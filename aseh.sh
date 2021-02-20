#!/bin/bash
##############################################################################
#
# aseh.sh - Azure Scheduled Events Handler
#
# COPYRIGHT (C) 2021 K.WATANABE
#
##############################################################################
POLL_INTERVAL=1
API_ENDPOINT='http://169.254.169.254/metadata/scheduledevents?api-version=2019-08-01'
LOG_FILE="/var/log/aseh.log"
KILL_PROCESS="FOO"

function Reboot () {
    date "+%c: Reboot." >> ${LOG_FILE}
    wall "This computer will be restarted!"
    pkill ${KILL_PROCESS}
}
function Redeploy () {
    date "+%c: Redeploy." >> ${LOG_FILE}
    wall "This computer will be redeployed!"
    pkill ${KILL_PROCESS}
}
function Freeze () {
    date "+%c: Freeze." >> ${LOG_FILE}
    wall "This computer will be freezed!"
    #pkill ${KILL_PROCESS}
}
function Preempt () {
    date "+%c: Preempt." >> ${LOG_FILE}
    wall "This computer will be preempted!"
    pkill ${KILL_PROCESS}
}
function Terminate () {
    date "+%c: Terminate." >> ${LOG_FILE}
    wall "This computer will be terminated!"
    pkill ${KILL_PROCESS}
}

while :;
do
    for EVENT in `curl -H "Metadata:true" "${API_ENDPOINT}" | jq -r ".Events[] | .EventType"`
    do
        case "${EVENT}" in
            "Reboot"|"Redeploy"|"Freeze"|"Preempt"|"Terminate")
                ${EVENT}
                ;;
            *)
                ;;
        esac
    done
    sleep ${POLL_INTERVAL}
done


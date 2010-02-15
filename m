Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab0BOQ56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 11:57:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653Ab0BOQ54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 11:57:56 -0500
Message-ID: <4B797CFB.9050906@redhat.com>
Date: Mon, 15 Feb 2010 11:57:31 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL] tracing fixes
References: <20100214090913.GA26388@elte.hu> <4B78A60B.3030807@redhat.com> <20100215045024.GC19287@elte.hu>
In-Reply-To: <20100215045024.GC19287@elte.hu>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/mixed;
 boundary="------------000309030904030208090900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000309030904030208090900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Ingo Molnar wrote:
> 
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Hi Ingo,
>>
>> Could you push this commit too?
>>
>> 5ecaafdbf44b1ba400b746c60c401d54c7ee0863
>> kprobes: Add mcount to the kprobes blacklist
>>
>> Since this bug can be easily reproduced with kprobe-tracer.
> 
> Ok, i've cherry-picked it into urgent.
> 
> I'm wondering, how complete is the kprobes blacklist? You can test it by 
> putting a probe on every single function in the system via something like:
> 
>   for N in $(cut -d' ' -f3 /proc/kallsyms  | cut -f1); do
>     perf probe $N
>     perf probe -d $N
>   done

Yeah, something like that, and I used kprobe stress test tool which
I attached for that :)

 From http://lkml.org/lkml/2009/8/13/497
---
Usage
-----
   kprobestest [-s SYMLIST] [-b BLACKLIST] [-w WHITELIST]
      Run stress test. If SYMLIST file is specified, use it as
      an initial symbol list (This is useful for verifying white list
      after diagnosing all symbols).
   kprobestest cleanup
      Cleanup all lists


How to Work
-----------
This tool list up all symbols in the kernel via /proc/kallsyms, and sorts
it into groups (each of them including 64 symbols in default). And then,
it tests each group by using kprobe-tracer. If a kernel crash occurred,
that group is moved into 'failed' dir. If the group passed the test, this
script moves it into 'passed' dir and saves kprobe_profile into
'passed/profiles/'.
After testing all groups, all 'failed' groups are merged and sorted into
smaller groups (divided by 4, in default). And those are tested again.
This loop will be repeated until all group has just 1 symbol.
Finally, the script sorts all 'passed' symbols into 'tested', 'untested',
and 'missed' based on profiles.


Note
----
  - This script just gives us some clues to the blacklisted functions.
    In some cases, a combination of probe points will cause a problem, but
    each of them doesn't cause the problem alone.
---

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


--------------000309030904030208090900
Content-Type: text/plain;
 name="kprobestest"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kprobestest"

#!/bin/bash
#
#  kprobestest: Kprobes stress test tool
#  Written by Masami Hiramatsu <mhiramat@redhat.com>
#
#  Usage:
#     $ kprobestest [-s SYMLIST] [-b BLACKLIST] [-w WHITELIST]
#        Run stress test. If SYMLIST file is specified, use it as 
#        an initial symbol list (This is useful for verifying white list
#        after diagnosing all symbols).
#
#     $ kprobestest cleanup
#        Cleanup all lists

DEBUGFS=/debug
INITNR=64
DIV=4
SYMFILE=syms.list
FAILFILE=black.list
FAILBKUP=1

function do_test () {
  # Do some benchmark
  for i in {1..4} ; do
  sleep 0.5
  echo -n "."
  done
}

function usage () {
  echo "Usage: kprobestest [cleanup] [-s SYMLIST] [-b BLACKLIST] [-w WHITELIST]"
  exit 0
}

function cleanup_test () {
  rm -rf $SYMFILE failed passed testing unset backup
  exit 0
}


# Parse arguments
WHITELIST=
BLACKLIST=
SYMLIST=

while [ "$1" ]; do
case $1 in
  cleanup)
    cleanup_test
    ;;
  run)
    # ignore
    ;;
  -s)
    SYMLIST=$2
    shift 1
    ;;
  -b)
    BLACKLIST=$2
    shift 1
    ;;
  -w)
    WHITELIST=$2
    shift 1
    ;;
  *)
    usage
    ;;
esac
shift 1
done

# Show configurations
echo "Kprobe stress test starting."
[ -f "$BLACKLIST" ] && echo "Blacklist: $BLACKLIST" || BLACKLIST=""
[ -f "$WHITELIST" ] && echo "Whitelist: $WHITELIST" || WHITELIST=""
[ -f "$SYMLIST" ] && echo "Symlist: $SYMLIST" || SYMLIST=""

function make_filter () {
local EXP=""
if [ -z "$WHITELIST" -a -z "$BLACKLIST" ]; then
  echo "s/^$//g"
else
  for i in `cat $WHITELIST $BLACKLIST` ;do
    [ -z "$EXP" ] && EXP="^$i\$" || EXP="$EXP\\|^$i\$"
  done ; EXP="s/$EXP//g"
  echo $EXP
fi
}

function list_allsyms () {
local sym
local out=0
for sym in `sort /proc/kallsyms | egrep '[0-9a-f]+ [Tt] [^[]*$' | cut -d\  -f 3`;do
  [ $sym  = "_stext" ] && out=1 && continue
  [ $sym  = "__kprobes_text_start" ] && out=0 && continue
  [ $sym  = "__kprobes_text_end" ] && out=1 && continue
  [ $sym  = "_etext" ] && break
  [ $out -eq 1 ] && echo $sym
done
}

function prep_testing () {
local i=0
local n=0
local NR=$1
local fname=

echo "Grouping symbols: $NR"

fname=`printf "list-%03d.%d" $i $NR`
cat $SYMFILE | while read ln; do
  [ -z "$ln" ] && continue
  echo "$ln" >> testing/$fname
  n=$((n+1))
  if [ $n -eq $NR ]; then
    n=0
    i=$((i+1))
    fname=`printf "list-%03d.%d" $i $NR`
  fi
done
sync
}

function init_first () {
local EXP
EXP=`make_filter`
if [ -f "$SYMLIST" ]; then
  cat $SYMLIST | sed $EXP > $SYMFILE
else
  echo -n "Generating symbol list from /proc/kallsyms..."
  list_allsyms | sed $EXP > $SYMFILE
  echo "done. " `wc -l $SYMFILE | cut -f1 -d\  ` "symbols listed."
fi
mkdir testing
mkdir failed
mkdir backup
mkdir unset
mkdir passed
mkdir passed/profiles
prep_testing $INITNR
}

function get_max_nr () {
wc -l failed/list-* unset/list-* 2>/dev/null |\
awk '/^ *[0-9]+ .*list.*$/{ if (nr < $1) nr=$1 } BEGIN { nr=0 } END { print nr}'
}

function init_next () {
local NR
NR=`get_max_nr`
[ $NR -eq 0 ] && return 1
[ $NR -eq 1 ] && return 2
[ $NR -le $DIV ] && NR=1 || NR=`expr $NR / $DIV`

cat failed/* unset/* > $SYMFILE
if [ $FAILBKUP ]; then
    cp failed/* unset/* backup/
fi
rm failed/* unset/*

prep_testing $NR
return 0
}


# Initialize symbols
if [ ! -d testing ]; then
  init_first
elif [ -z "`ls testing/`" ]; then
  init_next
fi

function set_probes () {
local s
for s in `cat $1`; do
  echo "p:$s" $s >> $DEBUGFS/tracing/kprobe_events
  [ $? -ne 0 ] && return 1
  echo 1 > $DEBUGFS/tracing/events/kprobes/$s/enable
done
return 0
}

function clear_probes () {
  echo > $DEBUGFS/tracing/kprobe_events
}

function save_profile () {
  cat $DEBUGFS/tracing/kprobe_profile > passed/profiles/$1.prof
}

clear_probes

echo "Starting tests.."

RET=0

while [ $RET -eq 0 ]; do

  for list in `cd testing/; ls`; do
  echo -n $list
  mv testing/$list failed/
  sync;sync
  echo -n "sync.."
  set_probes failed/$list
  if [ $? -ne 0 ]; then
    clear_probes
    sync;sync
    echo "can not set"
    mv failed/$list unset/
    sync;sync
  else
    do_test
    save_profile $list
    clear_probes
    sync;sync
    echo "done"
    mv failed/$list passed/
    sync;sync
  fi
  done

  init_next
  RET=$?
done

if [ $RET -eq 1 ];then
# No failed symbols
  echo "no failed symbols found."
else
  echo "found failed symbols:"
  cat failed/* | tee $FAILFILE
  rm failed/*
fi

cat unset/* > "unset.list"
rm unset/*

function profile_symbols () {
  local s h m
  rm -f tested.list missed.list untested.list
  cat passed/profiles/*.prof | while read s h m ;do
    if [ $h -ne 0 ]; then 
      echo $s >> tested.list
    elif [ $m -ne 0 ]; then
      echo $s >> missed.list
    else
      echo $s >> untested.list
    fi
  done
}

echo -n "Profiling symbols..."
profile_symbols
echo done
echo tested: `wc -l tested.list | cut -d\  -f1` symbols
echo missed: `wc -l missed.list | cut -d\  -f1` symbols
echo untested: `wc -l untested.list | cut -d\  -f1` symbols
echo unset: `wc -l unset.list | cut -d\  -f1` symbols


--------------000309030904030208090900--

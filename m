Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbZIJGIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbZIJGIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 02:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbZIJGIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 02:08:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34078 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049AbZIJGIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 02:08:30 -0400
Date: Thu, 10 Sep 2009 08:08:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nikos Chantziaras <realnc@arcor.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090910060824.GF1335@elte.hu>
References: <20090908091304.GQ18599@kernel.dk> <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk> <20090909061308.GA28109@elte.hu> <1252486344.28645.18.camel@marge.simson.net> <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk> <20090909122006.GA18599@kernel.dk> <20090909180404.GA11027@elte.hu> <4AA80C1E.2080901@arcor.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <4AA80C1E.2080901@arcor.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Nikos Chantziaras <realnc@arcor.de> wrote:

> On 09/09/2009 09:04 PM, Ingo Molnar wrote:
>> [...]
>> * Jens Axboe<jens.axboe@oracle.com>  wrote:
>>
>>> On Wed, Sep 09 2009, Jens Axboe wrote:
>>>  [...]
>>> BFS210 runs on the laptop (dual core intel core duo). With make -j4
>>> running, I clock the following latt -c8 'sleep 10' latencies:
>>>
>>> -rc9
>>>
>>>          Max                17895 usec
>>>          Avg                 8028 usec
>>>          Stdev               5948 usec
>>>          Stdev mean           405 usec
>>>
>>>          Max                17896 usec
>>>          Avg                 4951 usec
>>>          Stdev               6278 usec
>>>          Stdev mean           427 usec
>>>
>>>          Max                17885 usec
>>>          Avg                 5526 usec
>>>          Stdev               6819 usec
>>>          Stdev mean           464 usec
>>>
>>> -rc9 + mike
>>>
>>>          Max                 6061 usec
>>>          Avg                 3797 usec
>>>          Stdev               1726 usec
>>>          Stdev mean           117 usec
>>>
>>>          Max                 5122 usec
>>>          Avg                 3958 usec
>>>          Stdev               1697 usec
>>>          Stdev mean           115 usec
>>>
>>>          Max                 6691 usec
>>>          Avg                 2130 usec
>>>          Stdev               2165 usec
>>>          Stdev mean           147 usec
>>
>> At least in my tests these latencies were mainly due to a bug in
>> latt.c - i've attached the fixed version.
>>
>> The other reason was wakeup batching. If you do this:
>>
>>     echo 0>  /proc/sys/kernel/sched_wakeup_granularity_ns
>>
>> ... then you can switch on insta-wakeups on -tip too.
>>
>> With a dual-core box and a make -j4 background job running, on
>> latest -tip i get the following latencies:
>>
>>   $ ./latt -c8 sleep 30
>>   Entries: 656 (clients=8)
>>
>>   Averages:
>>   ------------------------------
>>   	Max	      158 usec
>> 	Avg	       12 usec
>> 	Stdev	       10 usec
>
> With your version of latt.c, I get these results with 2.6-tip vs  
> 2.6.31-rc9-bfs:
>
>
> (mainline)
> Averages:
> ------------------------------
>         Max            50 usec
>         Avg            12 usec
>         Stdev           3 usec
>
>
> (BFS)
> Averages:
> ------------------------------
>         Max           474 usec
>         Avg            11 usec
>         Stdev          16 usec
>
> However, the interactivity problems still remain.  Does that mean 
> it's not a latency issue?

It means that Jens's test-app, which demonstrated and helped us fix 
the issue for him does not help us fix it for you just yet.

The "fluidity problem" you described might not be a classic latency 
issue per se (which latt.c measures), but a timeslicing / CPU time 
distribution problem.

A slight shift in CPU time allocation can change the flow of tasks 
to result in a 'choppier' system.

Have you tried, in addition of the granularity tweaks you've done, 
to renice mplayer either up or down? (or compiz and Xorg for that 
matter)

I'm not necessarily suggesting this as a 'real' solution (we really 
prefer kernels that just get it right) - but it's an additional 
parameter dimension along which you can tweak CPU time distribution 
on your box.

Here's the general rule of thumb: mine one nice level gives plus 5% 
CPU time to a task and takes away 5% CPU time from another task - 
i.e. shifts the CPU allocation by 10%.
 
( this is modified by all sorts of dynamic conditions: by the number
  of tasks running and their wakeup patters so not a rule cast into 
  stone - but still a good ballpark figure for CPU intense tasks. )

Btw., i've read your descriptions about what you've tuned so far - 
have you seen/checked the wakeup_granularity tunable as well? 
Setting that to 0 will change the general balance of how CPU time is 
allocated between tasks too.

There's also a whole bunch of scheduler features you can turn on/off 
individually via /debug/sched_features. For example, to turn off 
NEW_FAIR_SLEEPERS, you can do:

  # cat /debug/sched_features 
  NEW_FAIR_SLEEPERS NO_NORMALIZED_SLEEPER ADAPTIVE_GRAN WAKEUP_PREEMPT 
  START_DEBIT AFFINE_WAKEUPS CACHE_HOT_BUDDY SYNC_WAKEUPS NO_HRTICK 
  NO_DOUBLE_TICK ASYM_GRAN LB_BIAS LB_WAKEUP_UPDATE ASYM_EFF_LOAD 
  NO_WAKEUP_OVERLAP LAST_BUDDY OWNER_SPIN 

  # echo NO_NEW_FAIR_SLEEPERS > /debug/sched_features

Btw., NO_NEW_FAIR_SLEEPERS is something that will turn the scheduler 
into a more classic fair scheduler (like BFS is too).

NO_START_DEBIT might be another thing that improves (or worsens :-/) 
make -j type of kernel build workloads.

Note, these flags are all runtime, the new settings take effect 
almost immediately (and at the latest it takes effect when a task 
has started up) and safe to do runtime.

It basically gives us 32768 pluggable schedulers each with a 
slightly separate algorithm - each setting in essence creates a new 
scheduler. (this mechanism is how we introduce new scheduler 
features and allow their debugging / regression-testing.)

(okay, almost, so beware: turning on HRTICK might lock up your 
system.)

Plus, yet another dimension of tuning on SMP systems (such as 
dual-core) are the sched-domains tunable. There's a whole world of 
tuning in that area and BFS essentially implements a very agressive 
'always balance to other CPUs' policy.

I've attached my sched-tune-domains script which helps tune these 
parameters.

For example on a testbox of mine it outputs:

usage: tune-sched-domains <val>
{cpu0/domain0:SIBLING} SD flag: 239
+   1: SD_LOAD_BALANCE:          Do load balancing on this domain
+   2: SD_BALANCE_NEWIDLE:       Balance when about to become idle
+   4: SD_BALANCE_EXEC:          Balance on exec
+   8: SD_BALANCE_FORK:          Balance on fork, clone
-  16: SD_WAKE_IDLE:             Wake to idle CPU on task wakeup
+  32: SD_WAKE_AFFINE:           Wake task to waking CPU
+  64: SD_WAKE_BALANCE:          Perform balancing at task wakeup
+ 128: SD_SHARE_CPUPOWER:        Domain members share cpu power
- 256: SD_POWERSAVINGS_BALANCE:  Balance for power savings
- 512: SD_SHARE_PKG_RESOURCES:   Domain members share cpu pkg resources
-1024: SD_SERIALIZE:             Only a single load balancing instance
-2048: SD_WAKE_IDLE_FAR:         Gain latency sacrificing cache hit
-4096: SD_PREFER_SIBLING:        Prefer to place tasks in a sibling domain
{cpu0/domain1:MC} SD flag: 4735
+   1: SD_LOAD_BALANCE:          Do load balancing on this domain
+   2: SD_BALANCE_NEWIDLE:       Balance when about to become idle
+   4: SD_BALANCE_EXEC:          Balance on exec
+   8: SD_BALANCE_FORK:          Balance on fork, clone
+  16: SD_WAKE_IDLE:             Wake to idle CPU on task wakeup
+  32: SD_WAKE_AFFINE:           Wake task to waking CPU
+  64: SD_WAKE_BALANCE:          Perform balancing at task wakeup
- 128: SD_SHARE_CPUPOWER:        Domain members share cpu power
- 256: SD_POWERSAVINGS_BALANCE:  Balance for power savings
+ 512: SD_SHARE_PKG_RESOURCES:   Domain members share cpu pkg resources
-1024: SD_SERIALIZE:             Only a single load balancing instance
-2048: SD_WAKE_IDLE_FAR:         Gain latency sacrificing cache hit
+4096: SD_PREFER_SIBLING:        Prefer to place tasks in a sibling domain
{cpu0/domain2:NODE} SD flag: 3183
+   1: SD_LOAD_BALANCE:          Do load balancing on this domain
+   2: SD_BALANCE_NEWIDLE:       Balance when about to become idle
+   4: SD_BALANCE_EXEC:          Balance on exec
+   8: SD_BALANCE_FORK:          Balance on fork, clone
-  16: SD_WAKE_IDLE:             Wake to idle CPU on task wakeup
+  32: SD_WAKE_AFFINE:           Wake task to waking CPU
+  64: SD_WAKE_BALANCE:          Perform balancing at task wakeup
- 128: SD_SHARE_CPUPOWER:        Domain members share cpu power
- 256: SD_POWERSAVINGS_BALANCE:  Balance for power savings
- 512: SD_SHARE_PKG_RESOURCES:   Domain members share cpu pkg resources
+1024: SD_SERIALIZE:             Only a single load balancing instance
+2048: SD_WAKE_IDLE_FAR:         Gain latency sacrificing cache hit
-4096: SD_PREFER_SIBLING:        Prefer to place tasks in a sibling domain

The way i can turn on say SD_WAKE_IDLE for the NODE domain is to:

   tune-sched-domains 239 4735 $((3183+16))

( This is a pretty stone-age script i admit ;-)

Thanks for all your testing so far,

	Ingo

--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=tune-sched-domains


DIR=/proc/sys/kernel/sched_domain/

print_flags()
{
  flags[1]="SD_LOAD_BALANCE:          Do load balancing on this domain"
  flags[2]="SD_BALANCE_NEWIDLE:       Balance when about to become idle"
  flags[4]="SD_BALANCE_EXEC:          Balance on exec"
  flags[8]="SD_BALANCE_FORK:          Balance on fork, clone"
  flags[16]="SD_WAKE_IDLE:             Wake to idle CPU on task wakeup"
  flags[32]="SD_WAKE_AFFINE:           Wake task to waking CPU"
  flags[64]="SD_WAKE_BALANCE:          Perform balancing at task wakeup"
  flags[128]="SD_SHARE_CPUPOWER:        Domain members share cpu power"
  flags[256]="SD_POWERSAVINGS_BALANCE:  Balance for power savings"
  flags[512]="SD_SHARE_PKG_RESOURCES:   Domain members share cpu pkg resources"
  flags[1024]="SD_SERIALIZE:             Only a single load balancing instance"
  flags[2048]="SD_WAKE_IDLE_FAR:         Gain latency sacrificing cache hit"
  flags[4096]="SD_PREFER_SIBLING:        Prefer to place tasks in a sibling domain"

  DEC=$1
  CPU=$2
  DOM=$3

  [ -d $DIR/$CPU/$DOM ] || { exit 0; }

  NAME=$(cat $DIR/$CPU/$DOM/name)

  [ $DEC = "-1" ] && DEC=$(cat $DIR/$CPU/$DOM/flags)

  echo "{$CPU/$DOM:$NAME} SD flag: $DEC"

  for ((mask=1;mask<=4096;mask*=2)); do
   if [ "$[$mask & $DEC]" != "0" ]; then
      printf "+%4d: %s\n" $mask "${flags[$mask]}"
   else
      if [ $mask -le 4096 ]; then
        printf "%c%4d: %s\n" "-" $mask "${flags[$mask]}"
      fi
   fi
  done
}


[ $# -lt "1" ] && {
  echo 'usage: tune-sched-domains <val>'

  print_flags -1 cpu0 domain0
  print_flags -1 cpu0 domain1
  print_flags -1 cpu0 domain2
  print_flags -1 cpu0 domain3

  exit -1;
}

DOM0=$1
DOM1=${2:-$DOM0}
DOM2=${3:-$DOM1}
DOM3=${4:-$DOM2}

cd $DIR

for CPU in *; do
 cd $CPU
 for DOM in *; do

  FLAGS=$DOM/flags

  VAL=`cat $FLAGS`
  case $FLAGS in
     "domain0/flags") NEW_VAL=$DOM0 ;;
     "domain1/flags") NEW_VAL=$DOM1 ;;
     "domain2/flags") NEW_VAL=$DOM2 ;;
     "domain3/flags") NEW_VAL=$DOM3 ;;
     *) echo "error!" ;;
  esac

  echo $NEW_VAL > $FLAGS

  [ "$CPU" = "cpu0" ] && {
    echo "changed $FLAGS: $VAL => $NEW_VAL"
    print_flags $NEW_VAL $CPU $DOM
  }
 done
 cd ..
done



--Dxnq1zWXvFF0Q93v--

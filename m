Return-Path: <linux-kernel-owner+w=401wt.eu-S1752102AbZIJQCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbZIJQCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 12:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbZIJQCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 12:02:23 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:14166 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbZIJQCW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 12:02:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I7S0Bw2UGCjFQQQwcoPk/ITvqLPX6TMCKvptc3+G8/VvUFf3SDfKPcJtA7lCGx3QDq
         0kkpxkcusdNJuy7ySAVRXa6WGnEAf42fmX+iLAFFUJY+Lpt1za2DIToogtKGXO1YSzXW
         IwP3cdAHjedepXlfb4RE+49uOCV4Bpf1DCFKg=
MIME-Version: 1.0
In-Reply-To: <20090910060824.GF1335@elte.hu>
References: <20090908091304.GQ18599@kernel.dk>
	 <20090908203409.GJ18599@kernel.dk> <20090909061308.GA28109@elte.hu>
	 <1252486344.28645.18.camel@marge.simson.net>
	 <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk>
	 <20090909122006.GA18599@kernel.dk> <20090909180404.GA11027@elte.hu>
	 <4AA80C1E.2080901@arcor.de> <20090910060824.GF1335@elte.hu>
Date: Thu, 10 Sep 2009 09:02:19 -0700
Message-ID: <dda83e780909100902s32f076e7o87cebbbfc40d6dea@mail.gmail.com>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Bret Towe <magnade@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nikos Chantziaras <realnc@arcor.de>, Jens Axboe <jens.axboe@oracle.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 9, 2009 at 11:08 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Nikos Chantziaras <realnc@arcor.de> wrote:
>
>> On 09/09/2009 09:04 PM, Ingo Molnar wrote:
>>> [...]
>>> * Jens Axboe<jens.axboe@oracle.com>  wrote:
>>>
>>>> On Wed, Sep 09 2009, Jens Axboe wrote:
>>>>  [...]
>>>> BFS210 runs on the laptop (dual core intel core duo). With make -j4
>>>> running, I clock the following latt -c8 'sleep 10' latencies:
>>>>
>>>> -rc9
>>>>
>>>>          Max                17895 usec
>>>>          Avg                 8028 usec
>>>>          Stdev               5948 usec
>>>>          Stdev mean           405 usec
>>>>
>>>>          Max                17896 usec
>>>>          Avg                 4951 usec
>>>>          Stdev               6278 usec
>>>>          Stdev mean           427 usec
>>>>
>>>>          Max                17885 usec
>>>>          Avg                 5526 usec
>>>>          Stdev               6819 usec
>>>>          Stdev mean           464 usec
>>>>
>>>> -rc9 + mike
>>>>
>>>>          Max                 6061 usec
>>>>          Avg                 3797 usec
>>>>          Stdev               1726 usec
>>>>          Stdev mean           117 usec
>>>>
>>>>          Max                 5122 usec
>>>>          Avg                 3958 usec
>>>>          Stdev               1697 usec
>>>>          Stdev mean           115 usec
>>>>
>>>>          Max                 6691 usec
>>>>          Avg                 2130 usec
>>>>          Stdev               2165 usec
>>>>          Stdev mean           147 usec
>>>
>>> At least in my tests these latencies were mainly due to a bug in
>>> latt.c - i've attached the fixed version.
>>>
>>> The other reason was wakeup batching. If you do this:
>>>
>>>     echo 0>  /proc/sys/kernel/sched_wakeup_granularity_ns
>>>
>>> ... then you can switch on insta-wakeups on -tip too.
>>>
>>> With a dual-core box and a make -j4 background job running, on
>>> latest -tip i get the following latencies:
>>>
>>>   $ ./latt -c8 sleep 30
>>>   Entries: 656 (clients=8)
>>>
>>>   Averages:
>>>   ------------------------------
>>>      Max           158 usec
>>>      Avg            12 usec
>>>      Stdev          10 usec
>>
>> With your version of latt.c, I get these results with 2.6-tip vs
>> 2.6.31-rc9-bfs:
>>
>>
>> (mainline)
>> Averages:
>> ------------------------------
>>         Max            50 usec
>>         Avg            12 usec
>>         Stdev           3 usec
>>
>>
>> (BFS)
>> Averages:
>> ------------------------------
>>         Max           474 usec
>>         Avg            11 usec
>>         Stdev          16 usec
>>
>> However, the interactivity problems still remain.  Does that mean
>> it's not a latency issue?
>
> It means that Jens's test-app, which demonstrated and helped us fix
> the issue for him does not help us fix it for you just yet.
>
> The "fluidity problem" you described might not be a classic latency
> issue per se (which latt.c measures), but a timeslicing / CPU time
> distribution problem.
>
> A slight shift in CPU time allocation can change the flow of tasks
> to result in a 'choppier' system.
>
> Have you tried, in addition of the granularity tweaks you've done,
> to renice mplayer either up or down? (or compiz and Xorg for that
> matter)
>
> I'm not necessarily suggesting this as a 'real' solution (we really
> prefer kernels that just get it right) - but it's an additional
> parameter dimension along which you can tweak CPU time distribution
> on your box.
>
> Here's the general rule of thumb: mine one nice level gives plus 5%
> CPU time to a task and takes away 5% CPU time from another task -
> i.e. shifts the CPU allocation by 10%.
>
> ( this is modified by all sorts of dynamic conditions: by the number
>  of tasks running and their wakeup patters so not a rule cast into
>  stone - but still a good ballpark figure for CPU intense tasks. )
>
> Btw., i've read your descriptions about what you've tuned so far -
> have you seen/checked the wakeup_granularity tunable as well?
> Setting that to 0 will change the general balance of how CPU time is
> allocated between tasks too.
>
> There's also a whole bunch of scheduler features you can turn on/off
> individually via /debug/sched_features. For example, to turn off
> NEW_FAIR_SLEEPERS, you can do:
>
>  # cat /debug/sched_features
>  NEW_FAIR_SLEEPERS NO_NORMALIZED_SLEEPER ADAPTIVE_GRAN WAKEUP_PREEMPT
>  START_DEBIT AFFINE_WAKEUPS CACHE_HOT_BUDDY SYNC_WAKEUPS NO_HRTICK
>  NO_DOUBLE_TICK ASYM_GRAN LB_BIAS LB_WAKEUP_UPDATE ASYM_EFF_LOAD
>  NO_WAKEUP_OVERLAP LAST_BUDDY OWNER_SPIN
>
>  # echo NO_NEW_FAIR_SLEEPERS > /debug/sched_features
>
> Btw., NO_NEW_FAIR_SLEEPERS is something that will turn the scheduler
> into a more classic fair scheduler (like BFS is too).
>
> NO_START_DEBIT might be another thing that improves (or worsens :-/)
> make -j type of kernel build workloads.

thanks to this thread and others I've seen several kernel tunables
that can effect how the scheduler performs/acts
but what I don't see after a bit of looking is where all these are documented
perhaps thats also part of the reason there are unhappy people with
the current code in the kernel just because they don't know how
to tune it for their workload

> Note, these flags are all runtime, the new settings take effect
> almost immediately (and at the latest it takes effect when a task
> has started up) and safe to do runtime.
>
> It basically gives us 32768 pluggable schedulers each with a
> slightly separate algorithm - each setting in essence creates a new
> scheduler. (this mechanism is how we introduce new scheduler
> features and allow their debugging / regression-testing.)
>
> (okay, almost, so beware: turning on HRTICK might lock up your
> system.)
>
> Plus, yet another dimension of tuning on SMP systems (such as
> dual-core) are the sched-domains tunable. There's a whole world of
> tuning in that area and BFS essentially implements a very agressive
> 'always balance to other CPUs' policy.
>
> I've attached my sched-tune-domains script which helps tune these
> parameters.
>
> For example on a testbox of mine it outputs:
>
> usage: tune-sched-domains <val>
> {cpu0/domain0:SIBLING} SD flag: 239
> +   1: SD_LOAD_BALANCE:          Do load balancing on this domain
> +   2: SD_BALANCE_NEWIDLE:       Balance when about to become idle
> +   4: SD_BALANCE_EXEC:          Balance on exec
> +   8: SD_BALANCE_FORK:          Balance on fork, clone
> -  16: SD_WAKE_IDLE:             Wake to idle CPU on task wakeup
> +  32: SD_WAKE_AFFINE:           Wake task to waking CPU
> +  64: SD_WAKE_BALANCE:          Perform balancing at task wakeup
> + 128: SD_SHARE_CPUPOWER:        Domain members share cpu power
> - 256: SD_POWERSAVINGS_BALANCE:  Balance for power savings
> - 512: SD_SHARE_PKG_RESOURCES:   Domain members share cpu pkg resources
> -1024: SD_SERIALIZE:             Only a single load balancing instance
> -2048: SD_WAKE_IDLE_FAR:         Gain latency sacrificing cache hit
> -4096: SD_PREFER_SIBLING:        Prefer to place tasks in a sibling domain
> {cpu0/domain1:MC} SD flag: 4735
> +   1: SD_LOAD_BALANCE:          Do load balancing on this domain
> +   2: SD_BALANCE_NEWIDLE:       Balance when about to become idle
> +   4: SD_BALANCE_EXEC:          Balance on exec
> +   8: SD_BALANCE_FORK:          Balance on fork, clone
> +  16: SD_WAKE_IDLE:             Wake to idle CPU on task wakeup
> +  32: SD_WAKE_AFFINE:           Wake task to waking CPU
> +  64: SD_WAKE_BALANCE:          Perform balancing at task wakeup
> - 128: SD_SHARE_CPUPOWER:        Domain members share cpu power
> - 256: SD_POWERSAVINGS_BALANCE:  Balance for power savings
> + 512: SD_SHARE_PKG_RESOURCES:   Domain members share cpu pkg resources
> -1024: SD_SERIALIZE:             Only a single load balancing instance
> -2048: SD_WAKE_IDLE_FAR:         Gain latency sacrificing cache hit
> +4096: SD_PREFER_SIBLING:        Prefer to place tasks in a sibling domain
> {cpu0/domain2:NODE} SD flag: 3183
> +   1: SD_LOAD_BALANCE:          Do load balancing on this domain
> +   2: SD_BALANCE_NEWIDLE:       Balance when about to become idle
> +   4: SD_BALANCE_EXEC:          Balance on exec
> +   8: SD_BALANCE_FORK:          Balance on fork, clone
> -  16: SD_WAKE_IDLE:             Wake to idle CPU on task wakeup
> +  32: SD_WAKE_AFFINE:           Wake task to waking CPU
> +  64: SD_WAKE_BALANCE:          Perform balancing at task wakeup
> - 128: SD_SHARE_CPUPOWER:        Domain members share cpu power
> - 256: SD_POWERSAVINGS_BALANCE:  Balance for power savings
> - 512: SD_SHARE_PKG_RESOURCES:   Domain members share cpu pkg resources
> +1024: SD_SERIALIZE:             Only a single load balancing instance
> +2048: SD_WAKE_IDLE_FAR:         Gain latency sacrificing cache hit
> -4096: SD_PREFER_SIBLING:        Prefer to place tasks in a sibling domain
>
> The way i can turn on say SD_WAKE_IDLE for the NODE domain is to:
>
>   tune-sched-domains 239 4735 $((3183+16))
>
> ( This is a pretty stone-age script i admit ;-)
>
> Thanks for all your testing so far,
>
>        Ingo
>

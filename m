Return-Path: <linux-kernel-owner+w=401wt.eu-S932597AbYFKTCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbYFKTCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 15:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759273AbYFKTCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 15:02:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55558 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710AbYFKTCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 15:02:05 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5315"; a="3851446"
Message-ID: <4850214A.8090100@qualcomm.com>
Date: Wed, 11 Jun 2008 12:02:34 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Oleg Nesterov <oleg@tv-sign.ru>, mingo@elte.hu,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Paul Jackson <pj@sgi.com>,
       menage@google.com, linux-kernel@vger.kernel.org,
       Mark Hounschell <dmarkh@cfl.rr.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: workqueue cpu affinity
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com>	 <20080605152953.dcfefa47.pj@sgi.com>	 <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com>	 <484D99AD.4000306@qualcomm.com> <1213080240.31518.5.camel@twins>	 <484E9FE8.9040504@qualcomm.com>  <20080610170005.GA6038@tv-sign.ru>	 <1213118386.19005.9.camel@lappy.programming.kicks-ass.net>	 <484EE303.9070007@qualcomm.com> <1213166964.31518.62.camel@twins>
In-Reply-To: <1213166964.31518.62.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2008-06-10 at 13:24 -0700, Max Krasnyansky wrote:
>> If at this point people still get this "Oh no, that's wrong" feeling, please
>> read this excellent statement by Paul J
>>
>> "A key reason that Linux has succeeded is that it actively seeks to work for a
>> variety of people, purposes and products. One operating system is now a strong
>> player in the embedded market, the real time market, and the High Performance
>> Computing market, as well as being an important player in a variety of other
>> markets. That's a rather stunning success."
>> — Paul Jackson, in a June 4th, 2008 message on the Linux Kernel mailing list.
> 
> While true, that doesn't mean we'll just merge anything :-)
No, of course not.

>>> Of course, things that use schedule_on_each_cpu() will still end up
>>> doing things on your isolated cpus, but getting around those would
>>> probably get you into some correctness trouble.
>> There is literally a _single_ user of that API.
> 
> There are quite a bit more on -rt, where a lot of on_each_cpu() callers,
> that now use IPIs and run in hardirq context are converted to schedule.
Yes I noticed that. I did not look deep enough though. I played with -rt
kernels but did not look over all the changes.

>>> drivers/oprofile/cpu_buffer.c:	schedule_delayed_work_on(i, &b->work, DEFAULT_TIMER_EXPIRE + i);
>>> drivers/oprofile/cpu_buffer.c: * By using schedule_delayed_work_on and then schedule_delayed_work
>> Yep I mentioned before that messing with the workqueues brakes oprofile. So
To sum up the discussion:
Overall conclusion regarding workqueues for the current mainline kernels is
that starting/moving workqueue threads is not a big deal. It's definitely not
encouraged but at the same time is not be prohibited (and it isn't at this
point I'm moving them from user-space).

Looks like the action items are:
- Optimize workqueue flush
- Timer or IPI based Oprofile (configurable)
- Optimize pagevec drain. I wonder if there is something on that front in the
Nick's latest patches.


Of course I may not be able to look at all those

Did I miss any other suggestion ?





Max
>> yes this one is an issue. However again it's not a catastrophic failure of the
>> system. Oprofile will not be able to collect samples from the CPU RT app is
>> running on and it actually warns the user about it (it prints and error that
>> the work is running on the wrong cpu). I'm working on a patch that collects
>> samples via IPI or per cpu timer. It will be configurable of course. So this
>> one is not a big deal either.
> 
> NMI/timers sound like a good way to run oprofile - I thought it could
> already use them.. ? Anyway, see below.. [2]
Yeah, I'm not sure why oprofile uses workqueues. Seems like a much heavier way
to collect samples than a lightweight per cpu timer.

>>> mm/slab.c:	schedule_delayed_work_on(cpu, reap_work,
>> Garbage collection. Again see scenarios I described above. If the kernel is
>> not being heavily used on the isolated cpu there is not a whole lot of SLAB
>> activity, not running the garbage collector is not a big deal.
>> Also SLUB does not have per cpu garbage collector, people running RT apps
>> should simply switch to the SLUB. So this one is non-issue.
> 
> Dude, SLUB uses on_each_cpu(), that's even worse for your #2 case. Hmm
> so does SLAB.. and a lot of other code.
Sure. I was talking about _workqueues_ specifically.
There is also add_timer_on().

Also on_each_cpu() is an IPI. It's not necessarily worse for the #2 case.
Depending what the IPI does of course. In the SLUB case it's essentially a
noop on the CPU that is no a heavy SLUB user. I've been meaning to profile
IPIs and timers but they have not generated enough noise.

btw Converting everything to threads like -rt does is not necessarily the best
solutions for all cases. Look at the "empty SLUB" case. IPI will get in and
out with minimal intrusion. The threaded approach will have to run the
scheduler and do a context switch. Granted in-kernel context switches are
super fast but still not as fast as the IPI. Just to clarify I'm not saying
-rt is doing the wrong thing, I'm just saying it's not black and white that
threads are better in _all_ cases.

>>> mm/swap.c:	return schedule_on_each_cpu(lru_add_drain_per_cpu);
>> This is one is swap LRU handling. This is the only user of
>> schedule_on_each_cpu() btw. This case is similar to the above cases. Most
>> people doing RT either have no swap at all, or avoid any kind of swapping
>> activity on the CPUs used for RT. If they aren't already they should :).
> 
> It isn't actually swap only - its all paging, including pagecache etc..
> Still, you're probably right in that the per cpu lrus are empty, 
Oh, I missed the pagecache part. btw It's also used only for the CONFIG_NUMA
case.

> but why not improve the current scheme by keeping a cpumask of cpus with
> non-emppty pagevecs, that way everybody wins.
I did not know enough about it to come with such an idea :). So yes now that
you mentioned it sounds like a good thing to do.

>>> mm/vmstat.c:	schedule_delayed_work_on(cpu, vmstat_work, HZ + cpu);
>> Not sure if it's an issue or not. It has not been for me.
>> And again if it is an issue it's not a catastrophic failure kind of thing.
>> There is not a whole lot of VM activity on the cpus running RT apps, otherwise
>> they won't run for very long ;-).
> 
> Looking at this code I'm not seeing the harm in letting it run - even
> for your #2 case, it certainly is not worse than some of the
> on_each_cpu() code, and starving it doesn't seem like a big issue.
Yes that's I meant. ie That nothing needs to be done here. We just let it run
and if it starves it starves, no big deal.

> ---
> I'm worried by your approach to RT - both your solutions [1,2] and
> oversight of the on_each_cpu() stuff seem to indicate you don't care
> about some jitter on your isolated cpu.
Hang on, why do say an oversight of on_each_cpu() ?
I started this discussion about workqueues specifically. on_each_cpu() is an
IPI. Actually awhile ago I looked at most uses of the xxx_on_cpu() api
including for_each_xxx_cpu(). Sure I may have missed something, but there is
no oversight in general. Which is why I've solicited feedback for awhile now.
As I mentioned awhile back the reason I'm doing this stuff is precisely
because I care about the jitter. And what I'm getting is 1-2usec on the
isolated CPUs when non-isolated one is loaded to the extreme. This is on the
NUMA dual Opteron box. None of the existing -rt solutions I tried (RTAI,
Xenomai and -rt) could do this.

btw I'm not sure what your concern is for the #1 use case (ie regular -rt
threads that block). It's not exactly my solution ;-). I just mentioned it as
a use case that benefits from CPU isolation. In that case again due to the
fact that heaviest latency sources have been moved to the other CPUs rt apps
To sum up the discussion:
Overall conclusion regarding workqueues for the current mainline kernels is
that starting/moving workqueue threads is not a big deal. It's definitely not
encouraged but at the same time is not be prohibited (and it isn't at this
point I'm moving them from user-space).

Looks like the action items are:
- Optimize workqueue flush
- Timer or IPI based Oprofile (configurable)
- Optimize pagevec drain. I wonder if there is something on that front in the
Nick's latest patches.


Of course I may not be able to look at all those

Did I miss any other suggestion ?





Maxenjoy fairly low latencies.

> Timers and on_each_cpu() code run with hardirqs disabled and can do all
> kinds of funny stuff like spin on shared locks. This will certainly
> affect your #2 case.
It does. See above. Once most things are moved overall impact of those IPIs is
 fairly small.

> Again, the problem with most of your ideas is that they are very narrow
> - they fail to consider the bigger picture/other use-cases.
Uh, that's a very broad statement ;-). I'm actually surprised that you draw
such a conclusion. I'm not even sure what ideas specifically you're talking
about. If you look at my latest cpuisol tree it contains exactly 4 patches.
Three that you've already ACKed and are either bug fixes or simple extensions.
So it's essentially a vanilla kernel running on the off-the-shelf hardware and
providing awesome latencies. I not sure how that is a bad thing or how it
fails to consider big picture.

> To quote Paul again:
>         "A key reason that Linux has succeeded is that it actively seeks
>         to work for a variety of people, purposes and products"
> 
> You often seem to forget 'variety' and target only your one use-case.
Please be more specific. Which part targets only my use case. I'm assuming
that by _my_ use case you mean #2 - "rt thread that never blocks", because the
other use case is totally generic.
I don't see how things that I'm doing address only my use case. There is
clearly some usage of the scheduler isolation capabilities already. Look for
example at this wiki page:
http://rt.wiki.kernel.org/index.php/CPU_shielding_using_/proc_and_/dev/cpuset
My changes clearly improve that use case.

> I'm not saying it doesn't work for you - I'm just saying that by putting
> in a little more effort (ok, -rt is a lot more effort) we can make it
> work for a lot more people by taking out a lot of the restrictions
> you've put upon yourself.
Actually it may seem like a lot of restrictions but in reality the only
restriction is on how RT threads are designed (and there will always be some).
Otherwise you get an off-the-shelf box with essentially vanilla kernel that
can be used in any way you like and can run very tight RT apps at the same time.

> Please don't take this too personal - I'm glad you're working on this.
> I'm just trying to see what we can generalize.
Oh, no worries, I'm not taking this personally, except maybe the "most your
ideas suck" part which got me a little bit ;-). I'm definitely all for making
it suitable for more general usage.
This is actually first constructive criticism (except for the "most of your
ideas suck" part :). Oleg had some specific suggestions about workqueues. But
otherwise it's been mostly "oh, it feels wrong" kind of thing with no specific
suggestions and/or pointers.

Thanks for your suggestions and pointers. I definitely appreciate them.
I'll send a separate email with the summary of the discussion. This one is too
long :).

Once again thanks a lot for the detailed reply
Max



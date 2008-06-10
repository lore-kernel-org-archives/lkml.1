Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbYFJUYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbYFJUYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbYFJUYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:24:07 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33703 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYFJUYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:24:05 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5314"; a="3821687"
Message-ID: <484EE303.9070007@qualcomm.com>
Date: Tue, 10 Jun 2008 13:24:35 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       mingo@elte.hu, Andrew Morton <akpm@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>, Paul Jackson <pj@sgi.com>,
       menage@google.com, linux-kernel@vger.kernel.org,
       Mark Hounschell <dmarkh@cfl.rr.com>
Subject: workqueue cpu affinity
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com>	 <20080605152953.dcfefa47.pj@sgi.com>	 <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com>	 <484D99AD.4000306@qualcomm.com> <1213080240.31518.5.camel@twins>	 <484E9FE8.9040504@qualcomm.com>  <20080610170005.GA6038@tv-sign.ru> <1213118386.19005.9.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1213118386.19005.9.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok looks like we got deeper into workqueue discussion in the wrong mail thread
:). So let me restart it.

Here is some backgound on this. Full cpu isolation requires some tweaks to the
workqueue handling. Either the workqueue threads need to be moved (which is my
current approach), or work needs to be redirected when it's submitted.
flush_*_work() needs to be improved too. See Peter's reply below.

First reaction that a lot of people get is "oh no no, this is bad, this will
not work". Which is understandable but _wrong_ ;-). See below for more details
and analysis.

One thing that helps in accepting this isolation idea is to think about the
use cases. There are two uses cases for it:
1. Normal threaded RT apps with threads that use system calls, block on
events, etc.
2. Specialized RT apps with thread(s) that require close to 100% of the CPU
resources. Their threads avoid using system calls and avoid blocking. This is
done to achieve very low latency and low overhead.

Scenario #1 is straightforward. You'd want to isolate the processor the RT app
is running on to avoid typical sources of latency. Workqueues running on the
same processor is not an issue (because RT threads block), but you do not get
the same latency guaranties.

Workqueues are an issue for the scenario #2. Workqueue kthreads do not get a
chance to run because user's RT threads are higher priority. However those RT
threads should not use regular kernel services because that by definition
means that they are not getting ~100% of the CPU they want. In other words
they cannot have it both ways :).

Therefore it's expected that the kernel won't be used heavily on those cpus,
and nothing really schedules workqueues and stuff. It's also expected that
certain kernel services may not be available on those CPUs. Again we cannot
have it both ways. ie Have all the kernel services and yet the kernel is not
supposed to use much CPU time :).

If at this point people still get this "Oh no, that's wrong" feeling, please
read this excellent statement by Paul J

"A key reason that Linux has succeeded is that it actively seeks to work for a
variety of people, purposes and products. One operating system is now a strong
player in the embedded market, the real time market, and the High Performance
Computing market, as well as being an important player in a variety of other
markets. That's a rather stunning success."
— Paul Jackson, in a June 4th, 2008 message on the Linux Kernel mailing list.

btw Paul, it got picked up by the kerneltrap.org
http://kerneltrap.org/Quote/A_Rather_Stunning_Success

Sorry for the lengthy into. Back to the technical discussions.

Peter Zijlstra wrote:
> The advantage of creating a more flexible or fine-grained flush is that
> large machine also profit from it.
I agree, our current workqueue flush scheme is expensive because it has to
schedule on each online cpu. So yes improving flush makes sense in general.

> A simple scheme would be creating a workqueue context that is passed
> along on enqueue, and then passed to flush.
> 
> This context could:
> 
>  - either track the individual worklets and employ a completion scheme
> to wait for them;
> 
>  - or track on which cpus the worklets are enqueued and flush only those
> few cpus.
> 
> Doing this would solve your case since nobody (except those having
> business) will enqueue something on the isolated cpus.
> 
> And it will improve the large machine case for the same reasons - it
> won't have to iterate all cpus.
This will require a bit of surgery across the entire tree. There is a lot of
code that calls flush_scheduled_work()P. All that would have to be changed,
which is ok, but I think as the first step we could simply allow moving
workqueue threads out of cpus where that load in undesirable and make people
aware of what happens in that case.
When I get a chance I'll look into the flush scheme you proposed above.

> Of course, things that use schedule_on_each_cpu() will still end up
> doing things on your isolated cpus, but getting around those would
> probably get you into some correctness trouble.
There is literally a _single_ user of that API.
Actually lets look at all the current users of the schedule_on(cpu) kind of API.

git grep
'queue_delayed_work_on\|schedPule_delayed_work_on\|schedule_on_each_cpu' |\
	grep -v 'workqueue\.[ch]\|\.txt'

> drivers/cpufreq/cpufreq_ondemand.c:	queue_delayed_work_on(cpu, kondemand_wq, &dbs_info->work, delay);
> drivers/cpufreq/cpufreq_ondemand.c:	queue_delayed_work_on(dbs_info->cpu, kondemand_wq, &dbs_info->work,
No big deal. Worst case cpufreq state or that cpu will be stale.
RT apps would not want cpufreq governor messing with the cpu frequencies
anyway. So if you look back at the scenarios #1 and #2 I described above this
is non-issue.

> drivers/macintosh/rack-meter.c:	schedule_delayed_work_on(cpu, &rcpu->sniffer,
> drivers/macintosh/rack-meter.c:	schedule_delayed_work_on(cpu, &rm->cpu[cpu].sniffer,
Not a big deal either. In the worst case stats for the isolated cpus will not
be updated. Can probably be converted to timers.

> drivers/oprofile/cpu_buffer.c:	schedule_delayed_work_on(i, &b->work, DEFAULT_TIMER_EXPIRE + i);
> drivers/oprofile/cpu_buffer.c: * By using schedule_delayed_work_on and then schedule_delayed_work
Yep I mentioned before that messing with the workqueues brakes oprofile. So
yes this one is an issue. However again it's not a catastrophic failure of the
system. Oprofile will not be able to collect samples from the CPU RT app is
running on and it actually warns the user about it (it prints and error that
the work is running on the wrong cpu). I'm working on a patch that collects
samples via IPI or per cpu timer. It will be configurable of course. So this
one is not a big deal either.

> mm/slab.c:	schedule_delayed_work_on(cpu, reap_work,
Garbage collection. Again see scenarios I described above. If the kernel is
not being heavily used on the isolated cpu there is not a whole lot of SLAB
activity, not running the garbage collector is not a big deal.
Also SLUB does not have per cpu garbage collector, people running RT apps
should simply switch to the SLUB. So this one is non-issue.

> mm/swap.c:	return schedule_on_each_cpu(lru_add_drain_per_cpu);
This is one is swap LRU handling. This is the only user of
schedule_on_each_cpu() btw. This case is similar to the above cases. Most
people doing RT either have no swap at all, or avoid any kind of swapping
activity on the CPUs used for RT. If they aren't already they should :).

> mm/vmstat.c:	schedule_delayed_work_on(cpu, vmstat_work, HZ + cpu);
Not sure if it's an issue or not. It has not been for me.
And again if it is an issue it's not a catastrophic failure kind of thing.
There is not a whole lot of VM activity on the cpus running RT apps, otherwise
they won't run for very long ;-).

So as you can see all the current users that require strict workqueue cpu
affinity is at most an inconvenience (like not being able to profile cpuX, or
stale stats). Nothing fundamental fails. We've been running all kinds of
machines with both scenarios #1 and #2 for weeks (rebooted for upgrades only).
They do not show any more problems than the machine with the regular setup.

There may be some other users that implicitly rely on the work queue affinity
but I could not easily find them by looking at the code, nor did they show up
during testing.
If you know of any please let me know, we should convert them from
	schedule_work()
to
	schedule_work_on(cpuX)
to make the requirements clear.

Thanks
Max

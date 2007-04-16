Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbXDPHFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbXDPHFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 03:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbXDPHFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 03:05:52 -0400
Received: from qsrv03sl.mx.bigpond.com ([144.140.92.183]:36841 "EHLO
	qsrv03sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbXDPHFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 03:05:51 -0400
Message-ID: <4623050B.8020602@bigpond.net.au>
Date: Mon, 16 Apr 2007 15:09:31 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Ingo Molnar <mingo@elte.hu>, Matt Mackall <mpm@selenic.com>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415150536.GA6623@elte.hu> <20070415200535.GC11166@waste.org> <20070415204824.GA25813@elte.hu> <20070415233909.GE2986@holomorphy.com> <4622CC30.6030707@bigpond.net.au> <20070416030405.GI8915@holomorphy.com>
In-Reply-To: <20070416030405.GI8915@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta07sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Mon, 16 Apr 2007 05:09:36 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> William Lee Irwin III wrote:
>>> One of the reasons I never posted my own code is that it never met its
>>> own design goals, which absolutely included switching on the fly. I
>>> think Peter Williams may have done something about that.
>>> It was my hope
>>> to be able to do insmod sched_foo.ko until it became clear that the
>>> effort it was intended to assist wasn't going to get even the limited
>>> hardware access required, at which point I largely stopped working on
>>> it.
> 
> On Mon, Apr 16, 2007 at 11:06:56AM +1000, Peter Williams wrote:
>> I didn't but some students did.
>> In a previous life, I did implement a runtime configurable CPU 
>> scheduling mechanism (implemented on True64, Solaris and Linux) that 
>> allowed schedulers to be loaded as modules at run time.  This was 
>> released commercially on True64 and Solaris.  So I know that it can be done.
>> I have thought about doing something similar for the SPA schedulers 
>> which differ in only small ways from each other but lack motivation.
> 
> Driver models for scheduling are not so far out. AFAICS it's largely a
> tug-of-war over design goals, e.g. maintaining per-cpu runqueues and
> switching out intra-queue policies vs. switching out whole-system
> policies, SMP handling and all. Whether this involves load balancing
> depends strongly on e.g. whether you have per-cpu runqueues. A 2.4.x
> scheduler module, for instance, would not have a load balancer at all,
> as it has only one global runqueue. There are other sorts of policies
> wanting significant changes to SMP handling vs. the stock load
> balancing.

Well a single run queue removes the need for load balancing but has 
scalability issues on large systems.  Personally, I think something in 
between would be the best solution i.e. multiple run queues but more 
than one CPU per run queue.  I think that this would be a particularly 
good solution to the problems introduced by hyper threading and multi 
core systems and also NUMA systems.  E.g. if all CPUs in a hyper thread 
package are using the one queue then the case where one CPU is trying to 
run a high priority task and the other a low priority task (i.e. the 
cases that the sleeping dependent mechanism tried to address) is less 
likely to occur.

By the way, I think that it's a very bad idea for the scheduling 
mechanism and the load balancing mechanism to be coupled.  The anomalies 
that will be experienced and the attempts to make ad hoc fixes for them 
will lead to complexity spiralling out of control.

> 
> 
> William Lee Irwin III wrote:
>>> I'm not sure what happened there. It wasn't a big enough patch to take
>>> hits in this area due to getting overwhelmed by the programming burden
>>> like some other efforts of mine. Maybe things started getting ugly once
>>> on-the-fly switching entered the picture. My guess is that Peter Williams
>>> will have to chime in here, since things have diverged enough from my
>>> one-time contribution 4 years ago.
> 
> On Mon, Apr 16, 2007 at 11:06:56AM +1000, Peter Williams wrote:
>> From my POV, the current version of plugsched is considerably simpler 
>> than it was when I took the code over from Con as I put considerable 
>> effort into minimizing code overlap in the various schedulers.
>> I also put considerable effort into minimizing any changes to the load 
>> balancing code (something Ingo seems to think is a deficiency) and the 
>> result is that plugsched allows "intra run queue" scheduling to be 
>> easily modified WITHOUT effecting load balancing.  To my mind scheduling 
>> and load balancing are orthogonal and keeping them that way simplifies 
>> things.
> 
> ISTR rearranging things for con in such a fashion that it no longer
> worked out of the box (though that wasn't the intention; restructuring it
> to be more suited to his purposes was) and that's what he worked off of
> afterward. I don't remember very well what changed there as I clearly
> invested less effort there than the prior versions. Now that I think of
> it, that may have been where the sample policy demonstrating scheduling
> classes was lost.

I can't comment here as (as far as I can recall) I never saw your code 
and only became involved when Con posted his version of cpusched.

> 
> 
> On Mon, Apr 16, 2007 at 11:06:56AM +1000, Peter Williams wrote:
>> As Ingo correctly points out, plugsched does not allow different 
>> schedulers to be used per CPU but it would not be difficult to modify it 
>> so that they could.  Although I've considered doing this over the years 
>> I decided not to as it would just increase the complexity and the amount 
>> of work required to keep the patch set going.  About six months ago I 
>> decided to reduce the amount of work I was doing on plugsched (as it was 
>> obviously never going to be accepted) and now only publish patches 
>> against the vanilla kernel's major releases (and the only reason that I 
>> kept doing that is that the download figures indicated that about 80 
>> users were interested in the experiment).
> 
> That's a rather different goal from what I was going on about with it,
> so it's all diverged quite a bit.

Yes, pragmatic considerations dictated a change of tack.

> Where I had a significant need for
> mucking with the entire concept of how SMP was handled, this is rather
> different.

Yes, I went with the idea of intra run queue scheduling being orthogonal 
to load balancing for two reasons:

1. I think that coupling them is a bad idea from the complexity POV, and
2. it's enough of a battle fighting for modifications to one bit of the 
code without trying to do it to two simultaneously.

> At this point I'm questioning the relevance of my own work,
> though it was already relatively marginal as it started life as an
> attempt at a sort of debug patch to help gang scheduling (which is in
> itself a rather marginally relevant feature to most users) code along.

The main commercial plug in scheduler used with the run time loadable 
module scheduler that I mentioned earlier did gang scheduling (at the 
insistence of the Tru64 kernel folks).  As this scheduler was a 
hierarchical "fair share" scheduler: i.e. allocating CPU "fairly" 
("unfairly" really in according to an allocation policy) among higher 
level entities such as users, groups and applications as well as 
processes; it was fairly easy to make it a gang scheduler by modifying 
it to give all of a process's threads the same priority based on the 
process's CPU usage rather than different priorities based on the 
threads' usage rates.  In fact, it would have been possible to select 
between gang and non gang on a per process basis if that was considered 
desirable.

The fact that threads and processes are distinct entities on Tru64 and 
Solaris made this easier to do on them than on Linux.

My experience with this scheduler leads me to believe that to achieve 
gang scheduling and fairness, etc. you need (usage) statistics based 
schedulers.

> 
> 
> On Mon, Apr 16, 2007 at 11:06:56AM +1000, Peter Williams wrote:
>> PS I no longer read LKML (due to time constraints) and would appreciate 
>> it if I could be CC'd on any e-mails suggesting scheduler changes.
>> PPS I'm just happy to see that Ingo has finally accepted that the 
>> vanilla scheduler was badly in need of fixing and don't really care who 
>> fixes it.
>> PPS Different schedulers for different aims (i.e. server or work 
>> station) do make a difference.  E.g. the spa_svr scheduler in plugsched 
>> does about 1% better on kernbench than the next best scheduler in the bunch.
>> PPPS Con, fairness isn't always best as humans aren't very altruistic 
>> and we need to give unfair preference to interactive tasks in order to 
>> stop the users flinging their PCs out the window.  But the current 
>> scheduler doesn't do this very well and is also not very good at 
>> fairness so needs to change.  But the changes need to address 
>> interactive response and fairness not just fairness.
> 
> Kernel compiles not so useful a benchmark. SDET, OAST, AIM7, etc. are
> better ones. I'd not bother citing kernel compile results.

spa_svr actually does its best work when the system isn't fully loaded 
as the type of improvement it strives to achieve (minimizing on queue 
wait time) hasn't got much room to manoeuvre when the system is fully 
loaded.  Therefore, the fact that it's 1% better even in these 
circumstances is a good result and also indicates that the overhead for 
keeping the scheduling statistics it uses for its decision making is 
well spent.  Especially, when you consider that the total available room 
for improvement on this benchmark is less than 3%.

To elaborate, the motivation for this scheduler was acquired from the 
observation of scheduling statistics (in particular, on queue wait time) 
on systems running at about 30% to 50% load.  Theoretically, at these 
load levels there should be no such waiting but the statistics show that 
there is considerable waiting (sometimes as high as 30% to 50%).  I put 
this down to "lack of serendipity" e.g.  everyone sleeping at the same 
time and then trying to run at the same time would be complete lack of 
serendipity.  On the other hand, if everyone is synced then there would 
be total serendipity.

Obviously, from the POV of a client, time the server task spends waiting 
on the queue adds to the response time for any request that has been 
made so reduction of this time on a server is a good thing(tm).  Equally 
obviously, trying to achieve this synchronization by asking the tasks to 
cooperate with each other is not a feasible solution and some external 
influence needs to be exerted and this is what spa_svr does -- it nudges 
the scheduling order of the tasks in a way that makes them become well 
synced.

Unfortunately, this is not a good scheduler for an interactive system as 
it minimizes the response times for ALL tasks (and the system as a 
whole) and this can result in increased response time for some 
interactive tasks (clunkiness) which annoys interactive users.  When you 
start fiddling with this scheduler to bring back "interactive 
unfairness" you kill a lot of its superior low overall wait time 
performance.

So this is why I think "horses for courses" schedulers are worth while.


> 
> In any event, I'm not sure what to say about different schedulers for
> different aims. My intentions with plugsched were not centered around
> production usage or intra-queue policy. I'm relatively indifferent to
> the notion of having pluggable CPU schedulers, intra-queue or otherwise,
> in mainline. I don't see any particular harm in it, but neither am I
> particularly motivated to have it in.

If you look at the struct sched_spa_child in the file 
include/linux/sched_spa.h you'll see that the interface for switching 
between the various SPA schedulers is quite small and making them 
runtime switchable would be easy (I haven't done this in cpusched as I 
wanted to keep the same interface for switching schedulers for all 
schedulers: i.e. all run time switchable or none run time switchable; as 
the main aim of plugsched had become a mechanism for evaluating 
different intra queue scheduling designs.)

> I had a rather strong sense of
> instrumentality about it, and since it became useless to me (at a
> conceptual level; the implementation was never finished ot the point of
> dynamic loading of scheduler modules) for assisting development on
> large systems via reboot avoidance by dint of it becoming clear that
> access to such was never going to happen, I've stopped looking at it.

I'll probably stop looking at this problem as well at least for the time 
being until all this new code has settled.

Peter
PS As I no longer read LKML, I haven't yet seen Ingo's or Con's or 
Nick's new schedulers yet so am unable to comment on their technical 
merits with respect to my comments above.
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce

Return-Path: <linux-kernel-owner+w=401wt.eu-S1030565AbXDPMzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030565AbXDPMzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 08:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030581AbXDPMzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 08:55:33 -0400
Received: from omta02sl.mx.bigpond.com ([144.140.93.154]:23850 "EHLO
	omta02sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030565AbXDPMza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 08:55:30 -0400
Message-ID: <46237239.1070903@bigpond.net.au>
Date: Mon, 16 Apr 2007 22:55:21 +1000
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
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415150536.GA6623@elte.hu> <20070415200535.GC11166@waste.org> <20070415204824.GA25813@elte.hu> <20070415233909.GE2986@holomorphy.com> <4622CC30.6030707@bigpond.net.au> <20070416030405.GI8915@holomorphy.com> <4623050B.8020602@bigpond.net.au> <20070416110439.GH2986@holomorphy.com>
In-Reply-To: <20070416110439.GH2986@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta02sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Mon, 16 Apr 2007 12:55:26 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> William Lee Irwin III wrote:
>>> Driver models for scheduling are not so far out. AFAICS it's largely a
>>> tug-of-war over design goals, e.g. maintaining per-cpu runqueues and
>>> switching out intra-queue policies vs. switching out whole-system
>>> policies, SMP handling and all. Whether this involves load balancing
>>> depends strongly on e.g. whether you have per-cpu runqueues. A 2.4.x
>>> scheduler module, for instance, would not have a load balancer at all,
>>> as it has only one global runqueue. There are other sorts of policies
>>> wanting significant changes to SMP handling vs. the stock load
>>> balancing.
> 
> On Mon, Apr 16, 2007 at 03:09:31PM +1000, Peter Williams wrote:
>> Well a single run queue removes the need for load balancing but has 
>> scalability issues on large systems.  Personally, I think something in 
>> between would be the best solution i.e. multiple run queues but more 
>> than one CPU per run queue.  I think that this would be a particularly 
>> good solution to the problems introduced by hyper threading and multi 
>> core systems and also NUMA systems.  E.g. if all CPUs in a hyper thread 
>> package are using the one queue then the case where one CPU is trying to 
>> run a high priority task and the other a low priority task (i.e. the 
>> cases that the sleeping dependent mechanism tried to address) is less 
>> likely to occur.
> 
> This wasn't meant to sing the praises of the 2.4.x scheduler; it was
> rather meant to point out that the 2.4.x scheduler, among others, is
> unimplementable within the framework if it assumes per-cpu runqueues.
> More plausibly useful single-queue schedulers would likely use a vastly
> different policy and attempt to carry out all queue manipulations via
> lockless operations.
> 
> 
> On Mon, Apr 16, 2007 at 03:09:31PM +1000, Peter Williams wrote:
>> By the way, I think that it's a very bad idea for the scheduling 
>> mechanism and the load balancing mechanism to be coupled.  The anomalies 
>> that will be experienced and the attempts to make ad hoc fixes for them 
>> will lead to complexity spiralling out of control.
> 
> This is clearly unavoidable in the case of gang scheduling. There is
> simply no other way to schedule N tasks which must all be run
> simultaneously when they run at all on N cpus of the system without
> such coupling and furthermore at an extremely intimate level,
> particularly when multiple competing gangs must be scheduled in such
> a fashion.

I can't see the logic here or why you would want to do such a thing.  It 
certainly doesn't coincide with what I interpret "gang scheduling" to mean.

> 
> 
> William Lee Irwin III wrote:
>>> Where I had a significant need for
>>> mucking with the entire concept of how SMP was handled, this is rather
>>> different.
> 
> On Mon, Apr 16, 2007 at 03:09:31PM +1000, Peter Williams wrote:
>> Yes, I went with the idea of intra run queue scheduling being orthogonal 
>> to load balancing for two reasons:
>> 1. I think that coupling them is a bad idea from the complexity POV, and
>> 2. it's enough of a battle fighting for modifications to one bit of the 
>> code without trying to do it to two simultaneously.
> 
> As nice as that sounds, such a code structure would've precluded the
> entire raison d'etre of the patch, i.e. gang scheduling.

Not for what I understand "gang scheduling" to mean.  As I understand it 
the constraints of gang scheduling are no where near as strict as you 
seem to think they are.  And for what it's worth I don't think that what 
you think it means is in any sense a reasonable target.

> 
> 
> William Lee Irwin III wrote:
>>> At this point I'm questioning the relevance of my own work,
>>> though it was already relatively marginal as it started life as an
>>> attempt at a sort of debug patch to help gang scheduling (which is in
>>> itself a rather marginally relevant feature to most users) code along.
> 
> On Mon, Apr 16, 2007 at 03:09:31PM +1000, Peter Williams wrote:
>> The main commercial plug in scheduler used with the run time loadable 
>> module scheduler that I mentioned earlier did gang scheduling (at the 
>> insistence of the Tru64 kernel folks).  As this scheduler was a 
>> hierarchical "fair share" scheduler: i.e. allocating CPU "fairly" 
>> ("unfairly" really in according to an allocation policy) among higher 
>> level entities such as users, groups and applications as well as 
>> processes; it was fairly easy to make it a gang scheduler by modifying 
>> it to give all of a process's threads the same priority based on the 
>> process's CPU usage rather than different priorities based on the 
>> threads' usage rates.  In fact, it would have been possible to select 
>> between gang and non gang on a per process basis if that was considered 
>> desirable.
>> The fact that threads and processes are distinct entities on Tru64 and 
>> Solaris made this easier to do on them than on Linux.
>> My experience with this scheduler leads me to believe that to achieve 
>> gang scheduling and fairness, etc. you need (usage) statistics based 
>> schedulers.
> 
> This does not appear to make sense unless it's based on an incorrect
> use of the term "gang scheduling."

It's become obvious that we mean different things.

> I'm referring to a gang as a set of
> tasks (typically restricted to threads of the same process) which must
> all be considered runnable or unrunnable simultaneously, and are for
> the sake of performance required to all actually be run simultaneously.
> This means a gang of N threads, when run, must run on N processors at
> once. A time and a set of processors must be chosen for any time
> interval where the gang is running. This interacts with load balancing
> by needing to choose the cpus to run the gang on, and also arranging
> for a set of cpus available for the gang to use to exist by means of
> migrating tasks off the chosen cpus.

Sounds like a job for the load balancer NOT the scheduler.

Also I can't see you meeting such strict constraints without making the 
tasks all SCHED_FIFO.

> 
> 
> William Lee Irwin III wrote:
>>> Kernel compiles not so useful a benchmark. SDET, OAST, AIM7, etc. are
>>> better ones. I'd not bother citing kernel compile results.
> 
> On Mon, Apr 16, 2007 at 03:09:31PM +1000, Peter Williams wrote:
>> spa_svr actually does its best work when the system isn't fully loaded 
>> as the type of improvement it strives to achieve (minimizing on queue 
>> wait time) hasn't got much room to manoeuvre when the system is fully 
>> loaded.  Therefore, the fact that it's 1% better even in these 
>> circumstances is a good result and also indicates that the overhead for 
>> keeping the scheduling statistics it uses for its decision making is 
>> well spent.  Especially, when you consider that the total available room 
>> for improvement on this benchmark is less than 3%.
> 
> None of these benchmarks require the system to be fully loaded. They
> are, on the other hand, vastly more realistic simulated workloads than
> kernel compiles, and furthermore are actually developed as benchmarks,
> with in some cases even measurements of variance, iteration to
> convergence, and similar such things that make them actually scientific.
> 
> 
> On Mon, Apr 16, 2007 at 03:09:31PM +1000, Peter Williams wrote:
>> To elaborate, the motivation for this scheduler was acquired from the 
>> observation of scheduling statistics (in particular, on queue wait time) 
>> on systems running at about 30% to 50% load.  Theoretically, at these 
>> load levels there should be no such waiting but the statistics show that 
>> there is considerable waiting (sometimes as high as 30% to 50%).  I put 
>> this down to "lack of serendipity" e.g.  everyone sleeping at the same 
>> time and then trying to run at the same time would be complete lack of 
>> serendipity.  On the other hand, if everyone is synced then there would 
>> be total serendipity.
>> Obviously, from the POV of a client, time the server task spends waiting 
>> on the queue adds to the response time for any request that has been 
>> made so reduction of this time on a server is a good thing(tm).  Equally 
>> obviously, trying to achieve this synchronization by asking the tasks to 
>> cooperate with each other is not a feasible solution and some external 
>> influence needs to be exerted and this is what spa_svr does -- it nudges 
>> the scheduling order of the tasks in a way that makes them become well 
>> synced.
> 
> This all sounds like a relatively good idea. So it's good for throughput
> vs. latency or otherwise not particularly interactive. No big deal, just
> use it where it makes sense.
> 
> 
> On Mon, Apr 16, 2007 at 03:09:31PM +1000, Peter Williams wrote:
>> Unfortunately, this is not a good scheduler for an interactive system as 
>> it minimizes the response times for ALL tasks (and the system as a 
>> whole) and this can result in increased response time for some 
>> interactive tasks (clunkiness) which annoys interactive users.  When you 
>> start fiddling with this scheduler to bring back "interactive 
>> unfairness" you kill a lot of its superior low overall wait time 
>> performance.
>> So this is why I think "horses for courses" schedulers are worth while.
> 
> I have no particular objection to using an appropriate scheduler for the
> system's workload. I also have little or no preference as to how that's
> accomplished overall. But I really think that if we want to push
> pluggable scheduling it should load schedulers as kernel modules on the
> fly and so on versus pure /proc/ tunables and a compiled-in set of
> alternatives.
> 
> 
> William Lee Irwin III wrote:
>>> In any event, I'm not sure what to say about different schedulers for
>>> different aims. My intentions with plugsched were not centered around
>>> production usage or intra-queue policy. I'm relatively indifferent to
>>> the notion of having pluggable CPU schedulers, intra-queue or otherwise,
>>> in mainline. I don't see any particular harm in it, but neither am I
>>> particularly motivated to have it in.
> 
> On Mon, Apr 16, 2007 at 03:09:31PM +1000, Peter Williams wrote:
>> If you look at the struct sched_spa_child in the file 
>> include/linux/sched_spa.h you'll see that the interface for switching 
>> between the various SPA schedulers is quite small and making them 
>> runtime switchable would be easy (I haven't done this in cpusched as I 
>> wanted to keep the same interface for switching schedulers for all 
>> schedulers: i.e. all run time switchable or none run time switchable; as 
>> the main aim of plugsched had become a mechanism for evaluating 
>> different intra queue scheduling designs.)
> 
> I remember actually looking at this, and I would almost characterize
> the differences between the SPA schedulers as a tunable parameter. I
> have a different concept of what pluggability means from how the SPA
> schedulers were switched, but no particular objection to the method
> given the commonalities between them.

Yes, that's the way I look at them (in fact, in Zaphod that's exactly 
what they were -- i.e. Zaphod could be made to behave like various SPA 
schedulers by fiddling its run time parameters).  They illustrate (to my 
mind) that once you get rid of the O(1) scheduler and replace it with a 
simple mechanism such as SPA (where there's a small number of points 
where the scheduling discipline gets to do its thing rather than being 
interspersed willy nilly throughout the rest of the code) adding run 
time switchable "horses for courses" scheduler disciplines becomes 
simple.  I think that the simplifications in Ingo's new scheduler (whose 
scheduling classes now look a lot like Solaris's and its predecessor 
OSes' scheduler classes) may make it possible to have switchable 
scheduling disciplines within a scheduling class.

I think that something similar (i.e. switchability) could be done for 
load balancing so that different load balancers could be used when 
required.  By keeping this load balancing functionality orthogonal to 
the intra run queue scheduling disciplines you increase the number of 
options available.

As I see it, if the scheduling discipline in use does its job properly 
within a run queue and the load balancer does its job of keeping the 
weighted load/demand on each run queue roughly equal (except where it 
has to do otherwise for your version of "gang scheduling") then the 
overall outcome will meet expectations.  Note that I talk of run queues 
not CPUs as I think a shift to multiple CPUs per run queue may be a good 
idea.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce

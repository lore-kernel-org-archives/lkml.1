Return-Path: <linux-kernel-owner+w=401wt.eu-S933127AbXEVKop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbXEVKop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 06:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756378AbXEVKoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 06:44:38 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:43102 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbXEVKoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 06:44:37 -0400
Message-ID: <4652C98F.7040609@mentorg.com>
Date: Tue, 22 May 2007 16:14:31 +0530
From: Pranith Kumar D <pranith-kumar_d@mentor.com>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CFS: sched-design-CFS.txt - ambiguity about leftmost
 and some formatting
References: <465292B0.8040604@mentorg.com> <20070522083051.GA9699@elte.hu> <4652B7B6.4080002@mentorg.com> <20070522101437.GA32528@elte.hu> <4652C379.3050801@mentorg.com> <20070522102430.GA2344@elte.hu>
In-Reply-To: <20070522102430.GA2344@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 May 2007 10:44:32.0217 (UTC) FILETIME=[2E5EC490:01C79C5E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> one chunk still fails:
>
>  patching file Documentation/sched-design-CFS.txt
>  Hunk #1 FAILED at 1.
>  1 out of 4 hunks FAILED -- saving rejects to file 
>  Documentation/sched-design-CFS.txt.rej
>
> i've attached my current version of sched-design-CFS.txt.
>
> 	Ingo
>   
> ------------------------------------------------------------------------
>
>
> this is the CFS scheduler.
>
> 80% of CFS's design can be summed up in a single sentence: CFS basically
> models an "ideal, precise multi-tasking CPU" on real hardware.
>
> "Ideal multi-tasking CPU" is a (non-existent :-) CPU that has 100%
> physical power and which can run each task at precise equal speed, in
> parallel, each at 1/nr_running speed. For example: if there are 2 tasks
> running then it runs each at 50% physical power - totally in parallel.
>
> On real hardware, we can run only a single task at once, so while that
> one task runs the other tasks that are waiting for the CPU are at a
> disadvantage - the current task gets an unfair amount of CPU time. In
> CFS this fairness imbalance is expressed and tracked via the per-task
> p->wait_runtime (nanosec-unit) value. "wait_runtime" is the amount of
> time the task should now run on the CPU for it become completely fair
> and balanced.
>
> ( small detail: on 'ideal' hardware, the p->wait_runtime value would
>   always be zero - no task would ever get 'out of balance' from the
>   'ideal' share of CPU time. )
>
> CFS's task picking logic is based on this p->wait_runtime value and it
> is thus very simple: it always tries to run the task with the largest
> p->wait_runtime value. In other words, CFS tries to run the task with
> the 'gravest need' for more CPU time. So CFS always tries to split up
> CPU time between runnable tasks as close to 'ideal multitasking
> hardware' as possible.
>
> Most of the rest of CFS's design just falls out of this really simple
> concept, with a few add-on embellishments like nice levels,
> multiprocessing and various algorithm variants to recognize sleepers.
>
> In practice it works like this: the system runs a task a bit, and when
> the task schedules (or a scheduler tick happens) the task's CPU usage is
> 'accounted for': the (small) time it just spent using the physical CPU
> is deducted from p->wait_runtime. [minus the 'fair share' it would have
> gotten anyway]. Once p->wait_runtime gets low enough so that another
> task becomes the 'leftmost task' (plus a small amount of 'granularity'
> distance relative to the leftmost task so that we do not over-schedule
> tasks and trash the cache) then the new leftmost task is picked and the
> current task is preempted.
>
> The rq->fair_clock value tracks the 'CPU time a runnable task would have
> fairly gotten, had it been runnable during that time'. So by using
> rq->fair_clock values we can accurately timestamp and measure the
> 'expected CPU time' a task should have gotten. All runnable tasks are
> sorted in the rbtree by the "rq->fair_clock - p->wait_runtime" key, and
> CFS picks the 'leftmost' task and sticks to it. As the system progresses
> forwards, newly woken tasks are put into the tree more and more to the
> right - slowly but surely giving a chance for every task to become the
> 'leftmost task' and thus get on the CPU within a deterministic amount of
> time.
>
> Some implementation details:
>
>  - the introduction of Scheduling Classes: an extensible hierarchy of
>    scheduler modules. These modules encapsulate scheduling policy
>    details and are handled by the scheduler core without the core
>    code assuming about them too much.
>
>  - sched_fair.c implements the 'CFS desktop scheduler': it is a
>    replacement for the vanilla scheduler's SCHED_OTHER interactivity
>    code.
>
>    i'd like to give credit to Con Kolivas for the general approach here:
>    he has proven via RSDL/SD that 'fair scheduling' is possible and that
>    it results in better desktop scheduling. Kudos Con!
>
>    The CFS patch uses a completely different approach and implementation
>    from RSDL/SD. My goal was to make CFS's interactivity quality exceed
>    that of RSDL/SD, which is a high standard to meet :-) Testing
>    feedback is welcome to decide this one way or another. [ and, in any
>    case, all of SD's logic could be added via a kernel/sched_sd.c module
>    as well, if Con is interested in such an approach. ]
>
>    CFS's design is quite radical: it does not use runqueues, it uses a
>    time-ordered rbtree to build a 'timeline' of future task execution,
>    and thus has no 'array switch' artifacts (by which both the vanilla
>    scheduler and RSDL/SD are affected).
>
>    CFS uses nanosecond granularity accounting and does not rely on any
>    jiffies or other HZ detail. Thus the CFS scheduler has no notion of
>    'timeslices' and has no heuristics whatsoever. There is only one
>    central tunable:
>
>          /proc/sys/kernel/sched_granularity_ns
>
>    which can be used to tune the scheduler from 'desktop' (low
>    latencies) to 'server' (good batching) workloads. It defaults to a
>    setting suitable for desktop workloads. SCHED_BATCH is handled by the
>    CFS scheduler module too.
>
>    due to its design, the CFS scheduler is not prone to any of the
>    'attacks' that exist today against the heuristics of the stock
>    scheduler: fiftyp.c, thud.c, chew.c, ring-test.c, massive_intr.c all
>    work fine and do not impact interactivity and produce the expected
>    behavior.
>
>    the CFS scheduler has a much stronger handling of nice levels and
>    SCHED_BATCH: both types of workloads should be isolated much more
>    agressively than under the vanilla scheduler.
>
>    ( another rdetail: due to nanosec accounting and timeline sorting,
>      sched_yield() support is very simple under CFS, and in fact under
>      CFS sched_yield() behaves much better than under any other
>      scheduler i have tested so far. )
>
>  - sched_rt.c implements SCHED_FIFO and SCHED_RR semantics, in a simpler
>    way than the vanilla scheduler does. It uses 100 runqueues (for all
>    100 RT priority levels, instead of 140 in the vanilla scheduler)
>    and it needs no expired array.
>
>  - reworked/sanitized SMP load-balancing: the runqueue-walking
>    assumptions are gone from the load-balancing code now, and
>    iterators of the scheduling modules are used. The balancing code got
>    quite a bit simpler as a result.
>
>   
This should work. ( praying...)

Signed-off by: Pranith Kumar D <pranith-kumar_d@mentor.com>

--- linux-2.6.21.1//Documentation/sched-design-CFS.txt.orig    
2007-05-22 16:06:58.000000000 +0530
+++ linux-2.6.21.1//Documentation/sched-design-CFS.txt    2007-05-22 
16:06:38.000000000 +0530
@@ -1,20 +1,20 @@
 
-this is the CFS scheduler.
+This is the CFS scheduler.
 
 80% of CFS's design can be summed up in a single sentence: CFS basically
 models an "ideal, precise multi-tasking CPU" on real hardware.
 
-"Ideal multi-tasking CPU" is a (non-existent :-) CPU that has 100%
+"Ideal multi-tasking CPU" is a (non-existent  :-))  CPU that has 100%
 physical power and which can run each task at precise equal speed, in
 parallel, each at 1/nr_running speed. For example: if there are 2 tasks
 running then it runs each at 50% physical power - totally in parallel.
 
 On real hardware, we can run only a single task at once, so while that
-one task runs the other tasks that are waiting for the CPU are at a
+one task runs, the other tasks that are waiting for the CPU are at a
 disadvantage - the current task gets an unfair amount of CPU time. In
 CFS this fairness imbalance is expressed and tracked via the per-task
 p->wait_runtime (nanosec-unit) value. "wait_runtime" is the amount of
-time the task should now run on the CPU for it become completely fair
+time the task should now run on the CPU for it to become completely fair
 and balanced.
 
 ( small detail: on 'ideal' hardware, the p->wait_runtime value would
@@ -37,10 +37,10 @@ the task schedules (or a scheduler tick
 'accounted for': the (small) time it just spent using the physical CPU
 is deducted from p->wait_runtime. [minus the 'fair share' it would have
 gotten anyway]. Once p->wait_runtime gets low enough so that another
-task becomes the 'leftmost task' (plus a small amount of 'granularity'
-distance relative to the leftmost task so that we do not over-schedule
-tasks and trash the cache) then the new leftmost task is picked and the
-current task is preempted.
+task becomes the 'leftmost task' of the time-ordered rbtree it maintains
+(plus a small amount of 'granularity' distance relative to the leftmost
+task so that we do not over-schedule tasks and trash the cache) then the
+new leftmost task is picked and the current task is preempted.
 
 The rq->fair_clock value tracks the 'CPU time a runnable task would have
 fairly gotten, had it been runnable during that time'. So by using
@@ -64,7 +64,7 @@ Some implementation details:
    replacement for the vanilla scheduler's SCHED_OTHER interactivity
    code.
 
-   i'd like to give credit to Con Kolivas for the general approach here:
+   I'd like to give credit to Con Kolivas for the general approach here:
    he has proven via RSDL/SD that 'fair scheduling' is possible and that
    it results in better desktop scheduling. Kudos Con!
 
@@ -92,7 +92,7 @@ Some implementation details:
    setting suitable for desktop workloads. SCHED_BATCH is handled by the
    CFS scheduler module too.
 
-   due to its design, the CFS scheduler is not prone to any of the
+   Due to its design, the CFS scheduler is not prone to any of the
    'attacks' that exist today against the heuristics of the stock
    scheduler: fiftyp.c, thud.c, chew.c, ring-test.c, massive_intr.c all
    work fine and do not impact interactivity and produce the expected
@@ -102,7 +102,7 @@ Some implementation details:
    SCHED_BATCH: both types of workloads should be isolated much more
    agressively than under the vanilla scheduler.
 
-   ( another rdetail: due to nanosec accounting and timeline sorting,
+   ( another detail: due to nanosec accounting and timeline sorting,
      sched_yield() support is very simple under CFS, and in fact under
      CFS sched_yield() behaves much better than under any other
      scheduler i have tested so far. )


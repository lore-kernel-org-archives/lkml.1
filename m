Return-Path: <linux-kernel-owner+w=401wt.eu-S1765357AbXEVIbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765357AbXEVIbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbXEVIa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:30:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46130 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863AbXEVIaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:30:55 -0400
Date: Tue, 22 May 2007 10:30:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pranith Kumar D <pranith-kumar_d@mentor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CFS: sched-design-CFS.txt - ambiguity about leftmost
Message-ID: <20070522083051.GA9699@elte.hu>
References: <465292B0.8040604@mentorg.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465292B0.8040604@mentorg.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Pranith Kumar D <pranith-kumar_d@mentor.com> wrote:

> Hello,
> I felt the description of the leftmost task a bit ambiguous. Is it the 
> leftmost task in the rbtree?

yeah, the leftmost task in the rbtree.

> or did u mean the "most leftout task" in the task list? If it is so 
> then this patch should correct the leftmost task as "most leftout 
> task". NACK it if I'm wrong. Just trying to help. :)

feel free to make it less ambigious. FYI, i recently changed the text 
(not released yet, change attached below), if you change it then please 
send a patch against this version. Thanks,

	Ingo

Index: linux/Documentation/sched-design-CFS.txt
===================================================================
--- linux.orig/Documentation/sched-design-CFS.txt
+++ linux/Documentation/sched-design-CFS.txt
@@ -1,20 +1,59 @@
-[announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
 
-i'm pleased to announce the first release of the "Modular Scheduler Core
-and Completely Fair Scheduler [CFS]" patchset:
+this is the CFS scheduler.
 
-   http://redhat.com/~mingo/cfs-scheduler/
+80% of CFS's design can be summed up in a single sentence: CFS basically
+models an "ideal, precise multi-tasking CPU" on real hardware.
 
-This project is a complete rewrite of the Linux task scheduler. My goal
-is to address various feature requests and to fix deficiencies in the
-vanilla scheduler that were suggested/found in the past few years, both
-for desktop scheduling and for server scheduling workloads.
+"Ideal multi-tasking CPU" is a (non-existent :-) CPU that has 100%
+physical power and which can run each task at precise equal speed, in
+parallel, each at 1/nr_running speed. For example: if there are 2 tasks
+running then it runs each at 50% physical power - totally in parallel.
+
+On real hardware, we can run only a single task at once, so while that
+one task runs the other tasks that are waiting for the CPU are at a
+disadvantage - the current task gets an unfair amount of CPU time. In
+CFS this fairness imbalance is expressed and tracked via the per-task
+p->wait_runtime (nanosec-unit) value. "wait_runtime" is the amount of
+time the task should now run on the CPU for it become completely fair
+and balanced.
+
+( small detail: on 'ideal' hardware, the p->wait_runtime value would
+  always be zero - no task would ever get 'out of balance' from the
+  'ideal' share of CPU time. )
+
+CFS's task picking logic is based on this p->wait_runtime value and it
+is thus very simple: it always tries to run the task with the largest
+p->wait_runtime value. In other words, CFS tries to run the task with
+the 'gravest need' for more CPU time. So CFS always tries to split up
+CPU time between runnable tasks as close to 'ideal multitasking
+hardware' as possible.
+
+Most of the rest of CFS's design just falls out of this really simple
+concept, with a few add-on embellishments like nice levels,
+multiprocessing and various algorithm variants to recognize sleepers.
+
+In practice it works like this: the system runs a task a bit, and when
+the task schedules (or a scheduler tick happens) the task's CPU usage is
+'accounted for': the (small) time it just spent using the physical CPU
+is deducted from p->wait_runtime. [minus the 'fair share' it would have
+gotten anyway]. Once p->wait_runtime gets low enough so that another
+task becomes the 'leftmost task' (plus a small amount of 'granularity'
+distance relative to the leftmost task so that we do not over-schedule
+tasks and trash the cache) then the new leftmost task is picked and the
+current task is preempted.
+
+The rq->fair_clock value tracks the 'CPU time a runnable task would have
+fairly gotten, had it been runnable during that time'. So by using
+rq->fair_clock values we can accurately timestamp and measure the
+'expected CPU time' a task should have gotten. All runnable tasks are
+sorted in the rbtree by the "rq->fair_clock - p->wait_runtime" key, and
+CFS picks the 'leftmost' task and sticks to it. As the system progresses
+forwards, newly woken tasks are put into the tree more and more to the
+right - slowly but surely giving a chance for every task to become the
+'leftmost task' and thus get on the CPU within a deterministic amount of
+time.
 
-[ QuickStart: apply the patch, recompile, reboot. The new scheduler
-  will be active by default and all tasks will default to the
-  SCHED_NORMAL interactive scheduling class. ]
-
-Highlights are:
+Some implementation details:
 
  - the introduction of Scheduling Classes: an extensible hierarchy of
    scheduler modules. These modules encapsulate scheduling policy
@@ -78,30 +117,3 @@ Highlights are:
    iterators of the scheduling modules are used. The balancing code got
    quite a bit simpler as a result.
 
-the core scheduler got smaller by more than 700 lines:
-
- kernel/sched.c | 1454 ++++++++++++++++------------------------------------------------
- 1 file changed, 372 insertions(+), 1082 deletions(-)
-
-and even adding all the scheduling modules, the total size impact is
-relatively small:
-
- 18 files changed, 1454 insertions(+), 1133 deletions(-)
-
-most of the increase is due to extensive comments. The kernel size
-impact is in fact a small negative:
-
-   text    data     bss     dec     hex filename
-  23366    4001      24   27391    6aff kernel/sched.o.vanilla
-  24159    2705      56   26920    6928 kernel/sched.o.CFS
-
-(this is mainly due to the benefit of getting rid of the expired array
-and its data structure overhead.)
-
-thanks go to Thomas Gleixner and Arjan van de Ven for review of this
-patchset.
-
-as usual, any sort of feedback, bugreports, fixes and suggestions are
-more than welcome,
-
-	Ingo

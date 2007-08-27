Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbXH0Kxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbXH0Kxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 06:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbXH0Kxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 06:53:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47616 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbXH0Kxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 06:53:31 -0400
Date: Mon, 27 Aug 2007 12:53:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Boldi <a1426z@gawab.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070827105317.GA15003@elte.hu>
References: <200708111344.42934.a1426z@gawab.com> <200708261927.07040.a1426z@gawab.com> <20070826163907.GB12453@elte.hu> <200708270706.41565.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708270706.41565.a1426z@gawab.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4851]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Boldi <a1426z@gawab.com> wrote:

> > could you send the exact patch that shows what you did?
> 
> On 2.6.22.5-v20.3 (not v20.4):
> 
> 340-    curr->delta_exec += delta_exec;
> 341-
> 342-    if (unlikely(curr->delta_exec > sysctl_sched_stat_granularity)) {
> 343://          __update_curr(cfs_rq, curr);
> 344-            curr->delta_exec = 0;
> 345-    }
> 346-    curr->exec_start = rq_of(cfs_rq)->clock;

ouch - this produces a really broken scheduler - with this we dont do 
any run-time accounting (!).

Could you try the patch below instead, does this make 3x glxgears smooth 
again? (if yes, could you send me your Signed-off-by line as well.)

	Ingo

------------------------>
Subject: sched: make the scheduler converge to the ideal latency
From: Ingo Molnar <mingo@elte.hu>

de-HZ-ification of the granularity defaults unearthed a pre-existing
property of CFS: while it correctly converges to the granularity goal,
it does not prevent run-time fluctuations in the range of [-gran ...
+gran].

With the increase of the granularity due to the removal of HZ
dependencies, this becomes visible in chew-max output (with 5 tasks
running):

 out:  28 . 27. 32 | flu:  0 .  0 | ran:    9 .   13 | per:   37 .   40
 out:  27 . 27. 32 | flu:  0 .  0 | ran:   17 .   13 | per:   44 .   40
 out:  27 . 27. 32 | flu:  0 .  0 | ran:    9 .   13 | per:   36 .   40
 out:  29 . 27. 32 | flu:  2 .  0 | ran:   17 .   13 | per:   46 .   40
 out:  28 . 27. 32 | flu:  0 .  0 | ran:    9 .   13 | per:   37 .   40
 out:  29 . 27. 32 | flu:  0 .  0 | ran:   18 .   13 | per:   47 .   40
 out:  28 . 27. 32 | flu:  0 .  0 | ran:    9 .   13 | per:   37 .   40

average slice is the ideal 13 msecs and the period is picture-perfect 40
msecs. But the 'ran' field fluctuates around 13.33 msecs and there's no
mechanism in CFS to keep that from happening: it's a perfectly valid
solution that CFS finds.

the solution is to add a granularity/preemption rule that knows about
the "target latency", which makes tasks that run longer than the ideal
latency run a bit less. The simplest approach is to simply decrease the
preemption granularity when a task overruns its ideal latency. For this
we have to track how much the task executed since its last preemption.

( this adds a new field to task_struct, but we can eliminate that
  overhead in 2.6.24 by putting all the scheduler timestamps into an
  anonymous union. )

with this change in place, chew-max output is fluctuation-less all
around:

 out:  28 . 27. 39 | flu:  0 .  2 | ran:   13 .   13 | per:   41 .   40
 out:  28 . 27. 39 | flu:  0 .  2 | ran:   13 .   13 | per:   41 .   40
 out:  28 . 27. 39 | flu:  0 .  2 | ran:   13 .   13 | per:   41 .   40
 out:  28 . 27. 39 | flu:  0 .  2 | ran:   13 .   13 | per:   41 .   40
 out:  28 . 27. 39 | flu:  0 .  1 | ran:   13 .   13 | per:   41 .   40
 out:  28 . 27. 39 | flu:  0 .  1 | ran:   13 .   13 | per:   41 .   40

this patch has no impact on any fastpath or on any globally observable
scheduling property. (unless you have sharp enough eyes to see
millisecond-level ruckles in glxgears smoothness :-)

Also, with this mechanism in place the formula for adaptive granularity
can be simplified down to the obvious "granularity = latency/nr_running"
calculation.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    1 +
 kernel/sched_fair.c   |   43 ++++++++++++++-----------------------------
 2 files changed, 15 insertions(+), 29 deletions(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -904,6 +904,7 @@ struct sched_entity {
 
 	u64			exec_start;
 	u64			sum_exec_runtime;
+	u64			prev_sum_exec_runtime;
 	u64			wait_start_fair;
 	u64			sleep_start_fair;
 
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -225,30 +225,6 @@ static struct sched_entity *__pick_next_
  * Calculate the preemption granularity needed to schedule every
  * runnable task once per sysctl_sched_latency amount of time.
  * (down to a sensible low limit on granularity)
- *
- * For example, if there are 2 tasks running and latency is 10 msecs,
- * we switch tasks every 5 msecs. If we have 3 tasks running, we have
- * to switch tasks every 3.33 msecs to get a 10 msecs observed latency
- * for each task. We do finer and finer scheduling up to until we
- * reach the minimum granularity value.
- *
- * To achieve this we use the following dynamic-granularity rule:
- *
- *    gran = lat/nr - lat/nr/nr
- *
- * This comes out of the following equations:
- *
- *    kA1 + gran = kB1
- *    kB2 + gran = kA2
- *    kA2 = kA1
- *    kB2 = kB1 - d + d/nr
- *    lat = d * nr
- *
- * Where 'k' is key, 'A' is task A (waiting), 'B' is task B (running),
- * '1' is start of time, '2' is end of time, 'd' is delay between
- * 1 and 2 (during which task B was running), 'nr' is number of tasks
- * running, 'lat' is the the period of each task. ('lat' is the
- * sched_latency that we aim for.)
  */
 static long
 sched_granularity(struct cfs_rq *cfs_rq)
@@ -257,7 +233,7 @@ sched_granularity(struct cfs_rq *cfs_rq)
 	unsigned int nr = cfs_rq->nr_running;
 
 	if (nr > 1) {
-		gran = gran/nr - gran/nr/nr;
+		gran = gran/nr;
 		gran = max(gran, sysctl_sched_min_granularity);
 	}
 
@@ -668,7 +644,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 /*
  * Preempt the current task with a newly woken task if needed:
  */
-static void
+static int
 __check_preempt_curr_fair(struct cfs_rq *cfs_rq, struct sched_entity *se,
 			  struct sched_entity *curr, unsigned long granularity)
 {
@@ -679,8 +655,11 @@ __check_preempt_curr_fair(struct cfs_rq 
 	 * preempt the current task unless the best task has
 	 * a larger than sched_granularity fairness advantage:
 	 */
-	if (__delta > niced_granularity(curr, granularity))
+	if (__delta > niced_granularity(curr, granularity)) {
 		resched_task(rq_of(cfs_rq)->curr);
+		return 1;
+	}
+	return 0;
 }
 
 static inline void
@@ -725,6 +704,7 @@ static void put_prev_entity(struct cfs_r
 
 static void entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 {
+	unsigned long gran, delta_exec;
 	struct sched_entity *next;
 
 	/*
@@ -741,8 +721,13 @@ static void entity_tick(struct cfs_rq *c
 	if (next == curr)
 		return;
 
-	__check_preempt_curr_fair(cfs_rq, next, curr,
-			sched_granularity(cfs_rq));
+	gran = sched_granularity(cfs_rq);
+	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
+	if (delta_exec > gran)
+		gran = 0;
+
+	if (__check_preempt_curr_fair(cfs_rq, next, curr, gran))
+		curr->prev_sum_exec_runtime = curr->sum_exec_runtime;
 }
 
 /**************************************************

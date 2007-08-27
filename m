Return-Path: <linux-kernel-owner+w=401wt.eu-S1763478AbXH0Ulq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763478AbXH0Ulq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbXH0Ulf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:41:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44088 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226AbXH0Ule (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:41:34 -0400
Date: Mon, 27 Aug 2007 22:41:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Boldi <a1426z@gawab.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070827204116.GA12495@elte.hu>
References: <200708111344.42934.a1426z@gawab.com> <200708270706.41565.a1426z@gawab.com> <20070827105317.GA15003@elte.hu> <200708271746.47685.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708271746.47685.a1426z@gawab.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Boldi <a1426z@gawab.com> wrote:

> > Could you try the patch below instead, does this make 3x glxgears 
> > smooth again? (if yes, could you send me your Signed-off-by line as 
> > well.)
> 
> The task-startup stalling is still there for ~10sec.
> 
> Can you see the problem on your machine?

nope (i have no framebuffer setup) - but i can see some chew-max 
latencies that occur when new tasks are started up. I _think_ it's 
probably the same problem as yours.

could you try the patch below (which is the combo patch of my current 
queue), ontop of head 50c46637aa? This makes chew-max behave better 
during task mass-startup here.

	Ingo

----------------->
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
 
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -1587,6 +1587,7 @@ static void __sched_fork(struct task_str
 	p->se.wait_start_fair		= 0;
 	p->se.exec_start		= 0;
 	p->se.sum_exec_runtime		= 0;
+	p->se.prev_sum_exec_runtime	= 0;
 	p->se.delta_exec		= 0;
 	p->se.delta_fair_run		= 0;
 	p->se.delta_fair_sleep		= 0;
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -82,12 +82,12 @@ enum {
 };
 
 unsigned int sysctl_sched_features __read_mostly =
-		SCHED_FEAT_FAIR_SLEEPERS	*1 |
+		SCHED_FEAT_FAIR_SLEEPERS	*0 |
 		SCHED_FEAT_SLEEPER_AVG		*0 |
 		SCHED_FEAT_SLEEPER_LOAD_AVG	*1 |
 		SCHED_FEAT_PRECISE_CPU_LOAD	*1 |
-		SCHED_FEAT_START_DEBIT		*1 |
-		SCHED_FEAT_SKIP_INITIAL		*0;
+		SCHED_FEAT_START_DEBIT		*0 |
+		SCHED_FEAT_SKIP_INITIAL		*1;
 
 extern struct sched_class fair_sched_class;
 
@@ -225,39 +225,15 @@ static struct sched_entity *__pick_next_
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
-static long
+static unsigned long
 sched_granularity(struct cfs_rq *cfs_rq)
 {
 	unsigned int gran = sysctl_sched_latency;
 	unsigned int nr = cfs_rq->nr_running;
 
 	if (nr > 1) {
-		gran = gran/nr - gran/nr/nr;
+		gran = gran/nr;
 		gran = max(gran, sysctl_sched_min_granularity);
 	}
 
@@ -489,6 +465,9 @@ update_stats_wait_end(struct cfs_rq *cfs
 {
 	unsigned long delta_fair;
 
+	if (unlikely(!se->wait_start_fair))
+		return;
+
 	delta_fair = (unsigned long)min((u64)(2*sysctl_sched_runtime_limit),
 			(u64)(cfs_rq->fair_clock - se->wait_start_fair));
 
@@ -668,7 +647,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 /*
  * Preempt the current task with a newly woken task if needed:
  */
-static void
+static int
 __check_preempt_curr_fair(struct cfs_rq *cfs_rq, struct sched_entity *se,
 			  struct sched_entity *curr, unsigned long granularity)
 {
@@ -679,8 +658,11 @@ __check_preempt_curr_fair(struct cfs_rq 
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
@@ -725,6 +707,7 @@ static void put_prev_entity(struct cfs_r
 
 static void entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 {
+	unsigned long gran, delta_exec;
 	struct sched_entity *next;
 
 	/*
@@ -741,8 +724,13 @@ static void entity_tick(struct cfs_rq *c
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
@@ -1080,29 +1068,27 @@ static void task_new_fair(struct rq *rq,
 
 	sched_info_queued(p);
 
+	update_curr(cfs_rq);
 	update_stats_enqueue(cfs_rq, se);
-	/*
-	 * Child runs first: we let it run before the parent
-	 * until it reschedules once. We set up the key so that
-	 * it will preempt the parent:
-	 */
-	p->se.fair_key = current->se.fair_key -
-		niced_granularity(&rq->curr->se, sched_granularity(cfs_rq)) - 1;
+
 	/*
 	 * The first wait is dominated by the child-runs-first logic,
 	 * so do not credit it with that waiting time yet:
 	 */
 	if (sysctl_sched_features & SCHED_FEAT_SKIP_INITIAL)
-		p->se.wait_start_fair = 0;
+		se->wait_start_fair = 0;
 
 	/*
 	 * The statistical average of wait_runtime is about
 	 * -granularity/2, so initialize the task with that:
 	 */
-	if (sysctl_sched_features & SCHED_FEAT_START_DEBIT)
-		p->se.wait_runtime = -(sched_granularity(cfs_rq) / 2);
+	if (sysctl_sched_features & SCHED_FEAT_START_DEBIT) {
+		se->wait_runtime = -(sched_granularity(cfs_rq)/2);
+		schedstat_add(cfs_rq, wait_runtime, se->wait_runtime);
+	}
 
 	__enqueue_entity(cfs_rq, se);
+	resched_task(current);
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED

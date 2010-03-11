Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0CKJvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:51:10 -0500
Received: from mail.gmx.net ([213.165.64.20]:35940 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755411Ab0CKJvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:51:07 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+7IRldh667kW76oMnWx7u6CSJwIY7mgDrLTuz+zW
	naC7xWCXApvgLG
Subject: Re: [patch 2/12] sched: remove avg_wakeup
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1268300950.6785.27.camel@marge.simson.net>
References: <1268300950.6785.27.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 11 Mar 2010 10:51:02 +0100
Message-Id: <1268301062.6785.29.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: remove avg_wakeup.

Testing the load which led to this heuristic (nfs4 kbuild) shows that it has
outlived it's usefullness.  With intervening load balancing changes, I cannot
see any difference with/without, so recover there fastpath cycles.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 include/linux/sched.h   |    3 ---
 kernel/sched.c          |   26 ++++----------------------
 kernel/sched_debug.c    |    1 -
 kernel/sched_fair.c     |   31 -------------------------------
 kernel/sched_features.h |    6 ------
 5 files changed, 4 insertions(+), 63 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1105,9 +1105,6 @@ struct sched_entity {
 
 	u64			nr_migrations;
 
-	u64			start_runtime;
-	u64			avg_wakeup;
-
 #ifdef CONFIG_SCHEDSTATS
 	u64			wait_start;
 	u64			wait_max;
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1880,9 +1880,6 @@ static void update_avg(u64 *avg, u64 sam
 static void
 enqueue_task(struct rq *rq, struct task_struct *p, int wakeup, bool head)
 {
-	if (wakeup)
-		p->se.start_runtime = p->se.sum_exec_runtime;
-
 	sched_info_queued(p);
 	p->sched_class->enqueue_task(rq, p, wakeup, head);
 	p->se.on_rq = 1;
@@ -1890,17 +1887,11 @@ enqueue_task(struct rq *rq, struct task_
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 {
-	if (sleep) {
-		if (p->se.last_wakeup) {
-			update_avg(&p->se.avg_overlap,
-				p->se.sum_exec_runtime - p->se.last_wakeup);
-			p->se.last_wakeup = 0;
-		} else {
-			update_avg(&p->se.avg_wakeup,
-				sysctl_sched_wakeup_granularity);
-		}
+	if (sleep && p->se.last_wakeup) {
+		update_avg(&p->se.avg_overlap,
+			p->se.sum_exec_runtime - p->se.last_wakeup);
+		p->se.last_wakeup = 0;
 	}
-
 	sched_info_dequeued(p);
 	p->sched_class->dequeue_task(rq, p, sleep);
 	p->se.on_rq = 0;
@@ -2466,13 +2457,6 @@ out_activate:
 	 */
 	if (!in_interrupt()) {
 		struct sched_entity *se = &current->se;
-		u64 sample = se->sum_exec_runtime;
-
-		if (se->last_wakeup)
-			sample -= se->last_wakeup;
-		else
-			sample -= se->start_runtime;
-		update_avg(&se->avg_wakeup, sample);
 
 		se->last_wakeup = se->sum_exec_runtime;
 	}
@@ -2540,8 +2524,6 @@ static void __sched_fork(struct task_str
 	p->se.nr_migrations		= 0;
 	p->se.last_wakeup		= 0;
 	p->se.avg_overlap		= 0;
-	p->se.start_runtime		= 0;
-	p->se.avg_wakeup		= sysctl_sched_wakeup_granularity;
 
 #ifdef CONFIG_SCHEDSTATS
 	p->se.wait_start			= 0;
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -408,7 +408,6 @@ void proc_sched_show_task(struct task_st
 	PN(se.vruntime);
 	PN(se.sum_exec_runtime);
 	PN(se.avg_overlap);
-	PN(se.avg_wakeup);
 
 	nr_switches = p->nvcsw + p->nivcsw;
 
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1591,42 +1591,11 @@ static int select_task_rq_fair(struct ta
 }
 #endif /* CONFIG_SMP */
 
-/*
- * Adaptive granularity
- *
- * se->avg_wakeup gives the average time a task runs until it does a wakeup,
- * with the limit of wakeup_gran -- when it never does a wakeup.
- *
- * So the smaller avg_wakeup is the faster we want this task to preempt,
- * but we don't want to treat the preemptee unfairly and therefore allow it
- * to run for at least the amount of time we'd like to run.
- *
- * NOTE: we use 2*avg_wakeup to increase the probability of actually doing one
- *
- * NOTE: we use *nr_running to scale with load, this nicely matches the
- *       degrading latency on load.
- */
-static unsigned long
-adaptive_gran(struct sched_entity *curr, struct sched_entity *se)
-{
-	u64 this_run = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
-	u64 expected_wakeup = 2*se->avg_wakeup * cfs_rq_of(se)->nr_running;
-	u64 gran = 0;
-
-	if (this_run < expected_wakeup)
-		gran = expected_wakeup - this_run;
-
-	return min_t(s64, gran, sysctl_sched_wakeup_granularity);
-}
-
 static unsigned long
 wakeup_gran(struct sched_entity *curr, struct sched_entity *se)
 {
 	unsigned long gran = sysctl_sched_wakeup_granularity;
 
-	if (cfs_rq_of(curr)->curr && sched_feat(ADAPTIVE_GRAN))
-		gran = adaptive_gran(curr, se);
-
 	/*
 	 * Since its curr running now, convert the gran from real-time
 	 * to virtual-time in his units.
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -31,12 +31,6 @@ SCHED_FEAT(START_DEBIT, 1)
 SCHED_FEAT(WAKEUP_PREEMPT, 1)
 
 /*
- * Compute wakeup_gran based on task behaviour, clipped to
- *  [0, sched_wakeup_gran_ns]
- */
-SCHED_FEAT(ADAPTIVE_GRAN, 1)
-
-/*
  * When converting the wakeup granularity to virtual time, do it such
  * that heavier tasks preempting a lighter task have an edge.
  */



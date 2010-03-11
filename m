Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab0CKJwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:52:17 -0500
Received: from mail.gmx.net ([213.165.64.20]:49985 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755285Ab0CKJwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:52:15 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+fc0AEUIufM0AKH1n4d+oaw+rQZ13Hj/rw5nyHGg
	yOAOw55/tGV1A2
Subject: Re: [patch 3/12] sched: remove avg_overlap
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1268300950.6785.27.camel@marge.simson.net>
References: <1268300950.6785.27.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 11 Mar 2010 10:52:01 +0100
Message-Id: <1268301121.6785.30.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42999999999999999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: remove avg_overlap

Both avg_overlap and avg_wakeup had an inherent problem in that their accuracy
was detrimentally affected by cross-cpu wakeups, this because we are missing
the necessary call to update_curr().  This can't be fixed without increasing
overhead in our already too fat fastpath.

Additionally, with recent load balancing changes making us prefer to place tasks
in an idle cache domain (which is good for compute bound loads), communicating
tasks suffer when a sync wakeup, which would enable affine placement, is turned
into a non-sync wakeup by SYNC_LESS.  With one task on the runqueue, wake_affine()
rejects the affine wakeup request, leaving the unfortunate where placed, taking
frequent cache misses.

Remove it, and recover some fastpath cycles.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 include/linux/sched.h   |    3 ---
 kernel/sched.c          |   33 ---------------------------------
 kernel/sched_debug.c    |    1 -
 kernel/sched_fair.c     |   18 ------------------
 kernel/sched_features.h |   16 ----------------
 5 files changed, 71 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1100,9 +1100,6 @@ struct sched_entity {
 	u64			vruntime;
 	u64			prev_sum_exec_runtime;
 
-	u64			last_wakeup;
-	u64			avg_overlap;
-
 	u64			nr_migrations;
 
 #ifdef CONFIG_SCHEDSTATS
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1887,11 +1887,6 @@ enqueue_task(struct rq *rq, struct task_
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 {
-	if (sleep && p->se.last_wakeup) {
-		update_avg(&p->se.avg_overlap,
-			p->se.sum_exec_runtime - p->se.last_wakeup);
-		p->se.last_wakeup = 0;
-	}
 	sched_info_dequeued(p);
 	p->sched_class->dequeue_task(rq, p, sleep);
 	p->se.on_rq = 0;
@@ -2452,15 +2447,6 @@ out_activate:
 	activate_task(rq, p, 1);
 	success = 1;
 
-	/*
-	 * Only attribute actual wakeups done by this task.
-	 */
-	if (!in_interrupt()) {
-		struct sched_entity *se = &current->se;
-
-		se->last_wakeup = se->sum_exec_runtime;
-	}
-
 out_running:
 	trace_sched_wakeup(rq, p, success);
 	check_preempt_curr(rq, p, wake_flags);
@@ -2522,8 +2508,6 @@ static void __sched_fork(struct task_str
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
 	p->se.nr_migrations		= 0;
-	p->se.last_wakeup		= 0;
-	p->se.avg_overlap		= 0;
 
 #ifdef CONFIG_SCHEDSTATS
 	p->se.wait_start			= 0;
@@ -3623,23 +3607,6 @@ static inline void schedule_debug(struct
 
 static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
-	if (prev->state == TASK_RUNNING) {
-		u64 runtime = prev->se.sum_exec_runtime;
-
-		runtime -= prev->se.prev_sum_exec_runtime;
-		runtime = min_t(u64, runtime, 2*sysctl_sched_migration_cost);
-
-		/*
-		 * In order to avoid avg_overlap growing stale when we are
-		 * indeed overlapping and hence not getting put to sleep, grow
-		 * the avg_overlap on preemption.
-		 *
-		 * We use the average preemption runtime because that
-		 * correlates to the amount of cache footprint a task can
-		 * build up.
-		 */
-		update_avg(&prev->se.avg_overlap, runtime);
-	}
 	prev->sched_class->put_prev_task(rq, prev);
 }
 
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -407,7 +407,6 @@ void proc_sched_show_task(struct task_st
 	PN(se.exec_start);
 	PN(se.vruntime);
 	PN(se.sum_exec_runtime);
-	PN(se.avg_overlap);
 
 	nr_switches = p->nvcsw + p->nivcsw;
 
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1240,7 +1240,6 @@ static inline unsigned long effective_lo
 
 static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
-	struct task_struct *curr = current;
 	unsigned long this_load, load;
 	int idx, this_cpu, prev_cpu;
 	unsigned long tl_per_task;
@@ -1255,18 +1254,6 @@ static int wake_affine(struct sched_doma
 	load	  = source_load(prev_cpu, idx);
 	this_load = target_load(this_cpu, idx);
 
-	if (sync) {
-	       if (sched_feat(SYNC_LESS) &&
-		   (curr->se.avg_overlap > sysctl_sched_migration_cost ||
-		    p->se.avg_overlap > sysctl_sched_migration_cost))
-		       sync = 0;
-	} else {
-		if (sched_feat(SYNC_MORE) &&
-		    (curr->se.avg_overlap < sysctl_sched_migration_cost &&
-		     p->se.avg_overlap < sysctl_sched_migration_cost))
-			sync = 1;
-	}
-
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
 	 * effect of the currently running task from the load
@@ -1710,11 +1697,6 @@ static void check_preempt_wakeup(struct
 	if (sched_feat(WAKEUP_SYNC) && sync)
 		goto preempt;
 
-	if (sched_feat(WAKEUP_OVERLAP) &&
-			se->avg_overlap < sysctl_sched_migration_cost &&
-			pse->avg_overlap < sysctl_sched_migration_cost)
-		goto preempt;
-
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -42,12 +42,6 @@ SCHED_FEAT(ASYM_GRAN, 1)
 SCHED_FEAT(WAKEUP_SYNC, 0)
 
 /*
- * Wakeup preempt based on task behaviour. Tasks that do not overlap
- * don't get preempted.
- */
-SCHED_FEAT(WAKEUP_OVERLAP, 0)
-
-/*
  * Use the SYNC wakeup hint, pipes and the likes use this to indicate
  * the remote end is likely to consume the data we just wrote, and
  * therefore has cache benefit from being placed on the same cpu, see
@@ -64,16 +58,6 @@ SCHED_FEAT(SYNC_WAKEUPS, 1)
 SCHED_FEAT(AFFINE_WAKEUPS, 1)
 
 /*
- * Weaken SYNC hint based on overlap
- */
-SCHED_FEAT(SYNC_LESS, 1)
-
-/*
- * Add SYNC hint based on overlap
- */
-SCHED_FEAT(SYNC_MORE, 0)
-
-/*
  * Prefer to schedule the task we woke last (assuming it failed
  * wakeup-preemption), since its likely going to consume data we
  * touched, increases cache locality.



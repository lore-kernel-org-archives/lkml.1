Return-Path: <linux-kernel-owner+w=401wt.eu-S935103AbZLPRIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935103AbZLPRIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762286AbZLPRGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:06:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36124 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762282AbZLPRGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:06:17 -0500
Message-Id: <20091216170518.191697025@chello.nl>
References: <20091216170430.073353839@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 16 Dec 2009 18:04:41 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 11/12] sched: Remove the cfs_rq dependency from set_task_cpu()
Content-Disposition: inline; filename=foo1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to remove the cfs_rq dependency from set_task_cpu() we need
to ensure the task is cfs_rq invariant for all callsites.

The simple approach is to substract cfs_rq->min_vruntime from
se->vruntime on dequeue, and add cfs_rq->min_vruntime on enqueue.

However, this has the downside of breaking FAIR_SLEEPERS since we
loose the old vruntime as we only maintain the relative position.

To solve this, we observe that we only migrate runnable tasks, we do
this using deactivate_task(.sleep=0) and activate_task(.wakeup=0),
therefore we can restrain the min_vruntime invariance to that state.

The only other case is wakeup balancing, since we want to maintain the
old vruntime we cannot make it relative on dequeue, but since we don't
migrate inactive tasks, we can do so right before we activate it
again.

This is where we need the new pre-wakeup hook, we need to call this
while still holding the old rq->lock. We could fold it into
->select_task_rq(), but since that has multiple callsites and would
obfuscate the locking requirements, that seems like a fudge.

This leaves the fork() case, simply make sure that ->task_fork()
leaves the ->vruntime in a relative state.

This covers all cases where set_task_cpu() gets called, and ensures it
sees a relative vruntime.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    2 +-
 kernel/sched.c        |    6 +-----
 kernel/sched_fair.c   |   50 ++++++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 46 insertions(+), 12 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2038,8 +2038,6 @@ task_hot(struct task_struct *p, u64 now,
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 {
 	int old_cpu = task_cpu(p);
-	struct cfs_rq *old_cfsrq = task_cfs_rq(p),
-		      *new_cfsrq = cpu_cfs_rq(old_cfsrq, new_cpu);
 
 #ifdef CONFIG_SCHED_DEBUG
 	/*
@@ -2056,8 +2054,6 @@ void set_task_cpu(struct task_struct *p,
 		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS,
 				     1, 1, NULL, 0);
 	}
-	p->se.vruntime -= old_cfsrq->min_vruntime -
-					 new_cfsrq->min_vruntime;
 
 	__set_task_cpu(p, new_cpu);
 }
@@ -10109,7 +10105,7 @@ void sched_move_task(struct task_struct 
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	if (tsk->sched_class->moved_group)
-		tsk->sched_class->moved_group(tsk);
+		tsk->sched_class->moved_group(tsk, on_rq);
 #endif
 
 	if (unlikely(running))
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -510,6 +510,7 @@ __update_curr(struct cfs_rq *cfs_rq, str
 	curr->sum_exec_runtime += delta_exec;
 	schedstat_add(cfs_rq, exec_clock, delta_exec);
 	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
+
 	curr->vruntime += delta_exec_weighted;
 	update_min_vruntime(cfs_rq);
 }
@@ -765,16 +766,26 @@ place_entity(struct cfs_rq *cfs_rq, stru
 	se->vruntime = vruntime;
 }
 
+#define ENQUEUE_WAKEUP	1
+#define ENQUEUE_MIGRATE 2
+
 static void
-enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
+enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
 	/*
+	 * Update the normalized vruntime before updating min_vruntime
+	 * through callig update_curr().
+	 */
+	if (!(flags & ENQUEUE_WAKEUP) || (flags & ENQUEUE_MIGRATE))
+		se->vruntime += cfs_rq->min_vruntime;
+
+	/*
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
 	account_entity_enqueue(cfs_rq, se);
 
-	if (wakeup) {
+	if (flags & ENQUEUE_WAKEUP) {
 		place_entity(cfs_rq, se, 0);
 		enqueue_sleeper(cfs_rq, se);
 	}
@@ -828,6 +839,14 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 		__dequeue_entity(cfs_rq, se);
 	account_entity_dequeue(cfs_rq, se);
 	update_min_vruntime(cfs_rq);
+
+	/*
+	 * Normalize the entity after updating the min_vruntime because the
+	 * update can refer to the ->curr item and we need to reflect this
+	 * movement in our normalized position.
+	 */
+	if (!sleep)
+		se->vruntime -= cfs_rq->min_vruntime;
 }
 
 /*
@@ -1038,13 +1057,19 @@ static void enqueue_task_fair(struct rq 
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
+	int flags = 0;
+
+	if (wakeup)
+		flags |= ENQUEUE_WAKEUP;
+	if (p->state == TASK_WAKING)
+		flags |= ENQUEUE_MIGRATE;
 
 	for_each_sched_entity(se) {
 		if (se->on_rq)
 			break;
 		cfs_rq = cfs_rq_of(se);
-		enqueue_entity(cfs_rq, se, wakeup);
-		wakeup = 1;
+		enqueue_entity(cfs_rq, se, flags);
+		flags = ENQUEUE_WAKEUP;
 	}
 
 	hrtick_update(rq);
@@ -1120,6 +1145,14 @@ static void yield_task_fair(struct rq *r
 
 #ifdef CONFIG_SMP
 
+static void task_waking_fair(struct rq *rq, struct task_struct *p)
+{
+	struct sched_entity *se = &p->se;
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+	se->vruntime -= cfs_rq->min_vruntime;
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 /*
  * effective_load() calculates the load change as seen from the root_task_group
@@ -1978,6 +2011,8 @@ static void task_fork_fair(struct task_s
 		resched_task(rq->curr);
 	}
 
+	se->vruntime -= cfs_rq->min_vruntime;
+
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
@@ -2031,12 +2066,13 @@ static void set_curr_task_fair(struct rq
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static void moved_group_fair(struct task_struct *p)
+static void moved_group_fair(struct task_struct *p, int on_rq)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
 
 	update_curr(cfs_rq);
-	place_entity(cfs_rq, &p->se, 1);
+	if (!on_rq)
+		place_entity(cfs_rq, &p->se, 1);
 }
 #endif
 
@@ -2076,6 +2112,8 @@ static const struct sched_class fair_sch
 	.move_one_task		= move_one_task_fair,
 	.rq_online		= rq_online_fair,
 	.rq_offline		= rq_offline_fair,
+
+	.task_waking		= task_waking_fair,
 #endif
 
 	.set_curr_task          = set_curr_task_fair,
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1116,7 +1116,7 @@ struct sched_class {
 					 struct task_struct *task);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	void (*moved_group) (struct task_struct *p);
+	void (*moved_group) (struct task_struct *p, int on_rq);
 #endif
 };
 

-- 


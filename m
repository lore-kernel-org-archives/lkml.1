Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbYCIRJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbYCIRJy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYCIRJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:09:19 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:4594 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751939AbYCIRJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:09:17 -0400
Message-Id: <20080309170927.621294000@chello.nl>
References: <20080309170850.256853000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 09 Mar 2008 18:08:58 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 08/17] sched: fair-group: single RQ approach
Content-Disposition: inline; filename=sched-fair-group-single-rq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current hierarchical RQ group scheduler suffers from a number of problems:
 - yield
 - wakeup preemption
 - sleeper fairness

All these problems are due to the isolation caused by the multiple RQ design.
They are caused by the fact that vruntime becomes a local property.

Solve this by returning to a single RQ model.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c      |    9 --
 kernel/sched_fair.c |  193 +++++++++++++++++++++++++++-------------------------
 2 files changed, 105 insertions(+), 97 deletions(-)

Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -1270,6 +1270,9 @@ static void __resched_task(struct task_s
  */
 #define SRR(x, y) (((x) + (1UL << ((y) - 1))) >> (y))
 
+/*
+ * delta *= weight / lw
+ */
 static unsigned long
 calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 		struct load_weight *lw)
@@ -1292,12 +1295,6 @@ calc_delta_mine(unsigned long delta_exec
 	return (unsigned long)min(tmp, (u64)(unsigned long)LONG_MAX);
 }
 
-static inline unsigned long
-calc_delta_fair(unsigned long delta_exec, struct load_weight *lw)
-{
-	return calc_delta_mine(delta_exec, NICE_0_LOAD, lw);
-}
-
 static inline void update_load_add(struct load_weight *lw, unsigned long inc)
 {
 	lw->weight += inc;
Index: linux-2.6-2/kernel/sched_fair.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_fair.c
+++ linux-2.6-2/kernel/sched_fair.c
@@ -238,12 +238,22 @@ static inline s64 entity_key(struct cfs_
  */
 static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
+	struct rb_node **link;
 	struct rb_node *parent = NULL;
 	struct sched_entity *entry;
-	s64 key = entity_key(cfs_rq, se);
+	s64 key;
 	int leftmost = 1;
 
+	if (!entity_is_task(se))
+		return;
+
+	if (se == cfs_rq->curr)
+		return;
+
+	cfs_rq = &rq_of(cfs_rq)->cfs;
+
+	link = &cfs_rq->tasks_timeline.rb_node;
+	key = entity_key(cfs_rq, se);
 	/*
 	 * Find the right place in the rbtree:
 	 */
@@ -275,6 +285,14 @@ static void __enqueue_entity(struct cfs_
 
 static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
+	if (!entity_is_task(se))
+		return;
+
+	if (se == cfs_rq->curr)
+		return;
+
+	cfs_rq = &rq_of(cfs_rq)->cfs;
+
 	if (cfs_rq->rb_leftmost == &se->run_node)
 		cfs_rq->rb_leftmost = rb_next(&se->run_node);
 
@@ -353,6 +371,13 @@ static u64 sched_slice(struct cfs_rq *cf
 {
 	u64 slice = __sched_period(cfs_rq->nr_running);
 
+	/*
+	 * FIXME: curious 'hack' to make it boot - when the tick is started we
+	 * hit this with the init_task, which is not actually enqueued.
+	 */
+	if (unlikely(rq_of(cfs_rq)->load.weight <= se->load.weight))
+		goto out;
+
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 
@@ -360,37 +385,66 @@ static u64 sched_slice(struct cfs_rq *cf
 		do_div(slice, cfs_rq->load.weight);
 	}
 
+out:
 	return slice;
 }
 
 /*
  * We calculate the vruntime slice of a to be inserted task
  *
- * vs = s/w = p/rw
+ * vs = s*rw/w = p
  */
 static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	unsigned long nr_running = cfs_rq->nr_running;
-	unsigned long weight;
-	u64 vslice;
 
 	if (!se->on_rq)
 		nr_running++;
 
-	vslice = __sched_period(nr_running);
+	return __sched_period(nr_running);
+}
 
+static inline unsigned long
+calc_delta_fair(unsigned long delta, struct sched_entity *se)
+{
 	for_each_sched_entity(se) {
-		cfs_rq = cfs_rq_of(se);
+		delta = calc_delta_mine(delta,
+				cfs_rq_of(se)->load.weight, &se->load);
+	}
 
-		weight = cfs_rq->load.weight;
-		if (!se->on_rq)
-			weight += se->load.weight;
+	return delta;
+}
+
+/*
+ * The goal of calc_delta_asym() is to be asymmetrically around NICE_0_LOAD, in
+ * that it favours >=0 over <0.
+ *
+ *   -20         |
+ *               |
+ *     0 --------+-------
+ *             .'
+ *    19     .'
+ *
+ */
+static unsigned long
+calc_delta_asym(unsigned long delta, struct sched_entity *se)
+{
+	struct load_weight lw = {
+		.weight = NICE_0_LOAD,
+		.inv_weight = 1UL << (WMULT_SHIFT-NICE_0_SHIFT)
+	};
+
+	for_each_sched_entity(se) {
+		struct load_weight *se_lw = &se->load;
 
-		vslice *= NICE_0_LOAD;
-		do_div(vslice, weight);
+		if (se->load.weight < NICE_0_LOAD)
+			se_lw = &lw;
+
+		delta = calc_delta_mine(delta,
+				cfs_rq_of(se)->load.weight, se_lw);
 	}
 
-	return vslice;
+	return delta;
 }
 
 /*
@@ -408,13 +462,14 @@ __update_curr(struct cfs_rq *cfs_rq, str
 
 	curr->sum_exec_runtime += delta_exec;
 	schedstat_add(cfs_rq, exec_clock, delta_exec);
-	delta_exec_weighted = delta_exec;
-	if (unlikely(curr->load.weight != NICE_0_LOAD)) {
-		delta_exec_weighted = calc_delta_fair(delta_exec_weighted,
-							&curr->load);
-	}
+	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
 	curr->vruntime += delta_exec_weighted;
 
+	if (!entity_is_task(curr))
+		return;
+
+	cfs_rq = &rq_of(cfs_rq)->cfs;
+
 	/*
 	 * maintain cfs_rq->min_vruntime to be a monotonic increasing
 	 * value tracking the leftmost vruntime in the tree.
@@ -594,6 +649,11 @@ place_entity(struct cfs_rq *cfs_rq, stru
 {
 	u64 vruntime;
 
+	if (!entity_is_task(se))
+		return;
+
+	cfs_rq = &rq_of(cfs_rq)->cfs;
+
 	vruntime = cfs_rq->min_vruntime;
 
 	/*
@@ -608,7 +668,7 @@ place_entity(struct cfs_rq *cfs_rq, stru
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
 		if (sched_feat(NEW_FAIR_SLEEPERS))
-			vruntime -= sysctl_sched_latency;
+			vruntime -= calc_delta_asym(sysctl_sched_latency, se);
 
 		/* ensure we never gain time by being placed backwards. */
 		vruntime = max_vruntime(se->vruntime, vruntime);
@@ -632,8 +692,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 
 	update_stats_enqueue(cfs_rq, se);
 	check_spread(cfs_rq, se);
-	if (se != cfs_rq->curr)
-		__enqueue_entity(cfs_rq, se);
+	__enqueue_entity(cfs_rq, se);
 	account_entity_enqueue(cfs_rq, se);
 }
 
@@ -659,8 +718,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 #endif
 	}
 
-	if (se != cfs_rq->curr)
-		__dequeue_entity(cfs_rq, se);
+	__dequeue_entity(cfs_rq, se);
 	account_entity_dequeue(cfs_rq, se);
 }
 
@@ -689,6 +747,8 @@ set_next_entity(struct cfs_rq *cfs_rq, s
 		 * runqueue.
 		 */
 		update_stats_wait_end(cfs_rq, se);
+		if (WARN_ON_ONCE(cfs_rq->curr))
+			cfs_rq->curr = NULL;
 		__dequeue_entity(cfs_rq, se);
 	}
 
@@ -708,18 +768,6 @@ set_next_entity(struct cfs_rq *cfs_rq, s
 	se->prev_sum_exec_runtime = se->sum_exec_runtime;
 }
 
-static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
-{
-	struct sched_entity *se = NULL;
-
-	if (first_fair(cfs_rq)) {
-		se = __pick_next_entity(cfs_rq);
-		set_next_entity(cfs_rq, se);
-	}
-
-	return se;
-}
-
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
 	/*
@@ -730,12 +778,12 @@ static void put_prev_entity(struct cfs_r
 		update_curr(cfs_rq);
 
 	check_spread(cfs_rq, prev);
+	cfs_rq->curr = NULL;
 	if (prev->on_rq) {
 		update_stats_wait_start(cfs_rq, prev);
 		/* Put 'current' back into the tree. */
 		__enqueue_entity(cfs_rq, prev);
 	}
-	cfs_rq->curr = NULL;
 }
 
 static void
@@ -746,6 +794,9 @@ entity_tick(struct cfs_rq *cfs_rq, struc
 	 */
 	update_curr(cfs_rq);
 
+	if (!entity_is_task(curr))
+		return;
+
 #ifdef CONFIG_SCHED_HRTICK
 	/*
 	 * queued ticks are scheduled to match the slice, so don't bother
@@ -761,7 +812,8 @@ entity_tick(struct cfs_rq *cfs_rq, struc
 		return;
 #endif
 
-	if (cfs_rq->nr_running > 1 || !sched_feat(WAKEUP_PREEMPT))
+	if (rq_of(cfs_rq)->load.weight != curr->load.weight ||
+			!sched_feat(WAKEUP_PREEMPT))
 		check_preempt_tick(cfs_rq, curr);
 }
 
@@ -878,7 +930,7 @@ static void yield_task_fair(struct rq *r
 	/*
 	 * Are we the only task in the tree?
 	 */
-	if (unlikely(cfs_rq->nr_running == 1))
+	if (unlikely(rq->load.weight == curr->se.load.weight))
 		return;
 
 	if (likely(!sysctl_sched_compat_yield) && curr->policy != SCHED_BATCH) {
@@ -893,7 +945,7 @@ static void yield_task_fair(struct rq *r
 	/*
 	 * Find the rightmost entry in the rbtree:
 	 */
-	rightmost = __pick_last_entity(cfs_rq);
+	rightmost = __pick_last_entity(&rq->cfs);
 	/*
 	 * Already in the rightmost position?
 	 */
@@ -1055,18 +1107,6 @@ out_set_cpu:
 }
 #endif /* CONFIG_SMP */
 
-/* return depth at which a sched entity is present in the hierarchy */
-static inline int depth_se(struct sched_entity *se)
-{
-	int depth = 0;
-
-	for_each_sched_entity(se)
-		depth++;
-
-	return depth;
-}
-
-
 /*
  * Preempt the current task with a newly woken task if needed:
  */
@@ -1076,7 +1116,6 @@ static void check_preempt_wakeup(struct 
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
 	struct sched_entity *se = &curr->se, *pse = &p->se;
 	unsigned long gran;
-	int se_depth, pse_depth;
 
 	if (unlikely(rt_prio(p->prio))) {
 		update_rq_clock(rq);
@@ -1095,39 +1134,10 @@ static void check_preempt_wakeup(struct 
 		return;
 
 	/*
-	 * preemption test can be made between sibling entities who are in the
-	 * same cfs_rq i.e who have a common parent. Walk up the hierarchy of
-	 * both tasks until we find their ancestors who are siblings of common
-	 * parent.
+	 * More easily preempt - nice tasks, while not making it harder for
+	 * + nice tasks.
 	 */
-
-	/* First walk up until both entities are at same depth */
-	se_depth = depth_se(se);
-	pse_depth = depth_se(pse);
-
-	while (se_depth > pse_depth) {
-		se_depth--;
-		se = parent_entity(se);
-	}
-
-	while (pse_depth > se_depth) {
-		pse_depth--;
-		pse = parent_entity(pse);
-	}
-
-	while (!is_same_group(se, pse)) {
-		se = parent_entity(se);
-		pse = parent_entity(pse);
-	}
-
-	gran = sysctl_sched_wakeup_granularity;
-	/*
-	 * More easily preempt - nice tasks, while not making
-	 * it harder for + nice tasks.
-	 */
-	if (unlikely(se->load.weight > NICE_0_LOAD))
-		gran = calc_delta_fair(gran, &se->load);
-
+	gran = calc_delta_asym(sysctl_sched_wakeup_granularity, se);
 	if (pse->vruntime + gran < se->vruntime)
 		resched_task(curr);
 }
@@ -1136,17 +1146,18 @@ static struct task_struct *pick_next_tas
 {
 	struct task_struct *p;
 	struct cfs_rq *cfs_rq = &rq->cfs;
-	struct sched_entity *se;
+	struct sched_entity *se, *next;
 
-	if (unlikely(!cfs_rq->nr_running))
+	if (!first_fair(cfs_rq))
 		return NULL;
 
-	do {
-		se = pick_next_entity(cfs_rq);
-		cfs_rq = group_cfs_rq(se);
-	} while (cfs_rq);
+	next = se = __pick_next_entity(cfs_rq);
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+		set_next_entity(cfs_rq, se);
+	}
 
-	p = task_of(se);
+	p = task_of(next);
 	hrtick_start_fair(rq, p);
 
 	return p;

--


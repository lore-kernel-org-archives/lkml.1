Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbYCIRSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbYCIRSe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbYCIRRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:17:08 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:53533 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbYCIRRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:17:06 -0400
Message-Id: <20080309170928.629757000@chello.nl>
References: <20080309170850.256853000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 09 Mar 2008 18:09:02 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 12/17] sched: fair: cfs_root_rq
Content-Disposition: inline; filename=sched-single-rq-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have a single tree, there is no need to carry this in the
hierarchy. Strip the tree info from cfs_rq and put it in cfs_root_rq.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c       |   38 ++++++++----
 kernel/sched_debug.c |   41 +++++++++----
 kernel/sched_fair.c  |  152 +++++++++++++++++++++++++--------------------------
 3 files changed, 128 insertions(+), 103 deletions(-)

Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -381,17 +381,23 @@ static inline void unlock_doms_cur(void)
 
 #endif	/* CONFIG_GROUP_SCHED */
 
-/* CFS-related fields in a runqueue */
-struct cfs_rq {
-	struct load_weight load;
-	unsigned long nr_running;
-
-	u64 exec_clock;
+struct cfs_root_rq {
 	u64 min_vruntime;
 
 	struct rb_root tasks_timeline;
 	struct rb_node *rb_leftmost;
 
+#ifdef CONFIG_SCHEDSTATS
+	unsigned long nr_spread_over;
+	u64 exec_clock;
+#endif
+};
+
+/* CFS-related fields in a runqueue */
+struct cfs_rq {
+	struct load_weight load;
+	unsigned long nr_running;
+
 	struct list_head tasks;
 	struct list_head *balance_iterator;
 
@@ -401,8 +407,6 @@ struct cfs_rq {
 	 */
 	struct sched_entity *curr;
 
-	unsigned long nr_spread_over;
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */
 
@@ -528,6 +532,7 @@ struct rq {
 	unsigned long nr_load_updates;
 	u64 nr_switches;
 
+	struct cfs_root_rq cfs_root;
 	struct cfs_rq cfs;
 	struct rt_rq rt;
 
@@ -1821,8 +1826,8 @@ void set_task_cpu(struct task_struct *p,
 {
 	int old_cpu = task_cpu(p);
 	struct rq *old_rq = cpu_rq(old_cpu), *new_rq = cpu_rq(new_cpu);
-	struct cfs_rq *old_cfsrq = task_cfs_rq(p),
-		      *new_cfsrq = cpu_cfs_rq(old_cfsrq, new_cpu);
+	struct cfs_root_rq *old_cfs_r_rq = &old_rq->cfs_root,
+			   *new_cfs_r_rq = &new_rq->cfs_root;
 	u64 clock_offset;
 
 	clock_offset = old_rq->clock - new_rq->clock;
@@ -1840,8 +1845,8 @@ void set_task_cpu(struct task_struct *p,
 			schedstat_inc(p, se.nr_forced2_migrations);
 	}
 #endif
-	p->se.vruntime -= old_cfsrq->min_vruntime -
-					 new_cfsrq->min_vruntime;
+	p->se.vruntime -= old_cfs_r_rq->min_vruntime -
+			  new_cfs_r_rq->min_vruntime;
 
 	__set_task_cpu(p, new_cpu);
 }
@@ -7484,14 +7489,18 @@ int in_sched_functions(unsigned long add
 		&& addr < (unsigned long)__sched_text_end);
 }
 
+static void init_cfs_root_rq(struct cfs_root_rq *cfs_r_rq)
+{
+	cfs_r_rq->tasks_timeline = RB_ROOT;
+	cfs_r_rq->min_vruntime = (u64)(-(1LL << 20));
+}
+
 static void init_cfs_rq(struct cfs_rq *cfs_rq, struct rq *rq)
 {
-	cfs_rq->tasks_timeline = RB_ROOT;
 	INIT_LIST_HEAD(&cfs_rq->tasks);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	cfs_rq->rq = rq;
 #endif
-	cfs_rq->min_vruntime = (u64)(-(1LL << 20));
 }
 
 static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
@@ -7617,6 +7626,7 @@ void __init sched_init(void)
 		rq->nr_running = 0;
 		rq->clock = 1;
 		update_last_tick_seen(rq);
+		init_cfs_root_rq(&rq->cfs_root);
 		init_cfs_rq(&rq->cfs, rq);
 		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
Index: linux-2.6-2/kernel/sched_debug.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_debug.c
+++ linux-2.6-2/kernel/sched_debug.c
@@ -101,49 +101,60 @@ static void print_rq(struct seq_file *m,
 	read_unlock_irqrestore(&tasklist_lock, flags);
 }
 
-void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
+void print_cfs_root(struct seq_file *m, int cpu)
 {
 	s64 MIN_vruntime = -1, min_vruntime, max_vruntime = -1,
 		spread, rq0_min_vruntime, spread0;
 	struct rq *rq = &per_cpu(runqueues, cpu);
+	struct cfs_root_rq *cfs_r_rq = &rq->cfs_root;
 	struct sched_entity *last;
 	unsigned long flags;
 
-	SEQ_printf(m, "\ncfs_rq\n");
-
-	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "exec_clock",
-			SPLIT_NS(cfs_rq->exec_clock));
+	SEQ_printf(m, "\ncfs_root_rq\n");
 
 	spin_lock_irqsave(&rq->lock, flags);
-	if (cfs_rq->rb_leftmost)
-		MIN_vruntime = (__pick_next_entity(cfs_rq))->vruntime;
-	last = __pick_last_entity(cfs_rq);
+	if (cfs_r_rq->rb_leftmost)
+		MIN_vruntime = (__pick_next_entity(cfs_r_rq))->vruntime;
+	last = __pick_last_entity(cfs_r_rq);
 	if (last)
 		max_vruntime = last->vruntime;
-	min_vruntime = rq->cfs.min_vruntime;
-	rq0_min_vruntime = per_cpu(runqueues, 0).cfs.min_vruntime;
+	min_vruntime = cfs_r_rq->min_vruntime;
+	rq0_min_vruntime = per_cpu(runqueues, 0).cfs_root.min_vruntime;
 	spin_unlock_irqrestore(&rq->lock, flags);
+
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "MIN_vruntime",
 			SPLIT_NS(MIN_vruntime));
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "min_vruntime",
 			SPLIT_NS(min_vruntime));
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "max_vruntime",
 			SPLIT_NS(max_vruntime));
+
 	spread = max_vruntime - MIN_vruntime;
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "spread",
 			SPLIT_NS(spread));
 	spread0 = min_vruntime - rq0_min_vruntime;
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "spread0",
 			SPLIT_NS(spread0));
+
+#ifdef CONFIG_SCHEDSTATS
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "exec_clock",
+			SPLIT_NS(cfs_r_rq->exec_clock));
+	SEQ_printf(m, "  .%-30s: %ld\n", "nr_spread_over",
+			cfs_r_rq->nr_spread_over);
+#endif
+}
+
+void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
+{
+	SEQ_printf(m, "\ncfs_rq\n");
+
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load^-1", cfs_rq->load.inv_weight);
+
 #ifdef CONFIG_SCHEDSTATS
-	SEQ_printf(m, "  .%-30s: %d\n", "bkl_count",
-			rq->bkl_count);
+	SEQ_printf(m, "  .%-30s: %d\n", "bkl_count", rq_of(cfs_rq)->bkl_count);
 #endif
-	SEQ_printf(m, "  .%-30s: %ld\n", "nr_spread_over",
-			cfs_rq->nr_spread_over);
 }
 
 static void print_cpu(struct seq_file *m, int cpu)
@@ -191,6 +202,8 @@ static void print_cpu(struct seq_file *m
 #undef P
 #undef PN
 
+	print_cfs_root(m, cpu);
+
 	print_cfs_stats(m, cpu);
 
 	print_rq(m, rq, cpu);
Index: linux-2.6-2/kernel/sched_fair.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_fair.c
+++ linux-2.6-2/kernel/sched_fair.c
@@ -218,15 +218,14 @@ static inline u64 min_vruntime(u64 min_v
 	return min_vruntime;
 }
 
-static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static inline
+s64 entity_key(struct cfs_root_rq *cfs_r_rq, struct sched_entity *se)
 {
-	return se->vruntime - cfs_rq->min_vruntime;
+	return se->vruntime - cfs_r_rq->min_vruntime;
 }
 
-/*
- * Enqueue an entity into the rb-tree:
- */
-static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static void __enqueue_timeline(struct cfs_root_rq *cfs_r_rq,
+		struct sched_entity *se)
 {
 	struct rb_node **link;
 	struct rb_node *parent = NULL;
@@ -234,16 +233,8 @@ static void __enqueue_entity(struct cfs_
 	s64 key;
 	int leftmost = 1;
 
-	if (!entity_is_task(se))
-		return;
-
-	if (se == cfs_rq->curr)
-		return;
-
-	cfs_rq = &rq_of(cfs_rq)->cfs;
-
-	link = &cfs_rq->tasks_timeline.rb_node;
-	key = entity_key(cfs_rq, se);
+	link = &cfs_r_rq->tasks_timeline.rb_node;
+	key = entity_key(cfs_r_rq, se);
 	/*
 	 * Find the right place in the rbtree:
 	 */
@@ -254,7 +245,7 @@ static void __enqueue_entity(struct cfs_
 		 * We dont care about collisions. Nodes with
 		 * the same key stay together.
 		 */
-		if (key < entity_key(cfs_rq, entry)) {
+		if (key < entity_key(cfs_r_rq, entry)) {
 			link = &parent->rb_left;
 		} else {
 			link = &parent->rb_right;
@@ -267,46 +258,66 @@ static void __enqueue_entity(struct cfs_
 	 * used):
 	 */
 	if (leftmost)
-		cfs_rq->rb_leftmost = &se->run_node;
+		cfs_r_rq->rb_leftmost = &se->run_node;
 
 	rb_link_node(&se->run_node, parent, link);
-	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
+	rb_insert_color(&se->run_node, &cfs_r_rq->tasks_timeline);
 }
 
-static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static void __dequeue_timeline(struct cfs_root_rq *cfs_r_rq,
+		struct sched_entity *se)
+{
+	if (cfs_r_rq->rb_leftmost == &se->run_node)
+		cfs_r_rq->rb_leftmost = rb_next(&se->run_node);
+
+	rb_erase(&se->run_node, &cfs_r_rq->tasks_timeline);
+}
+
+/*
+ * Enqueue an entity into the rb-tree:
+ */
+static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
+
 	if (!entity_is_task(se))
 		return;
 
 	if (se == cfs_rq->curr)
 		return;
 
-	cfs_rq = &rq_of(cfs_rq)->cfs;
+	__enqueue_timeline(&rq_of(cfs_rq)->cfs_root, se);
+}
 
-	if (cfs_rq->rb_leftmost == &se->run_node)
-		cfs_rq->rb_leftmost = rb_next(&se->run_node);
+static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	if (!entity_is_task(se))
+		return;
 
-	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
+	if (se == cfs_rq->curr)
+		return;
+
+	__dequeue_timeline(&rq_of(cfs_rq)->cfs_root, se);
 }
 
-static inline struct rb_node *first_fair(struct cfs_rq *cfs_rq)
+static inline struct rb_node *first_fair(struct cfs_root_rq *cfs_r_rq)
 {
-	return cfs_rq->rb_leftmost;
+	return cfs_r_rq->rb_leftmost;
 }
 
-static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
+static struct sched_entity *__pick_next_entity(struct cfs_root_rq *cfs_r_rq)
 {
-	return rb_entry(first_fair(cfs_rq), struct sched_entity, run_node);
+	return rb_entry(first_fair(cfs_r_rq), struct sched_entity, run_node);
 }
 
-static inline struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
+static inline
+struct sched_entity *__pick_last_entity(struct cfs_root_rq *cfs_r_rq)
 {
 	struct rb_node *last = rb_last(&cfs_rq->tasks_timeline);
 
 	if (!last)
 		return NULL;
 
-	return rb_entry(last, struct sched_entity, run_node);
+	return rb_entry(last, struct sched_entity, timeline_node);
 }
 
 /**************************************************************
@@ -435,6 +446,25 @@ calc_delta_asym(unsigned long delta, str
 	return delta;
 }
 
+static inline
+void __update_root(struct cfs_root_rq *cfs_r_rq, struct sched_entity *curr)
+{
+	u64 vruntime;
+
+	/*
+	 * maintain cfs_r_rq->min_vruntime to be a monotonic increasing
+	 * value tracking the leftmost vruntime in the tree.
+	 */
+	if (first_fair(cfs_r_rq)) {
+		vruntime = min_vruntime(curr->vruntime,
+				__pick_next_entity(cfs_r_rq)->vruntime);
+	} else
+		vruntime = curr->vruntime;
+
+	cfs_r_rq->min_vruntime =
+		max_vruntime(cfs_r_rq->min_vruntime, vruntime);
+}
+
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
@@ -443,33 +473,11 @@ static inline void
 __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 	      unsigned long delta_exec)
 {
-	unsigned long delta_exec_weighted;
-	u64 vruntime;
-
 	schedstat_set(curr->exec_max, max((u64)delta_exec, curr->exec_max));
 
 	curr->sum_exec_runtime += delta_exec;
-	schedstat_add(cfs_rq, exec_clock, delta_exec);
-	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
-	curr->vruntime += delta_exec_weighted;
-
-	if (!entity_is_task(curr))
-		return;
-
-	cfs_rq = &rq_of(cfs_rq)->cfs;
-
-	/*
-	 * maintain cfs_rq->min_vruntime to be a monotonic increasing
-	 * value tracking the leftmost vruntime in the tree.
-	 */
-	if (first_fair(cfs_rq)) {
-		vruntime = min_vruntime(curr->vruntime,
-				__pick_next_entity(cfs_rq)->vruntime);
-	} else
-		vruntime = curr->vruntime;
-
-	cfs_rq->min_vruntime =
-		max_vruntime(cfs_rq->min_vruntime, vruntime);
+	schedstat_add(&rq_of(cfs_rq)->cfs_root, exec_clock, delta_exec);
+	curr->vruntime += calc_delta_fair(delta_exec, curr);
 }
 
 static void update_curr(struct cfs_rq *cfs_rq)
@@ -492,9 +500,8 @@ static void update_curr(struct cfs_rq *c
 	curr->exec_start = now;
 
 	if (entity_is_task(curr)) {
-		struct task_struct *curtask = task_of(curr);
-
-		cpuacct_charge(curtask, delta_exec);
+		__update_root(&rq_of(cfs_rq)->cfs_root, curr);
+		cpuacct_charge(task_of(curr), delta_exec);
 	}
 }
 
@@ -622,27 +629,27 @@ static void enqueue_sleeper(struct cfs_r
 static void check_spread(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 #ifdef CONFIG_SCHED_DEBUG
-	s64 d = se->vruntime - cfs_rq->min_vruntime;
+	struct cfs_root_rq *cfs_r_rq = &rq_of(cfs_rq)->cfs_root;
+	s64 d = se->vruntime - cfs_r_rq->min_vruntime;
 
 	if (d < 0)
 		d = -d;
 
 	if (d > 3*sysctl_sched_latency)
-		schedstat_inc(cfs_rq, nr_spread_over);
+		schedstat_inc(cfs_r_rq, nr_spread_over);
 #endif
 }
 
 static void
 place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 {
+	struct cfs_root_rq *cfs_r_rq = &rq_of(cfs_rq)->cfs_root;
 	u64 vruntime;
 
 	if (!entity_is_task(se))
 		return;
 
-	cfs_rq = &rq_of(cfs_rq)->cfs;
-
-	vruntime = cfs_rq->min_vruntime;
+	vruntime = cfs_r_rq->min_vruntime;
 
 	/*
 	 * The 'current' period is already promised to the current tasks,
@@ -933,7 +940,7 @@ static void yield_task_fair(struct rq *r
 	/*
 	 * Find the rightmost entry in the rbtree:
 	 */
-	rightmost = __pick_last_entity(&rq->cfs);
+	rightmost = __pick_last_entity(&rq->cfs_root);
 	/*
 	 * Already in the rightmost position?
 	 */
@@ -1133,17 +1140,15 @@ static void check_preempt_wakeup(struct 
 static struct task_struct *pick_next_task_fair(struct rq *rq)
 {
 	struct task_struct *p;
-	struct cfs_rq *cfs_rq = &rq->cfs;
+	struct cfs_root_rq *cfs_r_rq = &rq->cfs_root;
 	struct sched_entity *se, *next;
 
-	if (!first_fair(cfs_rq))
+	if (!first_fair(cfs_r_rq))
 		return NULL;
 
-	next = se = __pick_next_entity(cfs_rq);
-	for_each_sched_entity(se) {
-		cfs_rq = cfs_rq_of(se);
-		set_next_entity(cfs_rq, se);
-	}
+	next = se = __pick_next_entity(cfs_r_rq);
+	for_each_sched_entity(se)
+		set_next_entity(cfs_rq_of(se), se);
 
 	p = task_of(next);
 	hrtick_start_fair(rq, p);
@@ -1157,12 +1162,9 @@ static struct task_struct *pick_next_tas
 static void put_prev_task_fair(struct rq *rq, struct task_struct *prev)
 {
 	struct sched_entity *se = &prev->se;
-	struct cfs_rq *cfs_rq;
 
-	for_each_sched_entity(se) {
-		cfs_rq = cfs_rq_of(se);
-		put_prev_entity(cfs_rq, se);
-	}
+	for_each_sched_entity(se)
+		put_prev_entity(cfs_rq_of(se), se);
 }
 
 #ifdef CONFIG_SMP

--


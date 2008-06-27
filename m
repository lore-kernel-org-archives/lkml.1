Return-Path: <linux-kernel-owner+w=401wt.eu-S1760612AbYF0MGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612AbYF0MGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757218AbYF0L6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:22 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:60135 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777AbYF0L6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:58:07 -0400
Message-Id: <20080627115211.205321397@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:14 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 05/30] sched: revert revert of: fair-group: SMP-nice for group scheduling
Content-Disposition: inline; filename=sched-revert-revert-smp-group-balancer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try again..

Initial commit: 18d95a2832c1392a2d63227a7a6d433cb9f2037e
Revert: 6363ca57c76b7b83639ca8c83fc285fa26a7880e

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
---
 include/linux/sched.h |    1 
 kernel/sched.c        |  430 ++++++++++++++++++++++++++++++++++++++++++++++----
 kernel/sched_debug.c  |    5 
 kernel/sched_fair.c   |  124 +++++++++-----
 kernel/sched_rt.c     |    4 
 5 files changed, 489 insertions(+), 75 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -765,6 +765,7 @@ struct sched_domain {
 	struct sched_domain *child;	/* bottom domain must be null terminated */
 	struct sched_group *groups;	/* the balancing groups of the domain */
 	cpumask_t span;			/* span of all CPUs in this domain */
+	int first_cpu;			/* cache of the first cpu in this domain */
 	unsigned long min_interval;	/* Minimum balance interval ms */
 	unsigned long max_interval;	/* Maximum balance interval ms */
 	unsigned int busy_factor;	/* less balancing by factor if busy */
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -403,6 +403,43 @@ struct cfs_rq {
 	 */
 	struct list_head leaf_cfs_rq_list;
 	struct task_group *tg;	/* group that "owns" this runqueue */
+
+#ifdef CONFIG_SMP
+	unsigned long task_weight;
+	unsigned long shares;
+	/*
+	 * We need space to build a sched_domain wide view of the full task
+	 * group tree, in order to avoid depending on dynamic memory allocation
+	 * during the load balancing we place this in the per cpu task group
+	 * hierarchy. This limits the load balancing to one instance per cpu,
+	 * but more should not be needed anyway.
+	 */
+	struct aggregate_struct {
+		/*
+		 *   load = weight(cpus) * f(tg)
+		 *
+		 * Where f(tg) is the recursive weight fraction assigned to
+		 * this group.
+		 */
+		unsigned long load;
+
+		/*
+		 * part of the group weight distributed to this span.
+		 */
+		unsigned long shares;
+
+		/*
+		 * The sum of all runqueue weights within this span.
+		 */
+		unsigned long rq_weight;
+
+		/*
+		 * Weight contributed by tasks; this is the part we can
+		 * influence by moving tasks around.
+		 */
+		unsigned long task_weight;
+	} aggregate;
+#endif
 #endif
 };
 
@@ -1484,6 +1521,326 @@ static unsigned long source_load(int cpu
 static unsigned long target_load(int cpu, int type);
 static unsigned long cpu_avg_load_per_task(int cpu);
 static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+
+/*
+ * Group load balancing.
+ *
+ * We calculate a few balance domain wide aggregate numbers; load and weight.
+ * Given the pictures below, and assuming each item has equal weight:
+ *
+ *         root          1 - thread
+ *         / | \         A - group
+ *        A  1  B
+ *       /|\   / \
+ *      C 2 D 3   4
+ *      |   |
+ *      5   6
+ *
+ * load:
+ *    A and B get 1/3-rd of the total load. C and D get 1/3-rd of A's 1/3-rd,
+ *    which equals 1/9-th of the total load.
+ *
+ * shares:
+ *    The weight of this group on the selected cpus.
+ *
+ * rq_weight:
+ *    Direct sum of all the cpu's their rq weight, e.g. A would get 3 while
+ *    B would get 2.
+ *
+ * task_weight:
+ *    Part of the rq_weight contributed by tasks; all groups except B would
+ *    get 1, B gets 2.
+ */
+
+static inline struct aggregate_struct *
+aggregate(struct task_group *tg, struct sched_domain *sd)
+{
+	return &tg->cfs_rq[sd->first_cpu]->aggregate;
+}
+
+typedef void (*aggregate_func)(struct task_group *, struct sched_domain *);
+
+/*
+ * Iterate the full tree, calling @down when first entering a node and @up when
+ * leaving it for the final time.
+ */
+static
+void aggregate_walk_tree(aggregate_func down, aggregate_func up,
+			 struct sched_domain *sd)
+{
+	struct task_group *parent, *child;
+
+	rcu_read_lock();
+	parent = &root_task_group;
+down:
+	(*down)(parent, sd);
+	list_for_each_entry_rcu(child, &parent->children, siblings) {
+		parent = child;
+		goto down;
+
+up:
+		continue;
+	}
+	(*up)(parent, sd);
+
+	child = parent;
+	parent = parent->parent;
+	if (parent)
+		goto up;
+	rcu_read_unlock();
+}
+
+/*
+ * Calculate the aggregate runqueue weight.
+ */
+static
+void aggregate_group_weight(struct task_group *tg, struct sched_domain *sd)
+{
+	unsigned long rq_weight = 0;
+	unsigned long task_weight = 0;
+	int i;
+
+	for_each_cpu_mask(i, sd->span) {
+		rq_weight += tg->cfs_rq[i]->load.weight;
+		task_weight += tg->cfs_rq[i]->task_weight;
+	}
+
+	aggregate(tg, sd)->rq_weight = rq_weight;
+	aggregate(tg, sd)->task_weight = task_weight;
+}
+
+/*
+ * Compute the weight of this group on the given cpus.
+ */
+static
+void aggregate_group_shares(struct task_group *tg, struct sched_domain *sd)
+{
+	unsigned long shares = 0;
+	int i;
+
+	for_each_cpu_mask(i, sd->span)
+		shares += tg->cfs_rq[i]->shares;
+
+	if ((!shares && aggregate(tg, sd)->rq_weight) || shares > tg->shares)
+		shares = tg->shares;
+
+	aggregate(tg, sd)->shares = shares;
+}
+
+/*
+ * Compute the load fraction assigned to this group, relies on the aggregate
+ * weight and this group's parent's load, i.e. top-down.
+ */
+static
+void aggregate_group_load(struct task_group *tg, struct sched_domain *sd)
+{
+	unsigned long load;
+
+	if (!tg->parent) {
+		int i;
+
+		load = 0;
+		for_each_cpu_mask(i, sd->span)
+			load += cpu_rq(i)->load.weight;
+
+	} else {
+		load = aggregate(tg->parent, sd)->load;
+
+		/*
+		 * shares is our weight in the parent's rq so
+		 * shares/parent->rq_weight gives our fraction of the load
+		 */
+		load *= aggregate(tg, sd)->shares;
+		load /= aggregate(tg->parent, sd)->rq_weight + 1;
+	}
+
+	aggregate(tg, sd)->load = load;
+}
+
+static void __set_se_shares(struct sched_entity *se, unsigned long shares);
+
+/*
+ * Calculate and set the cpu's group shares.
+ */
+static void
+__update_group_shares_cpu(struct task_group *tg, struct sched_domain *sd,
+			  int tcpu)
+{
+	int boost = 0;
+	unsigned long shares;
+	unsigned long rq_weight;
+
+	if (!tg->se[tcpu])
+		return;
+
+	rq_weight = tg->cfs_rq[tcpu]->load.weight;
+
+	/*
+	 * If there are currently no tasks on the cpu pretend there is one of
+	 * average load so that when a new task gets to run here it will not
+	 * get delayed by group starvation.
+	 */
+	if (!rq_weight) {
+		boost = 1;
+		rq_weight = NICE_0_LOAD;
+	}
+
+	/*
+	 *           \Sum shares * rq_weight
+	 * shares =  -----------------------
+	 *               \Sum rq_weight
+	 *
+	 */
+	shares = aggregate(tg, sd)->shares * rq_weight;
+	shares /= aggregate(tg, sd)->rq_weight + 1;
+
+	/*
+	 * record the actual number of shares, not the boosted amount.
+	 */
+	tg->cfs_rq[tcpu]->shares = boost ? 0 : shares;
+
+	if (shares < MIN_SHARES)
+		shares = MIN_SHARES;
+	else if (shares > MAX_SHARES)
+		shares = MAX_SHARES;
+
+	__set_se_shares(tg->se[tcpu], shares);
+}
+
+/*
+ * Re-adjust the weights on the cpu the task came from and on the cpu the
+ * task went to.
+ */
+static void
+__move_group_shares(struct task_group *tg, struct sched_domain *sd,
+		    int scpu, int dcpu)
+{
+	unsigned long shares;
+
+	shares = tg->cfs_rq[scpu]->shares + tg->cfs_rq[dcpu]->shares;
+
+	__update_group_shares_cpu(tg, sd, scpu);
+	__update_group_shares_cpu(tg, sd, dcpu);
+
+	/*
+	 * ensure we never loose shares due to rounding errors in the
+	 * above redistribution.
+	 */
+	shares -= tg->cfs_rq[scpu]->shares + tg->cfs_rq[dcpu]->shares;
+	if (shares)
+		tg->cfs_rq[dcpu]->shares += shares;
+}
+
+/*
+ * Because changing a group's shares changes the weight of the super-group
+ * we need to walk up the tree and change all shares until we hit the root.
+ */
+static void
+move_group_shares(struct task_group *tg, struct sched_domain *sd,
+		  int scpu, int dcpu)
+{
+	while (tg) {
+		__move_group_shares(tg, sd, scpu, dcpu);
+		tg = tg->parent;
+	}
+}
+
+static
+void aggregate_group_set_shares(struct task_group *tg, struct sched_domain *sd)
+{
+	unsigned long shares = aggregate(tg, sd)->shares;
+	int i;
+
+	for_each_cpu_mask(i, sd->span) {
+		struct rq *rq = cpu_rq(i);
+		unsigned long flags;
+
+		spin_lock_irqsave(&rq->lock, flags);
+		__update_group_shares_cpu(tg, sd, i);
+		spin_unlock_irqrestore(&rq->lock, flags);
+	}
+
+	aggregate_group_shares(tg, sd);
+
+	/*
+	 * ensure we never loose shares due to rounding errors in the
+	 * above redistribution.
+	 */
+	shares -= aggregate(tg, sd)->shares;
+	if (shares) {
+		tg->cfs_rq[sd->first_cpu]->shares += shares;
+		aggregate(tg, sd)->shares += shares;
+	}
+}
+
+/*
+ * Calculate the accumulative weight and recursive load of each task group
+ * while walking down the tree.
+ */
+static
+void aggregate_get_down(struct task_group *tg, struct sched_domain *sd)
+{
+	aggregate_group_weight(tg, sd);
+	aggregate_group_shares(tg, sd);
+	aggregate_group_load(tg, sd);
+}
+
+/*
+ * Rebalance the cpu shares while walking back up the tree.
+ */
+static
+void aggregate_get_up(struct task_group *tg, struct sched_domain *sd)
+{
+	aggregate_group_set_shares(tg, sd);
+}
+
+static DEFINE_PER_CPU(spinlock_t, aggregate_lock);
+
+static void __init init_aggregate(void)
+{
+	int i;
+
+	for_each_possible_cpu(i)
+		spin_lock_init(&per_cpu(aggregate_lock, i));
+}
+
+static int get_aggregate(struct sched_domain *sd)
+{
+	if (!spin_trylock(&per_cpu(aggregate_lock, sd->first_cpu)))
+		return 0;
+
+	aggregate_walk_tree(aggregate_get_down, aggregate_get_up, sd);
+	return 1;
+}
+
+static void put_aggregate(struct sched_domain *sd)
+{
+	spin_unlock(&per_cpu(aggregate_lock, sd->first_cpu));
+}
+
+static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
+{
+	cfs_rq->shares = shares;
+}
+
+#else
+
+static inline void init_aggregate(void)
+{
+}
+
+static inline int get_aggregate(struct sched_domain *sd)
+{
+	return 0;
+}
+
+static inline void put_aggregate(struct sched_domain *sd)
+{
+}
+#endif
+
 #endif
 
 #include "sched_stats.h"
@@ -1498,26 +1855,14 @@ static int task_hot(struct task_struct *
 #define for_each_class(class) \
    for (class = sched_class_highest; class; class = class->next)
 
-static inline void inc_load(struct rq *rq, const struct task_struct *p)
-{
-	update_load_add(&rq->load, p->se.load.weight);
-}
-
-static inline void dec_load(struct rq *rq, const struct task_struct *p)
-{
-	update_load_sub(&rq->load, p->se.load.weight);
-}
-
-static void inc_nr_running(struct task_struct *p, struct rq *rq)
+static void inc_nr_running(struct rq *rq)
 {
 	rq->nr_running++;
-	inc_load(rq, p);
 }
 
-static void dec_nr_running(struct task_struct *p, struct rq *rq)
+static void dec_nr_running(struct rq *rq)
 {
 	rq->nr_running--;
-	dec_load(rq, p);
 }
 
 static void set_load_weight(struct task_struct *p)
@@ -1609,7 +1954,7 @@ static void activate_task(struct rq *rq,
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, wakeup);
-	inc_nr_running(p, rq);
+	inc_nr_running(rq);
 }
 
 /*
@@ -1621,7 +1966,7 @@ static void deactivate_task(struct rq *r
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, sleep);
-	dec_nr_running(p, rq);
+	dec_nr_running(rq);
 }
 
 /**
@@ -2274,7 +2619,7 @@ void wake_up_new_task(struct task_struct
 		 * management (if any):
 		 */
 		p->sched_class->task_new(rq, p);
-		inc_nr_running(p, rq);
+		inc_nr_running(rq);
 	}
 	check_preempt_curr(rq, p);
 #ifdef CONFIG_SMP
@@ -3265,9 +3610,12 @@ static int load_balance(int this_cpu, st
 	unsigned long imbalance;
 	struct rq *busiest;
 	unsigned long flags;
+	int unlock_aggregate;
 
 	cpus_setall(*cpus);
 
+	unlock_aggregate = get_aggregate(sd);
+
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
 	 * sibling can pick up load irrespective of busy siblings. In this case,
@@ -3383,8 +3731,9 @@ redo:
 
 	if (!ld_moved && !sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
 	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		return -1;
-	return ld_moved;
+		ld_moved = -1;
+
+	goto out;
 
 out_balanced:
 	schedstat_inc(sd, lb_balanced[idle]);
@@ -3399,8 +3748,13 @@ out_one_pinned:
 
 	if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
 	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		return -1;
-	return 0;
+		ld_moved = -1;
+	else
+		ld_moved = 0;
+out:
+	if (unlock_aggregate)
+		put_aggregate(sd);
+	return ld_moved;
 }
 
 /*
@@ -4588,10 +4942,8 @@ void set_user_nice(struct task_struct *p
 		goto out_unlock;
 	}
 	on_rq = p->se.on_rq;
-	if (on_rq) {
+	if (on_rq)
 		dequeue_task(rq, p, 0);
-		dec_load(rq, p);
-	}
 
 	p->static_prio = NICE_TO_PRIO(nice);
 	set_load_weight(p);
@@ -4601,7 +4953,6 @@ void set_user_nice(struct task_struct *p
 
 	if (on_rq) {
 		enqueue_task(rq, p, 0);
-		inc_load(rq, p);
 		/*
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
@@ -7040,6 +7391,7 @@ static int __build_sched_domains(const c
 			SD_INIT(sd, ALLNODES);
 			set_domain_attribute(sd, attr);
 			sd->span = *cpu_map;
+			sd->first_cpu = first_cpu(sd->span);
 			cpu_to_allnodes_group(i, cpu_map, &sd->groups, tmpmask);
 			p = sd;
 			sd_allnodes = 1;
@@ -7050,6 +7402,7 @@ static int __build_sched_domains(const c
 		SD_INIT(sd, NODE);
 		set_domain_attribute(sd, attr);
 		sched_domain_node_span(cpu_to_node(i), &sd->span);
+		sd->first_cpu = first_cpu(sd->span);
 		sd->parent = p;
 		if (p)
 			p->child = sd;
@@ -7061,6 +7414,7 @@ static int __build_sched_domains(const c
 		SD_INIT(sd, CPU);
 		set_domain_attribute(sd, attr);
 		sd->span = *nodemask;
+		sd->first_cpu = first_cpu(sd->span);
 		sd->parent = p;
 		if (p)
 			p->child = sd;
@@ -7072,6 +7426,7 @@ static int __build_sched_domains(const c
 		SD_INIT(sd, MC);
 		set_domain_attribute(sd, attr);
 		sd->span = cpu_coregroup_map(i);
+		sd->first_cpu = first_cpu(sd->span);
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
@@ -7084,6 +7439,7 @@ static int __build_sched_domains(const c
 		SD_INIT(sd, SIBLING);
 		set_domain_attribute(sd, attr);
 		sd->span = per_cpu(cpu_sibling_map, i);
+		sd->first_cpu = first_cpu(sd->span);
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
@@ -7781,6 +8137,7 @@ void __init sched_init(void)
 	}
 
 #ifdef CONFIG_SMP
+	init_aggregate();
 	init_defrootdomain();
 #endif
 
@@ -8346,14 +8703,11 @@ void sched_move_task(struct task_struct 
 #endif /* CONFIG_GROUP_SCHED */
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static void set_se_shares(struct sched_entity *se, unsigned long shares)
+static void __set_se_shares(struct sched_entity *se, unsigned long shares)
 {
 	struct cfs_rq *cfs_rq = se->cfs_rq;
-	struct rq *rq = cfs_rq->rq;
 	int on_rq;
 
-	spin_lock_irq(&rq->lock);
-
 	on_rq = se->on_rq;
 	if (on_rq)
 		dequeue_entity(cfs_rq, se, 0);
@@ -8363,8 +8717,17 @@ static void set_se_shares(struct sched_e
 
 	if (on_rq)
 		enqueue_entity(cfs_rq, se, 0);
+}
 
-	spin_unlock_irq(&rq->lock);
+static void set_se_shares(struct sched_entity *se, unsigned long shares)
+{
+	struct cfs_rq *cfs_rq = se->cfs_rq;
+	struct rq *rq = cfs_rq->rq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rq->lock, flags);
+	__set_se_shares(se, shares);
+	spin_unlock_irqrestore(&rq->lock, flags);
 }
 
 static DEFINE_MUTEX(shares_mutex);
@@ -8403,8 +8766,13 @@ int sched_group_set_shares(struct task_g
 	 * w/o tripping rebalance_share or load_balance_fair.
 	 */
 	tg->shares = shares;
-	for_each_possible_cpu(i)
+	for_each_possible_cpu(i) {
+		/*
+		 * force a rebalance
+		 */
+		cfs_rq_set_shares(tg->cfs_rq[i], 0);
 		set_se_shares(tg->se[i], shares);
+	}
 
 	/*
 	 * Enable load balance activity on this group, by inserting it back on
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -167,6 +167,11 @@ void print_cfs_rq(struct seq_file *m, in
 #endif
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_spread_over",
 			cfs_rq->nr_spread_over);
+#ifdef CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_SMP
+	SEQ_printf(m, "  .%-30s: %lu\n", "shares", cfs_rq->shares);
+#endif
+#endif
 }
 
 void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -567,10 +567,27 @@ update_stats_curr_start(struct cfs_rq *c
  * Scheduling class queueing methods:
  */
 
+#if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
+static void
+add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long weight)
+{
+	cfs_rq->task_weight += weight;
+}
+#else
+static inline void
+add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long weight)
+{
+}
+#endif
+
 static void
 account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	update_load_add(&cfs_rq->load, se->load.weight);
+	if (!parent_entity(se))
+		inc_cpu_load(rq_of(cfs_rq), se->load.weight);
+	if (entity_is_task(se))
+		add_cfs_task_weight(cfs_rq, se->load.weight);
 	cfs_rq->nr_running++;
 	se->on_rq = 1;
 	list_add(&se->group_node, &cfs_rq->tasks);
@@ -580,6 +597,10 @@ static void
 account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	update_load_sub(&cfs_rq->load, se->load.weight);
+	if (!parent_entity(se))
+		dec_cpu_load(rq_of(cfs_rq), se->load.weight);
+	if (entity_is_task(se))
+		add_cfs_task_weight(cfs_rq, -se->load.weight);
 	cfs_rq->nr_running--;
 	se->on_rq = 0;
 	list_del_init(&se->group_node);
@@ -1372,75 +1393,90 @@ static struct task_struct *load_balance_
 	return __load_balance_iterator(cfs_rq, cfs_rq->balance_iterator);
 }
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-static int cfs_rq_best_prio(struct cfs_rq *cfs_rq)
+static unsigned long
+__load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		unsigned long max_load_move, struct sched_domain *sd,
+		enum cpu_idle_type idle, int *all_pinned, int *this_best_prio,
+		struct cfs_rq *cfs_rq)
 {
-	struct sched_entity *curr;
-	struct task_struct *p;
-
-	if (!cfs_rq->nr_running || !first_fair(cfs_rq))
-		return MAX_PRIO;
-
-	curr = cfs_rq->curr;
-	if (!curr)
-		curr = __pick_next_entity(cfs_rq);
+	struct rq_iterator cfs_rq_iterator;
 
-	p = task_of(curr);
+	cfs_rq_iterator.start = load_balance_start_fair;
+	cfs_rq_iterator.next = load_balance_next_fair;
+	cfs_rq_iterator.arg = cfs_rq;
 
-	return p->prio;
+	return balance_tasks(this_rq, this_cpu, busiest,
+			max_load_move, sd, idle, all_pinned,
+			this_best_prio, &cfs_rq_iterator);
 }
-#endif
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
 		  int *all_pinned, int *this_best_prio)
 {
-	struct cfs_rq *busy_cfs_rq;
 	long rem_load_move = max_load_move;
-	struct rq_iterator cfs_rq_iterator;
-
-	cfs_rq_iterator.start = load_balance_start_fair;
-	cfs_rq_iterator.next = load_balance_next_fair;
+	int busiest_cpu = cpu_of(busiest);
+	struct task_group *tg;
 
-	for_each_leaf_cfs_rq(busiest, busy_cfs_rq) {
-#ifdef CONFIG_FAIR_GROUP_SCHED
-		struct cfs_rq *this_cfs_rq;
+	rcu_read_lock();
+	list_for_each_entry(tg, &task_groups, list) {
 		long imbalance;
-		unsigned long maxload;
+		unsigned long this_weight, busiest_weight;
+		long rem_load, max_load, moved_load;
+
+		/*
+		 * empty group
+		 */
+		if (!aggregate(tg, sd)->task_weight)
+			continue;
+
+		rem_load = rem_load_move * aggregate(tg, sd)->rq_weight;
+		rem_load /= aggregate(tg, sd)->load + 1;
+
+		this_weight = tg->cfs_rq[this_cpu]->task_weight;
+		busiest_weight = tg->cfs_rq[busiest_cpu]->task_weight;
 
-		this_cfs_rq = cpu_cfs_rq(busy_cfs_rq, this_cpu);
+		imbalance = (busiest_weight - this_weight) / 2;
 
-		imbalance = busy_cfs_rq->load.weight - this_cfs_rq->load.weight;
-		/* Don't pull if this_cfs_rq has more load than busy_cfs_rq */
-		if (imbalance <= 0)
+		if (imbalance < 0)
+			imbalance = busiest_weight;
+
+		max_load = max(rem_load, imbalance);
+		moved_load = __load_balance_fair(this_rq, this_cpu, busiest,
+				max_load, sd, idle, all_pinned, this_best_prio,
+				tg->cfs_rq[busiest_cpu]);
+
+		if (!moved_load)
 			continue;
 
-		/* Don't pull more than imbalance/2 */
-		imbalance /= 2;
-		maxload = min(rem_load_move, imbalance);
+		move_group_shares(tg, sd, busiest_cpu, this_cpu);
 
-		*this_best_prio = cfs_rq_best_prio(this_cfs_rq);
-#else
-# define maxload rem_load_move
-#endif
-		/*
-		 * pass busy_cfs_rq argument into
-		 * load_balance_[start|next]_fair iterators
-		 */
-		cfs_rq_iterator.arg = busy_cfs_rq;
-		rem_load_move -= balance_tasks(this_rq, this_cpu, busiest,
-					       maxload, sd, idle, all_pinned,
-					       this_best_prio,
-					       &cfs_rq_iterator);
+		moved_load *= aggregate(tg, sd)->load;
+		moved_load /= aggregate(tg, sd)->rq_weight + 1;
 
-		if (rem_load_move <= 0)
+		rem_load_move -= moved_load;
+		if (rem_load_move < 0)
 			break;
 	}
+	rcu_read_unlock();
 
 	return max_load_move - rem_load_move;
 }
+#else
+static unsigned long
+load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		  unsigned long max_load_move,
+		  struct sched_domain *sd, enum cpu_idle_type idle,
+		  int *all_pinned, int *this_best_prio)
+{
+	return __load_balance_fair(this_rq, this_cpu, busiest,
+			max_load_move, sd, idle, all_pinned,
+			this_best_prio, &busiest->cfs);
+}
+#endif
 
 static int
 move_one_task_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -671,6 +671,8 @@ static void enqueue_task_rt(struct rq *r
 		rt_se->timeout = 0;
 
 	enqueue_rt_entity(rt_se);
+
+	inc_cpu_load(rq, p->se.load.weight);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
@@ -679,6 +681,8 @@ static void dequeue_task_rt(struct rq *r
 
 	update_curr_rt(rq);
 	dequeue_rt_entity(rt_se);
+
+	dec_cpu_load(rq, p->se.load.weight);
 }
 
 /*

-- 


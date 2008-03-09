Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578AbYCIRKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbYCIRKp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYCIRJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:09:21 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:52814 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbYCIRJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:09:17 -0400
Message-Id: <20080309170926.700195000@chello.nl>
References: <20080309170850.256853000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 09 Mar 2008 18:08:54 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Abhishek Chandra <chandra@cs.umn.edu>
Subject: [RFC/PATCH 04/17] sched: fair-group: SMP-nice for group scheduling
Content-Disposition: inline; filename=sched-fair-group-load-balance.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement SMP nice support for the full group hierarchy.

On each load-balance action, compile a sched_domain wide view of the full
task_group tree. We compute the domain wide RQ weight and RQ load when
walking down the hierarchy, and readjust the weights when walking back up.

After collecting and readjusting the domain wide view, we try to balance the
tasks within the task_groups. The current approach is a naive search for the
group which has the biggest load imbalance - assuming a few group rebalances
will sufice to balance out the cpus.

If all else fails, we try to balance the cpus by evacuating whole groups away
from the cpu.

Inspired by Srivatsa Vaddsgiri's previous code and Abhishek Chandra's H-SMP
paper.

XXX: there will be some numerical issues due to the limited nature of 
     SCHED_LOAD_SCALE wrt to representing a task_groups invluence on the
     total weight. When the tree is deep enough, or the task weight small
     enough, we'll run out of bits.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Abhishek Chandra <chandra@cs.umn.edu>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
---
 kernel/sched.c      |  317 +++++++++++++++++++++++++++++++++++++++++++++++-----
 kernel/sched_fair.c |  179 +++++++++++++++++++++--------
 kernel/sched_rt.c   |    4 
 3 files changed, 424 insertions(+), 76 deletions(-)

Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -270,6 +270,9 @@ struct task_group {
 
 	struct rcu_head rcu;
 	struct list_head list;
+	struct task_group *parent;
+	struct list_head siblings;
+	struct list_head children;
 };
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -326,6 +329,8 @@ struct task_group init_task_group = {
 	.rt_se	= init_sched_rt_entity_p,
 	.rt_rq	= init_rt_rq_p,
 #endif
+
+	.children = LIST_HEAD_INIT(init_task_group.children),
 };
 
 /* return group to which a task belongs */
@@ -407,6 +412,30 @@ struct cfs_rq {
 	 */
 	struct list_head leaf_cfs_rq_list;
 	struct task_group *tg;	/* group that "owns" this runqueue */
+
+#ifdef CONFIG_SMP
+	/*
+	 * We need space to build a sched_domain wide view of the full task
+	 * group tree, in order to avoid depending on dynamic memory allocation
+	 * during the load balancing we place this in the per cpu task group
+	 * hierarchy. This limits the load balancing to one instance per cpu,
+	 * but more should not be needed anyway.
+	 */
+	struct aggregate_struct {
+		/*
+		 *   load = weight(cpus) * SCHED_LOAD_SCALE * f(tg)
+		 *
+		 * Where f(tg) is the recursive weight fraction assigned to
+		 * this group.
+		 */
+		unsigned long load;
+
+		/*
+		 * The sum of all runqueue weights within this sched_domain.
+		 */
+		unsigned long weight;
+	} aggregate;
+#endif
 #endif
 };
 
@@ -1360,11 +1389,240 @@ static void cpuacct_charge(struct task_s
 static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
 #endif
 
+static inline void inc_cpu_load(struct rq *rq, unsigned long load)
+{
+	update_load_add(&rq->load, load);
+}
+
+static inline void dec_cpu_load(struct rq *rq, unsigned long load)
+{
+	update_load_sub(&rq->load, load);
+}
+
 #ifdef CONFIG_SMP
 static unsigned long source_load(int cpu, int type);
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
+ * weight:
+ *    Direct sum of all the cpu's their rq weight, e.g. A would get 3 while
+ *    B would get 2.
+ *
+ */
+
+static inline
+struct aggregate_struct *aggregate(struct task_group *tg, int cpu)
+{
+	return &tg->cfs_rq[cpu]->aggregate;
+}
+
+typedef void (*aggregate_func)(struct task_group *, int, cpumask_t);
+
+/*
+ * Iterate the full tree, calling @down when first entering a node and @up when
+ * leaving it for the final time.
+ */
+static
+void aggregate_walk_tree(aggregate_func down, aggregate_func up,
+			 int cpu, cpumask_t mask)
+{
+	struct task_group *parent, *child;
+
+	rcu_read_lock();
+	parent = &init_task_group;
+down:
+	(*down)(parent, cpu, mask);
+	list_for_each_entry_rcu(child, &parent->children, siblings) {
+		parent = child;
+		goto down;
+
+up:
+		continue;
+	}
+	(*up)(parent, cpu, mask);
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
+void aggregate_group_weight(struct task_group *tg, int cpu, cpumask_t mask)
+{
+	int i;
+	unsigned long weight = 0;
+
+	for_each_cpu_mask(i, mask)
+		weight += tg->cfs_rq[i]->load.weight;
+
+	aggregate(tg, cpu)->weight = weight;
+}
+
+/*
+ * Compute the load fraction assigned to this group, relies on the aggregate
+ * weight and this group's parent's load, i.e. top-down.
+ */
+static
+void aggregate_group_load(struct task_group *tg, int cpu, cpumask_t mask)
+{
+	unsigned long weight = cpus_weight(mask);
+	unsigned long load;
+
+	if (!tg->parent) {
+		load = SCHED_LOAD_SCALE * weight;
+	} else {
+		load = aggregate(tg->parent, cpu)->load;
+		load *= tg->shares * weight;
+		load /= aggregate(tg->parent, cpu)->weight;
+	}
+
+	aggregate(tg, cpu)->load = load;
+}
+
+static void set_se_shares(struct sched_entity *se, unsigned long shares);
+
+/*
+ * Calculate and set the cpu's group shares.
+ */
+static void __update_group_shares_cpu(struct task_group *tg, int acpu,
+		int tcpu, unsigned long weight)
+{
+	unsigned long local_shares;
+	unsigned long local_weight;
+	unsigned long total_shares;
+
+	if (!tg->se[tcpu])
+		return;
+
+	if (!aggregate(tg, acpu)->weight)
+		return;
+
+	total_shares = weight * tg->shares;
+	local_weight = tg->cfs_rq[tcpu]->load.weight;
+
+	/*
+	 * If there are currently no tasks on the cpu pretend there is one of
+	 * average load so that when a new task gets to run here it will not
+	 * get delayed by group starvation.
+	 */
+	if (!local_weight)
+		local_weight = NICE_0_LOAD;
+
+	local_shares = total_shares * local_weight;
+	local_shares /= aggregate(tg, acpu)->weight;
+
+	if (local_shares < 2)
+		local_shares = 2;
+
+	set_se_shares(tg->se[tcpu], local_shares);
+}
+
+/*
+ * Because changing a group's shares changes the weight of the super-group
+ * we need to walk up the tree and change all shares until we hit the root.
+ */
+static void update_group_shares_cpu(struct task_group *tg, int acpu,
+		int tcpu, unsigned long weight)
+{
+	while (tg) {
+		__update_group_shares_cpu(tg, acpu, tcpu, weight);
+		tg = tg->parent;
+	}
+}
+
+static
+void aggregate_group_shares(struct task_group *tg, int cpu, cpumask_t mask)
+{
+	unsigned long weight = cpus_weight(mask);
+	int i;
+
+	for_each_cpu_mask(i, mask)
+		__update_group_shares_cpu(tg, cpu, i, weight);
+}
+
+/*
+ * Calculate the accumulative weight and recursive load of each task group
+ * while walking down the tree.
+ */
+static
+void aggregate_get_down(struct task_group *tg, int cpu, cpumask_t mask)
+{
+	aggregate_group_weight(tg, cpu, mask);
+	aggregate_group_load(tg, cpu, mask);
+}
+
+/*
+ * Rebalance the cpu shares while walking back up the tree.
+ */
+static
+void aggregate_get_up(struct task_group *tg, int cpu, cpumask_t mask)
+{
+	aggregate_group_shares(tg, cpu, mask);
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
+static void get_aggregate(int cpu, cpumask_t mask)
+{
+	spin_lock(&per_cpu(aggregate_lock, cpu));
+	aggregate_walk_tree(aggregate_get_down, aggregate_get_up, cpu, mask);
+}
+
+static void put_aggregate(int cpu, cpumask_t mask)
+{
+	spin_unlock(&per_cpu(aggregate_lock, cpu));
+}
+
+#else
+
+static inline void init_aggregate(void)
+{
+}
+
+static inline void get_aggregate(int cpu, cpumask_t mask)
+{
+}
+
+static inline void put_aggregate(int cpu, cpumask_t mask)
+{
+}
+
+#endif
+
 #endif /* CONFIG_SMP */
 
 #include "sched_stats.h"
@@ -1377,26 +1635,14 @@ static int task_hot(struct task_struct *
 
 #define sched_class_highest (&rt_sched_class)
 
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
@@ -1488,7 +1734,7 @@ static void activate_task(struct rq *rq,
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, wakeup);
-	inc_nr_running(p, rq);
+	inc_nr_running(rq);
 }
 
 /*
@@ -1500,7 +1746,7 @@ static void deactivate_task(struct rq *r
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, sleep);
-	dec_nr_running(p, rq);
+	dec_nr_running(rq);
 }
 
 /**
@@ -2141,7 +2387,7 @@ void wake_up_new_task(struct task_struct
 		 * management (if any):
 		 */
 		p->sched_class->task_new(rq, p);
-		inc_nr_running(p, rq);
+		inc_nr_running(rq);
 	}
 	ftrace_wake_up_new_task(p, rq->curr);
 	check_preempt_curr(rq, p);
@@ -3136,6 +3382,8 @@ static int load_balance(int this_cpu, st
 	cpumask_t cpus = CPU_MASK_ALL;
 	unsigned long flags;
 
+	get_aggregate(this_cpu, sd->span);
+
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
 	 * sibling can pick up load irrespective of busy siblings. In this case,
@@ -3251,8 +3499,9 @@ redo:
 
 	if (!ld_moved && !sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
 	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		return -1;
-	return ld_moved;
+		ld_moved = -1;
+
+	goto out;
 
 out_balanced:
 	schedstat_inc(sd, lb_balanced[idle]);
@@ -3267,8 +3516,12 @@ out_one_pinned:
 
 	if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
 	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		return -1;
-	return 0;
+		ld_moved = -1;
+	else
+		ld_moved = 0;
+out:
+	put_aggregate(this_cpu, sd->span);
+	return ld_moved;
 }
 
 /*
@@ -4503,10 +4756,8 @@ void set_user_nice(struct task_struct *p
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
@@ -4516,7 +4767,6 @@ void set_user_nice(struct task_struct *p
 
 	if (on_rq) {
 		enqueue_task(rq, p, 0);
-		inc_load(rq, p);
 		/*
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
@@ -7338,6 +7588,7 @@ void __init sched_init(void)
 	int i, j;
 
 #ifdef CONFIG_SMP
+	init_aggregate();
 	init_defrootdomain();
 #endif
 
@@ -7803,12 +8054,22 @@ struct task_group *sched_create_group(st
 	if (!alloc_rt_sched_group(tg, parent))
 		goto err;
 
+	INIT_LIST_HEAD(&tg->children);
+
 	spin_lock_irqsave(&task_group_lock, flags);
 	for_each_possible_cpu(i) {
 		register_fair_sched_group(tg, i);
 		register_rt_sched_group(tg, i);
 	}
 	list_add_rcu(&tg->list, &task_groups);
+
+	rcu_assign_pointer(tg->parent, parent);
+
+	if (!parent)
+		list_add_rcu(&tg->siblings, &init_task_group.children);
+	else
+		list_add_rcu(&tg->siblings, &parent->children);
+
 	spin_unlock_irqrestore(&task_group_lock, flags);
 
 	return tg;
@@ -7837,6 +8098,7 @@ void sched_destroy_group(struct task_gro
 		unregister_rt_sched_group(tg, i);
 	}
 	list_del_rcu(&tg->list);
+	list_del_rcu(&tg->siblings);
 	spin_unlock_irqrestore(&task_group_lock, flags);
 
 	/* wait for possible concurrent references to cfs_rqs complete */
@@ -7889,9 +8151,10 @@ static void set_se_shares(struct sched_e
 {
 	struct cfs_rq *cfs_rq = se->cfs_rq;
 	struct rq *rq = cfs_rq->rq;
+	unsigned long flags;
 	int on_rq;
 
-	spin_lock_irq(&rq->lock);
+	spin_lock_irqsave(&rq->lock, flags);
 
 	on_rq = se->on_rq;
 	if (on_rq)
@@ -7903,7 +8166,7 @@ static void set_se_shares(struct sched_e
 	if (on_rq)
 		enqueue_entity(cfs_rq, se, 0);
 
-	spin_unlock_irq(&rq->lock);
+	spin_unlock_irqrestore(&rq->lock, flags);
 }
 
 static DEFINE_MUTEX(shares_mutex);
Index: linux-2.6-2/kernel/sched_fair.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_fair.c
+++ linux-2.6-2/kernel/sched_fair.c
@@ -804,15 +804,22 @@ static void enqueue_task_fair(struct rq 
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
+	struct sched_entity *top_se = NULL;
 
 	for_each_sched_entity(se) {
-		if (se->on_rq)
+		top_se = se;
+		if (se->on_rq) {
+			top_se = NULL;
 			break;
+		}
 		cfs_rq = cfs_rq_of(se);
 		enqueue_entity(cfs_rq, se, wakeup);
 		wakeup = 1;
 	}
 
+	if (top_se)
+		inc_cpu_load(rq, top_se->load.weight);
+
 	hrtick_start_fair(rq, rq->curr);
 }
 
@@ -825,16 +832,24 @@ static void dequeue_task_fair(struct rq 
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
+	struct sched_entity *top_se = NULL;
 
 	for_each_sched_entity(se) {
+		top_se = se;
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, sleep);
 		/* Don't dequeue parent if it has other entities besides us */
-		if (cfs_rq->load.weight)
+		if (cfs_rq->load.weight) {
+			if (parent_entity(se))
+				top_se = NULL;
 			break;
+		}
 		sleep = 1;
 	}
 
+	if (top_se)
+		dec_cpu_load(rq, top_se->load.weight);
+
 	hrtick_start_fair(rq, rq->curr);
 }
 
@@ -1189,73 +1204,139 @@ static struct task_struct *load_balance_
 	return __load_balance_iterator(cfs_rq, cfs_rq->rb_load_balance_curr);
 }
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-static int cfs_rq_best_prio(struct cfs_rq *cfs_rq)
-{
-	struct sched_entity *curr;
-	struct task_struct *p;
-
-	if (!cfs_rq->nr_running || !first_fair(cfs_rq))
-		return MAX_PRIO;
-
-	curr = cfs_rq->curr;
-	if (!curr)
-		curr = __pick_next_entity(cfs_rq);
-
-	p = task_of(curr);
-
-	return p->prio;
-}
-#endif
-
 static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
 		  int *all_pinned, int *this_best_prio)
 {
-	struct cfs_rq *busy_cfs_rq;
 	long rem_load_move = max_load_move;
 	struct rq_iterator cfs_rq_iterator;
+	struct cfs_rq *cfs_rq = NULL;
+	unsigned long load_moved;
 
-	cfs_rq_iterator.start = load_balance_start_fair;
-	cfs_rq_iterator.next = load_balance_next_fair;
-
-	for_each_leaf_cfs_rq(busiest, busy_cfs_rq) {
 #ifdef CONFIG_FAIR_GROUP_SCHED
-		struct cfs_rq *this_cfs_rq;
-		long imbalance;
-		unsigned long maxload;
+	int busiest_cpu = cpu_of(busiest);
+	unsigned long max_imbalance = 0;
+	unsigned long min_imbalance = 0;
+	struct task_group *tg, *min_tg = NULL, *max_tg = NULL;
+	unsigned long weight, max_load;
 
-		this_cfs_rq = cpu_cfs_rq(busy_cfs_rq, this_cpu);
+	/*
+	 * Group load balancing; we look for the group whoes imbalance has the
+	 * biggest load effect. Failing to find any group that is out of
+	 * balance, we look for groups to remove from the busy cpu.
+	 */
 
-		imbalance = busy_cfs_rq->load.weight - this_cfs_rq->load.weight;
-		/* Don't pull if this_cfs_rq has more load than busy_cfs_rq */
-		if (imbalance <= 0)
+again:
+	rcu_read_lock();
+	list_for_each_entry(tg, &task_groups, list) {
+		long imbalance;
+		unsigned long this_weight, busiest_weight;
+
+		/*
+		 * empty group
+		 */
+		if (!aggregate(tg, this_cpu)->weight)
 			continue;
 
-		/* Don't pull more than imbalance/2 */
-		imbalance /= 2;
-		maxload = min(rem_load_move, imbalance);
+		this_weight = tg->cfs_rq[this_cpu]->load.weight;
+		busiest_weight = tg->cfs_rq[busiest_cpu]->load.weight;
+
+		imbalance = busiest_weight - this_weight;
 
-		*this_best_prio = cfs_rq_best_prio(this_cfs_rq);
-#else
-# define maxload rem_load_move
-#endif
 		/*
-		 * pass busy_cfs_rq argument into
-		 * load_balance_[start|next]_fair iterators
+		 * Scale the imbalance to reflect the effect it has on the
+		 * total load.
 		 */
-		cfs_rq_iterator.arg = busy_cfs_rq;
-		rem_load_move -= balance_tasks(this_rq, this_cpu, busiest,
-					       maxload, sd, idle, all_pinned,
-					       this_best_prio,
-					       &cfs_rq_iterator);
+		if (imbalance > 0) {
+			/*
+			 * Calculate the load we could shift by balancing this
+			 * group.
+			 */
+			imbalance *= aggregate(tg, this_cpu)->load;
+			imbalance /= aggregate(tg, this_cpu)->weight;
 
-		if (rem_load_move <= 0)
-			break;
+			if (imbalance > max_imbalance) {
+				max_imbalance = imbalance;
+				max_tg = tg;
+			}
+		} else {
+			/*
+			 * Calculate the load we could shift by taking away this
+			 * group.
+			 */
+			imbalance = busiest_weight;
+			imbalance *= aggregate(tg, this_cpu)->load;
+			imbalance /= aggregate(tg, this_cpu)->weight;
+
+			if (imbalance < rem_load_move &&
+					imbalance > min_imbalance) {
+				min_imbalance = imbalance;
+				min_tg = tg;
+			}
+		}
 	}
 
+	/*
+	 * Prefer to balance groups to ensure maximal concurrency. If that
+	 * fails, try to take a whole group out.
+	 */
+	if (max_tg) {
+		tg = max_tg;
+		cfs_rq = tg->cfs_rq[busiest_cpu];
+		max_load = min_t(unsigned long, rem_load_move, max_imbalance/2);
+	} else if (min_tg) {
+		tg = min_tg;
+		cfs_rq = tg->cfs_rq[busiest_cpu];
+		max_load = min_t(unsigned long, rem_load_move, min_imbalance);
+	} else
+		goto out;
+
+	max_load *= aggregate(tg, this_cpu)->weight;
+	max_load /= aggregate(tg, this_cpu)->load;
+
+	*this_best_prio = 0;
+#else
+	cfs_rq = &busiest->cfs;
+#define max_load rem_load_move
+#endif
+
+	cfs_rq_iterator.start = load_balance_start_fair;
+	cfs_rq_iterator.next = load_balance_next_fair;
+	cfs_rq_iterator.arg = cfs_rq;
+
+	load_moved = balance_tasks(this_rq, this_cpu, busiest,
+			max_load, sd, idle, all_pinned,
+			this_best_prio, &cfs_rq_iterator);
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	/*
+	 * Scale the moved load to be comparable to total load.
+	 */
+	load_moved *= aggregate(tg, this_cpu)->load;
+	load_moved /= aggregate(tg, this_cpu)->weight;
+
+	rem_load_move -= load_moved;
+
+	/*
+	 * Re-compute the cpu shares for the affected cpus in this group.
+	 */
+	weight = cpus_weight(sd->span);
+	update_group_shares_cpu(tg, this_cpu, this_cpu, weight);
+	update_group_shares_cpu(tg, this_cpu, busiest_cpu, weight);
+
+out:
+	rcu_read_unlock();
+	/*
+	 * While there is more work to do, try again.
+	 */
+	if (rem_load_move > 0 && cfs_rq)
+		goto again;
+#else
+	rem_load_move -= load_moved;
+#endif
+
 	return max_load_move - rem_load_move;
 }
 
Index: linux-2.6-2/kernel/sched_rt.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_rt.c
+++ linux-2.6-2/kernel/sched_rt.c
@@ -518,6 +518,8 @@ static void enqueue_task_rt(struct rq *r
 	 */
 	for_each_sched_rt_entity(rt_se)
 		enqueue_rt_entity(rt_se);
+
+	inc_cpu_load(rq, p->se.load.weight);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
@@ -537,6 +539,8 @@ static void dequeue_task_rt(struct rq *r
 		if (rt_rq && rt_rq->rt_nr_running)
 			enqueue_rt_entity(rt_se);
 	}
+
+	dec_cpu_load(rq, p->se.load.weight);
 }
 
 /*

--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbYF0MAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbYF0MAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbYF0L57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:57:59 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:43059 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbYF0L5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:53 -0400
Message-Id: <20080627115211.653984469@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:23 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 14/30] sched: simplify the group load balancer
Content-Disposition: inline; filename=sched-per-cpu-load.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While thinking about the previous patch - I realized that using per domain
aggregate load values in load_balance_fair() is wrong. We should use the
load value for that CPU.

By not needing per domain hierarchical load values we don't need to store
per domain aggregate shares, which greatly simplifies all the math.

It basically falls apart in two separate computations:
 - per domain update of the shares
 - per CPU update of the hierarchical load

Also get rid of the move_group_shares() stuff - just re-compute the shares
again after a successful load balance.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c      |  286 +++++++++++-----------------------------------------
 kernel/sched_fair.c |   15 +-
 2 files changed, 72 insertions(+), 229 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -406,34 +406,23 @@ struct cfs_rq {
 	struct task_group *tg;	/* group that "owns" this runqueue */
 
 #ifdef CONFIG_SMP
-	unsigned long task_weight;
-	unsigned long shares;
 	/*
-	 * We need space to build a sched_domain wide view of the full task
-	 * group tree, in order to avoid depending on dynamic memory allocation
-	 * during the load balancing we place this in the per cpu task group
-	 * hierarchy. This limits the load balancing to one instance per cpu,
-	 * but more should not be needed anyway.
+	 * the part of load.weight contributed by tasks
 	 */
-	struct aggregate_struct {
-		/*
-		 *   load = weight(cpus) * f(tg)
-		 *
-		 * Where f(tg) is the recursive weight fraction assigned to
-		 * this group.
-		 */
-		unsigned long load;
+	unsigned long task_weight;
 
-		/*
-		 * part of the group weight distributed to this span.
-		 */
-		unsigned long shares;
+	/*
+	 *   h_load = weight * f(tg)
+	 *
+	 * Where f(tg) is the recursive weight fraction assigned to
+	 * this group.
+	 */
+	unsigned long h_load;
 
-		/*
-		 * The sum of all runqueue weights within this span.
-		 */
-		unsigned long rq_weight;
-	} aggregate;
+	/*
+	 * this cpu's part of tg->shares
+	 */
+	unsigned long shares;
 #endif
 #endif
 };
@@ -1443,47 +1432,14 @@ static int task_hot(struct task_struct *
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
-/*
- * Group load balancing.
- *
- * We calculate a few balance domain wide aggregate numbers; load and weight.
- * Given the pictures below, and assuming each item has equal weight:
- *
- *         root          1 - thread
- *         / | \         A - group
- *        A  1  B
- *       /|\   / \
- *      C 2 D 3   4
- *      |   |
- *      5   6
- *
- * load:
- *    A and B get 1/3-rd of the total load. C and D get 1/3-rd of A's 1/3-rd,
- *    which equals 1/9-th of the total load.
- *
- * shares:
- *    The weight of this group on the selected cpus.
- *
- * rq_weight:
- *    Direct sum of all the cpu's their rq weight, e.g. A would get 3 while
- *    B would get 2.
- */
-
-static inline struct aggregate_struct *
-aggregate(struct task_group *tg, int cpu)
-{
-	return &tg->cfs_rq[cpu]->aggregate;
-}
-
-typedef void (*aggregate_func)(struct task_group *, int, struct sched_domain *);
+typedef void (*tg_visitor)(struct task_group *, int, struct sched_domain *);
 
 /*
  * Iterate the full tree, calling @down when first entering a node and @up when
  * leaving it for the final time.
  */
-static
-void aggregate_walk_tree(aggregate_func down, aggregate_func up,
-			 int cpu, struct sched_domain *sd)
+static void
+walk_tg_tree(tg_visitor down, tg_visitor up, int cpu, struct sched_domain *sd)
 {
 	struct task_group *parent, *child;
 
@@ -1507,72 +1463,6 @@ up:
 	rcu_read_unlock();
 }
 
-/*
- * Calculate the aggregate runqueue weight.
- */
-static void
-aggregate_group_weight(struct task_group *tg, int cpu, struct sched_domain *sd)
-{
-	unsigned long rq_weight = 0;
-	int i;
-
-	for_each_cpu_mask(i, sd->span)
-		rq_weight += tg->cfs_rq[i]->load.weight;
-
-	aggregate(tg, cpu)->rq_weight = rq_weight;
-}
-
-/*
- * Compute the weight of this group on the given cpus.
- */
-static void
-aggregate_group_shares(struct task_group *tg, int cpu, struct sched_domain *sd)
-{
-	unsigned long shares = 0;
-	int i;
-
-	for_each_cpu_mask(i, sd->span)
-		shares += tg->cfs_rq[i]->shares;
-
-	if ((!shares && aggregate(tg, cpu)->rq_weight) || shares > tg->shares)
-		shares = tg->shares;
-
-	if (!sd->parent || !(sd->parent->flags & SD_LOAD_BALANCE))
-		shares = tg->shares;
-
-	aggregate(tg, cpu)->shares = shares;
-}
-
-/*
- * Compute the load fraction assigned to this group, relies on the aggregate
- * weight and this group's parent's load, i.e. top-down.
- */
-static void
-aggregate_group_load(struct task_group *tg, int cpu, struct sched_domain *sd)
-{
-	unsigned long load;
-
-	if (!tg->parent) {
-		int i;
-
-		load = 0;
-		for_each_cpu_mask(i, sd->span)
-			load += cpu_rq(i)->load.weight;
-
-	} else {
-		load = aggregate(tg->parent, cpu)->load;
-
-		/*
-		 * shares is our weight in the parent's rq so
-		 * shares/parent->rq_weight gives our fraction of the load
-		 */
-		load *= aggregate(tg, cpu)->shares;
-		load /= aggregate(tg->parent, cpu)->rq_weight + 1;
-	}
-
-	aggregate(tg, cpu)->load = load;
-}
-
 static void __set_se_shares(struct sched_entity *se, unsigned long shares);
 
 /*
@@ -1580,16 +1470,16 @@ static void __set_se_shares(struct sched
  */
 static void
 __update_group_shares_cpu(struct task_group *tg, int cpu,
-			  struct sched_domain *sd, int tcpu)
+			  unsigned long sd_shares, unsigned long sd_rq_weight)
 {
 	int boost = 0;
 	unsigned long shares;
 	unsigned long rq_weight;
 
-	if (!tg->se[tcpu])
+	if (!tg->se[cpu])
 		return;
 
-	rq_weight = tg->cfs_rq[tcpu]->load.weight;
+	rq_weight = tg->cfs_rq[cpu]->load.weight;
 
 	/*
 	 * If there are currently no tasks on the cpu pretend there is one of
@@ -1601,124 +1491,97 @@ __update_group_shares_cpu(struct task_gr
 		rq_weight = NICE_0_LOAD;
 	}
 
+	if (unlikely(rq_weight > sd_rq_weight))
+		rq_weight = sd_rq_weight;
+
 	/*
 	 *           \Sum shares * rq_weight
 	 * shares =  -----------------------
 	 *               \Sum rq_weight
 	 *
 	 */
-	shares = aggregate(tg, cpu)->shares * rq_weight;
-	shares /= aggregate(tg, cpu)->rq_weight + 1;
+	shares = (sd_shares * rq_weight) / (sd_rq_weight + 1);
 
 	/*
 	 * record the actual number of shares, not the boosted amount.
 	 */
-	tg->cfs_rq[tcpu]->shares = boost ? 0 : shares;
+	tg->cfs_rq[cpu]->shares = boost ? 0 : shares;
 
 	if (shares < MIN_SHARES)
 		shares = MIN_SHARES;
 	else if (shares > MAX_SHARES)
 		shares = MAX_SHARES;
 
-	__set_se_shares(tg->se[tcpu], shares);
+	__set_se_shares(tg->se[cpu], shares);
 }
 
 /*
- * Re-adjust the weights on the cpu the task came from and on the cpu the
- * task went to.
+ * Re-compute the task group their per cpu shares over the given domain.
+ * This needs to be done in a bottom-up fashion because the rq weight of a
+ * parent group depends on the shares of its child groups.
  */
 static void
-__move_group_shares(struct task_group *tg, int cpu, struct sched_domain *sd,
-		    int scpu, int dcpu)
+tg_shares_up(struct task_group *tg, int cpu, struct sched_domain *sd)
 {
-	__update_group_shares_cpu(tg, cpu, sd, scpu);
-	__update_group_shares_cpu(tg, cpu, sd, dcpu);
-}
+	unsigned long rq_weight = 0;
+	unsigned long shares = 0;
+	int i;
 
-/*
- * Because changing a group's shares changes the weight of the super-group
- * we need to walk up the tree and change all shares until we hit the root.
- */
-static void
-move_group_shares(struct task_group *tg, int cpu, struct sched_domain *sd,
-		  int scpu, int dcpu)
-{
-	while (tg) {
-		__move_group_shares(tg, cpu, sd, scpu, dcpu);
-		tg = tg->parent;
+	for_each_cpu_mask(i, sd->span) {
+		rq_weight += tg->cfs_rq[i]->load.weight;
+		shares += tg->cfs_rq[i]->shares;
 	}
-}
 
-static void
-aggregate_group_set_shares(struct task_group *tg, int cpu, struct sched_domain *sd)
-{
-	int i;
+	if ((!shares && rq_weight) || shares > tg->shares)
+		shares = tg->shares;
+
+	if (!sd->parent || !(sd->parent->flags & SD_LOAD_BALANCE))
+		shares = tg->shares;
 
 	for_each_cpu_mask(i, sd->span) {
 		struct rq *rq = cpu_rq(i);
 		unsigned long flags;
 
 		spin_lock_irqsave(&rq->lock, flags);
-		__update_group_shares_cpu(tg, cpu, sd, i);
+		__update_group_shares_cpu(tg, i, shares, rq_weight);
 		spin_unlock_irqrestore(&rq->lock, flags);
 	}
-
-	aggregate_group_shares(tg, cpu, sd);
 }
 
 /*
- * Calculate the accumulative weight and recursive load of each task group
- * while walking down the tree.
+ * Compute the cpu's hierarchical load factor for each task group.
+ * This needs to be done in a top-down fashion because the load of a child
+ * group is a fraction of its parents load.
  */
 static void
-aggregate_get_down(struct task_group *tg, int cpu, struct sched_domain *sd)
+tg_load_down(struct task_group *tg, int cpu, struct sched_domain *sd)
 {
-	aggregate_group_weight(tg, cpu, sd);
-	aggregate_group_shares(tg, cpu, sd);
-	aggregate_group_load(tg, cpu, sd);
-}
-
-/*
- * Rebalance the cpu shares while walking back up the tree.
- */
-static void
-aggregate_get_up(struct task_group *tg, int cpu, struct sched_domain *sd)
-{
-	aggregate_group_set_shares(tg, cpu, sd);
-}
-
-static void
-aggregate_get_nop(struct task_group *tg, int cpu, struct sched_domain *sd)
-{
-}
-
-static DEFINE_PER_CPU(spinlock_t, aggregate_lock);
+	unsigned long load;
 
-static void __init init_aggregate(void)
-{
-	int i;
+	if (!tg->parent) {
+		load = cpu_rq(cpu)->load.weight;
+	} else {
+		load = tg->parent->cfs_rq[cpu]->h_load;
+		load *= tg->cfs_rq[cpu]->shares;
+		load /= tg->parent->cfs_rq[cpu]->load.weight + 1;
+	}
 
-	for_each_possible_cpu(i)
-		spin_lock_init(&per_cpu(aggregate_lock, i));
+	tg->cfs_rq[cpu]->h_load = load;
 }
 
-static int get_aggregate(int cpu, struct sched_domain *sd)
+static void
+tg_nop(struct task_group *tg, int cpu, struct sched_domain *sd)
 {
-	if (!spin_trylock(&per_cpu(aggregate_lock, cpu)))
-		return 0;
-
-	aggregate_walk_tree(aggregate_get_down, aggregate_get_up, cpu, sd);
-	return 1;
 }
 
-static void update_aggregate(int cpu, struct sched_domain *sd)
+static void update_shares(struct sched_domain *sd)
 {
-	aggregate_walk_tree(aggregate_get_down, aggregate_get_nop, cpu, sd);
+	walk_tg_tree(tg_nop, tg_shares_up, 0, sd);
 }
 
-static void put_aggregate(int cpu, struct sched_domain *sd)
+static void update_h_load(int cpu)
 {
-	spin_unlock(&per_cpu(aggregate_lock, cpu));
+	walk_tg_tree(tg_load_down, tg_nop, cpu, NULL);
 }
 
 static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
@@ -1728,22 +1591,10 @@ static void cfs_rq_set_shares(struct cfs
 
 #else
 
-static inline void init_aggregate(void)
-{
-}
-
-static inline int get_aggregate(int cpu, struct sched_domain *sd)
-{
-	return 0;
-}
-
-static inline void update_aggregate(int cpu, struct sched_domain *sd)
+static inline void update_shares(struct sched_domain *sd)
 {
 }
 
-static inline void put_aggregate(int cpu, struct sched_domain *sd)
-{
-}
 #endif
 
 #endif
@@ -2172,12 +2023,6 @@ find_idlest_group(struct sched_domain *s
 	int load_idx = sd->forkexec_idx;
 	int imbalance = 100 + (sd->imbalance_pct-100)/2;
 
-	/*
-	 * now that we have both rqs locked the rq weight won't change
-	 * anymore - so update the stats.
-	 */
-	update_aggregate(this_cpu, sd);
-
 	do {
 		unsigned long load, avg_load;
 		int local_group;
@@ -3521,12 +3366,9 @@ static int load_balance(int this_cpu, st
 	unsigned long imbalance;
 	struct rq *busiest;
 	unsigned long flags;
-	int unlock_aggregate;
 
 	cpus_setall(*cpus);
 
-	unlock_aggregate = get_aggregate(this_cpu, sd);
-
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
 	 * sibling can pick up load irrespective of busy siblings. In this case,
@@ -3540,6 +3382,7 @@ static int load_balance(int this_cpu, st
 	schedstat_inc(sd, lb_count[idle]);
 
 redo:
+	update_shares(sd);
 	group = find_busiest_group(sd, this_cpu, &imbalance, idle, &sd_idle,
 				   cpus, balance);
 
@@ -3663,8 +3506,8 @@ out_one_pinned:
 	else
 		ld_moved = 0;
 out:
-	if (unlock_aggregate)
-		put_aggregate(this_cpu, sd);
+	if (ld_moved)
+		update_shares(sd);
 	return ld_moved;
 }
 
@@ -8043,7 +7886,6 @@ void __init sched_init(void)
 	}
 
 #ifdef CONFIG_SMP
-	init_aggregate();
 	init_defrootdomain();
 #endif
 
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1421,17 +1421,20 @@ load_balance_fair(struct rq *this_rq, in
 	struct task_group *tg;
 
 	rcu_read_lock();
+	update_h_load(busiest_cpu);
+
 	list_for_each_entry(tg, &task_groups, list) {
+		struct cfs_rq *busiest_cfs_rq = tg->cfs_rq[busiest_cpu];
 		long rem_load, moved_load;
 
 		/*
 		 * empty group
 		 */
-		if (!tg->cfs_rq[busiest_cpu]->task_weight)
+		if (!busiest_cfs_rq->task_weight)
 			continue;
 
-		rem_load = rem_load_move * aggregate(tg, this_cpu)->rq_weight;
-		rem_load /= aggregate(tg, this_cpu)->load + 1;
+		rem_load = rem_load_move * busiest_cfs_rq->load.weight;
+		rem_load /= busiest_cfs_rq->h_load + 1;
 
 		moved_load = __load_balance_fair(this_rq, this_cpu, busiest,
 				rem_load, sd, idle, all_pinned, this_best_prio,
@@ -1440,10 +1443,8 @@ load_balance_fair(struct rq *this_rq, in
 		if (!moved_load)
 			continue;
 
-		move_group_shares(tg, this_cpu, sd, busiest_cpu, this_cpu);
-
-		moved_load *= aggregate(tg, this_cpu)->load;
-		moved_load /= aggregate(tg, this_cpu)->rq_weight + 1;
+		moved_load *= busiest_cfs_rq->h_load;
+		moved_load /= busiest_cfs_rq->load.weight + 1;
 
 		rem_load_move -= moved_load;
 		if (rem_load_move < 0)

-- 


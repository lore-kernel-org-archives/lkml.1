Return-Path: <linux-kernel-owner+w=401wt.eu-S1759986AbYF0MFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986AbYF0MFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbYF0L6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:05 -0400
Received: from viefep25-int.chello.at ([62.179.121.45]:22368 "EHLO
	viefep25-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbYF0L5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:55 -0400
X-SourceIP: 62.163.52.83
Message-Id: <20080627115211.408635538@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:18 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/30] sched: fix sched_domain aggregation
Content-Disposition: inline; filename=sched-fair-smp-lb.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keeping the aggregate on the first cpu of the sched domain has two problems:
 - it could collide between different sched domains on different cpus
 - it could slow things down because of the remote accesses

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    1 
 kernel/sched.c        |  113 +++++++++++++++++++++++---------------------------
 kernel/sched_fair.c   |   12 ++---
 3 files changed, 60 insertions(+), 66 deletions(-)

Index: linux-2.6-2/include/linux/sched.h
===================================================================
--- linux-2.6-2.orig/include/linux/sched.h
+++ linux-2.6-2/include/linux/sched.h
@@ -766,7 +766,6 @@ struct sched_domain {
 	struct sched_domain *child;	/* bottom domain must be null terminated */
 	struct sched_group *groups;	/* the balancing groups of the domain */
 	cpumask_t span;			/* span of all CPUs in this domain */
-	int first_cpu;			/* cache of the first cpu in this domain */
 	unsigned long min_interval;	/* Minimum balance interval ms */
 	unsigned long max_interval;	/* Maximum balance interval ms */
 	unsigned int busy_factor;	/* less balancing by factor if busy */
Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -1539,12 +1539,12 @@ static int task_hot(struct task_struct *
  */
 
 static inline struct aggregate_struct *
-aggregate(struct task_group *tg, struct sched_domain *sd)
+aggregate(struct task_group *tg, int cpu)
 {
-	return &tg->cfs_rq[sd->first_cpu]->aggregate;
+	return &tg->cfs_rq[cpu]->aggregate;
 }
 
-typedef void (*aggregate_func)(struct task_group *, struct sched_domain *);
+typedef void (*aggregate_func)(struct task_group *, int, struct sched_domain *);
 
 /*
  * Iterate the full tree, calling @down when first entering a node and @up when
@@ -1552,14 +1552,14 @@ typedef void (*aggregate_func)(struct ta
  */
 static
 void aggregate_walk_tree(aggregate_func down, aggregate_func up,
-			 struct sched_domain *sd)
+			 int cpu, struct sched_domain *sd)
 {
 	struct task_group *parent, *child;
 
 	rcu_read_lock();
 	parent = &root_task_group;
 down:
-	(*down)(parent, sd);
+	(*down)(parent, cpu, sd);
 	list_for_each_entry_rcu(child, &parent->children, siblings) {
 		parent = child;
 		goto down;
@@ -1567,7 +1567,7 @@ down:
 up:
 		continue;
 	}
-	(*up)(parent, sd);
+	(*up)(parent, cpu, sd);
 
 	child = parent;
 	parent = parent->parent;
@@ -1579,8 +1579,8 @@ up:
 /*
  * Calculate the aggregate runqueue weight.
  */
-static
-void aggregate_group_weight(struct task_group *tg, struct sched_domain *sd)
+static void
+aggregate_group_weight(struct task_group *tg, int cpu, struct sched_domain *sd)
 {
 	unsigned long rq_weight = 0;
 	unsigned long task_weight = 0;
@@ -1591,15 +1591,15 @@ void aggregate_group_weight(struct task_
 		task_weight += tg->cfs_rq[i]->task_weight;
 	}
 
-	aggregate(tg, sd)->rq_weight = rq_weight;
-	aggregate(tg, sd)->task_weight = task_weight;
+	aggregate(tg, cpu)->rq_weight = rq_weight;
+	aggregate(tg, cpu)->task_weight = task_weight;
 }
 
 /*
  * Compute the weight of this group on the given cpus.
  */
-static
-void aggregate_group_shares(struct task_group *tg, struct sched_domain *sd)
+static void
+aggregate_group_shares(struct task_group *tg, int cpu, struct sched_domain *sd)
 {
 	unsigned long shares = 0;
 	int i;
@@ -1607,18 +1607,18 @@ void aggregate_group_shares(struct task_
 	for_each_cpu_mask(i, sd->span)
 		shares += tg->cfs_rq[i]->shares;
 
-	if ((!shares && aggregate(tg, sd)->rq_weight) || shares > tg->shares)
+	if ((!shares && aggregate(tg, cpu)->rq_weight) || shares > tg->shares)
 		shares = tg->shares;
 
-	aggregate(tg, sd)->shares = shares;
+	aggregate(tg, cpu)->shares = shares;
 }
 
 /*
  * Compute the load fraction assigned to this group, relies on the aggregate
  * weight and this group's parent's load, i.e. top-down.
  */
-static
-void aggregate_group_load(struct task_group *tg, struct sched_domain *sd)
+static void
+aggregate_group_load(struct task_group *tg, int cpu, struct sched_domain *sd)
 {
 	unsigned long load;
 
@@ -1630,17 +1630,17 @@ void aggregate_group_load(struct task_gr
 			load += cpu_rq(i)->load.weight;
 
 	} else {
-		load = aggregate(tg->parent, sd)->load;
+		load = aggregate(tg->parent, cpu)->load;
 
 		/*
 		 * shares is our weight in the parent's rq so
 		 * shares/parent->rq_weight gives our fraction of the load
 		 */
-		load *= aggregate(tg, sd)->shares;
-		load /= aggregate(tg->parent, sd)->rq_weight + 1;
+		load *= aggregate(tg, cpu)->shares;
+		load /= aggregate(tg->parent, cpu)->rq_weight + 1;
 	}
 
-	aggregate(tg, sd)->load = load;
+	aggregate(tg, cpu)->load = load;
 }
 
 static void __set_se_shares(struct sched_entity *se, unsigned long shares);
@@ -1649,8 +1649,8 @@ static void __set_se_shares(struct sched
  * Calculate and set the cpu's group shares.
  */
 static void
-__update_group_shares_cpu(struct task_group *tg, struct sched_domain *sd,
-			  int tcpu)
+__update_group_shares_cpu(struct task_group *tg, int cpu,
+			  struct sched_domain *sd, int tcpu)
 {
 	int boost = 0;
 	unsigned long shares;
@@ -1677,8 +1677,8 @@ __update_group_shares_cpu(struct task_gr
 	 *               \Sum rq_weight
 	 *
 	 */
-	shares = aggregate(tg, sd)->shares * rq_weight;
-	shares /= aggregate(tg, sd)->rq_weight + 1;
+	shares = aggregate(tg, cpu)->shares * rq_weight;
+	shares /= aggregate(tg, cpu)->rq_weight + 1;
 
 	/*
 	 * record the actual number of shares, not the boosted amount.
@@ -1698,15 +1698,15 @@ __update_group_shares_cpu(struct task_gr
  * task went to.
  */
 static void
-__move_group_shares(struct task_group *tg, struct sched_domain *sd,
+__move_group_shares(struct task_group *tg, int cpu, struct sched_domain *sd,
 		    int scpu, int dcpu)
 {
 	unsigned long shares;
 
 	shares = tg->cfs_rq[scpu]->shares + tg->cfs_rq[dcpu]->shares;
 
-	__update_group_shares_cpu(tg, sd, scpu);
-	__update_group_shares_cpu(tg, sd, dcpu);
+	__update_group_shares_cpu(tg, cpu, sd, scpu);
+	__update_group_shares_cpu(tg, cpu, sd, dcpu);
 
 	/*
 	 * ensure we never loose shares due to rounding errors in the
@@ -1722,19 +1722,19 @@ __move_group_shares(struct task_group *t
  * we need to walk up the tree and change all shares until we hit the root.
  */
 static void
-move_group_shares(struct task_group *tg, struct sched_domain *sd,
+move_group_shares(struct task_group *tg, int cpu, struct sched_domain *sd,
 		  int scpu, int dcpu)
 {
 	while (tg) {
-		__move_group_shares(tg, sd, scpu, dcpu);
+		__move_group_shares(tg, cpu, sd, scpu, dcpu);
 		tg = tg->parent;
 	}
 }
 
-static
-void aggregate_group_set_shares(struct task_group *tg, struct sched_domain *sd)
+static void
+aggregate_group_set_shares(struct task_group *tg, int cpu, struct sched_domain *sd)
 {
-	unsigned long shares = aggregate(tg, sd)->shares;
+	unsigned long shares = aggregate(tg, cpu)->shares;
 	int i;
 
 	for_each_cpu_mask(i, sd->span) {
@@ -1742,20 +1742,20 @@ void aggregate_group_set_shares(struct t
 		unsigned long flags;
 
 		spin_lock_irqsave(&rq->lock, flags);
-		__update_group_shares_cpu(tg, sd, i);
+		__update_group_shares_cpu(tg, cpu, sd, i);
 		spin_unlock_irqrestore(&rq->lock, flags);
 	}
 
-	aggregate_group_shares(tg, sd);
+	aggregate_group_shares(tg, cpu, sd);
 
 	/*
 	 * ensure we never loose shares due to rounding errors in the
 	 * above redistribution.
 	 */
-	shares -= aggregate(tg, sd)->shares;
+	shares -= aggregate(tg, cpu)->shares;
 	if (shares) {
-		tg->cfs_rq[sd->first_cpu]->shares += shares;
-		aggregate(tg, sd)->shares += shares;
+		tg->cfs_rq[cpu]->shares += shares;
+		aggregate(tg, cpu)->shares += shares;
 	}
 }
 
@@ -1763,21 +1763,21 @@ void aggregate_group_set_shares(struct t
  * Calculate the accumulative weight and recursive load of each task group
  * while walking down the tree.
  */
-static
-void aggregate_get_down(struct task_group *tg, struct sched_domain *sd)
+static void
+aggregate_get_down(struct task_group *tg, int cpu, struct sched_domain *sd)
 {
-	aggregate_group_weight(tg, sd);
-	aggregate_group_shares(tg, sd);
-	aggregate_group_load(tg, sd);
+	aggregate_group_weight(tg, cpu, sd);
+	aggregate_group_shares(tg, cpu, sd);
+	aggregate_group_load(tg, cpu, sd);
 }
 
 /*
  * Rebalance the cpu shares while walking back up the tree.
  */
-static
-void aggregate_get_up(struct task_group *tg, struct sched_domain *sd)
+static void
+aggregate_get_up(struct task_group *tg, int cpu, struct sched_domain *sd)
 {
-	aggregate_group_set_shares(tg, sd);
+	aggregate_group_set_shares(tg, cpu, sd);
 }
 
 static DEFINE_PER_CPU(spinlock_t, aggregate_lock);
@@ -1790,18 +1790,18 @@ static void __init init_aggregate(void)
 		spin_lock_init(&per_cpu(aggregate_lock, i));
 }
 
-static int get_aggregate(struct sched_domain *sd)
+static int get_aggregate(int cpu, struct sched_domain *sd)
 {
-	if (!spin_trylock(&per_cpu(aggregate_lock, sd->first_cpu)))
+	if (!spin_trylock(&per_cpu(aggregate_lock, cpu)))
 		return 0;
 
-	aggregate_walk_tree(aggregate_get_down, aggregate_get_up, sd);
+	aggregate_walk_tree(aggregate_get_down, aggregate_get_up, cpu, sd);
 	return 1;
 }
 
-static void put_aggregate(struct sched_domain *sd)
+static void put_aggregate(int cpu, struct sched_domain *sd)
 {
-	spin_unlock(&per_cpu(aggregate_lock, sd->first_cpu));
+	spin_unlock(&per_cpu(aggregate_lock, cpu));
 }
 
 static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
@@ -1815,12 +1815,12 @@ static inline void init_aggregate(void)
 {
 }
 
-static inline int get_aggregate(struct sched_domain *sd)
+static inline int get_aggregate(int cpu, struct sched_domain *sd)
 {
 	return 0;
 }
 
-static inline void put_aggregate(struct sched_domain *sd)
+static inline void put_aggregate(int cpu, struct sched_domain *sd)
 {
 }
 #endif
@@ -3604,7 +3604,7 @@ static int load_balance(int this_cpu, st
 
 	cpus_setall(*cpus);
 
-	unlock_aggregate = get_aggregate(sd);
+	unlock_aggregate = get_aggregate(this_cpu, sd);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -3743,7 +3743,7 @@ out_one_pinned:
 		ld_moved = 0;
 out:
 	if (unlock_aggregate)
-		put_aggregate(sd);
+		put_aggregate(this_cpu, sd);
 	return ld_moved;
 }
 
@@ -7337,7 +7337,6 @@ static int __build_sched_domains(const c
 			SD_INIT(sd, ALLNODES);
 			set_domain_attribute(sd, attr);
 			sd->span = *cpu_map;
-			sd->first_cpu = first_cpu(sd->span);
 			cpu_to_allnodes_group(i, cpu_map, &sd->groups, tmpmask);
 			p = sd;
 			sd_allnodes = 1;
@@ -7348,7 +7347,6 @@ static int __build_sched_domains(const c
 		SD_INIT(sd, NODE);
 		set_domain_attribute(sd, attr);
 		sched_domain_node_span(cpu_to_node(i), &sd->span);
-		sd->first_cpu = first_cpu(sd->span);
 		sd->parent = p;
 		if (p)
 			p->child = sd;
@@ -7360,7 +7358,6 @@ static int __build_sched_domains(const c
 		SD_INIT(sd, CPU);
 		set_domain_attribute(sd, attr);
 		sd->span = *nodemask;
-		sd->first_cpu = first_cpu(sd->span);
 		sd->parent = p;
 		if (p)
 			p->child = sd;
@@ -7372,7 +7369,6 @@ static int __build_sched_domains(const c
 		SD_INIT(sd, MC);
 		set_domain_attribute(sd, attr);
 		sd->span = cpu_coregroup_map(i);
-		sd->first_cpu = first_cpu(sd->span);
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
@@ -7385,7 +7381,6 @@ static int __build_sched_domains(const c
 		SD_INIT(sd, SIBLING);
 		set_domain_attribute(sd, attr);
 		sd->span = per_cpu(cpu_sibling_map, i);
-		sd->first_cpu = first_cpu(sd->span);
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
Index: linux-2.6-2/kernel/sched_fair.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_fair.c
+++ linux-2.6-2/kernel/sched_fair.c
@@ -1403,11 +1403,11 @@ load_balance_fair(struct rq *this_rq, in
 		/*
 		 * empty group
 		 */
-		if (!aggregate(tg, sd)->task_weight)
+		if (!aggregate(tg, this_cpu)->task_weight)
 			continue;
 
-		rem_load = rem_load_move * aggregate(tg, sd)->rq_weight;
-		rem_load /= aggregate(tg, sd)->load + 1;
+		rem_load = rem_load_move * aggregate(tg, this_cpu)->rq_weight;
+		rem_load /= aggregate(tg, this_cpu)->load + 1;
 
 		this_weight = tg->cfs_rq[this_cpu]->task_weight;
 		busiest_weight = tg->cfs_rq[busiest_cpu]->task_weight;
@@ -1425,10 +1425,10 @@ load_balance_fair(struct rq *this_rq, in
 		if (!moved_load)
 			continue;
 
-		move_group_shares(tg, sd, busiest_cpu, this_cpu);
+		move_group_shares(tg, this_cpu, sd, busiest_cpu, this_cpu);
 
-		moved_load *= aggregate(tg, sd)->load;
-		moved_load /= aggregate(tg, sd)->rq_weight + 1;
+		moved_load *= aggregate(tg, this_cpu)->load;
+		moved_load /= aggregate(tg, this_cpu)->rq_weight + 1;
 
 		rem_load_move -= moved_load;
 		if (rem_load_move < 0)

-- 


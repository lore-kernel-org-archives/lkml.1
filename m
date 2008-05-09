Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbYEIJsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbYEIJsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 05:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbYEIJru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 05:47:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:46713 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750836AbYEIJrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 05:47:47 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+xkhshFoGxMi4Ms1QrwEqoEDLB/SnX9UUur7Bniz
	hmsdm+G2CwDrVu
Subject: Re: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
In-Reply-To: <1210321407.5285.0.camel@marge.simson.net>
References: <1210136148.3453.59.camel@ymzhang>
	 <1210177575.6525.4.camel@lappy.programming.kicks-ass.net>
	 <1210228531.3453.124.camel@ymzhang>
	 <1210233617.4895.6.camel@marge.simson.net>
	 <1210237267.3453.143.camel@ymzhang>
	 <1210238114.11887.3.camel@marge.simson.net>
	 <1210238622.13978.193.camel@twins>  <1210295779.3453.155.camel@ymzhang>
	 <1210315870.13978.204.camel@twins>
	 <1210318362.15296.4.camel@marge.simson.net>
	 <1210319417.13978.207.camel@twins>
	 <1210319914.5250.2.camel@marge.simson.net>
	 <1210320160.13978.209.camel@twins>
	 <1210321407.5285.0.camel@marge.simson.net>
Content-Type: multipart/mixed; boundary="=-VaE9fwpuDRDJ4lboMhl4"
Date: Fri, 09 May 2008 11:47:37 +0200
Message-Id: <1210326457.5230.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VaE9fwpuDRDJ4lboMhl4
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Fri, 2008-05-09 at 10:23 +0200, Mike Galbraith wrote:
> On Fri, 2008-05-09 at 10:02 +0200, Peter Zijlstra wrote:

> > > > Hm, ok. Does the patch at hand improve or regress the group config for
> > > > you?
> > > 
> > > I'm testing got.today.
> > > 
> > > You mean 46151122e0a2e80e5a6b2889f595e371fe2b600d?
> > 
> > Exactly - Yanmin says it makes it worse for him, I'm wondering if you
> > can see a similar problem with group scheduling enabled.
> 
> Nope, same fugly curve +-jitter.

Seems to be smpnice, see 2.6.26.git.grp.n- in attached.

	-Mike

Index: linux-2.6.26.git/include/linux/sched.h
===================================================================
--- linux-2.6.26.git.orig/include/linux/sched.h
+++ linux-2.6.26.git/include/linux/sched.h
@@ -766,7 +766,6 @@ struct sched_domain {
 	struct sched_domain *child;	/* bottom domain must be null terminated */
 	struct sched_group *groups;	/* the balancing groups of the domain */
 	cpumask_t span;			/* span of all CPUs in this domain */
-	int first_cpu;			/* cache of the first cpu in this domain */
 	unsigned long min_interval;	/* Minimum balance interval ms */
 	unsigned long max_interval;	/* Maximum balance interval ms */
 	unsigned int busy_factor;	/* less balancing by factor if busy */
Index: linux-2.6.26.git/kernel/sched.c
===================================================================
--- linux-2.6.26.git.orig/kernel/sched.c
+++ linux-2.6.26.git/kernel/sched.c
@@ -398,43 +398,6 @@ struct cfs_rq {
 	 */
 	struct list_head leaf_cfs_rq_list;
 	struct task_group *tg;	/* group that "owns" this runqueue */
-
-#ifdef CONFIG_SMP
-	unsigned long task_weight;
-	unsigned long shares;
-	/*
-	 * We need space to build a sched_domain wide view of the full task
-	 * group tree, in order to avoid depending on dynamic memory allocation
-	 * during the load balancing we place this in the per cpu task group
-	 * hierarchy. This limits the load balancing to one instance per cpu,
-	 * but more should not be needed anyway.
-	 */
-	struct aggregate_struct {
-		/*
-		 *   load = weight(cpus) * f(tg)
-		 *
-		 * Where f(tg) is the recursive weight fraction assigned to
-		 * this group.
-		 */
-		unsigned long load;
-
-		/*
-		 * part of the group weight distributed to this span.
-		 */
-		unsigned long shares;
-
-		/*
-		 * The sum of all runqueue weights within this span.
-		 */
-		unsigned long rq_weight;
-
-		/*
-		 * Weight contributed by tasks; this is the part we can
-		 * influence by moving tasks around.
-		 */
-		unsigned long task_weight;
-	} aggregate;
-#endif
 #endif
 };
 
@@ -1490,349 +1453,11 @@ static void cpuacct_charge(struct task_s
 static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
 #endif
 
-static inline void inc_cpu_load(struct rq *rq, unsigned long load)
-{
-	update_load_add(&rq->load, load);
-}
-
-static inline void dec_cpu_load(struct rq *rq, unsigned long load)
-{
-	update_load_sub(&rq->load, load);
-}
-
 #ifdef CONFIG_SMP
 static unsigned long source_load(int cpu, int type);
 static unsigned long target_load(int cpu, int type);
 static unsigned long cpu_avg_load_per_task(int cpu);
 static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-
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
- *
- * task_weight:
- *    Part of the rq_weight contributed by tasks; all groups except B would
- *    get 1, B gets 2.
- */
-
-static inline struct aggregate_struct *
-aggregate(struct task_group *tg, struct sched_domain *sd)
-{
-	return &tg->cfs_rq[sd->first_cpu]->aggregate;
-}
-
-typedef void (*aggregate_func)(struct task_group *, struct sched_domain *);
-
-/*
- * Iterate the full tree, calling @down when first entering a node and @up when
- * leaving it for the final time.
- */
-static
-void aggregate_walk_tree(aggregate_func down, aggregate_func up,
-			 struct sched_domain *sd)
-{
-	struct task_group *parent, *child;
-
-	rcu_read_lock();
-	parent = &root_task_group;
-down:
-	(*down)(parent, sd);
-	list_for_each_entry_rcu(child, &parent->children, siblings) {
-		parent = child;
-		goto down;
-
-up:
-		continue;
-	}
-	(*up)(parent, sd);
-
-	child = parent;
-	parent = parent->parent;
-	if (parent)
-		goto up;
-	rcu_read_unlock();
-}
-
-/*
- * Calculate the aggregate runqueue weight.
- */
-static
-void aggregate_group_weight(struct task_group *tg, struct sched_domain *sd)
-{
-	unsigned long rq_weight = 0;
-	unsigned long task_weight = 0;
-	int i;
-
-	for_each_cpu_mask(i, sd->span) {
-		rq_weight += tg->cfs_rq[i]->load.weight;
-		task_weight += tg->cfs_rq[i]->task_weight;
-	}
-
-	aggregate(tg, sd)->rq_weight = rq_weight;
-	aggregate(tg, sd)->task_weight = task_weight;
-}
-
-/*
- * Compute the weight of this group on the given cpus.
- */
-static
-void aggregate_group_shares(struct task_group *tg, struct sched_domain *sd)
-{
-	unsigned long shares = 0;
-	int i;
-
-	for_each_cpu_mask(i, sd->span)
-		shares += tg->cfs_rq[i]->shares;
-
-	if ((!shares && aggregate(tg, sd)->rq_weight) || shares > tg->shares)
-		shares = tg->shares;
-
-	aggregate(tg, sd)->shares = shares;
-}
-
-/*
- * Compute the load fraction assigned to this group, relies on the aggregate
- * weight and this group's parent's load, i.e. top-down.
- */
-static
-void aggregate_group_load(struct task_group *tg, struct sched_domain *sd)
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
-		load = aggregate(tg->parent, sd)->load;
-
-		/*
-		 * shares is our weight in the parent's rq so
-		 * shares/parent->rq_weight gives our fraction of the load
-		 */
-		load *= aggregate(tg, sd)->shares;
-		load /= aggregate(tg->parent, sd)->rq_weight + 1;
-	}
-
-	aggregate(tg, sd)->load = load;
-}
-
-static void __set_se_shares(struct sched_entity *se, unsigned long shares);
-
-/*
- * Calculate and set the cpu's group shares.
- */
-static void
-__update_group_shares_cpu(struct task_group *tg, struct sched_domain *sd,
-			  int tcpu)
-{
-	int boost = 0;
-	unsigned long shares;
-	unsigned long rq_weight;
-
-	if (!tg->se[tcpu])
-		return;
-
-	rq_weight = tg->cfs_rq[tcpu]->load.weight;
-
-	/*
-	 * If there are currently no tasks on the cpu pretend there is one of
-	 * average load so that when a new task gets to run here it will not
-	 * get delayed by group starvation.
-	 */
-	if (!rq_weight) {
-		boost = 1;
-		rq_weight = NICE_0_LOAD;
-	}
-
-	/*
-	 *           \Sum shares * rq_weight
-	 * shares =  -----------------------
-	 *               \Sum rq_weight
-	 *
-	 */
-	shares = aggregate(tg, sd)->shares * rq_weight;
-	shares /= aggregate(tg, sd)->rq_weight + 1;
-
-	/*
-	 * record the actual number of shares, not the boosted amount.
-	 */
-	tg->cfs_rq[tcpu]->shares = boost ? 0 : shares;
-
-	if (shares < MIN_SHARES)
-		shares = MIN_SHARES;
-	else if (shares > MAX_SHARES)
-		shares = MAX_SHARES;
-
-	__set_se_shares(tg->se[tcpu], shares);
-}
-
-/*
- * Re-adjust the weights on the cpu the task came from and on the cpu the
- * task went to.
- */
-static void
-__move_group_shares(struct task_group *tg, struct sched_domain *sd,
-		    int scpu, int dcpu)
-{
-	unsigned long shares;
-
-	shares = tg->cfs_rq[scpu]->shares + tg->cfs_rq[dcpu]->shares;
-
-	__update_group_shares_cpu(tg, sd, scpu);
-	__update_group_shares_cpu(tg, sd, dcpu);
-
-	/*
-	 * ensure we never loose shares due to rounding errors in the
-	 * above redistribution.
-	 */
-	shares -= tg->cfs_rq[scpu]->shares + tg->cfs_rq[dcpu]->shares;
-	if (shares)
-		tg->cfs_rq[dcpu]->shares += shares;
-}
-
-/*
- * Because changing a group's shares changes the weight of the super-group
- * we need to walk up the tree and change all shares until we hit the root.
- */
-static void
-move_group_shares(struct task_group *tg, struct sched_domain *sd,
-		  int scpu, int dcpu)
-{
-	while (tg) {
-		__move_group_shares(tg, sd, scpu, dcpu);
-		tg = tg->parent;
-	}
-}
-
-static
-void aggregate_group_set_shares(struct task_group *tg, struct sched_domain *sd)
-{
-	unsigned long shares = aggregate(tg, sd)->shares;
-	int i;
-
-	for_each_cpu_mask(i, sd->span) {
-		struct rq *rq = cpu_rq(i);
-		unsigned long flags;
-
-		spin_lock_irqsave(&rq->lock, flags);
-		__update_group_shares_cpu(tg, sd, i);
-		spin_unlock_irqrestore(&rq->lock, flags);
-	}
-
-	aggregate_group_shares(tg, sd);
-
-	/*
-	 * ensure we never loose shares due to rounding errors in the
-	 * above redistribution.
-	 */
-	shares -= aggregate(tg, sd)->shares;
-	if (shares) {
-		tg->cfs_rq[sd->first_cpu]->shares += shares;
-		aggregate(tg, sd)->shares += shares;
-	}
-}
-
-/*
- * Calculate the accumulative weight and recursive load of each task group
- * while walking down the tree.
- */
-static
-void aggregate_get_down(struct task_group *tg, struct sched_domain *sd)
-{
-	aggregate_group_weight(tg, sd);
-	aggregate_group_shares(tg, sd);
-	aggregate_group_load(tg, sd);
-}
-
-/*
- * Rebalance the cpu shares while walking back up the tree.
- */
-static
-void aggregate_get_up(struct task_group *tg, struct sched_domain *sd)
-{
-	aggregate_group_set_shares(tg, sd);
-}
-
-static DEFINE_PER_CPU(spinlock_t, aggregate_lock);
-
-static void __init init_aggregate(void)
-{
-	int i;
-
-	for_each_possible_cpu(i)
-		spin_lock_init(&per_cpu(aggregate_lock, i));
-}
-
-static int get_aggregate(struct sched_domain *sd)
-{
-	if (!spin_trylock(&per_cpu(aggregate_lock, sd->first_cpu)))
-		return 0;
-
-	aggregate_walk_tree(aggregate_get_down, aggregate_get_up, sd);
-	return 1;
-}
-
-static void put_aggregate(struct sched_domain *sd)
-{
-	spin_unlock(&per_cpu(aggregate_lock, sd->first_cpu));
-}
-
-static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
-{
-	cfs_rq->shares = shares;
-}
-
-#else
-
-static inline void init_aggregate(void)
-{
-}
-
-static inline int get_aggregate(struct sched_domain *sd)
-{
-	return 0;
-}
-
-static inline void put_aggregate(struct sched_domain *sd)
-{
-}
-#endif
-
-#else /* CONFIG_SMP */
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
-{
-}
-#endif
-
 #endif /* CONFIG_SMP */
 
 #include "sched_stats.h"
@@ -1845,14 +1470,26 @@ static void cfs_rq_set_shares(struct cfs
 
 #define sched_class_highest (&rt_sched_class)
 
-static void inc_nr_running(struct rq *rq)
+static inline void inc_load(struct rq *rq, const struct task_struct *p)
+{
+	update_load_add(&rq->load, p->se.load.weight);
+}
+
+static inline void dec_load(struct rq *rq, const struct task_struct *p)
+{
+	update_load_sub(&rq->load, p->se.load.weight);
+}
+
+static void inc_nr_running(struct task_struct *p, struct rq *rq)
 {
 	rq->nr_running++;
+	inc_load(rq, p);
 }
 
-static void dec_nr_running(struct rq *rq)
+static void dec_nr_running(struct task_struct *p, struct rq *rq)
 {
 	rq->nr_running--;
+	dec_load(rq, p);
 }
 
 static void set_load_weight(struct task_struct *p)
@@ -1944,7 +1581,7 @@ static void activate_task(struct rq *rq,
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, wakeup);
-	inc_nr_running(rq);
+	inc_nr_running(p, rq);
 }
 
 /*
@@ -1956,7 +1593,7 @@ static void deactivate_task(struct rq *r
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, sleep);
-	dec_nr_running(rq);
+	dec_nr_running(p, rq);
 }
 
 /**
@@ -2609,7 +2246,7 @@ void wake_up_new_task(struct task_struct
 		 * management (if any):
 		 */
 		p->sched_class->task_new(rq, p);
-		inc_nr_running(rq);
+		inc_nr_running(p, rq);
 	}
 	check_preempt_curr(rq, p);
 #ifdef CONFIG_SMP
@@ -3600,12 +3237,9 @@ static int load_balance(int this_cpu, st
 	unsigned long imbalance;
 	struct rq *busiest;
 	unsigned long flags;
-	int unlock_aggregate;
 
 	cpus_setall(*cpus);
 
-	unlock_aggregate = get_aggregate(sd);
-
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
 	 * sibling can pick up load irrespective of busy siblings. In this case,
@@ -3721,9 +3355,8 @@ redo:
 
 	if (!ld_moved && !sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
 	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		ld_moved = -1;
-
-	goto out;
+		return -1;
+	return ld_moved;
 
 out_balanced:
 	schedstat_inc(sd, lb_balanced[idle]);
@@ -3738,13 +3371,8 @@ out_one_pinned:
 
 	if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
 	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		ld_moved = -1;
-	else
-		ld_moved = 0;
-out:
-	if (unlock_aggregate)
-		put_aggregate(sd);
-	return ld_moved;
+		return -1;
+	return 0;
 }
 
 /*
@@ -4955,8 +4583,10 @@ void set_user_nice(struct task_struct *p
 		goto out_unlock;
 	}
 	on_rq = p->se.on_rq;
-	if (on_rq)
+	if (on_rq) {
 		dequeue_task(rq, p, 0);
+		dec_load(rq, p);
+	}
 
 	p->static_prio = NICE_TO_PRIO(nice);
 	set_load_weight(p);
@@ -4966,6 +4596,7 @@ void set_user_nice(struct task_struct *p
 
 	if (on_rq) {
 		enqueue_task(rq, p, 0);
+		inc_load(rq, p);
 		/*
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
@@ -7339,7 +6970,6 @@ static int __build_sched_domains(const c
 			SD_INIT(sd, ALLNODES);
 			set_domain_attribute(sd, attr);
 			sd->span = *cpu_map;
-			sd->first_cpu = first_cpu(sd->span);
 			cpu_to_allnodes_group(i, cpu_map, &sd->groups, tmpmask);
 			p = sd;
 			sd_allnodes = 1;
@@ -7350,7 +6980,6 @@ static int __build_sched_domains(const c
 		SD_INIT(sd, NODE);
 		set_domain_attribute(sd, attr);
 		sched_domain_node_span(cpu_to_node(i), &sd->span);
-		sd->first_cpu = first_cpu(sd->span);
 		sd->parent = p;
 		if (p)
 			p->child = sd;
@@ -7362,7 +6991,6 @@ static int __build_sched_domains(const c
 		SD_INIT(sd, CPU);
 		set_domain_attribute(sd, attr);
 		sd->span = *nodemask;
-		sd->first_cpu = first_cpu(sd->span);
 		sd->parent = p;
 		if (p)
 			p->child = sd;
@@ -7374,7 +7002,6 @@ static int __build_sched_domains(const c
 		SD_INIT(sd, MC);
 		set_domain_attribute(sd, attr);
 		sd->span = cpu_coregroup_map(i);
-		sd->first_cpu = first_cpu(sd->span);
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
@@ -7387,7 +7014,6 @@ static int __build_sched_domains(const c
 		SD_INIT(sd, SIBLING);
 		set_domain_attribute(sd, attr);
 		sd->span = per_cpu(cpu_sibling_map, i);
-		sd->first_cpu = first_cpu(sd->span);
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
@@ -8057,7 +7683,6 @@ void __init sched_init(void)
 	}
 
 #ifdef CONFIG_SMP
-	init_aggregate();
 	init_defrootdomain();
 #endif
 
@@ -8622,11 +8247,14 @@ void sched_move_task(struct task_struct 
 #endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static void __set_se_shares(struct sched_entity *se, unsigned long shares)
+static void set_se_shares(struct sched_entity *se, unsigned long shares)
 {
 	struct cfs_rq *cfs_rq = se->cfs_rq;
+	struct rq *rq = cfs_rq->rq;
 	int on_rq;
 
+	spin_lock_irq(&rq->lock);
+
 	on_rq = se->on_rq;
 	if (on_rq)
 		dequeue_entity(cfs_rq, se, 0);
@@ -8636,17 +8264,8 @@ static void __set_se_shares(struct sched
 
 	if (on_rq)
 		enqueue_entity(cfs_rq, se, 0);
-}
 
-static void set_se_shares(struct sched_entity *se, unsigned long shares)
-{
-	struct cfs_rq *cfs_rq = se->cfs_rq;
-	struct rq *rq = cfs_rq->rq;
-	unsigned long flags;
-
-	spin_lock_irqsave(&rq->lock, flags);
-	__set_se_shares(se, shares);
-	spin_unlock_irqrestore(&rq->lock, flags);
+	spin_unlock_irq(&rq->lock);
 }
 
 static DEFINE_MUTEX(shares_mutex);
@@ -8685,13 +8304,8 @@ int sched_group_set_shares(struct task_g
 	 * w/o tripping rebalance_share or load_balance_fair.
 	 */
 	tg->shares = shares;
-	for_each_possible_cpu(i) {
-		/*
-		 * force a rebalance
-		 */
-		cfs_rq_set_shares(tg->cfs_rq[i], 0);
+	for_each_possible_cpu(i)
 		set_se_shares(tg->se[i], shares);
-	}
 
 	/*
 	 * Enable load balance activity on this group, by inserting it back on
Index: linux-2.6.26.git/kernel/sched_fair.c
===================================================================
--- linux-2.6.26.git.orig/kernel/sched_fair.c
+++ linux-2.6.26.git/kernel/sched_fair.c
@@ -541,27 +541,10 @@ update_stats_curr_start(struct cfs_rq *c
  * Scheduling class queueing methods:
  */
 
-#if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
-static void
-add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long weight)
-{
-	cfs_rq->task_weight += weight;
-}
-#else
-static inline void
-add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long weight)
-{
-}
-#endif
-
 static void
 account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	update_load_add(&cfs_rq->load, se->load.weight);
-	if (!parent_entity(se))
-		inc_cpu_load(rq_of(cfs_rq), se->load.weight);
-	if (entity_is_task(se))
-		add_cfs_task_weight(cfs_rq, se->load.weight);
 	cfs_rq->nr_running++;
 	se->on_rq = 1;
 	list_add(&se->group_node, &cfs_rq->tasks);
@@ -571,10 +554,6 @@ static void
 account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	update_load_sub(&cfs_rq->load, se->load.weight);
-	if (!parent_entity(se))
-		dec_cpu_load(rq_of(cfs_rq), se->load.weight);
-	if (entity_is_task(se))
-		add_cfs_task_weight(cfs_rq, -se->load.weight);
 	cfs_rq->nr_running--;
 	se->on_rq = 0;
 	list_del_init(&se->group_node);
@@ -1366,90 +1345,75 @@ static struct task_struct *load_balance_
 	return __load_balance_iterator(cfs_rq, cfs_rq->balance_iterator);
 }
 
-static unsigned long
-__load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		unsigned long max_load_move, struct sched_domain *sd,
-		enum cpu_idle_type idle, int *all_pinned, int *this_best_prio,
-		struct cfs_rq *cfs_rq)
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static int cfs_rq_best_prio(struct cfs_rq *cfs_rq)
 {
-	struct rq_iterator cfs_rq_iterator;
+	struct sched_entity *curr;
+	struct task_struct *p;
 
-	cfs_rq_iterator.start = load_balance_start_fair;
-	cfs_rq_iterator.next = load_balance_next_fair;
-	cfs_rq_iterator.arg = cfs_rq;
+	if (!cfs_rq->nr_running || !first_fair(cfs_rq))
+		return MAX_PRIO;
+
+	curr = cfs_rq->curr;
+	if (!curr)
+		curr = __pick_next_entity(cfs_rq);
 
-	return balance_tasks(this_rq, this_cpu, busiest,
-			max_load_move, sd, idle, all_pinned,
-			this_best_prio, &cfs_rq_iterator);
+	p = task_of(curr);
+
+	return p->prio;
 }
+#endif
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
 static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
 		  int *all_pinned, int *this_best_prio)
 {
+	struct cfs_rq *busy_cfs_rq;
 	long rem_load_move = max_load_move;
-	int busiest_cpu = cpu_of(busiest);
-	struct task_group *tg;
-
-	rcu_read_lock();
-	list_for_each_entry(tg, &task_groups, list) {
-		long imbalance;
-		unsigned long this_weight, busiest_weight;
-		long rem_load, max_load, moved_load;
-
-		/*
-		 * empty group
-		 */
-		if (!aggregate(tg, sd)->task_weight)
-			continue;
-
-		rem_load = rem_load_move * aggregate(tg, sd)->rq_weight;
-		rem_load /= aggregate(tg, sd)->load + 1;
-
-		this_weight = tg->cfs_rq[this_cpu]->task_weight;
-		busiest_weight = tg->cfs_rq[busiest_cpu]->task_weight;
+	struct rq_iterator cfs_rq_iterator;
 
-		imbalance = (busiest_weight - this_weight) / 2;
+	cfs_rq_iterator.start = load_balance_start_fair;
+	cfs_rq_iterator.next = load_balance_next_fair;
 
-		if (imbalance < 0)
-			imbalance = busiest_weight;
+	for_each_leaf_cfs_rq(busiest, busy_cfs_rq) {
+#ifdef CONFIG_FAIR_GROUP_SCHED
+		struct cfs_rq *this_cfs_rq;
+		long imbalance;
+		unsigned long maxload;
 
-		max_load = max(rem_load, imbalance);
-		moved_load = __load_balance_fair(this_rq, this_cpu, busiest,
-				max_load, sd, idle, all_pinned, this_best_prio,
-				tg->cfs_rq[busiest_cpu]);
+		this_cfs_rq = cpu_cfs_rq(busy_cfs_rq, this_cpu);
 
-		if (!moved_load)
+		imbalance = busy_cfs_rq->load.weight - this_cfs_rq->load.weight;
+		/* Don't pull if this_cfs_rq has more load than busy_cfs_rq */
+		if (imbalance <= 0)
 			continue;
 
-		move_group_shares(tg, sd, busiest_cpu, this_cpu);
+		/* Don't pull more than imbalance/2 */
+		imbalance /= 2;
+		maxload = min(rem_load_move, imbalance);
 
-		moved_load *= aggregate(tg, sd)->load;
-		moved_load /= aggregate(tg, sd)->rq_weight + 1;
+		*this_best_prio = cfs_rq_best_prio(this_cfs_rq);
+#else
+# define maxload rem_load_move
+#endif
+		/*
+		 * pass busy_cfs_rq argument into
+		 * load_balance_[start|next]_fair iterators
+		 */
+		cfs_rq_iterator.arg = busy_cfs_rq;
+		rem_load_move -= balance_tasks(this_rq, this_cpu, busiest,
+					       maxload, sd, idle, all_pinned,
+					       this_best_prio,
+					       &cfs_rq_iterator);
 
-		rem_load_move -= moved_load;
-		if (rem_load_move < 0)
+		if (rem_load_move <= 0)
 			break;
 	}
-	rcu_read_unlock();
 
 	return max_load_move - rem_load_move;
 }
-#else
-static unsigned long
-load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		  unsigned long max_load_move,
-		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned, int *this_best_prio)
-{
-	return __load_balance_fair(this_rq, this_cpu, busiest,
-			max_load_move, sd, idle, all_pinned,
-			this_best_prio, &busiest->cfs);
-}
-#endif
 
 static int
 move_one_task_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
Index: linux-2.6.26.git/kernel/sched_rt.c
===================================================================
--- linux-2.6.26.git.orig/kernel/sched_rt.c
+++ linux-2.6.26.git/kernel/sched_rt.c
@@ -513,8 +513,6 @@ static void enqueue_task_rt(struct rq *r
 	 */
 	for_each_sched_rt_entity(rt_se)
 		enqueue_rt_entity(rt_se);
-
-	inc_cpu_load(rq, p->se.load.weight);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
@@ -534,8 +532,6 @@ static void dequeue_task_rt(struct rq *r
 		if (rt_rq && rt_rq->rt_nr_running)
 			enqueue_rt_entity(rt_se);
 	}
-
-	dec_cpu_load(rq, p->se.load.weight);
 }
 
 /*
Index: linux-2.6.26.git/kernel/sched_debug.c
===================================================================
--- linux-2.6.26.git.orig/kernel/sched_debug.c
+++ linux-2.6.26.git/kernel/sched_debug.c
@@ -169,7 +169,7 @@ void print_cfs_rq(struct seq_file *m, in
 			cfs_rq->nr_spread_over);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_SMP
-	SEQ_printf(m, "  .%-30s: %lu\n", "shares", cfs_rq->shares);
+	SEQ_printf(m, "  .%-30s: %lu\n", "shares", cfs_rq->tg->shares);
 #endif
 #endif
 }


--=-VaE9fwpuDRDJ4lboMhl4
Content-Disposition: attachment; filename=yy.pdf
Content-Type: application/pdf; name=yy.pdf
Content-Transfer-Encoding: base64

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
ZykpnT4x6gJ83jgxmhMu7Ra0adHscGnUUDaz/ADA9yoQGqXru4FMj4rruyk+nJNumVneDcmsud1/
iACQaGlV+6aKA5RMjML6aOjGcvaI3FAe1dZ3q2R6+QEKEysqKqJ5pWXlDKsinBqtYf8EfHVqRTSb
FbakVpDS6IQbov7QxPClPrNaZ7W2tg6GHMhIL45eXlwdHVlcVXQeLrS2XdS/Ld6XXNgEYRyWwyaV
+ytYCoejvmgIGYKd9F76xDxvPWBiDCqbNrE0apyGqWxmNCWElRewkosVa2gi6uX/BwIfYKoKZW5k
c3RyZWFtCmVuZG9iagoKMTMgMCBvYmoKMTExMDAKZW5kb2JqCgoxNCAwIG9iago8PC9UeXBlL0Zv
bnREZXNjcmlwdG9yL0ZvbnROYW1lL0JBQUFBQStBbGJhbnlBTVQKL0ZsYWdzIDQKL0ZvbnRCQm94
Wy0yMjIgLTMwNiAxMDcyIDEwMzddL0l0YWxpY0FuZ2xlIDAKL0FzY2VudCA5MDUKL0Rlc2NlbnQg
LTIxMQovQ2FwSGVpZ2h0IDEwMzcKL1N0ZW1WIDgwCi9Gb250RmlsZTIgMTIgMCBSPj4KZW5kb2Jq
CgoxNSAwIG9iago8PC9MZW5ndGggMzc0L0ZpbHRlci9GbGF0ZURlY29kZT4+CnN0cmVhbQp4nF2S
zW6DMAyA7zxFjt2hgoS/VkJIHS0Sh/1obA9AiemQRkCBHnj7xTbbpB1AXxLb+ZLYL6pzZfrFf7Vj
W8Miut5oC/N4ty2IK9x640kldN8u24j+7dBMnu9y63VeYKhMN2aZ57+5tXmxq9id9HiFB89/sRps
b25i91HUblzfp+kLBjCLCLw8Fxo6V+epmZ6bAXzK2lfaLffLuncpfwHv6wRC0ViySjtqmKemBduY
G3hZEOQiK8vcA6P/rYURp1y79rOxLlS60CCIw9yxIk4OyCFzjBwRpxFyTBxK5IRzA+SU42n+wJwi
H4kVxZw4VyE/MlPNgpn2PTMnyBdmciu5zsWxDHge3ST7p1hTsn+Ke0n2D9FBsn94RN78KYb9E5rf
/Kk++6szMvtH6CDZPymQ2T+lefaPyYH9EzyXZH9VIrN/jD6K/VO8K7X541nUdv8hPdz2QviE2GM/
rSHau7WuLagRqR+wE3oDv706jRNm0fcNt466eAplbmRzdHJlYW0KZW5kb2JqCgoxNiAwIG9iago8
PC9UeXBlL0ZvbnQvU3VidHlwZS9UcnVlVHlwZS9CYXNlRm9udC9CQUFBQUErQWxiYW55QU1UCi9G
aXJzdENoYXIgMAovTGFzdENoYXIgMzQKL1dpZHRoc1s3NTAgNjY2IDU1NiA1NTYgMjc3IDU1NiA2
NjYgNTU2IDU1NiAyNzcgNTU2IDU1NiA1NTYgNTU2IDU1NiAyNzcKNTU2IDMzMyA1NTYgNTU2IDU1
NiA1NTYgMjIyIDU1NiAzMzMgNzIyIDIyMiA1MDAgNzIyIDU1NiAyNzcgOTQzCjU1NiA1NTYgNTAw
IF0KL0ZvbnREZXNjcmlwdG9yIDE0IDAgUgovVG9Vbmljb2RlIDE1IDAgUgo+PgplbmRvYmoKCjE3
IDAgb2JqCjw8L0YxIDE2IDAgUgo+PgplbmRvYmoKCjE4IDAgb2JqCjw8L0ZvbnQgMTcgMCBSCi9Q
cm9jU2V0Wy9QREYvVGV4dF0KPj4KZW5kb2JqCgoxIDAgb2JqCjw8L1R5cGUvUGFnZS9QYXJlbnQg
MTEgMCBSL1Jlc291cmNlcyAxOCAwIFIvTWVkaWFCb3hbMCAwIDc5MiA2MTJdL1N0cnVjdFBhcmVu
dHMgMAovR3JvdXA8PC9TL1RyYW5zcGFyZW5jeS9DUy9EZXZpY2VSR0IvSSB0cnVlPj4vQ29udGVu
dHMgMiAwIFI+PgplbmRvYmoKCjE5IDAgb2JqCjw8L0NvdW50IDEvRmlyc3QgMjAgMCBSL0xhc3Qg
MjAgMCBSCj4+CmVuZG9iagoKMjAgMCBvYmoKPDwvQ291bnQgMC9UaXRsZTxGRUZGMDA1MzAwNjgw
MDY1MDA2NTAwNzQwMDMxPgovRGVzdFsxIDAgUi9YWVogMCA2MTIgMF0vUGFyZW50IDE5IDAgUj4+
CmVuZG9iagoKNCAwIG9iago8PC9UeXBlL1N0cnVjdEVsZW0KL1MvUAovUCAyMSAwIFIKL1BnIDEg
MCBSCi9LWzAgXQo+PgplbmRvYmoKCjUgMCBvYmoKPDwvVHlwZS9TdHJ1Y3RFbGVtCi9TL1AKL1Ag
MjEgMCBSCi9QZyAxIDAgUgovS1sxIF0KPj4KZW5kb2JqCgo2IDAgb2JqCjw8L1R5cGUvU3RydWN0
RWxlbQovUy9QCi9QIDIxIDAgUgovUGcgMSAwIFIKL0tbMiBdCj4+CmVuZG9iagoKNyAwIG9iago8
PC9UeXBlL1N0cnVjdEVsZW0KL1MvUAovUCAyMSAwIFIKL1BnIDEgMCBSCi9LWzMgXQo+PgplbmRv
YmoKCjggMCBvYmoKPDwvVHlwZS9TdHJ1Y3RFbGVtCi9TL1AKL1AgMjEgMCBSCi9QZyAxIDAgUgov
S1s0IF0KPj4KZW5kb2JqCgo5IDAgb2JqCjw8L1R5cGUvU3RydWN0RWxlbQovUy9QCi9QIDIxIDAg
UgovUGcgMSAwIFIKL0tbNSBdCj4+CmVuZG9iagoKMTAgMCBvYmoKPDwvVHlwZS9TdHJ1Y3RFbGVt
Ci9TL1AKL1AgMjEgMCBSCi9QZyAxIDAgUgovS1s2IF0KPj4KZW5kb2JqCgoyMSAwIG9iago8PC9U
eXBlL1N0cnVjdFRyZWVSb290Ci9QYXJlbnRUcmVlIDIyIDAgUgovS1s0IDAgUiA1IDAgUiA2IDAg
UiA3IDAgUiA4IDAgUiA5IDAgUiAxMCAwIFIgXQo+PgplbmRvYmoKCjIyIDAgb2JqCjw8L051bXNb
CjAgWyA0IDAgUiA1IDAgUiA2IDAgUiA3IDAgUiA4IDAgUiA5IDAgUiAxMCAwIFIgXQpdPj4KZW5k
b2JqCgoxMSAwIG9iago8PC9UeXBlL1BhZ2VzCi9SZXNvdXJjZXMgMTggMCBSCi9NZWRpYUJveFsg
MCAwIDU5NSA4NDIgXQovS2lkc1sgMSAwIFIgXQovQ291bnQgMT4+CmVuZG9iagoKMjMgMCBvYmoK
PDwvVHlwZS9DYXRhbG9nL1BhZ2VzIDExIDAgUgovT3BlbkFjdGlvblsxIDAgUiAvWFlaIG51bGwg
bnVsbCAwXQovT3V0bGluZXMgMTkgMCBSCi9TdHJ1Y3RUcmVlUm9vdCAyMSAwIFIKL01hcmtJbmZv
PDwvTWFya2VkIHRydWU+Pgo+PgplbmRvYmoKCjI0IDAgb2JqCjw8L0NyZWF0b3I8RkVGRjAwNDMw
MDYxMDA2QzAwNjM+Ci9Qcm9kdWNlcjxGRUZGMDA0RjAwNzAwMDY1MDA2RTAwNEYwMDY2MDA2NjAw
NjkwMDYzMDA2NTAwMkUwMDZGMDA3MjAwNjcwMDIwMDAzMjAwMkUwMDMzPgovQ3JlYXRpb25EYXRl
KEQ6MjAwODA1MDkxMTQyMzArMDInMDAnKT4+CmVuZG9iagoKeHJlZgowIDI1CjAwMDAwMDAwMDAg
NjU1MzUgZiAKMDAwMDAxNDk2MyAwMDAwMCBuIAowMDAwMDAwMDE5IDAwMDAwIG4gCjAwMDAwMDI3
MTUgMDAwMDAgbiAKMDAwMDAxNTI4NSAwMDAwMCBuIAowMDAwMDE1MzU1IDAwMDAwIG4gCjAwMDAw
MTU0MjUgMDAwMDAgbiAKMDAwMDAxNTQ5NSAwMDAwMCBuIAowMDAwMDE1NTY1IDAwMDAwIG4gCjAw
MDAwMTU2MzUgMDAwMDAgbiAKMDAwMDAxNTcwNSAwMDAwMCBuIAowMDAwMDE1OTY1IDAwMDAwIG4g
CjAwMDAwMDI3MzYgMDAwMDAgbiAKMDAwMDAxMzkyMyAwMDAwMCBuIAowMDAwMDEzOTQ2IDAwMDAw
IG4gCjAwMDAwMTQxMzggMDAwMDAgbiAKMDAwMDAxNDU4MiAwMDAwMCBuIAowMDAwMDE0ODc1IDAw
MDAwIG4gCjAwMDAwMTQ5MDggMDAwMDAgbiAKMDAwMDAxNTEyNCAwMDAwMCBuIAowMDAwMDE1MTgw
IDAwMDAwIG4gCjAwMDAwMTU3NzYgMDAwMDAgbiAKMDAwMDAxNTg4NiAwMDAwMCBuIAowMDAwMDE2
MDY1IDAwMDAwIG4gCjAwMDAwMTYyMTYgMDAwMDAgbiAKdHJhaWxlcgo8PC9TaXplIDI1L1Jvb3Qg
MjMgMCBSCi9JbmZvIDI0IDAgUgovSUQgWyA8OTIyOTUwRDdDQTk5MDgyMUU2NTk1RkU4MkI0OURG
RTg+Cjw5MjI5NTBEN0NBOTkwODIxRTY1OTVGRTgyQjQ5REZFOD4gXQovRG9jQ2hlY2tzdW0gLzdF
MTkzMUE4NUM1RDhGMzMzNTlCNTQyNzJGQTk3NzMyCj4+CnN0YXJ0eHJlZgoxNjM5NQolJUVPRgo=


--=-VaE9fwpuDRDJ4lboMhl4--


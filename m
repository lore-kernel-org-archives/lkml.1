Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbYEGJeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbYEGJeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 05:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYEGJeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 05:34:14 -0400
Received: from mga07.intel.com ([143.182.124.22]:40982 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751138AbYEGJeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 05:34:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,447,1204531200"; 
   d="scan'208";a="243192887"
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080507091748.GB30645@elte.hu>
References: <1210039590.3453.18.camel@ymzhang>
	 <20080507091748.GB30645@elte.hu>
Content-Type: multipart/mixed; boundary="=-ZpdyJKgXvm7e341G7Kl5"
Date: Wed, 07 May 2008 17:33:03 +0800
Message-Id: <1210152783.3453.82.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZpdyJKgXvm7e341G7Kl5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On Wed, 2008-05-07 at 11:17 +0200, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > Comparing with 2.6.25, volanoMark has big regression with kernel 
> > 2.6.26-rc1. It's about 50% on my 8-core stoakley, 16-core tigerton, 
> > and Itanium Montecito.
> > 
> > With bisect, I located below patch.
> 
> thanks Yanmin, i've queued up your patch that reverts this change.
﻿
Sorry. The reverting patch has a comment-out block. I need delete it if you queue the
patch officially.


--=-ZpdyJKgXvm7e341G7Kl5
Content-Disposition: attachment; filename=revert_smpnice.patch
Content-Type: text/x-patch; name=revert_smpnice.patch; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

diff -Nraup linux-2.6.26-rc1/include/linux/sched.h linux-2.6.26-rc1_smpnice/include/linux/sched.h
--- linux-2.6.26-rc1/include/linux/sched.h	2008-05-06 06:27:56.000000000 +0800
+++ linux-2.6.26-rc1_smpnice/include/linux/sched.h	2008-05-06 02:16:33.000000000 +0800
@@ -764,7 +764,6 @@ struct sched_domain {
 	struct sched_domain *child;	/* bottom domain must be null terminated */
 	struct sched_group *groups;	/* the balancing groups of the domain */
 	cpumask_t span;			/* span of all CPUs in this domain */
-	int first_cpu;			/* cache of the first cpu in this domain */
 	unsigned long min_interval;	/* Minimum balance interval ms */
 	unsigned long max_interval;	/* Maximum balance interval ms */
 	unsigned int busy_factor;	/* less balancing by factor if busy */
diff -Nraup linux-2.6.26-rc1/kernel/sched.c linux-2.6.26-rc1_smpnice/kernel/sched.c
--- linux-2.6.26-rc1/kernel/sched.c	2008-05-06 06:27:56.000000000 +0800
+++ linux-2.6.26-rc1_smpnice/kernel/sched.c	2008-05-06 02:20:45.000000000 +0800
@@ -318,8 +318,6 @@ static DEFINE_MUTEX(doms_cur_mutex);
 # define INIT_TASK_GROUP_LOAD	NICE_0_LOAD
 #endif
 
-#define MIN_SHARES	2
-
 static int init_task_group_load = INIT_TASK_GROUP_LOAD;
 #endif
 
@@ -411,43 +409,6 @@ struct cfs_rq {
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
 
@@ -1551,347 +1512,11 @@ static void cpuacct_charge(struct task_s
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
@@ -1904,14 +1529,26 @@ static void cfs_rq_set_shares(struct cfs
 
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
@@ -2003,7 +1640,7 @@ static void activate_task(struct rq *rq,
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, wakeup);
-	inc_nr_running(rq);
+	inc_nr_running(p, rq);
 }
 
 /*
@@ -2015,7 +1652,7 @@ static void deactivate_task(struct rq *r
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, sleep);
-	dec_nr_running(rq);
+	dec_nr_running(p, rq);
 }
 
 /**
@@ -2668,7 +2305,7 @@ void wake_up_new_task(struct task_struct
 		 * management (if any):
 		 */
 		p->sched_class->task_new(rq, p);
-		inc_nr_running(rq);
+		inc_nr_running(p, rq);
 	}
 	check_preempt_curr(rq, p);
 #ifdef CONFIG_SMP
@@ -3659,12 +3296,9 @@ static int load_balance(int this_cpu, st
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
@@ -3780,9 +3414,8 @@ redo:
 
 	if (!ld_moved && !sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
 	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		ld_moved = -1;
-
-	goto out;
+		return -1;
+	return ld_moved;
 
 out_balanced:
 	schedstat_inc(sd, lb_balanced[idle]);
@@ -3797,13 +3430,8 @@ out_one_pinned:
 
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
@@ -5018,8 +4646,10 @@ void set_user_nice(struct task_struct *p
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
@@ -5029,6 +4659,7 @@ void set_user_nice(struct task_struct *p
 
 	if (on_rq) {
 		enqueue_task(rq, p, 0);
+		inc_load(rq, p);
 		/*
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
@@ -7402,7 +7033,6 @@ static int __build_sched_domains(const c
 			SD_INIT(sd, ALLNODES);
 			set_domain_attribute(sd, attr);
 			sd->span = *cpu_map;
-			sd->first_cpu = first_cpu(sd->span);
 			cpu_to_allnodes_group(i, cpu_map, &sd->groups, tmpmask);
 			p = sd;
 			sd_allnodes = 1;
@@ -7413,7 +7043,6 @@ static int __build_sched_domains(const c
 		SD_INIT(sd, NODE);
 		set_domain_attribute(sd, attr);
 		sched_domain_node_span(cpu_to_node(i), &sd->span);
-		sd->first_cpu = first_cpu(sd->span);
 		sd->parent = p;
 		if (p)
 			p->child = sd;
@@ -7425,7 +7054,6 @@ static int __build_sched_domains(const c
 		SD_INIT(sd, CPU);
 		set_domain_attribute(sd, attr);
 		sd->span = *nodemask;
-		sd->first_cpu = first_cpu(sd->span);
 		sd->parent = p;
 		if (p)
 			p->child = sd;
@@ -7437,7 +7065,6 @@ static int __build_sched_domains(const c
 		SD_INIT(sd, MC);
 		set_domain_attribute(sd, attr);
 		sd->span = cpu_coregroup_map(i);
-		sd->first_cpu = first_cpu(sd->span);
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
@@ -7450,7 +7077,6 @@ static int __build_sched_domains(const c
 		SD_INIT(sd, SIBLING);
 		set_domain_attribute(sd, attr);
 		sd->span = per_cpu(cpu_sibling_map, i);
-		sd->first_cpu = first_cpu(sd->span);
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
@@ -8115,7 +7741,6 @@ void __init sched_init(void)
 	}
 
 #ifdef CONFIG_SMP
-	init_aggregate();
 	init_defrootdomain();
 #endif
 
@@ -8682,11 +8307,14 @@ void sched_move_task(struct task_struct 
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
@@ -8696,17 +8324,8 @@ static void __set_se_shares(struct sched
 
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
@@ -8727,8 +8346,8 @@ int sched_group_set_shares(struct task_g
 	 * (The default weight is 1024 - so there's no practical
 	 *  limitation from this.)
 	 */
-	if (shares < MIN_SHARES)
-		shares = MIN_SHARES;
+	if (shares < 2)
+		shares = 2;
 
 	mutex_lock(&shares_mutex);
 	if (tg->shares == shares)
@@ -8748,13 +8367,8 @@ int sched_group_set_shares(struct task_g
 	 * w/o tripping rebalance_share or load_balance_fair.
 	 */
 	tg->shares = shares;
-	for_each_possible_cpu(i) {
-		/*
-		 * force a rebalance
-		 */
-		cfs_rq_set_shares(tg->cfs_rq[i], 0);
-		set_se_shares(tg->se[i], shares/nr_cpu_ids);
-	}
+	for_each_possible_cpu(i)
+		set_se_shares(tg->se[i], shares);
 
 	/*
 	 * Enable load balance activity on this group, by inserting it back on
diff -Nraup linux-2.6.26-rc1/kernel/sched_debug.c linux-2.6.26-rc1_smpnice/kernel/sched_debug.c
--- linux-2.6.26-rc1/kernel/sched_debug.c	2008-05-06 06:27:56.000000000 +0800
+++ linux-2.6.26-rc1_smpnice/kernel/sched_debug.c	2008-05-07 10:35:08.000000000 +0800
@@ -167,11 +167,6 @@ void print_cfs_rq(struct seq_file *m, in
 #endif
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_spread_over",
 			cfs_rq->nr_spread_over);
-#ifdef CONFIG_FAIR_GROUP_SCHED
-#ifdef CONFIG_SMP
-	SEQ_printf(m, "  .%-30s: %lu\n", "shares", cfs_rq->shares);
-#endif
-#endif
 }
 
 static void print_cpu(struct seq_file *m, int cpu)
diff -Nraup linux-2.6.26-rc1/kernel/sched_fair.c linux-2.6.26-rc1_smpnice/kernel/sched_fair.c
--- linux-2.6.26-rc1/kernel/sched_fair.c	2008-05-06 06:27:56.000000000 +0800
+++ linux-2.6.26-rc1_smpnice/kernel/sched_fair.c	2008-05-06 02:16:33.000000000 +0800
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
@@ -1359,90 +1338,75 @@ static struct task_struct *load_balance_
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
diff -Nraup linux-2.6.26-rc1/kernel/sched_rt.c linux-2.6.26-rc1_smpnice/kernel/sched_rt.c
--- linux-2.6.26-rc1/kernel/sched_rt.c	2008-05-06 06:27:56.000000000 +0800
+++ linux-2.6.26-rc1_smpnice/kernel/sched_rt.c	2008-05-06 02:16:33.000000000 +0800
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

--=-ZpdyJKgXvm7e341G7Kl5--


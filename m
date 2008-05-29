Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbYE2PqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbYE2PqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbYE2PqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:46:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47619 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbYE2PqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:46:12 -0400
Date: Thu, 29 May 2008 17:45:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: [git pull] scheduler fixes
Message-ID: <20080529154552.GA10376@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest sched-fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

this fixes scheduler related sysbench (and other benchmarks)
performance regressions. The sysbench throughput results compared to 
2.6.24-rc4 are:

                          [tx/sec, higher is better]

                 .26-rc4        .26-rc4+sched-fixes
  -------------------------------------------------
      1:             687              727    +5.43%
      2:            1460             1480    +1.34%
      4:            2911             3080    +5.49%
      8:            5496             5932    +7.35%
     16:           10049            10822    +7.14%
     32:            7598            10082   +24.64%
     64:            7958             9331   +14.71%
    128:            8169             8574    +4.73%
    256:            8398             8469    +0.84%
  -------------------------------------------------
    SUM:           52730            58501    +9.86%

with these fixes applied 2.6.26 is a net improvement over 2.6.25:

                     .25        .26-rc4+sched-fixes
  -------------------------------------------------
      1:             701              727    +3.47%
      2:            1484             1480    -0.23%
      4:            3050             3080    +0.96%
      8:            5918             5932    +0.24%
     16:           10794            10822    +0.26%
     32:           10082            10082    -0.01%
     64:            8894             9331    +4.68%
    128:            7685             8574   +10.38%
    256:            5258             8469   +37.92%
  -------------------------------------------------
    SUM:           53870            58501    +7.92%

the group balancing revert makes the linecount rather large, but
it was a relatively straightforward (albeit not automatic) revert.

it is a bit late because i was hoping for these patches from Peter
to work out:

   http://programming.kicks-ass.net/kernel-patches/sched-smp-group-fixes/

but they ended up being more risky than the revert, so we'll go for the
revert for 2.6.26. Thanks to Peter and Mike for sorting out these issues.

	Ingo

------------------>
Adrian Bunk (1):
      show_schedstat(): fix memleak

Ingo Molnar (4):
      revert ("sched: fair: weight calculations")
      sched: cleanup
      revert ("sched: fair-group: SMP-nice for group scheduling")
      sched: re-tune NUMA topologies

Mike Galbraith (1):
      sched: stop wake_affine from causing serious imbalance

Peter Zijlstra (1):
      sched: fix sched_clock_cpu()

Roel Kluin (1):
      sched: unite unlikely pairs in rt_policy() and schedule_debug()

 include/linux/sched.h    |    1 -
 include/linux/topology.h |    4 +-
 kernel/sched.c           |  447 +++++-----------------------------------------
 kernel/sched_clock.c     |   18 ++-
 kernel/sched_debug.c     |    5 -
 kernel/sched_fair.c      |  254 ++++++++++-----------------
 kernel/sched_rt.c        |    4 -
 kernel/sched_stats.h     |    1 +
 8 files changed, 150 insertions(+), 584 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3e05e54..ae0be3c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -766,7 +766,6 @@ struct sched_domain {
 	struct sched_domain *child;	/* bottom domain must be null terminated */
 	struct sched_group *groups;	/* the balancing groups of the domain */
 	cpumask_t span;			/* span of all CPUs in this domain */
-	int first_cpu;			/* cache of the first cpu in this domain */
 	unsigned long min_interval;	/* Minimum balance interval ms */
 	unsigned long max_interval;	/* Maximum balance interval ms */
 	unsigned int busy_factor;	/* less balancing by factor if busy */
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 4bb7074..24f3d22 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -166,7 +166,9 @@ void arch_update_cpu_topology(void);
 	.busy_idx		= 3,			\
 	.idle_idx		= 3,			\
 	.flags			= SD_LOAD_BALANCE	\
-				| SD_SERIALIZE,	\
+				| SD_BALANCE_NEWIDLE	\
+				| SD_WAKE_AFFINE	\
+				| SD_SERIALIZE,		\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 64,			\
 }
diff --git a/kernel/sched.c b/kernel/sched.c
index cfa222a..bfb8ad8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -136,7 +136,7 @@ static inline void sg_inc_cpu_power(struct sched_group *sg, u32 val)
 
 static inline int rt_policy(int policy)
 {
-	if (unlikely(policy == SCHED_FIFO) || unlikely(policy == SCHED_RR))
+	if (unlikely(policy == SCHED_FIFO || policy == SCHED_RR))
 		return 1;
 	return 0;
 }
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
 
@@ -1368,9 +1331,6 @@ static void __resched_task(struct task_struct *p, int tif_bit)
  */
 #define SRR(x, y) (((x) + (1UL << ((y) - 1))) >> (y))
 
-/*
- * delta *= weight / lw
- */
 static unsigned long
 calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 		struct load_weight *lw)
@@ -1393,6 +1353,12 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 	return (unsigned long)min(tmp, (u64)(unsigned long)LONG_MAX);
 }
 
+static inline unsigned long
+calc_delta_fair(unsigned long delta_exec, struct load_weight *lw)
+{
+	return calc_delta_mine(delta_exec, NICE_0_LOAD, lw);
+}
+
 static inline void update_load_add(struct load_weight *lw, unsigned long inc)
 {
 	lw->weight += inc;
@@ -1505,326 +1471,6 @@ static unsigned long source_load(int cpu, int type);
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
 #else /* CONFIG_SMP */
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -1845,14 +1491,26 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 
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
@@ -1944,7 +1602,7 @@ static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, wakeup);
-	inc_nr_running(rq);
+	inc_nr_running(p, rq);
 }
 
 /*
@@ -1956,7 +1614,7 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, sleep);
-	dec_nr_running(rq);
+	dec_nr_running(p, rq);
 }
 
 /**
@@ -2609,7 +2267,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 		 * management (if any):
 		 */
 		p->sched_class->task_new(rq, p);
-		inc_nr_running(rq);
+		inc_nr_running(p, rq);
 	}
 	check_preempt_curr(rq, p);
 #ifdef CONFIG_SMP
@@ -3600,12 +3258,9 @@ static int load_balance(int this_cpu, struct rq *this_rq,
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
@@ -3721,9 +3376,8 @@ redo:
 
 	if (!ld_moved && !sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
 	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		ld_moved = -1;
-
-	goto out;
+		return -1;
+	return ld_moved;
 
 out_balanced:
 	schedstat_inc(sd, lb_balanced[idle]);
@@ -3738,13 +3392,8 @@ out_one_pinned:
 
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
@@ -4430,7 +4079,7 @@ static inline void schedule_debug(struct task_struct *prev)
 	 * schedule() atomically, we ignore that path for now.
 	 * Otherwise, whine if we are scheduling when we should not be.
 	 */
-	if (unlikely(in_atomic_preempt_off()) && unlikely(!prev->exit_state))
+	if (unlikely(in_atomic_preempt_off() && !prev->exit_state))
 		__schedule_bug(prev);
 
 	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
@@ -4931,8 +4580,10 @@ void set_user_nice(struct task_struct *p, long nice)
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
@@ -4942,6 +4593,7 @@ void set_user_nice(struct task_struct *p, long nice)
 
 	if (on_rq) {
 		enqueue_task(rq, p, 0);
+		inc_load(rq, p);
 		/*
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
@@ -7316,7 +6968,6 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 			SD_INIT(sd, ALLNODES);
 			set_domain_attribute(sd, attr);
 			sd->span = *cpu_map;
-			sd->first_cpu = first_cpu(sd->span);
 			cpu_to_allnodes_group(i, cpu_map, &sd->groups, tmpmask);
 			p = sd;
 			sd_allnodes = 1;
@@ -7327,7 +6978,6 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 		SD_INIT(sd, NODE);
 		set_domain_attribute(sd, attr);
 		sched_domain_node_span(cpu_to_node(i), &sd->span);
-		sd->first_cpu = first_cpu(sd->span);
 		sd->parent = p;
 		if (p)
 			p->child = sd;
@@ -7339,7 +6989,6 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 		SD_INIT(sd, CPU);
 		set_domain_attribute(sd, attr);
 		sd->span = *nodemask;
-		sd->first_cpu = first_cpu(sd->span);
 		sd->parent = p;
 		if (p)
 			p->child = sd;
@@ -7351,7 +7000,6 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 		SD_INIT(sd, MC);
 		set_domain_attribute(sd, attr);
 		sd->span = cpu_coregroup_map(i);
-		sd->first_cpu = first_cpu(sd->span);
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
@@ -7364,7 +7012,6 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 		SD_INIT(sd, SIBLING);
 		set_domain_attribute(sd, attr);
 		sd->span = per_cpu(cpu_sibling_map, i);
-		sd->first_cpu = first_cpu(sd->span);
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
@@ -7568,8 +7215,8 @@ static int build_sched_domains(const cpumask_t *cpu_map)
 
 static cpumask_t *doms_cur;	/* current sched domains */
 static int ndoms_cur;		/* number of sched domains in 'doms_cur' */
-static struct sched_domain_attr *dattr_cur;	/* attribues of custom domains
-						   in 'doms_cur' */
+static struct sched_domain_attr *dattr_cur;
+				/* attribues of custom domains in 'doms_cur' */
 
 /*
  * Special case: If a kmalloc of a doms_cur partition (array of
@@ -8034,7 +7681,6 @@ void __init sched_init(void)
 	}
 
 #ifdef CONFIG_SMP
-	init_aggregate();
 	init_defrootdomain();
 #endif
 
@@ -8599,11 +8245,14 @@ void sched_move_task(struct task_struct *tsk)
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
@@ -8613,17 +8262,8 @@ static void __set_se_shares(struct sched_entity *se, unsigned long shares)
 
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
@@ -8662,13 +8302,8 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
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
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index 9c597e3..ce05271 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -59,22 +59,26 @@ static inline struct sched_clock_data *cpu_sdc(int cpu)
 	return &per_cpu(sched_clock_data, cpu);
 }
 
+static __read_mostly int sched_clock_running;
+
 void sched_clock_init(void)
 {
 	u64 ktime_now = ktime_to_ns(ktime_get());
-	u64 now = 0;
+	unsigned long now_jiffies = jiffies;
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
 		struct sched_clock_data *scd = cpu_sdc(cpu);
 
 		scd->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
-		scd->prev_jiffies = jiffies;
-		scd->prev_raw = now;
-		scd->tick_raw = now;
+		scd->prev_jiffies = now_jiffies;
+		scd->prev_raw = 0;
+		scd->tick_raw = 0;
 		scd->tick_gtod = ktime_now;
 		scd->clock = ktime_now;
 	}
+
+	sched_clock_running = 1;
 }
 
 /*
@@ -136,6 +140,9 @@ u64 sched_clock_cpu(int cpu)
 	struct sched_clock_data *scd = cpu_sdc(cpu);
 	u64 now, clock;
 
+	if (unlikely(!sched_clock_running))
+		return 0ull;
+
 	WARN_ON_ONCE(!irqs_disabled());
 	now = sched_clock();
 
@@ -174,6 +181,9 @@ void sched_clock_tick(void)
 	struct sched_clock_data *scd = this_scd();
 	u64 now, now_gtod;
 
+	if (unlikely(!sched_clock_running))
+		return;
+
 	WARN_ON_ONCE(!irqs_disabled());
 
 	now = sched_clock();
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 5f06118..8bb7130 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -167,11 +167,6 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
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
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index e24ecd3..08ae848 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -334,34 +334,6 @@ int sched_nr_latency_handler(struct ctl_table *table, int write,
 #endif
 
 /*
- * delta *= w / rw
- */
-static inline unsigned long
-calc_delta_weight(unsigned long delta, struct sched_entity *se)
-{
-	for_each_sched_entity(se) {
-		delta = calc_delta_mine(delta,
-				se->load.weight, &cfs_rq_of(se)->load);
-	}
-
-	return delta;
-}
-
-/*
- * delta *= rw / w
- */
-static inline unsigned long
-calc_delta_fair(unsigned long delta, struct sched_entity *se)
-{
-	for_each_sched_entity(se) {
-		delta = calc_delta_mine(delta,
-				cfs_rq_of(se)->load.weight, &se->load);
-	}
-
-	return delta;
-}
-
-/*
  * The idea is to set a period in which each task runs once.
  *
  * When there are too many tasks (sysctl_sched_nr_latency) we have to stretch
@@ -390,54 +362,47 @@ static u64 __sched_period(unsigned long nr_running)
  */
 static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	return calc_delta_weight(__sched_period(cfs_rq->nr_running), se);
+	u64 slice = __sched_period(cfs_rq->nr_running);
+
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+
+		slice *= se->load.weight;
+		do_div(slice, cfs_rq->load.weight);
+	}
+
+
+	return slice;
 }
 
 /*
  * We calculate the vruntime slice of a to be inserted task
  *
- * vs = s*rw/w = p
+ * vs = s/w = p/rw
  */
 static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	unsigned long nr_running = cfs_rq->nr_running;
+	unsigned long weight;
+	u64 vslice;
 
 	if (!se->on_rq)
 		nr_running++;
 
-	return __sched_period(nr_running);
-}
-
-/*
- * The goal of calc_delta_asym() is to be asymmetrically around NICE_0_LOAD, in
- * that it favours >=0 over <0.
- *
- *   -20         |
- *               |
- *     0 --------+-------
- *             .'
- *    19     .'
- *
- */
-static unsigned long
-calc_delta_asym(unsigned long delta, struct sched_entity *se)
-{
-	struct load_weight lw = {
-		.weight = NICE_0_LOAD,
-		.inv_weight = 1UL << (WMULT_SHIFT-NICE_0_SHIFT)
-	};
+	vslice = __sched_period(nr_running);
 
 	for_each_sched_entity(se) {
-		struct load_weight *se_lw = &se->load;
+		cfs_rq = cfs_rq_of(se);
 
-		if (se->load.weight < NICE_0_LOAD)
-			se_lw = &lw;
+		weight = cfs_rq->load.weight;
+		if (!se->on_rq)
+			weight += se->load.weight;
 
-		delta = calc_delta_mine(delta,
-				cfs_rq_of(se)->load.weight, se_lw);
+		vslice *= NICE_0_LOAD;
+		do_div(vslice, weight);
 	}
 
-	return delta;
+	return vslice;
 }
 
 /*
@@ -454,7 +419,11 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 
 	curr->sum_exec_runtime += delta_exec;
 	schedstat_add(cfs_rq, exec_clock, delta_exec);
-	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
+	delta_exec_weighted = delta_exec;
+	if (unlikely(curr->load.weight != NICE_0_LOAD)) {
+		delta_exec_weighted = calc_delta_fair(delta_exec_weighted,
+							&curr->load);
+	}
 	curr->vruntime += delta_exec_weighted;
 }
 
@@ -541,27 +510,10 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
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
@@ -571,10 +523,6 @@ static void
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
@@ -661,17 +609,8 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
-		if (sched_feat(NEW_FAIR_SLEEPERS)) {
-			unsigned long thresh = sysctl_sched_latency;
-
-			/*
-			 * convert the sleeper threshold into virtual time
-			 */
-			if (sched_feat(NORMALIZED_SLEEPER))
-				thresh = calc_delta_fair(thresh, se);
-
-			vruntime -= thresh;
-		}
+		if (sched_feat(NEW_FAIR_SLEEPERS))
+			vruntime -= sysctl_sched_latency;
 
 		/* ensure we never gain time by being placed backwards. */
 		vruntime = max_vruntime(se->vruntime, vruntime);
@@ -1057,16 +996,27 @@ wake_affine(struct rq *rq, struct sched_domain *this_sd, struct rq *this_rq,
 	struct task_struct *curr = this_rq->curr;
 	unsigned long tl = this_load;
 	unsigned long tl_per_task;
+	int balanced;
 
-	if (!(this_sd->flags & SD_WAKE_AFFINE))
+	if (!(this_sd->flags & SD_WAKE_AFFINE) || !sched_feat(AFFINE_WAKEUPS))
 		return 0;
 
 	/*
+	 * If sync wakeup then subtract the (maximum possible)
+	 * effect of the currently running task from the load
+	 * of the current CPU:
+	 */
+	if (sync)
+		tl -= current->se.load.weight;
+
+	balanced = 100*(tl + p->se.load.weight) <= imbalance*load;
+
+	/*
 	 * If the currently running task will sleep within
 	 * a reasonable amount of time then attract this newly
 	 * woken task:
 	 */
-	if (sync && curr->sched_class == &fair_sched_class) {
+	if (sync && balanced && curr->sched_class == &fair_sched_class) {
 		if (curr->se.avg_overlap < sysctl_sched_migration_cost &&
 				p->se.avg_overlap < sysctl_sched_migration_cost)
 			return 1;
@@ -1075,16 +1025,8 @@ wake_affine(struct rq *rq, struct sched_domain *this_sd, struct rq *this_rq,
 	schedstat_inc(p, se.nr_wakeups_affine_attempts);
 	tl_per_task = cpu_avg_load_per_task(this_cpu);
 
-	/*
-	 * If sync wakeup then subtract the (maximum possible)
-	 * effect of the currently running task from the load
-	 * of the current CPU:
-	 */
-	if (sync)
-		tl -= current->se.load.weight;
-
 	if ((tl <= load && tl + target_load(prev_cpu, idx) <= tl_per_task) ||
-			100*(tl + p->se.load.weight) <= imbalance*load) {
+			balanced) {
 		/*
 		 * This domain has SD_WAKE_AFFINE and
 		 * p is cache cold in this domain, and
@@ -1169,10 +1111,11 @@ static unsigned long wakeup_gran(struct sched_entity *se)
 	unsigned long gran = sysctl_sched_wakeup_granularity;
 
 	/*
-	 * More easily preempt - nice tasks, while not making it harder for
-	 * + nice tasks.
+	 * More easily preempt - nice tasks, while not making
+	 * it harder for + nice tasks.
 	 */
-	gran = calc_delta_asym(sysctl_sched_wakeup_granularity, se);
+	if (unlikely(se->load.weight > NICE_0_LOAD))
+		gran = calc_delta_fair(gran, &se->load);
 
 	return gran;
 }
@@ -1366,90 +1309,75 @@ static struct task_struct *load_balance_next_fair(void *arg)
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
+
+	p = task_of(curr);
 
-	return balance_tasks(this_rq, this_cpu, busiest,
-			max_load_move, sd, idle, all_pinned,
-			this_best_prio, &cfs_rq_iterator);
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
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 060e87b..3432d57 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -513,8 +513,6 @@ static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
 	 */
 	for_each_sched_rt_entity(rt_se)
 		enqueue_rt_entity(rt_se);
-
-	inc_cpu_load(rq, p->se.load.weight);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
@@ -534,8 +532,6 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
 		if (rt_rq && rt_rq->rt_nr_running)
 			enqueue_rt_entity(rt_se);
 	}
-
-	dec_cpu_load(rq, p->se.load.weight);
 }
 
 /*
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 5bae2e0..a38878e 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -67,6 +67,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
 		preempt_enable();
 #endif
 	}
+	kfree(mask_str);
 	return 0;
 }
 

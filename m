Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbYEKJXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbYEKJXN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 05:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbYEKJW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 05:22:56 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:45229 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbYEKJWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 05:22:53 -0400
Date: Sun, 11 May 2008 12:21:32 +0300
From: Adrian Bunk <bunk@kernel.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] kernel/sched*: optimize inlining
Message-ID: <20080511092132.GE1645@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/sched* contained tons of inline's, and the result of removing 
them all is impressing (with x86_64_defconfig)
   text    data     bss     dec     hex filename
  39557    8234     280   48071    bbc7 kernel/sched.o
  41792    8234     280   50306    c482 kernel/sched.o.old

That's a 5.3% text size reduction (!), which is more than twice as much 
as the 2.3% the "optimized inlining" achieves on average for the whole 
kernel.

Note that any remarks regarding whether this patch might affect the 
performance are invalid since noone cared about the performance when
the "x86: add optimized inlining" commit that does the same for the 
whole kernel entered the tree.

This patch also removes some unused dummy functions gcc now warns about.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 kernel/sched.c       |  158 ++++++++++++++++---------------------------
 kernel/sched_clock.c |    4 -
 kernel/sched_fair.c  |   60 ++++++++--------
 kernel/sched_rt.c    |   60 ++++++++--------
 kernel/sched_stats.h |   18 ++--
 5 files changed, 132 insertions(+), 168 deletions(-)

624eadf549ab433079c0cf228e4217985b5f2460 diff --git a/kernel/sched.c b/kernel/sched.c
index c51b656..f4f43b9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -118,7 +118,7 @@
  * Divide a load by a sched group cpu_power : (load / sg->__cpu_power)
  * Since cpu_power is a 'constant', we can use a reciprocal divide.
  */
-static inline u32 sg_div_cpu_power(const struct sched_group *sg, u32 load)
+static u32 sg_div_cpu_power(const struct sched_group *sg, u32 load)
 {
 	return reciprocal_divide(load, sg->reciprocal_cpu_power);
 }
@@ -127,21 +127,21 @@ static inline u32 sg_div_cpu_power(const struct sched_group *sg, u32 load)
  * Each time a sched group cpu_power is changed,
  * we must compute its reciprocal value
  */
-static inline void sg_inc_cpu_power(struct sched_group *sg, u32 val)
+static void sg_inc_cpu_power(struct sched_group *sg, u32 val)
 {
 	sg->__cpu_power += val;
 	sg->reciprocal_cpu_power = reciprocal_value(sg->__cpu_power);
 }
 #endif
 
-static inline int rt_policy(int policy)
+static int rt_policy(int policy)
 {
 	if (unlikely(policy == SCHED_FIFO) || unlikely(policy == SCHED_RR))
 		return 1;
 	return 0;
 }
 
-static inline int task_has_rt_policy(struct task_struct *p)
+static int task_has_rt_policy(struct task_struct *p)
 {
 	return rt_policy(p->policy);
 }
@@ -328,7 +328,7 @@ static int init_task_group_load = INIT_TASK_GROUP_LOAD;
 struct task_group init_task_group;
 
 /* return group to which a task belongs */
-static inline struct task_group *task_group(struct task_struct *p)
+static struct task_group *task_group(struct task_struct *p)
 {
 	struct task_group *tg;
 
@@ -344,7 +344,7 @@ static inline struct task_group *task_group(struct task_struct *p)
 }
 
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
-static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
+static void set_task_rq(struct task_struct *p, unsigned int cpu)
 {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
@@ -359,7 +359,7 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 
 #else
 
-static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
+static void set_task_rq(struct task_struct *p, unsigned int cpu) { }
 
 #endif	/* CONFIG_GROUP_SCHED */
 
@@ -598,12 +598,12 @@ struct rq {
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
-static inline void check_preempt_curr(struct rq *rq, struct task_struct *p)
+static void check_preempt_curr(struct rq *rq, struct task_struct *p)
 {
 	rq->curr->sched_class->check_preempt_curr(rq, p);
 }
 
-static inline int cpu_of(struct rq *rq)
+static int cpu_of(struct rq *rq)
 {
 #ifdef CONFIG_SMP
 	return rq->cpu;
@@ -627,7 +627,7 @@ static inline int cpu_of(struct rq *rq)
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 
-static inline void update_rq_clock(struct rq *rq)
+static void update_rq_clock(struct rq *rq)
 {
 	rq->clock = sched_clock_cpu(cpu_of(rq));
 }
@@ -796,12 +796,12 @@ static __read_mostly int scheduler_running;
  */
 int sysctl_sched_rt_runtime = 950000;
 
-static inline u64 global_rt_period(void)
+static u64 global_rt_period(void)
 {
 	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
 }
 
-static inline u64 global_rt_runtime(void)
+static u64 global_rt_runtime(void)
 {
 	if (sysctl_sched_rt_period < 0)
 		return RUNTIME_INF;
@@ -892,22 +892,22 @@ EXPORT_SYMBOL_GPL(cpu_clock);
 # define finish_arch_switch(prev)	do { } while (0)
 #endif
 
-static inline int task_current(struct rq *rq, struct task_struct *p)
+static int task_current(struct rq *rq, struct task_struct *p)
 {
 	return rq->curr == p;
 }
 
 #ifndef __ARCH_WANT_UNLOCKED_CTXSW
-static inline int task_running(struct rq *rq, struct task_struct *p)
+static int task_running(struct rq *rq, struct task_struct *p)
 {
 	return task_current(rq, p);
 }
 
-static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
+static void prepare_lock_switch(struct rq *rq, struct task_struct *next)
 {
 }
 
-static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
+static void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 {
 #ifdef CONFIG_DEBUG_SPINLOCK
 	/* this is a valid case when another task releases the spinlock */
@@ -924,7 +924,7 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 }
 
 #else /* __ARCH_WANT_UNLOCKED_CTXSW */
-static inline int task_running(struct rq *rq, struct task_struct *p)
+static int task_running(struct rq *rq, struct task_struct *p)
 {
 #ifdef CONFIG_SMP
 	return p->oncpu;
@@ -933,7 +933,7 @@ static inline int task_running(struct rq *rq, struct task_struct *p)
 #endif
 }
 
-static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
+static void prepare_lock_switch(struct rq *rq, struct task_struct *next)
 {
 #ifdef CONFIG_SMP
 	/*
@@ -950,7 +950,7 @@ static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
 #endif
 }
 
-static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
+static void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 {
 #ifdef CONFIG_SMP
 	/*
@@ -971,7 +971,7 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
  * __task_rq_lock - lock the runqueue a given task resides on.
  * Must be called interrupts disabled.
  */
-static inline struct rq *__task_rq_lock(struct task_struct *p)
+static struct rq *__task_rq_lock(struct task_struct *p)
 	__acquires(rq->lock)
 {
 	for (;;) {
@@ -1009,7 +1009,7 @@ static void __task_rq_unlock(struct rq *rq)
 	spin_unlock(&rq->lock);
 }
 
-static inline void task_rq_unlock(struct rq *rq, unsigned long *flags)
+static void task_rq_unlock(struct rq *rq, unsigned long *flags)
 	__releases(rq->lock)
 {
 	spin_unlock_irqrestore(&rq->lock, *flags);
@@ -1032,7 +1032,7 @@ static struct rq *this_rq_lock(void)
 
 static void __resched_task(struct task_struct *p, int tif_bit);
 
-static inline void resched_task(struct task_struct *p)
+static void resched_task(struct task_struct *p)
 {
 	__resched_task(p, TIF_NEED_RESCHED);
 }
@@ -1048,12 +1048,12 @@ static inline void resched_task(struct task_struct *p)
  * When we get rescheduled we reprogram the hrtick_timer outside of the
  * rq->lock.
  */
-static inline void resched_hrt(struct task_struct *p)
+static void resched_hrt(struct task_struct *p)
 {
 	__resched_task(p, TIF_HRTICK_RESCHED);
 }
 
-static inline void resched_rq(struct rq *rq)
+static void resched_rq(struct rq *rq)
 {
 	unsigned long flags;
 
@@ -1073,7 +1073,7 @@ enum {
  *  - enabled by features
  *  - hrtimer is actually high res
  */
-static inline int hrtick_enabled(struct rq *rq)
+static int hrtick_enabled(struct rq *rq)
 {
 	if (!sched_feat(HRTICK))
 		return 0;
@@ -1239,15 +1239,15 @@ void hrtick_resched(void)
 	local_irq_restore(flags);
 }
 #else
-static inline void hrtick_clear(struct rq *rq)
+static void hrtick_clear(struct rq *rq)
 {
 }
 
-static inline void hrtick_set(struct rq *rq)
+static void hrtick_set(struct rq *rq)
 {
 }
 
-static inline void init_rq_hrtick(struct rq *rq)
+static void init_rq_hrtick(struct rq *rq)
 {
 }
 
@@ -1255,7 +1255,7 @@ void hrtick_resched(void)
 {
 }
 
-static inline void init_hrtick(void)
+static void init_hrtick(void)
 {
 }
 #endif
@@ -1393,13 +1393,13 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 	return (unsigned long)min(tmp, (u64)(unsigned long)LONG_MAX);
 }
 
-static inline void update_load_add(struct load_weight *lw, unsigned long inc)
+static void update_load_add(struct load_weight *lw, unsigned long inc)
 {
 	lw->weight += inc;
 	lw->inv_weight = 0;
 }
 
-static inline void update_load_sub(struct load_weight *lw, unsigned long dec)
+static void update_load_sub(struct load_weight *lw, unsigned long dec)
 {
 	lw->weight -= dec;
 	lw->inv_weight = 0;
@@ -1487,15 +1487,15 @@ iter_move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 #ifdef CONFIG_CGROUP_CPUACCT
 static void cpuacct_charge(struct task_struct *tsk, u64 cputime);
 #else
-static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
+static void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
 #endif
 
-static inline void inc_cpu_load(struct rq *rq, unsigned long load)
+static void inc_cpu_load(struct rq *rq, unsigned long load)
 {
 	update_load_add(&rq->load, load);
 }
 
-static inline void dec_cpu_load(struct rq *rq, unsigned long load)
+static void dec_cpu_load(struct rq *rq, unsigned long load)
 {
 	update_load_sub(&rq->load, load);
 }
@@ -1538,7 +1538,7 @@ static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
  *    get 1, B gets 2.
  */
 
-static inline struct aggregate_struct *
+static struct aggregate_struct *
 aggregate(struct task_group *tg, struct sched_domain *sd)
 {
 	return &tg->cfs_rq[sd->first_cpu]->aggregate;
@@ -1811,16 +1811,16 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 
 #else
 
-static inline void init_aggregate(void)
+static void init_aggregate(void)
 {
 }
 
-static inline int get_aggregate(struct sched_domain *sd)
+static int get_aggregate(struct sched_domain *sd)
 {
 	return 0;
 }
 
-static inline void put_aggregate(struct sched_domain *sd)
+static void put_aggregate(struct sched_domain *sd)
 {
 }
 #endif
@@ -1892,7 +1892,7 @@ static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 /*
  * __normal_prio - return the priority that is based on the static prio
  */
-static inline int __normal_prio(struct task_struct *p)
+static int __normal_prio(struct task_struct *p)
 {
 	return p->static_prio;
 }
@@ -1904,7 +1904,7 @@ static inline int __normal_prio(struct task_struct *p)
  * setprio syscalls, and whenever the interactivity
  * estimator recalculates.
  */
-static inline int normal_prio(struct task_struct *p)
+static int normal_prio(struct task_struct *p)
 {
 	int prio;
 
@@ -1963,7 +1963,7 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
  * task_curr - is this task currently executing on a CPU?
  * @p: the task in question.
  */
-inline int task_curr(const struct task_struct *p)
+int task_curr(const struct task_struct *p)
 {
 	return cpu_curr(task_cpu(p)) == p;
 }
@@ -1974,7 +1974,7 @@ unsigned long weighted_cpuload(const int cpu)
 	return cpu_rq(cpu)->load.weight;
 }
 
-static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
+static void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
 	set_task_rq(p, cpu);
 #ifdef CONFIG_SMP
@@ -1988,9 +1988,9 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 #endif
 }
 
-static inline void check_class_changed(struct rq *rq, struct task_struct *p,
-				       const struct sched_class *prev_class,
-				       int oldprio, int running)
+static void check_class_changed(struct rq *rq, struct task_struct *p,
+				const struct sched_class *prev_class,
+				int oldprio, int running)
 {
 	if (prev_class != p->sched_class) {
 		if (prev_class->switched_from)
@@ -2690,7 +2690,7 @@ fire_sched_out_preempt_notifiers(struct task_struct *curr,
  * prepare_task_switch sets up locking and calls architecture specific
  * hooks.
  */
-static inline void
+static void
 prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
@@ -2776,7 +2776,7 @@ asmlinkage void schedule_tail(struct task_struct *prev)
  * context_switch - switch to the new MM and the new
  * thread's register state.
  */
-static inline void
+static void
 context_switch(struct rq *rq, struct task_struct *prev,
 	       struct task_struct *next)
 {
@@ -4126,7 +4126,7 @@ static void run_rebalance_domains(struct softirq_action *h)
  * idle load balancing owner or decide to stop the periodic load balancing,
  * if the whole system is idle.
  */
-static inline void trigger_load_balance(struct rq *rq, int cpu)
+static void trigger_load_balance(struct rq *rq, int cpu)
 {
 #ifdef CONFIG_NO_HZ
 	/*
@@ -4185,7 +4185,7 @@ static inline void trigger_load_balance(struct rq *rq, int cpu)
 /*
  * on UP we do not need to balance between CPUs:
  */
-static inline void idle_balance(int cpu, struct rq *rq)
+static void idle_balance(int cpu, struct rq *rq)
 {
 }
 
@@ -4423,7 +4423,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 /*
  * Various schedule()-time debugging checks and statistics:
  */
-static inline void schedule_debug(struct task_struct *prev)
+static void schedule_debug(struct task_struct *prev)
 {
 	/*
 	 * Test if we are atomic. Since do_exit() needs to call into
@@ -4447,7 +4447,7 @@ static inline void schedule_debug(struct task_struct *prev)
 /*
  * Pick up the highest-prio task:
  */
-static inline struct task_struct *
+static struct task_struct *
 pick_next_task(struct rq *rq, struct task_struct *prev)
 {
 	const struct sched_class *class;
@@ -4728,7 +4728,7 @@ void complete_all(struct completion *x)
 }
 EXPORT_SYMBOL(complete_all);
 
-static inline long __sched
+static long __sched
 do_wait_for_common(struct completion *x, long timeout, int state)
 {
 	if (!x->done) {
@@ -5860,7 +5860,7 @@ cpumask_t nohz_cpu_mask = CPU_MASK_NONE;
  *
  * This idea comes from the SD scheduler of Con Kolivas:
  */
-static inline void sched_init_granularity(void)
+static void sched_init_granularity(void)
 {
 	unsigned int factor = 1 + ilog2(num_online_cpus());
 	const unsigned long limit = 200000000;
@@ -8370,34 +8370,16 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 	return 0;
 }
 
-static inline void register_fair_sched_group(struct task_group *tg, int cpu)
+static void register_fair_sched_group(struct task_group *tg, int cpu)
 {
 	list_add_rcu(&tg->cfs_rq[cpu]->leaf_cfs_rq_list,
 			&cpu_rq(cpu)->leaf_cfs_rq_list);
 }
 
-static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
+static void unregister_fair_sched_group(struct task_group *tg, int cpu)
 {
 	list_del_rcu(&tg->cfs_rq[cpu]->leaf_cfs_rq_list);
 }
-#else
-static inline void free_fair_sched_group(struct task_group *tg)
-{
-}
-
-static inline
-int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
-{
-	return 1;
-}
-
-static inline void register_fair_sched_group(struct task_group *tg, int cpu)
-{
-}
-
-static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
-{
-}
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -8459,34 +8441,16 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 	return 0;
 }
 
-static inline void register_rt_sched_group(struct task_group *tg, int cpu)
+static void register_rt_sched_group(struct task_group *tg, int cpu)
 {
 	list_add_rcu(&tg->rt_rq[cpu]->leaf_rt_rq_list,
 			&cpu_rq(cpu)->leaf_rt_rq_list);
 }
 
-static inline void unregister_rt_sched_group(struct task_group *tg, int cpu)
+static void unregister_rt_sched_group(struct task_group *tg, int cpu)
 {
 	list_del_rcu(&tg->rt_rq[cpu]->leaf_rt_rq_list);
 }
-#else
-static inline void free_rt_sched_group(struct task_group *tg)
-{
-}
-
-static inline
-int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
-{
-	return 1;
-}
-
-static inline void register_rt_sched_group(struct task_group *tg, int cpu)
-{
-}
-
-static inline void unregister_rt_sched_group(struct task_group *tg, int cpu)
-{
-}
 #endif
 
 #ifdef CONFIG_GROUP_SCHED
@@ -8760,7 +8724,7 @@ static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
 #endif
 
 /* Must be called with tasklist_lock held */
-static inline int tg_has_rt_tasks(struct task_group *tg)
+static int tg_has_rt_tasks(struct task_group *tg)
 {
 	struct task_struct *g, *p;
 	do_each_thread(g, p) {
@@ -8912,7 +8876,7 @@ int sched_rt_handler(struct ctl_table *table, int write,
 #ifdef CONFIG_CGROUP_SCHED
 
 /* return corresponding task_group object of a cgroup */
-static inline struct task_group *cgroup_tg(struct cgroup *cgrp)
+static struct task_group *cgroup_tg(struct cgroup *cgrp)
 {
 	return container_of(cgroup_subsys_state(cgrp, cpu_cgroup_subsys_id),
 			    struct task_group, css);
@@ -9070,14 +9034,14 @@ struct cpuacct {
 struct cgroup_subsys cpuacct_subsys;
 
 /* return cpu accounting group corresponding to this container */
-static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
+static struct cpuacct *cgroup_ca(struct cgroup *cgrp)
 {
 	return container_of(cgroup_subsys_state(cgrp, cpuacct_subsys_id),
 			    struct cpuacct, css);
 }
 
 /* return cpu accounting group to which this task belongs */
-static inline struct cpuacct *task_ca(struct task_struct *tsk)
+static struct cpuacct *task_ca(struct task_struct *tsk)
 {
 	return container_of(task_subsys_state(tsk, cpuacct_subsys_id),
 			    struct cpuacct, css);
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index 9c597e3..15e7919 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -49,12 +49,12 @@ struct sched_clock_data {
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_clock_data, sched_clock_data);
 
-static inline struct sched_clock_data *this_scd(void)
+static struct sched_clock_data *this_scd(void)
 {
 	return &__get_cpu_var(sched_clock_data);
 }
 
-static inline struct sched_clock_data *cpu_sdc(int cpu)
+static struct sched_clock_data *cpu_sdc(int cpu)
 {
 	return &per_cpu(sched_clock_data, cpu);
 }
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index e24ecd3..ff362c7 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -77,7 +77,7 @@ const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
  * CFS operations on generic schedulable entities:
  */
 
-static inline struct task_struct *task_of(struct sched_entity *se)
+static struct task_struct *task_of(struct sched_entity *se)
 {
 	return container_of(se, struct task_struct, se);
 }
@@ -85,7 +85,7 @@ static inline struct task_struct *task_of(struct sched_entity *se)
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
 /* cpu runqueue to which this cfs_rq is attached */
-static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
+static struct rq *rq_of(struct cfs_rq *cfs_rq)
 {
 	return cfs_rq->rq;
 }
@@ -97,19 +97,19 @@ static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
 #define for_each_sched_entity(se) \
 		for (; se; se = se->parent)
 
-static inline struct cfs_rq *task_cfs_rq(struct task_struct *p)
+static struct cfs_rq *task_cfs_rq(struct task_struct *p)
 {
 	return p->se.cfs_rq;
 }
 
 /* runqueue on which this entity is (to be) queued */
-static inline struct cfs_rq *cfs_rq_of(struct sched_entity *se)
+static struct cfs_rq *cfs_rq_of(struct sched_entity *se)
 {
 	return se->cfs_rq;
 }
 
 /* runqueue "owned" by this group */
-static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
+static struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
 {
 	return grp->my_q;
 }
@@ -117,7 +117,7 @@ static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
 /* Given a group's cfs_rq on one cpu, return its corresponding cfs_rq on
  * another cpu ('this_cpu')
  */
-static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
+static struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
 {
 	return cfs_rq->tg->cfs_rq[this_cpu];
 }
@@ -127,7 +127,7 @@ static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
 	list_for_each_entry_rcu(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
 
 /* Do the two (enqueued) entities belong to the same group ? */
-static inline int
+static int
 is_same_group(struct sched_entity *se, struct sched_entity *pse)
 {
 	if (se->cfs_rq == pse->cfs_rq)
@@ -136,14 +136,14 @@ is_same_group(struct sched_entity *se, struct sched_entity *pse)
 	return 0;
 }
 
-static inline struct sched_entity *parent_entity(struct sched_entity *se)
+static struct sched_entity *parent_entity(struct sched_entity *se)
 {
 	return se->parent;
 }
 
 #else	/* CONFIG_FAIR_GROUP_SCHED */
 
-static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
+static struct rq *rq_of(struct cfs_rq *cfs_rq)
 {
 	return container_of(cfs_rq, struct rq, cfs);
 }
@@ -153,12 +153,12 @@ static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
 #define for_each_sched_entity(se) \
 		for (; se; se = NULL)
 
-static inline struct cfs_rq *task_cfs_rq(struct task_struct *p)
+static struct cfs_rq *task_cfs_rq(struct task_struct *p)
 {
 	return &task_rq(p)->cfs;
 }
 
-static inline struct cfs_rq *cfs_rq_of(struct sched_entity *se)
+static struct cfs_rq *cfs_rq_of(struct sched_entity *se)
 {
 	struct task_struct *p = task_of(se);
 	struct rq *rq = task_rq(p);
@@ -167,12 +167,12 @@ static inline struct cfs_rq *cfs_rq_of(struct sched_entity *se)
 }
 
 /* runqueue "owned" by this group */
-static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
+static struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
 {
 	return NULL;
 }
 
-static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
+static struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
 {
 	return &cpu_rq(this_cpu)->cfs;
 }
@@ -180,13 +180,13 @@ static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
 #define for_each_leaf_cfs_rq(rq, cfs_rq) \
 		for (cfs_rq = &rq->cfs; cfs_rq; cfs_rq = NULL)
 
-static inline int
+static int
 is_same_group(struct sched_entity *se, struct sched_entity *pse)
 {
 	return 1;
 }
 
-static inline struct sched_entity *parent_entity(struct sched_entity *se)
+static struct sched_entity *parent_entity(struct sched_entity *se)
 {
 	return NULL;
 }
@@ -198,7 +198,7 @@ static inline struct sched_entity *parent_entity(struct sched_entity *se)
  * Scheduling class tree data structure manipulation methods:
  */
 
-static inline u64 max_vruntime(u64 min_vruntime, u64 vruntime)
+static u64 max_vruntime(u64 min_vruntime, u64 vruntime)
 {
 	s64 delta = (s64)(vruntime - min_vruntime);
 	if (delta > 0)
@@ -207,7 +207,7 @@ static inline u64 max_vruntime(u64 min_vruntime, u64 vruntime)
 	return min_vruntime;
 }
 
-static inline u64 min_vruntime(u64 min_vruntime, u64 vruntime)
+static u64 min_vruntime(u64 min_vruntime, u64 vruntime)
 {
 	s64 delta = (s64)(vruntime - min_vruntime);
 	if (delta < 0)
@@ -216,7 +216,7 @@ static inline u64 min_vruntime(u64 min_vruntime, u64 vruntime)
 	return min_vruntime;
 }
 
-static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	return se->vruntime - cfs_rq->min_vruntime;
 }
@@ -292,7 +292,7 @@ static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
 }
 
-static inline struct rb_node *first_fair(struct cfs_rq *cfs_rq)
+static struct rb_node *first_fair(struct cfs_rq *cfs_rq)
 {
 	return cfs_rq->rb_leftmost;
 }
@@ -302,7 +302,7 @@ static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
 	return rb_entry(first_fair(cfs_rq), struct sched_entity, run_node);
 }
 
-static inline struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
+static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *last = rb_last(&cfs_rq->tasks_timeline);
 
@@ -336,7 +336,7 @@ int sched_nr_latency_handler(struct ctl_table *table, int write,
 /*
  * delta *= w / rw
  */
-static inline unsigned long
+static unsigned long
 calc_delta_weight(unsigned long delta, struct sched_entity *se)
 {
 	for_each_sched_entity(se) {
@@ -350,7 +350,7 @@ calc_delta_weight(unsigned long delta, struct sched_entity *se)
 /*
  * delta *= rw / w
  */
-static inline unsigned long
+static unsigned long
 calc_delta_fair(unsigned long delta, struct sched_entity *se)
 {
 	for_each_sched_entity(se) {
@@ -444,7 +444,7 @@ calc_delta_asym(unsigned long delta, struct sched_entity *se)
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
  */
-static inline void
+static void
 __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 	      unsigned long delta_exec)
 {
@@ -484,7 +484,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
 	}
 }
 
-static inline void
+static void
 update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	schedstat_set(se->wait_start, rq_of(cfs_rq)->clock);
@@ -514,7 +514,7 @@ update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	schedstat_set(se->wait_start, 0);
 }
 
-static inline void
+static void
 update_stats_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	/*
@@ -528,7 +528,7 @@ update_stats_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 /*
  * We are picking a new current task - update its stats:
  */
-static inline void
+static void
 update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	/*
@@ -548,7 +548,7 @@ add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long weight)
 	cfs_rq->task_weight += weight;
 }
 #else
-static inline void
+static void
 add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long weight)
 {
 }
@@ -897,7 +897,7 @@ static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 	}
 }
 #else
-static inline void
+static void
 hrtick_start_fair(struct rq *rq, struct task_struct *p)
 {
 }
@@ -1038,7 +1038,7 @@ static int wake_idle(int cpu, struct task_struct *p)
 	return cpu;
 }
 #else
-static inline int wake_idle(int cpu, struct task_struct *p)
+static int wake_idle(int cpu, struct task_struct *p)
 {
 	return cpu;
 }
@@ -1207,7 +1207,7 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se)
 }
 
 /* return depth at which a sched entity is present in the hierarchy */
-static inline int depth_se(struct sched_entity *se)
+static int depth_se(struct sched_entity *se)
 {
 	int depth = 0;
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 060e87b..0280e1c 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -5,12 +5,12 @@
 
 #ifdef CONFIG_SMP
 
-static inline int rt_overloaded(struct rq *rq)
+static int rt_overloaded(struct rq *rq)
 {
 	return atomic_read(&rq->rd->rto_count);
 }
 
-static inline void rt_set_overload(struct rq *rq)
+static void rt_set_overload(struct rq *rq)
 {
 	cpu_set(rq->cpu, rq->rd->rto_mask);
 	/*
@@ -24,7 +24,7 @@ static inline void rt_set_overload(struct rq *rq)
 	atomic_inc(&rq->rd->rto_count);
 }
 
-static inline void rt_clear_overload(struct rq *rq)
+static void rt_clear_overload(struct rq *rq)
 {
 	/* the order here really doesn't matter */
 	atomic_dec(&rq->rd->rto_count);
@@ -45,19 +45,19 @@ static void update_rt_migration(struct rq *rq)
 }
 #endif /* CONFIG_SMP */
 
-static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
+static struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
 {
 	return container_of(rt_se, struct task_struct, rt);
 }
 
-static inline int on_rt_rq(struct sched_rt_entity *rt_se)
+static int on_rt_rq(struct sched_rt_entity *rt_se)
 {
 	return !list_empty(&rt_se->run_list);
 }
 
 #ifdef CONFIG_RT_GROUP_SCHED
 
-static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
+static u64 sched_rt_runtime(struct rt_rq *rt_rq)
 {
 	if (!rt_rq->tg)
 		return RUNTIME_INF;
@@ -65,7 +65,7 @@ static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
 	return rt_rq->rt_runtime;
 }
 
-static inline u64 sched_rt_period(struct rt_rq *rt_rq)
+static u64 sched_rt_period(struct rt_rq *rt_rq)
 {
 	return ktime_to_ns(rt_rq->tg->rt_bandwidth.rt_period);
 }
@@ -73,12 +73,12 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 #define for_each_leaf_rt_rq(rt_rq, rq) \
 	list_for_each_entry(rt_rq, &rq->leaf_rt_rq_list, leaf_rt_rq_list)
 
-static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
+static struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
 {
 	return rt_rq->rq;
 }
 
-static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
+static struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
 {
 	return rt_se->rt_rq;
 }
@@ -86,7 +86,7 @@ static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
 #define for_each_sched_rt_entity(rt_se) \
 	for (; rt_se; rt_se = rt_se->parent)
 
-static inline struct rt_rq *group_rt_rq(struct sched_rt_entity *rt_se)
+static struct rt_rq *group_rt_rq(struct sched_rt_entity *rt_se)
 {
 	return rt_se->my_q;
 }
@@ -115,7 +115,7 @@ static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 		dequeue_rt_entity(rt_se);
 }
 
-static inline int rt_rq_throttled(struct rt_rq *rt_rq)
+static int rt_rq_throttled(struct rt_rq *rt_rq)
 {
 	return rt_rq->rt_throttled && !rt_rq->rt_nr_boosted;
 }
@@ -133,36 +133,36 @@ static int rt_se_boosted(struct sched_rt_entity *rt_se)
 }
 
 #ifdef CONFIG_SMP
-static inline cpumask_t sched_rt_period_mask(void)
+static cpumask_t sched_rt_period_mask(void)
 {
 	return cpu_rq(smp_processor_id())->rd->span;
 }
 #else
-static inline cpumask_t sched_rt_period_mask(void)
+static cpumask_t sched_rt_period_mask(void)
 {
 	return cpu_online_map;
 }
 #endif
 
-static inline
+static
 struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
 {
 	return container_of(rt_b, struct task_group, rt_bandwidth)->rt_rq[cpu];
 }
 
-static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
+static struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 {
 	return &rt_rq->tg->rt_bandwidth;
 }
 
 #else
 
-static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
+static u64 sched_rt_runtime(struct rt_rq *rt_rq)
 {
 	return rt_rq->rt_runtime;
 }
 
-static inline u64 sched_rt_period(struct rt_rq *rt_rq)
+static u64 sched_rt_period(struct rt_rq *rt_rq)
 {
 	return ktime_to_ns(def_rt_bandwidth.rt_period);
 }
@@ -170,12 +170,12 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 #define for_each_leaf_rt_rq(rt_rq, rq) \
 	for (rt_rq = &rq->rt; rt_rq; rt_rq = NULL)
 
-static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
+static struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
 {
 	return container_of(rt_rq, struct rq, rt);
 }
 
-static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
+static struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
 {
 	struct task_struct *p = rt_task_of(rt_se);
 	struct rq *rq = task_rq(p);
@@ -186,36 +186,36 @@ static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
 #define for_each_sched_rt_entity(rt_se) \
 	for (; rt_se; rt_se = NULL)
 
-static inline struct rt_rq *group_rt_rq(struct sched_rt_entity *rt_se)
+static struct rt_rq *group_rt_rq(struct sched_rt_entity *rt_se)
 {
 	return NULL;
 }
 
-static inline void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
+static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 {
 }
 
-static inline void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
+static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 {
 }
 
-static inline int rt_rq_throttled(struct rt_rq *rt_rq)
+static int rt_rq_throttled(struct rt_rq *rt_rq)
 {
 	return rt_rq->rt_throttled;
 }
 
-static inline cpumask_t sched_rt_period_mask(void)
+static cpumask_t sched_rt_period_mask(void)
 {
 	return cpu_online_map;
 }
 
-static inline
+static
 struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
 {
 	return &cpu_rq(cpu)->rt;
 }
 
-static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
+static struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 {
 	return &def_rt_bandwidth;
 }
@@ -301,7 +301,7 @@ static int balance_runtime(struct rt_rq *rt_rq)
 }
 #endif
 
-static inline int rt_se_prio(struct sched_rt_entity *rt_se)
+static int rt_se_prio(struct sched_rt_entity *rt_se)
 {
 #ifdef CONFIG_RT_GROUP_SCHED
 	struct rt_rq *rt_rq = group_rt_rq(rt_se);
@@ -385,7 +385,7 @@ static void update_curr_rt(struct rq *rq)
 	}
 }
 
-static inline
+static
 void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
 	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
@@ -413,7 +413,7 @@ void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 #endif
 }
 
-static inline
+static
 void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
 	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
@@ -781,7 +781,7 @@ static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
 	return count;
 }
 
-static inline int pick_optimal_cpu(int this_cpu, cpumask_t *mask)
+static int pick_optimal_cpu(int this_cpu, cpumask_t *mask)
 {
 	int first;
 
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 5bae2e0..0c87a64 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -99,7 +99,7 @@ const struct file_operations proc_schedstat_operations = {
 /*
  * Expects runqueue lock to be held for atomicity of update
  */
-static inline void
+static void
 rq_sched_info_arrive(struct rq *rq, unsigned long long delta)
 {
 	if (rq) {
@@ -111,7 +111,7 @@ rq_sched_info_arrive(struct rq *rq, unsigned long long delta)
 /*
  * Expects runqueue lock to be held for atomicity of update
  */
-static inline void
+static void
 rq_sched_info_depart(struct rq *rq, unsigned long long delta)
 {
 	if (rq)
@@ -121,10 +121,10 @@ rq_sched_info_depart(struct rq *rq, unsigned long long delta)
 # define schedstat_add(rq, field, amt)	do { (rq)->field += (amt); } while (0)
 # define schedstat_set(var, val)	do { var = (val); } while (0)
 #else /* !CONFIG_SCHEDSTATS */
-static inline void
+static void
 rq_sched_info_arrive(struct rq *rq, unsigned long long delta)
 {}
-static inline void
+static void
 rq_sched_info_depart(struct rq *rq, unsigned long long delta)
 {}
 # define schedstat_inc(rq, field)	do { } while (0)
@@ -148,7 +148,7 @@ rq_sched_info_depart(struct rq *rq, unsigned long long delta)
  * long it was from the *first* time it was queued to the time that it
  * finally hit a cpu.
  */
-static inline void sched_info_dequeued(struct task_struct *t)
+static void sched_info_dequeued(struct task_struct *t)
 {
 	t->sched_info.last_queued = 0;
 }
@@ -187,7 +187,7 @@ static void sched_info_arrive(struct task_struct *t)
  * the timestamp if it is already not set.  It's assumed that
  * sched_info_dequeued() will clear that stamp when appropriate.
  */
-static inline void sched_info_queued(struct task_struct *t)
+static void sched_info_queued(struct task_struct *t)
 {
 	if (unlikely(sched_info_on()))
 		if (!t->sched_info.last_queued)
@@ -198,7 +198,7 @@ static inline void sched_info_queued(struct task_struct *t)
  * Called when a process ceases being the active-running process, either
  * voluntarily or involuntarily.  Now we can calculate how long we ran.
  */
-static inline void sched_info_depart(struct task_struct *t)
+static void sched_info_depart(struct task_struct *t)
 {
 	unsigned long long delta = task_rq(t)->clock -
 					t->sched_info.last_arrival;
@@ -212,7 +212,7 @@ static inline void sched_info_depart(struct task_struct *t)
  * their time slice.  (This may also be called when switching to or from
  * the idle task.)  We are only called when prev != next.
  */
-static inline void
+static void
 __sched_info_switch(struct task_struct *prev, struct task_struct *next)
 {
 	struct rq *rq = task_rq(prev);
@@ -228,7 +228,7 @@ __sched_info_switch(struct task_struct *prev, struct task_struct *next)
 	if (next != rq->idle)
 		sched_info_arrive(next);
 }
-static inline void
+static void
 sched_info_switch(struct task_struct *prev, struct task_struct *next)
 {
 	if (unlikely(sched_info_on()))


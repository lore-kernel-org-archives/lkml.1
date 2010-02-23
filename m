Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab0BWStB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 13:49:01 -0500
Received: from ms01.sssup.it ([193.205.80.99]:56181 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753297Ab0BWSse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 13:48:34 -0500
From: Fabio Checconi <fchecconi@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Turner <pjt@google.com>,
       Dario Faggioli <faggioli@gandalf.sssup.it>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Dhaval Giani <dhaval@retis.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>, linux-kernel@vger.kernel.org,
       Fabio Checconi <fchecconi@gmail.com>,
       Fabio Checconi <fabio@gandalf.sssup.it>
Subject: [PATCH 2/3] sched: enforce per-cpu utilization limits on runtime balancing
Date: Tue, 23 Feb 2010 19:56:34 +0100
Message-Id: <91b76b9b7555024d9afd7264eeae1b2db6a5e74c.1266931410.git.fabio@helm.retis>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <cover.1266931410.git.fabio@helm.retis>
References: <cover.1266931410.git.fabio@helm.retis>
In-Reply-To: <cover.1266931410.git.fabio@helm.retis>
References: <cover.1266931410.git.fabio@helm.retis>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enforce utilization constraints on the bandwidth assignments produced
by the runtime balancing code.  The underlying EDF scheduler requires,
in order to work reliably, that the utilization on each cpu does not
exceed 100%; this patch adds per-cpu utilization tracking and does not
allow the balancer to exceed the global RT bandwidth assignment on any
cpu.

Whenever the bandwidth assigments change (i.e., the user writes an
RT-scheduler cgroup attribute, or a task_group disappears, the bandwidth
assignment is reset to a symmetric assignment, and the balancing restarts
from a safe startpoint.  This requires iterating on all the rt_rq's in the
system (N_cpu * N_groups), and it is surely suboptimal, but it is
conceptually simple and safe.

Synchronization needs a couple of words: a per-rq flag disables runtime
balancing to/from single rq's; the flag relies on spinlock acquire
barriers to ensure that all the balancing operations starting after the
flag has been set see the its correct value.  To protect the per-rq
free bandwidth counter we use per-rq locks, that can nest like rq->lock;
reusing existing locks proved not to be easy, as the various
rt_runtime_locks act on a per-group or per-rt_rq basis.

Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
---
 kernel/sched.c    |   77 ++++++++++-----
 kernel/sched_rt.c |  280 +++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 312 insertions(+), 45 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index fe013c6..4dddbc2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -374,6 +374,11 @@ struct rt_rq {
 struct rt_edf_tree {
 	struct rb_root rb_root;
 	struct rb_node *rb_leftmost;
+
+#ifdef CONFIG_SMP
+	unsigned long rt_free_bw;
+	raw_spinlock_t rt_bw_lock;
+#endif
 };
 
 /* Root runqueue for rt tasks: */
@@ -458,6 +463,7 @@ struct rq {
 
 	struct cfs_rq cfs;
 	struct rt_root_rq rt;
+	int rt_balancing_disabled;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
@@ -1754,6 +1760,25 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 }
 #endif
 
+#ifdef CONFIG_RT_GROUP_SCHED
+static unsigned long to_ratio(u64 period, u64 runtime)
+{
+	if (runtime == RUNTIME_INF)
+		return 1UL << 20;
+
+	return div64_u64(runtime << 20, period);
+}
+#endif
+
+#ifdef CONFIG_SMP
+static inline unsigned long rt_init_free_bw(void)
+{
+	unsigned long used = to_ratio(global_rt_period(), global_rt_runtime());
+
+	return to_ratio(RUNTIME_INF, RUNTIME_INF) - used;
+}
+#endif
+
 static void calc_load_account_active(struct rq *this_rq);
 static void update_sysctl(void);
 static int get_update_sysctl_factor(void);
@@ -7563,6 +7588,9 @@ static void init_rt_root_rq(struct rt_root_rq *rt, struct rq *rq)
 	rt->rt_nr_migratory = 0;
 	rt->overloaded = 0;
 	plist_head_init_raw(&rt->pushable_tasks, &rq->lock);
+
+	rt->rt_edf_tree.rt_free_bw = rt_init_free_bw();
+	raw_spin_lock_init(&rt->rt_edf_tree.rt_bw_lock);
 #endif
 	rt->rt_edf_tree.rb_root = RB_ROOT;
 	init_rt_rq(&rt->rt_rq, rq, &def_rt_bandwidth);
@@ -8114,7 +8142,11 @@ static void free_sched_group(struct task_group *tg)
 	kfree(tg);
 }
 
-/* allocate runqueue etc for a new task group */
+/*
+ * Allocate runqueue etc for a new task group.  Note that new groups
+ * are created with zero runtime, so there is no need to update the
+ * free bandwidth counters.
+ */
 struct task_group *sched_create_group(struct task_group *parent)
 {
 	struct task_group *tg;
@@ -8159,6 +8191,8 @@ static void free_sched_group_rcu(struct rcu_head *rhp)
 	free_sched_group(container_of(rhp, struct task_group, rcu));
 }
 
+static DEFINE_MUTEX(rt_constraints_mutex);
+
 /* Destroy runqueue etc associated with a task group */
 void sched_destroy_group(struct task_group *tg)
 {
@@ -8174,6 +8208,10 @@ void sched_destroy_group(struct task_group *tg)
 	list_del_rcu(&tg->siblings);
 	spin_unlock_irqrestore(&task_group_lock, flags);
 
+	mutex_lock(&rt_constraints_mutex);
+	rt_reset_runtime();
+	mutex_unlock(&rt_constraints_mutex);
+
 	/* wait for possible concurrent references to cfs_rqs complete */
 	call_rcu(&tg->rcu, free_sched_group_rcu);
 }
@@ -8313,15 +8351,6 @@ unsigned long sched_group_shares(struct task_group *tg)
 /*
  * Ensure that the real time constraints are schedulable.
  */
-static DEFINE_MUTEX(rt_constraints_mutex);
-
-static unsigned long to_ratio(u64 period, u64 runtime)
-{
-	if (runtime == RUNTIME_INF)
-		return 1ULL << 20;
-
-	return div64_u64(runtime << 20, period);
-}
 
 /* Must be called with tasklist_lock held */
 static inline int tg_has_rt_tasks(struct task_group *tg)
@@ -8442,7 +8471,7 @@ static int __rt_schedulable(struct task_group *tg, u64 period,
 static int tg_set_bandwidth(struct task_group *tg, int task_data,
 		u64 rt_period, u64 rt_runtime)
 {
-	int i, err = 0;
+	int err = 0;
 
 	mutex_lock(&rt_constraints_mutex);
 	read_lock(&tasklist_lock);
@@ -8454,15 +8483,6 @@ static int tg_set_bandwidth(struct task_group *tg, int task_data,
 		raw_spin_lock_irq(&tg->rt_task_bandwidth.rt_runtime_lock);
 		tg->rt_task_bandwidth.rt_period = ns_to_ktime(rt_period);
 		tg->rt_task_bandwidth.rt_runtime = rt_runtime;
-
-		for_each_possible_cpu(i) {
-			struct rt_rq *rt_rq = tg->rt_rq[i];
-
-			raw_spin_lock(&rt_rq->rt_runtime_lock);
-			rt_rq->rt_runtime = rt_runtime;
-			rt_rq->rt_period = ns_to_ktime(rt_period);
-			raw_spin_unlock(&rt_rq->rt_runtime_lock);
-		}
 		raw_spin_unlock_irq(&tg->rt_task_bandwidth.rt_runtime_lock);
 	} else {
 		raw_spin_lock_irq(&tg->rt_bandwidth.rt_runtime_lock);
@@ -8473,6 +8493,8 @@ static int tg_set_bandwidth(struct task_group *tg, int task_data,
 
 unlock:
 	read_unlock(&tasklist_lock);
+	if (task_data)
+		rt_reset_runtime();
 	mutex_unlock(&rt_constraints_mutex);
 
 	return err;
@@ -8568,12 +8590,12 @@ int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
 	return 1;
 }
 
+static inline void sched_rt_update_bandwidth(void) {}
+
 #else /* !CONFIG_RT_GROUP_SCHED */
+
 static int sched_rt_global_constraints(void)
 {
-	unsigned long flags;
-	int i;
-
 	if (sysctl_sched_rt_period <= 0)
 		return -EINVAL;
 
@@ -8586,7 +8608,7 @@ static int sched_rt_global_constraints(void)
 
 	raw_spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
 	for_each_possible_cpu(i) {
-		struct rt_rq *rt_rq = &cpu_rq(i)->rt;
+		struct rt_rq *rt_rq = &cpu_rq(i)->rt.rt_rq;
 
 		raw_spin_lock(&rt_rq->rt_runtime_lock);
 		rt_rq->rt_runtime = global_rt_runtime();
@@ -8596,6 +8618,12 @@ static int sched_rt_global_constraints(void)
 
 	return 0;
 }
+
+static inline void sched_rt_update_bandwidth(void)
+{
+	rt_reset_runtime();
+}
+
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 int sched_rt_handler(struct ctl_table *table, int write,
@@ -8621,6 +8649,7 @@ int sched_rt_handler(struct ctl_table *table, int write,
 			def_rt_bandwidth.rt_runtime = global_rt_runtime();
 			def_rt_bandwidth.rt_period =
 				ns_to_ktime(global_rt_period());
+			sched_rt_update_bandwidth();
 		}
 	}
 	mutex_unlock(&mutex);
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 7b8af0b..27768bd 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -360,27 +360,218 @@ static inline int rt_time_before(u64 a, u64 b)
 }
 
 #ifdef CONFIG_SMP
+
 /*
- * We ran out of runtime, see if we can borrow some from our neighbours.
+ * Reset the balancing machinery, restarting from a safe runtime assignment
+ * on all the cpus/rt_rqs in the system.  There is room for improvements here,
+ * as this iterates through all the rt_rqs in the system; the main problem
+ * is that after the balancing has been running for some time we are not
+ * sure that the fragmentation of the free bandwidth it produced allows new
+ * groups to run where they need to run.  The caller has to make sure that
+ * only one instance of this function is running at any time.
  */
-static int do_balance_runtime(struct rt_rq *rt_rq)
+static void __rt_reset_runtime(void)
 {
-	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
-	struct root_domain *rd = cpu_rq(smp_processor_id())->rd;
-	int i, weight, more = 0;
+	struct rq *rq;
+	struct rt_rq *rt_rq;
+	struct rt_bandwidth *rt_b;
+	unsigned long flags;
+	int i;
+
+	for_each_possible_cpu(i) {
+		rq = cpu_rq(i);
+
+		rq->rt_balancing_disabled = 1;
+		/*
+		 * Make sure that all the new calls to do_balance_runtime()
+		 * see the disable flag and do not migrate anything.  We will
+		 * implicitly wait for the old ones to terminate entering all
+		 * the rt_b->rt_runtime_lock, one by one.  Note that maybe
+		 * iterating over the task_groups first would be a good idea...
+		 */
+		smp_wmb();
+
+		for_each_leaf_rt_rq(rt_rq, rq) {
+			rt_b = sched_rt_bandwidth(rt_rq);
+
+			raw_spin_lock_irqsave(&rt_b->rt_runtime_lock, flags);
+			raw_spin_lock(&rt_rq->rt_runtime_lock);
+			rt_rq->rt_runtime = rt_b->rt_runtime;
+			rt_rq->rt_period = rt_b->rt_period;
+			rt_rq->rt_time = 0;
+			raw_spin_unlock(&rt_rq->rt_runtime_lock);
+			raw_spin_unlock_irqrestore(&rt_b->rt_runtime_lock, flags);
+		}
+	}
+}
+
+#ifdef CONFIG_RT_GROUP_SCHED
+
+static unsigned long rt_used_bandwidth(void)
+{
+	struct task_group *tg;
+	unsigned long used = 0;
 	u64 rt_period;
 
+	rcu_read_lock();
+	list_for_each_entry_rcu(tg, &task_groups, list) {
+		rt_period = ktime_to_ns(tg->rt_task_bandwidth.rt_period);
+		used += to_ratio(rt_period, tg->rt_task_bandwidth.rt_runtime);
+	}
+	rcu_read_unlock();
+
+	return used;
+}
+
+#else
+
+static unsigned long rt_used_bandwidth(void)
+{
+	return to_ratio(global_rt_period(), global_rt_runtime());
+}
+
+#endif
+
+static void __rt_restart_balancing(void)
+{
+	unsigned long used, global, free;
+	struct rq *rq;
+	int i;
+
+	used = rt_used_bandwidth();
+	global = to_ratio(RUNTIME_INF, RUNTIME_INF);
+
+	free = global - used;
+
+	for_each_possible_cpu(i) {
+		rq = cpu_rq(i);
+
+		/*
+		 * Lockless: balancing is disabled, and any previous
+		 * balancing operation is terminated.
+		 */
+		rq->rt.rt_edf_tree.rt_free_bw = free;
+
+		/*
+		 * Make sure that before restarting balancing everyone
+		 * sees the new free bandwidth.
+		 */
+		smp_wmb();
+
+		BUG_ON(!rq->rt_balancing_disabled);
+		rq->rt_balancing_disabled = 0;
+	}
+}
+
+static void rt_reset_runtime(void)
+{
+	__rt_reset_runtime();
+	__rt_restart_balancing();
+}
+
+static inline void double_spin_lock(raw_spinlock_t *lock1,
+				    raw_spinlock_t *lock2)
+	__acquires(lock1)
+	__acquires(lock2)
+{
+	if (lock1 < lock2) {
+		raw_spin_lock(lock1);
+		raw_spin_lock_nested(lock2, SINGLE_DEPTH_NESTING);
+	} else {
+		raw_spin_lock(lock2);
+		raw_spin_lock_nested(lock1, SINGLE_DEPTH_NESTING);
+	}
+}
+
+static inline void double_spin_unlock(raw_spinlock_t *lock1,
+				      raw_spinlock_t *lock2)
+	__releases(lock1)
+	__releases(lock2)
+{
+	raw_spin_unlock(lock1);
+	lock_set_subclass(&lock2->dep_map, 0, _RET_IP_);
+	raw_spin_unlock(lock2);
+}
+
+static u64 from_ratio(unsigned long ratio, u64 period)
+{
+	return (ratio * period) >> 20;
+}
+
+/*
+ * Try to move *diff units of runtime from src to dst, checking
+ * that the utilization does not exceed the global limits on the
+ * destination cpu.  Returns true if the migration succeeded, leaving
+ * in *diff the actual amount of runtime moved, false on failure, which
+ * means that no more bandwidth can be migrated to rt_rq.
+ */
+static int rt_move_bw(struct rt_rq *src, struct rt_rq *dst,
+		       s64 *diff, u64 rt_period)
+{
+	struct rq *rq = rq_of_rt_rq(dst), *src_rq = rq_of_rt_rq(src);
+	struct rt_edf_tree *dtree = &rq->rt.rt_edf_tree;
+	struct rt_edf_tree *stree = &src_rq->rt.rt_edf_tree;
+	unsigned long bw_to_move;
+	int ret = 0;
+
+	double_spin_lock(&dtree->rt_bw_lock, &stree->rt_bw_lock);
+
+	if (dtree->rt_free_bw) {
+		bw_to_move = to_ratio(rt_period, *diff);
+		if (bw_to_move > dtree->rt_free_bw) {
+			bw_to_move = dtree->rt_free_bw;
+			*diff = from_ratio(bw_to_move, rt_period);
+		}
+
+		stree->rt_free_bw -= bw_to_move;
+		dtree->rt_free_bw += bw_to_move;
+		ret = 1;
+	}
+
+	double_spin_unlock(&dtree->rt_bw_lock, &stree->rt_bw_lock);
+
+	return ret;
+}
+
+/*
+ * Handle runtime rebalancing: try to push our bandwidth to
+ * runqueues that need it.
+ */
+static void do_balance_runtime(struct rt_rq *rt_rq)
+{
+	struct rq *rq = cpu_rq(smp_processor_id());
+	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+	struct root_domain *rd = rq->rd;
+	int i, weight, ret;
+	u64 rt_period, prev_runtime;
+	s64 diff;
+
 	weight = cpumask_weight(rd->span);
 
 	raw_spin_lock(&rt_b->rt_runtime_lock);
+	/*
+	 * The raw_spin_lock() acts as an acquire barrier, ensuring
+	 * that rt_balancing_disabled is accessed after taking the lock;
+	 * since rt_reset_runtime() takes rt_runtime_lock after
+	 * setting the disable flag we are sure that no bandwidth
+	 * is migrated while the reset is in progress.
+	 */
+	if (rq->rt_balancing_disabled)
+		goto out;
+
+	prev_runtime = rt_rq->rt_runtime;
 	rt_period = ktime_to_ns(rt_b->rt_period);
+
 	for_each_cpu(i, rd->span) {
 		struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
-		s64 diff;
+		struct rq *iter_rq = rq_of_rt_rq(iter);
 
 		if (iter == rt_rq)
 			continue;
 
+		if (iter_rq->rt_balancing_disabled)
+			continue;
+
 		raw_spin_lock(&iter->rt_runtime_lock);
 		/*
 		 * Either all rqs have inf runtime and there's nothing to steal
@@ -399,10 +590,14 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
 			diff = div_u64((u64)diff, weight);
 			if (rt_rq->rt_runtime + diff > rt_period)
 				diff = rt_period - rt_rq->rt_runtime;
-			iter->rt_runtime -= diff;
-			rt_rq->rt_runtime += diff;
-			more = 1;
-			if (rt_rq->rt_runtime == rt_period) {
+
+			ret = rt_move_bw(iter, rt_rq, &diff, rt_period);
+			if (ret) {
+				iter->rt_runtime -= diff;
+				rt_rq->rt_runtime += diff;
+			}
+
+			if (!ret || rt_rq->rt_runtime == rt_period) {
 				raw_spin_unlock(&iter->rt_runtime_lock);
 				break;
 			}
@@ -410,9 +605,34 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
 next:
 		raw_spin_unlock(&iter->rt_runtime_lock);
 	}
-	raw_spin_unlock(&rt_b->rt_runtime_lock);
 
-	return more;
+	/*
+	 * If the runqueue is not throttled, changing its runtime
+	 * without updating its deadline could create transients during
+	 * which the rt_rq uses more bandwidth than assigned.  Here vtime
+	 * is the time instant when an ideal server with prev_runtime /
+	 * rt_period utilization would have given the same amount of
+	 * service to rt_rq as it actually received.  At this time instant
+	 * it is true that rt_time = vtime * prev_runtime / rt_period,
+	 * (the service in the ideal server grows linearly at the nominal
+	 * rate allocated to rt_rq), so we can invert the relation to
+	 * find vtime and calculate the new deadline from there.  If the
+	 * vtime is in the past then rt_rq is lagging behind the ideal
+	 * system and we cannot risk an overload afterwards, so we just
+	 * restart from rq->clock.
+	 */
+	if (!rt_rq_throttled(rt_rq) && prev_runtime != rt_rq->rt_runtime) {
+		u64 vtime = rt_rq->rt_deadline - rt_period +
+			div64_u64(rt_rq->rt_time * rt_period, prev_runtime);
+
+		if (rt_time_before(vtime, rq->clock))
+			vtime = rq->clock;
+
+		rt_rq->rt_deadline = vtime + rt_period;
+		sched_rt_deadline_updated(rt_rq);
+	}
+out:
+	raw_spin_unlock(&rt_b->rt_runtime_lock);
 }
 
 /*
@@ -536,22 +756,35 @@ static void enable_runtime(struct rq *rq)
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
-static int balance_runtime(struct rt_rq *rt_rq)
+static inline void balance_runtime(struct rt_rq *rt_rq)
 {
-	int more = 0;
-
 	if (rt_rq->rt_time > rt_rq->rt_runtime) {
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
-		more = do_balance_runtime(rt_rq);
+		do_balance_runtime(rt_rq);
 		raw_spin_lock(&rt_rq->rt_runtime_lock);
 	}
-
-	return more;
 }
+
 #else /* !CONFIG_SMP */
-static inline int balance_runtime(struct rt_rq *rt_rq)
+
+static void rt_reset_runtime(void)
 {
-	return 0;
+	struct rq *rq = this_rq();
+	struct rt_bandwidth *rt_b;
+	struct rt_rq *rt_rq;
+	unsigned long flags;
+
+	for_each_leaf_rt_rq(rt_rq, rq) {
+		rt_b = sched_rt_bandwidth(rt_rq);
+
+		raw_spin_lock_irqsave(&rt_b->rt_runtime_lock, flags);
+		raw_spin_lock(&rt_rq->rt_runtime_lock);
+		rt_rq->rt_runtime = rt_b->rt_runtime;
+		rt_rq->rt_period = rt_b->rt_period;
+		rt_rq->rt_time = 0;
+		raw_spin_unlock(&rt_rq->rt_runtime_lock);
+		raw_spin_unlock_irqrestore(&rt_b->rt_runtime_lock, flags);
+	}
 }
 #endif /* CONFIG_SMP */
 
@@ -571,7 +804,12 @@ static int __do_sched_rt_period_timer(struct rt_rq *rt_rq, int overrun)
 	int idle = 1;
 	u64 runtime;
 
-	if (rt_rq->rt_time) {
+	/*
+	 * !rt_rq->rt_time && rt_rq->rt_throttled can happen if rt_rq
+	 * changed its parameters, we update them lazily here, to avoid
+	 * touching the timer from the configuration code.
+	 */
+	if (rt_rq->rt_time || rt_rq->rt_throttled) {
 		runtime = rt_rq->rt_runtime;
 		rt_rq->rt_time -= min(rt_rq->rt_time, overrun * runtime);
 		rt_rq->rt_deadline += overrun * ktime_to_ns(rt_rq->rt_period);
-- 
1.6.5.7



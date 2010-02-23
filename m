Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab0BWSsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 13:48:37 -0500
Received: from ms01.sssup.it ([193.205.80.99]:56181 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753383Ab0BWSsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 13:48:32 -0500
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
Subject: [PATCH 1/3] sched: use EDF to schedule groups
Date: Tue, 23 Feb 2010 19:56:33 +0100
Message-Id: <4aed689fbdd9a7e4c625d4dd4f85533ec61722ef.1266931410.git.fabio@helm.retis>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <cover.1266931410.git.fabio@helm.retis>
References: <cover.1266931410.git.fabio@helm.retis>
In-Reply-To: <cover.1266931410.git.fabio@helm.retis>
References: <cover.1266931410.git.fabio@helm.retis>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify sched_rt in order to implement throttling using  EDF among groups;
this allows the user to specify groups with different periods.

This patch:
  - adds a deadline to rt_rq's (and removes the scheduling entity from
    it, as the new two-level compression of the full cgroup hierarchy do
    not use it for intermediates nodes anymore);
  - moves the rt_period_timer from struct rt_bandwidth to struct rt_rq,
    since periods and replenishments are no more synchronized among rt_rq's
    belonging to the same task_group;
  - adds a new struct rt_bandwidth to each task_group; the old one is
    used only for admission control, on a full cgroup hierarchy, while the
    new one is used to contain the parameters used to reserve bandwidth
    to tasks;
  - introduces a per-rq rt_edf_tree structure, to keep all the rt_rq's
    belonging to the same cpu ordered by their dynamic priority (i.e.,
    their deadline, if they are not boosted, or the static priority of
    their highest priority task if they are);
  - updates the admission control code, to take into account the bandwidth
    assigned to tasks via the new cgroup attributes rt_task_period_us and
    rt_task_runtime_us (this bandwidth is not available for lower-level
    cgroups);
  - removes highest_prio tracking for non-root rt_rq's and flattens the
    arbitrary task_group hierarchy to a two-level one, transparently to
    the users, who still see the full cgroup hierarchy.  The push/pull
    logic is altered a bit after this change, as the toplevel
    rt_nr_running is no more meaningful, we use rt_nr_total instead
    (the reasoning behind this is that tasks should be pushed/pulled
     without taking into account the fact that they are throttled or not).
    The toplevel runqueue, containing both the rt_edf_tree and the
    highest_prio data is no more a rt_rq, but it has its own type,
    rt_root_rq.

Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
---
 include/linux/sched.h |    8 +-
 kernel/sched.c        |  404 ++++++++++++++------------
 kernel/sched_rt.c     |  775 ++++++++++++++++++++++++++++++++++---------------
 3 files changed, 764 insertions(+), 423 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0eef87b..b82343b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2517,12 +2517,12 @@ extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
 extern unsigned long sched_group_shares(struct task_group *tg);
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
-extern int sched_group_set_rt_runtime(struct task_group *tg,
+extern int sched_group_set_rt_runtime(struct task_group *tg, int task_data,
 				      long rt_runtime_us);
-extern long sched_group_rt_runtime(struct task_group *tg);
-extern int sched_group_set_rt_period(struct task_group *tg,
+extern long sched_group_rt_runtime(struct task_group *tg, int task_data);
+extern int sched_group_set_rt_period(struct task_group *tg, int task_data,
 				      long rt_period_us);
-extern long sched_group_rt_period(struct task_group *tg);
+extern long sched_group_rt_period(struct task_group *tg, int task_data);
 extern int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk);
 #endif
 #endif
diff --git a/kernel/sched.c b/kernel/sched.c
index 9a1705e..fe013c6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -144,34 +144,10 @@ struct rt_bandwidth {
 	raw_spinlock_t		rt_runtime_lock;
 	ktime_t			rt_period;
 	u64			rt_runtime;
-	struct hrtimer		rt_period_timer;
 };
 
 static struct rt_bandwidth def_rt_bandwidth;
 
-static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
-
-static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
-{
-	struct rt_bandwidth *rt_b =
-		container_of(timer, struct rt_bandwidth, rt_period_timer);
-	ktime_t now;
-	int overrun;
-	int idle = 0;
-
-	for (;;) {
-		now = hrtimer_cb_get_time(timer);
-		overrun = hrtimer_forward(timer, now, rt_b->rt_period);
-
-		if (!overrun)
-			break;
-
-		idle = do_sched_rt_period_timer(rt_b, overrun);
-	}
-
-	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
-}
-
 static
 void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime)
 {
@@ -179,10 +155,6 @@ void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime)
 	rt_b->rt_runtime = runtime;
 
 	raw_spin_lock_init(&rt_b->rt_runtime_lock);
-
-	hrtimer_init(&rt_b->rt_period_timer,
-			CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	rt_b->rt_period_timer.function = sched_rt_period_timer;
 }
 
 static inline int rt_bandwidth_enabled(void)
@@ -190,43 +162,6 @@ static inline int rt_bandwidth_enabled(void)
 	return sysctl_sched_rt_runtime >= 0;
 }
 
-static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
-{
-	ktime_t now;
-
-	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
-		return;
-
-	if (hrtimer_active(&rt_b->rt_period_timer))
-		return;
-
-	raw_spin_lock(&rt_b->rt_runtime_lock);
-	for (;;) {
-		unsigned long delta;
-		ktime_t soft, hard;
-
-		if (hrtimer_active(&rt_b->rt_period_timer))
-			break;
-
-		now = hrtimer_cb_get_time(&rt_b->rt_period_timer);
-		hrtimer_forward(&rt_b->rt_period_timer, now, rt_b->rt_period);
-
-		soft = hrtimer_get_softexpires(&rt_b->rt_period_timer);
-		hard = hrtimer_get_expires(&rt_b->rt_period_timer);
-		delta = ktime_to_ns(ktime_sub(hard, soft));
-		__hrtimer_start_range_ns(&rt_b->rt_period_timer, soft, delta,
-				HRTIMER_MODE_ABS_PINNED, 0);
-	}
-	raw_spin_unlock(&rt_b->rt_runtime_lock);
-}
-
-#ifdef CONFIG_RT_GROUP_SCHED
-static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
-{
-	hrtimer_cancel(&rt_b->rt_period_timer);
-}
-#endif
-
 /*
  * sched_domains_mutex serializes calls to arch_init_sched_domains,
  * detach_destroy_domains and partition_sched_domains.
@@ -254,10 +189,13 @@ struct task_group {
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
-	struct sched_rt_entity **rt_se;
 	struct rt_rq **rt_rq;
 
+	/* CPU bandwidth reserved to this group (tasks + child groups). */
 	struct rt_bandwidth rt_bandwidth;
+
+	/* CPU bandwidth reserved to the tasks in this group. */
+	struct rt_bandwidth rt_task_bandwidth;
 #endif
 
 	struct rcu_head rcu;
@@ -329,7 +267,6 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 
 #ifdef CONFIG_RT_GROUP_SCHED
 	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
-	p->rt.parent = task_group(p)->rt_se[cpu];
 #endif
 }
 
@@ -410,6 +347,37 @@ struct cfs_rq {
 struct rt_rq {
 	struct rt_prio_array active;
 	unsigned long rt_nr_running;
+	struct rb_node rb_node;
+	int rt_throttled;
+
+	int highest_prio;
+
+	u64 rt_deadline;
+	u64 rt_time;
+	u64 rt_runtime;
+	ktime_t rt_period;
+
+	struct hrtimer rt_period_timer;
+
+	/* Nests inside the rq lock: */
+	raw_spinlock_t rt_runtime_lock;
+
+	unsigned long rt_nr_boosted;
+
+#ifdef CONFIG_RT_GROUP_SCHED
+	struct rq *rq;
+	struct list_head leaf_rt_rq_list;
+	struct task_group *tg;
+#endif
+};
+
+struct rt_edf_tree {
+	struct rb_root rb_root;
+	struct rb_node *rb_leftmost;
+};
+
+/* Root runqueue for rt tasks: */
+struct rt_root_rq {
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	struct {
 		int curr; /* highest queued rt task prio */
@@ -424,19 +392,8 @@ struct rt_rq {
 	int overloaded;
 	struct plist_head pushable_tasks;
 #endif
-	int rt_throttled;
-	u64 rt_time;
-	u64 rt_runtime;
-	/* Nests inside the rq lock: */
-	raw_spinlock_t rt_runtime_lock;
-
-#ifdef CONFIG_RT_GROUP_SCHED
-	unsigned long rt_nr_boosted;
-
-	struct rq *rq;
-	struct list_head leaf_rt_rq_list;
-	struct task_group *tg;
-#endif
+	struct rt_edf_tree rt_edf_tree;
+	struct rt_rq rt_rq;
 };
 
 #ifdef CONFIG_SMP
@@ -500,7 +457,7 @@ struct rq {
 	u64 nr_switches;
 
 	struct cfs_rq cfs;
-	struct rt_rq rt;
+	struct rt_root_rq rt;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
@@ -4560,7 +4517,7 @@ recheck:
 		 * assigned.
 		 */
 		if (rt_bandwidth_enabled() && rt_policy(policy) &&
-				task_group(p)->rt_bandwidth.rt_runtime == 0)
+		    task_group(p)->rt_task_bandwidth.rt_runtime == 0)
 			return -EPERM;
 #endif
 
@@ -7561,7 +7518,8 @@ static void init_cfs_rq(struct cfs_rq *cfs_rq, struct rq *rq)
 	cfs_rq->min_vruntime = (u64)(-(1LL << 20));
 }
 
-static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
+static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq,
+		       struct rt_bandwidth *rt_b)
 {
 	struct rt_prio_array *array;
 	int i;
@@ -7574,29 +7532,42 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 	/* delimiter for bitsearch: */
 	__set_bit(MAX_RT_PRIO, array->bitmap);
 
-#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
-	rt_rq->highest_prio.curr = MAX_RT_PRIO;
-#ifdef CONFIG_SMP
-	rt_rq->highest_prio.next = MAX_RT_PRIO;
-#endif
-#endif
-#ifdef CONFIG_SMP
-	rt_rq->rt_nr_migratory = 0;
-	rt_rq->overloaded = 0;
-	plist_head_init_raw(&rt_rq->pushable_tasks, &rq->lock);
-#endif
+	rt_rq->highest_prio = MAX_RT_PRIO;
 
 	rt_rq->rt_time = 0;
 	rt_rq->rt_throttled = 0;
-	rt_rq->rt_runtime = 0;
+	rt_rq->rt_deadline = 0;
+	rt_rq->rt_runtime = rt_b->rt_runtime;
+	rt_rq->rt_period = rt_b->rt_period;
 	raw_spin_lock_init(&rt_rq->rt_runtime_lock);
 
+	hrtimer_init(&rt_rq->rt_period_timer, CLOCK_MONOTONIC,
+		     HRTIMER_MODE_REL);
+	rt_rq->rt_period_timer.function = sched_rt_period_timer;
+
 #ifdef CONFIG_RT_GROUP_SCHED
 	rt_rq->rt_nr_boosted = 0;
 	rt_rq->rq = rq;
 #endif
 }
 
+static void init_rt_root_rq(struct rt_root_rq *rt, struct rq *rq)
+{
+#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
+	rt->highest_prio.curr = MAX_RT_PRIO;
+#ifdef CONFIG_SMP
+	rt->highest_prio.next = MAX_RT_PRIO;
+#endif
+#endif
+#ifdef CONFIG_SMP
+	rt->rt_nr_migratory = 0;
+	rt->overloaded = 0;
+	plist_head_init_raw(&rt->pushable_tasks, &rq->lock);
+#endif
+	rt->rt_edf_tree.rb_root = RB_ROOT;
+	init_rt_rq(&rt->rt_rq, rq, &def_rt_bandwidth);
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 				struct sched_entity *se, int cpu, int add,
@@ -7628,30 +7599,17 @@ static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 
 #ifdef CONFIG_RT_GROUP_SCHED
 static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
-		struct sched_rt_entity *rt_se, int cpu, int add,
-		struct sched_rt_entity *parent)
+			     int cpu, int add)
 {
 	struct rq *rq = cpu_rq(cpu);
 
 	tg->rt_rq[cpu] = rt_rq;
-	init_rt_rq(rt_rq, rq);
+	init_rt_rq(rt_rq, rq, &tg->rt_task_bandwidth);
 	rt_rq->tg = tg;
-	rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
 	if (add)
 		list_add(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);
 
-	tg->rt_se[cpu] = rt_se;
-	if (!rt_se)
-		return;
-
-	if (!parent)
-		rt_se->rt_rq = &rq->rt;
-	else
-		rt_se->rt_rq = parent->my_q;
-
-	rt_se->my_q = rt_rq;
-	rt_se->parent = parent;
-	INIT_LIST_HEAD(&rt_se->run_list);
+	RB_CLEAR_NODE(&rt_rq->rb_node);
 }
 #endif
 
@@ -7664,7 +7622,7 @@ void __init sched_init(void)
 	alloc_size += 2 * nr_cpu_ids * sizeof(void **);
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
-	alloc_size += 2 * nr_cpu_ids * sizeof(void **);
+	alloc_size += nr_cpu_ids * sizeof(void **);
 #endif
 #ifdef CONFIG_CPUMASK_OFFSTACK
 	alloc_size += num_possible_cpus() * cpumask_size();
@@ -7681,9 +7639,6 @@ void __init sched_init(void)
 
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 #ifdef CONFIG_RT_GROUP_SCHED
-		init_task_group.rt_se = (struct sched_rt_entity **)ptr;
-		ptr += nr_cpu_ids * sizeof(void **);
-
 		init_task_group.rt_rq = (struct rt_rq **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
 
@@ -7706,6 +7661,9 @@ void __init sched_init(void)
 #ifdef CONFIG_RT_GROUP_SCHED
 	init_rt_bandwidth(&init_task_group.rt_bandwidth,
 			global_rt_period(), global_rt_runtime());
+
+	init_rt_bandwidth(&init_task_group.rt_task_bandwidth,
+			global_rt_period(), global_rt_runtime());
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_CGROUP_SCHED
@@ -7727,7 +7685,7 @@ void __init sched_init(void)
 		rq->calc_load_active = 0;
 		rq->calc_load_update = jiffies + LOAD_FREQ;
 		init_cfs_rq(&rq->cfs, rq);
-		init_rt_rq(&rq->rt, rq);
+		init_rt_root_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		init_task_group.shares = init_task_group_load;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
@@ -7755,11 +7713,10 @@ void __init sched_init(void)
 #endif
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-		rq->rt.rt_runtime = def_rt_bandwidth.rt_runtime;
 #ifdef CONFIG_RT_GROUP_SCHED
 		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
 #ifdef CONFIG_CGROUP_SCHED
-		init_tg_rt_entry(&init_task_group, &rq->rt, NULL, i, 1, NULL);
+		init_tg_rt_entry(&init_task_group, &rq->rt.rt_rq, i, 1);
 #endif
 #endif
 
@@ -8068,38 +8025,39 @@ static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
 #ifdef CONFIG_RT_GROUP_SCHED
 static void free_rt_sched_group(struct task_group *tg)
 {
+	struct rt_rq *rt_rq;
 	int i;
 
-	destroy_rt_bandwidth(&tg->rt_bandwidth);
+	if (!tg->rt_rq)
+		return;
 
 	for_each_possible_cpu(i) {
-		if (tg->rt_rq)
-			kfree(tg->rt_rq[i]);
-		if (tg->rt_se)
-			kfree(tg->rt_se[i]);
+		rt_rq = tg->rt_rq[i];
+
+		if (rt_rq) {
+			hrtimer_cancel(&rt_rq->rt_period_timer);
+			kfree(rt_rq);
+		}
 	}
 
 	kfree(tg->rt_rq);
-	kfree(tg->rt_se);
 }
 
 static
 int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 {
 	struct rt_rq *rt_rq;
-	struct sched_rt_entity *rt_se;
 	struct rq *rq;
 	int i;
 
 	tg->rt_rq = kzalloc(sizeof(rt_rq) * nr_cpu_ids, GFP_KERNEL);
 	if (!tg->rt_rq)
 		goto err;
-	tg->rt_se = kzalloc(sizeof(rt_se) * nr_cpu_ids, GFP_KERNEL);
-	if (!tg->rt_se)
-		goto err;
 
 	init_rt_bandwidth(&tg->rt_bandwidth,
 			ktime_to_ns(def_rt_bandwidth.rt_period), 0);
+	init_rt_bandwidth(&tg->rt_task_bandwidth,
+			ktime_to_ns(def_rt_bandwidth.rt_period), 0);
 
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
@@ -8109,19 +8067,12 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 		if (!rt_rq)
 			goto err;
 
-		rt_se = kzalloc_node(sizeof(struct sched_rt_entity),
-				     GFP_KERNEL, cpu_to_node(i));
-		if (!rt_se)
-			goto err_free_rq;
-
-		init_tg_rt_entry(tg, rt_rq, rt_se, i, 0, parent->rt_se[i]);
+		init_tg_rt_entry(tg, rt_rq, i, 0);
 	}
 
 	return 1;
 
- err_free_rq:
-	kfree(rt_rq);
- err:
+err:
 	return 0;
 }
 
@@ -8389,27 +8340,65 @@ struct rt_schedulable_data {
 	struct task_group *tg;
 	u64 rt_period;
 	u64 rt_runtime;
+	int rt_task_data;
 };
 
-static int tg_schedulable(struct task_group *tg, void *data)
+static inline void rt_tg_parameters(struct task_group *tg, int task_data,
+				    u64 *period, u64 *runtime)
+{
+	struct rt_bandwidth *rt_b = task_data ? &tg->rt_task_bandwidth :
+				    &tg->rt_bandwidth;
+
+	*period = ktime_to_ns(rt_b->rt_period);
+	*runtime = rt_b->rt_runtime;
+}
+
+static unsigned long tg_utilization(struct task_group *tg,
+				    struct rt_schedulable_data *d)
 {
-	struct rt_schedulable_data *d = data;
 	struct task_group *child;
-	unsigned long total, sum = 0;
+	unsigned long sum;
 	u64 period, runtime;
 
-	period = ktime_to_ns(tg->rt_bandwidth.rt_period);
-	runtime = tg->rt_bandwidth.rt_runtime;
-
-	if (tg == d->tg) {
+	if (d && tg == d->tg && d->rt_task_data) {
 		period = d->rt_period;
 		runtime = d->rt_runtime;
+	} else
+		rt_tg_parameters(tg, 1, &period, &runtime);
+
+	/* Task utilization. */
+	sum = to_ratio(period, runtime);
+
+	/* Children utilization. */
+	list_for_each_entry_rcu(child, &tg->children, siblings) {
+		if (d && child == d->tg && !d->rt_task_data) {
+			period = d->rt_period;
+			runtime = d->rt_runtime;
+		} else
+			rt_tg_parameters(child, 0, &period, &runtime);
+
+		sum += to_ratio(period, runtime);
 	}
 
+	return sum;
+}
+
+static int tg_schedulable(struct task_group *tg, void *data)
+{
+	struct rt_schedulable_data *d = data;
+	unsigned long total, sum;
+	u64 period, runtime;
+
+	if (tg == d->tg && !d->rt_task_data) {
+		period = d->rt_period;
+		runtime = d->rt_runtime;
+	} else
+		rt_tg_parameters(tg, 0, &period, &runtime);
+
 	/*
 	 * Cannot have more runtime than the period.
 	 */
-	if (runtime > period && runtime != RUNTIME_INF)
+	if (runtime > period)
 		return -EINVAL;
 
 	/*
@@ -8429,17 +8418,7 @@ static int tg_schedulable(struct task_group *tg, void *data)
 	/*
 	 * The sum of our children's runtime should not exceed our own.
 	 */
-	list_for_each_entry_rcu(child, &tg->children, siblings) {
-		period = ktime_to_ns(child->rt_bandwidth.rt_period);
-		runtime = child->rt_bandwidth.rt_runtime;
-
-		if (child == d->tg) {
-			period = d->rt_period;
-			runtime = d->rt_runtime;
-		}
-
-		sum += to_ratio(period, runtime);
-	}
+	sum = tg_utilization(tg, d);
 
 	if (sum > total)
 		return -EINVAL;
@@ -8447,89 +8426,109 @@ static int tg_schedulable(struct task_group *tg, void *data)
 	return 0;
 }
 
-static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
+static int __rt_schedulable(struct task_group *tg, u64 period,
+			    u64 runtime, int task_data)
 {
 	struct rt_schedulable_data data = {
 		.tg = tg,
 		.rt_period = period,
 		.rt_runtime = runtime,
+		.rt_task_data = task_data,
 	};
 
 	return walk_tg_tree(tg_schedulable, tg_nop, &data);
 }
 
-static int tg_set_bandwidth(struct task_group *tg,
+static int tg_set_bandwidth(struct task_group *tg, int task_data,
 		u64 rt_period, u64 rt_runtime)
 {
 	int i, err = 0;
 
 	mutex_lock(&rt_constraints_mutex);
 	read_lock(&tasklist_lock);
-	err = __rt_schedulable(tg, rt_period, rt_runtime);
+	err = __rt_schedulable(tg, rt_period, rt_runtime, task_data);
 	if (err)
 		goto unlock;
 
-	raw_spin_lock_irq(&tg->rt_bandwidth.rt_runtime_lock);
-	tg->rt_bandwidth.rt_period = ns_to_ktime(rt_period);
-	tg->rt_bandwidth.rt_runtime = rt_runtime;
+	if (task_data) {
+		raw_spin_lock_irq(&tg->rt_task_bandwidth.rt_runtime_lock);
+		tg->rt_task_bandwidth.rt_period = ns_to_ktime(rt_period);
+		tg->rt_task_bandwidth.rt_runtime = rt_runtime;
 
-	for_each_possible_cpu(i) {
-		struct rt_rq *rt_rq = tg->rt_rq[i];
+		for_each_possible_cpu(i) {
+			struct rt_rq *rt_rq = tg->rt_rq[i];
 
-		raw_spin_lock(&rt_rq->rt_runtime_lock);
-		rt_rq->rt_runtime = rt_runtime;
-		raw_spin_unlock(&rt_rq->rt_runtime_lock);
+			raw_spin_lock(&rt_rq->rt_runtime_lock);
+			rt_rq->rt_runtime = rt_runtime;
+			rt_rq->rt_period = ns_to_ktime(rt_period);
+			raw_spin_unlock(&rt_rq->rt_runtime_lock);
+		}
+		raw_spin_unlock_irq(&tg->rt_task_bandwidth.rt_runtime_lock);
+	} else {
+		raw_spin_lock_irq(&tg->rt_bandwidth.rt_runtime_lock);
+		tg->rt_bandwidth.rt_period = ns_to_ktime(rt_period);
+		tg->rt_bandwidth.rt_runtime = rt_runtime;
+		raw_spin_unlock_irq(&tg->rt_bandwidth.rt_runtime_lock);
 	}
-	raw_spin_unlock_irq(&tg->rt_bandwidth.rt_runtime_lock);
- unlock:
+
+unlock:
 	read_unlock(&tasklist_lock);
 	mutex_unlock(&rt_constraints_mutex);
 
 	return err;
 }
 
-int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
+int sched_group_set_rt_runtime(struct task_group *tg, int task_data,
+			       long rt_runtime_us)
 {
 	u64 rt_runtime, rt_period;
 
-	rt_period = ktime_to_ns(tg->rt_bandwidth.rt_period);
+	rt_period = task_data ? ktime_to_ns(tg->rt_task_bandwidth.rt_period) :
+		    ktime_to_ns(tg->rt_bandwidth.rt_period);
 	rt_runtime = (u64)rt_runtime_us * NSEC_PER_USEC;
 	if (rt_runtime_us < 0)
 		rt_runtime = RUNTIME_INF;
 
-	return tg_set_bandwidth(tg, rt_period, rt_runtime);
+	return tg_set_bandwidth(tg, task_data, rt_period, rt_runtime);
 }
 
-long sched_group_rt_runtime(struct task_group *tg)
+long sched_group_rt_runtime(struct task_group *tg, int task_data)
 {
 	u64 rt_runtime_us;
 
-	if (tg->rt_bandwidth.rt_runtime == RUNTIME_INF)
+	rt_runtime_us = task_data ? tg->rt_task_bandwidth.rt_runtime :
+			tg->rt_bandwidth.rt_runtime;
+
+	if (rt_runtime_us == RUNTIME_INF)
 		return -1;
 
-	rt_runtime_us = tg->rt_bandwidth.rt_runtime;
 	do_div(rt_runtime_us, NSEC_PER_USEC);
 	return rt_runtime_us;
 }
 
-int sched_group_set_rt_period(struct task_group *tg, long rt_period_us)
+int sched_group_set_rt_period(struct task_group *tg, int task_data,
+			      long rt_period_us)
 {
 	u64 rt_runtime, rt_period;
 
 	rt_period = (u64)rt_period_us * NSEC_PER_USEC;
-	rt_runtime = tg->rt_bandwidth.rt_runtime;
+	rt_runtime = task_data ? tg->rt_task_bandwidth.rt_runtime :
+		     tg->rt_bandwidth.rt_runtime;
 
 	if (rt_period == 0)
 		return -EINVAL;
 
-	return tg_set_bandwidth(tg, rt_period, rt_runtime);
+	return tg_set_bandwidth(tg, task_data, rt_period, rt_runtime);
 }
 
-long sched_group_rt_period(struct task_group *tg)
+long sched_group_rt_period(struct task_group *tg, int task_data)
 {
 	u64 rt_period_us;
 
-	rt_period_us = ktime_to_ns(tg->rt_bandwidth.rt_period);
+	rt_period_us = task_data ?
+		       ktime_to_ns(tg->rt_task_bandwidth.rt_period) :
+		       ktime_to_ns(tg->rt_bandwidth.rt_period);
+
 	do_div(rt_period_us, NSEC_PER_USEC);
 	return rt_period_us;
 }
@@ -8553,7 +8552,7 @@ static int sched_rt_global_constraints(void)
 
 	mutex_lock(&rt_constraints_mutex);
 	read_lock(&tasklist_lock);
-	ret = __rt_schedulable(NULL, 0, 0);
+	ret = __rt_schedulable(NULL, 0, 0, 0);
 	read_unlock(&tasklist_lock);
 	mutex_unlock(&rt_constraints_mutex);
 
@@ -8563,7 +8562,7 @@ static int sched_rt_global_constraints(void)
 int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
 {
 	/* Don't accept realtime tasks when there is no way for them to run */
-	if (rt_task(tsk) && tg->rt_bandwidth.rt_runtime == 0)
+	if (rt_task(tsk) && tg->rt_task_bandwidth.rt_runtime == 0)
 		return 0;
 
 	return 1;
@@ -8735,23 +8734,46 @@ static u64 cpu_shares_read_u64(struct cgroup *cgrp, struct cftype *cft)
 static int cpu_rt_runtime_write(struct cgroup *cgrp, struct cftype *cft,
 				s64 val)
 {
-	return sched_group_set_rt_runtime(cgroup_tg(cgrp), val);
+	return sched_group_set_rt_runtime(cgroup_tg(cgrp), 0, val);
 }
 
 static s64 cpu_rt_runtime_read(struct cgroup *cgrp, struct cftype *cft)
 {
-	return sched_group_rt_runtime(cgroup_tg(cgrp));
+	return sched_group_rt_runtime(cgroup_tg(cgrp), 0);
 }
 
 static int cpu_rt_period_write_uint(struct cgroup *cgrp, struct cftype *cftype,
 		u64 rt_period_us)
 {
-	return sched_group_set_rt_period(cgroup_tg(cgrp), rt_period_us);
+	return sched_group_set_rt_period(cgroup_tg(cgrp), 0, rt_period_us);
 }
 
 static u64 cpu_rt_period_read_uint(struct cgroup *cgrp, struct cftype *cft)
 {
-	return sched_group_rt_period(cgroup_tg(cgrp));
+	return sched_group_rt_period(cgroup_tg(cgrp), 0);
+}
+
+static int cpu_rt_task_runtime_write(struct cgroup *cgrp, struct cftype *cft,
+				     s64 val)
+{
+	return sched_group_set_rt_runtime(cgroup_tg(cgrp), 1, val);
+}
+
+static s64 cpu_rt_task_runtime_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	return sched_group_rt_runtime(cgroup_tg(cgrp), 1);
+}
+
+static int cpu_rt_task_period_write_uint(struct cgroup *cgrp,
+					 struct cftype *cftype,
+					 u64 rt_period_us)
+{
+	return sched_group_set_rt_period(cgroup_tg(cgrp), 1, rt_period_us);
+}
+
+static u64 cpu_rt_task_period_read_uint(struct cgroup *cgrp, struct cftype *cft)
+{
+	return sched_group_rt_period(cgroup_tg(cgrp), 1);
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
@@ -8774,6 +8796,16 @@ static struct cftype cpu_files[] = {
 		.read_u64 = cpu_rt_period_read_uint,
 		.write_u64 = cpu_rt_period_write_uint,
 	},
+	{
+		.name = "rt_task_runtime_us",
+		.read_s64 = cpu_rt_task_runtime_read,
+		.write_s64 = cpu_rt_task_runtime_write,
+	},
+	{
+		.name = "rt_task_period_us",
+		.read_u64 = cpu_rt_task_period_read_uint,
+		.write_u64 = cpu_rt_task_period_write_uint,
+	},
 #endif
 };
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index bf3e38f..7b8af0b 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -5,13 +5,8 @@
 
 #ifdef CONFIG_RT_GROUP_SCHED
 
-#define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
-
 static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
 {
-#ifdef CONFIG_SCHED_DEBUG
-	WARN_ON_ONCE(!rt_entity_is_task(rt_se));
-#endif
 	return container_of(rt_se, struct task_struct, rt);
 }
 
@@ -27,8 +22,6 @@ static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
 
 #else /* CONFIG_RT_GROUP_SCHED */
 
-#define rt_entity_is_task(rt_se) (1)
-
 static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
 {
 	return container_of(rt_se, struct task_struct, rt);
@@ -36,7 +29,8 @@ static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
 
 static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
 {
-	return container_of(rt_rq, struct rq, rt);
+	struct rt_root_rq *rt = container_of(rt_rq, struct rt_root_rq, rt_rq);
+	return container_of(rt, struct rq, rt);
 }
 
 static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
@@ -44,7 +38,7 @@ static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
 	struct task_struct *p = rt_task_of(rt_se);
 	struct rq *rq = task_rq(p);
 
-	return &rq->rt;
+	return &rq->rt.rt_rq;
 }
 
 #endif /* CONFIG_RT_GROUP_SCHED */
@@ -83,45 +77,41 @@ static inline void rt_clear_overload(struct rq *rq)
 	cpumask_clear_cpu(rq->cpu, rq->rd->rto_mask);
 }
 
-static void update_rt_migration(struct rt_rq *rt_rq)
+static void update_rt_migration(struct rt_root_rq *rt)
 {
-	if (rt_rq->rt_nr_migratory && rt_rq->rt_nr_total > 1) {
-		if (!rt_rq->overloaded) {
-			rt_set_overload(rq_of_rt_rq(rt_rq));
-			rt_rq->overloaded = 1;
+	struct rq *rq = container_of(rt, struct rq, rt);
+
+	if (rt->rt_nr_migratory && rt->rt_nr_total > 1) {
+		if (!rt->overloaded) {
+			rt_set_overload(rq);
+			rt->overloaded = 1;
 		}
-	} else if (rt_rq->overloaded) {
-		rt_clear_overload(rq_of_rt_rq(rt_rq));
-		rt_rq->overloaded = 0;
+	} else if (rt->overloaded) {
+		rt_clear_overload(rq);
+		rt->overloaded = 0;
 	}
 }
 
 static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
-	if (!rt_entity_is_task(rt_se))
-		return;
-
-	rt_rq = &rq_of_rt_rq(rt_rq)->rt;
+	struct rt_root_rq *rt = &rq_of_rt_rq(rt_rq)->rt;
 
-	rt_rq->rt_nr_total++;
+	rt->rt_nr_total++;
 	if (rt_se->nr_cpus_allowed > 1)
-		rt_rq->rt_nr_migratory++;
+		rt->rt_nr_migratory++;
 
-	update_rt_migration(rt_rq);
+	update_rt_migration(rt);
 }
 
 static void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
-	if (!rt_entity_is_task(rt_se))
-		return;
-
-	rt_rq = &rq_of_rt_rq(rt_rq)->rt;
+	struct rt_root_rq *rt = &rq_of_rt_rq(rt_rq)->rt;
 
-	rt_rq->rt_nr_total--;
+	rt->rt_nr_total--;
 	if (rt_se->nr_cpus_allowed > 1)
-		rt_rq->rt_nr_migratory--;
+		rt->rt_nr_migratory--;
 
-	update_rt_migration(rt_rq);
+	update_rt_migration(rt);
 }
 
 static void enqueue_pushable_task(struct rq *rq, struct task_struct *p)
@@ -168,6 +158,18 @@ static inline int on_rt_rq(struct sched_rt_entity *rt_se)
 	return !list_empty(&rt_se->run_list);
 }
 
+static inline int rt_rq_on_rq(struct rt_rq *rt_rq)
+{
+	return !RB_EMPTY_NODE(&rt_rq->rb_node);
+}
+
+static inline int rt_rq_is_leftmost(struct rt_rq *rt_rq)
+{
+	struct rq *rq = rq_of_rt_rq(rt_rq);
+
+	return rq->rt.rt_edf_tree.rb_leftmost == &rt_rq->rb_node;
+}
+
 #ifdef CONFIG_RT_GROUP_SCHED
 
 static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
@@ -180,48 +182,41 @@ static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
 
 static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 {
-	return ktime_to_ns(rt_rq->tg->rt_bandwidth.rt_period);
+	return ktime_to_ns(rt_rq->tg->rt_task_bandwidth.rt_period);
 }
 
 #define for_each_leaf_rt_rq(rt_rq, rq) \
 	list_for_each_entry_rcu(rt_rq, &rq->leaf_rt_rq_list, leaf_rt_rq_list)
 
-#define for_each_sched_rt_entity(rt_se) \
-	for (; rt_se; rt_se = rt_se->parent)
-
-static inline struct rt_rq *group_rt_rq(struct sched_rt_entity *rt_se)
-{
-	return rt_se->my_q;
-}
-
-static void enqueue_rt_entity(struct sched_rt_entity *rt_se, bool head);
-static void dequeue_rt_entity(struct sched_rt_entity *rt_se);
+static void __dequeue_rt_rq(struct rt_rq *rt_rq);
+static void __enqueue_rt_rq(struct rt_rq *rt_rq);
 
 static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 {
-	int this_cpu = smp_processor_id();
-	struct task_struct *curr = rq_of_rt_rq(rt_rq)->curr;
-	struct sched_rt_entity *rt_se;
-
-	rt_se = rt_rq->tg->rt_se[this_cpu];
+	struct rq *rq = rq_of_rt_rq(rt_rq);
 
-	if (rt_rq->rt_nr_running) {
-		if (rt_se && !on_rt_rq(rt_se))
-			enqueue_rt_entity(rt_se, false);
-		if (rt_rq->highest_prio.curr < curr->prio)
-			resched_task(curr);
+	if (rt_rq->rt_nr_running && !rt_rq_on_rq(rt_rq)) {
+		__enqueue_rt_rq(rt_rq);
+		if (rt_rq_is_leftmost(rt_rq))
+			resched_task(rq->curr);
 	}
 }
 
 static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 {
-	int this_cpu = smp_processor_id();
-	struct sched_rt_entity *rt_se;
+	if (rt_rq_on_rq(rt_rq))
+		__dequeue_rt_rq(rt_rq);
+}
 
-	rt_se = rt_rq->tg->rt_se[this_cpu];
+static inline void sched_rt_deadline_updated(struct rt_rq *rt_rq)
+{
+	int was_leftmost = rt_rq_is_leftmost(rt_rq);
 
-	if (rt_se && on_rt_rq(rt_se))
-		dequeue_rt_entity(rt_se);
+	sched_rt_rq_dequeue(rt_rq);
+	sched_rt_rq_enqueue(rt_rq);
+
+	if (was_leftmost && !rt_rq_is_leftmost(rt_rq))
+		resched_task(rq_of_rt_rq(rt_rq)->curr);
 }
 
 static inline int rt_rq_throttled(struct rt_rq *rt_rq)
@@ -231,12 +226,8 @@ static inline int rt_rq_throttled(struct rt_rq *rt_rq)
 
 static int rt_se_boosted(struct sched_rt_entity *rt_se)
 {
-	struct rt_rq *rt_rq = group_rt_rq(rt_se);
 	struct task_struct *p;
 
-	if (rt_rq)
-		return !!rt_rq->rt_nr_boosted;
-
 	p = rt_task_of(rt_se);
 	return p->prio != p->normal_prio;
 }
@@ -256,12 +247,48 @@ static inline const struct cpumask *sched_rt_period_mask(void)
 static inline
 struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
 {
-	return container_of(rt_b, struct task_group, rt_bandwidth)->rt_rq[cpu];
+	return container_of(rt_b, struct task_group,
+			    rt_task_bandwidth)->rt_rq[cpu];
 }
 
 static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 {
-	return &rt_rq->tg->rt_bandwidth;
+	return &rt_rq->tg->rt_task_bandwidth;
+}
+
+static inline void rt_period_set_expires(struct rt_rq *rt_rq)
+{
+	ktime_t now, delta, dline;
+	struct rq *rq = rq_of_rt_rq(rt_rq);
+
+	/*
+	 * Compensate for discrepancies between rq->clock (used to
+	 * calculate deadlines) and the hrtimer-measured time, to obtain
+	 * a valid absolute time instant for the timer itself.
+	 */
+	now = hrtimer_cb_get_time(&rt_rq->rt_period_timer);
+	delta = ktime_sub_ns(now, rq->clock);
+	dline = ktime_add(ns_to_ktime(rt_rq->rt_deadline), delta);
+
+	hrtimer_set_expires(&rt_rq->rt_period_timer, dline);
+}
+
+static int __do_sched_rt_period_timer(struct rt_rq *rt_rq, int overrun);
+
+static inline void rt_compensate_overruns(struct rt_rq *rt_rq, int overrun)
+{
+	if (unlikely(overrun))
+		__do_sched_rt_period_timer(rt_rq, overrun);
+}
+
+static struct rt_rq *pick_next_rt_rq(struct rq *rq)
+{
+	struct rb_node *left = rq->rt.rt_edf_tree.rb_leftmost;
+
+	if (!left)
+		return NULL;
+
+	return rb_entry(left, struct rt_rq, rb_node);
 }
 
 #else /* !CONFIG_RT_GROUP_SCHED */
@@ -279,14 +306,6 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 #define for_each_leaf_rt_rq(rt_rq, rq) \
 	for (rt_rq = &rq->rt; rt_rq; rt_rq = NULL)
 
-#define for_each_sched_rt_entity(rt_se) \
-	for (; rt_se; rt_se = NULL)
-
-static inline struct rt_rq *group_rt_rq(struct sched_rt_entity *rt_se)
-{
-	return NULL;
-}
-
 static inline void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 {
 	if (rt_rq->rt_nr_running)
@@ -297,6 +316,8 @@ static inline void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 {
 }
 
+static inline void sched_rt_deadline_updated(struct rt_rq *rt_rq) {}
+
 static inline int rt_rq_throttled(struct rt_rq *rt_rq)
 {
 	return rt_rq->rt_throttled;
@@ -310,7 +331,7 @@ static inline const struct cpumask *sched_rt_period_mask(void)
 static inline
 struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
 {
-	return &cpu_rq(cpu)->rt;
+	return &cpu_rq(cpu)->rt.rt_rq;
 }
 
 static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
@@ -318,8 +339,26 @@ static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 	return &def_rt_bandwidth;
 }
 
+static inline void rt_period_set_expires(struct rt_rq *rt_rq) {}
+static inline void rt_compensate_overruns(struct rt_rq *rt_rq, int overrun) {}
+
+static struct rt_rq *pick_next_rt_rq(struct rq *rq)
+{
+	struct rt_rq *rt_rq = &rq->rt.rt_rq;
+
+	if (!rt_rq->rt_nr_running || rt_rq_throttled(rt_rq))
+		return NULL;
+
+	return rt_rq;
+}
+
 #endif /* CONFIG_RT_GROUP_SCHED */
 
+static inline int rt_time_before(u64 a, u64 b)
+{
+	return (s64)(a - b) < 0;
+}
+
 #ifdef CONFIG_SMP
 /*
  * We ran out of runtime, see if we can borrow some from our neighbours.
@@ -516,56 +555,119 @@ static inline int balance_runtime(struct rt_rq *rt_rq)
 }
 #endif /* CONFIG_SMP */
 
-static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
+static inline int rt_rq_needs_recharge(struct rt_rq *rt_rq)
 {
-	int i, idle = 1;
-	const struct cpumask *span;
+	if (rt_rq->rt_time)
+		return 1;
 
-	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
+	if (!rt_rq_on_rq(rt_rq))
 		return 1;
 
-	span = sched_rt_period_mask();
-	for_each_cpu(i, span) {
-		int enqueue = 0;
-		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
-		struct rq *rq = rq_of_rt_rq(rt_rq);
-
-		raw_spin_lock(&rq->lock);
-		if (rt_rq->rt_time) {
-			u64 runtime;
-
-			raw_spin_lock(&rt_rq->rt_runtime_lock);
-			if (rt_rq->rt_throttled)
-				balance_runtime(rt_rq);
-			runtime = rt_rq->rt_runtime;
-			rt_rq->rt_time -= min(rt_rq->rt_time, overrun*runtime);
-			if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
-				rt_rq->rt_throttled = 0;
-				enqueue = 1;
-			}
-			if (rt_rq->rt_time || rt_rq->rt_nr_running)
-				idle = 0;
-			raw_spin_unlock(&rt_rq->rt_runtime_lock);
-		} else if (rt_rq->rt_nr_running)
+	return 0;
+}
+
+static int __do_sched_rt_period_timer(struct rt_rq *rt_rq, int overrun)
+{
+	int idle = 1;
+	u64 runtime;
+
+	if (rt_rq->rt_time) {
+		runtime = rt_rq->rt_runtime;
+		rt_rq->rt_time -= min(rt_rq->rt_time, overrun * runtime);
+		rt_rq->rt_deadline += overrun * ktime_to_ns(rt_rq->rt_period);
+
+		if (rt_rq->rt_time || rt_rq->rt_nr_running)
 			idle = 0;
 
-		if (enqueue)
+		if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
+			/* Un-throttle (even if we were boosted). */
+			rt_rq->rt_throttled = 0;
 			sched_rt_rq_enqueue(rt_rq);
-		raw_spin_unlock(&rq->lock);
-	}
+		} else if (!rt_rq_throttled(rt_rq)) {
+			/* The deadline changed, (re-)queue rt_rq. */
+			sched_rt_deadline_updated(rt_rq);
+		}
+	} else if (rt_rq->rt_nr_running)
+		idle = 0;
+
+	return idle && !rt_rq_needs_recharge(rt_rq);
+}
+
+static int do_sched_rt_period_timer(struct rt_rq *rt_rq, int overrun)
+{
+	struct rq *rq = rq_of_rt_rq(rt_rq);
+	int idle;
+
+	if (!rt_bandwidth_enabled() || rt_rq->rt_runtime == RUNTIME_INF)
+		return 1;
+
+	raw_spin_lock(&rq->lock);
+	raw_spin_lock(&rt_rq->rt_runtime_lock);
+
+	if (rt_rq->rt_throttled)
+		balance_runtime(rt_rq);
+
+	idle = __do_sched_rt_period_timer(rt_rq, overrun);
+
+	raw_spin_unlock(&rt_rq->rt_runtime_lock);
+	raw_spin_unlock(&rq->lock);
 
 	return idle;
 }
 
-static inline int rt_se_prio(struct sched_rt_entity *rt_se)
+static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *hrtimer)
 {
-#ifdef CONFIG_RT_GROUP_SCHED
-	struct rt_rq *rt_rq = group_rt_rq(rt_se);
+	struct rt_rq *rt_rq = container_of(hrtimer, struct rt_rq,
+					   rt_period_timer);
+	int overrun, idle = 0;
 
-	if (rt_rq)
-		return rt_rq->highest_prio.curr;
-#endif
+	for (;;) {
+		overrun = hrtimer_forward_now(hrtimer, rt_rq->rt_period);
+
+		if (!overrun)
+			break;
+
+		idle = do_sched_rt_period_timer(rt_rq, overrun);
+	}
+
+	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
+}
+
+static void start_rt_period_timer(struct rt_rq *rt_rq)
+{
+	ktime_t soft, hard;
+	unsigned long range;
+	int overrun;
 
+	rt_period_set_expires(rt_rq);
+
+	for (;;) {
+		/* Timer started, we'll get our recharge. */
+		if (hrtimer_active(&rt_rq->rt_period_timer))
+			return;
+
+		/* Make sure dline is in the future when the timer starts. */
+		overrun = hrtimer_forward_now(&rt_rq->rt_period_timer,
+					      rt_rq->rt_period);
+
+		/* Update deadline and handle recharges in case of overrun. */
+		rt_compensate_overruns(rt_rq, overrun);
+
+		/* Avoid unnecessary timer expirations. */
+		if (!rt_rq_needs_recharge(rt_rq))
+			return;
+
+		/* Try to program the timer. */
+		soft = hrtimer_get_softexpires(&rt_rq->rt_period_timer);
+		hard = hrtimer_get_expires(&rt_rq->rt_period_timer);
+		range = ktime_to_ns(ktime_sub(hard, soft));
+		__hrtimer_start_range_ns(&rt_rq->rt_period_timer, soft,
+					 range, HRTIMER_MODE_ABS, 0);
+	}
+}
+
+static inline int rt_se_prio(struct sched_rt_entity *rt_se)
+{
 	return rt_task_of(rt_se)->prio;
 }
 
@@ -586,6 +688,7 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 
 	if (rt_rq->rt_time > runtime) {
 		rt_rq->rt_throttled = 1;
+		start_rt_period_timer(rt_rq);
 		if (rt_rq_throttled(rt_rq)) {
 			sched_rt_rq_dequeue(rt_rq);
 			return 1;
@@ -626,16 +729,12 @@ static void update_curr_rt(struct rq *rq)
 	if (!rt_bandwidth_enabled())
 		return;
 
-	for_each_sched_rt_entity(rt_se) {
-		rt_rq = rt_rq_of_se(rt_se);
-
-		if (sched_rt_runtime(rt_rq) != RUNTIME_INF) {
-			raw_spin_lock(&rt_rq->rt_runtime_lock);
-			rt_rq->rt_time += delta_exec;
-			if (sched_rt_runtime_exceeded(rt_rq))
-				resched_task(curr);
-			raw_spin_unlock(&rt_rq->rt_runtime_lock);
-		}
+	if (sched_rt_runtime(rt_rq) != RUNTIME_INF) {
+		raw_spin_lock(&rt_rq->rt_runtime_lock);
+		rt_rq->rt_time += delta_exec;
+		if (sched_rt_runtime_exceeded(rt_rq))
+			resched_task(curr);
+		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 	}
 }
 
@@ -653,94 +752,134 @@ static inline int next_prio(struct rq *rq)
 		return MAX_RT_PRIO;
 }
 
-static void
-inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
+static void inc_rq_next_prio(struct rq *rq, int prio, int prev_prio)
 {
-	struct rq *rq = rq_of_rt_rq(rt_rq);
+	struct rt_root_rq *rt = &rq->rt;
 
 	if (prio < prev_prio) {
-
 		/*
 		 * If the new task is higher in priority than anything on the
 		 * run-queue, we know that the previous high becomes our
 		 * next-highest.
 		 */
-		rt_rq->highest_prio.next = prev_prio;
+		rt->highest_prio.next = prev_prio;
 
 		if (rq->online)
 			cpupri_set(&rq->rd->cpupri, rq->cpu, prio);
-
-	} else if (prio == rt_rq->highest_prio.curr)
+	} else if (prio == rt->highest_prio.curr) {
 		/*
 		 * If the next task is equal in priority to the highest on
 		 * the run-queue, then we implicitly know that the next highest
 		 * task cannot be any lower than current
 		 */
-		rt_rq->highest_prio.next = prio;
-	else if (prio < rt_rq->highest_prio.next)
+		rt->highest_prio.next = prio;
+	} else if (prio < rt->highest_prio.next) {
 		/*
 		 * Otherwise, we need to recompute next-highest
 		 */
-		rt_rq->highest_prio.next = next_prio(rq);
+		rt->highest_prio.next = next_prio(rq);
+	}
 }
 
-static void
-dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
+static void dec_rq_next_prio(struct rq *rq, int prio, int prev_prio)
+{
+	struct rt_root_rq *rt = &rq->rt;
+
+	if (rt->rt_nr_total && (prio <= rt->highest_prio.next))
+		rt->highest_prio.next = next_prio(rq);
+
+	if (rq->online && rt->highest_prio.curr != prev_prio)
+		cpupri_set(&rq->rd->cpupri, rq->cpu, rt->highest_prio.curr);
+}
+
+static inline void inc_rq_prio(struct rt_rq *rt_rq, int prio)
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);
+	int prev_prio = rq->rt.highest_prio.curr;
+
+	if (prio < prev_prio)
+		rq->rt.highest_prio.curr = prio;
 
-	if (rt_rq->rt_nr_running && (prio <= rt_rq->highest_prio.next))
-		rt_rq->highest_prio.next = next_prio(rq);
+	inc_rq_next_prio(rq, prio, prev_prio);
+}
+
+static inline int find_highest_prio(struct rq *rq)
+{
+	struct rt_rq *rt_rq;
+	int max = MAX_RT_PRIO;
+
+	for_each_leaf_rt_rq(rt_rq, rq) {
+		if (rt_rq->highest_prio < max)
+			max = rt_rq->highest_prio;
+	}
+
+	return max;
+}
+
+static void dec_rq_prio(struct rt_rq *rt_rq, int prio)
+{
+	struct rq *rq = rq_of_rt_rq(rt_rq);
+	int prev_prio = rq->rt.highest_prio.curr;
+
+	if (rq->rt.rt_nr_total) {
+		WARN_ON(prio < prev_prio);
+		/*
+		 * This may have been our highest task, and therefore
+		 * we may have some recomputation to do; since rq->rt
+		 * does not contain tasks/groups, we have to look into
+		 * the child runqueues.  (A possible optimization would
+		 * be using the prio_array of rq->rt to store entities
+		 * for the group, but with per-group balancing this
+		 * lookup will be no longer necessary.)
+		 */
+		if (prio == prev_prio)
+			rq->rt.highest_prio.curr = find_highest_prio(rq);
+	} else
+		rq->rt.highest_prio.curr = MAX_RT_PRIO;
 
-	if (rq->online && rt_rq->highest_prio.curr != prev_prio)
-		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio.curr);
+	dec_rq_next_prio(rq, prio, prev_prio);
 }
 
 #else /* CONFIG_SMP */
 
-static inline
-void inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio) {}
-static inline
-void dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio) {}
+static inline void inc_rq_prio(struct rt_rq *rt_rq, int prio) {}
+static inline void dec_rq_prio(struct rt_rq *rt_rq, int prio) {}
 
 #endif /* CONFIG_SMP */
 
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
+
 static void
 inc_rt_prio(struct rt_rq *rt_rq, int prio)
 {
-	int prev_prio = rt_rq->highest_prio.curr;
+	int prev_prio = rt_rq->highest_prio;
 
 	if (prio < prev_prio)
-		rt_rq->highest_prio.curr = prio;
+		rt_rq->highest_prio = prio;
 
-	inc_rt_prio_smp(rt_rq, prio, prev_prio);
+	inc_rq_prio(rt_rq, prio);
 }
 
 static void
 dec_rt_prio(struct rt_rq *rt_rq, int prio)
 {
-	int prev_prio = rt_rq->highest_prio.curr;
+	int prev_prio = rt_rq->highest_prio;
 
 	if (rt_rq->rt_nr_running) {
-
 		WARN_ON(prio < prev_prio);
-
 		/*
 		 * This may have been our highest task, and therefore
 		 * we may have some recomputation to do
 		 */
 		if (prio == prev_prio) {
 			struct rt_prio_array *array = &rt_rq->active;
-
-			rt_rq->highest_prio.curr =
+			rt_rq->highest_prio =
 				sched_find_first_bit(array->bitmap);
 		}
-
 	} else
-		rt_rq->highest_prio.curr = MAX_RT_PRIO;
+		rt_rq->highest_prio = MAX_RT_PRIO;
 
-	dec_rt_prio_smp(rt_rq, prio, prev_prio);
+	dec_rq_prio(rt_rq, prio);
 }
 
 #else
@@ -757,9 +896,6 @@ inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
 	if (rt_se_boosted(rt_se))
 		rt_rq->rt_nr_boosted++;
-
-	if (rt_rq->tg)
-		start_rt_bandwidth(&rt_rq->tg->rt_bandwidth);
 }
 
 static void
@@ -771,17 +907,226 @@ dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	WARN_ON(!rt_rq->rt_nr_running && rt_rq->rt_nr_boosted);
 }
 
+static inline int rt_rq_prio(struct rt_rq *rt_rq)
+{
+	return rt_rq->highest_prio;
+}
+
+static inline int rt_rq_before(struct rt_rq *a, struct rt_rq *b)
+{
+	/*
+	 * Schedule by priority if:
+	 * - both a and b are boosted;
+	 * - throttling is disabled system-wide.
+	 */
+	if ((a->rt_nr_boosted && b->rt_nr_boosted) ||
+	    global_rt_runtime() == RUNTIME_INF)
+		return rt_rq_prio(a) < rt_rq_prio(b);
+
+	/* Only a is boosted, choose it. */
+	if (a->rt_nr_boosted)
+		return 1;
+
+	/* Only b is boosted, choose it. */
+	if (b->rt_nr_boosted)
+		return 0;
+
+	/* Order by deadline. */
+	return rt_time_before(a->rt_deadline, b->rt_deadline);
+}
+
+static void __enqueue_rt_rq(struct rt_rq *rt_rq)
+{
+	struct rq *rq = rq_of_rt_rq(rt_rq);
+	struct rt_edf_tree *rt_tree = &rq->rt.rt_edf_tree;
+	struct rb_node **link = &rt_tree->rb_root.rb_node;
+	struct rb_node *parent = NULL;
+	struct rt_rq *entry;
+	int leftmost = 1;
+
+	BUG_ON(rt_rq_on_rq(rt_rq));
+
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct rt_rq, rb_node);
+		if (rt_rq_before(rt_rq, entry))
+			link = &parent->rb_left;
+		else {
+			link = &parent->rb_right;
+			leftmost = 0;
+		}
+	}
+
+	if (leftmost)
+		rt_tree->rb_leftmost = &rt_rq->rb_node;
+
+	rb_link_node(&rt_rq->rb_node, parent, link);
+	rb_insert_color(&rt_rq->rb_node, &rt_tree->rb_root);
+}
+
+static void __dequeue_rt_rq(struct rt_rq *rt_rq)
+{
+	struct rq *rq = rq_of_rt_rq(rt_rq);
+	struct rt_edf_tree *rt_tree = &rq->rt.rt_edf_tree;
+
+	BUG_ON(!rt_rq_on_rq(rt_rq));
+
+	if (rt_tree->rb_leftmost == &rt_rq->rb_node)
+		rt_tree->rb_leftmost = rb_next(&rt_rq->rb_node);
+
+	rb_erase(&rt_rq->rb_node, &rt_tree->rb_root);
+	RB_CLEAR_NODE(&rt_rq->rb_node);
+}
+
+static void rt_rq_update_deadline(struct rt_rq *rt_rq)
+{
+	struct rq *rq = rq_of_rt_rq(rt_rq);
+	u64 runtime, period, left, right;
+
+	raw_spin_lock(&rt_rq->rt_runtime_lock);
+
+	runtime = sched_rt_runtime(rt_rq);
+	period = ktime_to_ns(rt_rq->rt_period);
+	/*
+	 * Update the deadline to the current time only if:
+	 * - it is in the past;
+	 * - using it would lead to a timeframe during which the
+	 *   group would exceed ist allocated bandwidth.
+	 *
+	 * For the second condition to hold, we check that in the
+	 * time left before the deadline, using the residual budget,
+	 * the group would exceed its runtime / period share.
+	 * In formula:
+	 *   rt_time / (deadline - rq->clock) >= runtime / period
+	 *
+	 * left and right are the two sides of the equation, after a bit
+	 * of shuffling to use multiplications instead of divisions; the
+	 * goto is there to avoid the multiplications when not necessary.
+	 */
+	if (rt_time_before(rt_rq->rt_deadline, rq->clock))
+		goto update;
+
+	left = period * rt_rq->rt_time;
+	right = (rt_rq->rt_deadline - rq->clock) * rt_rq->rt_runtime;
+
+	if (rt_time_before(right, left)) {
+update:
+		rt_rq->rt_deadline = rq->clock + period;
+		rt_rq->rt_time -= min(runtime, rt_rq->rt_time);
+
+		/*
+		 * Be sure to return a runqueue that can execute, if it
+		 * was boosted and consumed too much runtime; postpone
+		 * the deadline accordingly.
+		 */
+		while (rt_rq->rt_time > runtime) {
+			rt_rq->rt_deadline += period;
+			rt_rq->rt_time -= runtime;
+		}
+	}
+	raw_spin_unlock(&rt_rq->rt_runtime_lock);
+}
+
+static inline int rt_rq_boosted(struct rt_rq *rt_rq)
+{
+	if (!rt_rq->rt_nr_boosted)
+		return MAX_RT_PRIO;
+
+	return rt_rq_prio(rt_rq);
+}
+
+static void enqueue_rt_rq(struct rt_rq *rt_rq, int old_boosted)
+{
+	int on_rq = rt_rq_on_rq(rt_rq);
+
+	BUG_ON(!rt_rq->rt_nr_running);
+	BUG_ON(on_rq && rt_rq_throttled(rt_rq));
+
+	if (on_rq) {
+		if (old_boosted != rt_rq_boosted(rt_rq)) {
+			/* Boosted priority/state change: requeue rt_rq. */
+			__dequeue_rt_rq(rt_rq);
+		} else {
+			/* Already queued properly. */
+			return;
+		}
+	}
+
+	if (rt_rq_throttled(rt_rq))
+		return;
+
+	if (!rt_rq->rt_nr_boosted) {
+		/*
+		 * When we update a deadline we may end up rebalancing, and
+		 * thus requeueing the rt_rq, so we need to revalidate on_rq.
+		 */
+		rt_rq_update_deadline(rt_rq);
+		on_rq = rt_rq_on_rq(rt_rq);
+	}
+
+	if (!on_rq)
+		__enqueue_rt_rq(rt_rq);
+}
+
+static void dequeue_rt_rq(struct rt_rq *rt_rq, int old_boosted)
+{
+	int on_rq = rt_rq_on_rq(rt_rq);
+
+	/*
+	 * Here we do not expect throttled rt_rq's to be in the
+	 * EDF tree; note that when they exceed their assigned budget
+	 * they are dequeued via sched_rt_rq_dequeue().
+	 */
+	BUG_ON(on_rq && rt_rq_throttled(rt_rq));
+
+	if (on_rq && (!rt_rq->rt_nr_running ||
+	    old_boosted != rt_rq_boosted(rt_rq))) {
+		/*
+		 * Dequeue the rt_rq either if it has no more tasks or
+		 * its boosted priority/status changed and it needs to
+		 * be requeued.
+		 */
+		__dequeue_rt_rq(rt_rq);
+		on_rq = 0;
+	}
+
+	/* If we do not need to requeue the rt_rq, just return. */
+	if (!rt_rq->rt_nr_running || rt_rq_throttled(rt_rq))
+		return;
+
+	/* Reposition rt_rq. */
+	if (!on_rq)
+		__enqueue_rt_rq(rt_rq);
+}
+
 #else /* CONFIG_RT_GROUP_SCHED */
 
 static void
 inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
-	start_rt_bandwidth(&def_rt_bandwidth);
+	raw_spin_lock(&rt_rq->rt_runtime_lock);
+	start_rt_period_timer(rt_rq);
+	raw_spin_unlock(&rt_rq->rt_runtime_lock);
 }
 
 static inline
 void dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq) {}
 
+static inline int rt_rq_boosted(struct rt_rq *rt_rq)
+{
+	return MAX_RT_PRIO;
+}
+
+static inline int rt_rq_before(struct rt_rq *a, struct rt_rq *b)
+{
+	BUG();
+
+	return 0;
+}
+
+static inline void enqueue_rt_rq(struct rt_rq *rt_rq, int old_boosted) {}
+static inline void dequeue_rt_rq(struct rt_rq *rt_rq, int old_boosted) {}
+
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 static inline
@@ -792,38 +1137,31 @@ void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	WARN_ON(!rt_prio(prio));
 	rt_rq->rt_nr_running++;
 
-	inc_rt_prio(rt_rq, prio);
 	inc_rt_migration(rt_se, rt_rq);
+	inc_rt_prio(rt_rq, prio);
 	inc_rt_group(rt_se, rt_rq);
 }
 
 static inline
 void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
-	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
+	int prio = rt_se_prio(rt_se);
+
+	WARN_ON(!rt_prio(prio));
 	WARN_ON(!rt_rq->rt_nr_running);
 	rt_rq->rt_nr_running--;
 
-	dec_rt_prio(rt_rq, rt_se_prio(rt_se));
 	dec_rt_migration(rt_se, rt_rq);
+	dec_rt_prio(rt_rq, prio);
 	dec_rt_group(rt_se, rt_rq);
 }
 
-static void __enqueue_rt_entity(struct sched_rt_entity *rt_se, bool head)
+static void enqueue_rt_entity(struct sched_rt_entity *rt_se, bool head)
 {
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	struct rt_prio_array *array = &rt_rq->active;
-	struct rt_rq *group_rq = group_rt_rq(rt_se);
 	struct list_head *queue = array->queue + rt_se_prio(rt_se);
-
-	/*
-	 * Don't enqueue the group if its throttled, or when empty.
-	 * The latter is a consequence of the former when a child group
-	 * get throttled and the current group doesn't have any other
-	 * active members.
-	 */
-	if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
-		return;
+	int boosted = rt_rq_boosted(rt_rq);
 
 	if (head)
 		list_add(&rt_se->run_list, queue);
@@ -832,56 +1170,22 @@ static void __enqueue_rt_entity(struct sched_rt_entity *rt_se, bool head)
 	__set_bit(rt_se_prio(rt_se), array->bitmap);
 
 	inc_rt_tasks(rt_se, rt_rq);
+
+	enqueue_rt_rq(rt_rq, boosted);
 }
 
-static void __dequeue_rt_entity(struct sched_rt_entity *rt_se)
+static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
 {
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	struct rt_prio_array *array = &rt_rq->active;
+	int boosted = rt_rq_boosted(rt_rq);
 
 	list_del_init(&rt_se->run_list);
 	if (list_empty(array->queue + rt_se_prio(rt_se)))
 		__clear_bit(rt_se_prio(rt_se), array->bitmap);
 
 	dec_rt_tasks(rt_se, rt_rq);
-}
-
-/*
- * Because the prio of an upper entry depends on the lower
- * entries, we must remove entries top - down.
- */
-static void dequeue_rt_stack(struct sched_rt_entity *rt_se)
-{
-	struct sched_rt_entity *back = NULL;
-
-	for_each_sched_rt_entity(rt_se) {
-		rt_se->back = back;
-		back = rt_se;
-	}
-
-	for (rt_se = back; rt_se; rt_se = rt_se->back) {
-		if (on_rt_rq(rt_se))
-			__dequeue_rt_entity(rt_se);
-	}
-}
-
-static void enqueue_rt_entity(struct sched_rt_entity *rt_se, bool head)
-{
-	dequeue_rt_stack(rt_se);
-	for_each_sched_rt_entity(rt_se)
-		__enqueue_rt_entity(rt_se, head);
-}
-
-static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
-{
-	dequeue_rt_stack(rt_se);
-
-	for_each_sched_rt_entity(rt_se) {
-		struct rt_rq *rt_rq = group_rt_rq(rt_se);
-
-		if (rt_rq && rt_rq->rt_nr_running)
-			__enqueue_rt_entity(rt_se, false);
-	}
+	dequeue_rt_rq(rt_rq, boosted);
 }
 
 /*
@@ -932,12 +1236,9 @@ requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se, int head)
 static void requeue_task_rt(struct rq *rq, struct task_struct *p, int head)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
-	struct rt_rq *rt_rq;
+	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 
-	for_each_sched_rt_entity(rt_se) {
-		rt_rq = rt_rq_of_se(rt_se);
-		requeue_rt_entity(rt_rq, rt_se, head);
-	}
+	requeue_rt_entity(rt_rq, rt_se, head);
 }
 
 static void yield_task_rt(struct rq *rq)
@@ -1009,12 +1310,26 @@ static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 
 #endif /* CONFIG_SMP */
 
+static inline int check_preempt_rt_rq(struct task_struct *curr,
+				      struct task_struct *p)
+{
+	struct rt_rq *rt_rq, *cur_rq;
+
+	cur_rq = rt_rq_of_se(&curr->rt);
+	rt_rq = rt_rq_of_se(&p->rt);
+
+	if (rt_rq == cur_rq)
+		return p->prio < curr->prio;
+
+	return rt_rq_before(rt_rq, cur_rq);
+}
+
 /*
  * Preempt the current task with a newly woken task if needed:
  */
 static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p, int flags)
 {
-	if (p->prio < rq->curr->prio) {
+	if (check_preempt_rt_rq(rq->curr, p)) {
 		resched_task(rq->curr);
 		return;
 	}
@@ -1037,14 +1352,19 @@ static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p, int flag
 #endif
 }
 
-static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
-						   struct rt_rq *rt_rq)
+static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq)
 {
-	struct rt_prio_array *array = &rt_rq->active;
-	struct sched_rt_entity *next = NULL;
+	struct rt_rq *rt_rq;
+	struct rt_prio_array *array;
+	struct sched_rt_entity *next;
 	struct list_head *queue;
 	int idx;
 
+	rt_rq = pick_next_rt_rq(rq);
+	if (!rt_rq)
+		return NULL;
+
+	array = &rt_rq->active;
 	idx = sched_find_first_bit(array->bitmap);
 	BUG_ON(idx >= MAX_RT_PRIO);
 
@@ -1058,22 +1378,11 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 {
 	struct sched_rt_entity *rt_se;
 	struct task_struct *p;
-	struct rt_rq *rt_rq;
-
-	rt_rq = &rq->rt;
 
-	if (unlikely(!rt_rq->rt_nr_running))
+	rt_se = pick_next_rt_entity(rq);
+	if (!rt_se)
 		return NULL;
 
-	if (rt_rq_throttled(rt_rq))
-		return NULL;
-
-	do {
-		rt_se = pick_next_rt_entity(rq, rt_rq);
-		BUG_ON(!rt_se);
-		rt_rq = group_rt_rq(rt_se);
-	} while (rt_rq);
-
 	p = rt_task_of(rt_se);
 	p->se.exec_start = rq->clock;
 
@@ -1311,7 +1620,7 @@ static int push_rt_task(struct rq *rq)
 	if (!next_task)
 		return 0;
 
- retry:
+retry:
 	if (unlikely(next_task == rq->curr)) {
 		WARN_ON(1);
 		return 0;
@@ -1423,7 +1732,7 @@ static int pull_rt_task(struct rq *this_rq)
 		/*
 		 * Are there still pullable RT tasks?
 		 */
-		if (src_rq->rt.rt_nr_running <= 1)
+		if (src_rq->rt.rt_nr_total <= 1)
 			goto skip;
 
 		p = pick_next_highest_task_rt(src_rq, this_cpu);
@@ -1459,7 +1768,7 @@ static int pull_rt_task(struct rq *this_rq)
 			 * but possible)
 			 */
 		}
- skip:
+skip:
 		double_unlock_balance(this_rq, src_rq);
 	}
 
@@ -1573,7 +1882,7 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p,
 	 * we may need to handle the pulling of RT tasks
 	 * now.
 	 */
-	if (!rq->rt.rt_nr_running)
+	if (!rq->rt.rt_nr_total)
 		pull_rt_task(rq);
 }
 
-- 
1.6.5.7



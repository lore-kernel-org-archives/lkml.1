Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbYBDVS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbYBDVS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbYBDVRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:17:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41970 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbYBDVRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:17:11 -0500
Message-Id: <20080204211837.759865000@chello.nl>
References: <20080204210258.118479000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 04 Feb 2008 22:03:05 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: tong.n.li@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 7/8] sched: rt-group: synchonised bandwidth period
Content-Disposition: inline; filename=sched-rt-group-period.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various SMP balancing algorithms require that the bandwidth period
run in sync.

Possible improvements are moving the rt_bandwidth thing into root_domain
and keeping a span per rt_bandwidth which marks throttled cpus.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h    |    7 +
 kernel/sched.c           |  263 +++++++++++++++++++++++++++++++++++++----------
 kernel/sched_rt.c        |  104 ++++++++++++------
 kernel/sysctl.c          |    4 
 kernel/time/tick-sched.c |    5 
 5 files changed, 293 insertions(+), 90 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1519,6 +1519,10 @@ int sched_nr_latency_handler(struct ctl_
 extern unsigned int sysctl_sched_rt_period;
 extern int sysctl_sched_rt_runtime;
 
+int sched_rt_handler(struct ctl_table *table, int write,
+		struct file *filp, void __user *buffer, size_t *lenp,
+		loff_t *ppos);
+
 extern unsigned int sysctl_sched_compat_yield;
 
 #ifdef CONFIG_RT_MUTEXES
@@ -2000,6 +2004,9 @@ extern unsigned long sched_group_shares(
 extern int sched_group_set_rt_runtime(struct task_group *tg,
 				      long rt_runtime_us);
 extern long sched_group_rt_runtime(struct task_group *tg);
+extern int sched_group_set_rt_period(struct task_group *tg,
+				      long rt_period_us);
+extern long sched_group_rt_period(struct task_group *tg);
 
 #endif
 
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -114,6 +114,11 @@ unsigned long long __attribute__((weak))
  */
 #define DEF_TIMESLICE		(100 * HZ / 1000)
 
+/*
+ * single value that denotes runtime == period, ie unlimited time.
+ */
+#define RUNTIME_INF	((u64)~0ULL)
+
 #ifdef CONFIG_SMP
 /*
  * Divide a load by a sched group cpu_power : (load / sg->__cpu_power)
@@ -155,6 +160,81 @@ struct rt_prio_array {
 	struct list_head queue[MAX_RT_PRIO];
 };
 
+static inline ktime_t ns_to_ktime(u64 ns)
+{
+	static const ktime_t ktime_zero = { .tv64 = 0 };
+	return ktime_add_ns(ktime_zero, ns);
+}
+
+struct rt_bandwidth {
+	ktime_t rt_period;
+	u64 rt_runtime;
+	struct hrtimer rt_period_timer;
+};
+
+static struct rt_bandwidth def_rt_bandwidth;
+
+static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
+
+static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
+{
+	struct rt_bandwidth *rt_b =
+		container_of(timer, struct rt_bandwidth, rt_period_timer);
+	ktime_t now;
+	int overrun;
+	int idle = 0;
+
+	for (;;) {
+		now = hrtimer_cb_get_time(timer);
+		overrun = hrtimer_forward(timer, now, rt_b->rt_period);
+
+		if (!overrun)
+			break;
+
+		idle = do_sched_rt_period_timer(rt_b, overrun);
+	}
+
+	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
+}
+
+static
+void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime)
+{
+	rt_b->rt_period = ns_to_ktime(period);
+	rt_b->rt_runtime = runtime;
+
+	hrtimer_init(&rt_b->rt_period_timer,
+			CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	rt_b->rt_period_timer.function = sched_rt_period_timer;
+	rt_b->rt_period_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
+}
+
+static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
+{
+	ktime_t now;
+
+	if (rt_b->rt_runtime == RUNTIME_INF)
+		return;
+
+	for (;;) {
+		if (hrtimer_active(&rt_b->rt_period_timer))
+			break;
+
+		now = hrtimer_cb_get_time(&rt_b->rt_period_timer);
+		hrtimer_forward(&rt_b->rt_period_timer, now, rt_b->rt_period);
+		hrtimer_start(&rt_b->rt_period_timer,
+			      rt_b->rt_period_timer.expires,
+			      HRTIMER_MODE_ABS);
+	}
+}
+
+#ifdef CONFIG_RT_GROUP_SCHED
+static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
+{
+	hrtimer_cancel(&rt_b->rt_period_timer);
+}
+#endif
+
 #ifdef CONFIG_GROUP_SCHED
 
 #include <linux/cgroup.h>
@@ -216,7 +296,7 @@ struct task_group {
 	struct sched_rt_entity **rt_se;
 	struct rt_rq **rt_rq;
 
-	u64 rt_runtime;
+	struct rt_bandwidth rt_bandwidth;
 #endif
 
 	struct rcu_head rcu;
@@ -462,8 +542,6 @@ struct rq {
 
 	struct cfs_rq cfs;
 	struct rt_rq rt;
-	u64 rt_period_expire;
-	int rt_throttled;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
@@ -618,23 +696,6 @@ static void update_rq_clock(struct rq *r
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 
-unsigned long rt_needs_cpu(int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-	u64 delta;
-
-	if (!rq->rt_throttled)
-		return 0;
-
-	if (rq->clock > rq->rt_period_expire)
-		return 1;
-
-	delta = rq->rt_period_expire - rq->clock;
-	do_div(delta, NSEC_PER_SEC / HZ);
-
-	return (unsigned long)delta;
-}
-
 /*
  * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
  */
@@ -686,10 +747,18 @@ unsigned int sysctl_sched_rt_period = 10
  */
 int sysctl_sched_rt_runtime = 950000;
 
-/*
- * single value that denotes runtime == period, ie unlimited time.
- */
-#define RUNTIME_INF	((u64)~0ULL)
+static inline u64 global_rt_period(void)
+{
+	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
+}
+
+static inline u64 global_rt_runtime(void)
+{
+	if (sysctl_sched_rt_period < 0)
+		return RUNTIME_INF;
+
+	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
+}
 
 /*
  * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
@@ -3768,7 +3837,6 @@ void scheduler_tick(void)
 	rq->tick_timestamp = rq->clock;
 	update_cpu_load(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
-	update_sched_rt_period(rq);
 	spin_unlock(&rq->lock);
 
 #ifdef CONFIG_SMP
@@ -4593,7 +4661,7 @@ recheck:
 	 * Do not allow realtime tasks into groups that have no runtime
 	 * assigned.
 	 */
-	if (rt_policy(policy) && task_group(p)->rt_runtime == 0)
+	if (rt_policy(policy) && task_group(p)->rt_bandwidth.rt_runtime == 0)
 		return -EPERM;
 #endif
 
@@ -7204,6 +7272,14 @@ void __init sched_init(void)
 	init_defrootdomain();
 #endif
 
+	init_rt_bandwidth(&def_rt_bandwidth,
+			global_rt_period(), global_rt_runtime());
+
+#ifdef CONFIG_RT_GROUP_SCHED
+	init_rt_bandwidth(&init_task_group.rt_bandwidth,
+			global_rt_period(), global_rt_runtime());
+#endif
+
 #ifdef CONFIG_GROUP_SCHED
 	list_add(&init_task_group.list, &task_groups);
 #endif
@@ -7227,15 +7303,11 @@ void __init sched_init(void)
 
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
-		init_task_group.rt_runtime =
-			sysctl_sched_rt_runtime * NSEC_PER_USEC;
 		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
 		init_tg_rt_entry(rq, &init_task_group,
 				&per_cpu(init_rt_rq, i),
 				&per_cpu(init_sched_rt_entity, i), i, 1);
 #endif
-		rq->rt_period_expire = 0;
-		rq->rt_throttled = 0;
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
 			rq->cpu_load[j] = 0;
@@ -7419,8 +7491,6 @@ void set_curr_task(int cpu, struct task_
 
 #endif
 
-#ifdef CONFIG_GROUP_SCHED
-
 #if defined CONFIG_FAIR_GROUP_SCHED && defined CONFIG_SMP
 /*
  * distribute shares of all task groups among their schedulable entities,
@@ -7650,6 +7720,8 @@ static void free_rt_sched_group(struct t
 {
 	int i;
 
+	destroy_rt_bandwidth(&tg->rt_bandwidth);
+
 	for_each_possible_cpu(i) {
 		if (tg->rt_rq)
 			kfree(tg->rt_rq[i]);
@@ -7675,7 +7747,8 @@ static int alloc_rt_sched_group(struct t
 	if (!tg->rt_se)
 		goto err;
 
-	tg->rt_runtime = 0;
+	init_rt_bandwidth(&tg->rt_bandwidth,
+			ktime_to_ns(def_rt_bandwidth.rt_period), 0);
 
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
@@ -7718,6 +7791,7 @@ static inline int alloc_rt_sched_group(s
 }
 #endif
 
+#ifdef CONFIG_GROUP_SCHED
 static void free_sched_group(struct task_group *tg)
 {
 	free_fair_sched_group(tg);
@@ -7809,6 +7883,7 @@ void sched_move_task(struct task_struct 
 
 	task_rq_unlock(rq, &flags);
 }
+#endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 /* rq->lock to be locked by caller */
@@ -7914,59 +7989,129 @@ static int __rt_schedulable(struct task_
 	struct task_group *tgi;
 	unsigned long total = 0;
 	unsigned long global_ratio =
-		to_ratio(sysctl_sched_rt_period,
-			 sysctl_sched_rt_runtime < 0 ?
-				RUNTIME_INF : sysctl_sched_rt_runtime);
+		to_ratio(global_rt_period(), global_rt_runtime());
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(tgi, &task_groups, list) {
 		if (tgi == tg)
 			continue;
 
-		total += to_ratio(period, tgi->rt_runtime);
+		total += to_ratio(ktime_to_ns(tgi->rt_bandwidth.rt_period),
+				tgi->rt_bandwidth.rt_runtime);
 	}
 	rcu_read_unlock();
 
 	return total + to_ratio(period, runtime) < global_ratio;
 }
 
-int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
+static int tg_set_bandwidth(struct task_group *tg,
+		u64 rt_period, u64 rt_runtime)
 {
-	u64 rt_runtime, rt_period;
 	int err = 0;
 
-	rt_period = sysctl_sched_rt_period * NSEC_PER_USEC;
-	rt_runtime = (u64)rt_runtime_us * NSEC_PER_USEC;
-	if (rt_runtime_us == -1)
-		rt_runtime = rt_period;
-
 	mutex_lock(&rt_constraints_mutex);
 	if (!__rt_schedulable(tg, rt_period, rt_runtime)) {
 		err = -EINVAL;
 		goto unlock;
 	}
-	if (rt_runtime_us == -1)
-		rt_runtime = RUNTIME_INF;
-	tg->rt_runtime = rt_runtime;
+	tg->rt_bandwidth.rt_period = ns_to_ktime(rt_period);
+	tg->rt_bandwidth.rt_runtime = rt_runtime;
  unlock:
 	mutex_unlock(&rt_constraints_mutex);
 
 	return err;
 }
 
+int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
+{
+	u64 rt_runtime, rt_period;
+
+	rt_period = ktime_to_ns(tg->rt_bandwidth.rt_period);
+	rt_runtime = (u64)rt_runtime_us * NSEC_PER_USEC;
+	if (rt_runtime_us < 0)
+		rt_runtime = RUNTIME_INF;
+
+	return tg_set_bandwidth(tg, rt_period, rt_runtime);
+}
+
 long sched_group_rt_runtime(struct task_group *tg)
 {
 	u64 rt_runtime_us;
 
-	if (tg->rt_runtime == RUNTIME_INF)
+	if (tg->rt_bandwidth.rt_runtime == RUNTIME_INF)
 		return -1;
 
-	rt_runtime_us = tg->rt_runtime;
+	rt_runtime_us = tg->rt_bandwidth.rt_runtime;
 	do_div(rt_runtime_us, NSEC_PER_USEC);
 	return rt_runtime_us;
 }
+
+int sched_group_set_rt_period(struct task_group *tg, long rt_period_us)
+{
+	u64 rt_runtime, rt_period;
+
+	rt_period = (u64)rt_period_us * NSEC_PER_USEC;
+	rt_runtime = tg->rt_bandwidth.rt_runtime;
+
+	return tg_set_bandwidth(tg, rt_period, rt_runtime);
+}
+
+long sched_group_rt_period(struct task_group *tg)
+{
+	u64 rt_period_us;
+
+	rt_period_us = ktime_to_ns(tg->rt_bandwidth.rt_period);
+	do_div(rt_period_us, NSEC_PER_USEC);
+	return rt_period_us;
+}
+
+static int sched_rt_global_constraints(void)
+{
+	int ret = 0;
+
+	mutex_lock(&rt_constraints_mutex);
+	if (!__rt_schedulable(NULL, 1, 0))
+		ret = -EINVAL;
+	mutex_unlock(&rt_constraints_mutex);
+
+	return ret;
+}
+#else
+static int sched_rt_global_constraints(void)
+{
+	return 0;
+}
 #endif
-#endif	/* CONFIG_GROUP_SCHED */
+
+int sched_rt_handler(struct ctl_table *table, int write,
+		struct file *filp, void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int ret;
+	int old_period, old_runtime;
+	static DEFINE_MUTEX(mutex);
+
+	mutex_lock(&mutex);
+	old_period = sysctl_sched_rt_period;
+	old_runtime = sysctl_sched_rt_runtime;
+
+	ret = proc_dointvec(table, write, filp, buffer, lenp, ppos);
+
+	if (!ret && write) {
+		ret = sched_rt_global_constraints();
+		if (ret) {
+			sysctl_sched_rt_period = old_period;
+			sysctl_sched_rt_runtime = old_runtime;
+		} else {
+			def_rt_bandwidth.rt_runtime = global_rt_runtime();
+			def_rt_bandwidth.rt_period =
+				ns_to_ktime(global_rt_period());
+		}
+	}
+	mutex_unlock(&mutex);
+
+	return ret;
+}
 
 #ifdef CONFIG_CGROUP_SCHED
 
@@ -8016,7 +8161,7 @@ cpu_cgroup_can_attach(struct cgroup_subs
 {
 #ifdef CONFIG_RT_GROUP_SCHED
 	/* Don't accept realtime tasks when there is no way for them to run */
-	if (rt_task(tsk) && cgroup_tg(cgrp)->rt_runtime == 0)
+	if (rt_task(tsk) && cgroup_tg(cgrp)->rt_bandwidth.rt_runtime == 0)
 		return -EINVAL;
 #else
 	/* We don't support RT-tasks being in separate groups */
@@ -8094,6 +8239,17 @@ static ssize_t cpu_rt_runtime_read(struc
 
 	return simple_read_from_buffer(buf, nbytes, ppos, tmp, len);
 }
+
+static int cpu_rt_period_write_uint(struct cgroup *cgrp, struct cftype *cftype,
+		u64 rt_period_us)
+{
+	return sched_group_set_rt_period(cgroup_tg(cgrp), rt_period_us);
+}
+
+static u64 cpu_rt_period_read_uint(struct cgroup *cgrp, struct cftype *cft)
+{
+	return sched_group_rt_period(cgroup_tg(cgrp));
+}
 #endif
 
 static struct cftype cpu_files[] = {
@@ -8110,6 +8266,11 @@ static struct cftype cpu_files[] = {
 		.read = cpu_rt_runtime_read,
 		.write = cpu_rt_runtime_write,
 	},
+	{
+		.name = "rt_period_us",
+		.read_uint = cpu_rt_period_read_uint,
+		.write_uint = cpu_rt_period_write_uint,
+	},
 #endif
 };
 
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -62,7 +62,7 @@ static inline u64 sched_rt_runtime(struc
 	if (!rt_rq->tg)
 		return RUNTIME_INF;
 
-	return rt_rq->tg->rt_runtime;
+	return rt_rq->tg->rt_bandwidth.rt_runtime;
 }
 
 #define for_each_leaf_rt_rq(rt_rq, rq) \
@@ -127,14 +127,29 @@ static int rt_se_boosted(struct sched_rt
 	return p->prio != p->normal_prio;
 }
 
+#ifdef CONFIG_SMP
+static inline cpumask_t sched_rt_period_mask(void)
+{
+	return cpu_rq(smp_processor_id())->rd->span;
+}
 #else
+static inline cpumask_t sched_rt_period_mask(void)
+{
+	return cpu_online_map;
+}
+#endif
 
-static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
+static inline
+struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
 {
-	if (sysctl_sched_rt_runtime == -1)
-		return RUNTIME_INF;
+	return container_of(rt_b, struct task_group, rt_bandwidth)->rt_rq[cpu];
+}
 
-	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
+#else
+
+static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
+{
+	return def_rt_bandwidth.rt_runtime;
 }
 
 #define for_each_leaf_rt_rq(rt_rq, rq) \
@@ -173,8 +188,55 @@ static inline int rt_rq_throttled(struct
 {
 	return rt_rq->rt_throttled;
 }
+
+static inline cpumask_t sched_rt_period_mask(void)
+{
+	return cpu_online_map;
+}
+
+static inline
+struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
+{
+	return &cpu_rq(cpu)->rt;
+}
+
 #endif
 
+static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
+{
+	int i, idle = 1;
+	cpumask_t span;
+
+	if (rt_b->rt_runtime == RUNTIME_INF)
+		return 1;
+
+	span = sched_rt_period_mask();
+	for_each_cpu_mask(i, span) {
+		int enqueue = 0;
+		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
+		struct rq *rq = rq_of_rt_rq(rt_rq);
+
+		spin_lock(&rq->lock);
+		if (rt_rq->rt_time) {
+			u64 runtime = rt_b->rt_runtime;
+
+			rt_rq->rt_time -= min(rt_rq->rt_time, overrun*runtime);
+			if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
+				rt_rq->rt_throttled = 0;
+				enqueue = 1;
+			}
+			if (rt_rq->rt_time || rt_rq->rt_nr_running)
+				idle = 0;
+		}
+
+		if (enqueue)
+			sched_rt_rq_enqueue(rt_rq);
+		spin_unlock(&rq->lock);
+	}
+
+	return idle;
+}
+
 static inline int rt_se_prio(struct sched_rt_entity *rt_se)
 {
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -198,11 +260,7 @@ static int sched_rt_runtime_exceeded(str
 		return rt_rq_throttled(rt_rq);
 
 	if (rt_rq->rt_time > runtime) {
-		struct rq *rq = rq_of_rt_rq(rt_rq);
-
-		rq->rt_throttled = 1;
 		rt_rq->rt_throttled = 1;
-
 		if (rt_rq_throttled(rt_rq)) {
 			sched_rt_rq_dequeue(rt_rq);
 			return 1;
@@ -212,29 +270,6 @@ static int sched_rt_runtime_exceeded(str
 	return 0;
 }
 
-static void update_sched_rt_period(struct rq *rq)
-{
-	struct rt_rq *rt_rq;
-	u64 period;
-
-	while (rq->clock > rq->rt_period_expire) {
-		period = (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
-		rq->rt_period_expire += period;
-
-		for_each_leaf_rt_rq(rt_rq, rq) {
-			u64 runtime = sched_rt_runtime(rt_rq);
-
-			rt_rq->rt_time -= min(rt_rq->rt_time, runtime);
-			if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
-				rt_rq->rt_throttled = 0;
-				sched_rt_rq_enqueue(rt_rq);
-			}
-		}
-
-		rq->rt_throttled = 0;
-	}
-}
-
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
@@ -284,6 +319,11 @@ void inc_rt_tasks(struct sched_rt_entity
 #ifdef CONFIG_RT_GROUP_SCHED
 	if (rt_se_boosted(rt_se))
 		rt_rq->rt_nr_boosted++;
+
+	if (rt_rq->tg)
+		start_rt_bandwidth(&rt_rq->tg->rt_bandwidth);
+#else
+	start_rt_bandwidth(&def_rt_bandwidth);
 #endif
 }
 
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -336,7 +336,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_rt_period,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= &sched_rt_handler,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -344,7 +344,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_rt_runtime,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= &sched_rt_handler,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
Index: linux-2.6/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-sched.c
+++ linux-2.6/kernel/time/tick-sched.c
@@ -191,7 +191,6 @@ u64 get_cpu_idle_time_us(int cpu, u64 *l
 void tick_nohz_stop_sched_tick(void)
 {
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies, flags;
-	unsigned long rt_jiffies;
 	struct tick_sched *ts;
 	ktime_t last_update, expires, now;
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
@@ -244,10 +243,6 @@ void tick_nohz_stop_sched_tick(void)
 	next_jiffies = get_next_timer_interrupt(last_jiffies);
 	delta_jiffies = next_jiffies - last_jiffies;
 
-	rt_jiffies = rt_needs_cpu(cpu);
-	if (rt_jiffies && rt_jiffies < delta_jiffies)
-		delta_jiffies = rt_jiffies;
-
 	if (rcu_needs_cpu(cpu))
 		delta_jiffies = 1;
 	/*

--


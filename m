Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbYADN6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbYADN6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 08:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbYADN4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 08:56:32 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:57427 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753309AbYADN42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 08:56:28 -0500
Message-Id: <20080104135653.157876000@chello.nl>
References: <20080104135457.336761000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 04 Jan 2008 14:55:03 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6/7] sched: rt-group: per group period
Content-Disposition: inline; filename=sched-rt-rq-hrtimer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven asked for per group periods in order to get closer to RMA or EDF
scheduling.

Use the fancy new hrtimers to provide a per group period

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h    |    2 
 kernel/sched.c           |  225 +++++++++++++++++++++++++++++++++++++++++------
 kernel/sched_rt.c        |   61 ++++++------
 kernel/sysctl.c          |    2 
 kernel/time/tick-sched.c |    5 -
 5 files changed, 232 insertions(+), 63 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -230,8 +230,6 @@ static inline int select_nohz_load_balan
 }
 #endif
 
-extern unsigned long rt_needs_cpu(int cpu);
-
 /*
  * Only dump TASK_* tasks. (0 for all tasks)
  */
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -177,6 +177,7 @@ struct task_group {
 	struct rt_rq **rt_rq;
 
 	unsigned int rt_ratio;
+	ktime_t rt_period;
 
 	/*
 	 * shares assigned to a task group governs how much of cpu bandwidth
@@ -372,6 +373,7 @@ struct rt_rq {
 #endif
 	int rt_throttled;
 	u64 rt_time;
+	struct hrtimer rt_period_timer;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	struct rq *rq;
@@ -441,8 +443,6 @@ struct rq {
 
 	struct cfs_rq cfs;
 	struct rt_rq rt;
-	u64 rt_period_expire;
-	int rt_throttled;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
@@ -595,23 +595,6 @@ static void update_rq_clock(struct rq *r
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
@@ -652,10 +635,10 @@ const_debug unsigned int sysctl_sched_fe
 const_debug unsigned int sysctl_sched_nr_migrate = 32;
 
 /*
- * period over which we measure -rt task cpu usage in ms.
+ * period over which we measure -rt task cpu usage in us.
  * default: 1s
  */
-const_debug unsigned int sysctl_sched_rt_period = 1000;
+const_debug unsigned int sysctl_sched_rt_period = 1000000;
 
 #define SCHED_RT_FRAC_SHIFT	16
 #define SCHED_RT_FRAC		(1UL << SCHED_RT_FRAC_SHIFT)
@@ -664,7 +647,7 @@ const_debug unsigned int sysctl_sched_rt
  * ratio of time -rt tasks may consume.
  * default: 95%
  */
-const_debug unsigned int sysctl_sched_rt_ratio = 62259;
+const_debug unsigned int sysctl_sched_rt_ratio = 32768; //62259;
 
 /*
  * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
@@ -1245,6 +1228,12 @@ static unsigned long cpu_avg_load_per_ta
 static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
 #endif /* CONFIG_SMP */
 
+static inline ktime_t ns_to_ktime(u64 ns)
+{
+	static const ktime_t ktime_zero = { .tv64 = 0 };
+	return ktime_add_ns(ktime_zero, ns);
+}
+
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"
@@ -3741,7 +3730,6 @@ void scheduler_tick(void)
 	rq->tick_timestamp = rq->clock;
 	update_cpu_load(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
-	update_sched_rt_period(rq);
 	spin_unlock(&rq->lock);
 
 #ifdef CONFIG_SMP
@@ -5287,6 +5275,152 @@ static inline void sched_init_granularit
 	sysctl_sched_batch_wakeup_granularity *= factor;
 }
 
+static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
+{
+	struct rt_rq *rt_rq =
+		container_of(timer, struct rt_rq, rt_period_timer);
+	struct rq *rq = rq_of_rt_rq(rt_rq);
+	ktime_t now = ktime_get();
+
+	WARN_ON(smp_processor_id() != cpu_of(rq));
+	WARN_ON(!in_irq());
+
+	spin_lock(&rq->lock);
+	update_sched_rt_period(rt_rq);
+	spin_unlock(&rq->lock);
+
+	hrtimer_forward(timer, now, sched_rt_period(rt_rq));
+	return HRTIMER_RESTART;
+}
+
+static void sched_rt_period_start(struct rt_rq *rt_rq)
+{
+	ktime_t period = sched_rt_period(rt_rq);
+
+	WARN_ON(smp_processor_id() != cpu_of(rq_of_rt_rq(rt_rq)));
+
+	for (;;) {
+		ktime_t now = ktime_get();
+		hrtimer_forward(&rt_rq->rt_period_timer, now, period);
+		hrtimer_start(&rt_rq->rt_period_timer,
+				rt_rq->rt_period_timer.expires,
+				HRTIMER_MODE_ABS);
+		if (hrtimer_active(&rt_rq->rt_period_timer))
+			break;
+	}
+}
+
+static void sched_rt_period_stop(struct rt_rq *rt_rq)
+{
+	hrtimer_cancel(&rt_rq->rt_period_timer);
+}
+
+static void sched_rt_period_start_cpu(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	struct rt_rq *rt_rq;
+
+	for_each_leaf_rt_rq(rt_rq, rq)
+		sched_rt_period_start(rt_rq);
+}
+
+#ifdef CONFIG_SMP
+static void sched_rt_period_stop_cpu(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	struct rt_rq *rt_rq;
+
+	for_each_leaf_rt_rq(rt_rq, rq)
+		sched_rt_period_stop(rt_rq);
+}
+
+static int sched_rt_period_hotplug(struct notifier_block *nfb,
+		unsigned long action, void *hcpu)
+{
+	int cpu = (unsigned long)hcpu;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
+		sched_rt_period_start_cpu(cpu);
+		return NOTIFY_OK;
+
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+		sched_rt_period_stop_cpu(cpu);
+		return NOTIFY_OK;
+
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		return NOTIFY_OK;
+
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_OK;
+}
+
+static void __init __sched_rt_period_init(void *arg)
+{
+	int cpu = smp_processor_id();
+	sched_rt_period_start_cpu(cpu);
+}
+
+static void __init sched_rt_period_init(void)
+{
+	on_each_cpu(__sched_rt_period_init, NULL, 0, 1);
+	hotcpu_notifier(sched_rt_period_hotplug, 0);
+}
+
+static void __sched_rt_period_init_tg(void *arg)
+{
+	struct task_group *tg = arg;
+	int cpu = smp_processor_id();
+
+	sched_rt_period_start(tg->rt_rq[cpu]);
+}
+
+static void sched_rt_period_init_tg(struct task_group *tg)
+{
+	on_each_cpu(__sched_rt_period_init_tg, tg, 0, 1);
+}
+
+static void __sched_rt_period_destroy_tg(void *arg)
+{
+	struct task_group *tg = arg;
+	int cpu = smp_processor_id();
+
+	sched_rt_period_stop(tg->rt_rq[cpu]);
+}
+
+static void sched_rt_period_destroy_tg(struct task_group *tg)
+{
+	on_each_cpu(__sched_rt_period_destroy_tg, tg, 0, 1);
+}
+#else
+static void __init sched_rt_period_init(void)
+{
+	sched_rt_period_start_cpu(0);
+}
+
+static void sched_rt_period_init_tg(struct task_group *tg)
+{
+	sched_rt_period_start(tg->rt_rq[0]);
+}
+
+static void sched_rt_period_destroy_tg(struct task_group *tg)
+{
+	sched_rt_period_stop(tg->rt_rq[0]);
+}
+#endif
+
 #ifdef CONFIG_SMP
 /*
  * This is how migration works:
@@ -7068,6 +7202,7 @@ void __init sched_init_smp(void)
 	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
 		BUG();
 	sched_init_granularity();
+	sched_rt_period_init();
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	if (nr_cpu_ids == 1)
@@ -7088,6 +7223,7 @@ void __init sched_init_smp(void)
 void __init sched_init_smp(void)
 {
 	sched_init_granularity();
+	sched_rt_period_init();
 }
 #endif /* CONFIG_SMP */
 
@@ -7131,6 +7267,11 @@ static void init_rt_rq(struct rt_rq *rt_
 	rt_rq->rt_time = 0;
 	rt_rq->rt_throttled = 0;
 
+	hrtimer_init(&rt_rq->rt_period_timer,
+			CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	rt_rq->rt_period_timer.function = sched_rt_period_timer;
+	rt_rq->rt_period_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	rt_rq->rq = rq;
 #endif
@@ -7201,6 +7342,8 @@ void __init sched_init(void)
 				&per_cpu(init_sched_entity, i), i, 1);
 
 		init_task_group.rt_ratio = sysctl_sched_rt_ratio; /* XXX */
+		init_task_group.rt_period =
+			ns_to_ktime(sysctl_sched_rt_period * NSEC_PER_USEC);
 		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
 		init_tg_rt_entry(rq, &init_task_group,
 				&per_cpu(init_rt_rq, i),
@@ -7208,8 +7351,6 @@ void __init sched_init(void)
 
 		list_add(&init_task_group.list, &task_groups);
 #endif
-		rq->rt_period_expire = 0;
-		rq->rt_throttled = 0;
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
 			rq->cpu_load[j] = 0;
@@ -7598,6 +7739,7 @@ struct task_group *sched_create_group(vo
 
 	tg->shares = NICE_0_LOAD;
 	tg->rt_ratio = 0; /* XXX */
+	tg->rt_period = ns_to_ktime(sysctl_sched_rt_period * NSEC_PER_USEC);
 
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
@@ -7637,6 +7779,8 @@ struct task_group *sched_create_group(vo
 	list_add_rcu(&tg->list, &task_groups);
 	unlock_task_group_list();
 
+	sched_rt_period_init_tg(tg);
+
 	return tg;
 
 err:
@@ -7658,6 +7802,8 @@ void sched_destroy_group(struct task_gro
 	struct rt_rq *rt_rq = NULL;
 	int i;
 
+	sched_rt_period_destroy_tg(tg);
+
 	lock_task_group_list();
 	for_each_possible_cpu(i) {
 		cfs_rq = tg->cfs_rq[i];
@@ -7815,6 +7961,19 @@ unsigned long sched_group_rt_ratio(struc
 	return tg->rt_ratio;
 }
 
+int sched_group_set_rt_period(struct task_group *tg, unsigned long rt_period)
+{
+	tg->rt_period = ns_to_ktime((u64)rt_period * NSEC_PER_USEC);
+	return 0;
+}
+
+unsigned long sched_group_rt_period(struct task_group *tg)
+{
+	u64 ns = ktime_to_ns(tg->rt_period);
+	do_div(ns, NSEC_PER_USEC);
+	return ns;
+}
+
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_FAIR_CGROUP_SCHED
@@ -7903,6 +8062,17 @@ static u64 cpu_rt_ratio_read_uint(struct
 	return (u64) tg->rt_ratio;
 }
 
+static int cpu_rt_period_write_uint(struct cgroup *cgrp, struct cftype *cftype,
+		u64 rt_period_val)
+{
+	return sched_group_set_rt_period(cgroup_tg(cgrp), rt_period_val);
+}
+
+static u64 cpu_rt_period_read_uint(struct cgroup *cgrp, struct cftype *cft)
+{
+	return (u64) sched_group_rt_period(cgroup_tg(cgrp));
+}
+
 static struct cftype cpu_files[] = {
 	{
 		.name = "shares",
@@ -7914,6 +8084,11 @@ static struct cftype cpu_files[] = {
 		.read_uint = cpu_rt_ratio_read_uint,
 		.write_uint = cpu_rt_ratio_write_uint,
 	},
+	{
+		.name = "rt_period_us",
+		.read_uint = cpu_rt_period_read_uint,
+		.write_uint = cpu_rt_period_write_uint,
+	},
 };
 
 static int cpu_cgroup_populate(struct cgroup_subsys *ss, struct cgroup *cont)
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -65,6 +65,17 @@ static inline unsigned int sched_rt_rati
 	return rt_rq->tg->rt_ratio;
 }
 
+static inline ktime_t sched_rt_period(struct rt_rq *rt_rq)
+{
+	BUG_ON(!rt_rq->tg);
+	return rt_rq->tg->rt_period;
+}
+
+static inline u64 sched_rt_period_ns(struct rt_rq *rt_rq)
+{
+	return ktime_to_ns(sched_rt_period(rt_rq));
+}
+
 #define for_each_leaf_rt_rq(rt_rq, rq) \
 	list_for_each_entry(rt_rq, &rq->leaf_rt_rq_list, leaf_rt_rq_list)
 
@@ -117,6 +128,16 @@ static inline unsigned int sched_rt_rati
 	return sysctl_sched_rt_ratio;
 }
 
+static inline ktime_t sched_rt_period(struct rt_rq *rt_rq)
+{
+	return ns_to_ktime((u64)sysctl_sched_rt_period * NSEC_PER_USEC);
+}
+
+static inline u64 sched_rt_period_ns(struct rt_rq *rt_rq)
+{
+	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
+}
+
 #define for_each_leaf_rt_rq(rt_rq, rq) \
 	for (rt_rq = &rq->rt; rt_rq; rt_rq = NULL)
 
@@ -174,15 +195,11 @@ static int sched_rt_ratio_exceeded(struc
 	if (rt_rq->rt_throttled)
 		return 1;
 
-	period = (u64)sysctl_sched_rt_period * NSEC_PER_MSEC;
+	period = sched_rt_period_ns(rt_rq);
 	ratio = (period * rt_ratio) >> SCHED_RT_FRAC_SHIFT;
 
 	if (rt_rq->rt_time > ratio) {
-		struct rq *rq = rq_of_rt_rq(rt_rq);
-
-		rq->rt_throttled = 1;
 		rt_rq->rt_throttled = 1;
-
 		sched_rt_ratio_dequeue(rt_rq);
 		return 1;
 	}
@@ -190,27 +207,16 @@ static int sched_rt_ratio_exceeded(struc
 	return 0;
 }
 
-static void update_sched_rt_period(struct rq *rq)
+static void update_sched_rt_period(struct rt_rq *rt_rq)
 {
-	struct rt_rq *rt_rq;
-	u64 period;
-
-	while (rq->clock > rq->rt_period_expire) {
-		period = (u64)sysctl_sched_rt_period * NSEC_PER_MSEC;
-		rq->rt_period_expire += period;
-
-		for_each_leaf_rt_rq(rt_rq, rq) {
-			unsigned long rt_ratio = sched_rt_ratio(rt_rq);
-			u64 ratio = (period * rt_ratio) >> SCHED_RT_FRAC_SHIFT;
-
-			rt_rq->rt_time -= min(rt_rq->rt_time, ratio);
-			if (rt_rq->rt_throttled) {
-				rt_rq->rt_throttled = 0;
-				sched_rt_ratio_enqueue(rt_rq);
-			}
-		}
-
-		rq->rt_throttled = 0;
+	u64 period = sched_rt_period_ns(rt_rq);
+	unsigned long rt_ratio = sched_rt_ratio(rt_rq);
+	u64 ratio = (period * rt_ratio) >> SCHED_RT_FRAC_SHIFT;
+
+	rt_rq->rt_time -= min(rt_rq->rt_time, ratio);
+	if (rt_rq->rt_throttled) {
+		rt_rq->rt_throttled = 0;
+		sched_rt_ratio_enqueue(rt_rq);
 	}
 }
 
@@ -238,11 +244,6 @@ static void update_curr_rt(struct rq *rq
 	cpuacct_charge(curr, delta_exec);
 
 	rt_rq->rt_time += delta_exec;
-	/*
-	 * might make it a tad more accurate:
-	 *
-	 * update_sched_rt_period(rq);
-	 */
 	if (sched_rt_ratio_exceeded(rt_rq))
 		resched_task(curr);
 }
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -311,7 +311,7 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_rt_period_ms",
+		.procname	= "sched_rt_period_us",
 		.data		= &sysctl_sched_rt_period,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
Index: linux-2.6/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-sched.c
+++ linux-2.6/kernel/time/tick-sched.c
@@ -153,7 +153,6 @@ void tick_nohz_update_jiffies(void)
 void tick_nohz_stop_sched_tick(void)
 {
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies, flags;
-	unsigned long rt_jiffies;
 	struct tick_sched *ts;
 	ktime_t last_update, expires, now, delta;
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
@@ -217,10 +216,6 @@ void tick_nohz_stop_sched_tick(void)
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


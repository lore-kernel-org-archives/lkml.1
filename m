Return-Path: <linux-kernel-owner+w=401wt.eu-S1759285AbYAFQX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285AbYAFQX1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756917AbYAFQXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:23:16 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:38774 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754045AbYAFQXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:23:15 -0500
Message-Id: <20080106162124.789124000@chello.nl>
References: <20080106161128.152634000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 06 Jan 2008 17:11:39 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 11/11] sched: rt-group: interface
Content-Disposition: inline; filename=sched-rt-group-interface.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the rt_ratio interface to rt_runtime_us, to match rt_period_us.
This avoids picking a granularity for the ratio.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    8 +++
 kernel/sched.c        |  116 ++++++++++++++++++++++++++++++++++----------------
 kernel/sched_rt.c     |   42 +++++++-----------
 kernel/sysctl.c       |    4 -
 4 files changed, 106 insertions(+), 64 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1518,7 +1518,7 @@ extern unsigned int sysctl_sched_feature
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
 extern unsigned int sysctl_sched_rt_period;
-extern unsigned int sysctl_sched_rt_ratio;
+extern unsigned int sysctl_sched_rt_runtime;
 #if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
 extern unsigned int sysctl_sched_min_bal_int_shares;
 extern unsigned int sysctl_sched_max_bal_int_shares;
@@ -2014,6 +2014,12 @@ extern void sched_destroy_group(struct t
 extern void sched_move_task(struct task_struct *tsk);
 extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
 extern unsigned long sched_group_shares(struct task_group *tg);
+extern int sched_group_set_rt_runtime(struct task_group *tg,
+				      unsigned long rt_runtime_us);
+extern unsigned long sched_group_rt_runtime(struct task_group *tg);
+extern int sched_group_set_rt_period(struct task_group *tg,
+				     unsigned long rt_runtime_us);
+extern unsigned long sched_group_rt_period(struct task_group *tg);
 
 #endif
 
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -176,7 +176,7 @@ struct task_group {
 	struct sched_rt_entity **rt_se;
 	struct rt_rq **rt_rq;
 
-	unsigned int rt_ratio;
+	u64 rt_runtime;
 	ktime_t rt_period;
 
 	/*
@@ -646,19 +646,16 @@ const_debug unsigned int sysctl_sched_fe
 const_debug unsigned int sysctl_sched_nr_migrate = 32;
 
 /*
- * period over which we measure -rt task cpu usage in us.
+ * period over which we measure rt task cpu usage in us.
  * default: 1s
  */
 const_debug unsigned int sysctl_sched_rt_period = 1000000;
 
-#define SCHED_RT_FRAC_SHIFT	16
-#define SCHED_RT_FRAC		(1UL << SCHED_RT_FRAC_SHIFT)
-
 /*
- * ratio of time -rt tasks may consume.
- * default: 95%
+ * part of the period that we allow rt tasks to run in us.
+ * default: 0.95s
  */
-const_debug unsigned int sysctl_sched_rt_ratio = 62259;
+const_debug unsigned int sysctl_sched_rt_runtime = 950000;
 
 /*
  * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
@@ -7209,7 +7206,8 @@ void __init sched_init(void)
 				&per_cpu(init_sched_entity, i), i, 1);
 
 		rq->rt.rt_rq_type = RT_RQ_EDF;
-		init_task_group.rt_ratio = sysctl_sched_rt_ratio; /* XXX */
+		init_task_group.rt_runtime =
+			sysctl_sched_rt_runtime * NSEC_PER_USEC;
 		init_task_group.rt_period =
 			ns_to_ktime(sysctl_sched_rt_period * NSEC_PER_USEC);
 		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
@@ -7606,7 +7604,7 @@ struct task_group *sched_create_group(vo
 		goto err;
 
 	tg->shares = NICE_0_LOAD;
-	tg->rt_ratio = 0; /* XXX */
+	tg->rt_runtime = 0; /* XXX */
 	tg->rt_period = ns_to_ktime(sysctl_sched_rt_period * NSEC_PER_USEC);
 
 	for_each_possible_cpu(i) {
@@ -7801,41 +7799,87 @@ unsigned long sched_group_shares(struct 
 }
 
 /*
- * Ensure the total rt_ratio <= sysctl_sched_rt_ratio
+ * Ensure that the real time constraints are schedulable.
  */
-int sched_group_set_rt_ratio(struct task_group *tg, unsigned long rt_ratio)
+static DEFINE_MUTEX(rt_constraints_mutex);
+
+static unsigned long to_ratio(u64 period, u64 runtime)
+{
+	u64 r = runtime * (1ULL << 16);
+	do_div(r, period);
+	return r;
+}
+
+static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
 {
 	struct task_group *tgi;
 	unsigned long total = 0;
+	unsigned long global_ratio =
+		to_ratio(sysctl_sched_rt_period, sysctl_sched_rt_runtime);
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(tgi, &task_groups, list)
-		total += tgi->rt_ratio;
+	list_for_each_entry_rcu(tgi, &task_groups, list) {
+		if (tgi == tg)
+			continue;
+
+		total += to_ratio(ktime_to_ns(tgi->rt_period), tgi->rt_runtime);
+	}
 	rcu_read_unlock();
 
-	if (total + rt_ratio - tg->rt_ratio > sysctl_sched_rt_ratio)
-		return -EINVAL;
+	return total + to_ratio(period, runtime) < global_ratio;
+}
 
-	tg->rt_ratio = rt_ratio;
-	return 0;
+int sched_group_set_rt_runtime(struct task_group *tg,
+			       unsigned long rt_runtime_us)
+{
+	u64 rt_runtime = (u64)rt_runtime_us * NSEC_PER_USEC;
+	int err = 0;
+
+	mutex_lock(&rt_constraints_mutex);
+	if (!__rt_schedulable(tg, ktime_to_ns(tg->rt_period), rt_runtime)) {
+		err = -EINVAL;
+		goto unlock;
+	}
+
+	tg->rt_runtime = rt_runtime;
+ unlock:
+	mutex_unlock(&rt_constraints_mutex);
+
+	return err;
 }
 
-unsigned long sched_group_rt_ratio(struct task_group *tg)
+unsigned long sched_group_rt_runtime(struct task_group *tg)
 {
-	return tg->rt_ratio;
+	u64 rt_runtime_us = tg->rt_runtime;
+
+	do_div(rt_runtime_us, NSEC_PER_USEC);
+	return rt_runtime_us;
 }
 
-int sched_group_set_rt_period(struct task_group *tg, unsigned long rt_period)
+int sched_group_set_rt_period(struct task_group *tg, unsigned long rt_period_us)
 {
-	tg->rt_period = ns_to_ktime((u64)rt_period * NSEC_PER_USEC);
-	return 0;
+	u64 rt_period = (u64)rt_period_us * NSEC_PER_USEC;
+	int err = 0;
+
+	mutex_lock(&rt_constraints_mutex);
+	if (!__rt_schedulable(tg, rt_period, tg->rt_runtime)) {
+		err = -EINVAL;
+		goto unlock;
+	}
+
+	tg->rt_period = ns_to_ktime(rt_period);
+ unlock:
+	mutex_unlock(&rt_constraints_mutex);
+
+	return err;
 }
 
 unsigned long sched_group_rt_period(struct task_group *tg)
 {
-	u64 ns = ktime_to_ns(tg->rt_period);
-	do_div(ns, NSEC_PER_USEC);
-	return ns;
+	u64 rt_period_us = ktime_to_ns(tg->rt_period);
+
+	do_div(rt_period_us, NSEC_PER_USEC);
+	return rt_period_us;
 }
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
@@ -7913,17 +7957,15 @@ static u64 cpu_shares_read_uint(struct c
 	return (u64) tg->shares;
 }
 
-static int cpu_rt_ratio_write_uint(struct cgroup *cgrp, struct cftype *cftype,
-		u64 rt_ratio_val)
+static int cpu_rt_runtime_write_uint(struct cgroup *cgrp, struct cftype *cftype,
+		u64 rt_runtime_val)
 {
-	return sched_group_set_rt_ratio(cgroup_tg(cgrp), rt_ratio_val);
+	return sched_group_set_rt_runtime(cgroup_tg(cgrp), rt_runtime_val);
 }
 
-static u64 cpu_rt_ratio_read_uint(struct cgroup *cgrp, struct cftype *cft)
+static u64 cpu_rt_runtime_read_uint(struct cgroup *cgrp, struct cftype *cft)
 {
-	struct task_group *tg = cgroup_tg(cgrp);
-
-	return (u64) tg->rt_ratio;
+	return sched_group_rt_runtime(cgroup_tg(cgrp));
 }
 
 static int cpu_rt_period_write_uint(struct cgroup *cgrp, struct cftype *cftype,
@@ -7934,7 +7976,7 @@ static int cpu_rt_period_write_uint(stru
 
 static u64 cpu_rt_period_read_uint(struct cgroup *cgrp, struct cftype *cft)
 {
-	return (u64) sched_group_rt_period(cgroup_tg(cgrp));
+	return sched_group_rt_period(cgroup_tg(cgrp));
 }
 
 static struct cftype cpu_files[] = {
@@ -7944,9 +7986,9 @@ static struct cftype cpu_files[] = {
 		.write_uint = cpu_shares_write_uint,
 	},
 	{
-		.name = "rt_ratio",
-		.read_uint = cpu_rt_ratio_read_uint,
-		.write_uint = cpu_rt_ratio_write_uint,
+		.name = "rt_runtime_us",
+		.read_uint = cpu_rt_runtime_read_uint,
+		.write_uint = cpu_rt_runtime_write_uint,
 	},
 	{
 		.name = "rt_period_us",
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -57,12 +57,12 @@ static inline int on_rt_rq(struct sched_
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
-static inline unsigned int sched_rt_ratio(struct rt_rq *rt_rq)
+static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
 {
 	if (!rt_rq->tg)
-		return SCHED_RT_FRAC;
+		return 0;
 
-	return rt_rq->tg->rt_ratio;
+	return rt_rq->tg->rt_runtime;
 }
 
 static inline ktime_t sched_rt_period(struct rt_rq *rt_rq)
@@ -100,7 +100,7 @@ static inline struct rt_rq *group_rt_rq(
 static void enqueue_rt_entity(struct sched_rt_entity *rt_se);
 static void dequeue_rt_entity(struct sched_rt_entity *rt_se);
 
-static void sched_rt_ratio_enqueue(struct rt_rq *rt_rq)
+static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 {
 	struct sched_rt_entity *rt_se = rt_rq->rt_se;
 
@@ -113,7 +113,7 @@ static void sched_rt_ratio_enqueue(struc
 	}
 }
 
-static void sched_rt_ratio_dequeue(struct rt_rq *rt_rq)
+static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 {
 	struct sched_rt_entity *rt_se = rt_rq->rt_se;
 
@@ -218,9 +218,9 @@ static struct sched_rt_entity *next_rt_d
 
 #else
 
-static inline unsigned int sched_rt_ratio(struct rt_rq *rt_rq)
+static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
 {
-	return sysctl_sched_rt_ratio;
+	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
 }
 
 static inline ktime_t sched_rt_period(struct rt_rq *rt_rq)
@@ -257,11 +257,11 @@ static inline struct rt_rq *group_rt_rq(
 	return NULL;
 }
 
-static inline void sched_rt_ratio_enqueue(struct rt_rq *rt_rq)
+static inline void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 {
 }
 
-static inline void sched_rt_ratio_dequeue(struct rt_rq *rt_rq)
+static inline void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 {
 }
 
@@ -300,25 +300,21 @@ static inline int rt_se_prio(struct sche
 	return rt_task_of(rt_se)->prio;
 }
 
-static int sched_rt_ratio_exceeded(struct rt_rq *rt_rq)
+static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 {
-	unsigned int rt_ratio = sched_rt_ratio(rt_rq);
-	u64 period, ratio;
+	u64 runtime = sched_rt_runtime(rt_rq);
 
-	if (rt_ratio == SCHED_RT_FRAC)
+	if (!runtime)
 		goto out;
 
 	if (rt_rq->rt_throttled)
 		goto out;
 
-	period = sched_rt_period_ns(rt_rq);
-	ratio = (period * rt_ratio) >> SCHED_RT_FRAC_SHIFT;
-
-	if (rt_rq->rt_time > ratio) {
+	if (rt_rq->rt_time > runtime) {
 		rt_rq->rt_throttled = 1;
 		if (rt_rq_throttled(rt_rq)) {
 			WARN_ON(!hrtimer_active(&rt_rq->rt_period_timer));
-			sched_rt_ratio_dequeue(rt_rq);
+			sched_rt_rq_dequeue(rt_rq);
 		}
 	}
 
@@ -328,14 +324,12 @@ out:
 
 static void update_sched_rt_period(struct rt_rq *rt_rq)
 {
-	u64 period = sched_rt_period_ns(rt_rq);
-	unsigned long rt_ratio = sched_rt_ratio(rt_rq);
-	u64 ratio = (period * rt_ratio) >> SCHED_RT_FRAC_SHIFT;
+	u64 runtime = sched_rt_runtime(rt_rq);
 
-	rt_rq->rt_time -= min(rt_rq->rt_time, ratio);
+	rt_rq->rt_time -= min(rt_rq->rt_time, runtime);
 	if (rt_rq->rt_throttled) {
 		rt_rq->rt_throttled = 0;
-		sched_rt_ratio_enqueue(rt_rq);
+		sched_rt_rq_enqueue(rt_rq);
 	}
 }
 
@@ -412,7 +406,7 @@ static void update_curr_rt(struct rq *rq
 	cpuacct_charge(curr, delta_exec);
 
 	rt_rq->rt_time += delta_exec;
-	if (sched_rt_ratio_exceeded(rt_rq))
+	if (sched_rt_runtime_exceeded(rt_rq))
 		resched_task(curr);
 }
 
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -319,8 +319,8 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_rt_ratio",
-		.data		= &sysctl_sched_rt_ratio,
+		.procname	= "sched_rt_runtime_us",
+		.data		= &sysctl_sched_rt_runtime,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,

--


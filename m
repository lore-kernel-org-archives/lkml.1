Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbXLaAiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbXLaAiU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 19:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbXLaAiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 19:38:08 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:26901 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754349AbXLaAiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 19:38:05 -0500
Message-Id: <20071231001647.246807000@chello.nl>
References: <20071231001137.147986000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 31 Dec 2007 01:11:39 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 2/3] sched: rt time limit
Content-Disposition: inline; filename=sched-rt-limit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very simple time limit on the realtime scheduling classes.
Allow the rq's realtime class to consume sched_rt_ratio of every
sched_rt_period slice. If the class exceeds this quota the fair class
will preempt the realtime class.

TODO: 
 - rt limit vs load-balance
 - proper interface

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    2 +
 kernel/sched.c        |   70 +++++++++++++++++++++++++++++++++++---------------
 kernel/sched_rt.c     |   53 +++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c       |   18 ++++++++++++
 4 files changed, 122 insertions(+), 21 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1531,6 +1531,8 @@ extern unsigned int sysctl_sched_child_r
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
+extern unsigned int sysctl_sched_rt_period;
+extern unsigned int sysctl_sched_rt_ratio;
 #if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
 extern unsigned int sysctl_sched_min_bal_int_shares;
 extern unsigned int sysctl_sched_max_bal_int_shares;
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -342,13 +342,14 @@ struct cfs_rq {
 /* Real-Time classes' related field in a runqueue: */
 struct rt_rq {
 	struct rt_prio_array active;
-	int rt_load_balance_idx;
-	struct list_head *rt_load_balance_head, *rt_load_balance_curr;
 	unsigned long rt_nr_running;
+#ifdef CONFIG_SMP
 	unsigned long rt_nr_migratory;
-	/* highest queued rt task prio */
-	int highest_prio;
+	int highest_prio; /* highest queued rt task prio */
 	int overloaded;
+#endif
+	u64 rt_time;
+	u64 rt_throttled;
 };
 
 #ifdef CONFIG_SMP
@@ -415,6 +416,7 @@ struct rq {
 	struct list_head leaf_cfs_rq_list;
 #endif
 	struct rt_rq rt;
+	u64 rt_period_expire;
 
 	/*
 	 * This is part of a global counter where only the total sum
@@ -601,6 +603,21 @@ const_debug unsigned int sysctl_sched_fe
 const_debug unsigned int sysctl_sched_nr_migrate = 32;
 
 /*
+ * period over which we measure -rt task cpu usage in ms.
+ * default: 1s
+ */
+const_debug unsigned int sysctl_sched_rt_period = 1000;
+
+#define SCHED_RT_FRAC_SHIFT	16
+#define SCHED_RT_FRAC		(1UL << SCHED_RT_FRAC_SHIFT)
+
+/*
+ * ratio of time -rt tasks may consume.
+ * default: 100%
+ */
+const_debug unsigned int sysctl_sched_rt_ratio = SCHED_RT_FRAC;
+
+/*
  * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
  * clock constructed from sched_clock():
  */
@@ -3673,8 +3690,8 @@ void scheduler_tick(void)
 		rq->clock = next_tick;
 	rq->tick_timestamp = rq->clock;
 	update_cpu_load(rq);
-	if (curr != rq->idle) /* FIXME: needed? */
-		curr->sched_class->task_tick(rq, curr, 0);
+	curr->sched_class->task_tick(rq, curr, 0);
+	update_sched_rt_period(rq);
 	spin_unlock(&rq->lock);
 
 #ifdef CONFIG_SMP
@@ -7029,6 +7046,29 @@ static void init_cfs_rq(struct cfs_rq *c
 	cfs_rq->min_vruntime = (u64)(-(1LL << 20));
 }
 
+static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
+{
+	struct rt_prio_array *array;
+	int i;
+
+	array = &rt_rq->active;
+	for (i = 0; i < MAX_RT_PRIO; i++) {
+		INIT_LIST_HEAD(array->queue + i);
+		__clear_bit(i, array->bitmap);
+	}
+	/* delimiter for bitsearch: */
+	__set_bit(MAX_RT_PRIO, array->bitmap);
+
+#ifdef CONFIG_SMP
+	rt_rq->rt_nr_migratory = 0;
+	rt_rq->highest_prio = MAX_RT_PRIO;
+	rt_rq->overloaded = 0;
+#endif
+
+	rt_rq->rt_time = 0;
+	rt_rq->rt_throttled = 0;
+}
+
 void __init sched_init(void)
 {
 	int highest_cpu = 0;
@@ -7039,7 +7079,6 @@ void __init sched_init(void)
 #endif
 
 	for_each_possible_cpu(i) {
-		struct rt_prio_array *array;
 		struct rq *rq;
 
 		rq = cpu_rq(i);
@@ -7071,6 +7110,8 @@ void __init sched_init(void)
 		}
 		init_task_group.shares = init_task_group_load;
 #endif
+		init_rt_rq(&rq->rt, rq);
+		rq->rt_period_expire = 0;
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
 			rq->cpu_load[j] = 0;
@@ -7083,22 +7124,11 @@ void __init sched_init(void)
 		rq->cpu = i;
 		rq->migration_thread = NULL;
 		INIT_LIST_HEAD(&rq->migration_queue);
-		rq->rt.highest_prio = MAX_RT_PRIO;
-		rq->rt.overloaded = 0;
 		rq_attach_root(rq, &def_root_domain);
 #endif
 		init_rq_hrtick(rq);
-
 		atomic_set(&rq->nr_iowait, 0);
-
-		array = &rq->rt.active;
-		for (j = 0; j < MAX_RT_PRIO; j++) {
-			INIT_LIST_HEAD(array->queue + j);
-			__clear_bit(j, array->bitmap);
-		}
 		highest_cpu = i;
-		/* delimiter for bitsearch: */
-		__set_bit(MAX_RT_PRIO, array->bitmap);
 	}
 
 	set_load_weight(&init_task);
@@ -7270,7 +7300,7 @@ void set_curr_task(int cpu, struct task_
 #ifdef CONFIG_SMP
 /*
  * distribute shares of all task groups among their schedulable entities,
- * to reflect load distrbution across cpus.
+ * to reflect load distribution across cpus.
  */
 static int rebalance_shares(struct sched_domain *sd, int this_cpu)
 {
@@ -7337,7 +7367,7 @@ static int rebalance_shares(struct sched
  * sysctl_sched_max_bal_int_shares represents the maximum interval between
  * consecutive calls to rebalance_shares() in the same sched domain.
  *
- * These settings allows for the appropriate tradeoff between accuracy of
+ * These settings allows for the appropriate trade-off between accuracy of
  * fairness and the associated overhead.
  *
  */
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -45,6 +45,50 @@ static void update_rt_migration(struct r
 }
 #endif /* CONFIG_SMP */
 
+static int sched_rt_ratio_exceeded(struct rq *rq, struct rt_rq *rt_rq)
+{
+	u64 period, ratio;
+
+	if (sysctl_sched_rt_ratio == SCHED_RT_FRAC)
+		return 0;
+
+	if (rt_rq->rt_throttled)
+		return 1;
+
+	period = (u64)sysctl_sched_rt_period * NSEC_PER_MSEC;
+	ratio = (period * sysctl_sched_rt_ratio) >> SCHED_RT_FRAC_SHIFT;
+
+	if (rt_rq->rt_time > ratio) {
+		rt_rq->rt_throttled = rq->clock + period - rt_rq->rt_time;
+		return 1;
+	}
+
+	return 0;
+}
+
+static void update_sched_rt_period(struct rq *rq)
+{
+	while (rq->clock > rq->rt_period_expire) {
+		u64 period, ratio;
+
+		period = (u64)sysctl_sched_rt_period * NSEC_PER_MSEC;
+		ratio = (period * sysctl_sched_rt_ratio) >> SCHED_RT_FRAC_SHIFT;
+
+		rq->rt.rt_time -= min(rq->rt.rt_time, ratio);
+		rq->rt_period_expire += period;
+	}
+
+	/*
+	 * When the rt throttle is expired, let them rip.
+	 * (XXX: use hrtick when available)
+	 */
+	if (rq->rt.rt_throttled && rq->clock > rq->rt.rt_throttled) {
+		rq->rt.rt_throttled = 0;
+		if (!sched_rt_ratio_exceeded(rq, &rq->rt))
+			resched_task(rq->curr);
+	}
+}
+
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
@@ -66,6 +110,11 @@ static void update_curr_rt(struct rq *rq
 	curr->se.sum_exec_runtime += delta_exec;
 	curr->se.exec_start = rq->clock;
 	cpuacct_charge(curr, delta_exec);
+
+	rq->rt.rt_time += delta_exec;
+	update_sched_rt_period(rq);
+	if (sched_rt_ratio_exceeded(rq, &rq->rt))
+		resched_task(curr);
 }
 
 static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
@@ -208,8 +257,12 @@ static struct task_struct *pick_next_tas
 	struct rt_prio_array *array = &rq->rt.active;
 	struct task_struct *next;
 	struct list_head *queue;
+	struct rt_rq *rt_rq = &rq->rt;
 	int idx;
 
+	if (sched_rt_ratio_exceeded(rq, rt_rq))
+		return NULL;
+
 	idx = sched_find_first_bit(array->bitmap);
 	if (idx >= MAX_RT_PRIO)
 		return NULL;
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -309,7 +309,23 @@ static struct ctl_table kern_table[] = {
 		.procname	= "sched_nr_migrate",
 		.data		= &sysctl_sched_nr_migrate,
 		.maxlen		= sizeof(unsigned int),
-		.mode		= 644,
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_rt_period_ms",
+		.data		= &sysctl_sched_rt_period,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_rt_ratio",
+		.data		= &sysctl_sched_rt_ratio,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
 #if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)

--


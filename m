Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349Ab0AEIBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab0AEIBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 03:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283Ab0AEIBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 03:01:08 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:55091 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab0AEIBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 03:01:06 -0500
Date: Tue, 5 Jan 2010 13:30:21 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: [RFC v5 PATCH 3/8] sched: Bandwidth initialization for fair task
	groups
Message-ID: <20100105080021.GH27899@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20100105075703.GE27899@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105075703.GE27899@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: Bandwidth initialization for fair task groups.

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

Introduce the notion of hard limiting for CFS groups by bringing in
the concept of runtime and period for them. Add cgroup files to control
runtime and period.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 init/Kconfig        |   13 ++++
 kernel/sched.c      |  164 +++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_fair.c |   18 ++++++
 3 files changed, 195 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index a23da9f..6b76df4 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -486,6 +486,19 @@ config CGROUP_SCHED
 
 endchoice
 
+config CFS_HARD_LIMITS
+	bool "Hard Limits for CFS Group Scheduler"
+	depends on EXPERIMENTAL
+	depends on FAIR_GROUP_SCHED && CGROUP_SCHED
+	default n
+	help
+	  This option enables hard limiting of CPU time obtained by
+	  a fair task group. Use this if you want to throttle a group of tasks
+	  based on its CPU usage. For more details refer to
+	  Documentation/scheduler/sched-cfs-hard-limits.txt
+
+	  Say N if unsure.
+
 menuconfig CGROUPS
 	boolean "Control Group support"
 	help
diff --git a/kernel/sched.c b/kernel/sched.c
index 4a24d62..48d5483 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -151,6 +151,14 @@ static struct sched_bandwidth def_rt_bandwidth;
 
 static int do_sched_rt_period_timer(struct sched_bandwidth *sched_b, int overrun);
 
+/*
+ * Nothing much to do now. Will be populated in subsequent hard limit patches.
+ */
+static int do_sched_cfs_period_timer(struct sched_bandwidth *sched_b, int overrun)
+{
+	return 0;
+}
+
 static enum hrtimer_restart sched_period_timer(struct hrtimer *timer, int rt)
 {
 	struct sched_bandwidth *sched_b =
@@ -168,6 +176,8 @@ static enum hrtimer_restart sched_period_timer(struct hrtimer *timer, int rt)
 
 		if (rt)
 			idle = do_sched_rt_period_timer(sched_b, overrun);
+		else
+			idle = do_sched_cfs_period_timer(sched_b, overrun);
 	}
 
 	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
@@ -266,6 +276,7 @@ struct task_group {
 	/* runqueue "owned" by this group on each cpu */
 	struct cfs_rq **cfs_rq;
 	unsigned long shares;
+	struct sched_bandwidth cfs_bandwidth;
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -463,6 +474,7 @@ struct cfs_rq {
 	unsigned long rq_weight;
 #endif
 #endif
+	struct rq_bandwidth rq_bandwidth;
 };
 
 /* Real-Time classes' related field in a runqueue: */
@@ -2075,6 +2087,38 @@ static inline void balance_runtime(struct rq_bandwidth *rq_b,
 }
 #endif /* CONFIG_SMP */
 
+/*
+ * Runtime allowed for a cfs group before it is hard limited.
+ * default: Infinite which means no hard limiting.
+ */
+u64 sched_cfs_runtime = RUNTIME_INF;
+
+/*
+ * period over which we hard limit the cfs group's bandwidth.
+ * default: 0.5s
+ */
+u64 sched_cfs_period = 500000;
+
+static inline u64 global_cfs_period(void)
+{
+	return sched_cfs_period * NSEC_PER_USEC;
+}
+
+static inline u64 global_cfs_runtime(void)
+{
+	return RUNTIME_INF;
+}
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+/*
+ * Refresh the runtimes of the throttled groups.
+ */
+static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
+{
+	return sched_period_timer(timer, 0);
+}
+#endif
+
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"
@@ -9640,6 +9684,7 @@ static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 	struct rq *rq = cpu_rq(cpu);
 	tg->cfs_rq[cpu] = cfs_rq;
 	init_cfs_rq(cfs_rq, rq);
+	init_rq_bandwidth(&cfs_rq->rq_bandwidth, tg->cfs_bandwidth.runtime);
 	cfs_rq->tg = tg;
 	if (add)
 		list_add(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
@@ -9765,6 +9810,12 @@ void __init sched_init(void)
 #endif /* CONFIG_USER_SCHED */
 #endif /* CONFIG_RT_GROUP_SCHED */
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	init_sched_bandwidth(&init_task_group.cfs_bandwidth,
+		global_cfs_period(), global_cfs_runtime(),
+		&sched_cfs_period_timer);
+#endif
+
 #ifdef CONFIG_GROUP_SCHED
 	list_add(&init_task_group.list, &task_groups);
 	INIT_LIST_HEAD(&init_task_group.children);
@@ -9791,6 +9842,8 @@ void __init sched_init(void)
 		init_cfs_rq(&rq->cfs, rq);
 		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
+		init_rq_bandwidth(&rq->cfs.rq_bandwidth,
+				init_task_group.cfs_bandwidth.runtime);
 		init_task_group.shares = init_task_group_load;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
 #ifdef CONFIG_CGROUP_SCHED
@@ -10070,6 +10123,7 @@ static void free_fair_sched_group(struct task_group *tg)
 {
 	int i;
 
+	destroy_sched_bandwidth(&tg->cfs_bandwidth);
 	for_each_possible_cpu(i) {
 		if (tg->cfs_rq)
 			kfree(tg->cfs_rq[i]);
@@ -10096,6 +10150,8 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 	if (!tg->se)
 		goto err;
 
+	init_sched_bandwidth(&tg->cfs_bandwidth, global_cfs_period(),
+		global_cfs_runtime(), &sched_cfs_period_timer);
 	tg->shares = NICE_0_LOAD;
 
 	for_each_possible_cpu(i) {
@@ -10824,6 +10880,102 @@ static u64 cpu_shares_read_u64(struct cgroup *cgrp, struct cftype *cft)
 
 	return (u64) tg->shares;
 }
+
+#ifdef CONFIG_CFS_HARD_LIMITS
+
+static int tg_set_cfs_bandwidth(struct task_group *tg,
+		u64 cfs_period, u64 cfs_runtime)
+{
+	int i;
+
+	if (tg == &init_task_group)
+		return -EINVAL;
+
+	raw_spin_lock_irq(&tg->cfs_bandwidth.runtime_lock);
+	tg->cfs_bandwidth.period = ns_to_ktime(cfs_period);
+	tg->cfs_bandwidth.runtime = cfs_runtime;
+
+	for_each_possible_cpu(i) {
+		struct cfs_rq *cfs_rq = tg->cfs_rq[i];
+
+		raw_spin_lock(&cfs_rq->rq_bandwidth.runtime_lock);
+		cfs_rq->rq_bandwidth.runtime = cfs_runtime;
+		raw_spin_unlock(&cfs_rq->rq_bandwidth.runtime_lock);
+	}
+
+	raw_spin_unlock_irq(&tg->cfs_bandwidth.runtime_lock);
+	return 0;
+}
+
+int tg_set_cfs_runtime(struct task_group *tg, long cfs_runtime_us)
+{
+	u64 cfs_runtime, cfs_period;
+
+	cfs_period = ktime_to_ns(tg->cfs_bandwidth.period);
+	cfs_runtime = (u64)cfs_runtime_us * NSEC_PER_USEC;
+	if (cfs_runtime_us < 0)
+		cfs_runtime = RUNTIME_INF;
+
+	return tg_set_cfs_bandwidth(tg, cfs_period, cfs_runtime);
+}
+
+long tg_get_cfs_runtime(struct task_group *tg)
+{
+	u64 cfs_runtime_us;
+
+	if (tg->cfs_bandwidth.runtime == RUNTIME_INF)
+		return -1;
+
+	cfs_runtime_us = tg->cfs_bandwidth.runtime;
+	do_div(cfs_runtime_us, NSEC_PER_USEC);
+	return cfs_runtime_us;
+}
+
+int tg_set_cfs_period(struct task_group *tg, long cfs_period_us)
+{
+	u64 cfs_runtime, cfs_period;
+
+	cfs_period = (u64)cfs_period_us * NSEC_PER_USEC;
+	cfs_runtime = tg->cfs_bandwidth.runtime;
+
+	if (cfs_period == 0)
+		return -EINVAL;
+
+	return tg_set_cfs_bandwidth(tg, cfs_period, cfs_runtime);
+}
+
+long tg_get_cfs_period(struct task_group *tg)
+{
+	u64 cfs_period_us;
+
+	cfs_period_us = ktime_to_ns(tg->cfs_bandwidth.period);
+	do_div(cfs_period_us, NSEC_PER_USEC);
+	return cfs_period_us;
+}
+
+static s64 cpu_cfs_runtime_read_s64(struct cgroup *cgrp, struct cftype *cft)
+{
+	return tg_get_cfs_runtime(cgroup_tg(cgrp));
+}
+
+static int cpu_cfs_runtime_write_s64(struct cgroup *cgrp, struct cftype *cftype,
+				s64 cfs_runtime_us)
+{
+	return tg_set_cfs_runtime(cgroup_tg(cgrp), cfs_runtime_us);
+}
+
+static u64 cpu_cfs_period_read_u64(struct cgroup *cgrp, struct cftype *cft)
+{
+	return tg_get_cfs_period(cgroup_tg(cgrp));
+}
+
+static int cpu_cfs_period_write_u64(struct cgroup *cgrp, struct cftype *cftype,
+				u64 cfs_period_us)
+{
+	return tg_set_cfs_period(cgroup_tg(cgrp), cfs_period_us);
+}
+
+#endif /* CONFIG_CFS_HARD_LIMITS */
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -10857,6 +11009,18 @@ static struct cftype cpu_files[] = {
 		.read_u64 = cpu_shares_read_u64,
 		.write_u64 = cpu_shares_write_u64,
 	},
+#ifdef CONFIG_CFS_HARD_LIMITS
+	{
+		.name = "cfs_runtime_us",
+		.read_s64 = cpu_cfs_runtime_read_s64,
+		.write_s64 = cpu_cfs_runtime_write_s64,
+	},
+	{
+		.name = "cfs_period_us",
+		.read_u64 = cpu_cfs_period_read_u64,
+		.write_u64 = cpu_cfs_period_write_u64,
+	},
+#endif /* CONFIG_CFS_HARD_LIMITS */
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
 	{
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 42ac3c9..0dfb7a5 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -205,6 +205,18 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 	}
 }
 
+static inline struct sched_bandwidth *sched_cfs_bandwidth(struct cfs_rq *cfs_rq)
+{
+	return &cfs_rq->tg->cfs_bandwidth;
+}
+
+static inline void start_cfs_bandwidth(struct cfs_rq *cfs_rq)
+{
+	if (cfs_rq->tg)
+		start_sched_bandwidth(sched_cfs_bandwidth(cfs_rq), 0);
+	return;
+}
+
 #else	/* !CONFIG_FAIR_GROUP_SCHED */
 
 static inline struct task_struct *task_of(struct sched_entity *se)
@@ -265,6 +277,11 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 {
 }
 
+static inline void start_cfs_bandwidth(struct cfs_rq *cfs_rq)
+{
+	return;
+}
+
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
 
@@ -360,6 +377,7 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 	rb_link_node(&se->run_node, parent, link);
 	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
+	start_cfs_bandwidth(cfs_rq);
 }
 
 static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)

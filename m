Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbZKQOep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbZKQOep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 09:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbZKQOep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 09:34:45 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49657 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbZKQOen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 09:34:43 -0500
Date: Tue, 17 Nov 2009 20:04:39 +0530
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
Subject: [RFC v4 PATCH 2/7] sched: Bandwidth initialization for fair task
	groups
Message-ID: <20091117143439.GM17335@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20091117143306.GK17335@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117143306.GK17335@in.ibm.com>
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
 init/Kconfig   |   13 +++
 kernel/sched.c |  277 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 290 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index f515864..fea8cbe 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -477,6 +477,19 @@ config CGROUP_SCHED
 
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
index 1309e8d..1d46fdc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -237,6 +237,15 @@ static DEFINE_MUTEX(sched_domains_mutex);
 
 #include <linux/cgroup.h>
 
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_CFS_HARD_LIMITS)
+struct cfs_bandwidth {
+	spinlock_t		cfs_runtime_lock;
+	ktime_t			cfs_period;
+	u64			cfs_runtime;
+	struct hrtimer		cfs_period_timer;
+};
+#endif
+
 struct cfs_rq;
 
 static LIST_HEAD(task_groups);
@@ -257,6 +266,9 @@ struct task_group {
 	/* runqueue "owned" by this group on each cpu */
 	struct cfs_rq **cfs_rq;
 	unsigned long shares;
+#ifdef CONFIG_CFS_HARD_LIMITS
+	struct cfs_bandwidth cfs_bandwidth;
+#endif
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -445,6 +457,19 @@ struct cfs_rq {
 	unsigned long rq_weight;
 #endif
 #endif
+#ifdef CONFIG_CFS_HARD_LIMITS
+	/* set when the group is throttled  on this cpu */
+	int cfs_throttled;
+
+	/* runtime currently consumed by the group on this rq */
+	u64 cfs_time;
+
+	/* runtime available to the group on this rq */
+	u64 cfs_runtime;
+
+	/* Protects the cfs runtime related fields of this cfs_rq */
+	spinlock_t cfs_runtime_lock;
+#endif
 };
 
 /* Real-Time classes' related field in a runqueue: */
@@ -1833,6 +1858,144 @@ static inline const struct cpumask *sched_bw_period_mask(void)
 
 #endif
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_CFS_HARD_LIMITS
+
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
+static inline void cfs_rq_runtime_lock(struct cfs_rq *cfs_rq)
+{
+	spin_lock(&cfs_rq->cfs_runtime_lock);
+}
+
+static inline void cfs_rq_runtime_unlock(struct cfs_rq *cfs_rq)
+{
+	spin_unlock(&cfs_rq->cfs_runtime_lock);
+}
+
+/*
+ * Refresh the runtimes of the throttled groups.
+ * But nothing much to do now, will populate this in later patches.
+ */
+static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
+{
+	struct cfs_bandwidth *cfs_b =
+		container_of(timer, struct cfs_bandwidth, cfs_period_timer);
+
+	hrtimer_add_expires_ns(timer, ktime_to_ns(cfs_b->cfs_period));
+	return HRTIMER_RESTART;
+}
+
+/*
+ * TODO: Check if this kind of timer setup is sufficient for cfs or
+ * should we do what rt is doing.
+ */
+static void start_cfs_bandwidth(struct task_group *tg)
+{
+	struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
+
+	/*
+	 * Timer isn't setup for groups with infinite runtime
+	 */
+	if (cfs_b->cfs_runtime == RUNTIME_INF)
+		return;
+
+	if (hrtimer_active(&cfs_b->cfs_period_timer))
+		return;
+
+	hrtimer_start_range_ns(&cfs_b->cfs_period_timer, cfs_b->cfs_period,
+			0, HRTIMER_MODE_REL);
+}
+
+static void init_cfs_bandwidth(struct task_group *tg)
+{
+	struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
+
+	cfs_b->cfs_period = ns_to_ktime(global_cfs_period());
+	cfs_b->cfs_runtime = global_cfs_runtime();
+
+	spin_lock_init(&cfs_b->cfs_runtime_lock);
+
+	hrtimer_init(&cfs_b->cfs_period_timer,
+			CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	cfs_b->cfs_period_timer.function = &sched_cfs_period_timer;
+}
+
+static inline void destroy_cfs_bandwidth(struct task_group *tg)
+{
+	hrtimer_cancel(&tg->cfs_bandwidth.cfs_period_timer);
+}
+
+static void init_cfs_hard_limits(struct cfs_rq *cfs_rq, struct task_group *tg)
+{
+	cfs_rq->cfs_time = 0;
+	cfs_rq->cfs_throttled = 0;
+	cfs_rq->cfs_runtime = tg->cfs_bandwidth.cfs_runtime;
+	spin_lock_init(&cfs_rq->cfs_runtime_lock);
+}
+
+#else /* !CONFIG_CFS_HARD_LIMITS */
+
+static void init_cfs_bandwidth(struct task_group *tg)
+{
+	return;
+}
+
+static inline void destroy_cfs_bandwidth(struct task_group *tg)
+{
+	return;
+}
+
+static void init_cfs_hard_limits(struct cfs_rq *cfs_rq, struct task_group *tg)
+{
+	return;
+}
+
+static inline void cfs_rq_runtime_lock(struct cfs_rq *cfs_rq)
+{
+	return;
+}
+
+static inline void cfs_rq_runtime_unlock(struct cfs_rq *cfs_rq)
+{
+	return;
+}
+
+#endif /* CONFIG_CFS_HARD_LIMITS */
+#else /* !CONFIG_FAIR_GROUP_SCHED */
+
+static inline void cfs_rq_runtime_lock(struct cfs_rq *cfs_rq)
+{
+	return;
+}
+
+static inline void cfs_rq_runtime_unlock(struct cfs_rq *cfs_rq)
+{
+	return;
+}
+
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"
@@ -9286,6 +9449,7 @@ static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 	struct rq *rq = cpu_rq(cpu);
 	tg->cfs_rq[cpu] = cfs_rq;
 	init_cfs_rq(cfs_rq, rq);
+	init_cfs_hard_limits(cfs_rq, tg);
 	cfs_rq->tg = tg;
 	if (add)
 		list_add(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
@@ -9415,6 +9579,10 @@ void __init sched_init(void)
 #endif /* CONFIG_USER_SCHED */
 #endif /* CONFIG_RT_GROUP_SCHED */
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	init_cfs_bandwidth(&init_task_group);
+#endif
+
 #ifdef CONFIG_GROUP_SCHED
 	list_add(&init_task_group.list, &task_groups);
 	INIT_LIST_HEAD(&init_task_group.children);
@@ -9441,6 +9609,7 @@ void __init sched_init(void)
 		init_cfs_rq(&rq->cfs, rq);
 		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
+		init_cfs_hard_limits(&rq->cfs, &init_task_group);
 		init_task_group.shares = init_task_group_load;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
 #ifdef CONFIG_CGROUP_SCHED
@@ -9716,6 +9885,7 @@ static void free_fair_sched_group(struct task_group *tg)
 {
 	int i;
 
+	destroy_cfs_bandwidth(tg);
 	for_each_possible_cpu(i) {
 		if (tg->cfs_rq)
 			kfree(tg->cfs_rq[i]);
@@ -9742,6 +9912,7 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 	if (!tg->se)
 		goto err;
 
+	init_cfs_bandwidth(tg);
 	tg->shares = NICE_0_LOAD;
 
 	for_each_possible_cpu(i) {
@@ -10465,6 +10636,100 @@ static u64 cpu_shares_read_u64(struct cgroup *cgrp, struct cftype *cft)
 
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
+	spin_lock_irq(&tg->cfs_bandwidth.cfs_runtime_lock);
+	tg->cfs_bandwidth.cfs_period = ns_to_ktime(cfs_period);
+	tg->cfs_bandwidth.cfs_runtime = cfs_runtime;
+
+	for_each_possible_cpu(i) {
+		struct cfs_rq *cfs_rq = tg->cfs_rq[i];
+
+		cfs_rq_runtime_lock(cfs_rq);
+		cfs_rq->cfs_runtime = cfs_runtime;
+		cfs_rq_runtime_unlock(cfs_rq);
+	}
+
+	start_cfs_bandwidth(tg);
+	spin_unlock_irq(&tg->cfs_bandwidth.cfs_runtime_lock);
+	return 0;
+}
+
+int tg_set_cfs_runtime(struct task_group *tg, long cfs_runtime_us)
+{
+	u64 cfs_runtime, cfs_period;
+
+	cfs_period = ktime_to_ns(tg->cfs_bandwidth.cfs_period);
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
+	if (tg->cfs_bandwidth.cfs_runtime == RUNTIME_INF)
+		return -1;
+
+	cfs_runtime_us = tg->cfs_bandwidth.cfs_runtime;
+	do_div(cfs_runtime_us, NSEC_PER_USEC);
+	return cfs_runtime_us;
+}
+
+int tg_set_cfs_period(struct task_group *tg, long cfs_period_us)
+{
+	u64 cfs_runtime, cfs_period;
+
+	cfs_period = (u64)cfs_period_us * NSEC_PER_USEC;
+	cfs_runtime = tg->cfs_bandwidth.cfs_runtime;
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
+	cfs_period_us = ktime_to_ns(tg->cfs_bandwidth.cfs_period);
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
@@ -10498,6 +10763,18 @@ static struct cftype cpu_files[] = {
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

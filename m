Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab0BMC4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 21:56:39 -0500
Received: from smtp-out.google.com ([216.239.33.17]:44748 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab0BMC4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 21:56:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=L5bn6LZcUZH2lb+Ry6b5jQEMfsrnSnmac3p4hF3uhpZksym0Un45xrZTKaX91xGGn
	8Ks0/eBfQlE41Dsx88iOg==
Subject: [RFC PATCH v1 1/4] sched: introduce primitives to account for CFS
	bandwidth tracking
To: linux-kernel@vger.kernel.org
From: Paul <pjt@google.com>
Cc: Paul Menage <menage@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>,
       Chris Friesen <cfriesen@nortel.com>, Avi Kivity <avi@redhat.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Nikhil Rao <ncrao@google.com>, Ingo Molnar <mingo@elte.hu>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Mike Waychison <mikew@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>
Date: Fri, 12 Feb 2010 18:54:57 -0800
Message-ID: <20100213025457.23325.69574.stgit@kitami.corp.google.com>
In-Reply-To: <20100213025417.23325.90048.stgit@kitami.corp.google.com>
References: <20100213025417.23325.90048.stgit@kitami.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Turner <pjt@google.com>

In this patch we introduce the notion of CFS bandwidth, to account for the
realities of SMP this is partitioned into globally unassigned bandwidth, and
locally claimed bandwidth:
- The global bandwidth is per task_group, it represents a pool of unclaimed
  bandwidth that cfs_rq's can allocate from.  It uses the new cfs_bandwidth
  structure.
- The local bandwidth is tracked per-cfs_rq, this represents allotments from
  the global pool
  bandwidth assigned to a task_group, this is tracked using the
  new cfs_bandwidth structure.

Bandwidth is managed via cgroupfs via two new files in the cpu subsystem:
- cpu.cfs_period_us : the bandwidth period in usecs
- cpu.cfs_quota_us : the cpu bandwidth (in usecs) that this tg will be allowed
  to consume over period above.

A per-cfs_bandwidth timer is also introduced to handle future refresh at
period expiration.  There's some minor refactoring here so that
start_bandwidth_timer() functionality can be shared

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 init/Kconfig        |    9 ++
 kernel/sched.c      |  275 +++++++++++++++++++++++++++++++++++++++++++++++----
 kernel/sched_fair.c |   14 ++-
 3 files changed, 273 insertions(+), 25 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index d95ca7c..fb8c7d8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -496,6 +496,15 @@ config CGROUP_SCHED
 
 endchoice
 
+config CFS_BANDWIDTH
+	bool "CPU bandwidth provisioning for FAIR_GROUP_SCHED"
+	depends on EXPERIMENTAL
+	depends on FAIR_GROUP_SCHED && CGROUP_SCHED
+	default n
+	help
+	  This option allows users to define quota and period for cpu
+	  bandwidth provisioning on a per-cgroup basis.
+
 menuconfig CGROUPS
 	boolean "Control Group support"
 	help
diff --git a/kernel/sched.c b/kernel/sched.c
index 3a8fb30..6cc4bf4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -190,10 +190,28 @@ static inline int rt_bandwidth_enabled(void)
 	return sysctl_sched_rt_runtime >= 0;
 }
 
-static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
+static void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
 {
-	ktime_t now;
+	unsigned long delta;
+	ktime_t soft, hard, now;
+
+	for (;;) {
+		if (hrtimer_active(period_timer))
+			break;
+
+		now = hrtimer_cb_get_time(period_timer);
+		hrtimer_forward(period_timer, now, period);
+
+		soft = hrtimer_get_softexpires(period_timer);
+		hard = hrtimer_get_expires(period_timer);
+		delta = ktime_to_ns(ktime_sub(hard, soft));
+		__hrtimer_start_range_ns(period_timer, soft, delta, 
+					 HRTIMER_MODE_ABS_PINNED, 0);
+	}
+}
 
+static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
+{
 	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
 		return;
 
@@ -201,22 +219,7 @@ static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
 		return;
 
 	raw_spin_lock(&rt_b->rt_runtime_lock);
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
+	start_bandwidth_timer(&rt_b->rt_period_timer, rt_b->rt_period);
 	raw_spin_unlock(&rt_b->rt_runtime_lock);
 }
 
@@ -241,6 +244,15 @@ struct cfs_rq;
 
 static LIST_HEAD(task_groups);
 
+#ifdef CONFIG_CFS_BANDWIDTH
+struct cfs_bandwidth {
+	raw_spinlock_t		lock;
+	ktime_t			period;
+	u64			runtime, quota;
+	struct hrtimer		period_timer;
+};
+#endif
+
 /* task group related information */
 struct task_group {
 #ifdef CONFIG_CGROUP_SCHED
@@ -272,6 +284,10 @@ struct task_group {
 	struct task_group *parent;
 	struct list_head siblings;
 	struct list_head children;
+
+#ifdef CONFIG_CFS_BANDWIDTH
+	struct cfs_bandwidth cfs_bandwidth;
+#endif
 };
 
 #ifdef CONFIG_USER_SCHED
@@ -445,9 +461,76 @@ struct cfs_rq {
 	 */
 	unsigned long rq_weight;
 #endif
+#ifdef CONFIG_CFS_BANDWIDTH
+	u64 quota_assigned, quota_used;
+#endif
 #endif
 };
 
+#ifdef CONFIG_CFS_BANDWIDTH
+static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun);
+
+static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
+{
+	struct cfs_bandwidth *cfs_b =
+		container_of(timer, struct cfs_bandwidth, period_timer);
+	ktime_t now;
+	int overrun;
+	int idle = 0;
+
+	for (;;) {
+		now = hrtimer_cb_get_time(timer);
+		overrun = hrtimer_forward(timer, now, cfs_b->period);
+
+		if (!overrun)
+			break;
+
+		idle = do_sched_cfs_period_timer(cfs_b, overrun);
+	}
+
+	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
+}
+
+static
+void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b, u64 quota, u64 period)
+{
+	raw_spin_lock_init(&cfs_b->lock);
+	cfs_b->quota = cfs_b->runtime = quota;
+	cfs_b->period = ns_to_ktime(period);
+
+	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	cfs_b->period_timer.function = sched_cfs_period_timer;
+}
+
+static
+void init_cfs_rq_quota(struct cfs_rq *cfs_rq)
+{
+	cfs_rq->quota_used = 0;
+	if (cfs_rq->tg->cfs_bandwidth.quota == RUNTIME_INF)
+		cfs_rq->quota_assigned = RUNTIME_INF;
+	else
+		cfs_rq->quota_assigned = 0;
+}
+
+static void start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	if (cfs_b->quota == RUNTIME_INF)
+		return;
+
+	if (hrtimer_active(&cfs_b->period_timer))
+		return;
+
+	raw_spin_lock(&cfs_b->lock);
+	start_bandwidth_timer(&cfs_b->period_timer, cfs_b->period);
+	raw_spin_unlock(&cfs_b->lock);
+}
+
+static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	hrtimer_cancel(&cfs_b->period_timer);
+}
+#endif
+
 /* Real-Time classes' related field in a runqueue: */
 struct rt_rq {
 	struct rt_prio_array active;
@@ -1834,6 +1917,14 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 #endif
 }
 
+#ifdef CONFIG_CFS_BANDWIDTH
+/*
+ * default period for cfs group bandwidth.
+ * default: 0.5s
+ */
+static u64 sched_cfs_bandwidth_period = 500000000ULL;
+#endif
+
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"
@@ -9422,6 +9513,9 @@ static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 	tg->cfs_rq[cpu] = cfs_rq;
 	init_cfs_rq(cfs_rq, rq);
 	cfs_rq->tg = tg;
+#ifdef CONFIG_CFS_BANDWIDTH
+	init_cfs_rq_quota(cfs_rq);
+#endif
 	if (add)
 		list_add(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
 
@@ -9594,6 +9688,10 @@ void __init sched_init(void)
 		 * We achieve this by letting init_task_group's tasks sit
 		 * directly in rq->cfs (i.e init_task_group->se[] = NULL).
 		 */
+#ifdef CONFIG_CFS_BANDWIDTH
+		init_cfs_bandwidth(&init_task_group.cfs_bandwidth,
+				RUNTIME_INF, sched_cfs_bandwidth_period);
+#endif
 		init_tg_cfs_entry(&init_task_group, &rq->cfs, NULL, i, 1, NULL);
 #elif defined CONFIG_USER_SCHED
 		root_task_group.shares = NICE_0_LOAD;
@@ -9851,6 +9949,10 @@ static void free_fair_sched_group(struct task_group *tg)
 {
 	int i;
 
+#ifdef CONFIG_CFS_BANDWIDTH
+	destroy_cfs_bandwidth(&tg->cfs_bandwidth);
+#endif
+
 	for_each_possible_cpu(i) {
 		if (tg->cfs_rq)
 			kfree(tg->cfs_rq[i]);
@@ -9878,7 +9980,10 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 		goto err;
 
 	tg->shares = NICE_0_LOAD;
-
+#ifdef CONFIG_CFS_BANDWIDTH
+	init_cfs_bandwidth(&tg->cfs_bandwidth, RUNTIME_INF,
+			sched_cfs_bandwidth_period);
+#endif
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
 
@@ -10333,7 +10438,7 @@ static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
 	return walk_tg_tree(tg_schedulable, tg_nop, &data);
 }
 
-static int tg_set_bandwidth(struct task_group *tg,
+static int tg_set_rt_bandwidth(struct task_group *tg,
 		u64 rt_period, u64 rt_runtime)
 {
 	int i, err = 0;
@@ -10372,7 +10477,7 @@ int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
 	if (rt_runtime_us < 0)
 		rt_runtime = RUNTIME_INF;
 
-	return tg_set_bandwidth(tg, rt_period, rt_runtime);
+	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
 }
 
 long sched_group_rt_runtime(struct task_group *tg)
@@ -10397,7 +10502,7 @@ int sched_group_set_rt_period(struct task_group *tg, long rt_period_us)
 	if (rt_period == 0)
 		return -EINVAL;
 
-	return tg_set_bandwidth(tg, rt_period, rt_runtime);
+	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
 }
 
 long sched_group_rt_period(struct task_group *tg)
@@ -10604,6 +10709,120 @@ static u64 cpu_shares_read_u64(struct cgroup *cgrp, struct cftype *cft)
 
 	return (u64) tg->shares;
 }
+
+#ifdef CONFIG_CFS_BANDWIDTH
+static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
+{
+	int i;
+	static DEFINE_MUTEX(mutex);
+
+	if (tg == &init_task_group)
+		return -EINVAL;
+
+	if (!period)
+		return -EINVAL;
+
+	mutex_lock(&mutex);
+	/*
+	 * Ensure we have at least one tick of bandwidth every period.  This is
+	 * to prevent reaching a state of large arrears when throttled via
+	 * entity_tick() resulting in prolonged exit starvation.
+	 */
+	if (NS_TO_JIFFIES(quota) < 1)
+		return -EINVAL;
+
+	raw_spin_lock_irq(&tg->cfs_bandwidth.lock);
+	tg->cfs_bandwidth.period = ns_to_ktime(period);
+	tg->cfs_bandwidth.runtime = tg->cfs_bandwidth.quota = quota;
+	raw_spin_unlock_irq(&tg->cfs_bandwidth.lock);
+
+	for_each_possible_cpu(i) {
+		struct cfs_rq *cfs_rq = tg->cfs_rq[i];
+		struct rq *rq = rq_of(cfs_rq);
+
+		raw_spin_lock_irq(&rq->lock);
+		cfs_rq->quota_used = 0;
+		if (quota == RUNTIME_INF)
+			cfs_rq->quota_assigned = RUNTIME_INF;
+		else
+			cfs_rq->quota_assigned = 0;
+		raw_spin_unlock_irq(&rq->lock);
+	}
+	mutex_unlock(&mutex);
+
+	return 0;
+}
+
+int tg_set_cfs_quota(struct task_group *tg, long cfs_runtime_us)
+{
+	u64 quota, period;
+
+	period = ktime_to_ns(tg->cfs_bandwidth.period);
+	if (cfs_runtime_us < 0)
+		quota = RUNTIME_INF;
+	else
+		quota = (u64)cfs_runtime_us * NSEC_PER_USEC;
+
+	return tg_set_cfs_bandwidth(tg, period, quota);
+}
+
+long tg_get_cfs_quota(struct task_group *tg)
+{
+	u64 quota_us;
+
+	if (tg->cfs_bandwidth.quota == RUNTIME_INF)
+		return -1;
+
+	quota_us = tg->cfs_bandwidth.quota;
+	do_div(quota_us, NSEC_PER_USEC);
+	return quota_us;
+}
+
+int tg_set_cfs_period(struct task_group *tg, long cfs_period_us)
+{
+	u64 quota, period;
+
+	period = (u64)cfs_period_us * NSEC_PER_USEC;
+	quota = tg->cfs_bandwidth.quota;
+
+	if (period <= 0)
+		return -EINVAL;
+
+	return tg_set_cfs_bandwidth(tg, period, quota);
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
+static s64 cpu_cfs_quota_read_s64(struct cgroup *cgrp, struct cftype *cft)
+{
+	return tg_get_cfs_quota(cgroup_tg(cgrp));
+}
+
+static int cpu_cfs_quota_write_s64(struct cgroup *cgrp, struct cftype *cftype,
+				s64 cfs_quota_us)
+{
+	return tg_set_cfs_quota(cgroup_tg(cgrp), cfs_quota_us);
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
+#endif /* CONFIG_CFS_BANDWIDTH */
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -10638,6 +10857,18 @@ static struct cftype cpu_files[] = {
 		.write_u64 = cpu_shares_write_u64,
 	},
 #endif
+#ifdef CONFIG_CFS_BANDWIDTH
+	{
+		.name = "cfs_quota_us",
+		.read_s64 = cpu_cfs_quota_read_s64,
+		.write_s64 = cpu_cfs_quota_write_s64,
+	},
+	{
+		.name = "cfs_period_us",
+		.read_u64 = cpu_cfs_period_read_u64,
+		.write_u64 = cpu_cfs_period_write_u64,
+	},
+#endif
 #ifdef CONFIG_RT_GROUP_SCHED
 	{
 		.name = "rt_runtime_us",
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 8fe7ee8..7b109ff 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -264,10 +264,8 @@ static inline void
 find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 {
 }
-
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
-
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
  */
@@ -360,6 +358,9 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 	rb_link_node(&se->run_node, parent, link);
 	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
+#ifdef CONFIG_CFS_BANDWIDTH
+	start_cfs_bandwidth(&cfs_rq->tg->cfs_bandwidth);
+#endif
 }
 
 static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -1143,6 +1144,13 @@ static void yield_task_fair(struct rq *rq)
 	se->vruntime = rightmost->vruntime + 1;
 }
 
+#ifdef CONFIG_CFS_BANDWIDTH
+static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
+{
+	return 1;
+}
+#endif
+
 #ifdef CONFIG_SMP
 
 static void task_waking_fair(struct rq *rq, struct task_struct *p)
@@ -1172,7 +1180,7 @@ static void task_waking_fair(struct rq *rq, struct task_struct *p)
  * We still saw a performance dip, some tracing learned us that between
  * cgroup:/ and cgroup:/foo balancing the number of affine wakeups increased
  * significantly. Therefore try to bias the error in direction of failing
- * the affine wakeup.
+ * the affie wakeup.
  *
  */
 static long effective_load(struct task_group *tg, int cpu,


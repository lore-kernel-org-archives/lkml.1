Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbYBDVRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbYBDVRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbYBDVRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:17:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46901 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbYBDVRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:17:08 -0500
Message-Id: <20080204211836.968632000@chello.nl>
References: <20080204210258.118479000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 04 Feb 2008 22:03:01 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: tong.n.li@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/8] sched: rt-group: interface
Content-Disposition: inline; filename=sched-rt-group-interface.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the rt_ratio interface to rt_runtime_us, to match rt_period_us.
This avoids picking a granularity for the ratio.

Extend the /sys/kernel/uids/<uid>/ interface to allow setting
the group's rt_runtime.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/ABI/testing/sysfs-kernel-uids |    6 +
 Documentation/sched-rt-group.txt            |   59 +++++++++++
 include/linux/sched.h                       |    7 -
 kernel/sched.c                              |  145 +++++++++++++++++++++-------
 kernel/sched_rt.c                           |   53 ++++------
 kernel/sysctl.c                             |   32 +++---
 kernel/user.c                               |   28 +++++
 7 files changed, 250 insertions(+), 80 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1507,8 +1507,6 @@ extern unsigned int sysctl_sched_child_r
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
-extern unsigned int sysctl_sched_rt_period;
-extern unsigned int sysctl_sched_rt_ratio;
 #if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
 extern unsigned int sysctl_sched_min_bal_int_shares;
 extern unsigned int sysctl_sched_max_bal_int_shares;
@@ -1518,6 +1516,8 @@ int sched_nr_latency_handler(struct ctl_
 		struct file *file, void __user *buffer, size_t *length,
 		loff_t *ppos);
 #endif
+extern unsigned int sysctl_sched_rt_period;
+extern int sysctl_sched_rt_runtime;
 
 extern unsigned int sysctl_sched_compat_yield;
 
@@ -1997,6 +1997,9 @@ extern void sched_destroy_group(struct t
 extern void sched_move_task(struct task_struct *tsk);
 extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
 extern unsigned long sched_group_shares(struct task_group *tg);
+extern int sched_group_set_rt_runtime(struct task_group *tg,
+				      long rt_runtime_us);
+extern long sched_group_rt_runtime(struct task_group *tg);
 
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
 
 	/*
 	 * shares assigned to a task group governs how much of cpu bandwidth
@@ -654,19 +654,21 @@ const_debug unsigned int sysctl_sched_fe
 const_debug unsigned int sysctl_sched_nr_migrate = 32;
 
 /*
- * period over which we measure -rt task cpu usage in ms.
+ * period over which we measure -rt task cpu usage in us.
  * default: 1s
  */
-const_debug unsigned int sysctl_sched_rt_period = 1000;
+unsigned int sysctl_sched_rt_period = 1000000;
 
-#define SCHED_RT_FRAC_SHIFT	16
-#define SCHED_RT_FRAC		(1UL << SCHED_RT_FRAC_SHIFT)
+/*
+ * part of the period that we allow rt tasks to run in us.
+ * default: 0.95s
+ */
+int sysctl_sched_rt_runtime = 950000;
 
 /*
- * ratio of time -rt tasks may consume.
- * default: 95%
+ * single value that denotes runtime == period, ie unlimited time.
  */
-const_debug unsigned int sysctl_sched_rt_ratio = 62259;
+#define RUNTIME_INF	((u64)~0ULL)
 
 /*
  * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
@@ -7191,7 +7193,8 @@ void __init sched_init(void)
 				&per_cpu(init_cfs_rq, i),
 				&per_cpu(init_sched_entity, i), i, 1);
 
-		init_task_group.rt_ratio = sysctl_sched_rt_ratio; /* XXX */
+		init_task_group.rt_runtime =
+			sysctl_sched_rt_runtime * NSEC_PER_USEC;
 		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
 		init_tg_rt_entry(rq, &init_task_group,
 				&per_cpu(init_rt_rq, i),
@@ -7586,7 +7589,7 @@ struct task_group *sched_create_group(vo
 		goto err;
 
 	tg->shares = NICE_0_LOAD;
-	tg->rt_ratio = 0; /* XXX */
+	tg->rt_runtime = 0;
 
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
@@ -7780,30 +7783,76 @@ unsigned long sched_group_shares(struct 
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
+	if (runtime == RUNTIME_INF)
+		return 1ULL << 16;
+
+	runtime *= (1ULL << 16);
+	do_div(runtime, period);
+	return runtime;
+}
+
+static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
 {
 	struct task_group *tgi;
 	unsigned long total = 0;
+	unsigned long global_ratio =
+		to_ratio(sysctl_sched_rt_period,
+			 sysctl_sched_rt_runtime < 0 ?
+				RUNTIME_INF : sysctl_sched_rt_runtime);
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(tgi, &task_groups, list)
-		total += tgi->rt_ratio;
-	rcu_read_unlock();
+	list_for_each_entry_rcu(tgi, &task_groups, list) {
+		if (tgi == tg)
+			continue;
 
-	if (total + rt_ratio - tg->rt_ratio > sysctl_sched_rt_ratio)
-		return -EINVAL;
+		total += to_ratio(period, tgi->rt_runtime);
+	}
+	rcu_read_unlock();
 
-	tg->rt_ratio = rt_ratio;
-	return 0;
+	return total + to_ratio(period, runtime) < global_ratio;
 }
 
-unsigned long sched_group_rt_ratio(struct task_group *tg)
+int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
 {
-	return tg->rt_ratio;
+	u64 rt_runtime, rt_period;
+	int err = 0;
+
+	rt_period = sysctl_sched_rt_period * NSEC_PER_USEC;
+	rt_runtime = (u64)rt_runtime_us * NSEC_PER_USEC;
+	if (rt_runtime_us == -1)
+		rt_runtime = rt_period;
+
+	mutex_lock(&rt_constraints_mutex);
+	if (!__rt_schedulable(tg, rt_period, rt_runtime)) {
+		err = -EINVAL;
+		goto unlock;
+	}
+	if (rt_runtime_us == -1)
+		rt_runtime = RUNTIME_INF;
+	tg->rt_runtime = rt_runtime;
+ unlock:
+	mutex_unlock(&rt_constraints_mutex);
+
+	return err;
 }
 
+long sched_group_rt_runtime(struct task_group *tg)
+{
+	u64 rt_runtime_us;
+
+	if (tg->rt_runtime == RUNTIME_INF)
+		return -1;
+
+	rt_runtime_us = tg->rt_runtime;
+	do_div(rt_runtime_us, NSEC_PER_USEC);
+	return rt_runtime_us;
+}
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_FAIR_CGROUP_SCHED
@@ -7879,17 +7928,49 @@ static u64 cpu_shares_read_uint(struct c
 	return (u64) tg->shares;
 }
 
-static int cpu_rt_ratio_write_uint(struct cgroup *cgrp, struct cftype *cftype,
-		u64 rt_ratio_val)
-{
-	return sched_group_set_rt_ratio(cgroup_tg(cgrp), rt_ratio_val);
+static int cpu_rt_runtime_write(struct cgroup *cgrp, struct cftype *cft,
+				struct file *file,
+				const char __user *userbuf,
+				size_t nbytes, loff_t *unused_ppos)
+{
+	char buffer[64];
+	int retval = 0;
+	s64 val;
+	char *end;
+
+	if (!nbytes)
+		return -EINVAL;
+	if (nbytes >= sizeof(buffer))
+		return -E2BIG;
+	if (copy_from_user(buffer, userbuf, nbytes))
+		return -EFAULT;
+
+	buffer[nbytes] = 0;     /* nul-terminate */
+
+	/* strip newline if necessary */
+	if (nbytes && (buffer[nbytes-1] == '\n'))
+		buffer[nbytes-1] = 0;
+	val = simple_strtoll(buffer, &end, 0);
+	if (*end)
+		return -EINVAL;
+
+	/* Pass to subsystem */
+	retval = sched_group_set_rt_runtime(cgroup_tg(cgrp), val);
+	if (!retval)
+		retval = nbytes;
+	return retval;
 }
 
-static u64 cpu_rt_ratio_read_uint(struct cgroup *cgrp, struct cftype *cft)
-{
-	struct task_group *tg = cgroup_tg(cgrp);
+static ssize_t cpu_rt_runtime_read(struct cgroup *cgrp, struct cftype *cft,
+				   struct file *file,
+				   char __user *buf, size_t nbytes,
+				   loff_t *ppos)
+{
+	char tmp[64];
+	long val = sched_group_rt_runtime(cgroup_tg(cgrp));
+	int len = sprintf(tmp, "%ld\n", val);
 
-	return (u64) tg->rt_ratio;
+	return simple_read_from_buffer(buf, nbytes, ppos, tmp, len);
 }
 
 static struct cftype cpu_files[] = {
@@ -7899,9 +7980,9 @@ static struct cftype cpu_files[] = {
 		.write_uint = cpu_shares_write_uint,
 	},
 	{
-		.name = "rt_ratio",
-		.read_uint = cpu_rt_ratio_read_uint,
-		.write_uint = cpu_rt_ratio_write_uint,
+		.name = "rt_runtime_us",
+		.read = cpu_rt_runtime_read,
+		.write = cpu_rt_runtime_write,
 	},
 };
 
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
+		return RUNTIME_INF;
 
-	return rt_rq->tg->rt_ratio;
+	return rt_rq->tg->rt_runtime;
 }
 
 #define for_each_leaf_rt_rq(rt_rq, rq) \
@@ -89,7 +89,7 @@ static inline struct rt_rq *group_rt_rq(
 static void enqueue_rt_entity(struct sched_rt_entity *rt_se);
 static void dequeue_rt_entity(struct sched_rt_entity *rt_se);
 
-static void sched_rt_ratio_enqueue(struct rt_rq *rt_rq)
+static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 {
 	struct sched_rt_entity *rt_se = rt_rq->rt_se;
 
@@ -102,7 +102,7 @@ static void sched_rt_ratio_enqueue(struc
 	}
 }
 
-static void sched_rt_ratio_dequeue(struct rt_rq *rt_rq)
+static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 {
 	struct sched_rt_entity *rt_se = rt_rq->rt_se;
 
@@ -129,9 +129,12 @@ static int rt_se_boosted(struct sched_rt
 
 #else
 
-static inline unsigned int sched_rt_ratio(struct rt_rq *rt_rq)
+static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
 {
-	return sysctl_sched_rt_ratio;
+	if (sysctl_sched_rt_runtime == -1)
+		return RUNTIME_INF;
+
+	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
 }
 
 #define for_each_leaf_rt_rq(rt_rq, rq) \
@@ -158,11 +161,11 @@ static inline struct rt_rq *group_rt_rq(
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
 
@@ -184,28 +187,24 @@ static inline int rt_se_prio(struct sche
 	return rt_task_of(rt_se)->prio;
 }
 
-static int sched_rt_ratio_exceeded(struct rt_rq *rt_rq)
+static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 {
-	unsigned int rt_ratio = sched_rt_ratio(rt_rq);
-	u64 period, ratio;
+	u64 runtime = sched_rt_runtime(rt_rq);
 
-	if (rt_ratio == SCHED_RT_FRAC)
+	if (runtime == RUNTIME_INF)
 		return 0;
 
 	if (rt_rq->rt_throttled)
 		return rt_rq_throttled(rt_rq);
 
-	period = (u64)sysctl_sched_rt_period * NSEC_PER_MSEC;
-	ratio = (period * rt_ratio) >> SCHED_RT_FRAC_SHIFT;
-
-	if (rt_rq->rt_time > ratio) {
+	if (rt_rq->rt_time > runtime) {
 		struct rq *rq = rq_of_rt_rq(rt_rq);
 
 		rq->rt_throttled = 1;
 		rt_rq->rt_throttled = 1;
 
 		if (rt_rq_throttled(rt_rq)) {
-			sched_rt_ratio_dequeue(rt_rq);
+			sched_rt_rq_dequeue(rt_rq);
 			return 1;
 		}
 	}
@@ -219,17 +218,16 @@ static void update_sched_rt_period(struc
 	u64 period;
 
 	while (rq->clock > rq->rt_period_expire) {
-		period = (u64)sysctl_sched_rt_period * NSEC_PER_MSEC;
+		period = (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
 		rq->rt_period_expire += period;
 
 		for_each_leaf_rt_rq(rt_rq, rq) {
-			unsigned long rt_ratio = sched_rt_ratio(rt_rq);
-			u64 ratio = (period * rt_ratio) >> SCHED_RT_FRAC_SHIFT;
+			u64 runtime = sched_rt_runtime(rt_rq);
 
-			rt_rq->rt_time -= min(rt_rq->rt_time, ratio);
-			if (rt_rq->rt_throttled) {
+			rt_rq->rt_time -= min(rt_rq->rt_time, runtime);
+			if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
 				rt_rq->rt_throttled = 0;
-				sched_rt_ratio_enqueue(rt_rq);
+				sched_rt_rq_enqueue(rt_rq);
 			}
 		}
 
@@ -262,12 +260,7 @@ static void update_curr_rt(struct rq *rq
 	cpuacct_charge(curr, delta_exec);
 
 	rt_rq->rt_time += delta_exec;
-	/*
-	 * might make it a tad more accurate:
-	 *
-	 * update_sched_rt_period(rq);
-	 */
-	if (sched_rt_ratio_exceeded(rt_rq))
+	if (sched_rt_runtime_exceeded(rt_rq))
 		resched_task(curr);
 }
 
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -311,22 +311,6 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_rt_period_ms",
-		.data		= &sysctl_sched_rt_period,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_rt_ratio",
-		.data		= &sysctl_sched_rt_ratio,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
 #if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
 	{
 		.ctl_name       = CTL_UNNUMBERED,
@@ -348,6 +332,22 @@ static struct ctl_table kern_table[] = {
 #endif
 	{
 		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_rt_period_us",
+		.data		= &sysctl_sched_rt_period,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_rt_runtime_us",
+		.data		= &sysctl_sched_rt_runtime,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_compat_yield",
 		.data		= &sysctl_sched_compat_yield,
 		.maxlen		= sizeof(unsigned int),
Index: linux-2.6/Documentation/ABI/testing/sysfs-kernel-uids
===================================================================
--- linux-2.6.orig/Documentation/ABI/testing/sysfs-kernel-uids
+++ linux-2.6/Documentation/ABI/testing/sysfs-kernel-uids
@@ -12,3 +12,9 @@ Description:
 		B has shares = 2048, User B will get twice the CPU
 		bandwidth user A will. For more details refer
 		Documentation/sched-design-CFS.txt
+
+What:		/sys/kernel/uids/<uid>/cpu_rt_runtime_us
+Date:		January 2008
+Contact:	Peter Zijlstra <a.p.zijlstra@chello.nl>
+Description:	See Documentation/sched-rt-group.txt
+
Index: linux-2.6/Documentation/sched-rt-group.txt
===================================================================
--- /dev/null
+++ linux-2.6/Documentation/sched-rt-group.txt
@@ -0,0 +1,59 @@
+
+
+Real-Time group scheduling.
+
+The problem space:
+
+In order to schedule multiple groups of realtime tasks each group must
+be assigned a fixed portion of the cpu time available. Without a minimum
+guarantee a realtime group can obviously fall short. A fuzzy upper limit
+is of no use since it cannot be relied upon. Which leaves us with just
+the single fixed portion.
+
+CPU time is divided by means of specifying how much time can be spend
+running in a given period. Say a frame fixed realtime renderer must
+deliver a 25 frames a second, which yields a period of 0.04s. Now say
+it will also have to play some music and respond to input, leaving it
+with around 80% for the graphics. We can then give this group a runtime
+of 0.8 * 0.04s = 0.032s.
+
+This way the graphics group will have a 0.04s period with a 0.032s runtime
+limit.
+
+Now if the audio thread needs to refill the dma buffer every 0.005s, but
+needs only about 3% cpu time to do so, it will can do with a 0.03 * 0.005s
+= 0.00015s.
+
+
+The Interface:
+
+system wide:
+
+/proc/sys/kernel/sched_rt_period_ms
+/proc/sys/kernel/sched_rt_runtime_us
+
+CONFIG_FAIR_USER_SCHED
+
+/sys/kernel/uids/<uid>/cpu_rt_runtime_us
+
+or
+
+CONFIG_FAIR_CGROUP_SCHED
+
+/cgroup/<cgroup>/cpu.rt_runtime_us
+
+[ time is specified in us because the interface is s32, this gives an
+  operating range of ~35m to 1us ]
+
+The period takes values in [ 1, INT_MAX ], runtime in [ -1, INT_MAX - 1 ].
+
+A runtime of -1 specifies runtime == period, ie. no limit.
+
+New groups get the period from /proc/sys/kernel/sched_rt_period_us and
+a runtime of 0.
+
+Settings are constrainted to:
+
+   \Sum_{i} runtime_{i} / global_period <= global_runtime / global_period
+
+in order to keep the configuration schedulable.
Index: linux-2.6/kernel/user.c
===================================================================
--- linux-2.6.orig/kernel/user.c
+++ linux-2.6/kernel/user.c
@@ -156,9 +156,37 @@ static ssize_t cpu_shares_store(struct k
 static struct kobj_attribute cpu_share_attr =
 	__ATTR(cpu_share, 0644, cpu_shares_show, cpu_shares_store);
 
+static ssize_t cpu_rt_runtime_show(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   char *buf)
+{
+	struct user_struct *up = container_of(kobj, struct user_struct, kobj);
+
+	return sprintf(buf, "%lu\n", sched_group_rt_runtime(up->tg));
+}
+
+static ssize_t cpu_rt_runtime_store(struct kobject *kobj,
+				    struct kobj_attribute *attr,
+				    const char *buf, size_t size)
+{
+	struct user_struct *up = container_of(kobj, struct user_struct, kobj);
+	unsigned long rt_runtime;
+	int rc;
+
+	sscanf(buf, "%lu", &rt_runtime);
+
+	rc = sched_group_set_rt_runtime(up->tg, rt_runtime);
+
+	return (rc ? rc : size);
+}
+
+static struct kobj_attribute cpu_rt_runtime_attr =
+	__ATTR(cpu_rt_runtime, 0644, cpu_rt_runtime_show, cpu_rt_runtime_store);
+
 /* default attributes per uid directory */
 static struct attribute *uids_attributes[] = {
 	&cpu_share_attr.attr,
+	&cpu_rt_runtime_attr.attr,
 	NULL
 };
 

--


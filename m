Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbYAHX1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbYAHX1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYAHX1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:27:32 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46913 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbYAHX1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:27:31 -0500
Subject: Re: [PATCH 12/11] sched: rt-group: uid-group interface
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: vatsa@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080108105733.GA2569@linux.vnet.ibm.com>
References: <20080106161128.152634000@chello.nl>
	 <1199703080.7143.24.camel@twins>
	 <20080107122330.GB25945@linux.vnet.ibm.com>
	 <1199725063.31975.53.camel@lappy>
	 <20080108105733.GA2569@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 00:26:41 +0100
Message-Id: <1199834801.31975.57.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-08 at 16:27 +0530, Dhaval Giani wrote:
> On Mon, Jan 07, 2008 at 05:57:42PM +0100, Peter Zijlstra wrote:
> > 
> > Subject: sched: rt-group: add uid-group interface
> > 
> > Extend the /sys/kernel/uids/<uid>/ interface to allow setting
> > the group's rt_period and rt_runtime.
> > 
> 
> Hi Peter,
> 
> Cool stuff! I will try out these patches and try to give you some
> feedback.
> 
> One request though, could you please add some documentation to
> Documentation/ABI/testing/sysfs-kernel-uids?

compile tested only attempt at finalizing the interface

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1519,8 +1519,6 @@ extern unsigned int sysctl_sched_child_r
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
-extern unsigned int sysctl_sched_rt_period;
-extern unsigned int sysctl_sched_rt_runtime;
 #if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
 extern unsigned int sysctl_sched_min_bal_int_shares;
 extern unsigned int sysctl_sched_max_bal_int_shares;
@@ -1530,6 +1528,8 @@ int sched_nr_latency_handler(struct ctl_
 		struct file *file, void __user *buffer, size_t *length,
 		loff_t *ppos);
 #endif
+extern unsigned int sysctl_sched_rt_period;
+extern int sysctl_sched_rt_runtime;
 
 extern unsigned int sysctl_sched_compat_yield;
 
@@ -2017,8 +2017,8 @@ extern void sched_move_task(struct task_
 extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
 extern unsigned long sched_group_shares(struct task_group *tg);
 extern int sched_group_set_rt_runtime(struct task_group *tg,
-				      unsigned long rt_runtime_us);
-extern unsigned long sched_group_rt_runtime(struct task_group *tg);
+				      long rt_runtime_us);
+extern long sched_group_rt_runtime(struct task_group *tg);
 extern int sched_group_set_rt_period(struct task_group *tg,
 				     unsigned long rt_runtime_us);
 extern unsigned long sched_group_rt_period(struct task_group *tg);
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -649,13 +649,18 @@ const_debug unsigned int sysctl_sched_nr
  * period over which we measure rt task cpu usage in us.
  * default: 1s
  */
-const_debug unsigned int sysctl_sched_rt_period = 1000000;
+unsigned int sysctl_sched_rt_period = 1000000;
 
 /*
  * part of the period that we allow rt tasks to run in us.
  * default: 0.95s
  */
-const_debug unsigned int sysctl_sched_rt_runtime = 950000;
+int sysctl_sched_rt_runtime = 950000;
+
+/*
+ * single value that denotes runtime == period, ie unlimited time.
+ */
+#define RUNTIME_INF	((u64)~0ULL)
 
 /*
  * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
@@ -7751,7 +7756,7 @@ struct task_group *sched_create_group(vo
 		goto err;
 
 	tg->shares = NICE_0_LOAD;
-	tg->rt_runtime = 0; /* XXX */
+	tg->rt_runtime = 0;
 	tg->rt_period = ns_to_ktime(sysctl_sched_rt_period * NSEC_PER_USEC);
 
 	for_each_possible_cpu(i) {
@@ -7956,9 +7961,12 @@ static DEFINE_MUTEX(rt_constraints_mutex
 
 static unsigned long to_ratio(u64 period, u64 runtime)
 {
-	u64 r = runtime * (1ULL << 16);
-	do_div(r, period);
-	return r;
+	if (runtime == RUNTIME_INF)
+		return 1ULL << 16;
+
+	runtime *= (1ULL << 16);
+	do_div(runtime, period);
+	return runtime;
 }
 
 static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
@@ -7980,12 +7988,15 @@ static int __rt_schedulable(struct task_
 	return total + to_ratio(period, runtime) < global_ratio;
 }
 
-int sched_group_set_rt_runtime(struct task_group *tg,
-			       unsigned long rt_runtime_us)
+int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
 {
-	u64 rt_runtime = (u64)rt_runtime_us * NSEC_PER_USEC;
+	u64 rt_runtime;
 	int err = 0;
 
+	rt_runtime = (u64)rt_runtime_us * NSEC_PER_USEC;
+	if (rt_runtime_us == -1)
+		rt_runtime = RUNTIME_INF;
+
 	mutex_lock(&rt_constraints_mutex);
 	if (!__rt_schedulable(tg, ktime_to_ns(tg->rt_period), rt_runtime)) {
 		err = -EINVAL;
@@ -7999,10 +8010,14 @@ int sched_group_set_rt_runtime(struct ta
 	return err;
 }
 
-unsigned long sched_group_rt_runtime(struct task_group *tg)
+long sched_group_rt_runtime(struct task_group *tg)
 {
-	u64 rt_runtime_us = tg->rt_runtime;
+	u64 rt_runtime_us;
 
+	if (tg->rt_runtime == RUNTIME_INF)
+		return -1;
+
+	rt_runtime_us = tg->rt_runtime;
 	do_div(rt_runtime_us, NSEC_PER_USEC);
 	return rt_runtime_us;
 }
@@ -8108,15 +8123,49 @@ static u64 cpu_shares_read_uint(struct c
 	return (u64) tg->shares;
 }
 
-static int cpu_rt_runtime_write_uint(struct cgroup *cgrp, struct cftype *cftype,
-		u64 rt_runtime_val)
-{
-	return sched_group_set_rt_runtime(cgroup_tg(cgrp), rt_runtime_val);
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
 
-static u64 cpu_rt_runtime_read_uint(struct cgroup *cgrp, struct cftype *cft)
-{
-	return sched_group_rt_runtime(cgroup_tg(cgrp));
+static ssize_t cpu_rt_runtime_read(struct cgroup *cgrp, struct cftype *cft,
+				   struct file *file,
+				   char __user *buf, size_t nbytes,
+				   loff_t *ppos)
+{
+	char tmp[64];
+	long val = sched_group_rt_runtime(cgroup_tg(cgrp));
+	int len = sprintf(tmp, "%ld\n", val);
+
+	return simple_read_from_buffer(buf, nbytes, ppos, tmp, len);
 }
 
 static int cpu_rt_period_write_uint(struct cgroup *cgrp, struct cftype *cftype,
@@ -8138,8 +8187,8 @@ static struct cftype cpu_files[] = {
 	},
 	{
 		.name = "rt_runtime_us",
-		.read_uint = cpu_rt_runtime_read_uint,
-		.write_uint = cpu_rt_runtime_write_uint,
+		.read = cpu_rt_runtime_read,
+		.write = cpu_rt_runtime_write,
 	},
 	{
 		.name = "rt_period_us",
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -60,7 +60,7 @@ static inline int on_rt_rq(struct sched_
 static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
 {
 	if (!rt_rq->tg)
-		return 0;
+		return RUNTIME_INF;
 
 	return rt_rq->tg->rt_runtime;
 }
@@ -220,6 +220,9 @@ static struct sched_rt_entity *next_rt_d
 
 static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
 {
+	if (sysctl_sched_rt_runtime == -1)
+		return RUNTIME_INF;
+
 	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
 }
 
@@ -304,7 +307,7 @@ static int sched_rt_runtime_exceeded(str
 {
 	u64 runtime = sched_rt_runtime(rt_rq);
 
-	if (!runtime)
+	if (runtime == RUNTIME_INF)
 		goto out;
 
 	if (rt_rq->rt_throttled)
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -309,22 +309,6 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_rt_period_us",
-		.data		= &sysctl_sched_rt_period,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_rt_runtime_us",
-		.data		= &sysctl_sched_rt_runtime,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
 #if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
 	{
 		.ctl_name       = CTL_UNNUMBERED,
@@ -346,6 +330,22 @@ static struct ctl_table kern_table[] = {
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
Index: linux-2.6/kernel/user.c
===================================================================
--- linux-2.6.orig/kernel/user.c
+++ linux-2.6/kernel/user.c
@@ -175,17 +175,17 @@ static ssize_t cpu_rt_runtime_show(struc
 {
 	struct user_struct *up = container_of(kset, struct user_struct, kset);
 
-	return sprintf(buffer, "%lu\n", sched_group_rt_runtime(up->tg));
+	return sprintf(buffer, "%ld\n", sched_group_rt_runtime(up->tg));
 }
 
 static ssize_t cpu_rt_runtime_store(struct kset *kset, const char *buffer,
 				    size_t size)
 {
 	struct user_struct *up = container_of(kset, struct user_struct, kset);
-	unsigned long rt_runtime_us;
+	long rt_runtime_us;
 	int rc;
 
-	sscanf(buffer, "%lu", &rt_runtime_us);
+	sscanf(buffer, "%ld", &rt_runtime_us);
 	rc = sched_group_set_rt_runtime(up->tg, rt_runtime_us);
 
 	return (rc ?: size);
Index: linux-2.6/Documentation/ABI/testing/sysfs-kernel-uids
===================================================================
--- linux-2.6.orig/Documentation/ABI/testing/sysfs-kernel-uids
+++ linux-2.6/Documentation/ABI/testing/sysfs-kernel-uids
@@ -12,3 +12,14 @@ Description:
 		B has shares = 2048, User B will get twice the CPU
 		bandwidth user A will. For more details refer
 		Documentation/sched-design-CFS.txt
+
+What:		/sys/kernel/uids/<uid>/cpu_rt_period_us
+Date:		January 2008
+Contact:	Peter Zijlstra <a.p.zijlstra@chello.nl>
+Description:	See Documentation/sched-rt-group.txt
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
@@ -0,0 +1,69 @@
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
+If it so happens that the graphics group runs at a higher priority than
+the audio group is might be that the audio group will not get CPU time
+in time to meet its deadline. Whereas the graphics group will still easily
+make its deadline if it were delayed for the amount of time the audio
+group needs.
+
+This problem is solved using Earliest Deadline First (EDF) scheduling of the
+realtime groups.
+
+The Interface:
+
+system wide:
+
+/proc/sys/kernel/sched_rt_period_us
+/proc/sys/kernel/sched_rt_runtime_us
+
+CONFIG_FAIR_USER_SCHED
+
+/sys/kernel/uids/<uid>/cpu_rt_period_us
+/sys/kernel/uids/<uid>/cpu_rt_runtime_us
+
+or
+
+CONFIG_FAIR_CGROUP_SCHED
+
+/cgroup/<cgroup>/cpu.rt_period_us
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
+   \Sum_{i} runtime_{i} / period_{i} <= global_runtime / global_period
+
+in order to keep the configuration schedulable.



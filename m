Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbXLBTYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbXLBTYd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 14:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbXLBTY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 14:24:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46537 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbXLBTYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 14:24:25 -0500
Date: Sun, 2 Dec 2007 20:24:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler fixes for v2.6.24-rc4
Message-ID: <20071202192412.GA1598@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

this includes a single commit: a revert of a revert :-/ It turns out 
revert cfb5285660 went in by mistake (outside of sched.git). This commit 
has been tested quite extensively and it does not impact the normal case 
anyway.

Thanks!

	Ingo

------------------>
Srivatsa Vaddagiri (1):
      sched: cpu accounting controller (V2)

 include/linux/cgroup_subsys.h |    7 +
 init/Kconfig                  |    7 +
 kernel/sched.c                |  155 ++++++++++++++++++++++++++++++++++--------
 kernel/sched_fair.c           |    6 +
 kernel/sched_rt.c             |    1 
 5 files changed, 150 insertions(+), 26 deletions(-)

diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index d62fcee..9ec4318 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -30,3 +30,10 @@ SUBSYS(cpu_cgroup)
 #endif
 
 /* */
+
+#ifdef CONFIG_CGROUP_CPUACCT
+SUBSYS(cpuacct)
+#endif
+
+/* */
+
diff --git a/init/Kconfig b/init/Kconfig
index d35e44f..404bbf3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -354,6 +354,13 @@ config FAIR_CGROUP_SCHED
 
 endchoice
 
+config CGROUP_CPUACCT
+	bool "Simple CPU accounting cgroup subsystem"
+	depends on CGROUPS
+	help
+	  Provides a simple Resource Controller for monitoring the
+	  total CPU consumed by the tasks in a cgroup
+
 config SYSFS_DEPRECATED
 	bool "Create deprecated sysfs files"
 	default y
diff --git a/kernel/sched.c b/kernel/sched.c
index 98dcdf2..59ff6b1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -854,6 +854,12 @@ iter_move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		   struct rq_iterator *iterator);
 #endif
 
+#ifdef CONFIG_CGROUP_CPUACCT
+static void cpuacct_charge(struct task_struct *tsk, u64 cputime);
+#else
+static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
+#endif
+
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"
@@ -7221,38 +7227,12 @@ static u64 cpu_shares_read_uint(struct cgroup *cgrp, struct cftype *cft)
 	return (u64) tg->shares;
 }
 
-static u64 cpu_usage_read(struct cgroup *cgrp, struct cftype *cft)
-{
-	struct task_group *tg = cgroup_tg(cgrp);
-	unsigned long flags;
-	u64 res = 0;
-	int i;
-
-	for_each_possible_cpu(i) {
-		/*
-		 * Lock to prevent races with updating 64-bit counters
-		 * on 32-bit arches.
-		 */
-		spin_lock_irqsave(&cpu_rq(i)->lock, flags);
-		res += tg->se[i]->sum_exec_runtime;
-		spin_unlock_irqrestore(&cpu_rq(i)->lock, flags);
-	}
-	/* Convert from ns to ms */
-	do_div(res, NSEC_PER_MSEC);
-
-	return res;
-}
-
 static struct cftype cpu_files[] = {
 	{
 		.name = "shares",
 		.read_uint = cpu_shares_read_uint,
 		.write_uint = cpu_shares_write_uint,
 	},
-	{
-		.name = "usage",
-		.read_uint = cpu_usage_read,
-	},
 };
 
 static int cpu_cgroup_populate(struct cgroup_subsys *ss, struct cgroup *cont)
@@ -7272,3 +7252,126 @@ struct cgroup_subsys cpu_cgroup_subsys = {
 };
 
 #endif	/* CONFIG_FAIR_CGROUP_SCHED */
+
+#ifdef CONFIG_CGROUP_CPUACCT
+
+/*
+ * CPU accounting code for task groups.
+ *
+ * Based on the work by Paul Menage (menage@google.com) and Balbir Singh
+ * (balbir@in.ibm.com).
+ */
+
+/* track cpu usage of a group of tasks */
+struct cpuacct {
+	struct cgroup_subsys_state css;
+	/* cpuusage holds pointer to a u64-type object on every cpu */
+	u64 *cpuusage;
+};
+
+struct cgroup_subsys cpuacct_subsys;
+
+/* return cpu accounting group corresponding to this container */
+static inline struct cpuacct *cgroup_ca(struct cgroup *cont)
+{
+	return container_of(cgroup_subsys_state(cont, cpuacct_subsys_id),
+			    struct cpuacct, css);
+}
+
+/* return cpu accounting group to which this task belongs */
+static inline struct cpuacct *task_ca(struct task_struct *tsk)
+{
+	return container_of(task_subsys_state(tsk, cpuacct_subsys_id),
+			    struct cpuacct, css);
+}
+
+/* create a new cpu accounting group */
+static struct cgroup_subsys_state *cpuacct_create(
+	struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	struct cpuacct *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
+
+	if (!ca)
+		return ERR_PTR(-ENOMEM);
+
+	ca->cpuusage = alloc_percpu(u64);
+	if (!ca->cpuusage) {
+		kfree(ca);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return &ca->css;
+}
+
+/* destroy an existing cpu accounting group */
+static void cpuacct_destroy(struct cgroup_subsys *ss,
+			    struct cgroup *cont)
+{
+	struct cpuacct *ca = cgroup_ca(cont);
+
+	free_percpu(ca->cpuusage);
+	kfree(ca);
+}
+
+/* return total cpu usage (in nanoseconds) of a group */
+static u64 cpuusage_read(struct cgroup *cont, struct cftype *cft)
+{
+	struct cpuacct *ca = cgroup_ca(cont);
+	u64 totalcpuusage = 0;
+	int i;
+
+	for_each_possible_cpu(i) {
+		u64 *cpuusage = percpu_ptr(ca->cpuusage, i);
+
+		/*
+		 * Take rq->lock to make 64-bit addition safe on 32-bit
+		 * platforms.
+		 */
+		spin_lock_irq(&cpu_rq(i)->lock);
+		totalcpuusage += *cpuusage;
+		spin_unlock_irq(&cpu_rq(i)->lock);
+	}
+
+	return totalcpuusage;
+}
+
+static struct cftype files[] = {
+	{
+		.name = "usage",
+		.read_uint = cpuusage_read,
+	},
+};
+
+static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	return cgroup_add_files(cont, ss, files, ARRAY_SIZE(files));
+}
+
+/*
+ * charge this task's execution time to its accounting group.
+ *
+ * called with rq->lock held.
+ */
+static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
+{
+	struct cpuacct *ca;
+
+	if (!cpuacct_subsys.active)
+		return;
+
+	ca = task_ca(tsk);
+	if (ca) {
+		u64 *cpuusage = percpu_ptr(ca->cpuusage, task_cpu(tsk));
+
+		*cpuusage += cputime;
+	}
+}
+
+struct cgroup_subsys cpuacct_subsys = {
+	.name = "cpuacct",
+	.create = cpuacct_create,
+	.destroy = cpuacct_destroy,
+	.populate = cpuacct_populate,
+	.subsys_id = cpuacct_subsys_id,
+};
+#endif	/* CONFIG_CGROUP_CPUACCT */
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 2f16e15..37bb265 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -351,6 +351,12 @@ static void update_curr(struct cfs_rq *cfs_rq)
 
 	__update_curr(cfs_rq, curr, delta_exec);
 	curr->exec_start = now;
+
+	if (entity_is_task(curr)) {
+		struct task_struct *curtask = task_of(curr);
+
+		cpuacct_charge(curtask, delta_exec);
+	}
 }
 
 static inline void
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 8abd752..ee9c8b6 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -23,6 +23,7 @@ static void update_curr_rt(struct rq *rq)
 
 	curr->se.sum_exec_runtime += delta_exec;
 	curr->se.exec_start = rq->clock;
+	cpuacct_charge(curr, delta_exec);
 }
 
 static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)


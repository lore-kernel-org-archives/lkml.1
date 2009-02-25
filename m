Return-Path: <linux-kernel-owner+w=401wt.eu-S1762125AbZBYK7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762125AbZBYK7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:59:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757186AbZBYK6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:58:52 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:60625 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbZBYK6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:58:51 -0500
Date: Wed, 25 Feb 2009 16:29:20 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 2/2] Add per-cgroup CPU controller statistics
Message-ID: <20090225105920.GC4008@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090225105730.GA4008@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225105730.GA4008@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balaji Rao <balajirrao@gmail.com>

sched: Add cpu controller statistics

Add per-cgroup cpu controller statistics like system time and user time
consumed by groups of tasks.

Signed-off-by: Balaji Rao <balajirrao@gmail.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c |  106 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -263,10 +263,25 @@ struct cfs_rq;
 
 static LIST_HEAD(task_groups);
 
+#ifdef CONFIG_CGROUP_SCHED
+enum cpu_cgroup_stat_index {
+	CPU_CGROUP_STAT_UTIME, /* User time of the task group */
+	CPU_CGROUP_STAT_STIME, /* Kernel time of the task group */
+	CPU_CGROUP_STAT_GTIME, /* Guest time of the task group */
+
+	CPU_CGROUP_STAT_NSTATS,
+};
+
+struct cpu_cgroup_stat {
+	struct percpu_counter cpustat[CPU_CGROUP_STAT_NSTATS];
+};
+#endif
+
 /* task group related information */
 struct task_group {
 #ifdef CONFIG_CGROUP_SCHED
 	struct cgroup_subsys_state css;
+	struct cpu_cgroup_stat *stat;
 #endif
 
 #ifdef CONFIG_USER_SCHED
@@ -4159,6 +4174,19 @@ unsigned long long task_delta_exec(struc
 	return ns;
 }
 
+#ifdef CONFIG_CGROUP_SCHED
+static void account_task_group_time(struct task_struct *p,
+			enum cpu_cgroup_stat_index idx, int val)
+{
+	struct task_group *tg = task_group(p);
+
+	if (likely(tg->stat))
+		percpu_counter_add(&tg->stat->cpustat[idx], val);
+}
+#else
+#define account_task_group_time(x, y, z)	{ 0; }
+#endif
+
 /*
  * Account user cpu time to a process.
  * @p: the process that the cpu time gets accounted to
@@ -4182,6 +4210,10 @@ void account_user_time(struct task_struc
 		cpustat->nice = cputime64_add(cpustat->nice, tmp);
 	else
 		cpustat->user = cputime64_add(cpustat->user, tmp);
+
+	account_task_group_time(p, CPU_CGROUP_STAT_UTIME,
+			cputime_to_msecs(cputime));
+
 	/* Account for user time used */
 	acct_update_integrals(p);
 }
@@ -4206,6 +4238,9 @@ static void account_guest_time(struct ta
 	account_group_user_time(p, cputime);
 	p->gtime = cputime_add(p->gtime, cputime);
 
+	account_task_group_time(p, CPU_CGROUP_STAT_GTIME,
+			cputime_to_msecs(cputime));
+
 	/* Add guest time to cpustat. */
 	cpustat->user = cputime64_add(cpustat->user, tmp);
 	cpustat->guest = cputime64_add(cpustat->guest, tmp);
@@ -4243,6 +4278,8 @@ void account_system_time(struct task_str
 	else
 		cpustat->system = cputime64_add(cpustat->system, tmp);
 
+	account_task_group_time(p, CPU_CGROUP_STAT_STIME,
+				cputime_to_msecs(cputime));
 	/* Account for system time used */
 	acct_update_integrals(p);
 }
@@ -9290,6 +9327,7 @@ static struct cgroup_subsys_state *
 cpu_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
 	struct task_group *tg, *parent;
+	int i;
 
 	if (!cgrp->parent) {
 		/* This is early initialization for the top cgroup */
@@ -9301,6 +9339,15 @@ cpu_cgroup_create(struct cgroup_subsys *
 	if (IS_ERR(tg))
 		return ERR_PTR(-ENOMEM);
 
+	tg->stat = kmalloc(sizeof(struct cpu_cgroup_stat), GFP_KERNEL);
+	if (!tg->stat) {
+		sched_destroy_group(tg);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	for (i = 0; i < CPU_CGROUP_STAT_NSTATS; i++)
+		percpu_counter_init(&tg->stat->cpustat[i], 0);
+
 	return &tg->css;
 }
 
@@ -9308,6 +9355,13 @@ static void
 cpu_cgroup_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
 	struct task_group *tg = cgroup_tg(cgrp);
+	int i;
+
+	if (tg->stat) {
+		for (i = 0; i < CPU_CGROUP_STAT_NSTATS; i++)
+			percpu_counter_destroy(&tg->stat->cpustat[i]);
+		kfree(tg->stat);
+	}
 
 	sched_destroy_group(tg);
 }
@@ -9336,6 +9390,53 @@ cpu_cgroup_attach(struct cgroup_subsys *
 	sched_move_task(tsk);
 }
 
+static void cpu_cgroup_initialize(void)
+{
+	int i;
+	struct cpu_cgroup_stat *stat;
+
+	stat = kmalloc(sizeof(struct cpu_cgroup_stat) , GFP_KERNEL);
+	if (!stat)
+		return;
+
+	for (i = 0; i < CPU_CGROUP_STAT_NSTATS; i++)
+		percpu_counter_init(&stat->cpustat[i], 0);
+	init_task_group.stat = stat;
+}
+
+static s64 cpu_cgroup_read_stat(struct cpu_cgroup_stat *stat,
+		enum cpu_cgroup_stat_index idx)
+{
+	if (stat)
+		return percpu_counter_read(&stat->cpustat[idx]);
+	return 0;
+}
+
+static const struct cpu_cgroup_stat_desc {
+	const char *msg;
+	u64 unit;
+} cpu_cgroup_stat_desc[] = {
+	[CPU_CGROUP_STAT_UTIME] = { "utime", 1, },
+	[CPU_CGROUP_STAT_STIME] = { "stime", 1, },
+	[CPU_CGROUP_STAT_GTIME] = { "gtime", 1, },
+};
+
+static int cpu_cgroup_stats_show(struct cgroup *cgrp, struct cftype *cft,
+		struct cgroup_map_cb *cb)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+	struct cpu_cgroup_stat *stat = tg->stat;
+	int i;
+
+	for (i = 0; i < CPU_CGROUP_STAT_NSTATS; i++) {
+		s64 val;
+		val = cpu_cgroup_read_stat(stat, i);
+		val *= cpu_cgroup_stat_desc[i].unit;
+		cb->fill(cb, cpu_cgroup_stat_desc[i].msg, val);
+	}
+	return 0;
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static int cpu_shares_write_u64(struct cgroup *cgrp, struct cftype *cftype,
 				u64 shareval)
@@ -9395,6 +9496,10 @@ static struct cftype cpu_files[] = {
 		.write_u64 = cpu_rt_period_write_uint,
 	},
 #endif
+	{
+		.name = "stat",
+		.read_map = cpu_cgroup_stats_show,
+	},
 };
 
 static int cpu_cgroup_populate(struct cgroup_subsys *ss, struct cgroup *cont)
@@ -9409,6 +9514,7 @@ struct cgroup_subsys cpu_cgroup_subsys =
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
 	.populate	= cpu_cgroup_populate,
+	.initialize	= cpu_cgroup_initialize,
 	.subsys_id	= cpu_cgroup_subsys_id,
 	.early_init	= 1,
 };

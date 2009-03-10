Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZCJMmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZCJMmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 08:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZCJMlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 08:41:53 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51151 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbZCJMlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 08:41:51 -0400
Date: Tue, 10 Mar 2009 18:12:08 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [RFC PATCH] cpuacct: per-cgroup utime/stime statistics - v1
Message-ID: <20090310124208.GC3902@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Based on the comments received during my last post
(http://lkml.org/lkml/2009/2/25/129), here is a fresh attempt
to get per-cgroup utime/stime statistics as part of cpuacct controller.

This patch adds a new file cpuacct.stat which displays two stats:
utime and stime. I wasn't too sure about the usefulness of providing
per-cgroup guest and steal times and hence not including them here.

Note that I am using percpu_counter for collecting these two stats.
Since percpu_counter subsystem doesn't protect the readside, readers could
theoritically obtain incorrect values for these stats on 32bit systems.
I hope occasional wrong values is not too much of a concern for
statistics like this. If it is a problem, we have to either fix
percpu_counter or do it all by ourselves as Kamezawa attempted
for cpuacct.usage (http://lkml.org/lkml/2009/3/4/14)

Regards,
Bharata.

cpuacct: Add stime and utime statistics

Add per-cgroup cpuacct controller statistics like the system and user
time consumed by the group of tasks.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Signed-off-by: Balaji Rao <balajirrao@gmail.com>
---
 Documentation/cgroups/cpuacct.txt |    8 +++
 kernel/sched.c                    |   87 +++++++++++++++++++++++++++++++++++---
 2 files changed, 89 insertions(+), 6 deletions(-)

--- a/Documentation/cgroups/cpuacct.txt
+++ b/Documentation/cgroups/cpuacct.txt
@@ -30,3 +30,11 @@ The above steps create a new group g1 an
 process (bash) into it. CPU time consumed by this bash and its children
 can be obtained from g1/cpuacct.usage and the same is accumulated in
 /cgroups/cpuacct.usage also.
+
+cpuacct.stat file lists a few statistics which further divide the
+CPU time obtained by the cgroup into user and system times. Currently
+the following statistics are supported:
+
+utime: Time in milliseconds spent by tasks of the cgroup in user mode.
+stime: Time in milliseconds spent by tasks of the cgroup in kernel mode.
+
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1393,10 +1393,22 @@ iter_move_one_task(struct rq *this_rq, i
 		   struct rq_iterator *iterator);
 #endif
 
+/* Time spent by the tasks of the cpu accounting group executing in ... */
+enum cpuacct_stat_index {
+	CPUACCT_STAT_UTIME,	/* ... user mode */
+	CPUACCT_STAT_STIME,	/* ... kernel mode */
+
+	CPUACCT_STAT_NSTATS,
+};
+
 #ifdef CONFIG_CGROUP_CPUACCT
 static void cpuacct_charge(struct task_struct *tsk, u64 cputime);
+static void cpuacct_update_stats(struct task_struct *tsk,
+		enum cpuacct_stat_index idx, int val);
 #else
 static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
+static void cpuacct_update_stats(struct task_struct *tsk,
+		enum cpuacct_stat_index idx, int val) {}
 #endif
 
 static inline void inc_cpu_load(struct rq *rq, unsigned long load)
@@ -4182,6 +4194,8 @@ void account_user_time(struct task_struc
 		cpustat->nice = cputime64_add(cpustat->nice, tmp);
 	else
 		cpustat->user = cputime64_add(cpustat->user, tmp);
+
+	cpuacct_update_stats(p, CPUACCT_STAT_UTIME, cputime_to_msecs(cputime));
 	/* Account for user time used */
 	acct_update_integrals(p);
 }
@@ -4243,6 +4257,8 @@ void account_system_time(struct task_str
 	else
 		cpustat->system = cputime64_add(cpustat->system, tmp);
 
+	cpuacct_update_stats(p, CPUACCT_STAT_STIME, cputime_to_msecs(cputime));
+
 	/* Account for system time used */
 	acct_update_integrals(p);
 }
@@ -9438,6 +9454,7 @@ struct cpuacct {
 	struct cgroup_subsys_state css;
 	/* cpuusage holds pointer to a u64-type object on every cpu */
 	u64 *cpuusage;
+	struct percpu_counter cpustat[CPUACCT_STAT_NSTATS];
 	struct cpuacct *parent;
 };
 
@@ -9462,20 +9479,33 @@ static struct cgroup_subsys_state *cpuac
 	struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
 	struct cpuacct *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
+	int i;
 
 	if (!ca)
-		return ERR_PTR(-ENOMEM);
+		goto out1;
 
 	ca->cpuusage = alloc_percpu(u64);
-	if (!ca->cpuusage) {
-		kfree(ca);
-		return ERR_PTR(-ENOMEM);
-	}
+	if (!ca->cpuusage)
+		goto out2;
+
+	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
+		if (percpu_counter_init(&ca->cpustat[i], 0))
+			goto out3;
 
 	if (cgrp->parent)
 		ca->parent = cgroup_ca(cgrp->parent);
 
 	return &ca->css;
+
+out3:
+	i--;
+	while (i-- >= 0)
+		percpu_counter_destroy(&ca->cpustat[i]);
+	free_percpu(ca->cpuusage);
+out2:
+	kfree(ca);
+out1:
+	return ERR_PTR(-ENOMEM);
 }
 
 /* destroy an existing cpu accounting group */
@@ -9483,7 +9513,10 @@ static void
 cpuacct_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
 	struct cpuacct *ca = cgroup_ca(cgrp);
+	int i;
 
+	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
+		percpu_counter_destroy(&ca->cpustat[i]);
 	free_percpu(ca->cpuusage);
 	kfree(ca);
 }
@@ -9570,6 +9603,28 @@ static int cpuacct_percpu_seq_read(struc
 	return 0;
 }
 
+static const struct cpuacct_stat_desc {
+	const char *msg;
+	u64 unit;
+} cpuacct_stat_desc[] = {
+	[CPUACCT_STAT_UTIME] = { "utime", 1, },
+	[CPUACCT_STAT_STIME] = { "stime", 1, },
+};
+
+static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
+		struct cgroup_map_cb *cb)
+{
+	struct cpuacct *ca = cgroup_ca(cgrp);
+	int i;
+
+	for (i = 0; i < CPUACCT_STAT_NSTATS; i++) {
+		s64 val = percpu_counter_read(&ca->cpustat[i]);
+		val *= cpuacct_stat_desc[i].unit;
+		cb->fill(cb, cpuacct_stat_desc[i].msg, val);
+	}
+	return 0;
+}
+
 static struct cftype files[] = {
 	{
 		.name = "usage",
@@ -9580,7 +9635,10 @@ static struct cftype files[] = {
 		.name = "usage_percpu",
 		.read_seq_string = cpuacct_percpu_seq_read,
 	},
-
+	{
+		.name = "stat",
+		.read_map = cpuacct_stats_show,
+	},
 };
 
 static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
@@ -9610,6 +9668,23 @@ static void cpuacct_charge(struct task_s
 	}
 }
 
+/*
+ * Account the system/user time to the task's accounting group.
+ */
+static void cpuacct_update_stats(struct task_struct *tsk,
+		enum cpuacct_stat_index idx, int val)
+{
+	struct cpuacct *ca;
+
+	if (!cpuacct_subsys.active)
+		return;
+
+	ca = task_ca(tsk);
+
+	for (; ca; ca = ca->parent)
+		percpu_counter_add(&ca->cpustat[idx], val);
+}
+
 struct cgroup_subsys cpuacct_subsys = {
 	.name = "cpuacct",
 	.create = cpuacct_create,

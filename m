Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbZCWEfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbZCWEfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 00:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbZCWEfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 00:35:20 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46965 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbZCWEfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 00:35:19 -0400
Date: Mon, 23 Mar 2009 10:05:38 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH -tip] cpuacct: per-cgroup utime/stime statistics - v4
Message-ID: <20090323043538.GB3306@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here is the v4 of the cpuacct statistics patch to obtain per-cgroup
system and user times  with appropriate tags and complete changelog.
This applies against the latest -tip plus the cpuacct hierarchy fix v2
which I posted just now. Could you please include this in -tip ?

Changelog:

v4
- Remove comments in cpuacct_update_stats() which explained why rcu_read_lock()
  was needed (as per Peter Zijlstra's review comments).
- Don't say that percpu_counter_read() is broken in Documentation/cpuacct.txt
  as per KAMEZAWA Hiroyuki's review comments.

v3
- Fix a small race in the cpuacct hierarchy walk.

v2
- stime and utime now exported in clock_t units instead of msecs.
- Addressed the code review comments from Balbir and Li Zefan.
- Moved to -tip tree.

v1
- Moved the stime/utime accounting to cpuacct controller.

Earlier versions
- http://lkml.org/lkml/2009/2/25/129

Regards,
Bharata.

cpuacct: Add stime and utime statistics

Add per-cgroup cpuacct controller statistics like the system and user
time consumed by the group of tasks.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Signed-off-by: Balaji Rao <balajirrao@gmail.com>
CC: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: Li Zefan <lizf@cn.fujitsu.com>
CC: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---
 Documentation/cgroups/cpuacct.txt |   18 +++++++
 kernel/sched.c                    |   88 +++++++++++++++++++++++++++++++++++---
 2 files changed, 100 insertions(+), 6 deletions(-)

--- a/Documentation/cgroups/cpuacct.txt
+++ b/Documentation/cgroups/cpuacct.txt
@@ -30,3 +30,21 @@ The above steps create a new group g1 an
 process (bash) into it. CPU time consumed by this bash and its children
 can be obtained from g1/cpuacct.usage and the same is accumulated in
 /cgroups/cpuacct.usage also.
+
+cpuacct.stat file lists a few statistics which further divide the
+CPU time obtained by the cgroup into user and system times. Currently
+the following statistics are supported:
+
+utime: Time spent by tasks of the cgroup in user mode.
+stime: Time spent by tasks of the cgroup in kernel mode.
+
+utime and stime are in USER_HZ unit.
+
+cpuacct controller uses percpu_counter interface to collect utime and
+stime. This causes two side effects:
+
+- It is theoretically possible to see wrong values for stime and utime.
+  This is because percpu_counter_read() on 32bit systems isn't safe
+  against concurrent writes.
+- It is possible to see slightly outdated values for stime and utime
+  due to the batch processing nature of percpu_counter.
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1442,10 +1442,22 @@ iter_move_one_task(struct rq *this_rq, i
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
+		enum cpuacct_stat_index idx, cputime_t val);
 #else
 static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
+static inline void cpuacct_update_stats(struct task_struct *tsk,
+		enum cpuacct_stat_index idx, cputime_t val) {}
 #endif
 
 static inline void inc_cpu_load(struct rq *rq, unsigned long load)
@@ -4375,6 +4387,8 @@ void account_user_time(struct task_struc
 		cpustat->nice = cputime64_add(cpustat->nice, tmp);
 	else
 		cpustat->user = cputime64_add(cpustat->user, tmp);
+
+	cpuacct_update_stats(p, CPUACCT_STAT_UTIME, cputime);
 	/* Account for user time used */
 	acct_update_integrals(p);
 }
@@ -4436,6 +4450,8 @@ void account_system_time(struct task_str
 	else
 		cpustat->system = cputime64_add(cpustat->system, tmp);
 
+	cpuacct_update_stats(p, CPUACCT_STAT_STIME, cputime);
+
 	/* Account for system time used */
 	acct_update_integrals(p);
 }
@@ -9724,6 +9740,7 @@ struct cpuacct {
 	struct cgroup_subsys_state css;
 	/* cpuusage holds pointer to a u64-type object on every cpu */
 	u64 *cpuusage;
+	struct percpu_counter cpustat[CPUACCT_STAT_NSTATS];
 	struct cpuacct *parent;
 };
 
@@ -9748,20 +9765,33 @@ static struct cgroup_subsys_state *cpuac
 	struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
 	struct cpuacct *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
+	int i;
 
 	if (!ca)
-		return ERR_PTR(-ENOMEM);
+		goto out;
 
 	ca->cpuusage = alloc_percpu(u64);
-	if (!ca->cpuusage) {
-		kfree(ca);
-		return ERR_PTR(-ENOMEM);
-	}
+	if (!ca->cpuusage)
+		goto out_free_ca;
+
+	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
+		if (percpu_counter_init(&ca->cpustat[i], 0))
+			goto out_free_counters;
 
 	if (cgrp->parent)
 		ca->parent = cgroup_ca(cgrp->parent);
 
 	return &ca->css;
+
+out_free_counters:
+	i--;
+	while (i-- >= 0)
+		percpu_counter_destroy(&ca->cpustat[i]);
+	free_percpu(ca->cpuusage);
+out_free_ca:
+	kfree(ca);
+out:
+	return ERR_PTR(-ENOMEM);
 }
 
 /* destroy an existing cpu accounting group */
@@ -9769,7 +9799,10 @@ static void
 cpuacct_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
 	struct cpuacct *ca = cgroup_ca(cgrp);
+	int i;
 
+	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
+		percpu_counter_destroy(&ca->cpustat[i]);
 	free_percpu(ca->cpuusage);
 	kfree(ca);
 }
@@ -9856,6 +9889,25 @@ static int cpuacct_percpu_seq_read(struc
 	return 0;
 }
 
+static const char *cpuacct_stat_desc[] = {
+	[CPUACCT_STAT_UTIME] = "utime",
+	[CPUACCT_STAT_STIME] = "stime",
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
+		val = cputime_to_clock_t(val);
+		cb->fill(cb, cpuacct_stat_desc[i], val);
+	}
+	return 0;
+}
+
 static struct cftype files[] = {
 	{
 		.name = "usage",
@@ -9866,7 +9918,10 @@ static struct cftype files[] = {
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
@@ -9900,6 +9955,27 @@ static void cpuacct_charge(struct task_s
 	rcu_read_unlock();
 }
 
+/*
+ * Charge the system/user time to the task's accounting group.
+ */
+static void cpuacct_update_stats(struct task_struct *tsk,
+		enum cpuacct_stat_index idx, cputime_t val)
+{
+	struct cpuacct *ca;
+
+	if (unlikely(!cpuacct_subsys.active))
+		return;
+
+	rcu_read_lock();
+	ca = task_ca(tsk);
+
+	do {
+		percpu_counter_add(&ca->cpustat[idx], val);
+		ca = ca->parent;
+	} while (ca);
+	rcu_read_unlock();
+}
+
 struct cgroup_subsys cpuacct_subsys = {
 	.name = "cpuacct",
 	.create = cpuacct_create,

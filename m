Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbZCaEc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbZCaEc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 00:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbZCaEcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 00:32:18 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38505 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbZCaEcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 00:32:17 -0400
Date: Tue, 31 Mar 2009 10:02:22 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH -tip] cpuacct: per-cgroup utime/stime statistics - v7
Message-ID: <20090331043222.GA4093@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the next version of the cpuacct statistics patch to obtain
per-cgroup system and user times. This version changes the names from
stime to system and utime to user.

Ingo, Could you please take this in now ?

Regards,
Bharata.

cpuacct: Add system and user time statistics

Add per-cgroup cpuacct controller statistics like the system and user
time consumed by the group of tasks.

Changelog:

v7
- Changed the name of the statistic from utime to user and from stime to
  system so that in future we could easily add other statistics like irq,
  softirq, steal times etc easily.

v6
- Fixed a bug in the error path of cpuacct_create() (pointed by Li Zefan).

v5
- In cpuacct_stats_show(), use cputime64_to_clock_t() since we are
  operating on a 64bit variable here.

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

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Signed-off-by: Balaji Rao <balajirrao@gmail.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---
 Documentation/cgroups/cpuacct.txt |   18 +++++++
 kernel/sched.c                    |   87 +++++++++++++++++++++++++++++++++++---
 2 files changed, 99 insertions(+), 6 deletions(-)

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
+user: Time spent by tasks of the cgroup in user mode.
+system: Time spent by tasks of the cgroup in kernel mode.
+
+user and system are in USER_HZ unit.
+
+cpuacct controller uses percpu_counter interface to collect user and
+system times. This has two side effects:
+
+- It is theoretically possible to see wrong values for user and system times.
+  This is because percpu_counter_read() on 32bit systems isn't safe
+  against concurrent writes.
+- It is possible to see slightly outdated values for user and system times
+  due to the batch processing nature of percpu_counter.
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1439,10 +1439,22 @@ iter_move_one_task(struct rq *this_rq, i
 		   struct rq_iterator *iterator);
 #endif
 
+/* Time spent by the tasks of the cpu accounting group executing in ... */
+enum cpuacct_stat_index {
+	CPUACCT_STAT_USER,	/* ... user mode */
+	CPUACCT_STAT_SYSTEM,	/* ... kernel mode */
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
@@ -4637,6 +4649,8 @@ void account_user_time(struct task_struc
 		cpustat->nice = cputime64_add(cpustat->nice, tmp);
 	else
 		cpustat->user = cputime64_add(cpustat->user, tmp);
+
+	cpuacct_update_stats(p, CPUACCT_STAT_USER, cputime);
 	/* Account for user time used */
 	acct_update_integrals(p);
 }
@@ -4698,6 +4712,8 @@ void account_system_time(struct task_str
 	else
 		cpustat->system = cputime64_add(cpustat->system, tmp);
 
+	cpuacct_update_stats(p, CPUACCT_STAT_SYSTEM, cputime);
+
 	/* Account for system time used */
 	acct_update_integrals(p);
 }
@@ -9986,6 +10002,7 @@ struct cpuacct {
 	struct cgroup_subsys_state css;
 	/* cpuusage holds pointer to a u64-type object on every cpu */
 	u64 *cpuusage;
+	struct percpu_counter cpustat[CPUACCT_STAT_NSTATS];
 	struct cpuacct *parent;
 };
 
@@ -10010,20 +10027,32 @@ static struct cgroup_subsys_state *cpuac
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
+	while (--i >= 0)
+		percpu_counter_destroy(&ca->cpustat[i]);
+	free_percpu(ca->cpuusage);
+out_free_ca:
+	kfree(ca);
+out:
+	return ERR_PTR(-ENOMEM);
 }
 
 /* destroy an existing cpu accounting group */
@@ -10031,7 +10060,10 @@ static void
 cpuacct_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
 	struct cpuacct *ca = cgroup_ca(cgrp);
+	int i;
 
+	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
+		percpu_counter_destroy(&ca->cpustat[i]);
 	free_percpu(ca->cpuusage);
 	kfree(ca);
 }
@@ -10118,6 +10150,25 @@ static int cpuacct_percpu_seq_read(struc
 	return 0;
 }
 
+static const char *cpuacct_stat_desc[] = {
+	[CPUACCT_STAT_USER] = "user",
+	[CPUACCT_STAT_SYSTEM] = "system",
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
+		val = cputime64_to_clock_t(val);
+		cb->fill(cb, cpuacct_stat_desc[i], val);
+	}
+	return 0;
+}
+
 static struct cftype files[] = {
 	{
 		.name = "usage",
@@ -10128,7 +10179,10 @@ static struct cftype files[] = {
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
@@ -10162,6 +10216,27 @@ static void cpuacct_charge(struct task_s
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

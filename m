Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbYF0MDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbYF0MDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbYF0L6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:11 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:48323 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754869AbYF0L5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:55 -0400
X-SourceIP: 62.163.52.83
Message-Id: <20080627115212.251661522@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:35 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 26/30] sched: update shares on wakeup
Content-Disposition: inline; filename=sched-throttle-update_shares.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We found that the affine wakeup code needs rather accurate load figures
to be effective. The trouble is that updating the load figures is fairly
expensive with group scheduling. Therefore ratelimit the updating.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/sched.h   |    3 +++
 kernel/sched.c          |   30 +++++++++++++++++++++++++++++-
 kernel/sched_features.h |    3 ++-
 kernel/sysctl.c         |    8 ++++++++
 4 files changed, 42 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -778,6 +778,12 @@ late_initcall(sched_init_debug);
 const_debug unsigned int sysctl_sched_nr_migrate = 32;
 
 /*
+ * ratelimit for updating the group shares.
+ * default: 0.5ms
+ */
+const_debug unsigned int sysctl_sched_shares_ratelimit = 500000;
+
+/*
  * period over which we measure -rt task cpu usage in us.
  * default: 1s
  */
@@ -1590,7 +1596,13 @@ tg_nop(struct task_group *tg, int cpu, s
 
 static void update_shares(struct sched_domain *sd)
 {
-	walk_tg_tree(tg_nop, tg_shares_up, 0, sd);
+	u64 now = cpu_clock(raw_smp_processor_id());
+	s64 elapsed = now - sd->last_update;
+
+	if (elapsed >= (s64)(u64)sysctl_sched_shares_ratelimit) {
+		sd->last_update = now;
+		walk_tg_tree(tg_nop, tg_shares_up, 0, sd);
+	}
 }
 
 static void update_shares_locked(struct rq *rq, struct sched_domain *sd)
@@ -2199,6 +2211,22 @@ static int try_to_wake_up(struct task_st
 	if (!sched_feat(SYNC_WAKEUPS))
 		sync = 0;
 
+#ifdef CONFIG_SMP
+	if (sched_feat(LB_WAKEUP_UPDATE)) {
+		struct sched_domain *sd;
+
+		this_cpu = raw_smp_processor_id();
+		cpu = task_cpu(p);
+
+		for_each_domain(this_cpu, sd) {
+			if (cpu_isset(cpu, sd->span)) {
+				update_shares(sd);
+				break;
+			}
+		}
+	}
+#endif
+
 	smp_wmb();
 	rq = task_rq_lock(p, &flags);
 	old_state = p->state;
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -8,4 +8,5 @@ SCHED_FEAT(SYNC_WAKEUPS, 1)
 SCHED_FEAT(HRTICK, 1)
 SCHED_FEAT(DOUBLE_TICK, 0)
 SCHED_FEAT(ASYM_GRAN, 1)
-SCHED_FEAT(LB_BIAS, 0)
\ No newline at end of file
+SCHED_FEAT(LB_BIAS, 0)
+SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -783,6 +783,8 @@ struct sched_domain {
 	unsigned int balance_interval;	/* initialise to 1. units in ms. */
 	unsigned int nr_balance_failed; /* initialise to 0 */
 
+	u64 last_update;
+
 #ifdef CONFIG_SCHEDSTATS
 	/* load_balance() stats */
 	unsigned int lb_count[CPU_MAX_IDLE_TYPES];
@@ -1605,6 +1607,7 @@ extern unsigned int sysctl_sched_child_r
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
+extern unsigned int sysctl_sched_shares_ratelimit;
 
 int sched_nr_latency_handler(struct ctl_table *table, int write,
 		struct file *file, void __user *buffer, size_t *length,
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -269,6 +269,14 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_shares_ratelimit",
+		.data		= &sysctl_sched_shares_ratelimit,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_child_runs_first",
 		.data		= &sysctl_sched_child_runs_first,
 		.maxlen		= sizeof(unsigned int),

-- 


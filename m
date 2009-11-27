Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbZK0Opz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbZK0Opz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 09:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbZK0Opx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 09:45:53 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:49986 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbZK0Opv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 09:45:51 -0500
From: ehrhardt@linux.vnet.ibm.com
To: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: ehrhardt@linux.vnet.ibm.com, Holger.Wolf@de.ibm.com, epasch@de.ibm.com,
       schwidefsky@de.ibm.com
Subject: [PATCH 1/3] sched: fix missing sched tunable recalculation on cpu add/remove
Date: Fri, 27 Nov 2009 15:45:53 +0100
Message-Id: <1259333155-14475-2-git-send-email-ehrhardt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1259333155-14475-1-git-send-email-ehrhardt@linux.vnet.ibm.com>
References: <1259333155-14475-1-git-send-email-ehrhardt@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

Based on Peter Zijlstras patch suggestion this enables recalculation of the
scheduler tunables in response of a change in the number of cpus.
It also adds a max of eight cpus that are considered in that scaling.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
---

[diffstat]
 sched.c      |   29 ++++++++++++++++-------------
 sched_fair.c |   16 ++++++++++++++++
 2 files changed, 32 insertions(+), 13 deletions(-)

[diff]
Index: linux-2.6-git-schedrecalc/kernel/sched.c
===================================================================
--- linux-2.6-git-schedrecalc.orig/kernel/sched.c
+++ linux-2.6-git-schedrecalc/kernel/sched.c
@@ -814,6 +814,7 @@ const_debug unsigned int sysctl_sched_nr
  * default: 0.25ms
  */
 unsigned int sysctl_sched_shares_ratelimit = 250000;
+unsigned int normalized_sysctl_sched_shares_ratelimit = 250000;
 
 /*
  * Inject some fuzzyness into changing the per-cpu group shares
@@ -1810,6 +1811,7 @@ static void cfs_rq_set_shares(struct cfs
 #endif
 
 static void calc_load_account_active(struct rq *this_rq);
+static void update_sysctl(void);
 
 #include "sched_stats.h"
 #include "sched_idletask.c"
@@ -7003,22 +7005,23 @@ cpumask_var_t nohz_cpu_mask;
  *
  * This idea comes from the SD scheduler of Con Kolivas:
  */
-static inline void sched_init_granularity(void)
+static void update_sysctl(void)
 {
-	unsigned int factor = 1 + ilog2(num_online_cpus());
-	const unsigned long limit = 200000000;
-
-	sysctl_sched_min_granularity *= factor;
-	if (sysctl_sched_min_granularity > limit)
-		sysctl_sched_min_granularity = limit;
-
-	sysctl_sched_latency *= factor;
-	if (sysctl_sched_latency > limit)
-		sysctl_sched_latency = limit;
+	unsigned int cpus = max(num_online_cpus(), 8U);
+	unsigned int factor = 1 + ilog2(cpus);
 
-	sysctl_sched_wakeup_granularity *= factor;
+#define SET_SYSCTL(name) \
+	sysctl_##name = (factor) * normalized_sysctl_##name
+	SET_SYSCTL(sched_min_granularity);
+	SET_SYSCTL(sched_latency);
+	SET_SYSCTL(sched_wakeup_granularity);
+	SET_SYSCTL(sched_shares_ratelimit);
+#undef SET_SYSCTL
+}
 
-	sysctl_sched_shares_ratelimit *= factor;
+static inline void sched_init_granularity(void)
+{
+	update_sysctl();
 }
 
 #ifdef CONFIG_SMP
Index: linux-2.6-git-schedrecalc/kernel/sched_fair.c
===================================================================
--- linux-2.6-git-schedrecalc.orig/kernel/sched_fair.c
+++ linux-2.6-git-schedrecalc/kernel/sched_fair.c
@@ -35,12 +35,14 @@
  *  run vmstat and monitor the context-switches (cs) field)
  */
 unsigned int sysctl_sched_latency = 5000000ULL;
+unsigned int normalized_sysctl_sched_latency = 5000000ULL;
 
 /*
  * Minimal preemption granularity for CPU-bound tasks:
  * (default: 1 msec * (1 + ilog(ncpus)), units: nanoseconds)
  */
 unsigned int sysctl_sched_min_granularity = 1000000ULL;
+unsigned int normalized_sysctl_sched_min_granularity = 1000000ULL;
 
 /*
  * is kept at sysctl_sched_latency / sysctl_sched_min_granularity
@@ -70,6 +72,7 @@ unsigned int __read_mostly sysctl_sched_
  * have immediate wakeup/sleep latencies.
  */
 unsigned int sysctl_sched_wakeup_granularity = 1000000UL;
+unsigned int normalized_sysctl_sched_wakeup_granularity = 1000000UL;
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
 
@@ -1850,6 +1853,17 @@ move_one_task_fair(struct rq *this_rq, i
 
 	return 0;
 }
+
+static void rq_online_fair(struct rq *rq)
+{
+	update_sysctl();
+}
+
+static void rq_offline_fair(struct rq *rq)
+{
+	update_sysctl();
+}
+
 #endif /* CONFIG_SMP */
 
 /*
@@ -1997,6 +2011,8 @@ static const struct sched_class fair_sch
 
 	.load_balance		= load_balance_fair,
 	.move_one_task		= move_one_task_fair,
+	.rq_online		= rq_online_fair,
+	.rq_offline		= rq_offline_fair,
 #endif
 
 	.set_curr_task          = set_curr_task_fair,

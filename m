Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZLIJ7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZLIJ7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbZLIJ5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:57:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:45771 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556AbZLIJ5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:57:44 -0500
Date: Wed, 9 Dec 2009 09:56:02 GMT
From: tip-bot for Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, ehrhardt@linux.vnet.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, ehrhardt@linux.vnet.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1259579808-11357-2-git-send-email-ehrhardt@linux.vnet.ibm.com>
References: <1259579808-11357-2-git-send-email-ehrhardt@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix missing sched tunable recalculation on cpu add/remove
Message-ID: <tip-0bcdcf28c979869f44e05121b96ff2cfb05bd8e6@git.kernel.org>
Git-Commit-ID: 0bcdcf28c979869f44e05121b96ff2cfb05bd8e6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0bcdcf28c979869f44e05121b96ff2cfb05bd8e6
Gitweb:     http://git.kernel.org/tip/0bcdcf28c979869f44e05121b96ff2cfb05bd8e6
Author:     Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
AuthorDate: Mon, 30 Nov 2009 12:16:46 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 10:03:58 +0100

sched: Fix missing sched tunable recalculation on cpu add/remove

Based on Peter Zijlstras patch suggestion this enables recalculation of
the scheduler tunables in response of a change in the number of cpus. It
also adds a max of eight cpus that are considered in that scaling.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1259579808-11357-2-git-send-email-ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |   29 ++++++++++++++++-------------
 kernel/sched_fair.c |   16 ++++++++++++++++
 2 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3878f50..b54ecf8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -814,6 +814,7 @@ const_debug unsigned int sysctl_sched_nr_migrate = 32;
  * default: 0.25ms
  */
 unsigned int sysctl_sched_shares_ratelimit = 250000;
+unsigned int normalized_sysctl_sched_shares_ratelimit = 250000;
 
 /*
  * Inject some fuzzyness into changing the per-cpu group shares
@@ -1814,6 +1815,7 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 #endif
 
 static void calc_load_account_active(struct rq *this_rq);
+static void update_sysctl(void);
 
 static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
@@ -7028,22 +7030,23 @@ cpumask_var_t nohz_cpu_mask;
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
+	unsigned int cpus = min(num_online_cpus(), 8U);
+	unsigned int factor = 1 + ilog2(cpus);
 
-	sysctl_sched_wakeup_granularity *= factor;
+#define SET_SYSCTL(name) \
+	(sysctl_##name = (factor) * normalized_sysctl_##name)
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
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c163a28..71b3458 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
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
@@ -70,6 +72,7 @@ unsigned int __read_mostly sysctl_sched_compat_yield;
  * have immediate wakeup/sleep latencies.
  */
 unsigned int sysctl_sched_wakeup_granularity = 1000000UL;
+unsigned int normalized_sysctl_sched_wakeup_granularity = 1000000UL;
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
 
@@ -1890,6 +1893,17 @@ move_one_task_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 
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
@@ -2035,6 +2049,8 @@ static const struct sched_class fair_sched_class = {
 
 	.load_balance		= load_balance_fair,
 	.move_one_task		= move_one_task_fair,
+	.rq_online		= rq_online_fair,
+	.rq_offline		= rq_offline_fair,
 #endif
 
 	.set_curr_task          = set_curr_task_fair,

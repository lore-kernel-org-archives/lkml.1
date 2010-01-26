Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642Ab0A0ABa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab0A0ABa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953Ab0A0ABW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:01:22 -0500
Received: from kroah.org ([198.145.64.141]:35172 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab0AZXnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:22 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:24 2010
Message-Id: <20100126233924.675869677@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [29/98] sched: Fix missing sched tunable recalculation on cpu add/remove
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

commit 0bcdcf28c979869f44e05121b96ff2cfb05bd8e6 upstream.

Based on Peter Zijlstras patch suggestion this enables recalculation of
the scheduler tunables in response of a change in the number of cpus. It
also adds a max of eight cpus that are considered in that scaling.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1259579808-11357-2-git-send-email-ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c      |   29 ++++++++++++++++-------------
 kernel/sched_fair.c |   16 ++++++++++++++++
 2 files changed, 32 insertions(+), 13 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -816,6 +816,7 @@ const_debug unsigned int sysctl_sched_nr
  * default: 0.25ms
  */
 unsigned int sysctl_sched_shares_ratelimit = 250000;
+unsigned int normalized_sysctl_sched_shares_ratelimit = 250000;
 
 /*
  * Inject some fuzzyness into changing the per-cpu group shares
@@ -1812,6 +1813,7 @@ static void cfs_rq_set_shares(struct cfs
 #endif
 
 static void calc_load_account_active(struct rq *this_rq);
+static void update_sysctl(void);
 
 #include "sched_stats.h"
 #include "sched_idletask.c"
@@ -7018,22 +7020,23 @@ cpumask_var_t nohz_cpu_mask;
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
@@ -70,6 +72,7 @@ unsigned int __read_mostly sysctl_sched_
  * have immediate wakeup/sleep latencies.
  */
 unsigned int sysctl_sched_wakeup_granularity = 1000000UL;
+unsigned int normalized_sysctl_sched_wakeup_granularity = 1000000UL;
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
 
@@ -1880,6 +1883,17 @@ move_one_task_fair(struct rq *this_rq, i
 
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
@@ -2027,6 +2041,8 @@ static const struct sched_class fair_sch
 
 	.load_balance		= load_balance_fair,
 	.move_one_task		= move_one_task_fair,
+	.rq_online		= rq_online_fair,
+	.rq_offline		= rq_offline_fair,
 #endif
 
 	.set_curr_task          = set_curr_task_fair,



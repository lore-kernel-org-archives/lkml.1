Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbZCaKvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbZCaKvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 06:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755440AbZCaKuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 06:50:40 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:49196 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbZCaKuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 06:50:39 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH v4 4/5] sched: Arbitrate the nomination of preferred_wakeup_cpu
To: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Balbir Singh" <balbir@in.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Date: Tue, 31 Mar 2009 16:20:32 +0530
Message-ID: <20090331105032.16414.5468.stgit@sofia.in.ibm.com>
In-Reply-To: <20090331104829.16414.11385.stgit@sofia.in.ibm.com>
References: <20090331104829.16414.11385.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently for sched_mc/smt_power_savings = 2, we consolidate tasks
by having a preferred_wakeup_cpu which will be used for all the
further wake ups.

This preferred_wakeup_cpu is currently nominated by find_busiest_group()
when we perform load-balancing at sched_domains which has
SD_POWERSAVINGS_BALANCE flag set.

However, on systems which are multi-threaded and multi-core, we can
have multiple sched_domains in the same hierarchy with
SD_POWERSAVINGS_BALANCE flag set.

Currently we don't have any arbitration mechanism as to while performing
load balancing at which sched_domain in the hierarchy should
find_busiest_group(sd) nominate the preferred_wakeup_cpu.
Hence can overwrite valid nominations made previously thereby
causing the preferred_wakup_cpu to ping-pong,
thereby preventing us from effectively consolidating tasks.

Fix this by means of an arbitration algorithm, where in we nominate the
preferred_wakeup_cpu while performing load balancing at a particular
sched_domain if that sched_domain:
- is the topmost power aware sched_domain.
	OR
- contains the previously nominated preferred wake up cpu in it's span.

This will help to further fine tune the wake-up biasing logic by
identifying a partially busy core within a CPU package instead of
potentially waking up a completely idle core.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 36d116b..193bb67 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -549,6 +549,14 @@ struct root_domain {
 	 * This is triggered at POWERSAVINGS_BALANCE_WAKEUP(2).
 	 */
 	unsigned int preferred_wakeup_cpu;
+
+	/*
+	 * top_powersavings_sd_lvl records the level of the highest
+	 * sched_domain that has the SD_POWERSAVINGS_BALANCE flag set.
+	 *
+	 * Used to arbitrate nomination of the preferred_wakeup_cpu.
+	 */
+	enum sched_domain_level top_powersavings_sd_lvl;
 #endif
 };
 
@@ -3439,9 +3447,11 @@ static inline void update_sd_power_savings_stats(struct sched_group *group,
  * Returns 1 if there is potential to perform power-savings balance.
  * Else returns 0.
  */
-static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
-					int this_cpu, unsigned long *imbalance)
+static inline int check_power_save_busiest_group(struct sched_domain *sd,
+		struct sd_lb_stats *sds, int this_cpu, unsigned long *imbalance)
 {
+	struct root_domain *my_rd = cpu_rq(this_cpu)->rd;
+
 	if (!sds->power_savings_balance)
 		return 0;
 
@@ -3452,8 +3462,25 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
 	*imbalance = sds->min_load_per_task;
 	sds->busiest = sds->group_min;
 
-	if (active_power_savings_level >= POWERSAVINGS_BALANCE_WAKEUP) {
-		cpu_rq(this_cpu)->rd->preferred_wakeup_cpu =
+	/*
+	 * To avoid overwriting of preferred_wakeup_cpu nominations
+	 * while performing load-balancing at various sched_domain
+	 * levels, we define an arbitration mechanism wherein
+	 * we nominates a preferred_wakeup_cpu while load balancing
+	 * at a particular sched_domain sd if:
+	 *
+	 * - sd is the highest sched_domain in the hierarchy having the
+	 *   SD_POWERSAVINGS_BALANCE flag set.
+	 *
+	 *   OR
+	 *
+	 * - sd contains the previously nominated preferred_wakeup_cpu
+	 *   in it's span.
+	 */
+	if (sd->level == my_rd->top_powersavings_sd_lvl ||
+		cpumask_test_cpu(my_rd->preferred_wakeup_cpu,
+				sched_domain_span(sd))) {
+		my_rd->preferred_wakeup_cpu =
 			group_first_cpu(sds->group_leader);
 	}
 
@@ -3473,8 +3500,8 @@ static inline void update_sd_power_savings_stats(struct sched_group *group,
 	return;
 }
 
-static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
-					int this_cpu, unsigned long *imbalance)
+static inline int check_power_save_busiest_group(struct sched_domain *sd,
+		struct sd_lb_stats *sds, int this_cpu, unsigned long *imbalance)
 {
 	return 0;
 }
@@ -3838,7 +3865,7 @@ out_balanced:
 	 * There is no obvious imbalance. But check if we can do some balancing
 	 * to save power.
 	 */
-	if (check_power_save_busiest_group(&sds, this_cpu, imbalance))
+	if (check_power_save_busiest_group(sd, &sds, this_cpu, imbalance))
 		return sds.busiest;
 ret:
 	*imbalance = 0;
@@ -8059,6 +8086,8 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 	struct root_domain *rd;
 	cpumask_var_t nodemask, this_sibling_map, this_core_map, send_covered,
 		tmpmask;
+	struct sched_domain *sd;
+
 #ifdef CONFIG_NUMA
 	cpumask_var_t domainspan, covered, notcovered;
 	struct sched_group **sched_group_nodes = NULL;
@@ -8334,6 +8363,19 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 
 	err = 0;
 
+	rd->preferred_wakeup_cpu = UINT_MAX;
+	rd->top_powersavings_sd_lvl = SD_LV_NONE;
+
+	if (active_power_savings_level < POWERSAVINGS_BALANCE_WAKEUP)
+		goto free_tmpmask;
+
+	/* Record the level of the highest power-aware sched_domain */
+	for_each_domain(first_cpu(*cpu_map), sd) {
+		if (!(sd->flags & SD_POWERSAVINGS_BALANCE))
+			continue;
+		rd->top_powersavings_sd_lvl = sd->level;
+	}
+
 free_tmpmask:
 	free_cpumask_var(tmpmask);
 free_send_covered:


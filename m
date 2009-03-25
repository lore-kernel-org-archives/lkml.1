Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbZCYJRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbZCYJRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758778AbZCYJOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:14:54 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:60111 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758762AbZCYJOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:14:52 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [RFC PATCH 10/11] sched: Refactor the power savings balance code.
To: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Balbir Singh" <balbir@in.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Date: Wed, 25 Mar 2009 14:44:22 +0530
Message-ID: <20090325091422.13992.73616.stgit@sofia.in.ibm.com>
In-Reply-To: <20090325091239.13992.96090.stgit@sofia.in.ibm.com>
References: <20090325091239.13992.96090.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create seperate helper functions to initialize the power-savings-balance
related variables, to update them and to check if we have a scope for
performing power-savings balance.

Add no-op inline functions for the !(CONFIG_SCHED_MC || CONFIG_SCHED_SMT)
case.

This will eliminate all the #ifdef jungle in find_busiest_group() and the
other helper functions.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c |  236 ++++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 153 insertions(+), 83 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index cb2c97b..6404ddf 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3166,6 +3166,151 @@ static inline int get_sd_load_idx(struct sched_domain *sd,
 }
 
 
+#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+/**
+ * init_sd_power_savings_stats - Initialize power savings statistics for
+ * the given sched_domain, during load balancing.
+ *
+ * @sd: Sched domain whose power-savings statistics are to be initialized.
+ * @sds: Variable containing the statistics for sd.
+ * @idle: Idle status of the CPU at which we're performing load-balancing.
+ */
+static inline void init_sd_power_savings_stats(struct sched_domain *sd,
+	struct sd_lb_stats *sds, enum cpu_idle_type idle)
+{
+	/*
+	 * Busy processors will not participate in power savings
+	 * balance.
+	 */
+	if (idle == CPU_NOT_IDLE || !(sd->flags & SD_POWERSAVINGS_BALANCE))
+		sds->power_savings_balance = 0;
+	else {
+		sds->power_savings_balance = 1;
+		sds->min_nr_running = ULONG_MAX;
+		sds->leader_nr_running = 0;
+	}
+}
+
+/**
+ * update_sd_power_savings_stats - Update the power saving stats for a
+ * sched_domain while performing load balancing.
+ *
+ * @group: sched_group belonging to the sched_domain under consideration.
+ * @sds: Variable containing the statistics of the sched_domain
+ * @local_group: Does group contain the CPU for which we're performing
+ * 		load balancing ?
+ * @sgs: Variable containing the statistics of the group.
+ */
+static inline void update_sd_power_savings_stats(struct sched_group *group,
+	struct sd_lb_stats *sds, int local_group, struct sg_lb_stats *sgs)
+{
+
+	if (!sds->power_savings_balance)
+		return;
+
+	/*
+	 * If the local group is idle or completely loaded
+	 * no need to do power savings balance at this domain
+	 */
+	if (local_group && (sds->this_nr_running >= sgs->group_capacity ||
+				!sds->this_nr_running))
+		sds->power_savings_balance = 0;
+
+	/*
+	 * If a group is already running at full capacity or idle,
+	 * don't include that group in power savings calculations
+	 */
+	if (!sds->power_savings_balance ||
+		sgs->sum_nr_running >= sgs->group_capacity ||
+		!sgs->sum_nr_running)
+		return;
+
+	/*
+	 * Calculate the group which has the least non-idle load.
+	 * This is the group from where we need to pick up the load
+	 * for saving power
+	 */
+	if ((sgs->sum_nr_running < sds->min_nr_running) ||
+	    (sgs->sum_nr_running == sds->min_nr_running &&
+	     group_first_cpu(group) > group_first_cpu(sds->group_min))) {
+		sds->group_min = group;
+		sds->min_nr_running = sgs->sum_nr_running;
+		sds->min_load_per_task = sgs->sum_weighted_load /
+						sgs->sum_nr_running;
+	}
+
+	/*
+	 * Calculate the group which is almost near its
+	 * capacity but still has some space to pick up some load
+	 * from other group and save more power
+	 */
+	if (sgs->sum_nr_running > sgs->group_capacity - 1)
+		return;
+
+	if (sgs->sum_nr_running > sds->leader_nr_running ||
+	    (sgs->sum_nr_running == sds->leader_nr_running &&
+	     group_first_cpu(group) < group_first_cpu(sds->group_leader))) {
+		sds->group_leader = group;
+		sds->leader_nr_running = sgs->sum_nr_running;
+	}
+}
+
+/**
+ * check_power_save_busiest_group - Check if we have potential to perform
+ *	some power-savings balance. If yes, set the busiest group to be
+ *	the least loaded group in the sched_domain, so that it's CPUs can
+ *	be put to idle.
+ *
+ * @sds: Variable containing the statistics of the sched_domain
+ *	under consideration.
+ * @this_cpu: Cpu at which we're currently performing load-balancing.
+ * @imbalance: Variable to store the imbalance.
+ *
+ * Returns 1 if there is potential to perform power-savings balance.
+ * Else returns 0.
+ */
+static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
+					int this_cpu, unsigned long *imbalance)
+{
+	if (!sds->power_savings_balance)
+		return 0;
+
+	if (sds->this != sds->group_leader ||
+			sds->group_leader == sds->group_min)
+		return 0;
+
+	*imbalance = sds->min_load_per_task;
+	sds->busiest = sds->group_min;
+
+	if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP) {
+		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
+			group_first_cpu(sds->group_leader);
+	}
+
+	return 1;
+
+}
+#else /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
+static inline void init_sd_power_savings_stats(struct sched_domain *sd,
+	struct sd_lb_stats *sds, enum cpu_idle_type idle)
+{
+	return;
+}
+
+static inline void update_sd_power_savings_stats(struct sched_group *group,
+	struct sd_lb_stats *sds, int local_group, struct sg_lb_stats *sgs)
+{
+	return;
+}
+
+static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
+					int this_cpu, unsigned long *imbalance)
+{
+	return 0;
+}
+#endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
+
+
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
  * @group: sched_group whose statistics are to be updated.
@@ -3281,19 +3426,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 	struct sg_lb_stats sgs;
 	int load_idx;
 
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	/*
-	 * Busy processors will not participate in power savings
-	 * balance.
-	 */
-	if (idle == CPU_NOT_IDLE || !(sd->flags & SD_POWERSAVINGS_BALANCE))
-		sds->power_savings_balance = 0;
-	else {
-		sds->power_savings_balance = 1;
-		sds->min_nr_running = ULONG_MAX;
-		sds->leader_nr_running = 0;
-	}
-#endif
+	init_sd_power_savings_stats(sd, sds, idle);
 	load_idx = get_sd_load_idx(sd, idle);
 
 	do {
@@ -3326,61 +3459,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 			sds->group_imb = sgs.group_imb;
 		}
 
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-
-		if (!sds->power_savings_balance)
-			goto group_next;
-
-		/*
-		 * If the local group is idle or completely loaded
-		 * no need to do power savings balance at this domain
-		 */
-		if (local_group &&
-			(sds->this_nr_running >= sgs.group_capacity ||
-			!sds->this_nr_running))
-			sds->power_savings_balance = 0;
-
-		/*
-		 * If a group is already running at full capacity or idle,
-		 * don't include that group in power savings calculations
-		 */
-		if (!sds->power_savings_balance ||
-			sgs.sum_nr_running >= sgs.group_capacity ||
-			!sgs.sum_nr_running)
-			goto group_next;
-
-		/*
-		 * Calculate the group which has the least non-idle load.
-		 * This is the group from where we need to pick up the load
-		 * for saving power
-		 */
-		if ((sgs.sum_nr_running < sds->min_nr_running) ||
-		    (sgs.sum_nr_running == sds->min_nr_running &&
-		     group_first_cpu(group) >
-			group_first_cpu(sds->group_min))) {
-			sds->group_min = group;
-			sds->min_nr_running = sgs.sum_nr_running;
-			sds->min_load_per_task = sgs.sum_weighted_load /
-						sgs.sum_nr_running;
-		}
-
-		/*
-		 * Calculate the group which is almost near its
-		 * capacity but still has some space to pick up some load
-		 * from other group and save more power
-		 */
-		if (sgs.sum_nr_running > sgs.group_capacity - 1)
-			goto group_next;
-
-		if (sgs.sum_nr_running > sds->leader_nr_running ||
-		    (sgs.sum_nr_running == sds->leader_nr_running &&
-		     group_first_cpu(group) <
-			group_first_cpu(sds->group_leader))) {
-			sds->group_leader = group;
-			sds->leader_nr_running = sgs.sum_nr_running;
-		}
-group_next:
-#endif
+		update_sd_power_savings_stats(group, sds, local_group, &sgs);
 		group = group->next;
 	} while (group != sd->groups);
 
@@ -3551,21 +3630,12 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	return sds.busiest;
 
 out_balanced:
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	if (!sds.power_savings_balance)
-		goto ret;
-
-	if (sds.this != sds.group_leader || sds.group_leader == sds.group_min)
-		goto ret;
-
-	*imbalance = sds.min_load_per_task;
-	if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP) {
-		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
-			group_first_cpu(sds.group_leader);
-	}
-	return sds.group_min;
-
-#endif
+	/*
+	 * There is no obvious imbalance. But check if we can do some balancing
+	 * to save power.
+	 */
+	if (check_power_save_busiest_group(&sds, this_cpu, imbalance))
+		return sds.busiest;
 ret:
 	*imbalance = 0;
 	return NULL;


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbZCYJtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbZCYJtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759362AbZCYJrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:47:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:46461 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759359AbZCYJrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:47:32 -0400
Date: Wed, 25 Mar 2009 09:46:39 GMT
From: Gautham R Shenoy <ego@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, dhaval@linux.vnet.ibm.com,
       balbir@in.ibm.com, bharata@linux.vnet.ibm.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu,
       nickpiggin@yahoo.com.au
Reply-To: mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, balbir@in.ibm.com,
       bharata@linux.vnet.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, nickpiggin@yahoo.com.au, mingo@elte.hu
In-Reply-To: <20090325091401.13992.88737.stgit@sofia.in.ibm.com>
References: <20090325091401.13992.88737.stgit@sofia.in.ibm.com>
Subject: [tip:sched/balancing] sched: Create a helper function to calculate sched_domain stats for fbg()
Message-ID: <tip-37abe198b1246ddd206319c43502a687db62d347@git.kernel.org>
Git-Commit-ID: 37abe198b1246ddd206319c43502a687db62d347
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 09:46:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37abe198b1246ddd206319c43502a687db62d347
Gitweb:     http://git.kernel.org/tip/37abe198b1246ddd206319c43502a687db62d347
Author:     Gautham R Shenoy <ego@in.ibm.com>
AuthorDate: Wed, 25 Mar 2009 14:44:01 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 10:30:46 +0100

sched: Create a helper function to calculate sched_domain stats for fbg()

Impact: cleanup

Create a helper function named update_sd_lb_stats() to update the
various sched_domain related statistics in find_busiest_group().

With this we would have moved all the statistics computation out of
find_busiest_group().

Credit: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Balbir Singh" <balbir@in.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
LKML-Reference: <20090325091401.13992.88737.stgit@sofia.in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |  117 +++++++++++++++++++++++++++++++++++---------------------
 1 files changed, 73 insertions(+), 44 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8198dbe..ec715f9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3365,32 +3365,33 @@ static inline void update_sg_lb_stats(struct sched_group *group, int this_cpu,
 	sgs->group_capacity = group->__cpu_power / SCHED_LOAD_SCALE;
 
 }
-/******* find_busiest_group() helpers end here *********************/
 
-/*
- * find_busiest_group finds and returns the busiest CPU group within the
- * domain. It calculates and returns the amount of weighted load which
- * should be moved to restore balance via the imbalance parameter.
+/**
+ * update_sd_lb_stats - Update sched_group's statistics for load balancing.
+ * @sd: sched_domain whose statistics are to be updated.
+ * @this_cpu: Cpu for which load balance is currently performed.
+ * @idle: Idle status of this_cpu
+ * @sd_idle: Idle status of the sched_domain containing group.
+ * @cpus: Set of cpus considered for load balancing.
+ * @balance: Should we balance.
+ * @sds: variable to hold the statistics for this sched_domain.
  */
-static struct sched_group *
-find_busiest_group(struct sched_domain *sd, int this_cpu,
-		   unsigned long *imbalance, enum cpu_idle_type idle,
-		   int *sd_idle, const struct cpumask *cpus, int *balance)
+static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
+			enum cpu_idle_type idle, int *sd_idle,
+			const struct cpumask *cpus, int *balance,
+			struct sd_lb_stats *sds)
 {
-	struct sd_lb_stats sds;
 	struct sched_group *group = sd->groups;
-	unsigned long max_pull;
+	struct sg_lb_stats sgs;
 	int load_idx;
 
-	memset(&sds, 0, sizeof(sds));
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	sds.power_savings_balance = 1;
-	sds.min_nr_running = ULONG_MAX;
+	sds->power_savings_balance = 1;
+	sds->min_nr_running = ULONG_MAX;
 #endif
 	load_idx = get_sd_load_idx(sd, idle);
 
 	do {
-		struct sg_lb_stats sgs;
 		int local_group;
 
 		local_group = cpumask_test_cpu(this_cpu,
@@ -3399,25 +3400,25 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		update_sg_lb_stats(group, this_cpu, idle, load_idx, sd_idle,
 				local_group, cpus, balance, &sgs);
 
-		if (balance && !(*balance))
-			goto ret;
+		if (local_group && balance && !(*balance))
+			return;
 
-		sds.total_load += sgs.group_load;
-		sds.total_pwr += group->__cpu_power;
+		sds->total_load += sgs.group_load;
+		sds->total_pwr += group->__cpu_power;
 
 		if (local_group) {
-			sds.this_load = sgs.avg_load;
-			sds.this = group;
-			sds.this_nr_running = sgs.sum_nr_running;
-			sds.this_load_per_task = sgs.sum_weighted_load;
-		} else if (sgs.avg_load > sds.max_load &&
+			sds->this_load = sgs.avg_load;
+			sds->this = group;
+			sds->this_nr_running = sgs.sum_nr_running;
+			sds->this_load_per_task = sgs.sum_weighted_load;
+		} else if (sgs.avg_load > sds->max_load &&
 			   (sgs.sum_nr_running > sgs.group_capacity ||
 				sgs.group_imb)) {
-			sds.max_load = sgs.avg_load;
-			sds.busiest = group;
-			sds.busiest_nr_running = sgs.sum_nr_running;
-			sds.busiest_load_per_task = sgs.sum_weighted_load;
-			sds.group_imb = sgs.group_imb;
+			sds->max_load = sgs.avg_load;
+			sds->busiest = group;
+			sds->busiest_nr_running = sgs.sum_nr_running;
+			sds->busiest_load_per_task = sgs.sum_weighted_load;
+			sds->group_imb = sgs.group_imb;
 		}
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
@@ -3434,15 +3435,15 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		 * no need to do power savings balance at this domain
 		 */
 		if (local_group &&
-			(sds.this_nr_running >= sgs.group_capacity ||
-			!sds.this_nr_running))
-			sds.power_savings_balance = 0;
+			(sds->this_nr_running >= sgs.group_capacity ||
+			!sds->this_nr_running))
+			sds->power_savings_balance = 0;
 
 		/*
 		 * If a group is already running at full capacity or idle,
 		 * don't include that group in power savings calculations
 		 */
-		if (!sds.power_savings_balance ||
+		if (!sds->power_savings_balance ||
 			sgs.sum_nr_running >= sgs.group_capacity ||
 			!sgs.sum_nr_running)
 			goto group_next;
@@ -3452,13 +3453,13 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		 * This is the group from where we need to pick up the load
 		 * for saving power
 		 */
-		if ((sgs.sum_nr_running < sds.min_nr_running) ||
-		    (sgs.sum_nr_running == sds.min_nr_running &&
+		if ((sgs.sum_nr_running < sds->min_nr_running) ||
+		    (sgs.sum_nr_running == sds->min_nr_running &&
 		     group_first_cpu(group) >
-			group_first_cpu(sds.group_min))) {
-			sds.group_min = group;
-			sds.min_nr_running = sgs.sum_nr_running;
-			sds.min_load_per_task = sgs.sum_weighted_load /
+			group_first_cpu(sds->group_min))) {
+			sds->group_min = group;
+			sds->min_nr_running = sgs.sum_nr_running;
+			sds->min_load_per_task = sgs.sum_weighted_load /
 						sgs.sum_nr_running;
 		}
 
@@ -3470,18 +3471,46 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		if (sgs.sum_nr_running > sgs.group_capacity - 1)
 			goto group_next;
 
-		if (sgs.sum_nr_running > sds.leader_nr_running ||
-		    (sgs.sum_nr_running == sds.leader_nr_running &&
+		if (sgs.sum_nr_running > sds->leader_nr_running ||
+		    (sgs.sum_nr_running == sds->leader_nr_running &&
 		     group_first_cpu(group) <
-			group_first_cpu(sds.group_leader))) {
-			sds.group_leader = group;
-			sds.leader_nr_running = sgs.sum_nr_running;
+			group_first_cpu(sds->group_leader))) {
+			sds->group_leader = group;
+			sds->leader_nr_running = sgs.sum_nr_running;
 		}
 group_next:
 #endif
 		group = group->next;
 	} while (group != sd->groups);
 
+}
+/******* find_busiest_group() helpers end here *********************/
+
+/*
+ * find_busiest_group finds and returns the busiest CPU group within the
+ * domain. It calculates and returns the amount of weighted load which
+ * should be moved to restore balance via the imbalance parameter.
+ */
+static struct sched_group *
+find_busiest_group(struct sched_domain *sd, int this_cpu,
+		   unsigned long *imbalance, enum cpu_idle_type idle,
+		   int *sd_idle, const struct cpumask *cpus, int *balance)
+{
+	struct sd_lb_stats sds;
+	unsigned long max_pull;
+
+	memset(&sds, 0, sizeof(sds));
+
+	/*
+	 * Compute the various statistics relavent for load balancing at
+	 * this level.
+	 */
+	update_sd_lb_stats(sd, this_cpu, idle, sd_idle, cpus,
+					balance, &sds);
+
+	if (balance && !(*balance))
+		goto ret;
+
 	if (!sds.busiest || sds.this_load >= sds.max_load
 		|| sds.busiest_nr_running == 0)
 		goto out_balanced;

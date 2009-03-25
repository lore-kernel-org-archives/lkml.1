Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbZCYJOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbZCYJOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757613AbZCYJN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:13:58 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:33492 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbZCYJNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:13:54 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [RFC PATCH 03/11] sched: Define structure to store the sched_group
	statistics for fbg()
To: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Balbir Singh" <balbir@in.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Date: Wed, 25 Mar 2009 14:43:46 +0530
Message-ID: <20090325091345.13992.20099.stgit@sofia.in.ibm.com>
In-Reply-To: <20090325091239.13992.96090.stgit@sofia.in.ibm.com>
References: <20090325091239.13992.96090.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently a whole bunch of variables are used to store the various statistics
pertaining to the groups we iterate over in find_busiest_group().

Group them together in a single data structure and add appropriate comments.

This will be useful later on when we create helper functions to calculate the
sched_group statistics.

Credit: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c |   79 +++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 46 insertions(+), 33 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d95dcc0..6da9939 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3088,6 +3088,18 @@ static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 /********** Helpers for find_busiest_group ************************/
 
 /**
+ * sg_lb_stats - stats of a sched_group required for load_balancing
+ */
+struct sg_lb_stats {
+	unsigned long avg_load; /*Avg load across the CPUs of the group */
+	unsigned long group_load; /* Total load over the CPUs of the group */
+	unsigned long sum_nr_running; /* Nr tasks running in the group */
+	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
+	unsigned long group_capacity;
+	int group_imb; /* Is there an imbalance in the group ? */
+};
+
+/**
  * group_first_cpu - Returns the first cpu in the cpumask of a sched_group.
  * @group: The group whose first cpu is to be returned.
  */
@@ -3153,23 +3165,22 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	load_idx = get_sd_load_idx(sd, idle);
 
 	do {
-		unsigned long load, group_capacity, max_cpu_load, min_cpu_load;
+		struct sg_lb_stats sgs;
+		unsigned long load, max_cpu_load, min_cpu_load;
 		int local_group;
 		int i;
-		int __group_imb = 0;
 		unsigned int balance_cpu = -1, first_idle_cpu = 0;
-		unsigned long sum_nr_running, sum_weighted_load;
 		unsigned long sum_avg_load_per_task;
 		unsigned long avg_load_per_task;
 
 		local_group = cpumask_test_cpu(this_cpu,
 					       sched_group_cpus(group));
+		memset(&sgs, 0, sizeof(sgs));
 
 		if (local_group)
 			balance_cpu = group_first_cpu(group);
 
 		/* Tally up the load of all CPUs in the group */
-		sum_weighted_load = sum_nr_running = avg_load = 0;
 		sum_avg_load_per_task = avg_load_per_task = 0;
 
 		max_cpu_load = 0;
@@ -3197,9 +3208,9 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 					min_cpu_load = load;
 			}
 
-			avg_load += load;
-			sum_nr_running += rq->nr_running;
-			sum_weighted_load += weighted_cpuload(i);
+			sgs.group_load += load;
+			sgs.sum_nr_running += rq->nr_running;
+			sgs.sum_weighted_load += weighted_cpuload(i);
 
 			sum_avg_load_per_task += cpu_avg_load_per_task(i);
 		}
@@ -3216,12 +3227,12 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 			goto ret;
 		}
 
-		total_load += avg_load;
+		total_load += sgs.group_load;
 		total_pwr += group->__cpu_power;
 
 		/* Adjust by relative CPU power of the group */
-		avg_load = sg_div_cpu_power(group,
-				avg_load * SCHED_LOAD_SCALE);
+		sgs.avg_load = sg_div_cpu_power(group,
+				sgs.group_load * SCHED_LOAD_SCALE);
 
 
 		/*
@@ -3237,22 +3248,23 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 				sum_avg_load_per_task * SCHED_LOAD_SCALE);
 
 		if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
-			__group_imb = 1;
+			sgs.group_imb = 1;
 
-		group_capacity = group->__cpu_power / SCHED_LOAD_SCALE;
+		sgs.group_capacity = group->__cpu_power / SCHED_LOAD_SCALE;
 
 		if (local_group) {
-			this_load = avg_load;
+			this_load = sgs.avg_load;
 			this = group;
-			this_nr_running = sum_nr_running;
-			this_load_per_task = sum_weighted_load;
-		} else if (avg_load > max_load &&
-			   (sum_nr_running > group_capacity || __group_imb)) {
-			max_load = avg_load;
+			this_nr_running = sgs.sum_nr_running;
+			this_load_per_task = sgs.sum_weighted_load;
+		} else if (sgs.avg_load > max_load &&
+			   (sgs.sum_nr_running > sgs.group_capacity ||
+				sgs.group_imb)) {
+			max_load = sgs.avg_load;
 			busiest = group;
-			busiest_nr_running = sum_nr_running;
-			busiest_load_per_task = sum_weighted_load;
-			group_imb = __group_imb;
+			busiest_nr_running = sgs.sum_nr_running;
+			busiest_load_per_task = sgs.sum_weighted_load;
+			group_imb = sgs.group_imb;
 		}
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
@@ -3268,7 +3280,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		 * If the local group is idle or completely loaded
 		 * no need to do power savings balance at this domain
 		 */
-		if (local_group && (this_nr_running >= group_capacity ||
+		if (local_group && (this_nr_running >= sgs.group_capacity ||
 				    !this_nr_running))
 			power_savings_balance = 0;
 
@@ -3276,8 +3288,9 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		 * If a group is already running at full capacity or idle,
 		 * don't include that group in power savings calculations
 		 */
-		if (!power_savings_balance || sum_nr_running >= group_capacity
-		    || !sum_nr_running)
+		if (!power_savings_balance ||
+			sgs.sum_nr_running >= sgs.group_capacity ||
+			!sgs.sum_nr_running)
 			goto group_next;
 
 		/*
@@ -3285,13 +3298,13 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		 * This is the group from where we need to pick up the load
 		 * for saving power
 		 */
-		if ((sum_nr_running < min_nr_running) ||
-		    (sum_nr_running == min_nr_running &&
+		if ((sgs.sum_nr_running < min_nr_running) ||
+		    (sgs.sum_nr_running == min_nr_running &&
 		     group_first_cpu(group) > group_first_cpu(group_min))) {
 			group_min = group;
-			min_nr_running = sum_nr_running;
-			min_load_per_task = sum_weighted_load /
-						sum_nr_running;
+			min_nr_running = sgs.sum_nr_running;
+			min_load_per_task = sgs.sum_weighted_load /
+						sgs.sum_nr_running;
 		}
 
 		/*
@@ -3299,14 +3312,14 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		 * capacity but still has some space to pick up some load
 		 * from other group and save more power
 		 */
-		if (sum_nr_running > group_capacity - 1)
+		if (sgs.sum_nr_running > sgs.group_capacity - 1)
 			goto group_next;
 
-		if (sum_nr_running > leader_nr_running ||
-		    (sum_nr_running == leader_nr_running &&
+		if (sgs.sum_nr_running > leader_nr_running ||
+		    (sgs.sum_nr_running == leader_nr_running &&
 		     group_first_cpu(group) < group_first_cpu(group_leader))) {
 			group_leader = group;
-			leader_nr_running = sum_nr_running;
+			leader_nr_running = sgs.sum_nr_running;
 		}
 group_next:
 #endif


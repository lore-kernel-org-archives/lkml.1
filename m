Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbZCYJsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbZCYJsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759293AbZCYJrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:47:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:46436 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759214AbZCYJrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:47:21 -0400
Date: Wed, 25 Mar 2009 09:46:17 GMT
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
In-Reply-To: <20090325091345.13992.20099.stgit@sofia.in.ibm.com>
References: <20090325091345.13992.20099.stgit@sofia.in.ibm.com>
Subject: [tip:sched/balancing] sched: Define structure to store the sched_group statistics for fbg()
Message-ID: <tip-381be78fdc829a22f6327a0ed09f54b6270a976d@git.kernel.org>
Git-Commit-ID: 381be78fdc829a22f6327a0ed09f54b6270a976d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 09:46:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  381be78fdc829a22f6327a0ed09f54b6270a976d
Gitweb:     http://git.kernel.org/tip/381be78fdc829a22f6327a0ed09f54b6270a976d
Author:     Gautham R Shenoy <ego@in.ibm.com>
AuthorDate: Wed, 25 Mar 2009 14:43:46 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 10:30:45 +0100

sched: Define structure to store the sched_group statistics for fbg()

Impact: cleanup

Currently a whole bunch of variables are used to store the
various statistics pertaining to the groups we iterate over
in find_busiest_group().

Group them together in a single data structure and add
appropriate comments.

This will be useful later on when we create helper functions
to calculate the sched_group statistics.

Credit: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Balbir Singh" <balbir@in.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
LKML-Reference: <20090325091345.13992.20099.stgit@sofia.in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   79 ++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 46 insertions(+), 33 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f87adbe..109db12 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3192,6 +3192,18 @@ static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
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
@@ -3257,23 +3269,22 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
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
@@ -3301,9 +3312,9 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
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
@@ -3320,12 +3331,12 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
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
@@ -3341,22 +3352,23 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
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
@@ -3372,7 +3384,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		 * If the local group is idle or completely loaded
 		 * no need to do power savings balance at this domain
 		 */
-		if (local_group && (this_nr_running >= group_capacity ||
+		if (local_group && (this_nr_running >= sgs.group_capacity ||
 				    !this_nr_running))
 			power_savings_balance = 0;
 
@@ -3380,8 +3392,9 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
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
@@ -3389,13 +3402,13 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
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
@@ -3403,14 +3416,14 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
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

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbZCYJNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbZCYJNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbZCYJNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:13:43 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:58530 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbZCYJNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:13:41 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [RFC PATCH 01/11] sched: Simple helper functions for
	find_busiest_group()
To: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Balbir Singh" <balbir@in.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Date: Wed, 25 Mar 2009 14:43:35 +0530
Message-ID: <20090325091335.13992.55424.stgit@sofia.in.ibm.com>
In-Reply-To: <20090325091239.13992.96090.stgit@sofia.in.ibm.com>
References: <20090325091239.13992.96090.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the load idx calculation code is in find_busiest_group(). Move that
to a static inline helper function.

Similary, to find the first cpu of a sched_group we use
cpumask_first(sched_group_cpus(group))
Use a helper to that. It improves readability in
some cases.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c |   55 +++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8e2558c..0b65f8c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3085,6 +3085,43 @@ static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 
 	return 0;
 }
+/********** Helpers for find_busiest_group ************************/
+
+/**
+ * group_first_cpu - Returns the first cpu in the cpumask of a sched_group.
+ * @group: The group whose first cpu is to be returned.
+ */
+static inline unsigned int group_first_cpu(struct sched_group *group)
+{
+	return cpumask_first(sched_group_cpus(group));
+}
+
+/**
+ * get_sd_load_idx - Obtain the load index for a given sched domain.
+ * @sd: The sched_domain whose load_idx is to be obtained.
+ * @idle: The Idle status of the CPU for whose sd load_icx is obtained.
+ */
+static inline int get_sd_load_idx(struct sched_domain *sd,
+					enum cpu_idle_type idle)
+{
+	int load_idx;
+
+	switch (idle) {
+	case CPU_NOT_IDLE:
+		load_idx = sd->busy_idx;
+		break;
+
+	case CPU_NEWLY_IDLE:
+		load_idx = sd->newidle_idx;
+		break;
+	default:
+		load_idx = sd->idle_idx;
+		break;
+	}
+
+	return load_idx;
+}
+/******* find_busiest_group() helpers end here *********************/
 
 /*
  * find_busiest_group finds and returns the busiest CPU group within the
@@ -3113,12 +3150,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	busiest_load_per_task = busiest_nr_running = 0;
 	this_load_per_task = this_nr_running = 0;
 
-	if (idle == CPU_NOT_IDLE)
-		load_idx = sd->busy_idx;
-	else if (idle == CPU_NEWLY_IDLE)
-		load_idx = sd->newidle_idx;
-	else
-		load_idx = sd->idle_idx;
+	load_idx = get_sd_load_idx(sd, idle);
 
 	do {
 		unsigned long load, group_capacity, max_cpu_load, min_cpu_load;
@@ -3134,7 +3166,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 					       sched_group_cpus(group));
 
 		if (local_group)
-			balance_cpu = cpumask_first(sched_group_cpus(group));
+			balance_cpu = group_first_cpu(group);
 
 		/* Tally up the load of all CPUs in the group */
 		sum_weighted_load = sum_nr_running = avg_load = 0;
@@ -3255,8 +3287,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		 */
 		if ((sum_nr_running < min_nr_running) ||
 		    (sum_nr_running == min_nr_running &&
-		     cpumask_first(sched_group_cpus(group)) >
-		     cpumask_first(sched_group_cpus(group_min)))) {
+		     group_first_cpu(group) > group_first_cpu(group_min))) {
 			group_min = group;
 			min_nr_running = sum_nr_running;
 			min_load_per_task = sum_weighted_load /
@@ -3271,8 +3302,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		if (sum_nr_running <= group_capacity - 1) {
 			if (sum_nr_running > leader_nr_running ||
 			    (sum_nr_running == leader_nr_running &&
-			     cpumask_first(sched_group_cpus(group)) <
-			     cpumask_first(sched_group_cpus(group_leader)))) {
+			     group_first_cpu(group) <
+			     group_first_cpu(group_leader))) {
 				group_leader = group;
 				leader_nr_running = sum_nr_running;
 			}
@@ -3400,7 +3431,7 @@ out_balanced:
 		*imbalance = min_load_per_task;
 		if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP) {
 			cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
-				cpumask_first(sched_group_cpus(group_leader));
+				group_first_cpu(group_leader);
 		}
 		return group_min;
 	}


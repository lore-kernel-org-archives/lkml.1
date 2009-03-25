Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbZCYJr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbZCYJr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758943AbZCYJrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:47:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:46414 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759017AbZCYJrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:47:15 -0400
Date: Wed, 25 Mar 2009 09:46:02 GMT
From: Gautham R Shenoy <ego@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, dhaval@linux.vnet.ibm.com,
       balbir@in.ibm.com, bharata@linux.vnet.ibm.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu,
       svaidy@linux.vnet.ibm.com, nickpiggin@yahoo.com.au
Reply-To: mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, balbir@in.ibm.com,
       bharata@linux.vnet.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, nickpiggin@yahoo.com.au, svaidy@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20090325091335.13992.55424.stgit@sofia.in.ibm.com>
References: <20090325091335.13992.55424.stgit@sofia.in.ibm.com>
Subject: [tip:sched/balancing] sched: Simple helper functions for find_busiest_group()
Message-ID: <tip-67bb6c036d1fc3d332c8527a36a546e3e72e822c@git.kernel.org>
Git-Commit-ID: 67bb6c036d1fc3d332c8527a36a546e3e72e822c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 09:46:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67bb6c036d1fc3d332c8527a36a546e3e72e822c
Gitweb:     http://git.kernel.org/tip/67bb6c036d1fc3d332c8527a36a546e3e72e822c
Author:     Gautham R Shenoy <ego@in.ibm.com>
AuthorDate: Wed, 25 Mar 2009 14:43:35 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 10:30:44 +0100

sched: Simple helper functions for find_busiest_group()

Impact: cleanup

Currently the load idx calculation code is in find_busiest_group().
Move that to a static inline helper function.

Similary, to find the first cpu of a sched_group we use
cpumask_first(sched_group_cpus(group))

Use a helper to that. It improves readability in some cases.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Balbir Singh" <balbir@in.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
LKML-Reference: <20090325091335.13992.55424.stgit@sofia.in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   55 +++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7b389c7..6aec1e7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3189,6 +3189,43 @@ static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 
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
@@ -3217,12 +3254,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
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
@@ -3238,7 +3270,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 					       sched_group_cpus(group));
 
 		if (local_group)
-			balance_cpu = cpumask_first(sched_group_cpus(group));
+			balance_cpu = group_first_cpu(group);
 
 		/* Tally up the load of all CPUs in the group */
 		sum_weighted_load = sum_nr_running = avg_load = 0;
@@ -3359,8 +3391,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		 */
 		if ((sum_nr_running < min_nr_running) ||
 		    (sum_nr_running == min_nr_running &&
-		     cpumask_first(sched_group_cpus(group)) >
-		     cpumask_first(sched_group_cpus(group_min)))) {
+		     group_first_cpu(group) > group_first_cpu(group_min))) {
 			group_min = group;
 			min_nr_running = sum_nr_running;
 			min_load_per_task = sum_weighted_load /
@@ -3375,8 +3406,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
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
@@ -3504,7 +3535,7 @@ out_balanced:
 		*imbalance = min_load_per_task;
 		if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP) {
 			cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
-				cpumask_first(sched_group_cpus(group_leader));
+				group_first_cpu(group_leader);
 		}
 		return group_min;
 	}

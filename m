Return-Path: <linux-kernel-owner+w=401wt.eu-S1759242AbZCYJQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbZCYJQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758549AbZCYJO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:14:26 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:46817 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758584AbZCYJOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:14:24 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [RFC PATCH 08/11] sched: Create a helper function to calculate
	imbalance.
To: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Balbir Singh" <balbir@in.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Date: Wed, 25 Mar 2009 14:44:12 +0530
Message-ID: <20090325091411.13992.43293.stgit@sofia.in.ibm.com>
In-Reply-To: <20090325091239.13992.96090.stgit@sofia.in.ibm.com>
References: <20090325091239.13992.96090.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move all the imbalance calculation out of find_busiest_group() through this
helper function.

With this change, the structure of find_busiest_group() will be as follows:

- update_sched_domain_statistics.

- Check if imbalance exits.

- Update imbalance and return busiest.


Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c |   78 ++++++++++++++++++++++++++++++++------------------------
 1 files changed, 45 insertions(+), 33 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 364866f..b1b1b8a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3383,8 +3383,8 @@ group_next:
 
 /**
  * fix_small_imbalance - Calculate the minor imbalance that exists
- * 			amongst the groups of a sched_domain, during
- * 			load balancing.
+ *			amongst the groups of a sched_domain, during
+ *			load balancing.
  * @sds: Statistics of the sched_domain whose imbalance is to be calculated.
  * @this_cpu: The cpu at whose sched_domain we're performing load-balance.
  * @imbalance: Variable to store the imbalance.
@@ -3445,6 +3445,47 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 	if (pwr_move > pwr_now)
 		*imbalance = sds->busiest_load_per_task;
 }
+
+/**
+ * calculate_imbalance - Calculate the amount of imbalance present within the
+ *			 groups of a given sched_domain during load balance.
+ * @sds: statistics of the sched_domain whose imbalance is to be calculated.
+ * @this_cpu: Cpu for which currently load balance is being performed.
+ * @imbalance: The variable to store the imbalance.
+ */
+static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
+		unsigned long *imbalance)
+{
+	unsigned long max_pull;
+	/*
+	 * In the presence of smp nice balancing, certain scenarios can have
+	 * max load less than avg load(as we skip the groups at or below
+	 * its cpu_power, while calculating max_load..)
+	 */
+	if (sds->max_load < sds->avg_load) {
+		*imbalance = 0;
+		return fix_small_imbalance(sds, this_cpu, imbalance);
+	}
+
+	/* Don't want to pull so many tasks that a group would go idle */
+	max_pull = min(sds->max_load - sds->avg_load,
+			sds->max_load - sds->busiest_load_per_task);
+
+	/* How much load to actually move to equalise the imbalance */
+	*imbalance = min(max_pull * sds->busiest->__cpu_power,
+		(sds->avg_load - sds->this_load) * sds->this->__cpu_power)
+			/ SCHED_LOAD_SCALE;
+
+	/*
+	 * if *imbalance is less than the average load per runnable task
+	 * there is no gaurantee that any tasks will be moved so we'll have
+	 * a think about bumping its value to force at least one task to be
+	 * moved
+	 */
+	if (*imbalance < sds->busiest_load_per_task)
+		return fix_small_imbalance(sds, this_cpu, imbalance);
+
+}
 /******* find_busiest_group() helpers end here *********************/
 
 /*
@@ -3458,7 +3499,6 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		   int *sd_idle, const struct cpumask *cpus, int *balance)
 {
 	struct sd_lb_stats sds;
-	unsigned long max_pull;
 
 	memset(&sds, 0, sizeof(sds));
 
@@ -3501,36 +3541,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (sds.max_load <= sds.busiest_load_per_task)
 		goto out_balanced;
 
-	/*
-	 * In the presence of smp nice balancing, certain scenarios can have
-	 * max load less than avg load(as we skip the groups at or below
-	 * its cpu_power, while calculating max_load..)
-	 */
-	if (sds.max_load < sds.avg_load) {
-		*imbalance = 0;
-		fix_small_imbalance(&sds, this_cpu, imbalance);
-		goto ret_busiest;
-	}
-
-	/* Don't want to pull so many tasks that a group would go idle */
-	max_pull = min(sds.max_load - sds.avg_load,
-			sds.max_load - sds.busiest_load_per_task);
-
-	/* How much load to actually move to equalise the imbalance */
-	*imbalance = min(max_pull * sds.busiest->__cpu_power,
-			(sds.avg_load - sds.this_load) * sds.this->__cpu_power)
-			/ SCHED_LOAD_SCALE;
-
-	/*
-	 * if *imbalance is less than the average load per runnable task
-	 * there is no gaurantee that any tasks will be moved so we'll have
-	 * a think about bumping its value to force at least one task to be
-	 * moved
-	 */
-	if (*imbalance < sds.busiest_load_per_task)
-		fix_small_imbalance(&sds, this_cpu, imbalance);
-
-ret_busiest:
+	/* Looks like there is an imbalance. Compute it */
+	calculate_imbalance(&sds, this_cpu, imbalance);
 	return sds.busiest;
 
 out_balanced:


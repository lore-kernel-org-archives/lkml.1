Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbZCYJu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbZCYJu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759523AbZCYJrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:47:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:46480 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759498AbZCYJro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:47:44 -0400
Date: Wed, 25 Mar 2009 09:46:54 GMT
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
In-Reply-To: <20090325091411.13992.43293.stgit@sofia.in.ibm.com>
References: <20090325091411.13992.43293.stgit@sofia.in.ibm.com>
Subject: [tip:sched/balancing] sched: Create a helper function to calculate imbalance
Message-ID: <tip-dbc523a3b86f9e1765b5e70e6886913b99cc5cec@git.kernel.org>
Git-Commit-ID: dbc523a3b86f9e1765b5e70e6886913b99cc5cec
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 09:46:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dbc523a3b86f9e1765b5e70e6886913b99cc5cec
Gitweb:     http://git.kernel.org/tip/dbc523a3b86f9e1765b5e70e6886913b99cc5cec
Author:     Gautham R Shenoy <ego@in.ibm.com>
AuthorDate: Wed, 25 Mar 2009 14:44:12 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 10:30:47 +0100

sched: Create a helper function to calculate imbalance

Move all the imbalance calculation out of find_busiest_group()
through this helper function.

With this change, the structure of find_busiest_group() will be
as follows:

- update_sched_domain_statistics.

- check if imbalance exits.

- update imbalance and return busiest.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Balbir Singh" <balbir@in.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
LKML-Reference: <20090325091411.13992.43293.stgit@sofia.in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   78 ++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 45 insertions(+), 33 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 540147e..934f615 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3487,8 +3487,8 @@ group_next:
 
 /**
  * fix_small_imbalance - Calculate the minor imbalance that exists
- * 			amongst the groups of a sched_domain, during
- * 			load balancing.
+ *			amongst the groups of a sched_domain, during
+ *			load balancing.
  * @sds: Statistics of the sched_domain whose imbalance is to be calculated.
  * @this_cpu: The cpu at whose sched_domain we're performing load-balance.
  * @imbalance: Variable to store the imbalance.
@@ -3549,6 +3549,47 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
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
@@ -3562,7 +3603,6 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		   int *sd_idle, const struct cpumask *cpus, int *balance)
 {
 	struct sd_lb_stats sds;
-	unsigned long max_pull;
 
 	memset(&sds, 0, sizeof(sds));
 
@@ -3605,36 +3645,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
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

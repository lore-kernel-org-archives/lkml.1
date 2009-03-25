Return-Path: <linux-kernel-owner+w=401wt.eu-S1758966AbZCYJP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbZCYJP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758507AbZCYJOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:14:17 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:44424 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758388AbZCYJOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:14:15 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [RFC PATCH 07/11] sched: Create helper to calculate small_imbalance
	in find_busiest_group.
To: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Balbir Singh" <balbir@in.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Date: Wed, 25 Mar 2009 14:44:06 +0530
Message-ID: <20090325091406.13992.54316.stgit@sofia.in.ibm.com>
In-Reply-To: <20090325091239.13992.96090.stgit@sofia.in.ibm.com>
References: <20090325091239.13992.96090.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have two places in find_busiest_group() where we need to calculate the
minor imbalance before returning the busiest group. Encapsulate this
functionality into a seperate helper function.

Credit: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c |  131 ++++++++++++++++++++++++++++++--------------------------
 1 files changed, 70 insertions(+), 61 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5e01162..364866f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3380,6 +3380,71 @@ group_next:
 	} while (group != sd->groups);
 
 }
+
+/**
+ * fix_small_imbalance - Calculate the minor imbalance that exists
+ * 			amongst the groups of a sched_domain, during
+ * 			load balancing.
+ * @sds: Statistics of the sched_domain whose imbalance is to be calculated.
+ * @this_cpu: The cpu at whose sched_domain we're performing load-balance.
+ * @imbalance: Variable to store the imbalance.
+ */
+static inline void fix_small_imbalance(struct sd_lb_stats *sds,
+				int this_cpu, unsigned long *imbalance)
+{
+	unsigned long tmp, pwr_now = 0, pwr_move = 0;
+	unsigned int imbn = 2;
+
+	if (sds->this_nr_running) {
+		sds->this_load_per_task /= sds->this_nr_running;
+		if (sds->busiest_load_per_task >
+				sds->this_load_per_task)
+			imbn = 1;
+	} else
+		sds->this_load_per_task =
+			cpu_avg_load_per_task(this_cpu);
+
+	if (sds->max_load - sds->this_load + sds->busiest_load_per_task >=
+			sds->busiest_load_per_task * imbn) {
+		*imbalance = sds->busiest_load_per_task;
+		return;
+	}
+
+	/*
+	 * OK, we don't have enough imbalance to justify moving tasks,
+	 * however we may be able to increase total CPU power used by
+	 * moving them.
+	 */
+
+	pwr_now += sds->busiest->__cpu_power *
+			min(sds->busiest_load_per_task, sds->max_load);
+	pwr_now += sds->this->__cpu_power *
+			min(sds->this_load_per_task, sds->this_load);
+	pwr_now /= SCHED_LOAD_SCALE;
+
+	/* Amount of load we'd subtract */
+	tmp = sg_div_cpu_power(sds->busiest,
+			sds->busiest_load_per_task * SCHED_LOAD_SCALE);
+	if (sds->max_load > tmp)
+		pwr_move += sds->busiest->__cpu_power *
+			min(sds->busiest_load_per_task, sds->max_load - tmp);
+
+	/* Amount of load we'd add */
+	if (sds->max_load * sds->busiest->__cpu_power <
+		sds->busiest_load_per_task * SCHED_LOAD_SCALE)
+		tmp = sg_div_cpu_power(sds->this,
+			sds->max_load * sds->busiest->__cpu_power);
+	else
+		tmp = sg_div_cpu_power(sds->this,
+			sds->busiest_load_per_task * SCHED_LOAD_SCALE);
+	pwr_move += sds->this->__cpu_power *
+			min(sds->this_load_per_task, sds->this_load + tmp);
+	pwr_move /= SCHED_LOAD_SCALE;
+
+	/* Move if we gain throughput */
+	if (pwr_move > pwr_now)
+		*imbalance = sds->busiest_load_per_task;
+}
 /******* find_busiest_group() helpers end here *********************/
 
 /*
@@ -3443,7 +3508,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	 */
 	if (sds.max_load < sds.avg_load) {
 		*imbalance = 0;
-		goto small_imbalance;
+		fix_small_imbalance(&sds, this_cpu, imbalance);
+		goto ret_busiest;
 	}
 
 	/* Don't want to pull so many tasks that a group would go idle */
@@ -3461,67 +3527,10 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	 * a think about bumping its value to force at least one task to be
 	 * moved
 	 */
-	if (*imbalance < sds.busiest_load_per_task) {
-		unsigned long tmp, pwr_now, pwr_move;
-		unsigned int imbn;
-
-small_imbalance:
-		pwr_move = pwr_now = 0;
-		imbn = 2;
-		if (sds.this_nr_running) {
-			sds.this_load_per_task /= sds.this_nr_running;
-			if (sds.busiest_load_per_task >
-					sds.this_load_per_task)
-				imbn = 1;
-		} else
-			sds.this_load_per_task =
-				cpu_avg_load_per_task(this_cpu);
-
-		if (sds.max_load - sds.this_load +
-			sds.busiest_load_per_task >=
-				sds.busiest_load_per_task * imbn) {
-			*imbalance = sds.busiest_load_per_task;
-			return sds.busiest;
-		}
-
-		/*
-		 * OK, we don't have enough imbalance to justify moving tasks,
-		 * however we may be able to increase total CPU power used by
-		 * moving them.
-		 */
-
-		pwr_now += sds.busiest->__cpu_power *
-				min(sds.busiest_load_per_task, sds.max_load);
-		pwr_now += sds.this->__cpu_power *
-				min(sds.this_load_per_task, sds.this_load);
-		pwr_now /= SCHED_LOAD_SCALE;
-
-		/* Amount of load we'd subtract */
-		tmp = sg_div_cpu_power(sds.busiest,
-				sds.busiest_load_per_task * SCHED_LOAD_SCALE);
-		if (sds.max_load > tmp)
-			pwr_move += sds.busiest->__cpu_power *
-				min(sds.busiest_load_per_task,
-						sds.max_load - tmp);
-
-		/* Amount of load we'd add */
-		if (sds.max_load * sds.busiest->__cpu_power <
-				sds.busiest_load_per_task * SCHED_LOAD_SCALE)
-			tmp = sg_div_cpu_power(sds.this,
-				sds.max_load * sds.busiest->__cpu_power);
-		else
-			tmp = sg_div_cpu_power(sds.this,
-				sds.busiest_load_per_task * SCHED_LOAD_SCALE);
-		pwr_move += sds.this->__cpu_power *
-				min(sds.this_load_per_task,
-					sds.this_load + tmp);
-		pwr_move /= SCHED_LOAD_SCALE;
-
-		/* Move if we gain throughput */
-		if (pwr_move > pwr_now)
-			*imbalance = sds.busiest_load_per_task;
-	}
+	if (*imbalance < sds.busiest_load_per_task)
+		fix_small_imbalance(&sds, this_cpu, imbalance);
 
+ret_busiest:
 	return sds.busiest;
 
 out_balanced:


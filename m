Return-Path: <linux-kernel-owner+w=401wt.eu-S1759193AbZCYJtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193AbZCYJtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759398AbZCYJrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:47:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:46458 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759429AbZCYJra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:47:30 -0400
Date: Wed, 25 Mar 2009 09:46:46 GMT
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
In-Reply-To: <20090325091406.13992.54316.stgit@sofia.in.ibm.com>
References: <20090325091406.13992.54316.stgit@sofia.in.ibm.com>
Subject: [tip:sched/balancing] sched: Create helper to calculate small_imbalance in fbg()
Message-ID: <tip-2e6f44aeda426054fc58464df1ad571aecca0c92@git.kernel.org>
Git-Commit-ID: 2e6f44aeda426054fc58464df1ad571aecca0c92
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 09:46:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e6f44aeda426054fc58464df1ad571aecca0c92
Gitweb:     http://git.kernel.org/tip/2e6f44aeda426054fc58464df1ad571aecca0c92
Author:     Gautham R Shenoy <ego@in.ibm.com>
AuthorDate: Wed, 25 Mar 2009 14:44:06 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 10:30:47 +0100

sched: Create helper to calculate small_imbalance in fbg()

Impact: cleanup

We have two places in find_busiest_group() where we need to calculate
the minor imbalance before returning the busiest group. Encapsulate
this functionality into a seperate helper function.

Credit: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Balbir Singh" <balbir@in.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
LKML-Reference: <20090325091406.13992.54316.stgit@sofia.in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |  131 ++++++++++++++++++++++++++++++--------------------------
 1 files changed, 70 insertions(+), 61 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ec715f9..540147e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3484,6 +3484,71 @@ group_next:
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
@@ -3547,7 +3612,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	 */
 	if (sds.max_load < sds.avg_load) {
 		*imbalance = 0;
-		goto small_imbalance;
+		fix_small_imbalance(&sds, this_cpu, imbalance);
+		goto ret_busiest;
 	}
 
 	/* Don't want to pull so many tasks that a group would go idle */
@@ -3565,67 +3631,10 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
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

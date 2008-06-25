Return-Path: <linux-kernel-owner+w=401wt.eu-S1759598AbYFYPiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598AbYFYPiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYFYPiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:38:10 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:52000 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264AbYFYPiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:38:09 -0400
Date: Wed, 25 Jun 2008 21:09:47 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH] sched: Nominate the idle load balancer from a
	semi-idle group
Message-ID: <20080625153947.GA5922@in.ibm.com>
Reply-To: ego@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: Nominate the idle load balancer from a semi-idle group.

From: Gautham R Shenoy <ego@in.ibm.com>

This is an RFC Patch, not for inclusion!

Currently the first cpu in the nohz.cpu_mask is nominated as
the idle load balancer.
However, this also be a cpu from an idle group,
thereby not yiedling the expected power savings.

Improve the logic to pick an idle cpu from a semi-idle group
for performing the task of idle load balancing.

This patch did show a decent improvements for power-performance
benchmarks on a moderately loaded 4-socket quadcore system.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c |  122 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 113 insertions(+), 9 deletions(-)


diff --git a/kernel/sched.c b/kernel/sched.c
index 177efbe..7e41830 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3778,6 +3778,118 @@ static void run_rebalance_domains(struct softirq_action *h)
 #endif
 }
 
+#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+/*
+ * get_powersavings_sd: Returns the sched_domain for the cpu, where
+ *			powersavings load balancing is done.
+ * @cpu: The cpu whose powersavings sched domain is to be returned.
+ *
+ * powersavings sched domain of a cpu is one where we perform
+ * load balancing for powersavings.
+ * This domain would have the SD_POWERSAVINGS_BALANCE flag set.
+ */
+static struct sched_domain *get_powersavings_sd(int cpu)
+{
+	struct sched_domain *sd;
+
+	for_each_domain(cpu, sd)
+		if (sd->flags & SD_POWERSAVINGS_BALANCE)
+			return sd;
+
+	return NULL;
+}
+
+/*
+ * best_ilb: returns the best idle cpu which can do idle load balancing.
+ *
+ * An idle cpu is termed as the best idle cpu for load balancing, when it
+ * has atleast one non-idle sibling in its
+ * powersavings sched-domain (see get_powersavings_sd())
+ *
+ * We wouldn't want to pick the idle load balancer from a
+ * powersaving sched domain whose span-cpus are idle.
+ *
+ */
+static int best_ilb(void)
+{
+	struct sched_domain *sd;
+	cpumask_t search_mask = nohz.cpu_mask;
+	cpumask_t cpumask;
+	while (!cpus_empty(search_mask)) {
+		sd = get_powersavings_sd(first_cpu(search_mask));
+
+		cpus_and(cpumask, nohz.cpu_mask, sd->span);
+
+		/* If all the cpus in the domain are idle, skip this domain. */
+		if (cpus_equal(cpumask, sd->span)) {
+			cpus_andnot(search_mask, search_mask, cpumask);
+			continue;
+		}
+
+		return first_cpu(cpumask);
+	}
+
+	return -1;
+}
+
+/**
+ * find_new_ilb(): Find a new idle cpu to perform idle load balancing.
+ * @call_cpu: The cpu which is nominating the new idle load balancer.
+ *
+ * Finds a new idle cpu which can be nominated as the new
+ * idle load balancer, when the current idle load balancer is no longer idle.
+ *
+ * The algorithm checks if the call_cpu's
+ * powersavings_sched_domain (see get_powersavings_sd())
+ * contains an idle cpu. If yes, then it can take over the idle load
+ * balancer resposibility, since the package is not completely idle.
+ *
+ * Else, we obtain the best idle-load balancer(see best_ilb())
+ * which is an idle cpu from a semi-idle sched_domain.
+ *
+ * If there is no best idle-load balancer, we return the first cpu
+ * from the nohz.cpu_mask.
+ */
+static inline int find_new_ilb(int call_cpu)
+{
+	cpumask_t cpumask;
+	struct sched_domain *sd;
+	int ret_cpu = -1;
+
+	sd = get_powersavings_sd(call_cpu);
+
+	if (!sd)
+		goto default_ilb;
+
+	/*
+	 * First check if there exists an idle cpu in the call_cpu's
+	 * powersavings_sched_domain.
+	 */
+	cpus_and(cpumask, nohz.cpu_mask, sd->span);
+	ret_cpu = first_cpu(cpumask);
+
+	/* found one! */
+	if (ret_cpu < NR_CPUS)
+		goto done;
+
+	/* See if a best ilb exists */
+	ret_cpu = best_ilb();
+
+default_ilb:
+	if (ret_cpu < 0)
+		ret_cpu = first_cpu(nohz.cpu_mask);
+done:
+	return ret_cpu;
+
+}
+#else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
+static inline int find_new_ilb(int call_cpu)
+{
+	return first_cpu(nohz.cpu_mask);
+}
+
+#endif
+
 /*
  * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
  *
@@ -3802,15 +3914,7 @@ static inline void trigger_load_balance(struct rq *rq, int cpu)
 		}
 
 		if (atomic_read(&nohz.load_balancer) == -1) {
-			/*
-			 * simple selection for now: Nominate the
-			 * first cpu in the nohz list to be the next
-			 * ilb owner.
-			 *
-			 * TBD: Traverse the sched domains and nominate
-			 * the nearest cpu in the nohz.cpu_mask.
-			 */
-			int ilb = first_cpu(nohz.cpu_mask);
+			int ilb = find_new_ilb(cpu);
 
 			if (ilb < nr_cpu_ids)
 				resched_cpu(ilb);
-- 
Thanks and Regards
gautham

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbZDNE4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbZDNE4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 00:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbZDNEzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 00:55:48 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:36239 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbZDNEzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 00:55:46 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [RFC PATCH 2 1/2] sched: Nominate idle load balancer from a semi-idle
	package.
To: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, "Balbir Singh" <balbir@in.ibm.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Date: Tue, 14 Apr 2009 10:25:30 +0530
Message-ID: <20090414045530.7645.12175.stgit@sofia.in.ibm.com>
In-Reply-To: <20090414045356.7645.33369.stgit@sofia.in.ibm.com>
References: <20090414045356.7645.33369.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the nomination of idle-load balancer is done by choosing the first
idle cpu in the nohz.cpu_mask. This may not be power-efficient, since
such an idle cpu could come from a completely idle core/package thereby
preventing the whole core/package from being in a low-power state.

For eg, consider a quad-core dual package system. The cpu numbering need
not be sequential and can something like [0, 2, 4, 6] and [1, 3, 5, 7].
With sched_mc/smt_power_savings and the power-aware IRQ balance, we try to keep
as fewer Packages/Cores active. But the current idle load balancer logic
goes against this by choosing the first_cpu in the nohz.cpu_mask and not
taking the system topology into consideration.

Improve the algorithm to nominate the idle load balancer from a semi idle
cores/packages thereby increasing the probability of the cores/packages being
in deeper sleep states for longer duration.

The algorithm is activated only when sched_mc/smt_power_savings != 0.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c |  127 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 118 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 6cc1fd5..d702be7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4228,10 +4228,126 @@ static void active_load_balance(struct rq *busiest_rq, int busiest_cpu)
 static struct {
 	atomic_t load_balancer;
 	cpumask_var_t cpu_mask;
+	cpumask_var_t ilb_grp_nohz_mask;
 } nohz ____cacheline_aligned = {
 	.load_balancer = ATOMIC_INIT(-1),
 };
 
+#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+/**
+ * lowest_flag_domain - Return lowest sched_domain containing flag.
+ * @cpu:	The cpu whose lowest level of sched domain is to
+ *		be returned.
+ * @flag:	The flag to check for the lowest sched_domain
+ *		for the given cpu.
+ *
+ * Returns the lowest sched_domain of a cpu which contains the given flag.
+ */
+static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
+{
+	struct sched_domain *sd;
+
+	for_each_domain(cpu, sd)
+		if (sd && (sd->flags & flag))
+			break;
+
+	return sd;
+}
+
+/**
+ * for_each_flag_domain - Iterates over sched_domains containing the flag.
+ * @cpu:	The cpu whose domains we're iterating over.
+ * @sd:		variable holding the value of the power_savings_sd
+ *		for cpu.
+ * @flag:	The flag to filter the sched_domains to be iterated.
+ *
+ * Iterates over all the scheduler domains for a given cpu that has the 'flag'
+ * set, starting from the lowest sched_domain to the highest.
+ */
+#define for_each_flag_domain(cpu, sd, flag) \
+	for (sd = lowest_flag_domain(cpu, flag); \
+		(sd && (sd->flags & flag)); sd = sd->parent)
+
+/**
+ * is_semi_idle_group - Checks if the given sched_group is semi-idle.
+ * @ilb_group:	group to be checked for semi-idleness
+ *
+ * Returns:	1 if the group is semi-idle. 0 otherwise.
+ *
+ * We define a sched_group to be semi idle if it has atleast one idle-CPU
+ * and atleast one non-idle CPU. This helper function checks if the given
+ * sched_group is semi-idle or not.
+ */
+static inline int is_semi_idle_group(struct sched_group *ilb_group)
+{
+	cpumask_and(nohz.ilb_grp_nohz_mask, nohz.cpu_mask,
+					sched_group_cpus(ilb_group));
+
+	/*
+	 * A sched_group is semi-idle when it has atleast one busy cpu
+	 * and atleast one idle cpu.
+	 */
+	if (cpumask_empty(nohz.ilb_grp_nohz_mask))
+		return 0;
+
+	if (cpumask_equal(nohz.ilb_grp_nohz_mask, sched_group_cpus(ilb_group)))
+		return 0;
+
+	return 1;
+}
+/**
+ * find_new_ilb - Finds the optimum idle load balancer for nomination.
+ * @cpu:	The cpu which is nominating a new idle_load_balancer.
+ *
+ * Returns:	Returns the id of the idle load balancer if it exists,
+ *		Else, returns >= nr_cpu_ids.
+ *
+ * This algorithm picks the idle load balancer such that it belongs to a
+ * semi-idle powersavings sched_domain. The idea is to try and avoid
+ * completely idle packages/cores just for the purpose of idle load balancing
+ * when there are other idle cpu's which are better suited for that job.
+ */
+static int find_new_ilb(int cpu)
+{
+	struct sched_domain *sd;
+	struct sched_group *ilb_group;
+
+	/*
+	 * Have idle load balancer selection from semi-idle packages only
+	 * when power-aware load balancing is enabled
+	 */
+	if (!(sched_smt_power_savings || sched_mc_power_savings))
+		goto out_done;
+
+	/*
+	 * Optimize for the case when we have no idle CPUs or only one
+	 * idle CPU. Don't walk the sched_domain hierarchy in such cases
+	 */
+	if (cpumask_weight(nohz.cpu_mask) < 2)
+		goto out_done;
+
+	for_each_flag_domain(cpu, sd, SD_POWERSAVINGS_BALANCE) {
+		ilb_group = sd->groups;
+
+		do {
+			if (is_semi_idle_group(ilb_group))
+				return cpumask_first(nohz.ilb_grp_nohz_mask);
+
+			ilb_group = ilb_group->next;
+
+		} while (ilb_group != sd->groups);
+	}
+
+out_done:
+	return cpumask_first(nohz.cpu_mask);
+}
+#else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
+static inline int find_new_ilb(int call_cpu)
+{
+	return first_cpu(nohz.cpu_mask);
+}
+#endif
+
 /*
  * This routine will try to nominate the ilb (idle load balancing)
  * owner among the cpus whose ticks are stopped. ilb owner will do the idle
@@ -4456,15 +4572,7 @@ static inline void trigger_load_balance(struct rq *rq, int cpu)
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
-			int ilb = cpumask_first(nohz.cpu_mask);
+			int ilb = find_new_ilb(cpu);
 
 			if (ilb < nr_cpu_ids)
 				resched_cpu(ilb);
@@ -8985,6 +9093,7 @@ void __init sched_init(void)
 #ifdef CONFIG_SMP
 #ifdef CONFIG_NO_HZ
 	alloc_bootmem_cpumask_var(&nohz.cpu_mask);
+	alloc_bootmem_cpumask_var(&nohz.ilb_grp_nohz_mask);
 #endif
 	alloc_bootmem_cpumask_var(&cpu_isolated_map);
 #endif /* SMP */


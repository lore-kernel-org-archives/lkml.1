Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbZBPQvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbZBPQvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 11:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbZBPQvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 11:51:22 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:44516 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbZBPQvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:51:21 -0500
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH 2/3] sched: Fix the wakeup nomination for
	sched_mc/smt_power_savings.
To: linux-kernel@vger.kernel.org, svaidy@linux.vnet.ibm.com, mingo@elte.hu,
       a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, ego@in.ibm.com
Cc: balbir@in.ibm.com, dipankar@in.ibm.com, efault@gmx.de, andi@firstfloor.org,
       Gautham R Shenoy <ego@in.ibm.com>
Date: Mon, 16 Feb 2009 22:21:11 +0530
Message-ID: <20090216165111.12804.41620.stgit@sofia.in.ibm.com>
In-Reply-To: <20090216164719.12804.37013.stgit@sofia.in.ibm.com>
References: <20090216164719.12804.37013.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing algorithm to nominate a preferred wake up cpu would not
work on a machine which has both sched_mc_power_savings and
sched_smt_power_savings enabled. On such machines, the nomination at a lower
level would keep overwriting the nominations by it's peer-level as well as
higher level sched_domains. This would lead to the ping-ponging of the
nominated wake-up cpu, thereby preventing us from effectively consolidating
tasks.

Correct this by defining the authorized nomination sched_domain level, which
is either the highest sched_domain level containing the
SD_POWERSAVINGS_BALANCE flag or a lower level which contains the previously
nominated wake-up cpu in it's span.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 include/linux/sched.h |    1 +
 kernel/sched.c        |   43 ++++++++++++++++++++++++++++++++++++++++---
 kernel/sched_fair.c   |    2 +-
 3 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 06c5c6c..9827297 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -776,6 +776,7 @@ enum powersavings_balance_level {
 };
 
 extern int sched_mc_power_savings, sched_smt_power_savings;
+extern enum powersavings_balance_level active_power_savings_level;
 
 enum sched_domain_level {
 	SD_LV_NONE = 0,
diff --git a/kernel/sched.c b/kernel/sched.c
index 52bbf1c..af88f5a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -520,6 +520,11 @@ struct root_domain {
 	 * low system utilisation. Triggered at POWERSAVINGS_BALANCE_WAKEUP(2)
 	 */
 	unsigned int sched_mc_preferred_wakeup_cpu;
+	/*
+	 * The sched-domain level which is authorized to nominate the preferred
+	 * wake up cpu.
+	 */
+	enum sched_domain_level authorized_nomination_level;
 #endif
 };
 
@@ -3397,9 +3402,17 @@ out_balanced:
 		goto ret;
 
 	if (this == group_leader && group_leader != group_min) {
+		struct root_domain *my_rd = cpu_rq(this_cpu)->rd;
 		*imbalance = min_load_per_task;
-		if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP) {
-			cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
+		/*
+		 * The preferred wakeup cpu should be nominated by power-aware
+		 * sched-domains which contain the currently nominated cpu.
+		 */
+		if (sd->level == my_rd->authorized_nomination_level ||
+			(sd->level < my_rd->authorized_nomination_level &&
+			cpu_isset(my_rd->sched_mc_preferred_wakeup_cpu,
+					*sched_domain_span(sd)))) {
+			my_rd->sched_mc_preferred_wakeup_cpu =
 				cpumask_first(sched_group_cpus(group_leader));
 		}
 		return group_min;
@@ -3683,7 +3696,8 @@ redo:
 		    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
 			return -1;
 
-		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
+		if (active_power_savings_level <
+				POWERSAVINGS_BALANCE_WAKEUP)
 			return -1;
 
 		if (sd->nr_balance_failed++ < 2)
@@ -7192,6 +7206,7 @@ static void sched_domain_node_span(int node, struct cpumask *span)
 #endif /* CONFIG_NUMA */
 
 int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
+enum powersavings_balance_level active_power_savings_level;
 
 /*
  * The cpus mask in sched_group and sched_domain hangs off the end.
@@ -7781,6 +7796,25 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 
 	err = 0;
 
+/* Assign the sched-domain level which can nominate preferred wake-up cpu */
+	rd->sched_mc_preferred_wakeup_cpu = UINT_MAX;
+	rd->authorized_nomination_level = SD_LV_NONE;
+
+	if (active_power_savings_level >= POWERSAVINGS_BALANCE_WAKEUP) {
+		struct sched_domain *sd;
+		enum sched_domain_level authorized_nomination_level =
+								SD_LV_NONE;
+
+		for_each_domain(first_cpu(*cpu_map), sd) {
+			if (!(sd->flags & SD_POWERSAVINGS_BALANCE))
+				continue;
+			authorized_nomination_level = sd->level;
+		}
+
+		rd->authorized_nomination_level = authorized_nomination_level;
+	}
+
+
 free_tmpmask:
 	free_cpumask_var(tmpmask);
 free_send_covered:
@@ -8027,6 +8061,9 @@ static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
 	else
 		sched_mc_power_savings = level;
 
+	active_power_savings_level = max(sched_smt_power_savings,
+						sched_mc_power_savings);
+
 	arch_reinit_sched_domains();
 
 	return count;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5cc1c16..bddee3e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1042,7 +1042,7 @@ static int wake_idle(int cpu, struct task_struct *p)
 	chosen_wakeup_cpu =
 		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu;
 
-	if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP &&
+	if (active_power_savings_level >= POWERSAVINGS_BALANCE_WAKEUP &&
 		idle_cpu(cpu) && idle_cpu(this_cpu) &&
 		p->mm && !(p->flags & PF_KTHREAD) &&
 		cpu_isset(chosen_wakeup_cpu, p->cpus_allowed))


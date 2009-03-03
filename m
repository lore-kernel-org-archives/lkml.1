Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbZCCLwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbZCCLwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbZCCLv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:51:59 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:57262 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512AbZCCLv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:51:58 -0500
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH 2 2/3] sched: Fix the wakeup nomination for
	sched_mc/smt_power_savings.
To: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>,
       "Balbir Singh" <balbir@in.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>
Cc: "Dipankar Sarma" <dipankar@in.ibm.com>, efault@gmx.de, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Tue, 03 Mar 2009 17:21:49 +0530
Message-ID: <20090303115149.605.92140.stgit@sofia.in.ibm.com>
In-Reply-To: <20090303114648.605.86920.stgit@sofia.in.ibm.com>
References: <20090303114648.605.86920.stgit@sofia.in.ibm.com>
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
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 include/linux/sched.h |    1 +
 kernel/sched.c        |   74 +++++++++++++++++++++++++++++++++++++++++++++----
 kernel/sched_fair.c   |    2 +
 3 files changed, 70 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 362807a..7f66595 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -776,6 +776,7 @@ enum powersavings_balance_level {
 };
 
 extern int sched_mc_power_savings, sched_smt_power_savings;
+extern enum powersavings_balance_level active_power_savings_level;
 
 enum sched_domain_level {
 	SD_LV_NONE = 0,
diff --git a/kernel/sched.c b/kernel/sched.c
index 52bbf1c..7d22a96 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -515,11 +515,22 @@ struct root_domain {
 #endif
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 	/*
-	 * Preferred wake up cpu nominated by sched_mc balance that will be
-	 * used when most cpus are idle in the system indicating overall very
-	 * low system utilisation. Triggered at POWERSAVINGS_BALANCE_WAKEUP(2)
+	 * Preferred wake up cpu which is nominated by load balancer,
+	 * is the CPU on which the tasks would be woken up, which
+	 * otherwise would have woken up on an idle CPU even on a system
+	 * with low-cpu-utilization.
+	 * This is triggered at POWERSAVINGS_BALANCE_WAKEUP(2).
 	 */
 	unsigned int sched_mc_preferred_wakeup_cpu;
+	/*
+	 * authorized_nomination_level records the sched-domain level, which can
+	 * in the process of load-balancing nominate the
+	 * sched_mc_preferred_wakeup_cpu.
+	 *
+	 * This helps in serializing the nominations thereby preventing
+	 * multiple sched-domain levels overwriting each others' nominations.
+	 */
+	enum sched_domain_level authorized_nomination_level;
 #endif
 };
 
@@ -3090,6 +3101,22 @@ static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
  * find_busiest_group finds and returns the busiest CPU group within the
  * domain. It calculates and returns the amount of weighted load which
  * should be moved to restore balance via the imbalance parameter.
+ *
+ * Power-savings-balance: If the user has enabled the option to save power
+ * by means of task consolidation, then at the corresponding sched_domains,
+ * the SD_POWERSAVINGS_BALANCE flag will be set.
+ *
+ * Within such sched_domains, find_busiest_group would try to identify
+ * a sched_group which can be freed-up and it's tasks can be migrated to
+ * another group which has the capacity to accomodate the former's tasks.
+ * If such a "can-go-idle" sched_groups does exist, then the group which can
+ * accomodate it's tasks is returned as the busiest group.
+ *
+ * Furthermore, if the user opts for more aggressive power-aware load
+ * balancing, i.e when the active_power_savings_level greater or equal to
+ * POWERSAVINGS_BALANCE_WAKEUP, find_busiest_group will also nominate
+ * the preferred CPU, on which the tasks should hence forth
+ * be woken up on, instead of bothering an idle-cpu.
  */
 static struct sched_group *
 find_busiest_group(struct sched_domain *sd, int this_cpu,
@@ -3397,9 +3424,18 @@ out_balanced:
 		goto ret;
 
 	if (this == group_leader && group_leader != group_min) {
+		struct root_domain *my_rd = cpu_rq(this_cpu)->rd;
 		*imbalance = min_load_per_task;
-		if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP) {
-			cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
+		/*
+		 * Nominate the the preferred wakeup cpu only if this
+		 * sched_domain is authorized to do so, or if this sched_domain
+		 * contains the previously nominated cpu.
+		 */
+		if (sd->level == my_rd->authorized_nomination_level ||
+			(sd->level < my_rd->authorized_nomination_level &&
+			cpu_isset(my_rd->sched_mc_preferred_wakeup_cpu,
+					*sched_domain_span(sd)))) {
+			my_rd->sched_mc_preferred_wakeup_cpu =
 				cpumask_first(sched_group_cpus(group_leader));
 		}
 		return group_min;
@@ -3683,7 +3719,8 @@ redo:
 		    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
 			return -1;
 
-		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
+		if (active_power_savings_level <
+				POWERSAVINGS_BALANCE_WAKEUP)
 			return -1;
 
 		if (sd->nr_balance_failed++ < 2)
@@ -7193,6 +7230,9 @@ static void sched_domain_node_span(int node, struct cpumask *span)
 
 int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
 
+/* Records the currently active power saving level. */
+enum powersavings_balance_level active_power_savings_level;
+
 /*
  * The cpus mask in sched_group and sched_domain hangs off the end.
  * FIXME: use cpumask_var_t or dynamic percpu alloc to avoid wasting space
@@ -7781,6 +7821,25 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 
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
@@ -8027,6 +8086,9 @@ static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
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


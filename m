Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbZCFGaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbZCFGaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZCFG3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:29:16 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:55658 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbZCFG3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:29:15 -0500
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH V3 2/6] sched: Record the current active power savings level
To: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>,
       "Balbir Singh" <balbir@in.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>
Cc: "Dipankar Sarma" <dipankar@in.ibm.com>, efault@gmx.de, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 06 Mar 2009 11:59:00 +0530
Message-ID: <20090306062859.9445.46016.stgit@sofia.in.ibm.com>
In-Reply-To: <20090306060513.9445.28732.stgit@sofia.in.ibm.com>
References: <20090306060513.9445.28732.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current active power savings level of a system is defined as the
maximum of the sched_mc_power_savings and the sched_smt_power_savings.

The decisions during power-aware loadbalancing, depend on this value.

Record this value in a read mostly global variable instead of having to
compute it everytime.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

 include/linux/sched.h |    1 +
 kernel/sched.c        |    8 ++++++--
 kernel/sched_fair.c   |    2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 73aea7b..8563698 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -793,6 +793,7 @@ enum powersavings_balance_level {
 };
 
 extern int sched_mc_power_savings, sched_smt_power_savings;
+extern enum powersavings_balance_level active_power_savings_level;
 
 enum sched_domain_level {
 	SD_LV_NONE = 0,
diff --git a/kernel/sched.c b/kernel/sched.c
index 410eec4..4629bb1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3398,7 +3398,7 @@ out_balanced:
 
 	if (this == group_leader && group_leader != group_min) {
 		*imbalance = min_load_per_task;
-		if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP) {
+		if (active_power_savings_level >= POWERSAVINGS_BALANCE_WAKEUP) {
 			cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
 				cpumask_first(sched_group_cpus(group_leader));
 		}
@@ -3683,7 +3683,7 @@ redo:
 		    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
 			return -1;
 
-		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
+		if (active_power_savings_level < POWERSAVINGS_BALANCE_WAKEUP)
 			return -1;
 
 		if (sd->nr_balance_failed++ < 2)
@@ -7206,6 +7206,8 @@ static void sched_domain_node_span(int node, struct cpumask *span)
 #endif /* CONFIG_NUMA */
 
 int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
+/* Records the currently active power savings level */
+enum powersavings_balance_level __read_mostly active_power_savings_level;
 
 /*
  * The cpus mask in sched_group and sched_domain hangs off the end.
@@ -8040,6 +8042,8 @@ static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
 		sched_smt_power_savings = level;
 	else
 		sched_mc_power_savings = level;
+	active_power_savings_level = max(sched_smt_power_savings,
+						sched_mc_power_savings);
 
 	arch_reinit_sched_domains();
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0566f2a..a3583c6 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1054,7 +1054,7 @@ static int wake_idle(int cpu, struct task_struct *p)
 	chosen_wakeup_cpu =
 		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu;
 
-	if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP &&
+	if (active_power_savings_level >= POWERSAVINGS_BALANCE_WAKEUP &&
 		idle_cpu(cpu) && idle_cpu(this_cpu) &&
 		p->mm && !(p->flags & PF_KTHREAD) &&
 		cpu_isset(chosen_wakeup_cpu, p->cpus_allowed))


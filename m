Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbZCaKvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbZCaKvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 06:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbZCaKua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 06:50:30 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:56209 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbZCaKu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 06:50:29 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH v4 2/5] sched: Record the current active power savings level
To: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Balbir Singh" <balbir@in.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Date: Tue, 31 Mar 2009 16:20:22 +0530
Message-ID: <20090331105022.16414.4304.stgit@sofia.in.ibm.com>
In-Reply-To: <20090331104829.16414.11385.stgit@sofia.in.ibm.com>
References: <20090331104829.16414.11385.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing load balancer code is dependent on the sched_mc_power_savings
variable. However, on multi-core + multi-threaded machines, these decisions
need to be dependent on the values of both sched_mc_power_savings and
sched_smt_power_savings.

Create a new variable named active_power_savings_level which is the
maximum of the sched_mc_power_savings and sched_smt_power_savings.

Record this value in a read mostly global variable at the time when the user
changes the value of sched_mc/smt_power_savings tunable, and use it for
load-balancing decisions instead of computing it everytime.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 include/linux/sched.h |    1 +
 kernel/sched.c        |    8 ++++++--
 kernel/sched_fair.c   |    2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8aaf276..1b1cab4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -802,6 +802,7 @@ enum powersavings_balance_level {
 };
 
 extern int sched_mc_power_savings, sched_smt_power_savings;
+extern enum powersavings_balance_level active_power_savings_level;
 
 enum sched_domain_level {
 	SD_LV_NONE = 0,
diff --git a/kernel/sched.c b/kernel/sched.c
index 706517c..07b774e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3450,7 +3450,7 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
 	*imbalance = sds->min_load_per_task;
 	sds->busiest = sds->group_min;
 
-	if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP) {
+	if (active_power_savings_level >= POWERSAVINGS_BALANCE_WAKEUP) {
 		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
 			group_first_cpu(sds->group_leader);
 	}
@@ -4120,7 +4120,7 @@ redo:
 		    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
 			return -1;
 
-		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
+		if (active_power_savings_level < POWERSAVINGS_BALANCE_WAKEUP)
 			return -1;
 
 		if (sd->nr_balance_failed++ < 2)
@@ -7741,6 +7741,8 @@ static void sched_domain_node_span(int node, struct cpumask *span)
 #endif /* CONFIG_NUMA */
 
 int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
+/* Records the currently active power savings level */
+enum powersavings_balance_level __read_mostly active_power_savings_level;
 
 /*
  * The cpus mask in sched_group and sched_domain hangs off the end.
@@ -8575,6 +8577,8 @@ static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
 		sched_smt_power_savings = level;
 	else
 		sched_mc_power_savings = level;
+	active_power_savings_level = max(sched_smt_power_savings,
+						sched_mc_power_savings);
 
 	arch_reinit_sched_domains();
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3816f21..02324d2 100644
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


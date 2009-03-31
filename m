Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbZCaKvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbZCaKvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 06:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbZCaKuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 06:50:35 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:49188 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbZCaKue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 06:50:34 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH v4 3/5] sched: Rename the variable
	sched_mc_preferred_wakeup_cpu
To: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Balbir Singh" <balbir@in.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Date: Tue, 31 Mar 2009 16:20:27 +0530
Message-ID: <20090331105027.16414.21798.stgit@sofia.in.ibm.com>
In-Reply-To: <20090331104829.16414.11385.stgit@sofia.in.ibm.com>
References: <20090331104829.16414.11385.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_mc_preferred_wakeup_cpu is currently used when the user seeks
power savings through aggressive task consolidation.

But this functionality is applicable for both sched_mc_power_savings as
well as sched_smt_power_savings. So rename
sched_mc_preferred_wakeup_cpu to preferred_wakeup_cpu.

Also fix the comment for preferred_wakeup_cpu.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c      |   12 +++++++-----
 kernel/sched_fair.c |    2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 07b774e..36d116b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -542,11 +542,13 @@ struct root_domain {
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
-	unsigned int sched_mc_preferred_wakeup_cpu;
+	unsigned int preferred_wakeup_cpu;
 #endif
 };
 
@@ -3451,7 +3453,7 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
 	sds->busiest = sds->group_min;
 
 	if (active_power_savings_level >= POWERSAVINGS_BALANCE_WAKEUP) {
-		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
+		cpu_rq(this_cpu)->rd->preferred_wakeup_cpu =
 			group_first_cpu(sds->group_leader);
 	}
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 02324d2..dacb0d8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1052,7 +1052,7 @@ static int wake_idle(int cpu, struct task_struct *p)
 
 	this_cpu = smp_processor_id();
 	chosen_wakeup_cpu =
-		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu;
+		cpu_rq(this_cpu)->rd->preferred_wakeup_cpu;
 
 	if (active_power_savings_level >= POWERSAVINGS_BALANCE_WAKEUP &&
 		idle_cpu(cpu) && idle_cpu(this_cpu) &&


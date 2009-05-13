Return-Path: <linux-kernel-owner+w=401wt.eu-S1760406AbZEMNL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760406AbZEMNL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759943AbZEMNLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:11:33 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:32920 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760275AbZEMNLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:11:32 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 2/2] sched: loadbalancer hacks for forced packing of
	tasks
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 13 May 2009 18:41:20 +0530
Message-ID: <20090513131120.21440.81600.stgit@drishya.in.ibm.com>
In-Reply-To: <20090513130541.21440.33364.stgit@drishya.in.ibm.com>
References: <20090513130541.21440.33364.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pack more tasks in a group so as to reduce number of CPUs
used to run the work in the system.

Just for load balancing purpose, assume the group capacity
has been increased by group_capacity_bump()

Hacks:

o Make non-idle cpus also perform powersave balance so
  that we can pull more tasks into the group
o Increase group capacity for calculation
o Increase load-balancing threshold so that even if a
  group is overloaded by group_capacity_bump(), consider
  it balanced

Basically if we want to evacuate 2 cores, the group capacity
is increased by 2 (*SCHED_LOAD_SCALE) and the power save
balancer will accommodate the tasks after selecting the group
leader.

This will not work if the system is overloaded. Even
after pulling 2 extra tasks, there could be tasks to fill the
other package.  At this point we are not yet reducing the
group capacity of the other group.

*** RFC patch for discussion ***

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 kernel/sched.c |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f22b9f6..186b0ec 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3234,6 +3234,7 @@ struct sd_lb_stats {
 	int group_imb; /* Is there imbalance in this sd */
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 	int power_savings_balance; /* Is powersave balance needed for this sd */
+	unsigned int group_capacity_bump; /* % increase in group capacity */
 	struct sched_group *group_min; /* Least loaded group in sd */
 	struct sched_group *group_leader; /* Group which relieves group_min */
 	unsigned long min_load_per_task; /* load_per_task in group_min */
@@ -3294,6 +3295,15 @@ static inline int get_sd_load_idx(struct sched_domain *sd,
 
 int sched_evacuate_cores; /* No of forced-idle cores */
 
+static inline unsigned int group_capacity_bump(struct sched_domain *sd)
+{
+
+	if (sd->flags & SD_POWERSAVINGS_BALANCE)
+		return sched_evacuate_cores;
+
+	return 0;
+}
+
 /**
  * init_sd_power_savings_stats - Initialize power savings statistics for
  * the given sched_domain, during load balancing.
@@ -3309,12 +3319,14 @@ static inline void init_sd_power_savings_stats(struct sched_domain *sd,
 	 * Busy processors will not participate in power savings
 	 * balance.
 	 */
-	if (idle == CPU_NOT_IDLE || !(sd->flags & SD_POWERSAVINGS_BALANCE))
+	if ((idle == CPU_NOT_IDLE && !sched_evacuate_cores) ||
+		!(sd->flags & SD_POWERSAVINGS_BALANCE))
 		sds->power_savings_balance = 0;
 	else {
 		sds->power_savings_balance = 1;
 		sds->min_nr_running = ULONG_MAX;
 		sds->leader_nr_running = 0;
+		sds->group_capacity_bump = group_capacity_bump(sd);
 	}
 }
 
@@ -3436,6 +3448,12 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
 {
 	return 0;
 }
+
+static inline unsigned int group_capacity_bump(struct sched_domain *sd)
+{
+	return 0;
+}
+
 #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
 
 
@@ -3568,6 +3586,8 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 
 		if (local_group && balance && !(*balance))
 			return;
+		/* Bump up group capacity for forced packing of tasks */
+		sgs.group_capacity += sds->group_capacity_bump;
 
 		sds->total_load += sgs.group_load;
 		sds->total_pwr += group->__cpu_power;
@@ -3768,6 +3788,12 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
 		goto out_balanced;
 
+	/* Push the upper limits for overload */
+	if (sds.max_load <= (sds.busiest->__cpu_power +
+				sds.group_capacity_bump * SCHED_LOAD_SCALE) /
+				sds.busiest->__cpu_power * SCHED_LOAD_SCALE)
+		goto out_balanced;
+
 	sds.busiest_load_per_task /= sds.busiest_nr_running;
 	if (sds.group_imb)
 		sds.busiest_load_per_task =


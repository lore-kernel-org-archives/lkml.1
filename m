Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbZDZUri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbZDZUri (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 16:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756420AbZDZUrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 16:47:08 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:34077 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467AbZDZUrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 16:47:06 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v1 3/3] sched: loadbalancer hacks for forced packing of
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
Date: Mon, 27 Apr 2009 02:17:07 +0530
Message-ID: <20090426204707.17495.89167.stgit@drishya.in.ibm.com>
In-Reply-To: <20090426204029.17495.46609.stgit@drishya.in.ibm.com>
References: <20090426204029.17495.46609.stgit@drishya.in.ibm.com>
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
has been increased by group_capacity_bump_pct()

Hacks:

o Make non-idle cpus also perform powersave balance so
  that we can pull more tasks into the group
o Increase group capacity for calculation
o Increase load-balancing threshold so that even if a
  group is loaded by group_capacity_bump_pct, consider
  it balanced

*** RFC patch for discussion ***

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 kernel/sched.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f88ed04..b20dbcb 100644
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
@@ -3321,12 +3322,16 @@ static inline void init_sd_power_savings_stats(struct sched_domain *sd,
 	 * Busy processors will not participate in power savings
 	 * balance.
 	 */
-	if (idle == CPU_NOT_IDLE || !(sd->flags & SD_POWERSAVINGS_BALANCE))
+	if ((idle == CPU_NOT_IDLE &&
+		sched_mc_power_savings <
+		POWERSAVINGS_INCREASE_GROUP_CAPACITY_1) ||
+		!(sd->flags & SD_POWERSAVINGS_BALANCE))
 		sds->power_savings_balance = 0;
 	else {
 		sds->power_savings_balance = 1;
 		sds->min_nr_running = ULONG_MAX;
 		sds->leader_nr_running = 0;
+		sds->group_capacity_bump = group_capacity_bump_pct(sd);
 	}
 }
 
@@ -3586,6 +3591,9 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 
 		if (local_group && balance && !(*balance))
 			return;
+		/* Bump up group capacity for forced packing of tasks */
+		sgs.group_capacity = sgs.group_capacity *
+				sds->group_capacity_bump / 100;
 
 		sds->total_load += sgs.group_load;
 		sds->total_pwr += group->__cpu_power;
@@ -3786,6 +3794,10 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
 		goto out_balanced;
 
+	/* Push the upper limits for overload */
+	if (100 * sds.max_load <= sds.group_capacity_bump * SCHED_LOAD_SCALE)
+		goto out_balanced;
+
 	sds.busiest_load_per_task /= sds.busiest_nr_running;
 	if (sds.group_imb)
 		sds.busiest_load_per_task =


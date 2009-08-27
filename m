Return-Path: <linux-kernel-owner+w=401wt.eu-S1752108AbZH0PJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbZH0PJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 11:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbZH0PJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 11:09:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39823 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZH0PJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 11:09:21 -0400
Message-Id: <20090827150523.978071021@chello.nl>
References: <20090827150051.846026837@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 27 Aug 2009 17:00:54 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 3/6] sched: update the cpu_power sum during load-balance
Content-Disposition: inline; filename=sched-lb-3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to prepare for a more dynamic cpu_power, update the group sum
while walking the sched domains during load-balance.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/sched.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3691,6 +3691,31 @@ static inline int check_power_save_busie
 }
 #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
 
+static void update_sched_power(struct sched_domain *sd)
+{
+	struct sched_domain *child = sd->child;
+	struct sched_group *group, *sdg = sd->groups;
+	unsigned long power = sdg->__cpu_power;
+
+	if (!child) {
+		/* compute cpu power for this cpu */
+		return;
+	}
+
+	sdg->__cpu_power = 0;
+
+	group = child->groups;
+	do {
+		sdg->__cpu_power += group->__cpu_power;
+		group = group->next;
+	} while (group != child->groups);
+
+	if (sdg->__cpu_power < SCHED_LOAD_SCALE)
+		sdg->__cpu_power = SCHED_LOAD_SCALE;
+
+	if (power != sdg->__cpu_power)
+		sdg->reciprocal_cpu_power = reciprocal_value(sdg->__cpu_power);
+}
 
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
@@ -3715,8 +3740,11 @@ static inline void update_sg_lb_stats(st
 	unsigned long sum_avg_load_per_task;
 	unsigned long avg_load_per_task;
 
-	if (local_group)
+	if (local_group) {
 		balance_cpu = group_first_cpu(group);
+		if (balance_cpu == this_cpu)
+			update_sched_power(sd);
+	}
 
 	/* Tally up the load of all CPUs in the group */
 	sum_avg_load_per_task = avg_load_per_task = 0;
@@ -3855,7 +3883,6 @@ static inline void update_sd_lb_stats(st
 		update_sd_power_savings_stats(group, sds, local_group, &sgs);
 		group = group->next;
 	} while (group != sd->groups);
-
 }
 
 /**

-- 


Return-Path: <linux-kernel-owner+w=401wt.eu-S933265AbZIDIz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265AbZIDIz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932984AbZIDIzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:55:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:36632 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675AbZIDIzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:55:53 -0400
Date: Fri, 4 Sep 2009 08:55:24 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, andreas.herrmann3@amd.com, a.p.zijlstra@chello.nl,
       balbir@in.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: balbir@in.ibm.com, mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090901083825.985050292@chello.nl>
References: <20090901083825.985050292@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/balancing] sched: Update the cpu_power sum during load-balance
Message-ID: <tip-cc9fba7d7672fa3ed58d9d9ecb6c45b1351c29a6@git.kernel.org>
Git-Commit-ID: cc9fba7d7672fa3ed58d9d9ecb6c45b1351c29a6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 08:55:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc9fba7d7672fa3ed58d9d9ecb6c45b1351c29a6
Gitweb:     http://git.kernel.org/tip/cc9fba7d7672fa3ed58d9d9ecb6c45b1351c29a6
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 1 Sep 2009 10:34:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 10:09:53 +0200

sched: Update the cpu_power sum during load-balance

In order to prepare for a more dynamic cpu_power, update the
group sum while walking the sched domains during load-balance.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
LKML-Reference: <20090901083825.985050292@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   33 +++++++++++++++++++++++++++++----
 1 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9d64cec..ecb4a47 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3699,6 +3699,28 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
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
+	if (power != sdg->__cpu_power)
+		sdg->reciprocal_cpu_power = reciprocal_value(sdg->__cpu_power);
+}
 
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
@@ -3712,7 +3734,8 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
  * @balance: Should we balance.
  * @sgs: variable to hold the statistics for this group.
  */
-static inline void update_sg_lb_stats(struct sched_group *group, int this_cpu,
+static inline void update_sg_lb_stats(struct sched_domain *sd,
+			struct sched_group *group, int this_cpu,
 			enum cpu_idle_type idle, int load_idx, int *sd_idle,
 			int local_group, const struct cpumask *cpus,
 			int *balance, struct sg_lb_stats *sgs)
@@ -3723,8 +3746,11 @@ static inline void update_sg_lb_stats(struct sched_group *group, int this_cpu,
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
@@ -3828,7 +3854,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 		local_group = cpumask_test_cpu(this_cpu,
 					       sched_group_cpus(group));
 		memset(&sgs, 0, sizeof(sgs));
-		update_sg_lb_stats(group, this_cpu, idle, load_idx, sd_idle,
+		update_sg_lb_stats(sd, group, this_cpu, idle, load_idx, sd_idle,
 				local_group, cpus, balance, &sgs);
 
 		if (local_group && balance && !(*balance))
@@ -3863,7 +3889,6 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 		update_sd_power_savings_stats(group, sds, local_group, &sgs);
 		group = group->next;
 	} while (group != sd->groups);
-
 }
 
 /**

Return-Path: <linux-kernel-owner+w=401wt.eu-S933273AbZIDI45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbZIDI45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933031AbZIDI4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:56:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:36697 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933024AbZIDI4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:56:52 -0400
Date: Fri, 4 Sep 2009 08:56:14 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, andreas.herrmann3@amd.com, a.p.zijlstra@chello.nl,
       balbir@in.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: balbir@in.ibm.com, mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090901083826.342231003@chello.nl>
References: <20090901083826.342231003@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/balancing] sched: Try to deal with low capacity
Message-ID: <tip-bdb94aa5dbd8b55e75f5a50b61312fe589e2c2d1@git.kernel.org>
Git-Commit-ID: bdb94aa5dbd8b55e75f5a50b61312fe589e2c2d1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 08:56:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bdb94aa5dbd8b55e75f5a50b61312fe589e2c2d1
Gitweb:     http://git.kernel.org/tip/bdb94aa5dbd8b55e75f5a50b61312fe589e2c2d1
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 1 Sep 2009 10:34:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 10:09:55 +0200

sched: Try to deal with low capacity

When the capacity drops low, we want to migrate load away.
Allow the load-balancer to remove all tasks when we hit rock
bottom.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
LKML-Reference: <20090901083826.342231003@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   33 ++++++++++++++++++++++++++++-----
 1 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ab532b5..5f5b359 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3908,8 +3908,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
 		sgs->group_imb = 1;
 
-	sgs->group_capacity = group->__cpu_power / SCHED_LOAD_SCALE;
-
+	sgs->group_capacity =
+		DIV_ROUND_CLOSEST(group->__cpu_power, SCHED_LOAD_SCALE);
 }
 
 /**
@@ -3959,7 +3959,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 		 * and move all the excess tasks away.
 		 */
 		if (prefer_sibling)
-			sgs.group_capacity = 1;
+			sgs.group_capacity = min(sgs.group_capacity, 1UL);
 
 		if (local_group) {
 			sds->this_load = sgs.avg_load;
@@ -4191,6 +4191,26 @@ ret:
 	return NULL;
 }
 
+static struct sched_group *group_of(int cpu)
+{
+	struct sched_domain *sd = rcu_dereference(cpu_rq(cpu)->sd);
+
+	if (!sd)
+		return NULL;
+
+	return sd->groups;
+}
+
+static unsigned long power_of(int cpu)
+{
+	struct sched_group *group = group_of(cpu);
+
+	if (!group)
+		return SCHED_LOAD_SCALE;
+
+	return group->__cpu_power;
+}
+
 /*
  * find_busiest_queue - find the busiest runqueue among the cpus in group.
  */
@@ -4203,15 +4223,18 @@ find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
 	int i;
 
 	for_each_cpu(i, sched_group_cpus(group)) {
+		unsigned long power = power_of(i);
+		unsigned long capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
 		unsigned long wl;
 
 		if (!cpumask_test_cpu(i, cpus))
 			continue;
 
 		rq = cpu_rq(i);
-		wl = weighted_cpuload(i);
+		wl = weighted_cpuload(i) * SCHED_LOAD_SCALE;
+		wl /= power;
 
-		if (rq->nr_running == 1 && wl > imbalance)
+		if (capacity && rq->nr_running == 1 && wl > imbalance)
 			continue;
 
 		if (wl > max_load) {

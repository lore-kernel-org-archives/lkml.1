Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbYLJTof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbYLJTof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 14:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbYLJTo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 14:44:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40457 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbYLJToZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 14:44:25 -0500
Message-Id: <20081210194255.272279826@chello.nl>
References: <20081210194048.464111787@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 10 Dec 2008 20:40:49 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, dhaval@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
       cfriesen@nortel.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/2] sched: tg->weight
Content-Disposition: inline; filename=sched-tg_weight.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While going through the whole group thing again, I realized tg->shares ought
to be called tg->weight, as its the total group weight, and not a share of
the group weight.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    4 ++--
 kernel/sched.c        |   49 +++++++++++++++++++++++++++----------------------
 kernel/sched_fair.c   |    2 +-
 kernel/user.c         |    4 ++--
 4 files changed, 32 insertions(+), 27 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -275,7 +275,7 @@ struct task_group {
 	struct sched_entity **se;
 	/* runqueue "owned" by this group on each cpu */
 	struct cfs_rq **cfs_rq;
-	unsigned long shares;
+	unsigned long weight;
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -445,7 +445,7 @@ struct cfs_rq {
 	unsigned long h_load;
 
 	/*
-	 * this cpu's part of tg->shares
+	 * this cpu's part of tg->weight
 	 */
 	unsigned long shares;
 
@@ -1465,7 +1465,7 @@ static void __set_se_shares(struct sched
  * Calculate and set the cpu's group shares.
  */
 static void
-update_group_shares_cpu(struct task_group *tg, int cpu,
+update_group_weight_cpu(struct task_group *tg, int cpu,
 			unsigned long sd_shares, unsigned long sd_rq_weight)
 {
 	unsigned long shares;
@@ -1525,14 +1525,14 @@ static int tg_shares_up(struct task_grou
 		shares += tg->cfs_rq[i]->shares;
 	}
 
-	if ((!shares && rq_weight) || shares > tg->shares)
-		shares = tg->shares;
+	if ((!shares && rq_weight) || shares > tg->weight)
+		shares = tg->weight;
 
 	if (!sd->parent || !(sd->parent->flags & SD_LOAD_BALANCE))
-		shares = tg->shares;
+		shares = tg->weight;
 
 	for_each_cpu(i, sched_domain_span(sd))
-		update_group_shares_cpu(tg, i, shares, rq_weight);
+		update_group_weight_cpu(tg, i, shares, rq_weight);
 
 	return 0;
 }
@@ -8112,7 +8112,7 @@ static void init_tg_cfs_entry(struct tas
 		se->cfs_rq = parent->my_q;
 
 	se->my_q = cfs_rq;
-	se->load.weight = tg->shares;
+	se->load.weight = tg->weight;
 	se->load.inv_weight = 0;
 	se->parent = parent;
 }
@@ -8237,7 +8237,7 @@ void __init sched_init(void)
 		init_cfs_rq(&rq->cfs, rq);
 		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
-		init_task_group.shares = init_task_group_load;
+		init_task_group.weight = init_task_group_load;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
 #ifdef CONFIG_CGROUP_SCHED
 		/*
@@ -8261,7 +8261,7 @@ void __init sched_init(void)
 		 */
 		init_tg_cfs_entry(&init_task_group, &rq->cfs, NULL, i, 1, NULL);
 #elif defined CONFIG_USER_SCHED
-		root_task_group.shares = NICE_0_LOAD;
+		root_task_group.weight = NICE_0_LOAD;
 		init_tg_cfs_entry(&root_task_group, &rq->cfs, NULL, i, 0, NULL);
 		/*
 		 * In case of task-groups formed thr' the user id of tasks,
@@ -8524,7 +8524,7 @@ int alloc_fair_sched_group(struct task_g
 	if (!tg->se)
 		goto err;
 
-	tg->shares = NICE_0_LOAD;
+	tg->weight = NICE_0_LOAD;
 
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
@@ -8807,7 +8807,7 @@ static void set_se_shares(struct sched_e
 
 static DEFINE_MUTEX(shares_mutex);
 
-int sched_group_set_shares(struct task_group *tg, unsigned long shares)
+int sched_group_set_weight(struct task_group *tg, unsigned long shares)
 {
 	int i;
 	unsigned long flags;
@@ -8824,7 +8824,7 @@ int sched_group_set_shares(struct task_g
 		shares = MAX_SHARES;
 
 	mutex_lock(&shares_mutex);
-	if (tg->shares == shares)
+	if (tg->weight == shares)
 		goto done;
 
 	spin_lock_irqsave(&task_group_lock, flags);
@@ -8840,7 +8840,7 @@ int sched_group_set_shares(struct task_g
 	 * Now we are free to modify the group's share on each cpu
 	 * w/o tripping rebalance_share or load_balance_fair.
 	 */
-	tg->shares = shares;
+	tg->weight = shares;
 	for_each_possible_cpu(i) {
 		/*
 		 * force a rebalance
@@ -8863,9 +8863,9 @@ done:
 	return 0;
 }
 
-unsigned long sched_group_shares(struct task_group *tg)
+unsigned long sched_group_weight(struct task_group *tg)
 {
-	return tg->shares;
+	return tg->weight;
 }
 #endif
 
@@ -9183,17 +9183,17 @@ cpu_cgroup_attach(struct cgroup_subsys *
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static int cpu_shares_write_u64(struct cgroup *cgrp, struct cftype *cftype,
+static int cpu_weight_write_u64(struct cgroup *cgrp, struct cftype *cftype,
 				u64 shareval)
 {
-	return sched_group_set_shares(cgroup_tg(cgrp), shareval);
+	return sched_group_set_weight(cgroup_tg(cgrp), shareval);
 }
 
-static u64 cpu_shares_read_u64(struct cgroup *cgrp, struct cftype *cft)
+static u64 cpu_weight_read_u64(struct cgroup *cgrp, struct cftype *cft)
 {
 	struct task_group *tg = cgroup_tg(cgrp);
 
-	return (u64) tg->shares;
+	return (u64) tg->weight;
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
@@ -9225,8 +9225,13 @@ static struct cftype cpu_files[] = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	{
 		.name = "shares",
-		.read_u64 = cpu_shares_read_u64,
-		.write_u64 = cpu_shares_write_u64,
+		.read_u64 = cpu_weight_read_u64,
+		.write_u64 = cpu_weight_write_u64,
+	},
+	{
+		.name = "weight",
+		.read_u64 = cpu_weight_read_u64,
+		.write_u64 = cpu_weight_write_u64,
 	},
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1117,7 +1117,7 @@ static long effective_load(struct task_g
 		wl += more_w;
 		wg += more_w;
 
-		S = se->my_q->tg->shares;
+		S = se->my_q->tg->weight;
 		s = se->my_q->shares;
 		rw = se->my_q->rq_weight;
 
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -2282,8 +2282,8 @@ extern struct task_group *sched_create_g
 extern void sched_destroy_group(struct task_group *tg);
 extern void sched_move_task(struct task_struct *tsk);
 #ifdef CONFIG_FAIR_GROUP_SCHED
-extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
-extern unsigned long sched_group_shares(struct task_group *tg);
+extern int sched_group_set_weight(struct task_group *tg, unsigned long shares);
+extern unsigned long sched_group_weight(struct task_group *tg);
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
 extern int sched_group_set_rt_runtime(struct task_group *tg,
Index: linux-2.6/kernel/user.c
===================================================================
--- linux-2.6.orig/kernel/user.c
+++ linux-2.6/kernel/user.c
@@ -142,7 +142,7 @@ static ssize_t cpu_shares_show(struct ko
 {
 	struct user_struct *up = container_of(kobj, struct user_struct, kobj);
 
-	return sprintf(buf, "%lu\n", sched_group_shares(up->tg));
+	return sprintf(buf, "%lu\n", sched_group_weight(up->tg));
 }
 
 static ssize_t cpu_shares_store(struct kobject *kobj,
@@ -155,7 +155,7 @@ static ssize_t cpu_shares_store(struct k
 
 	sscanf(buf, "%lu", &shares);
 
-	rc = sched_group_set_shares(up->tg, shares);
+	rc = sched_group_set_weight(up->tg, shares);
 
 	return (rc ? rc : size);
 }

-- 


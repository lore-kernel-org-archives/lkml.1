Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYCIRRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYCIRRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYCIRQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:16:56 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:63728 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbYCIRQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:16:55 -0400
Message-Id: <20080309170926.096086000@chello.nl>
References: <20080309170850.256853000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 09 Mar 2008 18:08:52 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 02/17] sched: allow the CFS group scheduler to have multiple levels
Content-Disposition: inline; filename=dhaval-multi-level.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the group scheduler multi hierarchy aware.

[a.p.zijlstra@chello.nl: fixups]
Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    2 +-
 kernel/sched.c        |   39 +++++++++++++++++++++++----------------
 kernel/user.c         |    2 +-
 3 files changed, 25 insertions(+), 18 deletions(-)

Index: linux-2.6-2/include/linux/sched.h
===================================================================
--- linux-2.6-2.orig/include/linux/sched.h
+++ linux-2.6-2/include/linux/sched.h
@@ -2062,7 +2062,7 @@ extern void normalize_rt_tasks(void);
 
 extern struct task_group init_task_group;
 
-extern struct task_group *sched_create_group(void);
+extern struct task_group *sched_create_group(struct task_group *parent);
 extern void sched_destroy_group(struct task_group *tg);
 extern void sched_move_task(struct task_struct *tsk);
 #ifdef CONFIG_FAIR_GROUP_SCHED
Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -7273,10 +7273,11 @@ static void init_rt_rq(struct rt_rq *rt_
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static void init_tg_cfs_entry(struct rq *rq, struct task_group *tg,
-		struct cfs_rq *cfs_rq, struct sched_entity *se,
-		int cpu, int add)
+static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
+				struct sched_entity *se, int cpu, int add,
+				struct sched_entity *parent)
 {
+	struct rq *rq = cpu_rq(cpu);
 	tg->cfs_rq[cpu] = cfs_rq;
 	init_cfs_rq(cfs_rq, rq);
 	cfs_rq->tg = tg;
@@ -7288,7 +7289,11 @@ static void init_tg_cfs_entry(struct rq 
 	if (!se)
 		return;
 
-	se->cfs_rq = &rq->cfs;
+	if (!parent)
+		se->cfs_rq = &rq->cfs;
+	else
+		se->cfs_rq = parent->my_q;
+
 	se->my_q = cfs_rq;
 	se->load.weight = tg->shares;
 	se->load.inv_weight = div64_64(1ULL<<32, se->load.weight);
@@ -7375,7 +7380,8 @@ void __init sched_init(void)
 		 * We achieve this by letting init_task_group's tasks sit
 		 * directly in rq->cfs (i.e init_task_group->se[] = NULL).
 		 */
-		init_tg_cfs_entry(rq, &init_task_group, &rq->cfs, NULL, i, 1);
+		init_tg_cfs_entry(&init_task_group, &rq->cfs,
+							NULL, i, 1, NULL);
 #elif defined CONFIG_USER_SCHED
 		/*
 		 * In case of task-groups formed thr' the user id of tasks,
@@ -7390,7 +7396,7 @@ void __init sched_init(void)
 		 */
 		init_tg_cfs_entry(rq, &init_task_group,
 				&per_cpu(init_cfs_rq, i),
-				&per_cpu(init_sched_entity, i), i, 1);
+				&per_cpu(init_sched_entity, i), i, 1, NULL);
 
 #endif
 #endif /* CONFIG_FAIR_GROUP_SCHED */
@@ -7607,7 +7613,8 @@ static void free_fair_sched_group(struct
 	kfree(tg->se);
 }
 
-static int alloc_fair_sched_group(struct task_group *tg)
+static int alloc_fair_sched_group(struct task_group *tg,
+					struct task_group *parent)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se;
@@ -7636,7 +7643,10 @@ static int alloc_fair_sched_group(struct
 		if (!se)
 			goto err;
 
-		init_tg_cfs_entry(rq, tg, cfs_rq, se, i, 0);
+		if (!parent)
+			init_tg_cfs_entry(tg, cfs_rq, se, i, 0, NULL);
+		else
+			init_tg_cfs_entry(tg, cfs_rq, se, i, 0,	parent->se[i]);
 	}
 
 	return 1;
@@ -7769,7 +7779,7 @@ static void free_sched_group(struct task
 }
 
 /* allocate runqueue etc for a new task group */
-struct task_group *sched_create_group(void)
+struct task_group *sched_create_group(struct task_group *parent)
 {
 	struct task_group *tg;
 	unsigned long flags;
@@ -7779,7 +7789,7 @@ struct task_group *sched_create_group(vo
 	if (!tg)
 		return ERR_PTR(-ENOMEM);
 
-	if (!alloc_fair_sched_group(tg))
+	if (!alloc_fair_sched_group(tg, parent))
 		goto err;
 
 	if (!alloc_rt_sched_group(tg))
@@ -8138,7 +8148,7 @@ static inline struct task_group *cgroup_
 static struct cgroup_subsys_state *
 cpu_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
-	struct task_group *tg;
+	struct task_group *tg, *parent;
 
 	if (!cgrp->parent) {
 		/* This is early initialization for the top cgroup */
@@ -8146,11 +8156,8 @@ cpu_cgroup_create(struct cgroup_subsys *
 		return &init_task_group.css;
 	}
 
-	/* we support only 1-level deep hierarchical scheduler atm */
-	if (cgrp->parent->parent)
-		return ERR_PTR(-EINVAL);
-
-	tg = sched_create_group();
+	parent = cgroup_tg(cgrp->parent);
+	tg = sched_create_group(parent);
 	if (IS_ERR(tg))
 		return ERR_PTR(-ENOMEM);
 
Index: linux-2.6-2/kernel/user.c
===================================================================
--- linux-2.6-2.orig/kernel/user.c
+++ linux-2.6-2/kernel/user.c
@@ -101,7 +101,7 @@ static int sched_create_user(struct user
 {
 	int rc = 0;
 
-	up->tg = sched_create_group();
+	up->tg = sched_create_group(NULL);
 	if (IS_ERR(up->tg))
 		rc = -ENOMEM;
 

--


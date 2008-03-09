Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbYCIRKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbYCIRKW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbYCIRJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:09:20 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:39387 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbYCIRJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:09:17 -0400
Message-Id: <20080309170927.376604000@chello.nl>
References: <20080309170850.256853000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 09 Mar 2008 18:08:57 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 07/17] sched: fair-group: de-couple load-balancing from the rb-trees
Content-Disposition: inline; filename=sched-fair-group-smp.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

De-couple load-balancing from the rb-trees, so that I can change their
organization.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/init_task.h |    3 +++
 include/linux/sched.h     |    1 +
 kernel/sched.c            |   10 ++++++++--
 kernel/sched_fair.c       |   21 +++++++++++++--------
 4 files changed, 25 insertions(+), 10 deletions(-)

Index: linux-2.6-2/include/linux/init_task.h
===================================================================
--- linux-2.6-2.orig/include/linux/init_task.h
+++ linux-2.6-2/include/linux/init_task.h
@@ -151,6 +151,9 @@ extern struct group_info init_groups;
 	.cpus_allowed	= CPU_MASK_ALL,					\
 	.mm		= NULL,						\
 	.active_mm	= &init_mm,					\
+	.se		= {						\
+		.group_node 	= LIST_HEAD_INIT(tsk.se.group_node),	\
+	},								\
 	.rt		= {						\
 		.run_list	= LIST_HEAD_INIT(tsk.rt.run_list),	\
 		.time_slice	= HZ, 					\
Index: linux-2.6-2/include/linux/sched.h
===================================================================
--- linux-2.6-2.orig/include/linux/sched.h
+++ linux-2.6-2/include/linux/sched.h
@@ -922,6 +922,7 @@ struct load_weight {
 struct sched_entity {
 	struct load_weight	load;		/* for load-balancing */
 	struct rb_node		run_node;
+	struct list_head	group_node;
 	unsigned int		on_rq;
 
 	u64			exec_start;
Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -391,8 +391,12 @@ struct cfs_rq {
 
 	struct rb_root tasks_timeline;
 	struct rb_node *rb_leftmost;
-	struct rb_node *rb_load_balance_curr;
-	/* 'curr' points to currently running entity on this cfs_rq.
+
+	struct list_head tasks;
+	struct list_head *balance_iterator;
+
+	/*
+	 * 'curr' points to currently running entity on this cfs_rq.
 	 * It is set to NULL otherwise (i.e when none are currently running).
 	 */
 	struct sched_entity *curr;
@@ -2312,6 +2316,7 @@ static void __sched_fork(struct task_str
 
 	INIT_LIST_HEAD(&p->rt.run_list);
 	p->se.on_rq = 0;
+	INIT_LIST_HEAD(&p->se.group_node);
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
@@ -7484,6 +7489,7 @@ int in_sched_functions(unsigned long add
 static void init_cfs_rq(struct cfs_rq *cfs_rq, struct rq *rq)
 {
 	cfs_rq->tasks_timeline = RB_ROOT;
+	INIT_LIST_HEAD(&cfs_rq->tasks);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	cfs_rq->rq = rq;
 #endif
Index: linux-2.6-2/kernel/sched_fair.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_fair.c
+++ linux-2.6-2/kernel/sched_fair.c
@@ -518,6 +518,7 @@ account_entity_enqueue(struct cfs_rq *cf
 	update_load_add(&cfs_rq->load, se->load.weight);
 	cfs_rq->nr_running++;
 	se->on_rq = 1;
+	list_add(&se->group_node, &cfs_rq->tasks);
 }
 
 static void
@@ -526,6 +527,7 @@ account_entity_dequeue(struct cfs_rq *cf
 	update_load_sub(&cfs_rq->load, se->load.weight);
 	cfs_rq->nr_running--;
 	se->on_rq = 0;
+	list_del_init(&se->group_node);
 }
 
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -1177,21 +1179,24 @@ static void put_prev_task_fair(struct rq
  * the current task:
  */
 static struct task_struct *
-__load_balance_iterator(struct cfs_rq *cfs_rq, struct rb_node *curr)
+__load_balance_iterator(struct cfs_rq *cfs_rq, struct list_head *next)
 {
 	struct task_struct *p = NULL;
 	struct sched_entity *se;
 
-	if (!curr)
+	if (next == &cfs_rq->tasks)
 		return NULL;
 
 	/* Skip over entities that are not tasks */
 	do {
-		se = rb_entry(curr, struct sched_entity, run_node);
-		curr = rb_next(curr);
-	} while (curr && !entity_is_task(se));
+		se = list_entry(next, struct sched_entity, group_node);
+		next = next->next;
+	} while (next != &cfs_rq->tasks && !entity_is_task(se));
 
-	cfs_rq->rb_load_balance_curr = curr;
+	if (next == &cfs_rq->tasks)
+		return NULL;
+
+	cfs_rq->balance_iterator = next;
 
 	if (entity_is_task(se))
 		p = task_of(se);
@@ -1203,14 +1208,14 @@ static struct task_struct *load_balance_
 {
 	struct cfs_rq *cfs_rq = arg;
 
-	return __load_balance_iterator(cfs_rq, first_fair(cfs_rq));
+	return __load_balance_iterator(cfs_rq, cfs_rq->tasks.next);
 }
 
 static struct task_struct *load_balance_next_fair(void *arg)
 {
 	struct cfs_rq *cfs_rq = arg;
 
-	return __load_balance_iterator(cfs_rq, cfs_rq->rb_load_balance_curr);
+	return __load_balance_iterator(cfs_rq, cfs_rq->balance_iterator);
 }
 
 static unsigned long

--


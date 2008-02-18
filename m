Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbYBRKBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbYBRKBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbYBRJ72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 04:59:28 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:40028 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753928AbYBRJ7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 04:59:23 -0500
X-SourceIP: 80.56.237.116
Message-Id: <20080218095624.823121000@chello.nl>
References: <20080218095535.629736000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 18 Feb 2008 10:55:38 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       dhaval@linux.vnet.ibm.com, tong.n.li@intel.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/7] sched: fair-group: de-couple load-balancing from the rb-trees
Content-Disposition: inline; filename=sched-fair-group-smp.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

De-couple load-balancing from the rb-trees, so that I can change their
organization. Afterwards we'll probably want to redo load balancing to
not need the grouping info.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/init_task.h |    3 +++
 include/linux/sched.h     |    1 +
 kernel/sched.c            |   12 ++++++++++--
 kernel/sched_fair.c       |   15 +++++++++------
 4 files changed, 23 insertions(+), 8 deletions(-)

Index: linux-2.6/include/linux/init_task.h
===================================================================
--- linux-2.6.orig/include/linux/init_task.h
+++ linux-2.6/include/linux/init_task.h
@@ -132,6 +132,9 @@ extern struct group_info init_groups;
 	.cpus_allowed	= CPU_MASK_ALL,					\
 	.mm		= NULL,						\
 	.active_mm	= &init_mm,					\
+	.se		= {						\
+		.group_node 	= LIST_HEAD_INIT(tsk.se.group_node),	\
+	},								\
 	.rt		= {						\
 		.run_list	= LIST_HEAD_INIT(tsk.rt.run_list),	\
 		.time_slice	= HZ, 					\
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -909,6 +909,7 @@ struct load_weight {
 struct sched_entity {
 	struct load_weight	load;		/* for load-balancing */
 	struct rb_node		run_node;
+	struct list_head	group_node;
 	unsigned int		on_rq;
 
 	u64			exec_start;
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -437,8 +437,12 @@ struct cfs_rq {
 
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
@@ -2025,6 +2029,7 @@ static void __sched_fork(struct task_str
 
 	INIT_LIST_HEAD(&p->rt.run_list);
 	p->se.on_rq = 0;
+	INIT_LIST_HEAD(&p->se.group_node);
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
@@ -7196,6 +7201,7 @@ int in_sched_functions(unsigned long add
 static void init_cfs_rq(struct cfs_rq *cfs_rq, struct rq *rq)
 {
 	cfs_rq->tasks_timeline = RB_ROOT;
+	INIT_LIST_HEAD(&cfs_rq->tasks);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	cfs_rq->rq = rq;
 #endif
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -523,6 +523,7 @@ account_entity_enqueue(struct cfs_rq *cf
 	update_load_add(&cfs_rq->load, se->load.weight);
 	cfs_rq->nr_running++;
 	se->on_rq = 1;
+	list_add(&se->group_node, &cfs_rq->tasks);
 }
 
 static void
@@ -531,6 +532,7 @@ account_entity_dequeue(struct cfs_rq *cf
 	update_load_sub(&cfs_rq->load, se->load.weight);
 	cfs_rq->nr_running--;
 	se->on_rq = 0;
+	list_del_init(&se->group_node);
 }
 
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -1156,16 +1158,17 @@ static void put_prev_task_fair(struct rq
  * achieve that by always pre-iterating before returning
  * the current task:
  */
+
 static struct task_struct *
-__load_balance_iterator(struct cfs_rq *cfs_rq, struct rb_node *curr)
+__load_balance_iterator(struct cfs_rq *cfs_rq, struct list_head *next)
 {
 	struct task_struct *p;
 
-	if (!curr)
+	if (next == &cfs_rq->tasks)
 		return NULL;
 
-	p = rb_entry(curr, struct task_struct, se.run_node);
-	cfs_rq->rb_load_balance_curr = rb_next(curr);
+	p = list_entry(next, struct task_struct, se.group_node);
+	cfs_rq->balance_iterator = next->next;
 
 	return p;
 }
@@ -1174,14 +1177,14 @@ static struct task_struct *load_balance_
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


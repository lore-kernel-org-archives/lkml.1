Return-Path: <linux-kernel-owner+w=401wt.eu-S1760259AbXJaVQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259AbXJaVQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 17:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759235AbXJaVO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:14:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758719AbXJaVO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:14:26 -0400
Message-Id: <20071031211249.377363000@chello.nl>
References: <20071031211030.310581000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 31 Oct 2007 22:10:34 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: [PATCH 4/6] sched: sched_rt_entity
Content-Disposition: inline; filename=sched-rt-entity.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the task_struct members specific to rt scheduling together.
A future optimization could be to put sched_entity and sched_rt_entity
into a union.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
---
 include/linux/init_task.h |    5 +++--
 include/linux/sched.h     |    8 ++++++--
 kernel/sched.c            |    2 +-
 kernel/sched_rt.c         |   18 +++++++++---------
 mm/oom_kill.c             |    2 +-
 5 files changed, 20 insertions(+), 15 deletions(-)

Index: linux-2.6/include/linux/init_task.h
===================================================================
--- linux-2.6.orig/include/linux/init_task.h
+++ linux-2.6/include/linux/init_task.h
@@ -132,9 +132,10 @@ extern struct group_info init_groups;
 	.cpus_allowed	= CPU_MASK_ALL,					\
 	.mm		= NULL,						\
 	.active_mm	= &init_mm,					\
-	.run_list	= LIST_HEAD_INIT(tsk.run_list),			\
+	.rt		= {						\
+		.run_list	= LIST_HEAD_INIT(tsk.rt.run_list),	\
+		.time_slice	= HZ, },				\
 	.ioprio		= 0,						\
-	.time_slice	= HZ,						\
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
 	.ptrace_children= LIST_HEAD_INIT(tsk.ptrace_children),		\
 	.ptrace_list	= LIST_HEAD_INIT(tsk.ptrace_list),		\
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -911,6 +911,11 @@ struct sched_entity {
 #endif
 };
 
+struct sched_rt_entity {
+	struct list_head run_list;
+	unsigned int time_slice;
+};
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -927,9 +932,9 @@ struct task_struct {
 #endif
 
 	int prio, static_prio, normal_prio;
-	struct list_head run_list;
 	const struct sched_class *sched_class;
 	struct sched_entity se;
+	struct sched_rt_entity rt;
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	/* list of struct preempt_notifier: */
@@ -953,7 +958,6 @@ struct task_struct {
 
 	unsigned int policy;
 	cpumask_t cpus_allowed;
-	unsigned int time_slice;
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	struct sched_info sched_info;
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -29,7 +29,7 @@ static void enqueue_task_rt(struct rq *r
 {
 	struct rt_prio_array *array = &rq->rt.active;
 
-	list_add_tail(&p->run_list, array->queue + p->prio);
+	list_add_tail(&p->rt.run_list, array->queue + p->prio);
 	__set_bit(p->prio, array->bitmap);
 }
 
@@ -42,7 +42,7 @@ static void dequeue_task_rt(struct rq *r
 
 	update_curr_rt(rq);
 
-	list_del(&p->run_list);
+	list_del(&p->rt.run_list);
 	if (list_empty(array->queue + p->prio))
 		__clear_bit(p->prio, array->bitmap);
 }
@@ -55,7 +55,7 @@ static void requeue_task_rt(struct rq *r
 {
 	struct rt_prio_array *array = &rq->rt.active;
 
-	list_move_tail(&p->run_list, array->queue + p->prio);
+	list_move_tail(&p->rt.run_list, array->queue + p->prio);
 }
 
 static void
@@ -85,7 +85,7 @@ static struct task_struct *pick_next_tas
 		return NULL;
 
 	queue = array->queue + idx;
-	next = list_entry(queue->next, struct task_struct, run_list);
+	next = list_entry(queue->next, struct task_struct, rt.run_list);
 
 	next->se.exec_start = rq->clock;
 
@@ -121,7 +121,7 @@ static struct task_struct *load_balance_
 	head = array->queue + idx;
 	curr = head->prev;
 
-	p = list_entry(curr, struct task_struct, run_list);
+	p = list_entry(curr, struct task_struct, rt.run_list);
 
 	curr = curr->prev;
 
@@ -162,7 +162,7 @@ static struct task_struct *load_balance_
 		rq->rt.rt_load_balance_head = head;
 	}
 
-	p = list_entry(curr, struct task_struct, run_list);
+	p = list_entry(curr, struct task_struct, rt.run_list);
 
 	curr = curr->prev;
 
@@ -214,16 +214,16 @@ static void task_tick_rt(struct rq *rq, 
 	if (p->policy != SCHED_RR)
 		return;
 
-	if (--p->time_slice)
+	if (--p->rt.time_slice)
 		return;
 
-	p->time_slice = DEF_TIMESLICE;
+	p->rt.time_slice = DEF_TIMESLICE;
 
 	/*
 	 * Requeue to the end of queue if we are not the only element
 	 * on the queue:
 	 */
-	if (p->run_list.prev != p->run_list.next) {
+	if (p->rt.run_list.prev != p->rt.run_list.next) {
 		requeue_task_rt(rq, p);
 		set_tsk_need_resched(p);
 	}
Index: linux-2.6/mm/oom_kill.c
===================================================================
--- linux-2.6.orig/mm/oom_kill.c
+++ linux-2.6/mm/oom_kill.c
@@ -286,7 +286,7 @@ static void __oom_kill_task(struct task_
 	 * all the memory it needs. That way it should be able to
 	 * exit() and clear out its resources quickly...
 	 */
-	p->time_slice = HZ;
+	p->rt.time_slice = HZ;
 	set_tsk_thread_flag(p, TIF_MEMDIE);
 
 	force_sig(SIGKILL, p);
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1838,7 +1838,7 @@ static void __sched_fork(struct task_str
 	p->se.wait_max			= 0;
 #endif
 
-	INIT_LIST_HEAD(&p->run_list);
+	INIT_LIST_HEAD(&p->rt.run_list);
 	p->se.on_rq = 0;
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS

--


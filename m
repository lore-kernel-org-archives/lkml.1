Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbXJVJ4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbXJVJ4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbXJVJzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:55:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35778 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbXJVJzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:55:32 -0400
Message-Id: <20071022095659.005996000@chello.nl>
References: <20071022095054.393085000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 22 Oct 2007 11:50:57 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Daniel Walker <dwalker@mvista.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 3/3] rt: PI-workqueue: fix barriers
Content-Disposition: inline; filename=rt-workqueue-barrier.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The plist change to the workqueues left the barrier functionality broken.

The barrier is used for two things:
 - wait_on_work(), and
 - flush_cpu_workqueue().

wait_on_work() - uses the barrier to wait on the completion of the currently
worklet. This was done by inserting a completion barrier at the very head of
the worklist. With plist this would be the head of the highest prio.

In order to do that, we extend the plist_add functionality to allow adding to
the head of a prio. Another noteworthy point it that this high prio worklet
must not boost the prio further than the waiting task's prio, even though we
enqueue it at prio 99.

flush_cpu_workqueue() - is a full ordering barrier, although as the name
suggests usually used to wait for the worklist to drain. We'll support the
full ordering semantics currently present. This means that:

  W10, W22, W65, B, W80, B, W99

[ where Wn is a worklet at prio n, and B the barrier ]

would most likely execute in the following order:

  W10@99, W65@99, W22@99, W80@99, W99

[ Wn@m is Wn executed at prio m ]
[ W10 would be first because it can start executing while the others 
  are being added ]

Whereas without the barriers it would be:

  W10@99, W99, W80, W65, W22

The prio ordering of the plist makes it hard to impose an extra order on top.
The solution used is to nest plist structures. The example will look like:

  W10, B(B(W65, W22), W80), W99

That is, the barrier will splice the worklist into itself, and enqueue itself
as the next item to run (very first item, highest prio). The barrier will then
run its own plist to completion before 'popping' back to the regular worklist.

To avoid callstack nesting, run_workqueue is taught about this barrier stack.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/plist.h |   14 ++++++
 kernel/workqueue.c    |  104 ++++++++++++++++++++++++++++++++++++++++++--------
 lib/plist.c           |   10 +++-
 3 files changed, 110 insertions(+), 18 deletions(-)

Index: linux-2.6/include/linux/plist.h
===================================================================
--- linux-2.6.orig/include/linux/plist.h
+++ linux-2.6/include/linux/plist.h
@@ -145,9 +145,21 @@ static inline void plist_node_init(struc
 	plist_head_init(&node->plist, NULL);
 }
 
-extern void plist_add(struct plist_node *node, struct plist_head *head);
+void __plist_add(struct plist_node *node, struct plist_head *head, int tail);
+
+static inline void plist_add(struct plist_node *node, struct plist_head *head)
+{
+	__plist_add(node, head, 1);
+}
+
 extern void plist_del(struct plist_node *node, struct plist_head *head);
 
+static inline void plist_head_splice(struct plist_head *src, struct plist_head *dst)
+{
+	list_splice_init(&src->prio_list, &dst->prio_list);
+	list_splice_init(&src->node_list, &dst->node_list);
+}
+
 /**
  * plist_for_each - iterate over the plist
  * @pos:	the type * to use as a loop counter
Index: linux-2.6/lib/plist.c
===================================================================
--- linux-2.6.orig/lib/plist.c
+++ linux-2.6/lib/plist.c
@@ -72,7 +72,7 @@ static void plist_check_head(struct plis
  * @node:	&struct plist_node pointer
  * @head:	&struct plist_head pointer
  */
-void plist_add(struct plist_node *node, struct plist_head *head)
+void __plist_add(struct plist_node *node, struct plist_head *head, int tail)
 {
 	struct plist_node *iter;
 
@@ -92,7 +92,13 @@ void plist_add(struct plist_node *node, 
 lt_prio:
 	list_add_tail(&node->plist.prio_list, &iter->plist.prio_list);
 eq_prio:
-	list_add_tail(&node->plist.node_list, &iter->plist.node_list);
+	if (likely(tail))
+		list_add_tail(&node->plist.node_list, &iter->plist.node_list);
+	else {
+		iter = list_entry(iter->plist.prio_list.prev,
+				struct plist_node, plist.prio_list);
+		list_add(&node->plist.node_list, &iter->plist.node_list);
+	}
 
 	plist_check_head(head);
 }
Index: linux-2.6/kernel/workqueue.c
===================================================================
--- linux-2.6.orig/kernel/workqueue.c
+++ linux-2.6/kernel/workqueue.c
@@ -36,6 +36,8 @@
 
 #include <asm/uaccess.h>
 
+struct wq_full_barrier;
+
 /*
  * The per-CPU workqueue (if single thread, we always use the first
  * possible cpu).
@@ -52,6 +54,8 @@ struct cpu_workqueue_struct {
 	struct task_struct *thread;
 
 	int run_depth;		/* Detect run_workqueue() recursion depth */
+
+	struct wq_full_barrier *barrier;
 } ____cacheline_aligned;
 
 /*
@@ -125,10 +129,8 @@ struct cpu_workqueue_struct *get_wq_data
 }
 
 static void insert_work(struct cpu_workqueue_struct *cwq,
-				struct work_struct *work, int tail)
+		struct work_struct *work, int prio, int boost_prio, int tail)
 {
-	int prio = current->normal_prio;
-
 	set_wq_data(work, cwq);
 	/*
 	 * Ensure that we get the right work->data if we see the
@@ -136,10 +138,10 @@ static void insert_work(struct cpu_workq
 	 */
 	smp_wmb();
 	plist_node_init(&work->entry, prio);
-	plist_add(&work->entry, &cwq->worklist);
+	__plist_add(&work->entry, &cwq->worklist, tail);
 
-	if (prio < cwq->thread->prio)
-		task_setprio(cwq->thread, prio);
+	if (boost_prio < cwq->thread->prio)
+		task_setprio(cwq->thread, boost_prio);
 	wake_up(&cwq->more_work);
 }
 
@@ -150,7 +152,7 @@ static void __queue_work(struct cpu_work
 	unsigned long flags;
 
 	spin_lock_irqsave(&cwq->lock, flags);
-	insert_work(cwq, work, 1);
+	insert_work(cwq, work, current->normal_prio, current->normal_prio, 1);
 	spin_unlock_irqrestore(&cwq->lock, flags);
 }
 
@@ -257,8 +259,19 @@ static void leak_check(void *func)
 	dump_stack();
 }
 
+struct wq_full_barrier {
+	struct work_struct		work;
+	struct plist_head		worklist;
+	struct wq_full_barrier 		*prev_barrier;
+	int				prev_prio;
+	struct cpu_workqueue_struct 	*cwq;
+	struct completion		done;
+};
+
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
 {
+	struct plist_head *worklist = &cwq->worklist;
+
 	spin_lock_irq(&cwq->lock);
 	cwq->run_depth++;
 	if (cwq->run_depth > 3) {
@@ -267,16 +280,25 @@ static void run_workqueue(struct cpu_wor
 			__FUNCTION__, cwq->run_depth);
 		dump_stack();
 	}
-	while (!plist_head_empty(&cwq->worklist)) {
-		struct work_struct *work = plist_first_entry(&cwq->worklist,
+
+again:
+	while (!plist_head_empty(worklist)) {
+		int prio;
+		struct work_struct *work = plist_first_entry(worklist,
 						struct work_struct, entry);
 		work_func_t f = work->func;
 
-		if (likely(cwq->thread->prio != work->entry.prio))
-			task_setprio(cwq->thread, work->entry.prio);
+		prio = work->entry.prio;
+		if (unlikely(worklist != &cwq->worklist)) {
+			prio = min(prio, cwq->barrier->prev_prio);
+			prio = min(prio, plist_first(&cwq->worklist)->prio);
+		}
+
+		if (likely(cwq->thread->prio != prio))
+			task_setprio(cwq->thread, prio);
 
 		cwq->current_work = work;
-		plist_del(&work->entry, &cwq->worklist);
+		plist_del(&work->entry, worklist);
 		plist_node_init(&work->entry, MAX_PRIO);
 		spin_unlock_irq(&cwq->lock);
 
@@ -289,7 +311,27 @@ static void run_workqueue(struct cpu_wor
 
 		spin_lock_irq(&cwq->lock);
 		cwq->current_work = NULL;
+
+		if (unlikely(cwq->barrier))
+			worklist = &cwq->barrier->worklist;
+	}
+
+	if (unlikely(worklist != &cwq->worklist)) {
+		struct wq_full_barrier *barrier = cwq->barrier;
+
+		BUG_ON(!barrier);
+		cwq->barrier = barrier->prev_barrier;
+		complete(&barrier->done);
+
+		if (unlikely(cwq->barrier))
+			worklist = &cwq->barrier->worklist;
+		else
+			worklist = &cwq->worklist;
+
+		if (!plist_head_empty(worklist))
+			goto again;
 	}
+
 	task_setprio(cwq->thread, current->normal_prio);
 	cwq->run_depth--;
 	spin_unlock_irq(&cwq->lock);
@@ -343,7 +385,38 @@ static void insert_wq_barrier(struct cpu
 
 	init_completion(&barr->done);
 
-	insert_work(cwq, &barr->work, tail);
+	insert_work(cwq, &barr->work, 0, current->normal_prio, tail);
+}
+
+static void wq_full_barrier_func(struct work_struct *work)
+{
+	struct wq_full_barrier *barrier =
+		container_of(work, struct wq_full_barrier, work);
+	struct cpu_workqueue_struct *cwq = barrier->cwq;
+
+	spin_lock_irq(&cwq->lock);
+	barrier->prev_barrier = cwq->barrier;
+	if (cwq->barrier) {
+		barrier->prev_prio = min(cwq->barrier->prev_prio,
+				plist_first(&cwq->barrier->worklist)->prio);
+	} else
+		barrier->prev_prio = MAX_PRIO;
+	cwq->barrier = barrier;
+	spin_unlock_irq(&cwq->lock);
+}
+
+static void insert_wq_full_barrier(struct cpu_workqueue_struct *cwq,
+		struct wq_full_barrier *barr)
+{
+	INIT_WORK(&barr->work, wq_full_barrier_func);
+	__set_bit(WORK_STRUCT_PENDING, work_data_bits(&barr->work));
+
+	plist_head_init(&barr->worklist, NULL);
+	plist_head_splice(&cwq->worklist, &barr->worklist);
+	barr->cwq = cwq;
+	init_completion(&barr->done);
+
+	insert_work(cwq, &barr->work, 0, current->normal_prio, 1);
 }
 
 static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
@@ -358,13 +431,13 @@ static int flush_cpu_workqueue(struct cp
 		run_workqueue(cwq);
 		active = 1;
 	} else {
-		struct wq_barrier barr;
+		struct wq_full_barrier barr;
 
 		active = 0;
 		spin_lock_irq(&cwq->lock);
 		if (!plist_head_empty(&cwq->worklist) ||
 			cwq->current_work != NULL) {
-			insert_wq_barrier(cwq, &barr, 1);
+			insert_wq_full_barrier(cwq, &barr);
 			active = 1;
 		}
 		spin_unlock_irq(&cwq->lock);
@@ -759,6 +832,7 @@ init_cpu_workqueue(struct workqueue_stru
 	spin_lock_init(&cwq->lock);
 	plist_head_init(&cwq->worklist, NULL);
 	init_waitqueue_head(&cwq->more_work);
+	cwq->barrier = NULL;
 
 	return cwq;
 }

--


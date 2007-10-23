Return-Path: <linux-kernel-owner+w=401wt.eu-S1752457AbXJWTXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbXJWTXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 15:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbXJWTX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 15:23:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42195 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbXJWTX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 15:23:28 -0400
Subject: [RFC/PATCH 6/5] rt: PI-workqueue: wait_on_work() fixup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Daniel Walker <dwalker@mvista.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <20071023120357.782284000@chello.nl>
References: <20071023120357.782284000@chello.nl>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 21:22:24 +0200
Message-Id: <1193167344.5648.23.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: rt: PI-workqueue: wait_on_work() fixup

Oleg noticed that the new wait_on_work() barrier does not properly interact
with the nesting barrier.

The problem is that a wait_on_work() targeted at a worklet in a nested list
will complete too late.

Fix this by using a wait_queue instead.

[ will be folded into the previous patch on next posting ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/workqueue.c |   74 ++++++++++++++++++++---------------------------------
 1 file changed, 29 insertions(+), 45 deletions(-)

Index: linux-2.6/kernel/workqueue.c
===================================================================
--- linux-2.6.orig/kernel/workqueue.c
+++ linux-2.6/kernel/workqueue.c
@@ -33,10 +33,11 @@
 #include <linux/freezer.h>
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
+#include <linux/wait.h>
 
 #include <asm/uaccess.h>
 
-struct wq_full_barrier;
+struct wq_barrier;
 
 /*
  * The per-CPU workqueue (if single thread, we always use the first
@@ -55,7 +56,8 @@ struct cpu_workqueue_struct {
 
 	int run_depth;		/* Detect run_workqueue() recursion depth */
 
-	struct wq_full_barrier *barrier;
+	wait_queue_head_t work_done;
+	struct wq_barrier *barrier;
 } ____cacheline_aligned;
 
 /*
@@ -259,10 +261,10 @@ static void leak_check(void *func)
 	dump_stack();
 }
 
-struct wq_full_barrier {
+struct wq_barrier {
 	struct work_struct		work;
 	struct plist_head		worklist;
-	struct wq_full_barrier 		*prev_barrier;
+	struct wq_barrier 		*prev_barrier;
 	int				prev_prio;
 	int				waiter_prio;
 	struct cpu_workqueue_struct 	*cwq;
@@ -314,13 +316,13 @@ again:
 
 		spin_lock_irq(&cwq->lock);
 		cwq->current_work = NULL;
-
+		wake_up_all(&cwq->work_done);
 		if (unlikely(cwq->barrier))
 			worklist = &cwq->barrier->worklist;
 	}
 
 	if (unlikely(worklist != &cwq->worklist)) {
-		struct wq_full_barrier *barrier = cwq->barrier;
+		struct wq_barrier *barrier = cwq->barrier;
 
 		BUG_ON(!barrier);
 		cwq->barrier = barrier->prev_barrier;
@@ -369,32 +371,10 @@ static int worker_thread(void *__cwq)
 	return 0;
 }
 
-struct wq_barrier {
-	struct work_struct	work;
-	struct completion	done;
-};
-
 static void wq_barrier_func(struct work_struct *work)
 {
-	struct wq_barrier *barr = container_of(work, struct wq_barrier, work);
-	complete(&barr->done);
-}
-
-static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
-					struct wq_barrier *barr, int prio)
-{
-	INIT_WORK(&barr->work, wq_barrier_func);
-	__set_bit(WORK_STRUCT_PENDING, work_data_bits(&barr->work));
-
-	init_completion(&barr->done);
-
-	insert_work(cwq, &barr->work, prio, current->prio);
-}
-
-static void wq_full_barrier_func(struct work_struct *work)
-{
-	struct wq_full_barrier *barrier =
-		container_of(work, struct wq_full_barrier, work);
+	struct wq_barrier *barrier =
+		container_of(work, struct wq_barrier, work);
 	struct cpu_workqueue_struct *cwq = barrier->cwq;
 	int prio = MAX_PRIO;
 
@@ -409,10 +389,10 @@ static void wq_full_barrier_func(struct 
 	spin_unlock_irq(&cwq->lock);
 }
 
-static void insert_wq_full_barrier(struct cpu_workqueue_struct *cwq,
-		struct wq_full_barrier *barr)
+static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
+		struct wq_barrier *barr)
 {
-	INIT_WORK(&barr->work, wq_full_barrier_func);
+	INIT_WORK(&barr->work, wq_barrier_func);
 	__set_bit(WORK_STRUCT_PENDING, work_data_bits(&barr->work));
 
 	plist_head_init(&barr->worklist, NULL);
@@ -436,13 +416,13 @@ static int flush_cpu_workqueue(struct cp
 		run_workqueue(cwq);
 		active = 1;
 	} else {
-		struct wq_full_barrier barr;
+		struct wq_barrier barr;
 
 		active = 0;
 		spin_lock_irq(&cwq->lock);
 		if (!plist_head_empty(&cwq->worklist) ||
 			cwq->current_work != NULL) {
-			insert_wq_full_barrier(cwq, &barr);
+			insert_wq_barrier(cwq, &barr);
 			active = 1;
 		}
 		spin_unlock_irq(&cwq->lock);
@@ -518,21 +498,24 @@ static int try_to_grab_pending(struct wo
 	return ret;
 }
 
-static void wait_on_cpu_work(struct cpu_workqueue_struct *cwq,
-				struct work_struct *work)
+static inline
+int is_current_work(struct cpu_workqueue_struct *cwq, struct work_struct *work)
 {
-	struct wq_barrier barr;
-	int running = 0;
+	int ret;
 
 	spin_lock_irq(&cwq->lock);
-	if (unlikely(cwq->current_work == work)) {
-		insert_wq_barrier(cwq, &barr, -1);
-		running = 1;
-	}
+	ret = (cwq->current_work == work);
 	spin_unlock_irq(&cwq->lock);
 
-	if (unlikely(running))
-		wait_for_completion(&barr.done);
+	return ret;
+}
+
+static void wait_on_cpu_work(struct cpu_workqueue_struct *cwq,
+				struct work_struct *work)
+{
+	DEFINE_WAIT(wait);
+
+	wait_event(cwq->work_done, is_current_work(cwq, work));
 }
 
 static void wait_on_work(struct work_struct *work)
@@ -838,6 +821,7 @@ init_cpu_workqueue(struct workqueue_stru
 	plist_head_init(&cwq->worklist, NULL);
 	init_waitqueue_head(&cwq->more_work);
 	cwq->barrier = NULL;
+	init_waitqueue_head(&cwq->work_done);
 
 	return cwq;
 }



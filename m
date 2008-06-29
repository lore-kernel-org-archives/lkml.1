Return-Path: <linux-kernel-owner+w=401wt.eu-S1761767AbYF2Orh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761767AbYF2Orh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 10:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760554AbYF2Oqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 10:46:48 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41642 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760236AbYF2Oqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 10:46:46 -0400
Date: Sun, 29 Jun 2008 18:49:25 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarek Poplawski <jarkao2@o2.pl>, Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] workqueues: insert_work: use "list_head *" instead of "int tail"
Message-ID: <20080629144925.GA4344@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

insert_work() inserts the new work_struct before or after cwq->worklist,
depending on the "int tail" parameter. Change it to accept "list_head *"
instead, this shrinks .text a bit and allows us to insert the barrier
after specific work_struct.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/workqueue.c~WQ_1_S_TAIL_PREV	2008-05-18 15:44:19.000000000 +0400
+++ 26-rc2/kernel/workqueue.c	2008-06-12 21:28:13.000000000 +0400
@@ -125,7 +125,7 @@ struct cpu_workqueue_struct *get_wq_data
 }
 
 static void insert_work(struct cpu_workqueue_struct *cwq,
-				struct work_struct *work, int tail)
+			struct work_struct *work, struct list_head *head)
 {
 	set_wq_data(work, cwq);
 	/*
@@ -133,10 +133,7 @@ static void insert_work(struct cpu_workq
 	 * result of list_add() below, see try_to_grab_pending().
 	 */
 	smp_wmb();
-	if (tail)
-		list_add_tail(&work->entry, &cwq->worklist);
-	else
-		list_add(&work->entry, &cwq->worklist);
+	list_add_tail(&work->entry, head);
 	wake_up(&cwq->more_work);
 }
 
@@ -147,7 +144,7 @@ static void __queue_work(struct cpu_work
 	unsigned long flags;
 
 	spin_lock_irqsave(&cwq->lock, flags);
-	insert_work(cwq, work, 1);
+	insert_work(cwq, work, &cwq->worklist);
 	spin_unlock_irqrestore(&cwq->lock, flags);
 }
 
@@ -337,14 +334,14 @@ static void wq_barrier_func(struct work_
 }
 
 static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
-					struct wq_barrier *barr, int tail)
+			struct wq_barrier *barr, struct list_head *head)
 {
 	INIT_WORK(&barr->work, wq_barrier_func);
 	__set_bit(WORK_STRUCT_PENDING, work_data_bits(&barr->work));
 
 	init_completion(&barr->done);
 
-	insert_work(cwq, &barr->work, tail);
+	insert_work(cwq, &barr->work, head);
 }
 
 static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
@@ -364,7 +361,7 @@ static int flush_cpu_workqueue(struct cp
 		active = 0;
 		spin_lock_irq(&cwq->lock);
 		if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
-			insert_wq_barrier(cwq, &barr, 1);
+			insert_wq_barrier(cwq, &barr, &cwq->worklist);
 			active = 1;
 		}
 		spin_unlock_irq(&cwq->lock);
@@ -449,7 +446,7 @@ static void wait_on_cpu_work(struct cpu_
 
 	spin_lock_irq(&cwq->lock);
 	if (unlikely(cwq->current_work == work)) {
-		insert_wq_barrier(cwq, &barr, 0);
+		insert_wq_barrier(cwq, &barr, cwq->worklist.next);
 		running = 1;
 	}
 	spin_unlock_irq(&cwq->lock);


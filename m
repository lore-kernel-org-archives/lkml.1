Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbZAVJPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbZAVJPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbZAVJOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:14:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61139 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754586AbZAVJOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:14:38 -0500
Message-ID: <497838F0.7020408@cn.fujitsu.com>
Date: Thu, 22 Jan 2009 17:14:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] workqueue: not allow recursion run_workqueue
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) lockdep will complain when recursion run_workqueue
2) works is not run orderly when recursion run_workqueue

3) BUG!
   We use recursion run_workqueue to hidden deadlock when
   keventd trying to flush its own queue.

   It's bug. When flush_workqueue()(nested in a work callback)returns,
   the workqueue is not really flushed, the sequence statement of
   this work callback will do some thing bad.

   So we should not allow workqueue trying to flush its own queue.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2f44583..1129cde 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -48,8 +48,6 @@ struct cpu_workqueue_struct {
 
 	struct workqueue_struct *wq;
 	struct task_struct *thread;
-
-	int run_depth;		/* Detect run_workqueue() recursion depth */
 } ____cacheline_aligned;
 
 /*
@@ -262,13 +260,6 @@ EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
 {
 	spin_lock_irq(&cwq->lock);
-	cwq->run_depth++;
-	if (cwq->run_depth > 3) {
-		/* morton gets to eat his hat */
-		printk("%s: recursion depth exceeded: %d\n",
-			__func__, cwq->run_depth);
-		dump_stack();
-	}
 	while (!list_empty(&cwq->worklist)) {
 		struct work_struct *work = list_entry(cwq->worklist.next,
 						struct work_struct, entry);
@@ -311,7 +302,6 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 		spin_lock_irq(&cwq->lock);
 		cwq->current_work = NULL;
 	}
-	cwq->run_depth--;
 	spin_unlock_irq(&cwq->lock);
 }
 
@@ -368,29 +358,20 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
 
 static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
 {
-	int active;
+	int active = 0;
+	struct wq_barrier barr;
 
-	if (cwq->thread == current) {
-		/*
-		 * Probably keventd trying to flush its own queue. So simply run
-		 * it by hand rather than deadlocking.
-		 */
-		run_workqueue(cwq);
-		active = 1;
-	} else {
-		struct wq_barrier barr;
+	BUG_ON(cwq->thread == current);
 
-		active = 0;
-		spin_lock_irq(&cwq->lock);
-		if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
-			insert_wq_barrier(cwq, &barr, &cwq->worklist);
-			active = 1;
-		}
-		spin_unlock_irq(&cwq->lock);
-
-		if (active)
-			wait_for_completion(&barr.done);
+	spin_lock_irq(&cwq->lock);
+	if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
+		insert_wq_barrier(cwq, &barr, &cwq->worklist);
+		active = 1;
 	}
+	spin_unlock_irq(&cwq->lock);
+
+	if (active)
+		wait_for_completion(&barr.done);
 
 	return active;
 }


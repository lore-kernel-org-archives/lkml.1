Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbZBFBrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbZBFBrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 20:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZBFBq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 20:46:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57402 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbZBFBq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 20:46:56 -0500
Message-ID: <498B9675.3000202@cn.fujitsu.com>
Date: Fri, 06 Feb 2009 09:46:29 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] workqueue: not allow recursion run_workqueue
References: <497838F0.7020408@cn.fujitsu.com>	 <20090122093046.GC5891@nowhere> <20090122093649.GD24758@elte.hu>	 <c62985530901220306p78ea541cs28912a844297b304@mail.gmail.com> <1232622615.4890.114.camel@laptop> <498AA0F1.2030003@cn.fujitsu.com>
In-Reply-To: <498AA0F1.2030003@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo

This is new changelog, I didn't change the patch,
except use WARN_ON instead BUG_ON.

Thanks, Lai

From: Lai Jiangshan <laijs@cn.fujitsu.com>

1) lockdep will complain when recursion run_workqueue()
2) The recursive implement of run_workqueue() makes flush_workqueue()
   and it's doc are inconsistent. It may hide deadlock and other bugs.
3) recursion run_workqueue() will poison cwq->current_work,
   but flush_work() and __cancel_work_timer() ...etc. need
   reliable cwq->current_work.

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
+	WARN_ON(cwq->thread == current);
 
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


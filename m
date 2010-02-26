Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936104Ab0BZMTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:19:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:43391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935965Ab0BZMOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:14:39 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 29/43] workqueue: implement WQ_NON_REENTRANT
Date: Fri, 26 Feb 2010 21:23:06 +0900
Message-Id: <1267187000-18791-30-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 12:13:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With gcwq managing all the workers and work->data pointing to the last
gcwq it was on, non-reentrance can be easily implemented by checking
whether the work is still running on the previous gcwq on queueing.
Implement it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |    1 +
 kernel/workqueue.c        |   32 +++++++++++++++++++++++++++++---
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index c9aef27..77a1f12 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -224,6 +224,7 @@ static inline unsigned int work_static(struct work_struct *work) { return 0; }
 enum {
 	WQ_FREEZEABLE		= 1 << 0, /* freeze during suspend */
 	WQ_SINGLE_CPU		= 1 << 1, /* only single cpu at a time */
+	WQ_NON_REENTRANT	= 1 << 2, /* guarantee non-reentrance */
 };
 
 extern struct workqueue_struct *
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0fa4ad3..c150a01 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -534,11 +534,37 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 
 	debug_work_activate(work);
 
-	/* determine gcwq to use */
+	/*
+	 * Determine gcwq to use.  SINGLE_CPU is inherently
+	 * NON_REENTRANT, so test it first.
+	 */
 	if (!(wq->flags & WQ_SINGLE_CPU)) {
-		/* just use the requested cpu for multicpu workqueues */
+		struct global_cwq *last_gcwq;
+
+		/*
+		 * It's multi cpu.  If @wq is non-reentrant and @work
+		 * was previously on a different cpu, it might still
+		 * be running there, in which case the work needs to
+		 * be queued on that cpu to guarantee non-reentrance.
+		 */
 		gcwq = get_gcwq(cpu);
-		spin_lock_irqsave(&gcwq->lock, flags);
+		if (wq->flags & WQ_NON_REENTRANT &&
+		    (last_gcwq = get_work_gcwq(work)) && last_gcwq != gcwq) {
+			struct worker *worker;
+
+			spin_lock_irqsave(&last_gcwq->lock, flags);
+
+			worker = find_worker_executing_work(last_gcwq, work);
+
+			if (worker && worker->current_cwq->wq == wq)
+				gcwq = last_gcwq;
+			else {
+				/* meh... not running there, queue here */
+				spin_unlock_irqrestore(&last_gcwq->lock, flags);
+				spin_lock_irqsave(&gcwq->lock, flags);
+			}
+		} else
+			spin_lock_irqsave(&gcwq->lock, flags);
 	} else {
 		unsigned int req_cpu = cpu;
 
-- 
1.6.4.2


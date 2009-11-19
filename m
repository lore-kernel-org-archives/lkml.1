Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbZKSSEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbZKSSEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbZKSSEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:04:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbZKSSEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:04:50 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/28] SLOW_WORK: Add support for cancellation of slow work
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:20:49 +0000
Message-ID: <20091119172049.1679.58503.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>

Add support for cancellation of queued slow work and delayed slow work items.
The cancellation functions will wait for items that are pending or undergoing
execution to be discarded by the slow work facility.

Attempting to enqueue work that is in the process of being cancelled will
result in ECANCELED.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/slow-work.txt |   12 ++++++
 include/linux/slow-work.h   |    2 +
 kernel/slow-work.c          |   81 ++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 88 insertions(+), 7 deletions(-)

diff --git a/Documentation/slow-work.txt b/Documentation/slow-work.txt
index c655c51..2e384bd 100644
--- a/Documentation/slow-work.txt
+++ b/Documentation/slow-work.txt
@@ -108,7 +108,17 @@ on the item, 0 otherwise.
 
 
 The items are reference counted, so there ought to be no need for a flush
-operation.  When all a module's slow work items have been processed, and the
+operation.  But as the reference counting is optional, means to cancel
+existing work items are also included:
+
+	cancel_slow_work(&myitem);
+
+can be used to cancel pending work.  The above cancel function waits for
+existing work to have been executed (or prevent execution of them, depending
+on timing).
+
+
+When all a module's slow work items have been processed, and the
 module has no further interest in the facility, it should unregister its
 interest:
 
diff --git a/include/linux/slow-work.h b/include/linux/slow-work.h
index 9adb2b3..eef2018 100644
--- a/include/linux/slow-work.h
+++ b/include/linux/slow-work.h
@@ -51,6 +51,7 @@ struct slow_work {
 #define SLOW_WORK_EXECUTING	1	/* item currently executing */
 #define SLOW_WORK_ENQ_DEFERRED	2	/* item enqueue deferred */
 #define SLOW_WORK_VERY_SLOW	3	/* item is very slow */
+#define SLOW_WORK_CANCELLING	4	/* item is being cancelled, don't enqueue */
 	const struct slow_work_ops *ops; /* operations table for this item */
 	struct list_head	link;	/* link in queue */
 };
@@ -88,6 +89,7 @@ static inline void vslow_work_init(struct slow_work *work,
 }
 
 extern int slow_work_enqueue(struct slow_work *work);
+extern void slow_work_cancel(struct slow_work *work);
 extern int slow_work_register_user(struct module *owner);
 extern void slow_work_unregister_user(struct module *owner);
 
diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index fccf421..671cc43 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -236,12 +236,17 @@ static bool slow_work_execute(int id)
 	if (!test_and_clear_bit(SLOW_WORK_PENDING, &work->flags))
 		BUG();
 
-	work->ops->execute(work);
+	/* don't execute if the work is in the process of being cancelled */
+	if (!test_bit(SLOW_WORK_CANCELLING, &work->flags))
+		work->ops->execute(work);
 
 	if (very_slow)
 		atomic_dec(&vslow_work_executing_count);
 	clear_bit_unlock(SLOW_WORK_EXECUTING, &work->flags);
 
+	/* wake up anyone waiting for this work to be complete */
+	wake_up_bit(&work->flags, SLOW_WORK_EXECUTING);
+
 	/* if someone tried to enqueue the item whilst we were executing it,
 	 * then it'll be left unenqueued to avoid multiple threads trying to
 	 * execute it simultaneously
@@ -314,11 +319,16 @@ auto_requeue:
  * allowed to pick items to execute.  This ensures that very slow items won't
  * overly block ones that are just ordinarily slow.
  *
- * Returns 0 if successful, -EAGAIN if not.
+ * Returns 0 if successful, -EAGAIN if not (or -ECANCELED if cancelled work is
+ * attempted queued)
  */
 int slow_work_enqueue(struct slow_work *work)
 {
 	unsigned long flags;
+	int ret;
+
+	if (test_bit(SLOW_WORK_CANCELLING, &work->flags))
+		return -ECANCELED;
 
 	BUG_ON(slow_work_user_count <= 0);
 	BUG_ON(!work);
@@ -335,6 +345,9 @@ int slow_work_enqueue(struct slow_work *work)
 	if (!test_and_set_bit_lock(SLOW_WORK_PENDING, &work->flags)) {
 		spin_lock_irqsave(&slow_work_queue_lock, flags);
 
+		if (unlikely(test_bit(SLOW_WORK_CANCELLING, &work->flags)))
+			goto cancelled;
+
 		/* we promise that we will not attempt to execute the work
 		 * function in more than one thread simultaneously
 		 *
@@ -352,8 +365,9 @@ int slow_work_enqueue(struct slow_work *work)
 		if (test_bit(SLOW_WORK_EXECUTING, &work->flags)) {
 			set_bit(SLOW_WORK_ENQ_DEFERRED, &work->flags);
 		} else {
-			if (slow_work_get_ref(work) < 0)
-				goto cant_get_ref;
+			ret = slow_work_get_ref(work);
+			if (ret < 0)
+				goto failed;
 			if (test_bit(SLOW_WORK_VERY_SLOW, &work->flags))
 				list_add_tail(&work->link, &vslow_work_queue);
 			else
@@ -365,12 +379,67 @@ int slow_work_enqueue(struct slow_work *work)
 	}
 	return 0;
 
-cant_get_ref:
+cancelled:
+	ret = -ECANCELED;
+failed:
 	spin_unlock_irqrestore(&slow_work_queue_lock, flags);
-	return -EAGAIN;
+	return ret;
 }
 EXPORT_SYMBOL(slow_work_enqueue);
 
+static int slow_work_wait(void *word)
+{
+	schedule();
+	return 0;
+}
+
+/**
+ * slow_work_cancel - Cancel a slow work item
+ * @work: The work item to cancel
+ *
+ * This function will cancel a previously enqueued work item. If we cannot
+ * cancel the work item, it is guarenteed to have run when this function
+ * returns.
+ */
+void slow_work_cancel(struct slow_work *work)
+{
+	bool wait = true, put = false;
+
+	set_bit(SLOW_WORK_CANCELLING, &work->flags);
+
+	spin_lock_irq(&slow_work_queue_lock);
+
+	if (test_bit(SLOW_WORK_PENDING, &work->flags) &&
+	    !list_empty(&work->link)) {
+		/* the link in the pending queue holds a reference on the item
+		 * that we will need to release */
+		list_del_init(&work->link);
+		wait = false;
+		put = true;
+		clear_bit(SLOW_WORK_PENDING, &work->flags);
+
+	} else if (test_and_clear_bit(SLOW_WORK_ENQ_DEFERRED, &work->flags)) {
+		/* the executor is holding our only reference on the item, so
+		 * we merely need to wait for it to finish executing */
+		clear_bit(SLOW_WORK_PENDING, &work->flags);
+	}
+
+	spin_unlock_irq(&slow_work_queue_lock);
+
+	/* the EXECUTING flag is set by the executor whilst the spinlock is set
+	 * and before the item is dequeued - so assuming the above doesn't
+	 * actually dequeue it, simply waiting for the EXECUTING flag to be
+	 * released here should be sufficient */
+	if (wait)
+		wait_on_bit(&work->flags, SLOW_WORK_EXECUTING, slow_work_wait,
+			    TASK_UNINTERRUPTIBLE);
+
+	clear_bit(SLOW_WORK_CANCELLING, &work->flags);
+	if (put)
+		slow_work_put_ref(work);
+}
+EXPORT_SYMBOL(slow_work_cancel);
+
 /*
  * Schedule a cull of the thread pool at some time in the near future
  */


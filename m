Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbZKSRU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbZKSRU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbZKSRU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:20:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbZKSRUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:20:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/28] SLOW_WORK: Add delayed_slow_work support
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:20:54 +0000
Message-ID: <20091119172054.1679.3238.stgit@warthog.procyon.org.uk>
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

This adds support for starting slow work with a delay, similar
to the functionality we have for workqueues.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/slow-work.txt |   16 +++++
 include/linux/slow-work.h   |   29 ++++++++++
 kernel/slow-work.c          |  129 ++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 171 insertions(+), 3 deletions(-)

diff --git a/Documentation/slow-work.txt b/Documentation/slow-work.txt
index 2e384bd..a9d1b0f 100644
--- a/Documentation/slow-work.txt
+++ b/Documentation/slow-work.txt
@@ -41,6 +41,13 @@ expand files, provided the time taken to do so isn't too long.
 Operations of both types may sleep during execution, thus tying up the thread
 loaned to it.
 
+A further class of work item is available, based on the slow work item class:
+
+ (*) Delayed slow work items.
+
+These are slow work items that have a timer to defer queueing of the item for
+a while.
+
 
 THREAD-TO-CLASS ALLOCATION
 --------------------------
@@ -95,6 +102,10 @@ Slow work items may then be set up by:
 
      or:
 
+	delayed_slow_work_init(&myitem, &myitem_ops);
+
+     or:
+
 	vslow_work_init(&myitem, &myitem_ops);
 
      depending on its class.
@@ -104,7 +115,9 @@ A suitably set up work item can then be enqueued for processing:
 	int ret = slow_work_enqueue(&myitem);
 
 This will return a -ve error if the thread pool is unable to gain a reference
-on the item, 0 otherwise.
+on the item, 0 otherwise, or (for delayed work):
+
+	int ret = delayed_slow_work_enqueue(&myitem, my_jiffy_delay);
 
 
 The items are reference counted, so there ought to be no need for a flush
@@ -112,6 +125,7 @@ operation.  But as the reference counting is optional, means to cancel
 existing work items are also included:
 
 	cancel_slow_work(&myitem);
+	cancel_delayed_slow_work(&myitem);
 
 can be used to cancel pending work.  The above cancel function waits for
 existing work to have been executed (or prevent execution of them, depending
diff --git a/include/linux/slow-work.h b/include/linux/slow-work.h
index eef2018..b245b9a 100644
--- a/include/linux/slow-work.h
+++ b/include/linux/slow-work.h
@@ -17,6 +17,7 @@
 #ifdef CONFIG_SLOW_WORK
 
 #include <linux/sysctl.h>
+#include <linux/timer.h>
 
 struct slow_work;
 
@@ -52,10 +53,16 @@ struct slow_work {
 #define SLOW_WORK_ENQ_DEFERRED	2	/* item enqueue deferred */
 #define SLOW_WORK_VERY_SLOW	3	/* item is very slow */
 #define SLOW_WORK_CANCELLING	4	/* item is being cancelled, don't enqueue */
+#define SLOW_WORK_DELAYED	5	/* item is struct delayed_slow_work with active timer */
 	const struct slow_work_ops *ops; /* operations table for this item */
 	struct list_head	link;	/* link in queue */
 };
 
+struct delayed_slow_work {
+	struct slow_work	work;
+	struct timer_list	timer;
+};
+
 /**
  * slow_work_init - Initialise a slow work item
  * @work: The work item to initialise
@@ -72,6 +79,20 @@ static inline void slow_work_init(struct slow_work *work,
 }
 
 /**
+ * slow_work_init - Initialise a delayed slow work item
+ * @work: The work item to initialise
+ * @ops: The operations to use to handle the slow work item
+ *
+ * Initialise a delayed slow work item.
+ */
+static inline void delayed_slow_work_init(struct delayed_slow_work *dwork,
+					  const struct slow_work_ops *ops)
+{
+	init_timer(&dwork->timer);
+	slow_work_init(&dwork->work, ops);
+}
+
+/**
  * vslow_work_init - Initialise a very slow work item
  * @work: The work item to initialise
  * @ops: The operations to use to handle the slow work item
@@ -93,6 +114,14 @@ extern void slow_work_cancel(struct slow_work *work);
 extern int slow_work_register_user(struct module *owner);
 extern void slow_work_unregister_user(struct module *owner);
 
+extern int delayed_slow_work_enqueue(struct delayed_slow_work *dwork,
+				     unsigned long delay);
+
+static inline void delayed_slow_work_cancel(struct delayed_slow_work *dwork)
+{
+	slow_work_cancel(&dwork->work);
+}
+
 #ifdef CONFIG_SYSCTL
 extern ctl_table slow_work_sysctls[];
 #endif
diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index 671cc43..f67e1da 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -406,11 +406,40 @@ void slow_work_cancel(struct slow_work *work)
 	bool wait = true, put = false;
 
 	set_bit(SLOW_WORK_CANCELLING, &work->flags);
+	smp_mb();
+
+	/* if the work item is a delayed work item with an active timer, we
+	 * need to wait for the timer to finish _before_ getting the spinlock,
+	 * lest we deadlock against the timer routine
+	 *
+	 * the timer routine will leave DELAYED set if it notices the
+	 * CANCELLING flag in time
+	 */
+	if (test_bit(SLOW_WORK_DELAYED, &work->flags)) {
+		struct delayed_slow_work *dwork =
+			container_of(work, struct delayed_slow_work, work);
+		del_timer_sync(&dwork->timer);
+	}
 
 	spin_lock_irq(&slow_work_queue_lock);
 
-	if (test_bit(SLOW_WORK_PENDING, &work->flags) &&
-	    !list_empty(&work->link)) {
+	if (test_bit(SLOW_WORK_DELAYED, &work->flags)) {
+		/* the timer routine aborted or never happened, so we are left
+		 * holding the timer's reference on the item and should just
+		 * drop the pending flag and wait for any ongoing execution to
+		 * finish */
+		struct delayed_slow_work *dwork =
+			container_of(work, struct delayed_slow_work, work);
+
+		BUG_ON(timer_pending(&dwork->timer));
+		BUG_ON(!list_empty(&work->link));
+
+		clear_bit(SLOW_WORK_DELAYED, &work->flags);
+		put = true;
+		clear_bit(SLOW_WORK_PENDING, &work->flags);
+
+	} else if (test_bit(SLOW_WORK_PENDING, &work->flags) &&
+		   !list_empty(&work->link)) {
 		/* the link in the pending queue holds a reference on the item
 		 * that we will need to release */
 		list_del_init(&work->link);
@@ -441,6 +470,102 @@ void slow_work_cancel(struct slow_work *work)
 EXPORT_SYMBOL(slow_work_cancel);
 
 /*
+ * Handle expiry of the delay timer, indicating that a delayed slow work item
+ * should now be queued if not cancelled
+ */
+static void delayed_slow_work_timer(unsigned long data)
+{
+	struct slow_work *work = (struct slow_work *) data;
+	unsigned long flags;
+	bool queued = false, put = false;
+
+	spin_lock_irqsave(&slow_work_queue_lock, flags);
+	if (likely(!test_bit(SLOW_WORK_CANCELLING, &work->flags))) {
+		clear_bit(SLOW_WORK_DELAYED, &work->flags);
+
+		if (test_bit(SLOW_WORK_EXECUTING, &work->flags)) {
+			/* we discard the reference the timer was holding in
+			 * favour of the one the executor holds */
+			set_bit(SLOW_WORK_ENQ_DEFERRED, &work->flags);
+			put = true;
+		} else {
+			if (test_bit(SLOW_WORK_VERY_SLOW, &work->flags))
+				list_add_tail(&work->link, &vslow_work_queue);
+			else
+				list_add_tail(&work->link, &slow_work_queue);
+			queued = true;
+		}
+	}
+
+	spin_unlock_irqrestore(&slow_work_queue_lock, flags);
+	if (put)
+		slow_work_put_ref(work);
+	if (queued)
+		wake_up(&slow_work_thread_wq);
+}
+
+/**
+ * delayed_slow_work_enqueue - Schedule a delayed slow work item for processing
+ * @dwork: The delayed work item to queue
+ * @delay: When to start executing the work, in jiffies from now
+ *
+ * This is similar to slow_work_enqueue(), but it adds a delay before the work
+ * is actually queued for processing.
+ *
+ * The item can have delayed processing requested on it whilst it is being
+ * executed.  The delay will begin immediately, and if it expires before the
+ * item finishes executing, the item will be placed back on the queue when it
+ * has done executing.
+ */
+int delayed_slow_work_enqueue(struct delayed_slow_work *dwork,
+			      unsigned long delay)
+{
+	struct slow_work *work = &dwork->work;
+	unsigned long flags;
+	int ret;
+
+	if (delay == 0)
+		return slow_work_enqueue(&dwork->work);
+
+	BUG_ON(slow_work_user_count <= 0);
+	BUG_ON(!work);
+	BUG_ON(!work->ops);
+
+	if (test_bit(SLOW_WORK_CANCELLING, &work->flags))
+		return -ECANCELED;
+
+	if (!test_and_set_bit_lock(SLOW_WORK_PENDING, &work->flags)) {
+		spin_lock_irqsave(&slow_work_queue_lock, flags);
+
+		if (test_bit(SLOW_WORK_CANCELLING, &work->flags))
+			goto cancelled;
+
+		/* the timer holds a reference whilst it is pending */
+		ret = work->ops->get_ref(work);
+		if (ret < 0)
+			goto cant_get_ref;
+
+		if (test_and_set_bit(SLOW_WORK_DELAYED, &work->flags))
+			BUG();
+		dwork->timer.expires = jiffies + delay;
+		dwork->timer.data = (unsigned long) work;
+		dwork->timer.function = delayed_slow_work_timer;
+		add_timer(&dwork->timer);
+
+		spin_unlock_irqrestore(&slow_work_queue_lock, flags);
+	}
+
+	return 0;
+
+cancelled:
+	ret = -ECANCELED;
+cant_get_ref:
+	spin_unlock_irqrestore(&slow_work_queue_lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL(delayed_slow_work_enqueue);
+
+/*
  * Schedule a cull of the thread pool at some time in the near future
  */
 static void slow_work_schedule_cull(void)


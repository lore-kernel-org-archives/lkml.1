Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbXEFFfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbXEFFfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 01:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbXEFFfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 01:35:18 -0400
Received: from rwcrmhc12.comcast.net ([204.127.192.82]:44156 "EHLO
	rwcrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbXEFFfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 01:35:17 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 May 2007 01:35:17 EDT
Subject: [PATCH] relay: use plain timer instead of delayed work
From: Tom Zanussi <zanussi@comcast.net>
To: akpm@linux-foundation.org
Cc: oleg@tv-sign.ru, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 05 May 2007 23:46:20 -0500
Message-Id: <1178426780.29337.67.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch makes relay use timers instead of workqueues for reader
waking.

Tom

---

relay doesn't need to use schedule_delayed_work() for waking readers
when a simple timer will do.

Signed-off-by: Tom Zanussi <zanussi@comcast.net>
---

 include/linux/relay.h |    2 +-
 kernel/relay.c        |   37 ++++++++++++++++++++-----------------
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/include/linux/relay.h b/include/linux/relay.h
index 759a0f9..cac0732 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -38,7 +38,7 @@ struct rchan_buf
 	size_t subbufs_consumed;	/* count of sub-buffers consumed */
 	struct rchan *chan;		/* associated channel */
 	wait_queue_head_t read_wait;	/* reader wait queue */
-	struct delayed_work wake_readers; /* reader wake-up work struct */
+	struct timer_list timer; 	/* reader wake-up timer */
 	struct dentry *dentry;		/* channel file dentry */
 	struct kref kref;		/* channel buffer refcount */
 	struct page **page_array;	/* array of current buffer pages */
diff --git a/kernel/relay.c b/kernel/relay.c
index 577f251..6b252be 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -310,16 +310,13 @@ static struct rchan_callbacks default_channel_callbacks = {
 
 /**
  *	wakeup_readers - wake up readers waiting on a channel
- *	@work: work struct that contains the the channel buffer
+ *	@data: contains the the channel buffer
  *
- *	This is the work function used to defer reader waking.  The
- *	reason waking is deferred is that calling directly from write
- *	causes problems if you're writing from say the scheduler.
+ *	This is the timer function used to defer reader waking.
  */
-static void wakeup_readers(struct work_struct *work)
+static void wakeup_readers(unsigned long data)
 {
-	struct rchan_buf *buf =
-		container_of(work, struct rchan_buf, wake_readers.work);
+	struct rchan_buf *buf = (struct rchan_buf *)data;
 	wake_up_interruptible(&buf->read_wait);
 }
 
@@ -337,11 +334,11 @@ static void __relay_reset(struct rchan_buf *buf, unsigned int init)
 	if (init) {
 		init_waitqueue_head(&buf->read_wait);
 		kref_init(&buf->kref);
-		INIT_DELAYED_WORK(&buf->wake_readers, NULL);
-	} else {
-		cancel_delayed_work(&buf->wake_readers);
-		flush_scheduled_work();
-	}
+		init_timer(&buf->timer);
+		buf->timer.data = (unsigned long)buf;
+		buf->timer.function = wakeup_readers;
+	} else
+		del_timer_sync(&buf->timer);
 
 	buf->subbufs_produced = 0;
 	buf->subbufs_consumed = 0;
@@ -447,8 +444,7 @@ end:
 static void relay_close_buf(struct rchan_buf *buf)
 {
 	buf->finalized = 1;
-	cancel_delayed_work(&buf->wake_readers);
-	flush_scheduled_work();
+	del_timer_sync(&buf->timer);
 	kref_put(&buf->kref, relay_remove_buf);
 }
 
@@ -609,9 +605,16 @@ size_t relay_switch_subbuf(struct rchan_buf *buf, size_t length)
 			buf->padding[old_subbuf];
 		smp_mb();
 		if (waitqueue_active(&buf->read_wait)) {
-			PREPARE_DELAYED_WORK(&buf->wake_readers,
-					     wakeup_readers);
-			schedule_delayed_work(&buf->wake_readers, 1);
+			/*
+			 * Calling wake_up_interruptible() from here
+			 * will deadlock if we happen to be logging
+			 * from the scheduler (trying to re-grab
+			 * rq->lock), so defer it.
+			 */
+			if (!timer_pending(&buf->timer)) {
+				buf->timer.expires = jiffies + 1;
+				add_timer(&buf->timer);
+			}
 		}
 	}
 




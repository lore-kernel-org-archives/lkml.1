Return-Path: <linux-kernel-owner+w=401wt.eu-S933846AbZDHMKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846AbZDHMKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933397AbZDHMAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:00:54 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48930 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933400AbZDHMAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:00:22 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 07/13] writeback: include default_backing_dev_info in writeback
Date: Wed,  8 Apr 2009 14:00:10 +0200
Message-Id: <1239192016-19857-8-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.2.446.gfbdc0
In-Reply-To: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
References: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We see dirty inodes there occasionally, so better be safe and write them
out.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c         |   60 ++++++++++++++++++++++++++------------------
 include/linux/writeback.h |    1 +
 mm/backing-dev.c          |   31 ++++++++++++++---------
 3 files changed, 55 insertions(+), 37 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 756714f..bcca7c1 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -34,6 +34,10 @@
  */
 int nr_pdflush_threads = 0;
 
+static void generic_sync_wb_inodes(struct bdi_writeback *wb,
+				   struct super_block *sb,
+				   struct writeback_control *wbc);
+
 /**
  * writeback_acquire - attempt to get exclusive writeback access to a device
  * @bdi: the device's backing_dev_info structure
@@ -149,7 +153,7 @@ int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
  * older_than_this takes precedence over nr_to_write.  So we'll only write back
  * all dirty pages if they are all attached to "old" mappings.
  */
-static void wb_kupdated(struct bdi_writeback *wb)
+void wb_kupdated(struct bdi_writeback *wb)
 {
 	long nr_to_write;
 	struct writeback_control wbc = {
@@ -177,11 +181,7 @@ static void wb_kupdated(struct bdi_writeback *wb)
 	}
 }
 
-static void generic_sync_wb_inodes(struct bdi_writeback *wb,
-				   struct super_block *sb,
-				   struct writeback_control *wbc);
-
-static void wb_writeback(struct bdi_writeback *wb)
+void wb_writeback(struct bdi_writeback *wb)
 {
 	struct writeback_control wbc = {
 		.bdi			= wb->bdi,
@@ -217,6 +217,34 @@ static void wb_writeback(struct bdi_writeback *wb)
 }
 
 /*
+ * This will be inlined in bdi_writeback_task() once we get rid of any
+ * dirty inodes on the default_backing_dev_info
+ */
+void wb_do_writeback(struct bdi_writeback *wb)
+{
+	/*
+	 * We get here in two cases:
+	 *
+	 *  schedule_timeout() returned because the dirty writeback
+	 *  interval has elapsed. If that happens, we will be able
+	 *  to acquire the writeback lock and will proceed to do
+	 *  kupdated style writeout.
+	 *
+	 *  Someone called bdi_start_writeback(), which will acquire
+	 *  the writeback lock. This means our writeback_acquire()
+	 *  below will fail and we call into bdi_pdflush() for
+	 *  pdflush style writeout.
+	 *
+	 */
+	if (writeback_acquire(wb))
+		wb_kupdated(wb);
+	else
+		wb_writeback(wb);
+
+	writeback_release(wb);
+}
+
+/*
  * Handle writeback of dirty data for the device backed by this bdi. Also
  * wakes up periodically and does kupdated style flushing.
  */
@@ -231,26 +259,8 @@ int bdi_writeback_task(struct bdi_writeback *wb)
 		schedule_timeout(wait_jiffies);
 		try_to_freeze();
 
-		/*
-		 * We get here in two cases:
-		 *
-		 *  schedule_timeout() returned because the dirty writeback
-		 *  interval has elapsed. If that happens, we will be able
-		 *  to acquire the writeback lock and will proceed to do
-		 *  kupdated style writeout.
-		 *
-		 *  Someone called bdi_start_writeback(), which will acquire
-		 *  the writeback lock. This means our writeback_acquire()
-		 *  below will fail and we call into bdi_pdflush() for
-		 *  pdflush style writeout.
-		 *
-		 */
-		if (writeback_acquire(wb))
-			wb_kupdated(wb);
-		else
-			wb_writeback(wb);
+		wb_do_writeback(wb);
 
-		writeback_release(wb);
 		finish_wait(&wb->wait, &wait);
 	}
 
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index f241794..2e08bbd 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -69,6 +69,7 @@ void writeback_inodes(struct writeback_control *wbc);
 int inode_wait(void *);
 void sync_inodes_sb(struct super_block *, int wait);
 void sync_inodes(int wait);
+void wb_do_writeback(struct bdi_writeback *wb);
 
 /* writeback.h requires fs.h; it, too, is not included from here. */
 static inline void wait_on_inode(struct inode *inode)
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 4ebcc49..9707545 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -357,14 +357,6 @@ static int bdi_forker_task(void *ptr)
 		struct bdi_writeback *wb;
 		DEFINE_WAIT(wait);
 
-		/*
-		 * Should never trigger on the default bdi
-		 */
-		if (wb_has_dirty_io(me)) {
-			bdi_flush_io(me->bdi);
-			WARN_ON(1);
-		}
-
 		prepare_to_wait(&me->wait, &wait, TASK_INTERRUPTIBLE);
 
 		smp_mb();
@@ -372,6 +364,21 @@ static int bdi_forker_task(void *ptr)
 			schedule();
 
 		finish_wait(&me->wait, &wait);
+
+		/*
+		 * Ideally we'd like not to see any dirty inodes on the
+		 * default_backing_dev_info. Until these are tracked down,
+		 * perform the same writeback here that bdi_writeback_task
+		 * does. For logic, see comment in
+		 * fs/fs-writeback.c:bdi_writeback_task()
+		 */
+		if (wb_has_dirty_io(me))
+			wb_do_writeback(me);
+
+		/*
+		 * This is our real job - check for pending entries in
+		 * bdi_pending_list, and create the tasks that got added
+		 */
 repeat:
 		bdi = NULL;
 		spin_lock_bh(&bdi_lock);
@@ -544,12 +551,12 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 			ret = -ENOMEM;
 			goto exit;
 		}
-	} else {
-		spin_lock_bh(&bdi_lock);
-		list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
-		spin_unlock_bh(&bdi_lock);
 	}
 
+	spin_lock_bh(&bdi_lock);
+	list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
+	spin_unlock_bh(&bdi_lock);
+
 	bdi->dev = dev;
 	bdi_debug_register(bdi, dev_name(dev));
 
-- 
1.6.2.2.446.gfbdc0


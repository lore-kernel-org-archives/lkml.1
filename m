Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbZCVTai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbZCVTai (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbZCVT0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:26:45 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52611 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368AbZCVT0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:26:11 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de,
       hch@infradead.org, akpm@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 09/12] writeback: include default_backing_dev_info in writeback
Date: Sun, 22 Mar 2009 20:26:01 +0100
Message-Id: <1237749964-8343-10-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.12.g83676
In-Reply-To: <1237749964-8343-1-git-send-email-jens.axboe@oracle.com>
References: <1237749964-8343-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We see dirty inodes there occasionally, so better be safe and write them
out.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c           |   60 +++++++++++++++++++++++++------------------
 include/linux/backing-dev.h |    5 +++
 include/linux/writeback.h   |    1 +
 mm/backing-dev.c            |   35 +++++++++++++++----------
 4 files changed, 62 insertions(+), 39 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 741e127..5fcdcd4 100644
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
@@ -229,26 +257,8 @@ int bdi_writeback_task(struct bdi_writeback *wb)
 		schedule_timeout(dirty_writeback_interval);
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
 
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 279bc3f..9dd8cb9 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -308,6 +308,11 @@ static inline bool bdi_cap_swap_backed(struct backing_dev_info *bdi)
 	return bdi->capabilities & BDI_CAP_SWAP_BACKED;
 }
 
+static inline bool bdi_cap_flush_forker(struct backing_dev_info *bdi)
+{
+	return bdi->capabilities & BDI_CAP_FLUSH_FORKER;
+}
+
 static inline bool mapping_cap_writeback_dirty(struct address_space *mapping)
 {
 	return bdi_cap_writeback_dirty(mapping->backing_dev_info);
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index f96fea3..5f1d59f 100644
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
index 21406f2..7551648 100644
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
@@ -489,7 +496,7 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 	 * and add other bdi's to the list. They will get a thread created
 	 * on-demand when they need it.
 	 */
-	if (bdi->capabilities & BDI_CAP_FLUSH_FORKER) {
+	if (bdi_cap_flush_forker(bdi)) {
 		struct bdi_writeback *wb;
 
 		wb = bdi_new_wb(bdi);
@@ -505,12 +512,12 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
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
 
@@ -570,7 +577,7 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 void bdi_unregister(struct backing_dev_info *bdi)
 {
 	if (bdi->dev) {
-		if (!(bdi->capabilities & BDI_CAP_FLUSH_FORKER))
+		if (!bdi_cap_flush_forker(bdi))
 			bdi_wb_shutdown(bdi);
 		bdi_debug_unregister(bdi);
 		device_unregister(bdi->dev);
-- 
1.6.2.12.g83676


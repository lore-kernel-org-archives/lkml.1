Return-Path: <linux-kernel-owner+w=401wt.eu-S933684AbZDHMLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684AbZDHMLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933410AbZDHMA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:00:56 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48997 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933407AbZDHMAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:00:38 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 13/13] writeback: ensure consistency for generic_sync_sb_inodes() with WB_SYNC_ALL
Date: Wed,  8 Apr 2009 14:00:16 +0200
Message-Id: <1239192016-19857-14-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.2.446.gfbdc0
In-Reply-To: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
References: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If WB_SYNC_ALL is given, we must block waiting for any bdi/wb to become
available and flush our data. Switch the bdi_list protection to SRCU
instead of RCU so that we can do that.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c           |   49 +++++++++++++++++++++++++++++--------------
 include/linux/backing-dev.h |   12 ++++++++-
 mm/backing-dev.c            |   23 ++++++++++++--------
 mm/page-writeback.c         |    4 +-
 4 files changed, 59 insertions(+), 29 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 1d25d3a..0492399 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -50,11 +50,18 @@ static void generic_sync_wb_inodes(struct bdi_writeback *wb,
  * unless they implement their own.  Which is somewhat inefficient, as this
  * may prevent concurrent writeback against multiple devices.
  */
-static int writeback_acquire(struct bdi_writeback *wb)
+static bool writeback_acquire(struct bdi_writeback *wb, int wait)
 {
 	struct backing_dev_info *bdi = wb->bdi;
 
-	return !test_and_set_bit(wb->nr, &bdi->wb_active);
+	if (!test_and_set_bit(wb->nr, &bdi->wb_active))
+		return 1;
+	if (!wait)
+		return 0;
+
+	wait_on_bit_lock(&bdi->wb_active, wb->nr, bdi_sched_wait,
+				TASK_UNINTERRUPTIBLE);
+	return 1;
 }
 
 /**
@@ -82,12 +89,15 @@ static void writeback_release(struct bdi_writeback *wb)
 }
 
 static void wb_start_writeback(struct bdi_writeback *wb, struct super_block *sb,
-			       long nr_pages)
+			       long nr_pages, int wait)
 {
 	if (!wb_has_dirty_io(wb))
 		return;
 
-	if (writeback_acquire(wb)) {
+	/*
+	 * Wait is set, block waiting for the device to become available
+	 */
+	if (writeback_acquire(wb, wait)) {
 		wb->nr_pages = nr_pages;
 		wb->sb = sb;
 
@@ -100,7 +110,7 @@ static void wb_start_writeback(struct bdi_writeback *wb, struct super_block *sb,
 }
 
 int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
-			 long nr_pages)
+			 long nr_pages, int wait)
 {
 	struct bdi_writeback *wb;
 
@@ -114,14 +124,14 @@ int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
 	}
 
 	if (!bdi_wblist_needs_lock(bdi))
-		wb_start_writeback(&bdi->wb, sb, nr_pages);
+		wb_start_writeback(&bdi->wb, sb, nr_pages, wait);
 	else {
 		int idx;
 
 		idx = srcu_read_lock(&bdi->srcu);
 
 		list_for_each_entry_rcu(wb, &bdi->wb_list, list)
-			wb_start_writeback(wb, sb, nr_pages);
+			wb_start_writeback(wb, sb, nr_pages, wait);
 
 		srcu_read_unlock(&bdi->srcu, idx);
 	}
@@ -244,7 +254,7 @@ long wb_do_writeback(struct bdi_writeback *wb)
 	 *  pdflush style writeout.
 	 *
 	 */
-	if (writeback_acquire(wb))
+	if (writeback_acquire(wb, 0))
 		nr_pages = wb_kupdated(wb);
 	else
 		nr_pages = wb_writeback(wb);
@@ -295,21 +305,21 @@ int bdi_writeback_task(struct bdi_writeback *wb)
 	return 0;
 }
 
-void bdi_writeback_all(struct super_block *sb, long nr_pages)
+void bdi_writeback_all(struct super_block *sb, long nr_pages, int wait)
 {
 	struct backing_dev_info *bdi;
+	int idx;
 
-	rcu_read_lock();
-
+	idx = srcu_read_lock(&bdi_srcu);
 restart:
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
 		if (!bdi_has_dirty_io(bdi))
 			continue;
-		if (bdi_start_writeback(bdi, sb, nr_pages))
+		if (bdi_start_writeback(bdi, sb, nr_pages, wait))
 			goto restart;
 	}
 
-	rcu_read_unlock();
+	srcu_read_unlock(&bdi_srcu, idx);
 }
 
 /*
@@ -828,12 +838,19 @@ void generic_sync_bdi_inodes(struct super_block *sb,
 void generic_sync_sb_inodes(struct super_block *sb,
 				struct writeback_control *wbc)
 {
+	const int sync_all = wbc->sync_mode == WB_SYNC_ALL;
+
+	/*
+	 * Kick off the specified bdi, if given, or all of them. If sync_all
+	 * is true, then this is a blocking operation and we must make sure
+	 * to wait for any device that is currently doing a writeback operation.
+	 */
 	if (wbc->bdi)
-		bdi_start_writeback(wbc->bdi, sb, 0);
+		bdi_start_writeback(wbc->bdi, sb, 0, sync_all);
 	else
-		bdi_writeback_all(sb, 0);
+		bdi_writeback_all(sb, 0, sync_all);
 
-	if (wbc->sync_mode == WB_SYNC_ALL) {
+	if (sync_all) {
 		struct inode *inode, *old_inode = NULL;
 
 		spin_lock(&inode_lock);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index c7c1ed6..8ab2429 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/srcu.h>
+#include <linux/sched.h>
 #include <asm/atomic.h>
 
 struct page;
@@ -105,15 +106,22 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
 void bdi_unregister(struct backing_dev_info *bdi);
 int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
-			 long nr_pages);
+			 long nr_pages, int wait);
 int bdi_writeback_task(struct bdi_writeback *wb);
-void bdi_writeback_all(struct super_block *sb, long nr_pages);
+void bdi_writeback_all(struct super_block *sb, long nr_pages, int wait);
 void bdi_add_default_flusher_task(struct backing_dev_info *bdi);
 void bdi_add_flusher_task(struct backing_dev_info *bdi);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
+extern struct srcu_struct bdi_srcu;
+
+static inline int bdi_sched_wait(void *word)
+{
+	schedule();
+	return 0;
+}
 
 static inline int wb_is_default_task(struct bdi_writeback *wb)
 {
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 9d6ac11..8ee7b55 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -29,6 +29,7 @@ static struct class *bdi_class;
 DEFINE_SPINLOCK(bdi_lock);
 LIST_HEAD(bdi_list);
 LIST_HEAD(bdi_pending_list);
+struct srcu_struct bdi_srcu;
 
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
@@ -220,10 +221,19 @@ static int __init default_bdi_init(void)
 {
 	int err;
 
+	err = init_srcu_struct(&bdi_srcu);
+	if (err)
+		return err;
+
 	err = bdi_init(&default_backing_dev_info);
 	if (!err)
 		bdi_register(&default_backing_dev_info, NULL, "default");
 
+	if (err) {
+		bdi_destroy(&default_backing_dev_info);
+		cleanup_srcu_struct(&bdi_srcu);
+	}
+
 	return err;
 }
 subsys_initcall(default_bdi_init);
@@ -473,12 +483,6 @@ static void bdi_add_to_pending(struct rcu_head *head)
 	wake_up(&default_backing_dev_info.wb.wait);
 }
 
-static int sched_wait(void *word)
-{
-	schedule();
-	return 0;
-}
-
 static void bdi_add_one_flusher_task(struct backing_dev_info *bdi,
 				     int(*func)(struct backing_dev_info *))
 {
@@ -513,7 +517,7 @@ static void bdi_add_one_flusher_task(struct backing_dev_info *bdi,
 
 static int flusher_add_helper_block(struct backing_dev_info *bdi)
 {
-	wait_on_bit_lock(&bdi->state, BDI_pending, sched_wait,
+	wait_on_bit_lock(&bdi->state, BDI_pending, bdi_sched_wait,
 				TASK_UNINTERRUPTIBLE);
 	return 0;
 }
@@ -620,7 +624,8 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 	 * If setup is pending, wait for that to complete first
 	 * Make sure nobody finds us on the bdi_list anymore
 	 */
-	wait_on_bit(&bdi->state, BDI_pending, sched_wait, TASK_UNINTERRUPTIBLE);
+	wait_on_bit(&bdi->state, BDI_pending, bdi_sched_wait,
+			TASK_UNINTERRUPTIBLE);
 
 	/*
 	 * Make sure nobody finds us on the bdi_list anymore
@@ -633,7 +638,7 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 	 * Now make sure that anybody who is currently looking at us from
 	 * the bdi_list iteration have exited.
 	 */
-	synchronize_rcu();
+	synchronize_srcu(&bdi_srcu);
 
 	/*
 	 * Finally, kill the kernel threads. We don't need to be RCU
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index e71e3c2..bac4ad6 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -581,7 +581,7 @@ static void balance_dirty_pages(struct address_space *mapping)
 			(!laptop_mode && (global_page_state(NR_FILE_DIRTY)
 					  + global_page_state(NR_UNSTABLE_NFS)
 					  > background_thresh)))
-		bdi_start_writeback(bdi, NULL, 0);
+		bdi_start_writeback(bdi, NULL, 0, 0);
 }
 
 void set_page_dirty_balance(struct page *page, int page_mkwrite)
@@ -675,7 +675,7 @@ int wakeup_flusher_threads(long nr_pages)
 	if (nr_pages == 0)
 		nr_pages = global_page_state(NR_FILE_DIRTY) +
 				global_page_state(NR_UNSTABLE_NFS);
-	bdi_writeback_all(NULL, nr_pages);
+	bdi_writeback_all(NULL, nr_pages, 0);
 	return 0;
 }
 
-- 
1.6.2.2.446.gfbdc0


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbZIXOlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbZIXOlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZIXOkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:40:40 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44137 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbZIXOkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:40:37 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, shaohua.li@intel.com, chris.mason@oracle.com,
       jack@suse.cz, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 07/10] writeback: get rid to incorrect references to pdflush in comments
Date: Thu, 24 Sep 2009 16:40:33 +0200
Message-Id: <1253803236-20760-8-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.3.385.g60647
In-Reply-To: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
References: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/buffer.c         |   10 +++++-----
 fs/fs-writeback.c   |    5 +----
 mm/page-writeback.c |    8 ++++----
 mm/shmem.c          |    5 +++--
 mm/vmscan.c         |    8 ++++----
 5 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 90a9886..fc22b45 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -274,7 +274,7 @@ void invalidate_bdev(struct block_device *bdev)
 }
 
 /*
- * Kick pdflush then try to free up some ZONE_NORMAL memory.
+ * Kick the writeback threads then try to free up some ZONE_NORMAL memory.
  */
 static void free_more_memory(void)
 {
@@ -1699,9 +1699,9 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 		/*
 		 * If it's a fully non-blocking write attempt and we cannot
 		 * lock the buffer then redirty the page.  Note that this can
-		 * potentially cause a busy-wait loop from pdflush and kswapd
-		 * activity, but those code paths have their own higher-level
-		 * throttling.
+		 * potentially cause a busy-wait loop from writeback threads
+		 * and kswapd activity, but those code paths have their own
+		 * higher-level throttling.
 		 */
 		if (wbc->sync_mode != WB_SYNC_NONE || !wbc->nonblocking) {
 			lock_buffer(bh);
@@ -3191,7 +3191,7 @@ void block_sync_page(struct page *page)
  * still running obsolete flush daemons, so we terminate them here.
  *
  * Use of bdflush() is deprecated and will be removed in a future kernel.
- * The `pdflush' kernel threads fully replace bdflush daemons and this call.
+ * The `flush-X' kernel threads fully replace bdflush daemons and this call.
  */
 SYSCALL_DEFINE2(bdflush, int, func, long, data)
 {
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 15e375b..15944f7 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -320,7 +320,7 @@ static bool inode_dirtied_after(struct inode *inode, unsigned long t)
 	 * For inodes being constantly redirtied, dirtied_when can get stuck.
 	 * It _appears_ to be in the future, but is actually in distant past.
 	 * This test is necessary to prevent such wrapped-around relative times
-	 * from permanently stopping the whole pdflush writeback.
+	 * from permanently stopping the whole bdi writeback.
 	 */
 	ret = ret && time_before_eq(inode->dirtied_when, jiffies);
 #endif
@@ -1085,9 +1085,6 @@ EXPORT_SYMBOL(__mark_inode_dirty);
  * If older_than_this is non-NULL, then only write out inodes which
  * had their first dirtying at a time earlier than *older_than_this.
  *
- * If we're a pdlfush thread, then implement pdflush collision avoidance
- * against the entire list.
- *
  * If `bdi' is non-zero then we're being asked to writeback a specific queue.
  * This function assumes that the blockdev superblock's inodes are backed by
  * a variety of queues, so all inodes are searched.  For other superblocks,
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 3c78fc3..8bef063 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -58,7 +58,7 @@ static inline long sync_writeback_pages(unsigned long dirtied)
 /* The following parameters are exported via /proc/sys/vm */
 
 /*
- * Start background writeback (via pdflush) at this percentage
+ * Start background writeback (via writeback threads) at this percentage
  */
 int dirty_background_ratio = 10;
 
@@ -477,8 +477,8 @@ get_dirty_limits(unsigned long *pbackground, unsigned long *pdirty,
  * balance_dirty_pages() must be called by processes which are generating dirty
  * data.  It looks at the number of dirty pages in the machine and will force
  * the caller to perform writeback if the system is over `vm_dirty_ratio'.
- * If we're over `background_thresh' then pdflush is woken to perform some
- * writeout.
+ * If we're over `background_thresh' then the writeback threads are woken to
+ * perform some writeout.
  */
 static void balance_dirty_pages(struct address_space *mapping,
 				unsigned long write_chunk)
@@ -582,7 +582,7 @@ static void balance_dirty_pages(struct address_space *mapping,
 		bdi->dirty_exceeded = 0;
 
 	if (writeback_in_progress(bdi))
-		return;		/* pdflush is already working this queue */
+		return;
 
 	/*
 	 * In laptop mode, we wait until hitting the higher threshold before
diff --git a/mm/shmem.c b/mm/shmem.c
index b206a7a..aa94811 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1046,8 +1046,9 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 	 * sync from ever calling shmem_writepage; but a stacking filesystem
 	 * may use the ->writepage of its underlying filesystem, in which case
 	 * tmpfs should write out to swap only in response to memory pressure,
-	 * and not for pdflush or sync.  However, in those cases, we do still
-	 * want to check if there's a redundant swappage to be discarded.
+	 * and not for the writeback threads or sync.  However, in those cases,
+	 * we do still want to check if there's a redundant swappage to be
+	 * discarded.
 	 */
 	if (wbc->for_reclaim)
 		swap = get_swap_page();
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 613e89f..359c3c5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1709,10 +1709,10 @@ static void shrink_zones(int priority, struct zonelist *zonelist,
  *
  * If the caller is !__GFP_FS then the probability of a failure is reasonably
  * high - the zone may be full of dirty or under-writeback pages, which this
- * caller can't do much about.  We kick pdflush and take explicit naps in the
- * hope that some of these pages can be written.  But if the allocating task
- * holds filesystem locks which prevent writeout this might not work, and the
- * allocation attempt will fail.
+ * caller can't do much about.  We kick the writeback threads and take explicit
+ * naps in the hope that some of these pages can be written.  But if the
+ * allocating task holds filesystem locks which prevent writeout this might not
+ * work, and the allocation attempt will fail.
  *
  * returns:	0, if no pages reclaimed
  * 		else, the number of pages reclaimed
-- 
1.6.4.1.207.g68ea


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbZINJh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbZINJh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 05:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbZINJhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 05:37:33 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38652 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbZINJga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 05:36:30 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 3/7] writeback: only use bdi_writeback_all() for WB_SYNC_NONE writeout
Date: Mon, 14 Sep 2009 11:36:30 +0200
Message-Id: <1252920994-11141-4-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com>
References: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Data integrity writeback must use bdi_start_writeback() and ensure
that wbc->sb and wbc->bdi are set.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |   69 ++++++++++------------------------------------------
 1 files changed, 14 insertions(+), 55 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 1873fd0..5d4bd1c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -187,7 +187,8 @@ static void bdi_wait_on_work_clear(struct bdi_work *work)
 		    TASK_UNINTERRUPTIBLE);
 }
 
-static struct bdi_work *bdi_alloc_work(struct writeback_control *wbc)
+static void bdi_alloc_queue_work(struct backing_dev_info *bdi,
+				 struct writeback_control *wbc)
 {
 	struct bdi_work *work;
 
@@ -195,7 +196,7 @@ static struct bdi_work *bdi_alloc_work(struct writeback_control *wbc)
 	if (work)
 		bdi_work_init(work, wbc);
 
-	return work;
+	bdi_queue_work(bdi, work);
 }
 
 void bdi_start_writeback(struct writeback_control *wbc)
@@ -205,11 +206,9 @@ void bdi_start_writeback(struct writeback_control *wbc)
 	 * bdi_queue_work() will wake up the thread and flush old data. This
 	 * should ensure some amount of progress in freeing memory.
 	 */
-	if (wbc->sync_mode != WB_SYNC_ALL) {
-		struct bdi_work *w = bdi_alloc_work(wbc);
-
-		bdi_queue_work(wbc->bdi, w);
-	} else {
+	if (wbc->sync_mode != WB_SYNC_ALL)
+		bdi_alloc_queue_work(wbc->bdi, wbc);
+	else {
 		struct bdi_work work;
 
 		bdi_work_init(&work, wbc);
@@ -840,67 +839,26 @@ int bdi_writeback_task(struct bdi_writeback *wb)
 }
 
 /*
- * Schedule writeback for all backing devices. Expensive! If this is a data
- * integrity operation, writeback will be complete when this returns. If
- * we are simply called for WB_SYNC_NONE, then writeback will merely be
- * scheduled to run.
+ * Schedule writeback for all backing devices. Can only be used for
+ * WB_SYNC_NONE writeback, WB_SYNC_ALL should use bdi_start_writeback()
+ * and pass in the superblock.
  */
 static void bdi_writeback_all(struct writeback_control *wbc)
 {
-	const bool must_wait = wbc->sync_mode == WB_SYNC_ALL;
 	struct backing_dev_info *bdi;
-	struct bdi_work *work;
-	LIST_HEAD(list);
 
-restart:
+	WARN_ON(wbc->sync_mode == WB_SYNC_ALL);
+
 	spin_lock(&bdi_lock);
 
 	list_for_each_entry(bdi, &bdi_list, bdi_list) {
-		struct bdi_work *work;
-
 		if (!bdi_has_dirty_io(bdi))
 			continue;
 
-		/*
-		 * If work allocation fails, do the writes inline. We drop
-		 * the lock and restart the list writeout. This should be OK,
-		 * since this happens rarely and because the writeout should
-		 * eventually make more free memory available.
-		 */
-		work = bdi_alloc_work(wbc);
-		if (!work) {
-			struct writeback_control __wbc;
-
-			/*
-			 * Not a data integrity writeout, just continue
-			 */
-			if (!must_wait)
-				continue;
-
-			spin_unlock(&bdi_lock);
-			__wbc = *wbc;
-			__wbc.bdi = bdi;
-			writeback_inodes_wbc(&__wbc);
-			goto restart;
-		}
-		if (must_wait)
-			list_add_tail(&work->wait_list, &list);
-
-		bdi_queue_work(bdi, work);
+		bdi_alloc_queue_work(bdi, wbc);
 	}
 
 	spin_unlock(&bdi_lock);
-
-	/*
-	 * If this is for WB_SYNC_ALL, wait for pending work to complete
-	 * before returning.
-	 */
-	while (!list_empty(&list)) {
-		work = list_entry(list.next, struct bdi_work, wait_list);
-		list_del(&work->wait_list);
-		bdi_wait_on_work_clear(work);
-		call_rcu(&work->rcu_head, bdi_work_free);
-	}
 }
 
 /*
@@ -1157,6 +1115,7 @@ long sync_inodes_sb(struct super_block *sb)
 {
 	struct writeback_control wbc = {
 		.sb		= sb,
+		.bdi		= sb->s_bdi,
 		.sync_mode	= WB_SYNC_ALL,
 		.range_start	= 0,
 		.range_end	= LLONG_MAX,
@@ -1164,7 +1123,7 @@ long sync_inodes_sb(struct super_block *sb)
 	long nr_to_write = LONG_MAX; /* doesn't actually matter */
 
 	wbc.nr_to_write = nr_to_write;
-	bdi_writeback_all(&wbc);
+	bdi_start_writeback(&wbc);
 	wait_sb_inodes(&wbc);
 	return nr_to_write - wbc.nr_to_write;
 }
-- 
1.6.4.1.207.g68ea


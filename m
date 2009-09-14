Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbZINJhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbZINJhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 05:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbZINJgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 05:36:39 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38662 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbZINJgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 05:36:31 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 5/7] writeback: inline allocation failure handling in bdi_alloc_queue_work()
Date: Mon, 14 Sep 2009 11:36:32 +0200
Message-Id: <1252920994-11141-6-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com>
References: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gets rid of work == NULL in bdi_queue_work() and puts the
OOM handling where it belongs.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |   55 +++++++++++++++++++++++++++-------------------------
 1 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index d7592c7..5cd8b3b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -139,21 +139,19 @@ static void wb_clear_pending(struct bdi_writeback *wb, struct bdi_work *work)
 
 static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work *work)
 {
-	if (work) {
-		work->seen = bdi->wb_mask;
-		BUG_ON(!work->seen);
-		atomic_set(&work->pending, bdi->wb_cnt);
-		BUG_ON(!bdi->wb_cnt);
+	work->seen = bdi->wb_mask;
+	BUG_ON(!work->seen);
+	atomic_set(&work->pending, bdi->wb_cnt);
+	BUG_ON(!bdi->wb_cnt);
 
-		/*
-		 * Make sure stores are seen before it appears on the list
-		 */
-		smp_mb();
+	/*
+	 * Make sure stores are seen before it appears on the list
+	 */
+	smp_mb();
 
-		spin_lock(&bdi->wb_lock);
-		list_add_tail_rcu(&work->list, &bdi->work_list);
-		spin_unlock(&bdi->wb_lock);
-	}
+	spin_lock(&bdi->wb_lock);
+	list_add_tail_rcu(&work->list, &bdi->work_list);
+	spin_unlock(&bdi->wb_lock);
 
 	/*
 	 * If the default thread isn't there, make sure we add it. When
@@ -165,14 +163,12 @@ static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work *work)
 		struct bdi_writeback *wb = &bdi->wb;
 
 		/*
-		 * If we failed allocating the bdi work item, wake up the wb
-		 * thread always. As a safety precaution, it'll flush out
-		 * everything
+		 * End work now if this wb has no dirty IO pending. Otherwise
+		 * wakeup the handling thread
 		 */
-		if (!wb_has_dirty_io(wb)) {
-			if (work)
-				wb_clear_pending(wb, work);
-		} else if (wb->task)
+		if (!wb_has_dirty_io(wb))
+			wb_clear_pending(wb, work);
+		else if (wb->task)
 			wake_up_process(wb->task);
 	}
 }
@@ -192,11 +188,20 @@ static void bdi_alloc_queue_work(struct backing_dev_info *bdi,
 {
 	struct bdi_work *work;
 
+	/*
+	 * This is WB_SYNC_NONE writeback, so if allocation fails just
+	 * wakeup the thread for old dirty data writeback
+	 */
 	work = kmalloc(sizeof(*work), GFP_ATOMIC);
-	if (work)
+	if (work) {
 		bdi_work_init(work, wbc);
+		bdi_queue_work(bdi, work);
+	} else {
+		struct bdi_writeback *wb = &bdi->wb;
 
-	bdi_queue_work(bdi, work);
+		if (wb->task)
+			wake_up_process(wb->task);
+	}
 }
 
 void bdi_start_writeback(struct writeback_control *wbc)
@@ -852,10 +857,8 @@ static void bdi_writeback_all(struct writeback_control *wbc)
 	rcu_read_lock();
 
 	list_for_each_entry(bdi, &bdi_list, bdi_list) {
-		if (!bdi_has_dirty_io(bdi))
-			continue;
-
-		bdi_alloc_queue_work(bdi, wbc);
+		if (bdi_has_dirty_io(bdi))
+			bdi_alloc_queue_work(bdi, wbc);
 	}
 
 	rcu_read_unlock();
-- 
1.6.4.1.207.g68ea


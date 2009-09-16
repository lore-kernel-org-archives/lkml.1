Return-Path: <linux-kernel-owner+w=401wt.eu-S1758700AbZIPN2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700AbZIPN2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757459AbZIPN2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:28:05 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57934 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZIPNYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:24:48 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 08/16] writeback: inline allocation failure handling in bdi_alloc_queue_work()
Date: Wed, 16 Sep 2009 15:24:46 +0200
Message-Id: <1253107494-20160-9-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com>
References: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gets rid of work == NULL in bdi_queue_work() and puts the
OOM handling where it belongs.

Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |   49 +++++++++++++++++++++++++++----------------------
 1 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index f8cd7a9..59b3ee6 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -149,21 +149,19 @@ static void wb_clear_pending(struct bdi_writeback *wb, struct bdi_work *work)
 
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
@@ -175,14 +173,12 @@ static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work *work)
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
@@ -202,11 +198,20 @@ static void bdi_alloc_queue_work(struct backing_dev_info *bdi,
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
-- 
1.6.4.1.207.g68ea


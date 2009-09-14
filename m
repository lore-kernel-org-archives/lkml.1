Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbZINJgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbZINJgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 05:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbZINJgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 05:36:43 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38663 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbZINJgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 05:36:31 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 6/7] writeback: separate starting of sync vs opportunistic writeback
Date: Mon, 14 Sep 2009 11:36:33 +0200
Message-Id: <1252920994-11141-7-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com>
References: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bdi_start_writeback() is currently split into two paths, one for
WB_SYNC_NONE and one for WB_SYNC_ALL. Add bdi_sync_writeback()
for WB_SYNC_ALL writeback and let bdi_start_writeback() handle
only WB_SYNC_NONE.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c   |   51 ++++++++++++++++++++++++++++++++++-----------------
 mm/page-writeback.c |    1 -
 2 files changed, 34 insertions(+), 18 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 5cd8b3b..64ca471 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -204,24 +204,42 @@ static void bdi_alloc_queue_work(struct backing_dev_info *bdi,
 	}
 }
 
-void bdi_start_writeback(struct writeback_control *wbc)
+/**
+ * bdi_sync_writeback - start and wait for writeback
+ * @wbc: writeback parameters
+ *
+ * Description:
+ *   This does WB_SYNC_ALL data integrity writeback and waits for the
+ *   IO to complete. Callers must hold the sb s_umount semaphore for
+ *   reading, to avoid having the super disappear before we are done.
+ */
+static void bdi_sync_writeback(struct writeback_control *wbc)
 {
-	/*
-	 * WB_SYNC_NONE is opportunistic writeback. If this allocation fails,
-	 * bdi_queue_work() will wake up the thread and flush old data. This
-	 * should ensure some amount of progress in freeing memory.
-	 */
-	if (wbc->sync_mode != WB_SYNC_ALL)
-		bdi_alloc_queue_work(wbc->bdi, wbc);
-	else {
-		struct bdi_work work;
+	struct bdi_work work;
 
-		bdi_work_init(&work, wbc);
-		work.state |= WS_ONSTACK;
+	wbc->sync_mode = WB_SYNC_ALL;
 
-		bdi_queue_work(wbc->bdi, &work);
-		bdi_wait_on_work_clear(&work);
-	}
+	bdi_work_init(&work, wbc);
+	work.state |= WS_ONSTACK;
+
+	bdi_queue_work(wbc->bdi, &work);
+	bdi_wait_on_work_clear(&work);
+}
+
+/**
+ * bdi_start_writeback - start writeback
+ * @wbc: writeback parameters
+ *
+ * Description:
+ *   This does WB_SYNC_NONE opportunistic writeback. The IO is only
+ *   started when this function returns, we make no guarentees on
+ *   completion. Caller need not hold sb s_umount semaphore.
+ *
+ */
+void bdi_start_writeback(struct writeback_control *wbc)
+{
+	wbc->sync_mode = WB_SYNC_NONE;
+	bdi_alloc_queue_work(wbc->bdi, wbc);
 }
 
 /*
@@ -1119,14 +1137,13 @@ long sync_inodes_sb(struct super_block *sb)
 	struct writeback_control wbc = {
 		.sb		= sb,
 		.bdi		= sb->s_bdi,
-		.sync_mode	= WB_SYNC_ALL,
 		.range_start	= 0,
 		.range_end	= LLONG_MAX,
 	};
 	long nr_to_write = LONG_MAX; /* doesn't actually matter */
 
 	wbc.nr_to_write = nr_to_write;
-	bdi_start_writeback(&wbc);
+	bdi_sync_writeback(&wbc);
 	wait_sb_inodes(&wbc);
 	return nr_to_write - wbc.nr_to_write;
 }
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index a5f0f76..f61f0cc 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -585,7 +585,6 @@ static void balance_dirty_pages(struct address_space *mapping)
 					  > background_thresh))) {
 		struct writeback_control wbc = {
 			.bdi		= bdi,
-			.sync_mode	= WB_SYNC_NONE,
 			.nr_to_write	= nr_writeback,
 		};
 
-- 
1.6.4.1.207.g68ea


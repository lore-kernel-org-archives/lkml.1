Return-Path: <linux-kernel-owner+w=401wt.eu-S1761774AbZE0JoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761774AbZE0JoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 05:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761398AbZE0JmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 05:42:20 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41950 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760593AbZE0Jl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 05:41:57 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 08/11] writeback: allow sleepy exit of default writeback task
Date: Wed, 27 May 2009 11:41:49 +0200
Message-Id: <1243417312-7444-9-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com>
References: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we do lazy create of default writeback tasks for a bdi, we can
allow sleepy exit if it has been completely idle for 5 minutes.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c           |   52 ++++++++++++++++++++++++++++++++++--------
 include/linux/backing-dev.h |    5 ++++
 include/linux/writeback.h   |    2 +-
 3 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 92b3df7..8ccf270 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -303,10 +303,10 @@ void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
  * older_than_this takes precedence over nr_to_write.  So we'll only write back
  * all dirty pages if they are all attached to "old" mappings.
  */
-static void wb_kupdated(struct bdi_writeback *wb)
+static long wb_kupdated(struct bdi_writeback *wb)
 {
 	unsigned long oldest_jif;
-	long nr_to_write;
+	long nr_to_write, wrote = 0;
 	struct writeback_control wbc = {
 		.bdi			= wb->bdi,
 		.sync_mode		= WB_SYNC_NONE,
@@ -327,10 +327,13 @@ static void wb_kupdated(struct bdi_writeback *wb)
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		generic_sync_wb_inodes(wb, NULL, &wbc);
+		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 		if (wbc.nr_to_write > 0)
 			break;	/* All the old data is written */
 		nr_to_write -= MAX_WRITEBACK_PAGES;
 	}
+
+	return wrote;
 }
 
 static inline bool over_bground_thresh(void)
@@ -343,7 +346,7 @@ static inline bool over_bground_thresh(void)
 		global_page_state(NR_UNSTABLE_NFS) >= background_thresh);
 }
 
-static void __wb_writeback(struct bdi_writeback *wb, long nr_pages,
+static long __wb_writeback(struct bdi_writeback *wb, long nr_pages,
 			   struct super_block *sb,
 			   enum writeback_sync_modes sync_mode)
 {
@@ -353,6 +356,7 @@ static void __wb_writeback(struct bdi_writeback *wb, long nr_pages,
 		.older_than_this	= NULL,
 		.range_cyclic		= 1,
 	};
+	long wrote = 0;
 
 	for (;;) {
 		if (sync_mode == WB_SYNC_NONE && nr_pages <= 0 &&
@@ -365,6 +369,7 @@ static void __wb_writeback(struct bdi_writeback *wb, long nr_pages,
 		wbc.pages_skipped = 0;
 		generic_sync_wb_inodes(wb, sb, &wbc);
 		nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 		/*
 		 * If we ran out of stuff to write, bail unless more_io got set
 		 */
@@ -374,6 +379,8 @@ static void __wb_writeback(struct bdi_writeback *wb, long nr_pages,
 			break;
 		}
 	}
+
+	return wrote;
 }
 
 /*
@@ -402,10 +409,11 @@ static struct bdi_work *get_next_work_item(struct backing_dev_info *bdi,
 /*
  * Retrieve work items and do the writeback they describe
  */
-static void wb_writeback(struct bdi_writeback *wb)
+static long wb_writeback(struct bdi_writeback *wb)
 {
 	struct backing_dev_info *bdi = wb->bdi;
 	struct bdi_work *work;
+	long wrote = 0;
 
 	while ((work = get_next_work_item(bdi, wb)) != NULL) {
 		struct super_block *sb = bdi_work_sb(work);
@@ -419,7 +427,7 @@ static void wb_writeback(struct bdi_writeback *wb)
 		if (sync_mode == WB_SYNC_NONE)
 			wb_clear_pending(wb, work);
 
-		__wb_writeback(wb, nr_pages, sb, sync_mode);
+		wrote += __wb_writeback(wb, nr_pages, sb, sync_mode);
 
 		/*
 		 * This is a data integrity writeback, so only do the
@@ -428,14 +436,18 @@ static void wb_writeback(struct bdi_writeback *wb)
 		if (sync_mode == WB_SYNC_ALL)
 			wb_clear_pending(wb, work);
 	}
+
+	return wrote;
 }
 
 /*
  * This will be inlined in bdi_writeback_task() once we get rid of any
  * dirty inodes on the default_backing_dev_info
  */
-void wb_do_writeback(struct bdi_writeback *wb)
+long wb_do_writeback(struct bdi_writeback *wb)
 {
+	long wrote;
+
 	/*
 	 * We get here in two cases:
 	 *
@@ -447,9 +459,11 @@ void wb_do_writeback(struct bdi_writeback *wb)
 	 *  items on the work_list. Process those.
 	 */
 	if (list_empty(&wb->bdi->work_list))
-		wb_kupdated(wb);
+		wrote = wb_kupdated(wb);
 	else
-		wb_writeback(wb);
+		wrote = wb_writeback(wb);
+
+	return wrote;
 }
 
 /*
@@ -458,12 +472,30 @@ void wb_do_writeback(struct bdi_writeback *wb)
  */
 int bdi_writeback_task(struct bdi_writeback *wb)
 {
+	unsigned long last_active = jiffies;
+	unsigned long wait_jiffies = -1UL;
+	long pages_written;
 	DEFINE_WAIT(wait);
 
 	while (!kthread_should_stop()) {
-		unsigned long wait_jiffies;
 
-		wb_do_writeback(wb);
+		pages_written = wb_do_writeback(wb);
+
+		if (pages_written)
+			last_active = jiffies;
+		else if (wait_jiffies != -1UL) {
+			unsigned long max_idle;
+
+			/*
+			 * Longest period of inactivity that we tolerate. If we
+			 * see dirty data again later, the task will get
+			 * recreated automatically.
+			 */
+			max_idle = max(5UL * 60 * HZ, wait_jiffies);
+			if (time_after(jiffies, max_idle + last_active) &&
+			    wb_is_default_task(wb))
+				break;
+		}
 
 		prepare_to_wait(&wb->wait, &wait, TASK_INTERRUPTIBLE);
 		wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 352d47d..f6d1b05 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -112,6 +112,11 @@ int bdi_has_dirty_io(struct backing_dev_info *bdi);
 extern struct mutex bdi_lock;
 extern struct list_head bdi_list;
 
+static inline int wb_is_default_task(struct bdi_writeback *wb)
+{
+	return wb == &wb->bdi->wb;
+}
+
 static inline int bdi_wblist_needs_lock(struct backing_dev_info *bdi)
 {
 	return test_bit(BDI_wblist_lock, &bdi->state);
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index e414702..30e318b 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -69,7 +69,7 @@ void writeback_inodes(struct writeback_control *wbc);
 int inode_wait(void *);
 void sync_inodes_sb(struct super_block *, int wait);
 void sync_inodes(int wait);
-void wb_do_writeback(struct bdi_writeback *wb);
+long wb_do_writeback(struct bdi_writeback *wb);
 
 /* writeback.h requires fs.h; it, too, is not included from here. */
 static inline void wait_on_inode(struct inode *inode)
-- 
1.6.3.rc0.1.gf800


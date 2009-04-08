Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbZDHMJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbZDHMJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933387AbZDHMAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:00:50 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48931 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933401AbZDHMAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:00:22 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 08/13] writeback: allow sleepy exit of default writeback task
Date: Wed,  8 Apr 2009 14:00:11 +0200
Message-Id: <1239192016-19857-9-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.2.446.gfbdc0
In-Reply-To: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
References: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we do lazy create of default writeback tasks for a bdi, we can
allow sleepy exit if it has been completely idle for 5 minutes.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c           |   44 +++++++++++++++++++++++++++++++++++-------
 include/linux/backing-dev.h |    5 ++++
 include/linux/writeback.h   |    2 +-
 3 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index bcca7c1..7ed86a0 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -153,9 +153,9 @@ int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
  * older_than_this takes precedence over nr_to_write.  So we'll only write back
  * all dirty pages if they are all attached to "old" mappings.
  */
-void wb_kupdated(struct bdi_writeback *wb)
+long wb_kupdated(struct bdi_writeback *wb)
 {
-	long nr_to_write;
+	long nr_to_write, wrote = 0;
 	struct writeback_control wbc = {
 		.bdi		= wb->bdi,
 		.sync_mode	= WB_SYNC_NONE,
@@ -175,13 +175,16 @@ void wb_kupdated(struct bdi_writeback *wb)
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		generic_sync_bdi_inodes(NULL, &wbc);
+		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 		if (wbc.nr_to_write > 0)
 			break;	/* All the old data is written */
 		nr_to_write -= MAX_WRITEBACK_PAGES;
 	}
+
+	return wrote;
 }
 
-void wb_writeback(struct bdi_writeback *wb)
+long wb_writeback(struct bdi_writeback *wb)
 {
 	struct writeback_control wbc = {
 		.bdi			= wb->bdi,
@@ -189,7 +192,7 @@ void wb_writeback(struct bdi_writeback *wb)
 		.older_than_this	= NULL,
 		.range_cyclic		= 1,
 	};
-	long nr_pages = wb->nr_pages;
+	long nr_pages = wb->nr_pages, wrote = 0;
 
 	for (;;) {
 		unsigned long background_thresh, dirty_thresh;
@@ -205,6 +208,7 @@ void wb_writeback(struct bdi_writeback *wb)
 		wbc.pages_skipped = 0;
 		generic_sync_wb_inodes(wb, wb->sb, &wbc);
 		nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 		/*
 		 * If we ran out of stuff to write, bail unless more_io got set
 		 */
@@ -214,14 +218,18 @@ void wb_writeback(struct bdi_writeback *wb)
 			break;
 		}
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
+	long nr_pages;
+
 	/*
 	 * We get here in two cases:
 	 *
@@ -237,11 +245,12 @@ void wb_do_writeback(struct bdi_writeback *wb)
 	 *
 	 */
 	if (writeback_acquire(wb))
-		wb_kupdated(wb);
+		nr_pages = wb_kupdated(wb);
 	else
-		wb_writeback(wb);
+		nr_pages = wb_writeback(wb);
 
 	writeback_release(wb);
+	return nr_pages;
 }
 
 /*
@@ -250,6 +259,9 @@ void wb_do_writeback(struct bdi_writeback *wb)
  */
 int bdi_writeback_task(struct bdi_writeback *wb)
 {
+	unsigned long last_active = jiffies;
+	long pages_written;
+
 	while (!kthread_should_stop()) {
 		unsigned long wait_jiffies;
 		DEFINE_WAIT(wait);
@@ -259,9 +271,25 @@ int bdi_writeback_task(struct bdi_writeback *wb)
 		schedule_timeout(wait_jiffies);
 		try_to_freeze();
 
-		wb_do_writeback(wb);
+		pages_written = wb_do_writeback(wb);
 
 		finish_wait(&wb->wait, &wait);
+
+		if (pages_written)
+			last_active = jiffies;
+		else {
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
 	}
 
 	return 0;
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index c596bf6..ce23ec7 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -112,6 +112,11 @@ int bdi_has_dirty_io(struct backing_dev_info *bdi);
 extern spinlock_t bdi_lock;
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
index 2e08bbd..ddb10dc 100644
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
1.6.2.2.446.gfbdc0


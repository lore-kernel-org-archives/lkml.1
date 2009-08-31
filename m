Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbZHaMPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbZHaMPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZHaMPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:15:37 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41741 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbZHaMPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:15:23 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 06/10] writeback: allow sleepy exit of default writeback task
Date: Mon, 31 Aug 2009 14:14:47 +0200
Message-Id: <1251720891-19793-7-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1251720891-19793-1-git-send-email-jens.axboe@oracle.com>
References: <1251720891-19793-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we do lazy create of default writeback tasks for a bdi, we can
allow sleepy exit if it has been completely idle for 5 minutes.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c           |   30 +++++++++++++++++++++++++-----
 include/linux/backing-dev.h |    5 +++++
 include/linux/writeback.h   |    2 +-
 3 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 0423880..7e139d5 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -373,7 +373,7 @@ static struct bdi_work *get_next_work_item(struct backing_dev_info *bdi,
 /*
  * Retrieve work items and do the writeback they describe
  */
-void wb_do_writeback(struct bdi_writeback *wb, int force_wait)
+long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 {
 	struct backing_dev_info *bdi = wb->bdi;
 	struct bdi_work *work;
@@ -417,8 +417,10 @@ void wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 				global_page_state(NR_UNSTABLE_NFS) +
 				(inodes_stat.nr_inodes - inodes_stat.nr_unused);
 
-		wb_writeback(wb, nr_pages, NULL, WB_SYNC_NONE, 1);
+		wrote = wb_writeback(wb, nr_pages, NULL, WB_SYNC_NONE, 1);
 	}
+
+	return wrote;
 }
 
 /*
@@ -427,10 +429,28 @@ void wb_do_writeback(struct bdi_writeback *wb, int force_wait)
  */
 int bdi_writeback_task(struct bdi_writeback *wb)
 {
+	unsigned long last_active = jiffies;
+	unsigned long wait_jiffies = -1UL;
+	long pages_written;
+
 	while (!kthread_should_stop()) {
-		unsigned long wait_jiffies;
+		pages_written = wb_do_writeback(wb, 0);
+
+		if (pages_written)
+			last_active = jiffies;
+		else if (wait_jiffies != -1UL) {
+			unsigned long max_idle;
 
-		wb_do_writeback(wb, 0);
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
 
 		wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
 		set_current_state(TASK_INTERRUPTIBLE);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 90a1910..7a23f2f 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -110,6 +110,11 @@ int bdi_has_dirty_io(struct backing_dev_info *bdi);
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
index 588a449..e070b91 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -68,7 +68,7 @@ struct writeback_control {
 void writeback_inodes(struct writeback_control *wbc);
 int inode_wait(void *);
 void sync_inodes_sb(struct super_block *, int wait);
-void wb_do_writeback(struct bdi_writeback *wb, int force_wait);
+long wb_do_writeback(struct bdi_writeback *wb, int force_wait);
 
 /* writeback.h requires fs.h; it, too, is not included from here. */
 static inline void wait_on_inode(struct inode *inode)
-- 
1.6.4.1.207.g68ea


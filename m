Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbZLNTt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbZLNTt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757506AbZLNTtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:49:21 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:54239 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342AbZLNTtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:49:17 -0500
From: Matthew Garrett <mjg@redhat.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH v2] laptop-mode: Make flushes per-device
Date: Mon, 14 Dec 2009 14:48:38 -0500
Message-Id: <1260820118-2200-1-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091214190827.GS8742@kernel.dk>
References: <20091214190827.GS8742@kernel.dk>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the features of laptop-mode is that it forces a writeout of dirty
pages if something else triggers a physical read or write from a device.
The current implementation flushes pages on all devices, rather than only
the one that triggered the flush. This patch alters the behaviour so that
only the recently accessed block device is flushed, preventing other
disks being spun up for no terribly good reason.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---

Changes the completion call to take a BDI rather than a request, and make
sure that there's a del_timer_sync in blk_cleanup_queue().

 block/blk-core.c            |    6 +++++-
 include/linux/backing-dev.h |    4 ++++
 include/linux/writeback.h   |    4 +++-
 mm/page-writeback.c         |   43 ++++++++++++++++++++++++++-----------------
 4 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 718897e..e293862 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -450,6 +450,7 @@ void blk_cleanup_queue(struct request_queue *q)
 	 */
 	blk_sync_queue(q);
 
+	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
 	mutex_lock(&q->sysfs_lock);
 	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
 	mutex_unlock(&q->sysfs_lock);
@@ -510,10 +511,13 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 		return NULL;
 	}
 
+	setup_timer(&q->backing_dev_info.laptop_mode_wb_timer,
+		    laptop_mode_timer_fn, (unsigned long) q);
 	init_timer(&q->unplug_timer);
 	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
 	INIT_LIST_HEAD(&q->timeout_list);
 	INIT_WORK(&q->unplug_work, blk_unplug_work);
+	INIT_WORK(&q->backing_dev_info.laptop_mode_wb_work, laptop_mode_sync);
 
 	kobject_init(&q->kobj, &blk_queue_ktype);
 
@@ -2109,7 +2113,7 @@ static void blk_finish_request(struct request *req, int error)
 	BUG_ON(blk_queued_rq(req));
 
 	if (unlikely(laptop_mode) && blk_fs_request(req))
-		laptop_io_completion();
+		laptop_io_completion(&req->q->backing_dev_info);
 
 	blk_delete_timer(req);
 
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index fcbc26a..98fed25 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
+#include <linux/timer.h>
 #include <linux/writeback.h>
 #include <asm/atomic.h>
 
@@ -88,6 +89,9 @@ struct backing_dev_info {
 
 	struct device *dev;
 
+	struct timer_list laptop_mode_wb_timer;
+	struct work_struct laptop_mode_wb_work;
+
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debug_dir;
 	struct dentry *debug_stats;
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 705f01f..c2ca22c 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -93,8 +93,10 @@ static inline void inode_sync_wait(struct inode *inode)
 /*
  * mm/page-writeback.c
  */
-void laptop_io_completion(void);
+void laptop_io_completion(struct backing_dev_info *info);
 void laptop_sync_completion(void);
+void laptop_mode_sync(struct work_struct *work);
+void laptop_mode_timer_fn(unsigned long data);
 void throttle_vm_writeout(gfp_t gfp_mask);
 
 /* These are exported to sysctl. */
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0b19943..193ca76 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -683,10 +683,6 @@ void throttle_vm_writeout(gfp_t gfp_mask)
         }
 }
 
-static void laptop_timer_fn(unsigned long unused);
-
-static DEFINE_TIMER(laptop_mode_wb_timer, laptop_timer_fn, 0, 0);
-
 /*
  * sysctl handler for /proc/sys/vm/dirty_writeback_centisecs
  */
@@ -697,21 +693,27 @@ int dirty_writeback_centisecs_handler(ctl_table *table, int write,
 	return 0;
 }
 
-static void do_laptop_sync(struct work_struct *work)
+void laptop_mode_sync(struct work_struct *work)
 {
-	wakeup_flusher_threads(0);
-	kfree(work);
+	struct backing_dev_info *bdi =
+		container_of(work, struct backing_dev_info,
+			     laptop_mode_wb_work);
+	int nr_pages = global_page_state(NR_FILE_DIRTY) +
+		global_page_state(NR_UNSTABLE_NFS);
+
+	/*
+	 * We want to write everything out, not just down to the dirty
+	 * threshold
+	 */
+	if (bdi_has_dirty_io(bdi))
+		bdi_start_writeback(bdi, NULL, nr_pages);
 }
 
-static void laptop_timer_fn(unsigned long unused)
+void laptop_mode_timer_fn(unsigned long data)
 {
-	struct work_struct *work;
+	struct request_queue *q = (struct request_queue *)data;
 
-	work = kmalloc(sizeof(*work), GFP_ATOMIC);
-	if (work) {
-		INIT_WORK(work, do_laptop_sync);
-		schedule_work(work);
-	}
+	schedule_work(&q->backing_dev_info.laptop_mode_wb_work);
 }
 
 /*
@@ -719,9 +721,9 @@ static void laptop_timer_fn(unsigned long unused)
  * of all dirty data a few seconds from now.  If the flush is already scheduled
  * then push it back - the user is still using the disk.
  */
-void laptop_io_completion(void)
+void laptop_io_completion(struct backing_dev_info *info)
 {
-	mod_timer(&laptop_mode_wb_timer, jiffies + laptop_mode);
+	mod_timer(&info->laptop_mode_wb_timer, jiffies + laptop_mode);
 }
 
 /*
@@ -731,7 +733,14 @@ void laptop_io_completion(void)
  */
 void laptop_sync_completion(void)
 {
-	del_timer(&laptop_mode_wb_timer);
+	struct backing_dev_info *bdi;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list)
+		del_timer(&bdi->laptop_mode_wb_timer);
+
+	rcu_read_unlock();
 }
 
 /*
-- 
1.6.5.2


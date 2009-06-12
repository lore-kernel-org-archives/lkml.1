Return-Path: <linux-kernel-owner+w=401wt.eu-S1761120AbZFLM5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761120AbZFLM5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758539AbZFLMyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:54:49 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52349 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757208AbZFLMyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:54:22 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, dedekind1@gmail.com,
       fweisbec@gmail.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 14/15] writeback: convert bdi_lock to a spinlock
Date: Fri, 12 Jun 2009 14:54:14 +0200
Message-Id: <1244811255-5391-15-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1244811255-5391-1-git-send-email-jens.axboe@oracle.com>
References: <1244811255-5391-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't sleep under this lock anymore, so make it a spinlock instead.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c           |   10 +++++-----
 include/linux/backing-dev.h |    2 +-
 mm/backing-dev.c            |   36 ++++++++++++++++++------------------
 mm/page-writeback.c         |    8 ++++----
 4 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index d646e02..e15a3fa 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -216,9 +216,9 @@ static void bdi_start_work(struct backing_dev_info *bdi, struct bdi_work *work)
 	 * it gets created and wakes up, we'll run this work.
 	 */
 	if (unlikely(list_empty_careful(&bdi->wb_list))) {
-		mutex_lock(&bdi_lock);
+		spin_lock(&bdi_lock);
 		bdi_add_default_flusher_task(bdi);
-		mutex_unlock(&bdi_lock);
+		spin_unlock(&bdi_lock);
 	} else
 		bdi_sched_work(bdi, work);
 }
@@ -518,7 +518,7 @@ void bdi_writeback_all(struct super_block *sb, struct writeback_control *wbc)
 	LIST_HEAD(list);
 
 restart:
-	mutex_lock(&bdi_lock);
+	spin_lock(&bdi_lock);
 
 	list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
 		struct bdi_work *work;
@@ -537,7 +537,7 @@ restart:
 			if (!must_wait)
 				continue;
 
-			mutex_unlock(&bdi_lock);
+			spin_unlock(&bdi_lock);
 			wbc->bdi = bdi;
 			generic_sync_bdi_inodes(sb, wbc);
 			goto restart;
@@ -549,7 +549,7 @@ restart:
 		__bdi_start_work(bdi, work);
 	}
 
-	mutex_unlock(&bdi_lock);
+	spin_unlock(&bdi_lock);
 
 	/*
 	 * If this is for WB_SYNC_ALL, wait for pending work to complete
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index ef7d904..6815f8b 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -111,7 +111,7 @@ void bdi_add_default_flusher_task(struct backing_dev_info *bdi);
 void bdi_add_flusher_task(struct backing_dev_info *bdi);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
 
-extern struct mutex bdi_lock;
+extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
 
 static inline int wb_is_default_task(struct bdi_writeback *wb)
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 18d1194..b3e80c5 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -26,7 +26,7 @@ struct backing_dev_info default_backing_dev_info = {
 EXPORT_SYMBOL_GPL(default_backing_dev_info);
 
 static struct class *bdi_class;
-DEFINE_MUTEX(bdi_lock);
+DEFINE_SPINLOCK(bdi_lock);
 LIST_HEAD(bdi_list);
 LIST_HEAD(bdi_pending_list);
 
@@ -357,9 +357,9 @@ static int bdi_start_fn(void *ptr)
 	/*
 	 * Add us to the active bdi_list
 	 */
-	mutex_lock(&bdi_lock);
+	spin_lock(&bdi_lock);
 	list_add(&bdi->bdi_list, &bdi_list);
-	mutex_unlock(&bdi_lock);
+	spin_unlock(&bdi_lock);
 
 	bdi_task_init(bdi, wb);
 
@@ -479,7 +479,7 @@ static int bdi_forker_task(void *ptr)
 		if (wb_has_dirty_io(me) || !list_empty(&me->bdi->work_list))
 			wb_do_writeback(me);
 
-		mutex_lock(&bdi_lock);
+		spin_lock(&bdi_lock);
 
 		/*
 		 * Check if any existing bdi's have dirty data without
@@ -497,7 +497,7 @@ static int bdi_forker_task(void *ptr)
 		if (list_empty(&bdi_pending_list)) {
 			unsigned long wait;
 
-			mutex_unlock(&bdi_lock);
+			spin_unlock(&bdi_lock);
 			wait = msecs_to_jiffies(dirty_writeback_interval * 10);
 			schedule_timeout(wait);
 			try_to_freeze();
@@ -513,7 +513,7 @@ static int bdi_forker_task(void *ptr)
 		bdi = list_entry(bdi_pending_list.next, struct backing_dev_info,
 				 bdi_list);
 		list_del_init(&bdi->bdi_list);
-		mutex_unlock(&bdi_lock);
+		spin_unlock(&bdi_lock);
 
 		wb = bdi_new_wb(bdi);
 		if (!wb)
@@ -536,9 +536,9 @@ readd_flush:
 			 * a chance to flush other bdi's to free
 			 * memory.
 			 */
-			mutex_lock(&bdi_lock);
+			spin_lock(&bdi_lock);
 			list_add_tail(&bdi->bdi_list, &bdi_pending_list);
-			mutex_unlock(&bdi_lock);
+			spin_unlock(&bdi_lock);
 
 			bdi_flush_io(bdi);
 		}
@@ -580,10 +580,10 @@ static void bdi_add_one_flusher_task(struct backing_dev_info *bdi,
 
 static int flusher_add_helper_block(struct backing_dev_info *bdi)
 {
-	mutex_unlock(&bdi_lock);
+	spin_unlock(&bdi_lock);
 	wait_on_bit_lock(&bdi->state, BDI_pending, bdi_sched_wait,
 				TASK_UNINTERRUPTIBLE);
-	mutex_lock(&bdi_lock);
+	spin_lock(&bdi_lock);
 	return 0;
 }
 
@@ -611,9 +611,9 @@ void bdi_add_default_flusher_task(struct backing_dev_info *bdi)
  */
 void bdi_add_flusher_task(struct backing_dev_info *bdi)
 {
-	mutex_lock(&bdi_lock);
+	spin_lock(&bdi_lock);
 	bdi_add_one_flusher_task(bdi, flusher_add_helper_block);
-	mutex_unlock(&bdi_lock);
+	spin_unlock(&bdi_lock);
 }
 EXPORT_SYMBOL(bdi_add_flusher_task);
 
@@ -635,9 +635,9 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		goto exit;
 	}
 
-	mutex_lock(&bdi_lock);
+	spin_lock(&bdi_lock);
 	list_add_tail(&bdi->bdi_list, &bdi_list);
-	mutex_unlock(&bdi_lock);
+	spin_unlock(&bdi_lock);
 
 	bdi->dev = dev;
 
@@ -661,9 +661,9 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 			bdi_put_wb(bdi, wb);
 			ret = -ENOMEM;
 remove_err:
-			mutex_lock(&bdi_lock);
+			spin_lock(&bdi_lock);
 			list_del(&bdi->bdi_list);
-			mutex_unlock(&bdi_lock);
+			spin_unlock(&bdi_lock);
 			goto exit;
 		}
 	}
@@ -700,9 +700,9 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 	/*
 	 * Make sure nobody finds us on the bdi_list anymore
 	 */
-	mutex_lock(&bdi_lock);
+	spin_lock(&bdi_lock);
 	list_del(&bdi->bdi_list);
-	mutex_unlock(&bdi_lock);
+	spin_unlock(&bdi_lock);
 
 	/*
 	 * Finally, kill the kernel threads. We don't need to be RCU
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 91c8615..b5f7110 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -314,7 +314,7 @@ int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
 {
 	int ret = 0;
 
-	mutex_lock(&bdi_lock);
+	spin_lock(&bdi_lock);
 	if (min_ratio > bdi->max_ratio) {
 		ret = -EINVAL;
 	} else {
@@ -326,7 +326,7 @@ int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
 			ret = -EINVAL;
 		}
 	}
-	mutex_unlock(&bdi_lock);
+	spin_unlock(&bdi_lock);
 
 	return ret;
 }
@@ -338,14 +338,14 @@ int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned max_ratio)
 	if (max_ratio > 100)
 		return -EINVAL;
 
-	mutex_lock(&bdi_lock);
+	spin_lock(&bdi_lock);
 	if (bdi->min_ratio > max_ratio) {
 		ret = -EINVAL;
 	} else {
 		bdi->max_ratio = max_ratio;
 		bdi->max_prop_frac = (PROP_FRAC_BASE * max_ratio) / 100;
 	}
-	mutex_unlock(&bdi_lock);
+	spin_unlock(&bdi_lock);
 
 	return ret;
 }
-- 
1.6.3.rc0.1.gf800


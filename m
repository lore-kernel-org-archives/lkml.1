Return-Path: <linux-kernel-owner+w=401wt.eu-S1758836AbZIPN2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbZIPN2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758008AbZIPN2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:28:00 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57933 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbZIPNYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:24:48 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 07/16] writeback: use RCU to protect bdi_list
Date: Wed, 16 Sep 2009 15:24:45 +0200
Message-Id: <1253107494-20160-8-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com>
References: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that bdi_writeback_all() no longer handles integrity writeback,
it doesn't have to block anymore. This means that we can switch
bdi_list reader side protection to RCU.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c           |    6 ++--
 include/linux/backing-dev.h |    1 +
 mm/backing-dev.c            |   76 +++++++++++++++++++++++++++++++------------
 mm/page-writeback.c         |    8 ++--
 4 files changed, 63 insertions(+), 28 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 14f06b4..f8cd7a9 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -868,16 +868,16 @@ static void bdi_writeback_all(struct writeback_control *wbc)
 
 	WARN_ON(wbc->sync_mode == WB_SYNC_ALL);
 
-	spin_lock(&bdi_lock);
+	rcu_read_lock();
 
-	list_for_each_entry(bdi, &bdi_list, bdi_list) {
+	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
 		if (!bdi_has_dirty_io(bdi))
 			continue;
 
 		bdi_alloc_queue_work(bdi, wbc);
 	}
 
-	spin_unlock(&bdi_lock);
+	rcu_read_unlock();
 }
 
 /*
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index f169bcb..859e797 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -59,6 +59,7 @@ struct bdi_writeback {
 
 struct backing_dev_info {
 	struct list_head bdi_list;
+	struct rcu_head rcu_head;
 	unsigned long ra_pages;	/* max readahead in PAGE_CACHE_SIZE units */
 	unsigned long state;	/* Always use atomic bitops on this */
 	unsigned int capabilities; /* Device capabilities */
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index d3ca0da..fd93566 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -26,6 +26,12 @@ struct backing_dev_info default_backing_dev_info = {
 EXPORT_SYMBOL_GPL(default_backing_dev_info);
 
 static struct class *bdi_class;
+
+/*
+ * bdi_lock protects updates to bdi_list and bdi_pending_list, as well as
+ * reader side protection for bdi_pending_list. bdi_list has RCU reader side
+ * locking.
+ */
 DEFINE_SPINLOCK(bdi_lock);
 LIST_HEAD(bdi_list);
 LIST_HEAD(bdi_pending_list);
@@ -284,9 +290,9 @@ static int bdi_start_fn(void *ptr)
 	/*
 	 * Add us to the active bdi_list
 	 */
-	spin_lock(&bdi_lock);
-	list_add(&bdi->bdi_list, &bdi_list);
-	spin_unlock(&bdi_lock);
+	spin_lock_bh(&bdi_lock);
+	list_add_rcu(&bdi->bdi_list, &bdi_list);
+	spin_unlock_bh(&bdi_lock);
 
 	bdi_task_init(bdi, wb);
 
@@ -389,7 +395,7 @@ static int bdi_forker_task(void *ptr)
 		if (wb_has_dirty_io(me) || !list_empty(&me->bdi->work_list))
 			wb_do_writeback(me, 0);
 
-		spin_lock(&bdi_lock);
+		spin_lock_bh(&bdi_lock);
 
 		/*
 		 * Check if any existing bdi's have dirty data without
@@ -410,7 +416,7 @@ static int bdi_forker_task(void *ptr)
 		if (list_empty(&bdi_pending_list)) {
 			unsigned long wait;
 
-			spin_unlock(&bdi_lock);
+			spin_unlock_bh(&bdi_lock);
 			wait = msecs_to_jiffies(dirty_writeback_interval * 10);
 			schedule_timeout(wait);
 			try_to_freeze();
@@ -426,7 +432,7 @@ static int bdi_forker_task(void *ptr)
 		bdi = list_entry(bdi_pending_list.next, struct backing_dev_info,
 				 bdi_list);
 		list_del_init(&bdi->bdi_list);
-		spin_unlock(&bdi_lock);
+		spin_unlock_bh(&bdi_lock);
 
 		wb = &bdi->wb;
 		wb->task = kthread_run(bdi_start_fn, wb, "flush-%s",
@@ -445,9 +451,9 @@ static int bdi_forker_task(void *ptr)
 			 * a chance to flush other bdi's to free
 			 * memory.
 			 */
-			spin_lock(&bdi_lock);
+			spin_lock_bh(&bdi_lock);
 			list_add_tail(&bdi->bdi_list, &bdi_pending_list);
-			spin_unlock(&bdi_lock);
+			spin_unlock_bh(&bdi_lock);
 
 			bdi_flush_io(bdi);
 		}
@@ -456,6 +462,24 @@ static int bdi_forker_task(void *ptr)
 	return 0;
 }
 
+static void bdi_add_to_pending(struct rcu_head *head)
+{
+	struct backing_dev_info *bdi;
+
+	bdi = container_of(head, struct backing_dev_info, rcu_head);
+	INIT_LIST_HEAD(&bdi->bdi_list);
+
+	spin_lock(&bdi_lock);
+	list_add_tail(&bdi->bdi_list, &bdi_pending_list);
+	spin_unlock(&bdi_lock);
+
+	/*
+	 * We are now on the pending list, wake up bdi_forker_task()
+	 * to finish the job and add us back to the active bdi_list
+	 */
+	wake_up_process(default_backing_dev_info.wb.task);
+}
+
 /*
  * Add the default flusher task that gets created for any bdi
  * that has dirty data pending writeout
@@ -478,16 +502,29 @@ void static bdi_add_default_flusher_task(struct backing_dev_info *bdi)
 	 * waiting for previous additions to finish.
 	 */
 	if (!test_and_set_bit(BDI_pending, &bdi->state)) {
-		list_move_tail(&bdi->bdi_list, &bdi_pending_list);
+		list_del_rcu(&bdi->bdi_list);
 
 		/*
-		 * We are now on the pending list, wake up bdi_forker_task()
-		 * to finish the job and add us back to the active bdi_list
+		 * We must wait for the current RCU period to end before
+		 * moving to the pending list. So schedule that operation
+		 * from an RCU callback.
 		 */
-		wake_up_process(default_backing_dev_info.wb.task);
+		call_rcu(&bdi->rcu_head, bdi_add_to_pending);
 	}
 }
 
+/*
+ * Remove bdi from bdi_list, and ensure that it is no longer visible
+ */
+static void bdi_remove_from_list(struct backing_dev_info *bdi)
+{
+	spin_lock_bh(&bdi_lock);
+	list_del_rcu(&bdi->bdi_list);
+	spin_unlock_bh(&bdi_lock);
+
+	synchronize_rcu();
+}
+
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...)
 {
@@ -506,9 +543,9 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		goto exit;
 	}
 
-	spin_lock(&bdi_lock);
-	list_add_tail(&bdi->bdi_list, &bdi_list);
-	spin_unlock(&bdi_lock);
+	spin_lock_bh(&bdi_lock);
+	list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
+	spin_unlock_bh(&bdi_lock);
 
 	bdi->dev = dev;
 
@@ -526,9 +563,7 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 			wb->task = NULL;
 			ret = -ENOMEM;
 
-			spin_lock(&bdi_lock);
-			list_del(&bdi->bdi_list);
-			spin_unlock(&bdi_lock);
+			bdi_remove_from_list(bdi);
 			goto exit;
 		}
 	}
@@ -565,9 +600,7 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 	/*
 	 * Make sure nobody finds us on the bdi_list anymore
 	 */
-	spin_lock(&bdi_lock);
-	list_del(&bdi->bdi_list);
-	spin_unlock(&bdi_lock);
+	bdi_remove_from_list(bdi);
 
 	/*
 	 * Finally, kill the kernel threads. We don't need to be RCU
@@ -599,6 +632,7 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->max_ratio = 100;
 	bdi->max_prop_frac = PROP_FRAC_BASE;
 	spin_lock_init(&bdi->wb_lock);
+	INIT_RCU_HEAD(&bdi->rcu_head);
 	INIT_LIST_HEAD(&bdi->bdi_list);
 	INIT_LIST_HEAD(&bdi->wb_list);
 	INIT_LIST_HEAD(&bdi->work_list);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index abc648f..12c3d84 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -315,7 +315,7 @@ int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
 {
 	int ret = 0;
 
-	spin_lock(&bdi_lock);
+	spin_lock_bh(&bdi_lock);
 	if (min_ratio > bdi->max_ratio) {
 		ret = -EINVAL;
 	} else {
@@ -327,7 +327,7 @@ int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
 			ret = -EINVAL;
 		}
 	}
-	spin_unlock(&bdi_lock);
+	spin_unlock_bh(&bdi_lock);
 
 	return ret;
 }
@@ -339,14 +339,14 @@ int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned max_ratio)
 	if (max_ratio > 100)
 		return -EINVAL;
 
-	spin_lock(&bdi_lock);
+	spin_lock_bh(&bdi_lock);
 	if (bdi->min_ratio > max_ratio) {
 		ret = -EINVAL;
 	} else {
 		bdi->max_ratio = max_ratio;
 		bdi->max_prop_frac = (PROP_FRAC_BASE * max_ratio) / 100;
 	}
-	spin_unlock(&bdi_lock);
+	spin_unlock_bh(&bdi_lock);
 
 	return ret;
 }
-- 
1.6.4.1.207.g68ea


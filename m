Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbZCLOfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbZCLOfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756453AbZCLOeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:34:05 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40029 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755652AbZCLOdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:33:53 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 6/7] writeback: add lazy bdi->task creation
Date: Thu, 12 Mar 2009 15:33:47 +0100
Message-Id: <1236868428-20408-7-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com>
References: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of creating the bdi flusher threads when the bdi is registered,
defer that to the point where we have dirty IO pending and someone
attempts to start the flushing.

A bdi is put on the normal bdi_list when it is registered. When someone
attempts to schedule writeback on this bdi, we move it to a pending list
and wake up the default bdi forker thread to take care of setting up a
task and putting the bdi back on the normal bdi_list. If task creation
should fail, the forker thread will writeout some data on behalf of the
pending bdi. This should ensure progress always.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c           |   42 +++++-----
 include/linux/backing-dev.h |    8 ++-
 mm/backing-dev.c            |  196 +++++++++++++++++++++++++++++++++++++++----
 3 files changed, 206 insertions(+), 40 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 37b042f..c25c261 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -74,14 +74,17 @@ static void writeback_release(struct backing_dev_info *bdi)
 	clear_bit(BDI_pdflush, &bdi->state);
 }
 
-void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
+int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
 			 long nr_pages)
 {
 	/*
-	 * Should not happen, complain?
+	 * This only happens the first time someone kicks this bdi, so put
+	 * it out-of-line.
 	 */
-	if (unlikely(!bdi->task))
-		return;
+	if (unlikely(!bdi->task)) {
+		bdi_add_flusher_task(bdi);
+		return 1;
+	}
 
 	if (writeback_acquire(bdi)) {
 		bdi->wb_arg.nr_pages = nr_pages;
@@ -92,6 +95,8 @@ void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
 		smp_mb();
 		wake_up(&bdi->wait);
 	}
+
+	return 0;
 }
 
 /*
@@ -185,24 +190,13 @@ static void bdi_pdflush(struct backing_dev_info *bdi)
  * Handle writeback of dirty data for the device backed by this bdi. Also
  * wakes up periodically and does kupdated style flushing.
  */
-int bdi_writeback_task(void *ptr)
+int bdi_writeback_task(struct backing_dev_info *bdi)
 {
-	struct backing_dev_info *bdi = ptr;
-	struct task_struct *tsk = current;
-
-	tsk->flags |= PF_FLUSHER | PF_SWAPWRITE;
-	set_freezable();
-
-	/*
-	 * Our parent may run at a different priority, just set us to normal
-	 */
-	set_user_nice(tsk, 0);
-
 	while (!kthread_should_stop()) {
-		DECLARE_WAITQUEUE(wait, tsk);
+		DECLARE_WAITQUEUE(wait, current);
 
 		add_wait_queue(&bdi->wait, &wait);
-		set_task_state(tsk, TASK_INTERRUPTIBLE);
+		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(dirty_writeback_interval);
 		try_to_freeze();
 
@@ -226,7 +220,7 @@ int bdi_writeback_task(void *ptr)
 			bdi_pdflush(bdi);
 
 		writeback_release(bdi);
-		set_task_state(tsk, TASK_RUNNING);
+		set_current_state(TASK_RUNNING);
 		finish_wait(&bdi->wait, &wait);
 	}
 
@@ -239,9 +233,13 @@ void bdi_writeback_all(struct super_block *sb, long nr_pages)
 
 	rcu_read_lock();
 
-	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list)
-		if (bdi_has_dirty_io(bdi))
-			bdi_start_writeback(bdi, sb, nr_pages);
+restart:
+	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
+		if (!bdi_has_dirty_io(bdi))
+			continue;
+		if (bdi_start_writeback(bdi, sb, nr_pages))
+			goto restart;
+	}
 
 	rcu_read_unlock();
 }
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 3c94fbd..b9e2085 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -24,6 +24,7 @@ struct dentry;
  */
 enum bdi_state {
 	BDI_pdflush,		/* A pdflush thread is working this device */
+	BDI_pending,		/* On its way to being activated */
 	BDI_write_congested,	/* The write queue is getting full */
 	BDI_read_congested,	/* The read queue is getting full */
 	BDI_unused,		/* Available bits start here */
@@ -46,6 +47,7 @@ struct bdi_writeback_arg {
 
 struct backing_dev_info {
 	struct list_head bdi_list;
+	struct rcu_head rcu_head;
 
 	unsigned long ra_pages;	/* max readahead in PAGE_CACHE_SIZE units */
 	unsigned long state;	/* Always use atomic bitops on this */
@@ -85,10 +87,11 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...);
 int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
 void bdi_unregister(struct backing_dev_info *bdi);
-void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
+int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
 			 long nr_pages);
-int bdi_writeback_task(void *);
+int bdi_writeback_task(struct backing_dev_info *bdi);
 void bdi_writeback_all(struct super_block *sb, long nr_pages);
+void bdi_add_flusher_task(struct backing_dev_info *bdi);
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
@@ -215,6 +218,7 @@ int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
 #define BDI_CAP_EXEC_MAP	0x00000040
 #define BDI_CAP_NO_ACCT_WB	0x00000080
 #define BDI_CAP_SWAP_BACKED	0x00000100
+#define BDI_CAP_FLUSH_FORKER	0x00000200
 
 #define BDI_CAP_VMFLAGS \
 	(BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP)
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 0096b96..500d1fc 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -2,6 +2,7 @@
 #include <linux/wait.h>
 #include <linux/backing-dev.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
@@ -18,7 +19,7 @@ EXPORT_SYMBOL(default_unplug_io_fn);
 struct backing_dev_info default_backing_dev_info = {
 	.ra_pages	= VM_MAX_READAHEAD * 1024 / PAGE_CACHE_SIZE,
 	.state		= 0,
-	.capabilities	= BDI_CAP_MAP_COPY,
+	.capabilities	= BDI_CAP_MAP_COPY | BDI_CAP_FLUSH_FORKER,
 	.unplug_io_fn	= default_unplug_io_fn,
 };
 EXPORT_SYMBOL_GPL(default_backing_dev_info);
@@ -26,6 +27,7 @@ EXPORT_SYMBOL_GPL(default_backing_dev_info);
 static struct class *bdi_class;
 DEFINE_SPINLOCK(bdi_lock);
 LIST_HEAD(bdi_list);
+LIST_HEAD(bdi_pending_list);
 
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
@@ -197,6 +199,147 @@ static int __init default_bdi_init(void)
 }
 subsys_initcall(default_bdi_init);
 
+static int bdi_start_fn(void *ptr)
+{
+	struct backing_dev_info *bdi = ptr;
+	struct task_struct *tsk = current;
+
+	/*
+	 * Add us to the active bdi_list
+	 */
+	spin_lock_bh(&bdi_lock);
+	list_add_rcu(&bdi->bdi_list, &bdi_list);
+	spin_unlock_bh(&bdi_lock);
+
+	tsk->flags |= PF_FLUSHER | PF_SWAPWRITE;
+	set_freezable();
+
+	/*
+	 * Our parent may run at a different priority, just set us to normal
+	 */
+	set_user_nice(tsk, 0);
+
+	/*
+	 * Clear pending bit and wakeup anybody waiting to tear us down
+	 */
+	clear_bit(BDI_pending, &bdi->state);
+	wake_up_bit(&bdi->state, BDI_pending);
+
+	return bdi_writeback_task(bdi);
+}
+
+static int bdi_forker_task(void *ptr)
+{
+	struct backing_dev_info *bdi = ptr;
+	struct task_struct *tsk = current;
+
+	for (;;) {
+		DECLARE_WAITQUEUE(wait, tsk);
+
+		/*
+		 * Should never trigger on the default bdi
+		 */
+		WARN_ON(bdi_has_dirty_io(bdi));
+
+		add_wait_queue(&bdi->wait, &wait);
+		set_task_state(tsk, TASK_INTERRUPTIBLE);
+		smp_mb();
+		if (list_empty(&bdi_pending_list))
+			schedule();
+		else {
+			struct backing_dev_info *bdi = NULL;
+
+			spin_lock_bh(&bdi_lock);
+			if (!list_empty(&bdi_pending_list)) {
+				bdi = list_entry(bdi_pending_list.next,
+						 struct backing_dev_info,
+						 bdi_list);
+				list_del_init(&bdi->bdi_list);
+			}
+			spin_unlock_bh(&bdi_lock);
+
+			/*
+			 * If no bdi or bdi already got setup, continue
+			 */
+			if (!bdi || bdi->task)
+				continue;
+
+			bdi->task = kthread_run(bdi_start_fn, bdi, "bdi-%s",
+						dev_name(bdi->dev));
+			/*
+			 * If task creation fails, then readd the bdi to
+			 * the pending list and force writeout of the bdi
+			 * from this forker thread. That will free some memory
+			 * and we can try again.
+			 */
+			if (!bdi->task) {
+				struct writeback_control wbc = {
+					.bdi			= bdi,
+					.sync_mode		= WB_SYNC_NONE,
+					.older_than_this	= NULL,
+					.range_cyclic		= 1,
+				};
+
+				/*
+				 * Add this 'bdi' to the back, so we get
+				 * a chance to flush other bdi's to free
+				 * memory.
+				 */
+				spin_lock_bh(&bdi_lock);
+				list_add_tail(&bdi->bdi_list,
+						&bdi_pending_list);
+				spin_unlock_bh(&bdi_lock);
+
+				wbc.nr_to_write = 1024;
+				generic_sync_bdi_inodes(NULL, &wbc);
+			}
+		}
+
+		set_task_state(tsk, TASK_RUNNING);
+		finish_wait(&bdi->wait, &wait);
+	}
+
+	return 0;
+}
+
+/*
+ * Grace period has now ended, init bdi->bdi_list and add us to the
+ * list of bdi's that are pending for task creation. Wake up
+ * bdi_forker_task() to finish the job and add us back to the
+ * active bdi_list.
+ */
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
+	wake_up(&default_backing_dev_info.wait);
+}
+
+void bdi_add_flusher_task(struct backing_dev_info *bdi)
+{
+	if (test_and_set_bit(BDI_pending, &bdi->state))
+		return;
+
+	spin_lock_bh(&bdi_lock);
+	list_del_rcu(&bdi->bdi_list);
+	spin_unlock_bh(&bdi_lock);
+
+	/*
+	 * We need to wait for the current grace period to end,
+	 * in case others were browsing the bdi_list as well.
+	 * So defer the adding and wakeup to after the RCU
+	 * grace period has ended.
+	 */
+	call_rcu(&bdi->rcu_head, bdi_add_to_pending);
+}
+
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...)
 {
@@ -215,17 +358,24 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		goto exit;
 	}
 
-	bdi->task = kthread_run(bdi_writeback_task, bdi, "bdi-%s",
-					dev_name(dev));
-	if (!bdi->task) {
-		ret = -ENOMEM;
-		goto exit;
+	/*
+	 * Just start the forker thread for our default backing_dev_info,
+	 * and add other bdi's to the list. They will get a thread created
+	 * on-demand when they need it.
+	 */
+	if (bdi->capabilities & BDI_CAP_FLUSH_FORKER) {
+		bdi->task = kthread_run(bdi_forker_task, bdi, "bdi-%s",
+						dev_name(dev));
+		if (!bdi->task) {
+			ret = -ENOMEM;
+			goto exit;
+		}
+	} else {
+		spin_lock_bh(&bdi_lock);
+		list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
+		spin_unlock_bh(&bdi_lock);
 	}
 
-	spin_lock(&bdi_lock);
-	list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
-	spin_unlock(&bdi_lock);
-
 	bdi->dev = dev;
 	bdi_debug_register(bdi, dev_name(dev));
 
@@ -240,11 +390,22 @@ int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev)
 }
 EXPORT_SYMBOL(bdi_register_dev);
 
+static int sched_wait(void *word)
+{
+	schedule();
+	return 0;
+}
+
 static void bdi_remove_from_list(struct backing_dev_info *bdi)
 {
-	spin_lock(&bdi_lock);
+	/*
+	 * If setup is pending, wait for that to complete first
+	 */
+	wait_on_bit(&bdi->state, BDI_pending, sched_wait, TASK_UNINTERRUPTIBLE);
+
+	spin_lock_bh(&bdi_lock);
 	list_del_rcu(&bdi->bdi_list);
-	spin_unlock(&bdi_lock);
+	spin_unlock_bh(&bdi_lock);
 
 	/*
 	 * In case the bdi is freed right after unregister, we need to
@@ -256,10 +417,12 @@ static void bdi_remove_from_list(struct backing_dev_info *bdi)
 void bdi_unregister(struct backing_dev_info *bdi)
 {
 	if (bdi->dev) {
-		bdi_remove_from_list(bdi);
-		if (bdi->task) {
-			kthread_stop(bdi->task);
-			bdi->task = NULL;
+		if (!(bdi->capabilities & BDI_CAP_FLUSH_FORKER)) {
+			bdi_remove_from_list(bdi);
+			if (bdi->task) {
+				kthread_stop(bdi->task);
+				bdi->task = NULL;
+			}
 		}
 		bdi_debug_unregister(bdi);
 		device_unregister(bdi->dev);
@@ -272,6 +435,7 @@ int bdi_init(struct backing_dev_info *bdi)
 {
 	int i, err;
 
+	INIT_RCU_HEAD(&bdi->rcu_head);
 	bdi->dev = NULL;
 
 	bdi->min_ratio = 0;
-- 
1.6.2


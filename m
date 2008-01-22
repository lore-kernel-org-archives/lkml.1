Return-Path: <linux-kernel-owner+w=401wt.eu-S1760518AbYAVJzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760518AbYAVJzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 04:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757818AbYAVJyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 04:54:35 -0500
Received: from brick.kernel.dk ([87.55.233.238]:8783 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756509AbYAVJy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 04:54:27 -0500
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: knikanth@novell.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/6] io context sharing: preliminary support
Date: Tue, 22 Jan 2008 10:49:17 +0100
Message-Id: <1200995361-24001-3-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.rc2.84.gf85fd
In-Reply-To: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com>
References: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detach task state from ioc, instead keep track of how many processes
are accessing the ioc.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/ll_rw_blk.c         |   27 ++++++++++++++++-----------
 fs/ioprio.c               |    1 -
 include/linux/blkdev.h    |    2 +-
 include/linux/iocontext.h |   22 ++++++++++++++++++----
 kernel/fork.c             |    1 -
 5 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index bcd0354..ca8b228 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -3834,10 +3834,10 @@ int __init blk_dev_init(void)
 /*
  * IO Context helper functions
  */
-void put_io_context(struct io_context *ioc)
+int put_io_context(struct io_context *ioc)
 {
 	if (ioc == NULL)
-		return;
+		return 1;
 
 	BUG_ON(atomic_read(&ioc->refcount) == 0);
 
@@ -3856,7 +3856,9 @@ void put_io_context(struct io_context *ioc)
 		rcu_read_unlock();
 
 		kmem_cache_free(iocontext_cachep, ioc);
+		return 1;
 	}
+	return 0;
 }
 EXPORT_SYMBOL(put_io_context);
 
@@ -3871,15 +3873,17 @@ void exit_io_context(void)
 	current->io_context = NULL;
 	task_unlock(current);
 
-	ioc->task = NULL;
-	if (ioc->aic && ioc->aic->exit)
-		ioc->aic->exit(ioc->aic);
-	if (ioc->cic_root.rb_node != NULL) {
-		cic = rb_entry(rb_first(&ioc->cic_root), struct cfq_io_context, rb_node);
-		cic->exit(ioc);
-	}
+	if (atomic_dec_and_test(&ioc->nr_tasks)) {
+		if (ioc->aic && ioc->aic->exit)
+			ioc->aic->exit(ioc->aic);
+		if (ioc->cic_root.rb_node != NULL) {
+			cic = rb_entry(rb_first(&ioc->cic_root),
+				struct cfq_io_context, rb_node);
+			cic->exit(ioc);
+		}
 
-	put_io_context(ioc);
+		put_io_context(ioc);
+	}
 }
 
 struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
@@ -3889,7 +3893,8 @@ struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
 	ret = kmem_cache_alloc_node(iocontext_cachep, gfp_flags, node);
 	if (ret) {
 		atomic_set(&ret->refcount, 1);
-		ret->task = current;
+		atomic_set(&ret->nr_tasks, 1);
+		spin_lock_init(&ret->lock);
 		ret->ioprio_changed = 0;
 		ret->ioprio = 0;
 		ret->last_waited = jiffies; /* doesn't matter... */
diff --git a/fs/ioprio.c b/fs/ioprio.c
index a760040..06b5d97 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -54,7 +54,6 @@ static int set_task_ioprio(struct task_struct *task, int ioprio)
 			break;
 		}
 		task->io_context = ioc;
-		ioc->task = task;
 	} while (1);
 
 	if (!err) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d61c6f5..1633523 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -34,7 +34,7 @@ struct sg_io_hdr;
 #define BLKDEV_MIN_RQ	4
 #define BLKDEV_MAX_RQ	128	/* Default maximum */
 
-void put_io_context(struct io_context *ioc);
+int put_io_context(struct io_context *ioc);
 void exit_io_context(void);
 struct io_context *get_io_context(gfp_t gfp_flags, int node);
 struct io_context *alloc_io_context(gfp_t, int);
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 186807e..cd44d45 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -54,13 +54,15 @@ struct cfq_io_context {
 };
 
 /*
- * This is the per-process I/O subsystem state.  It is refcounted and
- * kmalloc'ed. Currently all fields are modified in process io context
- * (apart from the atomic refcount), so require no locking.
+ * I/O subsystem state of the associated processes.  It is refcounted
+ * and kmalloc'ed. These could be shared between processes.
  */
 struct io_context {
 	atomic_t refcount;
-	struct task_struct *task;
+	atomic_t nr_tasks;
+
+	/* all the fields below are protected by this lock */
+	spinlock_t lock;
 
 	unsigned short ioprio;
 	unsigned short ioprio_changed;
@@ -76,4 +78,16 @@ struct io_context {
 	void *ioc_data;
 };
 
+static inline struct io_context *ioc_task_link(struct io_context *ioc)
+{
+	/*
+	 * if ref count is zero, don't allow sharing (ioc is going away, it's
+	 * a race).
+	 */
+	if (ioc && atomic_inc_not_zero(&ioc->refcount))
+		return ioc;
+
+	return NULL;
+}
+
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index 9961fb7..4cfb0f4 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -804,7 +804,6 @@ static int copy_io(struct task_struct *tsk)
 		if (unlikely(!tsk->io_context))
 			return -ENOMEM;
 
-		tsk->io_context->task = tsk;
 		tsk->io_context->ioprio = ioc->ioprio;
 	}
 
-- 
1.5.4.rc2.84.gf85fd


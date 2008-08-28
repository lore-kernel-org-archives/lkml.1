Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbYH1SVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbYH1SVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756762AbYH1SUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:20:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:41694 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346AbYH1SUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:20:39 -0400
From: Tejun Heo <tj@kernel.org>
To: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/5] FUSE: separate out fuse_conn_init() from new_conn()
Date: Fri, 29 Aug 2008 03:19:02 +0900
Message-Id: <1219947544-666-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219947544-666-1-git-send-email-tj@kernel.org>
References: <1219947544-666-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 18:20:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out fuse_conn_init() from new_conn() and while at it
initialize fuse_conn->entry during conn initialization.

This will be used by CUSE.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/fuse_i.h |    5 ++
 fs/fuse/inode.c  |  116 +++++++++++++++++++++++++++++------------------------
 2 files changed, 68 insertions(+), 53 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index bc55f6d..4795264 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -679,6 +679,11 @@ void fuse_invalidate_entry_cache(struct dentry *entry);
 struct fuse_conn *fuse_conn_get(struct fuse_conn *fc);
 
 /**
+ * Initialize fuse_conn
+ */
+int fuse_conn_init(struct fuse_conn *fc, struct super_block *sb);
+
+/**
  * Release reference to fuse_conn
  */
 void fuse_conn_put(struct fuse_conn *fc);
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index fae8732..8d092ea 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -462,66 +462,76 @@ static int fuse_show_options(struct seq_file *m, struct vfsmount *mnt)
 	return 0;
 }
 
-static struct fuse_conn *new_conn(struct super_block *sb)
+int fuse_conn_init(struct fuse_conn *fc, struct super_block *sb)
 {
-	struct fuse_conn *fc;
 	int err;
 
-	fc = kzalloc(sizeof(*fc), GFP_KERNEL);
-	if (fc) {
-		spin_lock_init(&fc->lock);
-		mutex_init(&fc->inst_mutex);
-		atomic_set(&fc->count, 1);
-		init_waitqueue_head(&fc->waitq);
-		init_waitqueue_head(&fc->blocked_waitq);
-		init_waitqueue_head(&fc->reserved_req_waitq);
-		INIT_LIST_HEAD(&fc->pending);
-		INIT_LIST_HEAD(&fc->processing);
-		INIT_LIST_HEAD(&fc->io);
-		INIT_LIST_HEAD(&fc->interrupts);
-		INIT_LIST_HEAD(&fc->bg_queue);
-		atomic_set(&fc->num_waiting, 0);
-		fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
-		fc->bdi.unplug_io_fn = default_unplug_io_fn;
-		/* fuse does it's own writeback accounting */
-		fc->bdi.capabilities = BDI_CAP_NO_ACCT_WB;
-		fc->polled_files = RB_ROOT;
-		fc->dev = sb->s_dev;
-		err = bdi_init(&fc->bdi);
-		if (err)
-			goto error_kfree;
-		if (sb->s_bdev) {
-			err = bdi_register(&fc->bdi, NULL, "%u:%u-fuseblk",
-					   MAJOR(fc->dev), MINOR(fc->dev));
-		} else {
-			err = bdi_register_dev(&fc->bdi, fc->dev);
-		}
-		if (err)
-			goto error_bdi_destroy;
-		/*
-		 * For a single fuse filesystem use max 1% of dirty +
-		 * writeback threshold.
-		 *
-		 * This gives about 1M of write buffer for memory maps on a
-		 * machine with 1G and 10% dirty_ratio, which should be more
-		 * than enough.
-		 *
-		 * Privileged users can raise it by writing to
-		 *
-		 *    /sys/class/bdi/<bdi>/max_ratio
-		 */
-		bdi_set_max_ratio(&fc->bdi, 1);
-		fc->reqctr = 0;
-		fc->blocked = 1;
-		fc->attr_version = 1;
-		get_random_bytes(&fc->scramble_key, sizeof(fc->scramble_key));
+	memset(fc, 0, sizeof(*fc));
+	spin_lock_init(&fc->lock);
+	mutex_init(&fc->inst_mutex);
+	atomic_set(&fc->count, 1);
+	init_waitqueue_head(&fc->waitq);
+	init_waitqueue_head(&fc->blocked_waitq);
+	init_waitqueue_head(&fc->reserved_req_waitq);
+	INIT_LIST_HEAD(&fc->pending);
+	INIT_LIST_HEAD(&fc->processing);
+	INIT_LIST_HEAD(&fc->io);
+	INIT_LIST_HEAD(&fc->interrupts);
+	INIT_LIST_HEAD(&fc->bg_queue);
+	INIT_LIST_HEAD(&fc->entry);
+	atomic_set(&fc->num_waiting, 0);
+	fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
+	fc->bdi.unplug_io_fn = default_unplug_io_fn;
+	/* fuse does it's own writeback accounting */
+	fc->bdi.capabilities = BDI_CAP_NO_ACCT_WB;
+	fc->polled_files = RB_ROOT;
+	fc->dev = sb->s_dev;
+	err = bdi_init(&fc->bdi);
+	if (err)
+		goto error_mutex_destroy;
+	if (sb->s_bdev) {
+		err = bdi_register(&fc->bdi, NULL, "%u:%u-fuseblk",
+				   MAJOR(fc->dev), MINOR(fc->dev));
+	} else {
+		err = bdi_register_dev(&fc->bdi, fc->dev);
 	}
-	return fc;
+	if (err)
+		goto error_bdi_destroy;
+	/*
+	 * For a single fuse filesystem use max 1% of dirty +
+	 * writeback threshold.
+	 *
+	 * This gives about 1M of write buffer for memory maps on a
+	 * machine with 1G and 10% dirty_ratio, which should be more
+	 * than enough.
+	 *
+	 * Privileged users can raise it by writing to
+	 *
+	 *    /sys/class/bdi/<bdi>/max_ratio
+	 */
+	bdi_set_max_ratio(&fc->bdi, 1);
+	fc->reqctr = 0;
+	fc->blocked = 1;
+	fc->attr_version = 1;
+	get_random_bytes(&fc->scramble_key, sizeof(fc->scramble_key));
 
-error_bdi_destroy:
+	return 0;
+
+ error_bdi_destroy:
 	bdi_destroy(&fc->bdi);
-error_kfree:
+ error_mutex_destroy:
 	mutex_destroy(&fc->inst_mutex);
+	return err;
+}
+EXPORT_SYMBOL_GPL(fuse_conn_init);
+
+static struct fuse_conn *new_conn(struct super_block *sb)
+{
+	struct fuse_conn *fc;
+
+	fc = kmalloc(sizeof(*fc), GFP_KERNEL);
+	if (fc && fuse_conn_init(fc, sb) == 0)
+		return fc;
 	kfree(fc);
 	return NULL;
 }
-- 
1.5.4.5


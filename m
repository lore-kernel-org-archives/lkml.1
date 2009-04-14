Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbZDNB5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbZDNB5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 21:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZDNB4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 21:56:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:56159 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbZDNB4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 21:56:43 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] FUSE: update fuse_conn_init() and separate out fuse_conn_kill()
Date: Tue, 14 Apr 2009 10:54:52 +0900
Message-Id: <1239674094-30894-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1239674094-30894-1-git-send-email-tj@kernel.org>
References: <1239674094-30894-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 01:55:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update fuse_conn_init() such that it takes @devt and @bdev instead of
@sb and skip bdi registration if device number is not available.
Also, separate out fuse_conn_kill() from fuse_put_super() and export
it.

These will be used to implement cuse.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/fuse_i.h |    7 ++++++-
 fs/fuse/inode.c  |   49 +++++++++++++++++++++++++++++--------------------
 2 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 016a745..d2643df 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -679,7 +679,12 @@ struct fuse_conn *fuse_conn_get(struct fuse_conn *fc);
 /**
  * Initialize fuse_conn
  */
-int fuse_conn_init(struct fuse_conn *fc, struct super_block *sb);
+int fuse_conn_init(struct fuse_conn *fc, dev_t devt, struct block_device *bdev);
+
+/**
+ * Destroy fuse_conn
+ */
+void fuse_conn_kill(struct fuse_conn *fc);
 
 /**
  * Release reference to fuse_conn
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 459b73d..699b228 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -279,20 +279,7 @@ static void fuse_put_super(struct super_block *sb)
 	struct fuse_conn *fc = get_fuse_conn_super(sb);
 
 	fuse_send_destroy(fc);
-	spin_lock(&fc->lock);
-	fc->connected = 0;
-	fc->blocked = 0;
-	spin_unlock(&fc->lock);
-	/* Flush all readers on this fs */
-	kill_fasync(&fc->fasync, SIGIO, POLL_IN);
-	wake_up_all(&fc->waitq);
-	wake_up_all(&fc->blocked_waitq);
-	wake_up_all(&fc->reserved_req_waitq);
-	mutex_lock(&fuse_mutex);
-	list_del(&fc->entry);
-	fuse_ctl_remove_conn(fc);
-	mutex_unlock(&fuse_mutex);
-	bdi_destroy(&fc->bdi);
+	fuse_conn_kill(fc);
 	fuse_conn_put(fc);
 }
 
@@ -463,7 +450,7 @@ static int fuse_show_options(struct seq_file *m, struct vfsmount *mnt)
 	return 0;
 }
 
-int fuse_conn_init(struct fuse_conn *fc, struct super_block *sb)
+int fuse_conn_init(struct fuse_conn *fc, dev_t devt, struct block_device *bdev)
 {
 	int err;
 
@@ -487,18 +474,21 @@ int fuse_conn_init(struct fuse_conn *fc, struct super_block *sb)
 	fc->bdi.capabilities = BDI_CAP_NO_ACCT_WB;
 	fc->khctr = 0;
 	fc->polled_files = RB_ROOT;
-	fc->dev = sb->s_dev;
+	fc->dev = devt;
 	err = bdi_init(&fc->bdi);
+
 	if (err)
 		goto error_mutex_destroy;
-	if (sb->s_bdev) {
+
+	if (bdev)
 		err = bdi_register(&fc->bdi, NULL, "%u:%u-fuseblk",
 				   MAJOR(fc->dev), MINOR(fc->dev));
-	} else {
+	else if (fc->dev)
 		err = bdi_register_dev(&fc->bdi, fc->dev);
-	}
+
 	if (err)
 		goto error_bdi_destroy;
+
 	/*
 	 * For a single fuse filesystem use max 1% of dirty +
 	 * writeback threshold.
@@ -527,6 +517,25 @@ int fuse_conn_init(struct fuse_conn *fc, struct super_block *sb)
 }
 EXPORT_SYMBOL_GPL(fuse_conn_init);
 
+void fuse_conn_kill(struct fuse_conn *fc)
+{
+	spin_lock(&fc->lock);
+	fc->connected = 0;
+	fc->blocked = 0;
+	spin_unlock(&fc->lock);
+	/* Flush all readers on this fs */
+	kill_fasync(&fc->fasync, SIGIO, POLL_IN);
+	wake_up_all(&fc->waitq);
+	wake_up_all(&fc->blocked_waitq);
+	wake_up_all(&fc->reserved_req_waitq);
+	mutex_lock(&fuse_mutex);
+	list_del(&fc->entry);
+	fuse_ctl_remove_conn(fc);
+	mutex_unlock(&fuse_mutex);
+	bdi_destroy(&fc->bdi);
+}
+EXPORT_SYMBOL_GPL(fuse_conn_kill);
+
 void fuse_conn_put(struct fuse_conn *fc)
 {
 	if (atomic_dec_and_test(&fc->count)) {
@@ -840,7 +849,7 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 	if (!fc)
 		goto err_fput;
 
-	err = fuse_conn_init(fc, sb);
+	err = fuse_conn_init(fc, sb->s_dev, sb->s_bdev);
 	if (err) {
 		kfree(fc);
 		goto err_fput;
-- 
1.6.0.2


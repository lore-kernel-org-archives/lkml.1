Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbZDNB5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbZDNB5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 21:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbZDNB4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 21:56:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:56157 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbZDNB4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 21:56:43 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] FUSE: misc cleanups
Date: Tue, 14 Apr 2009 10:54:49 +0900
Message-Id: <1239674094-30894-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1239674094-30894-1-git-send-email-tj@kernel.org>
References: <1239674094-30894-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 01:55:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* fuse_file_alloc() was structured in weird way.  The success path was
  split between else block and code following the block.  Restructure
  the code such that it's easier to read and modify.

* Unindent success path of fuse_release_common() to ease future
  changes.

* Rename fuse_file_do_ioctl() to fuse_file_ioctl_common() for
  consistency.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/file.c |   89 ++++++++++++++++++++++++++++++--------------------------
 1 files changed, 48 insertions(+), 41 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 2b25133..01c7245 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -49,22 +49,26 @@ static int fuse_send_open(struct inode *inode, struct file *file, int isdir,
 struct fuse_file *fuse_file_alloc(struct fuse_conn *fc)
 {
 	struct fuse_file *ff;
+
 	ff = kmalloc(sizeof(struct fuse_file), GFP_KERNEL);
-	if (ff) {
-		ff->reserved_req = fuse_request_alloc();
-		if (!ff->reserved_req) {
-			kfree(ff);
-			return NULL;
-		} else {
-			INIT_LIST_HEAD(&ff->write_entry);
-			atomic_set(&ff->count, 0);
-			spin_lock(&fc->lock);
-			ff->kh = ++fc->khctr;
-			spin_unlock(&fc->lock);
-		}
-		RB_CLEAR_NODE(&ff->polled_node);
-		init_waitqueue_head(&ff->poll_wait);
+	if (unlikely(!ff))
+		return NULL;
+
+	ff->reserved_req = fuse_request_alloc();
+	if (unlikely(!ff->reserved_req)) {
+		kfree(ff);
+		return NULL;
 	}
+
+	INIT_LIST_HEAD(&ff->write_entry);
+	atomic_set(&ff->count, 0);
+	RB_CLEAR_NODE(&ff->polled_node);
+	init_waitqueue_head(&ff->poll_wait);
+
+	spin_lock(&fc->lock);
+	ff->kh = ++fc->khctr;
+	spin_unlock(&fc->lock);
+
 	return ff;
 }
 
@@ -158,34 +162,37 @@ void fuse_release_fill(struct fuse_file *ff, u64 nodeid, int flags, int opcode)
 
 int fuse_release_common(struct inode *inode, struct file *file, int isdir)
 {
-	struct fuse_file *ff = file->private_data;
-	if (ff) {
-		struct fuse_conn *fc = get_fuse_conn(inode);
-		struct fuse_req *req = ff->reserved_req;
+	struct fuse_conn *fc;
+	struct fuse_file *ff;
+	struct fuse_req *req;
 
-		fuse_release_fill(ff, get_node_id(inode), file->f_flags,
-				  isdir ? FUSE_RELEASEDIR : FUSE_RELEASE);
+	ff = file->private_data;
+	if (unlikely(!ff))
+		return 0;	/* return value is ignored by VFS */
 
-		/* Hold vfsmount and dentry until release is finished */
-		req->misc.release.vfsmount = mntget(file->f_path.mnt);
-		req->misc.release.dentry = dget(file->f_path.dentry);
+	fc = get_fuse_conn(inode);
+	req = ff->reserved_req;
 
-		spin_lock(&fc->lock);
-		list_del(&ff->write_entry);
-		if (!RB_EMPTY_NODE(&ff->polled_node))
-			rb_erase(&ff->polled_node, &fc->polled_files);
-		spin_unlock(&fc->lock);
+	fuse_release_fill(ff, get_node_id(inode), file->f_flags,
+			  isdir ? FUSE_RELEASEDIR : FUSE_RELEASE);
 
-		wake_up_interruptible_sync(&ff->poll_wait);
-		/*
-		 * Normally this will send the RELEASE request,
-		 * however if some asynchronous READ or WRITE requests
-		 * are outstanding, the sending will be delayed
-		 */
-		fuse_file_put(ff);
-	}
+	/* Hold vfsmount and dentry until release is finished */
+	req->misc.release.vfsmount = mntget(file->f_path.mnt);
+	req->misc.release.dentry = dget(file->f_path.dentry);
+
+	spin_lock(&fc->lock);
+	list_del(&ff->write_entry);
+	if (!RB_EMPTY_NODE(&ff->polled_node))
+		rb_erase(&ff->polled_node, &fc->polled_files);
+	spin_unlock(&fc->lock);
 
-	/* Return value is ignored by VFS */
+	wake_up_interruptible_sync(&ff->poll_wait);
+	/*
+	 * Normally this will send the RELEASE request, however if
+	 * some asynchronous READ or WRITE requests are outstanding,
+	 * the sending will be delayed.
+	 */
+	fuse_file_put(ff);
 	return 0;
 }
 
@@ -1601,8 +1608,8 @@ static int fuse_ioctl_copy_user(struct page **pages, struct iovec *iov,
  * limits ioctl data transfers to well-formed ioctls and is the forced
  * behavior for all FUSE servers.
  */
-static long fuse_file_do_ioctl(struct file *file, unsigned int cmd,
-			       unsigned long arg, unsigned int flags)
+static long fuse_file_ioctl_common(struct file *file, unsigned int cmd,
+				   unsigned long arg, unsigned int flags)
 {
 	struct inode *inode = file->f_dentry->d_inode;
 	struct fuse_file *ff = file->private_data;
@@ -1779,13 +1786,13 @@ static long fuse_file_do_ioctl(struct file *file, unsigned int cmd,
 static long fuse_file_ioctl(struct file *file, unsigned int cmd,
 			    unsigned long arg)
 {
-	return fuse_file_do_ioctl(file, cmd, arg, 0);
+	return fuse_file_ioctl_common(file, cmd, arg, 0);
 }
 
 static long fuse_file_compat_ioctl(struct file *file, unsigned int cmd,
 				   unsigned long arg)
 {
-	return fuse_file_do_ioctl(file, cmd, arg, FUSE_IOCTL_COMPAT);
+	return fuse_file_ioctl_common(file, cmd, arg, FUSE_IOCTL_COMPAT);
 }
 
 /*
-- 
1.6.0.2


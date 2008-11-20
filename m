Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbYKTOMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbYKTOMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbYKTOMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:12:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:34821 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828AbYKTOMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:12:03 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/5] FUSE: add file kernel handle
Date: Thu, 20 Nov 2008 23:11:36 +0900
Message-Id: <1227190298-4585-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1227190298-4585-1-git-send-email-tj@kernel.org>
References: <1227190298-4585-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 20 Nov 2008 14:11:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file handle, fuse_file->fh, is opaque value supplied by userland
FUSE server and uniqueness is not guaranteed.  Add file kernel handle,
fuse_file->kh, which is allocated by the kernel on file allocation and
guaranteed to be unique.

This will be used by poll to match notification to the respective file
but can be used for other purposes where unique file handle is
necessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/dir.c    |    2 +-
 fs/fuse/file.c   |    8 ++++++--
 fs/fuse/fuse_i.h |    8 +++++++-
 fs/fuse/inode.c  |    1 +
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index fd03330..7c6821e 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -408,7 +408,7 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry, int mode,
 		goto out_put_forget_req;
 
 	err = -ENOMEM;
-	ff = fuse_file_alloc();
+	ff = fuse_file_alloc(fc);
 	if (!ff)
 		goto out_put_request;
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 71fde8b..1f662f1 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -46,7 +46,7 @@ static int fuse_send_open(struct inode *inode, struct file *file, int isdir,
 	return err;
 }
 
-struct fuse_file *fuse_file_alloc(void)
+struct fuse_file *fuse_file_alloc(struct fuse_conn *fc)
 {
 	struct fuse_file *ff;
 	ff = kmalloc(sizeof(struct fuse_file), GFP_KERNEL);
@@ -58,6 +58,9 @@ struct fuse_file *fuse_file_alloc(void)
 		} else {
 			INIT_LIST_HEAD(&ff->write_entry);
 			atomic_set(&ff->count, 0);
+			spin_lock(&fc->lock);
+			ff->kh = ++fc->khctr;
+			spin_unlock(&fc->lock);
 		}
 	}
 	return ff;
@@ -109,6 +112,7 @@ void fuse_finish_open(struct inode *inode, struct file *file,
 
 int fuse_open_common(struct inode *inode, struct file *file, int isdir)
 {
+	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_open_out outarg;
 	struct fuse_file *ff;
 	int err;
@@ -121,7 +125,7 @@ int fuse_open_common(struct inode *inode, struct file *file, int isdir)
 	if (err)
 		return err;
 
-	ff = fuse_file_alloc();
+	ff = fuse_file_alloc(fc);
 	if (!ff)
 		return -ENOMEM;
 
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 35accfd..fdfdfb0 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -100,6 +100,9 @@ struct fuse_file {
 	/** Request reserved for flush and release */
 	struct fuse_req *reserved_req;
 
+	/** Kernel file handle guaranteed to be unique */
+	u64 kh;
+
 	/** File handle used by userspace */
 	u64 fh;
 
@@ -322,6 +325,9 @@ struct fuse_conn {
 	/** The list of requests under I/O */
 	struct list_head io;
 
+	/** The next unique kernel file handle */
+	u64 khctr;
+
 	/** Number of requests currently in the background */
 	unsigned num_background;
 
@@ -499,7 +505,7 @@ void fuse_read_fill(struct fuse_req *req, struct file *file,
  */
 int fuse_open_common(struct inode *inode, struct file *file, int isdir);
 
-struct fuse_file *fuse_file_alloc(void);
+struct fuse_file *fuse_file_alloc(struct fuse_conn *fc);
 void fuse_file_free(struct fuse_file *ff);
 void fuse_finish_open(struct inode *inode, struct file *file,
 		      struct fuse_file *ff, struct fuse_open_out *outarg);
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 2e99f34..9f27441 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -485,6 +485,7 @@ static struct fuse_conn *new_conn(struct super_block *sb)
 		fc->bdi.unplug_io_fn = default_unplug_io_fn;
 		/* fuse does it's own writeback accounting */
 		fc->bdi.capabilities = BDI_CAP_NO_ACCT_WB;
+		fc->khctr = 0;
 		fc->dev = sb->s_dev;
 		err = bdi_init(&fc->bdi);
 		if (err)
-- 
1.5.6


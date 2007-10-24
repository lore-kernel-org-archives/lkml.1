Return-Path: <linux-kernel-owner+w=401wt.eu-S1757709AbXJXLPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709AbXJXLPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755625AbXJXLOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:14:41 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:49711 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbXJXLOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:14:39 -0400
Message-Id: <20071024111427.005898819@szeredi.hu>
References: <20071024111333.530227696@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 24 Oct 2007 13:13:35 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 2/5] fuse: fix reading past EOF
Content-Disposition: inline; filename=fuse_read_eof_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Currently reading a fuse file will stop at cached i_size and return
EOF, even though the file might have grown since the attributes were
last updated.

So detect if trying to read past EOF, and refresh the attributes
before continuing with the read.

Thanks to mpb for the report.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-10-19 16:45:09.000000000 +0200
+++ linux/fs/fuse/dir.c	2007-10-19 16:46:33.000000000 +0200
@@ -775,6 +775,31 @@ static int fuse_do_getattr(struct inode 
 	return err;
 }
 
+int fuse_update_attributes(struct inode *inode, struct kstat *stat,
+			   struct file *file, bool *refreshed)
+{
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	int err;
+	bool r;
+
+	if (fi->i_time < get_jiffies_64()) {
+		r = true;
+		err = fuse_do_getattr(inode, stat, file);
+	} else {
+		r = false;
+		err = 0;
+		if (stat) {
+			generic_fillattr(inode, stat);
+			stat->mode = fi->orig_i_mode;
+		}
+	}
+
+	if (refreshed != NULL)
+		*refreshed = r;
+
+	return err;
+}
+
 /*
  * Calling into a user-controlled filesystem gives the filesystem
  * daemon ptrace-like capabilities over the requester process.  This
@@ -862,14 +887,9 @@ static int fuse_permission(struct inode 
 	 */
 	if ((fc->flags & FUSE_DEFAULT_PERMISSIONS) ||
 	    ((mask & MAY_EXEC) && S_ISREG(inode->i_mode))) {
-		struct fuse_inode *fi = get_fuse_inode(inode);
-		if (fi->i_time < get_jiffies_64()) {
-			err = fuse_do_getattr(inode, NULL, NULL);
-			if (err)
-				return err;
-
-			refreshed = true;
-		}
+		err = fuse_update_attributes(inode, NULL, NULL, &refreshed);
+		if (err)
+			return err;
 	}
 
 	if (fc->flags & FUSE_DEFAULT_PERMISSIONS) {
@@ -1173,22 +1193,12 @@ static int fuse_getattr(struct vfsmount 
 			struct kstat *stat)
 {
 	struct inode *inode = entry->d_inode;
-	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	int err;
 
 	if (!fuse_allow_task(fc, current))
 		return -EACCES;
 
-	if (fi->i_time < get_jiffies_64())
-		err = fuse_do_getattr(inode, stat, NULL);
-	else {
-		err = 0;
-		generic_fillattr(inode, stat);
-		stat->mode = fi->orig_i_mode;
-	}
-
-	return err;
+	return fuse_update_attributes(inode, stat, NULL, NULL);
 }
 
 static int fuse_setxattr(struct dentry *entry, const char *name,
Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-10-19 16:45:22.000000000 +0200
+++ linux/fs/fuse/file.c	2007-10-19 16:46:33.000000000 +0200
@@ -453,6 +453,25 @@ out:
 	return err;
 }
 
+static ssize_t fuse_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
+				  unsigned long nr_segs, loff_t pos)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+
+	if (pos + iov_length(iov, nr_segs) > i_size_read(inode)) {
+		int err;
+		/*
+		 * If trying to read past EOF, make sure the i_size
+		 * attribute is up-to-date.
+		 */
+		err = fuse_update_attributes(inode, NULL, iocb->ki_filp, NULL);
+		if (err)
+			return err;
+	}
+
+	return generic_file_aio_read(iocb, iov, nr_segs, pos);
+}
+
 static void fuse_write_fill(struct fuse_req *req, struct fuse_file *ff,
 			    struct inode *inode, loff_t pos, size_t count,
 			    int writepage)
@@ -887,7 +906,7 @@ static sector_t fuse_bmap(struct address
 static const struct file_operations fuse_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.aio_read	= fuse_file_aio_read,
 	.write		= do_sync_write,
 	.aio_write	= generic_file_aio_write,
 	.mmap		= fuse_file_mmap,
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2007-10-19 16:45:09.000000000 +0200
+++ linux/fs/fuse/fuse_i.h	2007-10-19 16:46:33.000000000 +0200
@@ -593,3 +593,6 @@ int fuse_valid_type(int m);
 int fuse_allow_task(struct fuse_conn *fc, struct task_struct *task);
 
 u64 fuse_lock_owner_id(struct fuse_conn *fc, fl_owner_t id);
+
+int fuse_update_attributes(struct inode *inode, struct kstat *stat,
+			   struct file *file, bool *refreshed);

--

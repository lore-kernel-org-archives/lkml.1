Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbXIXM0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbXIXM0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 08:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbXIXM0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 08:26:04 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:33618 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbXIXM0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:26:01 -0400
To: hch@infradead.org
Cc: trond.myklebust@fys.uio.no, adilger@clusterfs.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 1/2] VFS: new fgetattr() file operation
Message-Id: <E1IZmze-0003q9-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 24 Sep 2007 14:24:54 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to everyone for the feedback.  Here's two of the VFS patches
reworked according to comments.  I also plan to rework the setattr()
patch accordingly and perhaps the xattr patch, altough that is the
lowest priority.

Christoph, are these OK with you in this form?

----
From: Miklos Szeredi <mszeredi@suse.cz>

Add a new file operation: f_op->fgetattr(), that is invoked by
fstat().  Fall back to i_op->getattr() if it is not defined.

This is useful for filesystems such as sshfs, which don't have a state
associated with inodes, but do have a state associated with open file
handles, and can perform a getattr operation using these handles.

In these cases there are basically two ways to correctly implement
open-unlink-fstat semantics:

 1) use "sillyrenaming"

 2) keep track of open files for each inode within the filesystem, and
    randomly choose one for each getattr() request on an inode with
    i_nlink == 0

 3) VFS passes the open file to the filesystem, which can be used to
    perform a getattr operation on the file handle

No 3. is by far the simplest solution, but it does require this
interface change in the VFS.  It is also the only one that takes care
of the case, when a regular file is unlinked or renamed on the remote
host, while it is still open locally.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/stat.c
===================================================================
--- linux.orig/fs/stat.c	2007-09-24 13:04:37.000000000 +0200
+++ linux/fs/stat.c	2007-09-24 13:06:10.000000000 +0200
@@ -55,6 +55,27 @@ int vfs_getattr(struct vfsmount *mnt, st
 
 EXPORT_SYMBOL(vfs_getattr);
 
+static int vfs_fgetattr(struct file *file, struct kstat *stat)
+{
+	struct vfsmount *mnt = file->f_path.mnt;
+	struct dentry *dentry = file->f_path.dentry;
+	struct inode *inode = dentry->d_inode;
+	int retval;
+
+	retval = security_inode_getattr(mnt, dentry);
+	if (retval)
+		return retval;
+
+	if (file->f_op && file->f_op->fgetattr) {
+		return file->f_op->fgetattr(file, stat);
+	} else if (inode->i_op->getattr) {
+		return inode->i_op->getattr(mnt, dentry, stat);
+	} else {
+		generic_fillattr(inode, stat);
+		return 0;
+	}
+}
+
 int vfs_stat_fd(int dfd, char __user *name, struct kstat *stat)
 {
 	struct nameidata nd;
@@ -101,7 +122,7 @@ int vfs_fstat(unsigned int fd, struct ks
 	int error = -EBADF;
 
 	if (f) {
-		error = vfs_getattr(f->f_path.mnt, f->f_path.dentry, stat);
+		error = vfs_fgetattr(f, stat);
 		fput(f);
 	}
 	return error;
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2007-09-24 13:04:37.000000000 +0200
+++ linux/include/linux/fs.h	2007-09-24 13:06:10.000000000 +0200
@@ -1193,6 +1193,7 @@ struct file_operations {
 	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
 	int (*setlease)(struct file *, long, struct file_lock **);
 	int (*revoke)(struct file *, struct address_space *);
+	int (*fgetattr)(struct file *, struct kstat *);
 };
 
 struct inode_operations {

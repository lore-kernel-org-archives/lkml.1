Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbXJXMAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbXJXMAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756178AbXJXMAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:00:10 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:53765 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbXJXMAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:00:08 -0400
To: akpm@linux-foundation.org
CC: hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH] VFS: new fgetattr() file operation
Message-Id: <E1Iketp-0005dr-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 24 Oct 2007 13:59:49 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think Christoph will like the patch better, regardless of how
I change the description.

Of course, I'm open to suggestion on how to improve the interface, but
I think fundamentally this is the only way to correctly deal with the
below problem.

Anyway, here's the patch another time, please consider adding it to
-mm.  For 2.6.25 obviously.

Thanks,
Miklos
----

From: Miklos Szeredi <mszeredi@suse.cz>

Add a new file operation: f_op->fgetattr(), that is invoked by
fstat().  Fall back to i_op->getattr() if it is not defined.

We need this because fstat() semantics can in some cases be better
implemented if the filesystem has the open file available.

Let's take the following example: we have a network filesystem, with
the server implemented as an unprivileged userspace process running on
a UNIX system (this is basically what sshfs does).

We want the filesystem to follow the familiar UNIX file semantics as
closely as possible.  If for example we have this sequence of events,
we still would like fstat to work correctly:

 1) file X is opened on client
 2) file X is renamed to Y on server
 3) fstat() is performed on open file descriptor on client

This is only possible if the filesystem server acutally uses fstat()
on a file descriptor obtained when the file was opened.  Which means,
the filesystem client needs a way to get this information from the
VFS.

Even if we assume, that the remote filesystem never changes, it is
difficult to implement open-unlink-fstat semantics correctly in the
client, without having this information.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/stat.c
===================================================================
--- linux.orig/fs/stat.c	2007-10-24 11:59:46.000000000 +0200
+++ linux/fs/stat.c	2007-10-24 11:59:47.000000000 +0200
@@ -55,6 +55,33 @@ int vfs_getattr(struct vfsmount *mnt, st
 
 EXPORT_SYMBOL(vfs_getattr);
 
+/*
+ * Perform getattr on an open file
+ *
+ * Fall back to i_op->getattr (or generic_fillattr) if the filesystem
+ * doesn't define an f_op->fgetattr operation.
+ */
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
@@ -101,7 +128,7 @@ int vfs_fstat(unsigned int fd, struct ks
 	int error = -EBADF;
 
 	if (f) {
-		error = vfs_getattr(f->f_path.mnt, f->f_path.dentry, stat);
+		error = vfs_fgetattr(f, stat);
 		fput(f);
 	}
 	return error;
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2007-10-24 11:59:46.000000000 +0200
+++ linux/include/linux/fs.h	2007-10-24 11:59:47.000000000 +0200
@@ -1195,6 +1195,7 @@ struct file_operations {
 	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
 	int (*setlease)(struct file *, long, struct file_lock **);
 	int (*revoke)(struct file *, struct address_space *);
+	int (*fgetattr)(struct file *, struct kstat *);
 };
 
 struct inode_operations {
Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-10-24 11:59:46.000000000 +0200
+++ linux/fs/fuse/file.c	2007-10-24 12:01:00.000000000 +0200
@@ -871,6 +871,17 @@ static int fuse_file_flock(struct file *
 	return err;
 }
 
+static int fuse_file_fgetattr(struct file *file, struct kstat *stat)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+
+	if (!fuse_allow_task(fc, current))
+		return -EACCES;
+
+	return fuse_update_attributes(inode, stat, file, NULL);
+}
+
 static sector_t fuse_bmap(struct address_space *mapping, sector_t block)
 {
 	struct inode *inode = mapping->host;
@@ -920,6 +931,7 @@ static const struct file_operations fuse
 	.fsync		= fuse_fsync,
 	.lock		= fuse_file_lock,
 	.flock		= fuse_file_flock,
+	.fgetattr	= fuse_file_fgetattr,
 	.splice_read	= generic_file_splice_read,
 };
 
@@ -933,6 +945,7 @@ static const struct file_operations fuse
 	.fsync		= fuse_fsync,
 	.lock		= fuse_file_lock,
 	.flock		= fuse_file_flock,
+	.fgetattr	= fuse_file_fgetattr,
 	/* no mmap and splice_read */
 };
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbXJJQgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbXJJQgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 12:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756679AbXJJQfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 12:35:12 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47393 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638AbXJJQfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 12:35:09 -0400
Subject: [RFC][PATCH 2/7] get mount write in __dentry_open()
To: linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, hch@infradead.org, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 10 Oct 2007 09:34:39 -0700
References: <20071010163439.0F8089F7@kernel>
In-Reply-To: <20071010163439.0F8089F7@kernel>
Message-Id: <20071010163439.9DB7F219@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The first patch fixes an actual bug.  I think the
reset will reduce the chance for any future bugs
to creep in.

--

The r/o bind mount patches require matching mnt_want_write()
at filp creation time with a mnt_drop_write() at __fput().

We used to do this in may_open(), but Miklos pointed out
that __dentry_open() is used as well to create filps.  We
don't currently do mnt_want_write() for these.

If a filp on a writeable file is created this way, and
destroyed via __fput() we'll get a mount count imbalance.

This patch moves the mount write count acquisition from
may_open() into __dentry_open(), where we should catch
many more of the users.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namei.c |   12 ------------
 lxc-dave/fs/open.c  |   45 ++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 38 insertions(+), 19 deletions(-)

diff -puN fs/namei.c~get-write-in-__dentry_open fs/namei.c
--- lxc/fs/namei.c~get-write-in-__dentry_open	2007-10-03 14:44:52.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-10-04 18:02:48.000000000 -0700
@@ -1621,14 +1621,6 @@ int may_open(struct nameidata *nd, int a
 			return -EACCES;
 
 		flag &= ~O_TRUNC;
-	} else if (flag & FMODE_WRITE) {
-		/*
-		 * effectively: !special_file()
-		 * balanced by __fput()
-		 */
-		error = mnt_want_write(nd->mnt);
-		if (error)
-			return error;
 	}
 
 	error = vfs_permission(nd, acc_mode);
@@ -1778,11 +1770,7 @@ do_last:
 
 	/* Negative dentry, just create the file */
 	if (!path.dentry->d_inode) {
-		error = mnt_want_write(nd->mnt);
-		if (error)
-			goto exit_mutex_unlock;
 		error = open_namei_create(nd, &path, flag, mode);
-		mnt_drop_write(nd->mnt);
 		if (error)
 			goto exit;
 		return 0;
diff -puN fs/open.c~get-write-in-__dentry_open fs/open.c
--- lxc/fs/open.c~get-write-in-__dentry_open	2007-10-03 14:44:52.000000000 -0700
+++ lxc-dave/fs/open.c	2007-10-04 18:02:48.000000000 -0700
@@ -766,22 +766,51 @@ out:
 	return error;
 }
 
+/*
+ * You have to be very careful that these write
+ * counts get cleaned up in error cases and
+ * upon __fput().  This should probably never
+ * be called outside of __dentry_open().
+ */
+static inline int __get_file_write_access(struct inode *inode,
+					  struct vfsmount *mnt)
+{
+	int error;
+	error = get_write_access(inode);
+	if (error)
+		return error;
+	/*
+	 * Do not take mount writer counts on
+	 * special files since no writes to
+	 * the mount itself will occur.
+	 */
+	if (special_file(inode->i_mode))
+		return 0;
+
+	/*
+	 * Balanced in __fput()
+	 */
+	error = mnt_want_write(mnt);
+	if (error)
+		put_write_access(inode);
+	return error;
+}
+
 static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 					int flags, struct file *f,
 					int (*open)(struct inode *, struct file *))
 {
 	struct inode *inode;
-	int error;
+	int error = 0;
 
 	f->f_flags = flags;
 	f->f_mode = ((flags+1) & O_ACCMODE) | FMODE_LSEEK |
 				FMODE_PREAD | FMODE_PWRITE;
 	inode = dentry->d_inode;
-	if (f->f_mode & FMODE_WRITE) {
-		error = get_write_access(inode);
-		if (error)
-			goto cleanup_file;
-	}
+	if (f->f_mode & FMODE_WRITE)
+		error = __get_file_write_access(inode, mnt);
+	if (error)
+		goto cleanup_file;
 
 	f->f_mapping = inode->i_mapping;
 	f->f_path.dentry = dentry;
@@ -820,8 +849,10 @@ static struct file *__dentry_open(struct
 
 cleanup_all:
 	fops_put(f->f_op);
-	if (f->f_mode & FMODE_WRITE)
+	if (f->f_mode & FMODE_WRITE) {
 		put_write_access(inode);
+		mnt_drop_write(mnt);
+	}
 	file_kill(f);
 	f->f_path.dentry = NULL;
 	f->f_path.mnt = NULL;
diff -puN fs/file_table.c~get-write-in-__dentry_open fs/file_table.c
_

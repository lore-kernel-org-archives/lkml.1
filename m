Return-Path: <linux-kernel-owner+w=401wt.eu-S1762071AbYG3NKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762071AbYG3NKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 09:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758614AbYG3NJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 09:09:25 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57683 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183AbYG3NJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 09:09:23 -0400
Message-Id: <20080730130917.275055673@szeredi.hu>
References: <20080730130845.905327725@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 30 Jul 2008 15:08:49 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 4/4] vfs: create file_truncate() helper
Content-Disposition: inline; filename=vfs-create-file_truncate-helper.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

...and add kerneldoc comment to it and to do_truncate().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/exec.c          |    2 +-
 fs/open.c          |   24 ++++++++++++++++++++----
 include/linux/fs.h |    2 ++
 mm/tiny-shmem.c    |    2 +-
 4 files changed, 24 insertions(+), 6 deletions(-)

Index: linux-2.6/fs/exec.c
===================================================================
--- linux-2.6.orig/fs/exec.c	2008-07-30 13:52:36.000000000 +0200
+++ linux-2.6/fs/exec.c	2008-07-30 13:52:39.000000000 +0200
@@ -1827,7 +1827,7 @@ int do_coredump(long signr, int exit_cod
 		goto close_fail;
 	if (!file->f_op->write)
 		goto close_fail;
-	if (!ispipe && do_truncate(file->f_path.dentry, 0, 0, file) != 0)
+	if (!ispipe && file_truncate(file, 0, 0) != 0)
 		goto close_fail;
 
 	retval = binfmt->core_dump(signr, regs, file, core_limit);
Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c	2008-07-30 13:52:36.000000000 +0200
+++ linux-2.6/fs/open.c	2008-07-30 13:52:39.000000000 +0200
@@ -197,6 +197,13 @@ out:
 	return error;
 }
 
+/*
+ * do_truncate - truncate (or extend) an inode
+ * @dentry: the dentry to truncate
+ * @length: the new length
+ * @time_attrs: file times to be updated (e.g. ATTR_MTIME|ATTR_CTIME)
+ * @filp: an open file or NULL (see file_truncate() as well)
+ */
 int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 	struct file *filp)
 {
@@ -223,6 +230,17 @@ int do_truncate(struct dentry *dentry, l
 	return err;
 }
 
+/*
+ * file_truncate - truncate (or extend) an open file
+ * @filp: the open file
+ * @length: the new length
+ * @time_attrs: file times to be updated (e.g. ATTR_MTIME|ATTR_CTIME)
+ */
+int file_truncate(struct file *filp, loff_t length, unsigned int time_attrs)
+{
+	return do_truncate(filp->f_path.dentry, length, time_attrs, filp);
+}
+
 static long do_sys_truncate(const char __user *pathname, loff_t length)
 {
 	struct path path;
@@ -296,7 +314,6 @@ asmlinkage long sys_truncate(const char 
 static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 {
 	struct inode * inode;
-	struct dentry *dentry;
 	struct file * file;
 	int error;
 
@@ -312,8 +329,7 @@ static long do_sys_ftruncate(unsigned in
 	if (file->f_flags & O_LARGEFILE)
 		small = 0;
 
-	dentry = file->f_path.dentry;
-	inode = dentry->d_inode;
+	inode = file->f_path.dentry->d_inode;
 	error = -EINVAL;
 	if (!S_ISREG(inode->i_mode) || !(file->f_mode & FMODE_WRITE))
 		goto out_putf;
@@ -329,7 +345,7 @@ static long do_sys_ftruncate(unsigned in
 
 	error = locks_verify_truncate(inode, file, length);
 	if (!error)
-		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, file);
+		error = file_truncate(file, length, ATTR_MTIME|ATTR_CTIME);
 out_putf:
 	fput(file);
 out:
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-07-30 13:52:36.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-07-30 13:52:39.000000000 +0200
@@ -1614,6 +1614,8 @@ static inline int break_lease(struct ino
 
 extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
 		       struct file *filp);
+extern int file_truncate(struct file *filp, loff_t start,
+			 unsigned int time_attrs);
 extern long do_sys_open(int dfd, const char __user *filename, int flags,
 			int mode);
 extern struct file *filp_open(const char *, int, int);
Index: linux-2.6/mm/tiny-shmem.c
===================================================================
--- linux-2.6.orig/mm/tiny-shmem.c	2008-07-30 13:52:36.000000000 +0200
+++ linux-2.6/mm/tiny-shmem.c	2008-07-30 13:52:39.000000000 +0200
@@ -80,7 +80,7 @@ struct file *shmem_file_setup(char *name
 	inode->i_nlink = 0;	/* It is unlinked */
 
 	/* notify everyone as to the change of file size */
-	error = do_truncate(dentry, size, 0, file);
+	error = file_truncate(file, size, 0);
 	if (error < 0)
 		goto close_file;
 

--

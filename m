Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbYEPQf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbYEPQf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757135AbYEPQcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:32:45 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33736 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732AbYEPQcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:32:42 -0400
Message-Id: <20080516163227.154012790@szeredi.hu>
References: <20080516163136.560107038@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 16 May 2008 18:31:46 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 10/22] vfs: create file_truncate() helper
Content-Disposition: inline; filename=file_truncate.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Clean up do_truncate() API:

  - create a new function file_truncate()

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/exec.c          |    2 +-
 fs/open.c          |   24 ++++++++++++++++++++----
 include/linux/fs.h |    2 ++
 mm/tiny-shmem.c    |    2 +-
 4 files changed, 24 insertions(+), 6 deletions(-)

Index: linux-2.6/fs/exec.c
===================================================================
--- linux-2.6.orig/fs/exec.c	2008-05-16 17:50:35.000000000 +0200
+++ linux-2.6/fs/exec.c	2008-05-16 17:50:46.000000000 +0200
@@ -1763,7 +1763,7 @@ int do_coredump(long signr, int exit_cod
 		goto close_fail;
 	if (!file->f_op->write)
 		goto close_fail;
-	if (!ispipe && do_truncate(file->f_path.dentry, 0, 0, file) != 0)
+	if (!ispipe && file_truncate(file, 0, 0) != 0)
 		goto close_fail;
 
 	retval = binfmt->core_dump(signr, regs, file, core_limit);
Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c	2008-05-16 17:50:46.000000000 +0200
+++ linux-2.6/fs/open.c	2008-05-16 17:50:46.000000000 +0200
@@ -195,6 +195,13 @@ out:
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
@@ -221,6 +228,17 @@ int do_truncate(struct dentry *dentry, l
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
 static long do_sys_truncate(const char __user * path, loff_t length)
 {
 	struct nameidata nd;
@@ -294,7 +312,6 @@ asmlinkage long sys_truncate(const char 
 static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 {
 	struct inode * inode;
-	struct dentry *dentry;
 	struct file * file;
 	int error;
 
@@ -310,8 +327,7 @@ static long do_sys_ftruncate(unsigned in
 	if (file->f_flags & O_LARGEFILE)
 		small = 0;
 
-	dentry = file->f_path.dentry;
-	inode = dentry->d_inode;
+	inode = file->f_path.dentry->d_inode;
 	error = -EINVAL;
 	if (!S_ISREG(inode->i_mode) || !(file->f_mode & FMODE_WRITE))
 		goto out_putf;
@@ -327,7 +343,7 @@ static long do_sys_ftruncate(unsigned in
 
 	error = locks_verify_truncate(inode, file, length);
 	if (!error)
-		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, file);
+		error = file_truncate(file, length, ATTR_MTIME|ATTR_CTIME);
 out_putf:
 	fput(file);
 out:
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-16 17:50:35.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-16 17:50:46.000000000 +0200
@@ -1600,6 +1600,8 @@ static inline int break_lease(struct ino
 
 extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
 		       struct file *filp);
+extern int file_truncate(struct file *filp, loff_t start,
+			 unsigned int time_attrs);
 extern long do_sys_open(int dfd, const char __user *filename, int flags,
 			int mode);
 extern struct file *filp_open(const char *, int, int);
Index: linux-2.6/mm/tiny-shmem.c
===================================================================
--- linux-2.6.orig/mm/tiny-shmem.c	2008-05-16 17:50:35.000000000 +0200
+++ linux-2.6/mm/tiny-shmem.c	2008-05-16 17:50:46.000000000 +0200
@@ -80,7 +80,7 @@ struct file *shmem_file_setup(char *name
 	inode->i_nlink = 0;	/* It is unlinked */
 
 	/* notify everyone as to the change of file size */
-	error = do_truncate(dentry, size, 0, file);
+	error = file_truncate(file, size, 0);
 	if (error < 0)
 		goto close_file;
 

--

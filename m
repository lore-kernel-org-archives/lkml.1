Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbYEEJ7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbYEEJ7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 05:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758372AbYEEJzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 05:55:42 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38365 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758482AbYEEJzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 05:55:39 -0400
Message-Id: <20080505095526.823086058@szeredi.hu>
References: <20080505095440.820370974@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 05 May 2008 11:54:53 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [patch 12/15] vfs: create file_truncate() helper
Content-Disposition: inline; filename=file_truncate.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Clean up do_truncate() API:

  - create a new function file_truncate()
  - remove the 'struct file *' argument from do_truncate()

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/exec.c          |    2 +-
 fs/namei.c         |    3 +--
 fs/open.c          |   22 +++++++++++++++-------
 include/linux/fs.h |    5 +++--
 mm/tiny-shmem.c    |    2 +-
 5 files changed, 21 insertions(+), 13 deletions(-)

Index: linux-2.6/fs/exec.c
===================================================================
--- linux-2.6.orig/fs/exec.c	2008-05-05 11:29:20.000000000 +0200
+++ linux-2.6/fs/exec.c	2008-05-05 11:29:27.000000000 +0200
@@ -1763,7 +1763,7 @@ int do_coredump(long signr, int exit_cod
 		goto close_fail;
 	if (!file->f_op->write)
 		goto close_fail;
-	if (!ispipe && do_truncate(file->f_path.dentry, 0, 0, file) != 0)
+	if (!ispipe && file_truncate(file, 0, 0) != 0)
 		goto close_fail;
 
 	retval = binfmt->core_dump(signr, regs, file, core_limit);
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-05 11:29:27.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-05 11:29:27.000000000 +0200
@@ -1666,8 +1666,7 @@ int may_open(struct nameidata *nd, int a
 			DQUOT_INIT(inode);
 
 			error = do_truncate(dentry, 0,
-					    ATTR_MTIME|ATTR_CTIME|ATTR_OPEN,
-					    NULL);
+					    ATTR_MTIME|ATTR_CTIME|ATTR_OPEN);
 		}
 		put_write_access(inode);
 		if (error)
Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c	2008-05-05 11:29:27.000000000 +0200
+++ linux-2.6/fs/open.c	2008-05-05 11:29:28.000000000 +0200
@@ -195,8 +195,8 @@ out:
 	return error;
 }
 
-int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
-	struct file *filp)
+static int truncate_common(struct dentry *dentry, loff_t length,
+			   unsigned int time_attrs, struct file *filp)
 {
 	int err;
 	struct iattr newattrs;
@@ -221,6 +221,16 @@ int do_truncate(struct dentry *dentry, l
 	return err;
 }
 
+int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs)
+{
+	return truncate_common(dentry, length, time_attrs, NULL);
+}
+
+int file_truncate(struct file *filp, loff_t length, unsigned int time_attrs)
+{
+	return truncate_common(filp->f_path.dentry, length, time_attrs, filp);
+}
+
 static long do_sys_truncate(const char __user * path, loff_t length)
 {
 	struct nameidata nd;
@@ -268,7 +278,7 @@ static long do_sys_truncate(const char _
 	error = locks_verify_truncate(inode, NULL, length);
 	if (!error) {
 		DQUOT_INIT(inode);
-		error = do_truncate(nd.path.dentry, length, 0, NULL);
+		error = do_truncate(nd.path.dentry, length, 0);
 	}
 
 put_write_and_out:
@@ -290,7 +300,6 @@ asmlinkage long sys_truncate(const char 
 static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 {
 	struct inode * inode;
-	struct dentry *dentry;
 	struct file * file;
 	int error;
 
@@ -306,8 +315,7 @@ static long do_sys_ftruncate(unsigned in
 	if (file->f_flags & O_LARGEFILE)
 		small = 0;
 
-	dentry = file->f_path.dentry;
-	inode = dentry->d_inode;
+	inode = file->f_path.dentry->d_inode;
 	error = -EINVAL;
 	if (!S_ISREG(inode->i_mode) || !(file->f_mode & FMODE_WRITE))
 		goto out_putf;
@@ -319,7 +327,7 @@ static long do_sys_ftruncate(unsigned in
 
 	error = locks_verify_truncate(inode, file, length);
 	if (!error)
-		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, file);
+		error = file_truncate(file, length, ATTR_MTIME|ATTR_CTIME);
 out_putf:
 	fput(file);
 out:
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-05 11:29:20.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-05 11:29:28.000000000 +0200
@@ -1603,8 +1603,9 @@ static inline int break_lease(struct ino
 
 /* fs/open.c */
 
-extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
-		       struct file *filp);
+extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs);
+extern int file_truncate(struct file *filp, loff_t start,
+			 unsigned int time_attrs);
 extern long do_sys_open(int dfd, const char __user *filename, int flags,
 			int mode);
 extern struct file *filp_open(const char *, int, int);
Index: linux-2.6/mm/tiny-shmem.c
===================================================================
--- linux-2.6.orig/mm/tiny-shmem.c	2008-05-05 11:29:20.000000000 +0200
+++ linux-2.6/mm/tiny-shmem.c	2008-05-05 11:29:28.000000000 +0200
@@ -80,7 +80,7 @@ struct file *shmem_file_setup(char *name
 	inode->i_nlink = 0;	/* It is unlinked */
 
 	/* notify everyone as to the change of file size */
-	error = do_truncate(dentry, size, 0, file);
+	error = file_truncate(file, size, 0);
 	if (error < 0)
 		goto close_file;
 

--

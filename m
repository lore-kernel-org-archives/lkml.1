Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbYEXEFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbYEXEFG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 00:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbYEXEEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 00:04:53 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:62848 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbYEXEEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 00:04:52 -0400
To: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, trond.myklebust@fys.uio.no,
       linux-kernel@vger.kernel.org
Subject: Re: [git patch] vfs: permission API cleanup (v2)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <E1JzDzC-0008MT-Hb@pomaz-ex.szeredi.hu>
In-Reply-To: <E1JzDzC-0008MT-Hb@pomaz-ex.szeredi.hu>
Message-Id: <200805241304.BDI73412.HOJMOFSQLFtVOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 24 May 2008 13:04:48 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I tried to insert a new LSM hook for truncate operation, but I had to insert
security_path_truncate() hook into multiple locations since do_truncate() is
directly called from some locations.
http://svn.sourceforge.jp/cgi-bin/viewcvs.cgi/*checkout*/trunk/2.2.x/tomoyo-lsm/patches/lsm-add-hooks-for-pathname-based-control.patch?rev=1244&root=tomoyo

Is it possible to replace do_truncate() and file_truncate() with path_truncate()
so that security_path_truncate() is called from only path_truncate()?

Regards.

----------
Subject: Replace do_truncate() and file_truncate() with path_truncate().

This patch replaces do_truncate() and file_truncate() with path_truncate().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/exec.c          |    2 +-
 fs/namei.c         |   14 +++++++-------
 fs/open.c          |   21 ++++++++++++---------
 include/linux/fs.h |    6 ++----
 mm/tiny-shmem.c    |    2 +-
 5 files changed, 23 insertions(+), 22 deletions(-)

--- vfs.orig/fs/exec.c
+++ vfs/fs/exec.c
@@ -1763,7 +1763,7 @@ int do_coredump(long signr, int exit_cod
 		goto close_fail;
 	if (!file->f_op->write)
 		goto close_fail;
-	if (!ispipe && file_truncate(file, 0, 0) != 0)
+	if (!ispipe && path_truncate(&file->f_path, 0, 0, file) != 0)
 		goto close_fail;
 
 	retval = binfmt->core_dump(signr, regs, file, core_limit);
--- vfs.orig/fs/namei.c
+++ vfs/fs/namei.c
@@ -1626,8 +1626,8 @@ EXPORT_SYMBOL(path_create);
 int may_open(struct nameidata *nd, int acc_mode, int flag)
 {
 	int op;
-	struct dentry *dentry = nd->path.dentry;
-	struct inode *inode = dentry->d_inode;
+	struct path *path = &nd->path;
+	struct inode *inode = path->dentry->d_inode;
 	int error;
 
 	if (!inode)
@@ -1647,14 +1647,14 @@ int may_open(struct nameidata *nd, int a
 	if (S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
 	    	flag &= ~O_TRUNC;
 	} else if (S_ISBLK(inode->i_mode) || S_ISCHR(inode->i_mode)) {
-		if (nd->path.mnt->mnt_flags & MNT_NODEV)
+		if (path->mnt->mnt_flags & MNT_NODEV)
 			return -EACCES;
 
 		flag &= ~O_TRUNC;
 	}
 
 	op = (nd->flags & LOOKUP_OPEN) ? PERM_OP_OPEN : 0;
-	error = path_permission(&nd->path, acc_mode | op);
+	error = path_permission(path, acc_mode | op);
 	if (error)
 		return error;
 	/*
@@ -1691,9 +1691,9 @@ int may_open(struct nameidata *nd, int a
 		if (!error) {
 			DQUOT_INIT(inode);
 
-			error = do_truncate(dentry, 0,
-					    ATTR_MTIME|ATTR_CTIME|ATTR_OPEN,
-					    NULL);
+			error = path_truncate(path, 0,
+					      ATTR_MTIME|ATTR_CTIME|ATTR_OPEN,
+					      NULL);
 		}
 		put_write_access(inode);
 		if (error)
--- vfs.orig/fs/open.c
+++ vfs/fs/open.c
@@ -200,10 +200,10 @@ out:
  * @dentry: the dentry to truncate
  * @length: the new length
  * @time_attrs: file times to be updated (e.g. ATTR_MTIME|ATTR_CTIME)
- * @filp: an open file or NULL (see file_truncate() as well)
+ * @filp: an open file or NULL
  */
-int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
-	struct file *filp)
+static inline int do_truncate(struct dentry *dentry, loff_t length,
+			      unsigned int time_attrs, struct file *filp)
 {
 	int err;
 	struct iattr newattrs;
@@ -229,14 +229,16 @@ int do_truncate(struct dentry *dentry, l
 }
 
 /*
- * file_truncate - truncate (or extend) an open file
- * @filp: the open file
+ * path_truncate - truncate (or extend) a file
+ * @path: the path structure to truncate
  * @length: the new length
  * @time_attrs: file times to be updated (e.g. ATTR_MTIME|ATTR_CTIME)
+ * @filp: an open file or NULL
  */
-int file_truncate(struct file *filp, loff_t length, unsigned int time_attrs)
+int path_truncate(struct path *path, loff_t length, unsigned int time_attrs,
+		  struct file *filp)
 {
-	return do_truncate(filp->f_path.dentry, length, time_attrs, filp);
+	return do_truncate(path->dentry, length, time_attrs, filp);
 }
 
 static long do_sys_truncate(const char __user * path, loff_t length)
@@ -290,7 +292,7 @@ static long do_sys_truncate(const char _
 	error = locks_verify_truncate(inode, NULL, length);
 	if (!error) {
 		DQUOT_INIT(inode);
-		error = do_truncate(nd.path.dentry, length, 0, NULL);
+		error = path_truncate(&nd.path, length, 0, NULL);
 	}
 
 put_write_and_out:
@@ -343,7 +345,8 @@ static long do_sys_ftruncate(unsigned in
 
 	error = locks_verify_truncate(inode, file, length);
 	if (!error)
-		error = file_truncate(file, length, ATTR_MTIME|ATTR_CTIME);
+		error = path_truncate(&file->f_path, length,
+				      ATTR_MTIME|ATTR_CTIME, file);
 out_putf:
 	fput(file);
 out:
--- vfs.orig/include/linux/fs.h
+++ vfs/include/linux/fs.h
@@ -1609,10 +1609,8 @@ static inline int break_lease(struct ino
 
 /* fs/open.c */
 
-extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
-		       struct file *filp);
-extern int file_truncate(struct file *filp, loff_t start,
-			 unsigned int time_attrs);
+extern int path_truncate(struct path *path, loff_t start,
+			 unsigned int time_attrs, struct file *filp);
 extern long do_sys_open(int dfd, const char __user *filename, int flags,
 			int mode);
 extern struct file *filp_open(const char *, int, int);
--- vfs.orig/mm/tiny-shmem.c
+++ vfs/mm/tiny-shmem.c
@@ -80,7 +80,7 @@ struct file *shmem_file_setup(char *name
 	inode->i_nlink = 0;	/* It is unlinked */
 
 	/* notify everyone as to the change of file size */
-	error = file_truncate(file, size, 0);
+	error = path_truncate(&file->f_path, size, 0, file);
 	if (error < 0)
 		goto close_file;
 

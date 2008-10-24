Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbYJXH6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbYJXH6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 03:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYJXH6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 03:58:14 -0400
Received: from verein.lst.de ([213.95.11.210]:50437 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbYJXH6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 03:58:13 -0400
Date: Fri, 24 Oct 2008 09:58:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pass a struct path * to may_open
Message-ID: <20081024075810.GA20486@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need for the nameidata in may_open - a struct path is enough.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-10-23 20:19:55.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-10-23 23:07:11.000000000 +0200
@@ -1491,9 +1491,9 @@ int vfs_create(struct inode *dir, struct
 	return error;
 }
 
-int may_open(struct nameidata *nd, int acc_mode, int flag)
+int may_open(struct path *path, int acc_mode, int flag)
 {
-	struct dentry *dentry = nd->path.dentry;
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
 	int error;
 
@@ -1514,15 +1514,16 @@ int may_open(struct nameidata *nd, int a
 	if (S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
 	    	flag &= ~O_TRUNC;
 	} else if (S_ISBLK(inode->i_mode) || S_ISCHR(inode->i_mode)) {
-		if (nd->path.mnt->mnt_flags & MNT_NODEV)
+		if (path->mnt->mnt_flags & MNT_NODEV)
 			return -EACCES;
 
 		flag &= ~O_TRUNC;
 	}
 
-	error = vfs_permission(nd, acc_mode);
+	error = inode_permission(inode, acc_mode);
 	if (error)
 		return error;
+
 	/*
 	 * An append-only file must be opened in append mode for writing.
 	 */
@@ -1591,7 +1592,7 @@ static int __open_namei_create(struct na
 	if (error)
 		return error;
 	/* Don't check for write permission, don't truncate */
-	return may_open(nd, 0, flag & ~O_TRUNC);
+	return may_open(&nd->path, 0, flag & ~O_TRUNC);
 }
 
 /*
@@ -1777,7 +1778,7 @@ ok:
 		if (error)
 			goto exit;
 	}
-	error = may_open(&nd, acc_mode, flag);
+	error = may_open(&nd.path, acc_mode, flag);
 	if (error) {
 		if (will_write)
 			mnt_drop_write(nd.path.mnt);
Index: linux-2.6/fs/nfsctl.c
===================================================================
--- linux-2.6.orig/fs/nfsctl.c	2008-10-23 20:19:55.000000000 +0200
+++ linux-2.6/fs/nfsctl.c	2008-10-23 23:05:49.000000000 +0200
@@ -36,9 +36,10 @@ static struct file *do_open(char *name, 
 		return ERR_PTR(error);
 
 	if (flags == O_RDWR)
-		error = may_open(&nd,MAY_READ|MAY_WRITE,FMODE_READ|FMODE_WRITE);
+		error = may_open(&nd.path, MAY_READ|MAY_WRITE,
+					   FMODE_READ|FMODE_WRITE);
 	else
-		error = may_open(&nd, MAY_WRITE, FMODE_WRITE);
+		error = may_open(&nd.path, MAY_WRITE, FMODE_WRITE);
 
 	if (!error)
 		return dentry_open(nd.path.dentry, nd.path.mnt, flags);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-10-23 23:02:29.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-10-23 23:05:49.000000000 +0200
@@ -1865,7 +1865,7 @@ extern void free_write_pipe(struct file 
 
 extern struct file *do_filp_open(int dfd, const char *pathname,
 		int open_flag, int mode);
-extern int may_open(struct nameidata *, int, int);
+extern int may_open(struct path *, int, int);
 
 extern int kernel_read(struct file *, unsigned long, char *, unsigned long);
 extern struct file * open_exec(const char *);

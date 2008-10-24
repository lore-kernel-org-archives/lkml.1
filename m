Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYJXH7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYJXH7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 03:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYJXH7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 03:59:33 -0400
Received: from verein.lst.de ([213.95.11.210]:50454 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbYJXH7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 03:59:32 -0400
Date: Fri, 24 Oct 2008 09:59:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kill vfs_permission
Message-ID: <20081024075929.GB20486@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With all the nameidata removal there's no point anymore for this helper.
Of the three callers left two will go away with the next lookup series
anyway.

Also add proper kerneldoc to inode_permission as this is the main
permission check routine now.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/exec.c
===================================================================
--- linux-2.6.orig/fs/exec.c	2008-10-23 23:12:14.000000000 +0200
+++ linux-2.6/fs/exec.c	2008-10-23 23:12:18.000000000 +0200
@@ -126,7 +126,8 @@ asmlinkage long sys_uselib(const char __
 	if (nd.path.mnt->mnt_flags & MNT_NOEXEC)
 		goto exit;
 
-	error = vfs_permission(&nd, MAY_READ | MAY_EXEC | MAY_OPEN);
+	error = inode_permission(nd.path.dentry->d_inode,
+				 MAY_READ | MAY_EXEC | MAY_OPEN);
 	if (error)
 		goto exit;
 
@@ -679,7 +680,7 @@ struct file *open_exec(const char *name)
 	if (nd.path.mnt->mnt_flags & MNT_NOEXEC)
 		goto out_path_put;
 
-	err = vfs_permission(&nd, MAY_EXEC | MAY_OPEN);
+	err = inode_permission(nd.path.dentry->d_inode, MAY_EXEC | MAY_OPEN);
 	if (err)
 		goto out_path_put;
 
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-10-23 23:12:14.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-10-23 23:14:43.000000000 +0200
@@ -226,6 +226,16 @@ int generic_permission(struct inode *ino
 	return -EACCES;
 }
 
+/**
+ * inode_permission  -  check for access rights to a given inode
+ * @inode:	inode to check permission on
+ * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
+ *
+ * Used to check for read/write/execute permissions on an inode.
+ * We use "fsuid" for this, letting us set arbitrary permissions
+ * for filesystem access without changing the "normal" uids which
+ * are used for other things.
+ */
 int inode_permission(struct inode *inode, int mask)
 {
 	int retval;
@@ -265,21 +275,6 @@ int inode_permission(struct inode *inode
 }
 
 /**
- * vfs_permission  -  check for access rights to a given path
- * @nd:		lookup result that describes the path
- * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
- *
- * Used to check for read/write/execute permissions on a path.
- * We use "fsuid" for this, letting us set arbitrary permissions
- * for filesystem access without changing the "normal" uids which
- * are used for other things.
- */
-int vfs_permission(struct nameidata *nd, int mask)
-{
-	return inode_permission(nd->path.dentry->d_inode, mask);
-}
-
-/**
  * file_permission  -  check for additional access rights to a given file
  * @file:	file to check access rights for
  * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
@@ -289,7 +284,7 @@ int vfs_permission(struct nameidata *nd,
  *
  * Note:
  *	Do not use this function in new code.  All access checks should
- *	be done using vfs_permission().
+ *	be done using inode_permission().
  */
 int file_permission(struct file *file, int mask)
 {
@@ -859,7 +854,8 @@ static int __link_path_walk(const char *
 		nd->flags |= LOOKUP_CONTINUE;
 		err = exec_permission_lite(inode);
 		if (err == -EAGAIN)
-			err = vfs_permission(nd, MAY_EXEC);
+			err = inode_permission(nd->path.dentry->d_inode,
+					       MAY_EXEC);
  		if (err)
 			break;
 
@@ -2851,7 +2847,6 @@ EXPORT_SYMBOL(path_lookup);
 EXPORT_SYMBOL(kern_path);
 EXPORT_SYMBOL(vfs_path_lookup);
 EXPORT_SYMBOL(inode_permission);
-EXPORT_SYMBOL(vfs_permission);
 EXPORT_SYMBOL(file_permission);
 EXPORT_SYMBOL(unlock_rename);
 EXPORT_SYMBOL(vfs_create);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-10-23 23:14:56.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-10-23 23:14:59.000000000 +0200
@@ -1209,7 +1209,6 @@ extern void unlock_super(struct super_bl
 /*
  * VFS helper functions..
  */
-extern int vfs_permission(struct nameidata *, int);
 extern int vfs_create(struct inode *, struct dentry *, int, struct nameidata *);
 extern int vfs_mkdir(struct inode *, struct dentry *, int);
 extern int vfs_mknod(struct inode *, struct dentry *, int, dev_t);

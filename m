Return-Path: <linux-kernel-owner+w=401wt.eu-S933170AbXBES2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170AbXBES2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933228AbXBES1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:27:32 -0500
Received: from ns.suse.de ([195.135.220.2]:43526 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933216AbXBES1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:27:20 -0500
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, linux-security-module@vger.kernel.org,
       agruen@suse.de
Date: Mon, 05 Feb 2007 10:26:22 -0800
Message-Id: <20070205182622.12164.66195.sendpatchset@ermintrude.int.wirex.com>
In-Reply-To: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
Subject: [RFC 27/28] Add a struct vfsmount parameter to vfs_removexattr()
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a struct vfsmount parameter to vfs_removexattr()

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c
+++ linux-2.6/fs/nfsd/vfs.c
@@ -1974,7 +1974,7 @@ nfsd_set_posix_acl(struct svc_fh *fhp, i
 		if (!S_ISDIR(inode->i_mode) && type == ACL_TYPE_DEFAULT)
 			error = 0;
 		else {
-			error = vfs_removexattr(fhp->fh_dentry, name);
+			error = vfs_removexattr(fhp->fh_dentry, NULL, name);
 			if (error == -ENODATA)
 				error = 0;
 		}
Index: linux-2.6/fs/xattr.c
===================================================================
--- linux-2.6.orig/fs/xattr.c
+++ linux-2.6/fs/xattr.c
@@ -166,7 +166,7 @@ vfs_listxattr(struct dentry *dentry, str
 EXPORT_SYMBOL_GPL(vfs_listxattr);
 
 int
-vfs_removexattr(struct dentry *dentry, char *name)
+vfs_removexattr(struct dentry *dentry, struct vfsmount *mnt, char *name)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -437,7 +437,7 @@ sys_flistxattr(int fd, char __user *list
  * Extended attribute REMOVE operations
  */
 static long
-removexattr(struct dentry *d, char __user *name)
+removexattr(struct dentry *dentry, struct vfsmount *mnt, char __user *name)
 {
 	int error;
 	char kname[XATTR_NAME_MAX + 1];
@@ -448,7 +448,7 @@ removexattr(struct dentry *d, char __use
 	if (error < 0)
 		return error;
 
-	return vfs_removexattr(d, kname);
+	return vfs_removexattr(dentry, mnt, kname);
 }
 
 asmlinkage long
@@ -460,7 +460,7 @@ sys_removexattr(char __user *path, char 
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = removexattr(nd.dentry, name);
+	error = removexattr(nd.dentry, nd.mnt, name);
 	path_release(&nd);
 	return error;
 }
@@ -474,7 +474,7 @@ sys_lremovexattr(char __user *path, char
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = removexattr(nd.dentry, name);
+	error = removexattr(nd.dentry, nd.mnt, name);
 	path_release(&nd);
 	return error;
 }
@@ -491,7 +491,7 @@ sys_fremovexattr(int fd, char __user *na
 		return error;
 	dentry = f->f_path.dentry;
 	audit_inode(NULL, dentry->d_inode);
-	error = removexattr(dentry, name);
+	error = removexattr(dentry, f->f_path.mnt, name);
 	fput(f);
 	return error;
 }
Index: linux-2.6/include/linux/xattr.h
===================================================================
--- linux-2.6.orig/include/linux/xattr.h
+++ linux-2.6/include/linux/xattr.h
@@ -46,7 +46,7 @@ ssize_t vfs_listxattr(struct dentry *d, 
 		      size_t size);
 int vfs_setxattr(struct dentry *, struct vfsmount *, char *, void *, size_t,
 		 int);
-int vfs_removexattr(struct dentry *, char *);
+int vfs_removexattr(struct dentry *, struct vfsmount *, char *);
 
 ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);
 ssize_t generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size);

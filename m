Return-Path: <linux-kernel-owner+w=401wt.eu-S933198AbXBES0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198AbXBES0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933199AbXBES0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:26:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:47832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933195AbXBES0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:26:46 -0500
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, linux-security-module@vger.kernel.org,
       agruen@suse.de
Date: Mon, 05 Feb 2007 10:25:49 -0800
Message-Id: <20070205182549.12164.54830.sendpatchset@ermintrude.int.wirex.com>
In-Reply-To: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
Subject: [RFC 23/28] Add a struct vfsmount parameter to vfs_getxattr()
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a struct vfsmount parameter to vfs_getxattr()

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c
+++ linux-2.6/fs/nfsd/vfs.c
@@ -382,7 +382,7 @@ static ssize_t nfsd_getxattr(struct dent
 {
 	ssize_t buflen;
 
-	buflen = vfs_getxattr(dentry, key, NULL, 0);
+	buflen = vfs_getxattr(dentry, NULL, key, NULL, 0);
 	if (buflen <= 0)
 		return buflen;
 
@@ -390,7 +390,7 @@ static ssize_t nfsd_getxattr(struct dent
 	if (!*buf)
 		return -ENOMEM;
 
-	return vfs_getxattr(dentry, key, *buf, buflen);
+	return vfs_getxattr(dentry, NULL, key, *buf, buflen);
 }
 #endif
 
Index: linux-2.6/fs/xattr.c
===================================================================
--- linux-2.6.orig/fs/xattr.c
+++ linux-2.6/fs/xattr.c
@@ -107,7 +107,8 @@ out:
 EXPORT_SYMBOL_GPL(vfs_setxattr);
 
 ssize_t
-vfs_getxattr(struct dentry *dentry, char *name, void *value, size_t size)
+vfs_getxattr(struct dentry *dentry, struct vfsmount *mnt, char *name,
+	     void *value, size_t size)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -279,7 +280,8 @@ sys_fsetxattr(int fd, char __user *name,
  * Extended attribute GET operations
  */
 static ssize_t
-getxattr(struct dentry *d, char __user *name, void __user *value, size_t size)
+getxattr(struct dentry *dentry, struct vfsmount *mnt, char __user *name,
+	 void __user *value, size_t size)
 {
 	ssize_t error;
 	void *kvalue = NULL;
@@ -299,7 +301,7 @@ getxattr(struct dentry *d, char __user *
 			return -ENOMEM;
 	}
 
-	error = vfs_getxattr(d, kname, kvalue, size);
+	error = vfs_getxattr(dentry, mnt, kname, kvalue, size);
 	if (error > 0) {
 		if (size && copy_to_user(value, kvalue, error))
 			error = -EFAULT;
@@ -322,7 +324,7 @@ sys_getxattr(char __user *path, char __u
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = getxattr(nd.dentry, name, value, size);
+	error = getxattr(nd.dentry, nd.mnt, name, value, size);
 	path_release(&nd);
 	return error;
 }
@@ -337,7 +339,7 @@ sys_lgetxattr(char __user *path, char __
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = getxattr(nd.dentry, name, value, size);
+	error = getxattr(nd.dentry, nd.mnt, name, value, size);
 	path_release(&nd);
 	return error;
 }
@@ -351,7 +353,7 @@ sys_fgetxattr(int fd, char __user *name,
 	f = fget(fd);
 	if (!f)
 		return error;
-	error = getxattr(f->f_path.dentry, name, value, size);
+	error = getxattr(f->f_path.dentry, f->f_path.mnt, name, value, size);
 	fput(f);
 	return error;
 }
Index: linux-2.6/include/linux/xattr.h
===================================================================
--- linux-2.6.orig/include/linux/xattr.h
+++ linux-2.6/include/linux/xattr.h
@@ -40,7 +40,8 @@ struct xattr_handler {
 		   size_t size, int flags);
 };
 
-ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
+ssize_t vfs_getxattr(struct dentry *, struct vfsmount *, char *, void *,
+		     size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
 int vfs_setxattr(struct dentry *, struct vfsmount *, char *, void *, size_t,
 		 int);

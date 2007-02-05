Return-Path: <linux-kernel-owner+w=401wt.eu-S933184AbXBES1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184AbXBES1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933214AbXBES0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:26:55 -0500
Received: from ns2.suse.de ([195.135.220.15]:47817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933170AbXBES03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:26:29 -0500
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, linux-security-module@vger.kernel.org,
       agruen@suse.de
Date: Mon, 05 Feb 2007 10:25:32 -0800
Message-Id: <20070205182532.12164.97575.sendpatchset@ermintrude.int.wirex.com>
In-Reply-To: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
Subject: [RFC 21/28] Add a struct vfsmount parameter to vfs_setxattr()
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a struct vfsmount parameter to vfs_setxattr()

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c
+++ linux-2.6/fs/nfsd/vfs.c
@@ -415,7 +415,7 @@ set_nfsv4_acl_one(struct dentry *dentry,
 		goto out;
 	}
 
-	error = vfs_setxattr(dentry, key, buf, len, 0);
+	error = vfs_setxattr(dentry, NULL, key, buf, len, 0);
 out:
 	kfree(buf);
 	return error;
@@ -1969,7 +1969,7 @@ nfsd_set_posix_acl(struct svc_fh *fhp, i
 		size = 0;
 
 	if (size)
-		error = vfs_setxattr(fhp->fh_dentry, name, value, size, 0);
+		error = vfs_setxattr(fhp->fh_dentry, NULL, name, value, size,0);
 	else {
 		if (!S_ISDIR(inode->i_mode) && type == ACL_TYPE_DEFAULT)
 			error = 0;
Index: linux-2.6/fs/xattr.c
===================================================================
--- linux-2.6.orig/fs/xattr.c
+++ linux-2.6/fs/xattr.c
@@ -70,8 +70,8 @@ xattr_permission(struct inode *inode, co
 }
 
 int
-vfs_setxattr(struct dentry *dentry, char *name, void *value,
-		size_t size, int flags)
+vfs_setxattr(struct dentry *dentry, struct vfsmount *mnt, char *name,
+	     void *value, size_t size, int flags)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -194,8 +194,8 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
  * Extended attribute SET operations
  */
 static long
-setxattr(struct dentry *d, char __user *name, void __user *value,
-	 size_t size, int flags)
+setxattr(struct dentry *dentry, struct vfsmount *mnt, char __user *name,
+	 void __user *value, size_t size, int flags)
 {
 	int error;
 	void *kvalue = NULL;
@@ -222,7 +222,7 @@ setxattr(struct dentry *d, char __user *
 		}
 	}
 
-	error = vfs_setxattr(d, kname, kvalue, size, flags);
+	error = vfs_setxattr(dentry, mnt, kname, kvalue, size, flags);
 	kfree(kvalue);
 	return error;
 }
@@ -237,7 +237,7 @@ sys_setxattr(char __user *path, char __u
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = setxattr(nd.dentry, name, value, size, flags);
+	error = setxattr(nd.dentry, nd.mnt, name, value, size, flags);
 	path_release(&nd);
 	return error;
 }
@@ -252,7 +252,7 @@ sys_lsetxattr(char __user *path, char __
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = setxattr(nd.dentry, name, value, size, flags);
+	error = setxattr(nd.dentry, nd.mnt, name, value, size, flags);
 	path_release(&nd);
 	return error;
 }
@@ -270,7 +270,7 @@ sys_fsetxattr(int fd, char __user *name,
 		return error;
 	dentry = f->f_path.dentry;
 	audit_inode(NULL, dentry->d_inode);
-	error = setxattr(dentry, name, value, size, flags);
+	error = setxattr(dentry, f->f_vfsmnt, name, value, size, flags);
 	fput(f);
 	return error;
 }
Index: linux-2.6/include/linux/xattr.h
===================================================================
--- linux-2.6.orig/include/linux/xattr.h
+++ linux-2.6/include/linux/xattr.h
@@ -42,7 +42,8 @@ struct xattr_handler {
 
 ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
-int vfs_setxattr(struct dentry *, char *, void *, size_t, int);
+int vfs_setxattr(struct dentry *, struct vfsmount *, char *, void *, size_t,
+		 int);
 int vfs_removexattr(struct dentry *, char *);
 
 ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);

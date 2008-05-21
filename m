Return-Path: <linux-kernel-owner+w=401wt.eu-S936168AbYEURRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936168AbYEURRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932348AbYEURPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:15:51 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33050 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765232AbYEURPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:15:49 -0400
Message-Id: <20080521171543.579064376@szeredi.hu>
References: <20080521171458.077908538@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 21 May 2008 19:15:00 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 02/14] vfs: add path_listxattr()
Content-Disposition: inline; filename=path_listxattr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Introduce path_listxattr().  Make vfs_listxattr() static.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/xattr.c            |   15 ++++++++-------
 include/linux/xattr.h |    2 +-
 2 files changed, 9 insertions(+), 8 deletions(-)

Index: linux-2.6/fs/xattr.c
===================================================================
--- linux-2.6.orig/fs/xattr.c	2008-05-21 13:30:33.000000000 +0200
+++ linux-2.6/fs/xattr.c	2008-05-21 13:39:36.000000000 +0200
@@ -181,8 +181,9 @@ nolsm:
 EXPORT_SYMBOL_GPL(path_getxattr);
 
 ssize_t
-vfs_listxattr(struct dentry *d, char *list, size_t size)
+path_listxattr(struct path *path, char *list, size_t size)
 {
+	struct dentry *d = path->dentry;
 	ssize_t error;
 
 	error = security_inode_listxattr(d);
@@ -198,7 +199,7 @@ vfs_listxattr(struct dentry *d, char *li
 	}
 	return error;
 }
-EXPORT_SYMBOL_GPL(vfs_listxattr);
+EXPORT_SYMBOL_GPL(path_listxattr);
 
 static int
 vfs_removexattr(struct dentry *dentry, const char *name)
@@ -410,7 +411,7 @@ sys_fgetxattr(int fd, const char __user 
  * Extended attribute LIST operations
  */
 static ssize_t
-listxattr(struct dentry *d, char __user *list, size_t size)
+listxattr(struct path *path, char __user *list, size_t size)
 {
 	ssize_t error;
 	char *klist = NULL;
@@ -423,7 +424,7 @@ listxattr(struct dentry *d, char __user 
 			return -ENOMEM;
 	}
 
-	error = vfs_listxattr(d, klist, size);
+	error = path_listxattr(path, klist, size);
 	if (error > 0) {
 		if (size && copy_to_user(list, klist, error))
 			error = -EFAULT;
@@ -445,7 +446,7 @@ sys_listxattr(const char __user *path, c
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = listxattr(nd.path.dentry, list, size);
+	error = listxattr(&nd.path, list, size);
 	path_put(&nd.path);
 	return error;
 }
@@ -459,7 +460,7 @@ sys_llistxattr(const char __user *path, 
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = listxattr(nd.path.dentry, list, size);
+	error = listxattr(&nd.path, list, size);
 	path_put(&nd.path);
 	return error;
 }
@@ -474,7 +475,7 @@ sys_flistxattr(int fd, char __user *list
 	if (!f)
 		return error;
 	audit_inode(NULL, f->f_path.dentry);
-	error = listxattr(f->f_path.dentry, list, size);
+	error = listxattr(&f->f_path, list, size);
 	fput(f);
 	return error;
 }
Index: linux-2.6/include/linux/xattr.h
===================================================================
--- linux-2.6.orig/include/linux/xattr.h	2008-05-21 13:15:13.000000000 +0200
+++ linux-2.6/include/linux/xattr.h	2008-05-21 13:37:56.000000000 +0200
@@ -49,7 +49,7 @@ struct xattr_handler {
 
 ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
 ssize_t path_getxattr(struct path *, const char *, void *, size_t);
-ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
+ssize_t path_listxattr(struct path *, char *, size_t);
 int path_setxattr(struct path *, const char *, const void *, size_t, int);
 int path_removexattr(struct path *, const char *);
 

--

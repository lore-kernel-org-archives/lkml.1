Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbZKOGvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbZKOGvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 01:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbZKOGvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 01:51:50 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:53803 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819AbZKOGvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 01:51:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAD8u/0pGGN1W/2dsb2JhbACBTNA3hDwE
Date: Sun, 15 Nov 2009 01:51:53 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Debugfs: fix create mutex racy fops and private data
Message-ID: <20091115065153.GA29928@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 01:50:07 up 88 days, 17:39,  4 users,  load average: 0.72, 0.33,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting fops and private data outside of the mutex at debugfs file creation
introduces a race where the files can be opened with the wrong file operations
and private data. It is easy to trigger with a process waiting on file
creation notification.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Greg Kroah-Hartman <greg@kroah.com>
---
 fs/debugfs/inode.c |   55 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 23 deletions(-)

Index: linux-2.6-lttng/fs/debugfs/inode.c
===================================================================
--- linux-2.6-lttng.orig/fs/debugfs/inode.c	2009-11-15 01:22:59.000000000 -0500
+++ linux-2.6-lttng/fs/debugfs/inode.c	2009-11-15 01:42:46.000000000 -0500
@@ -32,7 +32,9 @@ static struct vfsmount *debugfs_mount;
 static int debugfs_mount_count;
 static bool debugfs_registered;
 
-static struct inode *debugfs_get_inode(struct super_block *sb, int mode, dev_t dev)
+static struct inode *debugfs_get_inode(struct super_block *sb, int mode, dev_t dev,
+				       void *data, const struct file_operations *fops)
+
 {
 	struct inode *inode = new_inode(sb);
 
@@ -44,14 +46,18 @@ static struct inode *debugfs_get_inode(s
 			init_special_inode(inode, mode, dev);
 			break;
 		case S_IFREG:
-			inode->i_fop = &debugfs_file_operations;
+			inode->i_fop = fops ? fops : &debugfs_file_operations;
+			inode->i_private = data;
 			break;
 		case S_IFLNK:
 			inode->i_op = &debugfs_link_operations;
+			inode->i_fop = fops;
+			inode->i_private = data;
 			break;
 		case S_IFDIR:
 			inode->i_op = &simple_dir_inode_operations;
-			inode->i_fop = &simple_dir_operations;
+			inode->i_fop = fops ? fops : &simple_dir_operations;
+			inode->i_private = data;
 
 			/* directory inodes start off with i_nlink == 2
 			 * (for "." entry) */
@@ -64,7 +70,8 @@ static struct inode *debugfs_get_inode(s
 
 /* SMP-safe */
 static int debugfs_mknod(struct inode *dir, struct dentry *dentry,
-			 int mode, dev_t dev)
+			 int mode, dev_t dev, void *data,
+			 const struct file_operations *fops)
 {
 	struct inode *inode;
 	int error = -EPERM;
@@ -72,7 +79,7 @@ static int debugfs_mknod(struct inode *d
 	if (dentry->d_inode)
 		return -EEXIST;
 
-	inode = debugfs_get_inode(dir->i_sb, mode, dev);
+	inode = debugfs_get_inode(dir->i_sb, mode, dev, data, fops);
 	if (inode) {
 		d_instantiate(dentry, inode);
 		dget(dentry);
@@ -81,12 +88,13 @@ static int debugfs_mknod(struct inode *d
 	return error;
 }
 
-static int debugfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+static int debugfs_mkdir(struct inode *dir, struct dentry *dentry, int mode,
+			 void *data, const struct file_operations *fops)
 {
 	int res;
 
 	mode = (mode & (S_IRWXUGO | S_ISVTX)) | S_IFDIR;
-	res = debugfs_mknod(dir, dentry, mode, 0);
+	res = debugfs_mknod(dir, dentry, mode, 0, data, fops);
 	if (!res) {
 		inc_nlink(dir);
 		fsnotify_mkdir(dir, dentry);
@@ -94,18 +102,20 @@ static int debugfs_mkdir(struct inode *d
 	return res;
 }
 
-static int debugfs_link(struct inode *dir, struct dentry *dentry, int mode)
+static int debugfs_link(struct inode *dir, struct dentry *dentry, int mode,
+			void *data, const struct file_operations *fops)
 {
 	mode = (mode & S_IALLUGO) | S_IFLNK;
-	return debugfs_mknod(dir, dentry, mode, 0);
+	return debugfs_mknod(dir, dentry, mode, 0, data, fops);
 }
 
-static int debugfs_create(struct inode *dir, struct dentry *dentry, int mode)
+static int debugfs_create(struct inode *dir, struct dentry *dentry, int mode,
+			  void *data, const struct file_operations *fops)
 {
 	int res;
 
 	mode = (mode & S_IALLUGO) | S_IFREG;
-	res = debugfs_mknod(dir, dentry, mode, 0);
+	res = debugfs_mknod(dir, dentry, mode, 0, data, fops);
 	if (!res)
 		fsnotify_create(dir, dentry);
 	return res;
@@ -139,7 +149,9 @@ static struct file_system_type debug_fs_
 
 static int debugfs_create_by_name(const char *name, mode_t mode,
 				  struct dentry *parent,
-				  struct dentry **dentry)
+				  struct dentry **dentry,
+				  void *data,
+				  const struct file_operations *fops)
 {
 	int error = 0;
 
@@ -164,13 +176,16 @@ static int debugfs_create_by_name(const 
 	if (!IS_ERR(*dentry)) {
 		switch (mode & S_IFMT) {
 		case S_IFDIR:
-			error = debugfs_mkdir(parent->d_inode, *dentry, mode);
+			error = debugfs_mkdir(parent->d_inode, *dentry, mode,
+					      data, fops);
 			break;
 		case S_IFLNK:
-			error = debugfs_link(parent->d_inode, *dentry, mode);
+			error = debugfs_link(parent->d_inode, *dentry, mode,
+					     data, fops);
 			break;
 		default:
-			error = debugfs_create(parent->d_inode, *dentry, mode);
+			error = debugfs_create(parent->d_inode, *dentry, mode,
+					       data, fops);
 			break;
 		}
 		dput(*dentry);
@@ -221,19 +236,13 @@ struct dentry *debugfs_create_file(const
 	if (error)
 		goto exit;
 
-	error = debugfs_create_by_name(name, mode, parent, &dentry);
+	error = debugfs_create_by_name(name, mode, parent, &dentry,
+				       data, fops);
 	if (error) {
 		dentry = NULL;
 		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 		goto exit;
 	}
-
-	if (dentry->d_inode) {
-		if (data)
-			dentry->d_inode->i_private = data;
-		if (fops)
-			dentry->d_inode->i_fop = fops;
-	}
 exit:
 	return dentry;
 }

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

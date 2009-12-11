Return-Path: <linux-kernel-owner+w=401wt.eu-S1762786AbZLKWZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762786AbZLKWZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762711AbZLKWZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:25:24 -0500
Received: from kroah.org ([198.145.64.141]:32793 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762715AbZLKWZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:25:02 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/27] debugfs: fix create mutex racy fops and private data
Date: Fri, 11 Dec 2009 14:24:33 -0800
Message-Id: <1260570289-6997-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Setting fops and private data outside of the mutex at debugfs file
creation introduces a race where the files can be opened with the wrong
file operations and private data.  It is easy to trigger with a process
waiting on file creation notification.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/debugfs/inode.c |   55 ++++++++++++++++++++++++++++++---------------------
 1 files changed, 32 insertions(+), 23 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 0d23b52..b486169 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -32,7 +32,9 @@ static struct vfsmount *debugfs_mount;
 static int debugfs_mount_count;
 static bool debugfs_registered;
 
-static struct inode *debugfs_get_inode(struct super_block *sb, int mode, dev_t dev)
+static struct inode *debugfs_get_inode(struct super_block *sb, int mode, dev_t dev,
+				       void *data, const struct file_operations *fops)
+
 {
 	struct inode *inode = new_inode(sb);
 
@@ -44,14 +46,18 @@ static struct inode *debugfs_get_inode(struct super_block *sb, int mode, dev_t d
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
@@ -64,7 +70,8 @@ static struct inode *debugfs_get_inode(struct super_block *sb, int mode, dev_t d
 
 /* SMP-safe */
 static int debugfs_mknod(struct inode *dir, struct dentry *dentry,
-			 int mode, dev_t dev)
+			 int mode, dev_t dev, void *data,
+			 const struct file_operations *fops)
 {
 	struct inode *inode;
 	int error = -EPERM;
@@ -72,7 +79,7 @@ static int debugfs_mknod(struct inode *dir, struct dentry *dentry,
 	if (dentry->d_inode)
 		return -EEXIST;
 
-	inode = debugfs_get_inode(dir->i_sb, mode, dev);
+	inode = debugfs_get_inode(dir->i_sb, mode, dev, data, fops);
 	if (inode) {
 		d_instantiate(dentry, inode);
 		dget(dentry);
@@ -81,12 +88,13 @@ static int debugfs_mknod(struct inode *dir, struct dentry *dentry,
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
@@ -94,18 +102,20 @@ static int debugfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
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
@@ -139,7 +149,9 @@ static struct file_system_type debug_fs_type = {
 
 static int debugfs_create_by_name(const char *name, mode_t mode,
 				  struct dentry *parent,
-				  struct dentry **dentry)
+				  struct dentry **dentry,
+				  void *data,
+				  const struct file_operations *fops)
 {
 	int error = 0;
 
@@ -164,13 +176,16 @@ static int debugfs_create_by_name(const char *name, mode_t mode,
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
@@ -221,19 +236,13 @@ struct dentry *debugfs_create_file(const char *name, mode_t mode,
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
1.6.5.5


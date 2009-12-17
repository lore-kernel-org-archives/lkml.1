Return-Path: <linux-kernel-owner+w=401wt.eu-S1759715AbZLQAyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715AbZLQAyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756036AbZLQAyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:54:35 -0500
Received: from kroah.org ([198.145.64.141]:44464 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755641AbZLQAyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:54:33 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 16:47:07 2009
Message-Id: <20091217004707.207213364@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 16:45:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [02/18] debugfs: fix create mutex racy fops and private data
In-Reply-To: <20091217005306.GA6230@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

commit d3a3b0adad0865c12e39b712ca89efbd0a3a0dbc upstream.

Setting fops and private data outside of the mutex at debugfs file
creation introduces a race where the files can be opened with the wrong
file operations and private data.  It is easy to trigger with a process
waiting on file creation notification.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/debugfs/inode.c |   55 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 23 deletions(-)

--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -32,7 +32,9 @@
 static struct vfsmount *debugfs_mount;
 static int debugfs_mount_count;
 
-static struct inode *debugfs_get_inode(struct super_block *sb, int mode, dev_t dev)
+static struct inode *debugfs_get_inode(struct super_block *sb, int mode, dev_t dev,
+				       void *data, const struct file_operations *fops)
+
 {
 	struct inode *inode = new_inode(sb);
 
@@ -47,14 +49,18 @@ static struct inode *debugfs_get_inode(s
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
@@ -67,7 +73,8 @@ static struct inode *debugfs_get_inode(s
 
 /* SMP-safe */
 static int debugfs_mknod(struct inode *dir, struct dentry *dentry,
-			 int mode, dev_t dev)
+			 int mode, dev_t dev, void *data,
+			 const struct file_operations *fops)
 {
 	struct inode *inode;
 	int error = -EPERM;
@@ -75,7 +82,7 @@ static int debugfs_mknod(struct inode *d
 	if (dentry->d_inode)
 		return -EEXIST;
 
-	inode = debugfs_get_inode(dir->i_sb, mode, dev);
+	inode = debugfs_get_inode(dir->i_sb, mode, dev, data, fops);
 	if (inode) {
 		d_instantiate(dentry, inode);
 		dget(dentry);
@@ -84,12 +91,13 @@ static int debugfs_mknod(struct inode *d
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
@@ -97,18 +105,20 @@ static int debugfs_mkdir(struct inode *d
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
@@ -142,7 +152,9 @@ static struct file_system_type debug_fs_
 
 static int debugfs_create_by_name(const char *name, mode_t mode,
 				  struct dentry *parent,
-				  struct dentry **dentry)
+				  struct dentry **dentry,
+				  void *data,
+				  const struct file_operations *fops)
 {
 	int error = 0;
 
@@ -167,13 +179,16 @@ static int debugfs_create_by_name(const 
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
@@ -224,19 +239,13 @@ struct dentry *debugfs_create_file(const
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



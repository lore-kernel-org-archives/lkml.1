Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbYEaPl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbYEaPl0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 11:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbYEaPis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 11:38:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57559 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbYEaPiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 11:38:18 -0400
Message-Id: <20080531153511.331589811@arndb.de>
References: <20080531152013.031903990@arndb.de>
User-Agent: quilt/0.46-1
Date: Sat, 31 May 2008 17:20:20 +0200
From: arnd@arndb.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hch@lst.de
Subject: [RFC 7/7] cramfs: add missing inode operations
Content-Disposition: inline; filename=0007-cramfs-add-missing-inode-operations.patch
X-Provags-ID: V01U2FsdGVkX1+acgbItv7yzwnyGE5vZ0+iku11Vi2oBoH+MqG
 a6Y4KDK1V1TI6Cuc/1P/zyqIUSSmkkJTMD1s7B6jxDtt4Ot00y
 VPL7pUzzMa3yBT49iz8VQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for create, link, symlink, mkdir, mknod
and rename, all of which are relatively simple to do based
on the previous patches.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/cramfs/inode.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index e7d2b47..bcdd592 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -557,6 +557,78 @@ int cramfs_rmdir(struct inode *dir, struct dentry *dentry)
 }
 
 /*
+ * File creation. Allocate an inode, and we're done..
+ */
+static int
+cramfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
+{
+	struct inode * inode = get_cramfs_inode(dir->i_sb, mode, dev);
+	int error = -ENOSPC;
+
+	if (inode) {
+		if (dir->i_mode & S_ISGID) {
+			inode->i_gid = dir->i_gid;
+			if (S_ISDIR(mode))
+				inode->i_mode |= S_ISGID;
+		}
+		d_instantiate(dentry, inode);
+		dget(dentry);	/* Extra count - pin the dentry in core */
+		error = 0;
+		dir->i_mtime = dir->i_ctime = CURRENT_TIME;
+	}
+	return error;
+}
+
+static int cramfs_mkdir(struct inode * dir, struct dentry * dentry, int mode)
+{
+	return cramfs_mknod(dir, dentry, mode | S_IFDIR, 0);
+}
+
+static int cramfs_create(struct inode *dir, struct dentry *dentry, int mode, struct nameidata *nd)
+{
+	return cramfs_mknod(dir, dentry, mode | S_IFREG, 0);
+}
+
+static int cramfs_symlink(struct inode * dir, struct dentry *dentry, const char * symname)
+{
+	struct inode *inode;
+	int error = -ENOSPC;
+
+	inode = get_cramfs_inode(dir->i_sb, S_IFLNK|S_IRWXUGO, 0);
+	if (inode) {
+		int l = strlen(symname)+1;
+		error = page_symlink(inode, symname, l);
+		if (!error) {
+			if (dir->i_mode & S_ISGID)
+				inode->i_gid = dir->i_gid;
+			d_instantiate(dentry, inode);
+			dget(dentry);
+			dir->i_mtime = dir->i_ctime = CURRENT_TIME;
+		} else
+			iput(inode);
+	}
+	return error;
+}
+
+int cramfs_rename(struct inode *old_dir, struct dentry *old_dentry,
+		struct inode *new_dir, struct dentry *new_dentry)
+{
+	struct inode *inode = old_dentry->d_inode;
+
+	if (!cramfs_empty(new_dentry))
+		return -ENOTEMPTY;
+
+	if (new_dentry->d_inode)
+		cramfs_unlink(new_dir, new_dentry);
+
+	old_dir->i_ctime = old_dir->i_mtime = new_dir->i_ctime =
+		new_dir->i_mtime = inode->i_ctime = CURRENT_TIME;
+
+	return 0;
+}
+
+
+/*
  * Lookup and fill in the inode data..
  */
 static struct dentry * cramfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
@@ -688,8 +760,14 @@ static const struct file_operations cramfs_directory_operations = {
 };
 
 static const struct inode_operations cramfs_dir_inode_operations = {
+	.create		= cramfs_create,
+	.link		= simple_link,
 	.unlink		= cramfs_unlink,
+	.symlink	= cramfs_symlink,
+	.mkdir		= cramfs_mkdir,
 	.rmdir		= cramfs_rmdir,
+	.mknod		= cramfs_mknod,
+	.rename		= cramfs_rename,
 	.lookup		= cramfs_lookup,
 };
 
-- 
1.5.4.3

-- 


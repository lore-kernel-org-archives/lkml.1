Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbYGVWOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbYGVWOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 18:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbYGVWNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 18:13:24 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59081 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbYGVWNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 18:13:23 -0400
Message-Id: <20080722221319.194777295@szeredi.hu>
References: <20080722221259.866628660@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 23 Jul 2008 00:13:01 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>
Subject: [patch 02/14] reiserfs: dont call vfs_rmdir
Content-Disposition: inline; filename=reiserfs-dont-call-vfs_rmdir.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

reiserfs_delete_xattrs() calls vfs_rmdir() to remove the private
directory associated with the extended attributes for an inode.
Replace with explicit call to reiserfs_rmdir().

The extended attribute files reside in a private directory, completely
inaccessible from userspace.  This means, that checking against mounts
on the dentry is not necessary.

The calls to may_delete() and security_inode_rmdir(), as performed by
vfs_rmdir() are also unecessary for this case.

Based on patch by Jeff Mahoney.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Jeff Mahoney <jeffm@suse.de>
---
 fs/reiserfs/namei.c         |    2 +-
 fs/reiserfs/xattr.c         |   22 +++++++++++++++++++++-
 include/linux/reiserfs_fs.h |    1 +
 3 files changed, 23 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/reiserfs/namei.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/namei.c	2008-07-23 00:10:13.000000000 +0200
+++ linux-2.6/fs/reiserfs/namei.c	2008-07-23 00:10:21.000000000 +0200
@@ -850,7 +850,7 @@ static inline int reiserfs_empty_dir(str
 	return 1;
 }
 
-static int reiserfs_rmdir(struct inode *dir, struct dentry *dentry)
+int reiserfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	int retval, err;
 	struct inode *inode;
Index: linux-2.6/fs/reiserfs/xattr.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/xattr.c	2008-07-23 00:10:13.000000000 +0200
+++ linux-2.6/fs/reiserfs/xattr.c	2008-07-23 00:10:21.000000000 +0200
@@ -35,6 +35,7 @@
 #include <linux/namei.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
+#include <linux/quotaops.h>
 #include <linux/file.h>
 #include <linux/pagemap.h>
 #include <linux/xattr.h>
@@ -712,6 +713,25 @@ reiserfs_delete_xattrs_filler(void *buf,
 
 }
 
+static int xattr_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	int error;
+
+	DQUOT_INIT(dir);
+
+	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
+	dentry_unhash(dentry);
+	error = reiserfs_rmdir(dir, dentry);
+	if (!error)
+		dentry->d_inode->i_flags |= S_DEAD;
+	mutex_unlock(&dentry->d_inode->i_mutex);
+	if (!error)
+		d_delete(dentry);
+	dput(dentry);
+
+	return error;
+}
+
 /* This is called w/ inode->i_mutex downed */
 int reiserfs_delete_xattrs(struct inode *inode)
 {
@@ -746,7 +766,7 @@ int reiserfs_delete_xattrs(struct inode 
 	if (dir->d_inode->i_nlink <= 2) {
 		root = get_xa_root(inode->i_sb, XATTR_REPLACE);
 		reiserfs_write_lock_xattrs(inode->i_sb);
-		err = vfs_rmdir(root->d_inode, dir);
+		err = xattr_rmdir(root->d_inode, dir);
 		reiserfs_write_unlock_xattrs(inode->i_sb);
 		dput(root);
 	} else {
Index: linux-2.6/include/linux/reiserfs_fs.h
===================================================================
--- linux-2.6.orig/include/linux/reiserfs_fs.h	2008-07-23 00:10:13.000000000 +0200
+++ linux-2.6/include/linux/reiserfs_fs.h	2008-07-23 00:10:21.000000000 +0200
@@ -1911,6 +1911,7 @@ static inline void reiserfs_update_sd(st
 void sd_attrs_to_i_attrs(__u16 sd_attrs, struct inode *inode);
 void i_attrs_to_sd_attrs(struct inode *inode, __u16 * sd_attrs);
 int reiserfs_setattr(struct dentry *dentry, struct iattr *attr);
+int reiserfs_rmdir(struct inode *dir, struct dentry *dentry);
 
 /* namei.c */
 void set_de_name_and_namelen(struct reiserfs_dir_entry *de);

--

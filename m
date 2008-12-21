Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbYLUO5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbYLUO5f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 09:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYLUO50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 09:57:26 -0500
Received: from www.tglx.de ([62.245.132.106]:37895 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbYLUO5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 09:57:22 -0500
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, malware-list@lists.printk.net, eparis@redhat.com,
       hch@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 1/5] VFS: DazukoFS, stackable-fs, file access control
From: John Ogness <dazukocode@ogness.net>
References: <86d4flh96z.fsf@johno-ibook.fn.ogness.net>
Date: Sun, 21 Dec 2008 15:56:42 +0100
In-Reply-To: <86d4flh96z.fsf@johno-ibook.fn.ogness.net> (John Ogness's message of "Sun\, 21 Dec 2008 15\:52\:36 +0100")
Message-ID: <868wq9h905.fsf@johno-ibook.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1: Introduces DazukoFS as a nullfs. This is the raw stackable
         filesystem part of DazukoFS and does nothing except stack and
         pass filesystem calls to the lower filesystem.

Patched against 2.6.28-rc9.

Signed-off-by: John Ogness <dazukocode@ogness.net>
---
 Documentation/filesystems/dazukofs.txt |   81 ++
 fs/Kconfig                             |   11 
 fs/Makefile                            |    1 
 fs/dazukofs/Makefile                   |    7 
 fs/dazukofs/dazukofs_fs.h              |  163 ++++
 fs/dazukofs/dentry.c                   |  183 +++++
 fs/dazukofs/file.c                     |  340 +++++++++
 fs/dazukofs/inode.c                    |  832 +++++++++++++++++++++++
 fs/dazukofs/mmap.c                     |  117 +++
 fs/dazukofs/super.c                    |  337 +++++++++
 10 files changed, 2072 insertions(+)
Index: linux-2.6.27/fs/dazukofs/dazukofs_fs.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.27/fs/dazukofs/dazukofs_fs.h	2008-12-21 15:09:53.000000000 +0100
@@ -0,0 +1,163 @@
+/* dazukofs: access control stackable filesystem
+
+   Copyright (C) 1997-2004 Erez Zadok
+   Copyright (C) 2001-2004 Stony Brook University
+   Copyright (C) 2004-2007 International Business Machines Corp.
+   Copyright (C) 2008 John Ogness
+     Author: John Ogness <dazukocode@ogness.net>
+
+   This program is free software; you can redistribute it and/or
+   modify it under the terms of the GNU General Public License
+   as published by the Free Software Foundation; either version 2
+   of the License, or (at your option) any later version.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program; if not, write to the Free Software
+   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+*/
+
+#ifndef __DAZUKOFS_FS_H
+#define __DAZUKOFS_FS_H
+
+extern struct kmem_cache *dazukofs_dentry_info_cachep;
+extern struct kmem_cache *dazukofs_file_info_cachep;
+extern struct file_operations dazukofs_main_fops;
+extern const struct file_operations dazukofs_dir_fops;
+extern struct dentry_operations dazukofs_dops;
+extern struct address_space_operations dazukofs_aops;
+
+extern int dazukofs_interpose(struct dentry *lower_dentry,
+			      struct dentry *dentry, struct super_block *sb,
+			      int already_hashed);
+
+struct dazukofs_sb_info {
+	struct super_block *lower_sb;
+};
+
+struct dazukofs_inode_info {
+	struct inode *lower_inode;
+
+	/*
+	 * the inode (embedded)
+	 */
+	struct inode vfs_inode;
+};
+
+struct dazukofs_dentry_info {
+	struct dentry *lower_dentry;
+	struct vfsmount *lower_mnt;
+};
+
+struct dazukofs_file_info {
+	struct file *lower_file;
+};
+
+static inline
+struct dazukofs_sb_info *GET_SB_INFO(struct super_block *upper_sb)
+{
+	return upper_sb->s_fs_info;
+}
+
+static inline void SET_SB_INFO(struct super_block *upper_sb,
+			       struct dazukofs_sb_info *sbi)
+{
+	upper_sb->s_fs_info = sbi;
+}
+
+static inline struct super_block *GET_LOWER_SB(struct super_block *upper_sb)
+{
+	return ((struct dazukofs_sb_info *)upper_sb->s_fs_info)->lower_sb;
+}
+
+static inline void SET_LOWER_SB(struct super_block *upper_sb,
+				struct super_block *lower_sb)
+{
+       ((struct dazukofs_sb_info *)upper_sb->s_fs_info)->lower_sb = lower_sb;
+}
+
+static inline
+struct dazukofs_inode_info *GET_INODE_INFO(struct inode *upper_inode)
+{
+	return container_of(upper_inode, struct dazukofs_inode_info,
+			    vfs_inode);
+}
+
+static inline struct inode *GET_LOWER_INODE(struct inode *upper_inode)
+{
+	return ((struct dazukofs_inode_info *)
+		container_of(upper_inode, struct dazukofs_inode_info,
+			     vfs_inode))->lower_inode;
+}
+
+static inline void SET_LOWER_INODE(struct inode *upper_inode,
+				   struct inode *lower_inode)
+{
+	((struct dazukofs_inode_info *)
+	 container_of(upper_inode, struct dazukofs_inode_info,
+		      vfs_inode))->lower_inode = lower_inode;
+}
+
+static inline
+struct dazukofs_dentry_info *GET_DENTRY_INFO(struct dentry *upper_dentry)
+{
+	return upper_dentry->d_fsdata;
+}
+
+static inline void SET_DENTRY_INFO(struct dentry *upper_dentry,
+				   struct dazukofs_dentry_info *dentryi)
+{
+	upper_dentry->d_fsdata = dentryi;
+}
+
+static inline struct dentry *GET_LOWER_DENTRY(struct dentry *upper_dentry)
+{
+	return ((struct dazukofs_dentry_info *)
+		upper_dentry->d_fsdata)->lower_dentry;
+}
+
+static inline struct vfsmount *GET_LOWER_MNT(struct dentry *upper_dentry)
+{
+	return ((struct dazukofs_dentry_info *)
+		upper_dentry->d_fsdata)->lower_mnt;
+}
+
+static inline void SET_LOWER_DENTRY(struct dentry *upper_dentry,
+				    struct dentry *lower_dentry,
+				    struct vfsmount *lower_mnt)
+{
+	((struct dazukofs_dentry_info *)upper_dentry->d_fsdata)->lower_dentry =
+		lower_dentry;
+	((struct dazukofs_dentry_info *)upper_dentry->d_fsdata)->lower_mnt =
+		lower_mnt;
+}
+
+static inline struct dazukofs_file_info *GET_FILE_INFO(struct file *upper_file)
+{
+	return upper_file->private_data;
+}
+
+static inline void SET_FILE_INFO(struct file *upper_file,
+				 struct dazukofs_file_info *filei)
+{
+	upper_file->private_data = filei;
+}
+
+static inline struct file *GET_LOWER_FILE(struct file *upper_file)
+{
+	return ((struct dazukofs_file_info *)
+		upper_file->private_data)->lower_file;
+}
+
+static inline void SET_LOWER_FILE(struct file *upper_file,
+				  struct file *lower_file)
+{
+	((struct dazukofs_file_info *)upper_file->private_data)->lower_file =
+		lower_file;
+}
+
+#endif  /* __DAZUKOFS_FS_H */
Index: linux-2.6.27/fs/dazukofs/dentry.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.27/fs/dazukofs/dentry.c	2008-12-21 15:09:53.000000000 +0100
@@ -0,0 +1,183 @@
+/* dazukofs: access control stackable filesystem
+
+   Copyright (C) 1997-2003 Erez Zadok
+   Copyright (C) 2001-2003 Stony Brook University
+   Copyright (C) 2004-2006 International Business Machines Corp.
+   Copyright (C) 2008 John Ogness
+     Author: John Ogness <dazukocode@ogness.net>
+
+   This program is free software; you can redistribute it and/or
+   modify it under the terms of the GNU General Public License
+   as published by the Free Software Foundation; either version 2
+   of the License, or (at your option) any later version.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program; if not, write to the Free Software
+   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+*/
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/mount.h>
+#include <linux/fs_stack.h>
+
+#include "dazukofs_fs.h"
+
+/**
+ * dazukofs_d_revalidate - revalidate a dentry found in the dcache
+ * @dentry: dentry to revalidate
+ * @nd: nameidata associated with dentry
+ *
+ * Description: Called when the VFS needs to revalidate a dentry. This is
+ * called whenever a name look-up finds a dentry in the dcache. Most
+ * filesystems leave this as NULL, because all their dentries in the dcache
+ * are valid.
+ *
+ * Call d_revalidate() on the lower dentry if available. The mnt/dentry
+ * (path) data in the nameidata needs to be temporarily swapped out for the
+ * lower call.
+ *
+ * After the call, the original path data is restored and the dentry's inode
+ * attributes are updated to match the lower inode.
+ *
+ * Returns 1 if dentry is valid, otherwise 0.
+ */
+static int dazukofs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
+{
+	struct vfsmount *lower_mnt;
+	struct dentry *lower_dentry;
+	struct vfsmount *vfsmount_save;
+	struct dentry *dentry_save;
+	int valid;
+
+	valid = 1;
+
+	lower_dentry = GET_LOWER_DENTRY(dentry);
+
+	if (!lower_dentry->d_op || !lower_dentry->d_op->d_revalidate)
+		goto out;
+
+	lower_mnt = GET_LOWER_MNT(dentry);
+
+	vfsmount_save = nd->path.mnt;
+	dentry_save = nd->path.dentry;
+
+	nd->path.mnt = mntget(lower_mnt);
+	nd->path.dentry = dget(lower_dentry);
+
+	valid = lower_dentry->d_op->d_revalidate(lower_dentry, nd);
+
+	mntput(lower_mnt);
+	dput(lower_dentry);
+
+	nd->path.mnt = vfsmount_save;
+	nd->path.dentry = dentry_save;
+
+	/* update the inode, even if d_revalidate() != 1 */
+	if (dentry->d_inode) {
+		struct inode *lower_inode;
+
+		lower_inode = GET_LOWER_INODE(dentry->d_inode);
+
+		fsstack_copy_attr_all(dentry->d_inode, lower_inode, NULL);
+	}
+out:
+	return valid;
+}
+
+/**
+ * dazukofs_d_hash - hash the given name
+ * @dentry: the parent dentry
+ * @name: the name to hash
+ *
+ * Description: Called when the VFS adds a dentry to the hash table.
+ *
+ * Call d_hash() on the lower dentry if available. Otherwise dazukofs
+ * does nothing. This is ok because the VFS will compute a default
+ * hash.
+ *
+ * Returns 0 on success.
+ */
+static int dazukofs_d_hash(struct dentry *dentry, struct qstr *name)
+{
+	struct dentry *lower_dentry = GET_LOWER_DENTRY(dentry);
+
+	if (!lower_dentry || !lower_dentry->d_op ||
+	    !lower_dentry->d_op->d_hash) {
+		return 0;
+	}
+
+	return lower_dentry->d_op->d_hash(lower_dentry, name);
+}
+
+/**
+ * dazukofs_d_release - clean up dentry
+ * @dentry: the dentry that will be released
+ *
+ * Description: Called when a dentry is really deallocated.
+ *
+ * Release our hold on the lower dentry and mnt. Then free the structure
+ * (from the cache) containing the lower data for this dentry.
+ */
+static void dazukofs_d_release(struct dentry *dentry)
+{
+	if (GET_DENTRY_INFO(dentry)) {
+		dput(GET_LOWER_DENTRY(dentry));
+		mntput(GET_LOWER_MNT(dentry));
+
+		kmem_cache_free(dazukofs_dentry_info_cachep,
+				GET_DENTRY_INFO(dentry));
+	}
+}
+
+/**
+ * dazukofs_d_compare - used to compare dentry's
+ * @dentry: the parent dentry
+ * @a: qstr of an existing dentry
+ * @b: qstr of a second dentry (dentry may not be valid)
+ *
+ * Description: Called when a dentry should be compared with another.
+ *
+ * Call d_compare() on the lower dentry if available. Otherwise, perform
+ * some basic comparisons between the two qstr's.
+ *
+ * Returns 0 if they are the same, otherwise 1.
+ */
+static int dazukofs_d_compare(struct dentry *dentry, struct qstr *a,
+			    struct qstr *b)
+{
+	struct dentry *lower_dentry = GET_LOWER_DENTRY(dentry);
+
+	if (lower_dentry && lower_dentry->d_op &&
+	    lower_dentry->d_op->d_compare) {
+
+		return lower_dentry->d_op->d_compare(lower_dentry, a, b);
+	}
+
+	if (a->len != b->len)
+		return 1;
+	if (memcmp(a->name, b->name, a->len))
+		return 1;
+
+	return 0;
+
+}
+
+/**
+ * Unused operations:
+ *   - d_delete
+ *   - d_iput
+ *   - d_dname
+ */
+struct dentry_operations dazukofs_dops = {
+	.d_revalidate	= dazukofs_d_revalidate,
+	.d_hash		= dazukofs_d_hash,
+	.d_release	= dazukofs_d_release,
+	.d_compare	= dazukofs_d_compare,
+};
Index: linux-2.6.27/fs/dazukofs/super.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.27/fs/dazukofs/super.c	2008-12-21 15:09:53.000000000 +0100
@@ -0,0 +1,337 @@
+/* dazukofs: access control stackable filesystem
+
+   Copyright (C) 1997-2003 Erez Zadok
+   Copyright (C) 2001-2003 Stony Brook University
+   Copyright (C) 2004-2006 International Business Machines Corp.
+   Copyright (C) 2008 John Ogness
+     Author: John Ogness <dazukocode@ogness.net>
+
+   This program is free software; you can redistribute it and/or
+   modify it under the terms of the GNU General Public License
+   as published by the Free Software Foundation; either version 2
+   of the License, or (at your option) any later version.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program; if not, write to the Free Software
+   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+*/
+
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/mount.h>
+
+#include "dazukofs_fs.h"
+
+static struct kmem_cache *dazukofs_inode_info_cachep;
+static struct kmem_cache *dazukofs_sb_info_cachep;
+struct kmem_cache *dazukofs_dentry_info_cachep;
+struct kmem_cache *dazukofs_file_info_cachep;
+
+static struct inode *dazukofs_alloc_inode(struct super_block *sb)
+{
+	struct dazukofs_inode_info *inodei;
+
+	inodei = kmem_cache_alloc(dazukofs_inode_info_cachep, GFP_KERNEL);
+	if (!inodei)
+		return NULL;
+
+	/*
+	 * The inode is embedded within the dazukofs_inode_info struct.
+	 */
+	return &(inodei->vfs_inode);
+}
+
+static void dazukofs_destroy_inode(struct inode *inode)
+{
+	/*
+	 * The inode is embedded within the dazukofs_inode_info struct.
+	 */
+	kmem_cache_free(dazukofs_inode_info_cachep,
+			GET_INODE_INFO(inode));
+}
+
+static int dazukofs_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	return vfs_statfs(GET_LOWER_DENTRY(dentry), buf);
+}
+
+static void dazukofs_clear_inode(struct inode *inode)
+{
+	iput(GET_LOWER_INODE(inode));
+}
+
+static void dazukofs_put_super(struct super_block *sb)
+{
+	struct dazukofs_sb_info *sbi = GET_SB_INFO(sb);
+
+	if (sbi)
+		kmem_cache_free(dazukofs_sb_info_cachep, sbi);
+}
+
+/**
+ * Unused operations:
+ *   - dirty_inode
+ *   - write_inode
+ *   - put_inode
+ *   - drop_inode
+ *   - delete_inode
+ *   - write_super
+ *   - sync_fs
+ *   - write_super_lockfs
+ *   - unlockfs
+ *   - remount_fs
+ *   - umount_begin
+ *   - show_options
+ *   - show_stats
+ *   - quota_read
+ *   - quota_write
+ */
+static struct super_operations dazukofs_sops = {
+	.alloc_inode	= dazukofs_alloc_inode,
+	.destroy_inode	= dazukofs_destroy_inode,
+	.put_super	= dazukofs_put_super,
+	.statfs		= dazukofs_statfs,
+	.clear_inode	= dazukofs_clear_inode,
+};
+
+static int dazukofs_parse_mount_options(char *options, struct super_block *sb)
+{
+	return 0;
+}
+
+static int dazukofs_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct dazukofs_sb_info *sbi;
+	struct dentry *root;
+	static const struct qstr name = { .name = "/", .len = 1 };
+	struct dazukofs_dentry_info *di;
+
+	sbi =  kmem_cache_zalloc(dazukofs_sb_info_cachep, GFP_KERNEL);
+	if (!sbi)
+		return -ENOMEM;
+
+	sb->s_op = &dazukofs_sops;
+
+	root = d_alloc(NULL, &name);
+	if (!root) {
+		kmem_cache_free(dazukofs_sb_info_cachep, sbi);
+		return -ENOMEM;
+	}
+
+	sb->s_root = root;
+
+	sb->s_root->d_op = &dazukofs_dops;
+	sb->s_root->d_sb = sb;
+	sb->s_root->d_parent = sb->s_root;
+
+	di = kmem_cache_zalloc(dazukofs_dentry_info_cachep, GFP_KERNEL);
+	if (!di) {
+		kmem_cache_free(dazukofs_sb_info_cachep, sbi);
+		dput(sb->s_root);
+		return -ENOMEM;
+	}
+
+	SET_DENTRY_INFO(sb->s_root, di);
+
+	SET_SB_INFO(sb, sbi);
+
+	return 0;
+}
+
+static int dazukofs_read_super(struct super_block *sb, const char *dev_name)
+{
+	struct nameidata nd;
+	struct dentry *lower_root;
+	struct vfsmount *lower_mnt;
+	int err;
+
+	memset(&nd, 0, sizeof(struct nameidata));
+	err = path_lookup(dev_name, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &nd);
+	if (err)
+		return err;
+
+	lower_root = dget(nd.path.dentry);
+	lower_mnt = mntget(nd.path.mnt);
+
+	if (IS_ERR(lower_root)) {
+		err = PTR_ERR(lower_root);
+		goto out_put;
+	}
+
+	if (!lower_root->d_inode) {
+		err = -ENOENT;
+		goto out_put;
+	}
+
+	SET_LOWER_SB(sb, lower_root->d_sb);
+	sb->s_maxbytes = lower_root->d_sb->s_maxbytes;
+	SET_LOWER_DENTRY(sb->s_root, lower_root, lower_mnt);
+
+	err = dazukofs_interpose(lower_root, sb->s_root, sb, 0);
+	if (err)
+		goto out_put;
+	goto out;
+
+out_put:
+	dput(lower_root);
+	mntput(lower_mnt);
+out:
+	path_put(&nd.path);
+	return err;
+}
+
+static int dazukofs_get_sb(struct file_system_type *fs_type, int flags,
+			   const char *dev_name, void *data,
+			   struct vfsmount *mnt)
+{
+	struct super_block *sb;
+	int err;
+
+	err = get_sb_nodev(fs_type, flags, data, dazukofs_fill_super, mnt);
+	if (err)
+		goto out;
+
+	sb = mnt->mnt_sb;
+
+	err = dazukofs_parse_mount_options(data, sb);
+	if (err)
+		goto out_abort;
+
+	err = dazukofs_read_super(sb, dev_name);
+	if (err)
+		goto out_abort;
+
+	goto out;
+
+out_abort:
+	up_write(&sb->s_umount);
+	deactivate_super(sb);
+out:
+	return err;
+}
+
+static void init_once(void *data)
+{
+	struct dazukofs_inode_info *inode_info =
+		(struct dazukofs_inode_info *)data;
+
+	memset(inode_info, 0, sizeof(struct dazukofs_inode_info));
+	inode_init_once(&(inode_info->vfs_inode));
+}
+
+static void destroy_caches(void)
+{
+	if (dazukofs_inode_info_cachep) {
+		kmem_cache_destroy(dazukofs_inode_info_cachep);
+		dazukofs_inode_info_cachep = NULL;
+	}
+
+	if (dazukofs_sb_info_cachep) {
+		kmem_cache_destroy(dazukofs_sb_info_cachep);
+		dazukofs_sb_info_cachep = NULL;
+	}
+
+	if (dazukofs_dentry_info_cachep) {
+		kmem_cache_destroy(dazukofs_dentry_info_cachep);
+		dazukofs_dentry_info_cachep = NULL;
+	}
+
+	if (dazukofs_file_info_cachep) {
+		kmem_cache_destroy(dazukofs_file_info_cachep);
+		dazukofs_file_info_cachep = NULL;
+	}
+}
+
+static int init_caches(void)
+{
+	dazukofs_inode_info_cachep =
+		kmem_cache_create("dazukofs_inode_info_cache",
+				  sizeof(struct dazukofs_inode_info), 0,
+				  SLAB_HWCACHE_ALIGN,
+				  init_once);
+	if (!dazukofs_inode_info_cachep)
+		goto out_nomem;
+
+	dazukofs_sb_info_cachep =
+		kmem_cache_create("dazukofs_sb_info_cache",
+				  sizeof(struct dazukofs_sb_info), 0,
+				  SLAB_HWCACHE_ALIGN,
+				  NULL);
+	if (!dazukofs_sb_info_cachep)
+		goto out_nomem;
+
+	dazukofs_dentry_info_cachep =
+		kmem_cache_create("dazukofs_dentry_info_cache",
+				  sizeof(struct dazukofs_dentry_info), 0,
+				  SLAB_HWCACHE_ALIGN,
+				  NULL);
+	if (!dazukofs_dentry_info_cachep)
+		goto out_nomem;
+
+	dazukofs_file_info_cachep =
+		kmem_cache_create("dazukofs_file_info_cache",
+				  sizeof(struct dazukofs_file_info), 0,
+				  SLAB_HWCACHE_ALIGN,
+				  NULL);
+	if (!dazukofs_file_info_cachep)
+		goto out_nomem;
+
+	return 0;
+
+out_nomem:
+	destroy_caches();
+	return -ENOMEM;
+}
+
+static struct file_system_type dazukofs_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "dazukofs",
+	.get_sb		= dazukofs_get_sb,
+	/*
+	 * XXX: We are using kill_anon_super() instead of my own function.
+	 *      Is this OK?
+	 */
+	.kill_sb	= kill_anon_super,
+	.fs_flags	= 0,
+};
+
+static int __init init_dazukofs_fs(void)
+{
+	int err = 0;
+
+	err = init_caches();
+	if (err)
+		goto error_out1;
+
+	err = register_filesystem(&dazukofs_fs_type);
+	if (err)
+		goto error_out2;
+
+	printk(KERN_INFO "dazukofs: loaded\n");
+	return 0;
+
+error_out2:
+	destroy_caches();
+error_out1:
+	return err;
+}
+
+static void __exit exit_dazukofs_fs(void)
+{
+	unregister_filesystem(&dazukofs_fs_type);
+	destroy_caches();
+	printk(KERN_INFO "dazukofs: unloaded\n");
+}
+
+MODULE_AUTHOR("John Ogness");
+MODULE_DESCRIPTION("pass-through stackable filesystem");
+MODULE_LICENSE("GPL");
+module_init(init_dazukofs_fs)
+module_exit(exit_dazukofs_fs)
Index: linux-2.6.27/fs/dazukofs/file.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.27/fs/dazukofs/file.c	2008-12-21 15:09:53.000000000 +0100
@@ -0,0 +1,340 @@
+/* dazukofs: access control stackable filesystem
+
+   Copyright (C) 1997-2004 Erez Zadok
+   Copyright (C) 2001-2004 Stony Brook University
+   Copyright (C) 2004-2007 International Business Machines Corp.
+   Copyright (C) 2008 John Ogness
+     Author: John Ogness <dazukocode@ogness.net>
+
+   This program is free software; you can redistribute it and/or
+   modify it under the terms of the GNU General Public License
+   as published by the Free Software Foundation; either version 2
+   of the License, or (at your option) any later version.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program; if not, write to the Free Software
+   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+*/
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/file.h>
+#include <linux/fs_stack.h>
+
+#include "dazukofs_fs.h"
+
+/**
+ * Description: Called when the VFS needs to move the file position index.
+ */
+static loff_t dazukofs_llseek(struct file *file, loff_t offset, int origin)
+{
+	loff_t retval = -EINVAL;
+	struct file *lower_file = GET_LOWER_FILE(file);
+
+	lower_file->f_pos = file->f_pos;
+
+	memcpy(&(lower_file->f_ra), &(file->f_ra),
+	       sizeof(struct file_ra_state));
+
+	if (lower_file->f_op && lower_file->f_op->llseek)
+		retval = lower_file->f_op->llseek(lower_file, offset, origin);
+	else
+		retval = generic_file_llseek(lower_file, offset, origin);
+
+	if (retval >= 0) {
+		file->f_pos = lower_file->f_pos;
+		file->f_version = lower_file->f_version;
+	}
+
+	return retval;
+}
+
+/**
+ * Description: Called by read(2) and related system calls.
+ */
+static ssize_t dazukofs_read(struct file *file, char *buf, size_t count,
+			   loff_t *ppos)
+{
+	int err = -EINVAL;
+	struct file *lower_file = GET_LOWER_FILE(file);
+	loff_t pos_copy = *ppos;
+
+	if (!lower_file->f_op || !lower_file->f_op->read)
+		goto out;
+
+	err = lower_file->f_op->read(lower_file, buf, count, &pos_copy);
+
+	lower_file->f_pos = pos_copy;
+	*ppos = pos_copy;
+
+	if (err >= 0) {
+		fsstack_copy_attr_atime(file->f_dentry->d_inode,
+					lower_file->f_dentry->d_inode);
+	}
+
+	memcpy(&(file->f_ra), &(lower_file->f_ra),
+	       sizeof(struct file_ra_state));
+out:
+	return err;
+}
+
+/**
+ * Description: Called by write(2) and related system calls.
+ */
+static ssize_t dazukofs_write(struct file *file, const char *buf,
+			      size_t count, loff_t *ppos)
+{
+	int err = -EINVAL;
+	struct file *lower_file = GET_LOWER_FILE(file);
+	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *lower_inode = GET_LOWER_INODE(inode);
+	loff_t pos_copy = *ppos;
+
+	if (!lower_file->f_op || !lower_file->f_op->write)
+		goto out;
+
+	err = lower_file->f_op->write(lower_file, buf, count, &pos_copy);
+
+	lower_file->f_pos = pos_copy;
+	*ppos = pos_copy;
+
+	if (err >= 0)
+		fsstack_copy_attr_atime(inode, lower_inode);
+
+	memcpy(&(file->f_ra), &(lower_file->f_ra),
+	       sizeof(struct file_ra_state));
+
+	mutex_lock(&inode->i_mutex);
+	i_size_write(inode, i_size_read(lower_inode));
+	mutex_unlock(&inode->i_mutex);
+out:
+	return err;
+}
+
+/**
+ * Description: Called when the VFS needs to read the directory contents.
+ */
+static int dazukofs_readdir(struct file *file, void *dirent, filldir_t filldir)
+{
+	int err;
+	struct file *lower_file = GET_LOWER_FILE(file);
+	struct inode *inode = file->f_dentry->d_inode;
+
+	lower_file->f_pos = file->f_pos;
+
+	err = vfs_readdir(lower_file, filldir, dirent);
+
+	file->f_pos = lower_file->f_pos;
+
+	if (err >= 0)
+		fsstack_copy_attr_atime(inode, lower_file->f_dentry->d_inode);
+
+	return err;
+}
+
+/**
+ * Description: Called by the ioctl(2) system call.
+ */
+static int dazukofs_ioctl(struct inode *inode, struct file *file,
+			  unsigned int cmd, unsigned long arg)
+{
+	struct file *lower_file = GET_LOWER_FILE(file);
+	struct inode *lower_inode = GET_LOWER_INODE(inode);
+	int err = -ENOTTY;
+
+	if (!lower_file || !lower_file->f_op || !lower_file->f_op->ioctl ||
+	    !lower_inode) {
+		goto out;
+	}
+
+	err = lower_file->f_op->ioctl(lower_inode, lower_file, cmd, arg);
+out:
+	return err;
+}
+
+/**
+ * Description: Called by the VFS when an inode should be opened. When the
+ * VFS opens a file, it creates a new "struct file". It then calls the open
+ * method for the newly allocated file structure. You might think that the
+ * open method really belongs in "struct inode_operations", and you may be
+ * right. I think it's done the way it is because it makes filesystems
+ * simpler to implement. The open() method is a good place to initialize
+ * the "private_data" member in the file structure if you want to point to
+ * a device structure.
+ */
+static int dazukofs_open(struct inode *inode, struct file *file)
+{
+	struct dentry *dentry = file->f_dentry;
+	struct dentry *lower_dentry = dget(GET_LOWER_DENTRY(dentry));
+	struct vfsmount *lower_mnt = mntget(GET_LOWER_MNT(dentry));
+	struct file *lower_file;
+	int err = 0;
+
+	SET_FILE_INFO(file, kmem_cache_zalloc(dazukofs_file_info_cachep,
+		      GFP_KERNEL));
+	if (!GET_FILE_INFO(file)) {
+		err = -ENOMEM;
+		goto error_out1;
+	}
+
+	lower_file = dentry_open(lower_dentry, lower_mnt, file->f_flags);
+	if (IS_ERR(lower_file)) {
+		err = PTR_ERR(lower_file);
+		/* dentry_open() already did dput() and mntput() */
+		goto error_out2;
+	}
+
+	SET_LOWER_FILE(file, lower_file);
+
+	return 0;
+
+error_out1:
+	dput(lower_dentry);
+	mntput(lower_mnt);
+error_out2:
+	return err;
+}
+
+/**
+ * Description: Called by the close(2) system call to flush a file.
+ */
+static int dazukofs_flush(struct file *file, fl_owner_t td)
+{
+	struct file *lower_file = GET_LOWER_FILE(file);
+	int err = 0;
+
+	if (!lower_file || !lower_file->f_op || !lower_file->f_op->flush)
+		goto out;
+
+	err = lower_file->f_op->flush(lower_file, td);
+out:
+	return err;
+}
+
+/**
+ * Description: Called when the last reference to an open file is closed.
+ */
+static int dazukofs_release(struct inode *inode, struct file *file)
+{
+	struct inode *lower_inode = GET_LOWER_INODE(inode);
+
+	fput(GET_LOWER_FILE(file));
+	inode->i_blocks = lower_inode->i_blocks;
+
+	kmem_cache_free(dazukofs_file_info_cachep, GET_FILE_INFO(file));
+
+	return 0;
+}
+
+/**
+ * Description: Called by the fsync(2) system call.
+ */
+static int dazukofs_fsync(struct file *file, struct dentry *dentry,
+			  int datasync)
+{
+	struct file *lower_file = GET_LOWER_FILE(file);
+	struct dentry *lower_dentry = GET_LOWER_DENTRY(dentry);
+	int err = -EINVAL;
+
+	if (!lower_file || !lower_file->f_op || !lower_file->f_op->fsync)
+		goto out;
+
+	err = lower_file->f_op->fsync(lower_file, lower_dentry, datasync);
+out:
+	return err;
+}
+
+/**
+ * Description: .called by the fcntl(2) system call when asynchronous
+ * (non-blocking) mode is enabled for a file.
+ */
+static int dazukofs_fasync(int fd, struct file *file, int flag)
+{
+	struct file *lower_file = GET_LOWER_FILE(file);
+	int err = 0;
+
+	if (!lower_file || !lower_file->f_op || !lower_file->f_op->fasync)
+		goto out;
+
+	err = lower_file->f_op->fasync(fd, lower_file, flag);
+out:
+	return err;
+}
+
+/**
+ * Unused operations:
+ *   - owner
+ *   - aio_read (generic)
+ *   - aio_write (generic)
+ *   - poll
+ *   - unlocked_ioctl
+ *   - compat_ioctl
+ *   - mmap (generic)
+ *   - aio_fsync
+ *   - lock
+ *   - sendpage
+ *   - get_unmapped_area
+ *   - check_flags
+ *   - dir_notify
+ *   - flock
+ *   - splice_write
+ *   - splice_read (generic)
+ *   - setlease
+ */
+struct file_operations dazukofs_main_fops = {
+	.llseek		= dazukofs_llseek,
+	.read		= dazukofs_read,
+	.aio_read	= generic_file_aio_read,
+	.write		= dazukofs_write,
+	.aio_write	= generic_file_aio_write,
+	.readdir	= dazukofs_readdir,
+	.ioctl		= dazukofs_ioctl,
+	.mmap		= generic_file_mmap,
+	.open		= dazukofs_open,
+	.flush		= dazukofs_flush,
+	.release	= dazukofs_release,
+	.fsync		= dazukofs_fsync,
+	.fasync		= dazukofs_fasync,
+	.splice_read	= generic_file_splice_read,
+};
+
+/**
+ * Unused operations:
+ *   - owner
+ *   - llseek
+ *   - read
+ *   - write
+ *   - aio_read
+ *   - aio_write
+ *   - poll
+ *   - unlocked_ioctl
+ *   - compat_ioctl
+ *   - mmap (generic)
+ *   - aio_fsync
+ *   - lock
+ *   - sendpage
+ *   - get_unmapped_area
+ *   - check_flags
+ *   - dir_notify
+ *   - flock
+ *   - splice_write
+ *   - splice_read (generic)
+ *   - setlease
+ */
+const struct file_operations dazukofs_dir_fops = {
+	.readdir	= dazukofs_readdir,
+	.ioctl		= dazukofs_ioctl,
+	.mmap		= generic_file_mmap,
+	.open		= dazukofs_open,
+	.flush		= dazukofs_flush,
+	.release	= dazukofs_release,
+	.fsync		= dazukofs_fsync,
+	.fasync		= dazukofs_fasync,
+	.splice_read	= generic_file_splice_read,
+};
Index: linux-2.6.27/fs/dazukofs/inode.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.27/fs/dazukofs/inode.c	2008-12-21 15:09:53.000000000 +0100
@@ -0,0 +1,832 @@
+/* dazukofs: access control stackable filesystem
+
+   Copyright (C) 1997-2004 Erez Zadok
+   Copyright (C) 2001-2004 Stony Brook University
+   Copyright (C) 2004-2007 International Business Machines Corp.
+   Copyright (C) 2008 John Ogness
+     Author: John Ogness <dazukocode@ogness.net>
+
+   This program is free software; you can redistribute it and/or
+   modify it under the terms of the GNU General Public License
+   as published by the Free Software Foundation; either version 2
+   of the License, or (at your option) any later version.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program; if not, write to the Free Software
+   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+*/
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/mount.h>
+#include <linux/uaccess.h>
+#include <linux/fs_stack.h>
+
+#include "dazukofs_fs.h"
+
+static struct inode_operations dazukofs_symlink_iops;
+static struct inode_operations dazukofs_dir_iops;
+static struct inode_operations dazukofs_main_iops;
+
+static int dazukofs_inode_test(struct inode *inode,
+			       void *candidate_lower_inode)
+{
+	if (GET_LOWER_INODE(inode) ==
+	    (struct inode *)candidate_lower_inode) {
+		return 1;
+	}
+
+	return 0;
+}
+
+static void dazukofs_init_inode(struct inode *inode, struct inode *lower_inode)
+{
+	SET_LOWER_INODE(inode, lower_inode);
+	inode->i_ino = lower_inode->i_ino;
+	inode->i_version++;
+	inode->i_op = &dazukofs_main_iops;
+	inode->i_fop = &dazukofs_main_fops;
+	inode->i_mapping->a_ops = &dazukofs_aops;
+}
+
+static int dazukofs_inode_set(struct inode *inode, void *lower_inode)
+{
+	dazukofs_init_inode(inode, (struct inode *)lower_inode);
+	return 0;
+}
+
+/**
+ * dazukofs_interpose - fill in new dentry, linking it to the lower dentry
+ * @lower_dentry: the corresponding lower dentry
+ * @denty: the new DazukoFS dentry
+ * @sb: super block of DazukoFS
+ * @already_hashed: flag to signify if "dentry" is already hashed
+ *
+ * Description: This is the key function which sets up all the hooks to
+ *              give DazukoFS control.
+ *
+ * Returns 0 on success.
+ */
+int dazukofs_interpose(struct dentry *lower_dentry, struct dentry *dentry,
+		       struct super_block *sb, int already_hashed)
+{
+	struct inode *inode;
+	struct inode *lower_inode = igrab(lower_dentry->d_inode);
+	int err = 0;
+
+	if (!lower_inode) {
+		err = -ESTALE;
+		goto out;
+	}
+
+	if (lower_inode->i_sb != GET_LOWER_SB(sb)) {
+		iput(lower_inode);
+		err = -EXDEV;
+		goto out;
+	}
+
+	inode = iget5_locked(sb, (unsigned long)lower_inode,
+			     dazukofs_inode_test, dazukofs_inode_set,
+			     lower_inode);
+
+	if (!inode) {
+		iput(lower_inode);
+		err = -EACCES;
+		goto out;
+	}
+
+	if (inode->i_state & I_NEW) {
+		unlock_new_inode(inode);
+		/*
+		 * This is a new node so we leave the lower_node "in use"
+		 * and do not call iput().
+		 */
+	} else {
+		/*
+		 * This is not a new node so we decrement the usage count.
+		 */
+		iput(lower_inode);
+	}
+
+	if (S_ISLNK(lower_inode->i_mode))
+		inode->i_op = &dazukofs_symlink_iops;
+	else if (S_ISDIR(lower_inode->i_mode))
+		inode->i_op = &dazukofs_dir_iops;
+
+	if (S_ISDIR(lower_inode->i_mode))
+		inode->i_fop = &dazukofs_dir_fops;
+
+	if (special_file(lower_inode->i_mode)) {
+		init_special_inode(inode, lower_inode->i_mode,
+				   lower_inode->i_rdev);
+	}
+
+	dentry->d_op = &dazukofs_dops;
+
+	if (already_hashed)
+		d_add(dentry, inode);
+	else
+		d_instantiate(dentry, inode);
+
+	fsstack_copy_attr_all(inode, lower_inode, NULL);
+	fsstack_copy_inode_size(inode, lower_inode);
+out:
+	return err;
+}
+
+/**
+ * Description: Called when the VFS needs to look up an inode in a parent
+ * directory. The name to look for is found in the dentry. This method
+ * must call d_add() to insert the found inode into the dentry. The
+ * "i_count" field in the inode structure should be incremented. If the
+ * named inode does not exist a NULL inode should be inserted into the
+ * dentry (this is called a negative dentry). Returning an error code
+ * from this routine must only be done on a real error, otherwise
+ * creating inodes with system calls like create(2), mknod(2), mkdir(2)
+ * and so on will fail. If you wish to overload the dentry methods then
+ * you should initialise the "d_dop" field in the dentry; this is a
+ * pointer to a struct "dentry_operations". This method is called with
+ * the directory inode semaphore held.
+ */
+static struct dentry *dazukofs_lookup(struct inode *dir, struct dentry *dentry,
+				      struct nameidata *nd)
+{
+	struct dentry *lower_dentry;
+	struct dentry *lower_dentry_parent;
+	struct vfsmount *lower_mnt;
+	int err = 0;
+
+	if ((dentry->d_name.len == 1 && !strcmp(dentry->d_name.name, "."))
+	    || (dentry->d_name.len == 2 &&
+		!strcmp(dentry->d_name.name, ".."))) {
+		d_drop(dentry);
+		goto out;
+	}
+
+	dentry->d_op = &dazukofs_dops;
+
+	lower_dentry_parent = GET_LOWER_DENTRY(dentry->d_parent);
+	lower_dentry = lookup_one_len(dentry->d_name.name, lower_dentry_parent,
+				      dentry->d_name.len);
+
+	if (IS_ERR(lower_dentry)) {
+		err = PTR_ERR(lower_dentry);
+		d_drop(dentry);
+		goto out;
+	}
+
+	BUG_ON(!atomic_read(&lower_dentry->d_count));
+
+	SET_DENTRY_INFO(dentry, kmem_cache_zalloc(dazukofs_dentry_info_cachep,
+			GFP_KERNEL));
+
+	if (!GET_DENTRY_INFO(dentry)) {
+		err = -ENOMEM;
+		goto out_dput;
+	}
+
+	lower_mnt = mntget(GET_LOWER_MNT(dentry->d_parent));
+
+	fsstack_copy_attr_atime(dir, lower_dentry_parent->d_inode);
+
+	SET_LOWER_DENTRY(dentry, lower_dentry, lower_mnt);
+
+	if (!lower_dentry->d_inode) {
+		/*
+		 * We want to add because we could not find in lower.
+		 */
+		d_add(dentry, NULL);
+		goto out;
+	}
+
+	err = dazukofs_interpose(lower_dentry, dentry, dir->i_sb, 1);
+	if (err)
+		goto out_dput;
+	goto out;
+
+out_dput:
+	dput(lower_dentry);
+	d_drop(dentry);
+
+out:
+	return ERR_PTR(err);
+}
+
+/**
+ * Description: Called by the mknod(2) system call to create a device
+ * (char, block) inode or a named pipe (FIFO) or socket. Only required if
+ * you want to support creating these types of inodes. You will probably
+ * need to call d_instantiate() just as you would in the create() method.
+ */
+static int dazukofs_mknod(struct inode *dir, struct dentry *dentry, int mode,
+			  dev_t dev)
+{
+	struct dentry *lower_dentry = GET_LOWER_DENTRY(dentry);
+	struct dentry *lower_dentry_parent = dget(lower_dentry->d_parent);
+	struct inode *lower_dentry_parent_inode = lower_dentry_parent->d_inode;
+	int err = -ENOENT;
+
+	mutex_lock_nested(&(lower_dentry_parent_inode->i_mutex),
+			  I_MUTEX_PARENT);
+
+	err = vfs_mknod(lower_dentry_parent_inode, lower_dentry, mode, dev);
+	if (err)
+		goto out;
+
+	err = dazukofs_interpose(lower_dentry, dentry, dir->i_sb, 0);
+	if (err)
+		goto out;
+
+	fsstack_copy_attr_times(dir, lower_dentry_parent_inode);
+	fsstack_copy_inode_size(dir, lower_dentry_parent_inode);
+out:
+	mutex_unlock(&(lower_dentry_parent_inode->i_mutex));
+	dput(lower_dentry_parent);
+
+	return err;
+}
+
+/**
+ * Description: Called by the mkdir(2) system call. Only required if you
+ * want to support creating subdirectories. You will probably need to call
+ * d_instantiate() just as you would in the create() method.
+ */
+static int dazukofs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	struct dentry *lower_dentry = GET_LOWER_DENTRY(dentry);
+	struct dentry *lower_dentry_parent = dget(lower_dentry->d_parent);
+	struct inode *lower_dentry_parent_inode = lower_dentry_parent->d_inode;
+	int err = -ENOENT;
+
+	mutex_lock_nested(&(lower_dentry_parent_inode->i_mutex),
+			  I_MUTEX_PARENT);
+
+	err = vfs_mkdir(lower_dentry_parent_inode, lower_dentry, mode);
+	if (err)
+		goto out;
+
+	err = dazukofs_interpose(lower_dentry, dentry, dir->i_sb, 0);
+	if (err)
+		goto out;
+
+	fsstack_copy_attr_times(dir, lower_dentry_parent_inode);
+	fsstack_copy_inode_size(dir, lower_dentry_parent_inode);
+	dir->i_nlink = lower_dentry_parent_inode->i_nlink;
+out:
+	mutex_unlock(&(lower_dentry_parent_inode->i_mutex));
+	dput(lower_dentry_parent);
+
+	return err;
+}
+
+/**
+ * Description: Called by the open(2) and creat(2) system calls. Only
+ * required if you want to support regular files. The dentry you get
+ * should not have an inode (i.e. it should be a negative dentry). Here
+ * you will probably call d_instantiate() with the dentry and the newly
+ * created inode.
+ */
+static int dazukofs_create(struct inode *dir, struct dentry *dentry, int mode,
+			   struct nameidata *nd)
+{
+	struct vfsmount *lower_mnt = GET_LOWER_MNT(dentry);
+	struct dentry *lower_dentry = GET_LOWER_DENTRY(dentry);
+	struct dentry *lower_dentry_parent = dget(lower_dentry->d_parent);
+	struct inode *lower_dentry_parent_inode = lower_dentry_parent->d_inode;
+	struct vfsmount *vfsmount_save;
+	struct dentry *dentry_save;
+	int err = -ENOENT;
+
+	mutex_lock_nested(&(lower_dentry_parent_inode->i_mutex),
+			  I_MUTEX_PARENT);
+
+	vfsmount_save = nd->path.mnt;
+	dentry_save = nd->path.dentry;
+
+	nd->path.mnt = mntget(lower_mnt);
+	nd->path.dentry = dget(lower_dentry);
+
+	err = vfs_create(lower_dentry_parent_inode, lower_dentry, mode, nd);
+
+	mntput(lower_mnt);
+	dput(lower_dentry);
+
+	nd->path.mnt = vfsmount_save;
+	nd->path.dentry = dentry_save;
+
+	if (err)
+		goto out;
+
+	err = dazukofs_interpose(lower_dentry, dentry, dir->i_sb, 0);
+	if (err)
+		goto out;
+
+	fsstack_copy_attr_times(dir, lower_dentry_parent_inode);
+	fsstack_copy_inode_size(dir, lower_dentry_parent_inode);
+out:
+	mutex_unlock(&(lower_dentry_parent_inode->i_mutex));
+	dput(lower_dentry_parent);
+
+	return err;
+}
+
+/**
+ * Description: Called by the symlink(2) system call. Only required if you
+ * want to support symlinks. You will probably need to call d_instantiate()
+ * just as you would in the create() method.
+ */
+static int dazukofs_symlink(struct inode *dir, struct dentry *dentry,
+			    const char *symname)
+{
+	struct dentry *lower_dentry = GET_LOWER_DENTRY(dentry);
+	struct dentry *lower_dentry_parent = dget(lower_dentry->d_parent);
+	struct inode *lower_dentry_parent_inode = lower_dentry_parent->d_inode;
+	int err = -ENOENT;
+
+	mutex_lock_nested(&(lower_dentry_parent_inode->i_mutex),
+			  I_MUTEX_PARENT);
+
+	err = vfs_symlink(lower_dentry_parent_inode, lower_dentry, symname);
+	if (err)
+		goto out;
+
+	err = dazukofs_interpose(lower_dentry, dentry, dir->i_sb, 0);
+	if (err)
+		goto out;
+
+	fsstack_copy_attr_times(dir, lower_dentry_parent_inode);
+	fsstack_copy_inode_size(dir, lower_dentry_parent_inode);
+out:
+	mutex_unlock(&(lower_dentry_parent_inode->i_mutex));
+	dput(lower_dentry_parent);
+
+	return err;
+}
+
+/**
+ * Description: Called by the readlink(2) system call. Only required if
+ * you want to support reading symbolic links.
+ */
+static int dazukofs_readlink(struct dentry *dentry, char __user *buf,
+			     int bufsiz)
+{
+	struct dentry *lower_dentry = GET_LOWER_DENTRY(dentry);
+	struct inode *lower_dentry_inode = lower_dentry->d_inode;
+	int err = 0;
+
+	if (!lower_dentry_inode) {
+		err = -ENOENT;
+		d_drop(dentry);
+		goto out;
+	}
+
+	if (!lower_dentry_inode->i_op ||
+	    !lower_dentry_inode->i_op->readlink) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	err = lower_dentry_inode->i_op->readlink(lower_dentry, buf, bufsiz);
+	if (err)
+		goto out;
+
+	fsstack_copy_attr_times(dentry->d_inode, lower_dentry_inode);
+out:
+	return err;
+}
+
+/**
+ * Description: Called by the VFS to follow a symbolic link to the inode
+ * it points to. Only required if you want to support symbolic links. This
+ * method returns a void pointer cookie that is passed to put_link().
+ */
+static void *dazukofs_follow_link(struct dentry *dentry, struct nameidata *nd)
+{
+	mm_segment_t fs_save;
+	int rc;
+	char *buf;
+	int len = PAGE_SIZE;
+	int err = 0;
+
+	/*
+	 * Released in dazukofs_put_link(). Only release here on error.
+	 */
+	buf = kmalloc(len, GFP_KERNEL);
+	if (!buf) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	fs_save = get_fs();
+	set_fs(get_ds());
+	rc = dazukofs_readlink(dentry, (char __user *)buf, len);
+	set_fs(fs_save);
+
+	if (rc < 0) {
+		err = rc;
+		goto out_free;
+	}
+	buf[rc] = 0;
+
+	nd_set_link(nd, buf);
+	goto out;
+
+out_free:
+	kfree(buf);
+out:
+	return ERR_PTR(err);
+}
+
+/**
+ * Description: Called by the VFS to release resources allocated by
+ * follow_link(). The cookie returned by follow_link() is passed to this
+ * method as the last parameter. It is used by filesystems such as NFS
+ * where page cache is not stable (i.e. page that was installed when the
+ * symbolic link walk started might not be in the page cache at the end
+ * of the walk).
+ */
+static void dazukofs_put_link(struct dentry *dentry, struct nameidata *nd,
+			      void *ptr)
+{
+	/*
+	 * Release the char* from dazukofs_follow_link().
+	 */
+	kfree(nd_get_link(nd));
+}
+
+/**
+ * Description: Called by the VFS to check for access rights on a
+ * POSIX-like filesystem.
+ */
+static int dazukofs_permission(struct inode *inode, int mask)
+{
+	return inode_permission(GET_LOWER_INODE(inode), mask);
+}
+
+/**
+ * Description: Called by the VFS to set attributes for a file. This method
+ * is called by chmod(2) and related system calls.
+ */
+static int dazukofs_setattr(struct dentry *dentry, struct iattr *ia)
+{
+	struct dentry *lower_dentry = GET_LOWER_DENTRY(dentry);
+	struct inode *inode = dentry->d_inode;
+	struct inode *lower_inode = GET_LOWER_INODE(inode);
+	int err;
+
+	err = notify_change(lower_dentry, ia);
+
+	fsstack_copy_attr_all(inode, lower_inode, NULL);
+	fsstack_copy_inode_size(inode, lower_inode);
+
+	return err;
+}
+
+/**
+ * Description: Called by the VFS to set an extended attribute for a file.
+ * Extended attribute is a name:value pair associated with an inode. This
+ * method is called by setxattr(2) system call.
+ */
+static int dazukofs_setxattr(struct dentry *dentry, const char *name,
+			     const void *value, size_t size, int flags)
+{
+	struct dentry *lower_dentry = GET_LOWER_DENTRY(dentry);
+	struct inode *lower_dentry_inode = lower_dentry->d_inode;
+	int err = 0;
+
+	if (!lower_dentry_inode) {
+		err = -ENOENT;
+		d_drop(dentry);
+		goto out;
+	}
+
+	if (!lower_dentry_inode->i_op ||
+	    !lower_dentry_inode->i_op->setxattr) {
+		err = -ENOSYS;
+		goto out;
+	}
+
+	err = lower_dentry_inode->i_op->setxattr(lower_dentry, name, value,
+						 size, flags);
+
+	fsstack_copy_attr_all(dentry->d_inode, lower_dentry_inode, NULL);
+	fsstack_copy_inode_size(dentry->d_inode, lower_dentry_inode);
+out:
+	return err;
+}
+
+/**
+ * Description: Called by the VFS to retrieve the value of an extended
+ * attribute name. This method is called by getxattr(2) function call.
+ */
+static ssize_t dazukofs_getxattr(struct dentry *dentry, const char *name,
+				 void *value, size_t size)
+{
+	struct dentry *lower_dentry = GET_LOWER_DENTRY(dentry);
+	struct inode *lower_dentry_inode = lower_dentry->d_inode;
+	ssize_t err = 0;
+
+	if (!lower_dentry_inode) {
+		err = -ENOENT;
+		d_drop(dentry);
+		goto out;
+	}
+
+	if (!lower_dentry_inode->i_op ||
+	    !lower_dentry_inode->i_op->getxattr) {
+		err = -ENOSYS;
+		goto out;
+	}
+
+	err = lower_dentry_inode->i_op->getxattr(lower_dentry, name,
+						 value, size);
+out:
+	return err;
+}
+
+/**
+ * Description: Called by the VFS to list all extended attributes for a
+ * given file. This method is called by listxattr(2) system call.
+ */
+static ssize_t dazukofs_listxattr(struct dentry *dentry, char *list,
+				  size_t size)
+{
+	struct dentry *lower_dentry = GET_LOWER_DENTRY(dentry);
+	struct inode *lower_dentry_inode = lower_dentry->d_inode;
+	int err = 0;
+
+	if (!lower_dentry_inode) {
+		err = -ENOENT;
+		d_drop(dentry);
+		goto out;
+	}
+
+	if (!lower_dentry_inode->i_op ||
+	    !lower_dentry_inode->i_op->listxattr) {
+		err = -ENOSYS;
+		goto out;
+	}
+
+	err = lower_dentry_inode->i_op->listxattr(lower_dentry, list, size);
+out:
+	return err;
+}
+
+/**
+ * Description: Called by the VFS to remove an extended attribute from a
+ * file. This method is called by removexattr(2) system call.
+ */
+static int dazukofs_removexattr(struct dentry *dentry, const char *name)
+{
+	struct dentry *lower_dentry = GET_LOWER_DENTRY(dentry);
+	struct inode *lower_dentry_inode = lower_dentry->d_inode;
+	int err = 0;
+
+	if (!lower_dentry_inode) {
+		err = -ENOENT;
+		d_drop(dentry);
+		goto out;
+	}
+
+	if (!lower_dentry_inode->i_op ||
+	    !lower_dentry_inode->i_op->removexattr) {
+		err = -ENOSYS;
+		goto out;
+	}
+
+	err = lower_dentry_inode->i_op->removexattr(lower_dentry, name);
+out:
+	return err;
+}
+
+/**
+ * Description: Called by the link(2) system call. Only required if you want
+ * to support hard links. You will probably need to call d_instantiate()
+ * just as you would in the create() method.
+ */
+static int dazukofs_link(struct dentry *old_dentry, struct inode *dir,
+			 struct dentry *new_dentry)
+{
+	struct dentry *lower_old_dentry = GET_LOWER_DENTRY(old_dentry);
+	struct dentry *lower_new_dentry = GET_LOWER_DENTRY(new_dentry);
+	struct dentry *lower_dentry_parent = dget(lower_new_dentry->d_parent);
+	struct inode *lower_dentry_parent_inode = lower_dentry_parent->d_inode;
+	int err = -ENOENT;
+
+	mutex_lock_nested(&(lower_dentry_parent_inode->i_mutex),
+			  I_MUTEX_PARENT);
+
+	err = vfs_link(lower_old_dentry, lower_dentry_parent_inode,
+		       lower_new_dentry);
+	if (err)
+		goto out;
+
+	err = dazukofs_interpose(lower_new_dentry, new_dentry, dir->i_sb, 0);
+	if (err)
+		goto out;
+
+	fsstack_copy_attr_times(dir, lower_dentry_parent_inode);
+	fsstack_copy_inode_size(dir, lower_dentry_parent_inode);
+out:
+	mutex_unlock(&(lower_dentry_parent_inode->i_mutex));
+	dput(lower_dentry_parent);
+
+	return err;
+}
+
+/**
+ * Description: Called by the unlink(2) system call. Only required if you
+ * want to support deleting inodes.
+ */
+static int dazukofs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct dentry *lower_dentry = GET_LOWER_DENTRY(dentry);
+	struct dentry *lower_dentry_parent = dget(lower_dentry->d_parent);
+	struct inode *lower_dentry_parent_inode = lower_dentry_parent->d_inode;
+	int err;
+
+	mutex_lock_nested(&(lower_dentry_parent_inode->i_mutex),
+			  I_MUTEX_PARENT);
+
+	err = vfs_unlink(lower_dentry_parent_inode, lower_dentry);
+	if (err)
+		goto out;
+
+	fsstack_copy_attr_times(dir, lower_dentry_parent_inode);
+	dentry->d_inode->i_nlink =
+		GET_LOWER_INODE(dentry->d_inode)->i_nlink;
+	fsstack_copy_attr_times(dentry->d_inode, dir);
+out:
+	mutex_unlock(&(lower_dentry_parent_inode->i_mutex));
+	dput(lower_dentry_parent);
+
+	return err;
+}
+
+/**
+ * Description: Called by the rmdir(2) system call. Only required if you
+ * want to support deleting subdirectories.
+ */
+static int dazukofs_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	struct dentry *lower_dentry = GET_LOWER_DENTRY(dentry);
+	struct dentry *lower_dentry_parent = dget(lower_dentry->d_parent);
+	struct inode *lower_dentry_parent_inode = lower_dentry_parent->d_inode;
+	int err;
+
+	mutex_lock_nested(&(lower_dentry_parent_inode->i_mutex),
+			  I_MUTEX_PARENT);
+
+	err = vfs_rmdir(lower_dentry_parent_inode, lower_dentry);
+	if (err)
+		goto out;
+
+	fsstack_copy_attr_times(dir, lower_dentry_parent_inode);
+	dir->i_nlink = lower_dentry_parent_inode->i_nlink;
+out:
+	mutex_unlock(&(lower_dentry_parent_inode->i_mutex));
+	dput(lower_dentry_parent);
+
+	if (!err)
+		d_drop(dentry);
+
+	return err;
+}
+
+/**
+ * Description: Called by the rename(2) system call to rename the object to
+ * have the parent and name given by the second inode and dentry.
+ */
+static int dazukofs_rename(struct inode *old_dir, struct dentry *old_dentry,
+			   struct inode *new_dir, struct dentry *new_dentry)
+{
+	struct dentry *lower_old_dentry = GET_LOWER_DENTRY(old_dentry);
+	struct dentry *lower_new_dentry = GET_LOWER_DENTRY(new_dentry);
+	struct dentry *lower_old_dentry_parent =
+		dget(lower_old_dentry->d_parent);
+	struct dentry *lower_new_dentry_parent =
+		dget(lower_new_dentry->d_parent);
+	struct inode *lower_old_dentry_parent_inode =
+		lower_old_dentry_parent->d_inode;
+	struct inode *lower_new_dentry_parent_inode =
+		lower_new_dentry_parent->d_inode;
+	int err = -ENOENT;
+
+	if (!lower_old_dentry_parent_inode) {
+		d_drop(old_dentry);
+		goto out;
+	}
+
+	if (!lower_new_dentry_parent_inode) {
+		d_drop(new_dentry);
+		goto out;
+	}
+
+	lock_rename(lower_old_dentry_parent, lower_new_dentry_parent);
+	err = vfs_rename(lower_old_dentry_parent_inode, lower_old_dentry,
+			 lower_new_dentry_parent_inode, lower_new_dentry);
+	unlock_rename(lower_old_dentry_parent, lower_new_dentry_parent);
+
+	if (err)
+		goto out;
+
+	fsstack_copy_attr_all(new_dir, lower_new_dentry_parent_inode, NULL);
+	if (new_dir != old_dir)
+		fsstack_copy_attr_all(old_dir, lower_old_dentry_parent_inode,
+				      NULL);
+out:
+	dput(lower_old_dentry_parent);
+	dput(lower_new_dentry_parent);
+
+	return err;
+}
+
+/**
+ * Unused operations:
+ *   - create
+ *   - lookup
+ *   - link
+ *   - unlink
+ *   - symlink
+ *   - mkdir
+ *   - rmdir
+ *   - mknod
+ *   - rename
+ *   - truncate
+ *   - getattr
+ *   - truncate_range
+ *   - fallocate
+ */
+static struct inode_operations dazukofs_symlink_iops = {
+	.readlink	= dazukofs_readlink,
+	.follow_link	= dazukofs_follow_link,
+	.put_link	= dazukofs_put_link,
+	.permission	= dazukofs_permission,
+	.setattr	= dazukofs_setattr,
+	.setxattr	= dazukofs_setxattr,
+	.getxattr	= dazukofs_getxattr,
+	.listxattr	= dazukofs_listxattr,
+	.removexattr	= dazukofs_removexattr,
+};
+
+/**
+ * Unused operations:
+ *   - readlink
+ *   - follow_link
+ *   - put_link
+ *   - truncate
+ *   - getattr
+ *   - truncate_range
+ *   - fallocate
+ */
+static struct inode_operations dazukofs_dir_iops = {
+	.create		= dazukofs_create,
+	.lookup		= dazukofs_lookup,
+	.link		= dazukofs_link,
+	.unlink		= dazukofs_unlink,
+	.symlink	= dazukofs_symlink,
+	.mkdir		= dazukofs_mkdir,
+	.rmdir		= dazukofs_rmdir,
+	.mknod		= dazukofs_mknod,
+	.rename		= dazukofs_rename,
+	.permission	= dazukofs_permission,
+	.setattr	= dazukofs_setattr,
+	.setxattr	= dazukofs_setxattr,
+	.getxattr	= dazukofs_getxattr,
+	.listxattr	= dazukofs_listxattr,
+	.removexattr	= dazukofs_removexattr,
+};
+
+/**
+ * Unused operations:
+ *   - create
+ *   - lookup
+ *   - link
+ *   - unlink
+ *   - symlink
+ *   - mkdir
+ *   - rmdir
+ *   - mknod
+ *   - rename
+ *   - readlink
+ *   - follow_link
+ *   - put_link
+ *   - truncate
+ *   - getattr
+ *   - truncate_range
+ *   - fallocate
+ */
+static struct inode_operations dazukofs_main_iops = {
+	.permission	= dazukofs_permission,
+	.setattr	= dazukofs_setattr,
+	.setxattr	= dazukofs_setxattr,
+	.getxattr	= dazukofs_getxattr,
+	.listxattr	= dazukofs_listxattr,
+	.removexattr	= dazukofs_removexattr,
+};
Index: linux-2.6.27/fs/dazukofs/mmap.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.27/fs/dazukofs/mmap.c	2008-12-21 15:09:53.000000000 +0100
@@ -0,0 +1,117 @@
+/* dazukofs: access control stackable filesystem
+
+   Copyright (C) 1997-2003 Erez Zadok
+   Copyright (C) 2001-2003 Stony Brook University
+   Copyright (C) 2004-2007 International Business Machines Corp.
+   Copyright (C) 2008 John Ogness
+     Author: John Ogness <dazukocode@ogness.net>
+
+   This program is free software; you can redistribute it and/or
+   modify it under the terms of the GNU General Public License
+   as published by the Free Software Foundation; either version 2
+   of the License, or (at your option) any later version.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program; if not, write to the Free Software
+   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+*/
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/pagemap.h>
+
+#include "dazukofs_fs.h"
+
+/**
+ * Description: Called by the VM to read a page from backing store. The page
+ * will be Locked when readpage is called, and should be unlocked and marked
+ * uptodate once the read completes. If ->readpage discovers that it needs
+ * to unlock the page for some reason, it can do so, and then return
+ * AOP_TRUNCATED_PAGE. In this case, the page will be relocated, relocked
+ * and if that all succeeds, ->readpage will be called again.
+ */
+static int dazukofs_readpage(struct file *file, struct page *page)
+{
+	struct dentry *dentry = file->f_dentry;
+	struct file *lower_file = GET_LOWER_FILE(file);
+	struct inode *inode = dentry->d_inode;
+	struct inode *lower_inode = GET_LOWER_INODE(inode);
+	const struct address_space_operations *lower_a_ops =
+		lower_inode->i_mapping->a_ops;
+	char *page_data;
+	struct page *lower_page;
+	char *lower_page_data;
+	int err = 0;
+
+	lower_page = read_cache_page(lower_inode->i_mapping, page->index,
+				     (filler_t *)lower_a_ops->readpage,
+				     (void *)lower_file);
+
+	if (IS_ERR(lower_page)) {
+		err = PTR_ERR(lower_page);
+		lower_page = NULL;
+		printk(KERN_ERR "dazukofs: Error reading from page cache.\n");
+		goto out;
+	}
+
+	wait_on_page_locked(lower_page);
+
+	page_data = (char *)kmap(page);
+	if (!page_data) {
+		err = -ENOMEM;
+		printk(KERN_ERR "dazukofs: Error mapping page.\n");
+		goto out;
+	}
+
+	lower_page_data = (char *)kmap(lower_page);
+	if (!lower_page_data) {
+		err = -ENOMEM;
+		printk(KERN_ERR "dazukofs: Error mapping lower page.\n");
+		goto out;
+	}
+
+	memcpy(page_data, lower_page_data, PAGE_CACHE_SIZE);
+
+	kunmap(lower_page);
+	kunmap(page);
+out:
+	if (lower_page)
+		page_cache_release(lower_page);
+
+	if (err)
+		ClearPageUptodate(page);
+	else
+		SetPageUptodate(page);
+
+	unlock_page(page);
+
+	return err;
+}
+
+/**
+ * Unused operations:
+ *   - writepage
+ *   - sync_page
+ *   - writepages
+ *   - set_page_dirty
+ *   - readpages
+ *   - prepare_write
+ *   - commit_write
+ *   - write_begin
+ *   - write_end
+ *   - bmap
+ *   - invalidatepage
+ *   - releasepage
+ *   - direct_IO
+ *   - get_xip_page
+ *   - migratepage
+ *   - launder_page
+ */
+struct address_space_operations dazukofs_aops = {
+	.readpage	= dazukofs_readpage,
+};
Index: linux-2.6.27/fs/dazukofs/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.27/fs/dazukofs/Makefile	2008-12-21 15:09:53.000000000 +0100
@@ -0,0 +1,7 @@
+#
+# Makefile for the Linux dazukofs-filesystem routines.
+#
+
+obj-$(CONFIG_DAZUKOFS_FS) += dazukofs.o
+
+dazukofs-objs := super.o inode.o file.o dentry.o mmap.o
Index: linux-2.6.27/fs/Kconfig
===================================================================
--- linux-2.6.27.orig/fs/Kconfig	2008-12-21 15:09:19.000000000 +0100
+++ linux-2.6.27/fs/Kconfig	2008-12-21 15:09:53.000000000 +0100
@@ -816,6 +816,17 @@
 	  To compile this file system support as a module, choose M here: the
 	  module will be called ecryptfs.
 
+config DAZUKOFS_FS
+	tristate "DazukoFS filesystem layer support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	help
+	  A pass-through stackable filesystem (also referred to as nullfs).
+	  See <file:Documentation/filesystems/dazukofs.txt> to learn more
+	  about DazukoFS.
+
+	  To compile this file system support as a module, choose M here: the
+	  module will be called dazukofs.
+
 config HFS_FS
 	tristate "Apple Macintosh file system support (EXPERIMENTAL)"
 	depends on BLOCK && EXPERIMENTAL
Index: linux-2.6.27/fs/Makefile
===================================================================
--- linux-2.6.27.orig/fs/Makefile	2008-12-21 15:09:19.000000000 +0100
+++ linux-2.6.27/fs/Makefile	2008-12-21 15:09:53.000000000 +0100
@@ -86,6 +86,7 @@
 obj-$(CONFIG_HFSPLUS_FS)	+= hfsplus/ # Before hfs to find wrapped HFS+
 obj-$(CONFIG_HFS_FS)		+= hfs/
 obj-$(CONFIG_ECRYPT_FS)		+= ecryptfs/
+obj-$(CONFIG_DAZUKOFS_FS)	+= dazukofs/
 obj-$(CONFIG_VXFS_FS)		+= freevxfs/
 obj-$(CONFIG_NFS_FS)		+= nfs/
 obj-$(CONFIG_EXPORTFS)		+= exportfs/
Index: linux-2.6.27/Documentation/filesystems/dazukofs.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.27/Documentation/filesystems/dazukofs.txt	2008-12-21 15:09:53.000000000 +0100
@@ -0,0 +1,81 @@
+================
+ ABOUT DAZUKOFS
+================
+
+DazukoFS is a pass-through stackable filesystem. A filesystem that does
+not perform any special modification but simply passes VFS calls to and
+from the lower filesystem is typically known as nullfs.
+
+
+
+=====================
+ MOUNTING/UNMOUNTING
+=====================
+
+DazukoFS is typically mounted on top of an existing directory. For example,
+to stack DazukoFS on top of the /opt directory, the following mount(8)
+command can be given:
+
+# mount -t dazukofs /opt /opt
+
+A process that accesses files in /opt will now be accessing them through
+DazukoFS. The stackable filesystem can then be unmounted with:
+
+# umount /opt
+
+
+
+===============
+ MOUNT ON BOOT
+===============
+
+You may want DazukoFS to be mounted over certain directories when the
+machine boots. The easiest way to do this is to add the mounts to
+the end of /etc/fstab. They would look something like this:
+
+/usr   /usr   dazukofs   defaults   0   0
+/opt   /opt   dazukofs   defaults   0   0
+
+
+
+=========
+ WARNING
+=========
+
+It is possible to mount DazukoFS to a directory other than the directory
+that is being stacked upon. For example:
+
+# mount -t dazukofs /opt /mnt
+
+When accessing files within /mnt, you will be accessing files in /opt
+(through DazukoFS). When accessing files directly in /opt, DazukoFS will not
+be involved.
+
+THIS HAS POTENTIAL PROBLEMS!
+
+If files are modified directly in /opt, the DazukoFS layer will not know
+about it. When DazukoFS later tries to access those files, it may result
+in corrupt data or kernel crashes. As long as /opt is modified ONLY through
+DazukoFS, there should not be any problems.
+
+This method of mounting DazukoFS may be interesting for servers that export
+a part of the filesystem and the service is in a chroot environment.
+
+
+
+==============
+ KNOWN ISSUES
+==============
+
+- DazukoFS does not support writing to memory mapped files. This should not
+  cause the kernel to crash, but will instead result in the application
+  failing to perform the writes (although mmap() will appear to be
+  successful from the application's viewpoint!).
+
+- It is not possible to stack DazukoFS over the root filesystem (/).
+  Stacking over pseudo filesystems (/proc, /dev, /sys) has not been
+  tested and should be avoided.
+
+Please report problems to the dazuko-devel mailing list
+(subscription required):
+     http://lists.nongnu.org/mailman/listinfo/dazuko-devel

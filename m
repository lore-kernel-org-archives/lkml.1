Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbYEZMbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbYEZMbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 08:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756435AbYEZMY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 08:24:29 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49639 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243AbYEZMYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 08:24:09 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH take 3 23/29] UBIFS: add VFS operations
Date: Mon, 26 May 2008 17:05:37 +0300
Message-Id: <1211810743-18936-24-git-send-email-Artem.Bityutskiy@nokia.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1211810743-18936-1-git-send-email-Artem.Bityutskiy@nokia.com>
References: <1211810743-18936-1-git-send-email-Artem.Bityutskiy@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 26 May 2008 12:23:53.0791 (UTC) FILETIME=[5C9644F0:01C8BF2B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds implementation of most of the VFS callbacks like
->readdir(), ->write_begin(), and so on. In most cases, it just
does budgeting and calls corresponding journal function, because
all new data goes first to the journal.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/ubifs/dir.c   | 1016 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ubifs/file.c  |  960 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ubifs/ioctl.c |  212 ++++++++++++
 3 files changed, 2188 insertions(+), 0 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
new file mode 100644
index 0000000..f77dddb
--- /dev/null
+++ b/fs/ubifs/dir.c
@@ -0,0 +1,1016 @@
+/*
+ * This file is part of UBIFS.
+ *
+ * Copyright (C) 2006-2008 Nokia Corporation.
+ * Copyright (C) 2006, 2007 University of Szeged, Hungary
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ * Authors: Artem Bityutskiy (Битюцкий Артём)
+ *          Adrian Hunter
+ *          Zoltan Sogor
+ */
+
+/*
+ * This file implements directory operations.
+ *
+ * All FS operations in this file allocate budget before writing anything to the
+ * media. If they fail to allocate it, the error is returned. The only
+ * exceptions are 'ubifs_unlink()' and 'ubifs_rmdir()' which keep working even
+ * if they unable to allocate the budget, because deletion %-ENOSPC failure is
+ * not what users are usually ready to get. UBIFS budgeting subsystem has some
+ * space reserved for these purposes.
+ *
+ * All operations in this file change the parent inode, e.g., 'ubifs_link()'
+ * changes ctime and nlink of the parent inode. The parent inode is written to
+ * the media straight away - it is not marked as dirty and there is no
+ * write-back for it. This was done to simplify file-system recovery which
+ * would otherwise be very difficult to do. So instead of marking the parent
+ * inode dirty, the operations mark it clean.
+ */
+
+#include "ubifs.h"
+
+/*
+ * Provide backing_dev_info in order to disable readahead. For UBIFS, I/O is
+ * not deferred, it is done immediately in readpage, which means the user would
+ * have to wait not just for their own I/O but the readahead I/O as well i.e.
+ * completely pointless.
+ */
+struct backing_dev_info ubifs_backing_dev_info = {
+	.ra_pages	= 0, /* Set to zero to disable readahead */
+	.state		= 0,
+	.capabilities	= BDI_CAP_MAP_COPY,
+	.unplug_io_fn	= default_unplug_io_fn,
+};
+
+/**
+ * inherit_flags - inherit flags of the parent inode.
+ * @dir: parent inode
+ * @mode: new inode mode flags
+ *
+ * This is a helper function for 'ubifs_new_inode()' which inherits flag of the
+ * parent directory inode @dir. UBIFS inodes inherit the following flags:
+ * o %UBIFS_COMPR_FL, which is useful to switch compression on/of on
+ *   sub-directory basis;
+ * o %UBIFS_SYNC_FL - useful for the same reasons;
+ * o %UBIFS_DIRSYNC_FL - similar, but relevant only to directories.
+ *
+ * This function returns the inherited flags.
+ */
+static int inherit_flags(const struct inode *dir, int mode)
+{
+	int flags;
+	const struct ubifs_inode *ui = ubifs_inode(dir);
+
+	if (!S_ISDIR(dir->i_mode))
+		/*
+		 * The parent is not a directory, which means that an extended
+		 * attribute inode is being created. No flags.
+		 */
+		return 0;
+
+	flags = ui->flags & (UBIFS_COMPR_FL | UBIFS_SYNC_FL | UBIFS_DIRSYNC_FL);
+	if (!S_ISDIR(mode))
+		/* The "DIRSYNC" flag only applies to directories */
+		flags &= ~UBIFS_DIRSYNC_FL;
+
+	return flags;
+}
+
+/**
+ * ubifs_new_inode - allocate new UBIFS inode object.
+ * @c: UBIFS file-system description object
+ * @dir: parent directory inode
+ * @mode: inode mode flags
+ *
+ * This function finds an unused inode number, allocates new inode and
+ * initializes it. Returns new inode in case of success and an error code in
+ * case of failure.
+ */
+struct inode *ubifs_new_inode(struct ubifs_info *c, const struct inode *dir,
+			      int mode)
+{
+	struct inode *inode;
+	struct ubifs_inode *ui;
+
+	inode = new_inode(c->vfs_sb);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	/*
+	 * Set 'S_NOCMTIME' to prevent VFS form updating [mc]time of inodes and
+	 * marking them dirty in file write path (see 'file_update_time()').
+	 * UBIFS has to fully control "clean <-> dirty" transitions of inodes
+	 * to make budgeting work.
+	 */
+	inode->i_flags |= (S_NOCMTIME);
+
+	inode->i_uid = current->fsuid;
+	if (dir->i_mode & S_ISGID) {
+		inode->i_gid = dir->i_gid;
+		if (S_ISDIR(mode))
+			mode |= S_ISGID;
+	} else
+		inode->i_gid = current->fsgid;
+	inode->i_mode = mode;
+	inode->i_mtime = inode->i_atime = inode->i_ctime =
+			 ubifs_current_time(inode);
+	inode->i_mapping->nrpages = 0;
+	/* Disable readahead */
+	inode->i_mapping->backing_dev_info = &ubifs_backing_dev_info;
+
+	switch (mode & S_IFMT) {
+	case S_IFREG:
+		inode->i_mapping->a_ops = &ubifs_file_address_operations;
+		inode->i_op = &ubifs_file_inode_operations;
+		inode->i_fop = &ubifs_file_operations;
+		break;
+	case S_IFDIR:
+		inode->i_op  = &ubifs_dir_inode_operations;
+		inode->i_fop = &ubifs_dir_operations;
+		inode->i_size = UBIFS_INO_NODE_SZ;
+		break;
+	case S_IFLNK:
+		inode->i_op = &ubifs_symlink_inode_operations;
+		break;
+	case S_IFSOCK:
+	case S_IFIFO:
+	case S_IFBLK:
+	case S_IFCHR:
+		inode->i_op  = &ubifs_file_inode_operations;
+		break;
+	default:
+		BUG();
+	}
+
+	ui = ubifs_inode(inode);
+	ui->flags = inherit_flags(dir, mode);
+	ubifs_set_inode_flags(inode);
+
+	if (S_ISREG(mode))
+		ui->compr_type = c->default_compr;
+	else
+		ui->compr_type = UBIFS_COMPR_NONE;
+
+	spin_lock(&c->cnt_lock);
+	/* Inode number overflow is currently not supported */
+	if (c->highest_inum >= INUM_WARN_WATERMARK) {
+		if (c->highest_inum >= INUM_WATERMARK) {
+			spin_unlock(&c->cnt_lock);
+			ubifs_err("out of inode numbers");
+			make_bad_inode(inode);
+			iput(inode);
+			return ERR_PTR(-EINVAL);
+		}
+		ubifs_warn("running out of inode numbers (current %lu, max %d)",
+			   c->highest_inum, INUM_WATERMARK);
+	}
+
+	inode->i_ino = ++c->highest_inum;
+	inode->i_generation = ++c->vfs_gen;
+	/*
+	 * The creation sequence number remains with this inode for its
+	 * lifetime. All nodes for this inode have a greater sequence number,
+	 * and so it is possible to distinguish obsolete nodes belonging to a
+	 * previous incarnation of the same inode number - for example, for the
+	 * purpose of rebuilding the index.
+	 */
+	ui->creat_sqnum = ++c->max_sqnum;
+	spin_unlock(&c->cnt_lock);
+
+	return inode;
+}
+
+#ifdef CONFIG_UBIFS_FS_DEBUG
+
+static int dbg_check_name(struct ubifs_dent_node *dent, struct qstr *nm)
+{
+	if (!(ubifs_chk_flags & UBIFS_CHK_GEN))
+		return 0;
+	if (le16_to_cpu(dent->nlen) != nm->len)
+		return -EINVAL;
+	if (memcmp(dent->name, nm->name, nm->len))
+		return -EINVAL;
+	return 0;
+}
+
+#else
+
+#define dbg_check_name(dent, nm) 0
+
+#endif
+
+static struct dentry *ubifs_lookup(struct inode *dir, struct dentry *dentry,
+				   struct nameidata *nd)
+{
+	int err;
+	union ubifs_key key;
+	struct inode *inode = NULL;
+	struct ubifs_dent_node *dent;
+	struct ubifs_info *c = dir->i_sb->s_fs_info;
+
+	dbg_gen("'%.*s' in dir ino %lu",
+		dentry->d_name.len, dentry->d_name.name, dir->i_ino);
+
+	if (dentry->d_name.len > UBIFS_MAX_NLEN)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	dent = kmalloc(UBIFS_MAX_DENT_NODE_SZ, GFP_NOFS);
+	if (!dent)
+		return ERR_PTR(-ENOMEM);
+
+	dent_key_init(c, &key, dir->i_ino, &dentry->d_name);
+
+	err = ubifs_tnc_lookup_nm(c, &key, dent, &dentry->d_name);
+	if (err) {
+		if (err == -ENOENT) {
+			dbg_gen("not found");
+			goto done;
+		}
+		goto out;
+	}
+
+	if (dbg_check_name(dent, &dentry->d_name)) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	inode = ubifs_iget(dir->i_sb, le64_to_cpu(dent->inum));
+	if (IS_ERR(inode)) {
+		/*
+		 * This should not happen. Probably the file-system needs
+		 * checking.
+		 */
+		err = PTR_ERR(inode);
+		ubifs_err("dead directory entry, error %d", err);
+		ubifs_ro_mode(c, err);
+		goto out;
+	}
+
+done:
+	kfree(dent);
+	/*
+	 * Note, d_splice_alias() would be required instead if we supported
+	 * NFS.
+	 */
+	d_add(dentry, inode);
+	return NULL;
+
+out:
+	kfree(dent);
+	return ERR_PTR(err);
+}
+
+static int ubifs_create(struct inode *dir, struct dentry *dentry, int mode,
+			struct nameidata *nd)
+{
+	struct inode *inode;
+	struct ubifs_info *c = dir->i_sb->s_fs_info;
+	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1 };
+	int err, sz_change = CALC_DENT_SIZE(dentry->d_name.len);
+
+	dbg_gen("dent '%.*s', mode %#x in dir ino %lu",
+		dentry->d_name.len, dentry->d_name.name, mode, dir->i_ino);
+
+	inode = ubifs_new_inode(c, dir, mode);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	err = ubifs_budget_inode_op(c, dir, &req);
+	if (err)
+		goto out;
+
+	dir->i_size += sz_change;
+
+	err = ubifs_jnl_update(c, dir, &dentry->d_name, inode, 0,
+			       IS_DIRSYNC(dir), 0);
+	if (err)
+		goto out_budg;
+
+	insert_inode_hash(inode);
+	d_instantiate(dentry, inode);
+	ubifs_release_ino_clean(c, dir, &req);
+	return 0;
+
+out_budg:
+	dir->i_size -= sz_change;
+	ubifs_cancel_ino_op(c, dir, &req);
+	ubifs_err("cannot create regular file, error %d", err);
+out:
+	make_bad_inode(inode);
+	iput(inode);
+	return err;
+}
+
+/**
+ * vfs_dent_type - get VFS directory entry type.
+ * @type: UBIFS directory entry type
+ *
+ * This function converts UBIFS directory entry type into VFS directory entry
+ * type.
+ */
+static unsigned int vfs_dent_type(uint8_t type)
+{
+	switch (type) {
+	case UBIFS_ITYPE_REG:
+		return DT_REG;
+	case UBIFS_ITYPE_DIR:
+		return DT_DIR;
+	case UBIFS_ITYPE_LNK:
+		return DT_LNK;
+	case UBIFS_ITYPE_BLK:
+		return DT_BLK;
+	case UBIFS_ITYPE_CHR:
+		return DT_CHR;
+	case UBIFS_ITYPE_FIFO:
+		return DT_FIFO;
+	case UBIFS_ITYPE_SOCK:
+		return DT_SOCK;
+	default:
+		BUG();
+	}
+	return 0;
+}
+
+/*
+ * The classical Unix view for directory is that it is a linear array of
+ * (name, inode number) entries. Linux/VFS assumes this model as well.
+ * Particularly, 'readdir()' call wants us to return a directory entry offset
+ * which later may be used to continue 'readdir()'ing the directory or to
+ * 'seek()' to that specific direntry. Obviously UBIFS does not really fit this
+ * model because directory entries are identified by keys, which may collide.
+ *
+ * UBIFS uses directory entry hash value for directory offsets, so
+ * 'seekdir()'/'telldir()' may not always work because of possible key
+ * collisions. But UBIFS guarantees that consecutive 'readdir()' calls work
+ * properly by means of saving full directory entry name in the private field
+ * of the file description object.
+ *
+ * This means that UBIFS cannot support NFS which requires full
+ * 'seekdir()'/'telldir()' support.
+ */
+static int ubifs_readdir(struct file *file, void *dirent, filldir_t filldir)
+{
+	int err, over = 0;
+	struct qstr nm;
+	union ubifs_key key;
+	struct ubifs_dent_node *dent;
+	struct inode *dir = file->f_path.dentry->d_inode;
+	struct ubifs_info *c = dir->i_sb->s_fs_info;
+
+	dbg_gen("dir ino %lu, f_pos %#llx", dir->i_ino, file->f_pos);
+
+	if (file->f_pos > UBIFS_S_KEY_HASH_MASK || file->f_pos == -1)
+		/*
+		 * The directory was seek'ed to a senseless position or there
+		 * are no more entries.
+		 */
+		return 0;
+
+	/* File positions 0 and 1 correspond to "." and ".." */
+	if (file->f_pos == 0) {
+		ubifs_assert(!file->private_data);
+		over = filldir(dirent, ".", 1, 0, dir->i_ino, DT_DIR);
+		if (over)
+			return 0;
+		file->f_pos = 1;
+	}
+
+	if (file->f_pos == 1) {
+		ubifs_assert(!file->private_data);
+		over = filldir(dirent, "..", 2, 1,
+			       parent_ino(file->f_path.dentry), DT_DIR);
+		if (over)
+			return 0;
+
+		/* Find the first entry in TNC and save it */
+		lowest_dent_key(c, &key, dir->i_ino);
+		nm.name = NULL;
+		dent = ubifs_tnc_next_ent(c, &key, &nm);
+		if (IS_ERR(dent)) {
+			err = PTR_ERR(dent);
+			goto out;
+		}
+
+		file->f_pos = key_hash_flash(c, &dent->key);
+		file->private_data = dent;
+	}
+
+	dent = file->private_data;
+	if (!dent) {
+		/*
+		 * The directory was seek'ed to and is now readdir'ed.
+		 * Find the entry corresponding to @file->f_pos or the
+		 * closest one.
+		 */
+		dent_key_init_hash(c, &key, dir->i_ino, file->f_pos);
+		nm.name = NULL;
+		dent = ubifs_tnc_next_ent(c, &key, &nm);
+		if (IS_ERR(dent)) {
+			err = PTR_ERR(dent);
+			goto out;
+		}
+		file->f_pos = key_hash_flash(c, &dent->key);
+		file->private_data = dent;
+	}
+
+	while (1) {
+		dbg_gen("feed '%s', ino %llu, new f_pos %#x",
+			dent->name, le64_to_cpu(dent->inum),
+			key_hash_flash(c, &dent->key));
+		ubifs_assert(dent->ch.sqnum > ubifs_inode(dir)->creat_sqnum);
+
+		nm.len = le16_to_cpu(dent->nlen);
+		over = filldir(dirent, dent->name, nm.len, file->f_pos,
+			       le64_to_cpu(dent->inum),
+			       vfs_dent_type(dent->type));
+		if (over)
+			return 0;
+
+		/* Switch to the next entry */
+		key_read(c, &dent->key, &key);
+		nm.name = dent->name;
+		dent = ubifs_tnc_next_ent(c, &key, &nm);
+		if (IS_ERR(dent)) {
+			err = PTR_ERR(dent);
+			goto out;
+		}
+
+		kfree(file->private_data);
+		file->f_pos = key_hash_flash(c, &dent->key);
+		file->private_data = dent;
+		cond_resched();
+	}
+
+out:
+	if (err != -ENOENT) {
+		ubifs_err("cannot find next direntry, error %d", err);
+		return err;
+	}
+
+	kfree(file->private_data);
+	file->private_data = NULL;
+	file->f_pos = -1;
+	return 0;
+}
+
+/* If a directory is seeked, we have to free saved readdir() state */
+loff_t ubifs_dir_llseek(struct file *file, loff_t offset, int origin)
+{
+	kfree(file->private_data);
+	file->private_data = NULL;
+	return generic_file_llseek(file, offset, origin);
+}
+
+/* Free saved readdir() state when the directory is closed */
+static int ubifs_dir_release(struct inode *dir, struct file *file)
+{
+	kfree(file->private_data);
+	file->private_data = NULL;
+	return 0;
+}
+
+static int ubifs_link(struct dentry *old_dentry, struct inode *dir,
+		      struct dentry *dentry)
+{
+	struct ubifs_info *c = dir->i_sb->s_fs_info;
+	struct inode *inode = old_dentry->d_inode;
+	struct ubifs_inode *ui = ubifs_inode(inode);
+	struct ubifs_budget_req req = { .new_dent = 1, .dirtied_ino = 1,
+					.dirtied_ino_d = ui->data_len };
+	int err, sz_change = CALC_DENT_SIZE(dentry->d_name.len);
+
+	dbg_gen("dent '%.*s' to ino %lu (nlink %d) in dir ino %lu",
+		dentry->d_name.len, dentry->d_name.name, inode->i_ino,
+		inode->i_nlink, dir->i_ino);
+
+	err = ubifs_budget_inode_op(c, dir, &req);
+	if (err)
+		return err;
+
+	inc_nlink(inode);
+	dir->i_size += sz_change;
+	inode->i_ctime = dir->i_mtime = dir->i_ctime =
+			 ubifs_current_time(inode);
+
+	err = ubifs_jnl_update(c, dir, &dentry->d_name, inode, 0,
+			       IS_DIRSYNC(dir), 0);
+	if (err)
+		goto out_budg;
+
+	atomic_inc(&inode->i_count);
+	d_instantiate(dentry, inode);
+	ubifs_release_ino_clean(c, dir, &req);
+	return 0;
+
+out_budg:
+	dir->i_size -= sz_change;
+	ubifs_cancel_ino_op(c, dir, &req);
+	drop_nlink(inode);
+	iput(inode);
+	return err;
+}
+
+static int ubifs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct ubifs_info *c = dir->i_sb->s_fs_info;
+	struct inode *inode = dentry->d_inode;
+	struct ubifs_budget_req req = { .mod_dent = 1, .dirtied_ino = 1 };
+	int sz_change = CALC_DENT_SIZE(dentry->d_name.len);
+	int err, budgeted = 1;
+
+	dbg_gen("dent '%.*s' from ino %lu (nlink %d) in dir ino %lu",
+		dentry->d_name.len, dentry->d_name.name, inode->i_ino,
+		inode->i_nlink, dir->i_ino);
+
+	err = ubifs_budget_inode_op(c, dir, &req);
+	if (err) {
+		if (err != -ENOSPC)
+			return err;
+		err = 0;
+		budgeted = 0;
+	}
+
+	dir->i_size -= sz_change;
+	dir->i_mtime = dir->i_ctime = ubifs_current_time(dir);
+
+	inode->i_ctime = dir->i_ctime;
+	drop_nlink(inode);
+
+	err = ubifs_jnl_update(c, dir, &dentry->d_name, inode, 1,
+			       IS_DIRSYNC(dir), 0);
+	if (err)
+		goto out_budg;
+
+	if (budgeted)
+		ubifs_release_ino_clean(c, dir, &req);
+
+	return 0;
+
+out_budg:
+	dir->i_size += sz_change;
+	inc_nlink(inode);
+	if (budgeted)
+		ubifs_cancel_ino_op(c, dir, &req);
+	return err;
+}
+
+/**
+ * check_dir_empty - check if a directory is empty or not.
+ * @c: UBIFS file-system description object
+ * @dir: VFS inode object of the directory to check
+ *
+ * This function checks if directory @dir is empty. Returns zero if the
+ * directory is empty, %-ENOTEMPTY if it is not, and other negative error codes
+ * in case of of errors.
+ */
+static int check_dir_empty(struct ubifs_info *c, struct inode *dir)
+{
+	struct qstr nm = { .name = NULL };
+	struct ubifs_dent_node *dent;
+	union ubifs_key key;
+	int err;
+
+	lowest_dent_key(c, &key, dir->i_ino);
+	dent = ubifs_tnc_next_ent(c, &key, &nm);
+	if (IS_ERR(dent)) {
+		err = PTR_ERR(dent);
+		if (err == -ENOENT)
+			err = 0;
+	} else {
+		kfree(dent);
+		err = -ENOTEMPTY;
+	}
+
+	return err;
+}
+
+static int ubifs_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	struct ubifs_info *c = dir->i_sb->s_fs_info;
+	struct inode *inode = dentry->d_inode;
+	struct ubifs_budget_req req = { .mod_dent = 1, .dirtied_ino = 1 };
+	int sz_change = CALC_DENT_SIZE(dentry->d_name.len);
+	int err, budgeted = 0;
+
+	dbg_gen("directory '%.*s', ino %lu in dir ino %lu", dentry->d_name.len,
+		dentry->d_name.name, inode->i_ino, dir->i_ino);
+
+	err = check_dir_empty(c, dentry->d_inode);
+	if (err)
+		return err;
+
+	budgeted = 1;
+	err = ubifs_budget_inode_op(c, dir, &req);
+	if (err) {
+		if (err != -ENOSPC)
+			return err;
+		budgeted = 0;
+	}
+
+	dir->i_size -= sz_change;
+	dir->i_mtime = dir->i_ctime = ubifs_current_time(dir);
+	drop_nlink(dir);
+
+	inode->i_size = 0;
+	inode->i_ctime = dir->i_ctime;
+	clear_nlink(inode);
+
+	err = ubifs_jnl_update(c, dir, &dentry->d_name, inode, 1,
+			       IS_DIRSYNC(dir), 0);
+	if (err)
+		goto out_budg;
+
+	if (budgeted)
+		ubifs_release_ino_clean(c, dir, &req);
+
+	return 0;
+
+out_budg:
+	dir->i_size += sz_change;
+	inc_nlink(dir);
+	inc_nlink(inode);
+	inc_nlink(inode);
+	if (budgeted)
+		ubifs_cancel_ino_op(c, dir, &req);
+	return err;
+}
+
+static int ubifs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	struct inode *inode;
+	struct ubifs_info *c = dir->i_sb->s_fs_info;
+	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1 };
+	int err, sz_change = CALC_DENT_SIZE(dentry->d_name.len);
+
+	dbg_gen("dent '%.*s', mode %#x in dir ino %lu",
+		dentry->d_name.len, dentry->d_name.name, mode, dir->i_ino);
+
+	err = ubifs_budget_inode_op(c, dir, &req);
+	if (err)
+		return err;
+
+	inode = ubifs_new_inode(c, dir, S_IFDIR | mode);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		goto out_budg;
+	}
+
+	insert_inode_hash(inode);
+	inc_nlink(inode);
+
+	dir->i_mtime = dir->i_ctime = ubifs_current_time(dir);
+	dir->i_size += sz_change;
+	inc_nlink(dir);
+
+	err = ubifs_jnl_update(c, dir, &dentry->d_name, inode, 0,
+			       IS_DIRSYNC(dir), 0);
+	if (err) {
+		ubifs_err("cannot create directory, error %d", err);
+		goto out_inode;
+	}
+
+	d_instantiate(dentry, inode);
+	ubifs_release_ino_clean(c, dir, &req);
+	return 0;
+
+out_inode:
+	dir->i_size -= sz_change;
+	drop_nlink(dir);
+	make_bad_inode(inode);
+	iput(inode);
+out_budg:
+	ubifs_cancel_ino_op(c, dir, &req);
+	return err;
+}
+
+static int ubifs_mknod(struct inode *dir, struct dentry *dentry,
+		       int mode, dev_t rdev)
+{
+	struct inode *inode;
+	struct ubifs_info *c = dir->i_sb->s_fs_info;
+	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1 };
+	union ubifs_dev_desc *dev = NULL;
+	int sz_change = CALC_DENT_SIZE(dentry->d_name.len);
+	int err, devlen = 0;
+
+	dbg_gen("dent '%.*s' in dir ino %lu",
+		dentry->d_name.len, dentry->d_name.name, dir->i_ino);
+
+	if (!new_valid_dev(rdev))
+		return -EINVAL;
+
+	if (S_ISBLK(mode) || S_ISCHR(mode)) {
+		dev = kmalloc(sizeof(union ubifs_dev_desc), GFP_NOFS);
+		if (!dev)
+			return -ENOMEM;
+		devlen = ubifs_encode_dev(dev, rdev);
+	}
+
+	err = ubifs_budget_inode_op(c, dir, &req);
+	if (err) {
+		kfree(dev);
+		return err;
+	}
+
+	inode = ubifs_new_inode(c, dir, mode);
+	if (IS_ERR(inode)) {
+		kfree(dev);
+		err = PTR_ERR(inode);
+		goto out_budg;
+	}
+
+	init_special_inode(inode, inode->i_mode, rdev);
+
+	inode->i_size = devlen;
+	ubifs_inode(inode)->data = dev;
+	ubifs_inode(inode)->data_len = devlen;
+
+	dir->i_size += sz_change;
+
+	err = ubifs_jnl_update(c, dir, &dentry->d_name, inode, 0,
+			       IS_DIRSYNC(dir), 0);
+	if (err)
+		goto out_inode;
+
+	insert_inode_hash(inode);
+	d_instantiate(dentry, inode);
+	ubifs_release_ino_clean(c, dir, &req);
+	return 0;
+
+out_inode:
+	dir->i_size -= sz_change;
+	make_bad_inode(inode);
+	iput(inode);
+out_budg:
+	ubifs_cancel_ino_op(c, dir, &req);
+	return err;
+}
+
+static int ubifs_symlink(struct inode *dir, struct dentry *dentry,
+			 const char *symname)
+{
+	struct inode *inode;
+	struct ubifs_inode *ui;
+	struct ubifs_info *c = dir->i_sb->s_fs_info;
+	int err, len = strlen(symname);
+	int sz_change = CALC_DENT_SIZE(dentry->d_name.len);
+	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
+					.new_ino_d = len };
+
+	dbg_gen("dent '%.*s', target '%s' in dir ino %lu", dentry->d_name.len,
+		dentry->d_name.name, symname, dir->i_ino);
+
+	if (len > UBIFS_MAX_INO_DATA)
+		return -ENAMETOOLONG;
+
+	err = ubifs_budget_inode_op(c, dir, &req);
+	if (err)
+		return err;
+
+	inode = ubifs_new_inode(c, dir, S_IFLNK | S_IRWXUGO);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		goto out_budg;
+	}
+
+	ui = ubifs_inode(inode);
+	ui->data = kmalloc(len + 1, GFP_NOFS);
+	if (!ui->data) {
+		err = -ENOMEM;
+		goto out_inode;
+	}
+
+	memcpy(ui->data, symname, len);
+	((char *)ui->data)[len] = '\0';
+	/*
+	 * The terminating zero byte is not written to the flash media and it
+	 * is put just to make later in-memory string processing simpler. Thus,
+	 * data length is @len, not @len + %1.
+	 */
+	ui->data_len = len;
+	inode->i_size = len;
+
+	dir->i_size += sz_change;
+
+	err = ubifs_jnl_update(c, dir, &dentry->d_name, inode, 0,
+			       IS_DIRSYNC(dir), 0);
+	if (err)
+		goto out_dir;
+
+	insert_inode_hash(inode);
+	d_instantiate(dentry, inode);
+	ubifs_release_ino_clean(c, dir, &req);
+	return 0;
+
+out_dir:
+	dir->i_size -= sz_change;
+out_inode:
+	make_bad_inode(inode);
+	iput(inode);
+out_budg:
+	ubifs_cancel_ino_op(c, dir, &req);
+	return err;
+}
+
+static int ubifs_rename(struct inode *old_dir, struct dentry *old_dentry,
+			struct inode *new_dir, struct dentry *new_dentry)
+{
+	struct ubifs_info *c = old_dir->i_sb->s_fs_info;
+	struct inode *old_inode = old_dentry->d_inode;
+	struct inode *new_inode = new_dentry->d_inode;
+	int err, move = (new_dir != old_dir);
+	int is_dir = S_ISDIR(old_inode->i_mode);
+	int unlink = !!new_inode;
+	int dirsync = (IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir));
+	int new_sz = CALC_DENT_SIZE(new_dentry->d_name.len);
+	int old_sz = CALC_DENT_SIZE(old_dentry->d_name.len);
+	struct ubifs_budget_req req = { .new_dent = 1, .mod_dent = 1 };
+	struct timespec time = ubifs_current_time(old_dir);
+
+	dbg_gen("dent '%.*s' ino %lu in dir ino %lu to dent '%.*s' in "
+		"dir ino %lu", old_dentry->d_name.len, old_dentry->d_name.name,
+		old_inode->i_ino, old_dir->i_ino, new_dentry->d_name.len,
+		new_dentry->d_name.name, new_dir->i_ino);
+
+	if (unlink && is_dir) {
+		err = check_dir_empty(c, new_inode);
+		if (err)
+			return err;
+	}
+
+	if (move) {
+		req.dirtied_ino = 1;
+		if (unlink) {
+			req.dirtied_ino += 2;
+			req.dirtied_ino_d = ubifs_inode(new_inode)->data_len;
+		}
+	}
+
+	/*
+	 * Note, rename may write @new_dir inode if the directory entry is
+	 * moved there. And if the @new_dir is dirty, we do not bother to make
+	 * it clean. It could be done, but requires extra coding which does not
+	 * seem to be really worth it.
+	 */
+	err = ubifs_budget_inode_op(c, old_dir, &req);
+	if (err)
+		return err;
+
+	/*
+	 * Like most other Unix systems, set the ctime for inodes on a
+	 * rename.
+	 */
+	old_inode->i_ctime = time;
+
+	/*
+	 * If we moved a directory to another parent directory, decrement
+	 * 'i_nlink' of the old parent. Also, update 'i_size' of the old parent
+	 * as well as its [mc]time.
+	 */
+	if (is_dir && move)
+		drop_nlink(old_dir);
+	old_dir->i_size -= old_sz;
+	old_dir->i_mtime = old_dir->i_ctime = time;
+	new_dir->i_mtime = new_dir->i_ctime = time;
+
+	/*
+	 * If we moved a directory object to new directory, parent's 'i_nlink'
+	 * should be adjusted.
+	 */
+	if (move && is_dir)
+		inc_nlink(new_dir);
+
+	/*
+	 * And finally, if we unlinked a direntry which happened to have the
+	 * same name as the moved direntry, we have to decrement 'i_nlink' of
+	 * the unlinked inode and change its ctime.
+	 */
+	if (unlink) {
+		/*
+		 * Directories cannot have hard-links, so if this is a
+		 * directory, decrement its 'i_nlink' twice because an empty
+		 * directory has 'i_nlink' 2.
+		 */
+		if (is_dir)
+			drop_nlink(new_inode);
+		new_inode->i_ctime = time;
+		drop_nlink(new_inode);
+	} else
+		new_dir->i_size += new_sz;
+
+	err = ubifs_jnl_rename(c, old_dir, old_dentry, new_dir, new_dentry,
+			       dirsync);
+	if (err)
+		goto out_inode;
+
+	ubifs_release_ino_clean(c, old_dir, &req);
+	return 0;
+
+out_inode:
+	if (unlink) {
+		if (is_dir)
+			inc_nlink(new_inode);
+		inc_nlink(new_inode);
+	} else
+		new_dir->i_size -= new_sz;
+	old_dir->i_size += old_sz;
+	if (is_dir && move) {
+		drop_nlink(new_dir);
+		inc_nlink(old_dir);
+	}
+	ubifs_cancel_ino_op(c, old_dir, &req);
+	return err;
+}
+
+int ubifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
+		  struct kstat *stat)
+{
+	struct inode *inode = dentry->d_inode;
+	loff_t size;
+
+	stat->dev = inode->i_sb->s_dev;
+	stat->ino = inode->i_ino;
+	stat->mode = inode->i_mode;
+	stat->nlink = inode->i_nlink;
+	stat->uid = inode->i_uid;
+	stat->gid = inode->i_gid;
+	stat->rdev = inode->i_rdev;
+	stat->atime = inode->i_atime;
+	stat->mtime = inode->i_mtime;
+	stat->ctime = inode->i_ctime;
+	stat->blksize = UBIFS_BLOCK_SIZE;
+	stat->size = i_size_read(inode);
+
+	spin_lock(&inode->i_lock);
+	size = ubifs_inode(inode)->xattr_size;
+	spin_unlock(&inode->i_lock);
+
+	/*
+	 * Unfortunately, the 'stat()' system call was designed for block
+	 * device based file systems, and it is not appropriate for UBIFS,
+	 * because UBIFS does not have notion of "block". For example, it is
+	 * difficult to tell how many block a directory takes - it actually
+	 * takes less than 300 bytes, but we have to round it to block size,
+	 * which introduces large mistake. This makes utilities like 'du' to
+	 * report completely senseless numbers. This is the reason why UBIFS
+	 * goes the same way as JFFS2 - it reports zero blocks for everything
+	 * but regular files, which makes more sense than reporting completely
+	 * wrong sizes.
+	 */
+	if (S_ISREG(inode->i_mode))
+		size += stat->size;
+
+	size = ALIGN(size, UBIFS_BLOCK_SIZE);
+	/*
+	 * Note, user-space expects 512-byte blocks count irrespectively of what
+	 * was reported in @stat->size.
+	 */
+	stat->blocks = size >> 9;
+
+	return 0;
+}
+
+struct inode_operations ubifs_dir_inode_operations = {
+	.lookup      = ubifs_lookup,
+	.create      = ubifs_create,
+	.link        = ubifs_link,
+	.symlink     = ubifs_symlink,
+	.unlink      = ubifs_unlink,
+	.mkdir       = ubifs_mkdir,
+	.rmdir       = ubifs_rmdir,
+	.mknod       = ubifs_mknod,
+	.rename      = ubifs_rename,
+	.setattr     = ubifs_setattr,
+	.getattr     = ubifs_getattr,
+#ifdef CONFIG_UBIFS_FS_XATTR
+	.setxattr    = ubifs_setxattr,
+	.getxattr    = ubifs_getxattr,
+	.listxattr   = ubifs_listxattr,
+	.removexattr = ubifs_removexattr,
+#endif
+};
+
+struct file_operations ubifs_dir_operations = {
+	.llseek         = ubifs_dir_llseek,
+	.release        = ubifs_dir_release,
+	.read           = generic_read_dir,
+	.readdir        = ubifs_readdir,
+	.fsync          = ubifs_fsync,
+	.unlocked_ioctl = ubifs_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl   = ubifs_compat_ioctl,
+#endif
+};
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
new file mode 100644
index 0000000..454fed5
--- /dev/null
+++ b/fs/ubifs/file.c
@@ -0,0 +1,960 @@
+/*
+ * This file is part of UBIFS.
+ *
+ * Copyright (C) 2006-2008 Nokia Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ * Authors: Artem Bityutskiy (Битюцкий Артём)
+ *          Adrian Hunter
+ */
+
+/*
+ * This file implements VFS file and inode operations of regular files, device
+ * nodes and symlinks as well as address space operations.
+ *
+ * UBIFS uses 2 page flags: PG_private and PG_checked. PG_private is set if the
+ * page is dirty and is used for budgeting purposes - dirty pages should not be
+ * budgeted. The PG_checked flag is set if full budgeting is required for the
+ * page e.g., when it corresponds to a file hole or it is just beyond the file
+ * size. The budgeting is done in 'ubifs_write_begin()', because it is OK to
+ * fail in this function, and the budget is released in 'ubifs_write_end()'. So
+ * the PG_private and PG_checked flags carry the information about how the page
+ * was budgeted, to make it possible to release the budget properly.
+ *
+ * A thing to keep in mind: inode's 'i_mutex' is locked in most VFS operations
+ * we implement. However, this is not true for '->writepage()', which might be
+ * called with 'i_mutex' unlocked. For example, when pdflush is performing
+ * write-back, it calls 'writepage()' with unlocked 'i_mutex', although the
+ * inode has 'I_LOCK' flag in this case. At "normal" work-paths 'i_mutex' is
+ * locked in '->writepage', e.g. in "sys_write -> alloc_pages -> direct reclaim
+ * path'. So, in '->writepage()' we are only guaranteed that the page is
+ * locked.
+ *
+ * Similarly, 'i_mutex' does not have to be locked in readpage(), e.g.,
+ * readahead path does not have it locked ("sys_read -> generic_file_aio_read
+ * -> ondemand_readahead -> readpage"). In case of readahead, 'I_LOCK' flag is
+ * not set as well.
+ *
+ * This, for example means that there might be 2 concurrent '->writepage()'
+ * calls for the same inode, but different inode dirty pages.
+ */
+
+#include "ubifs.h"
+#include <linux/mount.h>
+
+static int read_block(struct inode *inode, void *addr, unsigned int block,
+		      struct ubifs_data_node *dn)
+{
+	struct ubifs_info *c = inode->i_sb->s_fs_info;
+	int err, len, out_len;
+	union ubifs_key key;
+	unsigned int dlen;
+
+	data_key_init(c, &key, inode->i_ino, block);
+	err = ubifs_tnc_lookup(c, &key, dn);
+	if (err) {
+		if (err == -ENOENT)
+			/* Not found, so it must be a hole */
+			memset(addr, 0, UBIFS_BLOCK_SIZE);
+		return err;
+	}
+
+	ubifs_assert(dn->ch.sqnum > ubifs_inode(inode)->creat_sqnum);
+
+	len = le32_to_cpu(dn->size);
+	if (len <= 0 || len > UBIFS_BLOCK_SIZE)
+		goto dump;
+
+	dlen = le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ;
+	out_len = UBIFS_BLOCK_SIZE;
+	err = ubifs_decompress(&dn->data, dlen, addr, &out_len,
+			       le16_to_cpu(dn->compr_type));
+	if (err || len != out_len)
+		goto dump;
+
+	/*
+	 * Data length can be less than a full block, even for blocks that are
+	 * not the last in the file (e.g., as a result of making a hole and
+	 * appending data). Ensure that the remainder is zeroed out.
+	 */
+	if (len < UBIFS_BLOCK_SIZE)
+		memset(addr + len, 0, UBIFS_BLOCK_SIZE - len);
+
+	return 0;
+
+dump:
+	ubifs_err("bad data node (block %u, inode %lu)",
+		  block, inode->i_ino);
+	dbg_dump_node(c, dn);
+	return -EINVAL;
+}
+
+static int do_readpage(struct page *page)
+{
+	void *addr;
+	int err = 0, i;
+	unsigned int block, beyond;
+	struct ubifs_data_node *dn;
+	struct inode *inode = page->mapping->host;
+	loff_t i_size = i_size_read(inode);
+
+	dbg_gen("ino %lu, pg %lu, i_size %lld, flags %#lx",
+		inode->i_ino, page->index, i_size, page->flags);
+	ubifs_assert(!PageChecked(page));
+	ubifs_assert(!PagePrivate(page));
+
+	addr = kmap(page);
+
+	block = page->index << UBIFS_BLOCKS_PER_PAGE_SHIFT;
+	beyond = (i_size + UBIFS_BLOCK_SIZE - 1) >> UBIFS_BLOCK_SHIFT;
+	if (block >= beyond) {
+		/* Reading beyond inode */
+		SetPageChecked(page);
+		memset(addr, 0, PAGE_CACHE_SIZE);
+		goto out;
+	}
+
+	dn = kmalloc(UBIFS_MAX_DATA_NODE_SZ, GFP_NOFS);
+	if (!dn) {
+		err = -ENOMEM;
+		goto error;
+	}
+
+	i = 0;
+	while (1) {
+		int ret;
+
+		if (block >= beyond) {
+			/* Reading beyond inode */
+			err = -ENOENT;
+			memset(addr, 0, UBIFS_BLOCK_SIZE);
+		} else {
+			ret = read_block(inode, addr, block, dn);
+			if (ret) {
+				err = ret;
+				if (err != -ENOENT)
+					break;
+			}
+		}
+		if (++i >= UBIFS_BLOCKS_PER_PAGE)
+			break;
+		block += 1;
+		addr += UBIFS_BLOCK_SIZE;
+	}
+	if (err) {
+		if (err == -ENOENT) {
+			/* Not found, so it must be a hole */
+			SetPageChecked(page);
+			dbg_gen("hole");
+			goto out_free;
+		}
+		ubifs_err("cannot read page %lu of inode %lu, error %d",
+			  page->index, inode->i_ino, err);
+		goto error;
+	}
+
+out_free:
+	kfree(dn);
+out:
+	SetPageUptodate(page);
+	ClearPageError(page);
+	flush_dcache_page(page);
+	kunmap(page);
+	return 0;
+
+error:
+	kfree(dn);
+	ClearPageUptodate(page);
+	SetPageError(page);
+	flush_dcache_page(page);
+	kunmap(page);
+	return err;
+}
+
+static int ubifs_write_begin(struct file *file, struct address_space *mapping,
+			     loff_t pos, unsigned len, unsigned flags,
+			     struct page **pagep, void **fsdata)
+{
+	struct inode *inode = mapping->host;
+	struct ubifs_info *c = inode->i_sb->s_fs_info;
+	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
+	struct ubifs_budget_req req = { .new_page = 1 };
+	loff_t i_size =  i_size_read(inode);
+	int uninitialized_var(err);
+	struct page *page;
+
+	ubifs_assert(!(inode->i_sb->s_flags & MS_RDONLY));
+
+	if (unlikely(c->ro_media))
+		return -EROFS;
+
+	/*
+	 * We are about to have a page of data written and we have to budget for
+	 * this. The very important point here is that we have to budget before
+	 * locking the page, because budgeting may force write-back, which
+	 * would wait on locked pages and deadlock if we had the page locked.
+	 *
+	 * At this point we do not know anything about the page of data we are
+	 * going to change, so assume the biggest budget (i.e., assume that
+	 * this is a new page of data and it does not override an older page of
+	 * data in the inode). Later the budget will be amended if this is not
+	 * true.
+	 */
+	if (pos + len > i_size)
+		/*
+		 * We are writing beyond the file which means we are going to
+		 * change inode size and make the inode dirty. And in turn,
+		 * this means we have to budget for making the inode dirty.
+		 *
+		 * Note, if the inode is already dirty,
+		 * 'ubifs_budget_inode_op()' will not allocate any budget,
+		 * but will just lock the @budg_mutex of the inode to prevent
+		 * it from becoming clean before we have changed its size,
+		 * which is going to happen in 'ubifs_write_end()'.
+		 */
+		err = ubifs_budget_inode_op(c, inode, &req);
+	else
+		/*
+		 * The inode is not going to be marked as dirty by this write
+		 * operation, do not budget for this.
+		 */
+		err = ubifs_budget_space(c, &req);
+	if (unlikely(err))
+		return err;
+
+	page = __grab_cache_page(mapping, index);
+	if (unlikely(!page)) {
+		err = -ENOMEM;
+		goto out_release;
+	}
+
+	if (!PageUptodate(page)) {
+		/*
+		 * The page is not loaded from the flash and has to be loaded
+		 * unless we are writing all of it.
+		 */
+		if (!(pos & PAGE_CACHE_MASK) && len == PAGE_CACHE_SIZE)
+			/*
+			 * Set the PG_checked flag to make the further code
+			 * assume the page is new.
+			 */
+			SetPageChecked(page);
+		else {
+			err = do_readpage(page);
+			if (err)
+				goto out_unlock;
+		}
+
+		SetPageUptodate(page);
+		ClearPageError(page);
+	}
+
+	if (PagePrivate(page))
+		/*
+		 * The page is dirty, which means it was budgeted twice:
+		 *   o first time the budget was allocated by the task which
+		 *     made the page dirty and set the PG_private flag;
+		 *   o and then we budgeted for it for the second time at the
+		 *     very beginning of this function.
+		 *
+		 * So what we have to do is to release the page budget we
+		 * allocated.
+		 *
+		 * Note, the page write operation may change the inode length,
+		 * which makes it dirty and means the budget should be
+		 * allocated. This was done above in the "pos + len > i_size"
+		 * case. If this was done, we do not free the the inode budget,
+		 * because we cannot as we are really going to mark it dirty in
+		 * the 'ubifs_write_end()' function.
+		 */
+		ubifs_release_new_page_budget(c);
+	else if (!PageChecked(page))
+		/*
+		 * The page is not new, which means we are changing the page
+		 * which already exists on the media. This means that changing
+		 * the page does not make the amount of indexing information
+		 * larger, and this part of the budget which we have already
+		 * acquired may be released.
+		 */
+		ubifs_convert_page_budget(c);
+
+	*pagep = page;
+	return 0;
+
+out_unlock:
+	unlock_page(page);
+	page_cache_release(page);
+out_release:
+	if (pos + len > i_size)
+		ubifs_cancel_ino_op(c, inode, &req);
+	else
+		ubifs_release_budget(c, &req);
+	return err;
+}
+
+static int ubifs_write_end(struct file *file, struct address_space *mapping,
+			   loff_t pos, unsigned len, unsigned copied,
+			   struct page *page, void *fsdata)
+{
+	struct inode *inode = mapping->host;
+	struct ubifs_inode *ui = ubifs_inode(inode);
+	struct ubifs_info *c = inode->i_sb->s_fs_info;
+	loff_t i_size =  i_size_read(inode);
+
+	dbg_gen("ino %lu, pos %llu, pg %lu, len %u, copied %d, i_size %lld",
+		inode->i_ino, pos, page->index, len, copied, i_size);
+
+	if (unlikely(copied < len && len == PAGE_CACHE_SIZE)) {
+		/*
+		 * VFS copied less data to the page that it intended and
+		 * declared in its '->write_begin()' call via the @len
+		 * argument. If the page was not up-to-date, and @len was
+		 * @PAGE_CACHE_SIZE, the 'ubifs_write_begin()' function did
+		 * not load it from the media (for optimization reasons). This
+		 * means that part of the page contains garbage. So read the
+		 * page now.
+		 */
+		dbg_gen("copied %d instead of %d, read page and repeat",
+			copied, len);
+
+		if (pos + len > i_size)
+			/* See a comment below about this hacky unlock */
+			mutex_unlock(&ui->budg_mutex);
+
+		copied = do_readpage(page);
+
+		/*
+		 * Return 0 to force VFS to repeat the whole operation, or the
+		 * error code if 'do_readpage()' failed.
+		 */
+		goto out;
+	}
+
+	if (!PagePrivate(page)) {
+		SetPagePrivate(page);
+		atomic_long_inc(&c->dirty_pg_cnt);
+		__set_page_dirty_nobuffers(page);
+	}
+
+	if (pos + len > i_size) {
+		i_size_write(inode, pos + len);
+
+		/*
+		 * Note, we do not set @I_DIRTY_PAGES (which means that the
+		 * inode has dirty pages), this has been done in
+		 * '__set_page_dirty_nobuffers()'.
+		 */
+		mark_inode_dirty_sync(inode);
+
+		/*
+		 * The inode has been marked dirty, unlock it. This is a bit
+		 * hacky because normally we would have to call
+		 * 'ubifs_release_ino_dirty()'. But we know there is nothing
+		 * to release because page's budget will be released in
+		 * 'ubifs_write_page()' and inode's budget will be released in
+		 * 'ubifs_write_inode()', so just unlock the inode here for
+		 * optimization.
+		 */
+		mutex_unlock(&ui->budg_mutex);
+	}
+
+out:
+	unlock_page(page);
+	page_cache_release(page);
+	return copied;
+}
+
+static int ubifs_readpage(struct file *file, struct page *page)
+{
+	do_readpage(page);
+	unlock_page(page);
+	return 0;
+}
+
+/**
+ * release_existing_page_budget - release budget of an existing page.
+ * @c: UBIFS file-system description object
+ *
+ * This is a helper function which releases budget corresponding to the budget
+ * of changing one one page of data which already exists on the flash media.
+ *
+ * This function was not moved to "budget.c" because there is only one user.
+ */
+static void release_existing_page_budget(struct ubifs_info *c)
+{
+	struct ubifs_budget_req req = { .dd_growth = c->page_budget};
+
+	ubifs_release_budget(c, &req);
+}
+
+static int do_writepage(struct page *page, int len)
+{
+	int err = 0, i, blen;
+	unsigned int block;
+	void *addr;
+	union ubifs_key key;
+	struct inode *inode = page->mapping->host;
+	struct ubifs_info *c = inode->i_sb->s_fs_info;
+
+	/* Update radix tree tags */
+	set_page_writeback(page);
+
+	addr = kmap(page);
+
+	block = page->index << UBIFS_BLOCKS_PER_PAGE_SHIFT;
+	i = 0;
+	while (len) {
+		blen = min_t(int, len, UBIFS_BLOCK_SIZE);
+		data_key_init(c, &key, inode->i_ino, block);
+		err = ubifs_jnl_write_data(c, inode, &key, addr, blen);
+		if (err)
+			break;
+		if (++i >= UBIFS_BLOCKS_PER_PAGE)
+			break;
+		block += 1;
+		addr += blen;
+		len -= blen;
+	}
+	if (err) {
+		SetPageError(page);
+		ubifs_err("cannot write page %lu of inode %lu, error %d",
+			  page->index, inode->i_ino, err);
+		ubifs_ro_mode(c, err);
+	}
+
+	ubifs_assert(PagePrivate(page));
+	if (PageChecked(page))
+		ubifs_release_new_page_budget(c);
+	else
+		release_existing_page_budget(c);
+
+	atomic_long_dec(&c->dirty_pg_cnt);
+	ClearPagePrivate(page);
+	ClearPageChecked(page);
+
+	kunmap(page);
+	unlock_page(page);
+	end_page_writeback(page);
+
+	return err;
+}
+
+static int ubifs_writepage(struct page *page, struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	loff_t i_size =  i_size_read(inode);
+	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
+	int len;
+	void *kaddr;
+
+	dbg_gen("ino %lu, pg %lu, pg flags %#lx",
+		inode->i_ino, page->index, page->flags);
+	ubifs_assert(PagePrivate(page));
+
+	/* Is the page fully inside i_size? */
+	if (page->index < end_index)
+		return do_writepage(page, PAGE_CACHE_SIZE);
+
+	/* Is the page fully outside i_size? (truncate in progress) */
+	len = i_size & (PAGE_CACHE_SIZE - 1);
+	if (page->index >= end_index + 1 || !len) {
+		unlock_page(page);
+		return 0;
+	}
+
+	/*
+	 * The page straddles i_size. It must be zeroed out on each and every
+	 * writepage invocation because it may be mmapped. "A file is mapped
+	 * in multiples of the page size. For a file that is not a multiple of
+	 * the page size, the remaining memory is zeroed when mapped, and
+	 * writes to that region are not written out to the file."
+	 */
+	kaddr = kmap_atomic(page, KM_USER0);
+	memset(kaddr + len, 0, PAGE_CACHE_SIZE - len);
+	flush_dcache_page(page);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	return do_writepage(page, len);
+}
+
+static int ubifs_trunc(struct inode *inode, loff_t new_size)
+{
+	loff_t old_size;
+	int err;
+
+	dbg_gen("ino %lu, size %lld -> %lld",
+		inode->i_ino, inode->i_size, new_size);
+	old_size = inode->i_size;
+
+	err = vmtruncate(inode, new_size);
+	if (err)
+		return err;
+
+	if (new_size < old_size) {
+		struct ubifs_info *c = inode->i_sb->s_fs_info;
+		int offset = new_size & (UBIFS_BLOCK_SIZE - 1);
+
+		if (offset) {
+			pgoff_t index = new_size >> PAGE_CACHE_SHIFT;
+			struct page *page;
+
+			page = find_lock_page(inode->i_mapping, index);
+			if (page) {
+				if (PageDirty(page)) {
+					ubifs_assert(PagePrivate(page));
+
+					clear_page_dirty_for_io(page);
+					if (UBIFS_BLOCKS_PER_PAGE_SHIFT)
+						offset = new_size &
+							 (PAGE_CACHE_SIZE - 1);
+					err = do_writepage(page, offset);
+					page_cache_release(page);
+					if (err)
+						return err;
+					/*
+					 * We could now tell ubifs_jnl_truncate
+					 * not to read the last block.
+					 */
+				} else {
+					/*
+					 * We could 'kmap()' the page and
+					 * pass the data to ubifs_jnl_truncate
+					 * to save it from having to read it.
+					 */
+					unlock_page(page);
+					page_cache_release(page);
+				}
+			}
+		}
+		err = ubifs_jnl_truncate(c, inode->i_ino, old_size, new_size);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+int ubifs_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	unsigned int ia_valid = attr->ia_valid;
+	struct inode *inode = dentry->d_inode;
+	struct ubifs_info *c = inode->i_sb->s_fs_info;
+	struct ubifs_budget_req req;
+	int truncation, err = 0;
+
+	dbg_gen("ino %lu, ia_valid %#x", inode->i_ino, ia_valid);
+	err = inode_change_ok(inode, attr);
+	if (err)
+		return err;
+
+	memset(&req, 0, sizeof(struct ubifs_budget_req));
+
+	/*
+	 * If this is truncation, and we do not truncate on a block boundary,
+	 * budget for changing one data block, because the last block will be
+	 * re-written.
+	 */
+	truncation = (ia_valid & ATTR_SIZE) && attr->ia_size != inode->i_size;
+	if (truncation && attr->ia_size < inode->i_size &&
+	    (attr->ia_size & (UBIFS_BLOCK_SIZE - 1)))
+		req.dirtied_page = 1;
+
+	err = ubifs_budget_inode_op(c, inode, &req);
+	if (err)
+		return err;
+
+	if (truncation) {
+		err = ubifs_trunc(inode, attr->ia_size);
+		if (err) {
+			ubifs_cancel_ino_op(c, inode, &req);
+			return err;
+		}
+
+		inode->i_mtime = inode->i_ctime = ubifs_current_time(inode);
+	}
+
+	if (ia_valid & ATTR_UID)
+		inode->i_uid = attr->ia_uid;
+	if (ia_valid & ATTR_GID)
+		inode->i_gid = attr->ia_gid;
+	if (ia_valid & ATTR_ATIME)
+		inode->i_atime = timespec_trunc(attr->ia_atime,
+						inode->i_sb->s_time_gran);
+	if (ia_valid & ATTR_MTIME)
+		inode->i_mtime = timespec_trunc(attr->ia_mtime,
+						inode->i_sb->s_time_gran);
+	if (ia_valid & ATTR_CTIME)
+		inode->i_ctime = timespec_trunc(attr->ia_ctime,
+						inode->i_sb->s_time_gran);
+	if (ia_valid & ATTR_MODE) {
+		umode_t mode = attr->ia_mode;
+
+		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+			mode &= ~S_ISGID;
+		inode->i_mode = mode;
+	}
+
+	mark_inode_dirty_sync(inode);
+	ubifs_release_ino_dirty(c, inode, &req);
+
+	if (req.dirtied_page) {
+		/*
+		 * Truncation code does not make the reenacted page dirty, it
+		 * just changes it on journal level, so we have to release page
+		 * change budget.
+		 */
+		memset(&req, 0, sizeof(struct ubifs_budget_req));
+		req.dd_growth = c->page_budget;
+		ubifs_release_budget(c, &req);
+	}
+
+	if (IS_SYNC(inode))
+		err = write_inode_now(inode, 1);
+
+	return err;
+}
+
+static void ubifs_invalidatepage(struct page *page, unsigned long offset)
+{
+	struct inode *inode = page->mapping->host;
+	struct ubifs_info *c = inode->i_sb->s_fs_info;
+	struct ubifs_budget_req req;
+
+	ubifs_assert(PagePrivate(page));
+	if (offset)
+		/* Partial page remains dirty */
+		return;
+
+	memset(&req, 0, sizeof(struct ubifs_budget_req));
+	if (PageChecked(page)) {
+		req.new_page = 1;
+		req.idx_growth = -1;
+		req.data_growth = c->page_budget;
+	} else
+		req.dd_growth = c->page_budget;
+	ubifs_release_budget(c, &req);
+
+	atomic_long_dec(&c->dirty_pg_cnt);
+	ClearPagePrivate(page);
+	ClearPageChecked(page);
+}
+
+static void *ubifs_follow_link(struct dentry *dentry, struct nameidata *nd)
+{
+	struct ubifs_inode *ui = ubifs_inode(dentry->d_inode);
+
+	nd_set_link(nd, ui->data);
+	return NULL;
+}
+
+int ubifs_fsync(struct file *file, struct dentry *dentry, int datasync)
+{
+	struct inode *inode = dentry->d_inode;
+	struct ubifs_info *c = inode->i_sb->s_fs_info;
+	int err;
+
+	dbg_gen("syncing inode %lu", inode->i_ino);
+
+	/* Synchronize the inode and dirty pages */
+	err = write_inode_now(inode, 1);
+	if (err)
+		return err;
+
+	/*
+	 * Some data related to this inode may still sit in a write-buffer.
+	 * Flush them.
+	 */
+	err = ubifs_sync_wbufs_by_inodes(c, &inode, 1);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+/**
+ * mctime_update_needed - check if mtime or ctime update is needed.
+ * @inode: the inode to do the check for
+ * @now: current time
+ *
+ * This helper function checks if the inode mtime/ctime should be updated or
+ * not. If current values of the time-stamps are within the UBIFS inode time
+ * granularity, they are not updated. This is an optimization.
+ */
+static inline int mctime_update_needed(const struct inode *inode,
+				       const struct timespec *now)
+{
+	if (!timespec_equal(&inode->i_mtime, now) ||
+	    !timespec_equal(&inode->i_ctime, now))
+		return 1;
+	return 0;
+}
+
+/**
+ * update_ctime - update mtime and ctime of an inode.
+ * @c: UBIFS file-system description object
+ * @inode: inode to update
+ *
+ * This function updates mtime and ctime of the inode if it is not equivalent to
+ * current time. Returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+static int update_mctime(struct ubifs_info *c, struct inode *inode)
+{
+	struct timespec now = ubifs_current_time(inode);
+
+	if (mctime_update_needed(inode, &now)) {
+		struct ubifs_budget_req req;
+		int err;
+
+		memset(&req, 0, sizeof(struct ubifs_budget_req));
+		err = ubifs_budget_inode_op(c, inode, &req);
+		if (err)
+			return err;
+
+		inode->i_mtime = inode->i_ctime = now;
+		mark_inode_dirty_sync(inode);
+		mutex_unlock(&ubifs_inode(inode)->budg_mutex);
+	}
+
+	return 0;
+}
+
+static ssize_t ubifs_write(struct file *file, const char __user *buf,
+			   size_t len, loff_t *ppos)
+{
+	int err;
+	ssize_t ret;
+	struct inode *inode = file->f_mapping->host;
+	struct ubifs_info *c = inode->i_sb->s_fs_info;
+
+	err = update_mctime(c, inode);
+	if (err)
+		return err;
+
+	ret = do_sync_write(file, buf, len, ppos);
+	if (ret < 0)
+		return ret;
+
+	if (ret > 0 && IS_SYNC(inode)) {
+		err = ubifs_sync_wbufs_by_inodes(c, &inode, 1);
+		if (err)
+			return err;
+	}
+
+	return ret;
+}
+
+static ssize_t ubifs_aio_write(struct kiocb *iocb, const struct iovec *iov,
+			       unsigned long nr_segs, loff_t pos)
+{
+	int err;
+	ssize_t ret;
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	struct ubifs_info *c = inode->i_sb->s_fs_info;
+
+	err = update_mctime(c, inode);
+	if (err)
+		return err;
+
+	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
+	if (ret < 0)
+		return ret;
+
+	if (ret > 0 && IS_SYNC(inode)) {
+		err = ubifs_sync_wbufs_by_inodes(c, &inode, 1);
+		if (err)
+			return err;
+	}
+
+	return ret;
+}
+
+static int ubifs_set_page_dirty(struct page *page)
+{
+	int ret;
+
+	ret = __set_page_dirty_nobuffers(page);
+	/*
+	 * An attempt to dirty a page without budgeting for it - should not
+	 * happen.
+	 */
+	ubifs_assert(ret == 0);
+	return ret;
+}
+
+static int ubifs_releasepage(struct page *page, gfp_t unused_gfp_flags)
+{
+	/*
+	 * An attempt to release a dirty page without budgeting for it - should
+	 * not happen.
+	 */
+	if (PageWriteback(page))
+		return 0;
+	ubifs_assert(PagePrivate(page));
+	ubifs_assert(0);
+	ClearPagePrivate(page);
+	ClearPageChecked(page);
+	return 1;
+}
+
+/*
+ * mmap()d file has taken write protection fault and is being made
+ * writable. UBIFS must ensure page is budgeted for.
+ */
+static int ubifs_vm_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+{
+	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
+	struct ubifs_info *c = inode->i_sb->s_fs_info;
+	struct timespec now = ubifs_current_time(inode);
+	struct ubifs_budget_req req = { .new_page = 1 };
+	int err, update_time;
+
+	dbg_gen("ino %lu, pg %lu, i_size %lld",	inode->i_ino, page->index,
+		i_size_read(inode));
+	ubifs_assert(!(inode->i_sb->s_flags & MS_RDONLY));
+
+	if (unlikely(c->ro_media))
+		return -EROFS;
+
+	/*
+	 * We have not locked @page so far so we may budget for changing the
+	 * page. Note, we cannot do this after we locked the page, because
+	 * budgeting may cause write-back which would cause deadlock.
+	 *
+	 * At the moment we do not know whether the page is dirty or not, so we
+	 * assume that it is not and budget for a new page. We could look at
+	 * the @PG_private flag and figure this out, but we may race with write
+	 * back and the page state may change by the time we lock it, so this
+	 * would need additional care. We do not bother with this at the
+	 * moment, although it might be good idea to do. Instead, we allocate
+	 * budget for a new page and amend it later on if the page was in fact
+	 * dirty.
+	 *
+	 * The budgeting-related logic of this function is similar to what we
+	 * do in 'ubifs_write_begin()' and 'ubifs_write_end()'. Glance there
+	 * for more comments.
+	 */
+	if (mctime_update_needed(inode, &now)) {
+		/*
+		 * We have to change inode time stamp which requires extra
+		 * budgeting.
+		 */
+		update_time = 1;
+		err = ubifs_budget_inode_op(c, inode, &req);
+	} else {
+		update_time = 0;
+		err = ubifs_budget_space(c, &req);
+	}
+	if (unlikely(err)) {
+		if (err == -ENOSPC)
+			ubifs_warn("out of space for mmapped file "
+				   "(inode number %lu)", inode->i_ino);
+		return err;
+	}
+
+	lock_page(page);
+	if (unlikely(page->mapping != inode->i_mapping ||
+		     page_offset(page) > i_size_read(inode))) {
+		/* Page got truncated out from underneath us */
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (PagePrivate(page))
+		ubifs_release_new_page_budget(c);
+	else {
+		if (!PageChecked(page))
+			ubifs_convert_page_budget(c);
+		SetPagePrivate(page);
+		atomic_long_inc(&c->dirty_pg_cnt);
+		__set_page_dirty_nobuffers(page);
+	}
+
+	if (update_time) {
+		inode->i_mtime = inode->i_ctime = now;
+		mark_inode_dirty_sync(inode);
+		mutex_unlock(&ubifs_inode(inode)->budg_mutex);
+	}
+
+	unlock_page(page);
+	return 0;
+
+out_unlock:
+	unlock_page(page);
+	if (update_time)
+		ubifs_cancel_ino_op(c, inode, &req);
+	else
+		ubifs_release_budget(c, &req);
+	return err;
+}
+
+struct vm_operations_struct ubifs_file_vm_ops = {
+	.fault        = filemap_fault,
+	.page_mkwrite = ubifs_vm_page_mkwrite,
+};
+
+static int ubifs_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	int err;
+
+	/* 'generic_file_mmap()' takes care of NOMMU case */
+	err = generic_file_mmap(file, vma);
+	if (err)
+		return err;
+	vma->vm_ops = &ubifs_file_vm_ops;
+	return 0;
+}
+
+struct address_space_operations ubifs_file_address_operations = {
+	.readpage       = ubifs_readpage,
+	.writepage      = ubifs_writepage,
+	.write_begin    = ubifs_write_begin,
+	.write_end      = ubifs_write_end,
+	.invalidatepage = ubifs_invalidatepage,
+	.set_page_dirty = ubifs_set_page_dirty,
+	.releasepage    = ubifs_releasepage,
+};
+
+struct inode_operations ubifs_file_inode_operations = {
+	.setattr     = ubifs_setattr,
+	.getattr     = ubifs_getattr,
+#ifdef CONFIG_UBIFS_FS_XATTR
+	.setxattr    = ubifs_setxattr,
+	.getxattr    = ubifs_getxattr,
+	.listxattr   = ubifs_listxattr,
+	.removexattr = ubifs_removexattr,
+#endif
+};
+
+struct inode_operations ubifs_symlink_inode_operations = {
+	.readlink    = generic_readlink,
+	.follow_link = ubifs_follow_link,
+	.setattr     = ubifs_setattr,
+	.getattr     = ubifs_getattr,
+};
+
+struct file_operations ubifs_file_operations = {
+	.llseek         = generic_file_llseek,
+	.read           = do_sync_read,
+	.write          = ubifs_write,
+	.aio_read       = generic_file_aio_read,
+	.aio_write      = ubifs_aio_write,
+	.mmap           = ubifs_file_mmap,
+	.fsync          = ubifs_fsync,
+	.unlocked_ioctl = ubifs_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl   = ubifs_compat_ioctl,
+#endif
+};
diff --git a/fs/ubifs/ioctl.c b/fs/ubifs/ioctl.c
new file mode 100644
index 0000000..80a2ab4
--- /dev/null
+++ b/fs/ubifs/ioctl.c
@@ -0,0 +1,212 @@
+/*
+ * This file is part of UBIFS.
+ *
+ * Copyright (C) 2006-2008 Nokia Corporation.
+ * Copyright (C) 2006, 2007 University of Szeged, Hungary
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ * Authors: Zoltan Sogor
+ *          Artem Bityutskiy (Битюцкий Артём)
+ *          Adrian Hunter
+ */
+
+/* This file implements EXT2-compatible extended attribute ioctl() calls */
+
+#include <linux/compat.h>
+#include <linux/smp_lock.h>
+#include <linux/mount.h>
+#include "ubifs.h"
+
+/**
+ * ubifs_set_inode_flags - set VFS inode flags.
+ * @inode: VFS inode to set flags for
+ *
+ * This function propagates flags from UBIFS inode object to VFS inode object.
+ */
+void ubifs_set_inode_flags(struct inode *inode)
+{
+	unsigned int flags = ubifs_inode(inode)->flags;
+
+	inode->i_flags &= ~(S_SYNC | S_APPEND | S_IMMUTABLE | S_DIRSYNC);
+	if (flags & UBIFS_SYNC_FL)
+		inode->i_flags |= S_SYNC;
+	if (flags & UBIFS_APPEND_FL)
+		inode->i_flags |= S_APPEND;
+	if (flags & UBIFS_IMMUTABLE_FL)
+		inode->i_flags |= S_IMMUTABLE;
+	if (flags & UBIFS_DIRSYNC_FL)
+		inode->i_flags |= S_DIRSYNC;
+}
+
+/*
+ * ioctl2ubifs - convert ioctl inode flags to UBIFS inode flags.
+ * @ioctl_flags: flags to convert
+ *
+ * This function convert ioctl flags (@FS_COMPR_FL, etc) to UBIFS inode flags
+ * (@UBIFS_COMPR_FL, etc).
+ */
+static int ioctl2ubifs(int ioctl_flags)
+{
+	int ubifs_flags = 0;
+
+	if (ioctl_flags & FS_COMPR_FL)
+		ubifs_flags |= UBIFS_COMPR_FL;
+	if (ioctl_flags & FS_SYNC_FL)
+		ubifs_flags |= UBIFS_SYNC_FL;
+	if (ioctl_flags & FS_APPEND_FL)
+		ubifs_flags |= UBIFS_APPEND_FL;
+	if (ioctl_flags & FS_IMMUTABLE_FL)
+		ubifs_flags |= UBIFS_IMMUTABLE_FL;
+	if (ioctl_flags & FS_DIRSYNC_FL)
+		ubifs_flags |= UBIFS_DIRSYNC_FL;
+
+	return ubifs_flags;
+}
+
+/*
+ * ubifs2ioctl - convert UBIFS inode flags to ioctl inode flags.
+ * @ubifs_flags: flags to convert
+ *
+ * This function convert UBIFS (@UBIFS_COMPR_FL, etc) to ioctl flags
+ * (@FS_COMPR_FL, etc).
+ */
+static int ubifs2ioctl(int ubifs_flags)
+{
+	int ioctl_flags = 0;
+
+	if (ubifs_flags & UBIFS_COMPR_FL)
+		ioctl_flags |= FS_COMPR_FL;
+	if (ubifs_flags & UBIFS_SYNC_FL)
+		ioctl_flags |= FS_SYNC_FL;
+	if (ubifs_flags & UBIFS_APPEND_FL)
+		ioctl_flags |= FS_APPEND_FL;
+	if (ubifs_flags & UBIFS_IMMUTABLE_FL)
+		ioctl_flags |= FS_IMMUTABLE_FL;
+	if (ubifs_flags & UBIFS_DIRSYNC_FL)
+		ioctl_flags |= FS_DIRSYNC_FL;
+
+	return ioctl_flags;
+}
+
+static int setflags(struct inode *inode, int flags)
+{
+	struct ubifs_inode *ui = ubifs_inode(inode);
+	struct ubifs_info *c = inode->i_sb->s_fs_info;
+	struct ubifs_budget_req req;
+	int oldflags, err;
+
+	mutex_lock(&inode->i_mutex);
+	memset(&req, 0 , sizeof(struct ubifs_budget_req));
+	err = ubifs_budget_inode_op(c, inode, &req);
+	if (err)
+		goto out;
+
+	/*
+	 * The IMMUTABLE and APPEND_ONLY flags can only be changed by
+	 * the relevant capability.
+	 */
+	oldflags = ubifs2ioctl(ui->flags);
+	if ((flags ^ oldflags) & (FS_APPEND_FL | FS_IMMUTABLE_FL)) {
+		if (!capable(CAP_LINUX_IMMUTABLE)) {
+			err = -EPERM;
+			goto out_budg;
+		}
+	}
+
+	ui->flags = ioctl2ubifs(flags);
+	ubifs_set_inode_flags(inode);
+
+	inode->i_ctime = ubifs_current_time(inode);
+	mark_inode_dirty_sync(inode);
+
+	ubifs_release_ino_dirty(c, inode, &req);
+
+	if (IS_SYNC(inode))
+		err = write_inode_now(inode, 1);
+	mutex_unlock(&inode->i_mutex);
+	return err;
+
+out_budg:
+	ubifs_cancel_ino_op(c, inode, &req);
+out:
+	ubifs_err("can't modify inode %lu attributes", inode->i_ino);
+	mutex_unlock(&inode->i_mutex);
+	return err;
+}
+
+long ubifs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int flags, err;
+	struct inode *inode = file->f_path.dentry->d_inode;
+
+	switch (cmd) {
+	case FS_IOC_GETFLAGS:
+		flags = ubifs2ioctl(ubifs_inode(inode)->flags);
+
+		return put_user(flags, (int __user *) arg);
+
+	case FS_IOC_SETFLAGS: {
+		if (IS_RDONLY(inode))
+			return -EROFS;
+
+		if (!is_owner_or_cap(inode))
+			return -EACCES;
+
+		if (get_user(flags, (int __user *) arg))
+			return -EFAULT;
+
+		if (!S_ISDIR(inode->i_mode))
+			flags &= ~FS_DIRSYNC_FL;
+
+		/*
+		 * Make sure the file-system is read-write and make sure it
+		 * will not become read-only while we are changing the flags.
+		 */
+		err = mnt_want_write(file->f_path.mnt);
+		if (err)
+			return err;
+		err = setflags(inode, flags);
+		mnt_drop_write(file->f_path.mnt);
+		return err;
+	}
+
+	default:
+		return -ENOTTY;
+	}
+}
+
+#ifdef CONFIG_COMPAT
+long ubifs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int err;
+
+	switch (cmd) {
+	case FS_IOC32_GETFLAGS:
+		cmd = FS_IOC_GETFLAGS;
+		break;
+	case FS_IOC32_SETFLAGS:
+		cmd = FS_IOC_SETFLAGS;
+		break;
+	default:
+		return -ENOIOCTLCMD;
+	}
+
+	lock_kernel();
+	err = ubifs_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+	unlock_kernel();
+
+	return err;
+}
+#endif
-- 
1.5.4.1


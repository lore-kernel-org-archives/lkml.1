Return-Path: <linux-kernel-owner+w=401wt.eu-S1760789AbYDCRLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbYDCRLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760012AbYDCRKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:10:31 -0400
Received: from lazybastard.de ([212.112.238.170]:43592 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759883AbYDCRK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:10:26 -0400
Message-Id: <20080401181332.853833005@logfs.org>
References: <20080401181308.512473173@logfs.org>
Date: Tue, 01 Apr 2008 20:13:08 +0200
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [patch 5/15] fs/logfs/dir.c
From: joern@logfs.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2008-03-30 12:15:48.586669308 +0200
+++ linux-2.6.24logfs/fs/logfs/dir.c	2008-03-28 18:26:06.154955960 +0100
@@ -0,0 +1,765 @@
+/*
+ * fs/logfs/dir.c	- directory-related code
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ */
+#include "logfs.h"
+
+
+/*
+ * Atomic dir operations
+ *
+ * Directory operations are by default not atomic.  Dentries and Inodes are
+ * created/removed/altered in seperate operations.  Therefore we need to do
+ * a small amount of journaling.
+ *
+ * Create, link, mkdir, mknod and symlink all share the same function to do
+ * the work: __logfs_create.  This function works in two atomic steps:
+ * 1. allocate inode (remember in journal)
+ * 2. allocate dentry (clear journal)
+ *
+ * As we can only get interrupted between the two, when the inode we just
+ * created is simply stored in the anchor.  On next mount, if we were
+ * interrupted, we delete the inode.  From a users point of view the
+ * operation never happened.
+ *
+ * Unlink and rmdir also share the same function: unlink.  Again, this
+ * function works in two atomic steps
+ * 1. remove dentry (remember inode in journal)
+ * 2. unlink inode (clear journal)
+ *
+ * And again, on the next mount, if we were interrupted, we delete the inode.
+ * From a users point of view the operation succeeded.
+ *
+ * Rename is the real pain to deal with, harder than all the other methods
+ * combined.  Depending on the circumstances we can run into three cases.
+ * A "target rename" where the target dentry already existed, a "local
+ * rename" where both parent directories are identical or a "cross-directory
+ * rename" in the remaining case.
+ *
+ * Local rename is atomic, as the old dentry is simply rewritten with a new
+ * name.
+ *
+ * Cross-directory rename works in two steps, similar to __logfs_create and
+ * logfs_unlink:
+ * 1. Write new dentry (remember old dentry in journal)
+ * 2. Remove old dentry (clear journal)
+ *
+ * Here we remember a dentry instead of an inode.  On next mount, if we were
+ * interrupted, we delete the dentry.  From a users point of view, the
+ * operation succeeded.
+ *
+ * Target rename works in three atomic steps:
+ * 1. Attach old inode to new dentry (remember old dentry and new inode)
+ * 2. Remove old dentry (still remember the new inode)
+ * 3. Remove victim inode
+ *
+ * Here we remember both an inode an a dentry.  If we get interrupted
+ * between steps 1 and 2, we delete both the dentry and the inode.  If
+ * we get interrupted between steps 2 and 3, we delete just the inode.
+ * In either case, the remaining objects are deleted on next mount.  From
+ * a users point of view, the operation succeeded.
+ */
+
+typedef int (*dir_callback)(struct inode *dir, struct dentry *dentry,
+		struct logfs_disk_dentry *dd, loff_t pos, void *arg);
+
+static inline void logfs_inc_count(struct inode *inode)
+{
+	inode->i_nlink++;
+	mark_inode_dirty_sync(inode);
+}
+
+static inline void logfs_dec_count(struct inode *inode)
+{
+	inode->i_nlink--;
+	mark_inode_dirty_sync(inode);
+}
+
+static int read_dir(struct inode *dir, struct logfs_disk_dentry *dd, loff_t pos)
+{
+	return logfs_inode_read(dir, dd, sizeof(*dd), pos);
+}
+
+static int write_dir(struct inode *dir, struct logfs_disk_dentry *dd,
+		loff_t pos, struct logfs_transaction *ta)
+{
+	return logfs_inode_write(dir, dd, sizeof(*dd), pos,
+			WF_SYNC|WF_LOCK, ta, NULL);
+}
+
+static int write_inode(struct inode *inode)
+{
+	return __logfs_write_inode(inode, WF_LOCK|WF_SYNC);
+}
+
+static s64 dir_seek_data(struct inode *inode, s64 pos)
+{
+	s64 new_pos = logfs_seek_data(inode, pos);
+
+	return max(pos, new_pos - 1);
+}
+
+static int __logfs_dir_walk(struct inode *dir, struct dentry *dentry,
+		dir_callback handler, void *arg,
+		struct logfs_disk_dentry *dd, loff_t *pos)
+{
+	struct qstr *name = dentry ? &dentry->d_name : NULL;
+	int ret;
+
+	for (; ; (*pos)++) {
+		ret = read_dir(dir, dd, *pos);
+		if (ret == -EOF)
+			return 0;
+		if (ret == -ENODATA) {
+			/* deleted dentry */
+			*pos = dir_seek_data(dir, *pos);
+			continue;
+		}
+		if (ret)
+			return ret;
+		BUG_ON(dd->namelen == 0);
+
+		if (name) {
+			if (name->len != be16_to_cpu(dd->namelen))
+				continue;
+			if (memcmp(name->name, dd->name, name->len))
+				continue;
+		}
+
+		return handler(dir, dentry, dd, *pos, arg);
+	}
+	return ret;
+}
+
+static int logfs_dir_walk(struct inode *dir, struct dentry *dentry,
+		dir_callback handler, void *arg)
+{
+	struct logfs_disk_dentry dd;
+	loff_t pos = 0;
+
+	return __logfs_dir_walk(dir, dentry, handler, arg, &dd, &pos);
+}
+
+static int logfs_lookup_handler(struct inode *dir, struct dentry *dentry,
+		struct logfs_disk_dentry *dd, loff_t pos, void *arg)
+{
+	struct inode *inode;
+
+	inode = iget(dir->i_sb, be64_to_cpu(dd->ino));
+	if (!inode)
+		return -EIO;
+	return PTR_ERR(d_splice_alias(inode, dentry));
+}
+
+static struct dentry *logfs_lookup(struct inode *dir, struct dentry *dentry,
+		struct nameidata *nd)
+{
+	return ERR_PTR(logfs_dir_walk(dir, dentry, logfs_lookup_handler, NULL));
+}
+
+static int logfs_unlink_handler(struct inode *dir, struct dentry *dentry,
+		struct logfs_disk_dentry *dd, loff_t pos, void *ta)
+{
+	return logfs_delete(dir, pos, NULL, ta);
+}
+
+static int logfs_remove_inode(struct inode *inode)
+{
+	int ret;
+
+	inode->i_nlink--;
+	if (S_ISDIR(inode->i_mode))
+		inode->i_nlink--;
+	ret = write_inode(inode);
+	LOGFS_BUG_ON(ret, inode->i_sb);
+	return ret;
+}
+
+static void abort_transaction(struct inode *inode, struct logfs_transaction *ta)
+{
+	logfs_inode(inode)->li_transaction = NULL;
+	kfree(ta);
+}
+
+static int logfs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct logfs_super *super = logfs_super(dir->i_sb);
+	struct inode *inode = dentry->d_inode;
+	struct logfs_transaction *ta;
+	int ret;
+
+	ta = kzalloc(sizeof(*ta), GFP_KERNEL);
+	if (!ta)
+		return -ENOMEM;
+
+	ta->state = UNLINK_1;
+	ta->ino = inode->i_ino;
+
+	if (S_ISDIR(inode->i_mode))
+		dir->i_nlink--;
+	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+	mutex_lock(&super->s_dirop_mutex);
+	ret = logfs_dir_walk(dir, dentry, logfs_unlink_handler, ta);
+	if (!ret)
+		ret = write_inode(dir);
+
+	if (ret) {
+		super->s_victim_ino = 0;
+		abort_transaction(dir, ta);
+		printk(KERN_ERR"LOGFS: unable to delete inode\n");
+		if (S_ISDIR(inode->i_mode))
+			logfs_inc_count(dir);
+		goto out;
+	}
+
+	ta->state = UNLINK_2;
+	logfs_inode(inode)->li_transaction = ta;
+	ret = logfs_remove_inode(inode);
+out:
+	mutex_unlock(&super->s_dirop_mutex);
+	return ret;
+}
+
+static int logfs_empty_handler(struct inode *dir, struct dentry *dentry,
+		struct logfs_disk_dentry *dd, loff_t pos, void *arg)
+{
+	return -ENOTEMPTY;
+}
+
+static inline int logfs_empty_dir(struct inode *dir)
+{
+	return logfs_dir_walk(dir, NULL, logfs_empty_handler, NULL) == 0;
+}
+
+static int logfs_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+
+	if (!logfs_empty_dir(inode))
+		return -ENOTEMPTY;
+
+	return logfs_unlink(dir, dentry);
+}
+
+/* FIXME: readdir currently has it's own dir_walk code.  I don't see a good
+ * way to combine the two copies */
+#define IMPLICIT_NODES 2
+static int __logfs_readdir(struct file *file, void *buf, filldir_t filldir)
+{
+	struct logfs_disk_dentry dd;
+	struct inode *dir = file->f_dentry->d_inode;
+	loff_t pos = file->f_pos - IMPLICIT_NODES;
+	int err;
+
+	BUG_ON(pos < 0);
+	for (;; pos++) {
+		err = read_dir(dir, &dd, pos);
+		if (err == -EOF)
+			break;
+		if (err == -ENODATA) {
+			/* deleted dentry */
+			pos = dir_seek_data(dir, pos);
+			continue;
+		}
+		if (err)
+			return err;
+		BUG_ON(dd.namelen == 0);
+
+		if (filldir(buf, dd.name, be16_to_cpu(dd.namelen), pos,
+					be64_to_cpu(dd.ino), dd.type))
+			break;
+	}
+
+	file->f_pos = pos + IMPLICIT_NODES;
+	return 0;
+}
+
+static int logfs_readdir(struct file *file, void *buf, filldir_t filldir)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	ino_t pino = parent_ino(file->f_dentry);
+	int err;
+
+	if (file->f_pos < 0)
+		return -EINVAL;
+
+	if (file->f_pos == 0) {
+		if (filldir(buf, ".", 1, 1, inode->i_ino, DT_DIR) < 0)
+			return 0;
+		file->f_pos++;
+	}
+	if (file->f_pos == 1) {
+		if (filldir(buf, "..", 2, 2, pino, DT_DIR) < 0)
+			return 0;
+		file->f_pos++;
+	}
+
+	err = __logfs_readdir(file, buf, filldir);
+	return err;
+}
+
+static void logfs_set_name(struct logfs_disk_dentry *dd, struct qstr *name)
+{
+	dd->namelen = cpu_to_be16(name->len);
+	memcpy(dd->name, name->name, name->len);
+}
+
+static int logfs_write_dir(struct inode *dir, struct dentry *dentry,
+		struct inode *inode, struct logfs_transaction *ta)
+{
+	struct logfs_disk_dentry dd;
+	int err;
+
+	if (dentry->d_name.len > LOGFS_MAX_NAMELEN)
+		return -ENAMETOOLONG;
+
+	memset(&dd, 0, sizeof(dd));
+	dd.ino = cpu_to_be64(inode->i_ino);
+	dd.type = logfs_type(inode);
+	logfs_set_name(&dd, &dentry->d_name);
+
+	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+	/*
+	 * FIXME: the file size should actually get aligned when writing,
+	 * not when reading.
+	 */
+	err = write_dir(dir, &dd, logfs_seek_hole(dir, 0), ta);
+	if (err)
+		return err;
+	return 0;
+}
+
+static int __logfs_create(struct inode *dir, struct dentry *dentry,
+		struct inode *inode, const char *dest, long destlen)
+{
+	struct logfs_super *super = logfs_super(dir->i_sb);
+	struct logfs_inode *li = logfs_inode(inode);
+	struct logfs_transaction *ta;
+	int ret;
+
+	ta = kzalloc(sizeof(*ta), GFP_KERNEL);
+	if (!ta)
+		return -ENOMEM;
+
+	ta->state = CREATE_1;
+	mutex_lock(&super->s_dirop_mutex);
+	ta->ino = inode->i_ino;
+	if (S_ISDIR(inode->i_mode))
+		inode->i_nlink++;
+
+	if (dest) {
+		/* symlink */
+		ret = logfs_inode_write(inode, dest, destlen, 0,
+				WF_SYNC|WF_LOCK, ta, NULL);
+		if (!ret)
+			ret = write_inode(inode);
+	} else {
+		/* creat/mkdir/mknod */
+		super->s_victim_ino = inode->i_ino;
+		ret = write_inode(inode);
+	}
+	if (ret) {
+		super->s_victim_ino = 0;
+		abort_transaction(inode, ta);
+		li->li_flags |= LOGFS_IF_STILLBORN;
+		/* FIXME: truncate symlink */
+		inode->i_nlink--;
+		iput(inode);
+		goto out;
+	}
+
+	ta->state = CREATE_2;
+	if (S_ISDIR(inode->i_mode))
+		dir->i_nlink++;
+	ret = logfs_write_dir(dir, dentry, inode, ta);
+	/* sync directory */
+	if (!ret)
+		ret = write_inode(dir);
+
+	if (ret) {
+		super->s_victim_ino = 0;
+		abort_transaction(dir, ta);
+		if (S_ISDIR(inode->i_mode))
+			dir->i_nlink--;
+		logfs_remove_inode(inode);
+		iput(inode);
+		goto out;
+	}
+	d_instantiate(dentry, inode);
+out:
+	mutex_unlock(&super->s_dirop_mutex);
+	return ret;
+}
+
+static int logfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	struct inode *inode;
+
+	if (dir->i_nlink >= LOGFS_LINK_MAX)
+		return -EMLINK;
+
+	/*
+	 * FIXME: why do we have to fill in S_IFDIR, while the mode is
+	 * correct for mknod, creat, etc.?  Smells like the vfs *should*
+	 * do it for us but for some reason fails to do so.
+	 */
+	inode = logfs_new_inode(dir, S_IFDIR | mode);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	inode->i_op = &logfs_dir_iops;
+	inode->i_fop = &logfs_dir_fops;
+
+	return __logfs_create(dir, dentry, inode, NULL, 0);
+}
+
+static int logfs_create(struct inode *dir, struct dentry *dentry, int mode,
+		struct nameidata *nd)
+{
+	struct inode *inode;
+
+	inode = logfs_new_inode(dir, mode);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	inode->i_op = &logfs_reg_iops;
+	inode->i_fop = &logfs_reg_fops;
+	inode->i_mapping->a_ops = &logfs_reg_aops;
+
+	return __logfs_create(dir, dentry, inode, NULL, 0);
+}
+
+static int logfs_mknod(struct inode *dir, struct dentry *dentry, int mode,
+		dev_t rdev)
+{
+	struct inode *inode;
+
+	if (dentry->d_name.len > LOGFS_MAX_NAMELEN)
+		return -ENAMETOOLONG;
+
+	inode = logfs_new_inode(dir, mode);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	init_special_inode(inode, mode, rdev);
+
+	return __logfs_create(dir, dentry, inode, NULL, 0);
+}
+
+static int logfs_symlink(struct inode *dir, struct dentry *dentry,
+		const char *target)
+{
+	struct inode *inode;
+	size_t destlen = strlen(target) + 1;
+
+	if (destlen > dir->i_sb->s_blocksize)
+		return -ENAMETOOLONG;
+
+	inode = logfs_new_inode(dir, S_IFLNK | S_IRWXUGO);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	inode->i_op = &logfs_symlink_iops;
+	inode->i_mapping->a_ops = &logfs_reg_aops;
+
+	return __logfs_create(dir, dentry, inode, target, destlen);
+}
+
+static int logfs_permission(struct inode *inode, int mask, struct nameidata *nd)
+{
+	return generic_permission(inode, mask, NULL);
+}
+
+static int logfs_link(struct dentry *old_dentry, struct inode *dir,
+		struct dentry *dentry)
+{
+	struct inode *inode = old_dentry->d_inode;
+
+	if (inode->i_nlink >= LOGFS_LINK_MAX)
+		return -EMLINK;
+
+	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+	atomic_inc(&inode->i_count);
+	logfs_inc_count(inode);
+
+	return __logfs_create(dir, dentry, inode, NULL, 0);
+}
+
+static int logfs_nop_handler(struct inode *dir, struct dentry *dentry,
+		struct logfs_disk_dentry *dd, loff_t pos, void *arg)
+{
+	return 0;
+}
+
+static inline int logfs_get_dd(struct inode *dir, struct dentry *dentry,
+		struct logfs_disk_dentry *dd, loff_t *pos)
+{
+	*pos = 0;
+	return __logfs_dir_walk(dir, dentry, logfs_nop_handler, NULL, dd, pos);
+}
+
+/* Easiest case, a local rename and the target doesn't exist.  Just change
+ * the name in the old dd.
+ */
+static int logfs_rename_local(struct inode *dir, struct dentry *old_dentry,
+		struct dentry *new_dentry)
+{
+	struct logfs_disk_dentry dd;
+	loff_t pos;
+	int err;
+
+	err = logfs_get_dd(dir, old_dentry, &dd, &pos);
+	if (err)
+		return err;
+
+	logfs_set_name(&dd, &new_dentry->d_name);
+	return write_dir(dir, &dd, pos, NULL);
+}
+
+static int logfs_delete_dd(struct inode *dir, struct logfs_disk_dentry *dd,
+		loff_t pos, struct logfs_transaction *ta)
+{
+	int err;
+
+	err = read_dir(dir, dd, pos);
+
+	/*
+	 * Getting called with pos somewhere beyond eof is either a goofup
+	 * within this file or means someone maliciously edited the
+	 * (crc-protected) journal.
+	 */
+	LOGFS_BUG_ON(err == -EOF, dir->i_sb);
+	if (err)
+		return err;
+
+	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+	if (dd->type == DT_DIR)
+		dir->i_nlink--;
+	return logfs_delete(dir, pos, NULL, ta);
+}
+
+/*
+ * Cross-directory rename, target does not exist.  Just a little nasty.
+ * Create a new dentry in the target dir, then remove the old dentry,
+ * all the while taking care to remember our operation in the journal.
+ */
+static int logfs_rename_cross(struct inode *old_dir, struct dentry *old_dentry,
+			      struct inode *new_dir, struct dentry *new_dentry)
+{
+	struct logfs_super *super = logfs_super(old_dir->i_sb);
+	struct logfs_disk_dentry dd;
+	struct logfs_transaction *ta;
+	loff_t pos;
+	int err;
+
+	/* 1. locate source dd */
+	err = logfs_get_dd(old_dir, old_dentry, &dd, &pos);
+	if (err)
+		return err;
+
+	ta = kzalloc(sizeof(*ta), GFP_KERNEL);
+	if (!ta)
+		return -ENOMEM;
+
+	ta->state = CROSS_RENAME_1;
+	ta->dir = old_dir->i_ino;
+	ta->pos = pos;
+
+	/* 2. write target dd */
+	if (dd.type == DT_DIR)
+		new_dir->i_nlink++;
+	mutex_lock(&super->s_dirop_mutex);
+	err = logfs_write_dir(new_dir, new_dentry, old_dentry->d_inode, ta);
+	if (!err)
+		err = write_inode(new_dir);
+
+	if (err) {
+		super->s_rename_dir = 0;
+		super->s_rename_pos = 0;
+		abort_transaction(new_dir, ta);
+		goto out;
+	}
+
+	ta->state = CROSS_RENAME_2;
+	/* 3. remove source dd */
+	err = logfs_delete_dd(old_dir, &dd, pos, ta);
+	if (!err)
+		err = write_inode(old_dir);
+	LOGFS_BUG_ON(err, old_dir->i_sb);
+out:
+	mutex_unlock(&super->s_dirop_mutex);
+	return err;
+}
+
+static int logfs_replace_inode(struct inode *dir, struct dentry *dentry,
+		struct logfs_disk_dentry *dd, struct inode *inode,
+		struct logfs_transaction *ta)
+{
+	loff_t pos;
+	int err;
+
+	err = logfs_get_dd(dir, dentry, dd, &pos);
+	if (err)
+		return err;
+	dd->ino = cpu_to_be64(inode->i_ino);
+	dd->type = logfs_type(inode);
+
+	err = write_dir(dir, dd, pos, ta);
+	if (err)
+		return err;
+	return write_inode(dir);
+}
+
+/* Target dentry exists - the worst case.  We need to attach the source
+ * inode to the target dentry, then remove the orphaned target inode and
+ * source dentry.
+ */
+static int logfs_rename_target(struct inode *old_dir, struct dentry *old_dentry,
+			       struct inode *new_dir, struct dentry *new_dentry)
+{
+	struct logfs_super *super = logfs_super(old_dir->i_sb);
+	struct inode *old_inode = old_dentry->d_inode;
+	struct inode *new_inode = new_dentry->d_inode;
+	int isdir = S_ISDIR(old_inode->i_mode);
+	struct logfs_disk_dentry dd;
+	struct logfs_transaction *ta;
+	loff_t pos;
+	int err;
+
+	BUG_ON(isdir != S_ISDIR(new_inode->i_mode));
+	if (isdir) {
+		if (!logfs_empty_dir(new_inode))
+			return -ENOTEMPTY;
+	}
+
+	/* 1. locate source dd */
+	err = logfs_get_dd(old_dir, old_dentry, &dd, &pos);
+	if (err)
+		return err;
+
+	ta = kzalloc(sizeof(*ta), GFP_KERNEL);
+	if (!ta)
+		return -ENOMEM;
+
+	ta->state = TARGET_RENAME_1;
+	ta->dir = old_dir->i_ino;
+	ta->pos = pos;
+	ta->ino = new_inode->i_ino;
+
+	/* 2. attach source inode to target dd */
+	mutex_lock(&super->s_dirop_mutex);
+	err = logfs_replace_inode(new_dir, new_dentry, &dd, old_inode, ta);
+	if (err) {
+		super->s_rename_dir = 0;
+		super->s_rename_pos = 0;
+		super->s_victim_ino = 0;
+		abort_transaction(new_dir, ta);
+		goto out;
+	}
+
+	/* 3. remove source dd */
+	ta->state = TARGET_RENAME_2;
+	err = logfs_delete_dd(old_dir, &dd, pos, ta);
+	if (!err)
+		err = write_inode(old_dir);
+	LOGFS_BUG_ON(err, old_dir->i_sb);
+
+	/* 4. remove target inode */
+	ta->state = TARGET_RENAME_3;
+	logfs_inode(new_inode)->li_transaction = ta;
+	err = logfs_remove_inode(new_inode);
+
+out:
+	mutex_unlock(&super->s_dirop_mutex);
+	return err;
+}
+
+static int logfs_rename(struct inode *old_dir, struct dentry *old_dentry,
+			struct inode *new_dir, struct dentry *new_dentry)
+{
+	if (new_dentry->d_inode)
+		return logfs_rename_target(old_dir, old_dentry,
+					   new_dir, new_dentry);
+	else if (old_dir == new_dir)
+		return logfs_rename_local(old_dir, old_dentry, new_dentry);
+	return logfs_rename_cross(old_dir, old_dentry, new_dir, new_dentry);
+}
+
+/* No locking done here, as this is called before .get_sb() returns. */
+int logfs_replay_journal(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct logfs_disk_dentry dd;
+	struct inode *inode;
+	u64 ino, pos;
+	int err;
+
+	if (super->s_victim_ino) {
+		/* delete victim inode */
+		ino = super->s_victim_ino;
+		printk(KERN_INFO"LogFS: delete unmapped inode #%llx\n", ino);
+		inode = iget(sb, ino);
+		if (!inode)
+			goto fail;
+
+		LOGFS_BUG_ON(i_size_read(inode) > 0, sb);
+		super->s_victim_ino = 0;
+		err = logfs_remove_inode(inode);
+		iput(inode);
+		if (err) {
+			super->s_victim_ino = ino;
+			goto fail;
+		}
+	}
+	if (super->s_rename_dir) {
+		/* delete old dd from rename */
+		ino = super->s_rename_dir;
+		pos = super->s_rename_pos;
+		printk(KERN_INFO"LogFS: delete unbacked dentry (%llx, %llx)\n",
+				ino, pos);
+		inode = iget(sb, ino);
+		if (!inode)
+			goto fail;
+
+		super->s_rename_dir = 0;
+		super->s_rename_pos = 0;
+		err = logfs_delete_dd(inode, &dd, pos, NULL);
+		iput(inode);
+		if (err) {
+			super->s_rename_dir = ino;
+			super->s_rename_pos = pos;
+			goto fail;
+		}
+	}
+	return 0;
+fail:
+	LOGFS_BUG(sb);
+	return -EIO;
+}
+
+const struct inode_operations logfs_symlink_iops = {
+	.readlink	= generic_readlink,
+	.follow_link	= page_follow_link_light,
+};
+
+const struct inode_operations logfs_dir_iops = {
+	.create		= logfs_create,
+	.link		= logfs_link,
+	.lookup		= logfs_lookup,
+	.mkdir		= logfs_mkdir,
+	.mknod		= logfs_mknod,
+	.rename		= logfs_rename,
+	.rmdir		= logfs_rmdir,
+	.permission	= logfs_permission,
+	.symlink	= logfs_symlink,
+	.unlink		= logfs_unlink,
+};
+const struct file_operations logfs_dir_fops = {
+	.fsync		= logfs_fsync,
+	.ioctl		= logfs_ioctl,
+	.readdir	= logfs_readdir,
+	.read		= generic_read_dir,
+};


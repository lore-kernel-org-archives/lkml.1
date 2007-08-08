Return-Path: <linux-kernel-owner+w=401wt.eu-S935215AbXHHQWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935215AbXHHQWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934053AbXHHQWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:22:40 -0400
Received: from lazybastard.de ([212.112.238.170]:42370 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932960AbXHHQWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:22:37 -0400
Date: Wed, 8 Aug 2007 18:18:41 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [Patch 08/18] fs/logfs/inode.c
Message-ID: <20070808161841.GJ15319@lazybastard.org>
References: <20070808161234.GB15319@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070808161234.GB15319@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2007-08-05 21:14:35.622844160 +0200
+++ linux-2.6.21logfs/fs/logfs/inode.c	2007-08-08 02:57:37.000000000 +0200
@@ -0,0 +1,514 @@
+/*
+ * fs/logfs/inode.c	- inode handling code
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ */
+#include "logfs.h"
+#include <linux/writeback.h>
+
+/*
+ * We need to include <linux/writeback.h> - a header we normally shouldn't
+ * be mucking with.  If life only were that easy!
+ *
+ * As it is, LogFS' requirement to read inodes for garbage collection keeps
+ * breaking Linux assumptions.  In particular, an inode can get be in
+ * I_DELETING state when being written out.  Logfs then notices that it
+ * needs some space, does a little GC and tries to read just the inode in
+ * I_DELETING state.  So the code is waiting for itself to finish, lovely.
+ *
+ * Our strategy to solve this problem is to overload the generic drop_inode()
+ * and destroy_inode() methods.  Writeback happens between those two calls,
+ * so add the inode to a list in drop_inode() and remove it again in
+ * destroy_inode().  Any iget() in the GC path is replaced with logfs_iget(),
+ * which will check the list and only call the blocking iget() if the inode
+ * in question cannot deadlock.
+ *
+ * And of course this would be racy if we didn't take inode_lock in a few
+ * key moments.
+ */
+static struct kmem_cache *logfs_inode_cache;
+
+static int __logfs_read_inode(struct inode *inode);
+
+static struct inode *__logfs_iget(struct super_block *sb, unsigned long ino)
+{
+	struct inode *inode = iget_locked(sb, ino);
+	int err;
+
+	if (inode && (inode->i_state & I_NEW)) {
+		err = __logfs_read_inode(inode);
+		unlock_new_inode(inode);
+		if (err) {
+			/* set i_nlink to 0 to prevent caching */
+			inode->i_nlink = 0;
+			logfs_inode(inode)->li_flags |= LOGFS_IF_ZOMBIE;
+			iput(inode);
+			return NULL;
+		}
+	}
+
+	return inode;
+}
+
+/*
+ * is_cached is set to 1 if we hand out a cached inode, 0 otherwise.
+ * this allows logfs_iput to do the right thing later
+ */
+struct inode *logfs_iget(struct super_block *sb, ino_t ino, int *is_cached)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct logfs_inode *li;
+
+	if (ino == LOGFS_INO_MASTER)
+		return super->s_master_inode;
+
+	spin_lock(&inode_lock);
+	list_for_each_entry(li, &super->s_freeing_list, li_freeing_list)
+		if (li->vfs_inode.i_ino == ino) {
+			spin_unlock(&inode_lock);
+			*is_cached = 1;
+			return &li->vfs_inode;
+		}
+	spin_unlock(&inode_lock);
+
+	*is_cached = 0;
+	return __logfs_iget(sb, ino);
+}
+
+void logfs_iput(struct inode *inode, int is_cached)
+{
+	if (inode->i_ino == LOGFS_INO_MASTER)
+		return;
+
+	if (is_cached)
+		return;
+
+	iput(inode);
+}
+
+static void logfs_init_inode(struct inode *inode)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	int i;
+
+	li->li_flags	= LOGFS_IF_VALID;
+	li->li_used_bytes = 0;
+	li->li_transaction = NULL;
+	inode->i_uid	= 0;
+	inode->i_gid	= 0;
+	inode->i_size	= 0;
+	inode->i_blocks	= 0;
+	inode->i_ctime	= CURRENT_TIME;
+	inode->i_mtime	= CURRENT_TIME;
+	inode->i_nlink	= 1;
+	INIT_LIST_HEAD(&li->li_freeing_list);
+
+	for (i=0; i<LOGFS_EMBEDDED_FIELDS; i++)
+		li->li_data[i] = 0;
+
+	return;
+}
+
+static struct inode *logfs_alloc_inode(struct super_block *sb)
+{
+	struct logfs_inode *li;
+
+	li = kmem_cache_alloc(logfs_inode_cache, GFP_KERNEL);
+	if (!li)
+		return NULL;
+	logfs_init_inode(&li->vfs_inode);
+	return &li->vfs_inode;
+}
+
+/*
+ * In logfs inodes are written to an inode file.  The inode file, like any
+ * other file, is managed with a inode.  The inode file's inode, aka master
+ * inode, requires special handling in several respects.  First, it cannot be
+ * written to the inode file, so it is stored in the journal instead.
+ *
+ * Secondly, this inode cannot be written back and destroyed before all other
+ * inodes have been written.  The ordering is important.  Linux' VFS is happily
+ * unaware of the ordering constraint and would ordinarily destroy the master
+ * inode at umount time while other inodes are still in use and dirty.  Not
+ * good.
+ *
+ * So logfs makes sure the master inode is not written until all other inodes
+ * have been destroyed.  Sadly, this method has another side-effect.  The VFS
+ * will notice one remaining inode and print a frightening warning message.
+ * Worse, it is impossible to judge whether such a warning was caused by the
+ * master inode or any other inodes have leaked as well.
+ *
+ * Our attempt of solving this is with logfs_new_meta_inode() below.  Its
+ * purpose is to create a new inode that will not trigger the warning if such
+ * an inode is still in use.  An ugly hack, no doubt.  Suggections for
+ * improvement are welcome.
+ */
+struct inode *logfs_new_meta_inode(struct super_block *sb, u64 ino)
+{
+	struct inode *inode;
+
+	inode = logfs_alloc_inode(sb);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	inode->i_mode = 0;
+	inode->i_ino = ino;
+	inode->i_sb = sb;
+
+	/* This is a blatant copy of alloc_inode code.  We'd need alloc_inode
+	 * to be nonstatic, alas. */
+	{
+		static const struct address_space_operations empty_aops;
+		struct address_space * const mapping = &inode->i_data;
+
+		mapping->a_ops = &empty_aops;
+		mapping->host = inode;
+		mapping->flags = 0;
+		mapping_set_gfp_mask(mapping, GFP_HIGHUSER);
+		mapping->assoc_mapping = NULL;
+		mapping->backing_dev_info = &default_backing_dev_info;
+		inode->i_mapping = mapping;
+	}
+
+	return inode;
+}
+
+/*
+ * Time is stored as nanoseconds since the epoch.
+ */
+static struct timespec be64_to_timespec(__be64 betime)
+{
+	return ns_to_timespec(be64_to_cpu(betime));
+}
+
+static __be64 timespec_to_be64(struct timespec tsp)
+{
+	return cpu_to_be64((u64)tsp.tv_sec * NSEC_PER_SEC + tsp.tv_nsec);
+}
+
+static void logfs_disk_to_inode(struct logfs_disk_inode *di, struct inode*inode)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	int i;
+
+	inode->i_mode	= be16_to_cpu(di->di_mode);
+	li->li_height	= di->di_height;
+	li->li_flags	= be32_to_cpu(di->di_flags);
+	inode->i_uid	= be32_to_cpu(di->di_uid);
+	inode->i_gid	= be32_to_cpu(di->di_gid);
+	inode->i_size	= be64_to_cpu(di->di_size);
+	logfs_set_blocks(inode, be64_to_cpu(di->di_used_bytes));
+	inode->i_ctime	= be64_to_timespec(di->di_ctime);
+	inode->i_mtime	= be64_to_timespec(di->di_mtime);
+	inode->i_nlink	= be32_to_cpu(di->di_refcount);
+	inode->i_generation = be32_to_cpu(di->di_generation);
+
+	switch (inode->i_mode & S_IFMT) {
+	case S_IFCHR: /* fall through */
+	case S_IFBLK: /* fall through */
+	case S_IFIFO:
+		inode->i_rdev = be64_to_cpu(di->di_data[0]);
+		break;
+	default:
+		for (i=0; i<LOGFS_EMBEDDED_FIELDS; i++)
+			li->li_data[i] = be64_to_cpu(di->di_data[i]);
+		break;
+	}
+}
+
+static void logfs_inode_to_disk(struct inode *inode, struct logfs_disk_inode*di)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	int i;
+
+	di->di_mode	= cpu_to_be16(inode->i_mode);
+	di->di_height	= li->li_height;
+	di->di_pad	= 0;
+	di->di_flags	= cpu_to_be32(li->li_flags);
+	di->di_uid	= cpu_to_be32(inode->i_uid);
+	di->di_gid	= cpu_to_be32(inode->i_gid);
+	di->di_size	= cpu_to_be64(i_size_read(inode));
+	di->di_used_bytes = cpu_to_be64(li->li_used_bytes);
+	di->di_ctime	= timespec_to_be64(inode->i_ctime);
+	di->di_mtime	= timespec_to_be64(inode->i_mtime);
+	di->di_refcount	= cpu_to_be32(inode->i_nlink);
+	di->di_generation = cpu_to_be32(inode->i_generation);
+
+	switch (inode->i_mode & S_IFMT) {
+	case S_IFCHR: /* fall through */
+	case S_IFBLK: /* fall through */
+	case S_IFIFO:
+		di->di_data[0] = cpu_to_be64(inode->i_rdev);
+		break;
+	default:
+		for (i=0; i<LOGFS_EMBEDDED_FIELDS; i++)
+			di->di_data[i] = cpu_to_be64(li->li_data[i]);
+		break;
+	}
+}
+
+#define VALID_MASK (LOGFS_IF_VALID | LOGFS_IF_INVALID)
+static int logfs_read_disk_inode(struct logfs_disk_inode *di,
+		struct inode *inode)
+{
+	struct logfs_super *super = logfs_super(inode->i_sb);
+	ino_t ino = inode->i_ino;
+	int ret;
+
+	BUG_ON(!super->s_master_inode);
+	ret = logfs_inode_read(super->s_master_inode, di, sizeof(*di), ino);
+	if (ret)
+		return ret;
+
+	if ((be32_to_cpu(di->di_flags) & VALID_MASK) != LOGFS_IF_VALID) {
+		/*
+		 * We read wrong data, someone scribbled over it or we
+		 * have a bug.  Worth mentioning in the logs.
+		 */
+		printk(KERN_WARNING"LOGFS: read corrupt inode #%lx\n", ino);
+		WARN_ON(1);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int __logfs_read_inode(struct inode *inode)
+{
+	struct logfs_disk_inode di;
+	int ret;
+
+	ret = logfs_read_disk_inode(&di, inode);
+	if (ret)
+		return ret;
+	logfs_disk_to_inode(&di, inode);
+
+	switch (inode->i_mode & S_IFMT) {
+	case S_IFDIR:
+		inode->i_op = &logfs_dir_iops;
+		inode->i_fop = &logfs_dir_fops;
+		break;
+	case S_IFREG:
+		inode->i_op = &logfs_reg_iops;
+		inode->i_fop = &logfs_reg_fops;
+		inode->i_mapping->a_ops = &logfs_reg_aops;
+		break;
+	default:
+		;
+	}
+
+	return 0;
+}
+
+static void logfs_read_inode(struct inode *inode)
+{
+	int ret;
+
+	BUG_ON(inode->i_ino == LOGFS_INO_MASTER);
+
+	ret = __logfs_read_inode(inode);
+
+	if (ret)
+		make_bad_inode(inode);
+}
+
+/* This function should move to fs/fs-writeback.c or similar. */
+static void clear_inode_dirty_sync(struct inode *inode)
+{
+	spin_lock(&inode_lock);
+	inode->i_state &= ~I_DIRTY_SYNC;
+	spin_unlock(&inode_lock);
+}
+
+static int logfs_write_disk_inode(struct logfs_disk_inode *di,
+		struct inode *inode, int lock)
+{
+	struct logfs_super *super = logfs_super(inode->i_sb);
+	struct logfs_transaction *ta;
+	int ret;
+
+	/* FIXME: should we take inode->i_mutex? */
+	ta = logfs_inode(inode)->li_transaction;
+	logfs_inode(inode)->li_transaction = NULL;
+
+	logfs_inode_to_disk(inode, di);
+	ret = logfs_inode_write(super->s_master_inode, di, sizeof(*di),
+			inode->i_ino, lock, ta);
+	clear_inode_dirty_sync(inode);
+	return ret;
+}
+
+int __logfs_write_inode(struct inode *inode, int lock)
+{
+	struct logfs_disk_inode di;
+
+	BUG_ON(inode->i_ino == LOGFS_INO_MASTER);
+	return logfs_write_disk_inode(&di, inode, lock);
+}
+
+static int logfs_write_inode(struct inode *inode, int do_sync)
+{
+	int ret;
+
+	/* Can only happen if creat() failed.  Safe to skip. */
+	if (logfs_inode(inode)->li_flags & LOGFS_IF_STILLBORN)
+		return 0;
+
+	ret = __logfs_write_inode(inode, 1);
+	LOGFS_BUG_ON(ret, inode->i_sb);
+	return ret;
+}
+
+static void logfs_truncate_inode(struct inode *inode)
+{
+	i_size_write(inode, 0);
+	logfs_truncate(inode);
+	truncate_inode_pages(&inode->i_data, 0);
+}
+
+/*
+ * ZOMBIE inodes have already been deleted before and should remain dead,
+ * if it weren't for valid checking.  No need to kill them again here.
+ */
+static void logfs_delete_inode(struct inode *inode)
+{
+	struct logfs_super *super = logfs_super(inode->i_sb);
+
+	if (! (logfs_inode(inode)->li_flags & LOGFS_IF_ZOMBIE)) {
+		if (i_size_read(inode) > 0)
+			logfs_truncate_inode(inode);
+		logfs_delete(super->s_master_inode, inode->i_ino, NULL);
+	}
+	clear_inode(inode);
+}
+
+void __logfs_destroy_inode(struct inode *inode)
+{
+	if (likely(inode))
+		kmem_cache_free(logfs_inode_cache, logfs_inode(inode));
+}
+
+/*
+ * We need to remember which inodes are currently being dropped.  They
+ * would deadlock the cleaner, if it were to iget() them.  So
+ * logfs_drop_inode() adds them to super->s_freeing_list,
+ * logfs_destroy_inode() removes them again and logfs_iget() checks the
+ * list.
+ */
+static void logfs_destroy_inode(struct inode *inode)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+
+	BUG_ON(list_empty(&li->li_freeing_list));
+	spin_lock(&inode_lock);
+	list_del(&li->li_freeing_list);
+	spin_unlock(&inode_lock);
+	kmem_cache_free(logfs_inode_cache, li);
+}
+
+/* called with inode_lock held */
+static void logfs_drop_inode(struct inode *inode)
+{
+	struct logfs_super *super = logfs_super(inode->i_sb);
+	struct logfs_inode *li = logfs_inode(inode);
+
+	list_move(&li->li_freeing_list, &super->s_freeing_list);
+	generic_drop_inode(inode);
+}
+
+static u64 logfs_get_ino(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
+	u64 ino;
+
+	/*
+	 * FIXME: ino allocation should work in two modes:
+	 * o nonsparse - ifile is mostly occupied, just append
+	 * o sparse - ifile has lots of holes, fill them up
+	 *
+	 * SEEK_HOLE would obviously help a lot here.
+	 */
+	spin_lock(&super->s_ino_lock);
+	ino = super->s_last_ino;
+	super->s_last_ino++;
+	spin_unlock(&super->s_ino_lock);
+	return ino;
+}
+
+struct inode *logfs_new_inode(struct inode *dir, int mode)
+{
+	struct super_block *sb = dir->i_sb;
+	struct inode *inode;
+
+	inode = new_inode(sb);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	logfs_init_inode(inode);
+
+	/* inherit parent flags */
+	logfs_inode(inode)->li_flags |=
+		logfs_inode(dir)->li_flags & LOGFS_FL_INHERITED;
+
+	inode->i_mode = mode;
+	inode->i_ino = logfs_get_ino(sb);
+
+	inode->i_uid = current->fsuid;
+	inode->i_gid = current->fsgid;
+	if (dir->i_mode & S_ISGID) {
+		inode->i_gid = dir->i_gid;
+		if (S_ISDIR(mode))
+			inode->i_mode |= S_ISGID;
+	}
+
+	insert_inode_hash(inode);
+
+	return inode;
+}
+
+static void logfs_init_once(void *_li, struct kmem_cache *cachep,
+		unsigned long flags)
+{
+	struct logfs_inode *li = _li;
+	int i;
+
+	li->li_flags = 0;
+	li->li_used_bytes = 0;
+	for (i=0; i<LOGFS_EMBEDDED_FIELDS; i++)
+		li->li_data[i] = 0;
+	inode_init_once(&li->vfs_inode);
+}
+
+static int logfs_sync_fs(struct super_block *sb, int wait)
+{
+	logfs_super(sb)->s_devops->sync(sb);
+	return 0;
+}
+
+const struct super_operations logfs_super_operations = {
+	.alloc_inode	= logfs_alloc_inode,
+	.delete_inode	= logfs_delete_inode,
+	.destroy_inode	= logfs_destroy_inode,
+	.drop_inode	= logfs_drop_inode,
+	.read_inode	= logfs_read_inode,
+	.write_inode	= logfs_write_inode,
+	.statfs		= logfs_statfs,
+	.sync_fs	= logfs_sync_fs,
+};
+
+int logfs_init_inode_cache(void)
+{
+	logfs_inode_cache = kmem_cache_create("logfs_inode_cache",
+			sizeof(struct logfs_inode), 0, SLAB_RECLAIM_ACCOUNT,
+			logfs_init_once, NULL);
+	if (!logfs_inode_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void logfs_destroy_inode_cache(void)
+{
+	kmem_cache_destroy(logfs_inode_cache);
+}

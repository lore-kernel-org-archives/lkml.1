Return-Path: <linux-kernel-owner+w=401wt.eu-S1761727AbYDCRNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761727AbYDCRNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563AbYDCRK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:10:57 -0400
Received: from lazybastard.de ([212.112.238.170]:43621 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760173AbYDCRKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:10:55 -0400
Message-Id: <20080401181332.853833013@logfs.org>
References: <20080401181308.512473173@logfs.org>
Date: Tue, 01 Apr 2008 20:13:08 +0200
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [patch 13/15] fs/logfs/super.c
From: joern@logfs.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2008-04-02 16:29:12.813336657 +0200
+++ linux-2.6.24logfs/fs/logfs/super.c	2008-04-01 22:58:50.362878974 +0200
@@ -0,0 +1,374 @@
+/*
+ * fs/logfs/super.c
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ *
+ * Generally contains mount/umount code and also serves as a dump area for
+ * any functions that don't fit elsewhere and neither justify a file of their
+ * own.
+ */
+#include "logfs.h"
+#include <linux/bio.h>
+#include <linux/mtd/mtd.h>
+#include <linux/statfs.h>
+#include <linux/buffer_head.h>
+
+static void dump_write(struct super_block *sb, int blockno, void *buf)
+{
+	struct logfs_super *super = logfs_super(sb);
+
+	if (blockno << sb->s_blocksize_bits >= super->s_segsize)
+		return;
+	super->s_devops->write(sb, blockno << sb->s_blocksize_bits,
+			sb->s_blocksize, buf);
+}
+
+/*
+ * logfs_crash_dump - dump debug information to device
+ *
+ * The LogFS superblock only occupies part of a segment.  This function will
+ * write as much debug information as it can gather into the spare space.
+ */
+void logfs_crash_dump(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
+	int i, blockno = 2, bs = sb->s_blocksize;
+	static char scratch[4096];
+	void *stack = (void *) ((ulong)current & ~0x1fffUL);
+
+	/* all wbufs */
+	if (super->s_writesize > 1)
+		for (i = 0; i < LOGFS_NO_AREAS; i++) {
+			void *wbuf = super->s_area[i]->a_wbuf;
+			u64 ofs = sb->s_blocksize + i*super->s_writesize;
+			super->s_devops->write(sb, ofs, super->s_writesize,
+					wbuf);
+		}
+	/* both superblocks */
+	memset(scratch, 0, bs);
+	memcpy(scratch, super, sizeof(*super));
+	memcpy(scratch + sizeof(*super) + 32, sb, sizeof(*sb));
+	dump_write(sb, blockno++, scratch);
+	/* process stack */
+	dump_write(sb, blockno++, stack);
+	dump_write(sb, blockno++, stack + 0x1000);
+}
+
+/*
+ * TODO: move to lib/string.c
+ */
+/**
+ * memchr_inv - Find a character in an area of memory.
+ * @s: The memory area
+ * @c: The byte to search for
+ * @n: The size of the area.
+ *
+ * returns the address of the first character other than @c, or %NULL
+ * if the whole buffer contains just @c.
+ */
+void *memchr_inv(const void *s, int c, size_t n)
+{
+	const unsigned char *p = s;
+	while (n-- != 0)
+		if ((unsigned char)c != *p++)
+			return (void *)(p - 1);
+
+	return NULL;
+}
+
+/*
+ * FIXME: There should be a reserve for root, similar to ext2.
+ */
+int logfs_statfs(struct dentry *dentry, struct kstatfs *stats)
+{
+	struct super_block *sb = dentry->d_sb;
+	struct logfs_super *super = logfs_super(sb);
+
+	stats->f_type		= LOGFS_MAGIC_U32;
+	stats->f_bsize		= sb->s_blocksize;
+	stats->f_blocks		= super->s_size >> LOGFS_BLOCK_BITS >> 3;
+	stats->f_bfree		= super->s_free_bytes >> sb->s_blocksize_bits;
+	stats->f_bavail		= super->s_free_bytes >> sb->s_blocksize_bits;
+	stats->f_files		= 0;
+	stats->f_ffree		= 0;
+	stats->f_namelen	= LOGFS_MAX_NAMELEN;
+	return 0;
+}
+
+static int logfs_sb_set(struct super_block *sb, void *_super)
+{
+	struct logfs_super *super = _super;
+
+	sb->s_fs_info = super;
+	sb->s_mtd = super->s_mtd ? super->s_mtd->mtd : NULL;
+	sb->s_bdev = super->s_bdev;
+	return 0;
+}
+
+static int logfs_sb_test(struct super_block *sb, void *_super)
+{
+	struct logfs_super *super = _super;
+	struct mtd_info *mtd = super->s_mtd ? super->s_mtd->mtd : NULL;
+
+	if (mtd && sb->s_mtd == mtd)
+		return 1;
+	if (super->s_bdev && sb->s_bdev == super->s_bdev)
+		return 1;
+	return 0;
+}
+
+static int logfs_make_writeable(struct super_block *sb)
+{
+	int err;
+
+	/* Check areas for trailing unaccounted data */
+	err = logfs_check_areas(sb);
+	if (err)
+		return err;
+
+	/* Do one GC pass before any data gets dirtied */
+	logfs_gc_pass(sb);
+
+	/* after all initializations are done, replay the journal
+	 * for rw-mounts, if necessary */
+	err = logfs_replay_journal(sb);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int logfs_get_sb_final(struct super_block *sb, struct vfsmount *mnt)
+{
+	struct inode *rootdir;
+	int err;
+
+	/* root dir */
+	rootdir = iget(sb, LOGFS_INO_ROOT);
+	if (!rootdir)
+		goto fail;
+
+	sb->s_root = d_alloc_root(rootdir);
+	if (!sb->s_root)
+		goto fail;
+
+	/* FIXME: check for read-only mounts */
+	err = logfs_make_writeable(sb);
+	if (err)
+		goto fail;
+
+	return simple_set_mnt(mnt, sb);
+
+fail:
+	iput(logfs_super(sb)->s_master_inode);
+	return -EIO;
+}
+
+static int logfs_read_sb(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct logfs_disk_super ds;
+	s64 ofs;
+	int i, ret;
+
+	ofs = super->s_devops->find_sb(sb);
+	if (ofs < 0)
+		return -EIO;
+	ret = super->s_devops->read(sb, ofs, sizeof(ds), &ds);
+	if (ret)
+		return ret;
+
+	if (be64_to_cpu(ds.ds_magic) != LOGFS_MAGIC)
+		return -EIO;
+
+	super->s_size = be64_to_cpu(ds.ds_filesystem_size);
+	super->s_root_reserve = be64_to_cpu(ds.ds_root_reserve);
+	super->s_segsize = 1 << ds.ds_segment_shift;
+	super->s_segshift = ds.ds_segment_shift;
+	sb->s_blocksize = 1 << ds.ds_block_shift;
+	sb->s_blocksize_bits = ds.ds_block_shift;
+	super->s_writesize = 1 << ds.ds_write_shift;
+	super->s_writeshift = ds.ds_write_shift;
+	super->s_no_segs = super->s_size >> super->s_segshift;
+	super->s_no_blocks = super->s_segsize >> sb->s_blocksize_bits;
+
+	journal_for_each(i)
+		super->s_journal_seg[i] = be64_to_cpu(ds.ds_journal_seg[i]);
+
+	super->s_ifile_levels = ds.ds_ifile_levels;
+	super->s_iblock_levels = ds.ds_iblock_levels;
+	super->s_data_levels = ds.ds_data_levels;
+	super->s_total_levels = super->s_ifile_levels + super->s_iblock_levels
+		+ super->s_data_levels;
+	super->s_gc_reserve = super->s_total_levels *
+		(2 * super->s_no_blocks - 1);
+	super->s_gc_reserve <<= sb->s_blocksize_bits;
+
+	mutex_init(&super->s_dirop_mutex);
+	spin_lock_init(&super->s_ino_lock);
+	INIT_LIST_HEAD(&super->s_freeing_list);
+
+	ret = logfs_init_rw(super);
+	if (ret)
+		return ret;
+
+	ret = logfs_init_areas(sb);
+	if (ret)
+		return ret;
+
+	ret = logfs_init_gc(super);
+	if (ret)
+		return ret;
+
+	ret = logfs_init_journal(sb);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static void logfs_kill_sb(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
+
+	generic_shutdown_super(sb);
+
+	/* inode file is special and needs manual flushing */
+	logfs_flush_dirty(sb, 1);
+	BUG_ON(super->s_dirty_used_bytes || super->s_dirty_free_bytes);
+
+	logfs_cleanup_gc(super);
+	logfs_cleanup_journal(sb);
+	logfs_cleanup_areas(super);
+	logfs_cleanup_rw(super);
+	logfs_put_mtd(super->s_mtd);
+	logfs_put_bdev(super->s_bdev);
+	kfree(super);
+}
+
+int logfs_get_sb_device(struct file_system_type *type, int flags,
+		struct mtd_inode *mtd, struct block_device *bdev,
+		const struct logfs_device_ops *devops, struct vfsmount *mnt)
+{
+	struct logfs_super *super;
+	struct super_block *sb;
+	int i, err = -ENOMEM;
+
+	super = kzalloc(sizeof(*super), GFP_KERNEL);
+	if (!super)
+		goto err0;
+
+	super->s_mtd	= mtd;
+	super->s_bdev	= bdev;
+	err = -EINVAL;
+	sb = sget(type, logfs_sb_test, logfs_sb_set, super);
+	if (IS_ERR(sb))
+		goto err0;
+
+	if (sb->s_root) {
+		/* Device is already in use */
+		err = simple_set_mnt(mnt, sb);
+		goto err0;
+	}
+
+	super->s_devops = devops;
+	INIT_LIST_HEAD(&super->s_dirty_list);
+	for_each_area(i)
+		INIT_LIST_HEAD(&super->s_gc_dirty_list[i]);
+	/*
+	 * Careful here.  In principle s_maxbytes could easily be bumped up to
+	 * LOGFS_I5_SIZE.  Most of the code just needs a thorough audit and
+	 * a couple of changes to allow for 4x and 5x indirect blocks.
+	 *
+	 * There is one detail requiring a little more care, though:
+	 * As we use the upper half of each file's address space for metadata,
+	 * s_maxbytes must remain below LONG_MAX.  Which means a different
+	 * limit on 64bit and 32bit systems and potentially files created on
+	 * one system that cannot be fully read on another.
+	 *
+	 * LOGFS_I3_SIZE is below 8TB, which is a safe choice for now.
+	 */
+	sb->s_maxbytes	= LOGFS_I3_SIZE;
+	sb->s_op	= &logfs_super_operations;
+	sb->s_flags	= flags | MS_NOATIME;
+
+	err = logfs_read_sb(sb);
+	if (err)
+		goto err1;
+
+	sb->s_flags |= MS_ACTIVE;
+	err = logfs_get_sb_final(sb, mnt);
+	if (err)
+		goto err1;
+	return 0;
+
+err1:
+	up_write(&sb->s_umount);
+	deactivate_super(sb);
+	return err;
+err0:
+	kfree(super);
+	logfs_put_mtd(mtd);
+	logfs_put_bdev(bdev);
+	return err;
+}
+
+static int logfs_get_sb(struct file_system_type *type, int flags,
+		const char *devname, void *data, struct vfsmount *mnt)
+{
+	ulong mtdnr;
+
+	if (!devname)
+		return logfs_get_sb_bdev(type, flags, devname, mnt);
+	if (strncmp(devname, "mtd", 3))
+		return logfs_get_sb_bdev(type, flags, devname, mnt);
+
+	{
+		char *garbage;
+		mtdnr = simple_strtoul(devname+3, &garbage, 0);
+		if (*garbage)
+			return -EINVAL;
+	}
+
+	return logfs_get_sb_mtd(type, flags, mtdnr, mnt);
+}
+
+static struct file_system_type logfs_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "logfs",
+	.get_sb		= logfs_get_sb,
+	.kill_sb	= logfs_kill_sb,
+};
+
+static int __init logfs_init(void)
+{
+	int ret;
+
+	ret = logfs_compr_init();
+	if (ret)
+		return ret;
+
+	ret = logfs_init_inode_cache();
+	if (ret) {
+		logfs_compr_exit();
+		return ret;
+	}
+
+	return register_filesystem(&logfs_fs_type);
+}
+
+static void __exit logfs_exit(void)
+{
+	unregister_filesystem(&logfs_fs_type);
+	logfs_destroy_inode_cache();
+	logfs_compr_exit();
+}
+
+module_init(logfs_init);
+module_exit(logfs_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Joern Engel <joern@logfs.org>");
+MODULE_DESCRIPTION("scalable flash filesystem");


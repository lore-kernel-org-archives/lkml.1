Return-Path: <linux-kernel-owner+w=401wt.eu-S935146AbXHHQ0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935146AbXHHQ0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934147AbXHHQZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:25:37 -0400
Received: from lazybastard.de ([212.112.238.170]:42405 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbXHHQZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:25:32 -0400
Date: Wed, 8 Aug 2007 18:21:29 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [Patch 13/18] fs/logfs/super.c
Message-ID: <20070808162129.GO15319@lazybastard.org>
References: <20070808161234.GB15319@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070808161234.GB15319@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2007-08-05 21:14:35.622844160 +0200
+++ linux-2.6.21logfs/fs/logfs/super.c	2007-08-08 02:57:37.000000000 +0200
@@ -0,0 +1,569 @@
+/*
+ * fs/logfs/super.c
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ *
+ * Generally contains mount/umount code and also serves and a dump area for
+ * any functions that don't fit elsewhere and neither justify a file of their
+ * own.
+ */
+#include "logfs.h"
+#include <linux/bio.h>
+#include <linux/mtd/mtd.h>
+#include <linux/statfs.h>
+#include <linux/buffer_head.h>
+
+static int mtd_read(struct super_block *sb, loff_t ofs, size_t len, void *buf)
+{
+	struct mtd_info *mtd = logfs_super(sb)->s_mtd;
+	size_t retlen;
+	int ret;
+
+	ret = mtd->read(mtd, ofs, len, &retlen, buf);
+	BUG_ON(ret == -EINVAL);
+	if (ret)
+		return ret;
+
+	/* Not sure if we should loop instead. */
+	if (retlen != len)
+		return -EIO;
+
+	return 0;
+}
+
+static int mtd_write(struct super_block *sb, loff_t ofs, size_t len, void *buf)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct mtd_info *mtd = super->s_mtd;
+	size_t retlen;
+	loff_t page_start, page_end;
+	int ret;
+
+	if (super->s_flags & LOGFS_SB_FLAG_RO)
+		return -EROFS;
+
+	BUG_ON((ofs >= mtd->size) || (len > mtd->size - ofs));
+	BUG_ON(ofs != (ofs >> super->s_writeshift) << super->s_writeshift);
+	BUG_ON(len > PAGE_CACHE_SIZE);
+	page_start = ofs & PAGE_CACHE_MASK;
+	page_end = PAGE_CACHE_ALIGN(ofs + len) - 1;
+	ret = mtd->write(mtd, ofs, len, &retlen, buf);
+	if (ret || (retlen != len))
+		return -EIO;
+
+	return 0;
+}
+
+/*
+ * For as long as I can remember (since about 2001) mtd->erase has been an
+ * asynchronous interface lacking the first driver to actually use the
+ * asynchronous properties.  So just to prevent the first implementor of such
+ * a thing from breaking logfs in 2350, we do the usual pointless dance to
+ * declare a completion variable and wait for completion before returning
+ * from mtd_erase().  What an excercise in futility!
+ */
+static void logfs_erase_callback(struct erase_info *ei)
+{
+	complete((struct completion*)ei->priv);
+}
+
+static int mtd_erase(struct super_block *sb, loff_t ofs, size_t len)
+{
+	struct mtd_info *mtd = logfs_super(sb)->s_mtd;
+	struct erase_info ei;
+	DECLARE_COMPLETION_ONSTACK(complete);
+	int ret;
+
+	BUG_ON(len % mtd->erasesize);
+
+	if (logfs_super(sb)->s_flags & LOGFS_SB_FLAG_RO)
+		return -EROFS;
+
+	memset(&ei, 0, sizeof(ei));
+	ei.mtd = mtd;
+	ei.addr = ofs;
+	ei.len = len;
+	ei.callback = logfs_erase_callback;
+	ei.priv = (long)&complete;
+	ret = mtd->erase(mtd, &ei);
+	if (ret)
+		return -EIO;
+
+	wait_for_completion(&complete);
+	if (ei.state != MTD_ERASE_DONE)
+		return -EIO;
+	return 0;
+}
+
+static void mtd_sync(struct super_block *sb)
+{
+	struct mtd_info *mtd = logfs_super(sb)->s_mtd;
+
+	if (mtd->sync)
+		mtd->sync(mtd);
+}
+
+static const struct logfs_device_ops mtd_devops = {
+	.read	= mtd_read,
+	.write	= mtd_write,
+	.erase	= mtd_erase,
+	.sync	= mtd_sync,
+};
+
+static int bdev_read(struct super_block *sb, loff_t from, size_t len, void *buf)
+{
+	struct block_device *bdev = logfs_super(sb)->s_bdev;
+	struct address_space *mapping = bdev->bd_inode->i_mapping;
+	struct page *page;
+	long index = from >> PAGE_SHIFT;
+	long offset = from & (PAGE_SIZE-1);
+	long copylen;
+
+	while (len) {
+		copylen = min((ulong)len, PAGE_SIZE - offset);
+
+		page = read_cache_page(mapping, index,
+				(filler_t*)mapping->a_ops->readpage, NULL);
+		if (!page)
+			return -ENOMEM;
+		if (IS_ERR(page))
+			return PTR_ERR(page);
+
+		memcpy(buf, page_address(page) + offset, copylen);
+		page_cache_release(page);
+
+		buf += copylen;
+		len -= copylen;
+		offset = 0;
+		index++;
+	}
+	return 0;
+}
+
+static int bdev_write(struct super_block *sb, loff_t to, size_t len, void *buf)
+{
+	struct block_device *bdev = logfs_super(sb)->s_bdev;
+	struct address_space *mapping = bdev->bd_inode->i_mapping;
+	struct page *page;
+	long index = to >> PAGE_SHIFT;
+	long offset = to & (PAGE_SIZE-1);
+	long copylen;
+
+	if (logfs_super(sb)->s_flags & LOGFS_SB_FLAG_RO)
+		return -EROFS;
+
+	while (len) {
+		copylen = min((ulong)len, PAGE_SIZE - offset);
+
+		page = read_cache_page(mapping, index,
+				(filler_t*)mapping->a_ops->readpage, NULL);
+		if (!page)
+			return -ENOMEM;
+		if (IS_ERR(page))
+			return PTR_ERR(page);
+		lock_page(page);
+		memcpy(page_address(page) + offset, buf, copylen);
+		set_page_dirty(page);
+		unlock_page(page);
+		page_cache_release(page);
+
+		buf += copylen;
+		len -= copylen;
+		offset = 0;
+		index++;
+	}
+	return 0;
+}
+
+static int bdev_erase(struct super_block *sb, loff_t to, size_t len)
+{
+	struct block_device *bdev = logfs_super(sb)->s_bdev;
+	struct address_space *mapping = bdev->bd_inode->i_mapping;
+	struct page *page;
+	long index = to >> PAGE_SHIFT;
+	long offset = to & (PAGE_SIZE-1);
+	long copylen;
+
+	if (logfs_super(sb)->s_flags & LOGFS_SB_FLAG_RO)
+		return -EROFS;
+
+	while (len) {
+		copylen = min((ulong)len, PAGE_SIZE - offset);
+
+		page = read_cache_page(mapping, index,
+				(filler_t*)mapping->a_ops->readpage, NULL);
+		if (!page)
+			return -ENOMEM;
+		if (IS_ERR(page))
+			return PTR_ERR(page);
+		lock_page(page);
+		memset(page_address(page) + offset, 0xFF, copylen);
+		set_page_dirty(page);
+		unlock_page(page);
+		page_cache_release(page);
+
+		len -= copylen;
+		offset = 0;
+		index++;
+	}
+	return 0;
+}
+
+static void bdev_sync(struct super_block *sb)
+{
+	sync_blockdev(logfs_super(sb)->s_bdev);
+}
+
+static const struct logfs_device_ops bd_devops = {
+	.read	= bdev_read,
+	.write	= bdev_write,
+	.erase	= bdev_erase,
+	.sync	= bdev_sync,
+};
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
+	void *scratch = super->s_wblock[0];
+	void *stack = (void *) ((ulong)current & ~0x1fffUL);
+
+	/* all wbufs */
+	for (i=0; i<LOGFS_NO_AREAS; i++) {
+		void *wbuf = super->s_area[i]->a_wbuf;
+		u64 ofs = sb->s_blocksize + i*super->s_writesize;
+		super->s_devops->write(sb, ofs, super->s_writesize, wbuf);
+	}
+	/* both superblocks */
+	memset(scratch, 0, bs);
+	memcpy(scratch, super, sizeof(*super));
+	memcpy(scratch + sizeof(*super) + 32, sb, sizeof(*sb));
+	dump_write(sb, blockno++, scratch);
+	/* process stack */
+	dump_write(sb, blockno++, stack);
+	dump_write(sb, blockno++, stack + 0x1000);
+	/* wblocks are interesting whenever readwrite.c causes problems */
+	for (i=0; i<LOGFS_MAX_LEVELS; i++)
+		dump_write(sb, blockno++, super->s_wblock[i]);
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
+	while (n-- != 0) {
+		if ((unsigned char)c != *p++) {
+			return (void *)(p - 1);
+		}
+	}
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
+	stats->f_type	= LOGFS_MAGIC_U32;
+	stats->f_bsize	= sb->s_blocksize;
+	stats->f_blocks	= super->s_size >> LOGFS_BLOCK_BITS >> 3;
+	stats->f_bfree	= super->s_free_bytes >> sb->s_blocksize_bits;
+	stats->f_bavail	= super->s_free_bytes >> sb->s_blocksize_bits;
+	stats->f_files	= 0;
+	stats->f_ffree	= 0;
+	stats->f_namelen= LOGFS_MAX_NAMELEN;
+	return 0;
+}
+
+static int logfs_sb_set(struct super_block *sb, void *super)
+{
+	sb->s_fs_info = super;
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
+	err = logfs_fsck(sb);
+	if (err) {
+		printk(KERN_ERR"LOGFS: fsck failed, refusing to mount\n");
+		goto fail;
+	}
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
+	int i, ret;
+
+	ret = super->s_devops->read(sb, 0, sizeof(ds), &ds);
+	if (ret)
+		return ret;
+
+	ret = -EIO;
+	if (be64_to_cpu(ds.ds_magic) != LOGFS_MAGIC)
+		goto out0;
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
+	super->s_gc_reserve = super->s_total_levels * (2*super->s_no_blocks -1);
+	super->s_gc_reserve <<= sb->s_blocksize_bits;
+
+	mutex_init(&super->s_dirop_mutex);
+	spin_lock_init(&super->s_ino_lock);
+	INIT_LIST_HEAD(&super->s_freeing_list);
+
+	ret = logfs_init_rw(super);
+	if (ret)
+		goto out0;
+
+	ret = logfs_init_areas(sb);
+	if (ret)
+		goto out1;
+
+	ret = logfs_init_journal(sb);
+	if (ret)
+		goto out2;
+
+	ret = logfs_init_gc(super);
+	if (ret)
+		goto out3;
+
+	/* Do one GC pass before any data gets dirtied */
+	logfs_gc_pass(sb);
+
+	/* after all initializations are done, replay the journal
+	 * for rw-mounts, if necessary */
+	ret = logfs_replay_journal(sb);
+	if (ret)
+		goto out4;
+	return 0;
+
+out4:
+	logfs_cleanup_gc(super);
+out3:
+	logfs_cleanup_journal(sb);
+out2:
+	logfs_cleanup_areas(super);
+out1:
+	logfs_cleanup_rw(super);
+out0:
+	return ret;
+}
+
+static void logfs_kill_sb(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
+
+	generic_shutdown_super(sb);
+	logfs_cleanup_gc(super);
+	logfs_cleanup_journal(sb);
+	logfs_cleanup_areas(super);
+	logfs_cleanup_rw(super);
+	if (super->s_mtd)
+		put_mtd_device(super->s_mtd);
+	if (super->s_bdev)
+		close_bdev_excl(super->s_bdev);
+	kfree(super);
+}
+
+static void init_logfs_super(struct logfs_super *super)
+{
+	INIT_LIST_HEAD(&super->s_free_list);
+	INIT_LIST_HEAD(&super->s_low_list);
+}
+
+static int logfs_get_sb_device(struct file_system_type *type, int flags,
+		struct mtd_info *mtd, struct block_device *bdev,
+		const struct logfs_device_ops *devops, struct vfsmount *mnt)
+{
+	struct logfs_super *super = NULL;
+	struct super_block *sb;
+	int err = -ENOMEM;
+
+	super = kzalloc(sizeof*super, GFP_KERNEL);
+	if (!super)
+		goto err0;
+
+	init_logfs_super(super);
+
+	err = -EINVAL;
+	sb = sget(type, NULL, logfs_sb_set, super);
+	if (IS_ERR(sb))
+		goto err0;
+
+	super->s_mtd	= mtd;
+	super->s_bdev	= bdev;
+	super->s_devops = devops;
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
+	if (mtd)
+		put_mtd_device(mtd);
+	if (bdev)
+		close_bdev_excl(bdev);
+	return err;
+}
+
+static int logfs_get_sb_bdev(struct file_system_type *type, int flags,
+		const char *devname, void *data, struct vfsmount *mnt)
+{
+	struct block_device *bdev;
+
+	bdev = open_bdev_excl(devname, O_RDWR, NULL);
+	if (IS_ERR(bdev))
+		return PTR_ERR(bdev);
+
+	if (MAJOR(bdev->bd_dev) == MTD_BLOCK_MAJOR) {
+		close_bdev_excl(bdev);
+		return -EINVAL; /* FIXME: fall back to mtd */
+	}
+
+	return logfs_get_sb_device(type, flags, NULL, bdev, &bd_devops, mnt);
+}
+
+static int logfs_get_sb(struct file_system_type *type, int flags,
+		const char *devname, void *data, struct vfsmount *mnt)
+{
+	ulong mtdnr;
+	struct mtd_info *mtd;
+
+	if (!devname)
+		return logfs_get_sb_bdev(type, flags, devname, data, mnt);
+	if (strncmp(devname, "mtd", 3))
+		return logfs_get_sb_bdev(type, flags, devname, data, mnt);
+
+	{
+		char *garbage;
+		mtdnr = simple_strtoul(devname+3, &garbage, 0);
+		if (*garbage)
+			return -EINVAL;
+	}
+
+	mtd = get_mtd_device(NULL, mtdnr);
+	if (!mtd)
+		return -EINVAL;
+
+	return logfs_get_sb_device(type, flags, mtd, NULL, &mtd_devops, mnt);
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
+MODULE_LICENSE("GPLv2");
+MODULE_AUTHOR("Joern Engel <joern@logfs.org>");
+MODULE_DESCRIPTION("scalable flash filesystem");

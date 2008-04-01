Return-Path: <linux-kernel-owner+w=401wt.eu-S1762056AbYDCROj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762056AbYDCROj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760372AbYDCRLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:11:08 -0400
Received: from lazybastard.de ([212.112.238.170]:43630 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757603AbYDCRLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:11:03 -0400
Message-Id: <20080401181332.853833015@logfs.org>
References: <20080401181308.512473173@logfs.org>
Date: Tue, 01 Apr 2008 20:13:08 +0200
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>
Subject: [patch 15/15] fs/logfs/dev_mtd.c
From: joern@logfs.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2008-03-30 12:15:48.586669308 +0200
+++ linux-2.6.24logfs/fs/logfs/dev_mtd.c	2008-04-01 19:44:47.991289121 +0200
@@ -0,0 +1,406 @@
+/*
+ * fs/logfs/dev_mtd.c	- Device access methods for MTD
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ */
+#include "logfs.h"
+#include <linux/completion.h>
+#include <linux/mount.h>
+
+#define PAGE_OFS(ofs) ((ofs) & (PAGE_SIZE-1))
+
+static struct vfsmount *mtd_mount __read_mostly;
+static struct kmem_cache *mtd_cache __read_mostly;
+
+static inline struct mtd_inode *mtd_inode(struct inode *inode)
+{
+	return container_of(inode, struct mtd_inode, vfs_inode);
+}
+
+static int mtd_read(struct super_block *sb, loff_t ofs, size_t len, void *buf)
+{
+	struct mtd_inode *mi = logfs_super(sb)->s_mtd;
+	struct mtd_info *mtd = mi->mtd;
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
+	struct mtd_inode *mi = super->s_mtd;
+	struct mtd_info *mtd = mi->mtd;
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
+	complete((struct completion *)ei->priv);
+}
+
+static int mtd_erase(struct super_block *sb, loff_t ofs, size_t len)
+{
+	struct mtd_inode *mi = logfs_super(sb)->s_mtd;
+	struct mtd_info *mtd = mi->mtd;
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
+	struct mtd_inode *mi = logfs_super(sb)->s_mtd;
+	struct mtd_info *mtd = mi->mtd;
+
+	if (mtd->sync)
+		mtd->sync(mtd);
+}
+
+static s64 mtd_find_sb(struct super_block *sb)
+{
+	struct mtd_inode *mi = logfs_super(sb)->s_mtd;
+	struct mtd_info *mtd = mi->mtd;
+	s64 ofs = 0;
+
+	if (!mtd->block_isbad)
+		return 0;
+
+	while (mtd->block_isbad(mtd, ofs)) {
+		ofs += mtd->erasesize;
+		if (ofs > mtd->size)
+			return -EIO;
+	}
+	return ofs;
+}
+
+static int map_read(struct super_block *sb, loff_t ofs, size_t len, void *buf)
+{
+	struct mtd_inode *mi = logfs_super(sb)->s_mtd;
+	struct inode *inode = &mi->vfs_inode;
+	struct page *page;
+	void *buf0;
+	unsigned long page_ofs, cplen;
+	int err;
+
+	while (len) {
+		page = find_or_create_page(inode->i_mapping, ofs>>PAGE_SHIFT,
+				GFP_NOIO);
+		if (!page)
+			return -ENOMEM;
+
+		if (!PageUptodate(page)) {
+			buf0 = kmap(page);
+			err = mtd_read(sb, ofs&PAGE_MASK, PAGE_SIZE, buf0);
+			kunmap(page);
+			if (err) {
+				unlock_page(page);
+				page_cache_release(page);
+				return err;
+			}
+			SetPageUptodate(page);
+		}
+
+		page_ofs = PAGE_OFS(ofs);
+		cplen = min(PAGE_SIZE - page_ofs, (unsigned long)len);
+
+		buf0 = kmap_atomic(page, KM_USER0);
+		memcpy(buf, buf0 + page_ofs, cplen);
+		kunmap_atomic(buf0, KM_USER0);
+		unlock_page(page);
+		page_cache_release(page);
+
+		ofs += cplen;
+		buf += cplen;
+		len -= cplen;
+	}
+	return 0;
+}
+
+#ifdef CACHE_WRITES
+/* This variant is about 4% slower than the write-invalidate variant */
+static int map_write(struct super_block *sb, loff_t ofs, size_t len, void *buf)
+{
+	struct mtd_inode *mi = logfs_super(sb)->s_mtd;
+	struct inode *inode = &mi->vfs_inode;
+	struct page *page;
+	void *buf0;
+	unsigned long page_ofs, cplen;
+	int err;
+
+	while (len) {
+		page = find_or_create_page(inode->i_mapping, ofs>>PAGE_SHIFT,
+				GFP_NOIO);
+		if (!page)
+			return -ENOMEM;
+
+		if (!PageUptodate(page) &&
+				(PAGE_OFS(ofs) || (len < PAGE_SIZE))) {
+			buf0 = kmap(page);
+			err = mtd_read(sb, ofs&PAGE_MASK, PAGE_SIZE, buf0);
+			kunmap(page);
+			if (err) {
+				unlock_page(page);
+				page_cache_release(page);
+				return err;
+			}
+			SetPageUptodate(page);
+		}
+
+		page_ofs = PAGE_OFS(ofs);
+		cplen = min(PAGE_SIZE - page_ofs, (unsigned long)len);
+
+		buf0 = kmap_atomic(page, KM_USER0);
+		memcpy(buf0 + page_ofs, buf, cplen);
+		kunmap_atomic(buf0, KM_USER0);
+
+		buf0 = kmap(page);
+		err = mtd_write(sb, ofs, cplen, buf0 + page_ofs);
+		kunmap(page);
+		unlock_page(page);
+		page_cache_release(page);
+		if (err)
+			return err;
+
+		ofs += cplen;
+		buf += cplen;
+		len -= cplen;
+	}
+	return 0;
+}
+#else
+static int map_write(struct super_block *sb, loff_t ofs, size_t len, void *buf)
+{
+	struct mtd_inode *mi = logfs_super(sb)->s_mtd;
+	struct inode *inode = &mi->vfs_inode;
+	struct page *page;
+	unsigned long page_ofs, cplen;
+	int err;
+
+	err = mtd_write(sb, ofs, len, buf);
+	if (err)
+		return err;
+
+	while (len) {
+		page = find_get_page(inode->i_mapping, ofs>>PAGE_SHIFT);
+		if (page) {
+			ClearPageUptodate(page);
+			page_cache_release(page);
+		}
+
+		page_ofs = PAGE_OFS(ofs);
+		cplen = min(PAGE_SIZE - page_ofs, (unsigned long)len);
+
+		ofs += cplen;
+		buf += cplen;
+		len -= cplen;
+	}
+	return 0;
+}
+#endif
+
+static int map_erase(struct super_block *sb, loff_t ofs, size_t len)
+{
+	struct mtd_inode *mi = logfs_super(sb)->s_mtd;
+	struct inode *inode = &mi->vfs_inode;
+	struct page *page;
+	int err;
+
+	BUG_ON(PAGE_OFS(ofs) || PAGE_OFS(len));
+
+	err = mtd_erase(sb, ofs, len);
+	if (err)
+		return err;
+
+	while (len) {
+		page = find_get_page(inode->i_mapping, ofs>>PAGE_SHIFT);
+		if (page) {
+			ClearPageUptodate(page);
+			page_cache_release(page);
+		}
+
+		ofs += PAGE_SIZE;
+		len -= PAGE_SIZE;
+	}
+	return 0;
+}
+
+static const struct logfs_device_ops mtd_devops = {
+	.find_sb	= mtd_find_sb,
+	.read		= map_read,
+	.write		= map_write,
+	.erase		= map_erase,
+	.sync		= mtd_sync,
+};
+
+int logfs_get_sb_mtd(struct file_system_type *type, int flags,
+		int mtdnr, struct vfsmount *mnt)
+{
+	struct inode *inode;
+
+	inode = iget_locked(mtd_mount->mnt_sb, mtdnr);
+	if (!inode)
+		return -ENOMEM;
+
+	if (inode->i_state & I_NEW) {
+		inode->i_mode = S_IFCHR;
+		inode->i_rdev = MKDEV(MTD_CHAR_MAJOR, mtdnr);
+		mtd_inode(inode)->mtd = get_mtd_device(NULL, mtdnr);
+		if (!mtd_inode(inode)->mtd) {
+			make_bad_inode(inode);
+			unlock_new_inode(inode);
+			iput(inode);
+			return -EINVAL;
+		}
+		unlock_new_inode(inode);
+	}
+
+	mtd_inode(inode)->openers++;
+
+	return logfs_get_sb_device(type, flags, mtd_inode(inode), NULL,
+			&mtd_devops, mnt);
+}
+
+void logfs_put_mtd(struct mtd_inode *mi)
+{
+	if (mi) {
+		if (!--mi->openers)
+			truncate_inode_pages(mi->vfs_inode.i_mapping, 0);
+		iput(&mi->vfs_inode);
+	}
+}
+
+static struct inode *mtd_alloc_inode(struct super_block *sb)
+{
+	struct mtd_inode *mi = kmem_cache_alloc(mtd_cache, GFP_KERNEL);
+
+	if (!mi)
+		return NULL;
+	return &mi->vfs_inode;
+}
+
+static void mtd_destroy_inode(struct inode *inode)
+{
+	struct mtd_inode *mi = mtd_inode(inode);
+
+	put_mtd_device(mi->mtd);
+	kmem_cache_free(mtd_cache, mi);
+}
+
+static const struct super_operations mtd_sops = {
+	.alloc_inode	= mtd_alloc_inode,
+	.destroy_inode	= mtd_destroy_inode,
+};
+
+static int mtd_get_sb(struct file_system_type *fs_type, int flags,
+		const char *dev_name, void *data, struct vfsmount *mnt)
+{
+	return get_sb_pseudo(fs_type, "mtd:", NULL, 0x6D746400, mnt);
+}
+
+static void init_once(struct kmem_cache *cache, void *_mi)
+{
+	struct mtd_inode *mi = _mi;
+
+	mi->mtd = NULL;
+	mi->openers = 0;
+	inode_init_once(&mi->vfs_inode);
+}
+
+static struct file_system_type mtd_fs_type = {
+	.name		= "mtd",
+	.get_sb		= mtd_get_sb,
+	.kill_sb	= kill_anon_super,
+};
+
+static int __init logfs_mtd_init(void)
+{
+	int err;
+
+	mtd_cache = kmem_cache_create("mtd_cache", sizeof(struct mtd_inode), 0,
+			(SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
+			 SLAB_MEM_SPREAD|SLAB_PANIC),
+			init_once);
+	if (!mtd_cache)
+		return -ENOMEM;
+
+	err = register_filesystem(&mtd_fs_type);
+	if (err)
+		goto out1;
+
+	mtd_mount = kern_mount(&mtd_fs_type);
+	err = PTR_ERR(mtd_mount);
+	if (IS_ERR(mtd_mount))
+		goto out2;
+
+	return 0;
+out2:
+	unregister_filesystem(&mtd_fs_type);
+out1:
+	kmem_cache_destroy(mtd_cache);
+	return err;
+}
+
+static void __exit logfs_mtd_exit(void)
+{
+	unregister_filesystem(&mtd_fs_type);
+	kmem_cache_destroy(mtd_cache);
+}
+
+fs_initcall(logfs_mtd_init); /* FIXME: remove */


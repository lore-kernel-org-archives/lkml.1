Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbZKTUYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbZKTUYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 15:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbZKTUYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 15:24:10 -0500
Received: from lazybastard.de ([212.112.238.170]:48505 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668AbZKTUWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 15:22:49 -0500
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
From: Joern Engel <joern@logfs.org>
Subject: [PATCH 18/17] [LogFS] fio support
References: <20091120181113.GA2159@logfs.org>
Message-Id: <E1NBZJY-0003ie-IU@longford.logfs.org>
Date: Fri, 20 Nov 2009 20:38:40 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/logfs/dev_mtd.c |  131 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 131 insertions(+), 0 deletions(-)

diff --git a/fs/logfs/dev_mtd.c b/fs/logfs/dev_mtd.c
index 68e99d0..a13e7e5 100644
--- a/fs/logfs/dev_mtd.c
+++ b/fs/logfs/dev_mtd.c
@@ -232,6 +232,135 @@ static void mtd_put_device(struct super_block *sb)
 	put_mtd_device(logfs_super(sb)->s_mtd);
 }
 
+static int fio_readpage(void *_sb, struct page *page)
+{
+	struct super_block *sb = _sb;
+	struct mtd_info *mtd = sb->s_mtd;
+	struct wait_multiple wm_data;
+	struct fio *fio;
+
+	wait_multiple_init(&wm_data, 1);
+	fio = alloc_fio(GFP_NOFS);
+	fio->fi_mtd = mtd;
+	fio->fi_ofs = (u64)page->index << PAGE_SHIFT;
+	fio->fi_page = page;
+	fio->fi_private = &wm_data;
+	fio->fi_end_io = wait_multiple_complete;
+	mtd->fio_read(fio);
+	wait_for_completion(&wm_data.complete);
+
+	if (wm_data.err) {
+		ClearPageUptodate(page);
+		SetPageError(page);
+	} else {
+		SetPageUptodate(page);
+		ClearPageError(page);
+	}
+	unlock_page(page);
+	return wm_data.err;
+}
+
+static DECLARE_WAIT_QUEUE_HEAD(wq);
+
+static void writeseg_endio(struct fio *fio)
+{
+	struct super_block *sb = fio->fi_private;
+	struct logfs_super *super = logfs_super(sb);
+
+	if (atomic_dec_and_test(&super->s_pending_writes))
+		wake_up(&wq);
+	BUG_ON(fio->fi_err);
+	free_fio(fio);
+}
+
+static int __fio_writeseg(struct super_block *sb, u64 ofs, pgoff_t index,
+		size_t nr_pages)
+{
+	struct logfs_super *super = logfs_super(sb);
+	struct mtd_info *mtd = sb->s_mtd;
+	struct address_space *mapping = super->s_mapping_inode->i_mapping;
+	struct page *page;
+	struct fio *fio;
+	int i;
+
+	for (i = 0; i < nr_pages; i++) {
+		page = find_lock_page(mapping, index + i);
+		BUG_ON(!page);
+
+		fio = alloc_fio(GFP_NOFS);
+		fio->fi_mtd = mtd;
+		fio->fi_ofs = (u64)page->index << PAGE_SHIFT;
+		fio->fi_page = page;
+		fio->fi_private = sb;
+		fio->fi_end_io = writeseg_endio;
+		atomic_inc(&super->s_pending_writes);
+		unlock_page(page);
+		page_cache_release(page);
+		mtd->fio_write(fio);
+	}
+	return 0;
+}
+
+static void fio_writeseg(struct super_block *sb, u64 ofs, size_t len)
+{
+	struct logfs_super *super = logfs_super(sb);
+	int head;
+
+	if (super->s_flags & LOGFS_SB_FLAG_RO)
+		return;
+
+	if (len == 0) {
+		/* This can happen when the object fit perfectly into a
+		 * segment, the segment gets written per sync and subsequently
+		 * closed.
+		 */
+		return;
+	}
+	head = ofs & (PAGE_SIZE - 1);
+	if (head) {
+		ofs -= head;
+		len += head;
+	}
+	len = PAGE_ALIGN(len);
+	__fio_writeseg(sb, ofs, ofs >> PAGE_SHIFT, len >> PAGE_SHIFT);
+}
+
+static int fio_erase(struct super_block *sb, loff_t ofs, size_t len)
+{
+	struct mtd_info *mtd = sb->s_mtd;
+	struct wait_multiple wm_data;
+	struct fio *fio;
+
+	if (mtd->block_isbad(mtd, ofs))
+		return -EIO;
+	wait_multiple_init(&wm_data, 1);
+	fio = alloc_fio(GFP_NOFS);
+	fio->fi_mtd = mtd;
+	fio->fi_ofs = ofs;
+	fio->fi_private = &wm_data;
+	fio->fi_end_io = wait_multiple_complete;
+	mtd->fio_erase(fio);
+	wait_for_completion(&wm_data.complete);
+	return wm_data.err;
+}
+
+static void fio_sync(struct super_block *sb)
+{
+	struct logfs_super *super = logfs_super(sb);
+
+	wait_event(wq, atomic_read(&super->s_pending_writes) == 0);
+}
+
+static const struct logfs_device_ops fio_devops = {
+	.find_first_sb	= mtd_find_first_sb,
+	.find_last_sb	= mtd_find_last_sb,
+	.readpage	= fio_readpage,
+	.writeseg	= fio_writeseg,
+	.erase		= fio_erase,
+	.sync		= fio_sync,
+	.put_device	= mtd_put_device,
+};
+
 static const struct logfs_device_ops mtd_devops = {
 	.find_first_sb	= mtd_find_first_sb,
 	.find_last_sb	= mtd_find_last_sb,
@@ -249,5 +378,7 @@ int logfs_get_sb_mtd(struct file_system_type *type, int flags,
 	const struct logfs_device_ops *devops = &mtd_devops;
 
 	mtd = get_mtd_device(NULL, mtdnr);
+	if (mtd->fio_read)
+		devops = &fio_devops;
 	return logfs_get_sb_device(type, flags, mtd, NULL, devops, mnt);
 }
-- 
1.6.2.1


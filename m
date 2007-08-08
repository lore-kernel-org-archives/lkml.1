Return-Path: <linux-kernel-owner+w=401wt.eu-S935353AbXHHQVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935353AbXHHQVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934938AbXHHQVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:21:22 -0400
Received: from lazybastard.de ([212.112.238.170]:42356 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbXHHQVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:21:19 -0400
Date: Wed, 8 Aug 2007 18:17:20 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [Patch 05/18] fs/logfs/file.c
Message-ID: <20070808161720.GH15319@lazybastard.org>
References: <20070808161234.GB15319@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070808161234.GB15319@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2007-08-05 21:14:35.622844160 +0200
+++ linux-2.6.21logfs/fs/logfs/file.c	2007-08-08 02:57:37.000000000 +0200
@@ -0,0 +1,176 @@
+/*
+ * fs/logfs/file.c	- prepare_write, commit_write and friends
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ */
+#include "logfs.h"
+
+static int logfs_prepare_write(struct file *file, struct page *page,
+		unsigned start, unsigned end)
+{
+	if (PageUptodate(page))
+		return 0;
+
+	if ((start == 0) && (end == PAGE_CACHE_SIZE))
+		return 0;
+
+	return logfs_readpage_nolock(page);
+}
+
+static int logfs_commit_write(struct file *file, struct page *page,
+		unsigned start, unsigned end)
+{
+	struct inode *inode = page->mapping->host;
+	pgoff_t index = page->index;
+	void *buf;
+	int ret;
+
+	BUG_ON(PAGE_CACHE_SIZE != inode->i_sb->s_blocksize);
+	BUG_ON(page->index > I3_BLOCKS);
+
+	if (start == end)
+		return 0; /* FIXME: do we need to update inode? */
+
+	if (i_size_read(inode) < (index << PAGE_CACHE_SHIFT) + end) {
+		i_size_write(inode, (index << PAGE_CACHE_SHIFT) + end);
+		mark_inode_dirty_sync(inode);
+	}
+
+	buf = kmap(page);
+	ret = logfs_write_buf(inode, index, buf, 1, NULL);
+	kunmap(page);
+	return ret;
+}
+
+static int logfs_readpage(struct file *file, struct page *page)
+{
+	int ret;
+
+	ret = logfs_readpage_nolock(page);
+	unlock_page(page);
+	return ret;
+}
+
+static int __logfs_writepage(struct page *page, struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	pgoff_t index = page->index;
+	void *buf;
+	int ret;
+
+	buf = kmap(page);
+	ret = logfs_write_buf(inode, index, buf, 1, NULL);
+	kunmap(page);
+	unlock_page(page);
+	return ret;
+}
+
+static int logfs_writepage(struct page *page, struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	loff_t i_size = i_size_read(inode);
+	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
+	unsigned offset;
+	void *buf;
+
+	/* Write full page */
+	if (page->index < end_index)
+		return __logfs_writepage(page, wbc);
+
+	offset = i_size & (PAGE_CACHE_SIZE-1);
+	if (page->index > end_index || offset == 0) {
+		/*
+		 * I believe this case cannot happen, therefore the BUG.  If
+		 * this doesn't trigger for a year or so or someone explains
+		 * the code to me, I'll remove the branch completely.
+		 */
+		BUG();
+		do_invalidatepage(page, 0);
+		unlock_page(page);
+		return 0;
+	}
+	/* Write partial page, must clear the rest */
+	buf = kmap_atomic(page, KM_USER0);
+	memset(buf + offset, 0, PAGE_CACHE_SIZE - offset);
+	flush_dcache_page(page);
+	kunmap_atomic(page, KM_USER0);
+	return __logfs_writepage(page, wbc);
+}
+
+int logfs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
+		unsigned long arg)
+{
+	struct logfs_inode *li = logfs_inode(inode);
+	unsigned int oldflags, flags;
+	int err;
+
+	switch (cmd) {
+	case FS_IOC_GETFLAGS:
+		flags = li->li_flags & LOGFS_FL_USER_VISIBLE;
+		return put_user(flags, (int __user*)arg);
+	case FS_IOC_SETFLAGS:
+		if (IS_RDONLY(inode))
+			return -EROFS;
+
+		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
+			return -EACCES;
+
+		err = get_user(flags, (int __user*)arg);
+		if (err)
+			return err;
+
+		mutex_lock(&inode->i_mutex);
+		oldflags = li->li_flags;
+		flags &= LOGFS_FL_USER_MODIFIABLE;
+		flags |= oldflags & ~LOGFS_FL_USER_MODIFIABLE;
+		li->li_flags = flags;
+		mutex_unlock(&inode->i_mutex);
+
+		inode->i_ctime = CURRENT_TIME;
+		mark_inode_dirty_sync(inode);
+		return 0;
+
+	default:
+		return -ENOTTY;
+	}
+}
+
+int logfs_fsync(struct file *file, struct dentry *dentry, int datasync)
+{
+	struct inode *inode = dentry->d_inode;
+	struct logfs_super *super = logfs_super(inode->i_sb);
+	int err;
+
+	err = __logfs_write_inode(inode, 1);
+	if (err)
+		return err;
+
+	super->s_devops->sync(inode->i_sb);
+	return 0;
+}
+
+const struct inode_operations logfs_reg_iops = {
+	.truncate	= logfs_truncate,
+};
+
+const struct file_operations logfs_reg_fops = {
+	.aio_read	= generic_file_aio_read,
+	.aio_write	= generic_file_aio_write,
+	.fsync		= logfs_fsync,
+	.ioctl		= logfs_ioctl,
+	.llseek		= generic_file_llseek,
+	.mmap		= generic_file_readonly_mmap,
+	.open		= generic_file_open,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
+};
+
+const struct address_space_operations logfs_reg_aops = {
+	.commit_write	= logfs_commit_write,
+	.prepare_write	= logfs_prepare_write,
+	.readpage	= logfs_readpage,
+	.set_page_dirty	= __set_page_dirty_nobuffers,
+	.writepage	= logfs_writepage,
+};

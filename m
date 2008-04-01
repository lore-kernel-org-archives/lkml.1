Return-Path: <linux-kernel-owner+w=401wt.eu-S1761174AbYDCRMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761174AbYDCRMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbYDCRKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:10:39 -0400
Received: from lazybastard.de ([212.112.238.170]:43595 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760005AbYDCRK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:10:29 -0400
Message-Id: <20080401181332.853833006@logfs.org>
References: <20080401181308.512473173@logfs.org>
Date: Tue, 01 Apr 2008 20:13:08 +0200
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [patch 6/15] fs/logfs/file.c
From: joern@logfs.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- /dev/null	2008-03-30 12:15:48.586669308 +0200
+++ linux-2.6.24logfs/fs/logfs/file.c	2008-03-28 18:26:27.421722776 +0100
@@ -0,0 +1,236 @@
+/*
+ * fs/logfs/file.c	- prepare_write, commit_write and friends
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ */
+#include "logfs.h"
+#include <linux/sched.h>
+#include <linux/writeback.h>
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
+	ClearPageZero(page);
+	ret = logfs_write_buf(inode, page, NULL, WF_LOCK);
+	return ret;
+}
+
+int logfs_readpage(struct file *file, struct page *page)
+{
+	int ret;
+
+	ret = logfs_readpage_nolock(page);
+	unlock_page(page);
+	return ret;
+}
+
+/* Clear the page's dirty flag in the radix tree. */
+/* TODO: mucking with PageWriteback is silly.  Add a generic function to clear
+ * the dirty bit from the radix tree for filesystems that don't have to wait
+ * for page writeback to finish (i.e. any compressing filesystem).
+ */
+static void clear_radix_tree_dirty(struct page *page)
+{
+	BUG_ON(PagePrivate(page) || page->private);
+	set_page_writeback(page);
+	end_page_writeback(page);
+}
+
+static int __logfs_writepage(struct page *page, struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	int err;
+
+	ClearPageZero(page);
+	err = logfs_write_buf(inode, page, NULL, WF_LOCK);
+	if (err)
+		set_page_dirty(page);
+	else
+		clear_radix_tree_dirty(page);
+	unlock_page(page);
+	return err;
+}
+
+static int logfs_writepage(struct page *page, struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	loff_t i_size = i_size_read(inode);
+	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
+	unsigned offset;
+	u64 bix;
+	u8 level;
+
+	pr_debug("logfs_writepage(%lx, %lx, %p)\n", inode->i_ino, page->index,
+			page);
+
+	logfs_unpack_index(page->index, &bix, &level);
+
+	/* Indirect blocks are never truncated */
+	if (level > 0)
+		return __logfs_writepage(page, wbc);
+
+	/*
+	 * TODO: everything below is a near-verbatim copy of nobh_writepage().
+	 * The relevant bits should be factored out after logfs is merged.
+	 */
+
+	/* Is the page fully inside i_size? */
+	if (bix < end_index)
+		return __logfs_writepage(page, wbc);
+
+	 /* Is the page fully outside i_size? (truncate in progress) */
+	offset = i_size & (PAGE_CACHE_SIZE-1);
+	if (bix > end_index || offset == 0) {
+		unlock_page(page);
+		return 0; /* don't care */
+	}
+
+	/*
+	 * The page straddles i_size.  It must be zeroed out on each and every
+	 * writepage invokation because it may be mmapped.  "A file is mapped
+	 * in multiples of the page size.  For a file that is not a multiple of
+	 * the  page size, the remaining memory is zeroed when mapped, and
+	 * writes to that region are not written out to the file."
+	 */
+	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset, KM_USER0);
+	return __logfs_writepage(page, wbc);
+}
+
+static void logfs_invalidatepage(struct page *page, unsigned long offset)
+{
+	u64 bix;
+	u8 level;
+
+	/* Gets called for dirty indirect blocks at umount time */
+	logfs_unpack_index(page->index, &bix, &level);
+	BUG_ON(level == 0);
+	BUG_ON(PageZero(page));
+	logfs_write_buf(page->mapping->host, page, NULL, WF_LOCK);
+}
+
+static int logfs_releasepage(struct page *page, gfp_t only_xfs_uses_this)
+{
+	return 0; /* None of these are easy to release */
+}
+
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
+		return put_user(flags, (int __user *)arg);
+	case FS_IOC_SETFLAGS:
+		if (IS_RDONLY(inode))
+			return -EROFS;
+
+		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
+			return -EACCES;
+
+		err = get_user(flags, (int __user *)arg);
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
+	struct super_block *sb = dentry->d_inode->i_sb;
+	struct logfs_super *super = logfs_super(sb);
+
+	logfs_flush_dirty(sb, 1);
+
+	super->s_devops->sync(sb);
+	return 0;
+}
+
+static int logfs_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	struct inode *inode = dentry->d_inode;
+	int err = 0;
+
+	if (attr->ia_valid & ATTR_SIZE)
+		err = logfs_truncate(inode, attr->ia_size);
+	attr->ia_valid &= ~ATTR_SIZE;
+
+	if (!err)
+		err = inode_change_ok(inode, attr);
+	if (!err)
+		err = inode_setattr(inode, attr);
+	return err;
+}
+
+const struct inode_operations logfs_reg_iops = {
+	.setattr	= logfs_setattr,
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
+	.invalidatepage	= logfs_invalidatepage,
+	.prepare_write	= logfs_prepare_write,
+	.readpage	= logfs_readpage,
+	.releasepage	= logfs_releasepage,
+	.set_page_dirty	= __set_page_dirty_nobuffers,
+	.writepage	= logfs_writepage,
+	.writepages	= generic_writepages,
+};


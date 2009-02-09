Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbZBINWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbZBINWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbZBINWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:22:42 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:1128 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754043AbZBINWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:22:41 -0500
From: Boaz Harrosh <bharrosh@panasas.com>
To: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 4/8] exofs: address_space_operations
Date: Mon,  9 Feb 2009 15:22:35 +0200
Message-Id: <1234185755-7850-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <49902A9E.3070002@panasas.com>
References: <49902A9E.3070002@panasas.com>
X-OriginalArrivalTime: 09 Feb 2009 13:22:39.0237 (UTC) FILETIME=[7AE7E350:01C98AB9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK Now we start to read and write from osd-objects, page-by-page.
The page index is the object's offset.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/exofs/exofs.h |    6 +
 fs/exofs/inode.c |  322 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 328 insertions(+), 0 deletions(-)

diff --git a/fs/exofs/exofs.h b/fs/exofs/exofs.h
index 9470be3..59163eb 100644
--- a/fs/exofs/exofs.h
+++ b/fs/exofs/exofs.h
@@ -139,6 +139,9 @@ int osd_req_write_pages(struct osd_request *or,
 /* inode.c               */
 void exofs_truncate(struct inode *inode);
 int exofs_setattr(struct dentry *, struct iattr *);
+int exofs_write_begin(struct file *file, struct address_space *mapping,
+		loff_t pos, unsigned len, unsigned flags,
+		struct page **pagep, void **fsdata);
 
 /*********************
  * operation vectors *
@@ -147,6 +150,9 @@ int exofs_setattr(struct dentry *, struct iattr *);
 extern const struct inode_operations exofs_file_inode_operations;
 extern const struct file_operations exofs_file_operations;
 
+/* inode.c           */
+extern const struct address_space_operations exofs_aops;
+
 /* symlink.c         */
 extern const struct inode_operations exofs_symlink_inode_operations;
 extern const struct inode_operations exofs_fast_symlink_inode_operations;
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index b0bda1e..f4979ea 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -42,6 +42,328 @@
 #  define EXOFS_DEBUG_OBJ_ISIZE 1
 #endif
 
+/*
+ * Callback for readpage
+ */
+static int __readpage_done(struct osd_request *or, void *p, int unlock)
+{
+	struct page *page = p;
+	struct inode *inode = page->mapping->host;
+	struct exofs_sb_info *sbi = inode->i_sb->s_fs_info;
+	int ret;
+
+	ret = exofs_check_ok(or);
+	osd_end_request(or);
+
+	EXOFS_DBGMSG("ret=>%d unlock=%d page=%p\n", ret, unlock, page);
+
+	if (ret == 0) {
+		/* Everything is OK */
+		SetPageUptodate(page);
+		if (PageError(page))
+			ClearPageError(page);
+	} else if (ret == -EFAULT) {
+		/* In this case we were trying to read something that wasn't on
+		 * disk yet - return a page full of zeroes.  This should be OK,
+		 * because the object should be empty (if there was a write
+		 * before this read, the read would be waiting with the page
+		 * locked */
+		clear_highpage(page);
+
+		SetPageUptodate(page);
+		if (PageError(page))
+			ClearPageError(page);
+	} else /* Error */
+		SetPageError(page);
+
+	atomic_dec(&sbi->s_curr_pending);
+	if (unlock)
+		unlock_page(page);
+
+	return ret;
+}
+
+static void readpage_done(struct osd_request *or, void *p)
+{
+	__readpage_done(or, p, true);
+}
+
+/*
+ * Read a page from the OSD
+ */
+static int __readpage_filler(struct page *page, bool is_async)
+{
+	struct osd_request *or = NULL;
+	struct inode *inode = page->mapping->host;
+	struct exofs_i_info *oi = exofs_i(inode);
+	ino_t ino = inode->i_ino;
+	loff_t i_size = i_size_read(inode);
+	loff_t i_start = page->index << PAGE_CACHE_SHIFT;
+	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
+	struct super_block *sb = inode->i_sb;
+	struct exofs_sb_info *sbi = sb->s_fs_info;
+	struct osd_obj_id obj = {sbi->s_pid, ino + EXOFS_OBJ_OFF};
+	uint64_t amount;
+	int ret = 0;
+
+	BUG_ON(!PageLocked(page));
+
+	if (PageUptodate(page))
+		goto unlock;
+
+	if (page->index < end_index)
+		amount = PAGE_CACHE_SIZE;
+	else
+		amount = i_size & (PAGE_CACHE_SIZE - 1);
+
+	/* this will be out of bounds, or doesn't exist yet */
+	if ((page->index >= end_index + 1) || !obj_created(oi) || !amount
+	    /*|| (i_start >= oi->i_commit_size)*/) {
+		clear_highpage(page);
+
+		SetPageUptodate(page);
+		if (PageError(page))
+			ClearPageError(page);
+		goto unlock;
+	}
+
+	if (amount != PAGE_CACHE_SIZE)
+		zero_user(page, amount, PAGE_CACHE_SIZE - amount);
+
+	or = osd_start_request(sbi->s_dev, GFP_KERNEL);
+	if (unlikely(!or)) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	ret = osd_req_read_pages(or, &obj, i_start, amount, &page, 1);
+	if (unlikely(ret))
+		goto err;
+
+	atomic_inc(&sbi->s_curr_pending);
+	if (is_async) {
+		ret = exofs_async_op(or, readpage_done, page, oi->i_cred);
+		if (unlikely(ret)) {
+			atomic_dec(&sbi->s_curr_pending);
+			goto err;
+		}
+	} else {
+		exofs_sync_op(or, sbi->s_timeout, oi->i_cred);
+		ret = __readpage_done(or, page, false);
+	}
+
+	EXOFS_DBGMSG("ret=>%d unlock=%d page=%p\n", ret, is_async, page);
+	return ret;
+
+err:
+	if (or)
+		osd_end_request(or);
+	SetPageError(page);
+	EXOFS_DBGMSG("@err\n");
+unlock:
+	if (is_async)
+		unlock_page(page);
+	EXOFS_DBGMSG("@unlock is_async=%d\n", is_async);
+	return ret;
+}
+
+static int readpage_filler(struct page *page)
+{
+	int ret = __readpage_filler(page, true);
+
+	return ret;
+}
+
+/*
+ * We don't need the file
+ */
+static int exofs_readpage(struct file *file, struct page *page)
+{
+	return readpage_filler(page);
+}
+
+/*
+ * We don't need the data
+ */
+static int readpage_strip(void *data, struct page *page)
+{
+	return readpage_filler(page);
+}
+
+/*
+ * read a bunch of pages - usually for readahead
+ */
+static int exofs_readpages(struct file *file, struct address_space *mapping,
+			   struct list_head *pages, unsigned nr_pages)
+{
+	return read_cache_pages(mapping, pages, readpage_strip, NULL);
+}
+
+/*
+ * Callback function when writepage finishes.  Check for errors, unlock, clean
+ * up, etc.
+ */
+static void writepage_done(struct osd_request *or, void *p)
+{
+	int ret;
+	struct page *page = p;
+	struct inode *inode = page->mapping->host;
+	struct exofs_sb_info *sbi = inode->i_sb->s_fs_info;
+
+	ret = exofs_check_ok(or);
+	osd_end_request(or);
+	atomic_dec(&sbi->s_curr_pending);
+
+	if (ret) {
+		if (ret == -ENOSPC)
+			set_bit(AS_ENOSPC, &page->mapping->flags);
+		else
+			set_bit(AS_EIO, &page->mapping->flags);
+
+		SetPageError(page);
+	}
+
+	end_page_writeback(page);
+	unlock_page(page);
+}
+
+/*
+ * Write a page to disk.  page->index gives us the page number.  The page is
+ * locked before this function is called.  We write asynchronously and then the
+ * callback function (writepage_done) is called.  We signify that the operation
+ * has completed by unlocking the page and calling end_page_writeback().
+ */
+static int exofs_writepage(struct page *page, struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	struct exofs_i_info *oi = exofs_i(inode);
+	struct osd_obj_id obj;
+	loff_t i_size = i_size_read(inode);
+	unsigned long end_index = i_size >> PAGE_CACHE_SHIFT;
+	unsigned offset = 0;
+	struct osd_request *or;
+	struct exofs_sb_info *sbi;
+	uint64_t start;
+	uint64_t len = PAGE_CACHE_SIZE;
+	int ret = 0;
+
+	BUG_ON(!PageLocked(page));
+
+	/* if the object has not been created, and we are not in sync mode,
+	 * just return.  otherwise, wait. */
+	if (!obj_created(oi)) {
+		BUG_ON(!obj_2bcreated(oi));
+
+		if (wbc->sync_mode == WB_SYNC_NONE) {
+			redirty_page_for_writepage(wbc, page);
+			unlock_page(page);
+			ret = 0;
+			goto out;
+		} else
+			wait_event(oi->i_wq, obj_created(oi));
+	}
+
+	/* in this case, the page is within the limits of the file */
+	if (page->index < end_index)
+		goto do_it;
+
+	offset = i_size & (PAGE_CACHE_SIZE - 1);
+	len = offset;
+
+	/*in this case, the page is outside the limits (truncate in progress)*/
+	if (page->index >= end_index + 1 || !offset) {
+		unlock_page(page);
+		goto out;
+	}
+
+do_it:
+	BUG_ON(PageWriteback(page));
+	set_page_writeback(page);
+	start = page->index << PAGE_CACHE_SHIFT;
+	sbi = inode->i_sb->s_fs_info;
+	oi->i_commit_size = min_t(uint64_t, oi->i_commit_size, len + start);
+
+	or = osd_start_request(sbi->s_dev, GFP_KERNEL);
+	if (unlikely(!or)) {
+		EXOFS_ERR("ERROR: writepage failed.\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	obj.partition = sbi->s_pid;
+	obj.id = inode->i_ino + EXOFS_OBJ_OFF;
+	ret = osd_req_write_pages(or, &obj, start, len, &page, 1);
+	if (ret)
+		goto fail;
+
+	ret = exofs_async_op(or, writepage_done, page, oi->i_cred);
+	if (ret)
+		goto fail;
+
+	atomic_inc(&sbi->s_curr_pending);
+out:
+	return ret;
+fail:
+	if (or)
+		osd_end_request(or);
+	set_bit(AS_EIO, &page->mapping->flags);
+	end_page_writeback(page);
+	unlock_page(page);
+	goto out;
+}
+
+int exofs_write_begin(struct file *file, struct address_space *mapping,
+		loff_t pos, unsigned len, unsigned flags,
+		struct page **pagep, void **fsdata)
+{
+	int ret = 0;
+	struct page *page;
+
+	page = *pagep;
+	if (page == NULL) {
+		ret = simple_write_begin(file, mapping, pos, len, flags, pagep,
+					 fsdata);
+		if (ret) {
+			EXOFS_DBGMSG("simple_write_begin faild\n");
+			return ret;
+		}
+
+		page = *pagep;
+	}
+
+	 /* read modify write */
+	if (!PageUptodate(page) && (len != PAGE_CACHE_SIZE)) {
+		ret = __readpage_filler(page, false);
+		if (ret) {
+			/*SetPageError was done by readpage_filler. Is it ok?*/
+			unlock_page(page);
+			EXOFS_DBGMSG("__readpage_filler faild\n");
+		}
+	}
+
+	return ret;
+}
+
+static int exofs_write_begin_export(struct file *file,
+		struct address_space *mapping,
+		loff_t pos, unsigned len, unsigned flags,
+		struct page **pagep, void **fsdata)
+{
+	*pagep = NULL;
+
+	return exofs_write_begin(file, mapping, pos, len, flags, pagep,
+					fsdata);
+}
+
+const struct address_space_operations exofs_aops = {
+	.readpage	= exofs_readpage,
+	.readpages	= exofs_readpages,
+	.writepage	= exofs_writepage,
+	.write_begin	= exofs_write_begin_export,
+	.write_end	= simple_write_end,
+	.writepages	= generic_writepages,
+};
+
 /******************************************************************************
  * INODE OPERATIONS
  *****************************************************************************/
-- 
1.6.0.1


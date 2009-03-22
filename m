Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbZCVOBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbZCVOBe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 10:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZCVOBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 10:01:21 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:24945 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751850AbZCVOBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 10:01:19 -0400
Message-ID: <49C64416.4060801@panasas.com>
Date: Sun, 22 Mar 2009 15:58:46 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 4/8 ver5] exofs: address_space_operations
References: <49C1331D.1080805@panasas.com> <1237399473-29344-1-git-send-email-bharrosh@panasas.com>
In-Reply-To: <1237399473-29344-1-git-send-email-bharrosh@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Mar 2009 14:00:10.0604 (UTC) FILETIME=[83C2FAC0:01C9AAF6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK Now we start to read and write from osd-objects. We try to
collect at most contiguous pages as possible in a single write/read.
The first page index is the object's offset.

TODO:
   In 64-bit a single bio can carry at most 128 pages.
   Add support of chaining multiple bios

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/exofs/exofs.h |    6 +
 fs/exofs/inode.c |  691 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 697 insertions(+), 0 deletions(-)

diff --git a/fs/exofs/exofs.h b/fs/exofs/exofs.h
index d3b8bde..f30de6e 100644
--- a/fs/exofs/exofs.h
+++ b/fs/exofs/exofs.h
@@ -130,6 +130,9 @@ static inline struct exofs_i_info *exofs_i(struct inode *inode)
 /* inode.c               */
 void exofs_truncate(struct inode *inode);
 int exofs_setattr(struct dentry *, struct iattr *);
+int exofs_write_begin(struct file *file, struct address_space *mapping,
+		loff_t pos, unsigned len, unsigned flags,
+		struct page **pagep, void **fsdata);
 
 /*********************
  * operation vectors *
@@ -138,6 +141,9 @@ int exofs_setattr(struct dentry *, struct iattr *);
 extern const struct inode_operations exofs_file_inode_operations;
 extern const struct file_operations exofs_file_operations;
 
+/* inode.c           */
+extern const struct address_space_operations exofs_aops;
+
 /* symlink.c         */
 extern const struct inode_operations exofs_symlink_inode_operations;
 extern const struct inode_operations exofs_fast_symlink_inode_operations;
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index b0bda1e..ab7b56e 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -35,6 +35,7 @@
 
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
+#include <scsi/scsi_device.h>
 
 #include "exofs.h"
 
@@ -42,6 +43,696 @@
 #  define EXOFS_DEBUG_OBJ_ISIZE 1
 #endif
 
+struct page_collect {
+	struct exofs_sb_info *sbi;
+	struct request_queue *req_q;
+	struct inode *inode;
+	unsigned expected_pages;
+
+	struct bio *bio;
+	unsigned nr_pages;
+	unsigned long length;
+	long pg_first;
+};
+
+static void _pcol_init(struct page_collect *pcol, unsigned expected_pages,
+		struct inode *inode)
+{
+	struct exofs_sb_info *sbi = inode->i_sb->s_fs_info;
+	struct request_queue *req_q = sbi->s_dev->scsi_device->request_queue;
+
+	pcol->sbi = sbi;
+	pcol->req_q = req_q;
+	pcol->inode = inode;
+	pcol->expected_pages = expected_pages;
+
+	pcol->bio = NULL;
+	pcol->nr_pages = 0;
+	pcol->length = 0;
+	pcol->pg_first = -1;
+
+	EXOFS_DBGMSG("_pcol_init ino=0x%lx expected_pages=%u\n", inode->i_ino,
+		     expected_pages);
+}
+
+static void _pcol_reset(struct page_collect *pcol)
+{
+	pcol->expected_pages -= min(pcol->nr_pages, pcol->expected_pages);
+
+	pcol->bio = NULL;
+	pcol->nr_pages = 0;
+	pcol->length = 0;
+	pcol->pg_first = -1;
+	EXOFS_DBGMSG("_pcol_reset ino=0x%lx expected_pages=%u\n",
+		     pcol->inode->i_ino, pcol->expected_pages);
+
+	/* this is probably the end of the loop but in writes
+	 * it might not end here. don't be left with nothing
+	 */
+	if (!pcol->expected_pages)
+		pcol->expected_pages = 128;
+}
+
+static int pcol_try_alloc(struct page_collect *pcol)
+{
+	int pages = min_t(unsigned, pcol->expected_pages, BIO_MAX_PAGES);
+
+	for (; pages; pages >>= 1) {
+		pcol->bio = bio_alloc(GFP_KERNEL, pages);
+		if (likely(pcol->bio))
+			return 0;
+	}
+
+	EXOFS_ERR("Failed to kcalloc expected_pages=%u\n",
+		  pcol->expected_pages);
+	return -ENOMEM;
+}
+
+static void pcol_free(struct page_collect *pcol)
+{
+	bio_put(pcol->bio);
+	pcol->bio = NULL;
+}
+
+static int pcol_add_page(struct page_collect *pcol, struct page *page,
+			 unsigned len)
+{
+	int added_len = bio_add_pc_page(pcol->req_q, pcol->bio, page, len, 0);
+	if (unlikely(len != added_len))
+		return -ENOMEM;
+
+	++pcol->nr_pages;
+	pcol->length += len;
+	return 0;
+}
+
+static int update_read_page(struct page *page, int ret)
+{
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
+		ret = 0; /* recovered error */
+	} else /* Error */
+		SetPageError(page);
+
+	return ret;
+}
+
+static void update_write_page(struct page *page, int ret)
+{
+	if (ret) {
+		mapping_set_error(page->mapping, ret);
+		SetPageError(page);
+	}
+	end_page_writeback(page);
+}
+
+static int _readpage(struct page *page, bool is_sync);
+
+static int __readpages_done(struct osd_request *or, struct page_collect *pcol,
+			    bool do_unlock)
+{
+	struct bio_vec *bvec;
+	int i;
+	u64 resid;
+	u64 good_bytes;
+	u64 length = 0;
+	int ret = exofs_check_ok_resid(or, &resid, NULL);
+
+	osd_end_request(or);
+
+	if (likely(!ret))
+		good_bytes = pcol->length;
+	else if (!resid)
+		good_bytes = 0;
+	else
+		good_bytes = pcol->length - resid;
+
+	EXOFS_DBGMSG("readpages_done(%ld) good_bytes=%llx"
+		     " length=%zx nr_pages=%u\n",
+		     pcol->inode->i_ino, _LLU(good_bytes), pcol->length,
+		     pcol->nr_pages);
+
+	__bio_for_each_segment(bvec, pcol->bio, i, 0) {
+		struct page *page = bvec->bv_page;
+		struct inode *inode = page->mapping->host;
+
+		if (inode != pcol->inode)
+			continue; /* osd might add more pages at end */
+
+		if ((length < good_bytes) || (i == 0)) {
+			ret = update_read_page(page, (i == 0) ? ret : 0);
+			if (do_unlock)
+				unlock_page(page);
+			EXOFS_DBGMSG("    readpages_done(%ld, %ld)\n",
+				     inode->i_ino, page->index);
+		} else {
+			/* can not happen on single sync_readpage */
+			BUG_ON(!do_unlock);
+
+			/* try a single page read and only then it is
+			 * marked as SetPageError()
+			 */
+			EXOFS_ERR("    readpages_done(%ld, %ld) bad_bytes\n",
+				     inode->i_ino, page->index);
+			_readpage(page, false);
+		}
+
+		length += bvec->bv_len;
+	}
+
+	pcol_free(pcol);
+	EXOFS_DBGMSG("readpages_done END\n");
+	return ret;
+}
+
+static void readpages_done(struct osd_request *or, void *p)
+{
+	struct page_collect *pcol = p;
+
+	__readpages_done(or, pcol, true);
+	atomic_dec(&pcol->sbi->s_curr_pending);
+	kfree(p);
+}
+
+static void _unlock_pcol_pages(struct page_collect *pcol, int ret, int rw)
+{
+	struct bio_vec *bvec;
+	int i;
+
+	__bio_for_each_segment(bvec, pcol->bio, i, 0) {
+		struct page *page = bvec->bv_page;
+
+		if (rw == READ)
+			update_read_page(page, ret);
+		else
+			update_write_page(page, ret);
+
+		unlock_page(page);
+	}
+	pcol_free(pcol);
+}
+
+static int read_exec(struct page_collect *pcol, bool is_sync)
+{
+	struct exofs_i_info *oi = exofs_i(pcol->inode);
+	struct osd_obj_id obj = {pcol->sbi->s_pid,
+					pcol->inode->i_ino + EXOFS_OBJ_OFF};
+	struct osd_request *or = NULL;
+	struct page_collect *pcol_copy = NULL;
+	loff_t i_start = pcol->pg_first << PAGE_CACHE_SHIFT;
+	int ret;
+
+	if (!pcol->bio)
+		return 0;
+
+	/* see comment in _readpage() about sync reads */
+	WARN_ON(is_sync && (pcol->nr_pages != 1));
+
+	or = osd_start_request(pcol->sbi->s_dev, GFP_KERNEL);
+	if (unlikely(!or)) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	osd_req_read(or, &obj, pcol->bio, i_start);
+
+	if (is_sync) {
+		exofs_sync_op(or, pcol->sbi->s_timeout, oi->i_cred);
+		return __readpages_done(or, pcol, false);
+	}
+
+	pcol_copy = kmalloc(sizeof(*pcol_copy), GFP_KERNEL);
+	if (!pcol_copy) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	*pcol_copy = *pcol;
+	ret = exofs_async_op(or, readpages_done, pcol_copy, oi->i_cred);
+	if (unlikely(ret))
+		goto err;
+
+	atomic_inc(&pcol->sbi->s_curr_pending);
+
+	EXOFS_DBGMSG("read_exec obj=%llx start=%llx length=%zx\n",
+		  obj.id, _LLU(i_start), pcol->length);
+
+	/* pages ownership was passed to pcol_copy */
+	_pcol_reset(pcol);
+	return 0;
+
+err:
+	if (!is_sync)
+		_unlock_pcol_pages(pcol, ret, READ);
+	kfree(pcol_copy);
+	if (or)
+		osd_end_request(or);
+	return ret;
+}
+
+static int readpage_strip(void *data, struct page *page)
+{
+	struct page_collect *pcol = data;
+	struct inode *inode = pcol->inode;
+	struct exofs_i_info *oi = exofs_i(inode);
+	loff_t i_size = i_size_read(inode);
+	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
+	size_t len;
+	int ret;
+
+	/* FIXME: Just for debugging, will be removed */
+	if (PageUptodate(page))
+		EXOFS_ERR("PageUptodate(%ld, %ld)\n", pcol->inode->i_ino,
+			  page->index);
+
+	if (page->index < end_index)
+		len = PAGE_CACHE_SIZE;
+	else if (page->index == end_index)
+		len = i_size & ~PAGE_CACHE_MASK;
+	else
+		len = 0;
+
+	if (!len || !obj_created(oi)) {
+		/* this will be out of bounds, or doesn't exist yet.
+		 * Current page is cleared and the request is split
+		 */
+		clear_highpage(page);
+
+		SetPageUptodate(page);
+		if (PageError(page))
+			ClearPageError(page);
+
+		unlock_page(page);
+		EXOFS_DBGMSG("readpage_strip(%ld, %ld) empty page, splitting\n",
+			     inode->i_ino, page->index);
+
+		return read_exec(pcol, false);
+	}
+
+try_again:
+
+	if (unlikely(pcol->pg_first == -1)) {
+		pcol->pg_first = page->index;
+	} else if (unlikely((pcol->pg_first + pcol->nr_pages) !=
+		   page->index)) {
+		/* Discontinuity detected, split the request */
+		ret = read_exec(pcol, false);
+		if (unlikely(ret))
+			goto fail;
+		goto try_again;
+	}
+
+	if (!pcol->bio) {
+		ret = pcol_try_alloc(pcol);
+		if (unlikely(ret))
+			goto fail;
+	}
+
+	if (len != PAGE_CACHE_SIZE)
+		zero_user(page, len, PAGE_CACHE_SIZE - len);
+
+	EXOFS_DBGMSG("    readpage_strip(%ld, %ld) len=%zx\n", inode->i_ino,
+		  page->index, len);
+
+	ret = pcol_add_page(pcol, page, len);
+	if (ret) {
+		EXOFS_DBGMSG("Failed pcol_add_page pages[i]=%p "
+			  "len=%zx nr_pages=%u length=%zx\n",
+			  page, len, pcol->nr_pages, pcol->length);
+
+		/* split the request, and start again with current page */
+		ret = read_exec(pcol, false);
+		if (unlikely(ret))
+			goto fail;
+
+		goto try_again;
+	}
+
+	return 0;
+
+fail:
+	/* SetPageError(page); ??? */
+	unlock_page(page);
+	return ret;
+}
+
+static int exofs_readpages(struct file *file, struct address_space *mapping,
+			   struct list_head *pages, unsigned nr_pages)
+{
+	struct page_collect pcol;
+	int ret;
+
+	_pcol_init(&pcol, nr_pages, mapping->host);
+
+	ret = read_cache_pages(mapping, pages, readpage_strip, &pcol);
+	if (ret) {
+		EXOFS_ERR("read_cache_pages => %d\n", ret);
+		return ret;
+	}
+
+	return read_exec(&pcol, false);
+}
+
+static int _readpage(struct page *page, bool is_sync)
+{
+	struct page_collect pcol;
+	int ret;
+
+	_pcol_init(&pcol, 1, page->mapping->host);
+
+	/* readpage_strip might call read_exec(,async) inside at several places
+	 * but this is safe for is_async=0 since read_exec will not do anything
+	 * when we have a single page.
+	 */
+	ret = readpage_strip(&pcol, page);
+	if (ret) {
+		EXOFS_ERR("_readpage => %d\n", ret);
+		return ret;
+	}
+
+	return read_exec(&pcol, is_sync);
+}
+
+/*
+ * We don't need the file
+ */
+static int exofs_readpage(struct file *file, struct page *page)
+{
+	return _readpage(page, false);
+}
+
+static int exofs_writepage(struct page *page, struct writeback_control *wbc2);
+
+static void writepages_done(struct osd_request *or, void *p)
+{
+	struct page_collect *pcol = p;
+	struct bio_vec *bvec;
+	int i;
+	u64 resid;
+	u64  good_bytes;
+	u64  length = 0;
+
+	int ret = exofs_check_ok_resid(or, NULL, &resid);
+
+	osd_end_request(or);
+	atomic_dec(&pcol->sbi->s_curr_pending);
+
+	if (likely(!ret))
+		good_bytes = pcol->length;
+	else if (!resid)
+		good_bytes = 0;
+	else
+		good_bytes = pcol->length - resid;
+
+	EXOFS_DBGMSG("writepages_done(%lx) good_bytes=%llx"
+		     " length=%zx nr_pages=%u\n",
+		     pcol->inode->i_ino, _LLU(good_bytes), pcol->length,
+		     pcol->nr_pages);
+
+	__bio_for_each_segment(bvec, pcol->bio, i, 0) {
+		struct page *page = bvec->bv_page;
+		struct inode *inode = page->mapping->host;
+
+		if (inode != pcol->inode)
+			continue; /* osd might add more pages to a bio */
+
+		if ((length < good_bytes) || (i == 0)) {
+			update_write_page(page, ret);
+			unlock_page(page);
+			EXOFS_DBGMSG("    writepages_done(%lx, %lx)"
+				     " good_bytes ret=%x\n",
+				     inode->i_ino, page->index, ret);
+		} else {
+			/* try a single page write and only then it is
+			 * marked as SetPageError()
+			 */
+			EXOFS_ERR("    writepages_done(%lx, %lx) bad_bytes\n",
+				     inode->i_ino, page->index);
+
+			exofs_writepage(page, NULL);
+		}
+
+		length += bvec->bv_len;
+	}
+
+	pcol_free(pcol);
+	kfree(pcol);
+	EXOFS_DBGMSG("writepages_done END\n");
+}
+
+static int write_exec(struct page_collect *pcol)
+{
+	struct exofs_i_info *oi = exofs_i(pcol->inode);
+	struct osd_obj_id obj = {pcol->sbi->s_pid,
+					pcol->inode->i_ino + EXOFS_OBJ_OFF};
+	struct osd_request *or = NULL;
+	struct page_collect *pcol_copy = NULL;
+	loff_t i_start = pcol->pg_first << PAGE_CACHE_SHIFT;
+	int ret;
+
+	if (!pcol->bio)
+		return 0;
+
+	or = osd_start_request(pcol->sbi->s_dev, GFP_KERNEL);
+	if (unlikely(!or)) {
+		EXOFS_ERR("write_exec: Faild to osd_start_request()\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	pcol_copy = kmalloc(sizeof(*pcol_copy), GFP_KERNEL);
+	if (!pcol_copy) {
+		EXOFS_ERR("write_exec: Faild to kmalloc(pcol)\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	*pcol_copy = *pcol;
+
+	osd_req_write(or, &obj, pcol_copy->bio, i_start);
+	ret = exofs_async_op(or, writepages_done, pcol_copy, oi->i_cred);
+	if (unlikely(ret)) {
+		EXOFS_ERR("write_exec: exofs_async_op() Faild\n");
+		goto err;
+	}
+
+	atomic_inc(&pcol->sbi->s_curr_pending);
+	EXOFS_DBGMSG("write_exec(%lx, %lx) start=%llx length=%zx\n",
+		  pcol->inode->i_ino, pcol->pg_first, _LLU(i_start),
+		  pcol->length);
+	/* pages ownership was passed to pcol_copy */
+	_pcol_reset(pcol);
+	return 0;
+
+err:
+	_unlock_pcol_pages(pcol, ret, WRITE);
+	kfree(pcol_copy);
+	if (or)
+		osd_end_request(or);
+	return ret;
+}
+
+static int writepage_strip(struct page *page,
+			   struct writeback_control *wbc_unused, void *data)
+{
+	struct page_collect *pcol = data;
+	struct inode *inode = pcol->inode;
+	struct exofs_i_info *oi = exofs_i(inode);
+	loff_t i_size = i_size_read(inode);
+	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
+	size_t len;
+	int ret;
+
+	BUG_ON(!PageLocked(page));
+
+	ret = wait_obj_created(oi);
+	if (unlikely(ret))
+		goto fail;
+
+	if (page->index < end_index)
+		/* in this case, the page is within the limits of the file */
+		len = PAGE_CACHE_SIZE;
+	else {
+		len = i_size & ~PAGE_CACHE_MASK;
+
+		if (page->index > end_index || !len) {
+			/* in this case, the page is outside the limits
+			 * (truncate in progress)
+			 */
+			ret = write_exec(pcol);
+			if (unlikely(ret))
+				goto fail;
+			if (PageError(page))
+				ClearPageError(page);
+			unlock_page(page);
+			return 0;
+		}
+	}
+
+try_again:
+
+	if (unlikely(pcol->pg_first == -1)) {
+		pcol->pg_first = page->index;
+	} else if (unlikely((pcol->pg_first + pcol->nr_pages) !=
+		   page->index)) {
+		/* Discontinuity detected, split the request */
+		ret = write_exec(pcol);
+		if (unlikely(ret))
+			goto fail;
+		goto try_again;
+	}
+
+	if (!pcol->bio) {
+		ret = pcol_try_alloc(pcol);
+		if (unlikely(ret))
+			goto fail;
+	}
+
+	EXOFS_DBGMSG("    writepage_strip(%lx, %lx) len=%zx\n", inode->i_ino,
+		  page->index, len);
+
+	ret = pcol_add_page(pcol, page, len);
+	if (unlikely(ret)) {
+		EXOFS_DBGMSG("Failed pcol_add_page "
+			     "nr_pages=%u total_length=%zx\n",
+			     pcol->nr_pages, pcol->length);
+
+		/* split the request, next loop will start again */
+		ret = write_exec(pcol);
+		if (unlikely(ret)) {
+			EXOFS_DBGMSG("write_exec faild => %d", ret);
+			goto fail;
+		}
+
+		goto try_again;
+	}
+
+	BUG_ON(PageWriteback(page));
+	set_page_writeback(page);
+
+	return 0;
+
+fail:
+	set_bit(AS_EIO, &page->mapping->flags);
+	unlock_page(page);
+	return ret;
+}
+
+static int exofs_writepages(struct address_space *mapping,
+		       struct writeback_control *wbc)
+{
+	struct page_collect pcol;
+	long start, end, expected_pages;
+	int ret;
+
+	start = wbc->range_start >> PAGE_CACHE_SHIFT;
+	end = (wbc->range_end == LLONG_MAX) ?
+			start + mapping->nrpages :
+			wbc->range_end >> PAGE_CACHE_SHIFT;
+
+	if (start || end)
+		expected_pages = min(end - start + 1, 32L);
+	else
+		expected_pages = mapping->nrpages;
+
+	EXOFS_DBGMSG("inode(%lx) wbc->start=0x%llx wbc->end=0x%llx"
+		     " m->nrpages=%lu start=%ld end=%ld\n",
+		     mapping->host->i_ino, wbc->range_start, wbc->range_end,
+		     mapping->nrpages, start, end);
+
+	_pcol_init(&pcol, expected_pages, mapping->host);
+
+	ret = write_cache_pages(mapping, wbc, writepage_strip, &pcol);
+	if (ret) {
+		EXOFS_ERR("write_cache_pages => %d\n", ret);
+		return ret;
+	}
+
+	return write_exec(&pcol);
+}
+
+static int exofs_writepage(struct page *page, struct writeback_control *wbc)
+{
+	struct page_collect pcol;
+	int ret;
+
+	_pcol_init(&pcol, 1, page->mapping->host);
+
+	ret = writepage_strip(page, NULL, &pcol);
+	if (ret) {
+		EXOFS_ERR("exofs_writepage => %d\n", ret);
+		return ret;
+	}
+
+	return write_exec(&pcol);
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
+		ret = _readpage(page, true);
+		if (ret) {
+			/*SetPageError was done by _readpage. Is it ok?*/
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
+	.writepages	= exofs_writepages,
+	.write_begin	= exofs_write_begin_export,
+	.write_end	= simple_write_end,
+};
+
 /******************************************************************************
  * INODE OPERATIONS
  *****************************************************************************/
-- 
1.6.2.1



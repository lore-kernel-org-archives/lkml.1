Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbZFJJlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbZFJJlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757377AbZFJJib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40316 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600AbZFJJiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:38:14 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 14/24] GFS2: Clean up some file names
Date: Wed, 10 Jun 2009 09:30:55 +0100
Message-Id: <1244622665-7470-15-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-14-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-5-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-6-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-7-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-8-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-9-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-10-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-11-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-12-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-13-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-14-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames the ops_*.c files which have no counterpart
without the ops_ prefix in order to shorten the name and make
it more readable. In addition, ops_address.h (which was very
small) is moved into inode.h and inode.h is cleaned up by
adding extern where required.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/Makefile b/fs/gfs2/Makefile
index a851ea4..4f7332c 100644
--- a/fs/gfs2/Makefile
+++ b/fs/gfs2/Makefile
@@ -1,7 +1,7 @@
 obj-$(CONFIG_GFS2_FS) += gfs2.o
 gfs2-y := acl.o bmap.o dir.o eaops.o eattr.o glock.o \
 	glops.o inode.o log.o lops.o main.o meta_io.o \
-	mount.o ops_address.o ops_dentry.o ops_export.o ops_file.o \
+	mount.o aops.o dentry.o export.o file.o \
 	ops_fstype.o ops_inode.o ops_super.o quota.o \
 	recovery.o rgrp.o super.o sys.o trans.o util.o
 
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
new file mode 100644
index 0000000..03ebb43
--- /dev/null
+++ b/fs/gfs2/aops.c
@@ -0,0 +1,1145 @@
+/*
+ * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
+ * Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License version 2.
+ */
+
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/completion.h>
+#include <linux/buffer_head.h>
+#include <linux/pagemap.h>
+#include <linux/pagevec.h>
+#include <linux/mpage.h>
+#include <linux/fs.h>
+#include <linux/writeback.h>
+#include <linux/swap.h>
+#include <linux/gfs2_ondisk.h>
+#include <linux/backing-dev.h>
+
+#include "gfs2.h"
+#include "incore.h"
+#include "bmap.h"
+#include "glock.h"
+#include "inode.h"
+#include "log.h"
+#include "meta_io.h"
+#include "quota.h"
+#include "trans.h"
+#include "rgrp.h"
+#include "super.h"
+#include "util.h"
+#include "glops.h"
+
+
+static void gfs2_page_add_databufs(struct gfs2_inode *ip, struct page *page,
+				   unsigned int from, unsigned int to)
+{
+	struct buffer_head *head = page_buffers(page);
+	unsigned int bsize = head->b_size;
+	struct buffer_head *bh;
+	unsigned int start, end;
+
+	for (bh = head, start = 0; bh != head || !start;
+	     bh = bh->b_this_page, start = end) {
+		end = start + bsize;
+		if (end <= from || start >= to)
+			continue;
+		if (gfs2_is_jdata(ip))
+			set_buffer_uptodate(bh);
+		gfs2_trans_add_bh(ip->i_gl, bh, 0);
+	}
+}
+
+/**
+ * gfs2_get_block_noalloc - Fills in a buffer head with details about a block
+ * @inode: The inode
+ * @lblock: The block number to look up
+ * @bh_result: The buffer head to return the result in
+ * @create: Non-zero if we may add block to the file
+ *
+ * Returns: errno
+ */
+
+static int gfs2_get_block_noalloc(struct inode *inode, sector_t lblock,
+				  struct buffer_head *bh_result, int create)
+{
+	int error;
+
+	error = gfs2_block_map(inode, lblock, bh_result, 0);
+	if (error)
+		return error;
+	if (!buffer_mapped(bh_result))
+		return -EIO;
+	return 0;
+}
+
+static int gfs2_get_block_direct(struct inode *inode, sector_t lblock,
+				 struct buffer_head *bh_result, int create)
+{
+	return gfs2_block_map(inode, lblock, bh_result, 0);
+}
+
+/**
+ * gfs2_writepage_common - Common bits of writepage
+ * @page: The page to be written
+ * @wbc: The writeback control
+ *
+ * Returns: 1 if writepage is ok, otherwise an error code or zero if no error.
+ */
+
+static int gfs2_writepage_common(struct page *page,
+				 struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	loff_t i_size = i_size_read(inode);
+	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
+	unsigned offset;
+
+	if (gfs2_assert_withdraw(sdp, gfs2_glock_is_held_excl(ip->i_gl)))
+		goto out;
+	if (current->journal_info)
+		goto redirty;
+	/* Is the page fully outside i_size? (truncate in progress) */
+	offset = i_size & (PAGE_CACHE_SIZE-1);
+	if (page->index > end_index || (page->index == end_index && !offset)) {
+		page->mapping->a_ops->invalidatepage(page, 0);
+		goto out;
+	}
+	return 1;
+redirty:
+	redirty_page_for_writepage(wbc, page);
+out:
+	unlock_page(page);
+	return 0;
+}
+
+/**
+ * gfs2_writeback_writepage - Write page for writeback mappings
+ * @page: The page
+ * @wbc: The writeback control
+ *
+ */
+
+static int gfs2_writeback_writepage(struct page *page,
+				    struct writeback_control *wbc)
+{
+	int ret;
+
+	ret = gfs2_writepage_common(page, wbc);
+	if (ret <= 0)
+		return ret;
+
+	ret = mpage_writepage(page, gfs2_get_block_noalloc, wbc);
+	if (ret == -EAGAIN)
+		ret = block_write_full_page(page, gfs2_get_block_noalloc, wbc);
+	return ret;
+}
+
+/**
+ * gfs2_ordered_writepage - Write page for ordered data files
+ * @page: The page to write
+ * @wbc: The writeback control
+ *
+ */
+
+static int gfs2_ordered_writepage(struct page *page,
+				  struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	struct gfs2_inode *ip = GFS2_I(inode);
+	int ret;
+
+	ret = gfs2_writepage_common(page, wbc);
+	if (ret <= 0)
+		return ret;
+
+	if (!page_has_buffers(page)) {
+		create_empty_buffers(page, inode->i_sb->s_blocksize,
+				     (1 << BH_Dirty)|(1 << BH_Uptodate));
+	}
+	gfs2_page_add_databufs(ip, page, 0, inode->i_sb->s_blocksize-1);
+	return block_write_full_page(page, gfs2_get_block_noalloc, wbc);
+}
+
+/**
+ * __gfs2_jdata_writepage - The core of jdata writepage
+ * @page: The page to write
+ * @wbc: The writeback control
+ *
+ * This is shared between writepage and writepages and implements the
+ * core of the writepage operation. If a transaction is required then
+ * PageChecked will have been set and the transaction will have
+ * already been started before this is called.
+ */
+
+static int __gfs2_jdata_writepage(struct page *page, struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+
+	if (PageChecked(page)) {
+		ClearPageChecked(page);
+		if (!page_has_buffers(page)) {
+			create_empty_buffers(page, inode->i_sb->s_blocksize,
+					     (1 << BH_Dirty)|(1 << BH_Uptodate));
+		}
+		gfs2_page_add_databufs(ip, page, 0, sdp->sd_vfs->s_blocksize-1);
+	}
+	return block_write_full_page(page, gfs2_get_block_noalloc, wbc);
+}
+
+/**
+ * gfs2_jdata_writepage - Write complete page
+ * @page: Page to write
+ *
+ * Returns: errno
+ *
+ */
+
+static int gfs2_jdata_writepage(struct page *page, struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	int ret;
+	int done_trans = 0;
+
+	if (PageChecked(page)) {
+		if (wbc->sync_mode != WB_SYNC_ALL)
+			goto out_ignore;
+		ret = gfs2_trans_begin(sdp, RES_DINODE + 1, 0);
+		if (ret)
+			goto out_ignore;
+		done_trans = 1;
+	}
+	ret = gfs2_writepage_common(page, wbc);
+	if (ret > 0)
+		ret = __gfs2_jdata_writepage(page, wbc);
+	if (done_trans)
+		gfs2_trans_end(sdp);
+	return ret;
+
+out_ignore:
+	redirty_page_for_writepage(wbc, page);
+	unlock_page(page);
+	return 0;
+}
+
+/**
+ * gfs2_writeback_writepages - Write a bunch of dirty pages back to disk
+ * @mapping: The mapping to write
+ * @wbc: Write-back control
+ *
+ * For the data=writeback case we can already ignore buffer heads
+ * and write whole extents at once. This is a big reduction in the
+ * number of I/O requests we send and the bmap calls we make in this case.
+ */
+static int gfs2_writeback_writepages(struct address_space *mapping,
+				     struct writeback_control *wbc)
+{
+	return mpage_writepages(mapping, wbc, gfs2_get_block_noalloc);
+}
+
+/**
+ * gfs2_write_jdata_pagevec - Write back a pagevec's worth of pages
+ * @mapping: The mapping
+ * @wbc: The writeback control
+ * @writepage: The writepage function to call for each page
+ * @pvec: The vector of pages
+ * @nr_pages: The number of pages to write
+ *
+ * Returns: non-zero if loop should terminate, zero otherwise
+ */
+
+static int gfs2_write_jdata_pagevec(struct address_space *mapping,
+				    struct writeback_control *wbc,
+				    struct pagevec *pvec,
+				    int nr_pages, pgoff_t end)
+{
+	struct inode *inode = mapping->host;
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	loff_t i_size = i_size_read(inode);
+	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
+	unsigned offset = i_size & (PAGE_CACHE_SIZE-1);
+	unsigned nrblocks = nr_pages * (PAGE_CACHE_SIZE/inode->i_sb->s_blocksize);
+	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	int i;
+	int ret;
+
+	ret = gfs2_trans_begin(sdp, nrblocks, nrblocks);
+	if (ret < 0)
+		return ret;
+
+	for(i = 0; i < nr_pages; i++) {
+		struct page *page = pvec->pages[i];
+
+		lock_page(page);
+
+		if (unlikely(page->mapping != mapping)) {
+			unlock_page(page);
+			continue;
+		}
+
+		if (!wbc->range_cyclic && page->index > end) {
+			ret = 1;
+			unlock_page(page);
+			continue;
+		}
+
+		if (wbc->sync_mode != WB_SYNC_NONE)
+			wait_on_page_writeback(page);
+
+		if (PageWriteback(page) ||
+		    !clear_page_dirty_for_io(page)) {
+			unlock_page(page);
+			continue;
+		}
+
+		/* Is the page fully outside i_size? (truncate in progress) */
+		if (page->index > end_index || (page->index == end_index && !offset)) {
+			page->mapping->a_ops->invalidatepage(page, 0);
+			unlock_page(page);
+			continue;
+		}
+
+		ret = __gfs2_jdata_writepage(page, wbc);
+
+		if (ret || (--(wbc->nr_to_write) <= 0))
+			ret = 1;
+		if (wbc->nonblocking && bdi_write_congested(bdi)) {
+			wbc->encountered_congestion = 1;
+			ret = 1;
+		}
+
+	}
+	gfs2_trans_end(sdp);
+	return ret;
+}
+
+/**
+ * gfs2_write_cache_jdata - Like write_cache_pages but different
+ * @mapping: The mapping to write
+ * @wbc: The writeback control
+ * @writepage: The writepage function to call
+ * @data: The data to pass to writepage
+ *
+ * The reason that we use our own function here is that we need to
+ * start transactions before we grab page locks. This allows us
+ * to get the ordering right.
+ */
+
+static int gfs2_write_cache_jdata(struct address_space *mapping,
+				  struct writeback_control *wbc)
+{
+	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	int ret = 0;
+	int done = 0;
+	struct pagevec pvec;
+	int nr_pages;
+	pgoff_t index;
+	pgoff_t end;
+	int scanned = 0;
+	int range_whole = 0;
+
+	if (wbc->nonblocking && bdi_write_congested(bdi)) {
+		wbc->encountered_congestion = 1;
+		return 0;
+	}
+
+	pagevec_init(&pvec, 0);
+	if (wbc->range_cyclic) {
+		index = mapping->writeback_index; /* Start from prev offset */
+		end = -1;
+	} else {
+		index = wbc->range_start >> PAGE_CACHE_SHIFT;
+		end = wbc->range_end >> PAGE_CACHE_SHIFT;
+		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
+			range_whole = 1;
+		scanned = 1;
+	}
+
+retry:
+	 while (!done && (index <= end) &&
+		(nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+					       PAGECACHE_TAG_DIRTY,
+					       min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
+		scanned = 1;
+		ret = gfs2_write_jdata_pagevec(mapping, wbc, &pvec, nr_pages, end);
+		if (ret)
+			done = 1;
+		if (ret > 0)
+			ret = 0;
+
+		pagevec_release(&pvec);
+		cond_resched();
+	}
+
+	if (!scanned && !done) {
+		/*
+		 * We hit the last page and there is more work to be done: wrap
+		 * back to the start of the file
+		 */
+		scanned = 1;
+		index = 0;
+		goto retry;
+	}
+
+	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
+		mapping->writeback_index = index;
+	return ret;
+}
+
+
+/**
+ * gfs2_jdata_writepages - Write a bunch of dirty pages back to disk
+ * @mapping: The mapping to write
+ * @wbc: The writeback control
+ * 
+ */
+
+static int gfs2_jdata_writepages(struct address_space *mapping,
+				 struct writeback_control *wbc)
+{
+	struct gfs2_inode *ip = GFS2_I(mapping->host);
+	struct gfs2_sbd *sdp = GFS2_SB(mapping->host);
+	int ret;
+
+	ret = gfs2_write_cache_jdata(mapping, wbc);
+	if (ret == 0 && wbc->sync_mode == WB_SYNC_ALL) {
+		gfs2_log_flush(sdp, ip->i_gl);
+		ret = gfs2_write_cache_jdata(mapping, wbc);
+	}
+	return ret;
+}
+
+/**
+ * stuffed_readpage - Fill in a Linux page with stuffed file data
+ * @ip: the inode
+ * @page: the page
+ *
+ * Returns: errno
+ */
+
+static int stuffed_readpage(struct gfs2_inode *ip, struct page *page)
+{
+	struct buffer_head *dibh;
+	void *kaddr;
+	int error;
+
+	/*
+	 * Due to the order of unstuffing files and ->fault(), we can be
+	 * asked for a zero page in the case of a stuffed file being extended,
+	 * so we need to supply one here. It doesn't happen often.
+	 */
+	if (unlikely(page->index)) {
+		zero_user(page, 0, PAGE_CACHE_SIZE);
+		SetPageUptodate(page);
+		return 0;
+	}
+
+	error = gfs2_meta_inode_buffer(ip, &dibh);
+	if (error)
+		return error;
+
+	kaddr = kmap_atomic(page, KM_USER0);
+	memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode),
+	       ip->i_disksize);
+	memset(kaddr + ip->i_disksize, 0, PAGE_CACHE_SIZE - ip->i_disksize);
+	kunmap_atomic(kaddr, KM_USER0);
+	flush_dcache_page(page);
+	brelse(dibh);
+	SetPageUptodate(page);
+
+	return 0;
+}
+
+
+/**
+ * __gfs2_readpage - readpage
+ * @file: The file to read a page for
+ * @page: The page to read
+ *
+ * This is the core of gfs2's readpage. Its used by the internal file
+ * reading code as in that case we already hold the glock. Also its
+ * called by gfs2_readpage() once the required lock has been granted.
+ *
+ */
+
+static int __gfs2_readpage(void *file, struct page *page)
+{
+	struct gfs2_inode *ip = GFS2_I(page->mapping->host);
+	struct gfs2_sbd *sdp = GFS2_SB(page->mapping->host);
+	int error;
+
+	if (gfs2_is_stuffed(ip)) {
+		error = stuffed_readpage(ip, page);
+		unlock_page(page);
+	} else {
+		error = mpage_readpage(page, gfs2_block_map);
+	}
+
+	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+		return -EIO;
+
+	return error;
+}
+
+/**
+ * gfs2_readpage - read a page of a file
+ * @file: The file to read
+ * @page: The page of the file
+ *
+ * This deals with the locking required. We have to unlock and
+ * relock the page in order to get the locking in the right
+ * order.
+ */
+
+static int gfs2_readpage(struct file *file, struct page *page)
+{
+	struct address_space *mapping = page->mapping;
+	struct gfs2_inode *ip = GFS2_I(mapping->host);
+	struct gfs2_holder gh;
+	int error;
+
+	unlock_page(page);
+	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
+	error = gfs2_glock_nq(&gh);
+	if (unlikely(error))
+		goto out;
+	error = AOP_TRUNCATED_PAGE;
+	lock_page(page);
+	if (page->mapping == mapping && !PageUptodate(page))
+		error = __gfs2_readpage(file, page);
+	else
+		unlock_page(page);
+	gfs2_glock_dq(&gh);
+out:
+	gfs2_holder_uninit(&gh);
+	if (error && error != AOP_TRUNCATED_PAGE)
+		lock_page(page);
+	return error;
+}
+
+/**
+ * gfs2_internal_read - read an internal file
+ * @ip: The gfs2 inode
+ * @ra_state: The readahead state (or NULL for no readahead)
+ * @buf: The buffer to fill
+ * @pos: The file position
+ * @size: The amount to read
+ *
+ */
+
+int gfs2_internal_read(struct gfs2_inode *ip, struct file_ra_state *ra_state,
+                       char *buf, loff_t *pos, unsigned size)
+{
+	struct address_space *mapping = ip->i_inode.i_mapping;
+	unsigned long index = *pos / PAGE_CACHE_SIZE;
+	unsigned offset = *pos & (PAGE_CACHE_SIZE - 1);
+	unsigned copied = 0;
+	unsigned amt;
+	struct page *page;
+	void *p;
+
+	do {
+		amt = size - copied;
+		if (offset + size > PAGE_CACHE_SIZE)
+			amt = PAGE_CACHE_SIZE - offset;
+		page = read_cache_page(mapping, index, __gfs2_readpage, NULL);
+		if (IS_ERR(page))
+			return PTR_ERR(page);
+		p = kmap_atomic(page, KM_USER0);
+		memcpy(buf + copied, p + offset, amt);
+		kunmap_atomic(p, KM_USER0);
+		mark_page_accessed(page);
+		page_cache_release(page);
+		copied += amt;
+		index++;
+		offset = 0;
+	} while(copied < size);
+	(*pos) += size;
+	return size;
+}
+
+/**
+ * gfs2_readpages - Read a bunch of pages at once
+ *
+ * Some notes:
+ * 1. This is only for readahead, so we can simply ignore any things
+ *    which are slightly inconvenient (such as locking conflicts between
+ *    the page lock and the glock) and return having done no I/O. Its
+ *    obviously not something we'd want to do on too regular a basis.
+ *    Any I/O we ignore at this time will be done via readpage later.
+ * 2. We don't handle stuffed files here we let readpage do the honours.
+ * 3. mpage_readpages() does most of the heavy lifting in the common case.
+ * 4. gfs2_block_map() is relied upon to set BH_Boundary in the right places.
+ */
+
+static int gfs2_readpages(struct file *file, struct address_space *mapping,
+			  struct list_head *pages, unsigned nr_pages)
+{
+	struct inode *inode = mapping->host;
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct gfs2_holder gh;
+	int ret;
+
+	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
+	ret = gfs2_glock_nq(&gh);
+	if (unlikely(ret))
+		goto out_uninit;
+	if (!gfs2_is_stuffed(ip))
+		ret = mpage_readpages(mapping, pages, nr_pages, gfs2_block_map);
+	gfs2_glock_dq(&gh);
+out_uninit:
+	gfs2_holder_uninit(&gh);
+	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+		ret = -EIO;
+	return ret;
+}
+
+/**
+ * gfs2_write_begin - Begin to write to a file
+ * @file: The file to write to
+ * @mapping: The mapping in which to write
+ * @pos: The file offset at which to start writing
+ * @len: Length of the write
+ * @flags: Various flags
+ * @pagep: Pointer to return the page
+ * @fsdata: Pointer to return fs data (unused by GFS2)
+ *
+ * Returns: errno
+ */
+
+static int gfs2_write_begin(struct file *file, struct address_space *mapping,
+			    loff_t pos, unsigned len, unsigned flags,
+			    struct page **pagep, void **fsdata)
+{
+	struct gfs2_inode *ip = GFS2_I(mapping->host);
+	struct gfs2_sbd *sdp = GFS2_SB(mapping->host);
+	unsigned int data_blocks = 0, ind_blocks = 0, rblocks;
+	int alloc_required;
+	int error = 0;
+	struct gfs2_alloc *al;
+	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
+	unsigned from = pos & (PAGE_CACHE_SIZE - 1);
+	unsigned to = from + len;
+	struct page *page;
+
+	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &ip->i_gh);
+	error = gfs2_glock_nq(&ip->i_gh);
+	if (unlikely(error))
+		goto out_uninit;
+
+	error = gfs2_write_alloc_required(ip, pos, len, &alloc_required);
+	if (error)
+		goto out_unlock;
+
+	if (alloc_required || gfs2_is_jdata(ip))
+		gfs2_write_calc_reserv(ip, len, &data_blocks, &ind_blocks);
+
+	if (alloc_required) {
+		al = gfs2_alloc_get(ip);
+		if (!al) {
+			error = -ENOMEM;
+			goto out_unlock;
+		}
+
+		error = gfs2_quota_lock_check(ip);
+		if (error)
+			goto out_alloc_put;
+
+		al->al_requested = data_blocks + ind_blocks;
+		error = gfs2_inplace_reserve(ip);
+		if (error)
+			goto out_qunlock;
+	}
+
+	rblocks = RES_DINODE + ind_blocks;
+	if (gfs2_is_jdata(ip))
+		rblocks += data_blocks ? data_blocks : 1;
+	if (ind_blocks || data_blocks)
+		rblocks += RES_STATFS + RES_QUOTA;
+
+	error = gfs2_trans_begin(sdp, rblocks,
+				 PAGE_CACHE_SIZE/sdp->sd_sb.sb_bsize);
+	if (error)
+		goto out_trans_fail;
+
+	error = -ENOMEM;
+	flags |= AOP_FLAG_NOFS;
+	page = grab_cache_page_write_begin(mapping, index, flags);
+	*pagep = page;
+	if (unlikely(!page))
+		goto out_endtrans;
+
+	if (gfs2_is_stuffed(ip)) {
+		error = 0;
+		if (pos + len > sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode)) {
+			error = gfs2_unstuff_dinode(ip, page);
+			if (error == 0)
+				goto prepare_write;
+		} else if (!PageUptodate(page)) {
+			error = stuffed_readpage(ip, page);
+		}
+		goto out;
+	}
+
+prepare_write:
+	error = block_prepare_write(page, from, to, gfs2_block_map);
+out:
+	if (error == 0)
+		return 0;
+
+	page_cache_release(page);
+	if (pos + len > ip->i_inode.i_size)
+		vmtruncate(&ip->i_inode, ip->i_inode.i_size);
+out_endtrans:
+	gfs2_trans_end(sdp);
+out_trans_fail:
+	if (alloc_required) {
+		gfs2_inplace_release(ip);
+out_qunlock:
+		gfs2_quota_unlock(ip);
+out_alloc_put:
+		gfs2_alloc_put(ip);
+	}
+out_unlock:
+	gfs2_glock_dq(&ip->i_gh);
+out_uninit:
+	gfs2_holder_uninit(&ip->i_gh);
+	return error;
+}
+
+/**
+ * adjust_fs_space - Adjusts the free space available due to gfs2_grow
+ * @inode: the rindex inode
+ */
+static void adjust_fs_space(struct inode *inode)
+{
+	struct gfs2_sbd *sdp = inode->i_sb->s_fs_info;
+	struct gfs2_statfs_change_host *m_sc = &sdp->sd_statfs_master;
+	struct gfs2_statfs_change_host *l_sc = &sdp->sd_statfs_local;
+	u64 fs_total, new_free;
+
+	/* Total up the file system space, according to the latest rindex. */
+	fs_total = gfs2_ri_total(sdp);
+
+	spin_lock(&sdp->sd_statfs_spin);
+	if (fs_total > (m_sc->sc_total + l_sc->sc_total))
+		new_free = fs_total - (m_sc->sc_total + l_sc->sc_total);
+	else
+		new_free = 0;
+	spin_unlock(&sdp->sd_statfs_spin);
+	fs_warn(sdp, "File system extended by %llu blocks.\n",
+		(unsigned long long)new_free);
+	gfs2_statfs_change(sdp, new_free, new_free, 0);
+}
+
+/**
+ * gfs2_stuffed_write_end - Write end for stuffed files
+ * @inode: The inode
+ * @dibh: The buffer_head containing the on-disk inode
+ * @pos: The file position
+ * @len: The length of the write
+ * @copied: How much was actually copied by the VFS
+ * @page: The page
+ *
+ * This copies the data from the page into the inode block after
+ * the inode data structure itself.
+ *
+ * Returns: errno
+ */
+static int gfs2_stuffed_write_end(struct inode *inode, struct buffer_head *dibh,
+				  loff_t pos, unsigned len, unsigned copied,
+				  struct page *page)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	u64 to = pos + copied;
+	void *kaddr;
+	unsigned char *buf = dibh->b_data + sizeof(struct gfs2_dinode);
+	struct gfs2_dinode *di = (struct gfs2_dinode *)dibh->b_data;
+
+	BUG_ON((pos + len) > (dibh->b_size - sizeof(struct gfs2_dinode)));
+	kaddr = kmap_atomic(page, KM_USER0);
+	memcpy(buf + pos, kaddr + pos, copied);
+	memset(kaddr + pos + copied, 0, len - copied);
+	flush_dcache_page(page);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	if (!PageUptodate(page))
+		SetPageUptodate(page);
+	unlock_page(page);
+	page_cache_release(page);
+
+	if (copied) {
+		if (inode->i_size < to) {
+			i_size_write(inode, to);
+			ip->i_disksize = inode->i_size;
+		}
+		gfs2_dinode_out(ip, di);
+		mark_inode_dirty(inode);
+	}
+
+	if (inode == sdp->sd_rindex)
+		adjust_fs_space(inode);
+
+	brelse(dibh);
+	gfs2_trans_end(sdp);
+	gfs2_glock_dq(&ip->i_gh);
+	gfs2_holder_uninit(&ip->i_gh);
+	return copied;
+}
+
+/**
+ * gfs2_write_end
+ * @file: The file to write to
+ * @mapping: The address space to write to
+ * @pos: The file position
+ * @len: The length of the data
+ * @copied:
+ * @page: The page that has been written
+ * @fsdata: The fsdata (unused in GFS2)
+ *
+ * The main write_end function for GFS2. We have a separate one for
+ * stuffed files as they are slightly different, otherwise we just
+ * put our locking around the VFS provided functions.
+ *
+ * Returns: errno
+ */
+
+static int gfs2_write_end(struct file *file, struct address_space *mapping,
+			  loff_t pos, unsigned len, unsigned copied,
+			  struct page *page, void *fsdata)
+{
+	struct inode *inode = page->mapping->host;
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct buffer_head *dibh;
+	struct gfs2_alloc *al = ip->i_alloc;
+	unsigned int from = pos & (PAGE_CACHE_SIZE - 1);
+	unsigned int to = from + len;
+	int ret;
+
+	BUG_ON(gfs2_glock_is_locked_by_me(ip->i_gl) == NULL);
+
+	ret = gfs2_meta_inode_buffer(ip, &dibh);
+	if (unlikely(ret)) {
+		unlock_page(page);
+		page_cache_release(page);
+		goto failed;
+	}
+
+	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+
+	if (gfs2_is_stuffed(ip))
+		return gfs2_stuffed_write_end(inode, dibh, pos, len, copied, page);
+
+	if (!gfs2_is_writeback(ip))
+		gfs2_page_add_databufs(ip, page, from, to);
+
+	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
+	if (ret > 0) {
+		if (inode->i_size > ip->i_disksize)
+			ip->i_disksize = inode->i_size;
+		gfs2_dinode_out(ip, dibh->b_data);
+		mark_inode_dirty(inode);
+	}
+
+	if (inode == sdp->sd_rindex)
+		adjust_fs_space(inode);
+
+	brelse(dibh);
+	gfs2_trans_end(sdp);
+failed:
+	if (al) {
+		gfs2_inplace_release(ip);
+		gfs2_quota_unlock(ip);
+		gfs2_alloc_put(ip);
+	}
+	gfs2_glock_dq(&ip->i_gh);
+	gfs2_holder_uninit(&ip->i_gh);
+	return ret;
+}
+
+/**
+ * gfs2_set_page_dirty - Page dirtying function
+ * @page: The page to dirty
+ *
+ * Returns: 1 if it dirtyed the page, or 0 otherwise
+ */
+ 
+static int gfs2_set_page_dirty(struct page *page)
+{
+	SetPageChecked(page);
+	return __set_page_dirty_buffers(page);
+}
+
+/**
+ * gfs2_bmap - Block map function
+ * @mapping: Address space info
+ * @lblock: The block to map
+ *
+ * Returns: The disk address for the block or 0 on hole or error
+ */
+
+static sector_t gfs2_bmap(struct address_space *mapping, sector_t lblock)
+{
+	struct gfs2_inode *ip = GFS2_I(mapping->host);
+	struct gfs2_holder i_gh;
+	sector_t dblock = 0;
+	int error;
+
+	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, &i_gh);
+	if (error)
+		return 0;
+
+	if (!gfs2_is_stuffed(ip))
+		dblock = generic_block_bmap(mapping, lblock, gfs2_block_map);
+
+	gfs2_glock_dq_uninit(&i_gh);
+
+	return dblock;
+}
+
+static void gfs2_discard(struct gfs2_sbd *sdp, struct buffer_head *bh)
+{
+	struct gfs2_bufdata *bd;
+
+	lock_buffer(bh);
+	gfs2_log_lock(sdp);
+	clear_buffer_dirty(bh);
+	bd = bh->b_private;
+	if (bd) {
+		if (!list_empty(&bd->bd_le.le_list) && !buffer_pinned(bh))
+			list_del_init(&bd->bd_le.le_list);
+		else
+			gfs2_remove_from_journal(bh, current->journal_info, 0);
+	}
+	bh->b_bdev = NULL;
+	clear_buffer_mapped(bh);
+	clear_buffer_req(bh);
+	clear_buffer_new(bh);
+	gfs2_log_unlock(sdp);
+	unlock_buffer(bh);
+}
+
+static void gfs2_invalidatepage(struct page *page, unsigned long offset)
+{
+	struct gfs2_sbd *sdp = GFS2_SB(page->mapping->host);
+	struct buffer_head *bh, *head;
+	unsigned long pos = 0;
+
+	BUG_ON(!PageLocked(page));
+	if (offset == 0)
+		ClearPageChecked(page);
+	if (!page_has_buffers(page))
+		goto out;
+
+	bh = head = page_buffers(page);
+	do {
+		if (offset <= pos)
+			gfs2_discard(sdp, bh);
+		pos += bh->b_size;
+		bh = bh->b_this_page;
+	} while (bh != head);
+out:
+	if (offset == 0)
+		try_to_release_page(page, 0);
+}
+
+/**
+ * gfs2_ok_for_dio - check that dio is valid on this file
+ * @ip: The inode
+ * @rw: READ or WRITE
+ * @offset: The offset at which we are reading or writing
+ *
+ * Returns: 0 (to ignore the i/o request and thus fall back to buffered i/o)
+ *          1 (to accept the i/o request)
+ */
+static int gfs2_ok_for_dio(struct gfs2_inode *ip, int rw, loff_t offset)
+{
+	/*
+	 * Should we return an error here? I can't see that O_DIRECT for
+	 * a stuffed file makes any sense. For now we'll silently fall
+	 * back to buffered I/O
+	 */
+	if (gfs2_is_stuffed(ip))
+		return 0;
+
+	if (offset >= i_size_read(&ip->i_inode))
+		return 0;
+	return 1;
+}
+
+
+
+static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
+			      const struct iovec *iov, loff_t offset,
+			      unsigned long nr_segs)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_holder gh;
+	int rv;
+
+	/*
+	 * Deferred lock, even if its a write, since we do no allocation
+	 * on this path. All we need change is atime, and this lock mode
+	 * ensures that other nodes have flushed their buffered read caches
+	 * (i.e. their page cache entries for this inode). We do not,
+	 * unfortunately have the option of only flushing a range like
+	 * the VFS does.
+	 */
+	gfs2_holder_init(ip->i_gl, LM_ST_DEFERRED, 0, &gh);
+	rv = gfs2_glock_nq(&gh);
+	if (rv)
+		return rv;
+	rv = gfs2_ok_for_dio(ip, rw, offset);
+	if (rv != 1)
+		goto out; /* dio not valid, fall back to buffered i/o */
+
+	rv = blockdev_direct_IO_no_locking(rw, iocb, inode, inode->i_sb->s_bdev,
+					   iov, offset, nr_segs,
+					   gfs2_get_block_direct, NULL);
+out:
+	gfs2_glock_dq_m(1, &gh);
+	gfs2_holder_uninit(&gh);
+	return rv;
+}
+
+/**
+ * gfs2_releasepage - free the metadata associated with a page
+ * @page: the page that's being released
+ * @gfp_mask: passed from Linux VFS, ignored by us
+ *
+ * Call try_to_free_buffers() if the buffers in this page can be
+ * released.
+ *
+ * Returns: 0
+ */
+
+int gfs2_releasepage(struct page *page, gfp_t gfp_mask)
+{
+	struct inode *aspace = page->mapping->host;
+	struct gfs2_sbd *sdp = aspace->i_sb->s_fs_info;
+	struct buffer_head *bh, *head;
+	struct gfs2_bufdata *bd;
+
+	if (!page_has_buffers(page))
+		return 0;
+
+	gfs2_log_lock(sdp);
+	head = bh = page_buffers(page);
+	do {
+		if (atomic_read(&bh->b_count))
+			goto cannot_release;
+		bd = bh->b_private;
+		if (bd && bd->bd_ail)
+			goto cannot_release;
+		gfs2_assert_warn(sdp, !buffer_pinned(bh));
+		gfs2_assert_warn(sdp, !buffer_dirty(bh));
+		bh = bh->b_this_page;
+	} while(bh != head);
+	gfs2_log_unlock(sdp);
+
+	head = bh = page_buffers(page);
+	do {
+		gfs2_log_lock(sdp);
+		bd = bh->b_private;
+		if (bd) {
+			gfs2_assert_warn(sdp, bd->bd_bh == bh);
+			gfs2_assert_warn(sdp, list_empty(&bd->bd_list_tr));
+			if (!list_empty(&bd->bd_le.le_list)) {
+				if (!buffer_pinned(bh))
+					list_del_init(&bd->bd_le.le_list);
+				else
+					bd = NULL;
+			}
+			if (bd)
+				bd->bd_bh = NULL;
+			bh->b_private = NULL;
+		}
+		gfs2_log_unlock(sdp);
+		if (bd)
+			kmem_cache_free(gfs2_bufdata_cachep, bd);
+
+		bh = bh->b_this_page;
+	} while (bh != head);
+
+	return try_to_free_buffers(page);
+cannot_release:
+	gfs2_log_unlock(sdp);
+	return 0;
+}
+
+static const struct address_space_operations gfs2_writeback_aops = {
+	.writepage = gfs2_writeback_writepage,
+	.writepages = gfs2_writeback_writepages,
+	.readpage = gfs2_readpage,
+	.readpages = gfs2_readpages,
+	.sync_page = block_sync_page,
+	.write_begin = gfs2_write_begin,
+	.write_end = gfs2_write_end,
+	.bmap = gfs2_bmap,
+	.invalidatepage = gfs2_invalidatepage,
+	.releasepage = gfs2_releasepage,
+	.direct_IO = gfs2_direct_IO,
+	.migratepage = buffer_migrate_page,
+	.is_partially_uptodate = block_is_partially_uptodate,
+};
+
+static const struct address_space_operations gfs2_ordered_aops = {
+	.writepage = gfs2_ordered_writepage,
+	.readpage = gfs2_readpage,
+	.readpages = gfs2_readpages,
+	.sync_page = block_sync_page,
+	.write_begin = gfs2_write_begin,
+	.write_end = gfs2_write_end,
+	.set_page_dirty = gfs2_set_page_dirty,
+	.bmap = gfs2_bmap,
+	.invalidatepage = gfs2_invalidatepage,
+	.releasepage = gfs2_releasepage,
+	.direct_IO = gfs2_direct_IO,
+	.migratepage = buffer_migrate_page,
+	.is_partially_uptodate = block_is_partially_uptodate,
+};
+
+static const struct address_space_operations gfs2_jdata_aops = {
+	.writepage = gfs2_jdata_writepage,
+	.writepages = gfs2_jdata_writepages,
+	.readpage = gfs2_readpage,
+	.readpages = gfs2_readpages,
+	.sync_page = block_sync_page,
+	.write_begin = gfs2_write_begin,
+	.write_end = gfs2_write_end,
+	.set_page_dirty = gfs2_set_page_dirty,
+	.bmap = gfs2_bmap,
+	.invalidatepage = gfs2_invalidatepage,
+	.releasepage = gfs2_releasepage,
+	.is_partially_uptodate = block_is_partially_uptodate,
+};
+
+void gfs2_set_aops(struct inode *inode)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+
+	if (gfs2_is_writeback(ip))
+		inode->i_mapping->a_ops = &gfs2_writeback_aops;
+	else if (gfs2_is_ordered(ip))
+		inode->i_mapping->a_ops = &gfs2_ordered_aops;
+	else if (gfs2_is_jdata(ip))
+		inode->i_mapping->a_ops = &gfs2_jdata_aops;
+	else
+		BUG();
+}
+
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 253e1a3..1153a07 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -25,7 +25,6 @@
 #include "trans.h"
 #include "dir.h"
 #include "util.h"
-#include "ops_address.h"
 
 /* This doesn't need to be that large as max 64 bit pointers in a 4k
  * block is 512, so __u16 is fine for that. It saves stack space to
diff --git a/fs/gfs2/dentry.c b/fs/gfs2/dentry.c
new file mode 100644
index 0000000..022c66c
--- /dev/null
+++ b/fs/gfs2/dentry.c
@@ -0,0 +1,114 @@
+/*
+ * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
+ * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License version 2.
+ */
+
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/completion.h>
+#include <linux/buffer_head.h>
+#include <linux/gfs2_ondisk.h>
+#include <linux/crc32.h>
+
+#include "gfs2.h"
+#include "incore.h"
+#include "dir.h"
+#include "glock.h"
+#include "super.h"
+#include "util.h"
+#include "inode.h"
+
+/**
+ * gfs2_drevalidate - Check directory lookup consistency
+ * @dentry: the mapping to check
+ * @nd:
+ *
+ * Check to make sure the lookup necessary to arrive at this inode from its
+ * parent is still good.
+ *
+ * Returns: 1 if the dentry is ok, 0 if it isn't
+ */
+
+static int gfs2_drevalidate(struct dentry *dentry, struct nameidata *nd)
+{
+	struct dentry *parent = dget_parent(dentry);
+	struct gfs2_sbd *sdp = GFS2_SB(parent->d_inode);
+	struct gfs2_inode *dip = GFS2_I(parent->d_inode);
+	struct inode *inode = dentry->d_inode;
+	struct gfs2_holder d_gh;
+	struct gfs2_inode *ip = NULL;
+	int error;
+	int had_lock = 0;
+
+	if (inode) {
+		if (is_bad_inode(inode))
+			goto invalid;
+		ip = GFS2_I(inode);
+	}
+
+	if (sdp->sd_args.ar_localcaching)
+		goto valid;
+
+	had_lock = (gfs2_glock_is_locked_by_me(dip->i_gl) != NULL);
+	if (!had_lock) {
+		error = gfs2_glock_nq_init(dip->i_gl, LM_ST_SHARED, 0, &d_gh);
+		if (error)
+			goto fail;
+	} 
+
+	error = gfs2_dir_check(parent->d_inode, &dentry->d_name, ip);
+	switch (error) {
+	case 0:
+		if (!inode)
+			goto invalid_gunlock;
+		break;
+	case -ENOENT:
+		if (!inode)
+			goto valid_gunlock;
+		goto invalid_gunlock;
+	default:
+		goto fail_gunlock;
+	}
+
+valid_gunlock:
+	if (!had_lock)
+		gfs2_glock_dq_uninit(&d_gh);
+valid:
+	dput(parent);
+	return 1;
+
+invalid_gunlock:
+	if (!had_lock)
+		gfs2_glock_dq_uninit(&d_gh);
+invalid:
+	if (inode && S_ISDIR(inode->i_mode)) {
+		if (have_submounts(dentry))
+			goto valid;
+		shrink_dcache_parent(dentry);
+	}
+	d_drop(dentry);
+	dput(parent);
+	return 0;
+
+fail_gunlock:
+	gfs2_glock_dq_uninit(&d_gh);
+fail:
+	dput(parent);
+	return 0;
+}
+
+static int gfs2_dhash(struct dentry *dentry, struct qstr *str)
+{
+	str->hash = gfs2_disk_hash(str->name, str->len);
+	return 0;
+}
+
+const struct dentry_operations gfs2_dops = {
+	.d_revalidate = gfs2_drevalidate,
+	.d_hash = gfs2_dhash,
+};
+
diff --git a/fs/gfs2/export.c b/fs/gfs2/export.c
new file mode 100644
index 0000000..9200ef2
--- /dev/null
+++ b/fs/gfs2/export.c
@@ -0,0 +1,285 @@
+/*
+ * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
+ * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License version 2.
+ */
+
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/completion.h>
+#include <linux/buffer_head.h>
+#include <linux/exportfs.h>
+#include <linux/gfs2_ondisk.h>
+#include <linux/crc32.h>
+
+#include "gfs2.h"
+#include "incore.h"
+#include "dir.h"
+#include "glock.h"
+#include "glops.h"
+#include "inode.h"
+#include "super.h"
+#include "rgrp.h"
+#include "util.h"
+
+#define GFS2_SMALL_FH_SIZE 4
+#define GFS2_LARGE_FH_SIZE 8
+#define GFS2_OLD_FH_SIZE 10
+
+static int gfs2_encode_fh(struct dentry *dentry, __u32 *p, int *len,
+			  int connectable)
+{
+	__be32 *fh = (__force __be32 *)p;
+	struct inode *inode = dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	struct gfs2_inode *ip = GFS2_I(inode);
+
+	if (*len < GFS2_SMALL_FH_SIZE ||
+	    (connectable && *len < GFS2_LARGE_FH_SIZE))
+		return 255;
+
+	fh[0] = cpu_to_be32(ip->i_no_formal_ino >> 32);
+	fh[1] = cpu_to_be32(ip->i_no_formal_ino & 0xFFFFFFFF);
+	fh[2] = cpu_to_be32(ip->i_no_addr >> 32);
+	fh[3] = cpu_to_be32(ip->i_no_addr & 0xFFFFFFFF);
+	*len = GFS2_SMALL_FH_SIZE;
+
+	if (!connectable || inode == sb->s_root->d_inode)
+		return *len;
+
+	spin_lock(&dentry->d_lock);
+	inode = dentry->d_parent->d_inode;
+	ip = GFS2_I(inode);
+	igrab(inode);
+	spin_unlock(&dentry->d_lock);
+
+	fh[4] = cpu_to_be32(ip->i_no_formal_ino >> 32);
+	fh[5] = cpu_to_be32(ip->i_no_formal_ino & 0xFFFFFFFF);
+	fh[6] = cpu_to_be32(ip->i_no_addr >> 32);
+	fh[7] = cpu_to_be32(ip->i_no_addr & 0xFFFFFFFF);
+	*len = GFS2_LARGE_FH_SIZE;
+
+	iput(inode);
+
+	return *len;
+}
+
+struct get_name_filldir {
+	struct gfs2_inum_host inum;
+	char *name;
+};
+
+static int get_name_filldir(void *opaque, const char *name, int length,
+			    loff_t offset, u64 inum, unsigned int type)
+{
+	struct get_name_filldir *gnfd = opaque;
+
+	if (inum != gnfd->inum.no_addr)
+		return 0;
+
+	memcpy(gnfd->name, name, length);
+	gnfd->name[length] = 0;
+
+	return 1;
+}
+
+static int gfs2_get_name(struct dentry *parent, char *name,
+			 struct dentry *child)
+{
+	struct inode *dir = parent->d_inode;
+	struct inode *inode = child->d_inode;
+	struct gfs2_inode *dip, *ip;
+	struct get_name_filldir gnfd;
+	struct gfs2_holder gh;
+	u64 offset = 0;
+	int error;
+
+	if (!dir)
+		return -EINVAL;
+
+	if (!S_ISDIR(dir->i_mode) || !inode)
+		return -EINVAL;
+
+	dip = GFS2_I(dir);
+	ip = GFS2_I(inode);
+
+	*name = 0;
+	gnfd.inum.no_addr = ip->i_no_addr;
+	gnfd.inum.no_formal_ino = ip->i_no_formal_ino;
+	gnfd.name = name;
+
+	error = gfs2_glock_nq_init(dip->i_gl, LM_ST_SHARED, 0, &gh);
+	if (error)
+		return error;
+
+	error = gfs2_dir_read(dir, &offset, &gnfd, get_name_filldir);
+
+	gfs2_glock_dq_uninit(&gh);
+
+	if (!error && !*name)
+		error = -ENOENT;
+
+	return error;
+}
+
+static struct dentry *gfs2_get_parent(struct dentry *child)
+{
+	struct qstr dotdot;
+	struct dentry *dentry;
+
+	/*
+	 * XXX(hch): it would be a good idea to keep this around as a
+	 *	     static variable.
+	 */
+	gfs2_str2qstr(&dotdot, "..");
+
+	dentry = d_obtain_alias(gfs2_lookupi(child->d_inode, &dotdot, 1));
+	if (!IS_ERR(dentry))
+		dentry->d_op = &gfs2_dops;
+	return dentry;
+}
+
+static struct dentry *gfs2_get_dentry(struct super_block *sb,
+		struct gfs2_inum_host *inum)
+{
+	struct gfs2_sbd *sdp = sb->s_fs_info;
+	struct gfs2_holder i_gh, ri_gh, rgd_gh;
+	struct gfs2_rgrpd *rgd;
+	struct inode *inode;
+	struct dentry *dentry;
+	int error;
+
+	/* System files? */
+
+	inode = gfs2_ilookup(sb, inum->no_addr);
+	if (inode) {
+		if (GFS2_I(inode)->i_no_formal_ino != inum->no_formal_ino) {
+			iput(inode);
+			return ERR_PTR(-ESTALE);
+		}
+		goto out_inode;
+	}
+
+	error = gfs2_glock_nq_num(sdp, inum->no_addr, &gfs2_inode_glops,
+				  LM_ST_SHARED, LM_FLAG_ANY, &i_gh);
+	if (error)
+		return ERR_PTR(error);
+
+	error = gfs2_rindex_hold(sdp, &ri_gh);
+	if (error)
+		goto fail;
+
+	error = -EINVAL;
+	rgd = gfs2_blk2rgrpd(sdp, inum->no_addr);
+	if (!rgd)
+		goto fail_rindex;
+
+	error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_SHARED, 0, &rgd_gh);
+	if (error)
+		goto fail_rindex;
+
+	error = -ESTALE;
+	if (gfs2_get_block_type(rgd, inum->no_addr) != GFS2_BLKST_DINODE)
+		goto fail_rgd;
+
+	gfs2_glock_dq_uninit(&rgd_gh);
+	gfs2_glock_dq_uninit(&ri_gh);
+
+	inode = gfs2_inode_lookup(sb, DT_UNKNOWN,
+					inum->no_addr,
+					0, 0);
+	if (IS_ERR(inode)) {
+		error = PTR_ERR(inode);
+		goto fail;
+	}
+
+	error = gfs2_inode_refresh(GFS2_I(inode));
+	if (error) {
+		iput(inode);
+		goto fail;
+	}
+
+	/* Pick up the works we bypass in gfs2_inode_lookup */
+	if (inode->i_state & I_NEW) 
+		gfs2_set_iop(inode);
+
+	if (GFS2_I(inode)->i_no_formal_ino != inum->no_formal_ino) {
+		iput(inode);
+		goto fail;
+	}
+
+	error = -EIO;
+	if (GFS2_I(inode)->i_diskflags & GFS2_DIF_SYSTEM) {
+		iput(inode);
+		goto fail;
+	}
+
+	gfs2_glock_dq_uninit(&i_gh);
+
+out_inode:
+	dentry = d_obtain_alias(inode);
+	if (!IS_ERR(dentry))
+		dentry->d_op = &gfs2_dops;
+	return dentry;
+
+fail_rgd:
+	gfs2_glock_dq_uninit(&rgd_gh);
+
+fail_rindex:
+	gfs2_glock_dq_uninit(&ri_gh);
+
+fail:
+	gfs2_glock_dq_uninit(&i_gh);
+	return ERR_PTR(error);
+}
+
+static struct dentry *gfs2_fh_to_dentry(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type)
+{
+	struct gfs2_inum_host this;
+	__be32 *fh = (__force __be32 *)fid->raw;
+
+	switch (fh_type) {
+	case GFS2_SMALL_FH_SIZE:
+	case GFS2_LARGE_FH_SIZE:
+	case GFS2_OLD_FH_SIZE:
+		this.no_formal_ino = ((u64)be32_to_cpu(fh[0])) << 32;
+		this.no_formal_ino |= be32_to_cpu(fh[1]);
+		this.no_addr = ((u64)be32_to_cpu(fh[2])) << 32;
+		this.no_addr |= be32_to_cpu(fh[3]);
+		return gfs2_get_dentry(sb, &this);
+	default:
+		return NULL;
+	}
+}
+
+static struct dentry *gfs2_fh_to_parent(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type)
+{
+	struct gfs2_inum_host parent;
+	__be32 *fh = (__force __be32 *)fid->raw;
+
+	switch (fh_type) {
+	case GFS2_LARGE_FH_SIZE:
+	case GFS2_OLD_FH_SIZE:
+		parent.no_formal_ino = ((u64)be32_to_cpu(fh[4])) << 32;
+		parent.no_formal_ino |= be32_to_cpu(fh[5]);
+		parent.no_addr = ((u64)be32_to_cpu(fh[6])) << 32;
+		parent.no_addr |= be32_to_cpu(fh[7]);
+		return gfs2_get_dentry(sb, &parent);
+	default:
+		return NULL;
+	}
+}
+
+const struct export_operations gfs2_export_ops = {
+	.encode_fh = gfs2_encode_fh,
+	.fh_to_dentry = gfs2_fh_to_dentry,
+	.fh_to_parent = gfs2_fh_to_parent,
+	.get_name = gfs2_get_name,
+	.get_parent = gfs2_get_parent,
+};
+
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
new file mode 100644
index 0000000..73b6f55
--- /dev/null
+++ b/fs/gfs2/file.c
@@ -0,0 +1,765 @@
+/*
+ * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
+ * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License version 2.
+ */
+
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/completion.h>
+#include <linux/buffer_head.h>
+#include <linux/pagemap.h>
+#include <linux/uio.h>
+#include <linux/blkdev.h>
+#include <linux/mm.h>
+#include <linux/mount.h>
+#include <linux/fs.h>
+#include <linux/gfs2_ondisk.h>
+#include <linux/ext2_fs.h>
+#include <linux/crc32.h>
+#include <linux/writeback.h>
+#include <asm/uaccess.h>
+#include <linux/dlm.h>
+#include <linux/dlm_plock.h>
+
+#include "gfs2.h"
+#include "incore.h"
+#include "bmap.h"
+#include "dir.h"
+#include "glock.h"
+#include "glops.h"
+#include "inode.h"
+#include "log.h"
+#include "meta_io.h"
+#include "quota.h"
+#include "rgrp.h"
+#include "trans.h"
+#include "util.h"
+#include "eaops.h"
+
+/**
+ * gfs2_llseek - seek to a location in a file
+ * @file: the file
+ * @offset: the offset
+ * @origin: Where to seek from (SEEK_SET, SEEK_CUR, or SEEK_END)
+ *
+ * SEEK_END requires the glock for the file because it references the
+ * file's size.
+ *
+ * Returns: The new offset, or errno
+ */
+
+static loff_t gfs2_llseek(struct file *file, loff_t offset, int origin)
+{
+	struct gfs2_inode *ip = GFS2_I(file->f_mapping->host);
+	struct gfs2_holder i_gh;
+	loff_t error;
+
+	if (origin == 2) {
+		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY,
+					   &i_gh);
+		if (!error) {
+			error = generic_file_llseek_unlocked(file, offset, origin);
+			gfs2_glock_dq_uninit(&i_gh);
+		}
+	} else
+		error = generic_file_llseek_unlocked(file, offset, origin);
+
+	return error;
+}
+
+/**
+ * gfs2_readdir - Read directory entries from a directory
+ * @file: The directory to read from
+ * @dirent: Buffer for dirents
+ * @filldir: Function used to do the copying
+ *
+ * Returns: errno
+ */
+
+static int gfs2_readdir(struct file *file, void *dirent, filldir_t filldir)
+{
+	struct inode *dir = file->f_mapping->host;
+	struct gfs2_inode *dip = GFS2_I(dir);
+	struct gfs2_holder d_gh;
+	u64 offset = file->f_pos;
+	int error;
+
+	gfs2_holder_init(dip->i_gl, LM_ST_SHARED, 0, &d_gh);
+	error = gfs2_glock_nq(&d_gh);
+	if (error) {
+		gfs2_holder_uninit(&d_gh);
+		return error;
+	}
+
+	error = gfs2_dir_read(dir, &offset, dirent, filldir);
+
+	gfs2_glock_dq_uninit(&d_gh);
+
+	file->f_pos = offset;
+
+	return error;
+}
+
+/**
+ * fsflags_cvt
+ * @table: A table of 32 u32 flags
+ * @val: a 32 bit value to convert
+ *
+ * This function can be used to convert between fsflags values and
+ * GFS2's own flags values.
+ *
+ * Returns: the converted flags
+ */
+static u32 fsflags_cvt(const u32 *table, u32 val)
+{
+	u32 res = 0;
+	while(val) {
+		if (val & 1)
+			res |= *table;
+		table++;
+		val >>= 1;
+	}
+	return res;
+}
+
+static const u32 fsflags_to_gfs2[32] = {
+	[3] = GFS2_DIF_SYNC,
+	[4] = GFS2_DIF_IMMUTABLE,
+	[5] = GFS2_DIF_APPENDONLY,
+	[7] = GFS2_DIF_NOATIME,
+	[12] = GFS2_DIF_EXHASH,
+	[14] = GFS2_DIF_INHERIT_JDATA,
+};
+
+static const u32 gfs2_to_fsflags[32] = {
+	[gfs2fl_Sync] = FS_SYNC_FL,
+	[gfs2fl_Immutable] = FS_IMMUTABLE_FL,
+	[gfs2fl_AppendOnly] = FS_APPEND_FL,
+	[gfs2fl_NoAtime] = FS_NOATIME_FL,
+	[gfs2fl_ExHash] = FS_INDEX_FL,
+	[gfs2fl_InheritJdata] = FS_JOURNAL_DATA_FL,
+};
+
+static int gfs2_get_flags(struct file *filp, u32 __user *ptr)
+{
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_holder gh;
+	int error;
+	u32 fsflags;
+
+	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
+	error = gfs2_glock_nq(&gh);
+	if (error)
+		return error;
+
+	fsflags = fsflags_cvt(gfs2_to_fsflags, ip->i_diskflags);
+	if (!S_ISDIR(inode->i_mode) && ip->i_diskflags & GFS2_DIF_JDATA)
+		fsflags |= FS_JOURNAL_DATA_FL;
+	if (put_user(fsflags, ptr))
+		error = -EFAULT;
+
+	gfs2_glock_dq(&gh);
+	gfs2_holder_uninit(&gh);
+	return error;
+}
+
+void gfs2_set_inode_flags(struct inode *inode)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+	unsigned int flags = inode->i_flags;
+
+	flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
+	if (ip->i_diskflags & GFS2_DIF_IMMUTABLE)
+		flags |= S_IMMUTABLE;
+	if (ip->i_diskflags & GFS2_DIF_APPENDONLY)
+		flags |= S_APPEND;
+	if (ip->i_diskflags & GFS2_DIF_NOATIME)
+		flags |= S_NOATIME;
+	if (ip->i_diskflags & GFS2_DIF_SYNC)
+		flags |= S_SYNC;
+	inode->i_flags = flags;
+}
+
+/* Flags that can be set by user space */
+#define GFS2_FLAGS_USER_SET (GFS2_DIF_JDATA|			\
+			     GFS2_DIF_IMMUTABLE|		\
+			     GFS2_DIF_APPENDONLY|		\
+			     GFS2_DIF_NOATIME|			\
+			     GFS2_DIF_SYNC|			\
+			     GFS2_DIF_SYSTEM|			\
+			     GFS2_DIF_INHERIT_JDATA)
+
+/**
+ * gfs2_set_flags - set flags on an inode
+ * @inode: The inode
+ * @flags: The flags to set
+ * @mask: Indicates which flags are valid
+ *
+ */
+static int do_gfs2_set_flags(struct file *filp, u32 reqflags, u32 mask)
+{
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct buffer_head *bh;
+	struct gfs2_holder gh;
+	int error;
+	u32 new_flags, flags;
+
+	error = mnt_want_write(filp->f_path.mnt);
+	if (error)
+		return error;
+
+	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
+	if (error)
+		goto out_drop_write;
+
+	flags = ip->i_diskflags;
+	new_flags = (flags & ~mask) | (reqflags & mask);
+	if ((new_flags ^ flags) == 0)
+		goto out;
+
+	error = -EINVAL;
+	if ((new_flags ^ flags) & ~GFS2_FLAGS_USER_SET)
+		goto out;
+
+	error = -EPERM;
+	if (IS_IMMUTABLE(inode) && (new_flags & GFS2_DIF_IMMUTABLE))
+		goto out;
+	if (IS_APPEND(inode) && (new_flags & GFS2_DIF_APPENDONLY))
+		goto out;
+	if (((new_flags ^ flags) & GFS2_DIF_IMMUTABLE) &&
+	    !capable(CAP_LINUX_IMMUTABLE))
+		goto out;
+	if (!IS_IMMUTABLE(inode)) {
+		error = gfs2_permission(inode, MAY_WRITE);
+		if (error)
+			goto out;
+	}
+	if ((flags ^ new_flags) & GFS2_DIF_JDATA) {
+		if (flags & GFS2_DIF_JDATA)
+			gfs2_log_flush(sdp, ip->i_gl);
+		error = filemap_fdatawrite(inode->i_mapping);
+		if (error)
+			goto out;
+		error = filemap_fdatawait(inode->i_mapping);
+		if (error)
+			goto out;
+	}
+	error = gfs2_trans_begin(sdp, RES_DINODE, 0);
+	if (error)
+		goto out;
+	error = gfs2_meta_inode_buffer(ip, &bh);
+	if (error)
+		goto out_trans_end;
+	gfs2_trans_add_bh(ip->i_gl, bh, 1);
+	ip->i_diskflags = new_flags;
+	gfs2_dinode_out(ip, bh->b_data);
+	brelse(bh);
+	gfs2_set_inode_flags(inode);
+	gfs2_set_aops(inode);
+out_trans_end:
+	gfs2_trans_end(sdp);
+out:
+	gfs2_glock_dq_uninit(&gh);
+out_drop_write:
+	mnt_drop_write(filp->f_path.mnt);
+	return error;
+}
+
+static int gfs2_set_flags(struct file *filp, u32 __user *ptr)
+{
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	u32 fsflags, gfsflags;
+	if (get_user(fsflags, ptr))
+		return -EFAULT;
+	gfsflags = fsflags_cvt(fsflags_to_gfs2, fsflags);
+	if (!S_ISDIR(inode->i_mode)) {
+		if (gfsflags & GFS2_DIF_INHERIT_JDATA)
+			gfsflags ^= (GFS2_DIF_JDATA | GFS2_DIF_INHERIT_JDATA);
+		return do_gfs2_set_flags(filp, gfsflags, ~0);
+	}
+	return do_gfs2_set_flags(filp, gfsflags, ~GFS2_DIF_JDATA);
+}
+
+static long gfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	switch(cmd) {
+	case FS_IOC_GETFLAGS:
+		return gfs2_get_flags(filp, (u32 __user *)arg);
+	case FS_IOC_SETFLAGS:
+		return gfs2_set_flags(filp, (u32 __user *)arg);
+	}
+	return -ENOTTY;
+}
+
+/**
+ * gfs2_allocate_page_backing - Use bmap to allocate blocks
+ * @page: The (locked) page to allocate backing for
+ *
+ * We try to allocate all the blocks required for the page in
+ * one go. This might fail for various reasons, so we keep
+ * trying until all the blocks to back this page are allocated.
+ * If some of the blocks are already allocated, thats ok too.
+ */
+
+static int gfs2_allocate_page_backing(struct page *page)
+{
+	struct inode *inode = page->mapping->host;
+	struct buffer_head bh;
+	unsigned long size = PAGE_CACHE_SIZE;
+	u64 lblock = page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+
+	do {
+		bh.b_state = 0;
+		bh.b_size = size;
+		gfs2_block_map(inode, lblock, &bh, 1);
+		if (!buffer_mapped(&bh))
+			return -EIO;
+		size -= bh.b_size;
+		lblock += (bh.b_size >> inode->i_blkbits);
+	} while(size > 0);
+	return 0;
+}
+
+/**
+ * gfs2_page_mkwrite - Make a shared, mmap()ed, page writable
+ * @vma: The virtual memory area
+ * @page: The page which is about to become writable
+ *
+ * When the page becomes writable, we need to ensure that we have
+ * blocks allocated on disk to back that page.
+ */
+
+static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct page *page = vmf->page;
+	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	unsigned long last_index;
+	u64 pos = page->index << PAGE_CACHE_SHIFT;
+	unsigned int data_blocks, ind_blocks, rblocks;
+	int alloc_required = 0;
+	struct gfs2_holder gh;
+	struct gfs2_alloc *al;
+	int ret;
+
+	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
+	ret = gfs2_glock_nq(&gh);
+	if (ret)
+		goto out;
+
+	set_bit(GLF_DIRTY, &ip->i_gl->gl_flags);
+	set_bit(GIF_SW_PAGED, &ip->i_flags);
+
+	ret = gfs2_write_alloc_required(ip, pos, PAGE_CACHE_SIZE, &alloc_required);
+	if (ret || !alloc_required)
+		goto out_unlock;
+	ret = -ENOMEM;
+	al = gfs2_alloc_get(ip);
+	if (al == NULL)
+		goto out_unlock;
+
+	ret = gfs2_quota_lock_check(ip);
+	if (ret)
+		goto out_alloc_put;
+	gfs2_write_calc_reserv(ip, PAGE_CACHE_SIZE, &data_blocks, &ind_blocks);
+	al->al_requested = data_blocks + ind_blocks;
+	ret = gfs2_inplace_reserve(ip);
+	if (ret)
+		goto out_quota_unlock;
+
+	rblocks = RES_DINODE + ind_blocks;
+	if (gfs2_is_jdata(ip))
+		rblocks += data_blocks ? data_blocks : 1;
+	if (ind_blocks || data_blocks)
+		rblocks += RES_STATFS + RES_QUOTA;
+	ret = gfs2_trans_begin(sdp, rblocks, 0);
+	if (ret)
+		goto out_trans_fail;
+
+	lock_page(page);
+	ret = -EINVAL;
+	last_index = ip->i_inode.i_size >> PAGE_CACHE_SHIFT;
+	if (page->index > last_index)
+		goto out_unlock_page;
+	ret = 0;
+	if (!PageUptodate(page) || page->mapping != ip->i_inode.i_mapping)
+		goto out_unlock_page;
+	if (gfs2_is_stuffed(ip)) {
+		ret = gfs2_unstuff_dinode(ip, page);
+		if (ret)
+			goto out_unlock_page;
+	}
+	ret = gfs2_allocate_page_backing(page);
+
+out_unlock_page:
+	unlock_page(page);
+	gfs2_trans_end(sdp);
+out_trans_fail:
+	gfs2_inplace_release(ip);
+out_quota_unlock:
+	gfs2_quota_unlock(ip);
+out_alloc_put:
+	gfs2_alloc_put(ip);
+out_unlock:
+	gfs2_glock_dq(&gh);
+out:
+	gfs2_holder_uninit(&gh);
+	if (ret == -ENOMEM)
+		ret = VM_FAULT_OOM;
+	else if (ret)
+		ret = VM_FAULT_SIGBUS;
+	return ret;
+}
+
+static struct vm_operations_struct gfs2_vm_ops = {
+	.fault = filemap_fault,
+	.page_mkwrite = gfs2_page_mkwrite,
+};
+
+/**
+ * gfs2_mmap -
+ * @file: The file to map
+ * @vma: The VMA which described the mapping
+ *
+ * There is no need to get a lock here unless we should be updating
+ * atime. We ignore any locking errors since the only consequence is
+ * a missed atime update (which will just be deferred until later).
+ *
+ * Returns: 0
+ */
+
+static int gfs2_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct gfs2_inode *ip = GFS2_I(file->f_mapping->host);
+
+	if (!(file->f_flags & O_NOATIME)) {
+		struct gfs2_holder i_gh;
+		int error;
+
+		gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &i_gh);
+		error = gfs2_glock_nq(&i_gh);
+		file_accessed(file);
+		if (error == 0)
+			gfs2_glock_dq_uninit(&i_gh);
+	}
+	vma->vm_ops = &gfs2_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
+
+	return 0;
+}
+
+/**
+ * gfs2_open - open a file
+ * @inode: the inode to open
+ * @file: the struct file for this opening
+ *
+ * Returns: errno
+ */
+
+static int gfs2_open(struct inode *inode, struct file *file)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_holder i_gh;
+	struct gfs2_file *fp;
+	int error;
+
+	fp = kzalloc(sizeof(struct gfs2_file), GFP_KERNEL);
+	if (!fp)
+		return -ENOMEM;
+
+	mutex_init(&fp->f_fl_mutex);
+
+	gfs2_assert_warn(GFS2_SB(inode), !file->private_data);
+	file->private_data = fp;
+
+	if (S_ISREG(ip->i_inode.i_mode)) {
+		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY,
+					   &i_gh);
+		if (error)
+			goto fail;
+
+		if (!(file->f_flags & O_LARGEFILE) &&
+		    ip->i_disksize > MAX_NON_LFS) {
+			error = -EOVERFLOW;
+			goto fail_gunlock;
+		}
+
+		gfs2_glock_dq_uninit(&i_gh);
+	}
+
+	return 0;
+
+fail_gunlock:
+	gfs2_glock_dq_uninit(&i_gh);
+fail:
+	file->private_data = NULL;
+	kfree(fp);
+	return error;
+}
+
+/**
+ * gfs2_close - called to close a struct file
+ * @inode: the inode the struct file belongs to
+ * @file: the struct file being closed
+ *
+ * Returns: errno
+ */
+
+static int gfs2_close(struct inode *inode, struct file *file)
+{
+	struct gfs2_sbd *sdp = inode->i_sb->s_fs_info;
+	struct gfs2_file *fp;
+
+	fp = file->private_data;
+	file->private_data = NULL;
+
+	if (gfs2_assert_warn(sdp, fp))
+		return -EIO;
+
+	kfree(fp);
+
+	return 0;
+}
+
+/**
+ * gfs2_fsync - sync the dirty data for a file (across the cluster)
+ * @file: the file that points to the dentry (we ignore this)
+ * @dentry: the dentry that points to the inode to sync
+ *
+ * The VFS will flush "normal" data for us. We only need to worry
+ * about metadata here. For journaled data, we just do a log flush
+ * as we can't avoid it. Otherwise we can just bale out if datasync
+ * is set. For stuffed inodes we must flush the log in order to
+ * ensure that all data is on disk.
+ *
+ * The call to write_inode_now() is there to write back metadata and
+ * the inode itself. It does also try and write the data, but thats
+ * (hopefully) a no-op due to the VFS having already called filemap_fdatawrite()
+ * for us.
+ *
+ * Returns: errno
+ */
+
+static int gfs2_fsync(struct file *file, struct dentry *dentry, int datasync)
+{
+	struct inode *inode = dentry->d_inode;
+	int sync_state = inode->i_state & (I_DIRTY_SYNC|I_DIRTY_DATASYNC);
+	int ret = 0;
+
+	if (gfs2_is_jdata(GFS2_I(inode))) {
+		gfs2_log_flush(GFS2_SB(inode), GFS2_I(inode)->i_gl);
+		return 0;
+	}
+
+	if (sync_state != 0) {
+		if (!datasync)
+			ret = write_inode_now(inode, 0);
+
+		if (gfs2_is_stuffed(GFS2_I(inode)))
+			gfs2_log_flush(GFS2_SB(inode), GFS2_I(inode)->i_gl);
+	}
+
+	return ret;
+}
+
+#ifdef CONFIG_GFS2_FS_LOCKING_DLM
+
+/**
+ * gfs2_setlease - acquire/release a file lease
+ * @file: the file pointer
+ * @arg: lease type
+ * @fl: file lock
+ *
+ * We don't currently have a way to enforce a lease across the whole
+ * cluster; until we do, disable leases (by just returning -EINVAL),
+ * unless the administrator has requested purely local locking.
+ *
+ * Returns: errno
+ */
+
+static int gfs2_setlease(struct file *file, long arg, struct file_lock **fl)
+{
+	return -EINVAL;
+}
+
+/**
+ * gfs2_lock - acquire/release a posix lock on a file
+ * @file: the file pointer
+ * @cmd: either modify or retrieve lock state, possibly wait
+ * @fl: type and range of lock
+ *
+ * Returns: errno
+ */
+
+static int gfs2_lock(struct file *file, int cmd, struct file_lock *fl)
+{
+	struct gfs2_inode *ip = GFS2_I(file->f_mapping->host);
+	struct gfs2_sbd *sdp = GFS2_SB(file->f_mapping->host);
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+
+	if (!(fl->fl_flags & FL_POSIX))
+		return -ENOLCK;
+	if (__mandatory_lock(&ip->i_inode))
+		return -ENOLCK;
+
+	if (cmd == F_CANCELLK) {
+		/* Hack: */
+		cmd = F_SETLK;
+		fl->fl_type = F_UNLCK;
+	}
+	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+		return -EIO;
+	if (IS_GETLK(cmd))
+		return dlm_posix_get(ls->ls_dlm, ip->i_no_addr, file, fl);
+	else if (fl->fl_type == F_UNLCK)
+		return dlm_posix_unlock(ls->ls_dlm, ip->i_no_addr, file, fl);
+	else
+		return dlm_posix_lock(ls->ls_dlm, ip->i_no_addr, file, cmd, fl);
+}
+
+static int do_flock(struct file *file, int cmd, struct file_lock *fl)
+{
+	struct gfs2_file *fp = file->private_data;
+	struct gfs2_holder *fl_gh = &fp->f_fl_gh;
+	struct gfs2_inode *ip = GFS2_I(file->f_path.dentry->d_inode);
+	struct gfs2_glock *gl;
+	unsigned int state;
+	int flags;
+	int error = 0;
+
+	state = (fl->fl_type == F_WRLCK) ? LM_ST_EXCLUSIVE : LM_ST_SHARED;
+	flags = (IS_SETLKW(cmd) ? 0 : LM_FLAG_TRY) | GL_EXACT | GL_NOCACHE;
+
+	mutex_lock(&fp->f_fl_mutex);
+
+	gl = fl_gh->gh_gl;
+	if (gl) {
+		if (fl_gh->gh_state == state)
+			goto out;
+		flock_lock_file_wait(file,
+				     &(struct file_lock){.fl_type = F_UNLCK});
+		gfs2_glock_dq_wait(fl_gh);
+		gfs2_holder_reinit(state, flags, fl_gh);
+	} else {
+		error = gfs2_glock_get(GFS2_SB(&ip->i_inode), ip->i_no_addr,
+				       &gfs2_flock_glops, CREATE, &gl);
+		if (error)
+			goto out;
+		gfs2_holder_init(gl, state, flags, fl_gh);
+		gfs2_glock_put(gl);
+	}
+	error = gfs2_glock_nq(fl_gh);
+	if (error) {
+		gfs2_holder_uninit(fl_gh);
+		if (error == GLR_TRYFAILED)
+			error = -EAGAIN;
+	} else {
+		error = flock_lock_file_wait(file, fl);
+		gfs2_assert_warn(GFS2_SB(&ip->i_inode), !error);
+	}
+
+out:
+	mutex_unlock(&fp->f_fl_mutex);
+	return error;
+}
+
+static void do_unflock(struct file *file, struct file_lock *fl)
+{
+	struct gfs2_file *fp = file->private_data;
+	struct gfs2_holder *fl_gh = &fp->f_fl_gh;
+
+	mutex_lock(&fp->f_fl_mutex);
+	flock_lock_file_wait(file, fl);
+	if (fl_gh->gh_gl)
+		gfs2_glock_dq_uninit(fl_gh);
+	mutex_unlock(&fp->f_fl_mutex);
+}
+
+/**
+ * gfs2_flock - acquire/release a flock lock on a file
+ * @file: the file pointer
+ * @cmd: either modify or retrieve lock state, possibly wait
+ * @fl: type and range of lock
+ *
+ * Returns: errno
+ */
+
+static int gfs2_flock(struct file *file, int cmd, struct file_lock *fl)
+{
+	struct gfs2_inode *ip = GFS2_I(file->f_mapping->host);
+
+	if (!(fl->fl_flags & FL_FLOCK))
+		return -ENOLCK;
+	if (__mandatory_lock(&ip->i_inode))
+		return -ENOLCK;
+
+	if (fl->fl_type == F_UNLCK) {
+		do_unflock(file, fl);
+		return 0;
+	} else {
+		return do_flock(file, cmd, fl);
+	}
+}
+
+const struct file_operations gfs2_file_fops = {
+	.llseek		= gfs2_llseek,
+	.read		= do_sync_read,
+	.aio_read	= generic_file_aio_read,
+	.write		= do_sync_write,
+	.aio_write	= generic_file_aio_write,
+	.unlocked_ioctl	= gfs2_ioctl,
+	.mmap		= gfs2_mmap,
+	.open		= gfs2_open,
+	.release	= gfs2_close,
+	.fsync		= gfs2_fsync,
+	.lock		= gfs2_lock,
+	.flock		= gfs2_flock,
+	.splice_read	= generic_file_splice_read,
+	.splice_write	= generic_file_splice_write,
+	.setlease	= gfs2_setlease,
+};
+
+const struct file_operations gfs2_dir_fops = {
+	.readdir	= gfs2_readdir,
+	.unlocked_ioctl	= gfs2_ioctl,
+	.open		= gfs2_open,
+	.release	= gfs2_close,
+	.fsync		= gfs2_fsync,
+	.lock		= gfs2_lock,
+	.flock		= gfs2_flock,
+};
+
+#endif /* CONFIG_GFS2_FS_LOCKING_DLM */
+
+const struct file_operations gfs2_file_fops_nolock = {
+	.llseek		= gfs2_llseek,
+	.read		= do_sync_read,
+	.aio_read	= generic_file_aio_read,
+	.write		= do_sync_write,
+	.aio_write	= generic_file_aio_write,
+	.unlocked_ioctl	= gfs2_ioctl,
+	.mmap		= gfs2_mmap,
+	.open		= gfs2_open,
+	.release	= gfs2_close,
+	.fsync		= gfs2_fsync,
+	.splice_read	= generic_file_splice_read,
+	.splice_write	= generic_file_splice_write,
+	.setlease	= generic_setlease,
+};
+
+const struct file_operations gfs2_dir_fops_nolock = {
+	.readdir	= gfs2_readdir,
+	.unlocked_ioctl	= gfs2_ioctl,
+	.open		= gfs2_open,
+	.release	= gfs2_close,
+	.fsync		= gfs2_fsync,
+};
+
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 5a31d42..c03a1a3 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -30,7 +30,6 @@
 #include "inode.h"
 #include "log.h"
 #include "meta_io.h"
-#include "ops_address.h"
 #include "quota.h"
 #include "rgrp.h"
 #include "trans.h"
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index c30be2b..2c3ec07 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -11,8 +11,16 @@
 #define __INODE_DOT_H__
 
 #include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/mm.h>
 #include "util.h"
 
+extern int gfs2_releasepage(struct page *page, gfp_t gfp_mask);
+extern int gfs2_internal_read(struct gfs2_inode *ip,
+			      struct file_ra_state *ra_state,
+			      char *buf, loff_t *pos, unsigned size);
+extern void gfs2_set_aops(struct inode *inode);
+
 static inline int gfs2_is_stuffed(const struct gfs2_inode *ip)
 {
 	return !ip->i_height;
@@ -73,30 +81,31 @@ static inline void gfs2_inum_out(const struct gfs2_inode *ip,
 }
 
 
-void gfs2_set_iop(struct inode *inode);
-struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned type, 
-				u64 no_addr, u64 no_formal_ino,
-				int skip_freeing);
-struct inode *gfs2_ilookup(struct super_block *sb, u64 no_addr);
-
-int gfs2_inode_refresh(struct gfs2_inode *ip);
-
-int gfs2_dinode_dealloc(struct gfs2_inode *inode);
-int gfs2_change_nlink(struct gfs2_inode *ip, int diff);
-struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
-			   int is_root);
-struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
-			   unsigned int mode, dev_t dev);
-int gfs2_rmdiri(struct gfs2_inode *dip, const struct qstr *name,
-		struct gfs2_inode *ip);
-int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
-		   const struct gfs2_inode *ip);
-int gfs2_permission(struct inode *inode, int mask);
-int gfs2_readlinki(struct gfs2_inode *ip, char **buf, unsigned int *len);
-int gfs2_setattr_simple(struct gfs2_inode *ip, struct iattr *attr);
-struct inode *gfs2_lookup_simple(struct inode *dip, const char *name);
-void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf);
-void gfs2_dinode_print(const struct gfs2_inode *ip);
+extern void gfs2_set_iop(struct inode *inode);
+extern struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned type, 
+				       u64 no_addr, u64 no_formal_ino,
+				       int skip_freeing);
+extern struct inode *gfs2_ilookup(struct super_block *sb, u64 no_addr);
+
+extern int gfs2_inode_refresh(struct gfs2_inode *ip);
+
+extern int gfs2_dinode_dealloc(struct gfs2_inode *inode);
+extern int gfs2_change_nlink(struct gfs2_inode *ip, int diff);
+extern struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
+				  int is_root);
+extern struct inode *gfs2_createi(struct gfs2_holder *ghs,
+				  const struct qstr *name,
+				  unsigned int mode, dev_t dev);
+extern int gfs2_rmdiri(struct gfs2_inode *dip, const struct qstr *name,
+		       struct gfs2_inode *ip);
+extern int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
+			  const struct gfs2_inode *ip);
+extern int gfs2_permission(struct inode *inode, int mask);
+extern int gfs2_readlinki(struct gfs2_inode *ip, char **buf, unsigned int *len);
+extern int gfs2_setattr_simple(struct gfs2_inode *ip, struct iattr *attr);
+extern struct inode *gfs2_lookup_simple(struct inode *dip, const char *name);
+extern void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf);
+extern void gfs2_dinode_print(const struct gfs2_inode *ip);
 
 extern const struct inode_operations gfs2_file_iops;
 extern const struct inode_operations gfs2_dir_iops;
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 78a5f43..cb8d7a9 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -31,7 +31,6 @@
 #include "rgrp.h"
 #include "trans.h"
 #include "util.h"
-#include "ops_address.h"
 
 static int gfs2_aspace_writepage(struct page *page, struct writeback_control *wbc)
 {
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
deleted file mode 100644
index e566421..0000000
--- a/fs/gfs2/ops_address.c
+++ /dev/null
@@ -1,1146 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#include <linux/sched.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/completion.h>
-#include <linux/buffer_head.h>
-#include <linux/pagemap.h>
-#include <linux/pagevec.h>
-#include <linux/mpage.h>
-#include <linux/fs.h>
-#include <linux/writeback.h>
-#include <linux/swap.h>
-#include <linux/gfs2_ondisk.h>
-#include <linux/backing-dev.h>
-
-#include "gfs2.h"
-#include "incore.h"
-#include "bmap.h"
-#include "glock.h"
-#include "inode.h"
-#include "log.h"
-#include "meta_io.h"
-#include "ops_address.h"
-#include "quota.h"
-#include "trans.h"
-#include "rgrp.h"
-#include "super.h"
-#include "util.h"
-#include "glops.h"
-
-
-static void gfs2_page_add_databufs(struct gfs2_inode *ip, struct page *page,
-				   unsigned int from, unsigned int to)
-{
-	struct buffer_head *head = page_buffers(page);
-	unsigned int bsize = head->b_size;
-	struct buffer_head *bh;
-	unsigned int start, end;
-
-	for (bh = head, start = 0; bh != head || !start;
-	     bh = bh->b_this_page, start = end) {
-		end = start + bsize;
-		if (end <= from || start >= to)
-			continue;
-		if (gfs2_is_jdata(ip))
-			set_buffer_uptodate(bh);
-		gfs2_trans_add_bh(ip->i_gl, bh, 0);
-	}
-}
-
-/**
- * gfs2_get_block_noalloc - Fills in a buffer head with details about a block
- * @inode: The inode
- * @lblock: The block number to look up
- * @bh_result: The buffer head to return the result in
- * @create: Non-zero if we may add block to the file
- *
- * Returns: errno
- */
-
-static int gfs2_get_block_noalloc(struct inode *inode, sector_t lblock,
-				  struct buffer_head *bh_result, int create)
-{
-	int error;
-
-	error = gfs2_block_map(inode, lblock, bh_result, 0);
-	if (error)
-		return error;
-	if (!buffer_mapped(bh_result))
-		return -EIO;
-	return 0;
-}
-
-static int gfs2_get_block_direct(struct inode *inode, sector_t lblock,
-				 struct buffer_head *bh_result, int create)
-{
-	return gfs2_block_map(inode, lblock, bh_result, 0);
-}
-
-/**
- * gfs2_writepage_common - Common bits of writepage
- * @page: The page to be written
- * @wbc: The writeback control
- *
- * Returns: 1 if writepage is ok, otherwise an error code or zero if no error.
- */
-
-static int gfs2_writepage_common(struct page *page,
-				 struct writeback_control *wbc)
-{
-	struct inode *inode = page->mapping->host;
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	loff_t i_size = i_size_read(inode);
-	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
-	unsigned offset;
-
-	if (gfs2_assert_withdraw(sdp, gfs2_glock_is_held_excl(ip->i_gl)))
-		goto out;
-	if (current->journal_info)
-		goto redirty;
-	/* Is the page fully outside i_size? (truncate in progress) */
-	offset = i_size & (PAGE_CACHE_SIZE-1);
-	if (page->index > end_index || (page->index == end_index && !offset)) {
-		page->mapping->a_ops->invalidatepage(page, 0);
-		goto out;
-	}
-	return 1;
-redirty:
-	redirty_page_for_writepage(wbc, page);
-out:
-	unlock_page(page);
-	return 0;
-}
-
-/**
- * gfs2_writeback_writepage - Write page for writeback mappings
- * @page: The page
- * @wbc: The writeback control
- *
- */
-
-static int gfs2_writeback_writepage(struct page *page,
-				    struct writeback_control *wbc)
-{
-	int ret;
-
-	ret = gfs2_writepage_common(page, wbc);
-	if (ret <= 0)
-		return ret;
-
-	ret = mpage_writepage(page, gfs2_get_block_noalloc, wbc);
-	if (ret == -EAGAIN)
-		ret = block_write_full_page(page, gfs2_get_block_noalloc, wbc);
-	return ret;
-}
-
-/**
- * gfs2_ordered_writepage - Write page for ordered data files
- * @page: The page to write
- * @wbc: The writeback control
- *
- */
-
-static int gfs2_ordered_writepage(struct page *page,
-				  struct writeback_control *wbc)
-{
-	struct inode *inode = page->mapping->host;
-	struct gfs2_inode *ip = GFS2_I(inode);
-	int ret;
-
-	ret = gfs2_writepage_common(page, wbc);
-	if (ret <= 0)
-		return ret;
-
-	if (!page_has_buffers(page)) {
-		create_empty_buffers(page, inode->i_sb->s_blocksize,
-				     (1 << BH_Dirty)|(1 << BH_Uptodate));
-	}
-	gfs2_page_add_databufs(ip, page, 0, inode->i_sb->s_blocksize-1);
-	return block_write_full_page(page, gfs2_get_block_noalloc, wbc);
-}
-
-/**
- * __gfs2_jdata_writepage - The core of jdata writepage
- * @page: The page to write
- * @wbc: The writeback control
- *
- * This is shared between writepage and writepages and implements the
- * core of the writepage operation. If a transaction is required then
- * PageChecked will have been set and the transaction will have
- * already been started before this is called.
- */
-
-static int __gfs2_jdata_writepage(struct page *page, struct writeback_control *wbc)
-{
-	struct inode *inode = page->mapping->host;
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
-
-	if (PageChecked(page)) {
-		ClearPageChecked(page);
-		if (!page_has_buffers(page)) {
-			create_empty_buffers(page, inode->i_sb->s_blocksize,
-					     (1 << BH_Dirty)|(1 << BH_Uptodate));
-		}
-		gfs2_page_add_databufs(ip, page, 0, sdp->sd_vfs->s_blocksize-1);
-	}
-	return block_write_full_page(page, gfs2_get_block_noalloc, wbc);
-}
-
-/**
- * gfs2_jdata_writepage - Write complete page
- * @page: Page to write
- *
- * Returns: errno
- *
- */
-
-static int gfs2_jdata_writepage(struct page *page, struct writeback_control *wbc)
-{
-	struct inode *inode = page->mapping->host;
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	int ret;
-	int done_trans = 0;
-
-	if (PageChecked(page)) {
-		if (wbc->sync_mode != WB_SYNC_ALL)
-			goto out_ignore;
-		ret = gfs2_trans_begin(sdp, RES_DINODE + 1, 0);
-		if (ret)
-			goto out_ignore;
-		done_trans = 1;
-	}
-	ret = gfs2_writepage_common(page, wbc);
-	if (ret > 0)
-		ret = __gfs2_jdata_writepage(page, wbc);
-	if (done_trans)
-		gfs2_trans_end(sdp);
-	return ret;
-
-out_ignore:
-	redirty_page_for_writepage(wbc, page);
-	unlock_page(page);
-	return 0;
-}
-
-/**
- * gfs2_writeback_writepages - Write a bunch of dirty pages back to disk
- * @mapping: The mapping to write
- * @wbc: Write-back control
- *
- * For the data=writeback case we can already ignore buffer heads
- * and write whole extents at once. This is a big reduction in the
- * number of I/O requests we send and the bmap calls we make in this case.
- */
-static int gfs2_writeback_writepages(struct address_space *mapping,
-				     struct writeback_control *wbc)
-{
-	return mpage_writepages(mapping, wbc, gfs2_get_block_noalloc);
-}
-
-/**
- * gfs2_write_jdata_pagevec - Write back a pagevec's worth of pages
- * @mapping: The mapping
- * @wbc: The writeback control
- * @writepage: The writepage function to call for each page
- * @pvec: The vector of pages
- * @nr_pages: The number of pages to write
- *
- * Returns: non-zero if loop should terminate, zero otherwise
- */
-
-static int gfs2_write_jdata_pagevec(struct address_space *mapping,
-				    struct writeback_control *wbc,
-				    struct pagevec *pvec,
-				    int nr_pages, pgoff_t end)
-{
-	struct inode *inode = mapping->host;
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	loff_t i_size = i_size_read(inode);
-	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
-	unsigned offset = i_size & (PAGE_CACHE_SIZE-1);
-	unsigned nrblocks = nr_pages * (PAGE_CACHE_SIZE/inode->i_sb->s_blocksize);
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
-	int i;
-	int ret;
-
-	ret = gfs2_trans_begin(sdp, nrblocks, nrblocks);
-	if (ret < 0)
-		return ret;
-
-	for(i = 0; i < nr_pages; i++) {
-		struct page *page = pvec->pages[i];
-
-		lock_page(page);
-
-		if (unlikely(page->mapping != mapping)) {
-			unlock_page(page);
-			continue;
-		}
-
-		if (!wbc->range_cyclic && page->index > end) {
-			ret = 1;
-			unlock_page(page);
-			continue;
-		}
-
-		if (wbc->sync_mode != WB_SYNC_NONE)
-			wait_on_page_writeback(page);
-
-		if (PageWriteback(page) ||
-		    !clear_page_dirty_for_io(page)) {
-			unlock_page(page);
-			continue;
-		}
-
-		/* Is the page fully outside i_size? (truncate in progress) */
-		if (page->index > end_index || (page->index == end_index && !offset)) {
-			page->mapping->a_ops->invalidatepage(page, 0);
-			unlock_page(page);
-			continue;
-		}
-
-		ret = __gfs2_jdata_writepage(page, wbc);
-
-		if (ret || (--(wbc->nr_to_write) <= 0))
-			ret = 1;
-		if (wbc->nonblocking && bdi_write_congested(bdi)) {
-			wbc->encountered_congestion = 1;
-			ret = 1;
-		}
-
-	}
-	gfs2_trans_end(sdp);
-	return ret;
-}
-
-/**
- * gfs2_write_cache_jdata - Like write_cache_pages but different
- * @mapping: The mapping to write
- * @wbc: The writeback control
- * @writepage: The writepage function to call
- * @data: The data to pass to writepage
- *
- * The reason that we use our own function here is that we need to
- * start transactions before we grab page locks. This allows us
- * to get the ordering right.
- */
-
-static int gfs2_write_cache_jdata(struct address_space *mapping,
-				  struct writeback_control *wbc)
-{
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
-	int ret = 0;
-	int done = 0;
-	struct pagevec pvec;
-	int nr_pages;
-	pgoff_t index;
-	pgoff_t end;
-	int scanned = 0;
-	int range_whole = 0;
-
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
-		wbc->encountered_congestion = 1;
-		return 0;
-	}
-
-	pagevec_init(&pvec, 0);
-	if (wbc->range_cyclic) {
-		index = mapping->writeback_index; /* Start from prev offset */
-		end = -1;
-	} else {
-		index = wbc->range_start >> PAGE_CACHE_SHIFT;
-		end = wbc->range_end >> PAGE_CACHE_SHIFT;
-		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
-			range_whole = 1;
-		scanned = 1;
-	}
-
-retry:
-	 while (!done && (index <= end) &&
-		(nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-					       PAGECACHE_TAG_DIRTY,
-					       min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
-		scanned = 1;
-		ret = gfs2_write_jdata_pagevec(mapping, wbc, &pvec, nr_pages, end);
-		if (ret)
-			done = 1;
-		if (ret > 0)
-			ret = 0;
-
-		pagevec_release(&pvec);
-		cond_resched();
-	}
-
-	if (!scanned && !done) {
-		/*
-		 * We hit the last page and there is more work to be done: wrap
-		 * back to the start of the file
-		 */
-		scanned = 1;
-		index = 0;
-		goto retry;
-	}
-
-	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
-		mapping->writeback_index = index;
-	return ret;
-}
-
-
-/**
- * gfs2_jdata_writepages - Write a bunch of dirty pages back to disk
- * @mapping: The mapping to write
- * @wbc: The writeback control
- * 
- */
-
-static int gfs2_jdata_writepages(struct address_space *mapping,
-				 struct writeback_control *wbc)
-{
-	struct gfs2_inode *ip = GFS2_I(mapping->host);
-	struct gfs2_sbd *sdp = GFS2_SB(mapping->host);
-	int ret;
-
-	ret = gfs2_write_cache_jdata(mapping, wbc);
-	if (ret == 0 && wbc->sync_mode == WB_SYNC_ALL) {
-		gfs2_log_flush(sdp, ip->i_gl);
-		ret = gfs2_write_cache_jdata(mapping, wbc);
-	}
-	return ret;
-}
-
-/**
- * stuffed_readpage - Fill in a Linux page with stuffed file data
- * @ip: the inode
- * @page: the page
- *
- * Returns: errno
- */
-
-static int stuffed_readpage(struct gfs2_inode *ip, struct page *page)
-{
-	struct buffer_head *dibh;
-	void *kaddr;
-	int error;
-
-	/*
-	 * Due to the order of unstuffing files and ->fault(), we can be
-	 * asked for a zero page in the case of a stuffed file being extended,
-	 * so we need to supply one here. It doesn't happen often.
-	 */
-	if (unlikely(page->index)) {
-		zero_user(page, 0, PAGE_CACHE_SIZE);
-		SetPageUptodate(page);
-		return 0;
-	}
-
-	error = gfs2_meta_inode_buffer(ip, &dibh);
-	if (error)
-		return error;
-
-	kaddr = kmap_atomic(page, KM_USER0);
-	memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode),
-	       ip->i_disksize);
-	memset(kaddr + ip->i_disksize, 0, PAGE_CACHE_SIZE - ip->i_disksize);
-	kunmap_atomic(kaddr, KM_USER0);
-	flush_dcache_page(page);
-	brelse(dibh);
-	SetPageUptodate(page);
-
-	return 0;
-}
-
-
-/**
- * __gfs2_readpage - readpage
- * @file: The file to read a page for
- * @page: The page to read
- *
- * This is the core of gfs2's readpage. Its used by the internal file
- * reading code as in that case we already hold the glock. Also its
- * called by gfs2_readpage() once the required lock has been granted.
- *
- */
-
-static int __gfs2_readpage(void *file, struct page *page)
-{
-	struct gfs2_inode *ip = GFS2_I(page->mapping->host);
-	struct gfs2_sbd *sdp = GFS2_SB(page->mapping->host);
-	int error;
-
-	if (gfs2_is_stuffed(ip)) {
-		error = stuffed_readpage(ip, page);
-		unlock_page(page);
-	} else {
-		error = mpage_readpage(page, gfs2_block_map);
-	}
-
-	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		return -EIO;
-
-	return error;
-}
-
-/**
- * gfs2_readpage - read a page of a file
- * @file: The file to read
- * @page: The page of the file
- *
- * This deals with the locking required. We have to unlock and
- * relock the page in order to get the locking in the right
- * order.
- */
-
-static int gfs2_readpage(struct file *file, struct page *page)
-{
-	struct address_space *mapping = page->mapping;
-	struct gfs2_inode *ip = GFS2_I(mapping->host);
-	struct gfs2_holder gh;
-	int error;
-
-	unlock_page(page);
-	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
-	error = gfs2_glock_nq(&gh);
-	if (unlikely(error))
-		goto out;
-	error = AOP_TRUNCATED_PAGE;
-	lock_page(page);
-	if (page->mapping == mapping && !PageUptodate(page))
-		error = __gfs2_readpage(file, page);
-	else
-		unlock_page(page);
-	gfs2_glock_dq(&gh);
-out:
-	gfs2_holder_uninit(&gh);
-	if (error && error != AOP_TRUNCATED_PAGE)
-		lock_page(page);
-	return error;
-}
-
-/**
- * gfs2_internal_read - read an internal file
- * @ip: The gfs2 inode
- * @ra_state: The readahead state (or NULL for no readahead)
- * @buf: The buffer to fill
- * @pos: The file position
- * @size: The amount to read
- *
- */
-
-int gfs2_internal_read(struct gfs2_inode *ip, struct file_ra_state *ra_state,
-                       char *buf, loff_t *pos, unsigned size)
-{
-	struct address_space *mapping = ip->i_inode.i_mapping;
-	unsigned long index = *pos / PAGE_CACHE_SIZE;
-	unsigned offset = *pos & (PAGE_CACHE_SIZE - 1);
-	unsigned copied = 0;
-	unsigned amt;
-	struct page *page;
-	void *p;
-
-	do {
-		amt = size - copied;
-		if (offset + size > PAGE_CACHE_SIZE)
-			amt = PAGE_CACHE_SIZE - offset;
-		page = read_cache_page(mapping, index, __gfs2_readpage, NULL);
-		if (IS_ERR(page))
-			return PTR_ERR(page);
-		p = kmap_atomic(page, KM_USER0);
-		memcpy(buf + copied, p + offset, amt);
-		kunmap_atomic(p, KM_USER0);
-		mark_page_accessed(page);
-		page_cache_release(page);
-		copied += amt;
-		index++;
-		offset = 0;
-	} while(copied < size);
-	(*pos) += size;
-	return size;
-}
-
-/**
- * gfs2_readpages - Read a bunch of pages at once
- *
- * Some notes:
- * 1. This is only for readahead, so we can simply ignore any things
- *    which are slightly inconvenient (such as locking conflicts between
- *    the page lock and the glock) and return having done no I/O. Its
- *    obviously not something we'd want to do on too regular a basis.
- *    Any I/O we ignore at this time will be done via readpage later.
- * 2. We don't handle stuffed files here we let readpage do the honours.
- * 3. mpage_readpages() does most of the heavy lifting in the common case.
- * 4. gfs2_block_map() is relied upon to set BH_Boundary in the right places.
- */
-
-static int gfs2_readpages(struct file *file, struct address_space *mapping,
-			  struct list_head *pages, unsigned nr_pages)
-{
-	struct inode *inode = mapping->host;
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	struct gfs2_holder gh;
-	int ret;
-
-	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
-	ret = gfs2_glock_nq(&gh);
-	if (unlikely(ret))
-		goto out_uninit;
-	if (!gfs2_is_stuffed(ip))
-		ret = mpage_readpages(mapping, pages, nr_pages, gfs2_block_map);
-	gfs2_glock_dq(&gh);
-out_uninit:
-	gfs2_holder_uninit(&gh);
-	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		ret = -EIO;
-	return ret;
-}
-
-/**
- * gfs2_write_begin - Begin to write to a file
- * @file: The file to write to
- * @mapping: The mapping in which to write
- * @pos: The file offset at which to start writing
- * @len: Length of the write
- * @flags: Various flags
- * @pagep: Pointer to return the page
- * @fsdata: Pointer to return fs data (unused by GFS2)
- *
- * Returns: errno
- */
-
-static int gfs2_write_begin(struct file *file, struct address_space *mapping,
-			    loff_t pos, unsigned len, unsigned flags,
-			    struct page **pagep, void **fsdata)
-{
-	struct gfs2_inode *ip = GFS2_I(mapping->host);
-	struct gfs2_sbd *sdp = GFS2_SB(mapping->host);
-	unsigned int data_blocks = 0, ind_blocks = 0, rblocks;
-	int alloc_required;
-	int error = 0;
-	struct gfs2_alloc *al;
-	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
-	unsigned from = pos & (PAGE_CACHE_SIZE - 1);
-	unsigned to = from + len;
-	struct page *page;
-
-	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &ip->i_gh);
-	error = gfs2_glock_nq(&ip->i_gh);
-	if (unlikely(error))
-		goto out_uninit;
-
-	error = gfs2_write_alloc_required(ip, pos, len, &alloc_required);
-	if (error)
-		goto out_unlock;
-
-	if (alloc_required || gfs2_is_jdata(ip))
-		gfs2_write_calc_reserv(ip, len, &data_blocks, &ind_blocks);
-
-	if (alloc_required) {
-		al = gfs2_alloc_get(ip);
-		if (!al) {
-			error = -ENOMEM;
-			goto out_unlock;
-		}
-
-		error = gfs2_quota_lock_check(ip);
-		if (error)
-			goto out_alloc_put;
-
-		al->al_requested = data_blocks + ind_blocks;
-		error = gfs2_inplace_reserve(ip);
-		if (error)
-			goto out_qunlock;
-	}
-
-	rblocks = RES_DINODE + ind_blocks;
-	if (gfs2_is_jdata(ip))
-		rblocks += data_blocks ? data_blocks : 1;
-	if (ind_blocks || data_blocks)
-		rblocks += RES_STATFS + RES_QUOTA;
-
-	error = gfs2_trans_begin(sdp, rblocks,
-				 PAGE_CACHE_SIZE/sdp->sd_sb.sb_bsize);
-	if (error)
-		goto out_trans_fail;
-
-	error = -ENOMEM;
-	flags |= AOP_FLAG_NOFS;
-	page = grab_cache_page_write_begin(mapping, index, flags);
-	*pagep = page;
-	if (unlikely(!page))
-		goto out_endtrans;
-
-	if (gfs2_is_stuffed(ip)) {
-		error = 0;
-		if (pos + len > sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode)) {
-			error = gfs2_unstuff_dinode(ip, page);
-			if (error == 0)
-				goto prepare_write;
-		} else if (!PageUptodate(page)) {
-			error = stuffed_readpage(ip, page);
-		}
-		goto out;
-	}
-
-prepare_write:
-	error = block_prepare_write(page, from, to, gfs2_block_map);
-out:
-	if (error == 0)
-		return 0;
-
-	page_cache_release(page);
-	if (pos + len > ip->i_inode.i_size)
-		vmtruncate(&ip->i_inode, ip->i_inode.i_size);
-out_endtrans:
-	gfs2_trans_end(sdp);
-out_trans_fail:
-	if (alloc_required) {
-		gfs2_inplace_release(ip);
-out_qunlock:
-		gfs2_quota_unlock(ip);
-out_alloc_put:
-		gfs2_alloc_put(ip);
-	}
-out_unlock:
-	gfs2_glock_dq(&ip->i_gh);
-out_uninit:
-	gfs2_holder_uninit(&ip->i_gh);
-	return error;
-}
-
-/**
- * adjust_fs_space - Adjusts the free space available due to gfs2_grow
- * @inode: the rindex inode
- */
-static void adjust_fs_space(struct inode *inode)
-{
-	struct gfs2_sbd *sdp = inode->i_sb->s_fs_info;
-	struct gfs2_statfs_change_host *m_sc = &sdp->sd_statfs_master;
-	struct gfs2_statfs_change_host *l_sc = &sdp->sd_statfs_local;
-	u64 fs_total, new_free;
-
-	/* Total up the file system space, according to the latest rindex. */
-	fs_total = gfs2_ri_total(sdp);
-
-	spin_lock(&sdp->sd_statfs_spin);
-	if (fs_total > (m_sc->sc_total + l_sc->sc_total))
-		new_free = fs_total - (m_sc->sc_total + l_sc->sc_total);
-	else
-		new_free = 0;
-	spin_unlock(&sdp->sd_statfs_spin);
-	fs_warn(sdp, "File system extended by %llu blocks.\n",
-		(unsigned long long)new_free);
-	gfs2_statfs_change(sdp, new_free, new_free, 0);
-}
-
-/**
- * gfs2_stuffed_write_end - Write end for stuffed files
- * @inode: The inode
- * @dibh: The buffer_head containing the on-disk inode
- * @pos: The file position
- * @len: The length of the write
- * @copied: How much was actually copied by the VFS
- * @page: The page
- *
- * This copies the data from the page into the inode block after
- * the inode data structure itself.
- *
- * Returns: errno
- */
-static int gfs2_stuffed_write_end(struct inode *inode, struct buffer_head *dibh,
-				  loff_t pos, unsigned len, unsigned copied,
-				  struct page *page)
-{
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	u64 to = pos + copied;
-	void *kaddr;
-	unsigned char *buf = dibh->b_data + sizeof(struct gfs2_dinode);
-	struct gfs2_dinode *di = (struct gfs2_dinode *)dibh->b_data;
-
-	BUG_ON((pos + len) > (dibh->b_size - sizeof(struct gfs2_dinode)));
-	kaddr = kmap_atomic(page, KM_USER0);
-	memcpy(buf + pos, kaddr + pos, copied);
-	memset(kaddr + pos + copied, 0, len - copied);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
-
-	if (!PageUptodate(page))
-		SetPageUptodate(page);
-	unlock_page(page);
-	page_cache_release(page);
-
-	if (copied) {
-		if (inode->i_size < to) {
-			i_size_write(inode, to);
-			ip->i_disksize = inode->i_size;
-		}
-		gfs2_dinode_out(ip, di);
-		mark_inode_dirty(inode);
-	}
-
-	if (inode == sdp->sd_rindex)
-		adjust_fs_space(inode);
-
-	brelse(dibh);
-	gfs2_trans_end(sdp);
-	gfs2_glock_dq(&ip->i_gh);
-	gfs2_holder_uninit(&ip->i_gh);
-	return copied;
-}
-
-/**
- * gfs2_write_end
- * @file: The file to write to
- * @mapping: The address space to write to
- * @pos: The file position
- * @len: The length of the data
- * @copied:
- * @page: The page that has been written
- * @fsdata: The fsdata (unused in GFS2)
- *
- * The main write_end function for GFS2. We have a separate one for
- * stuffed files as they are slightly different, otherwise we just
- * put our locking around the VFS provided functions.
- *
- * Returns: errno
- */
-
-static int gfs2_write_end(struct file *file, struct address_space *mapping,
-			  loff_t pos, unsigned len, unsigned copied,
-			  struct page *page, void *fsdata)
-{
-	struct inode *inode = page->mapping->host;
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	struct buffer_head *dibh;
-	struct gfs2_alloc *al = ip->i_alloc;
-	unsigned int from = pos & (PAGE_CACHE_SIZE - 1);
-	unsigned int to = from + len;
-	int ret;
-
-	BUG_ON(gfs2_glock_is_locked_by_me(ip->i_gl) == NULL);
-
-	ret = gfs2_meta_inode_buffer(ip, &dibh);
-	if (unlikely(ret)) {
-		unlock_page(page);
-		page_cache_release(page);
-		goto failed;
-	}
-
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
-
-	if (gfs2_is_stuffed(ip))
-		return gfs2_stuffed_write_end(inode, dibh, pos, len, copied, page);
-
-	if (!gfs2_is_writeback(ip))
-		gfs2_page_add_databufs(ip, page, from, to);
-
-	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
-	if (ret > 0) {
-		if (inode->i_size > ip->i_disksize)
-			ip->i_disksize = inode->i_size;
-		gfs2_dinode_out(ip, dibh->b_data);
-		mark_inode_dirty(inode);
-	}
-
-	if (inode == sdp->sd_rindex)
-		adjust_fs_space(inode);
-
-	brelse(dibh);
-	gfs2_trans_end(sdp);
-failed:
-	if (al) {
-		gfs2_inplace_release(ip);
-		gfs2_quota_unlock(ip);
-		gfs2_alloc_put(ip);
-	}
-	gfs2_glock_dq(&ip->i_gh);
-	gfs2_holder_uninit(&ip->i_gh);
-	return ret;
-}
-
-/**
- * gfs2_set_page_dirty - Page dirtying function
- * @page: The page to dirty
- *
- * Returns: 1 if it dirtyed the page, or 0 otherwise
- */
- 
-static int gfs2_set_page_dirty(struct page *page)
-{
-	SetPageChecked(page);
-	return __set_page_dirty_buffers(page);
-}
-
-/**
- * gfs2_bmap - Block map function
- * @mapping: Address space info
- * @lblock: The block to map
- *
- * Returns: The disk address for the block or 0 on hole or error
- */
-
-static sector_t gfs2_bmap(struct address_space *mapping, sector_t lblock)
-{
-	struct gfs2_inode *ip = GFS2_I(mapping->host);
-	struct gfs2_holder i_gh;
-	sector_t dblock = 0;
-	int error;
-
-	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, &i_gh);
-	if (error)
-		return 0;
-
-	if (!gfs2_is_stuffed(ip))
-		dblock = generic_block_bmap(mapping, lblock, gfs2_block_map);
-
-	gfs2_glock_dq_uninit(&i_gh);
-
-	return dblock;
-}
-
-static void gfs2_discard(struct gfs2_sbd *sdp, struct buffer_head *bh)
-{
-	struct gfs2_bufdata *bd;
-
-	lock_buffer(bh);
-	gfs2_log_lock(sdp);
-	clear_buffer_dirty(bh);
-	bd = bh->b_private;
-	if (bd) {
-		if (!list_empty(&bd->bd_le.le_list) && !buffer_pinned(bh))
-			list_del_init(&bd->bd_le.le_list);
-		else
-			gfs2_remove_from_journal(bh, current->journal_info, 0);
-	}
-	bh->b_bdev = NULL;
-	clear_buffer_mapped(bh);
-	clear_buffer_req(bh);
-	clear_buffer_new(bh);
-	gfs2_log_unlock(sdp);
-	unlock_buffer(bh);
-}
-
-static void gfs2_invalidatepage(struct page *page, unsigned long offset)
-{
-	struct gfs2_sbd *sdp = GFS2_SB(page->mapping->host);
-	struct buffer_head *bh, *head;
-	unsigned long pos = 0;
-
-	BUG_ON(!PageLocked(page));
-	if (offset == 0)
-		ClearPageChecked(page);
-	if (!page_has_buffers(page))
-		goto out;
-
-	bh = head = page_buffers(page);
-	do {
-		if (offset <= pos)
-			gfs2_discard(sdp, bh);
-		pos += bh->b_size;
-		bh = bh->b_this_page;
-	} while (bh != head);
-out:
-	if (offset == 0)
-		try_to_release_page(page, 0);
-}
-
-/**
- * gfs2_ok_for_dio - check that dio is valid on this file
- * @ip: The inode
- * @rw: READ or WRITE
- * @offset: The offset at which we are reading or writing
- *
- * Returns: 0 (to ignore the i/o request and thus fall back to buffered i/o)
- *          1 (to accept the i/o request)
- */
-static int gfs2_ok_for_dio(struct gfs2_inode *ip, int rw, loff_t offset)
-{
-	/*
-	 * Should we return an error here? I can't see that O_DIRECT for
-	 * a stuffed file makes any sense. For now we'll silently fall
-	 * back to buffered I/O
-	 */
-	if (gfs2_is_stuffed(ip))
-		return 0;
-
-	if (offset >= i_size_read(&ip->i_inode))
-		return 0;
-	return 1;
-}
-
-
-
-static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
-			      const struct iovec *iov, loff_t offset,
-			      unsigned long nr_segs)
-{
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_mapping->host;
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_holder gh;
-	int rv;
-
-	/*
-	 * Deferred lock, even if its a write, since we do no allocation
-	 * on this path. All we need change is atime, and this lock mode
-	 * ensures that other nodes have flushed their buffered read caches
-	 * (i.e. their page cache entries for this inode). We do not,
-	 * unfortunately have the option of only flushing a range like
-	 * the VFS does.
-	 */
-	gfs2_holder_init(ip->i_gl, LM_ST_DEFERRED, 0, &gh);
-	rv = gfs2_glock_nq(&gh);
-	if (rv)
-		return rv;
-	rv = gfs2_ok_for_dio(ip, rw, offset);
-	if (rv != 1)
-		goto out; /* dio not valid, fall back to buffered i/o */
-
-	rv = blockdev_direct_IO_no_locking(rw, iocb, inode, inode->i_sb->s_bdev,
-					   iov, offset, nr_segs,
-					   gfs2_get_block_direct, NULL);
-out:
-	gfs2_glock_dq_m(1, &gh);
-	gfs2_holder_uninit(&gh);
-	return rv;
-}
-
-/**
- * gfs2_releasepage - free the metadata associated with a page
- * @page: the page that's being released
- * @gfp_mask: passed from Linux VFS, ignored by us
- *
- * Call try_to_free_buffers() if the buffers in this page can be
- * released.
- *
- * Returns: 0
- */
-
-int gfs2_releasepage(struct page *page, gfp_t gfp_mask)
-{
-	struct inode *aspace = page->mapping->host;
-	struct gfs2_sbd *sdp = aspace->i_sb->s_fs_info;
-	struct buffer_head *bh, *head;
-	struct gfs2_bufdata *bd;
-
-	if (!page_has_buffers(page))
-		return 0;
-
-	gfs2_log_lock(sdp);
-	head = bh = page_buffers(page);
-	do {
-		if (atomic_read(&bh->b_count))
-			goto cannot_release;
-		bd = bh->b_private;
-		if (bd && bd->bd_ail)
-			goto cannot_release;
-		gfs2_assert_warn(sdp, !buffer_pinned(bh));
-		gfs2_assert_warn(sdp, !buffer_dirty(bh));
-		bh = bh->b_this_page;
-	} while(bh != head);
-	gfs2_log_unlock(sdp);
-
-	head = bh = page_buffers(page);
-	do {
-		gfs2_log_lock(sdp);
-		bd = bh->b_private;
-		if (bd) {
-			gfs2_assert_warn(sdp, bd->bd_bh == bh);
-			gfs2_assert_warn(sdp, list_empty(&bd->bd_list_tr));
-			if (!list_empty(&bd->bd_le.le_list)) {
-				if (!buffer_pinned(bh))
-					list_del_init(&bd->bd_le.le_list);
-				else
-					bd = NULL;
-			}
-			if (bd)
-				bd->bd_bh = NULL;
-			bh->b_private = NULL;
-		}
-		gfs2_log_unlock(sdp);
-		if (bd)
-			kmem_cache_free(gfs2_bufdata_cachep, bd);
-
-		bh = bh->b_this_page;
-	} while (bh != head);
-
-	return try_to_free_buffers(page);
-cannot_release:
-	gfs2_log_unlock(sdp);
-	return 0;
-}
-
-static const struct address_space_operations gfs2_writeback_aops = {
-	.writepage = gfs2_writeback_writepage,
-	.writepages = gfs2_writeback_writepages,
-	.readpage = gfs2_readpage,
-	.readpages = gfs2_readpages,
-	.sync_page = block_sync_page,
-	.write_begin = gfs2_write_begin,
-	.write_end = gfs2_write_end,
-	.bmap = gfs2_bmap,
-	.invalidatepage = gfs2_invalidatepage,
-	.releasepage = gfs2_releasepage,
-	.direct_IO = gfs2_direct_IO,
-	.migratepage = buffer_migrate_page,
-	.is_partially_uptodate = block_is_partially_uptodate,
-};
-
-static const struct address_space_operations gfs2_ordered_aops = {
-	.writepage = gfs2_ordered_writepage,
-	.readpage = gfs2_readpage,
-	.readpages = gfs2_readpages,
-	.sync_page = block_sync_page,
-	.write_begin = gfs2_write_begin,
-	.write_end = gfs2_write_end,
-	.set_page_dirty = gfs2_set_page_dirty,
-	.bmap = gfs2_bmap,
-	.invalidatepage = gfs2_invalidatepage,
-	.releasepage = gfs2_releasepage,
-	.direct_IO = gfs2_direct_IO,
-	.migratepage = buffer_migrate_page,
-	.is_partially_uptodate = block_is_partially_uptodate,
-};
-
-static const struct address_space_operations gfs2_jdata_aops = {
-	.writepage = gfs2_jdata_writepage,
-	.writepages = gfs2_jdata_writepages,
-	.readpage = gfs2_readpage,
-	.readpages = gfs2_readpages,
-	.sync_page = block_sync_page,
-	.write_begin = gfs2_write_begin,
-	.write_end = gfs2_write_end,
-	.set_page_dirty = gfs2_set_page_dirty,
-	.bmap = gfs2_bmap,
-	.invalidatepage = gfs2_invalidatepage,
-	.releasepage = gfs2_releasepage,
-	.is_partially_uptodate = block_is_partially_uptodate,
-};
-
-void gfs2_set_aops(struct inode *inode)
-{
-	struct gfs2_inode *ip = GFS2_I(inode);
-
-	if (gfs2_is_writeback(ip))
-		inode->i_mapping->a_ops = &gfs2_writeback_aops;
-	else if (gfs2_is_ordered(ip))
-		inode->i_mapping->a_ops = &gfs2_ordered_aops;
-	else if (gfs2_is_jdata(ip))
-		inode->i_mapping->a_ops = &gfs2_jdata_aops;
-	else
-		BUG();
-}
-
diff --git a/fs/gfs2/ops_address.h b/fs/gfs2/ops_address.h
deleted file mode 100644
index 5da2128..0000000
--- a/fs/gfs2/ops_address.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#ifndef __OPS_ADDRESS_DOT_H__
-#define __OPS_ADDRESS_DOT_H__
-
-#include <linux/fs.h>
-#include <linux/buffer_head.h>
-#include <linux/mm.h>
-
-extern int gfs2_releasepage(struct page *page, gfp_t gfp_mask);
-extern int gfs2_internal_read(struct gfs2_inode *ip,
-			      struct file_ra_state *ra_state,
-			      char *buf, loff_t *pos, unsigned size);
-extern void gfs2_set_aops(struct inode *inode);
-
-#endif /* __OPS_ADDRESS_DOT_H__ */
diff --git a/fs/gfs2/ops_dentry.c b/fs/gfs2/ops_dentry.c
deleted file mode 100644
index 022c66c..0000000
--- a/fs/gfs2/ops_dentry.c
+++ /dev/null
@@ -1,114 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/completion.h>
-#include <linux/buffer_head.h>
-#include <linux/gfs2_ondisk.h>
-#include <linux/crc32.h>
-
-#include "gfs2.h"
-#include "incore.h"
-#include "dir.h"
-#include "glock.h"
-#include "super.h"
-#include "util.h"
-#include "inode.h"
-
-/**
- * gfs2_drevalidate - Check directory lookup consistency
- * @dentry: the mapping to check
- * @nd:
- *
- * Check to make sure the lookup necessary to arrive at this inode from its
- * parent is still good.
- *
- * Returns: 1 if the dentry is ok, 0 if it isn't
- */
-
-static int gfs2_drevalidate(struct dentry *dentry, struct nameidata *nd)
-{
-	struct dentry *parent = dget_parent(dentry);
-	struct gfs2_sbd *sdp = GFS2_SB(parent->d_inode);
-	struct gfs2_inode *dip = GFS2_I(parent->d_inode);
-	struct inode *inode = dentry->d_inode;
-	struct gfs2_holder d_gh;
-	struct gfs2_inode *ip = NULL;
-	int error;
-	int had_lock = 0;
-
-	if (inode) {
-		if (is_bad_inode(inode))
-			goto invalid;
-		ip = GFS2_I(inode);
-	}
-
-	if (sdp->sd_args.ar_localcaching)
-		goto valid;
-
-	had_lock = (gfs2_glock_is_locked_by_me(dip->i_gl) != NULL);
-	if (!had_lock) {
-		error = gfs2_glock_nq_init(dip->i_gl, LM_ST_SHARED, 0, &d_gh);
-		if (error)
-			goto fail;
-	} 
-
-	error = gfs2_dir_check(parent->d_inode, &dentry->d_name, ip);
-	switch (error) {
-	case 0:
-		if (!inode)
-			goto invalid_gunlock;
-		break;
-	case -ENOENT:
-		if (!inode)
-			goto valid_gunlock;
-		goto invalid_gunlock;
-	default:
-		goto fail_gunlock;
-	}
-
-valid_gunlock:
-	if (!had_lock)
-		gfs2_glock_dq_uninit(&d_gh);
-valid:
-	dput(parent);
-	return 1;
-
-invalid_gunlock:
-	if (!had_lock)
-		gfs2_glock_dq_uninit(&d_gh);
-invalid:
-	if (inode && S_ISDIR(inode->i_mode)) {
-		if (have_submounts(dentry))
-			goto valid;
-		shrink_dcache_parent(dentry);
-	}
-	d_drop(dentry);
-	dput(parent);
-	return 0;
-
-fail_gunlock:
-	gfs2_glock_dq_uninit(&d_gh);
-fail:
-	dput(parent);
-	return 0;
-}
-
-static int gfs2_dhash(struct dentry *dentry, struct qstr *str)
-{
-	str->hash = gfs2_disk_hash(str->name, str->len);
-	return 0;
-}
-
-const struct dentry_operations gfs2_dops = {
-	.d_revalidate = gfs2_drevalidate,
-	.d_hash = gfs2_dhash,
-};
-
diff --git a/fs/gfs2/ops_export.c b/fs/gfs2/ops_export.c
deleted file mode 100644
index 9200ef2..0000000
--- a/fs/gfs2/ops_export.c
+++ /dev/null
@@ -1,285 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/completion.h>
-#include <linux/buffer_head.h>
-#include <linux/exportfs.h>
-#include <linux/gfs2_ondisk.h>
-#include <linux/crc32.h>
-
-#include "gfs2.h"
-#include "incore.h"
-#include "dir.h"
-#include "glock.h"
-#include "glops.h"
-#include "inode.h"
-#include "super.h"
-#include "rgrp.h"
-#include "util.h"
-
-#define GFS2_SMALL_FH_SIZE 4
-#define GFS2_LARGE_FH_SIZE 8
-#define GFS2_OLD_FH_SIZE 10
-
-static int gfs2_encode_fh(struct dentry *dentry, __u32 *p, int *len,
-			  int connectable)
-{
-	__be32 *fh = (__force __be32 *)p;
-	struct inode *inode = dentry->d_inode;
-	struct super_block *sb = inode->i_sb;
-	struct gfs2_inode *ip = GFS2_I(inode);
-
-	if (*len < GFS2_SMALL_FH_SIZE ||
-	    (connectable && *len < GFS2_LARGE_FH_SIZE))
-		return 255;
-
-	fh[0] = cpu_to_be32(ip->i_no_formal_ino >> 32);
-	fh[1] = cpu_to_be32(ip->i_no_formal_ino & 0xFFFFFFFF);
-	fh[2] = cpu_to_be32(ip->i_no_addr >> 32);
-	fh[3] = cpu_to_be32(ip->i_no_addr & 0xFFFFFFFF);
-	*len = GFS2_SMALL_FH_SIZE;
-
-	if (!connectable || inode == sb->s_root->d_inode)
-		return *len;
-
-	spin_lock(&dentry->d_lock);
-	inode = dentry->d_parent->d_inode;
-	ip = GFS2_I(inode);
-	igrab(inode);
-	spin_unlock(&dentry->d_lock);
-
-	fh[4] = cpu_to_be32(ip->i_no_formal_ino >> 32);
-	fh[5] = cpu_to_be32(ip->i_no_formal_ino & 0xFFFFFFFF);
-	fh[6] = cpu_to_be32(ip->i_no_addr >> 32);
-	fh[7] = cpu_to_be32(ip->i_no_addr & 0xFFFFFFFF);
-	*len = GFS2_LARGE_FH_SIZE;
-
-	iput(inode);
-
-	return *len;
-}
-
-struct get_name_filldir {
-	struct gfs2_inum_host inum;
-	char *name;
-};
-
-static int get_name_filldir(void *opaque, const char *name, int length,
-			    loff_t offset, u64 inum, unsigned int type)
-{
-	struct get_name_filldir *gnfd = opaque;
-
-	if (inum != gnfd->inum.no_addr)
-		return 0;
-
-	memcpy(gnfd->name, name, length);
-	gnfd->name[length] = 0;
-
-	return 1;
-}
-
-static int gfs2_get_name(struct dentry *parent, char *name,
-			 struct dentry *child)
-{
-	struct inode *dir = parent->d_inode;
-	struct inode *inode = child->d_inode;
-	struct gfs2_inode *dip, *ip;
-	struct get_name_filldir gnfd;
-	struct gfs2_holder gh;
-	u64 offset = 0;
-	int error;
-
-	if (!dir)
-		return -EINVAL;
-
-	if (!S_ISDIR(dir->i_mode) || !inode)
-		return -EINVAL;
-
-	dip = GFS2_I(dir);
-	ip = GFS2_I(inode);
-
-	*name = 0;
-	gnfd.inum.no_addr = ip->i_no_addr;
-	gnfd.inum.no_formal_ino = ip->i_no_formal_ino;
-	gnfd.name = name;
-
-	error = gfs2_glock_nq_init(dip->i_gl, LM_ST_SHARED, 0, &gh);
-	if (error)
-		return error;
-
-	error = gfs2_dir_read(dir, &offset, &gnfd, get_name_filldir);
-
-	gfs2_glock_dq_uninit(&gh);
-
-	if (!error && !*name)
-		error = -ENOENT;
-
-	return error;
-}
-
-static struct dentry *gfs2_get_parent(struct dentry *child)
-{
-	struct qstr dotdot;
-	struct dentry *dentry;
-
-	/*
-	 * XXX(hch): it would be a good idea to keep this around as a
-	 *	     static variable.
-	 */
-	gfs2_str2qstr(&dotdot, "..");
-
-	dentry = d_obtain_alias(gfs2_lookupi(child->d_inode, &dotdot, 1));
-	if (!IS_ERR(dentry))
-		dentry->d_op = &gfs2_dops;
-	return dentry;
-}
-
-static struct dentry *gfs2_get_dentry(struct super_block *sb,
-		struct gfs2_inum_host *inum)
-{
-	struct gfs2_sbd *sdp = sb->s_fs_info;
-	struct gfs2_holder i_gh, ri_gh, rgd_gh;
-	struct gfs2_rgrpd *rgd;
-	struct inode *inode;
-	struct dentry *dentry;
-	int error;
-
-	/* System files? */
-
-	inode = gfs2_ilookup(sb, inum->no_addr);
-	if (inode) {
-		if (GFS2_I(inode)->i_no_formal_ino != inum->no_formal_ino) {
-			iput(inode);
-			return ERR_PTR(-ESTALE);
-		}
-		goto out_inode;
-	}
-
-	error = gfs2_glock_nq_num(sdp, inum->no_addr, &gfs2_inode_glops,
-				  LM_ST_SHARED, LM_FLAG_ANY, &i_gh);
-	if (error)
-		return ERR_PTR(error);
-
-	error = gfs2_rindex_hold(sdp, &ri_gh);
-	if (error)
-		goto fail;
-
-	error = -EINVAL;
-	rgd = gfs2_blk2rgrpd(sdp, inum->no_addr);
-	if (!rgd)
-		goto fail_rindex;
-
-	error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_SHARED, 0, &rgd_gh);
-	if (error)
-		goto fail_rindex;
-
-	error = -ESTALE;
-	if (gfs2_get_block_type(rgd, inum->no_addr) != GFS2_BLKST_DINODE)
-		goto fail_rgd;
-
-	gfs2_glock_dq_uninit(&rgd_gh);
-	gfs2_glock_dq_uninit(&ri_gh);
-
-	inode = gfs2_inode_lookup(sb, DT_UNKNOWN,
-					inum->no_addr,
-					0, 0);
-	if (IS_ERR(inode)) {
-		error = PTR_ERR(inode);
-		goto fail;
-	}
-
-	error = gfs2_inode_refresh(GFS2_I(inode));
-	if (error) {
-		iput(inode);
-		goto fail;
-	}
-
-	/* Pick up the works we bypass in gfs2_inode_lookup */
-	if (inode->i_state & I_NEW) 
-		gfs2_set_iop(inode);
-
-	if (GFS2_I(inode)->i_no_formal_ino != inum->no_formal_ino) {
-		iput(inode);
-		goto fail;
-	}
-
-	error = -EIO;
-	if (GFS2_I(inode)->i_diskflags & GFS2_DIF_SYSTEM) {
-		iput(inode);
-		goto fail;
-	}
-
-	gfs2_glock_dq_uninit(&i_gh);
-
-out_inode:
-	dentry = d_obtain_alias(inode);
-	if (!IS_ERR(dentry))
-		dentry->d_op = &gfs2_dops;
-	return dentry;
-
-fail_rgd:
-	gfs2_glock_dq_uninit(&rgd_gh);
-
-fail_rindex:
-	gfs2_glock_dq_uninit(&ri_gh);
-
-fail:
-	gfs2_glock_dq_uninit(&i_gh);
-	return ERR_PTR(error);
-}
-
-static struct dentry *gfs2_fh_to_dentry(struct super_block *sb, struct fid *fid,
-		int fh_len, int fh_type)
-{
-	struct gfs2_inum_host this;
-	__be32 *fh = (__force __be32 *)fid->raw;
-
-	switch (fh_type) {
-	case GFS2_SMALL_FH_SIZE:
-	case GFS2_LARGE_FH_SIZE:
-	case GFS2_OLD_FH_SIZE:
-		this.no_formal_ino = ((u64)be32_to_cpu(fh[0])) << 32;
-		this.no_formal_ino |= be32_to_cpu(fh[1]);
-		this.no_addr = ((u64)be32_to_cpu(fh[2])) << 32;
-		this.no_addr |= be32_to_cpu(fh[3]);
-		return gfs2_get_dentry(sb, &this);
-	default:
-		return NULL;
-	}
-}
-
-static struct dentry *gfs2_fh_to_parent(struct super_block *sb, struct fid *fid,
-		int fh_len, int fh_type)
-{
-	struct gfs2_inum_host parent;
-	__be32 *fh = (__force __be32 *)fid->raw;
-
-	switch (fh_type) {
-	case GFS2_LARGE_FH_SIZE:
-	case GFS2_OLD_FH_SIZE:
-		parent.no_formal_ino = ((u64)be32_to_cpu(fh[4])) << 32;
-		parent.no_formal_ino |= be32_to_cpu(fh[5]);
-		parent.no_addr = ((u64)be32_to_cpu(fh[6])) << 32;
-		parent.no_addr |= be32_to_cpu(fh[7]);
-		return gfs2_get_dentry(sb, &parent);
-	default:
-		return NULL;
-	}
-}
-
-const struct export_operations gfs2_export_ops = {
-	.encode_fh = gfs2_encode_fh,
-	.fh_to_dentry = gfs2_fh_to_dentry,
-	.fh_to_parent = gfs2_fh_to_parent,
-	.get_name = gfs2_get_name,
-	.get_parent = gfs2_get_parent,
-};
-
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
deleted file mode 100644
index 0ee7bd2..0000000
--- a/fs/gfs2/ops_file.c
+++ /dev/null
@@ -1,766 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/completion.h>
-#include <linux/buffer_head.h>
-#include <linux/pagemap.h>
-#include <linux/uio.h>
-#include <linux/blkdev.h>
-#include <linux/mm.h>
-#include <linux/mount.h>
-#include <linux/fs.h>
-#include <linux/gfs2_ondisk.h>
-#include <linux/ext2_fs.h>
-#include <linux/crc32.h>
-#include <linux/writeback.h>
-#include <asm/uaccess.h>
-#include <linux/dlm.h>
-#include <linux/dlm_plock.h>
-
-#include "gfs2.h"
-#include "incore.h"
-#include "bmap.h"
-#include "dir.h"
-#include "glock.h"
-#include "glops.h"
-#include "inode.h"
-#include "log.h"
-#include "meta_io.h"
-#include "quota.h"
-#include "rgrp.h"
-#include "trans.h"
-#include "util.h"
-#include "eaops.h"
-#include "ops_address.h"
-
-/**
- * gfs2_llseek - seek to a location in a file
- * @file: the file
- * @offset: the offset
- * @origin: Where to seek from (SEEK_SET, SEEK_CUR, or SEEK_END)
- *
- * SEEK_END requires the glock for the file because it references the
- * file's size.
- *
- * Returns: The new offset, or errno
- */
-
-static loff_t gfs2_llseek(struct file *file, loff_t offset, int origin)
-{
-	struct gfs2_inode *ip = GFS2_I(file->f_mapping->host);
-	struct gfs2_holder i_gh;
-	loff_t error;
-
-	if (origin == 2) {
-		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY,
-					   &i_gh);
-		if (!error) {
-			error = generic_file_llseek_unlocked(file, offset, origin);
-			gfs2_glock_dq_uninit(&i_gh);
-		}
-	} else
-		error = generic_file_llseek_unlocked(file, offset, origin);
-
-	return error;
-}
-
-/**
- * gfs2_readdir - Read directory entries from a directory
- * @file: The directory to read from
- * @dirent: Buffer for dirents
- * @filldir: Function used to do the copying
- *
- * Returns: errno
- */
-
-static int gfs2_readdir(struct file *file, void *dirent, filldir_t filldir)
-{
-	struct inode *dir = file->f_mapping->host;
-	struct gfs2_inode *dip = GFS2_I(dir);
-	struct gfs2_holder d_gh;
-	u64 offset = file->f_pos;
-	int error;
-
-	gfs2_holder_init(dip->i_gl, LM_ST_SHARED, 0, &d_gh);
-	error = gfs2_glock_nq(&d_gh);
-	if (error) {
-		gfs2_holder_uninit(&d_gh);
-		return error;
-	}
-
-	error = gfs2_dir_read(dir, &offset, dirent, filldir);
-
-	gfs2_glock_dq_uninit(&d_gh);
-
-	file->f_pos = offset;
-
-	return error;
-}
-
-/**
- * fsflags_cvt
- * @table: A table of 32 u32 flags
- * @val: a 32 bit value to convert
- *
- * This function can be used to convert between fsflags values and
- * GFS2's own flags values.
- *
- * Returns: the converted flags
- */
-static u32 fsflags_cvt(const u32 *table, u32 val)
-{
-	u32 res = 0;
-	while(val) {
-		if (val & 1)
-			res |= *table;
-		table++;
-		val >>= 1;
-	}
-	return res;
-}
-
-static const u32 fsflags_to_gfs2[32] = {
-	[3] = GFS2_DIF_SYNC,
-	[4] = GFS2_DIF_IMMUTABLE,
-	[5] = GFS2_DIF_APPENDONLY,
-	[7] = GFS2_DIF_NOATIME,
-	[12] = GFS2_DIF_EXHASH,
-	[14] = GFS2_DIF_INHERIT_JDATA,
-};
-
-static const u32 gfs2_to_fsflags[32] = {
-	[gfs2fl_Sync] = FS_SYNC_FL,
-	[gfs2fl_Immutable] = FS_IMMUTABLE_FL,
-	[gfs2fl_AppendOnly] = FS_APPEND_FL,
-	[gfs2fl_NoAtime] = FS_NOATIME_FL,
-	[gfs2fl_ExHash] = FS_INDEX_FL,
-	[gfs2fl_InheritJdata] = FS_JOURNAL_DATA_FL,
-};
-
-static int gfs2_get_flags(struct file *filp, u32 __user *ptr)
-{
-	struct inode *inode = filp->f_path.dentry->d_inode;
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_holder gh;
-	int error;
-	u32 fsflags;
-
-	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
-	error = gfs2_glock_nq(&gh);
-	if (error)
-		return error;
-
-	fsflags = fsflags_cvt(gfs2_to_fsflags, ip->i_diskflags);
-	if (!S_ISDIR(inode->i_mode) && ip->i_diskflags & GFS2_DIF_JDATA)
-		fsflags |= FS_JOURNAL_DATA_FL;
-	if (put_user(fsflags, ptr))
-		error = -EFAULT;
-
-	gfs2_glock_dq(&gh);
-	gfs2_holder_uninit(&gh);
-	return error;
-}
-
-void gfs2_set_inode_flags(struct inode *inode)
-{
-	struct gfs2_inode *ip = GFS2_I(inode);
-	unsigned int flags = inode->i_flags;
-
-	flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
-	if (ip->i_diskflags & GFS2_DIF_IMMUTABLE)
-		flags |= S_IMMUTABLE;
-	if (ip->i_diskflags & GFS2_DIF_APPENDONLY)
-		flags |= S_APPEND;
-	if (ip->i_diskflags & GFS2_DIF_NOATIME)
-		flags |= S_NOATIME;
-	if (ip->i_diskflags & GFS2_DIF_SYNC)
-		flags |= S_SYNC;
-	inode->i_flags = flags;
-}
-
-/* Flags that can be set by user space */
-#define GFS2_FLAGS_USER_SET (GFS2_DIF_JDATA|			\
-			     GFS2_DIF_IMMUTABLE|		\
-			     GFS2_DIF_APPENDONLY|		\
-			     GFS2_DIF_NOATIME|			\
-			     GFS2_DIF_SYNC|			\
-			     GFS2_DIF_SYSTEM|			\
-			     GFS2_DIF_INHERIT_JDATA)
-
-/**
- * gfs2_set_flags - set flags on an inode
- * @inode: The inode
- * @flags: The flags to set
- * @mask: Indicates which flags are valid
- *
- */
-static int do_gfs2_set_flags(struct file *filp, u32 reqflags, u32 mask)
-{
-	struct inode *inode = filp->f_path.dentry->d_inode;
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	struct buffer_head *bh;
-	struct gfs2_holder gh;
-	int error;
-	u32 new_flags, flags;
-
-	error = mnt_want_write(filp->f_path.mnt);
-	if (error)
-		return error;
-
-	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
-	if (error)
-		goto out_drop_write;
-
-	flags = ip->i_diskflags;
-	new_flags = (flags & ~mask) | (reqflags & mask);
-	if ((new_flags ^ flags) == 0)
-		goto out;
-
-	error = -EINVAL;
-	if ((new_flags ^ flags) & ~GFS2_FLAGS_USER_SET)
-		goto out;
-
-	error = -EPERM;
-	if (IS_IMMUTABLE(inode) && (new_flags & GFS2_DIF_IMMUTABLE))
-		goto out;
-	if (IS_APPEND(inode) && (new_flags & GFS2_DIF_APPENDONLY))
-		goto out;
-	if (((new_flags ^ flags) & GFS2_DIF_IMMUTABLE) &&
-	    !capable(CAP_LINUX_IMMUTABLE))
-		goto out;
-	if (!IS_IMMUTABLE(inode)) {
-		error = gfs2_permission(inode, MAY_WRITE);
-		if (error)
-			goto out;
-	}
-	if ((flags ^ new_flags) & GFS2_DIF_JDATA) {
-		if (flags & GFS2_DIF_JDATA)
-			gfs2_log_flush(sdp, ip->i_gl);
-		error = filemap_fdatawrite(inode->i_mapping);
-		if (error)
-			goto out;
-		error = filemap_fdatawait(inode->i_mapping);
-		if (error)
-			goto out;
-	}
-	error = gfs2_trans_begin(sdp, RES_DINODE, 0);
-	if (error)
-		goto out;
-	error = gfs2_meta_inode_buffer(ip, &bh);
-	if (error)
-		goto out_trans_end;
-	gfs2_trans_add_bh(ip->i_gl, bh, 1);
-	ip->i_diskflags = new_flags;
-	gfs2_dinode_out(ip, bh->b_data);
-	brelse(bh);
-	gfs2_set_inode_flags(inode);
-	gfs2_set_aops(inode);
-out_trans_end:
-	gfs2_trans_end(sdp);
-out:
-	gfs2_glock_dq_uninit(&gh);
-out_drop_write:
-	mnt_drop_write(filp->f_path.mnt);
-	return error;
-}
-
-static int gfs2_set_flags(struct file *filp, u32 __user *ptr)
-{
-	struct inode *inode = filp->f_path.dentry->d_inode;
-	u32 fsflags, gfsflags;
-	if (get_user(fsflags, ptr))
-		return -EFAULT;
-	gfsflags = fsflags_cvt(fsflags_to_gfs2, fsflags);
-	if (!S_ISDIR(inode->i_mode)) {
-		if (gfsflags & GFS2_DIF_INHERIT_JDATA)
-			gfsflags ^= (GFS2_DIF_JDATA | GFS2_DIF_INHERIT_JDATA);
-		return do_gfs2_set_flags(filp, gfsflags, ~0);
-	}
-	return do_gfs2_set_flags(filp, gfsflags, ~GFS2_DIF_JDATA);
-}
-
-static long gfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
-{
-	switch(cmd) {
-	case FS_IOC_GETFLAGS:
-		return gfs2_get_flags(filp, (u32 __user *)arg);
-	case FS_IOC_SETFLAGS:
-		return gfs2_set_flags(filp, (u32 __user *)arg);
-	}
-	return -ENOTTY;
-}
-
-/**
- * gfs2_allocate_page_backing - Use bmap to allocate blocks
- * @page: The (locked) page to allocate backing for
- *
- * We try to allocate all the blocks required for the page in
- * one go. This might fail for various reasons, so we keep
- * trying until all the blocks to back this page are allocated.
- * If some of the blocks are already allocated, thats ok too.
- */
-
-static int gfs2_allocate_page_backing(struct page *page)
-{
-	struct inode *inode = page->mapping->host;
-	struct buffer_head bh;
-	unsigned long size = PAGE_CACHE_SIZE;
-	u64 lblock = page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
-
-	do {
-		bh.b_state = 0;
-		bh.b_size = size;
-		gfs2_block_map(inode, lblock, &bh, 1);
-		if (!buffer_mapped(&bh))
-			return -EIO;
-		size -= bh.b_size;
-		lblock += (bh.b_size >> inode->i_blkbits);
-	} while(size > 0);
-	return 0;
-}
-
-/**
- * gfs2_page_mkwrite - Make a shared, mmap()ed, page writable
- * @vma: The virtual memory area
- * @page: The page which is about to become writable
- *
- * When the page becomes writable, we need to ensure that we have
- * blocks allocated on disk to back that page.
- */
-
-static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
-{
-	struct page *page = vmf->page;
-	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	unsigned long last_index;
-	u64 pos = page->index << PAGE_CACHE_SHIFT;
-	unsigned int data_blocks, ind_blocks, rblocks;
-	int alloc_required = 0;
-	struct gfs2_holder gh;
-	struct gfs2_alloc *al;
-	int ret;
-
-	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
-	ret = gfs2_glock_nq(&gh);
-	if (ret)
-		goto out;
-
-	set_bit(GLF_DIRTY, &ip->i_gl->gl_flags);
-	set_bit(GIF_SW_PAGED, &ip->i_flags);
-
-	ret = gfs2_write_alloc_required(ip, pos, PAGE_CACHE_SIZE, &alloc_required);
-	if (ret || !alloc_required)
-		goto out_unlock;
-	ret = -ENOMEM;
-	al = gfs2_alloc_get(ip);
-	if (al == NULL)
-		goto out_unlock;
-
-	ret = gfs2_quota_lock_check(ip);
-	if (ret)
-		goto out_alloc_put;
-	gfs2_write_calc_reserv(ip, PAGE_CACHE_SIZE, &data_blocks, &ind_blocks);
-	al->al_requested = data_blocks + ind_blocks;
-	ret = gfs2_inplace_reserve(ip);
-	if (ret)
-		goto out_quota_unlock;
-
-	rblocks = RES_DINODE + ind_blocks;
-	if (gfs2_is_jdata(ip))
-		rblocks += data_blocks ? data_blocks : 1;
-	if (ind_blocks || data_blocks)
-		rblocks += RES_STATFS + RES_QUOTA;
-	ret = gfs2_trans_begin(sdp, rblocks, 0);
-	if (ret)
-		goto out_trans_fail;
-
-	lock_page(page);
-	ret = -EINVAL;
-	last_index = ip->i_inode.i_size >> PAGE_CACHE_SHIFT;
-	if (page->index > last_index)
-		goto out_unlock_page;
-	ret = 0;
-	if (!PageUptodate(page) || page->mapping != ip->i_inode.i_mapping)
-		goto out_unlock_page;
-	if (gfs2_is_stuffed(ip)) {
-		ret = gfs2_unstuff_dinode(ip, page);
-		if (ret)
-			goto out_unlock_page;
-	}
-	ret = gfs2_allocate_page_backing(page);
-
-out_unlock_page:
-	unlock_page(page);
-	gfs2_trans_end(sdp);
-out_trans_fail:
-	gfs2_inplace_release(ip);
-out_quota_unlock:
-	gfs2_quota_unlock(ip);
-out_alloc_put:
-	gfs2_alloc_put(ip);
-out_unlock:
-	gfs2_glock_dq(&gh);
-out:
-	gfs2_holder_uninit(&gh);
-	if (ret == -ENOMEM)
-		ret = VM_FAULT_OOM;
-	else if (ret)
-		ret = VM_FAULT_SIGBUS;
-	return ret;
-}
-
-static struct vm_operations_struct gfs2_vm_ops = {
-	.fault = filemap_fault,
-	.page_mkwrite = gfs2_page_mkwrite,
-};
-
-/**
- * gfs2_mmap -
- * @file: The file to map
- * @vma: The VMA which described the mapping
- *
- * There is no need to get a lock here unless we should be updating
- * atime. We ignore any locking errors since the only consequence is
- * a missed atime update (which will just be deferred until later).
- *
- * Returns: 0
- */
-
-static int gfs2_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct gfs2_inode *ip = GFS2_I(file->f_mapping->host);
-
-	if (!(file->f_flags & O_NOATIME)) {
-		struct gfs2_holder i_gh;
-		int error;
-
-		gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &i_gh);
-		error = gfs2_glock_nq(&i_gh);
-		file_accessed(file);
-		if (error == 0)
-			gfs2_glock_dq_uninit(&i_gh);
-	}
-	vma->vm_ops = &gfs2_vm_ops;
-	vma->vm_flags |= VM_CAN_NONLINEAR;
-
-	return 0;
-}
-
-/**
- * gfs2_open - open a file
- * @inode: the inode to open
- * @file: the struct file for this opening
- *
- * Returns: errno
- */
-
-static int gfs2_open(struct inode *inode, struct file *file)
-{
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_holder i_gh;
-	struct gfs2_file *fp;
-	int error;
-
-	fp = kzalloc(sizeof(struct gfs2_file), GFP_KERNEL);
-	if (!fp)
-		return -ENOMEM;
-
-	mutex_init(&fp->f_fl_mutex);
-
-	gfs2_assert_warn(GFS2_SB(inode), !file->private_data);
-	file->private_data = fp;
-
-	if (S_ISREG(ip->i_inode.i_mode)) {
-		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY,
-					   &i_gh);
-		if (error)
-			goto fail;
-
-		if (!(file->f_flags & O_LARGEFILE) &&
-		    ip->i_disksize > MAX_NON_LFS) {
-			error = -EOVERFLOW;
-			goto fail_gunlock;
-		}
-
-		gfs2_glock_dq_uninit(&i_gh);
-	}
-
-	return 0;
-
-fail_gunlock:
-	gfs2_glock_dq_uninit(&i_gh);
-fail:
-	file->private_data = NULL;
-	kfree(fp);
-	return error;
-}
-
-/**
- * gfs2_close - called to close a struct file
- * @inode: the inode the struct file belongs to
- * @file: the struct file being closed
- *
- * Returns: errno
- */
-
-static int gfs2_close(struct inode *inode, struct file *file)
-{
-	struct gfs2_sbd *sdp = inode->i_sb->s_fs_info;
-	struct gfs2_file *fp;
-
-	fp = file->private_data;
-	file->private_data = NULL;
-
-	if (gfs2_assert_warn(sdp, fp))
-		return -EIO;
-
-	kfree(fp);
-
-	return 0;
-}
-
-/**
- * gfs2_fsync - sync the dirty data for a file (across the cluster)
- * @file: the file that points to the dentry (we ignore this)
- * @dentry: the dentry that points to the inode to sync
- *
- * The VFS will flush "normal" data for us. We only need to worry
- * about metadata here. For journaled data, we just do a log flush
- * as we can't avoid it. Otherwise we can just bale out if datasync
- * is set. For stuffed inodes we must flush the log in order to
- * ensure that all data is on disk.
- *
- * The call to write_inode_now() is there to write back metadata and
- * the inode itself. It does also try and write the data, but thats
- * (hopefully) a no-op due to the VFS having already called filemap_fdatawrite()
- * for us.
- *
- * Returns: errno
- */
-
-static int gfs2_fsync(struct file *file, struct dentry *dentry, int datasync)
-{
-	struct inode *inode = dentry->d_inode;
-	int sync_state = inode->i_state & (I_DIRTY_SYNC|I_DIRTY_DATASYNC);
-	int ret = 0;
-
-	if (gfs2_is_jdata(GFS2_I(inode))) {
-		gfs2_log_flush(GFS2_SB(inode), GFS2_I(inode)->i_gl);
-		return 0;
-	}
-
-	if (sync_state != 0) {
-		if (!datasync)
-			ret = write_inode_now(inode, 0);
-
-		if (gfs2_is_stuffed(GFS2_I(inode)))
-			gfs2_log_flush(GFS2_SB(inode), GFS2_I(inode)->i_gl);
-	}
-
-	return ret;
-}
-
-#ifdef CONFIG_GFS2_FS_LOCKING_DLM
-
-/**
- * gfs2_setlease - acquire/release a file lease
- * @file: the file pointer
- * @arg: lease type
- * @fl: file lock
- *
- * We don't currently have a way to enforce a lease across the whole
- * cluster; until we do, disable leases (by just returning -EINVAL),
- * unless the administrator has requested purely local locking.
- *
- * Returns: errno
- */
-
-static int gfs2_setlease(struct file *file, long arg, struct file_lock **fl)
-{
-	return -EINVAL;
-}
-
-/**
- * gfs2_lock - acquire/release a posix lock on a file
- * @file: the file pointer
- * @cmd: either modify or retrieve lock state, possibly wait
- * @fl: type and range of lock
- *
- * Returns: errno
- */
-
-static int gfs2_lock(struct file *file, int cmd, struct file_lock *fl)
-{
-	struct gfs2_inode *ip = GFS2_I(file->f_mapping->host);
-	struct gfs2_sbd *sdp = GFS2_SB(file->f_mapping->host);
-	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
-
-	if (!(fl->fl_flags & FL_POSIX))
-		return -ENOLCK;
-	if (__mandatory_lock(&ip->i_inode))
-		return -ENOLCK;
-
-	if (cmd == F_CANCELLK) {
-		/* Hack: */
-		cmd = F_SETLK;
-		fl->fl_type = F_UNLCK;
-	}
-	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		return -EIO;
-	if (IS_GETLK(cmd))
-		return dlm_posix_get(ls->ls_dlm, ip->i_no_addr, file, fl);
-	else if (fl->fl_type == F_UNLCK)
-		return dlm_posix_unlock(ls->ls_dlm, ip->i_no_addr, file, fl);
-	else
-		return dlm_posix_lock(ls->ls_dlm, ip->i_no_addr, file, cmd, fl);
-}
-
-static int do_flock(struct file *file, int cmd, struct file_lock *fl)
-{
-	struct gfs2_file *fp = file->private_data;
-	struct gfs2_holder *fl_gh = &fp->f_fl_gh;
-	struct gfs2_inode *ip = GFS2_I(file->f_path.dentry->d_inode);
-	struct gfs2_glock *gl;
-	unsigned int state;
-	int flags;
-	int error = 0;
-
-	state = (fl->fl_type == F_WRLCK) ? LM_ST_EXCLUSIVE : LM_ST_SHARED;
-	flags = (IS_SETLKW(cmd) ? 0 : LM_FLAG_TRY) | GL_EXACT | GL_NOCACHE;
-
-	mutex_lock(&fp->f_fl_mutex);
-
-	gl = fl_gh->gh_gl;
-	if (gl) {
-		if (fl_gh->gh_state == state)
-			goto out;
-		flock_lock_file_wait(file,
-				     &(struct file_lock){.fl_type = F_UNLCK});
-		gfs2_glock_dq_wait(fl_gh);
-		gfs2_holder_reinit(state, flags, fl_gh);
-	} else {
-		error = gfs2_glock_get(GFS2_SB(&ip->i_inode), ip->i_no_addr,
-				       &gfs2_flock_glops, CREATE, &gl);
-		if (error)
-			goto out;
-		gfs2_holder_init(gl, state, flags, fl_gh);
-		gfs2_glock_put(gl);
-	}
-	error = gfs2_glock_nq(fl_gh);
-	if (error) {
-		gfs2_holder_uninit(fl_gh);
-		if (error == GLR_TRYFAILED)
-			error = -EAGAIN;
-	} else {
-		error = flock_lock_file_wait(file, fl);
-		gfs2_assert_warn(GFS2_SB(&ip->i_inode), !error);
-	}
-
-out:
-	mutex_unlock(&fp->f_fl_mutex);
-	return error;
-}
-
-static void do_unflock(struct file *file, struct file_lock *fl)
-{
-	struct gfs2_file *fp = file->private_data;
-	struct gfs2_holder *fl_gh = &fp->f_fl_gh;
-
-	mutex_lock(&fp->f_fl_mutex);
-	flock_lock_file_wait(file, fl);
-	if (fl_gh->gh_gl)
-		gfs2_glock_dq_uninit(fl_gh);
-	mutex_unlock(&fp->f_fl_mutex);
-}
-
-/**
- * gfs2_flock - acquire/release a flock lock on a file
- * @file: the file pointer
- * @cmd: either modify or retrieve lock state, possibly wait
- * @fl: type and range of lock
- *
- * Returns: errno
- */
-
-static int gfs2_flock(struct file *file, int cmd, struct file_lock *fl)
-{
-	struct gfs2_inode *ip = GFS2_I(file->f_mapping->host);
-
-	if (!(fl->fl_flags & FL_FLOCK))
-		return -ENOLCK;
-	if (__mandatory_lock(&ip->i_inode))
-		return -ENOLCK;
-
-	if (fl->fl_type == F_UNLCK) {
-		do_unflock(file, fl);
-		return 0;
-	} else {
-		return do_flock(file, cmd, fl);
-	}
-}
-
-const struct file_operations gfs2_file_fops = {
-	.llseek		= gfs2_llseek,
-	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
-	.write		= do_sync_write,
-	.aio_write	= generic_file_aio_write,
-	.unlocked_ioctl	= gfs2_ioctl,
-	.mmap		= gfs2_mmap,
-	.open		= gfs2_open,
-	.release	= gfs2_close,
-	.fsync		= gfs2_fsync,
-	.lock		= gfs2_lock,
-	.flock		= gfs2_flock,
-	.splice_read	= generic_file_splice_read,
-	.splice_write	= generic_file_splice_write,
-	.setlease	= gfs2_setlease,
-};
-
-const struct file_operations gfs2_dir_fops = {
-	.readdir	= gfs2_readdir,
-	.unlocked_ioctl	= gfs2_ioctl,
-	.open		= gfs2_open,
-	.release	= gfs2_close,
-	.fsync		= gfs2_fsync,
-	.lock		= gfs2_lock,
-	.flock		= gfs2_flock,
-};
-
-#endif /* CONFIG_GFS2_FS_LOCKING_DLM */
-
-const struct file_operations gfs2_file_fops_nolock = {
-	.llseek		= gfs2_llseek,
-	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
-	.write		= do_sync_write,
-	.aio_write	= generic_file_aio_write,
-	.unlocked_ioctl	= gfs2_ioctl,
-	.mmap		= gfs2_mmap,
-	.open		= gfs2_open,
-	.release	= gfs2_close,
-	.fsync		= gfs2_fsync,
-	.splice_read	= generic_file_splice_read,
-	.splice_write	= generic_file_splice_write,
-	.setlease	= generic_setlease,
-};
-
-const struct file_operations gfs2_dir_fops_nolock = {
-	.readdir	= gfs2_readdir,
-	.unlocked_ioctl	= gfs2_ioctl,
-	.open		= gfs2_open,
-	.release	= gfs2_close,
-	.fsync		= gfs2_fsync,
-};
-
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 152e6c4..2e9b932 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -60,7 +60,6 @@
 #include "super.h"
 #include "trans.h"
 #include "inode.h"
-#include "ops_address.h"
 #include "util.h"
 
 #define QUOTA_USER 1
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index ee3d5c1..6122c7e 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -29,7 +29,6 @@
 #include "util.h"
 #include "log.h"
 #include "inode.h"
-#include "ops_address.h"
 
 #define BFITNOENT ((u32)~0)
 #define NO_BLOCK ((u64)~0)
-- 
1.6.0.6


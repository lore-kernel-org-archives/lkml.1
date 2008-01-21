Return-Path: <linux-kernel-owner+w=401wt.eu-S1760847AbYAUKFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760847AbYAUKFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759452AbYAUKCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759264AbYAUKCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:05 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/58] [GFS2] Add writepages for GFS2 jdata
Date: Mon, 21 Jan 2008 09:21:27 +0000
Message-Id: <12009073571991-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1200907356883-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
Message-Id: <e00203790f1de31add36d27cb8f8323f8852bd4b.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch resolves a lock ordering issue where we had been getting
a transaction lock in the wrong order with respect to the page lock.
By using writepages rather than just writepage, it is then possible
to start a transaction before locking the page, and thus matching the
locking order elsewhere in the code.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 70b404d..1e1fe8d 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -650,7 +650,7 @@ static void gfs2_ordered_write(struct gfs2_sbd *sdp)
 		get_bh(bh);
 		gfs2_log_unlock(sdp);
 		lock_buffer(bh);
-		if (test_clear_buffer_dirty(bh)) {
+		if (buffer_mapped(bh) && test_clear_buffer_dirty(bh)) {
 			bh->b_end_io = end_buffer_write_sync;
 			submit_bh(WRITE, bh);
 		} else {
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 4bf73ed..48913e5 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -21,6 +21,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/lm_interface.h>
 #include <linux/swap.h>
+#include <linux/pagevec.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -189,6 +190,34 @@ static int gfs2_ordered_writepage(struct page *page,
 }
 
 /**
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
  * gfs2_jdata_writepage - Write complete page
  * @page: Page to write
  *
@@ -199,7 +228,6 @@ static int gfs2_ordered_writepage(struct page *page,
 static int gfs2_jdata_writepage(struct page *page, struct writeback_control *wbc)
 {
 	struct inode *inode = page->mapping->host;
-	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	int error;
 	int done_trans = 0;
@@ -209,18 +237,14 @@ static int gfs2_jdata_writepage(struct page *page, struct writeback_control *wbc
 		return error;
 
 	if (PageChecked(page)) {
+		if (wbc->sync_mode != WB_SYNC_ALL)
+			goto out_ignore;
 		error = gfs2_trans_begin(sdp, RES_DINODE + 1, 0);
 		if (error)
 			goto out_ignore;
-		ClearPageChecked(page);
-		if (!page_has_buffers(page)) {
-			create_empty_buffers(page, inode->i_sb->s_blocksize,
-					     (1 << BH_Dirty)|(1 << BH_Uptodate));
-		}
-		gfs2_page_add_databufs(ip, page, 0, sdp->sd_vfs->s_blocksize-1);
 		done_trans = 1;
 	}
-	error = block_write_full_page(page, gfs2_get_block_noalloc, wbc);
+	error = __gfs2_jdata_writepage(page, wbc);
 	if (done_trans)
 		gfs2_trans_end(sdp);
 	return error;
@@ -247,6 +271,178 @@ static int gfs2_writeback_writepages(struct address_space *mapping,
 }
 
 /**
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
+	ret = gfs2_trans_begin(sdp, nrblocks, 0);
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
  * stuffed_readpage - Fill in a Linux page with stuffed file data
  * @ip: the inode
  * @page: the page
@@ -937,6 +1133,7 @@ static const struct address_space_operations gfs2_ordered_aops = {
 
 static const struct address_space_operations gfs2_jdata_aops = {
 	.writepage = gfs2_jdata_writepage,
+	.writepages = gfs2_jdata_writepages,
 	.readpage = gfs2_readpage,
 	.readpages = gfs2_readpages,
 	.sync_page = block_sync_page,
-- 
1.5.1.2


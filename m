Return-Path: <linux-kernel-owner+w=401wt.eu-S1761750AbXH1TWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761750AbXH1TWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761462AbXH1TJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:09:03 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58358 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755919AbXH1THd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:33 -0400
Message-Id: <20070828190732.462534469@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:10 -0700
From: clameter@sgi.com
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [19/36] Use page_cache_xxx for fs/xfs
Content-Disposition: inline; filename=0019-Use-page_cache_xxx-for-fs-xfs.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use page_cache_xxx for fs/xfs

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |   55 ++++++++++++++++++++++--------------------
 fs/xfs/linux-2.6/xfs_lrw.c  |    6 ++--
 2 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index fd4105d..e48817a 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -74,7 +74,7 @@ xfs_page_trace(
 	xfs_inode_t	*ip;
 	bhv_vnode_t	*vp = vn_from_inode(inode);
 	loff_t		isize = i_size_read(inode);
-	loff_t		offset = page_offset(page);
+	loff_t		offset = page_cache_offset(page->mapping);
 	int		delalloc = -1, unmapped = -1, unwritten = -1;
 
 	if (page_has_buffers(page))
@@ -610,7 +610,7 @@ xfs_probe_page(
 					break;
 			} while ((bh = bh->b_this_page) != head);
 		} else
-			ret = mapped ? 0 : PAGE_CACHE_SIZE;
+			ret = mapped ? 0 : page_cache_size(page->mapping);
 	}
 
 	return ret;
@@ -637,7 +637,7 @@ xfs_probe_cluster(
 	} while ((bh = bh->b_this_page) != head);
 
 	/* if we reached the end of the page, sum forwards in following pages */
-	tlast = i_size_read(inode) >> PAGE_CACHE_SHIFT;
+	tlast = page_cache_index(inode->i_mapping, i_size_read(inode));
 	tindex = startpage->index + 1;
 
 	/* Prune this back to avoid pathological behavior */
@@ -655,14 +655,14 @@ xfs_probe_cluster(
 			size_t pg_offset, len = 0;
 
 			if (tindex == tlast) {
-				pg_offset =
-				    i_size_read(inode) & (PAGE_CACHE_SIZE - 1);
+				pg_offset = page_cache_offset(inode->i_mapping,
+							i_size_read(inode));
 				if (!pg_offset) {
 					done = 1;
 					break;
 				}
 			} else
-				pg_offset = PAGE_CACHE_SIZE;
+				pg_offset = page_cache_size(inode->i_mapping);
 
 			if (page->index == tindex && !TestSetPageLocked(page)) {
 				len = xfs_probe_page(page, pg_offset, mapped);
@@ -744,7 +744,8 @@ xfs_convert_page(
 	int			bbits = inode->i_blkbits;
 	int			len, page_dirty;
 	int			count = 0, done = 0, uptodate = 1;
- 	xfs_off_t		offset = page_offset(page);
+	struct address_space	*map = inode->i_mapping;
+	xfs_off_t		offset = page_cache_pos(map, page->index, 0);
 
 	if (page->index != tindex)
 		goto fail;
@@ -752,7 +753,7 @@ xfs_convert_page(
 		goto fail;
 	if (PageWriteback(page))
 		goto fail_unlock_page;
-	if (page->mapping != inode->i_mapping)
+	if (page->mapping != map)
 		goto fail_unlock_page;
 	if (!xfs_is_delayed_page(page, (*ioendp)->io_type))
 		goto fail_unlock_page;
@@ -764,20 +765,20 @@ xfs_convert_page(
 	 * Derivation:
 	 *
 	 * End offset is the highest offset that this page should represent.
-	 * If we are on the last page, (end_offset & (PAGE_CACHE_SIZE - 1))
-	 * will evaluate non-zero and be less than PAGE_CACHE_SIZE and
+	 * If we are on the last page, (end_offset & page_cache_mask())
+	 * will evaluate non-zero and be less than page_cache_size() and
 	 * hence give us the correct page_dirty count. On any other page,
 	 * it will be zero and in that case we need page_dirty to be the
 	 * count of buffers on the page.
 	 */
 	end_offset = min_t(unsigned long long,
-			(xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT,
+			(xfs_off_t)(page->index + 1) << page_cache_shift(map),
 			i_size_read(inode));
 
 	len = 1 << inode->i_blkbits;
-	p_offset = min_t(unsigned long, end_offset & (PAGE_CACHE_SIZE - 1),
-					PAGE_CACHE_SIZE);
-	p_offset = p_offset ? roundup(p_offset, len) : PAGE_CACHE_SIZE;
+	p_offset = min_t(unsigned long, page_cache_offset(map, end_offset),
+					page_cache_size(map));
+	p_offset = p_offset ? roundup(p_offset, len) : page_cache_size(map);
 	page_dirty = p_offset / len;
 
 	bh = head = page_buffers(page);
@@ -933,6 +934,8 @@ xfs_page_state_convert(
 	int			page_dirty, count = 0;
 	int			trylock = 0;
 	int			all_bh = unmapped;
+	struct address_space	*map = inode->i_mapping;
+	int			pagesize = page_cache_size(map);
 
 	if (startio) {
 		if (wbc->sync_mode == WB_SYNC_NONE && wbc->nonblocking)
@@ -941,11 +944,11 @@ xfs_page_state_convert(
 
 	/* Is this page beyond the end of the file? */
 	offset = i_size_read(inode);
-	end_index = offset >> PAGE_CACHE_SHIFT;
-	last_index = (offset - 1) >> PAGE_CACHE_SHIFT;
+	end_index = page_cache_index(map, offset);
+	last_index = page_cache_index(map, (offset - 1));
 	if (page->index >= end_index) {
 		if ((page->index >= end_index + 1) ||
-		    !(i_size_read(inode) & (PAGE_CACHE_SIZE - 1))) {
+		    !(page_cache_offset(map, i_size_read(inode)))) {
 			if (startio)
 				unlock_page(page);
 			return 0;
@@ -959,22 +962,22 @@ xfs_page_state_convert(
 	 * Derivation:
 	 *
 	 * End offset is the highest offset that this page should represent.
-	 * If we are on the last page, (end_offset & (PAGE_CACHE_SIZE - 1))
-	 * will evaluate non-zero and be less than PAGE_CACHE_SIZE and
-	 * hence give us the correct page_dirty count. On any other page,
+	 * If we are on the last page, (page_cache_offset(mapping, end_offset))
+	 * will evaluate non-zero and be less than page_cache_size(mapping)
+	 * and hence give us the correct page_dirty count. On any other page,
 	 * it will be zero and in that case we need page_dirty to be the
 	 * count of buffers on the page.
  	 */
 	end_offset = min_t(unsigned long long,
-			(xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT, offset);
+			(xfs_off_t)page_cache_pos(map, page->index + 1, 0), offset);
 	len = 1 << inode->i_blkbits;
-	p_offset = min_t(unsigned long, end_offset & (PAGE_CACHE_SIZE - 1),
-					PAGE_CACHE_SIZE);
-	p_offset = p_offset ? roundup(p_offset, len) : PAGE_CACHE_SIZE;
+	p_offset = min_t(unsigned long, page_cache_offset(map, end_offset),
+					pagesize);
+	p_offset = p_offset ? roundup(p_offset, len) : pagesize;
 	page_dirty = p_offset / len;
 
 	bh = head = page_buffers(page);
-	offset = page_offset(page);
+	offset = page_cache_pos(map, page->index, 0);
 	flags = BMAPI_READ;
 	type = IOMAP_NEW;
 
@@ -1122,7 +1125,7 @@ xfs_page_state_convert(
 
 	if (ioend && iomap_valid) {
 		offset = (iomap.iomap_offset + iomap.iomap_bsize - 1) >>
-					PAGE_CACHE_SHIFT;
+					page_cache_shift(map);
 		tlast = min_t(pgoff_t, offset, last_index);
 		xfs_cluster_write(inode, page->index + 1, &iomap, &ioend,
 					wbc, startio, all_bh, tlast);
diff --git a/fs/xfs/linux-2.6/xfs_lrw.c b/fs/xfs/linux-2.6/xfs_lrw.c
index 1614b81..d1f3130 100644
--- a/fs/xfs/linux-2.6/xfs_lrw.c
+++ b/fs/xfs/linux-2.6/xfs_lrw.c
@@ -143,9 +143,9 @@ xfs_iozero(
 	do {
 		unsigned long index, offset;
 
-		offset = (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
-		index = pos >> PAGE_CACHE_SHIFT;
-		bytes = PAGE_CACHE_SIZE - offset;
+		offset = page_cache_offset(mapping, pos); /* Within page */
+		index = page_cache_index(mapping, pos);
+		bytes = page_cache_size(mapping) - offset;
 		if (bytes > count)
 			bytes = count;
 
-- 
1.5.2.4

-- 

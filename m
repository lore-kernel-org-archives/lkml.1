Return-Path: <linux-kernel-owner+w=401wt.eu-S1030420AbXCJJar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030420AbXCJJar (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 04:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030428AbXCJJar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 04:30:47 -0500
Received: from mx1-2.mail.ru ([194.67.23.121]:8253 "EHLO mx1.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030420AbXCJJap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 04:30:45 -0500
Date: Sat, 10 Mar 2007 12:31:26 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/4]: ufs: prepare write + change blocks on the fly
Message-ID: <20070310093125.GA792@rain>
Mail-Followup-To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes "change blocks numbers on the fly"
in case when "prepare write page" is in the call chain,
in this case some buffers may be not uptodate and not mapped,
we should care to map them and load from disk.

This patch was tested with:
ufs regressions simple tests
fsx-linux
ltp(20060306)
untar and build kernel

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>

---

Index: linux-2.6.21-rc3-git6/fs/ufs/balloc.c
===================================================================
--- linux-2.6.21-rc3-git6.orig/fs/ufs/balloc.c
+++ linux-2.6.21-rc3-git6/fs/ufs/balloc.c
@@ -244,62 +244,87 @@ failed:
  * We can come here from ufs_writepage or ufs_prepare_write,
  * locked_page is argument of these functions, so we already lock it.
  */
-static void ufs_change_blocknr(struct inode *inode, unsigned int beg,
-			       unsigned int count, unsigned int oldb,
-			       unsigned int newb, struct page *locked_page)
+static void ufs_change_blocknr(struct inode *inode, sector_t beg,
+			       unsigned int count, sector_t oldb,
+			       sector_t newb, struct page *locked_page)
 {
-	const unsigned mask = (1 << (PAGE_CACHE_SHIFT - inode->i_blkbits)) - 1;
+	const unsigned blks_per_page =
+		1 << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	const unsigned mask = blks_per_page - 1;
 	struct address_space * const mapping = inode->i_mapping;
-	pgoff_t index, cur_index;
-	unsigned end, pos, j;
+	pgoff_t index, cur_index, last_index;
+	unsigned pos, j, lblock;
+	sector_t end, i;
 	struct page *page;
 	struct buffer_head *head, *bh;
 
-	UFSD("ENTER, ino %lu, count %u, oldb %u, newb %u\n",
-	      inode->i_ino, count, oldb, newb);
+	UFSD("ENTER, ino %lu, count %u, oldb %llu, newb %llu\n",
+	      inode->i_ino, count,
+	     (unsigned long long)oldb, (unsigned long long)newb);
 
 	BUG_ON(!locked_page);
 	BUG_ON(!PageLocked(locked_page));
 
 	cur_index = locked_page->index;
-
-	for (end = count + beg; beg < end; beg = (beg | mask) + 1) {
-		index = beg >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	end = count + beg;
+	last_index = end >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	for (i = beg; i < end; i = (i | mask) + 1) {
+		index = i >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
 
 		if (likely(cur_index != index)) {
 			page = ufs_get_locked_page(mapping, index);
-			if (!page || IS_ERR(page)) /* it was truncated or EIO */
+			if (!page)/* it was truncated */
+				continue;
+			if (IS_ERR(page)) {/* or EIO */
+				ufs_error(inode->i_sb, __FUNCTION__,
+					  "read of page %llu failed\n",
+					  (unsigned long long)index);
 				continue;
+			}
 		} else
 			page = locked_page;
 
 		head = page_buffers(page);
 		bh = head;
-		pos = beg & mask;
+		pos = i & mask;
 		for (j = 0; j < pos; ++j)
 			bh = bh->b_this_page;
-		j = 0;
+
+
+		if (unlikely(index == last_index))
+			lblock = end & mask;
+		else
+			lblock = blks_per_page;
+
 		do {
-			if (buffer_mapped(bh)) {
-				pos = bh->b_blocknr - oldb;
-				if (pos < count) {
-					UFSD(" change from %llu to %llu\n",
-					     (unsigned long long)pos + oldb,
-					     (unsigned long long)pos + newb);
-					bh->b_blocknr = newb + pos;
-					unmap_underlying_metadata(bh->b_bdev,
-								  bh->b_blocknr);
-					mark_buffer_dirty(bh);
-					++j;
+			if (j >= lblock)
+				break;
+			pos = (i - beg) + j;
+
+			if (!buffer_mapped(bh))
+					map_bh(bh, inode->i_sb, oldb + pos);
+			if (!buffer_uptodate(bh)) {
+				ll_rw_block(READ, 1, &bh);
+				wait_on_buffer(bh);
+				if (!buffer_uptodate(bh)) {
+					ufs_error(inode->i_sb, __FUNCTION__,
+						  "read of block failed\n");
+					break;
 				}
 			}
 
+			UFSD(" change from %llu to %llu, pos %u\n",
+			     (unsigned long long)pos + oldb,
+			     (unsigned long long)pos + newb, pos);
+
+			bh->b_blocknr = newb + pos;
+			unmap_underlying_metadata(bh->b_bdev,
+						  bh->b_blocknr);
+			mark_buffer_dirty(bh);
+			++j;
 			bh = bh->b_this_page;
 		} while (bh != head);
 
-		if (j)
-			set_page_dirty(page);
-
 		if (likely(cur_index != index))
 			ufs_put_locked_page(page);
  	}
-- 
/Evgeniy


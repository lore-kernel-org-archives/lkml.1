Return-Path: <linux-kernel-owner+w=401wt.eu-S1763583AbXH1TZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763583AbXH1TZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761402AbXH1TJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:09:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58697 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755010AbXH1THc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:32 -0400
Message-Id: <20070828190728.843866428@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:05:56 -0700
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
Subject: [05/36] Use page_cache_xxx in mm/truncate.c
Content-Disposition: inline; filename=0005-Use-page_cache_xxx-in-mm-truncate.c.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use page_cache_xxx in mm/truncate.c

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 mm/truncate.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index bf8068d..8c3d32e 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -45,9 +45,10 @@ void do_invalidatepage(struct page *page, unsigned long offset)
 		(*invalidatepage)(page, offset);
 }
 
-static inline void truncate_partial_page(struct page *page, unsigned partial)
+static inline void truncate_partial_page(struct address_space *mapping,
+			struct page *page, unsigned partial)
 {
-	zero_user_segment(page, partial, PAGE_CACHE_SIZE);
+	zero_user_segment(page, partial, page_cache_size(mapping));
 	if (PagePrivate(page))
 		do_invalidatepage(page, partial);
 }
@@ -95,7 +96,7 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
 	if (page->mapping != mapping)
 		return;
 
-	cancel_dirty_page(page, PAGE_CACHE_SIZE);
+	cancel_dirty_page(page, page_cache_size(mapping));
 
 	if (PagePrivate(page))
 		do_invalidatepage(page, 0);
@@ -157,9 +158,9 @@ invalidate_complete_page(struct address_space *mapping, struct page *page)
 void truncate_inode_pages_range(struct address_space *mapping,
 				loff_t lstart, loff_t lend)
 {
-	const pgoff_t start = (lstart + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
+	const pgoff_t start = page_cache_next(mapping, lstart);
 	pgoff_t end;
-	const unsigned partial = lstart & (PAGE_CACHE_SIZE - 1);
+	const unsigned partial = page_cache_offset(mapping, lstart);
 	struct pagevec pvec;
 	pgoff_t next;
 	int i;
@@ -167,8 +168,9 @@ void truncate_inode_pages_range(struct address_space *mapping,
 	if (mapping->nrpages == 0)
 		return;
 
-	BUG_ON((lend & (PAGE_CACHE_SIZE - 1)) != (PAGE_CACHE_SIZE - 1));
-	end = (lend >> PAGE_CACHE_SHIFT);
+	BUG_ON(page_cache_offset(mapping, lend) !=
+				page_cache_size(mapping) - 1);
+	end = page_cache_index(mapping, lend);
 
 	pagevec_init(&pvec, 0);
 	next = start;
@@ -194,8 +196,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
 			}
 			if (page_mapped(page)) {
 				unmap_mapping_range(mapping,
-				  (loff_t)page_index<<PAGE_CACHE_SHIFT,
-				  PAGE_CACHE_SIZE, 0);
+				  page_cache_pos(mapping, page_index, 0),
+				  page_cache_size(mapping), 0);
 			}
 			truncate_complete_page(mapping, page);
 			unlock_page(page);
@@ -208,7 +210,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
 		struct page *page = find_lock_page(mapping, start - 1);
 		if (page) {
 			wait_on_page_writeback(page);
-			truncate_partial_page(page, partial);
+			truncate_partial_page(mapping, page, partial);
 			unlock_page(page);
 			page_cache_release(page);
 		}
@@ -236,8 +238,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
 			wait_on_page_writeback(page);
 			if (page_mapped(page)) {
 				unmap_mapping_range(mapping,
-				  (loff_t)page->index<<PAGE_CACHE_SHIFT,
-				  PAGE_CACHE_SIZE, 0);
+				  page_cache_pos(mapping, page->index, 0),
+				  page_cache_size(mapping), 0);
 			}
 			if (page->index > next)
 				next = page->index;
@@ -421,9 +423,8 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 					 * Zap the rest of the file in one hit.
 					 */
 					unmap_mapping_range(mapping,
-					   (loff_t)page_index<<PAGE_CACHE_SHIFT,
-					   (loff_t)(end - page_index + 1)
-							<< PAGE_CACHE_SHIFT,
+					   page_cache_pos(mapping, page_index, 0),
+					   page_cache_pos(mapping, end - page_index + 1, 0),
 					    0);
 					did_range_unmap = 1;
 				} else {
@@ -431,8 +432,8 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 					 * Just zap this page
 					 */
 					unmap_mapping_range(mapping,
-					  (loff_t)page_index<<PAGE_CACHE_SHIFT,
-					  PAGE_CACHE_SIZE, 0);
+					  page_cache_pos(mapping, page_index, 0),
+					  page_cache_size(mapping), 0);
 				}
 			}
 			BUG_ON(page_mapped(page));
-- 
1.5.2.4

-- 

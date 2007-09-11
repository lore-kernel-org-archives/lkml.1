Return-Path: <linux-kernel-owner+w=401wt.eu-S1762846AbXIKGOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846AbXIKGOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762283AbXIKGFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:05:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50605 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761261AbXIKGEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:04:33 -0400
Message-Id: <20070911060432.546240009@sgi.com>
References: <20070911060349.993975297@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 23:04:20 -0700
From: Christoph Lameter <clameter@sgi.com>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com, hugh@veritas.com
Cc: joern@lazybastard.org
Subject: [30/41] Add VM_BUG_ONs to check for correct page order
Content-Disposition: inline; filename=0030-Add-VM_BUG_ONs-to-check-for-correct-page-order.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Before allowing different page orders it may be wise to get some checkpoints
in at various places. Checkpoints will help debugging whenever a wrong order
page shows up in a mapping. Helps when converting new filesystems to utilize
larger pages.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/buffer.c  |    1 +
 mm/filemap.c |   18 +++++++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 130ea0d..eaec65e 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -893,6 +893,7 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 	long offset;
 	unsigned int page_size = page_cache_size(page->mapping);
 
+	BUG_ON(size > page_size);
 try_again:
 	head = NULL;
 	offset = page_size;
diff --git a/mm/filemap.c b/mm/filemap.c
index bfe6eaa..3a0ae48 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -128,6 +128,7 @@ void remove_from_page_cache(struct page *page)
 	struct address_space *mapping = page->mapping;
 
 	BUG_ON(!PageLocked(page));
+	VM_BUG_ON(mapping_order(mapping) != page_cache_page_order(page));
 
 	write_lock_irq(&mapping->tree_lock);
 	__remove_from_page_cache(page);
@@ -269,6 +270,7 @@ int wait_on_page_writeback_range(struct address_space *mapping,
 			if (page->index > end)
 				continue;
 
+			VM_BUG_ON(mapping_order(mapping) != page_cache_page_order(page));
 			wait_on_page_writeback(page);
 			if (PageError(page))
 				ret = -EIO;
@@ -440,6 +442,7 @@ int add_to_page_cache(struct page *page, struct address_space *mapping,
 {
 	int error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
 
+	VM_BUG_ON(mapping_order(mapping) != page_cache_page_order(page));
 	if (error == 0) {
 		write_lock_irq(&mapping->tree_lock);
 		error = radix_tree_insert(&mapping->page_tree, offset, page);
@@ -599,8 +602,10 @@ struct page * find_get_page(struct address_space *mapping, unsigned long offset)
 
 	read_lock_irq(&mapping->tree_lock);
 	page = radix_tree_lookup(&mapping->page_tree, offset);
-	if (page)
+	if (page) {
+		VM_BUG_ON(mapping_order(mapping) != page_cache_page_order(page));
 		page_cache_get(page);
+	}
 	read_unlock_irq(&mapping->tree_lock);
 	return page;
 }
@@ -625,6 +630,7 @@ struct page *find_lock_page(struct address_space *mapping,
 repeat:
 	page = radix_tree_lookup(&mapping->page_tree, offset);
 	if (page) {
+		VM_BUG_ON(mapping_order(mapping) != page_cache_page_order(page));
 		page_cache_get(page);
 		if (TestSetPageLocked(page)) {
 			read_unlock_irq(&mapping->tree_lock);
@@ -715,8 +721,10 @@ unsigned find_get_pages(struct address_space *mapping, pgoff_t start,
 	read_lock_irq(&mapping->tree_lock);
 	ret = radix_tree_gang_lookup(&mapping->page_tree,
 				(void **)pages, start, nr_pages);
-	for (i = 0; i < ret; i++)
+	for (i = 0; i < ret; i++) {
+		VM_BUG_ON(mapping_order(mapping) != page_cache_page_order(pages[i]));
 		page_cache_get(pages[i]);
+	}
 	read_unlock_irq(&mapping->tree_lock);
 	return ret;
 }
@@ -746,6 +754,7 @@ unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t index,
 		if (pages[i]->mapping == NULL || pages[i]->index != index)
 			break;
 
+		VM_BUG_ON(mapping_order(mapping) != page_cache_page_order(pages[i]));
 		page_cache_get(pages[i]);
 		index++;
 	}
@@ -774,8 +783,10 @@ unsigned find_get_pages_tag(struct address_space *mapping, pgoff_t *index,
 	read_lock_irq(&mapping->tree_lock);
 	ret = radix_tree_gang_lookup_tag(&mapping->page_tree,
 				(void **)pages, *index, nr_pages, tag);
-	for (i = 0; i < ret; i++)
+	for (i = 0; i < ret; i++) {
+		VM_BUG_ON(mapping_order(mapping) != page_cache_page_order(pages[i]));
 		page_cache_get(pages[i]);
+	}
 	if (ret)
 		*index = pages[ret - 1]->index + 1;
 	read_unlock_irq(&mapping->tree_lock);
@@ -2233,6 +2244,7 @@ int try_to_release_page(struct page *page, gfp_t gfp_mask)
 	struct address_space * const mapping = page->mapping;
 
 	BUG_ON(!PageLocked(page));
+	VM_BUG_ON(mapping_order(mapping) != page_cache_page_order(page));
 	if (PageWriteback(page))
 		return 0;
 
-- 
1.5.2.5

-- 

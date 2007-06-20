Return-Path: <linux-kernel-owner+w=401wt.eu-S1762380AbXFTSkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762380AbXFTSkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759260AbXFTSbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:31:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54794 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757946AbXFTSaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:14 -0400
Message-Id: <20070620183012.989667961@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:37 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [30/37] Add VM_BUG_ONs to check for correct page order
Content-Disposition: inline; filename=vps_safety_checks
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Before we start allowing different page orders we better get checkpoints in
at various places in the VM. Checkpoints will help debugging whenever a
wrong order page shows up in a mapping. This will be helpful for converting
new filesystems to utilize larger pages.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/buffer.c  |    1 +
 mm/filemap.c |   18 +++++++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc4-mm2/mm/filemap.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/mm/filemap.c	2007-06-18 23:09:36.000000000 -0700
+++ linux-2.6.22-rc4-mm2/mm/filemap.c	2007-06-19 19:20:29.000000000 -0700
@@ -128,6 +128,7 @@ void remove_from_page_cache(struct page 
 	struct address_space *mapping = page->mapping;
 
 	BUG_ON(!PageLocked(page));
+	VM_BUG_ON(mapping_order(mapping) != compound_order(page));
 
 	write_lock_irq(&mapping->tree_lock);
 	__remove_from_page_cache(page);
@@ -269,6 +270,7 @@ int wait_on_page_writeback_range(struct 
 			if (page->index > end)
 				continue;
 
+			VM_BUG_ON(mapping_order(mapping) != compound_order(page));
 			wait_on_page_writeback(page);
 			if (PageError(page))
 				ret = -EIO;
@@ -441,6 +443,7 @@ int add_to_page_cache(struct page *page,
 {
 	int error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
 
+	VM_BUG_ON(mapping_order(mapping) != compound_order(page));
 	if (error == 0) {
 		write_lock_irq(&mapping->tree_lock);
 		error = radix_tree_insert(&mapping->page_tree, offset, page);
@@ -600,8 +603,10 @@ struct page * find_get_page(struct addre
 
 	read_lock_irq(&mapping->tree_lock);
 	page = radix_tree_lookup(&mapping->page_tree, offset);
-	if (page)
+	if (page) {
+		VM_BUG_ON(mapping_order(mapping) != compound_order(page));
 		page_cache_get(page);
+	}
 	read_unlock_irq(&mapping->tree_lock);
 	return page;
 }
@@ -626,6 +631,7 @@ struct page *find_lock_page(struct addre
 repeat:
 	page = radix_tree_lookup(&mapping->page_tree, offset);
 	if (page) {
+		VM_BUG_ON(mapping_order(mapping) != compound_order(page));
 		page_cache_get(page);
 		if (TestSetPageLocked(page)) {
 			read_unlock_irq(&mapping->tree_lock);
@@ -711,8 +717,10 @@ unsigned find_get_pages(struct address_s
 	read_lock_irq(&mapping->tree_lock);
 	ret = radix_tree_gang_lookup(&mapping->page_tree,
 				(void **)pages, start, nr_pages);
-	for (i = 0; i < ret; i++)
+	for (i = 0; i < ret; i++) {
+		VM_BUG_ON(mapping_order(mapping) != compound_order(pages[i]));
 		page_cache_get(pages[i]);
+	}
 	read_unlock_irq(&mapping->tree_lock);
 	return ret;
 }
@@ -743,6 +751,7 @@ unsigned find_get_pages_contig(struct ad
 		if (pages[i]->mapping == NULL || pages[i]->index != index)
 			break;
 
+		VM_BUG_ON(mapping_order(mapping) != compound_order(pages[i]));
 		page_cache_get(pages[i]);
 		index++;
 	}
@@ -771,8 +780,10 @@ unsigned find_get_pages_tag(struct addre
 	read_lock_irq(&mapping->tree_lock);
 	ret = radix_tree_gang_lookup_tag(&mapping->page_tree,
 				(void **)pages, *index, nr_pages, tag);
-	for (i = 0; i < ret; i++)
+	for (i = 0; i < ret; i++) {
+		VM_BUG_ON(mapping_order(mapping) != compound_order(pages[i]));
 		page_cache_get(pages[i]);
+	}
 	if (ret)
 		*index = pages[ret - 1]->index + 1;
 	read_unlock_irq(&mapping->tree_lock);
@@ -2610,6 +2621,7 @@ int try_to_release_page(struct page *pag
 	struct address_space * const mapping = page->mapping;
 
 	BUG_ON(!PageLocked(page));
+	VM_BUG_ON(mapping_order(mapping) != compound_order(page));
 	if (PageWriteback(page))
 		return 0;
 
Index: linux-2.6.22-rc4-mm2/fs/buffer.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/buffer.c	2007-06-19 19:20:29.000000000 -0700
+++ linux-2.6.22-rc4-mm2/fs/buffer.c	2007-06-19 19:24:12.000000000 -0700
@@ -901,6 +901,7 @@ struct buffer_head *alloc_page_buffers(s
 	long offset;
 	unsigned page_size = page_cache_size(page->mapping);
 
+	BUG_ON(size > page_size);
 try_again:
 	head = NULL;
 	offset = page_size;

-- 

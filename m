Return-Path: <linux-kernel-owner+w=401wt.eu-S1423176AbXDXW2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423176AbXDXW2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423183AbXDXW1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:27:20 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56820 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423177AbXDXWXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:23:08 -0400
Message-Id: <20070424222307.720364206@sgi.com>
References: <20070424222105.883597089@sgi.com>
User-Agent: quilt/0.45-1
Date: Tue, 24 Apr 2007 15:21:19 -0700
From: clameter@sgi.com
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [14/17] Add VM_BUG_ONs to check for correct page order
Content-Disposition: inline; filename=var_pc_guards
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Before we start changing the page order we better get some debugging
in there that trips us up whenever a wrong order page shows up in a
mapping. This will be helpful for converting new filesystems to
utilize higher orders.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/filemap.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

Index: linux-2.6.21-rc7/mm/filemap.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/filemap.c	2007-04-24 11:45:26.000000000 -0700
+++ linux-2.6.21-rc7/mm/filemap.c	2007-04-24 11:46:04.000000000 -0700
@@ -127,6 +127,7 @@ void remove_from_page_cache(struct page 
 	struct address_space *mapping = page->mapping;
 
 	BUG_ON(!PageLocked(page));
+	VM_BUG_ON(mapping_order(mapping) != compound_order(page));
 
 	write_lock_irq(&mapping->tree_lock);
 	__remove_from_page_cache(page);
@@ -268,6 +269,7 @@ int wait_on_page_writeback_range(struct 
 			if (page->index > end)
 				continue;
 
+			VM_BUG_ON(mapping_order(mapping) != compound_order(page));
 			wait_on_page_writeback(page);
 			if (PageError(page))
 				ret = -EIO;
@@ -439,6 +441,7 @@ int add_to_page_cache(struct page *page,
 {
 	int error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
 
+	VM_BUG_ON(mapping_order(mapping) != compound_order(page));
 	if (error == 0) {
 		write_lock_irq(&mapping->tree_lock);
 		error = radix_tree_insert(&mapping->page_tree, offset, page);
@@ -598,8 +601,10 @@ struct page * find_get_page(struct addre
 
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
@@ -624,6 +629,7 @@ struct page *find_lock_page(struct addre
 repeat:
 	page = radix_tree_lookup(&mapping->page_tree, offset);
 	if (page) {
+		VM_BUG_ON(mapping_order(mapping) != compound_order(page));
 		page_cache_get(page);
 		if (TestSetPageLocked(page)) {
 			read_unlock_irq(&mapping->tree_lock);
@@ -685,6 +691,7 @@ repeat:
 		} else if (err == -EEXIST)
 			goto repeat;
 	}
+	VM_BUG_ON(mapping_order(mapping) != compound_order(page));
 	if (cached_page)
 		page_cache_release(cached_page);
 	return page;
@@ -716,8 +723,10 @@ unsigned find_get_pages(struct address_s
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
@@ -747,6 +756,7 @@ unsigned find_get_pages_contig(struct ad
 		if (pages[i]->mapping == NULL || pages[i]->index != index)
 			break;
 
+		VM_BUG_ON(mapping_order(mapping) != compound_order(pages[i]));
 		page_cache_get(pages[i]);
 		index++;
 	}
@@ -774,8 +784,10 @@ unsigned find_get_pages_tag(struct addre
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
@@ -2457,6 +2469,7 @@ int try_to_release_page(struct page *pag
 	struct address_space * const mapping = page->mapping;
 
 	BUG_ON(!PageLocked(page));
+	VM_BUG_ON(mapping_order(mapping) != compound_order(page));
 	if (PageWriteback(page))
 		return 0;
 

--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762296AbXH1TQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762296AbXH1TQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761318AbXH1TIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:08:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58841 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759816AbXH1THl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:41 -0400
Message-Id: <20070828190735.076092591@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:21 -0700
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
Subject: [30/36] Add VM_BUG_ONs to check for correct page order
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

Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c	2007-08-27 20:52:34.000000000 -0700
+++ linux-2.6/fs/buffer.c	2007-08-27 21:09:19.000000000 -0700
@@ -893,6 +893,7 @@ struct buffer_head *alloc_page_buffers(s
 	long offset;
 	unsigned int page_size = page_cache_size(page->mapping);
 
+	BUG_ON(size > page_size);
 try_again:
 	head = NULL;
 	offset = page_size;
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2007-08-27 21:08:04.000000000 -0700
+++ linux-2.6/mm/filemap.c	2007-08-27 21:09:19.000000000 -0700
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
@@ -440,6 +442,7 @@ int add_to_page_cache(struct page *page,
 {
 	int error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
 
+	VM_BUG_ON(mapping_order(mapping) != compound_order(page));
 	if (error == 0) {
 		write_lock_irq(&mapping->tree_lock);
 		error = radix_tree_insert(&mapping->page_tree, offset, page);
@@ -599,8 +602,10 @@ struct page * find_get_page(struct addre
 
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
@@ -625,6 +630,7 @@ struct page *find_lock_page(struct addre
 repeat:
 	page = radix_tree_lookup(&mapping->page_tree, offset);
 	if (page) {
+		VM_BUG_ON(mapping_order(mapping) != compound_order(page));
 		page_cache_get(page);
 		if (TestSetPageLocked(page)) {
 			read_unlock_irq(&mapping->tree_lock);
@@ -715,8 +721,10 @@ unsigned find_get_pages(struct address_s
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
@@ -746,6 +754,7 @@ unsigned find_get_pages_contig(struct ad
 		if (pages[i]->mapping == NULL || pages[i]->index != index)
 			break;
 
+		VM_BUG_ON(mapping_order(mapping) != compound_order(pages[i]));
 		page_cache_get(pages[i]);
 		index++;
 	}
@@ -774,8 +783,10 @@ unsigned find_get_pages_tag(struct addre
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
@@ -2233,6 +2244,7 @@ int try_to_release_page(struct page *pag
 	struct address_space * const mapping = page->mapping;
 
 	BUG_ON(!PageLocked(page));
+	VM_BUG_ON(mapping_order(mapping) != compound_order(page));
 	if (PageWriteback(page))
 		return 0;
 

-- 

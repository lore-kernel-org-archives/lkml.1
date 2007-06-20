Return-Path: <linux-kernel-owner+w=401wt.eu-S1763124AbXFTSoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763124AbXFTSoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254AbXFTSb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:31:58 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46752 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756300AbXFTSaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:10 -0400
Message-Id: <20070620183007.142889423@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:13 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [06/37] Use page_cache_xxx in mm/rmap.c
Content-Disposition: inline; filename=vps_mm_rmap
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/rmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.22-rc4-mm2/mm/rmap.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/mm/rmap.c	2007-06-14 10:35:45.000000000 -0700
+++ linux-2.6.22-rc4-mm2/mm/rmap.c	2007-06-14 10:49:29.000000000 -0700
@@ -210,9 +210,14 @@
 static inline unsigned long
 vma_address(struct page *page, struct vm_area_struct *vma)
 {
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff_t pgoff;
 	unsigned long address;
 
+	if (PageAnon(page))
+		pgoff = page->index;
+	else
+		pgoff = page->index << mapping_order(page->mapping);
+
 	address = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
 	if (unlikely(address < vma->vm_start || address >= vma->vm_end)) {
 		/* page should be within any vma from prio_tree_next */
@@ -357,7 +362,7 @@
 {
 	unsigned int mapcount;
 	struct address_space *mapping = page->mapping;
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff_t pgoff = page->index << (page_cache_shift(mapping) - PAGE_SHIFT);
 	struct vm_area_struct *vma;
 	struct prio_tree_iter iter;
 	int referenced = 0;
@@ -469,7 +474,7 @@
 
 static int page_mkclean_file(struct address_space *mapping, struct page *page)
 {
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff_t pgoff = page->index << (page_cache_shift(mapping) - PAGE_SHIFT);
 	struct vm_area_struct *vma;
 	struct prio_tree_iter iter;
 	int ret = 0;
@@ -885,7 +890,7 @@
 static int try_to_unmap_file(struct page *page, int migration)
 {
 	struct address_space *mapping = page->mapping;
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff_t pgoff = page->index << (page_cache_shift(mapping) - PAGE_SHIFT);
 	struct vm_area_struct *vma;
 	struct prio_tree_iter iter;
 	int ret = SWAP_AGAIN;

-- 

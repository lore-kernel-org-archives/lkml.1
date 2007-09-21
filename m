Return-Path: <linux-kernel-owner+w=401wt.eu-S1765890AbXIUVBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765890AbXIUVBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763953AbXIUUrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:47:32 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:35052 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764019AbXIUUrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:47:31 -0400
Date: Fri, 21 Sep 2007 21:47:19 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] LBS: fix crashes in vma_address
In-Reply-To: <Pine.LNX.4.64.0709212141220.6532@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0709212146440.13529@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0709212141220.6532@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vma_address oopsed on mapping_order(page->mapping): because page may now
be a tail page in which page->mapping is NULL.  There's (too!) many ways
to do this, I went for page_cache_page_order(page_cache_head(page)) so
we can also avoid the PageAnon test.   Indeed, use page_cache_page_order
throughout, to simplify those "page_cache_shift(mapping) - PAGE_SHIFT"s.

vma_address bugged on !PageAnon because loops over page_cache_base_pages
may try a component file page outside the range of the vma: just delete
that BUG_ON now it no longer applies.

Signed-off-by: Hugh Dickins <hugh@veritas.com>

--- 2.6.23-rc6-lbs/mm/rmap.c	2007-09-11 20:01:08.000000000 +0100
+++ linux/mm/rmap.c	2007-09-13 21:22:33.000000000 +0100
@@ -191,17 +191,10 @@ vma_address(struct page *page, struct vm
 	pgoff_t pgoff;
 	unsigned long address;
 
-	if (PageAnon(page))
-		pgoff = page->index;
-	else
-		pgoff = page->index << mapping_order(page->mapping);
-
+	pgoff = page->index << page_cache_page_order(page_cache_head(page));
 	address = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
-	if (unlikely(address < vma->vm_start || address >= vma->vm_end)) {
-		/* page should be within any vma from prio_tree_next */
-		BUG_ON(!PageAnon(page));
+	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
 		return -EFAULT;
-	}
 	return address;
 }
 
@@ -352,7 +345,7 @@ static int page_referenced_file(struct p
 {
 	unsigned int mapcount;
 	struct address_space *mapping = page->mapping;
-	pgoff_t pgoff = page->index << (page_cache_shift(mapping) - PAGE_SHIFT);
+	pgoff_t pgoff = page->index << page_cache_page_order(page);
 	struct vm_area_struct *vma;
 	struct prio_tree_iter iter;
 	int referenced = 0;
@@ -475,7 +468,7 @@ static int page_mkclean_one(struct page 
 
 static int page_mkclean_file(struct address_space *mapping, struct page *page)
 {
-	pgoff_t pgoff = page->index << (page_cache_shift(mapping) - PAGE_SHIFT);
+	pgoff_t pgoff = page->index << page_cache_page_order(page);
 	struct vm_area_struct *vma;
 	struct prio_tree_iter iter;
 	int ret = 0;
@@ -907,7 +900,7 @@ static int try_to_unmap_anon(struct page
 static int try_to_unmap_file(struct page *page, int migration)
 {
 	struct address_space *mapping = page->mapping;
-	pgoff_t pgoff = page->index << (page_cache_shift(mapping) - PAGE_SHIFT);
+	pgoff_t pgoff = page->index << page_cache_page_order(page);
 	struct vm_area_struct *vma;
 	struct prio_tree_iter iter;
 	int ret = SWAP_AGAIN;

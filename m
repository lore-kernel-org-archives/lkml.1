Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbYLAApg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbYLAApg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 19:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbYLAAp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 19:45:29 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:50045 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbYLAAp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 19:45:28 -0500
Date: Mon, 1 Dec 2008 00:45:45 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Dave Jones <davej@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 6/8] badpage: remove vma from page_remove_rmap
In-Reply-To: <Pine.LNX.4.64.0812010032210.10131@blonde.site>
Message-ID: <Pine.LNX.4.64.0812010044580.11401@blonde.site>
References: <Pine.LNX.4.64.0812010032210.10131@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove page_remove_rmap()'s vma arg, which was only for the Eeek message.
And remove the BUG_ON(page_mapcount(page) == 0) from CONFIG_DEBUG_VM's
page_dup_rmap(): we're trying to be more resilient about that than BUGs.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 include/linux/rmap.h |    2 +-
 mm/filemap_xip.c     |    2 +-
 mm/fremap.c          |    2 +-
 mm/memory.c          |    4 ++--
 mm/rmap.c            |    8 +++-----
 5 files changed, 8 insertions(+), 10 deletions(-)

--- badpage5/include/linux/rmap.h	2008-11-26 12:18:59.000000000 +0000
+++ badpage6/include/linux/rmap.h	2008-11-28 20:40:48.000000000 +0000
@@ -69,7 +69,7 @@ void __anon_vma_link(struct vm_area_stru
 void page_add_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
 void page_add_new_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
 void page_add_file_rmap(struct page *);
-void page_remove_rmap(struct page *, struct vm_area_struct *);
+void page_remove_rmap(struct page *);
 
 #ifdef CONFIG_DEBUG_VM
 void page_dup_rmap(struct page *page, struct vm_area_struct *vma, unsigned long address);
--- badpage5/mm/filemap_xip.c	2008-10-09 23:13:53.000000000 +0100
+++ badpage6/mm/filemap_xip.c	2008-11-28 20:40:48.000000000 +0000
@@ -193,7 +193,7 @@ retry:
 			/* Nuke the page table entry. */
 			flush_cache_page(vma, address, pte_pfn(*pte));
 			pteval = ptep_clear_flush_notify(vma, address, pte);
-			page_remove_rmap(page, vma);
+			page_remove_rmap(page);
 			dec_mm_counter(mm, file_rss);
 			BUG_ON(pte_dirty(pteval));
 			pte_unmap_unlock(pte, ptl);
--- badpage5/mm/fremap.c	2008-10-24 09:28:26.000000000 +0100
+++ badpage6/mm/fremap.c	2008-11-28 20:40:48.000000000 +0000
@@ -37,7 +37,7 @@ static void zap_pte(struct mm_struct *mm
 		if (page) {
 			if (pte_dirty(pte))
 				set_page_dirty(page);
-			page_remove_rmap(page, vma);
+			page_remove_rmap(page);
 			page_cache_release(page);
 			update_hiwater_rss(mm);
 			dec_mm_counter(mm, file_rss);
--- badpage5/mm/memory.c	2008-11-28 20:40:46.000000000 +0000
+++ badpage6/mm/memory.c	2008-11-28 20:40:48.000000000 +0000
@@ -788,7 +788,7 @@ static unsigned long zap_pte_range(struc
 					mark_page_accessed(page);
 				file_rss--;
 			}
-			page_remove_rmap(page, vma);
+			page_remove_rmap(page);
 			if (unlikely(page_mapcount(page) < 0))
 				print_bad_pte(vma, addr, ptent, page);
 			tlb_remove_page(tlb, page);
@@ -1996,7 +1996,7 @@ gotten:
 			 * mapcount is visible. So transitively, TLBs to
 			 * old page will be flushed before it can be reused.
 			 */
-			page_remove_rmap(old_page, vma);
+			page_remove_rmap(old_page);
 		}
 
 		/* Free the old page.. */
--- badpage5/mm/rmap.c	2008-11-28 20:40:40.000000000 +0000
+++ badpage6/mm/rmap.c	2008-11-28 20:40:48.000000000 +0000
@@ -707,7 +707,6 @@ void page_add_file_rmap(struct page *pag
  */
 void page_dup_rmap(struct page *page, struct vm_area_struct *vma, unsigned long address)
 {
-	BUG_ON(page_mapcount(page) == 0);
 	if (PageAnon(page))
 		__page_check_anon_rmap(page, vma, address);
 	atomic_inc(&page->_mapcount);
@@ -717,11 +716,10 @@ void page_dup_rmap(struct page *page, st
 /**
  * page_remove_rmap - take down pte mapping from a page
  * @page: page to remove mapping from
- * @vma: the vm area in which the mapping is removed
  *
  * The caller needs to hold the pte lock.
  */
-void page_remove_rmap(struct page *page, struct vm_area_struct *vma)
+void page_remove_rmap(struct page *page)
 {
 	if (atomic_add_negative(-1, &page->_mapcount)) {
 		/*
@@ -837,7 +835,7 @@ static int try_to_unmap_one(struct page 
 		dec_mm_counter(mm, file_rss);
 
 
-	page_remove_rmap(page, vma);
+	page_remove_rmap(page);
 	page_cache_release(page);
 
 out_unmap:
@@ -952,7 +950,7 @@ static int try_to_unmap_cluster(unsigned
 		if (pte_dirty(pteval))
 			set_page_dirty(page);
 
-		page_remove_rmap(page, vma);
+		page_remove_rmap(page);
 		page_cache_release(page);
 		dec_mm_counter(mm, file_rss);
 		(*mapcount)--;

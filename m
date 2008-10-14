Return-Path: <linux-kernel-owner+w=401wt.eu-S1761098AbYJNAdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761098AbYJNAdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 20:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYJNAcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 20:32:51 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:55734 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbYJNAcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 20:32:50 -0400
Date: Tue, 14 Oct 2008 01:32:18 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: [METAPATCH] mmotm: fix split-lru bisectability
Message-ID: <Pine.LNX.4.64.0810140125550.29541@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's an unbisectable 24-patch extent in the mmotm series, from
define-page_file_cache-function to mlock-mlocked-pages-are-unevictable-fix:
unbisectable because startup gets swamped by "Bad page state" messages
(with three unrelated build errors and their fixes along the way).

These bad page states come from when Linus fasttracked the PAGE_FLAGS
"cleanup" into 2.6.26, conflicting with PG_swapbacked patches already
queued in -mm, and then the merge was botched.  We fixed up the end
result at the time, but never got around to fixing the intermediates.
It would be regrettable if this unbisectability were preserved in git.

To apply this metapatch, cd into mmotm's broken-out or patches directory
(before define-page_file_cache-function has been applied), move series
file there if it's kept elsewhere, apply metapatch with "patch -p1" (one
file is deleted from series), then move back series file if necessary.

Based on mmotm .DATE=2008-10-10-19-22.  Doesn't bother to update the
diffstats: I've tried to keep the diffs minimal, without all the noise
which a quilt refresh here would have added.  So oddly I'm commenting
out NORECL_PGRESCUED and NORECL_PGCULLED in one patch, then removing
those lines in their fix patch - hmm, shouldn't they have got defined
eventually, and that code restored?  End result is the same as mmotm,
except that KOSAKI-San's page_referenced() args fix is included.

I'm pleased to say that checkpatch.pl reports that this metapatch
has no obvious style problems and is ready for submission :-)

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 series                                                       |    1 
 define-page_file_cache-function.patch                        |   26 +++++--
 vmscan-fix-pagecache-reclaim-referenced-bit-check-fix.patch  |    5 -
 unevictable-lru-infrastructure.patch                         |   12 +--
 unevictable-lru-infrastructure-defer-vm-event-counting.patch |    4 -
 mlock-mlocked-pages-are-unevictable.patch                    |   24 -------
 mlock-mlocked-pages-are-unevictable-fix.patch                |   33 ----------
 7 files changed, 32 insertions(+), 73 deletions(-)

--- a/series
+++ b/series
@@ -875,7 +875,6 @@ ramfs-and-ram-disk-pages-are-unevictable
 shm_locked-pages-are-unevictable.patch
 shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch
 mlock-mlocked-pages-are-unevictable.patch
-mlock-mlocked-pages-are-unevictable-fix.patch
 doc-unevictable-lru-and-mlocked-pages-documentation.patch
 doc-unevictable-lru-and-mlocked-pages-documentation-update.patch
 doc-unevictable-lru-and-mlocked-pages-documentation-update-2.patch
--- a/define-page_file_cache-function.patch
+++ b/define-page_file_cache-function.patch
@@ -92,16 +92,26 @@ diff -puN include/linux/page-flags.h~def
  
  __PAGEFLAG(SlobPage, slob_page)
  __PAGEFLAG(SlobFree, slob_free)
-@@ -330,7 +332,8 @@ static inline void __ClearPageTail(struc
- 
- #define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
- 			 1 << PG_buddy | 1 << PG_writeback | \
--			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active)
-+			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active | \
-+			 1 << PG_swapbacked)
+@@ -334,7 +336,8 @@ static inline void __ClearPageTail(struc
+  * Flags checked in bad_page().  Pages on the free list should not have
+  * these flags set.  It they are, there is a problem.
+  */
+-#define PAGE_FLAGS_CLEAR_WHEN_BAD (PAGE_FLAGS | 1 << PG_reclaim | 1 << PG_dirty)
++#define PAGE_FLAGS_CLEAR_WHEN_BAD (PAGE_FLAGS | \
++		1 << PG_reclaim | 1 << PG_dirty | 1 << PG_swapbacked)
  
  /*
-  * Flags checked in bad_page().  Pages on the free list should not have
+  * Flags checked when a page is freed.  Pages being freed should not have
+@@ -347,7 +350,8 @@ static inline void __ClearPageTail(struc
+  * Pages being prepped should not have these flags set.  It they are, there
+  * is a problem.
+  */
+-#define PAGE_FLAGS_CHECK_AT_PREP (PAGE_FLAGS | 1 << PG_reserved | 1 << PG_dirty)
++#define PAGE_FLAGS_CHECK_AT_PREP (PAGE_FLAGS | \
++		1 << PG_reserved | 1 << PG_dirty | 1 << PG_swapbacked)
+ 
+ #endif /* !__GENERATING_BOUNDS_H */
+ #endif	/* PAGE_FLAGS_H */
 diff -puN mm/memory.c~define-page_file_cache-function mm/memory.c
 --- a/mm/memory.c~define-page_file_cache-function
 +++ a/mm/memory.c
--- a/vmscan-fix-pagecache-reclaim-referenced-bit-check-fix.patch
+++ b/vmscan-fix-pagecache-reclaim-referenced-bit-check-fix.patch
@@ -10,13 +10,14 @@ Signed-off-by: Andrew Morton <akpm@linux
 diff -puN mm/vmscan.c~vmscan-fix-pagecache-reclaim-referenced-bit-check-fix mm/vmscan.c
 --- a/mm/vmscan.c~vmscan-fix-pagecache-reclaim-referenced-bit-check-fix
 +++ a/mm/vmscan.c
-@@ -1095,14 +1095,12 @@ static void shrink_active_list(unsigned 
+@@ -1095,14 +1095,13 @@ static void shrink_active_list(unsigned 
  		cond_resched();
  		page = lru_to_page(&l_hold);
  		list_del(&page->lru);
 +
 +		/* page_referenced clears PageReferenced */
-+		if (page_mapping_inuse(page) && page_referenced(page))
++		if (page_mapping_inuse(page) &&
++		    page_referenced(page, 0, sc->mem_cgroup))
 +			pgmoved++;
 +
  		list_add(&page->lru, &l_inactive);
--- a/unevictable-lru-infrastructure.patch
+++ b/unevictable-lru-infrastructure.patch
@@ -210,7 +210,7 @@ diff -puN include/linux/page-flags.h~une
  #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
  PAGEFLAG(Uncached, uncached)
  #else
-@@ -340,10 +353,16 @@ static inline void __ClearPageTail(struc
+@@ -340,9 +353,16 @@ static inline void __ClearPageTail(struc
  
  #endif /* !PAGEFLAGS_EXTENDED */
  
@@ -222,9 +222,9 @@ diff -puN include/linux/page-flags.h~une
 +
  #define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
  			 1 << PG_buddy | 1 << PG_writeback | \
- 			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active | \
--			 1 << PG_swapbacked)
-+			 1 << PG_swapbacked | __PG_UNEVICTABLE)
+-			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active)
++			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active | \
++			 __PG_UNEVICTABLE)
  
  /*
   * Flags checked in bad_page().  Pages on the free list should not have
@@ -755,10 +755,10 @@ diff -puN mm/vmscan.c~unevictable-lru-in
 +		 */
 +	}
 +
-+	if (was_unevictable && lru != LRU_UNEVICTABLE)
++ /*	if (was_unevictable && lru != LRU_UNEVICTABLE)
 +		count_vm_event(NORECL_PGRESCUED);
 +	else if (!was_unevictable && lru == LRU_UNEVICTABLE)
-+		count_vm_event(NORECL_PGCULLED);
++		count_vm_event(NORECL_PGCULLED);	*/
 +
 +	put_page(page);		/* drop ref from isolate */
 +}
--- a/unevictable-lru-infrastructure-defer-vm-event-counting.patch
+++ b/unevictable-lru-infrastructure-defer-vm-event-counting.patch
@@ -31,10 +31,10 @@ diff -puN mm/vmscan.c~unevictable-lru-in
  		 */
  	}
  
--	if (was_unevictable && lru != LRU_UNEVICTABLE)
+- /*	if (was_unevictable && lru != LRU_UNEVICTABLE)
 -		count_vm_event(NORECL_PGRESCUED);
 -	else if (!was_unevictable && lru == LRU_UNEVICTABLE)
--		count_vm_event(NORECL_PGCULLED);
+-		count_vm_event(NORECL_PGCULLED);	*/
 -
  	put_page(page);		/* drop ref from isolate */
  }
--- a/mlock-mlocked-pages-are-unevictable.patch
+++ b/mlock-mlocked-pages-are-unevictable.patch
@@ -126,7 +126,7 @@ diff -puN include/linux/page-flags.h~mlo
  PAGEFLAG_FALSE(Unevictable) TESTCLEARFLAG_FALSE(Unevictable)
  	SETPAGEFLAG_NOOP(Unevictable) CLEARPAGEFLAG_NOOP(Unevictable)
  	__CLEARPAGEFLAG_NOOP(Unevictable)
-@@ -356,21 +367,24 @@ static inline void __ClearPageTail(struc
+@@ -354,15 +365,17 @@ static inline void __ClearPageTail(struc
  #endif /* !PAGEFLAGS_EXTENDED */
  
  #ifdef CONFIG_UNEVICTABLE_LRU
@@ -142,29 +142,11 @@ diff -puN include/linux/page-flags.h~mlo
  #define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
  			 1 << PG_buddy | 1 << PG_writeback | \
  			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active | \
--			 1 << PG_swapbacked | __PG_UNEVICTABLE)
+-			 __PG_UNEVICTABLE)
 +			 __PG_UNEVICTABLE | __PG_MLOCKED)
  
  /*
   * Flags checked in bad_page().  Pages on the free list should not have
-  * these flags set.  It they are, there is a problem.
-  */
--#define PAGE_FLAGS_CLEAR_WHEN_BAD (PAGE_FLAGS | 1 << PG_reclaim | 1 << PG_dirty)
-+#define PAGE_FLAGS_CLEAR_WHEN_BAD (PAGE_FLAGS | \
-+		1 << PG_reclaim | 1 << PG_dirty | 1 << PG_swapbacked)
- 
- /*
-  * Flags checked when a page is freed.  Pages being freed should not have
-@@ -383,7 +397,8 @@ static inline void __ClearPageTail(struc
-  * Pages being prepped should not have these flags set.  It they are, there
-  * is a problem.
-  */
--#define PAGE_FLAGS_CHECK_AT_PREP (PAGE_FLAGS | 1 << PG_reserved | 1 << PG_dirty)
-+#define PAGE_FLAGS_CHECK_AT_PREP (PAGE_FLAGS | \
-+		1 << PG_reserved | 1 << PG_dirty | 1 << PG_swapbacked)
- 
- #endif /* !__GENERATING_BOUNDS_H */
- #endif	/* PAGE_FLAGS_H */
 diff -puN include/linux/rmap.h~mlock-mlocked-pages-are-unevictable include/linux/rmap.h
 --- a/include/linux/rmap.h~mlock-mlocked-pages-are-unevictable
 +++ a/include/linux/rmap.h
@@ -920,7 +902,7 @@ diff -puN mm/rmap.c~mlock-mlocked-pages-
 +	address = vma_address(page, vma);
 +	if (address == -EFAULT)		/* out of vma range */
 +		return 0;
-+	pte = page_check_address(page, vma->vm_mm, address, &ptl);
++	pte = page_check_address(page, vma->vm_mm, address, &ptl, 1);
 +	if (!pte)			/* the page is not in this mm */
 +		return 0;
 +	pte_unmap_unlock(pte, ptl);
--- a/mlock-mlocked-pages-are-unevictable-fix.patch
+++ b/mlock-mlocked-pages-are-unevictable-fix.patch
@@ -1,33 +0,0 @@
-From: Andrew Morton <akpm@linux-foundation.org>
-
-fix it for Nick's page_check_address() interface change.
-
-nfi if this is right, but I had a 50/50 chance.  Another victim of sucky
-changelogging.
-
-Cc: Dave Hansen <dave@linux.vnet.ibm.com>
-Cc: Hugh Dickins <hugh@veritas.com>
-Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
-Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
-Cc: Matt Mackall <mpm@selenic.com>
-Cc: Nick Piggin <npiggin@suse.de>
-Cc: Rik van Riel <riel@redhat.com>
-Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
----
-
- mm/rmap.c |    2 +-
- 1 file changed, 1 insertion(+), 1 deletion(-)
-
-diff -puN mm/rmap.c~mlock-mlocked-pages-are-unevictable-fix mm/rmap.c
---- a/mm/rmap.c~mlock-mlocked-pages-are-unevictable-fix
-+++ a/mm/rmap.c
-@@ -288,7 +288,7 @@ static int page_mapped_in_vma(struct pag
- 	address = vma_address(page, vma);
- 	if (address == -EFAULT)		/* out of vma range */
- 		return 0;
--	pte = page_check_address(page, vma->vm_mm, address, &ptl);
-+	pte = page_check_address(page, vma->vm_mm, address, &ptl, 1);
- 	if (!pte)			/* the page is not in this mm */
- 		return 0;
- 	pte_unmap_unlock(pte, ptl);
-_

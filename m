Return-Path: <linux-kernel-owner+w=401wt.eu-S934230AbZFLVrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934230AbZFLVrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765628AbZFLVqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:46:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48896 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765029AbZFLVqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:46:12 -0400
From: Izik Eidus <ieidus@redhat.com>
To: hugh.dickins@tiscali.co.uk
Cc: linux-kernel@vger.kernel.org, Izik Eidus <ieidus@redhat.com>
Subject: [PATCH 3/3] withdraw ksm-add-page_wrprotect-write-protecting-page.patch
Date: Sat, 13 Jun 2009 00:45:00 +0300
Message-Id: <1244843100-4128-4-git-send-email-ieidus@redhat.com>
In-Reply-To: <1244843100-4128-3-git-send-email-ieidus@redhat.com>
References: <1244843100-4128-1-git-send-email-ieidus@redhat.com>
 <1244843100-4128-2-git-send-email-ieidus@redhat.com>
 <1244843100-4128-3-git-send-email-ieidus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that ksm have its private write_protect_page(), we dont need this helper
function to do the write-protecting work for us.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
---
 include/linux/rmap.h |   12 ----
 mm/rmap.c            |  139 --------------------------------------------------
 2 files changed, 0 insertions(+), 151 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 8b98536..350e76d 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -118,10 +118,6 @@ static inline int try_to_munlock(struct page *page)
 }
 #endif
 
-#ifdef CONFIG_KSM
-int page_wrprotect(struct page *page, int *odirect_sync, int count_offset);
-#endif
-
 #else	/* !CONFIG_MMU */
 
 #define anon_vma_init()		do {} while (0)
@@ -136,14 +132,6 @@ static inline int page_mkclean(struct page *page)
 	return 0;
 }
 
-#ifdef CONFIG_KSM
-static inline int page_wrprotect(struct page *page, int *odirect_sync,
-				 int count_offset)
-{
-	return 0;
-}
-#endif
-
 #endif	/* CONFIG_MMU */
 
 /*
diff --git a/mm/rmap.c b/mm/rmap.c
index 34a2029..c3ba0b9 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -585,145 +585,6 @@ int page_mkclean(struct page *page)
 }
 EXPORT_SYMBOL_GPL(page_mkclean);
 
-#ifdef CONFIG_KSM
-
-static int page_wrprotect_one(struct page *page, struct vm_area_struct *vma,
-			      int *odirect_sync, int count_offset)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	unsigned long address;
-	pte_t *pte;
-	spinlock_t *ptl;
-	int ret = 0;
-
-	address = vma_address(page, vma);
-	if (address == -EFAULT)
-		goto out;
-
-	pte = page_check_address(page, mm, address, &ptl, 0);
-	if (!pte)
-		goto out;
-
-	if (pte_write(*pte)) {
-		pte_t entry;
-
-		flush_cache_page(vma, address, pte_pfn(*pte));
-		/*
-		 * Ok this is tricky, when get_user_pages_fast() run it doesnt
-		 * take any lock, therefore the check that we are going to make
-		 * with the pagecount against the mapcount is racey and
-		 * O_DIRECT can happen right after the check.
-		 * So we clear the pte and flush the tlb before the check
-		 * this assure us that no O_DIRECT can happen after the check
-		 * or in the middle of the check.
-		 */
-		entry = ptep_clear_flush(vma, address, pte);
-		/*
-		 * Check that no O_DIRECT or similar I/O is in progress on the
-		 * page
-		 */
-		if ((page_mapcount(page) + count_offset) != page_count(page)) {
-			*odirect_sync = 0;
-			set_pte_at_notify(mm, address, pte, entry);
-			goto out_unlock;
-		}
-		entry = pte_wrprotect(entry);
-		set_pte_at_notify(mm, address, pte, entry);
-	}
-	ret = 1;
-
-out_unlock:
-	pte_unmap_unlock(pte, ptl);
-out:
-	return ret;
-}
-
-static int page_wrprotect_file(struct page *page, int *odirect_sync,
-			       int count_offset)
-{
-	struct address_space *mapping;
-	struct prio_tree_iter iter;
-	struct vm_area_struct *vma;
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
-	int ret = 0;
-
-	mapping = page_mapping(page);
-	if (!mapping)
-		return ret;
-
-	spin_lock(&mapping->i_mmap_lock);
-
-	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff)
-		ret += page_wrprotect_one(page, vma, odirect_sync,
-					  count_offset);
-
-	spin_unlock(&mapping->i_mmap_lock);
-
-	return ret;
-}
-
-static int page_wrprotect_anon(struct page *page, int *odirect_sync,
-			       int count_offset)
-{
-	struct vm_area_struct *vma;
-	struct anon_vma *anon_vma;
-	int ret = 0;
-
-	anon_vma = page_lock_anon_vma(page);
-	if (!anon_vma)
-		return ret;
-
-	/*
-	 * If the page is inside the swap cache, its _count number was
-	 * increased by one, therefore we have to increase count_offset by one.
-	 */
-	if (PageSwapCache(page))
-		count_offset++;
-
-	list_for_each_entry(vma, &anon_vma->head, anon_vma_node)
-		ret += page_wrprotect_one(page, vma, odirect_sync,
-					  count_offset);
-
-	page_unlock_anon_vma(anon_vma);
-
-	return ret;
-}
-
-/**
- * page_wrprotect - set all ptes pointing to a page as readonly
- * @page:         the page to set as readonly
- * @odirect_sync: boolean value that is set to 0 when some of the ptes were not
- *                marked as readonly beacuse page_wrprotect_one() was not able
- *                to mark this ptes as readonly without opening window to a race
- *                with odirect
- * @count_offset: number of times page_wrprotect() caller had called get_page()
- *                on the page
- *
- * returns the number of ptes which were marked as readonly.
- * (ptes that were readonly before this function was called are counted as well)
- */
-int page_wrprotect(struct page *page, int *odirect_sync, int count_offset)
-{
-	int ret = 0;
-
-	/*
-	 * Page lock is needed for anon pages for the PageSwapCache check,
-	 * and for page_mapping for filebacked pages
-	 */
-	BUG_ON(!PageLocked(page));
-
-	*odirect_sync = 1;
-	if (PageAnon(page))
-		ret = page_wrprotect_anon(page, odirect_sync, count_offset);
-	else
-		ret = page_wrprotect_file(page, odirect_sync, count_offset);
-
-	return ret;
-}
-EXPORT_SYMBOL(page_wrprotect);
-
-#endif
-
 /**
  * __page_set_anon_rmap - setup new anonymous rmap
  * @page:	the page to add the mapping to
-- 
1.5.6.5


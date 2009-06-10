Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbZFJGa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbZFJGa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 02:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbZFJGaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 02:30:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45179 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbZFJGaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 02:30:16 -0400
Date: Wed, 10 Jun 2009 09:28:55 +0300
From: Izik Eidus <ieidus@redhat.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: aarcange@redhat.com, akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       chrisw@redhat.com, riel@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 0/4] RFC - ksm api change into madvise
Message-ID: <20090610092855.43be2405@woof.tlv.redhat.com>
In-Reply-To: <Pine.LNX.4.64.0906092013580.31606@sister.anvils>
References: <1242261048-4487-1-git-send-email-ieidus@redhat.com>
	<Pine.LNX.4.64.0906081555360.22943@sister.anvils>
	<4A2D47C1.5020302@redhat.com>
	<Pine.LNX.4.64.0906081902520.9518@sister.anvils>
	<4A2D7036.1010800@redhat.com>
	<20090609074848.5357839a@woof.tlv.redhat.com>
	<Pine.LNX.4.64.0906091807300.20120@sister.anvils>
	<Pine.LNX.4.64.0906092013580.31606@sister.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009 20:27:29 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> On Tue, 9 Jun 2009, Hugh Dickins wrote:
> > On Tue, 9 Jun 2009, Izik Eidus wrote:
> > > How does this look like?
> > 
> > One improvment to make now, though: you've elsewhere avoided
> > the pgd,pud,pmd,pte descent in ksm.c (using get_pte instead), and
> > page_check_address() is not static to rmap.c (filemap_xip wanted
> > it), so please continue to use that.  It's not exported, right, but
> > I think Chris was already decisive that we should abandon modular
> > KSM, yes?
> 
> I think you can simplify it further, can't you?  Isn't the get_pte()
> preamble in try_to_merge_one_page() just unnecessary overhead now?
> See untested code below.  Or even move the trylock/unlock of the page
> into write_protect_page if you prefer.  Later on we'll uninline
> rmap.c's vma_address() so you can use it instead of your
> addr_in_vma() copy.
> 
> Hugh


Great!, what you think about below? another thing we want to add or to
start sending it to Andrew?

btw may i add your signed-off to this patch?
(the only thing that i changed was taking down the *orig_pte = *ptep,
so we will merge write_protected pages, and add orig_pte = __pte(0) to
avoid annoying warning message about being used uninitialized)

>From 7304f4404d91a40e234b0530de6d3bfc8c5925a2 Mon Sep 17 00:00:00 2001
From: Izik Eidus <ieidus@redhat.com>
Date: Tue, 9 Jun 2009 21:00:55 +0300
Subject: [PATCH 1/2] ksm: remove ksm from being a module.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
---
 include/linux/mm.h   |    2 +-
 include/linux/rmap.h |    4 ++--
 mm/Kconfig           |    5 ++---
 mm/memory.c          |    2 +-
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e617bab..cdc08d2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1258,7 +1258,7 @@ int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
 
-#if defined(CONFIG_KSM) || defined(CONFIG_KSM_MODULE)
+#if defined(CONFIG_KSM)
 int replace_page(struct vm_area_struct *vma, struct page *oldpage,
 		 struct page *newpage, pte_t orig_pte, pgprot_t prot);
 #endif
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 469376d..939c171 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -118,7 +118,7 @@ static inline int try_to_munlock(struct page *page)
 }
 #endif
 
-#if defined(CONFIG_KSM) || defined(CONFIG_KSM_MODULE)
+#if defined(CONFIG_KSM)
 int page_wrprotect(struct page *page, int *odirect_sync, int count_offset);
 #endif
 
@@ -136,7 +136,7 @@ static inline int page_mkclean(struct page *page)
 	return 0;
 }
 
-#if defined(CONFIG_KSM) || defined(CONFIG_KSM_MODULE)
+#if defined(CONFIG_KSM)
 static inline int page_wrprotect(struct page *page, int *odirect_sync,
 				 int count_offset)
 {
diff --git a/mm/Kconfig b/mm/Kconfig
index 5ebfd18..e7c118f 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -227,10 +227,9 @@ config MMU_NOTIFIER
 	bool
 
 config KSM
-	tristate "Enable KSM for page sharing"
+	bool "Enable KSM for page sharing"
 	help
-	  Enable the KSM kernel module to allow page sharing of equal pages
-	  among different tasks.
+	  Enable KSM to allow page sharing of equal pages among different tasks.
 
 config NOMMU_INITIAL_TRIM_EXCESS
 	int "Turn on mmap() excess space trimming before booting"
diff --git a/mm/memory.c b/mm/memory.c
index 8b4e40e..e23d4dd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1617,7 +1617,7 @@ int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vm_insert_mixed);
 
-#if defined(CONFIG_KSM) || defined(CONFIG_KSM_MODULE)
+#if defined(CONFIG_KSM)
 
 /**
  * replace_page - replace page in vma with new page
-- 
1.5.6.5





>From 3d9975dea43ae848f21875b5f99accecf1366765 Mon Sep 17 00:00:00 2001
From: Izik Eidus <ieidus@redhat.com>
Date: Wed, 10 Jun 2009 09:16:26 +0300
Subject: [PATCH 2/2] ksm: remove page_wrprotect() from rmap.c

Remove page_wrprotect() from rmap.c and instead embedded the needed code
into ksm.c

Hugh pointed out that for the ksm usage case, we dont have to walk over the rmap
and to write protected page after page beacuse when Anonymous page is mapped
more than once, it have to be write protected already, and in a case that it
mapped just once, no need to walk over the rmap, we can instead write protect
it from inside ksm.c.

Thanks.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
---
 include/linux/rmap.h |   12 ----
 mm/ksm.c             |   86 +++++++++++++++++++++----------
 mm/rmap.c            |  139 --------------------------------------------------
 3 files changed, 59 insertions(+), 178 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 939c171..350e76d 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -118,10 +118,6 @@ static inline int try_to_munlock(struct page *page)
 }
 #endif
 
-#if defined(CONFIG_KSM)
-int page_wrprotect(struct page *page, int *odirect_sync, int count_offset);
-#endif
-
 #else	/* !CONFIG_MMU */
 
 #define anon_vma_init()		do {} while (0)
@@ -136,14 +132,6 @@ static inline int page_mkclean(struct page *page)
 	return 0;
 }
 
-#if defined(CONFIG_KSM)
-static inline int page_wrprotect(struct page *page, int *odirect_sync,
-				 int count_offset)
-{
-	return 0;
-}
-#endif
-
 #endif	/* CONFIG_MMU */
 
 /*
diff --git a/mm/ksm.c b/mm/ksm.c
index 74d921b..9d4be62 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -37,6 +37,7 @@
 #include <linux/swap.h>
 #include <linux/rbtree.h>
 #include <linux/anon_inodes.h>
+#include <linux/mmu_notifier.h>
 #include <linux/ksm.h>
 
 #include <asm/tlbflush.h>
@@ -642,6 +643,60 @@ static inline int pages_identical(struct page *page1, struct page *page2)
 	return !memcmp_pages(page1, page2);
 }
 
+static inline int write_protect_page(struct page *page,
+				     struct vm_area_struct *vma,
+				     pte_t *orig_pte)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long addr;
+	pte_t *ptep;
+	spinlock_t *ptl;
+	int swapped;
+	int ret = 1;
+
+	addr = addr_in_vma(vma, page);
+	if (addr == -EFAULT)
+		goto out;
+
+	ptep = page_check_address(page, mm, addr, &ptl, 0);
+	if (!ptep)
+		goto out;
+
+	if (pte_write(*ptep)) {
+		pte_t entry;
+
+		swapped = PageSwapCache(page);
+		flush_cache_page(vma, addr, page_to_pfn(page));
+		/*
+		 * Ok this is tricky, when get_user_pages_fast() run it doesnt
+		 * take any lock, therefore the check that we are going to make
+		 * with the pagecount against the mapcount is racey and
+		 * O_DIRECT can happen right after the check.
+		 * So we clear the pte and flush the tlb before the check
+		 * this assure us that no O_DIRECT can happen after the check
+		 * or in the middle of the check.
+		 */
+		entry = ptep_clear_flush(vma, addr, ptep);
+		/*
+		 * Check that no O_DIRECT or similar I/O is in progress on the
+		 * page
+		 */
+		if ((page_mapcount(page) + 2 + swapped) != page_count(page)) {
+			set_pte_at_notify(mm, addr, ptep, entry);
+			goto out_unlock;
+		}
+		entry = pte_wrprotect(entry);
+		set_pte_at_notify(mm, addr, ptep, entry);
+	}
+	*orig_pte = *ptep;
+	ret = 0;
+
+out_unlock:
+	pte_unmap_unlock(ptep, ptl);
+out:
+	return ret;
+}
+
 /*
  * try_to_merge_one_page - take two pages and merge them into one
  * @mm: mm_struct that hold vma pointing into oldpage
@@ -661,9 +716,7 @@ static int try_to_merge_one_page(struct mm_struct *mm,
 				 pgprot_t newprot)
 {
 	int ret = 1;
-	int odirect_sync;
-	unsigned long page_addr_in_vma;
-	pte_t orig_pte, *orig_ptep;
+	pte_t orig_pte = __pte(0);
 
 	if (!PageAnon(oldpage))
 		goto out;
@@ -671,42 +724,21 @@ static int try_to_merge_one_page(struct mm_struct *mm,
 	get_page(newpage);
 	get_page(oldpage);
 
-	page_addr_in_vma = addr_in_vma(vma, oldpage);
-	if (page_addr_in_vma == -EFAULT)
-		goto out_putpage;
-
-	orig_ptep = get_pte(mm, page_addr_in_vma);
-	if (!orig_ptep)
-		goto out_putpage;
-	orig_pte = *orig_ptep;
-	pte_unmap(orig_ptep);
-	if (!pte_present(orig_pte))
-		goto out_putpage;
-	if (page_to_pfn(oldpage) != pte_pfn(orig_pte))
-		goto out_putpage;
 	/*
 	 * we need the page lock to read a stable PageSwapCache in
-	 * page_wrprotect().
+	 * write_protect_page().
 	 * we use trylock_page() instead of lock_page(), beacuse we dont want to
 	 * wait here, we prefer to continue scanning and merging diffrent pages
 	 * and to come back to this page when it is unlocked.
 	 */
 	if (!trylock_page(oldpage))
 		goto out_putpage;
-	/*
-	 * page_wrprotect check if the page is swapped or in swap cache,
-	 * in the future we might want to run here if_present_pte and then
-	 * swap_free
-	 */
-	if (!page_wrprotect(oldpage, &odirect_sync, 2)) {
+
+	if (write_protect_page(oldpage, vma, &orig_pte)) {
 		unlock_page(oldpage);
 		goto out_putpage;
 	}
 	unlock_page(oldpage);
-	if (!odirect_sync)
-		goto out_putpage;
-
-	orig_pte = pte_wrprotect(orig_pte);
 
 	if (pages_identical(oldpage, newpage))
 		ret = replace_page(vma, oldpage, newpage, orig_pte, newprot);
diff --git a/mm/rmap.c b/mm/rmap.c
index f53074c..c3ba0b9 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -585,145 +585,6 @@ int page_mkclean(struct page *page)
 }
 EXPORT_SYMBOL_GPL(page_mkclean);
 
-#if defined(CONFIG_KSM) || defined(CONFIG_KSM_MODULE)
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




> 
> static inline int write_protect_page(struct page *page,
> 				     struct vm_area_struct *vma,
> 				     pte_t *orig_pte)
> {
> 	struct mm_struct *mm = vma->vm_mm;
> 	unsigned long addr;
> 	pte_t *ptep;
> 	spinlock_t *ptl;
> 	int swapped;
> 	int ret = 1;
> 
> 	addr = addr_in_vma(vma, page);
> 	if (addr == -EFAULT)
> 		goto out;
> 
> 	ptep = page_check_address(page, mm, addr, &ptl, 0);
> 	if (!ptep)
> 		goto out;
> 
> 	if (pte_write(*ptep)) {
> 		pte_t entry;
> 
> 		swapped = PageSwapCache(page);
> 		flush_cache_page(vma, addr, page_to_pfn(page));
> 		/*
> 		 * Ok this is tricky, when get_user_pages_fast() run
> it doesnt
> 		 * take any lock, therefore the check that we are
> going to make
> 		 * with the pagecount against the mapcount is racey
> and
> 		 * O_DIRECT can happen right after the check.
> 		 * So we clear the pte and flush the tlb before the
> check
> 		 * this assure us that no O_DIRECT can happen after
> the check
> 		 * or in the middle of the check.
> 		 */
> 		entry = ptep_clear_flush(vma, addr, ptep);
> 		/*
> 		 * Check that no O_DIRECT or similar I/O is in
> progress on the
> 		 * page
> 		 */
> 		if ((page_mapcount(page) + 2 + swapped) !=
> page_count(page)) { set_pte_at_notify(mm, addr, ptep, entry);
> 			goto out_unlock;
> 		}
> 		entry = pte_wrprotect(entry);
> 		set_pte_at_notify(mm, addr, ptep, entry);
> 		*orig_pte = *ptep;
> 	}
> 	ret = 0;
> 
> out_unlock:
> 	pte_unmap_unlock(ptep, ptl);
> out:
> 	return ret;
> }
> 
> /*
>  * try_to_merge_one_page - take two pages and merge them into one
>  * @mm: mm_struct that hold vma pointing into oldpage
>  * @vma: the vma that hold the pte pointing into oldpage
>  * @oldpage: the page that we want to replace with newpage
>  * @newpage: the page that we want to map instead of oldpage
>  * @newprot: the new permission of the pte inside vma
>  * note:
>  * oldpage should be anon page while newpage should be file mapped
> page *
>  * this function return 0 if the pages were merged, 1 otherwise.
>  */
> static int try_to_merge_one_page(struct mm_struct *mm,
> 				 struct vm_area_struct *vma,
> 				 struct page *oldpage,
> 				 struct page *newpage,
> 				 pgprot_t newprot)
> {
> 	int ret = 1;
> 	pte_t orig_pte;
> 
> 	if (!PageAnon(oldpage))
> 		goto out;
> 
> 	get_page(newpage);
> 	get_page(oldpage);
> 
> 	/*
> 	 * we need the page lock to read a stable PageSwapCache in
> 	 * write_protect_page().
> 	 * we use trylock_page() instead of lock_page(), beacuse we
> dont want to
> 	 * wait here, we prefer to continue scanning and merging
> diffrent pages
> 	 * and to come back to this page when it is unlocked.
> 	 */
> 	if (!trylock_page(oldpage))
> 		goto out_putpage;
> 
> 	if (write_protect_page(oldpage, vma, &orig_pte)) {
> 		unlock_page(oldpage);
> 		goto out_putpage;
> 	}
> 	unlock_page(oldpage);
> 
> 	if (pages_identical(oldpage, newpage))
> 		ret = replace_page(vma, oldpage, newpage, orig_pte,
> newprot);
> 
> out_putpage:
> 	put_page(oldpage);
> 	put_page(newpage);
> out:
> 	return ret;
> }

Return-Path: <linux-kernel-owner+w=401wt.eu-S934162AbZFLVqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934162AbZFLVqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765096AbZFLVqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:46:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48894 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764835AbZFLVqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:46:11 -0400
From: Izik Eidus <ieidus@redhat.com>
To: hugh.dickins@tiscali.co.uk
Cc: linux-kernel@vger.kernel.org, Izik Eidus <ieidus@redhat.com>
Subject: [PATCH 2/3] ksm: remove page_wrprotect() from rmap.c
Date: Sat, 13 Jun 2009 00:44:59 +0300
Message-Id: <1244843100-4128-3-git-send-email-ieidus@redhat.com>
In-Reply-To: <1244843100-4128-2-git-send-email-ieidus@redhat.com>
References: <1244843100-4128-1-git-send-email-ieidus@redhat.com>
 <1244843100-4128-2-git-send-email-ieidus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove page_wrprotect() from rmap.c and instead embedded the needed code
into ksm.c

Hugh pointed out that for the ksm usage case, we dont have to walk over the rmap
and to write protected page after page beacuse when Anonymous page is mapped
more than once, it have to be write protected already, and in a case that it
mapped just once, no need to walk over the rmap, we can instead write protect
it from inside ksm.c.

Thanks.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Izik Eidus <ieidus@redhat.com>
---
 mm/ksm.c |   92 +++++++++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 65 insertions(+), 27 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 74d921b..3aee221 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -37,6 +37,7 @@
 #include <linux/swap.h>
 #include <linux/rbtree.h>
 #include <linux/anon_inodes.h>
+#include <linux/mmu_notifier.h>
 #include <linux/ksm.h>
 
 #include <asm/tlbflush.h>
@@ -643,6 +644,66 @@ static inline int pages_identical(struct page *page1, struct page *page2)
 }
 
 /*
+ * If this anonymous page is mapped only here, its pte may need
+ * to be write-protected, If it`s mapped elsewhere, all its
+ * ptes are necessarily already write-protected. In either
+ * case, we need to lock and check page_count is not raised.
+ */
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
+/*
  * try_to_merge_one_page - take two pages and merge them into one
  * @mm: mm_struct that hold vma pointing into oldpage
  * @vma: the vma that hold the pte pointing into oldpage
@@ -661,9 +722,7 @@ static int try_to_merge_one_page(struct mm_struct *mm,
 				 pgprot_t newprot)
 {
 	int ret = 1;
-	int odirect_sync;
-	unsigned long page_addr_in_vma;
-	pte_t orig_pte, *orig_ptep;
+	pte_t orig_pte = __pte(0);
 
 	if (!PageAnon(oldpage))
 		goto out;
@@ -671,42 +730,21 @@ static int try_to_merge_one_page(struct mm_struct *mm,
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
-- 
1.5.6.5


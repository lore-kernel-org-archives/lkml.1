Return-Path: <linux-kernel-owner+w=401wt.eu-S1759115AbYBHWHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115AbYBHWHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbYBHWG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:06:59 -0500
Received: from relay2.sgi.com ([192.48.171.30]:36030 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751838AbYBHWG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:06:58 -0500
Message-Id: <20080208220656.305019927@sgi.com>
References: <20080208220616.089936205@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 08 Feb 2008 14:06:19 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>
Cc: Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: daniel.blueman@quadrics.com
Subject: [patch 3/6] mmu_notifier: invalidate_page callbacks
Content-Disposition: inline; filename=mmu_invalidate_page
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two callbacks to remove individual pages as done in rmap code

	invalidate_page()

Called from the inner loop of rmap walks to invalidate pages.

	age_page()

Called for the determination of the page referenced status.

If we do not care about page referenced status then an age_page callback
may be be omitted. PageLock and pte lock are held when either of the
functions is called.

Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>
Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/rmap.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c	2008-02-07 16:49:32.000000000 -0800
+++ linux-2.6/mm/rmap.c	2008-02-07 17:25:25.000000000 -0800
@@ -49,6 +49,7 @@
 #include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/memcontrol.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/tlbflush.h>
 
@@ -287,7 +288,8 @@ static int page_referenced_one(struct pa
 	if (vma->vm_flags & VM_LOCKED) {
 		referenced++;
 		*mapcount = 1;	/* break early from loop */
-	} else if (ptep_clear_flush_young(vma, address, pte))
+	} else if (ptep_clear_flush_young(vma, address, pte) |
+		   mmu_notifier_age_page(mm, address))
 		referenced++;
 
 	/* Pretend the page is referenced if the task has the
@@ -455,6 +457,7 @@ static int page_mkclean_one(struct page 
 
 		flush_cache_page(vma, address, pte_pfn(*pte));
 		entry = ptep_clear_flush(vma, address, pte);
+		mmu_notifier(invalidate_page, mm, address);
 		entry = pte_wrprotect(entry);
 		entry = pte_mkclean(entry);
 		set_pte_at(mm, address, pte, entry);
@@ -712,7 +715,8 @@ static int try_to_unmap_one(struct page 
 	 * skipped over this mm) then we should reactivate it.
 	 */
 	if (!migration && ((vma->vm_flags & VM_LOCKED) ||
-			(ptep_clear_flush_young(vma, address, pte)))) {
+			(ptep_clear_flush_young(vma, address, pte) |
+				mmu_notifier_age_page(mm, address)))) {
 		ret = SWAP_FAIL;
 		goto out_unmap;
 	}
@@ -720,6 +724,7 @@ static int try_to_unmap_one(struct page 
 	/* Nuke the page table entry. */
 	flush_cache_page(vma, address, page_to_pfn(page));
 	pteval = ptep_clear_flush(vma, address, pte);
+	mmu_notifier(invalidate_page, mm, address);
 
 	/* Move the dirty bit to the physical page now the pte is gone. */
 	if (pte_dirty(pteval))
@@ -844,12 +849,14 @@ static void try_to_unmap_cluster(unsigne
 		page = vm_normal_page(vma, address, *pte);
 		BUG_ON(!page || PageAnon(page));
 
-		if (ptep_clear_flush_young(vma, address, pte))
+		if (ptep_clear_flush_young(vma, address, pte) |
+		    mmu_notifier_age_page(mm, address))
 			continue;
 
 		/* Nuke the page table entry. */
 		flush_cache_page(vma, address, pte_pfn(*pte));
 		pteval = ptep_clear_flush(vma, address, pte);
+		mmu_notifier(invalidate_page, mm, address);
 
 		/* If nonlinear, store the file page offset in the pte. */
 		if (page->index != linear_page_index(vma, address))

-- 

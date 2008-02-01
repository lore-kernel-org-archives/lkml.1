Return-Path: <linux-kernel-owner+w=401wt.eu-S935631AbYBAFHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935631AbYBAFHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760928AbYBAFG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 00:06:27 -0500
Received: from relay1.sgi.com ([192.48.171.29]:42690 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756184AbYBAFGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 00:06:24 -0500
Message-Id: <20080201050623.571690348@sgi.com>
References: <20080201050439.009441434@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 31 Jan 2008 21:04:42 -0800
From: Christoph Lameter <clameter@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: daniel.blueman@quadrics.com
Subject: [patch 3/4] mmu_notifier: invalidate_page callbacks
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
may be be omitted.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Robin Holt <holt@sgi.com>

---
 mm/rmap.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c	2008-01-31 19:55:45.000000000 -0800
+++ linux-2.6/mm/rmap.c	2008-01-31 20:28:35.000000000 -0800
@@ -49,6 +49,7 @@
 #include <linux/rcupdate.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/tlbflush.h>
 
@@ -284,7 +285,8 @@ static int page_referenced_one(struct pa
 	if (!pte)
 		goto out;
 
-	if (ptep_clear_flush_young(vma, address, pte))
+	if (ptep_clear_flush_young(vma, address, pte) |
+	    mmu_notifier_age_page(mm, address))
 		referenced++;
 
 	/* Pretend the page is referenced if the task has the
@@ -434,6 +436,7 @@ static int page_mkclean_one(struct page 
 
 		flush_cache_page(vma, address, pte_pfn(*pte));
 		entry = ptep_clear_flush(vma, address, pte);
+		mmu_notifier(invalidate_page, mm, address);
 		entry = pte_wrprotect(entry);
 		entry = pte_mkclean(entry);
 		set_pte_at(mm, address, pte, entry);
@@ -677,7 +680,8 @@ static int try_to_unmap_one(struct page 
 	 * skipped over this mm) then we should reactivate it.
 	 */
 	if (!migration && ((vma->vm_flags & VM_LOCKED) ||
-			(ptep_clear_flush_young(vma, address, pte)))) {
+			(ptep_clear_flush_young(vma, address, pte) |
+				mmu_notifier_age_page(mm, address)))) {
 		ret = SWAP_FAIL;
 		goto out_unmap;
 	}
@@ -685,6 +689,7 @@ static int try_to_unmap_one(struct page 
 	/* Nuke the page table entry. */
 	flush_cache_page(vma, address, page_to_pfn(page));
 	pteval = ptep_clear_flush(vma, address, pte);
+	mmu_notifier(invalidate_page, mm, address);
 
 	/* Move the dirty bit to the physical page now the pte is gone. */
 	if (pte_dirty(pteval))
@@ -809,12 +814,14 @@ static void try_to_unmap_cluster(unsigne
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

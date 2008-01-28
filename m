Return-Path: <linux-kernel-owner+w=401wt.eu-S1762331AbYA1Ubd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762331AbYA1Ubd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758025AbYA1U3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:29:33 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48432 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757561AbYA1U30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:29:26 -0500
Message-Id: <20080128202924.334342410@sgi.com>
References: <20080128202840.974253868@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Jan 2008 12:28:44 -0800
From: Christoph Lameter <clameter@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>
Cc: Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: [patch 4/6] MMU notifier: invalidate_page callbacks using Linux rmaps
Content-Disposition: inline; filename=mmu_invalidate_page_callbacks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These notifiers here use the Linux rmaps to perform the callbacks.
In order to walk the rmaps locks must be held. Callbacks can therefore
only operate in an atomic context.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/rmap.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c	2008-01-25 14:27:01.000000000 -0800
+++ linux-2.6/mm/rmap.c	2008-01-25 14:27:04.000000000 -0800
@@ -288,6 +288,9 @@ static int page_referenced_one(struct pa
 	if (ptep_clear_flush_young(vma, address, pte))
 		referenced++;
 
+	if (mmu_notifier_age_page(mm, address))
+		referenced++;
+
 	/* Pretend the page is referenced if the task has the
 	   swap token and is in the middle of a page fault. */
 	if (mm != current->mm && has_swap_token(mm) &&
@@ -435,6 +438,7 @@ static int page_mkclean_one(struct page 
 
 		flush_cache_page(vma, address, pte_pfn(*pte));
 		entry = ptep_clear_flush(vma, address, pte);
+		mmu_notifier(invalidate_page, mm, address);
 		entry = pte_wrprotect(entry);
 		entry = pte_mkclean(entry);
 		set_pte_at(mm, address, pte, entry);
@@ -680,7 +684,8 @@ static int try_to_unmap_one(struct page 
 	 * skipped over this mm) then we should reactivate it.
 	 */
 	if (!migration && ((vma->vm_flags & VM_LOCKED) ||
-			(ptep_clear_flush_young(vma, address, pte)))) {
+			(ptep_clear_flush_young(vma, address, pte) ||
+				mmu_notifier_age_page(mm, address)))) {
 		ret = SWAP_FAIL;
 		goto out_unmap;
 	}
@@ -688,6 +693,7 @@ static int try_to_unmap_one(struct page 
 	/* Nuke the page table entry. */
 	flush_cache_page(vma, address, page_to_pfn(page));
 	pteval = ptep_clear_flush(vma, address, pte);
+	mmu_notifier(invalidate_page, mm, address);
 
 	/* Move the dirty bit to the physical page now the pte is gone. */
 	if (pte_dirty(pteval))
@@ -815,9 +821,13 @@ static void try_to_unmap_cluster(unsigne
 		if (ptep_clear_flush_young(vma, address, pte))
 			continue;
 
+		if (mmu_notifier_age_page(mm, address))
+			continue;
+
 		/* Nuke the page table entry. */
 		flush_cache_page(vma, address, pte_pfn(*pte));
 		pteval = ptep_clear_flush(vma, address, pte);
+		mmu_notifier(invalidate_page, mm, address);
 
 		/* If nonlinear, store the file page offset in the pte. */
 		if (page->index != linear_page_index(vma, address))

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbYA1Uag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbYA1Uag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757954AbYA1U33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:29:29 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48430 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757560AbYA1U30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:29:26 -0500
Message-Id: <20080128202923.849058104@sgi.com>
References: <20080128202840.974253868@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Jan 2008 12:28:42 -0800
From: Christoph Lameter <clameter@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>
Cc: Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: [patch 2/6] mmu_notifier: Callbacks to invalidate address ranges
Content-Disposition: inline; filename=mmu_invalidate_range_callbacks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The invalidation of address ranges in a mm_struct needs to be
performed when pages are removed or permissions etc change.
Most of the VM address space changes can use the range invalidate
callback.

invalidate_range() is generally called with mmap_sem held but
no spinlocks are active. If invalidate_range() is called with
locks held then we pass a flag into invalidate_range()

Comments state that mmap_sem must be held for
remap_pfn_range() but various drivers do not seem to do this.

Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>
Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/fremap.c  |    2 ++
 mm/hugetlb.c |    2 ++
 mm/memory.c  |   11 +++++++++--
 mm/mmap.c    |    1 +
 4 files changed, 14 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/fremap.c
===================================================================
--- linux-2.6.orig/mm/fremap.c	2008-01-25 19:31:05.000000000 -0800
+++ linux-2.6/mm/fremap.c	2008-01-25 19:32:49.000000000 -0800
@@ -15,6 +15,7 @@
 #include <linux/rmap.h>
 #include <linux/module.h>
 #include <linux/syscalls.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
@@ -211,6 +212,7 @@ asmlinkage long sys_remap_file_pages(uns
 		spin_unlock(&mapping->i_mmap_lock);
 	}
 
+	mmu_notifier(invalidate_range, mm, start, start + size, 0);
 	err = populate_range(mm, vma, start, size, pgoff);
 	if (!err && !(flags & MAP_NONBLOCK)) {
 		if (unlikely(has_write_lock)) {
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2008-01-25 19:31:05.000000000 -0800
+++ linux-2.6/mm/memory.c	2008-01-25 19:32:49.000000000 -0800
@@ -50,6 +50,7 @@
 #include <linux/delayacct.h>
 #include <linux/init.h>
 #include <linux/writeback.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h>
@@ -891,6 +892,8 @@ unsigned long zap_page_range(struct vm_a
 	end = unmap_vmas(&tlb, vma, address, end, &nr_accounted, details);
 	if (tlb)
 		tlb_finish_mmu(tlb, address, end);
+	mmu_notifier(invalidate_range, mm, address, end,
+		(details ? (details->i_mmap_lock != NULL)  : 0));
 	return end;
 }
 
@@ -1319,7 +1322,7 @@ int remap_pfn_range(struct vm_area_struc
 {
 	pgd_t *pgd;
 	unsigned long next;
-	unsigned long end = addr + PAGE_ALIGN(size);
+	unsigned long start = addr, end = addr + PAGE_ALIGN(size);
 	struct mm_struct *mm = vma->vm_mm;
 	int err;
 
@@ -1360,6 +1363,7 @@ int remap_pfn_range(struct vm_area_struc
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
+	mmu_notifier(invalidate_range, mm, start, end, 0);
 	return err;
 }
 EXPORT_SYMBOL(remap_pfn_range);
@@ -1443,7 +1447,7 @@ int apply_to_page_range(struct mm_struct
 {
 	pgd_t *pgd;
 	unsigned long next;
-	unsigned long end = addr + size;
+	unsigned long start = addr, end = addr + size;
 	int err;
 
 	BUG_ON(addr >= end);
@@ -1454,6 +1458,7 @@ int apply_to_page_range(struct mm_struct
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
+	mmu_notifier(invalidate_range, mm, start, end, 0);
 	return err;
 }
 EXPORT_SYMBOL_GPL(apply_to_page_range);
@@ -1634,6 +1639,8 @@ gotten:
 	/*
 	 * Re-check the pte - we dropped the lock
 	 */
+	mmu_notifier(invalidate_range, mm, address,
+				address + PAGE_SIZE - 1, 0);
 	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (likely(pte_same(*page_table, orig_pte))) {
 		if (old_page) {
Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c	2008-01-25 19:31:05.000000000 -0800
+++ linux-2.6/mm/mmap.c	2008-01-25 19:32:49.000000000 -0800
@@ -1748,6 +1748,7 @@ static void unmap_region(struct mm_struc
 	free_pgtables(&tlb, vma, prev? prev->vm_end: FIRST_USER_ADDRESS,
 				 next? next->vm_start: 0);
 	tlb_finish_mmu(tlb, start, end);
+	mmu_notifier(invalidate_range, mm, start, end, 0);
 }
 
 /*
Index: linux-2.6/mm/hugetlb.c
===================================================================
--- linux-2.6.orig/mm/hugetlb.c	2008-01-25 19:33:58.000000000 -0800
+++ linux-2.6/mm/hugetlb.c	2008-01-25 19:34:13.000000000 -0800
@@ -14,6 +14,7 @@
 #include <linux/mempolicy.h>
 #include <linux/cpuset.h>
 #include <linux/mutex.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -763,6 +764,7 @@ void __unmap_hugepage_range(struct vm_ar
 	}
 	spin_unlock(&mm->page_table_lock);
 	flush_tlb_range(vma, start, end);
+	mmu_notifier(invalidate_range, mm, start, end, 1);
 	list_for_each_entry_safe(page, tmp, &page_list, lru) {
 		list_del(&page->lru);
 		put_page(page);

-- 

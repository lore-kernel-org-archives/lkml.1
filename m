Return-Path: <linux-kernel-owner+w=401wt.eu-S2992524AbXDDCoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992524AbXDDCoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992442AbXDDCnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:43:47 -0400
Received: from waste.org ([66.93.16.53]:54632 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966303AbXDDCmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:42:21 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1.486631555@selenic.com>
Message-Id: <4.486631555@selenic.com>
Subject: [PATCH 3/13] maps: Remove vma from args in the page walker
Date: Tue, 03 Apr 2007 21:43:33 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove vma from args in the page walker

This makes the walker more generic.

Signed-off-by: Matt Mackall <mpm@selenic.com>

Index: mm/fs/proc/task_mmu.c
===================================================================
--- mm.orig/fs/proc/task_mmu.c	2007-03-24 21:33:50.000000000 -0500
+++ mm/fs/proc/task_mmu.c	2007-03-24 21:33:52.000000000 -0500
@@ -313,25 +313,26 @@ static void walk_pud_range(pgd_t *pgd, u
 }
 
 /*
- * walk_page_range - walk the page tables of a VMA with a callback
- * @vma - VMA to walk
+ * walk_page_range - walk a memory map's page tables with a callback
+ * @mm - memory map to walk
+ * @addr - starting address
+ * @end - ending address
  * @action - callback invoked for every bottom-level (PTE) page table
  * @private - private data passed to the callback function
  *
  * Recursively walk the page table for the memory area in a VMA, calling
  * a callback for every bottom-level (PTE) page table.
  */
-static void walk_page_range(struct vm_area_struct *vma,
+static void walk_page_range(struct mm_struct *mm,
+			    unsigned long addr, unsigned long end,
 			    void (*action)(pmd_t *, unsigned long,
 					   unsigned long, void *),
 			    void *private)
 {
-	unsigned long addr = vma->vm_start;
-	unsigned long end = vma->vm_end;
 	pgd_t *pgd;
 	unsigned long next;
 
-	for (pgd = pgd_offset(vma->vm_mm, addr); addr != end;
+	for (pgd = pgd_offset(mm, addr); addr != end;
 	     pgd++, addr = next) {
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
@@ -348,7 +349,8 @@ static int show_smap(struct seq_file *m,
 	memset(&mss, 0, sizeof mss);
 	mss.vma = vma;
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-		walk_page_range(vma, smaps_pte_range, &mss);
+		walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
+				smaps_pte_range, &mss);
 	return show_map_internal(m, v, &mss);
 }
 
@@ -359,7 +361,8 @@ void clear_refs_smap(struct mm_struct *m
 	down_read(&mm->mmap_sem);
 	for (vma = mm->mmap; vma; vma = vma->vm_next)
 		if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-			walk_page_range(vma, clear_refs_pte_range, vma);
+			walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
+					clear_refs_pte_range, vma);
 	flush_tlb_mm(mm);
 	up_read(&mm->mmap_sem);
 }

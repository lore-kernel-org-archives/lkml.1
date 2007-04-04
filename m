Return-Path: <linux-kernel-owner+w=401wt.eu-S966310AbXDDCnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966310AbXDDCnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966304AbXDDCmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:42:22 -0400
Received: from waste.org ([66.93.16.53]:5460 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966296AbXDDCmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:42:20 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1.486631555@selenic.com>
Message-Id: <3.486631555@selenic.com>
Subject: [PATCH 2/13] maps: Eliminate the pmd_walker struct in the page walker
Date: Tue, 03 Apr 2007 21:43:32 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate the pmd_walker struct in the page walker

This slightly simplifies things for the next few cleanups.

Signed-off-by: Matt Mackall <mpm@selenic.com>

Index: mm/fs/proc/task_mmu.c
===================================================================
--- mm.orig/fs/proc/task_mmu.c	2007-03-24 21:33:47.000000000 -0500
+++ mm/fs/proc/task_mmu.c	2007-03-24 21:33:50.000000000 -0500
@@ -116,6 +116,7 @@ static void pad_len_spaces(struct seq_fi
 
 struct mem_size_stats
 {
+	struct vm_area_struct *vma;
 	unsigned long resident;
 	unsigned long shared_clean;
 	unsigned long shared_dirty;
@@ -124,13 +125,6 @@ struct mem_size_stats
 	unsigned long referenced;
 };
 
-struct pmd_walker {
-	struct vm_area_struct *vma;
-	void *private;
-	void (*action)(struct vm_area_struct *, pmd_t *, unsigned long,
-		       unsigned long, void *);
-};
-
 static int show_map_internal(struct seq_file *m, void *v, struct mem_size_stats *mss)
 {
 	struct proc_maps_private *priv = m->private;
@@ -218,11 +212,11 @@ static int show_map(struct seq_file *m, 
 	return show_map_internal(m, v, NULL);
 }
 
-static void smaps_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-			    unsigned long addr, unsigned long end,
+static void smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			    void *private)
 {
 	struct mem_size_stats *mss = private;
+	struct vm_area_struct *vma = mss->vma;
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
@@ -258,10 +252,10 @@ static void smaps_pte_range(struct vm_ar
 	cond_resched();
 }
 
-static void clear_refs_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-				 unsigned long addr, unsigned long end,
-				 void *private)
+static void clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
+				 unsigned long end, void *private)
 {
+	struct vm_area_struct *vma = private;
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
@@ -284,8 +278,10 @@ static void clear_refs_pte_range(struct 
 	cond_resched();
 }
 
-static void walk_pmd_range(struct pmd_walker *walker, pud_t *pud,
-				  unsigned long addr, unsigned long end)
+static void walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
+			   void (*action)(pmd_t *, unsigned long,
+					  unsigned long, void *),
+			   void *private)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -295,12 +291,14 @@ static void walk_pmd_range(struct pmd_wa
 		next = pmd_addr_end(addr, end);
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
-		walker->action(walker->vma, pmd, addr, next, walker->private);
+		action(pmd, addr, next, private);
 	}
 }
 
-static void walk_pud_range(struct pmd_walker *walker, pgd_t *pgd,
-				  unsigned long addr, unsigned long end)
+static void walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
+			   void (*action)(pmd_t *, unsigned long,
+					  unsigned long, void *),
+			   void *private)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -310,7 +308,7 @@ static void walk_pud_range(struct pmd_wa
 		next = pud_addr_end(addr, end);
 		if (pud_none_or_clear_bad(pud))
 			continue;
-		walk_pmd_range(walker, pud, addr, next);
+		walk_pmd_range(pud, addr, next, action, private);
 	}
 }
 
@@ -324,18 +322,12 @@ static void walk_pud_range(struct pmd_wa
  * a callback for every bottom-level (PTE) page table.
  */
 static void walk_page_range(struct vm_area_struct *vma,
-			    void (*action)(struct vm_area_struct *,
-					   pmd_t *, unsigned long,
+			    void (*action)(pmd_t *, unsigned long,
 					   unsigned long, void *),
 			    void *private)
 {
 	unsigned long addr = vma->vm_start;
 	unsigned long end = vma->vm_end;
-	struct pmd_walker walker = {
-		.vma		= vma,
-		.private	= private,
-		.action		= action,
-	};
 	pgd_t *pgd;
 	unsigned long next;
 
@@ -344,7 +336,7 @@ static void walk_page_range(struct vm_ar
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		walk_pud_range(&walker, pgd, addr, next);
+		walk_pud_range(pgd, addr, next, action, private);
 	}
 }
 
@@ -354,6 +346,7 @@ static int show_smap(struct seq_file *m,
 	struct mem_size_stats mss;
 
 	memset(&mss, 0, sizeof mss);
+	mss.vma = vma;
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 		walk_page_range(vma, smaps_pte_range, &mss);
 	return show_map_internal(m, v, &mss);
@@ -366,7 +359,7 @@ void clear_refs_smap(struct mm_struct *m
 	down_read(&mm->mmap_sem);
 	for (vma = mm->mmap; vma; vma = vma->vm_next)
 		if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-			walk_page_range(vma, clear_refs_pte_range, NULL);
+			walk_page_range(vma, clear_refs_pte_range, vma);
 	flush_tlb_mm(mm);
 	up_read(&mm->mmap_sem);
 }

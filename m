Return-Path: <linux-kernel-owner+w=401wt.eu-S1946017AbXDDCnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946017AbXDDCnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966316AbXDDCnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:43:00 -0400
Received: from waste.org ([66.93.16.53]:54639 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966305AbXDDCmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:42:24 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1.486631555@selenic.com>
Message-Id: <6.486631555@selenic.com>
Subject: [PATCH 5/13] maps: Add callbacks for each level to page walker
Date: Tue, 03 Apr 2007 21:43:35 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add callbacks for each level to page walker

This allows iterating over all levels of the page tables. Recursion
continues to the depth of the lowest supplied callback.

This makes the page walker nearly completely generic and should allow
it to replace some other hand-rolled page table walkers.

Signed-off-by: Matt Mackall <mpm@selenic.com>

Index: mm/fs/proc/task_mmu.c
===================================================================
--- mm.orig/fs/proc/task_mmu.c	2007-03-24 21:33:58.000000000 -0500
+++ mm/fs/proc/task_mmu.c	2007-03-24 21:34:07.000000000 -0500
@@ -280,10 +280,35 @@ static int clear_refs_pte_range(pmd_t *p
 	return 0;
 }
 
+struct mm_walk {
+	int (*pgd_entry)(pgd_t *, unsigned long, unsigned long, void *);
+	int (*pud_entry)(pud_t *, unsigned long, unsigned long, void *);
+	int (*pmd_entry)(pmd_t *, unsigned long, unsigned long, void *);
+	int (*pte_entry)(pte_t *, unsigned long, unsigned long, void *);
+};
+
+static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+			  struct mm_walk *walk, void *private)
+{
+	pte_t *pte;
+	int err;
+
+	for (pte = pte_offset_map(pmd, addr); addr != end;
+	     addr += PAGE_SIZE, pte++) {
+		if (pte_none(*pte))
+			continue;
+		err = walk->pte_entry(pte, addr, addr, private);
+		if (err) {
+			pte_unmap(pte);
+			return err;
+		}
+	}
+	pte_unmap(pte);
+	return 0;
+}
+
 static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
-			  int (*action)(pmd_t *, unsigned long,
-					unsigned long, void *),
-			  void *private)
+			  struct mm_walk *walk, void *private)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -294,18 +319,22 @@ static int walk_pmd_range(pud_t *pud, un
 		next = pmd_addr_end(addr, end);
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
-		err = action(pmd, addr, next, private);
-		if (err)
-			return err;
+		if (walk->pmd_entry) {
+			err = walk->pmd_entry(pmd, addr, next, private);
+			if (err)
+				return err;
+		}
+		if (walk->pte_entry) {
+			err = walk_pte_range(pmd, addr, next, walk, private);
+			if (err)
+				return err;
+		}
 	}
-
 	return 0;
 }
 
 static int walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
-			  int (*action)(pmd_t *, unsigned long,
-					unsigned long, void *),
-			  void *private)
+			  struct mm_walk *walk, void *private)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -316,11 +345,17 @@ static int walk_pud_range(pgd_t *pgd, un
 		next = pud_addr_end(addr, end);
 		if (pud_none_or_clear_bad(pud))
 			continue;
-		err = walk_pmd_range(pud, addr, next, action, private);
-		if (err)
-			return err;
+		if (walk->pud_entry) {
+			err = walk->pud_entry(pud, addr, next, private);
+			if (err)
+				return err;
+		}
+		if (walk->pmd_entry || walk->pte_entry) {
+			err = walk_pmd_range(pud, addr, next, walk, private);
+			if (err)
+				return err;
+		}
 	}
-
 	return 0;
 }
 
@@ -337,9 +372,7 @@ static int walk_pud_range(pgd_t *pgd, un
  */
 static int walk_page_range(struct mm_struct *mm,
 			   unsigned long addr, unsigned long end,
-			   int (*action)(pmd_t *, unsigned long,
-					 unsigned long, void *),
-			   void *private)
+			   struct mm_walk *walk, void *private)
 {
 	pgd_t *pgd;
 	unsigned long next;
@@ -350,14 +383,22 @@ static int walk_page_range(struct mm_str
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		err = walk_pud_range(pgd, addr, next, action, private);
-		if (err)
-			return err;
+		if (walk->pgd_entry) {
+			err = walk->pgd_entry(pgd, addr, next, private);
+			if (err)
+				return err;
+		}
+		if (walk->pud_entry || walk->pmd_entry || walk->pte_entry) {
+			err = walk_pud_range(pgd, addr, next, walk, private);
+			if (err)
+				return err;
+		}
 	}
-
 	return 0;
 }
 
+static struct mm_walk smaps_walk = { .pmd_entry = smaps_pte_range };
+
 static int show_smap(struct seq_file *m, void *v)
 {
 	struct vm_area_struct *vma = v;
@@ -367,10 +408,12 @@ static int show_smap(struct seq_file *m,
 	mss.vma = vma;
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 		walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
-				smaps_pte_range, &mss);
+				&smaps_walk, &mss);
 	return show_map_internal(m, v, &mss);
 }
 
+static struct mm_walk clear_refs_walk = { .pmd_entry = clear_refs_pte_range };
+
 void clear_refs_smap(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
@@ -379,7 +422,7 @@ void clear_refs_smap(struct mm_struct *m
 	for (vma = mm->mmap; vma; vma = vma->vm_next)
 		if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 			walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
-					clear_refs_pte_range, vma);
+					&clear_refs_walk, vma);
 	flush_tlb_mm(mm);
 	up_read(&mm->mmap_sem);
 }

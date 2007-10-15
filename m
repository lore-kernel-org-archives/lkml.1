Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbXJOW0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbXJOW0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757086AbXJOW0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:26:09 -0400
Received: from waste.org ([66.93.16.53]:1290 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755629AbXJOW0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:26:06 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: Dave Hansen <haveblue@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <1.290135367@selenic.com>
Message-Id: <6.290135367@selenic.com>
Subject: [PATCH 5/11] maps3: use pagewalker in clear_refs and smaps
Date: Mon, 15 Oct 2007 17:26:02 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic pagewalker for smaps and clear_refs

Signed-off-by: Matt Mackall <mpm@selenic.com>

Index: l/fs/proc/task_mmu.c
===================================================================
--- l.orig/fs/proc/task_mmu.c	2007-10-14 13:36:56.000000000 -0500
+++ l/fs/proc/task_mmu.c	2007-10-14 13:37:08.000000000 -0500
@@ -116,6 +116,7 @@ static void pad_len_spaces(struct seq_fi
 
 struct mem_size_stats
 {
+	struct vm_area_struct *vma;
 	unsigned long resident;
 	unsigned long shared_clean;
 	unsigned long shared_dirty;
@@ -145,13 +146,6 @@ struct mem_size_stats
 #define PSS_DIV_BITS	12
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
@@ -241,11 +235,11 @@ static int show_map(struct seq_file *m, 
 	return show_map_internal(m, v, NULL);
 }
 
-static void smaps_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-			    unsigned long addr, unsigned long end,
-			    void *private)
+static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+			   void *private)
 {
 	struct mem_size_stats *mss = private;
+	struct vm_area_struct *vma = mss->vma;
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
@@ -283,12 +277,13 @@ static void smaps_pte_range(struct vm_ar
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
+	return 0;
 }
 
-static void clear_refs_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-				 unsigned long addr, unsigned long end,
-				 void *private)
+static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
+				unsigned long end, void *private)
 {
+	struct vm_area_struct *vma = private;
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
@@ -309,71 +304,10 @@ static void clear_refs_pte_range(struct 
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
+	return 0;
 }
 
-static inline void walk_pmd_range(struct pmd_walker *walker, pud_t *pud,
-				  unsigned long addr, unsigned long end)
-{
-	pmd_t *pmd;
-	unsigned long next;
-
-	for (pmd = pmd_offset(pud, addr); addr != end;
-	     pmd++, addr = next) {
-		next = pmd_addr_end(addr, end);
-		if (pmd_none_or_clear_bad(pmd))
-			continue;
-		walker->action(walker->vma, pmd, addr, next, walker->private);
-	}
-}
-
-static inline void walk_pud_range(struct pmd_walker *walker, pgd_t *pgd,
-				  unsigned long addr, unsigned long end)
-{
-	pud_t *pud;
-	unsigned long next;
-
-	for (pud = pud_offset(pgd, addr); addr != end;
-	     pud++, addr = next) {
-		next = pud_addr_end(addr, end);
-		if (pud_none_or_clear_bad(pud))
-			continue;
-		walk_pmd_range(walker, pud, addr, next);
-	}
-}
-
-/*
- * walk_page_range - walk the page tables of a VMA with a callback
- * @vma - VMA to walk
- * @action - callback invoked for every bottom-level (PTE) page table
- * @private - private data passed to the callback function
- *
- * Recursively walk the page table for the memory area in a VMA, calling
- * a callback for every bottom-level (PTE) page table.
- */
-static inline void walk_page_range(struct vm_area_struct *vma,
-				   void (*action)(struct vm_area_struct *,
-						  pmd_t *, unsigned long,
-						  unsigned long, void *),
-				   void *private)
-{
-	unsigned long addr = vma->vm_start;
-	unsigned long end = vma->vm_end;
-	struct pmd_walker walker = {
-		.vma		= vma,
-		.private	= private,
-		.action		= action,
-	};
-	pgd_t *pgd;
-	unsigned long next;
-
-	for (pgd = pgd_offset(vma->vm_mm, addr); addr != end;
-	     pgd++, addr = next) {
-		next = pgd_addr_end(addr, end);
-		if (pgd_none_or_clear_bad(pgd))
-			continue;
-		walk_pud_range(&walker, pgd, addr, next);
-	}
-}
+static struct mm_walk smaps_walk = { .pmd_entry = smaps_pte_range };
 
 static int show_smap(struct seq_file *m, void *v)
 {
@@ -381,11 +315,15 @@ static int show_smap(struct seq_file *m,
 	struct mem_size_stats mss;
 
 	memset(&mss, 0, sizeof mss);
+	mss.vma = vma;
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-		walk_page_range(vma, smaps_pte_range, &mss);
+		walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
+				&smaps_walk, &mss);
 	return show_map_internal(m, v, &mss);
 }
 
+static struct mm_walk clear_refs_walk = { .pmd_entry = clear_refs_pte_range };
+
 void clear_refs_smap(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
@@ -393,7 +331,8 @@ void clear_refs_smap(struct mm_struct *m
 	down_read(&mm->mmap_sem);
 	for (vma = mm->mmap; vma; vma = vma->vm_next)
 		if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-			walk_page_range(vma, clear_refs_pte_range, NULL);
+			walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
+					&clear_refs_walk, vma);
 	flush_tlb_mm(mm);
 	up_read(&mm->mmap_sem);
 }

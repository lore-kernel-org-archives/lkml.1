Return-Path: <linux-kernel-owner+w=401wt.eu-S966296AbXDDCm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966296AbXDDCm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966318AbXDDCm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:42:59 -0400
Received: from waste.org ([66.93.16.53]:54635 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966296AbXDDCmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:42:22 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1.486631555@selenic.com>
Message-Id: <5.486631555@selenic.com>
Subject: [PATCH 4/13] maps: Propagate errors from callback in page walker
Date: Tue, 03 Apr 2007 21:43:34 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Propagate errors from callback in page walker

Signed-off-by: Matt Mackall <mpm@selenic.com>

Index: mm/fs/proc/task_mmu.c
===================================================================
--- mm.orig/fs/proc/task_mmu.c	2007-03-24 21:33:52.000000000 -0500
+++ mm/fs/proc/task_mmu.c	2007-03-24 21:33:58.000000000 -0500
@@ -212,8 +212,8 @@ static int show_map(struct seq_file *m, 
 	return show_map_internal(m, v, NULL);
 }
 
-static void smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
-			    void *private)
+static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+			   void *private)
 {
 	struct mem_size_stats *mss = private;
 	struct vm_area_struct *vma = mss->vma;
@@ -250,10 +250,11 @@ static void smaps_pte_range(pmd_t *pmd, 
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
+	return 0;
 }
 
-static void clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
-				 unsigned long end, void *private)
+static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
+				unsigned long end, void *private)
 {
 	struct vm_area_struct *vma = private;
 	pte_t *pte, ptent;
@@ -276,40 +277,51 @@ static void clear_refs_pte_range(pmd_t *
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
+	return 0;
 }
 
-static void walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
-			   void (*action)(pmd_t *, unsigned long,
-					  unsigned long, void *),
-			   void *private)
+static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
+			  int (*action)(pmd_t *, unsigned long,
+					unsigned long, void *),
+			  void *private)
 {
 	pmd_t *pmd;
 	unsigned long next;
+	int err;
 
 	for (pmd = pmd_offset(pud, addr); addr != end;
 	     pmd++, addr = next) {
 		next = pmd_addr_end(addr, end);
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
-		action(pmd, addr, next, private);
+		err = action(pmd, addr, next, private);
+		if (err)
+			return err;
 	}
+
+	return 0;
 }
 
-static void walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
-			   void (*action)(pmd_t *, unsigned long,
-					  unsigned long, void *),
-			   void *private)
+static int walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
+			  int (*action)(pmd_t *, unsigned long,
+					unsigned long, void *),
+			  void *private)
 {
 	pud_t *pud;
 	unsigned long next;
+	int err;
 
 	for (pud = pud_offset(pgd, addr); addr != end;
 	     pud++, addr = next) {
 		next = pud_addr_end(addr, end);
 		if (pud_none_or_clear_bad(pud))
 			continue;
-		walk_pmd_range(pud, addr, next, action, private);
+		err = walk_pmd_range(pud, addr, next, action, private);
+		if (err)
+			return err;
 	}
+
+	return 0;
 }
 
 /*
@@ -323,22 +335,27 @@ static void walk_pud_range(pgd_t *pgd, u
  * Recursively walk the page table for the memory area in a VMA, calling
  * a callback for every bottom-level (PTE) page table.
  */
-static void walk_page_range(struct mm_struct *mm,
-			    unsigned long addr, unsigned long end,
-			    void (*action)(pmd_t *, unsigned long,
-					   unsigned long, void *),
-			    void *private)
+static int walk_page_range(struct mm_struct *mm,
+			   unsigned long addr, unsigned long end,
+			   int (*action)(pmd_t *, unsigned long,
+					 unsigned long, void *),
+			   void *private)
 {
 	pgd_t *pgd;
 	unsigned long next;
+	int err;
 
 	for (pgd = pgd_offset(mm, addr); addr != end;
 	     pgd++, addr = next) {
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		walk_pud_range(pgd, addr, next, action, private);
+		err = walk_pud_range(pgd, addr, next, action, private);
+		if (err)
+			return err;
 	}
+
+	return 0;
 }
 
 static int show_smap(struct seq_file *m, void *v)

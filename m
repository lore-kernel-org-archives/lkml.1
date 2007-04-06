Return-Path: <linux-kernel-owner+w=401wt.eu-S933262AbXDFWHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbXDFWHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932808AbXDFWGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:06:23 -0400
Received: from waste.org ([66.93.16.53]:40095 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933175AbXDFWBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:01:41 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1.469046093@selenic.com>
Message-Id: <7.469046093@selenic.com>
Subject: [PATCH 6/13] maps#2: Move the page walker code to lib/
Date: Fri, 06 Apr 2007 17:03:07 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the page walker code to lib/

This lets it get shared outside of proc/ and linked in only when
needed.

Signed-off-by: Matt Mackall <mpm@selenic.com>

Index: mm/fs/proc/task_mmu.c
===================================================================
--- mm.orig/fs/proc/task_mmu.c	2007-03-27 22:13:43.000000000 -0500
+++ mm/fs/proc/task_mmu.c	2007-03-27 22:13:51.000000000 -0500
@@ -280,123 +280,6 @@ static int clear_refs_pte_range(pmd_t *p
 	return 0;
 }
 
-struct mm_walk {
-	int (*pgd_entry)(pgd_t *, unsigned long, unsigned long, void *);
-	int (*pud_entry)(pud_t *, unsigned long, unsigned long, void *);
-	int (*pmd_entry)(pmd_t *, unsigned long, unsigned long, void *);
-	int (*pte_entry)(pte_t *, unsigned long, unsigned long, void *);
-};
-
-static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
-			  struct mm_walk *walk, void *private)
-{
-	pte_t *pte;
-	int err;
-
-	for (pte = pte_offset_map(pmd, addr); addr != end;
-	     addr += PAGE_SIZE, pte++) {
-		if (pte_none(*pte))
-			continue;
-		err = walk->pte_entry(pte, addr, addr, private);
-		if (err) {
-			pte_unmap(pte);
-			return err;
-		}
-	}
-	pte_unmap(pte);
-	return 0;
-}
-
-static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
-			  struct mm_walk *walk, void *private)
-{
-	pmd_t *pmd;
-	unsigned long next;
-	int err;
-
-	for (pmd = pmd_offset(pud, addr); addr != end;
-	     pmd++, addr = next) {
-		next = pmd_addr_end(addr, end);
-		if (pmd_none_or_clear_bad(pmd))
-			continue;
-		if (walk->pmd_entry) {
-			err = walk->pmd_entry(pmd, addr, next, private);
-			if (err)
-				return err;
-		}
-		if (walk->pte_entry) {
-			err = walk_pte_range(pmd, addr, next, walk, private);
-			if (err)
-				return err;
-		}
-	}
-	return 0;
-}
-
-static int walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
-			  struct mm_walk *walk, void *private)
-{
-	pud_t *pud;
-	unsigned long next;
-	int err;
-
-	for (pud = pud_offset(pgd, addr); addr != end;
-	     pud++, addr = next) {
-		next = pud_addr_end(addr, end);
-		if (pud_none_or_clear_bad(pud))
-			continue;
-		if (walk->pud_entry) {
-			err = walk->pud_entry(pud, addr, next, private);
-			if (err)
-				return err;
-		}
-		if (walk->pmd_entry || walk->pte_entry) {
-			err = walk_pmd_range(pud, addr, next, walk, private);
-			if (err)
-				return err;
-		}
-	}
-	return 0;
-}
-
-/*
- * walk_page_range - walk a memory map's page tables with a callback
- * @mm - memory map to walk
- * @addr - starting address
- * @end - ending address
- * @action - callback invoked for every bottom-level (PTE) page table
- * @private - private data passed to the callback function
- *
- * Recursively walk the page table for the memory area in a VMA, calling
- * a callback for every bottom-level (PTE) page table.
- */
-static int walk_page_range(struct mm_struct *mm,
-			   unsigned long addr, unsigned long end,
-			   struct mm_walk *walk, void *private)
-{
-	pgd_t *pgd;
-	unsigned long next;
-	int err;
-
-	for (pgd = pgd_offset(mm, addr); addr != end;
-	     pgd++, addr = next) {
-		next = pgd_addr_end(addr, end);
-		if (pgd_none_or_clear_bad(pgd))
-			continue;
-		if (walk->pgd_entry) {
-			err = walk->pgd_entry(pgd, addr, next, private);
-			if (err)
-				return err;
-		}
-		if (walk->pud_entry || walk->pmd_entry || walk->pte_entry) {
-			err = walk_pud_range(pgd, addr, next, walk, private);
-			if (err)
-				return err;
-		}
-	}
-	return 0;
-}
-
 static struct mm_walk smaps_walk = { .pmd_entry = smaps_pte_range };
 
 static int show_smap(struct seq_file *m, void *v)
Index: mm/include/linux/mm.h
===================================================================
--- mm.orig/include/linux/mm.h	2007-03-27 22:13:42.000000000 -0500
+++ mm/include/linux/mm.h	2007-03-27 22:13:51.000000000 -0500
@@ -747,6 +747,16 @@ unsigned long unmap_vmas(struct mmu_gath
 		struct vm_area_struct *start_vma, unsigned long start_addr,
 		unsigned long end_addr, unsigned long *nr_accounted,
 		struct zap_details *);
+
+struct mm_walk {
+	int (*pgd_entry)(pgd_t *, unsigned long, unsigned long, void *);
+	int (*pud_entry)(pud_t *, unsigned long, unsigned long, void *);
+	int (*pmd_entry)(pmd_t *, unsigned long, unsigned long, void *);
+	int (*pte_entry)(pte_t *, unsigned long, unsigned long, void *);
+};
+
+int walk_page_range(struct mm_struct *, unsigned long addr, unsigned long end,
+		    struct mm_walk *walk, void *private);
 void free_pgd_range(struct mmu_gather **tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 void free_pgtables(struct mmu_gather **tlb, struct vm_area_struct *start_vma,
Index: mm/lib/Makefile
===================================================================
--- mm.orig/lib/Makefile	2007-03-27 22:14:09.000000000 -0500
+++ mm/lib/Makefile	2007-03-27 22:16:49.000000000 -0500
@@ -7,7 +7,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 idr.o div64.o int_sqrt.o bitmap.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o
 
-lib-$(CONFIG_MMU) += ioremap.o
+lib-$(CONFIG_MMU) += ioremap.o pagewalk.o
 lib-$(CONFIG_SMP) += cpumask.o
 
 lib-y	+= kobject.o kref.o kobject_uevent.o klist.o
Index: mm/lib/pagewalk.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ mm/lib/pagewalk.c	2007-03-27 22:18:37.000000000 -0500
@@ -0,0 +1,111 @@
+#include <linux/mm.h>
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
+static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
+			  struct mm_walk *walk, void *private)
+{
+	pmd_t *pmd;
+	unsigned long next;
+	int err;
+
+	for (pmd = pmd_offset(pud, addr); addr != end;
+	     pmd++, addr = next) {
+		next = pmd_addr_end(addr, end);
+		if (pmd_none_or_clear_bad(pmd))
+			continue;
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
+	}
+	return 0;
+}
+
+static int walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
+			  struct mm_walk *walk, void *private)
+{
+	pud_t *pud;
+	unsigned long next;
+	int err;
+
+	for (pud = pud_offset(pgd, addr); addr != end;
+	     pud++, addr = next) {
+		next = pud_addr_end(addr, end);
+		if (pud_none_or_clear_bad(pud))
+			continue;
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
+	}
+	return 0;
+}
+
+/*
+ * walk_page_range - walk a memory map's page tables with a callback
+ * @mm - memory map to walk
+ * @addr - starting address
+ * @end - ending address
+ * @walk - set of callbacks to invoke for each level of the tree
+ * @private - private data passed to the callback function
+ *
+ * Recursively walk the page table for the memory area in a VMA, calling
+ * a callback for every bottom-level (PTE) page table.
+ */
+int walk_page_range(struct mm_struct *mm,
+		    unsigned long addr, unsigned long end,
+		    struct mm_walk *walk, void *private)
+{
+	pgd_t *pgd;
+	unsigned long next;
+	int err;
+
+	for (pgd = pgd_offset(mm, addr); addr != end;
+	     pgd++, addr = next) {
+		next = pgd_addr_end(addr, end);
+		if (pgd_none_or_clear_bad(pgd))
+			continue;
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
+	}
+	return 0;
+}

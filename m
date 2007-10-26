Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbXJZQg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbXJZQg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbXJZQgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:36:33 -0400
Received: from waste.org ([66.93.16.53]:56550 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753677AbXJZQgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:36:31 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: Dave Hansen <haveblue@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <1.430487409@selenic.com>
Message-Id: <5.430487409@selenic.com>
Subject: [PATCH 4/12] maps4: introduce a generic page walker
Date: Fri, 26 Oct 2007 11:36:30 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a general page table walker

Signed-off-by: Matt Mackall <mpm@selenic.com>

Index: l/include/linux/mm.h
===================================================================
--- l.orig/include/linux/mm.h	2007-10-26 11:19:36.000000000 -0500
+++ l/include/linux/mm.h	2007-10-26 11:20:37.000000000 -0500
@@ -773,6 +773,28 @@ unsigned long unmap_vmas(struct mmu_gath
 		struct vm_area_struct *start_vma, unsigned long start_addr,
 		unsigned long end_addr, unsigned long *nr_accounted,
 		struct zap_details *);
+
+/**
+ * mm_walk - callbacks for walk_page_range
+ * @pgd_entry: if set, called for each non-empty PGD (top-level) entry
+ * @pud_entry: if set, called for each non-empty PUD (2nd-level) entry
+ * @pmd_entry: if set, called for each non-empty PMD (3rd-level) entry
+ * @pte_entry: if set, called for each non-empty PTE (4th-level) entry
+ * @pte_hole: if set, called for each hole at all levels
+ *
+ * (see walk_page_range for more details)
+ */
+struct mm_walk {
+	int (*pgd_entry)(pgd_t *, unsigned long, unsigned long, void *);
+	int (*pud_entry)(pud_t *, unsigned long, unsigned long, void *);
+	int (*pmd_entry)(pmd_t *, unsigned long, unsigned long, void *);
+	int (*pte_entry)(pte_t *, unsigned long, unsigned long, void *);
+	int (*pte_hole)(unsigned long, unsigned long, void *);
+};
+
+int walk_page_range(const struct mm_struct *, unsigned long addr,
+		    unsigned long end, const struct mm_walk *walk,
+		    void *private);
 void free_pgd_range(struct mmu_gather **tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 void free_pgtables(struct mmu_gather **tlb, struct vm_area_struct *start_vma,
Index: l/mm/Makefile
===================================================================
--- l.orig/mm/Makefile	2007-10-26 11:19:36.000000000 -0500
+++ l/mm/Makefile	2007-10-26 11:20:01.000000000 -0500
@@ -5,7 +5,7 @@
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
-			   vmalloc.o
+			   vmalloc.o pagewalk.o
 
 obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   page_alloc.o page-writeback.o pdflush.o \
Index: l/mm/pagewalk.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ l/mm/pagewalk.c	2007-10-26 11:20:01.000000000 -0500
@@ -0,0 +1,131 @@
+#include <linux/mm.h>
+#include <linux/highmem.h>
+#include <linux/sched.h>
+
+static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+			  const struct mm_walk *walk, void *private)
+{
+	pte_t *pte;
+	int err = 0;
+
+	pte = pte_offset_map(pmd, addr);
+	do {
+		err = walk->pte_entry(pte, addr, addr + PAGE_SIZE, private);
+		if (err)
+		       break;
+	} while (pte++, addr += PAGE_SIZE, addr != end);
+
+	pte_unmap(pte);
+	return err;
+}
+
+static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
+			  const struct mm_walk *walk, void *private)
+{
+	pmd_t *pmd;
+	unsigned long next;
+	int err = 0;
+
+	pmd = pmd_offset(pud, addr);
+	do {
+		next = pmd_addr_end(addr, end);
+		if (pmd_none_or_clear_bad(pmd)) {
+			if (walk->pte_hole)
+				err = walk->pte_hole(addr, next, private);
+			if (err)
+				break;
+			continue;
+		}
+		if (walk->pmd_entry)
+			err = walk->pmd_entry(pmd, addr, next, private);
+		if (!err && walk->pte_entry)
+			err = walk_pte_range(pmd, addr, next, walk, private);
+		if (err)
+			break;
+	} while (pmd++, addr = next, addr != end);
+
+	return err;
+}
+
+static int walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
+			  const struct mm_walk *walk, void *private)
+{
+	pud_t *pud;
+	unsigned long next;
+	int err = 0;
+
+	pud = pud_offset(pgd, addr);
+	do {
+		next = pud_addr_end(addr, end);
+		if (pud_none_or_clear_bad(pud)) {
+			if (walk->pte_hole)
+				err = walk->pte_hole(addr, next, private);
+			if (err)
+				break;
+			continue;
+		}
+		if (walk->pud_entry)
+			err = walk->pud_entry(pud, addr, next, private);
+		if (!err && (walk->pmd_entry || walk->pte_entry))
+			err = walk_pmd_range(pud, addr, next, walk, private);
+		if (err)
+			break;
+	} while (pud++, addr = next, addr != end);
+
+	return err;
+}
+
+/**
+ * walk_page_range - walk a memory map's page tables with a callback
+ * @mm - memory map to walk
+ * @addr - starting address
+ * @end - ending address
+ * @walk - set of callbacks to invoke for each level of the tree
+ * @private - private data passed to the callback function
+ *
+ * Recursively walk the page table for the memory area in a VMA,
+ * calling supplied callbacks. Callbacks are called in-order (first
+ * PGD, first PUD, first PMD, first PTE, second PTE... second PMD,
+ * etc.). If lower-level callbacks are omitted, walking depth is reduced.
+ *
+ * Each callback receives an entry pointer, the start and end of the
+ * associated range, and a caller-supplied private data pointer.
+ *
+ * No locks are taken, but the bottom level iterator will map PTE
+ * directories from highmem if necessary.
+ *
+ * If any callback returns a non-zero value, the walk is aborted and
+ * the return value is propagated back to the caller. Otherwise 0 is returned.
+ */
+int walk_page_range(const struct mm_struct *mm,
+		    unsigned long addr, unsigned long end,
+		    const struct mm_walk *walk, void *private)
+{
+	pgd_t *pgd;
+	unsigned long next;
+	int err = 0;
+
+	if (addr >= end)
+		return err;
+
+	pgd = pgd_offset(mm, addr);
+	do {
+		next = pgd_addr_end(addr, end);
+		if (pgd_none_or_clear_bad(pgd)) {
+			if (walk->pte_hole)
+				err = walk->pte_hole(addr, next, private);
+			if (err)
+				break;
+			continue;
+		}
+		if (walk->pgd_entry)
+			err = walk->pgd_entry(pgd, addr, next, private);
+		if (!err &&
+		    (walk->pud_entry || walk->pmd_entry || walk->pte_entry))
+			err = walk_pud_range(pgd, addr, next, walk, private);
+		if (err)
+			break;
+	} while (pgd++, addr = next, addr != end);
+
+	return err;
+}

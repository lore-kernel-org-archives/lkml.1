Return-Path: <linux-kernel-owner+w=401wt.eu-S932340AbYEOOrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbYEOOrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 10:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756381AbYEOOrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 10:47:08 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:39494 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527AbYEOOrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 10:47:06 -0400
Message-Id: <482C6917.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 15 May 2008 15:47:19 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] remove double indirection on tlb parameter to
	free_pgd_range() & Co
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The double indirection here is not needed anywhere and hence (at least)
confusing.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/ia64/mm/hugetlbpage.c    |    2 +-
 arch/powerpc/mm/hugetlbpage.c |    8 ++++----
 fs/exec.c                     |    4 ++--
 include/asm-ia64/hugetlb.h    |    2 +-
 include/asm-powerpc/hugetlb.h |    2 +-
 include/asm-sh/hugetlb.h      |    2 +-
 include/asm-sparc64/hugetlb.h |    2 +-
 include/asm-x86/hugetlb.h     |    2 +-
 include/linux/mm.h            |    4 +---
 mm/internal.h                 |    3 +++
 mm/memory.c                   |   10 ++++++----
 mm/mmap.c                     |    6 ++++--
 12 files changed, 26 insertions(+), 21 deletions(-)

--- linux-2.6.26-rc2/arch/ia64/mm/hugetlbpage.c	2008-01-24 23:58:37.000000000 +0100
+++ 2.6.26-rc2-free_pgd_range-tlb-param/arch/ia64/mm/hugetlbpage.c	2008-05-15 11:58:09.000000000 +0200
@@ -112,7 +112,7 @@ follow_huge_pmd(struct mm_struct *mm, un
 	return NULL;
 }
 
-void hugetlb_free_pgd_range(struct mmu_gather **tlb,
+void hugetlb_free_pgd_range(struct mmu_gather *tlb,
 			unsigned long addr, unsigned long end,
 			unsigned long floor, unsigned long ceiling)
 {
--- linux-2.6.26-rc2/arch/powerpc/mm/hugetlbpage.c	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.26-rc2-free_pgd_range-tlb-param/arch/powerpc/mm/hugetlbpage.c	2008-05-15 11:57:50.000000000 +0200
@@ -255,7 +255,7 @@ static void hugetlb_free_pud_range(struc
  *
  * Must be called with pagetable lock held.
  */
-void hugetlb_free_pgd_range(struct mmu_gather **tlb,
+void hugetlb_free_pgd_range(struct mmu_gather *tlb,
 			    unsigned long addr, unsigned long end,
 			    unsigned long floor, unsigned long ceiling)
 {
@@ -315,13 +315,13 @@ void hugetlb_free_pgd_range(struct mmu_g
 		return;
 
 	start = addr;
-	pgd = pgd_offset((*tlb)->mm, addr);
+	pgd = pgd_offset(tlb->mm, addr);
 	do {
-		BUG_ON(get_slice_psize((*tlb)->mm, addr) != mmu_huge_psize);
+		BUG_ON(get_slice_psize(tlb->mm, addr) != mmu_huge_psize);
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		hugetlb_free_pud_range(*tlb, pgd, addr, next, floor, ceiling);
+		hugetlb_free_pud_range(tlb, pgd, addr, next, floor, ceiling);
 	} while (pgd++, addr = next, addr != end);
 }
 
--- linux-2.6.26-rc2/fs/exec.c	2008-05-15 14:35:04.000000000 +0200
+++ 2.6.26-rc2-free_pgd_range-tlb-param/fs/exec.c	2008-05-15 11:53:59.000000000 +0200
@@ -537,7 +537,7 @@ static int shift_arg_pages(struct vm_are
 		/*
 		 * when the old and new regions overlap clear from new_end.
 		 */
-		free_pgd_range(&tlb, new_end, old_end, new_end,
+		free_pgd_range(tlb, new_end, old_end, new_end,
 			vma->vm_next ? vma->vm_next->vm_start : 0);
 	} else {
 		/*
@@ -546,7 +546,7 @@ static int shift_arg_pages(struct vm_are
 		 * have constraints on va-space that make this illegal (IA64) -
 		 * for the others its just a little faster.
 		 */
-		free_pgd_range(&tlb, old_start, old_end, new_end,
+		free_pgd_range(tlb, old_start, old_end, new_end,
 			vma->vm_next ? vma->vm_next->vm_start : 0);
 	}
 	tlb_finish_mmu(tlb, new_end, old_end);
--- linux-2.6.26-rc2/include/asm-ia64/hugetlb.h	2008-05-15 14:35:10.000000000 +0200
+++ 2.6.26-rc2-free_pgd_range-tlb-param/include/asm-ia64/hugetlb.h	2008-05-15 16:30:02.000000000 +0200
@@ -4,7 +4,7 @@
 #include <asm/page.h>
 
 
-void hugetlb_free_pgd_range(struct mmu_gather **tlb, unsigned long addr,
+void hugetlb_free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 			    unsigned long end, unsigned long floor,
 			    unsigned long ceiling);
 
--- linux-2.6.26-rc2/include/asm-powerpc/hugetlb.h	2008-05-15 16:29:05.000000000 +0200
+++ 2.6.26-rc2-free_pgd_range-tlb-param/include/asm-powerpc/hugetlb.h	2008-05-15 16:29:21.000000000 +0200
@@ -7,7 +7,7 @@
 int is_hugepage_only_range(struct mm_struct *mm, unsigned long addr,
 			   unsigned long len);
 
-void hugetlb_free_pgd_range(struct mmu_gather **tlb, unsigned long addr,
+void hugetlb_free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 			    unsigned long end, unsigned long floor,
 			    unsigned long ceiling);
 
--- linux-2.6.26-rc2/include/asm-sh/hugetlb.h	2008-05-15 14:35:10.000000000 +0200
+++ 2.6.26-rc2-free_pgd_range-tlb-param/include/asm-sh/hugetlb.h	2008-05-15 16:29:49.000000000 +0200
@@ -26,7 +26,7 @@ static inline int prepare_hugepage_range
 static inline void hugetlb_prefault_arch_hook(struct mm_struct *mm) {
 }
 
-static inline void hugetlb_free_pgd_range(struct mmu_gather **tlb,
+static inline void hugetlb_free_pgd_range(struct mmu_gather *tlb,
 					  unsigned long addr, unsigned long end,
 					  unsigned long floor,
 					  unsigned long ceiling)
--- linux-2.6.26-rc2/include/asm-sparc64/hugetlb.h	2008-05-15 14:35:11.000000000 +0200
+++ 2.6.26-rc2-free_pgd_range-tlb-param/include/asm-sparc64/hugetlb.h	2008-05-15 16:30:43.000000000 +0200
@@ -31,7 +31,7 @@ static inline int prepare_hugepage_range
 	return 0;
 }
 
-static inline void hugetlb_free_pgd_range(struct mmu_gather **tlb,
+static inline void hugetlb_free_pgd_range(struct mmu_gather *tlb,
 					  unsigned long addr, unsigned long end,
 					  unsigned long floor,
 					  unsigned long ceiling)
--- linux-2.6.26-rc2/include/asm-x86/hugetlb.h	2008-05-15 14:35:11.000000000 +0200
+++ 2.6.26-rc2-free_pgd_range-tlb-param/include/asm-x86/hugetlb.h	2008-05-15 16:31:00.000000000 +0200
@@ -26,7 +26,7 @@ static inline int prepare_hugepage_range
 static inline void hugetlb_prefault_arch_hook(struct mm_struct *mm) {
 }
 
-static inline void hugetlb_free_pgd_range(struct mmu_gather **tlb,
+static inline void hugetlb_free_pgd_range(struct mmu_gather *tlb,
 					  unsigned long addr, unsigned long end,
 					  unsigned long floor,
 					  unsigned long ceiling)
--- linux-2.6.26-rc2/include/linux/mm.h	2008-05-15 14:35:11.000000000 +0200
+++ 2.6.26-rc2-free_pgd_range-tlb-param/include/linux/mm.h	2008-05-15 12:01:17.000000000 +0200
@@ -770,10 +770,8 @@ struct mm_walk {
 int walk_page_range(const struct mm_struct *, unsigned long addr,
 		    unsigned long end, const struct mm_walk *walk,
 		    void *private);
-void free_pgd_range(struct mmu_gather **tlb, unsigned long addr,
+void free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
-void free_pgtables(struct mmu_gather **tlb, struct vm_area_struct *start_vma,
-		unsigned long floor, unsigned long ceiling);
 int copy_page_range(struct mm_struct *dst, struct mm_struct *src,
 			struct vm_area_struct *vma);
 void unmap_mapping_range(struct address_space *mapping,
--- linux-2.6.26-rc2/mm/internal.h	2008-05-15 14:35:13.000000000 +0200
+++ 2.6.26-rc2-free_pgd_range-tlb-param/mm/internal.h	2008-05-15 12:01:52.000000000 +0200
@@ -13,6 +13,9 @@
 
 #include <linux/mm.h>
 
+void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
+		unsigned long floor, unsigned long ceiling);
+
 static inline void set_page_count(struct page *page, int v)
 {
 	atomic_set(&page->_count, v);
--- linux-2.6.26-rc2/mm/memory.c	2008-05-15 14:35:13.000000000 +0200
+++ 2.6.26-rc2-free_pgd_range-tlb-param/mm/memory.c	2008-05-15 12:03:17.000000000 +0200
@@ -61,6 +61,8 @@
 #include <linux/swapops.h>
 #include <linux/elf.h>
 
+#include "internal.h"
+
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 /* use the per-pgdat data instead for discontigmem - mbligh */
 unsigned long max_mapnr;
@@ -211,7 +213,7 @@ static inline void free_pud_range(struct
  *
  * Must be called with pagetable lock held.
  */
-void free_pgd_range(struct mmu_gather **tlb,
+void free_pgd_range(struct mmu_gather *tlb,
 			unsigned long addr, unsigned long end,
 			unsigned long floor, unsigned long ceiling)
 {
@@ -262,16 +264,16 @@ void free_pgd_range(struct mmu_gather **
 		return;
 
 	start = addr;
-	pgd = pgd_offset((*tlb)->mm, addr);
+	pgd = pgd_offset(tlb->mm, addr);
 	do {
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		free_pud_range(*tlb, pgd, addr, next, floor, ceiling);
+		free_pud_range(tlb, pgd, addr, next, floor, ceiling);
 	} while (pgd++, addr = next, addr != end);
 }
 
-void free_pgtables(struct mmu_gather **tlb, struct vm_area_struct *vma,
+void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		unsigned long floor, unsigned long ceiling)
 {
 	while (vma) {
--- linux-2.6.26-rc2/mm/mmap.c	2008-05-15 14:35:13.000000000 +0200
+++ 2.6.26-rc2-free_pgd_range-tlb-param/mm/mmap.c	2008-05-15 12:03:25.000000000 +0200
@@ -32,6 +32,8 @@
 #include <asm/tlb.h>
 #include <asm/mmu_context.h>
 
+#include "internal.h"
+
 #ifndef arch_mmap_check
 #define arch_mmap_check(addr, len, flags)	(0)
 #endif
@@ -1756,7 +1758,7 @@ static void unmap_region(struct mm_struc
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, vma, start, end, &nr_accounted, NULL);
 	vm_unacct_memory(nr_accounted);
-	free_pgtables(&tlb, vma, prev? prev->vm_end: FIRST_USER_ADDRESS,
+	free_pgtables(tlb, vma, prev? prev->vm_end: FIRST_USER_ADDRESS,
 				 next? next->vm_start: 0);
 	tlb_finish_mmu(tlb, start, end);
 }
@@ -2056,7 +2058,7 @@ void exit_mmap(struct mm_struct *mm)
 	/* Use -1 here to ensure all VMAs in the mm are unmapped */
 	end = unmap_vmas(&tlb, vma, 0, -1, &nr_accounted, NULL);
 	vm_unacct_memory(nr_accounted);
-	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, 0);
+	free_pgtables(tlb, vma, FIRST_USER_ADDRESS, 0);
 	tlb_finish_mmu(tlb, 0, end);
 
 	/*



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbZEKI1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbZEKI1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 04:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbZEKI1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 04:27:24 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:62650 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755342AbZEKI1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 04:27:22 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-IronPort-AV: E=Sophos;i="4.40,327,1238968800";   d="scan'208";a="11399163"
From: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
To: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/4]: affinity-on-next-touch
Date: Mon, 11 May 2009 10:27:24 +0200
Organization: Chair for Operating Systems, RWTH Aachen University
Message-id: <000d01c9d212$4fa61ae0$eef250a0$@rwth-aachen.de>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcnSEk9M1vJlI77nRBejRQws14Gh6g==
Content-language: de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Patch 1/4]: Extend the system call madvise with a new parameter
MADV_ACCESS_LWP (the same as used in Solaris). The specified memory area
then uses "affinity-on-next-touch".  In this case, madvise_access_lwp
protects the memory area from read and write access. To avoid unnecessary
list operations, the patch changes the permissions only in the page table
entries and does not update the list of VMAs. Beside this, the system call
madvise set also the new "untouched bit" of the "page" record.


include/asm-generic/mman.h |    1 +
include/linux/page-flags.h |    7 +++
mm/madvise.c               |  126
++++++++++++++++++++++++++++++++++++++++++++
3 files changed, 134 insertions(+), 0 deletions(-)


diff --git a/include/asm-generic/mman.h b/include/asm-generic/mman.h
index 5e3dde2..62fdc8c 100644
--- a/include/asm-generic/mman.h
+++ b/include/asm-generic/mman.h
@@ -29,6 +29,7 @@
 #define MADV_SEQUENTIAL        2               /* expect sequential page
references */
 #define MADV_WILLNEED  3               /* will need these pages */
 #define MADV_DONTNEED  4               /* don't need these pages */
+#define MADV_ACCESS_LWP        5               /* the next LWP will access
these pages at most */
 
 /* common parameters: try to keep these consistent across architectures */
 #define MADV_REMOVE    9               /* remove these pages & resources */
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 62214c7..e701c5a 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -104,6 +104,10 @@ enum pageflags {
 #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
        PG_uncached,            /* Page has been mapped as uncached */
 #endif
+#ifdef CONFIG_AFFINITY_ON_NEXT_TOUCH
+        PG_untouched,           /* migrate page on next touch */
+#endif
+
        __NR_PAGEFLAGS,
 
        /* Filesystems */
@@ -225,6 +229,9 @@ PAGEFLAG(OwnerPriv1, owner_priv_1)
TESTCLEARFLAG(OwnerPriv1, owner_priv_1)
  */
 TESTPAGEFLAG(Writeback, writeback) TESTSCFLAG(Writeback, writeback)
 __PAGEFLAG(Buddy, buddy)
+#ifdef CONFIG_AFFINITY_ON_NEXT_TOUCH
+PAGEFLAG(Untouched, untouched) TESTCLEARFLAG(Untouched, untouched)
+#endif
 PAGEFLAG(MappedToDisk, mappedtodisk)
 
 /* PG_readahead is only used for file reads; PG_reclaim is only for writes
*/
diff --git a/mm/madvise.c b/mm/madvise.c
index 36d6ea2..ae0b745 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -11,6 +11,11 @@
 #include <linux/mempolicy.h>
 #include <linux/hugetlb.h>
 #include <linux/sched.h>
+#include <linux/mmu_notifier.h>
+#include <linux/migrate.h>
+#include <linux/swap.h>
+#include <asm/cacheflush.h>
+#include <asm/tlbflush.h>

 /*
  * Any behaviour which results in changes to the vma->vm_flags needs to
@@ -23,6 +28,7 @@ static int madvise_need_mmap_write(int behavior)
        case MADV_REMOVE:
        case MADV_WILLNEED:
        case MADV_DONTNEED:
+       case MADV_ACCESS_LWP:
                return 0;
        default:
                /* be safe, default to 1. list exceptions explicitly */
@@ -216,6 +222,118 @@ static long madvise_remove(struct vm_area_struct *vma,
        return error;
 }
 
+#ifdef CONFIG_AFFINITY_ON_NEXT_TOUCH
+static inline void change_pte_range(struct vm_area_struct *vma,
+               struct mm_struct *mm, pmd_t *pmd, unsigned long addr,
+               unsigned long end, pgprot_t newprot)
+{
+       pte_t *pte, ptent;
+       struct page *page;
+       spinlock_t *ptl;
+
+       pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+       arch_enter_lazy_mmu_mode();
+       do {
+               if (pte_none(*pte))
+                       continue;
+               if (!pte_present(*pte))
+                       continue;
+
+               page = (struct page*) vm_normal_page(vma, addr, *pte);
+               if (!page 
+                 || PageReserved(page)
+                 || !trylock_page(page))
+                       continue;
+               SetPageUntouched(page);
+
+               ptent = ptep_modify_prot_start(mm, addr, pte);
+               ptent = pte_modify(ptent, newprot);
+               ptep_modify_prot_commit(mm, addr, pte, ptent);
+       } while (pte++, addr += PAGE_SIZE, addr != end);
+       arch_leave_lazy_mmu_mode();
+       pte_unmap_unlock(pte - 1, ptl);
+}
+
+static inline void change_pmd_range(struct vm_area_struct *vma,
+               struct mm_struct *mm, pud_t *pud, unsigned long addr,
+               unsigned long end, pgprot_t newprot)
+{
+       pmd_t *pmd;
+       unsigned long next;
+
+       pmd = pmd_offset(pud, addr);
+       do {
+               next = pmd_addr_end(addr, end);
+               if (pmd_none_or_clear_bad(pmd))
+                       continue;
+               change_pte_range(vma, mm, pmd, addr, next, newprot);
+       } while (pmd++, addr = next, addr != end);
+}
+
+static inline void change_pud_range(struct vm_area_struct *vma,
+               struct mm_struct *mm, pgd_t *pgd, unsigned long addr,
+               unsigned long end, pgprot_t newprot)
+{
+       pud_t *pud;
+       unsigned long next;
+
+       pud = pud_offset(pgd, addr);
+       do {
+               next = pud_addr_end(addr, end);
+               if (pud_none_or_clear_bad(pud))
+                       continue;
+               change_pmd_range(vma, mm, pud, addr, next, newprot);
+       } while (pud++, addr = next, addr != end);
+}
+
+/*
+ * To realize the page placement strategy "affinity-on-next-touch", the 
+ * access to the pages will be denied. If an access violation occurs, 
+ * the page fault handler migrates the page to the current node and 
+ * restores the original access permissions. The "untouched" bit is set,
+ * to signalize the page fault handler that this page uses the page 
+ * placement strategy "affinity-on-next-touch".
+ *
+ * NOTE: On a UMA architecture is such a page placement strategy
irrelevant. 
+ * Therefore, on such architectures we doesn't change the access
permissions.
+ */
+static long madvise_access_lwp(struct vm_area_struct *vma,
+                               unsigned long start, unsigned long end)
+{
+       struct mm_struct * mm = vma->vm_mm;
+       pgd_t *pgd;
+       pgprot_t newprot;
+       unsigned long addr, next;
+
+       /* On UMA architectures is no page migration necessary. */
+       if (num_online_nodes() == 1)
+               return 0;
+
+       if (!vma_migratable(vma))
+               return -EINVAL;
+
+       newprot = protection_map[PROT_NONE &
+                               (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)];
+       
+       mmu_notifier_invalidate_range_start(mm, start, end);
+       addr = start;
+       pgd = pgd_offset(mm, start);
+       flush_cache_range(vma, start, end);
+       do {
+               next = pgd_addr_end(addr, end);
+               if (pgd_none_or_clear_bad(pgd))
+                       continue;
+               change_pud_range(vma, mm, pgd, addr, next, newprot);
+       } while (pgd++, addr = next, addr != end);
+       flush_tlb_range(vma, start, end);
+       mmu_notifier_invalidate_range_end(mm, start, end);
+
+       lru_add_drain();
+
+       return 0;
+}
+#endif
+
 static long
 madvise_vma(struct vm_area_struct *vma, struct vm_area_struct **prev,
                unsigned long start, unsigned long end, int behavior)
@@ -246,6 +364,12 @@ madvise_vma(struct vm_area_struct *vma, struct
vm_area_struct **prev,
                error = madvise_dontneed(vma, prev, start, end);
                break;
 
+#ifdef CONFIG_AFFINITY_ON_NEXT_TOUCH
+       case MADV_ACCESS_LWP:
+               error = madvise_access_lwp(vma, start, end);
+               break;
+#endif
+
        default:
                error = -EINVAL;
                break;
@@ -277,6 +401,8 @@ madvise_vma(struct vm_area_struct *vma, struct
vm_area_struct **prev,
  *             so the kernel can free resources associated with it.
  *  MADV_REMOVE - the application wants to free up the given range of
  *             pages and associated backing store.
+ *  MADV_ACCESS_LWP - the next LWP, which touch the specified address
+ *              range, will access it heavily
  *
  * return values:
  *  zero    - success


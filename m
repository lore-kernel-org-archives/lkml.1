Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbZEKI2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbZEKI2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 04:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZEKI1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 04:27:34 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:62757 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755333AbZEKI1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 04:27:33 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-IronPort-AV: E=Sophos;i="4.40,327,1238968800";   d="scan'208";a="11399182"
From: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
To: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/4]: affinity-on-next-touch
Date: Mon, 11 May 2009 10:27:33 +0200
Organization: Chair for Operating Systems, RWTH Aachen University
Message-id: <000f01c9d212$554b6ae0$ffe240a0$@rwth-aachen.de>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcnSElT14b+7OsX2RZWoLI+wcqXYOA==
Content-language: de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Patch 3/4]: If the "untouched" bit is set, mprotect isn't permitted to
change the permission in the page table entry. By using of
"affinity-on-next-touch", the access permission will be set by the pte fault
handler.


mm/mprotect.c |   39 +++++++++++++++++++++++++++------------
1 files changed, 27 insertions(+), 12 deletions(-)


diff --git a/mm/mprotect.c b/mm/mprotect.c
index 258197b..815aa9b 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -35,9 +35,9 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot,
pgprot_t newprot)
 }
 #endif
 
-static void change_pte_range(struct mm_struct *mm, pmd_t *pmd,
-               unsigned long addr, unsigned long end, pgprot_t newprot,
-               int dirty_accountable)
+static void change_pte_range(struct vm_area_struct *vma, 
+               struct mm_struct *mm, pmd_t *pmd, unsigned long addr, 
+               unsigned long end, pgprot_t newprot, int dirty_accountable)
 {
        pte_t *pte, oldpte;
        spinlock_t *ptl;
@@ -48,6 +48,19 @@ static void change_pte_range(struct mm_struct *mm, pmd_t
*pmd,
                oldpte = *pte;
                if (pte_present(oldpte)) {
                        pte_t ptent;
+#ifdef CONFIG_AFFINITY_ON_NEXT_TOUCH
+                       if (vma_migratable(vma)) {
+                               struct page *page = vm_normal_page(vma,
addr,
+                                                       oldpte);
+                               /* 
+                                * By using affinity-on-next-touch the page 
+                                * fault handler will set the new page 
+                                * permissions! 
+                                */
+                               if (page && PageUntouched(page))
+                                       continue;
+                       }
+#endif
 
                        ptent = ptep_modify_prot_start(mm, addr, pte);
                        ptent = pte_modify(ptent, newprot);
@@ -78,9 +91,9 @@ static void change_pte_range(struct mm_struct *mm, pmd_t
*pmd,
        pte_unmap_unlock(pte - 1, ptl);
 }

-static inline void change_pmd_range(struct mm_struct *mm, pud_t *pud,
-               unsigned long addr, unsigned long end, pgprot_t newprot,
-               int dirty_accountable)
+static inline void change_pmd_range(struct vm_area_struct *vma, 
+               struct mm_struct *mm, pud_t *pud, unsigned long addr, 
+               unsigned long end, pgprot_t newprot, int dirty_accountable)
 {
        pmd_t *pmd;
        unsigned long next;
@@ -90,13 +103,14 @@ static inline void change_pmd_range(struct mm_struct
*mm, pud_t *pud,
                next = pmd_addr_end(addr, end);
                if (pmd_none_or_clear_bad(pmd))
                        continue;
-               change_pte_range(mm, pmd, addr, next, newprot,
dirty_accountable);
+               change_pte_range(vma, mm, pmd, addr, next, newprot, 
+                               dirty_accountable);
        } while (pmd++, addr = next, addr != end);
 }
 
-static inline void change_pud_range(struct mm_struct *mm, pgd_t *pgd,
-               unsigned long addr, unsigned long end, pgprot_t newprot,
-               int dirty_accountable)
+static inline void change_pud_range(struct vm_area_struct *vma, 
+               struct mm_struct *mm, pgd_t *pgd, unsigned long addr, 
+               unsigned long end, pgprot_t newprot, int dirty_accountable)
 {
        pud_t *pud;
        unsigned long next;
@@ -106,7 +120,8 @@ static inline void change_pud_range(struct mm_struct
*mm, pgd_t *pgd,
                next = pud_addr_end(addr, end);
                if (pud_none_or_clear_bad(pud))
                        continue;
-               change_pmd_range(mm, pud, addr, next, newprot,
dirty_accountable);
+               change_pmd_range(vma, mm, pud, addr, next, newprot, 
+                               dirty_accountable);
        } while (pud++, addr = next, addr != end);
 }
 
@@ -126,7 +141,7 @@ static void change_protection(struct vm_area_struct
*vma,
                next = pgd_addr_end(addr, end);
                if (pgd_none_or_clear_bad(pgd))
                        continue;
-               change_pud_range(mm, pgd, addr, next, newprot,
dirty_accountable);
+               change_pud_range(vma, mm, pgd, addr, next, newprot,
dirty_accountable);
        } while (pgd++, addr = next, addr != end);
        flush_tlb_range(vma, start, end);
 }


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758980AbYDDQvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980AbYDDQvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 12:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951AbYDDQvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 12:51:10 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:25628 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYDDQvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 12:51:08 -0400
Subject: [PATCH 2/3] hugetlbfs: add missing TLB flush to hugetlb_cow()
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       schwidefsky@de.ibm.com, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Tony Luck <tony.luck@intel.com>, Paul Mackerras <paulus@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <1207327534.4605.18.camel@localhost.localdomain>
References: <1207327534.4605.18.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 18:51:06 +0200
Message-Id: <1207327866.4605.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 2/3] hugetlbfs: add missing TLB flush to hugetlb_cow()

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

A cow break on a hugetlbfs page with page_count > 1 will set a new pte
with set_huge_pte_at(), w/o any tlb flush operation. The old pte will
remain in the tlb and subsequent write access to the page will result
in a page fault loop, for as long as it may take until the tlb is
flushed from somewhere else.
This patch introduces an architecture-specific huge_ptep_clear_flush()
function, which is called before the the set_huge_pte_at() in
hugetlb_cow().

ATTENTION: This is just a nop on all architectures for now, the s390
implementation will come with our large page patch later. Other
architectures should define their own huge_ptep_clear_flush() if needed.

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---

 include/asm-ia64/hugetlb.h    |    5 +++++
 include/asm-powerpc/hugetlb.h |    5 +++++
 include/asm-sh/hugetlb.h      |    5 +++++
 include/asm-sparc64/hugetlb.h |    5 +++++
 include/asm-x86/hugetlb.h     |    5 +++++
 mm/hugetlb.c                  |    1 +
 6 files changed, 26 insertions(+)

Index: linux-2.6.25-rc8/mm/hugetlb.c
===================================================================
--- linux-2.6.25-rc8.orig/mm/hugetlb.c
+++ linux-2.6.25-rc8/mm/hugetlb.c
@@ -875,6 +875,7 @@ static int hugetlb_cow(struct mm_struct 
 	ptep = huge_pte_offset(mm, address & HPAGE_MASK);
 	if (likely(pte_same(*ptep, pte))) {
 		/* Break COW */
+		huge_ptep_clear_flush(vma, address, ptep);
 		set_huge_pte_at(mm, address, ptep,
 				make_huge_pte(vma, new_page, 1));
 		/* Make the old page be freed below */
Index: linux-2.6.25-rc8/include/asm-ia64/hugetlb.h
===================================================================
--- linux-2.6.25-rc8.orig/include/asm-ia64/hugetlb.h
+++ linux-2.6.25-rc8/include/asm-ia64/hugetlb.h
@@ -34,4 +34,9 @@ static inline pte_t huge_ptep_get_and_cl
 	return ptep_get_and_clear(mm, addr, ptep);
 }
 
+static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
+					 unsigned long addr, pte_t *ptep)
+{
+}
+
 #endif /* _ASM_IA64_HUGETLB_H */
Index: linux-2.6.25-rc8/include/asm-powerpc/hugetlb.h
===================================================================
--- linux-2.6.25-rc8.orig/include/asm-powerpc/hugetlb.h
+++ linux-2.6.25-rc8/include/asm-powerpc/hugetlb.h
@@ -34,4 +34,9 @@ static inline void hugetlb_prefault_arch
 {
 }
 
+static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
+					 unsigned long addr, pte_t *ptep)
+{
+}
+
 #endif /* _ASM_POWERPC_HUGETLB_H */
Index: linux-2.6.25-rc8/include/asm-sh/hugetlb.h
===================================================================
--- linux-2.6.25-rc8.orig/include/asm-sh/hugetlb.h
+++ linux-2.6.25-rc8/include/asm-sh/hugetlb.h
@@ -46,4 +46,9 @@ static inline pte_t huge_ptep_get_and_cl
 	return ptep_get_and_clear(mm, addr, ptep);
 }
 
+static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
+					 unsigned long addr, pte_t *ptep)
+{
+}
+
 #endif /* _ASM_SH_HUGETLB_H */
Index: linux-2.6.25-rc8/include/asm-sparc64/hugetlb.h
===================================================================
--- linux-2.6.25-rc8.orig/include/asm-sparc64/hugetlb.h
+++ linux-2.6.25-rc8/include/asm-sparc64/hugetlb.h
@@ -39,4 +39,9 @@ static inline void hugetlb_free_pgd_rang
 	free_pgd_range(tlb, addr, end, floor, ceiling);
 }
 
+static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
+					 unsigned long addr, pte_t *ptep)
+{
+}
+
 #endif /* _ASM_SPARC64_HUGETLB_H */
Index: linux-2.6.25-rc8/include/asm-x86/hugetlb.h
===================================================================
--- linux-2.6.25-rc8.orig/include/asm-x86/hugetlb.h
+++ linux-2.6.25-rc8/include/asm-x86/hugetlb.h
@@ -46,4 +46,9 @@ static inline pte_t huge_ptep_get_and_cl
 	return ptep_get_and_clear(mm, addr, ptep);
 }
 
+static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
+					 unsigned long addr, pte_t *ptep)
+{
+}
+
 #endif /* _ASM_X86_HUGETLB_H */



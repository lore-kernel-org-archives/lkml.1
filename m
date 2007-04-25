Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbXDYWI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbXDYWI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbXDYWI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:08:28 -0400
Received: from gw.goop.org ([64.81.55.164]:33955 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485AbXDYWI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:08:27 -0400
Message-ID: <462FD179.6070802@goop.org>
Date: Wed, 25 Apr 2007 15:08:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: For debugging, make the initial page table setup
 less forgiving.
References: <200704132149.l3DLnvUY012097@tazenda.hos.anvin.org>	<20070425044813.f83dde4e.akpm@linux-foundation.org>	<462F73A0.40003@zytor.com> <m1irbks5qa.fsf@ebiederm.dsl.xmission.com>	<462F9B64.3020107@goop.org> <m1wt00qnwg.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1wt00qnwg.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Nope.  It's not overwriting anything.

This should fix it.

Subject: x86: fix PSE pagetable construction

When constructing the initial pagetable in pagetable_init, make sure
that non-PSE pmds are updated to PSE ones.

This moves the definition of pmd_huge() out of the hugetlbfs files
into pgtable.h.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>

---
 arch/i386/mm/hugetlbpage.c   |    6 +-----
 arch/i386/mm/init.c          |    2 +-
 include/asm-i386/pgtable.h   |    2 +-
 include/asm-x86_64/pgtable.h |    1 +
 include/linux/hugetlb.h      |    2 --
 5 files changed, 4 insertions(+), 9 deletions(-)

===================================================================
--- a/arch/i386/mm/hugetlbpage.c
+++ b/arch/i386/mm/hugetlbpage.c
@@ -183,6 +183,7 @@ follow_huge_addr(struct mm_struct *mm, u
 	return page;
 }
 
+#undef pmd_huge
 int pmd_huge(pmd_t pmd)
 {
 	return 0;
@@ -201,11 +202,6 @@ follow_huge_addr(struct mm_struct *mm, u
 follow_huge_addr(struct mm_struct *mm, unsigned long address, int write)
 {
 	return ERR_PTR(-EINVAL);
-}
-
-int pmd_huge(pmd_t pmd)
-{
-	return !!(pmd_val(pmd) & _PAGE_PSE);
 }
 
 struct page *
===================================================================
--- a/arch/i386/mm/init.c
+++ b/arch/i386/mm/init.c
@@ -172,7 +172,7 @@ static void __init kernel_physical_mappi
 			/* Map with big pages if possible, otherwise create normal page tables. */
 			if (cpu_has_pse) {
 				unsigned int address2 = (pfn + PTRS_PER_PTE - 1) * PAGE_SIZE + PAGE_OFFSET + PAGE_SIZE-1;
-				if (!pmd_present(*pmd)) {
+				if (!pmd_present(*pmd) || !pmd_huge(*pmd)) {
 					if (is_kernel_text(address) || is_kernel_text(address2))
 						set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE_EXEC));
 					else
===================================================================
--- a/include/asm-i386/pgtable.h
+++ b/include/asm-i386/pgtable.h
@@ -211,7 +211,7 @@ extern unsigned long pg0[];
 #define pmd_none(x)	(!(unsigned long)pmd_val(x))
 #define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
 #define	pmd_bad(x)	((pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
-
+#define pmd_huge(x)	((pmd_val(x) & _PAGE_PSE) != 0)
 
 #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))
 
===================================================================
--- a/include/asm-x86_64/pgtable.h
+++ b/include/asm-x86_64/pgtable.h
@@ -352,6 +352,7 @@ static inline int pmd_large(pmd_t pte) {
 			pmd_index(address))
 #define pmd_none(x)	(!pmd_val(x))
 #define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
+#define pmd_huge(x)	((pmd_val(x) & _PAGE_PSE) != 0)
 #define pmd_clear(xp)	do { set_pmd(xp, __pmd(0)); } while (0)
 #define pfn_pmd(nr,prot) (__pmd(((nr) << PAGE_SHIFT) | pgprot_val(prot)))
 #define pmd_pfn(x)  ((pmd_val(x) & __PHYSICAL_MASK) >> PAGE_SHIFT)
===================================================================
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -41,7 +41,6 @@ struct page *follow_huge_addr(struct mm_
 			      int write);
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 				pmd_t *pmd, int write);
-int pmd_huge(pmd_t pmd);
 void hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot);
 
@@ -114,7 +113,6 @@ static inline unsigned long hugetlb_tota
 #define hugetlb_report_node_meminfo(n, buf)	0
 #define follow_huge_pmd(mm, addr, pmd, write)	NULL
 #define prepare_hugepage_range(addr,len,pgoff)	(-EINVAL)
-#define pmd_huge(x)	0
 #define is_hugepage_only_range(mm, addr, len)	0
 #define hugetlb_free_pgd_range(tlb, addr, end, floor, ceiling) ({BUG(); 0; })
 #define hugetlb_fault(mm, vma, addr, write)	({ BUG(); 0; })





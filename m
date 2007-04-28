Return-Path: <linux-kernel-owner+w=401wt.eu-S1031103AbXD1F5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031103AbXD1F5z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 01:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031107AbXD1F5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 01:57:54 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34345 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031103AbXD1F5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 01:57:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: fix PSE pagetable construction
References: <4632AE54.7030200@goop.org>
Date: Fri, 27 Apr 2007 23:56:40 -0600
In-Reply-To: <4632AE54.7030200@goop.org> (Jeremy Fitzhardinge's message of
	"Fri, 27 Apr 2007 19:15:48 -0700")
Message-ID: <m1zm4tghyf.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> When constructing the initial pagetable in pagetable_init, make sure
> that non-PSE pmds are updated to PSE ones.  This fixes a bug in the
> paravirt pagetable init code, which otherwise tries to avoid overwrite
> existing mappings.
>
> This moves the definition of pmd_huge() out of the hugetlbfs files
> into pgtable.h.
>
> [ I know Eric would like to make larger changes to the way
>   pagetable init works, but this patch is the minimal fix to an
>   existing bug. ]

My preference would be for whoever had:
paravirt_ops-hooks-to-set-up-initial-pagetable.patch

queued to drop it until we can get a version that doesn't break early
page table setup.

Your partial fix still leaves the real page tables in a partially
incorrect state, and even if we removed your changes from the PSE
path we still can wind up not failing to set _PAGE_NX in the
appropriate places on 4K pages.

I have tried to be constructive and suggest how we can fix this
cleanly.

Short of that this is what I see needing to happen to fix the
above patches changes to arch/i386/mm/init.c.

Eric


...

Subject: [PATCH] i386: During page table initialization always set the leaf page table entries.

If we don't set the leaf page table entries it is quite possible that
we will inherit and incorrect page table entry from the initial boot
page table setup in head.S.  So we need to redo the effort here.

I don't know what to do about hypervisors like Xen that require
their page tables to be read only, as our identity mapped page
table entries currently violate that requirement.  All I know
if the kernel doesn't work properly on native hardware it is a bug.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/i386/mm/init.c |   52 +++++++++++++++++++-------------------------------
 1 files changed, 20 insertions(+), 32 deletions(-)

diff --git a/arch/i386/mm/init.c b/arch/i386/mm/init.c
index b77a43c..dbe16f6 100644
--- a/arch/i386/mm/init.c
+++ b/arch/i386/mm/init.c
@@ -63,18 +63,18 @@ static pmd_t * __init one_md_table_init(pgd_t *pgd)
 	pmd_t *pmd_table;
 		
 #ifdef CONFIG_X86_PAE
-	pmd_table = (pmd_t *) alloc_bootmem_low_pages(PAGE_SIZE);
-
-	paravirt_alloc_pd(__pa(pmd_table) >> PAGE_SHIFT);
-	set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
-	pud = pud_offset(pgd, 0);
-	if (pmd_table != pmd_offset(pud, 0)) 
-		BUG();
-#else
+	if (!(pgd_val(*pgd) & _PAGE_PRESENT)) {
+		pmd_table = (pmd_t *) alloc_bootmem_low_pages(PAGE_SIZE);
+
+		paravirt_alloc_pd(__pa(pmd_table) >> PAGE_SHIFT);
+		set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
+		pud = pud_offset(pgd, 0);
+		if (pmd_table != pmd_offset(pud, 0))
+			BUG();
+	}
+#endif
 	pud = pud_offset(pgd, 0);
 	pmd_table = pmd_offset(pud, 0);
-#endif
-
 	return pmd_table;
 }
 
@@ -84,7 +84,7 @@ static pmd_t * __init one_md_table_init(pgd_t *pgd)
  */
 static pte_t * __init one_page_table_init(pmd_t *pmd)
 {
-	if (pmd_none(*pmd)) {
+	if (!(pmd_val(*pmd) & _PAGE_PRESENT)) {
 		pte_t *page_table = (pte_t *) alloc_bootmem_low_pages(PAGE_SIZE);
 
 		paravirt_alloc_pt(__pa(page_table) >> PAGE_SHIFT);
@@ -109,7 +109,6 @@ static pte_t * __init one_page_table_init(pmd_t *pmd)
 static void __init page_table_range_init (unsigned long start, unsigned long end, pgd_t *pgd_base)
 {
 	pgd_t *pgd;
-	pud_t *pud;
 	pmd_t *pmd;
 	int pgd_idx, pmd_idx;
 	unsigned long vaddr;
@@ -120,13 +119,10 @@ static void __init page_table_range_init (unsigned long start, unsigned long end
 	pgd = pgd_base + pgd_idx;
 
 	for ( ; (pgd_idx < PTRS_PER_PGD) && (vaddr != end); pgd++, pgd_idx++) {
-		if (!(pgd_val(*pgd) & _PAGE_PRESENT))
-			one_md_table_init(pgd);
-		pud = pud_offset(pgd, vaddr);
-		pmd = pmd_offset(pud, vaddr);
+		pmd = one_md_table_init(pgd);
+		pmd = pmd + pmd_index(vaddr);
 		for (; (pmd_idx < PTRS_PER_PMD) && (vaddr != end); pmd++, pmd_idx++) {
-			if (pmd_none(*pmd)) 
-				one_page_table_init(pmd);
+			one_page_table_init(pmd);
 
 			vaddr += PMD_SIZE;
 		}
@@ -159,11 +155,7 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 	pfn = 0;
 
 	for (; pgd_idx < PTRS_PER_PGD; pgd++, pgd_idx++) {
-		if (!(pgd_val(*pgd) & _PAGE_PRESENT))
-			pmd = one_md_table_init(pgd);
-		else
-			pmd = pmd_offset(pud_offset(pgd, PAGE_OFFSET), PAGE_OFFSET);
-
+		pmd = one_md_table_init(pgd);
 		if (pfn >= max_low_pfn)
 			continue;
 		for (pmd_idx = 0; pmd_idx < PTRS_PER_PMD && pfn < max_low_pfn; pmd++, pmd_idx++) {
@@ -172,12 +164,11 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 			/* Map with big pages if possible, otherwise create normal page tables. */
 			if (cpu_has_pse) {
 				unsigned int address2 = (pfn + PTRS_PER_PTE - 1) * PAGE_SIZE + PAGE_OFFSET + PAGE_SIZE-1;
-				if (!pmd_present(*pmd)) {
-					if (is_kernel_text(address) || is_kernel_text(address2))
-						set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE_EXEC));
-					else
-						set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE));
-				}
+				if (is_kernel_text(address) || is_kernel_text(address2))
+					set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE_EXEC));
+				else
+					set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE));
+
 				pfn += PTRS_PER_PTE;
 			} else {
 				pte = one_page_table_init(pmd);
@@ -185,9 +176,6 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 				for (pte_ofs = 0;
 				     pte_ofs < PTRS_PER_PTE && pfn < max_low_pfn;
 				     pte++, pfn++, pte_ofs++, address += PAGE_SIZE) {
-					if (pte_present(*pte))
-						continue;
-
 					if (is_kernel_text(address))
 						set_pte(pte, pfn_pte(pfn, PAGE_KERNEL_EXEC));
 					else
-- 
1.5.1.1.181.g2de0


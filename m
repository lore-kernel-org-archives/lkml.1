Return-Path: <linux-kernel-owner+w=401wt.eu-S1763969AbXGFURy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763969AbXGFURy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 16:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762181AbXGFURr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 16:17:47 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:40278 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762135AbXGFURq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 16:17:46 -0400
Date: Fri, 6 Jul 2007 13:16:25 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, virtualization@lists.osdl.org
Subject: [PATCH] VMI: remove CONFIG_DEBUG_PAGE_TYPE and associated
	bitrotted code
Message-ID: <20070706201625.GT4306@sequoia.sous-sol.org>
References: <Pine.LNX.4.64.0707060847470.23786@localhost.localdomain> <468E890A.1070504@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468E890A.1070504@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Stefan Richter (stefanr@s5r6.in-berlin.de) wrote:
> > -#ifdef CONFIG_DEBUG_PAGE_TYPE
> > +#if 0 /* debug page type */
<snip>
> This misnamed CONFIG_DEBUG_PAGE_TYPE (it's not a Kconfig variable) has
> about 120 lines debug code dangling on it.  So, replacing it by #if 0
> will hopefully motivate a kind janitor to send a removal patch for that
> debug code eventually.  I don't do so just now because that code went in
> between 2.6.20 and 2.6.21-rc1, i.e. not so long ago.

This is Zach's code, his final call.  I know it was pretty useful early
on, and used to be an actual Kconfig option for VMI.  However, it's
completely disconnected; the setup call to vmi_apply_boot_page_allocations
isn't merged and the page->type field isn't either (no surprise on that),
and some of the VMI_PAGE_ constants have changed names.  Clearly, it is
ripe for bitrot (already has !CONFIG_NEED_MULTIPLE_NODES dependency,
dunno if VMI has the same limitation).  It definitely should not have
a misleading Kconfig name.  I'd nuke it all rather than #if 0.

thanks,
-chris
--

Subject: [PATCH] VMI: remove CONFIG_DEBUG_PAGE_TYPE and associated bitrotted code

From: Chris Wright <chrisw@sous-sol.org>

Remove the poorly named (non Kconfig) CONFIG_DEBUG_PAGE_TYPE compile
time conditional as well as the associated bitrotted debug code.

Cc: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Zachary Amsden <zach@vmware.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

diff --git a/arch/i386/kernel/vmi.c b/arch/i386/kernel/vmi.c
index c12720d..45c55e4 100644
--- a/arch/i386/kernel/vmi.c
+++ b/arch/i386/kernel/vmi.c
@@ -235,109 +235,6 @@ static void vmi_nop(void)
 {
 }
 
-#ifdef CONFIG_DEBUG_PAGE_TYPE
-
-#ifdef CONFIG_X86_PAE
-#define MAX_BOOT_PTS (2048+4+1)
-#else
-#define MAX_BOOT_PTS (1024+1)
-#endif
-
-/*
- * During boot, mem_map is not yet available in paging_init, so stash
- * all the boot page allocations here.
- */
-static struct {
-	u32 pfn;
-	int type;
-} boot_page_allocations[MAX_BOOT_PTS];
-static int num_boot_page_allocations;
-static int boot_allocations_applied;
-
-void vmi_apply_boot_page_allocations(void)
-{
-	int i;
-	BUG_ON(!mem_map);
-	for (i = 0; i < num_boot_page_allocations; i++) {
-		struct page *page = pfn_to_page(boot_page_allocations[i].pfn);
-		page->type = boot_page_allocations[i].type;
-		page->type = boot_page_allocations[i].type &
-				~(VMI_PAGE_ZEROED | VMI_PAGE_CLONE);
-	}
-	boot_allocations_applied = 1;
-}
-
-static void record_page_type(u32 pfn, int type)
-{
-	BUG_ON(num_boot_page_allocations >= MAX_BOOT_PTS);
-	boot_page_allocations[num_boot_page_allocations].pfn = pfn;
-	boot_page_allocations[num_boot_page_allocations].type = type;
-	num_boot_page_allocations++;
-}
-
-static void check_zeroed_page(u32 pfn, int type, struct page *page)
-{
-	u32 *ptr;
-	int i;
-	int limit = PAGE_SIZE / sizeof(int);
-
-	if (page_address(page))
-		ptr = (u32 *)page_address(page);
-	else
-		ptr = (u32 *)__va(pfn << PAGE_SHIFT);
-	/*
-	 * When cloning the root in non-PAE mode, only the userspace
-	 * pdes need to be zeroed.
-	 */
-	if (type & VMI_PAGE_CLONE)
-		limit = USER_PTRS_PER_PGD;
-	for (i = 0; i < limit; i++)
-		BUG_ON(ptr[i]);
-}
-
-/*
- * We stash the page type into struct page so we can verify the page
- * types are used properly.
- */
-static void vmi_set_page_type(u32 pfn, int type)
-{
-	/* PAE can have multiple roots per page - don't track */
-	if (PTRS_PER_PMD > 1 && (type & VMI_PAGE_PDP))
-		return;
-
-	if (boot_allocations_applied) {
-		struct page *page = pfn_to_page(pfn);
-		if (type != VMI_PAGE_NORMAL)
-			BUG_ON(page->type);
-		else
-			BUG_ON(page->type == VMI_PAGE_NORMAL);
-		page->type = type & ~(VMI_PAGE_ZEROED | VMI_PAGE_CLONE);
-		if (type & VMI_PAGE_ZEROED)
-			check_zeroed_page(pfn, type, page);
-	} else {
-		record_page_type(pfn, type);
-	}
-}
-
-static void vmi_check_page_type(u32 pfn, int type)
-{
-	/* PAE can have multiple roots per page - skip checks */
-	if (PTRS_PER_PMD > 1 && (type & VMI_PAGE_PDP))
-		return;
-
-	type &= ~(VMI_PAGE_ZEROED | VMI_PAGE_CLONE);
-	if (boot_allocations_applied) {
-		struct page *page = pfn_to_page(pfn);
-		BUG_ON((page->type ^ type) & VMI_PAGE_PAE);
-		BUG_ON(type == VMI_PAGE_NORMAL && page->type);
-		BUG_ON((type & page->type) == 0);
-	}
-}
-#else
-#define vmi_set_page_type(p,t) do { } while (0)
-#define vmi_check_page_type(p,t) do { } while (0)
-#endif
-
 #ifdef CONFIG_HIGHPTE
 static void *vmi_kmap_atomic_pte(struct page *page, enum km_type type)
 {
@@ -364,7 +261,6 @@ static void *vmi_kmap_atomic_pte(struct page *page, enum km_type type)
 
 static void vmi_allocate_pt(u32 pfn)
 {
-	vmi_set_page_type(pfn, VMI_PAGE_L1);
 	vmi_ops.allocate_page(pfn, VMI_PAGE_L1, 0, 0, 0);
 }
 
@@ -375,27 +271,22 @@ static void vmi_allocate_pd(u32 pfn)
 	 * It is called only for swapper_pg_dir, which already has
 	 * data on it.
 	 */
- 	vmi_set_page_type(pfn, VMI_PAGE_L2);
 	vmi_ops.allocate_page(pfn, VMI_PAGE_L2, 0, 0, 0);
 }
 
 static void vmi_allocate_pd_clone(u32 pfn, u32 clonepfn, u32 start, u32 count)
 {
- 	vmi_set_page_type(pfn, VMI_PAGE_L2 | VMI_PAGE_CLONE);
-	vmi_check_page_type(clonepfn, VMI_PAGE_L2);
 	vmi_ops.allocate_page(pfn, VMI_PAGE_L2 | VMI_PAGE_CLONE, clonepfn, start, count);
 }
 
 static void vmi_release_pt(u32 pfn)
 {
 	vmi_ops.release_page(pfn, VMI_PAGE_L1);
-	vmi_set_page_type(pfn, VMI_PAGE_NORMAL);
 }
 
 static void vmi_release_pd(u32 pfn)
 {
 	vmi_ops.release_page(pfn, VMI_PAGE_L2);
-	vmi_set_page_type(pfn, VMI_PAGE_NORMAL);
 }
 
 /*
@@ -419,26 +310,22 @@ static void vmi_release_pd(u32 pfn)
 
 static void vmi_update_pte(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
-	vmi_check_page_type(__pa(ptep) >> PAGE_SHIFT, VMI_PAGE_PTE);
 	vmi_ops.update_pte(ptep, vmi_flags_addr(mm, addr, VMI_PAGE_PT, 0));
 }
 
 static void vmi_update_pte_defer(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
-	vmi_check_page_type(__pa(ptep) >> PAGE_SHIFT, VMI_PAGE_PTE);
 	vmi_ops.update_pte(ptep, vmi_flags_addr_defer(mm, addr, VMI_PAGE_PT, 0));
 }
 
 static void vmi_set_pte(pte_t *ptep, pte_t pte)
 {
 	/* XXX because of set_pmd_pte, this can be called on PT or PD layers */
-	vmi_check_page_type(__pa(ptep) >> PAGE_SHIFT, VMI_PAGE_PTE | VMI_PAGE_PD);
 	vmi_ops.set_pte(pte, ptep, VMI_PAGE_PT);
 }
 
 static void vmi_set_pte_at(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
 {
-	vmi_check_page_type(__pa(ptep) >> PAGE_SHIFT, VMI_PAGE_PTE);
 	vmi_ops.set_pte(pte, ptep, vmi_flags_addr(mm, addr, VMI_PAGE_PT, 0));
 }
 
@@ -446,10 +333,8 @@ static void vmi_set_pmd(pmd_t *pmdp, pmd_t pmdval)
 {
 #ifdef CONFIG_X86_PAE
 	const pte_t pte = { pmdval.pmd, pmdval.pmd >> 32 };
-	vmi_check_page_type(__pa(pmdp) >> PAGE_SHIFT, VMI_PAGE_PMD);
 #else
 	const pte_t pte = { pmdval.pud.pgd.pgd };
-	vmi_check_page_type(__pa(pmdp) >> PAGE_SHIFT, VMI_PAGE_PGD);
 #endif
 	vmi_ops.set_pte(pte, (pte_t *)pmdp, VMI_PAGE_PD);
 }
@@ -471,7 +356,6 @@ static void vmi_set_pte_atomic(pte_t *ptep, pte_t pteval)
 
 static void vmi_set_pte_present(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
 {
-	vmi_check_page_type(__pa(ptep) >> PAGE_SHIFT, VMI_PAGE_PTE);
 	vmi_ops.set_pte(pte, ptep, vmi_flags_addr_defer(mm, addr, VMI_PAGE_PT, 1));
 }
 
@@ -479,21 +363,18 @@ static void vmi_set_pud(pud_t *pudp, pud_t pudval)
 {
 	/* Um, eww */
 	const pte_t pte = { pudval.pgd.pgd, pudval.pgd.pgd >> 32 };
-	vmi_check_page_type(__pa(pudp) >> PAGE_SHIFT, VMI_PAGE_PGD);
 	vmi_ops.set_pte(pte, (pte_t *)pudp, VMI_PAGE_PDP);
 }
 
 static void vmi_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
 	const pte_t pte = { 0 };
-	vmi_check_page_type(__pa(ptep) >> PAGE_SHIFT, VMI_PAGE_PTE);
 	vmi_ops.set_pte(pte, ptep, vmi_flags_addr(mm, addr, VMI_PAGE_PT, 0));
 }
 
 static void vmi_pmd_clear(pmd_t *pmd)
 {
 	const pte_t pte = { 0 };
-	vmi_check_page_type(__pa(pmd) >> PAGE_SHIFT, VMI_PAGE_PMD);
 	vmi_ops.set_pte(pte, (pte_t *)pmd, VMI_PAGE_PD);
 }
 #endif
diff --git a/include/asm-i386/vmi.h b/include/asm-i386/vmi.h
index eb8bd89..70d7d6f 100644
--- a/include/asm-i386/vmi.h
+++ b/include/asm-i386/vmi.h
@@ -225,7 +225,6 @@ struct pci_header {
 /* Function prototypes for bootstrapping */
 extern void vmi_init(void);
 extern void vmi_bringup(void);
-extern void vmi_apply_boot_page_allocations(void);
 
 /* State needed to start an application processor in an SMP system. */
 struct vmi_ap_state {

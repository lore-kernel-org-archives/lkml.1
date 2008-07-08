Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbYGHXWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbYGHXWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757764AbYGHXOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:54 -0400
Received: from gw.goop.org ([64.81.55.164]:51210 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376AbYGHXOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:45 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 31 of 55] xen32: create initial mappings like 64-bit
X-Mercurial-Node: b8a0df589661d76a82478c58fc648a1ebe357e9c
Message-Id: <b8a0df589661d76a8247.1215554813@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rearrange the pagetable initialization to share code with the 64-bit
kernel.  Rather than deferring anything to pagetable_setup_start, just
set up an initial pagetable in swapper_pg_dir early at startup, and
create an additional 8MB of physical memory mappings.  This matches
the native head_32.S mappings to a large degree, and allows the rest
of the pagetable setup to continue without much Xen vs. native
difference.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |  130 ++++++++++++++++++----------------------------
 1 file changed, 52 insertions(+), 78 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -854,50 +854,6 @@
 
 static __init void xen_pagetable_setup_start(pgd_t *base)
 {
-#ifdef CONFIG_X86_32
-	pgd_t *xen_pgd = (pgd_t *)xen_start_info->pt_base;
-	int i;
-
-	init_mm.pgd = base;
-	/*
-	 * copy top-level of Xen-supplied pagetable into place.  This
-	 * is a stand-in while we copy the pmd pages.
-	 */
-	memcpy(base, xen_pgd, PTRS_PER_PGD * sizeof(pgd_t));
-
-	/*
-	 * For PAE, need to allocate new pmds, rather than
-	 * share Xen's, since Xen doesn't like pmd's being
-	 * shared between address spaces.
-	 */
-	for (i = 0; i < PTRS_PER_PGD; i++) {
-		if (pgd_val_ma(xen_pgd[i]) & _PAGE_PRESENT) {
-			pmd_t *pmd = (pmd_t *)alloc_bootmem_low_pages(PAGE_SIZE);
-
-			memcpy(pmd, (void *)pgd_page_vaddr(xen_pgd[i]),
-			       PAGE_SIZE);
-
-			make_lowmem_page_readonly(pmd);
-
-			set_pgd(&base[i], __pgd(1 + __pa(pmd)));
-		} else
-			pgd_clear(&base[i]);
-	}
-
-	/* make sure zero_page is mapped RO so we can use it in pagetables */
-	make_lowmem_page_readonly(empty_zero_page);
-	make_lowmem_page_readonly(base);
-	/*
-	 * Switch to new pagetable.  This is done before
-	 * pagetable_init has done anything so that the new pages
-	 * added to the table can be prepared properly for Xen.
-	 */
-	xen_write_cr3(__pa(base));
-
-	/* Unpin initial Xen pagetable */
-	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE,
-			  PFN_DOWN(__pa(xen_start_info->pt_base)));
-#endif	/* CONFIG_X86_32 */
 }
 
 void xen_setup_shared_info(void)
@@ -936,12 +892,6 @@
 	pv_mmu_ops.set_pte = xen_set_pte;
 
 	xen_setup_shared_info();
-
-#ifdef CONFIG_X86_32
-	/* Actually pin the pagetable down, but we can't set PG_pinned
-	   yet because the page structures don't exist yet. */
-	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(base)));
-#endif
 }
 
 static __init void xen_post_allocator_init(void)
@@ -1299,14 +1249,17 @@
 #endif	/* CONFIG_X86_32 */
 }
 
-#ifdef CONFIG_X86_64
 /*
  * Like __va(), but returns address in the kernel mapping (which is
  * all we have until the physical memory mapping has been set up.
  */
 static void *__ka(phys_addr_t paddr)
 {
+#ifdef CONFIG_X86_64
 	return (void *)(paddr + __START_KERNEL_map);
+#else
+	return __va(paddr);
+#endif
 }
 
 /* Convert a machine address to physical address */
@@ -1326,6 +1279,7 @@
 	return __ka(m2p(maddr));
 }
 
+#ifdef CONFIG_X86_64
 static void walk(pgd_t *pgd, unsigned long addr)
 {
 	unsigned l4idx = pgd_index(addr);
@@ -1356,29 +1310,19 @@
 	xen_raw_printk("  l1: %016lx\n", l1.pte);
 	xen_raw_printk("      %016lx\n", pte_val(l1));
 }
+#endif
 
 static void set_page_prot(void *addr, pgprot_t prot)
 {
 	unsigned long pfn = __pa(addr) >> PAGE_SHIFT;
 	pte_t pte = pfn_pte(pfn, prot);
 
-	xen_raw_printk("addr=%p pfn=%lx mfn=%lx prot=%016x pte=%016x\n",
+	xen_raw_printk("addr=%p pfn=%lx mfn=%lx prot=%016llx pte=%016llx\n",
 		       addr, pfn, get_phys_to_machine(pfn),
 		       pgprot_val(prot), pte.pte);
 
 	if (HYPERVISOR_update_va_mapping((unsigned long)addr, pte, 0))
 		BUG();
-}
-
-static void convert_pfn_mfn(void *v)
-{
-	pte_t *pte = v;
-	int i;
-
-	/* All levels are converted the same way, so just treat them
-	   as ptes. */
-	for(i = 0; i < PTRS_PER_PTE; i++)
-		pte[i] = xen_make_pte(pte[i].pte);
 }
 
 /*
@@ -1388,7 +1332,7 @@
  */
 static pte_t level1_ident_pgt[PTRS_PER_PTE * 4] __page_aligned_bss;
 
-static __init void xen_map_identity_early(unsigned long max_pfn)
+static __init void xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
 {
 	unsigned pmdidx, pteidx;
 	unsigned ident_pte;
@@ -1399,11 +1343,9 @@
 	for(pmdidx = 0; pmdidx < PTRS_PER_PMD && pfn < max_pfn; pmdidx++) {
 		pte_t *pte_page;
 
-		BUG_ON(level2_ident_pgt[pmdidx].pmd != level2_kernel_pgt[pmdidx].pmd);
-
 		/* Reuse or allocate a page of ptes */
-		if (pmd_present(level2_ident_pgt[pmdidx]))
-			pte_page = m2v(level2_ident_pgt[pmdidx].pmd);
+		if (pmd_present(pmd[pmdidx]))
+			pte_page = m2v(pmd[pmdidx].pmd);
 		else {
 			/* Check for free pte pages */
 			if (ident_pte == ARRAY_SIZE(level1_ident_pgt))
@@ -1412,9 +1354,7 @@
 			pte_page = &level1_ident_pgt[ident_pte];
 			ident_pte += PTRS_PER_PTE;
 
-			/* Install new l1 in l2(s) */
-			level2_ident_pgt[pmdidx] = __pmd(__pa(pte_page) | _PAGE_TABLE);
-			level2_kernel_pgt[pmdidx] = level2_ident_pgt[pmdidx];
+			pmd[pmdidx] = __pmd(__pa(pte_page) | _PAGE_TABLE);
 		}
 
 		/* Install mappings */
@@ -1434,6 +1374,20 @@
 
 	for(pteidx = 0; pteidx < ident_pte; pteidx += PTRS_PER_PTE)
 		set_page_prot(&level1_ident_pgt[pteidx], PAGE_KERNEL_RO);
+
+	set_page_prot(pmd, PAGE_KERNEL_RO);
+}
+
+#ifdef CONFIG_X86_64
+static void convert_pfn_mfn(void *v)
+{
+	pte_t *pte = v;
+	int i;
+
+	/* All levels are converted the same way, so just treat them
+	   as ptes. */
+	for(i = 0; i < PTRS_PER_PTE; i++)
+		pte[i] = xen_make_pte(pte[i].pte);
 }
 
 /*
@@ -1471,18 +1425,18 @@
 	memcpy(level2_fixmap_pgt, l2, sizeof(pmd_t) * PTRS_PER_PMD);
 
 	/* Set up identity map */
-	xen_map_identity_early(max_pfn);
+	xen_map_identity_early(level2_ident_pgt, max_pfn);
 
 	/* Make pagetable pieces RO */
 	set_page_prot(init_level4_pgt, PAGE_KERNEL_RO);
 	set_page_prot(level3_ident_pgt, PAGE_KERNEL_RO);
 	set_page_prot(level3_kernel_pgt, PAGE_KERNEL_RO);
-	set_page_prot(level2_ident_pgt, PAGE_KERNEL_RO);
 	set_page_prot(level2_kernel_pgt, PAGE_KERNEL_RO);
 	set_page_prot(level2_fixmap_pgt, PAGE_KERNEL_RO);
 
 	/* Pin down new L4 */
-	pin_pagetable_pfn(MMUEXT_PIN_L4_TABLE, PFN_DOWN(__pa_symbol(init_level4_pgt)));
+	pin_pagetable_pfn(MMUEXT_PIN_L4_TABLE,
+			  PFN_DOWN(__pa_symbol(init_level4_pgt)));
 
 	/* Unpin Xen-provided one */
 	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
@@ -1498,17 +1452,37 @@
 
 	return pgd;
 }
-#else
+#else	/* !CONFIG_X86_64 */
+static pmd_t level2_kernel_pgt[PTRS_PER_PMD] __page_aligned_bss;
+
 static __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 {
+	pmd_t *kernel_pmd;
+
 	init_pg_tables_start = __pa(pgd);
 	init_pg_tables_end = __pa(pgd) + xen_start_info->nr_pt_frames*PAGE_SIZE;
 	max_pfn_mapped = PFN_DOWN(init_pg_tables_end + 512*1024);
 
-	x86_write_percpu(xen_cr3, __pa(pgd));
-	x86_write_percpu(xen_current_cr3, __pa(pgd));
+	kernel_pmd = m2v(pgd[KERNEL_PGD_BOUNDARY].pgd);
+	memcpy(level2_kernel_pgt, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);
 
-	return pgd;
+	xen_map_identity_early(level2_kernel_pgt, max_pfn);
+
+	memcpy(swapper_pg_dir, pgd, sizeof(pgd_t) * PTRS_PER_PGD);
+	set_pgd(&swapper_pg_dir[KERNEL_PGD_BOUNDARY],
+			__pgd(__pa(level2_kernel_pgt) | _PAGE_PRESENT));
+
+	set_page_prot(level2_kernel_pgt, PAGE_KERNEL_RO);
+	set_page_prot(swapper_pg_dir, PAGE_KERNEL_RO);
+	set_page_prot(empty_zero_page, PAGE_KERNEL_RO);
+
+	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
+
+	xen_write_cr3(__pa(swapper_pg_dir));
+
+	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(swapper_pg_dir)));
+
+	return swapper_pg_dir;
 }
 #endif	/* CONFIG_X86_64 */
 



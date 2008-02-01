Return-Path: <linux-kernel-owner+w=401wt.eu-S932333AbYBBJE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333AbYBBJE1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760142AbYBBJBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:01:35 -0500
Received: from gw.goop.org ([64.81.55.164]:59451 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758009AbYBBJBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:01:33 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 5] x86: rename paravirt_alloc_pt etc after the pagetable
	structure
X-Mercurial-Node: 44a3946ecc7501ab34bc5f39068039edab2541da
Message-Id: <44a3946ecc7501ab34bc.1201908324@localhost>
In-Reply-To: <patchbomb.1201908323@localhost>
Date: Fri, 01 Feb 2008 15:25:24 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>,
       Zach Amsden <zach@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename (alloc|release)_(pt|pd) to pte/pmd to explicitly match the name
of the appropriate pagetable level structure.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/kernel/paravirt.c |   10 +++++-----
 arch/x86/kernel/vmi_32.c   |   20 ++++++++++----------
 arch/x86/mm/init_32.c      |    6 +++---
 arch/x86/mm/ioremap.c      |    2 +-
 arch/x86/mm/pageattr.c     |    2 +-
 arch/x86/mm/pgtable.c      |   16 ++++++++--------
 arch/x86/xen/enlighten.c   |   30 +++++++++++++++---------------
 include/asm-x86/paravirt.h |   32 ++++++++++++++++----------------
 include/asm-x86/pgalloc.h  |   16 ++++++++--------
 9 files changed, 67 insertions(+), 67 deletions(-)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -382,11 +382,11 @@
 	.flush_tlb_single = native_flush_tlb_single,
 	.flush_tlb_others = native_flush_tlb_others,
 
-	.alloc_pt = paravirt_nop,
-	.alloc_pd = paravirt_nop,
-	.alloc_pd_clone = paravirt_nop,
-	.release_pt = paravirt_nop,
-	.release_pd = paravirt_nop,
+	.alloc_pte = paravirt_nop,
+	.alloc_pmd = paravirt_nop,
+	.alloc_pmd_clone = paravirt_nop,
+	.release_pte = paravirt_nop,
+	.release_pmd = paravirt_nop,
 
 	.set_pte = native_set_pte,
 	.set_pte_at = native_set_pte_at,
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -392,13 +392,13 @@
 }
 #endif
 
-static void vmi_allocate_pt(struct mm_struct *mm, u32 pfn)
+static void vmi_allocate_pte(struct mm_struct *mm, u32 pfn)
 {
 	vmi_set_page_type(pfn, VMI_PAGE_L1);
 	vmi_ops.allocate_page(pfn, VMI_PAGE_L1, 0, 0, 0);
 }
 
-static void vmi_allocate_pd(struct mm_struct *mm, u32 pfn)
+static void vmi_allocate_pmd(struct mm_struct *mm, u32 pfn)
 {
  	/*
 	 * This call comes in very early, before mem_map is setup.
@@ -409,20 +409,20 @@
 	vmi_ops.allocate_page(pfn, VMI_PAGE_L2, 0, 0, 0);
 }
 
-static void vmi_allocate_pd_clone(u32 pfn, u32 clonepfn, u32 start, u32 count)
+static void vmi_allocate_pmd_clone(u32 pfn, u32 clonepfn, u32 start, u32 count)
 {
  	vmi_set_page_type(pfn, VMI_PAGE_L2 | VMI_PAGE_CLONE);
 	vmi_check_page_type(clonepfn, VMI_PAGE_L2);
 	vmi_ops.allocate_page(pfn, VMI_PAGE_L2 | VMI_PAGE_CLONE, clonepfn, start, count);
 }
 
-static void vmi_release_pt(u32 pfn)
+static void vmi_release_pte(u32 pfn)
 {
 	vmi_ops.release_page(pfn, VMI_PAGE_L1);
 	vmi_set_page_type(pfn, VMI_PAGE_NORMAL);
 }
 
-static void vmi_release_pd(u32 pfn)
+static void vmi_release_pmd(u32 pfn)
 {
 	vmi_ops.release_page(pfn, VMI_PAGE_L2);
 	vmi_set_page_type(pfn, VMI_PAGE_NORMAL);
@@ -871,15 +871,15 @@
 
 	vmi_ops.allocate_page = vmi_get_function(VMI_CALL_AllocatePage);
 	if (vmi_ops.allocate_page) {
-		pv_mmu_ops.alloc_pt = vmi_allocate_pt;
-		pv_mmu_ops.alloc_pd = vmi_allocate_pd;
-		pv_mmu_ops.alloc_pd_clone = vmi_allocate_pd_clone;
+		pv_mmu_ops.alloc_pte = vmi_allocate_pte;
+		pv_mmu_ops.alloc_pmd = vmi_allocate_pmd;
+		pv_mmu_ops.alloc_pmd_clone = vmi_allocate_pmd_clone;
 	}
 
 	vmi_ops.release_page = vmi_get_function(VMI_CALL_ReleasePage);
 	if (vmi_ops.release_page) {
-		pv_mmu_ops.release_pt = vmi_release_pt;
-		pv_mmu_ops.release_pd = vmi_release_pd;
+		pv_mmu_ops.release_pte = vmi_release_pte;
+		pv_mmu_ops.release_pmd = vmi_release_pmd;
 	}
 
 	/* Set linear is needed in all cases */
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -68,7 +68,7 @@
 	if (!(pgd_val(*pgd) & _PAGE_PRESENT)) {
 		pmd_table = (pmd_t *) alloc_bootmem_low_pages(PAGE_SIZE);
 
-		paravirt_alloc_pd(&init_mm, __pa(pmd_table) >> PAGE_SHIFT);
+		paravirt_alloc_pmd(&init_mm, __pa(pmd_table) >> PAGE_SHIFT);
 		set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
 		pud = pud_offset(pgd, 0);
 		BUG_ON(pmd_table != pmd_offset(pud, 0));
@@ -97,7 +97,7 @@
 				(pte_t *)alloc_bootmem_low_pages(PAGE_SIZE);
 		}
 
-		paravirt_alloc_pt(&init_mm, __pa(page_table) >> PAGE_SHIFT);
+		paravirt_alloc_pte(&init_mm, __pa(page_table) >> PAGE_SHIFT);
 		set_pmd(pmd, __pmd(__pa(page_table) | _PAGE_TABLE));
 		BUG_ON(page_table != pte_offset_kernel(pmd, 0));
 	}
@@ -374,7 +374,7 @@
 
 		pte_clear(NULL, va, pte);
 	}
-	paravirt_alloc_pd(&init_mm, __pa(base) >> PAGE_SHIFT);
+	paravirt_alloc_pmd(&init_mm, __pa(base) >> PAGE_SHIFT);
 }
 
 void __init native_pagetable_setup_done(pgd_t *base)
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -332,7 +332,7 @@
 
 	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
 	pmd_clear(pmd);
-	paravirt_release_pt(__pa(bm_pte) >> PAGE_SHIFT);
+	paravirt_release_pte(__pa(bm_pte) >> PAGE_SHIFT);
 	__flush_tlb_all();
 }
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -249,7 +249,7 @@
 	address = __pa(address);
 	addr = address & LARGE_PAGE_MASK;
 	pbase = (pte_t *)page_address(base);
-	paravirt_alloc_pt(&init_mm, page_to_pfn(base));
+	paravirt_alloc_pte(&init_mm, page_to_pfn(base));
 
 	pgprot_val(ref_prot) &= ~_PAGE_NX;
 	for (i = 0; i < PTRS_PER_PTE; i++, addr += PAGE_SIZE)
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -20,14 +20,14 @@
 
 void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
 {
-	paravirt_release_pt(page_to_pfn(pte));
+	paravirt_release_pte(page_to_pfn(pte));
 	tlb_remove_page(tlb, pte);
 }
 
 #if PAGETABLE_LEVELS > 2
 void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 {
-	paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
+	paravirt_release_pmd(__pa(pmd) >> PAGE_SHIFT);
 	tlb_remove_page(tlb, virt_to_page(pmd));
 }
 
@@ -117,10 +117,10 @@
 		clone_pgd_range(pgd + USER_PTRS_PER_PGD,
 				swapper_pg_dir + USER_PTRS_PER_PGD,
 				KERNEL_PGD_PTRS);
-		paravirt_alloc_pd_clone(__pa(pgd) >> PAGE_SHIFT,
-					__pa(swapper_pg_dir) >> PAGE_SHIFT,
-					USER_PTRS_PER_PGD,
-					KERNEL_PGD_PTRS);
+		paravirt_alloc_pmd_clone(__pa(pgd) >> PAGE_SHIFT,
+					 __pa(swapper_pg_dir) >> PAGE_SHIFT,
+					 USER_PTRS_PER_PGD,
+					 KERNEL_PGD_PTRS);
 	}
 
 	/* list required to sync kernel mapping updates */
@@ -161,7 +161,7 @@
 
 			pgdp[i] = native_make_pgd(0);
 
-			paravirt_release_pd(pgd_val(pgd) >> PAGE_SHIFT);
+			paravirt_release_pmd(pgd_val(pgd) >> PAGE_SHIFT);
 			pmd_free(pmd);
 		}
 	}
@@ -219,7 +219,7 @@
 {
 	pgd_t *pgd = quicklist_alloc(0, GFP_KERNEL, pgd_ctor);
 
-	mm->pgd = pgd;		/* so that alloc_pd can use it */
+	mm->pgd = pgd;		/* so that alloc_pmd can use it */
 
 	if (pgd && !pgd_prepopulate_pmd(mm, pgd)) {
 		quicklist_free(0, pgd_dtor, pgd);
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -652,15 +652,15 @@
 
 /* Early in boot, while setting up the initial pagetable, assume
    everything is pinned. */
-static __init void xen_alloc_pt_init(struct mm_struct *mm, u32 pfn)
+static __init void xen_alloc_pte_init(struct mm_struct *mm, u32 pfn)
 {
 	BUG_ON(mem_map);	/* should only be used early */
 	make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
 }
 
-/* Early release_pt assumes that all pts are pinned, since there's
+/* Early release_pte assumes that all pts are pinned, since there's
    only init_mm and anything attached to that is pinned. */
-static void xen_release_pt_init(u32 pfn)
+static void xen_release_pte_init(u32 pfn)
 {
 	make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
 }
@@ -693,18 +693,18 @@
 	}
 }
 
-static void xen_alloc_pt(struct mm_struct *mm, u32 pfn)
+static void xen_alloc_pte(struct mm_struct *mm, u32 pfn)
 {
 	xen_alloc_ptpage(mm, pfn, MMUEXT_PIN_L1_TABLE);
 }
 
-static void xen_alloc_pd(struct mm_struct *mm, u32 pfn)
+static void xen_alloc_pmd(struct mm_struct *mm, u32 pfn)
 {
 	xen_alloc_ptpage(mm, pfn, MMUEXT_PIN_L2_TABLE);
 }
 
 /* This should never happen until we're OK to use struct page */
-static void xen_release_pt(u32 pfn)
+static void xen_release_pte(u32 pfn)
 {
 	struct page *page = pfn_to_page(pfn);
 
@@ -804,10 +804,10 @@
 {
 	/* This will work as long as patching hasn't happened yet
 	   (which it hasn't) */
-	pv_mmu_ops.alloc_pt = xen_alloc_pt;
-	pv_mmu_ops.alloc_pd = xen_alloc_pd;
-	pv_mmu_ops.release_pt = xen_release_pt;
-	pv_mmu_ops.release_pd = xen_release_pt;
+	pv_mmu_ops.alloc_pte = xen_alloc_pte;
+	pv_mmu_ops.alloc_pmd = xen_alloc_pmd;
+	pv_mmu_ops.release_pte = xen_release_pte;
+	pv_mmu_ops.release_pmd = xen_release_pte;
 	pv_mmu_ops.set_pte = xen_set_pte;
 
 	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
@@ -1030,11 +1030,11 @@
 	.pte_update = paravirt_nop,
 	.pte_update_defer = paravirt_nop,
 
-	.alloc_pt = xen_alloc_pt_init,
-	.release_pt = xen_release_pt_init,
-	.alloc_pd = xen_alloc_pt_init,
-	.alloc_pd_clone = paravirt_nop,
-	.release_pd = xen_release_pt_init,
+	.alloc_pte = xen_alloc_pte_init,
+	.release_pte = xen_release_pte_init,
+	.alloc_pmd = xen_alloc_pte_init,
+	.alloc_pmd_clone = paravirt_nop,
+	.release_pmd = xen_release_pte_init,
 
 #ifdef CONFIG_HIGHPTE
 	.kmap_atomic_pte = xen_kmap_atomic_pte,
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -220,11 +220,11 @@
 				 unsigned long va);
 
 	/* Hooks for allocating/releasing pagetable pages */
-	void (*alloc_pt)(struct mm_struct *mm, u32 pfn);
-	void (*alloc_pd)(struct mm_struct *mm, u32 pfn);
-	void (*alloc_pd_clone)(u32 pfn, u32 clonepfn, u32 start, u32 count);
-	void (*release_pt)(u32 pfn);
-	void (*release_pd)(u32 pfn);
+	void (*alloc_pte)(struct mm_struct *mm, u32 pfn);
+	void (*alloc_pmd)(struct mm_struct *mm, u32 pfn);
+	void (*alloc_pmd_clone)(u32 pfn, u32 clonepfn, u32 start, u32 count);
+	void (*release_pte)(u32 pfn);
+	void (*release_pmd)(u32 pfn);
 
 	/* Pagetable manipulation functions */
 	void (*set_pte)(pte_t *ptep, pte_t pteval);
@@ -894,28 +894,28 @@
 	PVOP_VCALL3(pv_mmu_ops.flush_tlb_others, &cpumask, mm, va);
 }
 
-static inline void paravirt_alloc_pt(struct mm_struct *mm, unsigned pfn)
+static inline void paravirt_alloc_pte(struct mm_struct *mm, unsigned pfn)
 {
-	PVOP_VCALL2(pv_mmu_ops.alloc_pt, mm, pfn);
+	PVOP_VCALL2(pv_mmu_ops.alloc_pte, mm, pfn);
 }
-static inline void paravirt_release_pt(unsigned pfn)
+static inline void paravirt_release_pte(unsigned pfn)
 {
-	PVOP_VCALL1(pv_mmu_ops.release_pt, pfn);
+	PVOP_VCALL1(pv_mmu_ops.release_pte, pfn);
 }
 
-static inline void paravirt_alloc_pd(struct mm_struct *mm, unsigned pfn)
+static inline void paravirt_alloc_pmd(struct mm_struct *mm, unsigned pfn)
 {
-	PVOP_VCALL2(pv_mmu_ops.alloc_pd, mm, pfn);
+	PVOP_VCALL2(pv_mmu_ops.alloc_pmd, mm, pfn);
 }
 
-static inline void paravirt_alloc_pd_clone(unsigned pfn, unsigned clonepfn,
-					   unsigned start, unsigned count)
+static inline void paravirt_alloc_pmd_clone(unsigned pfn, unsigned clonepfn,
+					    unsigned start, unsigned count)
 {
-	PVOP_VCALL4(pv_mmu_ops.alloc_pd_clone, pfn, clonepfn, start, count);
+	PVOP_VCALL4(pv_mmu_ops.alloc_pmd_clone, pfn, clonepfn, start, count);
 }
-static inline void paravirt_release_pd(unsigned pfn)
+static inline void paravirt_release_pmd(unsigned pfn)
 {
-	PVOP_VCALL1(pv_mmu_ops.release_pd, pfn);
+	PVOP_VCALL1(pv_mmu_ops.release_pmd, pfn);
 }
 
 #ifdef CONFIG_HIGHPTE
diff --git a/include/asm-x86/pgalloc.h b/include/asm-x86/pgalloc.h
--- a/include/asm-x86/pgalloc.h
+++ b/include/asm-x86/pgalloc.h
@@ -8,11 +8,11 @@
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
-#define paravirt_alloc_pt(mm, pfn) do { } while (0)
-#define paravirt_alloc_pd(mm, pfn) do { } while (0)
-#define paravirt_alloc_pd_clone(pfn, clonepfn, start, count) do { } while (0)
-#define paravirt_release_pt(pfn) do { } while (0)
-#define paravirt_release_pd(pfn) do { } while (0)
+#define paravirt_alloc_pte(mm, pfn) do { } while (0)
+#define paravirt_alloc_pmd(mm, pfn) do { } while (0)
+#define paravirt_alloc_pmd_clone(pfn, clonepfn, start, count) do { } while (0)
+#define paravirt_release_pte(pfn) do { } while (0)
+#define paravirt_release_pmd(pfn) do { } while (0)
 #endif
 
 /*
@@ -43,7 +43,7 @@
 static inline void pmd_populate_kernel(struct mm_struct *mm,
 				       pmd_t *pmd, pte_t *pte)
 {
-	paravirt_alloc_pt(mm, __pa(pte) >> PAGE_SHIFT);
+	paravirt_alloc_pte(mm, __pa(pte) >> PAGE_SHIFT);
 	set_pmd(pmd, __pmd(__pa(pte) | _PAGE_TABLE));
 }
 
@@ -52,7 +52,7 @@
 {
 	unsigned long pfn = page_to_pfn(pte);
 
-	paravirt_alloc_pt(mm, pfn);
+	paravirt_alloc_pte(mm, pfn);
 	set_pmd(pmd, __pmd(((pteval_t)pfn << PAGE_SHIFT) | _PAGE_TABLE));
 }
 
@@ -72,7 +72,7 @@
 
 static inline void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd)
 {
-	paravirt_alloc_pd(mm, __pa(pmd) >> PAGE_SHIFT);
+	paravirt_alloc_pmd(mm, __pa(pmd) >> PAGE_SHIFT);
 
 	/* Note: almost everything apart from _PAGE_PRESENT is
 	   reserved at the pmd (PDPT) level. */



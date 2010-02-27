Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030949Ab0B0Xwk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 18:52:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:48635 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030939Ab0B0Xwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 18:52:38 -0500
Date: Sat, 27 Feb 2010 23:52:11 GMT
From: tip-bot for Ian Campbell <ian.campbell@citrix.com>
Cc: jeremy@goop.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, ian.campbell@citrix.com, akataria@vmware.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jeremy@goop.org, ian.campbell@citrix.com, tglx@linutronix.de,
       akataria@vmware.com, mingo@elte.hu
In-Reply-To: <1267204562-11844-3-git-send-email-ian.campbell@citrix.com>
References: <1267204562-11844-3-git-send-email-ian.campbell@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, paravirt: Remove kmap_atomic_pte paravirt op.
Message-ID: <tip-dad52fc01161afcb8798c609e009aed4d104927f@git.kernel.org>
Git-Commit-ID: dad52fc01161afcb8798c609e009aed4d104927f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 27 Feb 2010 23:52:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dad52fc01161afcb8798c609e009aed4d104927f
Gitweb:     http://git.kernel.org/tip/dad52fc01161afcb8798c609e009aed4d104927f
Author:     Ian Campbell <ian.campbell@citrix.com>
AuthorDate: Fri, 26 Feb 2010 17:16:02 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 27 Feb 2010 14:41:35 -0800

x86, paravirt: Remove kmap_atomic_pte paravirt op.

Now that both Xen and VMI disable allocations of PTE pages from high
memory this paravirt op serves no further purpose.

This effectively reverts ce6234b5 "add kmap_atomic_pte for mapping
highpte pages".

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
LKML-Reference: <1267204562-11844-3-git-send-email-ian.campbell@citrix.com>
Acked-by: Alok Kataria <akataria@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/highmem.h        |    4 ----
 arch/x86/include/asm/paravirt.h       |    9 ---------
 arch/x86/include/asm/paravirt_types.h |    4 ----
 arch/x86/include/asm/pgtable_32.h     |    4 ++--
 arch/x86/kernel/paravirt.c            |    4 ----
 arch/x86/kernel/vmi_32.c              |   20 --------------------
 arch/x86/xen/mmu.c                    |   22 ----------------------
 7 files changed, 2 insertions(+), 65 deletions(-)

diff --git a/arch/x86/include/asm/highmem.h b/arch/x86/include/asm/highmem.h
index 014c2b8..a726650 100644
--- a/arch/x86/include/asm/highmem.h
+++ b/arch/x86/include/asm/highmem.h
@@ -66,10 +66,6 @@ void *kmap_atomic_pfn(unsigned long pfn, enum km_type type);
 void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot);
 struct page *kmap_atomic_to_page(void *ptr);
 
-#ifndef CONFIG_PARAVIRT
-#define kmap_atomic_pte(page, type)	kmap_atomic(page, type)
-#endif
-
 #define flush_cache_kmaps()	do { } while (0)
 
 extern void add_highpages_with_active_regions(int nid, unsigned long start_pfn,
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index dd59a85..5653f43 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -435,15 +435,6 @@ static inline void paravirt_release_pud(unsigned long pfn)
 	PVOP_VCALL1(pv_mmu_ops.release_pud, pfn);
 }
 
-#ifdef CONFIG_HIGHPTE
-static inline void *kmap_atomic_pte(struct page *page, enum km_type type)
-{
-	unsigned long ret;
-	ret = PVOP_CALL2(unsigned long, pv_mmu_ops.kmap_atomic_pte, page, type);
-	return (void *)ret;
-}
-#endif
-
 static inline void pte_update(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep)
 {
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index b1e70d5..db9ef55 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -304,10 +304,6 @@ struct pv_mmu_ops {
 #endif	/* PAGETABLE_LEVELS == 4 */
 #endif	/* PAGETABLE_LEVELS >= 3 */
 
-#ifdef CONFIG_HIGHPTE
-	void *(*kmap_atomic_pte)(struct page *page, enum km_type type);
-#endif
-
 	struct pv_lazy_ops lazy_mode;
 
 	/* dom0 ops */
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
index 01fd946..b422d22 100644
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -54,10 +54,10 @@ extern void set_pmd_pfn(unsigned long, unsigned long, pgprot_t);
 	 in_irq() ? KM_IRQ_PTE :	\
 	 KM_PTE0)
 #define pte_offset_map(dir, address)					\
-	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), __KM_PTE) +		\
+	((pte_t *)kmap_atomic(pmd_page(*(dir)), __KM_PTE) +		\
 	 pte_index((address)))
 #define pte_offset_map_nested(dir, address)				\
-	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), KM_PTE1) +		\
+	((pte_t *)kmap_atomic(pmd_page(*(dir)), KM_PTE1) +		\
 	 pte_index((address)))
 #define pte_unmap(pte) kunmap_atomic((pte), __KM_PTE)
 #define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 1b1739d..1db183e 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -428,10 +428,6 @@ struct pv_mmu_ops pv_mmu_ops = {
 	.ptep_modify_prot_start = __ptep_modify_prot_start,
 	.ptep_modify_prot_commit = __ptep_modify_prot_commit,
 
-#ifdef CONFIG_HIGHPTE
-	.kmap_atomic_pte = kmap_atomic,
-#endif
-
 #if PAGETABLE_LEVELS >= 3
 #ifdef CONFIG_X86_PAE
 	.set_pte_atomic = native_set_pte_atomic,
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 58aca86..7dd599d 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -267,22 +267,6 @@ static void vmi_nop(void)
 {
 }
 
-#ifdef CONFIG_HIGHPTE
-static void *vmi_kmap_atomic_pte(struct page *page, enum km_type type)
-{
-	void *va = kmap_atomic(page, type);
-
-	/*
-	 * We disable highmem allocations for page tables so we should never
-	 * see any calls to kmap_atomic_pte on a highmem page.
-	 */
-
-	BUG_ON(PageHighmem(page));
-
-	return va;
-}
-#endif
-
 static void vmi_allocate_pte(struct mm_struct *mm, unsigned long pfn)
 {
 	vmi_ops.allocate_page(pfn, VMI_PAGE_L1, 0, 0, 0);
@@ -777,10 +761,6 @@ static inline int __init activate_vmi(void)
 
 	/* Set linear is needed in all cases */
 	vmi_ops.set_linear_mapping = vmi_get_function(VMI_CALL_SetLinearMapping);
-#ifdef CONFIG_HIGHPTE
-	if (vmi_ops.set_linear_mapping)
-		pv_mmu_ops.kmap_atomic_pte = vmi_kmap_atomic_pte;
-#endif
 
 	/*
 	 * These MUST always be patched.  Don't support indirect jumps
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 350a3de..f9eb7de 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1427,24 +1427,6 @@ static void xen_pgd_free(struct mm_struct *mm, pgd_t *pgd)
 #endif
 }
 
-#ifdef CONFIG_HIGHPTE
-static void *xen_kmap_atomic_pte(struct page *page, enum km_type type)
-{
-	pgprot_t prot = PAGE_KERNEL;
-
-	/*
-	 * We disable highmem allocations for page tables so we should never
-	 * see any calls to kmap_atomic_pte on a highmem page.
-	 */
-	BUG_ON(PageHighMem(page));
-
-	if (PagePinned(page))
-		prot = PAGE_KERNEL_RO;
-
-	return kmap_atomic_prot(page, type, prot);
-}
-#endif
-
 #ifdef CONFIG_X86_32
 static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
 {
@@ -1903,10 +1885,6 @@ static const struct pv_mmu_ops xen_mmu_ops __initdata = {
 	.alloc_pmd_clone = paravirt_nop,
 	.release_pmd = xen_release_pmd_init,
 
-#ifdef CONFIG_HIGHPTE
-	.kmap_atomic_pte = xen_kmap_atomic_pte,
-#endif
-
 #ifdef CONFIG_X86_64
 	.set_pte = xen_set_pte,
 #else

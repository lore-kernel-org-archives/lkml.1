Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbXKHCdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbXKHCdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757763AbXKHCdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:33:31 -0500
Received: from gw.goop.org ([64.81.55.164]:57054 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639AbXKHCd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:33:29 -0500
Message-Id: <20071108015310.589144886@goop.org>
References: <20071108015008.660012621@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 07 Nov 2007 17:50:14 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Zach Amsden <zach@vmware.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: [PATCH RFC 6/7] x86/xen: simplify Xen mmu operations
Content-Disposition: inline; filename=x86-simplify-xen-mmu.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Take advantage of the unified page/pgtable.h definitions to reduce the
number of duplicate definitions of the various Xen mmu_ops functions.

Signed-off-by: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |    8 ++++-
 arch/x86/xen/mmu.c       |   67 +++++++++++++++++-----------------------------
 arch/x86/xen/mmu.h       |   26 +++++------------
 3 files changed, 41 insertions(+), 60 deletions(-)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1038,16 +1038,18 @@ static const struct pv_mmu_ops xen_mmu_o
 	.make_pte = xen_make_pte,
 	.make_pgd = xen_make_pgd,
 
+#if PAGETABLE_LEVELS >= 3
 #ifdef CONFIG_X86_PAE
 	.set_pte_atomic = xen_set_pte_atomic,
 	.set_pte_present = xen_set_pte_at,
+#endif	/* PAE */
 	.set_pud = xen_set_pud,
 	.pte_clear = xen_pte_clear,
 	.pmd_clear = xen_pmd_clear,
 
 	.make_pmd = xen_make_pmd,
 	.pmd_val = xen_pmd_val,
-#endif	/* PAE */
+#endif	/* PAGETABLE_LEVELS >= 3 */
 
 	.activate_mm = xen_activate_mm,
 	.dup_mmap = xen_dup_mmap,
@@ -1175,6 +1177,10 @@ asmlinkage void __init xen_start_kernel(
 	xen_setup_vcpu_info_placement();
 #endif
 
+#ifdef CONFIG_X86_PAE
+	__supported_pte_mask &= ~_PAGE_PCD;
+#endif
+
 	pv_info.kernel_rpl = 1;
 	if (xen_feature(XENFEAT_supervisor_mode_kernel))
 		pv_info.kernel_rpl = 0;
===================================================================
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -211,7 +211,7 @@ void xen_pmd_clear(pmd_t *pmdp)
 	xen_set_pmd(pmdp, __pmd(0));
 }
 
-unsigned long long xen_pte_val(pte_t pte)
+pteval_t xen_pte_val(pte_t pte)
 {
 	unsigned long long ret = 0;
 
@@ -223,23 +223,7 @@ unsigned long long xen_pte_val(pte_t pte
 	return ret;
 }
 
-unsigned long long xen_pmd_val(pmd_t pmd)
-{
-	unsigned long long ret = pmd.pmd;
-	if (ret)
-		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
-	return ret;
-}
-
-unsigned long long xen_pgd_val(pgd_t pgd)
-{
-	unsigned long long ret = pgd.pgd;
-	if (ret)
-		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
-	return ret;
-}
-
-pte_t xen_make_pte(unsigned long long pte)
+pte_t xen_make_pte(pteval_t pte)
 {
 	if (pte & 1)
 		pte = phys_to_machine(XPADDR(pte)).maddr;
@@ -247,20 +231,13 @@ pte_t xen_make_pte(unsigned long long pt
 	return (pte_t){ pte, pte >> 32 };
 }
 
-pmd_t xen_make_pmd(unsigned long long pmd)
+
+pmd_t xen_make_pmd(pmdval_t pmd)
 {
 	if (pmd & 1)
 		pmd = phys_to_machine(XPADDR(pmd)).maddr;
 
-	return (pmd_t){ pmd };
-}
-
-pgd_t xen_make_pgd(unsigned long long pgd)
-{
-	if (pgd & _PAGE_PRESENT)
-		pgd = phys_to_machine(XPADDR(pgd)).maddr;
-
-	return (pgd_t){ pgd };
+	return native_make_pmd(pmd);
 }
 #else  /* !PAE */
 void xen_set_pte(pte_t *ptep, pte_t pte)
@@ -268,7 +245,7 @@ void xen_set_pte(pte_t *ptep, pte_t pte)
 	*ptep = pte;
 }
 
-unsigned long xen_pte_val(pte_t pte)
+pteval_t xen_pte_val(pte_t pte)
 {
 	unsigned long ret = pte.pte_low;
 
@@ -278,30 +255,38 @@ unsigned long xen_pte_val(pte_t pte)
 	return ret;
 }
 
-unsigned long xen_pgd_val(pgd_t pgd)
-{
-	unsigned long ret = pgd.pgd;
-	if (ret)
-		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
-	return ret;
-}
-
-pte_t xen_make_pte(unsigned long pte)
+pte_t xen_make_pte(pteval_t pte)
 {
 	if (pte & _PAGE_PRESENT)
 		pte = phys_to_machine(XPADDR(pte)).maddr;
 
 	return (pte_t){ pte };
 }
+#endif	/* CONFIG_X86_PAE */
 
-pgd_t xen_make_pgd(unsigned long pgd)
+pmdval_t xen_pmd_val(pmd_t pmd)
+{
+	pmdval_t ret = native_pmd_val(pmd);
+	if (ret)
+		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
+	return ret;
+}
+
+pgdval_t xen_pgd_val(pgd_t pgd)
+{
+	pgdval_t ret = native_pgd_val(pgd);
+	if (ret)
+		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
+	return ret;
+}
+
+pgd_t xen_make_pgd(pgdval_t pgd)
 {
 	if (pgd & _PAGE_PRESENT)
 		pgd = phys_to_machine(XPADDR(pgd)).maddr;
 
-	return (pgd_t){ pgd };
+	return native_make_pgd(pgd);
 }
-#endif	/* CONFIG_X86_PAE */
 
 enum pt_level {
 	PT_PGD,
===================================================================
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -30,31 +30,21 @@ void xen_pgd_pin(pgd_t *pgd);
 void xen_pgd_pin(pgd_t *pgd);
 //void xen_pgd_unpin(pgd_t *pgd);
 
+pteval_t xen_pte_val(pte_t);
+pmdval_t xen_pmd_val(pmd_t);
+pgdval_t xen_pgd_val(pgd_t);
+
+pte_t xen_make_pte(pteval_t);
+pmd_t xen_make_pmd(pmdval_t);
+pgd_t xen_make_pgd(pgdval_t);
+
 #ifdef CONFIG_X86_PAE
-unsigned long long xen_pte_val(pte_t);
-unsigned long long xen_pmd_val(pmd_t);
-unsigned long long xen_pgd_val(pgd_t);
-
-pte_t xen_make_pte(unsigned long long);
-pmd_t xen_make_pmd(unsigned long long);
-pgd_t xen_make_pgd(unsigned long long);
-
 void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 		    pte_t *ptep, pte_t pteval);
 void xen_set_pte_atomic(pte_t *ptep, pte_t pte);
 void xen_set_pud(pud_t *ptr, pud_t val);
 void xen_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
 void xen_pmd_clear(pmd_t *pmdp);
-
-
-#else
-unsigned long xen_pte_val(pte_t);
-unsigned long xen_pmd_val(pmd_t);
-unsigned long xen_pgd_val(pgd_t);
-
-pte_t xen_make_pte(unsigned long);
-pmd_t xen_make_pmd(unsigned long);
-pgd_t xen_make_pgd(unsigned long);
 #endif
 
 #endif	/* _XEN_MMU_H */

-- 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbYEILGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbYEILGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYEILGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:06:10 -0400
Received: from gw.goop.org ([64.81.55.164]:40632 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbYEILGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:06:08 -0400
Message-ID: <48243015.2010801@goop.org>
Date: Fri, 09 May 2008 12:05:57 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH] xen: remove support for non-PAE 32-bit
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Non-PAE operation has been deprecated in Xen for a while, and is
rarely tested or used.  xen-unstable has now officially dropped
non-PAE support.  Since Xen/pvops' non-PAE support has also been
broken for a while, we may as well completely drop it altogether.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/Kconfig       |    2 -
 arch/x86/xen/enlighten.c   |   51 +++++++++++++++-----------------------------
 arch/x86/xen/mmu.c         |   19 +---------------
 arch/x86/xen/mmu.h         |   24 +++++---------------
 arch/x86/xen/xen-head.S    |    4 ---
 include/asm-x86/xen/page.h |    4 ---
 6 files changed, 27 insertions(+), 77 deletions(-)

===================================================================
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -6,7 +6,7 @@
 	bool "Xen guest support"
 	select PARAVIRT
 	depends on X86_32
-	depends on X86_CMPXCHG && X86_TSC && !(X86_VISWS || X86_VOYAGER)
+	depends on X86_CMPXCHG && X86_TSC && X86_PAE && !(X86_VISWS || X86_VOYAGER)
 	help
 	  This is the Linux Xen port.  Enabling this will allow the
 	  kernel to boot in a paravirtualized environment under the
===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -811,38 +811,35 @@
 static __init void xen_pagetable_setup_start(pgd_t *base)
 {
 	pgd_t *xen_pgd = (pgd_t *)xen_start_info->pt_base;
+	int i;
 
 	/* special set_pte for pagetable initialization */
 	pv_mmu_ops.set_pte = xen_set_pte_init;
 
 	init_mm.pgd = base;
 	/*
-	 * copy top-level of Xen-supplied pagetable into place.	 For
-	 * !PAE we can use this as-is, but for PAE it is a stand-in
-	 * while we copy the pmd pages.
+	 * copy top-level of Xen-supplied pagetable into place.  This
+	 * is a stand-in while we copy the pmd pages.
 	 */
 	memcpy(base, xen_pgd, PTRS_PER_PGD * sizeof(pgd_t));
 
-	if (PTRS_PER_PMD > 1) {
-		int i;
-		/*
-		 * For PAE, need to allocate new pmds, rather than
-		 * share Xen's, since Xen doesn't like pmd's being
-		 * shared between address spaces.
-		 */
-		for (i = 0; i < PTRS_PER_PGD; i++) {
-			if (pgd_val_ma(xen_pgd[i]) & _PAGE_PRESENT) {
-				pmd_t *pmd = (pmd_t *)alloc_bootmem_low_pages(PAGE_SIZE);
+	/*
+	 * For PAE, need to allocate new pmds, rather than
+	 * share Xen's, since Xen doesn't like pmd's being
+	 * shared between address spaces.
+	 */
+	for (i = 0; i < PTRS_PER_PGD; i++) {
+		if (pgd_val_ma(xen_pgd[i]) & _PAGE_PRESENT) {
+			pmd_t *pmd = (pmd_t *)alloc_bootmem_low_pages(PAGE_SIZE);
 
-				memcpy(pmd, (void *)pgd_page_vaddr(xen_pgd[i]),
-				       PAGE_SIZE);
+			memcpy(pmd, (void *)pgd_page_vaddr(xen_pgd[i]),
+			       PAGE_SIZE);
 
-				make_lowmem_page_readonly(pmd);
+			make_lowmem_page_readonly(pmd);
 
-				set_pgd(&base[i], __pgd(1 + __pa(pmd)));
-			} else
-				pgd_clear(&base[i]);
-		}
+			set_pgd(&base[i], __pgd(1 + __pa(pmd)));
+		} else
+			pgd_clear(&base[i]);
 	}
 
 	/* make sure zero_page is mapped RO so we can use it in pagetables */
@@ -899,17 +896,7 @@
 
 	/* Actually pin the pagetable down, but we can't set PG_pinned
 	   yet because the page structures don't exist yet. */
-	{
-		unsigned level;
-
-#ifdef CONFIG_X86_PAE
-		level = MMUEXT_PIN_L3_TABLE;
-#else
-		level = MMUEXT_PIN_L2_TABLE;
-#endif
-
-		pin_pagetable_pfn(level, PFN_DOWN(__pa(base)));
-	}
+	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(base)));
 }
 
 /* This is called once we have the cpu_possible_map */
@@ -1119,7 +1106,6 @@
 	.make_pte = xen_make_pte,
 	.make_pgd = xen_make_pgd,
 
-#ifdef CONFIG_X86_PAE
 	.set_pte_atomic = xen_set_pte_atomic,
 	.set_pte_present = xen_set_pte_at,
 	.set_pud = xen_set_pud,
@@ -1128,7 +1114,6 @@
 
 	.make_pmd = xen_make_pmd,
 	.pmd_val = xen_pmd_val,
-#endif	/* PAE */
 
 	.activate_mm = xen_activate_mm,
 	.dup_mmap = xen_dup_mmap,
===================================================================
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -222,7 +222,7 @@
 		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
 	return ret;
 }
-#ifdef CONFIG_X86_PAE
+
 void xen_set_pud(pud_t *ptr, pud_t val)
 {
 	struct multicall_space mcs;
@@ -272,12 +272,6 @@
 
 	return native_make_pmd(pmd);
 }
-#else  /* !PAE */
-void xen_set_pte(pte_t *ptep, pte_t pte)
-{
-	*ptep = pte;
-}
-#endif	/* CONFIG_X86_PAE */
 
 /*
   (Yet another) pagetable walker.  This one is intended for pinning a
@@ -430,8 +424,6 @@
    read-only, and can be pinned. */
 void xen_pgd_pin(pgd_t *pgd)
 {
-	unsigned level;
-
 	xen_mc_batch();
 
 	if (pgd_walk(pgd, pin_page, TASK_SIZE)) {
@@ -441,14 +433,7 @@
 		xen_mc_batch();
 	}
 
-#ifdef CONFIG_X86_PAE
-	level = MMUEXT_PIN_L3_TABLE;
-#else
-	level = MMUEXT_PIN_L2_TABLE;
-#endif
-
-	xen_do_pin(level, PFN_DOWN(__pa(pgd)));
-
+	xen_do_pin(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(pgd)));
 	xen_mc_issue(0);
 }
 
===================================================================
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -37,14 +37,13 @@
 void xen_pgd_pin(pgd_t *pgd);
 //void xen_pgd_unpin(pgd_t *pgd);
 
-#ifdef CONFIG_X86_PAE
-unsigned long long xen_pte_val(pte_t);
-unsigned long long xen_pmd_val(pmd_t);
-unsigned long long xen_pgd_val(pgd_t);
+pteval_t xen_pte_val(pte_t);
+pmdval_t xen_pmd_val(pmd_t);
+pgdval_t xen_pgd_val(pgd_t);
 
-pte_t xen_make_pte(unsigned long long);
-pmd_t xen_make_pmd(unsigned long long);
-pgd_t xen_make_pgd(unsigned long long);
+pte_t xen_make_pte(pteval_t);
+pmd_t xen_make_pmd(pmdval_t);
+pgd_t xen_make_pgd(pgdval_t);
 
 void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 		    pte_t *ptep, pte_t pteval);
@@ -53,15 +52,4 @@
 void xen_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
 void xen_pmd_clear(pmd_t *pmdp);
 
-
-#else
-unsigned long xen_pte_val(pte_t);
-unsigned long xen_pmd_val(pmd_t);
-unsigned long xen_pgd_val(pgd_t);
-
-pte_t xen_make_pte(unsigned long);
-pmd_t xen_make_pmd(unsigned long);
-pgd_t xen_make_pgd(unsigned long);
-#endif
-
 #endif	/* _XEN_MMU_H */
===================================================================
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -30,11 +30,7 @@
 	ELFNOTE(Xen, XEN_ELFNOTE_ENTRY,          .long  startup_xen)
 	ELFNOTE(Xen, XEN_ELFNOTE_HYPERCALL_PAGE, .long  hypercall_page)
 	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb")
-#ifdef CONFIG_X86_PAE
 	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz "yes")
-#else
-	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz "no")
-#endif
 	ELFNOTE(Xen, XEN_ELFNOTE_LOADER,         .asciz "generic")
 
 #endif /*CONFIG_XEN */
===================================================================
--- a/include/asm-x86/xen/page.h
+++ b/include/asm-x86/xen/page.h
@@ -150,13 +150,9 @@
 	return (pte_t) { .pte = x };
 }
 
-#ifdef CONFIG_X86_PAE
 #define pmd_val_ma(v) ((v).pmd)
 #define pud_val_ma(v) ((v).pgd.pgd)
 #define __pmd_ma(x)	((pmd_t) { (x) } )
-#else  /* !X86_PAE */
-#define pmd_val_ma(v)	((v).pud.pgd.pgd)
-#endif	/* CONFIG_X86_PAE */
 
 #define pgd_val_ma(x)	((x).pgd)
 



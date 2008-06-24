Return-Path: <linux-kernel-owner+w=401wt.eu-S1763174AbYFXPS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763174AbYFXPS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 11:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759978AbYFXPSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 11:18:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32979 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759779AbYFXPSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 11:18:45 -0400
Date: Tue, 24 Jun 2008 17:18:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, chrisw@sous-sol.org,
       xen-devel@lists.xensource.com
Subject: Re: [git pull] xen, x86 fixes
Message-ID: <20080624151812.GA18441@elte.hu>
References: <20080623194055.GA28384@elte.hu> <20080624073847.GA1897@cs181140183.pp.htv.fi> <4860EB57.30402@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4860EB57.30402@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Bringing that patch over into .26 would be the easiest fix.  It's 
> effectively a bugfix because non-PAE Xen is broken and unusable 
> anyway.
>
> Alternatively, I can easily put a little patch together to use the 
> right accessors that will compile in non-PAE.

that patch has been in testing since early May so we can put it into 
v2.6.26 - and as you say non-PAE paravirt guest support in Xen is 
deprecated and rarely used/tested.

Linus,

Please pull the latest x86 fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

which includes a cherry-pick of this one Xen commit from Jeremy - this 
fixes the build error reported by Adrian Bunk.

( alternatively we could do just the arch/x86/xen/Kconfig bit too but i 
  think we should just take this one as it touches Xen code only. )

Thanks,

	Ingo

------------------>
Jeremy Fitzhardinge (1):
      xen: remove support for non-PAE 32-bit

 arch/x86/xen/Kconfig       |    2 +-
 arch/x86/xen/enlighten.c   |   51 +++++++++++++++----------------------------
 arch/x86/xen/mmu.c         |   19 +--------------
 arch/x86/xen/mmu.h         |   24 +++++---------------
 arch/x86/xen/xen-head.S    |    4 ---
 include/asm-x86/xen/page.h |    4 ---
 6 files changed, 27 insertions(+), 77 deletions(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 2e641be..525b108 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -6,7 +6,7 @@ config XEN
 	bool "Xen guest support"
 	select PARAVIRT
 	depends on X86_32
-	depends on X86_CMPXCHG && X86_TSC && !(X86_VISWS || X86_VOYAGER)
+	depends on X86_CMPXCHG && X86_TSC && X86_PAE && !(X86_VISWS || X86_VOYAGER)
 	help
 	  This is the Linux Xen port.  Enabling this will allow the
 	  kernel to boot in a paravirtualized environment under the
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c048de3..f09c1c6 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -785,38 +785,35 @@ static __init void xen_set_pte_init(pte_t *ptep, pte_t pte)
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
@@ -873,17 +870,7 @@ static __init void xen_pagetable_setup_done(pgd_t *base)
 
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
@@ -1093,7 +1080,6 @@ static const struct pv_mmu_ops xen_mmu_ops __initdata = {
 	.make_pte = xen_make_pte,
 	.make_pgd = xen_make_pgd,
 
-#ifdef CONFIG_X86_PAE
 	.set_pte_atomic = xen_set_pte_atomic,
 	.set_pte_present = xen_set_pte_at,
 	.set_pud = xen_set_pud,
@@ -1102,7 +1088,6 @@ static const struct pv_mmu_ops xen_mmu_ops __initdata = {
 
 	.make_pmd = xen_make_pmd,
 	.pmd_val = xen_pmd_val,
-#endif	/* PAE */
 
 	.activate_mm = xen_activate_mm,
 	.dup_mmap = xen_dup_mmap,
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 265601d..df40bf7 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -228,7 +228,7 @@ pmdval_t xen_pmd_val(pmd_t pmd)
 {
 	return pte_mfn_to_pfn(pmd.pmd);
 }
-#ifdef CONFIG_X86_PAE
+
 void xen_set_pud(pud_t *ptr, pud_t val)
 {
 	struct multicall_space mcs;
@@ -276,12 +276,6 @@ pmd_t xen_make_pmd(pmdval_t pmd)
 	pmd = pte_pfn_to_mfn(pmd);
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
@@ -434,8 +428,6 @@ static int pin_page(struct page *page, enum pt_level level)
    read-only, and can be pinned. */
 void xen_pgd_pin(pgd_t *pgd)
 {
-	unsigned level;
-
 	xen_mc_batch();
 
 	if (pgd_walk(pgd, pin_page, TASK_SIZE)) {
@@ -445,14 +437,7 @@ void xen_pgd_pin(pgd_t *pgd)
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
 
diff --git a/arch/x86/xen/mmu.h b/arch/x86/xen/mmu.h
index b5e189b..5fe961c 100644
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -37,14 +37,13 @@ void xen_exit_mmap(struct mm_struct *mm);
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
@@ -53,15 +52,4 @@ void xen_set_pud(pud_t *ptr, pud_t val);
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
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 3175e97..6ec3b4f 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -30,11 +30,7 @@ ENTRY(hypercall_page)
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
diff --git a/include/asm-x86/xen/page.h b/include/asm-x86/xen/page.h
index baf3a4d..e11f240 100644
--- a/include/asm-x86/xen/page.h
+++ b/include/asm-x86/xen/page.h
@@ -150,13 +150,9 @@ static inline pte_t __pte_ma(pteval_t x)
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
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761566AbYFWTle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761566AbYFWTle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755722AbYFWTl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:41:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58405 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbYFWTlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:41:25 -0400
Date: Mon, 23 Jun 2008 21:40:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [git pull] xen, x86 fixes
Message-ID: <20080623194055.GA28384@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Linus,

please pull the latest x86 fixes tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

NOTE: contains the second, lguest half of the FPU fixlet from Suresh.

	Ingo

------------------>
Isaku Yamahata (1):
      xen: Use wmb instead of rmb in xen_evtchn_do_upcall().

Jeremy Fitzhardinge (2):
      xen: mask unwanted pte bits in __supported_pte_mask
      xen: don't drop NX bit

Suresh Siddha (1):
      x86: fix NULL pointer deref in __switch_to

 arch/x86/xen/enlighten.c  |    5 ++++
 arch/x86/xen/mmu.c        |   56 ++++++++++++++++++++++++---------------------
 arch/x86/xen/xen-head.S   |    2 +-
 drivers/lguest/x86/core.c |   15 +++++++-----
 drivers/xen/events.c      |    2 +-
 5 files changed, 46 insertions(+), 34 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c8a56e4..c048de3 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1228,6 +1228,11 @@ asmlinkage void __init xen_start_kernel(void)
 	if (xen_feature(XENFEAT_supervisor_mode_kernel))
 		pv_info.kernel_rpl = 0;
 
+	/* Prevent unwanted bits from being set in PTEs. */
+	__supported_pte_mask &= ~_PAGE_GLOBAL;
+	if (!is_initial_xendomain())
+		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
+
 	/* set the limit of our address space */
 	xen_reserve_top();
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 3525ef5..265601d 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -179,48 +179,54 @@ out:
 		preempt_enable();
 }
 
-pteval_t xen_pte_val(pte_t pte)
+/* Assume pteval_t is equivalent to all the other *val_t types. */
+static pteval_t pte_mfn_to_pfn(pteval_t val)
 {
-	pteval_t ret = pte.pte;
+	if (val & _PAGE_PRESENT) {
+		unsigned long mfn = (val & PTE_MASK) >> PAGE_SHIFT;
+		pteval_t flags = val & ~PTE_MASK;
+		val = (mfn_to_pfn(mfn) << PAGE_SHIFT) | flags;
+	}
+
+	return val;
+}
+
+static pteval_t pte_pfn_to_mfn(pteval_t val)
+{
+	if (val & _PAGE_PRESENT) {
+		unsigned long pfn = (val & PTE_MASK) >> PAGE_SHIFT;
+		pteval_t flags = val & ~PTE_MASK;
+		val = (pfn_to_mfn(pfn) << PAGE_SHIFT) | flags;
+	}
 
-	if (ret & _PAGE_PRESENT)
-		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
+	return val;
+}
 
-	return ret;
+pteval_t xen_pte_val(pte_t pte)
+{
+	return pte_mfn_to_pfn(pte.pte);
 }
 
 pgdval_t xen_pgd_val(pgd_t pgd)
 {
-	pgdval_t ret = pgd.pgd;
-	if (ret & _PAGE_PRESENT)
-		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
-	return ret;
+	return pte_mfn_to_pfn(pgd.pgd);
 }
 
 pte_t xen_make_pte(pteval_t pte)
 {
-	if (pte & _PAGE_PRESENT) {
-		pte = phys_to_machine(XPADDR(pte)).maddr;
-		pte &= ~(_PAGE_PCD | _PAGE_PWT);
-	}
-
-	return (pte_t){ .pte = pte };
+	pte = pte_pfn_to_mfn(pte);
+	return native_make_pte(pte);
 }
 
 pgd_t xen_make_pgd(pgdval_t pgd)
 {
-	if (pgd & _PAGE_PRESENT)
-		pgd = phys_to_machine(XPADDR(pgd)).maddr;
-
-	return (pgd_t){ pgd };
+	pgd = pte_pfn_to_mfn(pgd);
+	return native_make_pgd(pgd);
 }
 
 pmdval_t xen_pmd_val(pmd_t pmd)
 {
-	pmdval_t ret = native_pmd_val(pmd);
-	if (ret & _PAGE_PRESENT)
-		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
-	return ret;
+	return pte_mfn_to_pfn(pmd.pmd);
 }
 #ifdef CONFIG_X86_PAE
 void xen_set_pud(pud_t *ptr, pud_t val)
@@ -267,9 +273,7 @@ void xen_pmd_clear(pmd_t *pmdp)
 
 pmd_t xen_make_pmd(pmdval_t pmd)
 {
-	if (pmd & _PAGE_PRESENT)
-		pmd = phys_to_machine(XPADDR(pmd)).maddr;
-
+	pmd = pte_pfn_to_mfn(pmd);
 	return native_make_pmd(pmd);
 }
 #else  /* !PAE */
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 288d587..3175e97 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -17,7 +17,7 @@ ENTRY(startup_xen)
 
 	__FINIT
 
-.pushsection .bss.page_aligned
+.pushsection .text
 	.align PAGE_SIZE_asm
 ENTRY(hypercall_page)
 	.skip 0x1000
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 5126d5d..2e554a4 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -176,7 +176,7 @@ void lguest_arch_run_guest(struct lg_cpu *cpu)
 	 * we set it now, so we can trap and pass that trap to the Guest if it
 	 * uses the FPU. */
 	if (cpu->ts)
-		lguest_set_ts();
+		unlazy_fpu(current);
 
 	/* SYSENTER is an optimized way of doing system calls.  We can't allow
 	 * it because it always jumps to privilege level 0.  A normal Guest
@@ -196,6 +196,10 @@ void lguest_arch_run_guest(struct lg_cpu *cpu)
 	 * trap made the switcher code come back, and an error code which some
 	 * traps set.  */
 
+	 /* Restore SYSENTER if it's supposed to be on. */
+	 if (boot_cpu_has(X86_FEATURE_SEP))
+		wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
+
 	/* If the Guest page faulted, then the cr2 register will tell us the
 	 * bad virtual address.  We have to grab this now, because once we
 	 * re-enable interrupts an interrupt could fault and thus overwrite
@@ -203,13 +207,12 @@ void lguest_arch_run_guest(struct lg_cpu *cpu)
 	if (cpu->regs->trapnum == 14)
 		cpu->arch.last_pagefault = read_cr2();
 	/* Similarly, if we took a trap because the Guest used the FPU,
-	 * we have to restore the FPU it expects to see. */
+	 * we have to restore the FPU it expects to see.
+	 * math_state_restore() may sleep and we may even move off to
+	 * a different CPU. So all the critical stuff should be done
+	 * before this.  */
 	else if (cpu->regs->trapnum == 7)
 		math_state_restore();
-
-	/* Restore SYSENTER if it's supposed to be on. */
-	if (boot_cpu_has(X86_FEATURE_SEP))
-		wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
 }
 
 /*H:130 Now we've examined the hypercall code; our Guest can make requests.
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 4f0f22b..76e5b73 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -529,7 +529,7 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 
 #ifndef CONFIG_X86 /* No need for a barrier -- XCHG is a barrier on x86. */
 		/* Clear master flag /before/ clearing selector flag. */
-		rmb();
+		wmb();
 #endif
 		pending_words = xchg(&vcpu_info->evtchn_pending_sel, 0);
 		while (pending_words != 0) {

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYJBXlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYJBXlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbYJBXlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:41:45 -0400
Received: from gw.goop.org ([64.81.55.164]:60989 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbYJBXlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:41:44 -0400
Message-ID: <48E55C2B.1060804@goop.org>
Date: Thu, 02 Oct 2008 16:41:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen: clean up x86-64 warnings
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a couple of Xen features which rely on directly accessing
per-cpu data via a segment register, which is not yet available on
x86-64.  In the meantime, just disable direct access to the vcpu info
structure; this leaves some of the code as dead, but it will come to
life in time, and the warnings are suppressed.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c  |   61 +++++++--------------------------------------
 arch/x86/xen/xen-asm_64.S |   22 +++++++++++++---
 2 files changed, 28 insertions(+), 55 deletions(-)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -113,7 +113,14 @@
  *
  * 0: not available, 1: available
  */
-static int have_vcpu_info_placement = 1;
+static int have_vcpu_info_placement =
+#ifdef CONFIG_X86_32
+	1
+#else
+	0
+#endif
+	;
+
 
 static void xen_vcpu_setup(int cpu)
 {
@@ -973,6 +980,7 @@
 }
 #endif
 
+#ifdef CONFIG_X86_32
 static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
 {
 	/* If there's an existing pte, then don't allow _PAGE_RW to be set */
@@ -991,6 +999,7 @@
 
 	xen_set_pte(ptep, pte);
 }
+#endif
 
 static __init void xen_pagetable_setup_start(pgd_t *base)
 {
@@ -1057,7 +1066,6 @@
 
 	/* xen_vcpu_setup managed to place the vcpu_info within the
 	   percpu area for all cpus, so make use of it */
-#ifdef CONFIG_X86_32
 	if (have_vcpu_info_placement) {
 		printk(KERN_INFO "Xen: using vcpu_info placement\n");
 
@@ -1067,7 +1075,6 @@
 		pv_irq_ops.irq_enable = xen_irq_enable_direct;
 		pv_mmu_ops.read_cr2 = xen_read_cr2_direct;
 	}
-#endif
 }
 
 static unsigned xen_patch(u8 type, u16 clobbers, void *insnbuf,
@@ -1088,12 +1095,10 @@
 	goto patch_site
 
 	switch (type) {
-#ifdef CONFIG_X86_32
 		SITE(pv_irq_ops, irq_enable);
 		SITE(pv_irq_ops, irq_disable);
 		SITE(pv_irq_ops, save_fl);
 		SITE(pv_irq_ops, restore_fl);
-#endif /* CONFIG_X86_32 */
 #undef SITE
 
 	patch_site:
@@ -1430,47 +1435,10 @@
 	return __ka(m2p(maddr));
 }
 
-#ifdef CONFIG_X86_64
-static void walk(pgd_t *pgd, unsigned long addr)
-{
-	unsigned l4idx = pgd_index(addr);
-	unsigned l3idx = pud_index(addr);
-	unsigned l2idx = pmd_index(addr);
-	unsigned l1idx = pte_index(addr);
-	pgd_t l4;
-	pud_t l3;
-	pmd_t l2;
-	pte_t l1;
-
-	xen_raw_printk("walk %p, %lx -> %d %d %d %d\n",
-		       pgd, addr, l4idx, l3idx, l2idx, l1idx);
-
-	l4 = pgd[l4idx];
-	xen_raw_printk("  l4: %016lx\n", l4.pgd);
-	xen_raw_printk("      %016lx\n", pgd_val(l4));
-
-	l3 = ((pud_t *)(m2v(l4.pgd)))[l3idx];
-	xen_raw_printk("  l3: %016lx\n", l3.pud);
-	xen_raw_printk("      %016lx\n", pud_val(l3));
-
-	l2 = ((pmd_t *)(m2v(l3.pud)))[l2idx];
-	xen_raw_printk("  l2: %016lx\n", l2.pmd);
-	xen_raw_printk("      %016lx\n", pmd_val(l2));
-
-	l1 = ((pte_t *)(m2v(l2.pmd)))[l1idx];
-	xen_raw_printk("  l1: %016lx\n", l1.pte);
-	xen_raw_printk("      %016lx\n", pte_val(l1));
-}
-#endif
-
 static void set_page_prot(void *addr, pgprot_t prot)
 {
 	unsigned long pfn = __pa(addr) >> PAGE_SHIFT;
 	pte_t pte = pfn_pte(pfn, prot);
-
-	xen_raw_printk("addr=%p pfn=%lx mfn=%lx prot=%016llx pte=%016llx\n",
-		       addr, pfn, get_phys_to_machine(pfn),
-		       pgprot_val(prot), pte.pte);
 
 	if (HYPERVISOR_update_va_mapping((unsigned long)addr, pte, 0))
 		BUG();
@@ -1736,15 +1704,6 @@
 
 	xen_raw_console_write("about to get started...\n");
 
-#if 0
-	xen_raw_printk("&boot_params=%p __pa(&boot_params)=%lx __va(__pa(&boot_params))=%lx\n",
-		       &boot_params, __pa_symbol(&boot_params),
-		       __va(__pa_symbol(&boot_params)));
-
-	walk(pgd, &boot_params);
-	walk(pgd, __va(__pa(&boot_params)));
-#endif
-
 	/* Start the world */
 #ifdef CONFIG_X86_32
 	i386_start_kernel();
===================================================================
--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -26,15 +26,24 @@
 /* Pseudo-flag used for virtual NMI, which we don't implement yet */
 #define XEN_EFLAGS_NMI	0x80000000
 
-#if 0
-#include <asm/percpu.h>
-
+#if 1
+/*
+	x86-64 does not yet support direct access to percpu variables
+	via a segment override, so we just need to make sure this code
+	never gets used
+ */
+#define BUG			ud2a
+#define PER_CPU_VAR(var, off)	0xdeadbeef
+#endif
+
 /*
 	Enable events.  This clears the event mask and tests the pending
 	event status with one and operation.  If there are pending
 	events, then enter the hypervisor to get them handled.
  */
 ENTRY(xen_irq_enable_direct)
+	BUG
+
 	/* Unmask events */
 	movb $0, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
 
@@ -58,6 +67,8 @@
 	non-zero.
  */
 ENTRY(xen_irq_disable_direct)
+	BUG
+
 	movb $1, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
 ENDPATCH(xen_irq_disable_direct)
 	ret
@@ -74,6 +85,8 @@
 	Xen and x86 use opposite senses (mask vs enable).
  */
 ENTRY(xen_save_fl_direct)
+	BUG
+
 	testb $0xff, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
 	setz %ah
 	addb %ah,%ah
@@ -91,6 +104,8 @@
 	if so.
  */
 ENTRY(xen_restore_fl_direct)
+	BUG
+
 	testb $X86_EFLAGS_IF>>8, %ah
 	setz PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
 	/* Preempt here doesn't matter because that will deal with
@@ -133,7 +148,6 @@
 	pop %rcx
 	pop %rax
 	ret
-#endif
 
 ENTRY(xen_adjust_exception_frame)
 	mov 8+0(%rsp),%rcx



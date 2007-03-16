Return-Path: <linux-kernel-owner+w=401wt.eu-S965977AbXCPV7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965977AbXCPV7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 17:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965980AbXCPV7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 17:59:37 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53206 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965977AbXCPV7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 17:59:36 -0400
Date: Fri, 16 Mar 2007 14:59:16 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 03/26] Xen-paravirt_ops: use paravirt_nop to consistently mark no-op operations
Message-ID: <20070316215916.GP10574@sequoia.sous-sol.org>
References: <20070301232443.195603797@goop.org> <20070301232526.261284776@goop.org> <20070316094432.GU23174@elte.hu> <45FAE560.10401@goop.org> <20070316194904.GO10574@sequoia.sous-sol.org> <45FAF77A.8010607@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FAF77A.8010607@goop.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Chris Wright wrote:
> > how about __paravirt_nop_start < func < __paravirt_nop_end  and preserve
> > the types?
> >   
> 
> Er?  The reason for the (void *) cast is to stop gcc complaining about
> mismatched pointer types.

I mean like this (bunch of work, for a type check that we're really ignoring
anwyay, but this is the idea...)

diff -r 930fff55070e arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c	Fri Mar 16 11:09:10 2007 -0700
+++ b/arch/i386/kernel/paravirt.c	Fri Mar 16 14:48:04 2007 -0700
@@ -35,10 +35,60 @@
 #include <asm/tlbflush.h>
 #include <asm/timer.h>
 
-/* nop stub */
-void _paravirt_nop(void)
-{
-}
+/* nop stubs */
+void __paravirt_nop pv_nop_arch_setup(void)
+{
+}
+void __paravirt_nop pv_nop_set_lazy_mode(int mode)
+{
+}
+void __paravirt_nop pv_nop_alloc_pt(struct mm_struct *mm, u32 pfn)
+{
+}
+void __paravirt_nop pv_nop_alloc_pd(u32 pfn)
+{
+}
+void __paravirt_nop pv_nop_alloc_pd_clone(u32 pfn, u32 clonepfn, u32 start, u32 count)
+{
+}
+void __paravirt_nop pv_nop_release_pt(u32 pfn)
+{
+}
+void __paravirt_nop pv_nop_release_pd(u32 pfn)
+{
+}
+void __paravirt_nop pv_nop_pte_update(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+}
+void __paravirt_nop pv_nop_pte_update_defer(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+}
+void * __paravirt_nop pv_nop_kmap_atomic_pte(struct page *page, enum km_type type)
+{
+}
+void __paravirt_nop pv_nop_load_tr_desc(void)
+{
+}
+void __paravirt_nop pv_nop_activate_mm(struct mm_struct *prev, struct mm_struct *next)
+{
+}
+void __paravirt_nop pv_nop_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm)
+{
+}
+void __paravirt_nop pv_nop_exit_mmap(struct mm_struct *mm)
+{
+}
+void __paravirt_nop pv_nop_startup_ipi_hook(int phys_apicid, unsigned long start_eip, unsigned long start_esp)
+{
+}
+#ifdef CONFIG_X86_LOCAL_APIC
+void __paravirt_nop pv_nop_setup_boot_clock(void)
+{
+}
+void __paravirt_nop pv_nop_setup_secondary_clock(void)
+{
+}
+#endif
 
 static void __init default_banner(void)
 {
@@ -166,7 +216,7 @@ unsigned paravirt_patch_default(u8 type,
 	if (opfunc == NULL)
 		/* If there's no function, patch it with a ud2a (BUG) */
 		ret = paravirt_patch_insns(site, len, start_ud2a, end_ud2a);
-	else if (opfunc == paravirt_nop)
+	else if (opfunc >= __paravirt_nop_start || opfunc < __paravirt_nop_end)
 		/* If the operation is a nop, then nop the callsite */
 		ret = paravirt_patch_nop();
 	else if (type == PARAVIRT_PATCH(iret) ||
@@ -521,7 +571,7 @@ struct paravirt_ops paravirt_ops = {
 
  	.patch = native_patch,
 	.banner = default_banner,
-	.arch_setup = paravirt_nop,
+	.arch_setup = pv_nop_arch_setup,
 	.memory_setup = machine_specific_memory_setup,
 	.get_wallclock = native_get_wallclock,
 	.set_wallclock = native_set_wallclock,
@@ -577,7 +627,7 @@ struct paravirt_ops paravirt_ops = {
 	.setup_boot_clock = setup_boot_APIC_clock,
 	.setup_secondary_clock = setup_secondary_APIC_clock,
 #endif
-	.set_lazy_mode = paravirt_nop,
+	.set_lazy_mode = pv_nop_set_lazy_mode,
 
 	.pagetable_setup_start = native_pagetable_setup_start,
 	.pagetable_setup_done = native_pagetable_setup_done,
@@ -587,24 +637,24 @@ struct paravirt_ops paravirt_ops = {
 	.flush_tlb_single = native_flush_tlb_single,
 	.flush_tlb_others = native_flush_tlb_others,
 
-	.alloc_pt = paravirt_nop,
-	.alloc_pd = paravirt_nop,
-	.alloc_pd_clone = paravirt_nop,
-	.release_pt = paravirt_nop,
-	.release_pd = paravirt_nop,
+	.alloc_pt = pv_nop_alloc_pt,
+	.alloc_pd = pv_nop_alloc_pd,
+	.alloc_pd_clone = pv_nop_alloc_pd_clone,
+	.release_pt = pv_nop_release_pt,
+	.release_pd = pv_nop_release_pd,
 
 	.set_pte = native_set_pte,
 	.set_pte_at = native_set_pte_at,
 	.set_pmd = native_set_pmd,
-	.pte_update = paravirt_nop,
-	.pte_update_defer = paravirt_nop,
+	.pte_update = pv_nop_pte_update,
+	.pte_update_defer = pv_nop_pte_update_defer,
 
 	.ptep_get_and_clear = native_ptep_get_and_clear,
 
 #ifdef CONFIG_HIGHPTE
 	.kmap_atomic_pte = native_kmap_atomic_pte,
 #else
-	.kmap_atomic_pte = paravirt_nop,
+	.kmap_atomic_pte = pv_nop_kmap_atomic_pte,
 #endif
 
 #ifdef CONFIG_X86_PAE
@@ -627,11 +677,11 @@ struct paravirt_ops paravirt_ops = {
 	.irq_enable_sysexit = native_irq_enable_sysexit,
 	.iret = native_iret,
 
-	.dup_mmap = paravirt_nop,
-	.exit_mmap = paravirt_nop,
-	.activate_mm = paravirt_nop,
-
-	.startup_ipi_hook = paravirt_nop,
+	.dup_mmap = pv_nop_dup_mmap,
+	.exit_mmap = pv_nop_exit_mmap,
+	.activate_mm = pv_nop_activate_mm,
+
+	.startup_ipi_hook = pv_nop_startup_ipi_hook,
 };
 
 /*
diff -r 930fff55070e arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S	Fri Mar 16 11:09:10 2007 -0700
+++ b/arch/i386/kernel/vmlinux.lds.S	Fri Mar 16 14:16:42 2007 -0700
@@ -49,6 +49,9 @@ SECTIONS
 	SCHED_TEXT
 	LOCK_TEXT
 	KPROBES_TEXT
+	__paravirt_nop_start = .;
+	*(.paravirtnop)
+	__paravirt_nop_end = .;
 	*(.fixup)
 	*(.gnu.warning)
   	_etext = .;			/* End of text section */
diff -r 930fff55070e arch/i386/xen/enlighten.c
--- a/arch/i386/xen/enlighten.c	Fri Mar 16 11:09:10 2007 -0700
+++ b/arch/i386/xen/enlighten.c	Fri Mar 16 14:53:37 2007 -0700
@@ -697,7 +697,7 @@ static const struct paravirt_ops xen_par
 	.iret = (void *)&hypercall_page[__HYPERVISOR_iret],
 	.irq_enable_sysexit = (void *)xen_sti_sysexit,
 
-	.load_tr_desc = paravirt_nop,
+	.load_tr_desc = pv_nop_load_tr_desc,
 	.set_ldt = xen_set_ldt,
 	.load_gdt = xen_load_gdt,
 	.load_idt = xen_load_idt,
@@ -723,8 +723,8 @@ static const struct paravirt_ops xen_par
 	.apic_write = xen_apic_write,
 	.apic_write_atomic = xen_apic_write,
 	.apic_read = xen_apic_read,
-	.setup_boot_clock = paravirt_nop,
-	.setup_secondary_clock = paravirt_nop,
+	.setup_boot_clock = pv_nop_setup_boot_clock,
+	.setup_secondary_clock = pv_nop_setup_secondary_clock,
 #endif
 
 	.flush_tlb_user = xen_flush_tlb,
@@ -732,8 +732,8 @@ static const struct paravirt_ops xen_par
 	.flush_tlb_single = xen_flush_tlb_single,
 	.flush_tlb_others = xen_flush_tlb_others,
 
-	.pte_update = paravirt_nop,
-	.pte_update_defer = paravirt_nop,
+	.pte_update = pv_nop_pte_update,
+	.pte_update_defer = pv_nop_pte_update_defer,
 
 	.pagetable_setup_start = xen_pagetable_setup_start,
 	.pagetable_setup_done = xen_pagetable_setup_done,
@@ -747,9 +747,9 @@ static const struct paravirt_ops xen_par
 
 	.alloc_pt = xen_alloc_pt_init,
 	.release_pt = xen_release_pt,
-	.alloc_pd = paravirt_nop,
-	.alloc_pd_clone = paravirt_nop,
-	.release_pd = paravirt_nop,
+	.alloc_pd = pv_nop_alloc_pd,
+	.alloc_pd_clone = pv_nop_alloc_pd_clone,
+	.release_pd = pv_nop_release_pd,
 
 	.kmap_atomic_pte = xen_kmap_atomic_pte,
 
@@ -773,7 +773,7 @@ static const struct paravirt_ops xen_par
 #endif	/* PAE */
 
 	.set_lazy_mode = xen_set_lazy_mode,
-	.startup_ipi_hook = paravirt_nop,
+	.startup_ipi_hook = pv_nop_startup_ipi_hook,
 };
 
 #ifdef CONFIG_SMP
diff -r 930fff55070e include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Fri Mar 16 11:09:10 2007 -0700
+++ b/include/asm-i386/paravirt.h	Fri Mar 16 14:50:18 2007 -0700
@@ -202,6 +202,30 @@ int native_write_msr(unsigned int msr, u
 int native_write_msr(unsigned int msr, unsigned long long val);
 unsigned long long native_read_tsc(void);
 unsigned long long native_read_pmc(void);
+
+/* Paravirt nops */
+#define __paravirt_nop __attribute__ ((__section__ (".paravirtnop")))
+extern char __paravirt_nop_start[], __paravirt_nop_end[];
+
+void __paravirt_nop pv_nop_arch_setup(void);
+void __paravirt_nop pv_nop_set_lazy_mode(int mode);
+void __paravirt_nop pv_nop_alloc_pt(struct mm_struct *mm, u32 pfn);
+void __paravirt_nop pv_nop_alloc_pd(u32 pfn);
+void __paravirt_nop pv_nop_alloc_pd_clone(u32 pfn, u32 clonepfn, u32 start, u32 count);
+void __paravirt_nop pv_nop_release_pt(u32 pfn);
+void __paravirt_nop pv_nop_release_pd(u32 pfn);
+void __paravirt_nop pv_nop_pte_update(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+void __paravirt_nop pv_nop_pte_update_defer(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+void * __paravirt_nop pv_nop_kmap_atomic_pte(struct page *page, enum km_type type);
+void __paravirt_nop pv_nop_load_tr_desc(void);
+void __paravirt_nop pv_nop_activate_mm(struct mm_struct *prev, struct mm_struct *next);
+void __paravirt_nop pv_nop_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm);
+void __paravirt_nop pv_nop_exit_mmap(struct mm_struct *mm);
+void __paravirt_nop pv_nop_startup_ipi_hook(int phys_apicid, unsigned long start_eip, unsigned long start_esp);
+#ifdef CONFIG_X86_LOCAL_APIC
+void __paravirt_nop pv_nop_setup_boot_clock(void);
+void __paravirt_nop pv_nop_setup_secondary_clock(void);
+#endif
 
 /* Mark a paravirt probe function. */
 #define paravirt_probe(fn)						\
@@ -876,9 +900,6 @@ static inline pte_t raw_ptep_get_and_cle
 #define arch_enter_lazy_mmu_mode() PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_MMU)
 #define arch_leave_lazy_mmu_mode() PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_NONE)
 
-void _paravirt_nop(void);
-#define paravirt_nop	((void *)_paravirt_nop)
-
 /* These all sit in the .parainstructions section to tell us what to patch. */
 struct paravirt_patch_site {
 	u8 *instr; 		/* original instructions */

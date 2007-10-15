Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbXJOIRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbXJOIRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 04:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbXJOIQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 04:16:52 -0400
Received: from ozlabs.org ([203.10.76.45]:40970 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbXJOIQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 04:16:50 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC REPOST 1/2] paravirt: refactor struct paravirt_ops into smaller pv_*_ops
Date: Mon, 15 Oct 2007 18:16:36 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Zachary Amsden <zach@vmware.com>,
       Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@qumranet.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
References: <470BC758.1030504@goop.org> <200710120001.52456.rusty@rustcorp.com.au> <470FC7F4.1030300@goop.org>
In-Reply-To: <470FC7F4.1030300@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710151816.36758.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 October 2007 05:16:04 Jeremy Fitzhardinge wrote:
> Are you otherwise happy with the patch in its current form?  And are you
> happy with the lazymode changes?

No, and yes.

This applies on top of your 1/2.  Boots here, runs lguest.  It also 
exports pv_info: lg.ko checks it to avoid lguest-in-lguest.

Cheers,
Rusty.

==
Wean off "struct paravirt_ops" entirely: it's now merely a patching enumeration tool

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r d8192c55373b arch/i386/kernel/asm-offsets.c
--- a/arch/i386/kernel/asm-offsets.c	Mon Oct 15 16:56:40 2007 +1000
+++ b/arch/i386/kernel/asm-offsets.c	Mon Oct 15 18:10:52 2007 +1000
@@ -117,11 +117,13 @@ void foo(void)
 #ifdef CONFIG_PARAVIRT
 	BLANK();
 	OFFSET(PARAVIRT_enabled, pv_info, paravirt_enabled);
-	OFFSET(PARAVIRT_irq_disable, paravirt_ops, pv_irq_ops.irq_disable);
-	OFFSET(PARAVIRT_irq_enable, paravirt_ops, pv_irq_ops.irq_enable);
-	OFFSET(PARAVIRT_irq_enable_sysexit, paravirt_ops, pv_cpu_ops.irq_enable_sysexit);
-	OFFSET(PARAVIRT_iret, paravirt_ops, pv_cpu_ops.iret);
-	OFFSET(PARAVIRT_read_cr0, paravirt_ops, pv_cpu_ops.read_cr0);
+	OFFSET(PARAVIRT_PATCH_pv_cpu_ops, paravirt_patch_template, pv_cpu_ops);
+	OFFSET(PARAVIRT_PATCH_pv_irq_ops, paravirt_patch_template, pv_irq_ops);
+	OFFSET(PV_IRQ_irq_disable, pv_irq_ops, irq_disable);
+	OFFSET(PV_IRQ_irq_enable, pv_irq_ops, irq_enable);
+	OFFSET(PV_CPU_iret, pv_cpu_ops, iret);
+	OFFSET(PV_CPU_irq_enable_sysexit, pv_cpu_ops, irq_enable_sysexit);
+	OFFSET(PV_CPU_read_cr0, pv_cpu_ops, read_cr0);
 #endif
 
 #ifdef CONFIG_XEN
diff -r d8192c55373b arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c	Mon Oct 15 16:56:40 2007 +1000
+++ b/arch/i386/kernel/paravirt.c	Mon Oct 15 18:10:52 2007 +1000
@@ -34,8 +34,6 @@
 #include <asm/tlbflush.h>
 #include <asm/timer.h>
 
-struct paravirt_ops paravirt_ops;
-
 /* nop stub */
 void _paravirt_nop(void)
 {
@@ -160,10 +158,26 @@ unsigned paravirt_patch_jmp(void *insnbu
 	return 5;
 }
 
+/* Neat trick to map patch type back to the call within the
+ * corresponding structure. */
+static void *get_call_destination(u8 type)
+{
+	struct paravirt_patch_template tmpl = {
+		.pv_init_ops = pv_init_ops,
+		.pv_misc_ops = pv_misc_ops,
+		.pv_time_ops = pv_time_ops,
+		.pv_cpu_ops = pv_cpu_ops,
+		.pv_irq_ops = pv_irq_ops,
+		.pv_apic_ops = pv_apic_ops,
+		.pv_mmu_ops = pv_mmu_ops,
+	};
+	return *((void **)&tmpl + type);
+}
+
 unsigned paravirt_patch_default(u8 type, u16 clobbers, void *insnbuf,
 				unsigned long addr, unsigned len)
 {
-	void *opfunc = *((void **)&paravirt_ops + type);
+	void *opfunc = get_call_destination(type);
 	unsigned ret;
 
 	if (opfunc == NULL)
@@ -275,160 +289,136 @@ struct pv_info pv_info = {
 	.shared_kernel_pmd = 1,	/* Only used when CONFIG_X86_PAE is set */
 };
 
-struct paravirt_ops paravirt_ops = {
-	.pv_init_ops = {
-		 .patch = native_patch,
-		 .banner = default_banner,
-		 .arch_setup = paravirt_nop,
-		 .memory_setup = machine_specific_memory_setup,
-	 },
-
-	.pv_time_ops = {
-		 .time_init = hpet_time_init,
-		 .get_wallclock = native_get_wallclock,
-		 .set_wallclock = native_set_wallclock,
-		 .sched_clock = native_sched_clock,
-		 .get_cpu_khz = native_calculate_cpu_khz,
-	 },
-
-	.pv_irq_ops = {
-		 .init_IRQ = native_init_IRQ,
-		 .save_fl = native_save_fl,
-		 .restore_fl = native_restore_fl,
-		 .irq_disable = native_irq_disable,
-		 .irq_enable = native_irq_enable,
-		 .safe_halt = native_safe_halt,
-		 .halt = native_halt,
-	 },
-
-	.pv_cpu_ops = {
-		 .cpuid = native_cpuid,
-		 .get_debugreg = native_get_debugreg,
-		 .set_debugreg = native_set_debugreg,
-		 .clts = native_clts,
-		 .read_cr0 = native_read_cr0,
-		 .write_cr0 = native_write_cr0,
-		 .read_cr4 = native_read_cr4,
-		 .read_cr4_safe = native_read_cr4_safe,
-		 .write_cr4 = native_write_cr4,
-		 .wbinvd = native_wbinvd,
-		 .read_msr = native_read_msr_safe,
-		 .write_msr = native_write_msr_safe,
-		 .read_tsc = native_read_tsc,
-		 .read_pmc = native_read_pmc,
-		 .load_tr_desc = native_load_tr_desc,
-		 .set_ldt = native_set_ldt,
-		 .load_gdt = native_load_gdt,
-		 .load_idt = native_load_idt,
-		 .store_gdt = native_store_gdt,
-		 .store_idt = native_store_idt,
-		 .store_tr = native_store_tr,
-		 .load_tls = native_load_tls,
-		 .write_ldt_entry = write_dt_entry,
-		 .write_gdt_entry = write_dt_entry,
-		 .write_idt_entry = write_dt_entry,
-		 .load_esp0 = native_load_esp0,
-
-		 .irq_enable_sysexit = native_irq_enable_sysexit,
-		 .iret = native_iret,
-
-		 .set_iopl_mask = native_set_iopl_mask,
-		 .io_delay = native_io_delay,
-	 },
-
-	.pv_apic_ops = {
+struct pv_init_ops pv_init_ops = {
+	.patch = native_patch,
+	.banner = default_banner,
+	.arch_setup = paravirt_nop,
+	.memory_setup = machine_specific_memory_setup,
+};
+
+struct pv_time_ops pv_time_ops = {
+	.time_init = hpet_time_init,
+	.get_wallclock = native_get_wallclock,
+	.set_wallclock = native_set_wallclock,
+	.sched_clock = native_sched_clock,
+	.get_cpu_khz = native_calculate_cpu_khz,
+};
+
+struct pv_irq_ops pv_irq_ops = {
+	.init_IRQ = native_init_IRQ,
+	.save_fl = native_save_fl,
+	.restore_fl = native_restore_fl,
+	.irq_disable = native_irq_disable,
+	.irq_enable = native_irq_enable,
+	.safe_halt = native_safe_halt,
+	.halt = native_halt,
+};
+
+struct pv_cpu_ops pv_cpu_ops = {
+	.cpuid = native_cpuid,
+	.get_debugreg = native_get_debugreg,
+	.set_debugreg = native_set_debugreg,
+	.clts = native_clts,
+	.read_cr0 = native_read_cr0,
+	.write_cr0 = native_write_cr0,
+	.read_cr4 = native_read_cr4,
+	.read_cr4_safe = native_read_cr4_safe,
+	.write_cr4 = native_write_cr4,
+	.wbinvd = native_wbinvd,
+	.read_msr = native_read_msr_safe,
+	.write_msr = native_write_msr_safe,
+	.read_tsc = native_read_tsc,
+	.read_pmc = native_read_pmc,
+	.load_tr_desc = native_load_tr_desc,
+	.set_ldt = native_set_ldt,
+	.load_gdt = native_load_gdt,
+	.load_idt = native_load_idt,
+	.store_gdt = native_store_gdt,
+	.store_idt = native_store_idt,
+	.store_tr = native_store_tr,
+	.load_tls = native_load_tls,
+	.write_ldt_entry = write_dt_entry,
+	.write_gdt_entry = write_dt_entry,
+	.write_idt_entry = write_dt_entry,
+	.load_esp0 = native_load_esp0,
+
+	.irq_enable_sysexit = native_irq_enable_sysexit,
+	.iret = native_iret,
+
+	.set_iopl_mask = native_set_iopl_mask,
+	.io_delay = native_io_delay,
+};
+
+struct pv_apic_ops pv_apic_ops = {
 #ifdef CONFIG_X86_LOCAL_APIC
-		 .apic_write = native_apic_write,
-		 .apic_write_atomic = native_apic_write_atomic,
-		 .apic_read = native_apic_read,
-		 .setup_boot_clock = setup_boot_APIC_clock,
-		 .setup_secondary_clock = setup_secondary_APIC_clock,
-		 .startup_ipi_hook = paravirt_nop,
+	.apic_write = native_apic_write,
+	.apic_write_atomic = native_apic_write_atomic,
+	.apic_read = native_apic_read,
+	.setup_boot_clock = setup_boot_APIC_clock,
+	.setup_secondary_clock = setup_secondary_APIC_clock,
+	.startup_ipi_hook = paravirt_nop,
 #endif
-	 },
-
-	.pv_misc_ops = {
-		 .set_lazy_mode = paravirt_nop,
-	 },
-
-	.pv_mmu_ops = {
-		 .pagetable_setup_start = native_pagetable_setup_start,
-		 .pagetable_setup_done = native_pagetable_setup_done,
-
-		 .read_cr2 = native_read_cr2,
-		 .write_cr2 = native_write_cr2,
-		 .read_cr3 = native_read_cr3,
-		 .write_cr3 = native_write_cr3,
-
-		 .flush_tlb_user = native_flush_tlb,
-		 .flush_tlb_kernel = native_flush_tlb_global,
-		 .flush_tlb_single = native_flush_tlb_single,
-		 .flush_tlb_others = native_flush_tlb_others,
-
-		 .alloc_pt = paravirt_nop,
-		 .alloc_pd = paravirt_nop,
-		 .alloc_pd_clone = paravirt_nop,
-		 .release_pt = paravirt_nop,
-		 .release_pd = paravirt_nop,
-
-		 .set_pte = native_set_pte,
-		 .set_pte_at = native_set_pte_at,
-		 .set_pmd = native_set_pmd,
-		 .pte_update = paravirt_nop,
-		 .pte_update_defer = paravirt_nop,
+};
+
+struct pv_misc_ops pv_misc_ops = {
+	.set_lazy_mode = paravirt_nop,
+};
+
+struct pv_mmu_ops pv_mmu_ops = {
+	.pagetable_setup_start = native_pagetable_setup_start,
+	.pagetable_setup_done = native_pagetable_setup_done,
+
+	.read_cr2 = native_read_cr2,
+	.write_cr2 = native_write_cr2,
+	.read_cr3 = native_read_cr3,
+	.write_cr3 = native_write_cr3,
+
+	.flush_tlb_user = native_flush_tlb,
+	.flush_tlb_kernel = native_flush_tlb_global,
+	.flush_tlb_single = native_flush_tlb_single,
+	.flush_tlb_others = native_flush_tlb_others,
+
+	.alloc_pt = paravirt_nop,
+	.alloc_pd = paravirt_nop,
+	.alloc_pd_clone = paravirt_nop,
+	.release_pt = paravirt_nop,
+	.release_pd = paravirt_nop,
+
+	.set_pte = native_set_pte,
+	.set_pte_at = native_set_pte_at,
+	.set_pmd = native_set_pmd,
+	.pte_update = paravirt_nop,
+	.pte_update_defer = paravirt_nop,
 
 #ifdef CONFIG_HIGHPTE
-		 .kmap_atomic_pte = kmap_atomic,
+	.kmap_atomic_pte = kmap_atomic,
 #endif
 
 #ifdef CONFIG_X86_PAE
-		 .set_pte_atomic = native_set_pte_atomic,
-		 .set_pte_present = native_set_pte_present,
-		 .set_pud = native_set_pud,
-		 .pte_clear = native_pte_clear,
-		 .pmd_clear = native_pmd_clear,
-
-		 .pmd_val = native_pmd_val,
-		 .make_pmd = native_make_pmd,
+	.set_pte_atomic = native_set_pte_atomic,
+	.set_pte_present = native_set_pte_present,
+	.set_pud = native_set_pud,
+	.pte_clear = native_pte_clear,
+	.pmd_clear = native_pmd_clear,
+
+	.pmd_val = native_pmd_val,
+	.make_pmd = native_make_pmd,
 #endif
 
-		 .pte_val = native_pte_val,
-		 .pgd_val = native_pgd_val,
-
-		 .make_pte = native_make_pte,
-		 .make_pgd = native_make_pgd,
-
-		 .dup_mmap = paravirt_nop,
-		 .exit_mmap = paravirt_nop,
-		 .activate_mm = paravirt_nop,
-	 },
-};
-
-static void __init __used pv_aliases(void)
-{
-	/*
-	 * These asm statements need to be wrapped in a function just
-	 * so we can pass args to them; they are completely constant,
-	 * and this function is never executed.
-	 */
-#define substructure(inner)						\
-	asm volatile(".data; .globl " #inner "; "			\
-		     #inner " = paravirt_ops+%c0; .previous"		\
-		     : : "i" (offsetof(struct paravirt_ops, inner)))
-
-	substructure(pv_init_ops);
-	substructure(pv_misc_ops);
-	substructure(pv_time_ops);
-	substructure(pv_cpu_ops);
-	substructure(pv_irq_ops);
-	substructure(pv_apic_ops);
-	substructure(pv_mmu_ops);
-
-#undef substructure
-}
+	.pte_val = native_pte_val,
+	.pgd_val = native_pgd_val,
+
+	.make_pte = native_make_pte,
+	.make_pgd = native_make_pgd,
+
+	.dup_mmap = paravirt_nop,
+	.exit_mmap = paravirt_nop,
+	.activate_mm = paravirt_nop,
+};
 
 EXPORT_SYMBOL_GPL(pv_time_ops);
 EXPORT_SYMBOL_GPL(pv_cpu_ops);
 EXPORT_SYMBOL_GPL(pv_mmu_ops);
 EXPORT_SYMBOL_GPL(pv_apic_ops);
+EXPORT_SYMBOL_GPL(pv_info);
 EXPORT_SYMBOL    (pv_irq_ops);
diff -r d8192c55373b drivers/char/hvc_lguest.c
--- a/drivers/char/hvc_lguest.c	Mon Oct 15 16:56:40 2007 +1000
+++ b/drivers/char/hvc_lguest.c	Mon Oct 15 18:10:52 2007 +1000
@@ -115,7 +115,7 @@ static struct hv_ops lguest_cons = {
  * (0), and the struct hv_ops containing the put_chars() function. */
 static int __init cons_init(void)
 {
-	if (strcmp(paravirt_ops.name, "lguest") != 0)
+	if (strcmp(pv_info.name, "lguest") != 0)
 		return 0;
 
 	return hvc_instantiate(0, 0, &lguest_cons);
diff -r d8192c55373b drivers/lguest/core.c
--- a/drivers/lguest/core.c	Mon Oct 15 16:56:40 2007 +1000
+++ b/drivers/lguest/core.c	Mon Oct 15 18:10:52 2007 +1000
@@ -248,8 +248,8 @@ static void unmap_switcher(void)
 }
 
 /*H:130 Our Guest is usually so well behaved; it never tries to do things it
- * isn't allowed to.  Unfortunately, "struct paravirt_ops" isn't quite
- * complete, because it doesn't contain replacements for the Intel I/O
+ * isn't allowed to.  Unfortunately, Linux's paravirtual infrastructure isn't
+ * quite complete, because it doesn't contain replacements for the Intel I/O
  * instructions.  As a result, the Guest sometimes fumbles across one during
  * the boot process as it probes for various things which are usually attached
  * to a PC.
diff -r d8192c55373b drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c	Mon Oct 15 16:56:40 2007 +1000
+++ b/drivers/lguest/lguest.c	Mon Oct 15 18:10:52 2007 +1000
@@ -23,7 +23,7 @@
  *
  * So how does the kernel know it's a Guest?  The Guest starts at a special
  * entry point marked with a magic string, which sets up a few things then
- * calls here.  We replace the native functions in "struct paravirt_ops"
+ * calls here.  We replace the native functions various "paravirt" structures
  * with our Guest versions, then boot like normal. :*/
 
 /*
@@ -331,7 +331,7 @@ static void lguest_load_tls(struct threa
 }
 
 /*G:038 That's enough excitement for now, back to ploughing through each of
- * the paravirt_ops (we're about 1/3 of the way through).
+ * the different pv_ops structures (we're about 1/3 of the way through).
  *
  * This is the Local Descriptor Table, another weird Intel thingy.  Linux only
  * uses this for some strange applications like Wine.  We don't do anything
@@ -558,7 +558,7 @@ static void lguest_set_pte(pte_t *ptep, 
 		lazy_hcall(LHCALL_FLUSH_TLB, 1, 0, 0);
 }
 
-/* Unfortunately for Lguest, the paravirt_ops for page tables were based on
+/* Unfortunately for Lguest, the pv_mmu_ops for page tables were based on
  * native page table operations.  On native hardware you can set a new page
  * table entry whenever you want, but if you want to remove one you have to do
  * a TLB flush (a TLB is a little cache of page table entries kept by the CPU).
@@ -902,7 +902,7 @@ static __init char *lguest_memory_setup(
 /*G:050
  * Patching (Powerfully Placating Performance Pedants)
  *
- * We have already seen that "struct paravirt_ops" lets us replace simple
+ * We have already seen that pv_ops structures let us replace simple
  * native instructions with calls to the appropriate back end all throughout
  * the kernel.  This allows the same kernel to run as a Guest and as a native
  * kernel, but it's slow because of all the indirect branches.
@@ -957,9 +957,9 @@ static unsigned lguest_patch(u8 type, u1
 	return insn_len;
 }
 
-/*G:030 Once we get to lguest_init(), we know we're a Guest.  The paravirt_ops
- * structure in the kernel provides a single point for (almost) every routine
- * we have to override to avoid privileged instructions. */
+/*G:030 Once we get to lguest_init(), we know we're a Guest.  The pv_ops
+ * structures in the kernel provide points for (almost) every routine we have
+ * to override to avoid privileged instructions. */
 __init void lguest_init(void *boot)
 {
 	/* Copy boot parameters first: the Launcher put the physical location
diff -r d8192c55373b include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Mon Oct 15 16:56:40 2007 +1000
+++ b/include/asm-i386/paravirt.h	Mon Oct 15 18:10:52 2007 +1000
@@ -246,7 +246,10 @@ struct pv_mmu_ops {
 #endif
 };
 
-struct paravirt_ops
+/* This contains all the paravirt structures: we get a convenient
+ * number for each function using the offset which we use to indicate
+ * what to patch. */
+struct paravirt_patch_template
 {
 	struct pv_init_ops pv_init_ops;
 	struct pv_misc_ops pv_misc_ops;
@@ -267,7 +270,7 @@ extern struct pv_mmu_ops pv_mmu_ops;
 extern struct pv_mmu_ops pv_mmu_ops;
 
 #define PARAVIRT_PATCH(x)					\
-	(offsetof(struct paravirt_ops, x) / sizeof(void *))
+	(offsetof(struct paravirt_patch_template, x) / sizeof(void *))
 
 #define paravirt_type(op)				\
 	[paravirt_typenum] "i" (PARAVIRT_PATCH(op)),	\
@@ -311,14 +314,14 @@ int paravirt_disable_iospace(void);
 /*
  * This generates an indirect call based on the operation type number.
  * The type number, computed in PARAVIRT_PATCH, is derived from the
- * offset into the paravirt_ops structure, and can therefore be freely
- * converted back into a structure offset.
+ * offset into the paravirt_patch_template structure, and can therefore be
+ * freely converted back into a structure offset.
  */
 #define PARAVIRT_CALL	"call *%[paravirt_opptr];"
 
 /*
- * These macros are intended to wrap calls into a paravirt_ops
- * operation, so that they can be later identified and patched at
+ * These macros are intended to wrap calls through one of the paravirt
+ * ops structs, so that they can be later identified and patched at
  * runtime.
  *
  * Normally, a call to a pv_op function is a simple indirect call:
@@ -341,7 +344,7 @@ int paravirt_disable_iospace(void);
  * The call instruction itself is marked by placing its start address
  * and size into the .parainstructions section, so that
  * apply_paravirt() in arch/i386/kernel/alternative.c can do the
- * appropriate patching under the control of the backend paravirt_ops
+ * appropriate patching under the control of the backend pv_init_ops
  * implementation.
  *
  * Unfortunately there's no way to get gcc to generate the args setup
@@ -1092,7 +1095,7 @@ static inline unsigned long __raw_local_
 
 #else  /* __ASSEMBLY__ */
 
-#define PARA_PATCH(off)	((off) / 4)
+#define PARA_PATCH(struct, off)	((PARAVIRT_PATCH_##struct + (off)) / 4)
 
 #define PARA_SITE(ptype, clobbers, ops)		\
 771:;						\
@@ -1105,29 +1108,29 @@ 772:;						\
 	 .short clobbers;			\
 	.popsection
 
-#define INTERRUPT_RETURN					\
-	PARA_SITE(PARA_PATCH(PARAVIRT_iret), CLBR_NONE,		\
-		  jmp *%cs:paravirt_ops+PARAVIRT_iret)
+#define INTERRUPT_RETURN						\
+	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_iret), CLBR_NONE,	\
+		  jmp *%cs:pv_cpu_ops+PV_CPU_iret)
 
 #define DISABLE_INTERRUPTS(clobbers)					\
-	PARA_SITE(PARA_PATCH(PARAVIRT_irq_disable), clobbers,		\
+	PARA_SITE(PARA_PATCH(pv_irq_ops, PV_IRQ_irq_disable), clobbers, \
 		  pushl %eax; pushl %ecx; pushl %edx;			\
-		  call *%cs:paravirt_ops+PARAVIRT_irq_disable;		\
+		  call *%cs:pv_irq_ops+PV_IRQ_irq_disable;		\
 		  popl %edx; popl %ecx; popl %eax)			\
 
 #define ENABLE_INTERRUPTS(clobbers)					\
-	PARA_SITE(PARA_PATCH(PARAVIRT_irq_enable), clobbers,		\
+	PARA_SITE(PARA_PATCH(pv_irq_ops, PV_IRQ_irq_enable), clobbers,	\
 		  pushl %eax; pushl %ecx; pushl %edx;			\
-		  call *%cs:paravirt_ops+PARAVIRT_irq_enable;		\
+		  call *%cs:pv_irq_ops+PV_IRQ_irq_enable;		\
 		  popl %edx; popl %ecx; popl %eax)
 
-#define ENABLE_INTERRUPTS_SYSEXIT					\
-	PARA_SITE(PARA_PATCH(PARAVIRT_irq_enable_sysexit), CLBR_NONE,	\
-		  jmp *%cs:paravirt_ops+PARAVIRT_irq_enable_sysexit)
+#define ENABLE_INTERRUPTS_SYSEXIT					       \
+	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_irq_enable_sysexit), CLBR_NONE,\
+		  jmp *%cs:pv_cpu_ops+PV_CPU_irq_enable_sysexit)
 
 #define GET_CR0_INTO_EAX			\
 	push %ecx; push %edx;			\
-	call *paravirt_ops+PARAVIRT_read_cr0;	\
+	call *pv_cpu_ops+PV_CPU_read_cr0;	\
 	pop %edx; pop %ecx
 
 #endif /* __ASSEMBLY__ */

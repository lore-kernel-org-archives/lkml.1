Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbZJBB6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbZJBB6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbZJBB6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:58:39 -0400
Received: from kroah.org ([198.145.64.141]:32977 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972AbZJBBcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:45 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:09 2009
Message-Id: <20091002012409.555944588@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [025/136] xen: make -fstack-protector work under Xen
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=xen-make-fstack-protector-work-under-xen.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

commit 577eebeae34d340685d8985dfdb7dfe337c511e8 upstream.

-fstack-protector uses a special per-cpu "stack canary" value.
gcc generates special code in each function to test the canary to make
sure that the function's stack hasn't been overrun.

On x86-64, this is simply an offset of %gs, which is the usual per-cpu
base segment register, so setting it up simply requires loading %gs's
base as normal.

On i386, the stack protector segment is %gs (rather than the usual kernel
percpu %fs segment register).  This requires setting up the full kernel
GDT and then loading %gs accordingly.  We also need to make sure %gs is
initialized when bringing up secondary cpus too.

To keep things consistent, we do the full GDT/segment register setup on
both architectures.

Because we need to avoid -fstack-protected code before setting up the GDT
and because there's no way to disable it on a per-function basis, several
files need to have stack-protector inhibited.

[ Impact: allow Xen booting with stack-protector enabled ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/Makefile     |    4 +
 arch/x86/xen/Makefile    |    2 
 arch/x86/xen/enlighten.c |  131 ++++++++++++++++++++++++++++++++++++++++-------
 arch/x86/xen/smp.c       |    1 
 drivers/xen/Makefile     |    3 +
 5 files changed, 122 insertions(+), 19 deletions(-)

--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -1,6 +1,10 @@
 obj-y	:=  init.o init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
 	    pat.o pgtable.o gup.o
 
+# Make sure __phys_addr has no stackprotector
+nostackp := $(call cc-option, -fno-stack-protector)
+CFLAGS_ioremap.o		:= $(nostackp)
+
 obj-$(CONFIG_SMP)		+= tlb.o
 
 obj-$(CONFIG_X86_32)		+= pgtable_32.o iomap_32.o
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -51,6 +51,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/reboot.h>
+#include <asm/stackprotector.h>
 
 #include "xen-ops.h"
 #include "mmu.h"
@@ -330,18 +331,28 @@ static void xen_load_gdt(const struct de
 	unsigned long frames[pages];
 	int f;
 
-	/* A GDT can be up to 64k in size, which corresponds to 8192
-	   8-byte entries, or 16 4k pages.. */
+	/*
+	 * A GDT can be up to 64k in size, which corresponds to 8192
+	 * 8-byte entries, or 16 4k pages..
+	 */
 
 	BUG_ON(size > 65536);
 	BUG_ON(va & ~PAGE_MASK);
 
 	for (f = 0; va < dtr->address + size; va += PAGE_SIZE, f++) {
 		int level;
-		pte_t *ptep = lookup_address(va, &level);
+		pte_t *ptep;
 		unsigned long pfn, mfn;
 		void *virt;
 
+		/*
+		 * The GDT is per-cpu and is in the percpu data area.
+		 * That can be virtually mapped, so we need to do a
+		 * page-walk to get the underlying MFN for the
+		 * hypercall.  The page can also be in the kernel's
+		 * linear range, so we need to RO that mapping too.
+		 */
+		ptep = lookup_address(va, &level);
 		BUG_ON(ptep == NULL);
 
 		pfn = pte_pfn(*ptep);
@@ -358,6 +369,44 @@ static void xen_load_gdt(const struct de
 		BUG();
 }
 
+/*
+ * load_gdt for early boot, when the gdt is only mapped once
+ */
+static __init void xen_load_gdt_boot(const struct desc_ptr *dtr)
+{
+	unsigned long va = dtr->address;
+	unsigned int size = dtr->size + 1;
+	unsigned pages = (size + PAGE_SIZE - 1) / PAGE_SIZE;
+	unsigned long frames[pages];
+	int f;
+
+	/*
+	 * A GDT can be up to 64k in size, which corresponds to 8192
+	 * 8-byte entries, or 16 4k pages..
+	 */
+
+	BUG_ON(size > 65536);
+	BUG_ON(va & ~PAGE_MASK);
+
+	for (f = 0; va < dtr->address + size; va += PAGE_SIZE, f++) {
+		pte_t pte;
+		unsigned long pfn, mfn;
+
+		pfn = virt_to_pfn(va);
+		mfn = pfn_to_mfn(pfn);
+
+		pte = pfn_pte(pfn, PAGE_KERNEL_RO);
+
+		if (HYPERVISOR_update_va_mapping((unsigned long)va, pte, 0))
+			BUG();
+
+		frames[f] = mfn;
+	}
+
+	if (HYPERVISOR_set_gdt(frames, size / sizeof(struct desc_struct)))
+		BUG();
+}
+
 static void load_TLS_descriptor(struct thread_struct *t,
 				unsigned int cpu, unsigned int i)
 {
@@ -581,6 +630,29 @@ static void xen_write_gdt_entry(struct d
 	preempt_enable();
 }
 
+/*
+ * Version of write_gdt_entry for use at early boot-time needed to
+ * update an entry as simply as possible.
+ */
+static __init void xen_write_gdt_entry_boot(struct desc_struct *dt, int entry,
+					    const void *desc, int type)
+{
+	switch (type) {
+	case DESC_LDT:
+	case DESC_TSS:
+		/* ignore */
+		break;
+
+	default: {
+		xmaddr_t maddr = virt_to_machine(&dt[entry]);
+
+		if (HYPERVISOR_update_descriptor(maddr.maddr, *(u64 *)desc))
+			dt[entry] = *(struct desc_struct *)desc;
+	}
+
+	}
+}
+
 static void xen_load_sp0(struct tss_struct *tss,
 			 struct thread_struct *thread)
 {
@@ -965,6 +1037,23 @@ static const struct machine_ops __initda
 	.emergency_restart = xen_emergency_restart,
 };
 
+/*
+ * Set up the GDT and segment registers for -fstack-protector.  Until
+ * we do this, we have to be careful not to call any stack-protected
+ * function, which is most of the kernel.
+ */
+static void __init xen_setup_stackprotector(void)
+{
+	pv_cpu_ops.write_gdt_entry = xen_write_gdt_entry_boot;
+	pv_cpu_ops.load_gdt = xen_load_gdt_boot;
+
+	setup_stack_canary_segment(0);
+	switch_to_new_gdt(0);
+
+	pv_cpu_ops.write_gdt_entry = xen_write_gdt_entry;
+	pv_cpu_ops.load_gdt = xen_load_gdt;
+}
+
 /* First C function to be called on Xen boot */
 asmlinkage void __init xen_start_kernel(void)
 {
@@ -983,13 +1072,28 @@ asmlinkage void __init xen_start_kernel(
 	pv_apic_ops = xen_apic_ops;
 	pv_mmu_ops = xen_mmu_ops;
 
-#ifdef CONFIG_X86_64
 	/*
-	 * Setup percpu state.  We only need to do this for 64-bit
-	 * because 32-bit already has %fs set properly.
+	 * Set up some pagetable state before starting to set any ptes.
 	 */
-	load_percpu_segment(0);
-#endif
+
+	/* Prevent unwanted bits from being set in PTEs. */
+	__supported_pte_mask &= ~_PAGE_GLOBAL;
+	if (!xen_initial_domain())
+		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
+
+	__supported_pte_mask |= _PAGE_IOMAP;
+
+	xen_setup_features();
+
+	/* Get mfn list */
+	if (!xen_feature(XENFEAT_auto_translated_physmap))
+		xen_build_dynamic_phys_to_machine();
+
+	/*
+	 * Set up kernel GDT and segment registers, mainly so that
+	 * -fstack-protector code can be executed.
+	 */
+	xen_setup_stackprotector();
 
 	xen_init_irq_ops();
 	xen_init_cpuid_mask();
@@ -1001,8 +1105,6 @@ asmlinkage void __init xen_start_kernel(
 	set_xen_basic_apic_ops();
 #endif
 
-	xen_setup_features();
-
 	if (xen_feature(XENFEAT_mmu_pt_update_preserve_ad)) {
 		pv_mmu_ops.ptep_modify_prot_start = xen_ptep_modify_prot_start;
 		pv_mmu_ops.ptep_modify_prot_commit = xen_ptep_modify_prot_commit;
@@ -1019,17 +1121,8 @@ asmlinkage void __init xen_start_kernel(
 
 	xen_smp_init();
 
-	/* Get mfn list */
-	if (!xen_feature(XENFEAT_auto_translated_physmap))
-		xen_build_dynamic_phys_to_machine();
-
 	pgd = (pgd_t *)xen_start_info->pt_base;
 
-	/* Prevent unwanted bits from being set in PTEs. */
-	__supported_pte_mask &= ~_PAGE_GLOBAL;
-	if (!xen_initial_domain())
-		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
-
 #ifdef CONFIG_X86_64
 	/* Work out if we support NX */
 	check_efer();
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -8,6 +8,7 @@ endif
 # Make sure early boot has no stackprotector
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_enlighten.o		:= $(nostackp)
+CFLAGS_mmu.o			:= $(nostackp)
 
 obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 			time.o xen-asm.o xen-asm_$(BITS).o \
@@ -16,3 +17,4 @@ obj-y		:= enlighten.o setup.o multicalls
 obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
+
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -236,6 +236,7 @@ cpu_initialize_context(unsigned int cpu,
 	ctxt->user_regs.ss = __KERNEL_DS;
 #ifdef CONFIG_X86_32
 	ctxt->user_regs.fs = __KERNEL_PERCPU;
+	ctxt->user_regs.gs = __KERNEL_STACK_CANARY;
 #else
 	ctxt->gs_base_kernel = per_cpu_offset(cpu);
 #endif
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,6 +1,9 @@
 obj-y	+= grant-table.o features.o events.o manage.o
 obj-y	+= xenbus/
 
+nostackp := $(call cc-option, -fno-stack-protector)
+CFLAGS_features.o			:= $(nostackp)
+
 obj-$(CONFIG_HOTPLUG_CPU)	+= cpu_hotplug.o
 obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
 obj-$(CONFIG_XEN_BALLOON)	+= balloon.o



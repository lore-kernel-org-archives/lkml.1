Return-Path: <linux-kernel-owner+w=401wt.eu-S1031065AbXD2Rkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031065AbXD2Rkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030942AbXD2RbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:31:12 -0400
Received: from gw.goop.org ([64.81.55.164]:58978 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139AbXD2RaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:30:19 -0400
Message-Id: <20070429172911.435051000@goop.org>
References: <20070429172835.284784000@goop.org>
User-Agent: quilt/0.46-1
Date: Sun, 29 Apr 2007 10:28:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Adrian Bunk <bunk@stusta.de>
Subject: [patch 05/32] xen: Core Xen implementation
Content-Disposition: inline; filename=xen-core.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a rollup of all the core pieces of the Xen
implementation, including:
 - booting and setup
 - pagetable setup
 - privileged instructions
 - segmentation
 - multicall batching

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Ian Pratt <ian.pratt@xensource.com>
Cc: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Cc: Adrian Bunk <bunk@stusta.de>

---
 arch/i386/Makefile               |    3 
 arch/i386/kernel/entry.S         |   71 +++
 arch/i386/kernel/head.S          |    5 
 arch/i386/kernel/vmlinux.lds.S   |    1 
 arch/i386/xen/Makefile           |    1 
 arch/i386/xen/enlighten.c        |  733 ++++++++++++++++++++++++++++++++++++++
 arch/i386/xen/features.c         |   29 +
 arch/i386/xen/multicalls.c       |   82 ++++
 arch/i386/xen/multicalls.h       |   26 +
 arch/i386/xen/setup.c            |   96 ++++
 arch/i386/xen/xen-head.S         |   34 +
 arch/i386/xen/xen-ops.h          |   34 +
 include/asm-i386/irq.h           |    1 
 include/asm-i386/xen/hypercall.h |   18 
 include/xen/features.h           |   23 +
 include/xen/page.h               |  178 +++++++++
 16 files changed, 1334 insertions(+), 1 deletion(-)

===================================================================
--- a/arch/i386/Makefile
+++ b/arch/i386/Makefile
@@ -93,6 +93,9 @@ mcore-$(CONFIG_X86_ES7000)	:= mach-defau
 mcore-$(CONFIG_X86_ES7000)	:= mach-default
 core-$(CONFIG_X86_ES7000)	:= arch/i386/mach-es7000/
 
+# Xen paravirtualization support
+core-$(CONFIG_XEN)		+= arch/i386/xen/
+
 # default subarch .h files
 mflags-y += -Iinclude/asm-i386/mach-default
 
===================================================================
--- a/arch/i386/kernel/entry.S
+++ b/arch/i386/kernel/entry.S
@@ -1023,6 +1023,77 @@ ENTRY(kernel_thread_helper)
 	CFI_ENDPROC
 ENDPROC(kernel_thread_helper)
 
+#ifdef CONFIG_XEN
+ENTRY(xen_hypervisor_callback)
+	CFI_STARTPROC
+	pushl $0
+	CFI_ADJUST_CFA_OFFSET 4
+	SAVE_ALL
+	TRACE_IRQS_OFF
+	mov %esp, %eax
+	call xen_evtchn_do_upcall
+	jmp  ret_from_intr
+	CFI_ENDPROC
+ENDPROC(xen_hypervisor_callback)
+
+# Hypervisor uses this for application faults while it executes.
+# We get here for two reasons:
+#  1. Fault while reloading DS, ES, FS or GS
+#  2. Fault while executing IRET
+# Category 1 we fix up by reattempting the load, and zeroing the segment
+# register if the load fails.
+# Category 2 we fix up by jumping to do_iret_error. We cannot use the
+# normal Linux return path in this case because if we use the IRET hypercall
+# to pop the stack frame we end up in an infinite loop of failsafe callbacks.
+# We distinguish between categories by maintaining a status value in EAX.
+ENTRY(xen_failsafe_callback)
+	CFI_STARTPROC
+	pushl %eax
+	CFI_ADJUST_CFA_OFFSET 4
+	movl $1,%eax
+1:	mov 4(%esp),%ds
+2:	mov 8(%esp),%es
+3:	mov 12(%esp),%fs
+4:	mov 16(%esp),%gs
+	testl %eax,%eax
+	popl %eax
+	CFI_ADJUST_CFA_OFFSET -4
+	lea 16(%esp),%esp
+	CFI_ADJUST_CFA_OFFSET -16
+	jz 5f
+	addl $16,%esp
+	jmp iret_exc		# EAX != 0 => Category 2 (Bad IRET)
+5:	pushl $0		# EAX == 0 => Category 1 (Bad segment)
+	CFI_ADJUST_CFA_OFFSET 4
+	SAVE_ALL
+	jmp ret_from_exception
+	CFI_ENDPROC
+
+.section .fixup,"ax"
+6:	xorl %eax,%eax
+	movl %eax,4(%esp)
+	jmp 1b
+7:	xorl %eax,%eax
+	movl %eax,8(%esp)
+	jmp 2b
+8:	xorl %eax,%eax
+	movl %eax,12(%esp)
+	jmp 3b
+9:	xorl %eax,%eax
+	movl %eax,16(%esp)
+	jmp 4b
+.previous
+.section __ex_table,"a"
+	.align 4
+	.long 1b,6b
+	.long 2b,7b
+	.long 3b,8b
+	.long 4b,9b
+.previous
+ENDPROC(xen_failsafe_callback)
+
+#endif	/* CONFIG_XEN */
+
 .section .rodata,"a"
 #include "syscall_table.S"
 
===================================================================
--- a/arch/i386/kernel/head.S
+++ b/arch/i386/kernel/head.S
@@ -545,6 +545,8 @@ unhandled_paravirt:
 	ud2
 #endif
 
+#include "../xen/xen-head.S"
+
 /*
  * Real beginning of normal "text" segment
  */
@@ -554,7 +556,8 @@ ENTRY(_stext)
 /*
  * BSS section
  */
-.section ".bss.page_aligned","w"
+.section ".bss.page_aligned","wa"
+	.align PAGE_SIZE_asm
 ENTRY(swapper_pg_dir)
 	.fill 1024,4,0
 ENTRY(empty_zero_page)
===================================================================
--- a/arch/i386/kernel/vmlinux.lds.S
+++ b/arch/i386/kernel/vmlinux.lds.S
@@ -94,6 +94,7 @@ SECTIONS
 
   . = ALIGN(4096);
   .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
+	*(.data.page_aligned)
 	*(.data.idt)
   }
 
===================================================================
--- /dev/null
+++ b/arch/i386/xen/Makefile
@@ -0,0 +1,1 @@
+obj-y		:= enlighten.o setup.o features.o multicalls.o
===================================================================
--- /dev/null
+++ b/arch/i386/xen/enlighten.c
@@ -0,0 +1,733 @@
+/*
+ * Core of Xen paravirt_ops implementation.
+ *
+ * This file contains the xen_paravirt_ops structure itself, and the
+ * implementations for:
+ * - privileged instructions
+ * - interrupt flags
+ * - segment operations
+ * - booting and setup
+ *
+ * Jeremy Fitzhardinge <jeremy@xensource.com>, XenSource Inc, 2007
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/smp.h>
+#include <linux/preempt.h>
+#include <linux/percpu.h>
+#include <linux/delay.h>
+#include <linux/start_kernel.h>
+#include <linux/sched.h>
+#include <linux/bootmem.h>
+#include <linux/module.h>
+
+#include <xen/interface/xen.h>
+#include <xen/interface/physdev.h>
+#include <xen/interface/vcpu.h>
+#include <xen/features.h>
+#include <xen/page.h>
+
+#include <asm/paravirt.h>
+#include <asm/page.h>
+#include <asm/xen/hypercall.h>
+#include <asm/xen/hypervisor.h>
+#include <asm/fixmap.h>
+#include <asm/processor.h>
+#include <asm/setup.h>
+#include <asm/desc.h>
+#include <asm/pgtable.h>
+
+#include "xen-ops.h"
+#include "multicalls.h"
+
+EXPORT_SYMBOL_GPL(hypercall_page);
+
+DEFINE_PER_CPU(enum paravirt_lazy_mode, xen_lazy_mode);
+
+DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);
+DEFINE_PER_CPU(struct vcpu_info, xen_vcpu_info);
+DEFINE_PER_CPU(unsigned long, xen_cr3);
+
+struct start_info *xen_start_info;
+EXPORT_SYMBOL_GPL(xen_start_info);
+
+static void xen_vcpu_setup(int cpu)
+{
+	per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
+}
+
+static void __init xen_banner(void)
+{
+	printk(KERN_INFO "Booting paravirtualized kernel on %s\n",
+	       paravirt_ops.name);
+	printk(KERN_INFO "Hypervisor signature: %s\n", xen_start_info->magic);
+}
+
+static void xen_cpuid(unsigned int *eax, unsigned int *ebx,
+		      unsigned int *ecx, unsigned int *edx)
+{
+	unsigned maskedx = ~0;
+
+	/*
+	 * Mask out inconvenient features, to try and disable as many
+	 * unsupported kernel subsystems as possible.
+	 */
+	if (*eax == 1)
+		maskedx = ~((1 << X86_FEATURE_APIC) |  /* disable APIC */
+			    (1 << X86_FEATURE_ACPI) |  /* disable ACPI */
+			    (1 << X86_FEATURE_ACC));   /* thermal monitoring */
+
+	asm(XEN_EMULATE_PREFIX "cpuid"
+		: "=a" (*eax),
+		  "=b" (*ebx),
+		  "=c" (*ecx),
+		  "=d" (*edx)
+		: "0" (*eax), "2" (*ecx));
+	*edx &= maskedx;
+}
+
+static void xen_set_debugreg(int reg, unsigned long val)
+{
+	HYPERVISOR_set_debugreg(reg, val);
+}
+
+static unsigned long xen_get_debugreg(int reg)
+{
+	return HYPERVISOR_get_debugreg(reg);
+}
+
+static unsigned long xen_save_fl(void)
+{
+	struct vcpu_info *vcpu;
+	unsigned long flags;
+
+	preempt_disable();
+	vcpu = x86_read_percpu(xen_vcpu);
+	/* flag has opposite sense of mask */
+	flags = !vcpu->evtchn_upcall_mask;
+	preempt_enable();
+
+	/* convert to IF type flag
+	   -0 -> 0x00000000
+	   -1 -> 0xffffffff
+	*/
+	return (-flags) & X86_EFLAGS_IF;
+}
+
+static void xen_restore_fl(unsigned long flags)
+{
+	struct vcpu_info *vcpu;
+
+	preempt_disable();
+
+	/* convert from IF type flag */
+	flags = !(flags & X86_EFLAGS_IF);
+	vcpu = x86_read_percpu(xen_vcpu);
+	vcpu->evtchn_upcall_mask = flags;
+
+	if (flags == 0) {
+		/* Unmask then check (avoid races).  We're only protecting
+		   against updates by this CPU, so there's no need for
+		   anything stronger. */
+		barrier();
+
+		if (unlikely(vcpu->evtchn_upcall_pending))
+			force_evtchn_callback();
+		preempt_enable();
+	} else
+		preempt_enable_no_resched();
+}
+
+static void xen_irq_disable(void)
+{
+	struct vcpu_info *vcpu;
+	preempt_disable();
+	vcpu = x86_read_percpu(xen_vcpu);
+	vcpu->evtchn_upcall_mask = 1;
+	preempt_enable_no_resched();
+}
+
+static void xen_irq_enable(void)
+{
+	struct vcpu_info *vcpu;
+
+	preempt_disable();
+	vcpu = x86_read_percpu(xen_vcpu);
+	vcpu->evtchn_upcall_mask = 0;
+
+	/* Unmask then check (avoid races).  We're only protecting
+	   against updates by this CPU, so there's no need for
+	   anything stronger. */
+	barrier();
+
+	if (unlikely(vcpu->evtchn_upcall_pending))
+		force_evtchn_callback();
+	preempt_enable();
+}
+
+static void xen_safe_halt(void)
+{
+	/* Blocking includes an implicit local_irq_enable(). */
+	if (HYPERVISOR_sched_op(SCHEDOP_block, 0) != 0)
+		BUG();
+}
+
+static void xen_halt(void)
+{
+	if (irqs_disabled())
+		HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);
+	else
+		xen_safe_halt();
+}
+
+static void xen_set_lazy_mode(enum paravirt_lazy_mode mode)
+{
+	enum paravirt_lazy_mode *lazy = &get_cpu_var(xen_lazy_mode);
+
+	xen_mc_flush();
+
+	*lazy = mode;
+
+	put_cpu_var(xen_lazy_mode);
+}
+
+static unsigned long xen_store_tr(void)
+{
+	return 0;
+}
+
+static void xen_set_ldt(const void *addr, unsigned entries)
+{
+	unsigned long linear_addr = (unsigned long)addr;
+	struct mmuext_op *op;
+	struct multicall_space mcs = xen_mc_entry(sizeof(*op));
+
+	op = mcs.args;
+	op->cmd = MMUEXT_SET_LDT;
+	if (linear_addr) {
+		/* ldt my be vmalloced, use arbitrary_virt_to_machine */
+		xmaddr_t maddr;
+		maddr = arbitrary_virt_to_machine((unsigned long)addr);
+		linear_addr = (unsigned long)maddr.maddr;
+	}
+	op->arg1.linear_addr = linear_addr;
+	op->arg2.nr_ents = entries;
+
+	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
+
+	xen_mc_issue();
+}
+
+static void xen_load_gdt(const struct Xgt_desc_struct *dtr)
+{
+	unsigned long *frames;
+	unsigned long va = dtr->address;
+	unsigned int size = dtr->size + 1;
+	unsigned pages = (size + PAGE_SIZE - 1) / PAGE_SIZE;
+	int f;
+	struct multicall_space mcs;
+
+	/* A GDT can be up to 64k in size, which corresponds to 8192
+	   8-byte entries, or 16 4k pages.. */
+
+	BUG_ON(size > 65536);
+	BUG_ON(va & ~PAGE_MASK);
+
+	mcs = xen_mc_entry(sizeof(*frames) * pages);
+	frames = mcs.args;
+
+	for (f = 0; va < dtr->address + size; va += PAGE_SIZE, f++) {
+		frames[f] = virt_to_mfn(va);
+		make_lowmem_page_readonly((void *)va);
+	}
+
+	MULTI_set_gdt(mcs.mc, frames, size / sizeof(struct desc_struct));
+
+	xen_mc_issue();
+}
+
+static void load_TLS_descriptor(struct thread_struct *t,
+				unsigned int cpu, unsigned int i)
+{
+	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
+	xmaddr_t maddr = virt_to_machine(&gdt[GDT_ENTRY_TLS_MIN+i]);
+	struct multicall_space mc = xen_mc_entry(0);
+
+	MULTI_update_descriptor(mc.mc, maddr.maddr, t->tls_array[i]);
+}
+
+static void xen_load_tls(struct thread_struct *t, unsigned int cpu)
+{
+	load_TLS_descriptor(t, cpu, 0);
+	load_TLS_descriptor(t, cpu, 1);
+	load_TLS_descriptor(t, cpu, 2);
+
+	xen_mc_issue();
+}
+
+static void xen_write_ldt_entry(struct desc_struct *dt, int entrynum, u32 low, u32 high)
+{
+	unsigned long lp = (unsigned long)&dt[entrynum];
+	xmaddr_t mach_lp = virt_to_machine(lp);
+	u64 entry = (u64)high << 32 | low;
+
+	xen_mc_flush();
+	if (HYPERVISOR_update_descriptor(mach_lp.maddr, entry))
+		BUG();
+}
+
+static int cvt_gate_to_trap(int vector, u32 low, u32 high, struct trap_info *info)
+{
+	u8 type, dpl;
+
+	type = (high >> 8) & 0x1f;
+	dpl = (high >> 13) & 3;
+
+	if (type != 0xf && type != 0xe)
+		return 0;
+
+	info->vector = vector;
+	info->address = (high & 0xffff0000) | (low & 0x0000ffff);
+	info->cs = low >> 16;
+	info->flags = dpl;
+	/* interrupt gates clear IF */
+	if (type == 0xe)
+		info->flags |= 4;
+
+	return 1;
+}
+
+/* Locations of each CPU's IDT */
+static DEFINE_PER_CPU(struct Xgt_desc_struct, idt_desc);
+
+/* Set an IDT entry.  If the entry is part of the current IDT, then
+   also update Xen. */
+static void xen_write_idt_entry(struct desc_struct *dt, int entrynum, u32 low, u32 high)
+{
+
+	int cpu = smp_processor_id();
+	unsigned long p = (unsigned long)&dt[entrynum];
+	unsigned long start = per_cpu(idt_desc, cpu).address;
+	unsigned long end = start + per_cpu(idt_desc, cpu).size + 1;
+
+	xen_mc_flush();
+
+	write_dt_entry(dt, entrynum, low, high);
+
+	if (p >= start && (p + 8) <= end) {
+		struct trap_info info[2];
+
+		info[1].address = 0;
+
+		if (cvt_gate_to_trap(entrynum, low, high, &info[0]))
+			if (HYPERVISOR_set_trap_table(info))
+				BUG();
+	}
+}
+
+/* Load a new IDT into Xen.  In principle this can be per-CPU, so we
+   hold a spinlock to protect the static traps[] array (static because
+   it avoids allocation, and saves stack space). */
+static void xen_load_idt(const struct Xgt_desc_struct *desc)
+{
+	static DEFINE_SPINLOCK(lock);
+	static struct trap_info traps[257];
+
+	int cpu = smp_processor_id();
+	unsigned in, out, count;
+
+	per_cpu(idt_desc, cpu) = *desc;
+
+	count = (desc->size+1) / 8;
+	BUG_ON(count > 256);
+
+	spin_lock(&lock);
+	for(in = out = 0; in < count; in++) {
+		const u32 *entry = (u32 *)(desc->address + in * 8);
+
+		if (cvt_gate_to_trap(in, entry[0], entry[1], &traps[out]))
+			out++;
+	}
+	traps[out].address = 0;
+
+	xen_mc_flush();
+	if (HYPERVISOR_set_trap_table(traps))
+		BUG();
+
+	spin_unlock(&lock);
+}
+
+/* Write a GDT descriptor entry.  Ignore LDT descriptors, since
+   they're handled differently. */
+static void xen_write_gdt_entry(struct desc_struct *dt, int entry, u32 low, u32 high)
+{
+	switch ((high >> 8) & 0xff) {
+	case DESCTYPE_LDT:
+	case DESCTYPE_TSS:
+		/* ignore */
+		break;
+
+	default: {
+		xmaddr_t maddr = virt_to_machine(&dt[entry]);
+		u64 desc = (u64)high << 32 | low;
+
+		xen_mc_flush();
+		if (HYPERVISOR_update_descriptor(maddr.maddr, desc))
+			BUG();
+	}
+
+	}
+}
+
+static void xen_load_esp0(struct tss_struct *tss,
+				   struct thread_struct *thread)
+{
+	if (xen_get_lazy_mode() != PARAVIRT_LAZY_CPU) {
+		if (HYPERVISOR_stack_switch(__KERNEL_DS, thread->esp0))
+			BUG();
+	} else {
+		struct multicall_space mcs = xen_mc_entry(0);
+		MULTI_stack_switch(mcs.mc, __KERNEL_DS, thread->esp0);
+	}
+}
+
+static void xen_set_iopl_mask(unsigned mask)
+{
+	struct physdev_set_iopl set_iopl;
+
+	/* Force the change at ring 0. */
+	set_iopl.iopl = (mask == 0) ? 1 : (mask >> 12) & 3;
+	HYPERVISOR_physdev_op(PHYSDEVOP_set_iopl, &set_iopl);
+}
+
+static void xen_io_delay(void)
+{
+}
+
+#ifdef CONFIG_X86_LOCAL_APIC
+static unsigned long xen_apic_read(unsigned long reg)
+{
+	return 0;
+}
+#endif
+
+static void xen_flush_tlb(void)
+{
+	struct mmuext_op op;
+
+	op.cmd = MMUEXT_TLB_FLUSH_LOCAL;
+	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))
+		BUG();
+}
+
+static void xen_flush_tlb_single(unsigned long addr)
+{
+	struct mmuext_op op;
+
+	op.cmd = MMUEXT_INVLPG_LOCAL;
+	op.arg1.linear_addr = addr & PAGE_MASK;
+	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))
+		BUG();
+}
+
+static unsigned long xen_read_cr2(void)
+{
+	return x86_read_percpu(xen_vcpu)->arch.cr2;
+}
+
+static void xen_write_cr4(unsigned long cr4)
+{
+	/* never allow TSC to be disabled */
+	native_write_cr4(cr4 & ~X86_CR4_TSD);
+}
+
+/*
+ * Page-directory addresses above 4GB do not fit into architectural %cr3.
+ * When accessing %cr3, or equivalent field in vcpu_guest_context, guests
+ * must use the following accessor macros to pack/unpack valid MFNs.
+ *
+ * Note that Xen is using the fact that the pagetable base is always
+ * page-aligned, and putting the 12 MSB of the address into the 12 LSB
+ * of cr3.
+ */
+#define xen_pfn_to_cr3(pfn) (((unsigned)(pfn) << 12) | ((unsigned)(pfn) >> 20))
+#define xen_cr3_to_pfn(cr3) (((unsigned)(cr3) >> 12) | ((unsigned)(cr3) << 20))
+
+static unsigned long xen_read_cr3(void)
+{
+	return x86_read_percpu(xen_cr3);
+}
+
+static void xen_write_cr3(unsigned long cr3)
+{
+	if (cr3 == x86_read_percpu(xen_cr3)) {
+		/* just a simple tlb flush */
+		xen_flush_tlb();
+		return;
+	}
+
+	x86_write_percpu(xen_cr3, cr3);
+
+
+	{
+		struct mmuext_op *op;
+		struct multicall_space mcs = xen_mc_entry(sizeof(*op));
+		unsigned long mfn = pfn_to_mfn(PFN_DOWN(cr3));
+
+		op = mcs.args;
+		op->cmd = MMUEXT_NEW_BASEPTR;
+		op->arg1.mfn = mfn;
+
+		MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
+
+		xen_mc_issue();
+	}
+}
+
+static void xen_alloc_pt(u32 pfn)
+{
+	/* XXX pfn isn't necessarily a lowmem page */
+	make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
+}
+
+static void xen_alloc_pd(u32 pfn)
+{
+	make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
+}
+
+static void xen_release_pd(u32 pfn)
+{
+	make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
+}
+
+static void xen_release_pt(u32 pfn)
+{
+	make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
+}
+
+static void xen_alloc_pd_clone(u32 pfn, u32 clonepfn,
+					u32 start, u32 count)
+{
+	xen_alloc_pd(pfn);
+}
+
+static __init void xen_pagetable_setup_start(pgd_t *base)
+{
+	pgd_t *xen_pgd = (pgd_t *)xen_start_info->pt_base;
+
+	init_mm.pgd = base;
+	/*
+	 * copy top-level of Xen-supplied pagetable into place.	 For
+	 * !PAE we can use this as-is, but for PAE it is a stand-in
+	 * while we copy the pmd pages.
+	 */
+	memcpy(base, xen_pgd, PTRS_PER_PGD * sizeof(pgd_t));
+
+	if (PTRS_PER_PMD > 1) {
+		int i;
+		/*
+		 * For PAE, need to allocate new pmds, rather than
+		 * share Xen's, since Xen doesn't like pmd's being
+		 * shared between address spaces.
+		 */
+		for(i = 0; i < PTRS_PER_PGD; i++) {
+			if (pgd_val_ma(xen_pgd[i]) & _PAGE_PRESENT) {
+				pmd_t *pmd = (pmd_t *)alloc_bootmem_low_pages(PAGE_SIZE);
+
+				memcpy(pmd, (void *)pgd_page_vaddr(xen_pgd[i]),
+				       PAGE_SIZE);
+
+				xen_alloc_pd(PFN_DOWN(__pa(pmd)));
+
+				set_pgd(&base[i], __pgd(1 + __pa(pmd)));
+			} else
+				pgd_clear(&base[i]);
+		}
+	}
+
+	/* make sure zero_page is mapped RO so we can use it in pagetables */
+	make_lowmem_page_readonly(empty_zero_page);
+	make_lowmem_page_readonly(base);
+	/*
+	 * Switch to new pagetable.  This is done before
+	 * pagetable_init has done anything so that the new pages
+	 * added to the table can be prepared properly for Xen.
+	 */
+	xen_write_cr3(__pa(base));
+}
+
+static __init void xen_pagetable_setup_done(pgd_t *base)
+{
+	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
+		/*
+		 * Create a mapping for the shared info page.
+		 * Should be set_fixmap(), but shared_info is a machine
+		 * address with no corresponding pseudo-phys address.
+		 */
+#if 0
+		set_pte_mfn(fix_to_virt(FIX_PARAVIRT_BOOTMAP),
+			    PFN_DOWN(xen_start_info->shared_info),
+			    PAGE_KERNEL);
+#endif
+
+		HYPERVISOR_shared_info =
+			(struct shared_info *)fix_to_virt(FIX_PARAVIRT_BOOTMAP);
+
+	} else
+		HYPERVISOR_shared_info =
+			(struct shared_info *)__va(xen_start_info->shared_info);
+
+#if 0
+	xen_pgd_pin(base);
+#endif
+
+	xen_vcpu_setup(smp_processor_id());
+}
+
+static const struct paravirt_ops xen_paravirt_ops __initdata = {
+	.paravirt_enabled = 1,
+	.shared_kernel_pmd = 0,
+
+	.name = "Xen",
+	.banner = xen_banner,
+
+	.patch = paravirt_patch_default,
+
+	.memory_setup = xen_memory_setup,
+	.arch_setup = xen_arch_setup,
+
+	.cpuid = xen_cpuid,
+
+	.set_debugreg = xen_set_debugreg,
+	.get_debugreg = xen_get_debugreg,
+
+	.clts = native_clts,
+
+	.read_cr0 = native_read_cr0,
+	.write_cr0 = native_write_cr0,
+
+	.read_cr2 = xen_read_cr2,
+	.write_cr2 = native_write_cr2,
+
+	.read_cr3 = xen_read_cr3,
+	.write_cr3 = xen_write_cr3,
+
+	.read_cr4 = native_read_cr4,
+	.read_cr4_safe = native_read_cr4_safe,
+	.write_cr4 = xen_write_cr4,
+
+	.save_fl = xen_save_fl,
+	.restore_fl = xen_restore_fl,
+	.irq_disable = xen_irq_disable,
+	.irq_enable = xen_irq_enable,
+	.safe_halt = xen_safe_halt,
+	.halt = xen_halt,
+	.wbinvd = native_wbinvd,
+
+	.read_msr = native_read_msr_safe,
+	.write_msr = native_write_msr_safe,
+	.read_tsc = native_read_tsc,
+	.read_pmc = native_read_pmc,
+
+	.iret = (void *)&hypercall_page[__HYPERVISOR_iret],
+	.irq_enable_sysexit = NULL,  /* never called */
+
+	.load_tr_desc = paravirt_nop,
+	.set_ldt = xen_set_ldt,
+	.load_gdt = xen_load_gdt,
+	.load_idt = xen_load_idt,
+	.load_tls = xen_load_tls,
+
+	.store_gdt = native_store_gdt,
+	.store_idt = native_store_idt,
+	.store_tr = xen_store_tr,
+
+	.write_ldt_entry = xen_write_ldt_entry,
+	.write_gdt_entry = xen_write_gdt_entry,
+	.write_idt_entry = xen_write_idt_entry,
+	.load_esp0 = xen_load_esp0,
+
+	.set_iopl_mask = xen_set_iopl_mask,
+	.io_delay = xen_io_delay,
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	.apic_write = paravirt_nop,
+	.apic_write_atomic = paravirt_nop,
+	.apic_read = xen_apic_read,
+	.setup_boot_clock = paravirt_nop,
+	.setup_secondary_clock = paravirt_nop,
+	.startup_ipi_hook = paravirt_nop,
+#endif
+
+	.flush_tlb_user = xen_flush_tlb,
+	.flush_tlb_kernel = xen_flush_tlb,
+	.flush_tlb_single = xen_flush_tlb_single,
+
+	.pte_update = paravirt_nop,
+	.pte_update_defer = paravirt_nop,
+
+	.pagetable_setup_start = xen_pagetable_setup_start,
+	.pagetable_setup_done = xen_pagetable_setup_done,
+
+	.alloc_pt = xen_alloc_pt,
+	.alloc_pd = xen_alloc_pd,
+	.alloc_pd_clone = xen_alloc_pd_clone,
+	.release_pd = xen_release_pd,
+	.release_pt = xen_release_pt,
+
+	.set_lazy_mode = xen_set_lazy_mode,
+};
+
+/* First C function to be called on Xen boot */
+static asmlinkage void __init xen_start_kernel(void)
+{
+	pgd_t *pgd;
+
+	if (!xen_start_info)
+		return;
+
+	BUG_ON(memcmp(xen_start_info->magic, "xen-3.0", 7) != 0);
+
+	/* Install Xen paravirt ops */
+	paravirt_ops = xen_paravirt_ops;
+
+	xen_setup_features();
+
+	/* Get mfn list */
+	if (!xen_feature(XENFEAT_auto_translated_physmap))
+		phys_to_machine_mapping = (unsigned long *)xen_start_info->mfn_list;
+
+	pgd = (pgd_t *)xen_start_info->pt_base;
+
+	init_pg_tables_end = __pa(pgd) + xen_start_info->nr_pt_frames*PAGE_SIZE;
+
+	init_mm.pgd = pgd; /* use the Xen pagetables to start */
+
+	/* keep using Xen gdt for now; no urgent need to change it */
+
+	x86_write_percpu(xen_cr3, __pa(pgd));
+	xen_vcpu_setup(0);
+
+	paravirt_ops.kernel_rpl = 1;
+	if (xen_feature(XENFEAT_supervisor_mode_kernel))
+		paravirt_ops.kernel_rpl = 0;
+
+	/* set the limit of our address space */
+	reserve_top_address(-HYPERVISOR_VIRT_START + 2 * PAGE_SIZE);
+
+	/* set up basic CPUID stuff */
+	cpu_detect(&new_cpu_data);
+	new_cpu_data.hard_math = 1;
+	new_cpu_data.x86_capability[0] = cpuid_edx(1);
+
+	/* Poke various useful things into boot_params */
+	LOADER_TYPE = (9 << 4) | 0;
+	INITRD_START = xen_start_info->mod_start ? __pa(xen_start_info->mod_start) : 0;
+	INITRD_SIZE = xen_start_info->mod_len;
+
+	/* Start the world */
+	start_kernel();
+}
+
+paravirt_probe(xen_start_kernel);
===================================================================
--- /dev/null
+++ b/arch/i386/xen/features.c
@@ -0,0 +1,29 @@
+/******************************************************************************
+ * features.c
+ *
+ * Xen feature flags.
+ *
+ * Copyright (c) 2006, Ian Campbell, XenSource Inc.
+ */
+#include <linux/types.h>
+#include <linux/cache.h>
+#include <linux/module.h>
+#include <asm/xen/hypervisor.h>
+#include <xen/features.h>
+
+u8 xen_features[XENFEAT_NR_SUBMAPS * 32] __read_mostly;
+EXPORT_SYMBOL_GPL(xen_features);
+
+void xen_setup_features(void)
+{
+	struct xen_feature_info fi;
+	int i, j;
+
+	for (i = 0; i < XENFEAT_NR_SUBMAPS; i++) {
+		fi.submap_idx = i;
+		if (HYPERVISOR_xen_version(XENVER_get_features, &fi) < 0)
+			break;
+		for (j=0; j<32; j++)
+			xen_features[i*32+j] = !!(fi.submap & 1<<j);
+	}
+}
===================================================================
--- /dev/null
+++ b/arch/i386/xen/multicalls.c
@@ -0,0 +1,82 @@
+/*
+ * Xen hypercall batching.
+ *
+ * Xen allows multiple hypercalls to be issued at once, using the
+ * multicall interface.  This allows the cost of trapping into the
+ * hypervisor to be amortized over several calls.
+ *
+ * This file implements a simple interface for multicalls.  There's a
+ * per-cpu buffer of outstanding multicalls.  When you want to queue a
+ * multicall for issuing, you can allocate a multicall slot for the
+ * call and its arguments, along with storage for space which is
+ * pointed to by the arguments (for passing pointers to structures,
+ * etc).  When the multicall is actually issued, all the space for the
+ * commands and allocated memory is freed for reuse.
+ *
+ * Multicalls are flushed whenever any of the buffers get full, or
+ * when explicitly requested.  There's no way to get per-multicall
+ * return results back.  It will BUG if any of the multicalls fail.
+ *
+ * Jeremy Fitzhardinge <jeremy@xensource.com>, XenSource Inc, 2007
+ */
+#include <linux/percpu.h>
+
+#include <asm/xen/hypercall.h>
+
+#include "multicalls.h"
+
+#define MC_BATCH	8
+#define MC_ARGS		(MC_BATCH * 32 / sizeof(u64))
+
+struct mc_buffer {
+	struct multicall_entry entries[MC_BATCH];
+	u64 args[MC_ARGS];
+	unsigned mcidx, argidx;
+};
+
+static DEFINE_PER_CPU(struct mc_buffer, mc_buffer);
+
+void xen_mc_flush(void)
+{
+	struct mc_buffer *b = &get_cpu_var(mc_buffer);
+	int ret = 0;
+
+	if (b->mcidx) {
+		int i;
+
+		if (HYPERVISOR_multicall(b->entries, b->mcidx) != 0)
+			BUG();
+		for(i = 0; i < b->mcidx; i++)
+			if (b->entries[i].result < 0)
+				ret++;
+		b->mcidx = 0;
+		b->argidx = 0;
+	} else
+		BUG_ON(b->argidx != 0);
+
+	put_cpu_var(mc_buffer);
+
+	BUG_ON(ret);
+}
+
+struct multicall_space xen_mc_entry(size_t args)
+{
+	struct mc_buffer *b = &get_cpu_var(mc_buffer);
+	struct multicall_space ret;
+	unsigned argspace = (args + sizeof(u64) - 1) / sizeof(u64);
+
+	BUG_ON(argspace > MC_ARGS);
+
+	if (b->mcidx == MC_BATCH ||
+	    (b->argidx + argspace) > MC_ARGS)
+		xen_mc_flush();
+
+	ret.mc = &b->entries[b->mcidx];
+	b->mcidx++;
+	ret.args = &b->args[b->argidx];
+	b->argidx += argspace;
+
+	put_cpu_var(mc_buffer);
+
+	return ret;
+}
===================================================================
--- /dev/null
+++ b/arch/i386/xen/multicalls.h
@@ -0,0 +1,26 @@
+#ifndef _XEN_MULTICALLS_H
+#define _XEN_MULTICALLS_H
+
+#include "xen-ops.h"
+
+/* Multicalls */
+struct multicall_space
+{
+	struct multicall_entry *mc;
+	void *args;
+};
+
+/* Allocate room for a multicall and its args */
+struct multicall_space xen_mc_entry(size_t args);
+
+/* Flush all pending multicalls */
+void xen_mc_flush(void);
+
+/* Issue a multicall if we're not in lazy mode */
+static inline void xen_mc_issue(void)
+{
+	if (xen_get_lazy_mode() == PARAVIRT_LAZY_NONE)
+		xen_mc_flush();
+}
+
+#endif /* _XEN_MULTICALLS_H */
===================================================================
--- /dev/null
+++ b/arch/i386/xen/setup.c
@@ -0,0 +1,96 @@
+/*
+ * Machine specific setup for xen
+ *
+ * Jeremy Fitzhardinge <jeremy@xensource.com>, XenSource Inc, 2007
+ */
+
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/pm.h>
+
+#include <asm/elf.h>
+#include <asm/e820.h>
+#include <asm/setup.h>
+#include <asm/xen/hypervisor.h>
+#include <asm/xen/hypercall.h>
+
+#include <xen/interface/physdev.h>
+#include <xen/features.h>
+
+#include "xen-ops.h"
+
+/* These are code, but not functions.  Defined in entry.S */
+extern const char xen_hypervisor_callback[];
+extern const char xen_failsafe_callback[];
+
+static __initdata struct shared_info init_shared;
+
+/*
+ * Point at some empty memory to start with. We map the real shared_info
+ * page as soon as fixmap is up and running.
+ */
+struct shared_info *HYPERVISOR_shared_info = &init_shared;
+
+unsigned long *phys_to_machine_mapping;
+EXPORT_SYMBOL(phys_to_machine_mapping);
+
+/**
+ * machine_specific_memory_setup - Hook for machine specific memory setup.
+ **/
+
+char * __init xen_memory_setup(void)
+{
+	unsigned long max_pfn = xen_start_info->nr_pages;
+
+	e820.nr_map = 0;
+	add_memory_region(0, PFN_PHYS(max_pfn), E820_RAM);
+
+	return "Xen";
+}
+
+static void xen_idle(void)
+{
+	local_irq_disable();
+
+	if (need_resched())
+		local_irq_enable();
+	else {
+		current_thread_info()->status &= ~TS_POLLING;
+		smp_mb__after_clear_bit();
+		safe_halt();
+		current_thread_info()->status |= TS_POLLING;
+	}
+}
+
+void __init xen_arch_setup(void)
+{
+	struct physdev_set_iopl set_iopl;
+	int rc;
+
+	HYPERVISOR_vm_assist(VMASST_CMD_enable, VMASST_TYPE_4gb_segments);
+	HYPERVISOR_vm_assist(VMASST_CMD_enable, VMASST_TYPE_writable_pagetables);
+
+	if (!xen_feature(XENFEAT_auto_translated_physmap))
+		HYPERVISOR_vm_assist(VMASST_CMD_enable, VMASST_TYPE_pae_extended_cr3);
+
+	HYPERVISOR_set_callbacks(__KERNEL_CS, (unsigned long)xen_hypervisor_callback,
+				 __KERNEL_CS, (unsigned long)xen_failsafe_callback);
+
+	set_iopl.iopl = 1;
+	rc = HYPERVISOR_physdev_op(PHYSDEVOP_set_iopl, &set_iopl);
+	if (rc != 0)
+		printk(KERN_INFO "physdev_op failed %d\n", rc);
+
+#ifdef CONFIG_ACPI
+	if (!(xen_start_info->flags & SIF_INITDOMAIN)) {
+		printk(KERN_INFO "ACPI in unprivileged domain disabled\n");
+		disable_acpi();
+	}
+#endif
+
+	memcpy(boot_command_line, xen_start_info->cmd_line,
+	       MAX_GUEST_CMDLINE > COMMAND_LINE_SIZE ?
+	       COMMAND_LINE_SIZE : MAX_GUEST_CMDLINE);
+
+	pm_idle = xen_idle;
+}
===================================================================
--- /dev/null
+++ b/arch/i386/xen/xen-head.S
@@ -0,0 +1,34 @@
+/* Xen-specific pieces of head.S, intended to be included in the right
+	place in head.S */
+
+#ifdef CONFIG_XEN
+
+#include <linux/elfnote.h>
+#include <asm/boot.h>
+#include <xen/interface/elfnote.h>
+
+ENTRY(startup_xen)
+	movl %esi,xen_start_info
+	jmp startup_paravirt
+
+.pushsection ".bss.page_aligned"
+	.align PAGE_SIZE_asm
+ENTRY(hypercall_page)
+	.skip 0x1000
+.popsection
+
+	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_OS,       .asciz "linux")
+	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_VERSION,  .asciz "2.6")
+	ELFNOTE(Xen, XEN_ELFNOTE_XEN_VERSION,    .asciz "xen-3.0")
+	ELFNOTE(Xen, XEN_ELFNOTE_VIRT_BASE,      .long  __PAGE_OFFSET)
+	ELFNOTE(Xen, XEN_ELFNOTE_ENTRY,          .long  startup_xen)
+	ELFNOTE(Xen, XEN_ELFNOTE_HYPERCALL_PAGE, .long  hypercall_page)
+	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb")
+#ifdef CONFIG_X86_PAE
+	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz "yes")
+#else
+	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz "no")
+#endif
+	ELFNOTE(Xen, XEN_ELFNOTE_LOADER,         .asciz "generic")
+
+#endif /*CONFIG_XEN */
===================================================================
--- /dev/null
+++ b/arch/i386/xen/xen-ops.h
@@ -0,0 +1,34 @@
+#ifndef XEN_OPS_H
+#define XEN_OPS_H
+
+#include <linux/init.h>
+#include <linux/clocksource.h>
+
+DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
+DECLARE_PER_CPU(unsigned long, xen_cr3);
+
+extern struct start_info *xen_start_info;
+extern struct shared_info *HYPERVISOR_shared_info;
+
+char * __init xen_memory_setup(void);
+void __init xen_arch_setup(void);
+void __init xen_init_IRQ(void);
+
+unsigned long xen_cpu_khz(void);
+void __init xen_time_init(void);
+unsigned long xen_get_wallclock(void);
+int xen_set_wallclock(unsigned long time);
+cycle_t xen_clocksource_read(void);
+
+DECLARE_PER_CPU(enum paravirt_lazy_mode, xen_lazy_mode);
+
+static inline unsigned xen_get_lazy_mode(void)
+{
+	unsigned ret = get_cpu_var(xen_lazy_mode);
+	put_cpu_var(xen_lazy_mode);
+
+	return ret;
+}
+
+
+#endif /* XEN_OPS_H */
===================================================================
--- a/include/asm-i386/irq.h
+++ b/include/asm-i386/irq.h
@@ -41,6 +41,7 @@ extern void fixup_irqs(cpumask_t map);
 extern void fixup_irqs(cpumask_t map);
 #endif
 
+unsigned int do_IRQ(struct pt_regs *regs);
 void init_IRQ(void);
 void __init native_init_IRQ(void);
 
===================================================================
--- a/include/asm-i386/xen/hypercall.h
+++ b/include/asm-i386/xen/hypercall.h
@@ -410,4 +410,22 @@ MULTI_mmuext_op(struct multicall_entry *
 	mcl->args[2] = (unsigned long)success_count;
 	mcl->args[3] = domid;
 }
+
+static inline void
+MULTI_set_gdt(struct multicall_entry *mcl, unsigned long *frames, int entries)
+{
+	mcl->op = __HYPERVISOR_set_gdt;
+	mcl->args[0] = (unsigned long)frames;
+	mcl->args[1] = entries;
+}
+
+static inline void
+MULTI_stack_switch(struct multicall_entry *mcl,
+		   unsigned long ss, unsigned long esp)
+{
+	mcl->op = __HYPERVISOR_stack_switch;
+	mcl->args[0] = ss;
+	mcl->args[1] = esp;
+}
+
 #endif /* __HYPERCALL_H__ */
===================================================================
--- /dev/null
+++ b/include/xen/features.h
@@ -0,0 +1,23 @@
+/******************************************************************************
+ * features.h
+ *
+ * Query the features reported by Xen.
+ *
+ * Copyright (c) 2006, Ian Campbell
+ */
+
+#ifndef __XEN_FEATURES_H__
+#define __XEN_FEATURES_H__
+
+#include <xen/interface/features.h>
+
+void xen_setup_features(void);
+
+extern u8 xen_features[XENFEAT_NR_SUBMAPS * 32];
+
+static inline int xen_feature(int flag)
+{
+	return xen_features[flag];
+}
+
+#endif /* __ASM_XEN_FEATURES_H__ */
===================================================================
--- /dev/null
+++ b/include/xen/page.h
@@ -0,0 +1,178 @@
+#ifndef __XEN_PAGE_H
+#define __XEN_PAGE_H
+
+#include <linux/pfn.h>
+
+#include <asm/uaccess.h>
+
+#include <xen/features.h>
+
+#ifdef CONFIG_X86_PAE
+/* Xen machine address */
+typedef struct xmaddr {
+	unsigned long long maddr;
+} xmaddr_t;
+
+/* Xen pseudo-physical address */
+typedef struct xpaddr {
+	unsigned long long paddr;
+} xpaddr_t;
+#else
+/* Xen machine address */
+typedef struct xmaddr {
+	unsigned long maddr;
+} xmaddr_t;
+
+/* Xen pseudo-physical address */
+typedef struct xpaddr {
+	unsigned long paddr;
+} xpaddr_t;
+#endif
+
+#define XMADDR(x)	((xmaddr_t) { .maddr = (x) })
+#define XPADDR(x)	((xpaddr_t) { .paddr = (x) })
+
+/**** MACHINE <-> PHYSICAL CONVERSION MACROS ****/
+#define INVALID_P2M_ENTRY	(~0UL)
+#define FOREIGN_FRAME_BIT	(1UL<<31)
+#define FOREIGN_FRAME(m)	((m) | FOREIGN_FRAME_BIT)
+
+extern unsigned long *phys_to_machine_mapping;
+
+static inline unsigned long pfn_to_mfn(unsigned long pfn)
+{
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return pfn;
+
+	return phys_to_machine_mapping[(unsigned int)(pfn)] &
+		~FOREIGN_FRAME_BIT;
+}
+
+static inline int phys_to_machine_mapping_valid(unsigned long pfn)
+{
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return 1;
+
+	return (phys_to_machine_mapping[pfn] != INVALID_P2M_ENTRY);
+}
+
+static inline unsigned long mfn_to_pfn(unsigned long mfn)
+{
+	unsigned long pfn;
+
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return mfn;
+
+#if 0
+	if (unlikely((mfn >> machine_to_phys_order) != 0))
+		return max_mapnr;
+#endif
+
+	pfn = 0;
+	/*
+	 * The array access can fail (e.g., device space beyond end of RAM).
+	 * In such cases it doesn't matter what we return (we return garbage),
+	 * but we must handle the fault without crashing!
+	 */
+	__get_user(pfn, &machine_to_phys_mapping[mfn]);
+
+	return pfn;
+}
+
+static inline xmaddr_t phys_to_machine(xpaddr_t phys)
+{
+	unsigned offset = phys.paddr & ~PAGE_MASK;
+	return XMADDR(PFN_PHYS((u64)pfn_to_mfn(PFN_DOWN(phys.paddr))) | offset);
+}
+
+static inline xpaddr_t machine_to_phys(xmaddr_t machine)
+{
+	unsigned offset = machine.maddr & ~PAGE_MASK;
+	return XPADDR(PFN_PHYS((u64)mfn_to_pfn(PFN_DOWN(machine.maddr))) | offset);
+}
+
+/*
+ * We detect special mappings in one of two ways:
+ *  1. If the MFN is an I/O page then Xen will set the m2p entry
+ *     to be outside our maximum possible pseudophys range.
+ *  2. If the MFN belongs to a different domain then we will certainly
+ *     not have MFN in our p2m table. Conversely, if the page is ours,
+ *     then we'll have p2m(m2p(MFN))==MFN.
+ * If we detect a special mapping then it doesn't have a 'struct page'.
+ * We force !pfn_valid() by returning an out-of-range pointer.
+ *
+ * NB. These checks require that, for any MFN that is not in our reservation,
+ * there is no PFN such that p2m(PFN) == MFN. Otherwise we can get confused if
+ * we are foreign-mapping the MFN, and the other domain as m2p(MFN) == PFN.
+ * Yikes! Various places must poke in INVALID_P2M_ENTRY for safety.
+ *
+ * NB2. When deliberately mapping foreign pages into the p2m table, you *must*
+ *      use FOREIGN_FRAME(). This will cause pte_pfn() to choke on it, as we
+ *      require. In all the cases we care about, the FOREIGN_FRAME bit is
+ *      masked (e.g., pfn_to_mfn()) so behaviour there is correct.
+ */
+static inline unsigned long mfn_to_local_pfn(unsigned long mfn)
+{
+	extern unsigned long max_mapnr;
+	unsigned long pfn = mfn_to_pfn(mfn);
+	if ((pfn < max_mapnr)
+	    && !xen_feature(XENFEAT_auto_translated_physmap)
+	    && (phys_to_machine_mapping[pfn] != mfn))
+		return max_mapnr; /* force !pfn_valid() */
+	return pfn;
+}
+
+static inline void set_phys_to_machine(unsigned long pfn, unsigned long mfn)
+{
+	if (xen_feature(XENFEAT_auto_translated_physmap)) {
+		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
+		return;
+	}
+	phys_to_machine_mapping[pfn] = mfn;
+}
+
+/* VIRT <-> MACHINE conversion */
+#define virt_to_machine(v)	(phys_to_machine(XPADDR(__pa(v))))
+#define virt_to_mfn(v)		(pfn_to_mfn(PFN_DOWN(__pa(v))))
+#define mfn_to_virt(m)		(__va(mfn_to_pfn(m) << PAGE_SHIFT))
+
+#ifdef CONFIG_X86_PAE
+#define pte_mfn(_pte) (((_pte).pte_low >> PAGE_SHIFT) |\
+                       (((_pte).pte_high & 0xfff) << (32-PAGE_SHIFT)))
+
+static inline pte_t mfn_pte(unsigned long page_nr, pgprot_t pgprot)
+{
+	pte_t pte;
+
+	pte.pte_high = (page_nr >> (32 - PAGE_SHIFT)) | (pgprot_val(pgprot) >> 32);
+	pte.pte_high &= (__supported_pte_mask >> 32);
+	pte.pte_low = ((page_nr << PAGE_SHIFT) | pgprot_val(pgprot));
+	pte.pte_low &= __supported_pte_mask;
+
+	return pte;
+}
+
+static inline unsigned long long pte_val_ma(pte_t x)
+{
+	return ((unsigned long long)x.pte_high << 32) | x.pte_low;
+}
+#define pmd_val_ma(v) ((v).pmd)
+#define pud_val_ma(v) ((v).pgd.pgd)
+#define __pte_ma(x)	((pte_t) { .pte_low=(x), .pte_high=(x)>>32 } )
+#define __pmd_ma(x)	((pmd_t) { (x) } )
+#else  /* !X86_PAE */
+#define pte_mfn(_pte) ((_pte).pte_low >> PAGE_SHIFT)
+#define mfn_pte(pfn, prot)	__pte_ma(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
+#define pte_val_ma(x)	((x).pte_low)
+#define pmd_val_ma(v)	((v).pud.pgd.pgd)
+#define __pte_ma(x)	((pte_t) { (x) } )
+#endif	/* CONFIG_X86_PAE */
+
+#define pgd_val_ma(x)	((x).pgd)
+
+
+xmaddr_t arbitrary_virt_to_machine(unsigned long address);
+void make_lowmem_page_readonly(void *vaddr);
+void make_lowmem_page_readwrite(void *vaddr);
+
+#endif /* __XEN_PAGE_H */

-- 


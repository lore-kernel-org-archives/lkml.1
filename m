Return-Path: <linux-kernel-owner+w=401wt.eu-S1031028AbXD2RmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031028AbXD2RmA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030876AbXD2Rkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:40:45 -0400
Received: from gw.goop.org ([64.81.55.164]:59059 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbXD2RbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:31:00 -0400
Message-Id: <20070429172913.494178000@goop.org>
References: <20070429172835.284784000@goop.org>
User-Agent: quilt/0.46-1
Date: Sun, 29 Apr 2007 10:28:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@redhat.com>
Subject: [patch 15/32] xen: Xen SMP guest support
Content-Disposition: inline; filename=xen-smp.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fairly straightforward Xen implementation of smp_ops.

Xen has its own IPI mechanisms, and has no dependency on any
APIC-based IPI.  The smp_ops hooks and the flush_tlb_others pv_op
allow a Xen guest to avoid all APIC code in arch/i386 (the only apic
operation is a single apic_read for the apic version number).

One subtle point which needs to be addressed is unpinning pagetables
when another cpu may have a lazy tlb reference to the pagetable. Xen
will not allow an in-use pagetable to be unpinned, so we must find any
other cpus with a reference to the pagetable and get them to shoot
down their references.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/smp.c                             |    5 
 arch/i386/kernel/smpboot.c                         |    8 
 arch/i386/xen/Kconfig                              |    2 
 arch/i386/xen/Makefile                             |    2 
 arch/i386/xen/enlighten.c                          |  119 ++++-
 arch/i386/xen/events.c                             |   78 +++
 arch/i386/xen/mmu.c                                |   75 ++-
 arch/i386/xen/mmu.h                                |   13 
 arch/i386/xen/setup.c                              |    5 
 arch/i386/xen/smp.c                                |  405 ++++++++++++++++++++
 arch/i386/xen/time.c                               |    9 
 arch/i386/xen/xen-ops.h                            |   25 +
 include/asm-i386/mach-default/irq_vectors_limits.h |    2 
 include/asm-i386/mmu_context.h                     |    2 
 include/asm-i386/smp.h                             |    5 
 include/xen/events.h                               |   27 +
 16 files changed, 717 insertions(+), 65 deletions(-)

===================================================================
--- a/arch/i386/kernel/smp.c
+++ b/arch/i386/kernel/smp.c
@@ -23,6 +23,7 @@
 
 #include <asm/mtrr.h>
 #include <asm/tlbflush.h>
+#include <asm/mmu_context.h>
 #include <mach_apic.h>
 
 /*
@@ -250,13 +251,13 @@ static DEFINE_SPINLOCK(tlbstate_lock);
 static DEFINE_SPINLOCK(tlbstate_lock);
 
 /*
- * We cannot call mmdrop() because we are in interrupt context, 
+ * We cannot call mmdrop() because we are in interrupt context,
  * instead update mm->cpu_vm_mask.
  *
  * We need to reload %cr3 since the page tables may be going
  * away from under us..
  */
-static inline void leave_mm (unsigned long cpu)
+void leave_mm (unsigned long cpu)
 {
 	if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK)
 		BUG();
===================================================================
--- a/arch/i386/kernel/smpboot.c
+++ b/arch/i386/kernel/smpboot.c
@@ -149,7 +149,7 @@ void __init smp_alloc_memory(void)
  * a given CPU
  */
 
-static void __cpuinit smp_store_cpu_info(int id)
+void __cpuinit smp_store_cpu_info(int id)
 {
 	struct cpuinfo_x86 *c = cpu_data + id;
 
@@ -309,8 +309,7 @@ cpumask_t cpu_coregroup_map(int cpu)
 /* representing cpus for which sibling maps can be computed */
 static cpumask_t cpu_sibling_setup_map;
 
-static inline void
-set_cpu_sibling_map(int cpu)
+void set_cpu_sibling_map(int cpu)
 {
 	int i;
 	struct cpuinfo_x86 *c = cpu_data;
@@ -1145,8 +1144,7 @@ void __init native_smp_prepare_boot_cpu(
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static void
-remove_siblinginfo(int cpu)
+void remove_siblinginfo(int cpu)
 {
 	int sibling;
 	struct cpuinfo_x86 *c = cpu_data;
===================================================================
--- a/arch/i386/xen/Kconfig
+++ b/arch/i386/xen/Kconfig
@@ -4,7 +4,7 @@
 
 config XEN
 	bool "Enable support for Xen hypervisor"
-	depends on PARAVIRT && !PREEMPT && !SMP
+	depends on PARAVIRT && !PREEMPT
 	default y
 	help
 	  This is the Linux Xen port.  Enabling this will allow the
===================================================================
--- a/arch/i386/xen/Makefile
+++ b/arch/i386/xen/Makefile
@@ -1,2 +1,4 @@ obj-y		:= enlighten.o setup.o features.o
 obj-y		:= enlighten.o setup.o features.o multicalls.o mmu.o \
 			events.o time.o
+
+obj-$(CONFIG_SMP)	+= smp.o
===================================================================
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -40,6 +40,8 @@
 #include <asm/setup.h>
 #include <asm/desc.h>
 #include <asm/pgtable.h>
+#include <asm/smp.h>
+#include <asm/tlbflush.h>
 
 #include "xen-ops.h"
 #include "mmu.h"
@@ -56,7 +58,7 @@ struct start_info *xen_start_info;
 struct start_info *xen_start_info;
 EXPORT_SYMBOL_GPL(xen_start_info);
 
-static void xen_vcpu_setup(int cpu)
+void xen_vcpu_setup(int cpu)
 {
 	per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
 }
@@ -344,6 +346,32 @@ static void xen_write_idt_entry(struct d
 	}
 }
 
+static void xen_convert_trap_info(const struct Xgt_desc_struct *desc,
+				  struct trap_info *traps)
+{
+	unsigned in, out, count;
+
+	count = (desc->size+1) / 8;
+	BUG_ON(count > 256);
+
+	for(in = out = 0; in < count; in++) {
+		const u32 *entry = (u32 *)(desc->address + in * 8);
+
+		if (cvt_gate_to_trap(in, entry[0], entry[1], &traps[out]))
+			out++;
+	}
+	traps[out].address = 0;
+}
+
+void xen_copy_trap_info(struct trap_info *traps)
+{
+	const struct Xgt_desc_struct *desc = &get_cpu_var(idt_desc);
+
+	xen_convert_trap_info(desc, traps);
+
+	put_cpu_var(idt_desc);
+}
+
 /* Load a new IDT into Xen.  In principle this can be per-CPU, so we
    hold a spinlock to protect the static traps[] array (static because
    it avoids allocation, and saves stack space). */
@@ -351,23 +379,13 @@ static void xen_load_idt(const struct Xg
 {
 	static DEFINE_SPINLOCK(lock);
 	static struct trap_info traps[257];
-
 	int cpu = smp_processor_id();
-	unsigned in, out, count;
 
 	per_cpu(idt_desc, cpu) = *desc;
 
-	count = (desc->size+1) / 8;
-	BUG_ON(count > 256);
-
 	spin_lock(&lock);
-	for(in = out = 0; in < count; in++) {
-		const u32 *entry = (u32 *)(desc->address + in * 8);
-
-		if (cvt_gate_to_trap(in, entry[0], entry[1], &traps[out]))
-			out++;
-	}
-	traps[out].address = 0;
+
+	xen_convert_trap_info(desc, traps);
 
 	xen_mc_flush();
 	if (HYPERVISOR_set_trap_table(traps))
@@ -422,7 +440,15 @@ static void xen_io_delay(void)
 #ifdef CONFIG_X86_LOCAL_APIC
 static unsigned long xen_apic_read(unsigned long reg)
 {
+	/* Warn to see if there's any stray references */
+	WARN_ON(1);
 	return 0;
+}
+
+static void xen_apic_write(unsigned long reg, unsigned long val)
+{
+	/* Warn to see if there's any stray references */
+	WARN_ON(1);
 }
 #endif
 
@@ -445,6 +471,40 @@ static void xen_flush_tlb_single(unsigne
 		BUG();
 }
 
+static void xen_flush_tlb_others(const cpumask_t *cpus, struct mm_struct *mm,
+				 unsigned long va)
+{
+	struct mmuext_op op;
+	cpumask_t cpumask = *cpus;
+
+	/*
+	 * A couple of (to be removed) sanity checks:
+	 *
+	 * - current CPU must not be in mask
+	 * - mask must exist :)
+	 */
+	BUG_ON(cpus_empty(cpumask));
+	BUG_ON(cpu_isset(smp_processor_id(), cpumask));
+	BUG_ON(!mm);
+
+	/* If a CPU which we ran on has gone down, OK. */
+	cpus_and(cpumask, cpumask, cpu_online_map);
+	if (cpus_empty(cpumask))
+		return;
+
+	if (va == TLB_FLUSH_ALL) {
+		op.cmd = MMUEXT_TLB_FLUSH_MULTI;
+		op.arg2.vcpumask = (void *)cpus;
+	} else {
+		op.cmd = MMUEXT_INVLPG_MULTI;
+		op.arg1.linear_addr = va;
+		op.arg2.vcpumask = (void *)cpus;
+	}
+
+	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))
+		BUG();
+}
+
 static unsigned long xen_read_cr2(void)
 {
 	return x86_read_percpu(xen_vcpu)->arch.cr2;
@@ -455,18 +515,6 @@ static void xen_write_cr4(unsigned long 
 	/* never allow TSC to be disabled */
 	native_write_cr4(cr4 & ~X86_CR4_TSD);
 }
-
-/*
- * Page-directory addresses above 4GB do not fit into architectural %cr3.
- * When accessing %cr3, or equivalent field in vcpu_guest_context, guests
- * must use the following accessor macros to pack/unpack valid MFNs.
- *
- * Note that Xen is using the fact that the pagetable base is always
- * page-aligned, and putting the 12 MSB of the address into the 12 LSB
- * of cr3.
- */
-#define xen_pfn_to_cr3(pfn) (((unsigned)(pfn) << 12) | ((unsigned)(pfn) >> 20))
-#define xen_cr3_to_pfn(cr3) (((unsigned)(cr3) >> 12) | ((unsigned)(cr3) << 20))
 
 static unsigned long xen_read_cr3(void)
 {
@@ -736,8 +784,8 @@ static const struct paravirt_ops xen_par
 	.io_delay = xen_io_delay,
 
 #ifdef CONFIG_X86_LOCAL_APIC
-	.apic_write = paravirt_nop,
-	.apic_write_atomic = paravirt_nop,
+	.apic_write = xen_apic_write,
+	.apic_write_atomic = xen_apic_write,
 	.apic_read = xen_apic_read,
 	.setup_boot_clock = paravirt_nop,
 	.setup_secondary_clock = paravirt_nop,
@@ -747,6 +795,7 @@ static const struct paravirt_ops xen_par
 	.flush_tlb_user = xen_flush_tlb,
 	.flush_tlb_kernel = xen_flush_tlb,
 	.flush_tlb_single = xen_flush_tlb_single,
+	.flush_tlb_others = xen_flush_tlb_others,
 
 	.pte_update = paravirt_nop,
 	.pte_update_defer = paravirt_nop,
@@ -792,6 +841,19 @@ static const struct paravirt_ops xen_par
 	.set_lazy_mode = xen_set_lazy_mode,
 };
 
+#ifdef CONFIG_SMP
+static const struct smp_ops xen_smp_ops __initdata = {
+	.smp_prepare_boot_cpu = xen_smp_prepare_boot_cpu,
+	.smp_prepare_cpus = xen_smp_prepare_cpus,
+	.cpu_up = xen_cpu_up,
+	.smp_cpus_done = xen_smp_cpus_done,
+
+	.smp_send_stop = xen_smp_send_stop,
+	.smp_send_reschedule = xen_smp_send_reschedule,
+	.smp_call_function_mask = xen_smp_call_function_mask,
+};
+#endif	/* CONFIG_SMP */
+
 /* First C function to be called on Xen boot */
 static asmlinkage void __init xen_start_kernel(void)
 {
@@ -804,6 +866,9 @@ static asmlinkage void __init xen_start_
 
 	/* Install Xen paravirt ops */
 	paravirt_ops = xen_paravirt_ops;
+#ifdef CONFIG_SMP
+	smp_ops = xen_smp_ops;
+#endif
 
 	xen_setup_features();
 
===================================================================
--- a/arch/i386/xen/events.c
+++ b/arch/i386/xen/events.c
@@ -47,6 +47,9 @@ static DEFINE_SPINLOCK(irq_mapping_updat
 /* IRQ <-> VIRQ mapping. */
 static DEFINE_PER_CPU(int, virq_to_irq[NR_VIRQS]) = {[0 ... NR_VIRQS-1] = -1};
 
+/* IRQ <-> IPI mapping */
+static DEFINE_PER_CPU(int, ipi_to_irq[XEN_NR_IPIS]) = {[0 ... XEN_NR_IPIS-1] = -1};
+
 /* Packed IRQ information: binding type, sub-type index, and event channel. */
 struct packed_irq
 {
@@ -58,7 +61,13 @@ static struct packed_irq irq_info[NR_IRQ
 static struct packed_irq irq_info[NR_IRQS];
 
 /* Binding types. */
-enum { IRQT_UNBOUND, IRQT_PIRQ, IRQT_VIRQ, IRQT_IPI, IRQT_EVTCHN };
+enum {
+	IRQT_UNBOUND,
+	IRQT_PIRQ,
+	IRQT_VIRQ,
+	IRQT_IPI,
+	IRQT_EVTCHN
+};
 
 /* Convenient shorthand for packed representation of an unbound IRQ. */
 #define IRQ_UNBOUND	mk_irq_info(IRQT_UNBOUND, 0, 0)
@@ -261,6 +270,43 @@ static int bind_evtchn_to_irq(unsigned i
 	return irq;
 }
 
+static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
+{
+	struct evtchn_bind_ipi bind_ipi;
+	int evtchn, irq;
+
+	spin_lock(&irq_mapping_update_lock);
+
+	if ((irq = per_cpu(ipi_to_irq, cpu)[ipi]) == -1) {
+		if ((irq = find_unbound_irq()) < 0)
+			goto out;
+
+		dynamic_irq_init(irq);
+		set_irq_chip_and_handler_name(irq, &xen_dynamic_chip,
+					      handle_level_irq, "ipi");
+
+		bind_ipi.vcpu = cpu;
+		if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_ipi,
+						&bind_ipi) != 0)
+			BUG();
+		evtchn = bind_ipi.port;
+
+		evtchn_to_irq[evtchn] = irq;
+		irq_info[irq] = mk_irq_info(IRQT_IPI, ipi, evtchn);
+
+		per_cpu(ipi_to_irq, cpu)[ipi] = irq;
+
+		bind_evtchn_to_cpu(evtchn, cpu);
+	}
+
+	irq_bindcount[irq]++;
+
+ out:
+	spin_unlock(&irq_mapping_update_lock);
+	return irq;
+}
+
+
 static int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
 {
 	struct evtchn_bind_virq bind_virq;
@@ -369,12 +415,42 @@ int bind_virq_to_irqhandler(unsigned int
 }
 EXPORT_SYMBOL_GPL(bind_virq_to_irqhandler);
 
+int bind_ipi_to_irqhandler(enum ipi_vector ipi,
+			   unsigned int cpu,
+			   irq_handler_t handler,
+			   unsigned long irqflags,
+			   const char *devname,
+			   void *dev_id)
+{
+	int irq, retval;
+
+	irq = bind_ipi_to_irq(ipi, cpu);
+	if (irq < 0)
+		return irq;
+
+	retval = request_irq(irq, handler, irqflags, devname, dev_id);
+	if (retval != 0) {
+		unbind_from_irq(irq);
+		return retval;
+	}
+
+	return irq;
+}
+
 void unbind_from_irqhandler(unsigned int irq, void *dev_id)
 {
 	free_irq(irq, dev_id);
 	unbind_from_irq(irq);
 }
 EXPORT_SYMBOL_GPL(unbind_from_irqhandler);
+
+void xen_send_IPI_one(unsigned int cpu, enum ipi_vector vector)
+{
+	int irq = per_cpu(ipi_to_irq, cpu)[vector];
+	BUG_ON(irq < 0);
+	notify_remote_via_irq(irq);
+}
+
 
 /*
  * Search the CPUs pending events bitmasks.  For each one found, map
===================================================================
--- a/arch/i386/xen/mmu.c
+++ b/arch/i386/xen/mmu.c
@@ -388,8 +388,12 @@ void xen_pgd_pin(pgd_t *pgd)
 
 	xen_mc_batch();
 
-	if (pgd_walk(pgd, pin_page, TASK_SIZE))
+	if (pgd_walk(pgd, pin_page, TASK_SIZE)) {
+		/* re-enable interrupts for kmap_flush_unused */
+		xen_mc_issue(0);
 		kmap_flush_unused();
+		xen_mc_batch();
+	}
 
 	mcs = __xen_mc_entry(sizeof(*op));
 	op = mcs.args;
@@ -472,27 +476,58 @@ void xen_dup_mmap(struct mm_struct *oldm
 	spin_unlock(&mm->page_table_lock);
 }
 
+
+#ifdef CONFIG_SMP
+/* Another cpu may still have their %cr3 pointing at the pagetable, so
+   we need to repoint it somewhere else before we can unpin it. */
+static void drop_other_mm_ref(void *info)
+{
+	struct mm_struct *mm = info;
+
+	if (__get_cpu_var(cpu_tlbstate).active_mm == mm)
+		leave_mm(smp_processor_id());
+}
+
+static void drop_mm_ref(struct mm_struct *mm)
+{
+	if (current->active_mm == mm) {
+		if (current->mm == mm)
+			load_cr3(swapper_pg_dir);
+		else
+			leave_mm(smp_processor_id());
+	}
+
+	if (!cpus_empty(mm->cpu_vm_mask))
+		xen_smp_call_function_mask(mm->cpu_vm_mask, drop_other_mm_ref,
+					   mm, 1);
+}
+#else
+static void drop_mm_ref(struct mm_struct *mm)
+{
+	if (current->active_mm == mm)
+		load_cr3(swapper_pg_dir);
+}
+#endif
+
+/*
+ * While a process runs, Xen pins its pagetables, which means that the
+ * hypervisor forces it to be read-only, and it controls all updates
+ * to it.  This means that all pagetable updates have to go via the
+ * hypervisor, which is moderately expensive.
+ *
+ * Since we're pulling the pagetable down, we switch to use init_mm,
+ * unpin old process pagetable and mark it all read-write, which
+ * allows further operations on it to be simple memory accesses.
+ *
+ * The only subtle point is that another CPU may be still using the
+ * pagetable because of lazy tlb flushing.  This means we need need to
+ * switch all CPUs off this pagetable before we can unpin it.
+ */
 void xen_exit_mmap(struct mm_struct *mm)
 {
-	struct task_struct *tsk = current;
-
-	task_lock(tsk);
-
-	/*
-	 * We aggressively remove defunct pgd from cr3. We execute unmap_vmas()
-	 * *much* faster this way, as no tlb flushes means bigger wrpt batches.
-	 */
-	if (tsk->active_mm == mm) {
-		tsk->active_mm = &init_mm;
-		atomic_inc(&init_mm.mm_count);
-
-		switch_mm(mm, &init_mm, tsk);
-
-		atomic_dec(&mm->mm_count);
-		BUG_ON(atomic_read(&mm->mm_count) == 0);
-	}
-
-	task_unlock(tsk);
+	get_cpu();		/* make sure we don't move around */
+	drop_mm_ref(mm);
+	put_cpu();
 
 	xen_pgd_unpin(mm->pgd);
 }
===================================================================
--- a/arch/i386/xen/mmu.h
+++ b/arch/i386/xen/mmu.h
@@ -2,6 +2,19 @@
 
 #include <linux/linkage.h>
 #include <asm/page.h>
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
 
 void set_pte_mfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
 
===================================================================
--- a/arch/i386/xen/setup.c
+++ b/arch/i386/xen/setup.c
@@ -93,4 +93,9 @@ void __init xen_arch_setup(void)
 	       COMMAND_LINE_SIZE : MAX_GUEST_CMDLINE);
 
 	pm_idle = xen_idle;
+
+#ifdef CONFIG_SMP
+	/* fill cpus_possible with all available cpus */
+	xen_fill_possible_map();
+#endif
 }
===================================================================
--- /dev/null
+++ b/arch/i386/xen/smp.c
@@ -0,0 +1,405 @@
+/*
+ * Xen SMP support
+ *
+ * This file implements the Xen versions of smp_ops.  SMP under Xen is
+ * very straightforward.  Bringing a CPU up is simply a matter of
+ * loading its initial context and setting it running.
+ *
+ * IPIs are handled through the Xen event mechanism.
+ *
+ * Because virtual CPUs can be scheduled onto any real CPU, there's no
+ * useful topology information for the kernel to make use of.  As a
+ * result, all CPUs are treated as if they're single-core and
+ * single-threaded.
+ *
+ * This does not handle HOTPLUG_CPU yet.
+ */
+#include <linux/sched.h>
+#include <linux/err.h>
+
+#include <asm/paravirt.h>
+#include <asm/smp.h>
+#include <asm/desc.h>
+#include <asm/pgtable.h>
+#include <asm/cpu.h>
+
+#include <xen/interface/xen.h>
+#include <xen/interface/vcpu.h>
+
+#include <asm/xen/interface.h>
+#include <asm/xen/hypercall.h>
+
+#include <xen/page.h>
+#include <xen/events.h>
+
+#include "xen-ops.h"
+#include "mmu.h"
+
+static cpumask_t cpu_initialized_map;
+static DEFINE_PER_CPU(int, resched_irq);
+static DEFINE_PER_CPU(int, callfunc_irq);
+
+/*
+ * Structure and data for smp_call_function(). This is designed to minimise
+ * static memory requirements. It also looks cleaner.
+ */
+static DEFINE_SPINLOCK(call_lock);
+
+struct call_data_struct {
+	void (*func) (void *info);
+	void *info;
+	atomic_t started;
+	atomic_t finished;
+	int wait;
+};
+
+static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id);
+
+static struct call_data_struct *call_data;
+
+/*
+ * Reschedule call back. Nothing to do,
+ * all the work is done automatically when
+ * we return from the interrupt.
+ */
+static irqreturn_t xen_reschedule_interrupt(int irq, void *dev_id)
+{
+	return IRQ_HANDLED;
+}
+
+static __cpuinit void cpu_bringup_and_idle(void)
+{
+	int cpu = smp_processor_id();
+
+	cpu_init();
+	xen_setup_timer();
+
+	preempt_disable();
+	per_cpu(cpu_state, cpu) = CPU_ONLINE;
+
+	/* We can take interrupts now: we're officially "up". */
+	local_irq_enable();
+
+	wmb();
+	cpu_idle();
+}
+
+static int xen_smp_intr_init(unsigned int cpu)
+{
+	int rc;
+	const char *resched_name, *callfunc_name;
+
+	per_cpu(resched_irq, cpu) = per_cpu(callfunc_irq, cpu) = -1;
+
+	resched_name = kasprintf(GFP_KERNEL, "resched%d", cpu);
+	rc = bind_ipi_to_irqhandler(XEN_RESCHEDULE_VECTOR,
+				    cpu,
+				    xen_reschedule_interrupt,
+				    IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				    resched_name,
+				    NULL);
+	if (rc < 0)
+		goto fail;
+	per_cpu(resched_irq, cpu) = rc;
+
+	callfunc_name = kasprintf(GFP_KERNEL, "callfunc%d", cpu);
+	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_VECTOR,
+				    cpu,
+				    xen_call_function_interrupt,
+				    IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				    callfunc_name,
+				    NULL);
+	if (rc < 0)
+		goto fail;
+	per_cpu(callfunc_irq, cpu) = rc;
+
+	return 0;
+
+ fail:
+	if (per_cpu(resched_irq, cpu) >= 0)
+		unbind_from_irqhandler(per_cpu(resched_irq, cpu), NULL);
+	if (per_cpu(callfunc_irq, cpu) >= 0)
+		unbind_from_irqhandler(per_cpu(callfunc_irq, cpu), NULL);
+	return rc;
+}
+
+void __init xen_fill_possible_map(void)
+{
+	int i, rc;
+
+	for (i = 0; i < NR_CPUS; i++) {
+		rc = HYPERVISOR_vcpu_op(VCPUOP_is_up, i, NULL);
+		if (rc >= 0)
+			cpu_set(i, cpu_possible_map);
+	}
+}
+
+void __init xen_smp_prepare_boot_cpu(void)
+{
+	int cpu;
+
+	BUG_ON(smp_processor_id() != 0);
+	native_smp_prepare_boot_cpu();
+
+	xen_vcpu_setup(0);
+
+	/* We've switched to the "real" per-cpu gdt, so make sure the
+	   old memory can be recycled */
+	make_lowmem_page_readwrite(&per_cpu__gdt_page);
+
+	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+		cpus_clear(cpu_sibling_map[cpu]);
+		cpus_clear(cpu_core_map[cpu]);
+	}
+}
+
+void __init xen_smp_prepare_cpus(unsigned int max_cpus)
+{
+	unsigned cpu;
+
+	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+		cpus_clear(cpu_sibling_map[cpu]);
+		cpus_clear(cpu_core_map[cpu]);
+	}
+
+	smp_store_cpu_info(0);
+	set_cpu_sibling_map(0);
+
+	if (xen_smp_intr_init(0))
+		BUG();
+
+	cpu_initialized_map = cpumask_of_cpu(0);
+
+	/* Restrict the possible_map according to max_cpus. */
+	while ((num_possible_cpus() > 1) && (num_possible_cpus() > max_cpus)) {
+		for (cpu = NR_CPUS-1; !cpu_isset(cpu, cpu_possible_map); cpu--)
+			continue;
+		cpu_clear(cpu, cpu_possible_map);
+	}
+
+	for_each_possible_cpu (cpu) {
+		struct task_struct *idle;
+
+		if (cpu == 0)
+			continue;
+
+		idle = fork_idle(cpu);
+		if (IS_ERR(idle))
+			panic("failed fork for CPU %d", cpu);
+
+		cpu_set(cpu, cpu_present_map);
+	}
+
+	//init_xenbus_allowed_cpumask();
+}
+
+static __cpuinit int
+cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
+{
+	struct vcpu_guest_context *ctxt;
+	struct gdt_page *gdt = &per_cpu(gdt_page, cpu);
+
+	if (cpu_test_and_set(cpu, cpu_initialized_map))
+		return 0;
+
+	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
+	if (ctxt == NULL)
+		return -ENOMEM;
+
+	ctxt->flags = VGCF_IN_KERNEL;
+	ctxt->user_regs.ds = __USER_DS;
+	ctxt->user_regs.es = __USER_DS;
+	ctxt->user_regs.fs = __KERNEL_PERCPU;
+	ctxt->user_regs.gs = 0;
+	ctxt->user_regs.ss = __KERNEL_DS;
+	ctxt->user_regs.eip = (unsigned long)cpu_bringup_and_idle;
+	ctxt->user_regs.eflags = 0x1000; /* IOPL_RING1 */
+
+	memset(&ctxt->fpu_ctxt, 0, sizeof(ctxt->fpu_ctxt));
+
+	xen_copy_trap_info(ctxt->trap_ctxt);
+
+	ctxt->ldt_ents = 0;
+
+	BUG_ON((unsigned long)gdt->gdt & ~PAGE_MASK);
+	make_lowmem_page_readonly(gdt->gdt);
+
+	ctxt->gdt_frames[0] = virt_to_mfn(gdt->gdt);
+	ctxt->gdt_ents      = ARRAY_SIZE(gdt->gdt);
+
+	ctxt->user_regs.cs = __KERNEL_CS;
+	ctxt->user_regs.esp = idle->thread.esp0 - sizeof(struct pt_regs);
+
+	ctxt->kernel_ss = __KERNEL_DS;
+	ctxt->kernel_sp = idle->thread.esp0;
+
+	ctxt->event_callback_cs     = __KERNEL_CS;
+	ctxt->event_callback_eip    = (unsigned long)xen_hypervisor_callback;
+	ctxt->failsafe_callback_cs  = __KERNEL_CS;
+	ctxt->failsafe_callback_eip = (unsigned long)xen_failsafe_callback;
+
+	per_cpu(xen_cr3, cpu) = __pa(swapper_pg_dir);
+	ctxt->ctrlreg[3] = xen_pfn_to_cr3(virt_to_mfn(swapper_pg_dir));
+
+	if (HYPERVISOR_vcpu_op(VCPUOP_initialise, cpu, ctxt))
+		BUG();
+
+	kfree(ctxt);
+	return 0;
+}
+
+int __cpuinit xen_cpu_up(unsigned int cpu)
+{
+	struct task_struct *idle = idle_task(cpu);
+	int rc;
+
+#if 0
+	rc = cpu_up_check(cpu);
+	if (rc)
+		return rc;
+#endif
+
+	init_gdt(cpu);
+	per_cpu(current_task, cpu) = idle;
+	xen_vcpu_setup(cpu);
+	irq_ctx_init(cpu);
+
+	/* make sure interrupts start blocked */
+	per_cpu(xen_vcpu, cpu)->evtchn_upcall_mask = 1;
+
+	rc = cpu_initialize_context(cpu, idle);
+	if (rc)
+		return rc;
+
+	if (num_online_cpus() == 1)
+		alternatives_smp_switch(1);
+
+	rc = xen_smp_intr_init(cpu);
+	if (rc)
+		return rc;
+
+	/* This must be done before setting cpu_online_map */
+	smp_store_cpu_info(cpu);
+	set_cpu_sibling_map(cpu);
+	wmb();
+
+	cpu_set(cpu, cpu_online_map);
+
+	rc = HYPERVISOR_vcpu_op(VCPUOP_up, cpu, NULL);
+	BUG_ON(rc);
+
+	return 0;
+}
+
+void xen_smp_cpus_done(unsigned int max_cpus)
+{
+}
+
+static void stop_self(void *v)
+{
+	int cpu = smp_processor_id();
+
+	/* make sure we're not pinning something down */
+	load_cr3(swapper_pg_dir);
+	/* should set up a minimal gdt */
+
+	HYPERVISOR_vcpu_op(VCPUOP_down, cpu, NULL);
+	BUG();
+}
+
+void xen_smp_send_stop(void)
+{
+	cpumask_t mask = cpu_online_map;
+	cpu_clear(smp_processor_id(), mask);
+	xen_smp_call_function_mask(mask, stop_self, NULL, 0);
+}
+
+void xen_smp_send_reschedule(int cpu)
+{
+	xen_send_IPI_one(cpu, XEN_RESCHEDULE_VECTOR);
+}
+
+
+static void xen_send_IPI_mask(cpumask_t mask, enum ipi_vector vector)
+{
+	unsigned cpu;
+
+	cpus_and(mask, mask, cpu_online_map);
+
+	for_each_cpu_mask(cpu, mask)
+		xen_send_IPI_one(cpu, vector);
+}
+
+static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
+{
+	void (*func) (void *info) = call_data->func;
+	void *info = call_data->info;
+	int wait = call_data->wait;
+
+	/*
+	 * Notify initiating CPU that I've grabbed the data and am
+	 * about to execute the function
+	 */
+	mb();
+	atomic_inc(&call_data->started);
+	/*
+	 * At this point the info structure may be out of scope unless wait==1
+	 */
+	irq_enter();
+	(*func)(info);
+	irq_exit();
+
+	if (wait) {
+		mb();
+		atomic_inc(&call_data->finished);
+	}
+
+	return IRQ_HANDLED;
+}
+
+int xen_smp_call_function_mask(cpumask_t mask, void (*func)(void *),
+			       void *info, int wait)
+{
+	struct call_data_struct data;
+	int cpus;
+
+	/* Holding any lock stops cpus from going down. */
+	spin_lock(&call_lock);
+
+	cpu_clear(smp_processor_id(), mask);
+
+	cpus = cpus_weight(mask);
+	if (!cpus) {
+		spin_unlock(&call_lock);
+		return 0;
+	}
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	data.func = func;
+	data.info = info;
+	atomic_set(&data.started, 0);
+	data.wait = wait;
+	if (wait)
+		atomic_set(&data.finished, 0);
+
+	call_data = &data;
+	mb();
+
+	/* Send a message to other CPUs and wait for them to respond */
+	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
+
+	/* Make sure other vcpus get a chance to run.
+	   XXX too severe?  Maybe we should check the other CPU's states? */
+	HYPERVISOR_sched_op(SCHEDOP_yield, 0);
+
+	/* Wait for response */
+	while (atomic_read(&data.started) != cpus ||
+	       (wait && atomic_read(&data.finished) != cpus))
+		cpu_relax();
+
+	spin_unlock(&call_lock);
+
+	return 0;
+}
===================================================================
--- a/arch/i386/xen/time.c
+++ b/arch/i386/xen/time.c
@@ -472,8 +472,9 @@ static irqreturn_t xen_timer_interrupt(i
 	return ret;
 }
 
-static void xen_setup_timer(int cpu)
-{
+void xen_setup_timer(void)
+{
+	int cpu = smp_processor_id();
 	const char *name;
 	struct clock_event_device *evt;
 	int irq;
@@ -522,5 +523,5 @@ __init void xen_time_init(void)
 
 	tsc_disable = 0;
 
-	xen_setup_timer(cpu);
-}
+	xen_setup_timer();
+}
===================================================================
--- a/arch/i386/xen/xen-ops.h
+++ b/arch/i386/xen/xen-ops.h
@@ -2,6 +2,13 @@
 #define XEN_OPS_H
 
 #include <linux/init.h>
+#include <linux/percpu.h>
+
+/* These are code, but not functions.  Defined in entry.S */
+extern const char xen_hypervisor_callback[];
+extern const char xen_failsafe_callback[];
+
+void xen_copy_trap_info(struct trap_info *traps);
 
 DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
 DECLARE_PER_CPU(unsigned long, xen_cr3);
@@ -18,6 +25,7 @@ unsigned long xen_get_wallclock(void);
 unsigned long xen_get_wallclock(void);
 int xen_set_wallclock(unsigned long time);
 unsigned long long xen_sched_clock(void);
+void xen_setup_timer(void);
 
 void xen_mark_init_mm_pinned(void);
 
@@ -28,5 +36,22 @@ static inline unsigned xen_get_lazy_mode
 	return x86_read_percpu(xen_lazy_mode);
 }
 
+void __init xen_fill_possible_map(void);
+
+void xen_vcpu_setup(int cpu);
+void xen_smp_prepare_boot_cpu(void);
+void xen_smp_prepare_cpus(unsigned int max_cpus);
+int xen_cpu_up(unsigned int cpu);
+void xen_smp_cpus_done(unsigned int max_cpus);
+
+void xen_smp_send_stop(void);
+void xen_smp_send_reschedule(int cpu);
+int xen_smp_call_function (void (*func) (void *info), void *info, int nonatomic,
+			   int wait);
+int xen_smp_call_function_single(int cpu, void (*func) (void *info), void *info,
+				 int nonatomic, int wait);
+
+int xen_smp_call_function_mask(cpumask_t mask, void (*func)(void *),
+			       void *info, int wait);
 
 #endif /* XEN_OPS_H */
===================================================================
--- a/include/asm-i386/mach-default/irq_vectors_limits.h
+++ b/include/asm-i386/mach-default/irq_vectors_limits.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_IRQ_VECTORS_LIMITS_H
 #define _ASM_IRQ_VECTORS_LIMITS_H
 
-#ifdef CONFIG_X86_IO_APIC
+#if defined(CONFIG_X86_IO_APIC) || defined(CONFIG_PARAVIRT)
 #define NR_IRQS 224
 # if (224 >= 32 * NR_CPUS)
 # define NR_IRQ_VECTORS NR_IRQS
===================================================================
--- a/include/asm-i386/mmu_context.h
+++ b/include/asm-i386/mmu_context.h
@@ -31,6 +31,8 @@ static inline void enter_lazy_tlb(struct
 		per_cpu(cpu_tlbstate, cpu).state = TLBSTATE_LAZY;
 #endif
 }
+
+void leave_mm (unsigned long cpu);
 
 static inline void switch_mm(struct mm_struct *prev,
 			     struct mm_struct *next,
===================================================================
--- a/include/asm-i386/smp.h
+++ b/include/asm-i386/smp.h
@@ -43,9 +43,12 @@ extern u8 x86_cpu_to_apicid[];
 
 #define cpu_physical_id(cpu)	x86_cpu_to_apicid[cpu]
 
+extern void set_cpu_sibling_map(int cpu);
+
 #ifdef CONFIG_HOTPLUG_CPU
 extern void cpu_exit_clear(void);
 extern void cpu_uninit(void);
+extern void remove_siblinginfo(int cpu);
 #endif
 
 struct smp_ops
@@ -143,6 +146,8 @@ extern void __cpu_die(unsigned int cpu);
 extern void __cpu_die(unsigned int cpu);
 extern unsigned int num_processors;
 
+void __cpuinit smp_store_cpu_info(int id);
+
 #endif /* !__ASSEMBLY__ */
 
 #else /* CONFIG_SMP */
===================================================================
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -1,15 +1,32 @@
 #ifndef _XEN_EVENTS_H
 #define _XEN_EVENTS_H
 
-#include <linux/irq.h>
+#include <linux/interrupt.h>
+
+#include <xen/interface/event_channel.h>
+#include <asm/xen/hypercall.h>
+
+enum ipi_vector {
+	XEN_RESCHEDULE_VECTOR,
+	XEN_CALL_FUNCTION_VECTOR,
+
+	XEN_NR_IPIS,
+};
 
 int bind_evtchn_to_irqhandler(unsigned int evtchn,
-			      irqreturn_t (*handler)(int, void *),
+			      irq_handler_t handler,
 			      unsigned long irqflags, const char *devname,
 			      void *dev_id);
 int bind_virq_to_irqhandler(unsigned int virq, unsigned int cpu,
-			    irqreturn_t (*handler)(int, void *),
-			    unsigned long irqflags, const char *devname, void *dev_id);
+			    irq_handler_t handler,
+			    unsigned long irqflags, const char *devname,
+			    void *dev_id);
+int bind_ipi_to_irqhandler(enum ipi_vector ipi,
+			   unsigned int cpu,
+			   irq_handler_t handler,
+			   unsigned long irqflags,
+			   const char *devname,
+			   void *dev_id);
 
 /*
  * Common unbind function for all event sources. Takes IRQ to unbind from.
@@ -17,6 +34,8 @@ int bind_virq_to_irqhandler(unsigned int
  * made with bind_evtchn_to_irqhandler()).
  */
 void unbind_from_irqhandler(unsigned int irq, void *dev_id);
+
+void xen_send_IPI_one(unsigned int cpu, enum ipi_vector vector);
 
 static inline void notify_remote_via_evtchn(int port)
 {

-- 


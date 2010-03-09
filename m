Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab0CIQCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:02:06 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:9932 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab0CIQB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:01:57 -0500
X-IronPort-AV: E=Sophos;i="4.49,608,1262563200"; 
   d="scan'208";a="9859529"
Date: Tue, 9 Mar 2010 16:06:01 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3 of 5] Linux pvops: evtchn delivery for legacy interrupts
Message-ID: <alpine.DEB.2.00.1003091547140.26495@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch sets the callback to receive evtchns from Xen, using the
callback vector delivery mechanism.
It also sets up mapping for GSIs to PIRQs, using exactly the same code
path as in the dom0 case.
This allows the guest to receive evtchns in place of interrupts,
avoiding expensive EOIs.
Finally this patch introduces the PV on HVM SMP machinery, that at the
moment is exactly the same code as in the last patch series from Shen
and still needs some fixes.


The new version of the patch has some major fixes to the smp code,
now working correctly.
Instead of reimplementing flush_tlb_others as flush_tlb_all, I wrote my
own version of flush_tlb_others using smp_call_function_many.


Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Sheng Yang <sheng@linux.intel.com>

---

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9764b1a..f92dac2 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1707,6 +1707,8 @@ __apicdebuginit(void) print_IO_APIC(void)
 		struct irq_pin_list *entry;
 
 		cfg = desc->chip_data;
+		if (!cfg)
+			continue;
 		entry = cfg->irq_2_pin;
 		if (!entry)
 			continue;
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 88d9dc7..80a6b5a 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -34,8 +34,11 @@
 #include <xen/interface/vcpu.h>
 #include <xen/interface/memory.h>
 #include <xen/interface/hvm/hvm_op.h>
+#include <xen/interface/hvm/params.h>
 #include <xen/features.h>
 #include <xen/page.h>
+#include <xen/hvm.h>
+#include <xen/events.h>
 #include <xen/hvc-console.h>
 
 #include <asm/paravirt.h>
@@ -1322,14 +1325,41 @@ static void __init init_shared_info(void)
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
 }
 
+static int set_callback_via(uint64_t via)
+{
+       struct xen_hvm_param a;
+
+       a.domid = DOMID_SELF;
+       a.index = HVM_PARAM_CALLBACK_IRQ;
+       a.value = via;
+       return HYPERVISOR_hvm_op(HVMOP_set_param, &a);
+}
+
+void do_hvm_pv_evtchn_intr(void)
+{
+       xen_evtchn_do_upcall(get_irq_regs());
+}
+
 void __init xen_guest_init(void)
 {
 	int r;
+	uint64_t callback_via;
 
 	r = init_hvm_pv_info();
 	if (r < 0)
 		return;
 
 	init_shared_info();
+
+	callback_via = HVM_CALLBACK_VECTOR(GENERIC_INTERRUPT_VECTOR);
+	set_callback_via(callback_via);
+	generic_interrupt_extension = do_hvm_pv_evtchn_intr;
+
+	have_vcpu_info_placement = 0;
+	pv_irq_ops.init_IRQ = xen_init_IRQ;
+ 	pv_time_ops = xen_time_ops;
+ 	pv_apic_ops = xen_apic_ops;
+	machine_ops = xen_machine_ops;
+	xen_hvm_smp_init();
 }
 
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index ea8b5e6..62d0dec 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -15,11 +15,15 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 #include <linux/smp.h>
+#include <linux/nmi.h>
+#include <linux/mm_types.h>
 
 #include <asm/paravirt.h>
 #include <asm/desc.h>
 #include <asm/pgtable.h>
 #include <asm/cpu.h>
+#include <asm/trampoline.h>
+#include <asm/tlbflush.h>
 
 #include <xen/interface/xen.h>
 #include <xen/interface/vcpu.h>
@@ -170,8 +174,8 @@ static void __init xen_smp_prepare_boot_cpu(void)
 
 	/* We've switched to the "real" per-cpu gdt, so make sure the
 	   old memory can be recycled */
-	make_lowmem_page_readwrite(xen_initial_gdt);
-
+	if (xen_feature(XENFEAT_writable_descriptor_tables))
+		make_lowmem_page_readwrite(xen_initial_gdt);
 	xen_setup_vcpu_info_placement();
 }
 
@@ -281,6 +285,39 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	return 0;
 }
 
+static __cpuinit int
+hvm_pv_cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
+{
+       struct vcpu_guest_context *ctxt;
+       unsigned long start_ip;
+
+       if (cpumask_test_and_set_cpu(cpu, xen_cpu_initialized_map))
+               return 0;
+
+       ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
+       if (ctxt == NULL)
+               return -ENOMEM;
+
+       early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
+       initial_code = (unsigned long)cpu_bringup_and_idle;
+       stack_start.sp = (void *) idle->thread.sp;
+
+       /* start_ip had better be page-aligned! */
+       start_ip = setup_trampoline();
+
+       /* only start_ip is what we want */
+       ctxt->flags = VGCF_HVM_GUEST;
+       ctxt->user_regs.eip = start_ip;
+
+       printk(KERN_INFO "Booting processor %d ip 0x%lx\n", cpu, start_ip);
+
+       if (HYPERVISOR_vcpu_op(VCPUOP_initialise, cpu, ctxt))
+               BUG();
+
+       kfree(ctxt);
+       return 0;
+}
+
 static int __cpuinit xen_cpu_up(unsigned int cpu)
 {
 	struct task_struct *idle = idle_task(cpu);
@@ -290,6 +327,7 @@ static int __cpuinit xen_cpu_up(unsigned int cpu)
 #ifdef CONFIG_X86_32
 	irq_ctx_init(cpu);
 #else
+	initial_gs = per_cpu_offset(cpu);
 	clear_tsk_thread_flag(idle, TIF_FORK);
 	per_cpu(kernel_stack, cpu) =
 		(unsigned long)task_stack_page(idle) -
@@ -306,7 +344,12 @@ static int __cpuinit xen_cpu_up(unsigned int cpu)
 	/* make sure interrupts start blocked */
 	per_cpu(xen_vcpu, cpu)->evtchn_upcall_mask = 1;
 
-	rc = cpu_initialize_context(cpu, idle);
+	if (xen_pv_domain())
+		rc = cpu_initialize_context(cpu, idle);
+	else if (xen_hvm_domain())
+		rc = hvm_pv_cpu_initialize_context(cpu, idle);
+	else
+		BUG();
 	if (rc)
 		return rc;
 
@@ -483,3 +526,56 @@ void __init xen_smp_init(void)
 	xen_fill_possible_map();
 	xen_init_spinlocks();
 }
+
+static struct flush_tlb_args {
+	struct mm_struct *mm;
+	unsigned long va;
+};
+
+static void do_flush_tlb(void *data)
+{
+	unsigned long cpu = smp_processor_id();
+	struct flush_tlb_args *args = (struct flush_tlb_args *) data;
+
+	if (args->mm == NULL ||
+			args->mm == percpu_read(cpu_tlbstate.active_mm)) {
+		int tlbstate = percpu_read(cpu_tlbstate.state);
+
+		/*
+		 * args->mm == NULL means flush everything, including
+		 * global tlbs, which will only happen when flushing
+		 * kernel mappings.
+		 */
+		if (args->mm == NULL)
+			__flush_tlb_all();
+		else if (tlbstate == TLBSTATE_OK) {
+			if (args->va == TLB_FLUSH_ALL)
+				local_flush_tlb();
+			else
+				__flush_tlb_one(args->va);
+		}
+
+		if (tlbstate == TLBSTATE_LAZY)
+			leave_mm(cpu);
+	}
+}
+
+static void xen_hvm_flush_tlb_others(const struct cpumask *cpumask,
+                                     struct mm_struct *mm, unsigned long va)
+{
+	struct flush_tlb_args data;
+	data.mm = mm;
+	data.va = va;
+
+	preempt_disable();
+	smp_call_function_many(cpumask, do_flush_tlb, &data, 1);
+	preempt_enable();
+}
+
+void __init xen_hvm_smp_init(void)
+{
+	smp_ops = xen_smp_ops;
+	xen_init_spinlocks();
+	pv_mmu_ops.flush_tlb_others = xen_hvm_flush_tlb_others;
+}
+
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 4e0bd24..f2032c8 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -72,10 +72,12 @@ static inline void xen_setup_vcpu_vsyscall_time_info(int cpu)
 
 #ifdef CONFIG_SMP
 void xen_smp_init(void);
+void xen_hvm_smp_init(void);
 
 extern cpumask_var_t xen_cpu_initialized_map;
 #else
 static inline void xen_smp_init(void) {}
+static inline void xen_hvm_smp_init(void) {}
 #endif
 
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 3e2bebd..29a399d 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -553,7 +553,7 @@ int xen_allocate_pirq(unsigned gsi, int shareable, char *name)
 
 	/* If we are a PV guest, we don't have GSIs (no ACPI passed). Therefore
 	 * we are using the !xen_initial_domain() to drop in the function.*/
-	if (identity_mapped_irq(gsi) || !xen_initial_domain()) {
+	if (identity_mapped_irq(gsi) || xen_pv_domain()) {
 		irq = gsi;
 		irq_to_desc_alloc_node(irq, 0);
 		dynamic_irq_init(irq);
@@ -1048,9 +1048,10 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 	static DEFINE_PER_CPU(unsigned, nesting_count);
  	unsigned count;
 
-	exit_idle();
-	irq_enter();
-
+	if (!xen_hvm_domain()) {
+		exit_idle();
+		irq_enter();
+	}
 	do {
 		unsigned long pending_words;
 
@@ -1086,8 +1087,10 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 	} while(count != 1);
 
 out:
-	irq_exit();
-	set_irq_regs(old_regs);
+	if (!xen_hvm_domain()) {
+		irq_exit();
+		set_irq_regs(old_regs);
+	}
 
 	put_cpu();
 }
@@ -1397,7 +1400,9 @@ void __init xen_init_IRQ(void)
 	for (i = 0; i < NR_EVENT_CHANNELS; i++)
 		mask_evtchn(i);
 
-	irq_ctx_init(smp_processor_id());
-
-	xen_setup_pirqs();
+	if (xen_hvm_domain())
+		native_init_IRQ();
+	else
+		irq_ctx_init(smp_processor_id());
+ 	xen_setup_pirqs();
 }
diff --git a/include/xen/events.h b/include/xen/events.h
index 030a750..cbe3218 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -80,6 +80,8 @@ int xen_vector_from_irq(unsigned pirq);
 /* Return gsi allocated to pirq */
 int xen_gsi_from_irq(unsigned pirq);
 
+void xen_evtchn_do_upcall(struct pt_regs *regs);
+
 #ifdef CONFIG_XEN_DOM0_PCI
 void xen_setup_pirqs(void);
 #else
diff --git a/include/xen/hvm.h b/include/xen/hvm.h
index c2a55f6..35c9c11 100644
--- a/include/xen/hvm.h
+++ b/include/xen/hvm.h
@@ -3,6 +3,7 @@
 #define XEN_HVM_H__
 
 #include <xen/interface/hvm/params.h>
+#include <asm/xen/hypercall.h>
 
 static inline unsigned long hvm_get_parameter(int idx)
 {
@@ -20,4 +21,9 @@ static inline unsigned long hvm_get_parameter(int idx)
        return xhv.value;
 }
 
+#define HVM_CALLBACK_VIA_TYPE_VECTOR 0x2
+#define HVM_CALLBACK_VIA_TYPE_SHIFT 56
+#define HVM_CALLBACK_VECTOR(x) (((uint64_t)HVM_CALLBACK_VIA_TYPE_VECTOR)<<\
+                               HVM_CALLBACK_VIA_TYPE_SHIFT | (x))
+
 #endif /* XEN_HVM_H__ */

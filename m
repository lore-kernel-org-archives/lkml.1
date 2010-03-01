Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab0CAJjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:39:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:23633 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab0CAJhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:37:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,559,1262592000"; 
   d="scan'208";a="496561846"
From: Sheng Yang <sheng@linux.intel.com>
To: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>, linux-kernel@vger.kernel.org,
       Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 5/7] xen: Make event channel work with PV extension of HVM
Date: Mon,  1 Mar 2010 17:38:33 +0800
Message-Id: <1267436315-24486-6-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267436315-24486-1-git-send-email-sheng@linux.intel.com>
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We mapped each IOAPIC pin to a VIRQ, so that we can deliver interrupt through
these VIRQs.

We used X86_PLATFORM_IPI_VECTOR as the noficiation vector for hypervisor
to notify guest about the event.

The Xen PV timer is used to provide guest a reliable timer.

The patch also enabled SMP support, then we can support IPI through evtchn as well.

Then we don't use IOAPIC/LAPIC.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/xen/enlighten.c    |   72 +++++++++++++++++++++
 arch/x86/xen/irq.c          |   37 ++++++++++-
 arch/x86/xen/smp.c          |  144 ++++++++++++++++++++++++++++++++++++++++++-
 arch/x86/xen/xen-ops.h      |    3 +
 drivers/xen/events.c        |   66 ++++++++++++++++++-
 include/xen/events.h        |    1 +
 include/xen/hvm.h           |    5 ++
 include/xen/interface/xen.h |    6 ++-
 8 files changed, 326 insertions(+), 8 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index fdb9664..f617639 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -58,6 +58,9 @@
 #include <asm/reboot.h>
 #include <asm/stackprotector.h>
 
+#include <xen/hvm.h>
+#include <xen/events.h>
+
 #include "xen-ops.h"
 #include "mmu.h"
 #include "multicalls.h"
@@ -1212,6 +1215,8 @@ static void __init xen_hvm_pv_banner(void)
 		pv_info.name);
 	printk(KERN_INFO "Xen version: %d.%d%s\n",
 		version >> 16, version & 0xffff, extra.extraversion);
+	if (xen_hvm_pv_evtchn_enabled())
+		printk(KERN_INFO "PV feature: Event channel enabled\n");
 }
 
 static int xen_para_available(void)
@@ -1256,6 +1261,9 @@ static int init_hvm_pv_info(void)
 
 	xen_hvm_pv_status = XEN_HVM_PV_ENABLED;
 
+	if (edx & XEN_CPUID_FEAT2_HVM_PV_EVTCHN)
+		xen_hvm_pv_status |= XEN_HVM_PV_EVTCHN_ENABLED;
+
 	/* We only support 1 page of hypercall for now */
 	if (pages != 1)
 		return -ENOMEM;
@@ -1292,12 +1300,42 @@ static void __init init_shared_info(void)
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
 }
 
+static int set_callback_via(uint64_t via)
+{
+	struct xen_hvm_param a;
+
+	a.domid = DOMID_SELF;
+	a.index = HVM_PARAM_CALLBACK_IRQ;
+	a.value = via;
+	return HYPERVISOR_hvm_op(HVMOP_set_param, &a);
+}
+
+void do_hvm_pv_evtchn_intr(void)
+{
+#ifdef CONFIG_X86_64
+	per_cpu(irq_count, smp_processor_id())++;
+#endif
+	xen_evtchn_do_upcall(get_irq_regs());
+#ifdef CONFIG_X86_64
+	per_cpu(irq_count, smp_processor_id())--;
+#endif
+}
+
+#ifdef CONFIG_X86_LOCAL_APIC
+static void xen_hvm_pv_evtchn_apic_write(u32 reg, u32 val)
+{
+	/* The only one reached here should be EOI */
+	WARN_ON(reg != APIC_EOI);
+}
+#endif
+
 void __init xen_guest_init(void)
 {
 #ifdef CONFIG_X86_32
 	return;
 #else
 	int r;
+	uint64_t callback_via;
 
 	/* Ensure the we won't confused with PV */
 	if (xen_domain_type == XEN_PV_DOMAIN)
@@ -1310,6 +1348,40 @@ void __init xen_guest_init(void)
 	init_shared_info();
 
 	xen_hvm_pv_init_irq_ops();
+
+	if (xen_hvm_pv_evtchn_enabled()) {
+		if (enable_hvm_pv(HVM_PV_EVTCHN))
+			return;
+
+		pv_time_ops = xen_time_ops;
+
+		x86_init.timers.timer_init = xen_time_init;
+		x86_init.timers.setup_percpu_clockev = x86_init_noop;
+		x86_cpuinit.setup_percpu_clockev = x86_init_noop;
+
+		x86_platform.calibrate_tsc = xen_tsc_khz;
+		x86_platform.get_wallclock = xen_get_wallclock;
+		x86_platform.set_wallclock = xen_set_wallclock;
+
+		pv_apic_ops = xen_apic_ops;
+#ifdef CONFIG_X86_LOCAL_APIC
+		/*
+		 * set up the basic apic ops.
+		 */
+		set_xen_basic_apic_ops();
+		apic->write = xen_hvm_pv_evtchn_apic_write;
+#endif
+
+		callback_via = HVM_CALLBACK_VECTOR(X86_PLATFORM_IPI_VECTOR);
+		set_callback_via(callback_via);
+
+		x86_platform_ipi_callback = do_hvm_pv_evtchn_intr;
+
+		disable_acpi();
+
+		xen_hvm_pv_smp_init();
+		machine_ops = xen_machine_ops;
+	}
 #endif
 }
 
diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
index fadaa97..7827a6d 100644
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -5,6 +5,7 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/sched.h>
 #include <xen/interface/vcpu.h>
+#include <xen/xen.h>
 
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -132,6 +133,20 @@ void __init xen_init_irq_ops()
 	x86_init.irqs.intr_init = xen_init_IRQ;
 }
 
+static void xen_hvm_pv_evtchn_disable(void)
+{
+	native_irq_disable();
+	xen_irq_disable();
+}
+PV_CALLEE_SAVE_REGS_THUNK(xen_hvm_pv_evtchn_disable);
+
+static void xen_hvm_pv_evtchn_enable(void)
+{
+	native_irq_enable();
+	xen_irq_enable();
+}
+PV_CALLEE_SAVE_REGS_THUNK(xen_hvm_pv_evtchn_enable);
+
 static void xen_hvm_pv_safe_halt(void)
 {
 	/* Do local_irq_enable() explicitly in hvm_pv guest */
@@ -147,8 +162,26 @@ static void xen_hvm_pv_halt(void)
 		xen_hvm_pv_safe_halt();
 }
 
+static const struct pv_irq_ops xen_hvm_pv_irq_ops __initdata = {
+	.save_fl = __PV_IS_CALLEE_SAVE(native_save_fl),
+	.restore_fl = __PV_IS_CALLEE_SAVE(native_restore_fl),
+	.irq_disable = PV_CALLEE_SAVE(xen_hvm_pv_evtchn_disable),
+	.irq_enable = PV_CALLEE_SAVE(xen_hvm_pv_evtchn_enable),
+
+	.safe_halt = xen_hvm_pv_safe_halt,
+	.halt = xen_hvm_pv_halt,
+#ifdef CONFIG_X86_64
+	.adjust_exception_frame = paravirt_nop,
+#endif
+};
+
 void __init xen_hvm_pv_init_irq_ops(void)
 {
-	pv_irq_ops.safe_halt = xen_hvm_pv_safe_halt;
-	pv_irq_ops.halt = xen_hvm_pv_halt;
+	if (xen_hvm_pv_evtchn_enabled()) {
+		pv_irq_ops = xen_hvm_pv_irq_ops;
+		x86_init.irqs.intr_init = xen_hvm_pv_evtchn_init_IRQ;
+	} else {
+		pv_irq_ops.safe_halt = xen_hvm_pv_safe_halt;
+		pv_irq_ops.halt = xen_hvm_pv_halt;
+	}
 }
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 563d205..a85d0b6 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -15,20 +15,26 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 #include <linux/smp.h>
+#include <linux/nmi.h>
 
 #include <asm/paravirt.h>
 #include <asm/desc.h>
 #include <asm/pgtable.h>
 #include <asm/cpu.h>
+#include <asm/trampoline.h>
+#include <asm/tlbflush.h>
+#include <asm/mtrr.h>
 
 #include <xen/interface/xen.h>
 #include <xen/interface/vcpu.h>
 
 #include <asm/xen/interface.h>
 #include <asm/xen/hypercall.h>
+#include <asm/xen/hypervisor.h>
 
 #include <xen/page.h>
 #include <xen/events.h>
+#include <xen/xen.h>
 
 #include "xen-ops.h"
 #include "mmu.h"
@@ -171,7 +177,8 @@ static void __init xen_smp_prepare_boot_cpu(void)
 
 	/* We've switched to the "real" per-cpu gdt, so make sure the
 	   old memory can be recycled */
-	make_lowmem_page_readwrite(xen_initial_gdt);
+	if (xen_pv_domain())
+		make_lowmem_page_readwrite(xen_initial_gdt);
 
 	xen_setup_vcpu_info_placement();
 }
@@ -480,3 +487,138 @@ void __init xen_smp_init(void)
 	xen_fill_possible_map();
 	xen_init_spinlocks();
 }
+
+static __cpuinit void xen_hvm_pv_start_secondary(void)
+{
+	int cpu = smp_processor_id();
+
+	cpu_init();
+	touch_nmi_watchdog();
+	preempt_disable();
+
+	/* otherwise gcc will move up smp_processor_id before the cpu_init */
+	barrier();
+	/*
+	 * Check TSC synchronization with the BSP:
+	 */
+	check_tsc_sync_target();
+
+	/* Done in smp_callin(), move it here */
+	set_mtrr_aps_delayed_init();
+	smp_store_cpu_info(cpu);
+
+	/* This must be done before setting cpu_online_mask */
+	set_cpu_sibling_map(cpu);
+	wmb();
+
+	set_cpu_online(smp_processor_id(), true);
+	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
+
+	/* enable local interrupts */
+	local_irq_enable();
+
+	xen_setup_cpu_clockevents();
+
+	wmb();
+	cpu_idle();
+}
+
+static __cpuinit int
+hvm_pv_cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
+{
+	struct vcpu_guest_context *ctxt;
+	unsigned long start_ip;
+
+	if (cpumask_test_and_set_cpu(cpu, xen_cpu_initialized_map))
+		return 0;
+
+	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
+	if (ctxt == NULL)
+		return -ENOMEM;
+
+	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
+	initial_code = (unsigned long)xen_hvm_pv_start_secondary;
+	stack_start.sp = (void *) idle->thread.sp;
+
+	/* start_ip had better be page-aligned! */
+	start_ip = setup_trampoline();
+
+	/* only start_ip is what we want */
+	ctxt->flags = VGCF_HVM_GUEST;
+	ctxt->user_regs.eip = start_ip;
+
+	printk(KERN_INFO "Booting processor %d ip 0x%lx\n", cpu, start_ip);
+
+	if (HYPERVISOR_vcpu_op(VCPUOP_initialise, cpu, ctxt))
+		BUG();
+
+	kfree(ctxt);
+	return 0;
+}
+
+static int __init xen_hvm_pv_cpu_up(unsigned int cpu)
+{
+	struct task_struct *idle = idle_task(cpu);
+	int rc;
+	unsigned long flags;
+
+	per_cpu(current_task, cpu) = idle;
+
+#ifdef CONFIG_X86_32
+	irq_ctx_init(cpu);
+#else
+	clear_tsk_thread_flag(idle, TIF_FORK);
+	initial_gs = per_cpu_offset(cpu);
+	per_cpu(kernel_stack, cpu) =
+		(unsigned long)task_stack_page(idle) -
+		KERNEL_STACK_OFFSET + THREAD_SIZE;
+#endif
+
+	xen_setup_timer(cpu);
+	xen_init_lock_cpu(cpu);
+
+	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
+
+	rc = hvm_pv_cpu_initialize_context(cpu, idle);
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
+	rc = HYPERVISOR_vcpu_op(VCPUOP_up, cpu, NULL);
+	BUG_ON(rc);
+
+	/*
+	 * Check TSC synchronization with the AP (keep irqs disabled
+	 * while doing so):
+	 */
+	local_irq_save(flags);
+	check_tsc_sync_source(cpu);
+	local_irq_restore(flags);
+
+	while (!cpu_online(cpu)) {
+		cpu_relax();
+		touch_nmi_watchdog();
+	}
+
+	return 0;
+}
+
+static void xen_hvm_pv_flush_tlb_others(const struct cpumask *cpumask,
+					struct mm_struct *mm, unsigned long va)
+{
+	/* TODO Make it more specific */
+	flush_tlb_all();
+}
+
+void __init xen_hvm_pv_smp_init(void)
+{
+	smp_ops = xen_smp_ops;
+	smp_ops.cpu_up = xen_hvm_pv_cpu_up;
+	pv_mmu_ops.flush_tlb_others = xen_hvm_pv_flush_tlb_others;
+}
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index cc00760..a8cc129 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -34,6 +34,7 @@ void xen_reserve_top(void);
 char * __init xen_memory_setup(void);
 void __init xen_arch_setup(void);
 void __init xen_init_IRQ(void);
+void __init xen_hvm_pv_evtchn_init_IRQ(void);
 void xen_enable_sysenter(void);
 void xen_enable_syscall(void);
 void xen_vcpu_restore(void);
@@ -61,10 +62,12 @@ void xen_setup_vcpu_info_placement(void);
 
 #ifdef CONFIG_SMP
 void xen_smp_init(void);
+void xen_hvm_pv_smp_init(void);
 
 extern cpumask_var_t xen_cpu_initialized_map;
 #else
 static inline void xen_smp_init(void) {}
+static inline void xen_hvm_pv_smp_init(void) {}
 #endif
 
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index ce602dd..e1835db 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -37,9 +37,12 @@
 
 #include <xen/xen-ops.h>
 #include <xen/events.h>
+#include <xen/xen.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/event_channel.h>
 
+#include <asm/desc.h>
+
 /*
  * This lock protects updates to the following mapping and reference-count
  * arrays. The lock does not need to be acquired to read the mapping tables.
@@ -624,8 +627,13 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 	struct vcpu_info *vcpu_info = __get_cpu_var(xen_vcpu);
  	unsigned count;
 
-	exit_idle();
-	irq_enter();
+	/*
+	 * If is PV featured HVM, these have already been done
+	 */
+	if (likely(!xen_hvm_pv_evtchn_enabled())) {
+		exit_idle();
+		irq_enter();
+	}
 
 	do {
 		unsigned long pending_words;
@@ -662,8 +670,10 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 	} while(count != 1);
 
 out:
-	irq_exit();
-	set_irq_regs(old_regs);
+	if (likely(!xen_hvm_pv_evtchn_enabled())) {
+		irq_exit();
+		set_irq_regs(old_regs);
+	}
 
 	put_cpu();
 }
@@ -944,3 +954,51 @@ void __init xen_init_IRQ(void)
 
 	irq_ctx_init(smp_processor_id());
 }
+
+void __init xen_hvm_pv_evtchn_init_IRQ(void)
+{
+	int i;
+
+	xen_init_IRQ();
+	for (i = 0; i < NR_IRQS_LEGACY; i++) {
+		struct evtchn_bind_virq bind_virq;
+		struct irq_desc *desc = irq_to_desc(i);
+		int virq, evtchn;
+
+		virq = i + VIRQ_EMUL_PIN_START;
+		bind_virq.virq = virq;
+		bind_virq.vcpu = 0;
+
+		if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_virq,
+						&bind_virq) != 0)
+			BUG();
+
+		evtchn = bind_virq.port;
+		evtchn_to_irq[evtchn] = i;
+		irq_info[i] = mk_virq_info(evtchn, virq);
+
+		desc->status = IRQ_DISABLED;
+		desc->action = NULL;
+		desc->depth = 1;
+
+		/*
+		 * 16 old-style INTA-cycle interrupts:
+		 */
+		set_irq_chip_and_handler_name(i, &xen_dynamic_chip,
+					handle_level_irq, "event");
+	}
+
+	/*
+	 * Cover the whole vector space, no vector can escape
+	 * us. (some of these will be overridden and become
+	 * 'special' SMP interrupts)
+	 */
+	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
+		int vector = FIRST_EXTERNAL_VECTOR + i;
+		if (vector != IA32_SYSCALL_VECTOR)
+			set_intr_gate(vector, interrupt[i]);
+	}
+
+	/* generic IPI for platform specific use, now used for HVM evtchn */
+	alloc_intr_gate(X86_PLATFORM_IPI_VECTOR, x86_platform_ipi);
+}
diff --git a/include/xen/events.h b/include/xen/events.h
index e68d59a..91755db 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -56,4 +56,5 @@ void xen_poll_irq(int irq);
 /* Determine the IRQ which is bound to an event channel */
 unsigned irq_from_evtchn(unsigned int evtchn);
 
+void xen_evtchn_do_upcall(struct pt_regs *regs);
 #endif	/* _XEN_EVENTS_H */
diff --git a/include/xen/hvm.h b/include/xen/hvm.h
index 4ea8887..c66d788 100644
--- a/include/xen/hvm.h
+++ b/include/xen/hvm.h
@@ -20,4 +20,9 @@ static inline unsigned long hvm_get_parameter(int idx)
 	return xhv.value;
 }
 
+#define HVM_CALLBACK_VIA_TYPE_VECTOR 0x2
+#define HVM_CALLBACK_VIA_TYPE_SHIFT 56
+#define HVM_CALLBACK_VECTOR(x) (((uint64_t)HVM_CALLBACK_VIA_TYPE_VECTOR)<<\
+				HVM_CALLBACK_VIA_TYPE_SHIFT | (x))
+
 #endif /* XEN_HVM_H__ */
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index 2befa3e..9282ff7 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -90,7 +90,11 @@
 #define VIRQ_ARCH_6    22
 #define VIRQ_ARCH_7    23
 
-#define NR_VIRQS       24
+#define VIRQ_EMUL_PIN_START 24
+#define VIRQ_EMUL_PIN_NUM 16
+
+#define NR_VIRQS       40
+
 /*
  * MMU-UPDATE REQUESTS
  *
-- 
1.5.4.5


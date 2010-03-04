Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab0CDJhC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 04:37:02 -0500
Received: from mga02.intel.com ([134.134.136.20]:22650 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373Ab0CDJgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 04:36:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,580,1262592000"; 
   d="scan'208";a="601232394"
From: Sheng Yang <sheng@linux.intel.com>
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Keir Fraser <keir.fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@citrix.com>, linux-kernel@vger.kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 7/7] xen: Make event channel work with PV extension of HVM
Date: Thu,  4 Mar 2010 17:36:56 +0800
Message-Id: <1267695416-14988-8-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267695416-14988-1-git-send-email-sheng@linux.intel.com>
References: <1267695416-14988-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We mapped each IOAPIC pin to a VIRQ, so that we can deliver interrupt through
these VIRQs.

We used X86_PLATFORM_IPI_VECTOR as the noficiation vector for hypervisor
to notify guest about the event.

The patch also enabled SMP support, then we can support IPI through evtchn as well.

Then we don't use IOAPIC/LAPIC, eliminated the overhead brought by
unnecessary VMExit caused by LAPIC.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/xen/enlighten.c    |    6 +-
 arch/x86/xen/hvmpv.c        |   68 +++++++++++++++++++++++++++++++-
 arch/x86/xen/irq.c          |   28 +++++++++++++
 arch/x86/xen/smp.c          |   92 ++++++++++++++++++++++++++++++++++++++++--
 arch/x86/xen/xen-ops.h      |   14 +++++++
 drivers/xen/events.c        |   74 +++++++++++++++++++++++++++++++---
 include/xen/events.h        |    6 +++
 include/xen/hvm.h           |    5 ++
 include/xen/interface/xen.h |    6 ++-
 include/xen/xen.h           |    2 +
 10 files changed, 285 insertions(+), 16 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 36daccb..2d60e70 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -717,7 +717,7 @@ static u32 xen_safe_apic_wait_icr_idle(void)
         return 0;
 }
 
-static void set_xen_basic_apic_ops(void)
+void xen_set_basic_apic_ops(void)
 {
 	apic->read = xen_apic_read;
 	apic->write = xen_apic_write;
@@ -1026,7 +1026,7 @@ static void xen_crash_shutdown(struct pt_regs *regs)
 	xen_reboot(SHUTDOWN_crash);
 }
 
-static const struct machine_ops __initdata xen_machine_ops = {
+const struct machine_ops __initdata xen_machine_ops = {
 	.restart = xen_restart,
 	.halt = xen_machine_halt,
 	.power_off = xen_machine_halt,
@@ -1116,7 +1116,7 @@ asmlinkage void __init xen_start_kernel(void)
 	/*
 	 * set up the basic apic ops.
 	 */
-	set_xen_basic_apic_ops();
+	xen_set_basic_apic_ops();
 #endif
 
 	if (xen_feature(XENFEAT_mmu_pt_update_preserve_ad)) {
diff --git a/arch/x86/xen/hvmpv.c b/arch/x86/xen/hvmpv.c
index 284e021..233951b 100644
--- a/arch/x86/xen/hvmpv.c
+++ b/arch/x86/xen/hvmpv.c
@@ -17,6 +17,7 @@
 #include <xen/interface/version.h>
 #include <xen/interface/memory.h>
 
+#include <asm/reboot.h>
 #include <asm/xen/cpuid.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -44,6 +45,8 @@ static void __init xen_hvm_pv_banner(void)
 	printk(KERN_INFO "Xen version: %d.%d%s\n",
 		version >> 16, version & 0xffff, extra.extraversion);
 	printk(KERN_INFO "PV feature: PV clocksource enabled\n");
+	if (xen_hvm_pv_evtchn_enabled())
+		printk(KERN_INFO "PV feature: Event channel enabled\n");
 }
 
 static int __init xen_para_available(void)
@@ -83,6 +86,9 @@ static int __init init_hvm_pv_info(void)
 	if (!(edx & XEN_CPUID_FEAT2_HVM_PV))
 		return -ENODEV;
 
+	if (edx & XEN_CPUID_FEAT2_HVM_PV_EVTCHN)
+		xen_hvm_pv_features |= XEN_HVM_PV_EVTCHN_ENABLED;
+
 	/* We only support 1 page of hypercall for now */
 	if (pages != 1)
 		return -ENOMEM;
@@ -131,12 +137,42 @@ static void __init init_pv_clocksource(void)
 	x86_platform.get_wallclock = xen_get_wallclock;
 	x86_platform.set_wallclock = xen_set_wallclock;
 
-	clocksource_register(&xen_clocksource);
+	/* It would be done in xen_time_init() if evtchn enabled */
+	if (!xen_hvm_pv_evtchn_enabled())
+		clocksource_register(&xen_clocksource);
+}
+
+static int set_callback_via(uint64_t via)
+{
+	struct xen_hvm_param a;
+
+	a.domid = DOMID_SELF;
+	a.index = HVM_PARAM_CALLBACK_IRQ;
+	a.value = via;
+	return HYPERVISOR_hvm_op(HVMOP_set_param, &a);
 }
 
+void do_hvm_pv_evtchn_intr(void)
+{
+	per_cpu(irq_count, smp_processor_id())++;
+	xen_hvm_evtchn_do_upcall(get_irq_regs());
+	per_cpu(irq_count, smp_processor_id())--;
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
+extern struct machine_ops xen_machine_ops;
+
 void __init xen_guest_init(void)
 {
 	int r;
+	uint64_t callback_via;
 
 	/* Ensure the we won't confused with others */
 	if (xen_domain_type != XEN_NATIVE)
@@ -150,4 +186,34 @@ void __init xen_guest_init(void)
 
 	/* PV clocksource would be enabled by default */
 	init_pv_clocksource();
+
+	if (xen_hvm_pv_evtchn_enabled()) {
+		if (enable_hvm_pv(HVM_PV_EVTCHN))
+			return;
+
+		xen_hvm_pv_init_irq_ops();
+
+		x86_init.timers.timer_init = xen_time_init;
+		x86_init.timers.setup_percpu_clockev = x86_init_noop;
+		x86_cpuinit.setup_percpu_clockev = x86_init_noop;
+
+		pv_apic_ops.startup_ipi_hook = paravirt_nop;
+#ifdef CONFIG_X86_LOCAL_APIC
+		/*
+		 * set up the basic apic ops.
+		 */
+		xen_set_basic_apic_ops();
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
 }
diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
index 9d30105..e325640 100644
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -2,6 +2,7 @@
 
 #include <asm/x86_init.h>
 
+#include <xen/xen.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/sched.h>
 #include <xen/interface/vcpu.h>
@@ -131,3 +132,30 @@ void __init xen_init_irq_ops()
 	pv_irq_ops = xen_irq_ops;
 	x86_init.irqs.intr_init = xen_init_IRQ;
 }
+
+#ifdef CONFIG_XEN_HVM_PV
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
+void __init xen_hvm_pv_init_irq_ops(void)
+{
+	if (xen_hvm_pv_evtchn_enabled()) {
+		pv_irq_ops.irq_disable =
+			PV_CALLEE_SAVE(xen_hvm_pv_evtchn_disable);
+		pv_irq_ops.irq_enable =
+			PV_CALLEE_SAVE(xen_hvm_pv_evtchn_enable);
+		x86_init.irqs.intr_init = xen_hvm_pv_evtchn_init_IRQ;
+	}
+}
+#endif
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 563d205..a31429e 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -15,18 +15,24 @@
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
 
+#include <xen/xen.h>
 #include <xen/page.h>
 #include <xen/events.h>
 
@@ -63,8 +69,13 @@ static __cpuinit void cpu_bringup(void)
 	touch_softlockup_watchdog();
 	preempt_disable();
 
-	xen_enable_sysenter();
-	xen_enable_syscall();
+	if (xen_pv_domain()) {
+		xen_enable_sysenter();
+		xen_enable_syscall();
+	} else if (xen_hvm_pv_evtchn_enabled())
+		set_mtrr_aps_delayed_init();
+	else
+		BUG();
 
 	cpu = smp_processor_id();
 	smp_store_cpu_info(cpu);
@@ -171,7 +182,8 @@ static void __init xen_smp_prepare_boot_cpu(void)
 
 	/* We've switched to the "real" per-cpu gdt, so make sure the
 	   old memory can be recycled */
-	make_lowmem_page_readwrite(xen_initial_gdt);
+	if (xen_feature(XENFEAT_writable_descriptor_tables))
+		make_lowmem_page_readwrite(xen_initial_gdt);
 
 	xen_setup_vcpu_info_placement();
 }
@@ -282,6 +294,47 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	return 0;
 }
 
+#ifdef CONFIG_XEN_HVM_PV
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
+	initial_code = (unsigned long)cpu_bringup_and_idle;
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
+#else
+static int hvm_pv_cpu_initialize_context(unsigned int cpu,
+					 struct task_struct *idle)
+{
+	return 0;
+}
+#endif
+
 static int __cpuinit xen_cpu_up(unsigned int cpu)
 {
 	struct task_struct *idle = idle_task(cpu);
@@ -292,11 +345,17 @@ static int __cpuinit xen_cpu_up(unsigned int cpu)
 	irq_ctx_init(cpu);
 #else
 	clear_tsk_thread_flag(idle, TIF_FORK);
+
+	if (xen_hvm_pv_evtchn_enabled())
+		initial_gs = per_cpu_offset(cpu);
+
 	per_cpu(kernel_stack, cpu) =
 		(unsigned long)task_stack_page(idle) -
 		KERNEL_STACK_OFFSET + THREAD_SIZE;
 #endif
-	xen_setup_runstate_info(cpu);
+	if (xen_pv_domain())
+		xen_setup_runstate_info(cpu);
+
 	xen_setup_timer(cpu);
 	xen_init_lock_cpu(cpu);
 
@@ -305,7 +364,13 @@ static int __cpuinit xen_cpu_up(unsigned int cpu)
 	/* make sure interrupts start blocked */
 	per_cpu(xen_vcpu, cpu)->evtchn_upcall_mask = 1;
 
-	rc = cpu_initialize_context(cpu, idle);
+	if (xen_pv_domain())
+		rc = cpu_initialize_context(cpu, idle);
+	else if (xen_hvm_pv_evtchn_enabled())
+		rc = hvm_pv_cpu_initialize_context(cpu, idle);
+	else
+		BUG();
+
 	if (rc)
 		return rc;
 
@@ -480,3 +545,20 @@ void __init xen_smp_init(void)
 	xen_fill_possible_map();
 	xen_init_spinlocks();
 }
+
+#ifdef CONFIG_XEN_HVM_PV
+static void xen_hvm_pv_flush_tlb_others(const struct cpumask *cpumask,
+					struct mm_struct *mm, unsigned long va)
+{
+	/* TODO Make it more specific */
+	flush_tlb_all();
+}
+
+void __init xen_hvm_pv_smp_init(void)
+{
+	if (xen_hvm_pv_evtchn_enabled()) {
+		smp_ops = xen_smp_ops;
+		pv_mmu_ops.flush_tlb_others = xen_hvm_pv_flush_tlb_others;
+	}
+}
+#endif
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index f9153a3..6f55815 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -51,6 +51,12 @@ void __init xen_time_init(void);
 unsigned long xen_get_wallclock(void);
 int xen_set_wallclock(unsigned long time);
 unsigned long long xen_sched_clock(void);
+void xen_set_basic_apic_ops(void);
+
+#ifdef CONFIG_XEN_HVM_PV
+void __init xen_hvm_pv_init_irq_ops(void);
+void __init xen_hvm_pv_evtchn_init_IRQ(void);
+#endif /* CONFIG_XEN_HVM_PV */
 
 irqreturn_t xen_debug_interrupt(int irq, void *dev_id);
 
@@ -61,9 +67,17 @@ void xen_setup_vcpu_info_placement(void);
 #ifdef CONFIG_SMP
 void xen_smp_init(void);
 
+#ifdef CONFIG_XEN_HVM_PV
+void xen_hvm_pv_smp_init(void);
+#endif /* CONFIG_XEN_HVM_PV */
+
 extern cpumask_var_t xen_cpu_initialized_map;
 #else
 static inline void xen_smp_init(void) {}
+#ifdef CONFIG_XEN_HVM_PV
+static inline void xen_hvm_pv_smp_init(void) {}
+#endif /* CONFIG_XEN_HVM_PV */
+
 #endif
 
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index ce602dd..e4b9de6 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -32,14 +32,17 @@
 #include <asm/irq.h>
 #include <asm/idle.h>
 #include <asm/sync_bitops.h>
+#include <asm/desc.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
 
+#include <xen/xen.h>
 #include <xen/xen-ops.h>
 #include <xen/events.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/event_channel.h>
 
+
 /*
  * This lock protects updates to the following mapping and reference-count
  * arrays. The lock does not need to be acquired to read the mapping tables.
@@ -616,17 +619,13 @@ static DEFINE_PER_CPU(unsigned, xed_nesting_count);
  * a bitset of words which contain pending event bits.  The second
  * level is a bitset of pending events themselves.
  */
-void xen_evtchn_do_upcall(struct pt_regs *regs)
+void __xen_evtchn_do_upcall(struct pt_regs *regs)
 {
 	int cpu = get_cpu();
-	struct pt_regs *old_regs = set_irq_regs(regs);
 	struct shared_info *s = HYPERVISOR_shared_info;
 	struct vcpu_info *vcpu_info = __get_cpu_var(xen_vcpu);
  	unsigned count;
 
-	exit_idle();
-	irq_enter();
-
 	do {
 		unsigned long pending_words;
 
@@ -662,10 +661,25 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 	} while(count != 1);
 
 out:
+	put_cpu();
+}
+
+void xen_evtchn_do_upcall(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	exit_idle();
+	irq_enter();
+
+	__xen_evtchn_do_upcall(regs);
+
 	irq_exit();
 	set_irq_regs(old_regs);
+}
 
-	put_cpu();
+void xen_hvm_evtchn_do_upcall(struct pt_regs *regs)
+{
+	__xen_evtchn_do_upcall(regs);
 }
 
 /* Rebind a new event channel to an existing irq. */
@@ -944,3 +958,51 @@ void __init xen_init_IRQ(void)
 
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
index e68d59a..6b12725 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -56,4 +56,10 @@ void xen_poll_irq(int irq);
 /* Determine the IRQ which is bound to an event channel */
 unsigned irq_from_evtchn(unsigned int evtchn);
 
+void xen_evtchn_do_upcall(struct pt_regs *regs);
+
+#ifdef CONFIG_XEN_HVM_PV
+void xen_hvm_evtchn_do_upcall(struct pt_regs *regs);
+#endif
+
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
index 2befa3e..70a6c6e 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -90,7 +90,11 @@
 #define VIRQ_ARCH_6    22
 #define VIRQ_ARCH_7    23
 
-#define NR_VIRQS       24
+#define VIRQ_EMUL_PIN_START 24
+#define VIRQ_EMUL_PIN_NUM 16
+
+#define NR_VIRQS       (VIRQ_EMUL_PIN_START + VIRQ_EMUL_PIN_NUM)
+
 /*
  * MMU-UPDATE REQUESTS
  *
diff --git a/include/xen/xen.h b/include/xen/xen.h
index 11f5ced..ce2a256 100644
--- a/include/xen/xen.h
+++ b/include/xen/xen.h
@@ -26,6 +26,8 @@ extern u32 xen_hvm_pv_features;
 
 #define xen_hvm_pv_evtchn_enabled() \
 		(xen_hvm_pv_features & XEN_HVM_PV_EVTCHN_ENABLED)
+#else
+#define xen_hvm_pv_evtchn_enabled() 0
 #endif /* CONFIG_XEN_HVM_PV */
 
 #ifdef CONFIG_XEN_DOM0
-- 
1.5.4.5


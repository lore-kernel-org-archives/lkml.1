Return-Path: <linux-kernel-owner+w=401wt.eu-S1760854AbYGHXco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbYGHXco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757978AbYGHXPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:30 -0400
Received: from gw.goop.org ([64.81.55.164]:51207 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133AbYGHXOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:42 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 21 of 55] xen64: smp.c compile hacking
X-Mercurial-Node: 22a175601bba06c82afc85896c9d35b204f6eee7
Message-Id: <22a175601bba06c82afc.1215554803@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of random changes to make xen/smp.c compile in 64-bit mode.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>a
---
 arch/x86/xen/setup.c   |    7 ---
 arch/x86/xen/smp.c     |   98 +++++++++++++++++++++++++++---------------------
 arch/x86/xen/xen-ops.h |    2
 3 files changed, 58 insertions(+), 49 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -98,7 +98,7 @@
 	/* Mask events on entry, even though they get enabled immediately */
 	static struct callback_register sysenter = {
 		.type = CALLBACKTYPE_sysenter,
-		.address = { __KERNEL_CS, (unsigned long)xen_sysenter_target },
+		.address = XEN_CALLBACK(__KERNEL_CS, xen_sysenter_target),
 		.flags = CALLBACKF_mask_events,
 	};
 
@@ -143,11 +143,6 @@
 
 	pm_idle = xen_idle;
 
-#ifdef CONFIG_SMP
-	/* fill cpus_possible with all available cpus */
-	xen_fill_possible_map();
-#endif
-
 	paravirt_disable_iospace();
 
 	fiddle_vdso();
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -66,12 +66,20 @@
 	int cpu = smp_processor_id();
 
 	cpu_init();
+	preempt_disable();
+
 	xen_enable_sysenter();
 
-	preempt_disable();
-	per_cpu(cpu_state, cpu) = CPU_ONLINE;
+	cpu = smp_processor_id();
+	smp_store_cpu_info(cpu);
+	cpu_data(cpu).x86_max_cores = 1;
+	set_cpu_sibling_map(cpu);
 
 	xen_setup_cpu_clockevents();
+
+	cpu_set(cpu, cpu_online_map);
+	x86_write_percpu(cpu_state, CPU_ONLINE);
+	wmb();
 
 	/* We can take interrupts now: we're officially "up". */
 	local_irq_enable();
@@ -141,7 +149,7 @@
 	return rc;
 }
 
-void __init xen_fill_possible_map(void)
+static void __init xen_fill_possible_map(void)
 {
 	int i, rc;
 
@@ -154,24 +162,12 @@
 
 static void __init xen_smp_prepare_boot_cpu(void)
 {
-	int cpu;
-
 	BUG_ON(smp_processor_id() != 0);
 	native_smp_prepare_boot_cpu();
 
 	/* We've switched to the "real" per-cpu gdt, so make sure the
 	   old memory can be recycled */
-	make_lowmem_page_readwrite(&per_cpu__gdt_page);
-
-	for_each_possible_cpu(cpu) {
-		cpus_clear(per_cpu(cpu_sibling_map, cpu));
-		/*
-		 * cpu_core_map lives in a per cpu area that is cleared
-		 * when the per cpu array is allocated.
-		 *
-		 * cpus_clear(per_cpu(cpu_core_map, cpu));
-		 */
-	}
+	make_lowmem_page_readwrite(&per_cpu_var(gdt_page));
 
 	xen_setup_vcpu_info_placement();
 }
@@ -180,17 +176,8 @@
 {
 	unsigned cpu;
 
-	for_each_possible_cpu(cpu) {
-		cpus_clear(per_cpu(cpu_sibling_map, cpu));
-		/*
-		 * cpu_core_ map will be zeroed when the per
-		 * cpu area is allocated.
-		 *
-		 * cpus_clear(per_cpu(cpu_core_map, cpu));
-		 */
-	}
-
 	smp_store_cpu_info(0);
+	cpu_data(0).x86_max_cores = 1;
 	set_cpu_sibling_map(0);
 
 	if (xen_smp_intr_init(0))
@@ -225,7 +212,7 @@
 cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 {
 	struct vcpu_guest_context *ctxt;
-	struct gdt_page *gdt = &per_cpu(gdt_page, cpu);
+	struct desc_struct *gdt;
 
 	if (cpu_test_and_set(cpu, xen_cpu_initialized_map))
 		return 0;
@@ -234,12 +221,15 @@
 	if (ctxt == NULL)
 		return -ENOMEM;
 
+	gdt = get_cpu_gdt_table(cpu);
+
 	ctxt->flags = VGCF_IN_KERNEL;
 	ctxt->user_regs.ds = __USER_DS;
 	ctxt->user_regs.es = __USER_DS;
+	ctxt->user_regs.ss = __KERNEL_DS;
+#ifdef CONFIG_X86_32
 	ctxt->user_regs.fs = __KERNEL_PERCPU;
-	ctxt->user_regs.gs = 0;
-	ctxt->user_regs.ss = __KERNEL_DS;
+#endif
 	ctxt->user_regs.eip = (unsigned long)cpu_bringup_and_idle;
 	ctxt->user_regs.eflags = 0x1000; /* IOPL_RING1 */
 
@@ -249,11 +239,11 @@
 
 	ctxt->ldt_ents = 0;
 
-	BUG_ON((unsigned long)gdt->gdt & ~PAGE_MASK);
-	make_lowmem_page_readonly(gdt->gdt);
+	BUG_ON((unsigned long)gdt & ~PAGE_MASK);
+	make_lowmem_page_readonly(gdt);
 
-	ctxt->gdt_frames[0] = virt_to_mfn(gdt->gdt);
-	ctxt->gdt_ents      = ARRAY_SIZE(gdt->gdt);
+	ctxt->gdt_frames[0] = virt_to_mfn(gdt);
+	ctxt->gdt_ents      = GDT_ENTRIES;
 
 	ctxt->user_regs.cs = __KERNEL_CS;
 	ctxt->user_regs.esp = idle->thread.sp0 - sizeof(struct pt_regs);
@@ -261,9 +251,11 @@
 	ctxt->kernel_ss = __KERNEL_DS;
 	ctxt->kernel_sp = idle->thread.sp0;
 
+#ifdef CONFIG_X86_32
 	ctxt->event_callback_cs     = __KERNEL_CS;
+	ctxt->failsafe_callback_cs  = __KERNEL_CS;
+#endif
 	ctxt->event_callback_eip    = (unsigned long)xen_hypervisor_callback;
-	ctxt->failsafe_callback_cs  = __KERNEL_CS;
 	ctxt->failsafe_callback_eip = (unsigned long)xen_failsafe_callback;
 
 	per_cpu(xen_cr3, cpu) = __pa(swapper_pg_dir);
@@ -287,10 +279,27 @@
 		return rc;
 #endif
 
+#ifdef CONFIG_X86_64
+	/* Allocate node local memory for AP pdas */
+	WARN_ON(cpu == 0);
+	if (cpu > 0) {
+		rc = get_local_pda(cpu);
+		if (rc)
+			return rc;
+	}
+#endif
+
+#ifdef CONFIG_X86_32
 	init_gdt(cpu);
 	per_cpu(current_task, cpu) = idle;
 	irq_ctx_init(cpu);
+#else
+	cpu_pda(cpu)->pcurrent = idle;
+	clear_tsk_thread_flag(idle, TIF_FORK);
+#endif
 	xen_setup_timer(cpu);
+
+	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 
 	/* make sure interrupts start blocked */
 	per_cpu(xen_vcpu, cpu)->evtchn_upcall_mask = 1;
@@ -306,15 +315,13 @@
 	if (rc)
 		return rc;
 
-	smp_store_cpu_info(cpu);
-	set_cpu_sibling_map(cpu);
-	/* This must be done before setting cpu_online_map */
-	wmb();
-
-	cpu_set(cpu, cpu_online_map);
-
 	rc = HYPERVISOR_vcpu_op(VCPUOP_up, cpu, NULL);
 	BUG_ON(rc);
+
+	while(per_cpu(cpu_state, cpu) != CPU_ONLINE) {
+		HYPERVISOR_sched_op(SCHEDOP_yield, 0);
+		barrier();
+	}
 
 	return 0;
 }
@@ -379,7 +386,11 @@
 {
 	irq_enter();
 	generic_smp_call_function_interrupt();
+#ifdef CONFIG_X86_32
 	__get_cpu_var(irq_stat).irq_call_count++;
+#else
+	add_pda(irq_call_count, 1);
+#endif
 	irq_exit();
 
 	return IRQ_HANDLED;
@@ -389,7 +400,11 @@
 {
 	irq_enter();
 	generic_smp_call_function_single_interrupt();
+#ifdef CONFIG_X86_32
 	__get_cpu_var(irq_stat).irq_call_count++;
+#else
+	add_pda(irq_call_count, 1);
+#endif
 	irq_exit();
 
 	return IRQ_HANDLED;
@@ -411,4 +426,5 @@
 void __init xen_smp_init(void)
 {
 	smp_ops = xen_smp_ops;
+	xen_fill_possible_map();
 }
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -44,8 +44,6 @@
 
 void xen_mark_init_mm_pinned(void);
 
-void __init xen_fill_possible_map(void);
-
 void __init xen_setup_vcpu_info_placement(void);
 
 #ifdef CONFIG_SMP



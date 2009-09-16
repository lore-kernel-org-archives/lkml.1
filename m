Return-Path: <linux-kernel-owner+w=401wt.eu-S1757682AbZIPIop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbZIPIop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757969AbZIPIoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:44:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:43151 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757957AbZIPImz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:42:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,396,1249282800"; 
   d="scan'208";a="448946667"
From: Sheng Yang <sheng@linux.intel.com>
To: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jun Nakajima <jun.nakajima@intel.com>, Eddie Dong <eddie.dong@intel.com>,
       linux-kernel@vger.kernel.org, xen-devel <xen-devel@lists.xensource.com>,
       Sheng Yang <sheng@linux.intel.com>
Subject: [RFC][PATCH 09/10] xen/hybrid: Make event channel work with QEmu emulated devices
Date: Wed, 16 Sep 2009 16:42:30 +0800
Message-Id: <1253090551-7969-10-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1253090551-7969-1-git-send-email-sheng@linux.intel.com>
References: <1253090551-7969-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We mapped each IOAPIC pin to a VIRQ, so that we can deliver interrupt through
these VIRQs.

We also use GENERIC_INTERRUPT_VECTOR as the noficiation vector for hypervisor
to notify guest about the event.

Then we don't need IOAPIC/LAPIC now...

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/kernel/smpboot.c   |   14 ++++++++++++
 arch/x86/xen/enlighten.c    |   49 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/irq.c          |   15 +++++++++++-
 drivers/xen/events.c        |   47 +++++++++++++++++++++++++++++++++++++++++
 include/xen/events.h        |    1 +
 include/xen/hvm.h           |    5 ++++
 include/xen/interface/xen.h |    6 ++++-
 7 files changed, 134 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 58d24ef..39c1890 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -67,6 +67,10 @@
 
 #include <asm/smpboot_hooks.h>
 
+#ifdef CONFIG_XEN
+#include <asm/xen/hypervisor.h>
+#endif
+
 #ifdef CONFIG_X86_32
 u8 apicid_2_node[MAX_APICID];
 static int low_mappings;
@@ -1062,6 +1066,11 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	}
 	set_cpu_sibling_map(0);
 
+#ifdef CONFIG_XEN
+	if (xen_hybrid_evtchn_enabled())
+		goto out;
+#endif
+
 	enable_IR_x2apic();
 #ifdef CONFIG_X86_64
 	default_setup_apic_routing();
@@ -1131,6 +1140,11 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 {
 	pr_debug("Boot done.\n");
 
+#ifdef CONFIG_XEN
+	if (xen_hybrid_evtchn_enabled())
+		return;
+#endif
+
 	impress_friends();
 #ifdef CONFIG_X86_IO_APIC
 	setup_ioapic_dest();
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 18aba22..f515584 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -54,6 +54,10 @@
 #include <asm/reboot.h>
 
 #include <xen/hvm.h>
+#include <xen/events.h>
+#include <asm/acpi.h>
+#include <asm/irq_vectors.h>
+#include <asm/irq.h>
 
 #include "xen-ops.h"
 #include "mmu.h"
@@ -1055,6 +1059,8 @@ static void __init xen_hybrid_banner(void)
 
 	if (xen_hybrid_timer_enabled())
 		printk(KERN_INFO "Hybrid feature: PV Timer enabled\n");
+	if (xen_hybrid_evtchn_enabled())
+		printk(KERN_INFO "Hybrid feature: Event channel enabled\n");
 }
 
 static int xen_para_available(void)
@@ -1102,6 +1108,10 @@ static int init_hybrid_info(void)
 		xen_hybrid_status |= XEN_HYBRID_TIMER_ENABLED;
 		flags |= HVM_HYBRID_TIMER;
 	}
+	if (edx & XEN_CPUID_FEAT2_HYBRID_EVTCHN) {
+		xen_hybrid_status |= XEN_HYBRID_EVTCHN_ENABLED;
+		flags |= HVM_HYBRID_EVTCHN;
+	}
 
 	/* We only support 1 page of hypercall for now */
 	if (pages != 1)
@@ -1144,9 +1154,27 @@ static int __init init_shared_info(void)
 	return 0;
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
+void do_hybrid_intr(void)
+{
+	per_cpu(irq_count, smp_processor_id())++;
+	xen_evtchn_do_upcall(get_irq_regs());
+	per_cpu(irq_count, smp_processor_id())--;
+}
+
 void __init xen_start_hybrid(void)
 {
 	int r;
+	uint64_t callback_via;
 
 	if (!xen_para_available())
 		return;
@@ -1163,5 +1191,26 @@ void __init xen_start_hybrid(void)
 		pv_time_ops = xen_time_ops;
 		pv_apic_ops = xen_apic_ops;
 	}
+
+	if (xen_hybrid_evtchn_enabled()) {
+		pv_apic_ops = xen_apic_ops;
+#ifdef CONFIG_X86_LOCAL_APIC
+		/*
+		 * set up the basic apic ops.
+		 */
+		set_xen_basic_apic_ops();
+#endif
+
+		callback_via = HVM_CALLBACK_VECTOR(GENERIC_INTERRUPT_VECTOR);
+		set_callback_via(callback_via);
+
+		generic_interrupt_extension = do_hybrid_intr;
+
+		disable_acpi();
+		disable_apic = 1;
+
+		machine_ops = xen_machine_ops;
+		smp_ops.smp_send_stop = paravirt_nop;
+	}
 }
 
diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
index 52885c1..edca1c4 100644
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -66,6 +66,9 @@ PV_CALLEE_SAVE_REGS_THUNK(xen_restore_fl);
 
 static void xen_irq_disable(void)
 {
+	if (xen_hybrid_evtchn_enabled())
+		asm volatile("cli" : : : "memory");
+
 	/* There's a one instruction preempt window here.  We need to
 	   make sure we're don't switch CPUs between getting the vcpu
 	   pointer and updating the mask. */
@@ -79,6 +82,9 @@ static void xen_irq_enable(void)
 {
 	struct vcpu_info *vcpu;
 
+	if (xen_hybrid_evtchn_enabled())
+		asm volatile("sti" : : : "memory");
+
 	/* We don't need to worry about being preempted here, since
 	   either a) interrupts are disabled, so no preemption, or b)
 	   the caller is confused and is trying to re-enable interrupts
@@ -137,6 +143,11 @@ void __init xen_init_irq_ops()
 
 void __init xen_hybrid_init_irq_ops(void)
 {
-	pv_irq_ops.safe_halt = xen_safe_halt;
-	pv_irq_ops.halt = xen_halt;
+	if (!xen_hybrid_evtchn_enabled()) {
+		pv_irq_ops.safe_halt = xen_safe_halt;
+		pv_irq_ops.halt = xen_halt;
+	} else {
+		pv_irq_ops = xen_irq_ops;
+		pv_irq_ops.adjust_exception_frame = paravirt_nop;
+	}
 }
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 30963af..4973b70 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -40,6 +40,8 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/event_channel.h>
 
+#include <asm/desc.h>
+
 /*
  * This lock protects updates to the following mapping and reference-count
  * arrays. The lock does not need to be acquired to read the mapping tables.
@@ -931,4 +933,49 @@ void __init xen_init_IRQ(void)
 		mask_evtchn(i);
 
 	irq_ctx_init(smp_processor_id());
+
+	if (!xen_hybrid_evtchn_enabled())
+		return;
+
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
+	/* generic IPI for platform specific use, now used for hybrid */
+	alloc_intr_gate(GENERIC_INTERRUPT_VECTOR, generic_interrupt);
 }
diff --git a/include/xen/events.h b/include/xen/events.h
index 0d5f1ad..a21c68f 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -53,4 +53,5 @@ bool xen_test_irq_pending(int irq);
    irq will be disabled so it won't deliver an interrupt. */
 void xen_poll_irq(int irq);
 
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab0CJPnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:43:10 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:27705 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434Ab0CJPnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:43:05 -0500
X-IronPort-AV: E=Sophos;i="4.49,614,1262563200"; 
   d="scan'208";a="9880207"
Date: Wed, 10 Mar 2010 15:47:11 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 4 of 5] evtchn delivery on HVM
Message-ID: <alpine.DEB.2.00.1003101506570.28412@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch sets the callback to receive evtchns from Xen, using the
callback vector delivery mechanism.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Sheng Yang <sheng@linux.intel.com>

---

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 6292cc6..72e8546 100644
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
@@ -1267,9 +1270,25 @@ static void __init init_pv_clocksource(void)
 	xen_register_clocksource();
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
+	xen_evtchn_do_upcall(get_irq_regs());
+}
+
 void __init xen_guest_init(void)
 {
 	int r;
+	uint64_t callback_via;
 
 	r = init_hvm_pv_info();
 	if (r < 0)
@@ -1277,5 +1296,14 @@ void __init xen_guest_init(void)
 
 	init_shared_info();
 	init_pv_clocksource();
+
+	callback_via = HVM_CALLBACK_VECTOR(GENERIC_INTERRUPT_VECTOR);
+	set_callback_via(callback_via);
+	generic_interrupt_extension = do_hvm_pv_evtchn_intr;
+
+	have_vcpu_info_placement = 0;
+	x86_init.irqs.intr_init = xen_init_IRQ;
+	pv_time_ops = xen_time_ops;
+	machine_ops = xen_machine_ops;
 }
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 2f57276..ef25a53 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -621,9 +621,10 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 	struct vcpu_info *vcpu_info = __get_cpu_var(xen_vcpu);
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
 
@@ -659,8 +660,10 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
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
@@ -939,5 +942,8 @@ void __init xen_init_IRQ(void)
 	for (i = 0; i < NR_EVENT_CHANNELS; i++)
 		mask_evtchn(i);
 
-	irq_ctx_init(smp_processor_id());
+	if (xen_hvm_domain())
+		native_init_IRQ();
+	else
+		irq_ctx_init(smp_processor_id());
 }
diff --git a/include/xen/events.h b/include/xen/events.h
index e68d59a..b0d3b3c 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -56,4 +56,6 @@ void xen_poll_irq(int irq);
 /* Determine the IRQ which is bound to an event channel */
 unsigned irq_from_evtchn(unsigned int evtchn);
 
+void xen_evtchn_do_upcall(struct pt_regs *regs);
+
 #endif	/* _XEN_EVENTS_H */
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

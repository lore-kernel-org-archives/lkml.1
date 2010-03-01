Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167Ab0CAJhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:37:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:2366 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab0CAJhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:37:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,559,1262592000"; 
   d="scan'208";a="600065915"
From: Sheng Yang <sheng@linux.intel.com>
To: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 1/7] xen: add support for hvm_op
Date: Mon,  1 Mar 2010 17:38:29 +0800
Message-Id: <1267436315-24486-2-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267436315-24486-1-git-send-email-sheng@linux.intel.com>
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Add support for hvm_op hypercall.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/include/asm/xen/hypercall.h |    6 ++
 include/xen/hvm.h                    |   23 +++++++
 include/xen/interface/hvm/hvm_op.h   |   72 ++++++++++++++++++++++
 include/xen/interface/hvm/params.h   |  111 ++++++++++++++++++++++++++++++++++
 4 files changed, 212 insertions(+), 0 deletions(-)
 create mode 100644 include/xen/hvm.h
 create mode 100644 include/xen/interface/hvm/hvm_op.h
 create mode 100644 include/xen/interface/hvm/params.h

diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/xen/hypercall.h
index 9c371e4..47c2ebb 100644
--- a/arch/x86/include/asm/xen/hypercall.h
+++ b/arch/x86/include/asm/xen/hypercall.h
@@ -417,6 +417,12 @@ HYPERVISOR_nmi_op(unsigned long op, unsigned long arg)
 	return _hypercall2(int, nmi_op, op, arg);
 }
 
+static inline unsigned long __must_check
+HYPERVISOR_hvm_op(int op, void *arg)
+{
+	return _hypercall2(unsigned long, hvm_op, op, arg);
+}
+
 static inline void
 MULTI_fpu_taskswitch(struct multicall_entry *mcl, int set)
 {
diff --git a/include/xen/hvm.h b/include/xen/hvm.h
new file mode 100644
index 0000000..4ea8887
--- /dev/null
+++ b/include/xen/hvm.h
@@ -0,0 +1,23 @@
+/* Simple wrappers around HVM functions */
+#ifndef XEN_HVM_H__
+#define XEN_HVM_H__
+
+#include <xen/interface/hvm/params.h>
+
+static inline unsigned long hvm_get_parameter(int idx)
+{
+	struct xen_hvm_param xhv;
+	int r;
+
+	xhv.domid = DOMID_SELF;
+	xhv.index = idx;
+	r = HYPERVISOR_hvm_op(HVMOP_get_param, &xhv);
+	if (r < 0) {
+		printk(KERN_ERR "cannot get hvm parameter %d: %d.\n",
+		       idx, r);
+		return 0;
+	}
+	return xhv.value;
+}
+
+#endif /* XEN_HVM_H__ */
diff --git a/include/xen/interface/hvm/hvm_op.h b/include/xen/interface/hvm/hvm_op.h
new file mode 100644
index 0000000..7c74ba4
--- /dev/null
+++ b/include/xen/interface/hvm/hvm_op.h
@@ -0,0 +1,72 @@
+/*
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef __XEN_PUBLIC_HVM_HVM_OP_H__
+#define __XEN_PUBLIC_HVM_HVM_OP_H__
+
+/* Get/set subcommands: extra argument == pointer to xen_hvm_param struct. */
+#define HVMOP_set_param           0
+#define HVMOP_get_param           1
+struct xen_hvm_param {
+    domid_t  domid;    /* IN */
+    uint32_t index;    /* IN */
+    uint64_t value;    /* IN/OUT */
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_hvm_param);
+
+/* Set the logical level of one of a domain's PCI INTx wires. */
+#define HVMOP_set_pci_intx_level  2
+struct xen_hvm_set_pci_intx_level {
+    /* Domain to be updated. */
+    domid_t  domid;
+    /* PCI INTx identification in PCI topology (domain:bus:device:intx). */
+    uint8_t  domain, bus, device, intx;
+    /* Assertion level (0 = unasserted, 1 = asserted). */
+    uint8_t  level;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_hvm_set_pci_intx_level);
+
+/* Set the logical level of one of a domain's ISA IRQ wires. */
+#define HVMOP_set_isa_irq_level   3
+struct xen_hvm_set_isa_irq_level {
+    /* Domain to be updated. */
+    domid_t  domid;
+    /* ISA device identification, by ISA IRQ (0-15). */
+    uint8_t  isa_irq;
+    /* Assertion level (0 = unasserted, 1 = asserted). */
+    uint8_t  level;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_hvm_set_isa_irq_level);
+
+#define HVMOP_set_pci_link_route  4
+struct xen_hvm_set_pci_link_route {
+    /* Domain to be updated. */
+    domid_t  domid;
+    /* PCI link identifier (0-3). */
+    uint8_t  link;
+    /* ISA IRQ (1-15), or 0 (disable link). */
+    uint8_t  isa_irq;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_hvm_set_pci_link_route);
+
+/* Flushes all VCPU TLBs: @arg must be NULL. */
+#define HVMOP_flush_tlbs          5
+
+#endif /* __XEN_PUBLIC_HVM_HVM_OP_H__ */
diff --git a/include/xen/interface/hvm/params.h b/include/xen/interface/hvm/params.h
new file mode 100644
index 0000000..15d828f
--- /dev/null
+++ b/include/xen/interface/hvm/params.h
@@ -0,0 +1,111 @@
+/*
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef __XEN_PUBLIC_HVM_PARAMS_H__
+#define __XEN_PUBLIC_HVM_PARAMS_H__
+
+#include "hvm_op.h"
+
+/*
+ * Parameter space for HVMOP_{set,get}_param.
+ */
+
+/*
+ * How should CPU0 event-channel notifications be delivered?
+ * val[63:56] == 0: val[55:0] is a delivery GSI (Global System Interrupt).
+ * val[63:56] == 1: val[55:0] is a delivery PCI INTx line, as follows:
+ *                  Domain = val[47:32], Bus  = val[31:16],
+ *                  DevFn  = val[15: 8], IntX = val[ 1: 0]
+ * If val == 0 then CPU0 event-channel notifications are not delivered.
+ */
+#define HVM_PARAM_CALLBACK_IRQ 0
+
+/*
+ * These are not used by Xen. They are here for convenience of HVM-guest
+ * xenbus implementations.
+ */
+#define HVM_PARAM_STORE_PFN    1
+#define HVM_PARAM_STORE_EVTCHN 2
+
+#define HVM_PARAM_PAE_ENABLED  4
+
+#define HVM_PARAM_IOREQ_PFN    5
+
+#define HVM_PARAM_BUFIOREQ_PFN 6
+
+#ifdef __ia64__
+
+#define HVM_PARAM_NVRAM_FD     7
+#define HVM_PARAM_VHPT_SIZE    8
+#define HVM_PARAM_BUFPIOREQ_PFN	9
+
+#elif defined(__i386__) || defined(__x86_64__)
+
+/* Expose Viridian interfaces to this HVM guest? */
+#define HVM_PARAM_VIRIDIAN     9
+
+#endif
+
+/*
+ * Set mode for virtual timers (currently x86 only):
+ *  delay_for_missed_ticks (default):
+ *   Do not advance a vcpu's time beyond the correct delivery time for
+ *   interrupts that have been missed due to preemption. Deliver missed
+ *   interrupts when the vcpu is rescheduled and advance the vcpu's virtual
+ *   time stepwise for each one.
+ *  no_delay_for_missed_ticks:
+ *   As above, missed interrupts are delivered, but guest time always tracks
+ *   wallclock (i.e., real) time while doing so.
+ *  no_missed_ticks_pending:
+ *   No missed interrupts are held pending. Instead, to ensure ticks are
+ *   delivered at some non-zero rate, if we detect missed ticks then the
+ *   internal tick alarm is not disabled if the VCPU is preempted during the
+ *   next tick period.
+ *  one_missed_tick_pending:
+ *   Missed interrupts are collapsed together and delivered as one 'late tick'.
+ *   Guest time always tracks wallclock (i.e., real) time.
+ */
+#define HVM_PARAM_TIMER_MODE   10
+#define HVMPTM_delay_for_missed_ticks    0
+#define HVMPTM_no_delay_for_missed_ticks 1
+#define HVMPTM_no_missed_ticks_pending   2
+#define HVMPTM_one_missed_tick_pending   3
+
+/* Boolean: Enable virtual HPET (high-precision event timer)? (x86-only) */
+#define HVM_PARAM_HPET_ENABLED 11
+
+/* Identity-map page directory used by Intel EPT when CR0.PG=0. */
+#define HVM_PARAM_IDENT_PT     12
+
+/* Device Model domain, defaults to 0. */
+#define HVM_PARAM_DM_DOMAIN    13
+
+/* ACPI S state: currently support S0 and S3 on x86. */
+#define HVM_PARAM_ACPI_S_STATE 14
+
+/* TSS used on Intel when CR0.PE=0. */
+#define HVM_PARAM_VM86_TSS     15
+
+/* Boolean: Enable aligning all periodic vpts to reduce interrupts */
+#define HVM_PARAM_VPT_ALIGN    16
+
+#define HVM_NR_PARAMS          17
+
+#endif /* __XEN_PUBLIC_HVM_PARAMS_H__ */
-- 
1.5.4.5


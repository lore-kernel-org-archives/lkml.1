Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbZIPIn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbZIPIn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757682AbZIPIn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:43:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:54298 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755342AbZIPInU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:43:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,396,1249282800"; 
   d="scan'208";a="551023851"
From: Sheng Yang <sheng@linux.intel.com>
To: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jun Nakajima <jun.nakajima@intel.com>, Eddie Dong <eddie.dong@intel.com>,
       linux-kernel@vger.kernel.org, xen-devel <xen-devel@lists.xensource.com>,
       Sheng Yang <sheng@linux.intel.com>
Subject: [RFC][PATCH 03/10] xen/hybrid: Xen Hybrid Extension initialization
Date: Wed, 16 Sep 2009 16:42:24 +0800
Message-Id: <1253090551-7969-4-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1253090551-7969-1-git-send-email-sheng@linux.intel.com>
References: <1253090551-7969-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we know that PV guest have performance issue with x86_64 that guest kernel
and userspace resistent in the same ring, then the necessary TLB flushes when
switch between guest userspace and guest kernel cause overhead, and much more
syscall overhead is also introduced. The Hybrid Extension estimated these
overhead by putting guest kernel back in (non-root) ring0 then achieve the
better performance than PV guest.

The Hybrid Extension is started from real mode like HVM guest, but also with a
component based PV feature selection(e.g. PV halt, PV timer, event channel,
then PV drivers). So guest with Hybrid extension feature can takes the
advantages of both H/W virtualization and Para-Virtualization.

This patch introduced the Hybrid Extension guest initialization.

Guest would detect Hybrid capability using CPUID 0x40000002.edx, then call
HVMOP_enable_hybrid hypercall to enable hybrid support in hypervisor.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
---
 arch/x86/include/asm/xen/cpuid.h      |    7 +++
 arch/x86/include/asm/xen/hypervisor.h |   12 +++++
 arch/x86/kernel/paravirt.c            |   13 +++++-
 arch/x86/xen/enlighten.c              |   72 +++++++++++++++++++++++++++++++++
 include/xen/interface/hvm/hvm_op.h    |    8 ++++
 5 files changed, 111 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/xen/cpuid.h b/arch/x86/include/asm/xen/cpuid.h
index 8787f03..6fa82c0 100644
--- a/arch/x86/include/asm/xen/cpuid.h
+++ b/arch/x86/include/asm/xen/cpuid.h
@@ -65,4 +65,11 @@
 #define _XEN_CPUID_FEAT1_MMU_PT_UPDATE_PRESERVE_AD 0
 #define XEN_CPUID_FEAT1_MMU_PT_UPDATE_PRESERVE_AD  (1u<<0)
 
+#define _XEN_CPUID_FEAT2_HYBRID 0
+#define XEN_CPUID_FEAT2_HYBRID (1u<<0)
+#define _XEN_CPUID_FEAT2_HYBRID_TIMER 1
+#define XEN_CPUID_FEAT2_HYBRID_TIMER (1u<<1)
+#define _XEN_CPUID_FEAT2_HYBRID_EVTCHN 2
+#define XEN_CPUID_FEAT2_HYBRID_EVTCHN (1u<<2)
+
 #endif /* __XEN_PUBLIC_ARCH_X86_CPUID_H__ */
diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
index d5b7e90..7eee836 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -45,6 +45,7 @@ enum xen_domain_type {
 
 #ifdef CONFIG_XEN
 extern enum xen_domain_type xen_domain_type;
+extern void xen_start_hybrid(void);
 #else
 #define xen_domain_type		XEN_NATIVE
 #endif
@@ -55,6 +56,17 @@ extern enum xen_domain_type xen_domain_type;
 #define xen_hvm_domain()	(xen_domain() &&			\
 				 xen_domain_type == XEN_HVM_DOMAIN)
 
+#define XEN_HYBRID_ENABLED	    (1u << 0)
+#define XEN_HYBRID_TIMER_ENABLED    (1u << 1)
+#define XEN_HYBRID_EVTCHN_ENABLED   (1u << 2)
+extern u32 xen_hybrid_status;
+
+#define xen_hybrid_enabled() (xen_hybrid_status & XEN_HYBRID_ENABLED)
+#define xen_hybrid_timer_enabled() \
+	(xen_hybrid_status & XEN_HYBRID_TIMER_ENABLED)
+#define xen_hybrid_evtchn_enabled() \
+	(xen_hybrid_status & XEN_HYBRID_EVTCHN_ENABLED)
+
 #ifdef CONFIG_XEN_DOM0
 #include <xen/interface/xen.h>
 
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 9faf43b..323c98a 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -38,6 +38,10 @@
 #include <asm/tlbflush.h>
 #include <asm/timer.h>
 
+#ifdef CONFIG_XEN
+#include <asm/xen/hypervisor.h>
+#endif
+
 /* nop stub */
 void _paravirt_nop(void)
 {
@@ -313,6 +317,13 @@ void arch_flush_lazy_cpu_mode(void)
 	preempt_enable();
 }
 
+void hybrid_arch_setup(void)
+{
+#if defined(CONFIG_X86_64) && defined(CONFIG_XEN)
+	xen_start_hybrid();
+#endif
+}
+
 struct pv_info pv_info = {
 	.name = "bare hardware",
 	.paravirt_enabled = 0,
@@ -323,7 +334,7 @@ struct pv_info pv_info = {
 struct pv_init_ops pv_init_ops = {
 	.patch = native_patch,
 	.banner = default_banner,
-	.arch_setup = paravirt_nop,
+	.arch_setup = hybrid_arch_setup,
 	.memory_setup = machine_specific_memory_setup,
 };
 
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index f09e8c3..b93604e 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -31,6 +31,7 @@
 #include <xen/interface/version.h>
 #include <xen/interface/physdev.h>
 #include <xen/interface/vcpu.h>
+#include <xen/interface/hvm/hvm_op.h>
 #include <xen/features.h>
 #include <xen/page.h>
 #include <xen/hvc-console.h>
@@ -40,6 +41,7 @@
 #include <asm/page.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
+#include <asm/xen/cpuid.h>
 #include <asm/fixmap.h>
 #include <asm/processor.h>
 #include <asm/proto.h>
@@ -1037,3 +1039,73 @@ asmlinkage void __init xen_start_kernel(void)
 	x86_64_start_reservations((char *)__pa_symbol(&boot_params));
 #endif
 }
+
+static int xen_para_available(void)
+{
+	uint32_t eax, ebx, ecx, edx;
+	cpuid(XEN_CPUID_LEAF(0), &eax, &ebx, &ecx, &edx);
+
+	if (ebx == XEN_CPUID_SIGNATURE_EBX &&
+			ecx == XEN_CPUID_SIGNATURE_ECX &&
+			edx == XEN_CPUID_SIGNATURE_EDX &&
+			((eax - XEN_CPUID_LEAF(0)) >= 2))
+		return 1;
+
+	return 0;
+}
+
+u32 xen_hybrid_status;
+EXPORT_SYMBOL_GPL(xen_hybrid_status);
+
+static int enable_hybrid(u64 flags)
+{
+	struct xen_hvm_hybrid_type a;
+
+	a.domid = DOMID_SELF;
+	a.flags = flags;
+	return HYPERVISOR_hvm_op(HVMOP_enable_hybrid, &a);
+}
+
+static int init_hybrid_info(void)
+{
+	uint32_t ecx, edx, pages, msr;
+	u64 pfn, flags = 0;
+
+	if (!xen_para_available())
+		return -EINVAL;
+
+	cpuid(XEN_CPUID_LEAF(2), &pages, &msr, &ecx, &edx);
+
+	/* Check if hybrid mode is supported */
+	if (!(edx & XEN_CPUID_FEAT2_HYBRID))
+		return -ENODEV;
+
+	xen_hybrid_status = XEN_HYBRID_ENABLED;
+
+	/* We only support 1 page of hypercall for now */
+	if (pages != 1)
+		return -ENOMEM;
+
+	pfn = __pa(hypercall_page);
+	wrmsrl(msr, pfn);
+
+	xen_setup_features();
+
+	if (enable_hybrid(flags))
+		return -EINVAL;
+
+	return 0;
+}
+
+void __init xen_start_hybrid(void)
+{
+	int r;
+
+	if (!xen_para_available())
+		return;
+
+	r = init_hybrid_info();
+	if (r < 0)
+		return;
+}
+
diff --git a/include/xen/interface/hvm/hvm_op.h b/include/xen/interface/hvm/hvm_op.h
index 7c74ba4..936a391 100644
--- a/include/xen/interface/hvm/hvm_op.h
+++ b/include/xen/interface/hvm/hvm_op.h
@@ -69,4 +69,12 @@ DEFINE_GUEST_HANDLE_STRUCT(xen_hvm_set_pci_link_route);
 /* Flushes all VCPU TLBs: @arg must be NULL. */
 #define HVMOP_flush_tlbs          5
 
+#define HVMOP_enable_hybrid	  9
+struct xen_hvm_hybrid_type {
+	domid_t domid;
+	uint64_t flags;
+#define HVM_HYBRID_TIMER (1ull<<1)
+#define HVM_HYBRID_EVTCHN (1ull<<2)
+};
+
 #endif /* __XEN_PUBLIC_HVM_HVM_OP_H__ */
-- 
1.5.4.5


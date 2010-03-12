Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab0CLC4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 21:56:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:9241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab0CLCz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 21:55:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,624,1262592000"; 
   d="scan'208";a="603635511"
From: Sheng Yang <sheng@linux.intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>, linux-kernel@vger.kernel.org,
       Sheng Yang <sheng@linux.intel.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>
Subject: [PATCH][v9 4/6] xen/hvm: Xen PV extension of HVM initialization
Date: Fri, 12 Mar 2010 10:57:25 +0800
Message-Id: <1268362647-5317-5-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268362647-5317-1-git-send-email-sheng@linux.intel.com>
References: <1268362647-5317-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PV extended HVM(once known as Hybrid) is started from real mode like
HVM guest, but also with a component based PV feature selection(e.g. PV halt,
PV timer, event channel, then PV drivers). So guest can takes the advantages
of both H/W virtualization and Para-Virtualization.

This patch introduced the PV extension of HVM guest initialization.

Guest would detect the capability using CPUID 0x40000002.edx, then call
HVMOP_enable_pv hypercall to enable pv support in hypervisor.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
---
 arch/x86/include/asm/xen/cpuid.h      |    5 +
 arch/x86/include/asm/xen/hypervisor.h |   12 +++
 arch/x86/xen/Kconfig                  |    4 +
 arch/x86/xen/Makefile                 |    1 +
 arch/x86/xen/hvmpv.c                  |  135 +++++++++++++++++++++++++++++++++
 include/xen/interface/hvm/hvm_op.h    |    8 ++
 6 files changed, 165 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/xen/hvmpv.c

diff --git a/arch/x86/include/asm/xen/cpuid.h b/arch/x86/include/asm/xen/cpuid.h
index 8787f03..b3a0b3a 100644
--- a/arch/x86/include/asm/xen/cpuid.h
+++ b/arch/x86/include/asm/xen/cpuid.h
@@ -65,4 +65,9 @@
 #define _XEN_CPUID_FEAT1_MMU_PT_UPDATE_PRESERVE_AD 0
 #define XEN_CPUID_FEAT1_MMU_PT_UPDATE_PRESERVE_AD  (1u<<0)
 
+#define _XEN_CPUID_FEAT2_HVM_PV 0
+#define XEN_CPUID_FEAT2_HVM_PV (1u<<0)
+#define _XEN_CPUID_FEAT2_HVM_PV_CLOCK 1
+#define XEN_CPUID_FEAT2_HVM_PV_CLOCK (1u<<1)
+
 #endif /* __XEN_PUBLIC_ARCH_X86_CPUID_H__ */
diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
index d5b7e90..7569f64 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -55,6 +55,18 @@ extern enum xen_domain_type xen_domain_type;
 #define xen_hvm_domain()	(xen_domain() &&			\
 				 xen_domain_type == XEN_HVM_DOMAIN)
 
+#ifdef CONFIG_XEN_HVM_PV
+
+#define XEN_HVM_PV_CLOCK_ENABLED   (1u << 0)
+#define XEN_HVM_PV_EVTCHN_ENABLED   (1u << 1)
+extern u32 xen_hvm_pv_features;
+
+#define xen_hvm_pv_clock_enabled() \
+		(xen_hvm_pv_features & XEN_HVM_PV_CLOCK_ENABLED)
+#else
+#define xen_hvm_pv_clock_enabled() 0
+#endif /* CONFIG_XEN_HVM_PV */
+
 #ifdef CONFIG_XEN_DOM0
 #include <xen/interface/xen.h>
 
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index b83e119..74fc233 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -36,3 +36,7 @@ config XEN_DEBUG_FS
 	help
 	  Enable statistics output and various tuning options in debugfs.
 	  Enabling this option may incur a significant performance overhead.
+
+config XEN_HVM_PV
+	def_bool y
+	depends on XEN && X86_64
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 3bb4fc2..73bd5db 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -17,4 +17,5 @@ obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
+obj-$(CONFIG_XEN_HVM_PV)	+= hvmpv.o
 
diff --git a/arch/x86/xen/hvmpv.c b/arch/x86/xen/hvmpv.c
new file mode 100644
index 0000000..a24a1e9
--- /dev/null
+++ b/arch/x86/xen/hvmpv.c
@@ -0,0 +1,135 @@
+/*
+ * PV extension of HVM implementation.
+ *
+ * Sheng Yang <sheng@linux.intel.com>, Intel Corporation, 2010
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/percpu.h>
+#include <linux/module.h>
+
+#include <xen/features.h>
+#include <xen/events.h>
+#include <xen/hvm.h>
+#include <xen/interface/xen.h>
+#include <xen/interface/version.h>
+#include <xen/interface/memory.h>
+
+#include <asm/xen/cpuid.h>
+#include <asm/xen/hypercall.h>
+#include <asm/xen/hypervisor.h>
+
+#include "xen-ops.h"
+
+u32 xen_hvm_pv_features;
+EXPORT_SYMBOL_GPL(xen_hvm_pv_features);
+
+static const struct pv_info xen_hvm_pv_info __initdata = {
+	.paravirt_enabled = 1,
+	.shared_kernel_pmd = 0,
+	.kernel_rpl = 0,
+	.name = "Xen",
+};
+
+static void __init xen_hvm_pv_banner(void)
+{
+	unsigned version = HYPERVISOR_xen_version(XENVER_version, NULL);
+	struct xen_extraversion extra;
+	HYPERVISOR_xen_version(XENVER_extraversion, &extra);
+
+	printk(KERN_INFO "Booting PV extended HVM kernel on %s\n",
+		pv_info.name);
+	printk(KERN_INFO "Xen version: %d.%d%s\n",
+		version >> 16, version & 0xffff, extra.extraversion);
+}
+
+static int __init xen_para_available(void)
+{
+	uint32_t eax, ebx, ecx, edx;
+	cpuid(XEN_CPUID_LEAF(0), &eax, &ebx, &ecx, &edx);
+
+	if (ebx == XEN_CPUID_SIGNATURE_EBX &&
+	    ecx == XEN_CPUID_SIGNATURE_ECX &&
+	    edx == XEN_CPUID_SIGNATURE_EDX &&
+	    ((eax - XEN_CPUID_LEAF(0)) >= 2))
+		return 1;
+
+	return 0;
+}
+
+static int __init enable_hvm_pv(u64 flags)
+{
+	struct xen_hvm_pv_type a;
+
+	a.flags = flags;
+	return HYPERVISOR_hvm_op(HVMOP_enable_pv, &a);
+}
+
+static int __init init_hvm_pv_info(void)
+{
+	uint32_t ecx, edx, pages, msr;
+	u64 pfn;
+
+	if (!xen_para_available())
+		return -EINVAL;
+
+	cpuid(XEN_CPUID_LEAF(2), &pages, &msr, &ecx, &edx);
+
+	/* Check if hvm_pv mode is supported */
+	if (!(edx & XEN_CPUID_FEAT2_HVM_PV))
+		return -ENODEV;
+
+	if (pages < 1)
+		return -ENODEV;
+
+	pfn = __pa(hypercall_page);
+	if (wrmsr_safe(msr, (u32)pfn, ((u64)pfn) >> 32))
+		return -ENODEV;
+
+	return 0;
+}
+
+static struct shared_info shared_info_page __page_aligned_bss;
+
+static int __init init_shared_info(void)
+{
+	struct xen_add_to_physmap xatp;
+
+	xatp.domid = DOMID_SELF;
+	xatp.idx = 0;
+	xatp.space = XENMAPSPACE_shared_info;
+	xatp.gpfn = __pa(&shared_info_page) >> PAGE_SHIFT;
+	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
+		return -EINVAL;
+
+	HYPERVISOR_shared_info = (struct shared_info *)&shared_info_page;
+
+	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
+
+	return 0;
+}
+
+void __init xen_guest_init(void)
+{
+	int r;
+
+	/* Ensure the we won't confused with others */
+	if (xen_domain())
+		return;
+
+	r = init_hvm_pv_info();
+	if (r < 0)
+		return;
+
+	r = init_shared_info();
+	if (r < 0)
+		return;
+
+	xen_setup_features();
+
+	x86_init.oem.banner = xen_hvm_pv_banner;
+	pv_info = xen_hvm_pv_info;
+
+	xen_domain_type = XEN_HVM_DOMAIN;
+}
diff --git a/include/xen/interface/hvm/hvm_op.h b/include/xen/interface/hvm/hvm_op.h
index 7c74ba4..d229b50 100644
--- a/include/xen/interface/hvm/hvm_op.h
+++ b/include/xen/interface/hvm/hvm_op.h
@@ -69,4 +69,12 @@ DEFINE_GUEST_HANDLE_STRUCT(xen_hvm_set_pci_link_route);
 /* Flushes all VCPU TLBs: @arg must be NULL. */
 #define HVMOP_flush_tlbs          5
 
+/* Enable PV extended HVM features. Should called by BSP */
+#define HVMOP_enable_pv 9
+struct xen_hvm_pv_type {
+	/* The features want to be enabled */
+	uint32_t flags;
+#define HVM_PV_CLOCK  (1ull<<0)
+};
+
 #endif /* __XEN_PUBLIC_HVM_HVM_OP_H__ */
-- 
1.7.0.1


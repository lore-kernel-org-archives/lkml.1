Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab0CIQB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:01:56 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:9932 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab0CIQBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:01:54 -0500
X-IronPort-AV: E=Sophos;i="4.49,608,1262563200"; 
   d="scan'208";a="9859515"
Date: Tue, 9 Mar 2010 16:05:41 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2 of 5] Linux pvops: early PV on HVM
Message-ID: <alpine.DEB.2.00.1003091543050.26495@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch is derived from an earler version of the patch named "Xen PV
extension of HVM initialization" in Shen's patch series.
This patch:

- adds a xen_guest_init hook in setup.c right after kvm_guest_init;

- initializes basic pv on hvm features in xen_guest_init; 

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>

---

diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
index d5b7e90..bbd3f65 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -33,6 +33,7 @@
 #ifndef _ASM_X86_XEN_HYPERVISOR_H
 #define _ASM_X86_XEN_HYPERVISOR_H
 
+#ifdef CONFIG_XEN
 /* arch/i386/kernel/setup.c */
 extern struct shared_info *HYPERVISOR_shared_info;
 extern struct start_info *xen_start_info;
@@ -43,10 +44,11 @@ enum xen_domain_type {
 	XEN_HVM_DOMAIN,		/* running in a Xen hvm domain */
 };
 
-#ifdef CONFIG_XEN
 extern enum xen_domain_type xen_domain_type;
+extern void xen_guest_init(void);
 #else
 #define xen_domain_type		XEN_NATIVE
+#define xen_guest_init() do { } while (0)
 #endif
 
 #define xen_domain()		(xen_domain_type != XEN_NATIVE)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 86bef0f..2e23335 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -113,6 +113,8 @@
 #define ARCH_SETUP
 #endif
 
+#include <asm/xen/hypervisor.h>
+
 /*
  * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
  * The direct mapping extends to max_pfn_mapped, so that we can directly access
@@ -1015,6 +1017,7 @@ void __init setup_arch(char **cmdline_p)
 	probe_nr_irqs_gsi();
 
 	kvm_guest_init();
+	xen_guest_init();
 
 	e820_reserve_resources();
 	e820_mark_nosave_regions(max_low_pfn);
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 7a62c2b..88d9dc7 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -32,6 +32,8 @@
 #include <xen/interface/version.h>
 #include <xen/interface/physdev.h>
 #include <xen/interface/vcpu.h>
+#include <xen/interface/memory.h>
+#include <xen/interface/hvm/hvm_op.h>
 #include <xen/features.h>
 #include <xen/page.h>
 #include <xen/hvc-console.h>
@@ -1248,3 +1250,86 @@ asmlinkage void __init xen_start_kernel(void)
 	x86_64_start_reservations((char *)__pa_symbol(&boot_params));
 #endif
 }
+
+static uint32_t xen_cpuid_base(void)
+{
+	uint32_t base, eax, ebx, ecx, edx;
+	char signature[13];
+
+	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
+		cpuid(base, &eax, &ebx, &ecx, &edx);
+		*(uint32_t*)(signature + 0) = ebx;
+		*(uint32_t*)(signature + 4) = ecx;
+		*(uint32_t*)(signature + 8) = edx;
+		signature[12] = 0;
+
+		if (!strcmp("XenVMMXenVMM", signature) && ((eax - base) >= 2))
+			return base;
+	}
+
+	return 0;
+}
+
+static int init_hvm_pv_info(void)
+{
+	uint32_t eax, ebx, ecx, edx, pages, msr, base;
+	u64 pfn;
+
+	base = xen_cpuid_base();
+	if (!base)
+		return -EINVAL;
+
+	cpuid(base + 1, &eax, &ebx, &ecx, &edx);
+
+	printk(KERN_INFO "Xen version %d.%d.\n", eax >> 16, eax & 0xffff);
+
+	cpuid(base + 2, &pages, &msr, &ecx, &edx);
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
+	pv_info = xen_info;
+	pv_info.kernel_rpl = 0;
+
+	xen_domain_type = XEN_HVM_DOMAIN;
+
+	return 0;
+}
+
+static void __init init_shared_info(void)
+{
+	struct xen_add_to_physmap xatp;
+	struct shared_info *shared_info_page;
+
+	shared_info_page = (struct shared_info *) alloc_bootmem_pages(PAGE_SIZE);
+	xatp.domid = DOMID_SELF;
+	xatp.idx = 0;
+	xatp.space = XENMAPSPACE_shared_info;
+	xatp.gpfn = __pa(shared_info_page) >> PAGE_SHIFT;
+	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
+		BUG();
+
+	HYPERVISOR_shared_info = (struct shared_info *)shared_info_page;
+
+	/* Don't do the full vcpu_info placement stuff until we have a
+	   possible map and a non-dummy shared_info. */
+	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
+}
+
+void __init xen_guest_init(void)
+{
+	int r;
+
+	r = init_hvm_pv_info();
+	if (r < 0)
+		return;
+
+	init_shared_info();
+}
+
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index 97cad30..48efbd8 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -344,6 +344,9 @@ static int __init xenkbd_init(void)
 	if (xen_initial_domain())
 		return -ENODEV;
 
+	if (xen_hvm_domain())
+		return -ENODEV;
+
 	return xenbus_register_frontend(&xenkbd_driver);
 }
 
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 1e2dc9c..77566fb 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -689,6 +689,9 @@ static int __init xenfb_init(void)
 	if (xen_initial_domain())
 		return -ENODEV;
 
+	if (xen_hvm_domain())
+		return -ENODEV;
+
 	return xenbus_register_frontend(&xenfb_driver);
 }
 
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 348d042..c18ae96 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -53,6 +53,8 @@
 #include <xen/events.h>
 #include <xen/page.h>
 
+#include <xen/hvm.h>
+
 #include "xenbus_comms.h"
 #include "xenbus_probe.h"
 
@@ -722,10 +724,19 @@ static int __init xenbus_probe_init(void)
 		xen_store_interface = mfn_to_virt(xen_store_mfn);
 	} else {
 		xenstored_ready = 1;
-		xen_store_evtchn = xen_start_info->store_evtchn;
-		xen_store_mfn = xen_start_info->store_mfn;
+		if (xen_hvm_domain()) {
+			xen_store_evtchn =
+				hvm_get_parameter(HVM_PARAM_STORE_EVTCHN);
+			xen_store_mfn =
+				hvm_get_parameter(HVM_PARAM_STORE_PFN);
+			xen_store_interface =
+				ioremap(xen_store_mfn << PAGE_SHIFT, PAGE_SIZE);
+		} else {
+			xen_store_evtchn = xen_start_info->store_evtchn;
+			xen_store_mfn = xen_start_info->store_mfn;
+			xen_store_interface = mfn_to_virt(xen_store_mfn);
+		}
 	}
-	xen_store_interface = mfn_to_virt(xen_store_mfn);
 
 	/* Initialize the interface to xenstore. */
 	err = xs_init();

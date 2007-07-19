Return-Path: <linux-kernel-owner+w=401wt.eu-S938588AbXGSN6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938588AbXGSN6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760604AbXGSNsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:54 -0400
Received: from mx1.suse.de ([195.135.220.2]:54539 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932612AbXGSNsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:52 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: Yinghai.Lu@Sun.COM, ak@suse.de, alan@lxorguk.ukuu.org.uk,
       ebiederm@xmission.com, muli@il.ibm.com, vgoyal@in.ibm.com,
       davej@codemonkey.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [21/48] x86_64: disable the GART in shutdown
Message-Id: <20070719134850.E060414E71@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Yinghai Lu <Yinghai.Lu@Sun.COM>

For K8 system: 4G RAM with memory hole remapping enabled, or more than 4G
RAM installed.  when using kexec to load second kernel.  In the second
kernel, when mem is allocated for GART, it will do the memset for clear, it
will cause restart, because some device still used that for dma.  solution
will be:

in second kernel: disable that at first before we try to allocate mem for
it.  or in the first kernel: do disable that before shutdown. 
Andi/Eric/Alan prefer to second one for clean shutdown in first kernel. 
Andi also point out need to consider to AGP enable but mem less 4G case
too.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-dma.c  |    5 +++++
 arch/x86_64/kernel/pci-gart.c |   20 ++++++++++++++++++++
 arch/x86_64/kernel/reboot.c   |    4 ++++
 include/asm-x86_64/proto.h    |    7 +++++++
 4 files changed, 36 insertions(+)

Index: linux/arch/x86_64/kernel/pci-dma.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-dma.c
+++ linux/arch/x86_64/kernel/pci-dma.c
@@ -321,6 +321,11 @@ static int __init pci_iommu_init(void)
 	return 0;
 }
 
+void pci_iommu_shutdown(void)
+{
+	gart_iommu_shutdown();
+}
+
 #ifdef CONFIG_PCI
 /* Many VIA bridges seem to corrupt data for DAC. Disable it here */
 
Index: linux/arch/x86_64/kernel/pci-gart.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-gart.c
+++ linux/arch/x86_64/kernel/pci-gart.c
@@ -571,6 +571,26 @@ static const struct dma_mapping_ops gart
 	.unmap_sg = gart_unmap_sg,
 };
 
+void gart_iommu_shutdown(void)
+{
+	struct pci_dev *dev;
+	int i;
+
+	if (no_agp && (dma_ops != &gart_dma_ops))
+		return;
+
+        for (i = 0; i < num_k8_northbridges; i++) {
+                u32 ctl;
+
+                dev = k8_northbridges[i];
+                pci_read_config_dword(dev, 0x90, &ctl);
+
+                ctl &= ~1;
+
+                pci_write_config_dword(dev, 0x90, ctl);
+        }
+}
+
 void __init gart_iommu_init(void)
 { 
 	struct agp_kern_info info;
Index: linux/arch/x86_64/kernel/reboot.c
===================================================================
--- linux.orig/arch/x86_64/kernel/reboot.c
+++ linux/arch/x86_64/kernel/reboot.c
@@ -16,6 +16,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/apic.h>
+#include <asm/proto.h>
 
 /*
  * Power off function, if any
@@ -81,6 +82,7 @@ static inline void kb_wait(void)
 void machine_shutdown(void)
 {
 	unsigned long flags;
+
 	/* Stop the cpus and apics */
 #ifdef CONFIG_SMP
 	int reboot_cpu_id;
@@ -111,6 +113,8 @@ void machine_shutdown(void)
 	disable_IO_APIC();
 
 	local_irq_restore(flags);
+
+	pci_iommu_shutdown();
 }
 
 void machine_emergency_restart(void)
Index: linux/include/asm-x86_64/proto.h
===================================================================
--- linux.orig/include/asm-x86_64/proto.h
+++ linux/include/asm-x86_64/proto.h
@@ -85,11 +85,13 @@ extern int exception_trace;
 extern unsigned cpu_khz;
 extern unsigned tsc_khz;
 
+extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 #ifdef CONFIG_IOMMU
 extern void gart_iommu_init(void);
+extern void gart_iommu_shutdown(void);
 extern void __init gart_parse_options(char *);
 extern void iommu_hole_init(void);
 extern int fallback_aper_order;
@@ -101,6 +103,11 @@ extern int fix_aperture;
 #else
 #define iommu_aperture 0
 #define iommu_aperture_allowed 0
+
+static inline void gart_iommu_shutdown(void)
+{
+}
+
 #endif
 
 extern int reboot_force;

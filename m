Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbXFYVse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbXFYVse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbXFYVs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:48:26 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:47815 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbXFYVsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:48:25 -0400
Date: Mon, 25 Jun 2007 14:48:35 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 1/2] x86-64: disable the GART in shutdown
In-reply-to: <200706251234.04548.yinghai.lu@sun.com>
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200706251448.36201.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200706221219.16243.yinghai.lu@sun.com>
 <200706221934.59966.yinghai.lu@sun.com> <200706251234.04548.yinghai.lu@sun.com>
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/2] x86-64: disable the GART in shutdown

For K8 system: 4G RAM with memory hole remapping enabled, or more than 4G RAM
installed. when using kexec to load second kernel. In the second kernel,
 when mem is allocated for GART, it will do the memset for clear, it will cause
restart, because some device still used that for dma.
solution will be:
in second kernel: disable that at first before we try to allocate mem for it.
or in the first kernel: do disable that before shutdown.
Andi/Eric/Alan prefer to second one for clean shutdown in first kernel.
Andi also point out need to consider to AGP enable but mem less 4G case too.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

 arch/x86_64/kernel/pci-dma.c  |    5 +++++
 arch/x86_64/kernel/pci-gart.c |   21 +++++++++++++++++++++
 arch/x86_64/kernel/reboot.c   |    4 ++++
 include/asm-x86_64/proto.h    |    7 +++++++
 4 files changed, 37 insertions(+)

diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
index ae091cd..6c4fe16 100644
--- a/arch/x86_64/kernel/pci-gart.c
+++ b/arch/x86_64/kernel/pci-gart.c
@@ -571,6 +571,26 @@ static const struct dma_mapping_ops gart_dma_ops = {
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
diff --git a/arch/x86_64/kernel/pci-dma.c b/arch/x86_64/kernel/pci-dma.c
index 9f80aad..b406b54 100644
--- a/arch/x86_64/kernel/pci-dma.c
+++ b/arch/x86_64/kernel/pci-dma.c
@@ -322,6 +322,11 @@ static int __init pci_iommu_init(void)
 	return 0;
 }
 
+void pci_iommu_shutdown(void)
+{
+	gart_iommu_shutdown();
+}
+
 #ifdef CONFIG_PCI
 /* Many VIA bridges seem to corrupt data for DAC. Disable it here */
 
diff --git a/arch/x86_64/kernel/reboot.c b/arch/x86_64/kernel/reboot.c
index 7503068..e6e65c2 100644
--- a/arch/x86_64/kernel/reboot.c
+++ b/arch/x86_64/kernel/reboot.c
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
diff --git a/include/asm-x86_64/proto.h b/include/asm-x86_64/proto.h
index 85255db..b70aa0c 100644
--- a/include/asm-x86_64/proto.h
+++ b/include/asm-x86_64/proto.h
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

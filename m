Return-Path: <linux-kernel-owner+w=401wt.eu-S1751516AbXFWCdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbXFWCdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 22:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbXFWCdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 22:33:32 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:55111 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbXFWCdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 22:33:31 -0400
Date: Fri, 22 Jun 2007 19:34:59 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86-64: disable the GART in shutdown
In-reply-to: <467C6906.6020105@sun.com>
To: Andi Kleen <ak@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200706221934.59966.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200706221219.16243.yinghai.lu@sun.com>
 <200706230214.02535.ak@suse.de> <467C6906.6020105@sun.com>
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86-64: disable the GART in shutdown

For K8 system: 4G RAM with memory hole remapping enabled, or more than 4G RAM
installed. when mem is allocated for GART, it will do the memset for clear.
and for kexec case, the first kernel already enable that, the memset in second
kernel will cause the system restart. solution will be:
in second kernel: disable that at first before we try to allocate mem for it.
or in the first kernel: do disable that before shutdown.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

 arch/x86_64/kernel/pci-dma.c  |    7 +++++++
 arch/x86_64/kernel/pci-gart.c |   20 ++++++++++++++++++++
 arch/x86_64/kernel/reboot.c   |    4 ++++
 include/asm-x86_64/proto.h    |    2 ++
 4 files changed, 33 insertions(+)
diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
index ae091cd..4904d5f 100644
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
+	if (dma_ops != &gart_dma_ops)
+		return;
+
+	for (i = 0; i < num_k8_northbridges; i++) {
+		u32 ctl;
+
+		dev = k8_northbridges[i];
+		pci_read_config_dword(dev, 0x90, &ctl);
+
+		ctl &= ~1;
+
+		pci_write_config_dword(dev, 0x90, ctl);
+	}
+}
+
 void __init gart_iommu_init(void)
 { 
 	struct agp_kern_info info;
diff --git a/arch/x86_64/kernel/pci-dma.c b/arch/x86_64/kernel/pci-dma.c
index 9f80aad..64f2ab3 100644
--- a/arch/x86_64/kernel/pci-dma.c
+++ b/arch/x86_64/kernel/pci-dma.c
@@ -322,6 +322,13 @@ static int __init pci_iommu_init(void)
 	return 0;
 }
 
+void pci_iommu_shutdown(void)
+{
+#ifdef CONFIG_IOMMU
+	gart_iommu_shutdown();
+#endif
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
index 85255db..fb9f73e 100644
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

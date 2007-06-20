Return-Path: <linux-kernel-owner+w=401wt.eu-S1761466AbXFTKYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761466AbXFTKYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 06:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbXFTKXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 06:23:35 -0400
Received: from mail.suse.de ([195.135.220.2]:48414 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbXFTKXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 06:23:34 -0400
From: Andi Kleen <ak@suse.de>
References: <200706201223.443613000@suse.de>
In-Reply-To: <200706201223.443613000@suse.de>
To: torvalds@osdl.org, linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH for 2.6.22] [4/10] x86: Disable DAC on VIA bridges
Message-Id: <20070620102332.C160F14AEF@wotan.suse.de>
Date: Wed, 20 Jun 2007 12:23:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Several reports that VIA bridges don't support DAC and corrupt
data.  I don't know if it's fixed, but let's just blacklist
them all for now.

It can be overwritten with iommu=usedac

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/pci-dma.c     |   27 +++++++++++++++++++++++++++
 arch/x86_64/kernel/pci-dma.c   |   12 ++++++++++++
 include/asm-i386/dma-mapping.h |    6 ++++++
 3 files changed, 45 insertions(+)

Index: linux/arch/x86_64/kernel/pci-dma.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-dma.c
+++ linux/arch/x86_64/kernel/pci-dma.c
@@ -322,5 +322,17 @@ static int __init pci_iommu_init(void)
 	return 0;
 }
 
+#ifdef CONFIG_PCI
+/* Many VIA bridges seem to corrupt data for DAC. Disable it here */
+
+static __devinit void via_no_dac(struct pci_dev *dev)
+{
+	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI && forbid_dac == 0) {
+		printk(KERN_INFO "PCI: VIA PCI bridge detected. Disabling DAC.\n");
+		forbid_dac = 1;
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_ANY_ID, via_no_dac);
+#endif
 /* Must execute after PCI subsystem */
 fs_initcall(pci_iommu_init);
Index: linux/arch/i386/kernel/pci-dma.c
===================================================================
--- linux.orig/arch/i386/kernel/pci-dma.c
+++ linux/arch/i386/kernel/pci-dma.c
@@ -12,6 +12,7 @@
 #include <linux/string.h>
 #include <linux/pci.h>
 #include <linux/module.h>
+#include <linux/pci.h>
 #include <asm/io.h>
 
 struct dma_coherent_mem {
@@ -148,3 +149,29 @@ void *dma_mark_declared_memory_occupied(
 	return mem->virt_base + (pos << PAGE_SHIFT);
 }
 EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
+
+#ifdef CONFIG_PCI
+/* Many VIA bridges seem to corrupt data for DAC. Disable it here */
+
+int forbid_dac;
+EXPORT_SYMBOL(forbid_dac);
+
+static __devinit void via_no_dac(struct pci_dev *dev)
+{
+	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI && forbid_dac == 0) {
+		printk(KERN_INFO "PCI: VIA PCI bridge detected. Disabling DAC.\n");
+		forbid_dac = 1;
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_ANY_ID, via_no_dac);
+
+static int check_iommu(char *s)
+{
+	if (!strcmp(s, "usedac")) {
+		forbid_dac = -1;
+		return 1;
+	}
+	return 0;
+}
+__setup("iommu=", check_iommu);
+#endif
Index: linux/include/asm-i386/dma-mapping.h
===================================================================
--- linux.orig/include/asm-i386/dma-mapping.h
+++ linux/include/asm-i386/dma-mapping.h
@@ -123,6 +123,8 @@ dma_mapping_error(dma_addr_t dma_addr)
 	return 0;
 }
 
+extern int forbid_dac;
+
 static inline int
 dma_supported(struct device *dev, u64 mask)
 {
@@ -134,6 +136,10 @@ dma_supported(struct device *dev, u64 ma
         if(mask < 0x00ffffff)
                 return 0;
 
+	/* Work around chipset bugs */
+	if (forbid_dac > 0 && mask > 0xffffffffULL)
+		return 0;
+
 	return 1;
 }
 

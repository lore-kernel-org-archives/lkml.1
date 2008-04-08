Return-Path: <linux-kernel-owner+w=401wt.eu-S1759727AbYDHQa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727AbYDHQa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756313AbYDHQ2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:28:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758538AbYDHQ2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:28:10 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 13/28] x86: merge dma_supported
Date: Tue,  8 Apr 2008 13:20:55 -0300
Message-Id: <1207671757880-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code for both arches are very similar, so this patch merge them.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-dma.c    |   44 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/pci-dma_32.c |   24 ----------------------
 arch/x86/kernel/pci-dma_64.c |   44 +-----------------------------------------
 3 files changed, 45 insertions(+), 67 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index f6d6a92..4289a9b 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -14,6 +14,8 @@ EXPORT_SYMBOL(forbid_dac);
 const struct dma_mapping_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
+int iommu_sac_force __read_mostly = 0;
+
 #ifdef CONFIG_IOMMU_DEBUG
 int panic_on_overflow __read_mostly = 1;
 int force_iommu __read_mostly = 1;
@@ -33,6 +35,48 @@ int dma_set_mask(struct device *dev, u64 mask)
 }
 EXPORT_SYMBOL(dma_set_mask);
 
+int dma_supported(struct device *dev, u64 mask)
+{
+#ifdef CONFIG_PCI
+	if (mask > 0xffffffff && forbid_dac > 0) {
+		printk(KERN_INFO "PCI: Disallowing DAC for device %s\n",
+				 dev->bus_id);
+		return 0;
+	}
+#endif
+
+	if (dma_ops->dma_supported)
+		return dma_ops->dma_supported(dev, mask);
+
+	/* Copied from i386. Doesn't make much sense, because it will
+	   only work for pci_alloc_coherent.
+	   The caller just has to use GFP_DMA in this case. */
+	if (mask < DMA_24BIT_MASK)
+		return 0;
+
+	/* Tell the device to use SAC when IOMMU force is on.  This
+	   allows the driver to use cheaper accesses in some cases.
+
+	   Problem with this is that if we overflow the IOMMU area and
+	   return DAC as fallback address the device may not handle it
+	   correctly.
+
+	   As a special case some controllers have a 39bit address
+	   mode that is as efficient as 32bit (aic79xx). Don't force
+	   SAC for these.  Assume all masks <= 40 bits are of this
+	   type. Normally this doesn't make any difference, but gives
+	   more gentle handling of IOMMU overflow. */
+	if (iommu_sac_force && (mask >= DMA_40BIT_MASK)) {
+		printk(KERN_INFO "%s: Force SAC with mask %Lx\n",
+				 dev->bus_id, mask);
+		return 0;
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL(dma_supported);
+
+
 static int __init pci_iommu_init(void)
 {
 #ifdef CONFIG_CALGARY_IOMMU
diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
index 6543bb3..1d4091a 100644
--- a/arch/x86/kernel/pci-dma_32.c
+++ b/arch/x86/kernel/pci-dma_32.c
@@ -155,30 +155,6 @@ void *dma_mark_declared_memory_occupied(struct device *dev,
 EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
 
 #ifdef CONFIG_PCI
-/* Many VIA bridges seem to corrupt data for DAC. Disable it here */
-
-int
-dma_supported(struct device *dev, u64 mask)
-{
-	/*
-	 * we fall back to GFP_DMA when the mask isn't all 1s,
-	 * so we can't guarantee allocations that must be
-	 * within a tighter range than GFP_DMA..
-	 */
-	if (mask < 0x00ffffff)
-		return 0;
-
-	/* Work around chipset bugs */
-	if (forbid_dac > 0 && mask > 0xffffffffULL)
-		return 0;
-
-	if (dma_ops->dma_supported)
-		return dma_ops->dma_supported(dev, mask);
-
-	return 1;
-}
-EXPORT_SYMBOL(dma_supported);
-
 static int check_iommu(char *s)
 {
 	if (!strcmp(s, "usedac")) {
diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index 7820675..c80da76 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -24,7 +24,7 @@ EXPORT_SYMBOL(bad_dma_address);
 int iommu_bio_merge __read_mostly = 0;
 EXPORT_SYMBOL(iommu_bio_merge);
 
-static int iommu_sac_force __read_mostly = 0;
+extern int iommu_sac_force;
 
 int no_iommu __read_mostly;
 /* Set this to 1 if there is a HW IOMMU in the system */
@@ -161,48 +161,6 @@ void dma_free_coherent(struct device *dev, size_t size,
 }
 EXPORT_SYMBOL(dma_free_coherent);
 
-int dma_supported(struct device *dev, u64 mask)
-{
-#ifdef CONFIG_PCI
-	if (mask > 0xffffffff && forbid_dac > 0) {
-
-
-
-		printk(KERN_INFO "PCI: Disallowing DAC for device %s\n", dev->bus_id);
-		return 0;
-	}
-#endif
-
-	if (dma_ops->dma_supported)
-		return dma_ops->dma_supported(dev, mask);
-
-	/* Copied from i386. Doesn't make much sense, because it will
-	   only work for pci_alloc_coherent.
-	   The caller just has to use GFP_DMA in this case. */
-        if (mask < DMA_24BIT_MASK)
-                return 0;
-
-	/* Tell the device to use SAC when IOMMU force is on.  This
-	   allows the driver to use cheaper accesses in some cases.
-
-	   Problem with this is that if we overflow the IOMMU area and
-	   return DAC as fallback address the device may not handle it
-	   correctly.
-
-	   As a special case some controllers have a 39bit address
-	   mode that is as efficient as 32bit (aic79xx). Don't force
-	   SAC for these.  Assume all masks <= 40 bits are of this
-	   type. Normally this doesn't make any difference, but gives
-	   more gentle handling of IOMMU overflow. */
-	if (iommu_sac_force && (mask >= DMA_40BIT_MASK)) {
-		printk(KERN_INFO "%s: Force SAC with mask %Lx\n", dev->bus_id,mask);
-		return 0;
-	}
-
-	return 1;
-}
-EXPORT_SYMBOL(dma_supported);
-
 /*
  * See <Documentation/x86_64/boot-options.txt> for the iommu kernel parameter
  * documentation.
-- 
1.5.0.6


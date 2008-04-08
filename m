Return-Path: <linux-kernel-owner+w=401wt.eu-S1759501AbYDHQaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501AbYDHQaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758511AbYDHQ2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:28:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758488AbYDHQ2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:28:05 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 11/28] x86: move pci fixup to pci-dma.c
Date: Tue,  8 Apr 2008 13:20:53 -0300
Message-Id: <12076717441938-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

via_no_dac provides a fixup that is the same for both
architectures. Move it to pci-dma.c.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-dma.c     |   18 ++++++++++++++++++
 arch/x86/kernel/pci-dma_32.c  |   13 -------------
 arch/x86/kernel/pci-dma_64.c  |   15 ---------------
 include/asm-x86/dma-mapping.h |    2 +-
 4 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 6b77fd8..e81e16f 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -1,9 +1,13 @@
 #include <linux/dma-mapping.h>
 #include <linux/dmar.h>
+#include <linux/pci.h>
 
 #include <asm/gart.h>
 #include <asm/calgary.h>
 
+int forbid_dac __read_mostly;
+EXPORT_SYMBOL(forbid_dac);
+
 const struct dma_mapping_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
@@ -48,3 +52,17 @@ void pci_iommu_shutdown(void)
 }
 /* Must execute after PCI subsystem */
 fs_initcall(pci_iommu_init);
+
+#ifdef CONFIG_PCI
+/* Many VIA bridges seem to corrupt data for DAC. Disable it here */
+
+static __devinit void via_no_dac(struct pci_dev *dev)
+{
+	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI && forbid_dac == 0) {
+		printk(KERN_INFO "PCI: VIA PCI bridge detected."
+				 "Disabling DAC.\n");
+		forbid_dac = 1;
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_ANY_ID, via_no_dac);
+#endif
diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
index 9e82976..6543bb3 100644
--- a/arch/x86/kernel/pci-dma_32.c
+++ b/arch/x86/kernel/pci-dma_32.c
@@ -157,9 +157,6 @@ EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
 #ifdef CONFIG_PCI
 /* Many VIA bridges seem to corrupt data for DAC. Disable it here */
 
-int forbid_dac;
-EXPORT_SYMBOL(forbid_dac);
-
 int
 dma_supported(struct device *dev, u64 mask)
 {
@@ -182,16 +179,6 @@ dma_supported(struct device *dev, u64 mask)
 }
 EXPORT_SYMBOL(dma_supported);
 
-
-static __devinit void via_no_dac(struct pci_dev *dev)
-{
-	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI && forbid_dac == 0) {
-		printk(KERN_INFO "PCI: VIA PCI bridge detected. Disabling DAC.\n");
-		forbid_dac = 1;
-	}
-}
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_ANY_ID, via_no_dac);
-
 static int check_iommu(char *s)
 {
 	if (!strcmp(s, "usedac")) {
diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index 4202130..e194460 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -161,8 +161,6 @@ void dma_free_coherent(struct device *dev, size_t size,
 }
 EXPORT_SYMBOL(dma_free_coherent);
 
-static int forbid_dac __read_mostly;
-
 int dma_supported(struct device *dev, u64 mask)
 {
 #ifdef CONFIG_PCI
@@ -338,16 +336,3 @@ void __init pci_iommu_alloc(void)
 	pci_swiotlb_init();
 #endif
 }
-
-#ifdef CONFIG_PCI
-/* Many VIA bridges seem to corrupt data for DAC. Disable it here */
-
-static __devinit void via_no_dac(struct pci_dev *dev)
-{
-	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI && forbid_dac == 0) {
-		printk(KERN_INFO "PCI: VIA PCI bridge detected. Disabling DAC.\n");
-		forbid_dac = 1;
-	}
-}
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_ANY_ID, via_no_dac);
-#endif
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 914846d..d82517d 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -14,6 +14,7 @@ extern dma_addr_t bad_dma_address;
 extern int iommu_merge;
 extern struct device fallback_dev;
 extern int panic_on_overflow;
+extern int forbid_dac;
 
 struct dma_mapping_ops {
 	int             (*mapping_error)(dma_addr_t dma_addr);
@@ -223,6 +224,5 @@ dma_release_declared_memory(struct device *dev);
 extern void *
 dma_mark_declared_memory_occupied(struct device *dev,
 				  dma_addr_t device_addr, size_t size);
-extern int forbid_dac;
 #endif /* CONFIG_X86_32 */
 #endif
-- 
1.5.0.6


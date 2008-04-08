Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbYDHQ3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbYDHQ3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757916AbYDHQ1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:27:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757866AbYDHQ1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:27:33 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 09/28] x86: move initialization functions to pci-dma.c
Date: Tue,  8 Apr 2008 13:20:51 -0300
Message-Id: <12076717312471-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initcalls that triggers the various possibiities for
dma subsys are moved to pci-dma.c.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-dma.c    |   25 +++++++++++++++++++++++++
 arch/x86/kernel/pci-dma_64.c |   23 -----------------------
 2 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 1323cd8..d30634b 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -1,4 +1,8 @@
 #include <linux/dma-mapping.h>
+#include <linux/dmar.h>
+
+#include <asm/gart.h>
+#include <asm/calgary.h>
 
 const struct dma_mapping_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
@@ -14,4 +18,25 @@ int dma_set_mask(struct device *dev, u64 mask)
 }
 EXPORT_SYMBOL(dma_set_mask);
 
+static int __init pci_iommu_init(void)
+{
+#ifdef CONFIG_CALGARY_IOMMU
+	calgary_iommu_init();
+#endif
+
+	intel_iommu_init();
 
+#ifdef CONFIG_GART_IOMMU
+	gart_iommu_init();
+#endif
+
+	no_iommu_init();
+	return 0;
+}
+
+void pci_iommu_shutdown(void)
+{
+	gart_iommu_shutdown();
+}
+/* Must execute after PCI subsystem */
+fs_initcall(pci_iommu_init);
diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index e697b86..e95f671 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -347,27 +347,6 @@ void __init pci_iommu_alloc(void)
 #endif
 }
 
-static int __init pci_iommu_init(void)
-{
-#ifdef CONFIG_CALGARY_IOMMU
-	calgary_iommu_init();
-#endif
-
-	intel_iommu_init();
-
-#ifdef CONFIG_GART_IOMMU
-	gart_iommu_init();
-#endif
-
-	no_iommu_init();
-	return 0;
-}
-
-void pci_iommu_shutdown(void)
-{
-	gart_iommu_shutdown();
-}
-
 #ifdef CONFIG_PCI
 /* Many VIA bridges seem to corrupt data for DAC. Disable it here */
 
@@ -380,5 +359,3 @@ static __devinit void via_no_dac(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_ANY_ID, via_no_dac);
 #endif
-/* Must execute after PCI subsystem */
-fs_initcall(pci_iommu_init);
-- 
1.5.0.6


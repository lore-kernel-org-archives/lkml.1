Return-Path: <linux-kernel-owner+w=401wt.eu-S1759589AbYDHQao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbYDHQao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758554AbYDHQ2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:28:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758542AbYDHQ2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:28:10 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 12/28] x86: move x86_64-specific to common code.
Date: Tue,  8 Apr 2008 13:20:54 -0300
Message-Id: <12076717503496-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the bootmem functions, that are largely
x86_64-specific into pci-dma.c. The code goes inside an ifdef.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-dma.c    |   73 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/pci-dma_64.c |   68 ---------------------------------------
 2 files changed, 73 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index e81e16f..f6d6a92 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -1,7 +1,10 @@
 #include <linux/dma-mapping.h>
 #include <linux/dmar.h>
 #include <linux/pci.h>
+#include <linux/bootmem.h>
 
+#include <asm/proto.h>
+#include <asm/dma.h>
 #include <asm/gart.h>
 #include <asm/calgary.h>
 
@@ -66,3 +69,73 @@ static __devinit void via_no_dac(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_ANY_ID, via_no_dac);
 #endif
+
+#ifdef CONFIG_X86_64
+static __initdata void *dma32_bootmem_ptr;
+static unsigned long dma32_bootmem_size __initdata = (128ULL<<20);
+
+static int __init parse_dma32_size_opt(char *p)
+{
+	if (!p)
+		return -EINVAL;
+	dma32_bootmem_size = memparse(p, &p);
+	return 0;
+}
+early_param("dma32_size", parse_dma32_size_opt);
+
+void __init dma32_reserve_bootmem(void)
+{
+	unsigned long size, align;
+	if (end_pfn <= MAX_DMA32_PFN)
+		return;
+
+	align = 64ULL<<20;
+	size = round_up(dma32_bootmem_size, align);
+	dma32_bootmem_ptr = __alloc_bootmem_nopanic(size, align,
+				 __pa(MAX_DMA_ADDRESS));
+	if (dma32_bootmem_ptr)
+		dma32_bootmem_size = size;
+	else
+		dma32_bootmem_size = 0;
+}
+static void __init dma32_free_bootmem(void)
+{
+	int node;
+
+	if (end_pfn <= MAX_DMA32_PFN)
+		return;
+
+	if (!dma32_bootmem_ptr)
+		return;
+
+	for_each_online_node(node)
+		free_bootmem_node(NODE_DATA(node), __pa(dma32_bootmem_ptr),
+				  dma32_bootmem_size);
+
+	dma32_bootmem_ptr = NULL;
+	dma32_bootmem_size = 0;
+}
+
+void __init pci_iommu_alloc(void)
+{
+	/* free the range so iommu could get some range less than 4G */
+	dma32_free_bootmem();
+	/*
+	 * The order of these functions is important for
+	 * fall-back/fail-over reasons
+	 */
+#ifdef CONFIG_GART_IOMMU
+	gart_iommu_hole_init();
+#endif
+
+#ifdef CONFIG_CALGARY_IOMMU
+	detect_calgary();
+#endif
+
+	detect_intel_iommu();
+
+#ifdef CONFIG_SWIOTLB
+	pci_swiotlb_init();
+#endif
+}
+#endif
diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index e194460..7820675 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -268,71 +268,3 @@ static __init int iommu_setup(char *p)
 	return 0;
 }
 early_param("iommu", iommu_setup);
-
-static __initdata void *dma32_bootmem_ptr;
-static unsigned long dma32_bootmem_size __initdata = (128ULL<<20);
-
-static int __init parse_dma32_size_opt(char *p)
-{
-	if (!p)
-		return -EINVAL;
-	dma32_bootmem_size = memparse(p, &p);
-	return 0;
-}
-early_param("dma32_size", parse_dma32_size_opt);
-
-void __init dma32_reserve_bootmem(void)
-{
-	unsigned long size, align;
-	if (end_pfn <= MAX_DMA32_PFN)
-		return;
-
-	align = 64ULL<<20;
-	size = round_up(dma32_bootmem_size, align);
-	dma32_bootmem_ptr = __alloc_bootmem_nopanic(size, align,
-				 __pa(MAX_DMA_ADDRESS));
-	if (dma32_bootmem_ptr)
-		dma32_bootmem_size = size;
-	else
-		dma32_bootmem_size = 0;
-}
-static void __init dma32_free_bootmem(void)
-{
-	int node;
-
-	if (end_pfn <= MAX_DMA32_PFN)
-		return;
-
-	if (!dma32_bootmem_ptr)
-		return;
-
-	for_each_online_node(node)
-		free_bootmem_node(NODE_DATA(node), __pa(dma32_bootmem_ptr),
-				  dma32_bootmem_size);
-
-	dma32_bootmem_ptr = NULL;
-	dma32_bootmem_size = 0;
-}
-
-void __init pci_iommu_alloc(void)
-{
-	/* free the range so iommu could get some range less than 4G */
-	dma32_free_bootmem();
-	/*
-	 * The order of these functions is important for
-	 * fall-back/fail-over reasons
-	 */
-#ifdef CONFIG_GART_IOMMU
-	gart_iommu_hole_init();
-#endif
-
-#ifdef CONFIG_CALGARY_IOMMU
-	detect_calgary();
-#endif
-
-	detect_intel_iommu();
-
-#ifdef CONFIG_SWIOTLB
-	pci_swiotlb_init();
-#endif
-}
-- 
1.5.0.6


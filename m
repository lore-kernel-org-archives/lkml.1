Return-Path: <linux-kernel-owner+w=401wt.eu-S933700AbYEHVof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbYEHVof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 17:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762254AbYEHVoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 17:44:04 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:39994 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202AbYEHVn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 17:43:59 -0400
Subject: [RFC][PATCH] x86 calgary: add fallback dma_ops]]
From: Alexis Bruemmer <alexisb@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Muli <muli@il.ibm.com>
Content-Type: text/plain
Date: Thu, 08 May 2008 14:40:20 -0700
Message-Id: <1210282820.6114.209.camel@alexis>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the calgary code can give drivers addresses above 4GB which is
very bad for hardware that is only 32bit DMA addressable.  This patch
"teaches" calgary to fallback to the appropriate dma_ops when it
encounters a device/bus which is not behind the Calgary/CalIOC2.  I
believe there is a better way to do this and am open for ideas, but for
now this certainly fixes the badness.


Signed-off-by Alexis Bruemmer <alexisb@us.ibm.com>

---

Index: linux-2.6.26-rc1/arch/x86/kernel/pci-nommu.c
===================================================================
--- linux-2.6.26-rc1.orig/arch/x86/kernel/pci-nommu.c
+++ linux-2.6.26-rc1/arch/x86/kernel/pci-nommu.c
@@ -10,6 +10,7 @@
 #include <asm/gart.h>
 #include <asm/processor.h>
 #include <asm/dma.h>
+#include <asm/calgary.h>

 static int
 check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t size)
@@ -92,6 +93,10 @@ const struct dma_mapping_ops nommu_dma_o

 void __init no_iommu_init(void)
 {
+#ifdef CONFIG_CALGARY_IOMMU
+	if (use_calgary && (end_pfn < MAX_DMA32_PFN))
+		fallback_dma_ops = &nommu_dma_ops;
+#endif
 	if (dma_ops)
 		return;

Index: linux-2.6.26-rc1/arch/x86/kernel/pci-swiotlb_64.c
===================================================================
--- linux-2.6.26-rc1.orig/arch/x86/kernel/pci-swiotlb_64.c
+++ linux-2.6.26-rc1/arch/x86/kernel/pci-swiotlb_64.c
@@ -8,6 +8,7 @@
 #include <asm/gart.h>
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
+#include <asm/calgary.h>

 int swiotlb __read_mostly;

@@ -47,4 +48,10 @@ void __init pci_swiotlb_init(void)
 		swiotlb_init();
 		dma_ops = &swiotlb_dma_ops;
 	}
+#ifdef CONFIG_CALGARY_IOMMU
+	else if (use_calgary && (end_pfn > MAX_DMA32_PFN)) {
+		swiotlb_init();
+		fallback_dma_ops = &swiotlb_dma_ops;
+	}
+#endif
 }
Index: linux-2.6.26-rc1/include/asm-x86/calgary.h
===================================================================
--- linux-2.6.26-rc1.orig/include/asm-x86/calgary.h
+++ linux-2.6.26-rc1/include/asm-x86/calgary.h
@@ -60,6 +60,7 @@ struct cal_chipset_ops {
 #define TCE_TABLE_SIZE_8M		7

 extern int use_calgary;
+extern const struct dma_mapping_ops* fallback_dma_ops;

 #ifdef CONFIG_CALGARY_IOMMU
 extern int calgary_iommu_init(void);
Index: linux-2.6.26-rc1/arch/x86/kernel/pci-calgary_64.c
===================================================================
--- linux-2.6.26-rc1.orig/arch/x86/kernel/pci-calgary_64.c
+++ linux-2.6.26-rc1/arch/x86/kernel/pci-calgary_64.c
@@ -50,6 +50,7 @@ int use_calgary __read_mostly = 1;
 #else
 int use_calgary __read_mostly = 0;
 #endif /* CONFIG_CALGARY_DEFAULT_ENABLED */
+const struct dma_mapping_ops* fallback_dma_ops;

 #define PCI_DEVICE_ID_IBM_CALGARY 0x02a1
 #define PCI_DEVICE_ID_IBM_CALIOC2 0x0308
@@ -410,22 +411,6 @@ static void calgary_unmap_sg(struct devi
 	}
 }

-static int calgary_nontranslate_map_sg(struct device* dev,
-	struct scatterlist *sg, int nelems, int direction)
-{
-	struct scatterlist *s;
-	int i;
-
-	for_each_sg(sg, s, nelems, i) {
-		struct page *p = sg_page(s);
-
-		BUG_ON(!p);
-		s->dma_address = virt_to_bus(sg_virt(s));
-		s->dma_length = s->length;
-	}
-	return nelems;
-}
-
 static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 	int nelems, int direction)
 {
@@ -437,7 +422,7 @@ static int calgary_map_sg(struct device 
 	int i;

 	if (!translation_enabled(tbl))
-		return calgary_nontranslate_map_sg(dev, sg, nelems, direction);
+		return fallback_dma_ops->map_sg(dev, sg, nelems, direction);

 	for_each_sg(sg, s, nelems, i) {
 		BUG_ON(!sg_page(s));
@@ -480,13 +465,13 @@ static dma_addr_t calgary_map_single(str
 	unsigned int npages;
 	struct iommu_table *tbl = find_iommu_table(dev);

+	if (!translation_enabled(tbl))
+		return fallback_dma_ops->map_single(dev, paddr, size, direction);
+
 	uaddr = (unsigned long)vaddr;
 	npages = num_dma_pages(uaddr, size);

-	if (translation_enabled(tbl))
-		dma_handle = iommu_alloc(dev, tbl, vaddr, npages, direction);
-	else
-		dma_handle = virt_to_bus(vaddr);
+	dma_handle = iommu_alloc(dev, tbl, vaddr, npages, direction);

 	return dma_handle;
 }
@@ -497,8 +482,10 @@ static void calgary_unmap_single(struct 
 	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned int npages;

-	if (!translation_enabled(tbl))
+	if (!translation_enabled(tbl)) {
+		fallback_dma_ops->unmap_single(dev, dma_handle, size, direction);
 		return;
+	}

 	npages = num_dma_pages(dma_handle, size);
 	iommu_free(tbl, dma_handle, npages);
@@ -512,6 +499,9 @@ static void* calgary_alloc_coherent(stru
 	unsigned int npages, order;
 	struct iommu_table *tbl = find_iommu_table(dev);

+	if (!translation_enabled(tbl))
+		return fallback_dma_ops->alloc_coherent(dev, size, dma_handle, flag);
+
 	size = PAGE_ALIGN(size); /* size rounded up to full pages */
 	npages = size >> PAGE_SHIFT;
 	order = get_order(size);
@@ -522,15 +512,12 @@ static void* calgary_alloc_coherent(stru
 		goto error;
 	memset(ret, 0, size);

-	if (translation_enabled(tbl)) {
-		/* set up tces to cover the allocated range */
-		mapping = iommu_alloc(dev, tbl, ret, npages, DMA_BIDIRECTIONAL);
-		if (mapping == bad_dma_address)
-			goto free;
-
-		*dma_handle = mapping;
-	} else /* non translated slot */
-		*dma_handle = virt_to_bus(ret);
+	/* set up tces to cover the allocated range */
+	mapping = iommu_alloc(dev, tbl, ret, npages, DMA_BIDIRECTIONAL);
+	if (mapping == bad_dma_address)
+		goto free;
+
+	*dma_handle = mapping;

 	return ret;



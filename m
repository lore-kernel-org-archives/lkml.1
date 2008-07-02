Return-Path: <linux-kernel-owner+w=401wt.eu-S1761894AbYGBDwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761894AbYGBDwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 23:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757159AbYGBDwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 23:52:08 -0400
Received: from sh.osrg.net ([192.16.179.4]:34498 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151AbYGBDwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 23:52:07 -0400
Date: Wed, 2 Jul 2008 12:43:39 +0900
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, alexisb@us.ibm.com,
       linux-kernel@vger.kernel.org, muli@il.ibm.com, mingo@elte.hu
Subject: Re: [PATCH -mm] fix per-device dma_mapping_ops support
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080701194840.258b500f.akpm@linux-foundation.org>
References: <1214949124.6553.9.camel@alexis>
	<20080702113711Y.fujita.tomonori@lab.ntt.co.jp>
	<20080701194840.258b500f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080702124328B.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008 19:48:40 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 2 Jul 2008 11:37:27 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > > http://marc.info/?l=linux-kernel&m=121329005131176&w=2
> > > 
> > > Are they at a state where they can be picked-up?  If not what is needed
> > > to progress?
> > 
> > The updated patch to fix the Calgary IOMMU driver looks fine to
> > me. Andrew, can you put it in the -mm?
> 
> umm, put what into -mm?  I see four different patches and a string of
> back-and-forth discussion with no clear testing results.  It is
> unreasonsable and too error-prone to have me go picking through such a
> thread attempting to work out which of those patches should be applied
> and then writing people's changelogs for them.

Sorry,

My initial patch has some bugs (wasn't tested because I don't have
Calgary hardware) but Alexis fixed the problems and submitted new one
(he successfully tested it). I had one minor comment about it then he
submitted another one.

http://marc.info/?l=linux-kernel&m=121329005131176&w=2

I think that it can get into mainline with the dma-mapping-per-device
patchset.

As we discussed, we could do better but it takes some time. I think
that it's better to fix Calgary problems now. Then I'll try to improve
dma-mapping-per-device stuff.

Here's a repost of Alexis's latest patch.

Thanks,

=
From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH] x86 calgary: fix handling of devces that aren't behind the Calgary

The calgary code can give drivers addresses above 4GB which is very
bad for hardware that is only 32bit DMA addressable.

With this patch, the calgary code sets the global dma_ops to swiotlb
or nommu properly, and the dma_ops of devices behind the
Calgary/CalIOC2 to calgary_dma_ops. So the calgary code can handle
devices safely that aren't behind the Calgary/CalIOC2.

Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-calgary_64.c |   72 ++++++++++++++-----------------------
 include/asm-x86/iommu.h          |    1 +
 2 files changed, 28 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index dca9a82..84a8d6b 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -36,6 +36,7 @@
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
 #include <linux/iommu-helper.h>
+#include <asm/iommu.h>
 #include <asm/gart.h>
 #include <asm/calgary.h>
 #include <asm/tce.h>
@@ -410,22 +411,6 @@ static void calgary_unmap_sg(struct device *dev,
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
@@ -436,9 +421,6 @@ static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 	unsigned long entry;
 	int i;
 
-	if (!translation_enabled(tbl))
-		return calgary_nontranslate_map_sg(dev, sg, nelems, direction);
-
 	for_each_sg(sg, s, nelems, i) {
 		BUG_ON(!sg_page(s));
 
@@ -474,7 +456,6 @@ error:
 static dma_addr_t calgary_map_single(struct device *dev, phys_addr_t paddr,
 	size_t size, int direction)
 {
-	dma_addr_t dma_handle = bad_dma_address;
 	void *vaddr = phys_to_virt(paddr);
 	unsigned long uaddr;
 	unsigned int npages;
@@ -483,12 +464,7 @@ static dma_addr_t calgary_map_single(struct device *dev, phys_addr_t paddr,
 	uaddr = (unsigned long)vaddr;
 	npages = num_dma_pages(uaddr, size);
 
-	if (translation_enabled(tbl))
-		dma_handle = iommu_alloc(dev, tbl, vaddr, npages, direction);
-	else
-		dma_handle = virt_to_bus(vaddr);
-
-	return dma_handle;
+	return iommu_alloc(dev, tbl, vaddr, npages, direction);
 }
 
 static void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
@@ -497,9 +473,6 @@ static void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
 	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned int npages;
 
-	if (!translation_enabled(tbl))
-		return;
-
 	npages = num_dma_pages(dma_handle, size);
 	iommu_free(tbl, dma_handle, npages);
 }
@@ -522,18 +495,12 @@ static void* calgary_alloc_coherent(struct device *dev, size_t size,
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
-
+	/* set up tces to cover the allocated range */
+	mapping = iommu_alloc(dev, tbl, ret, npages, DMA_BIDIRECTIONAL);
+	if (mapping == bad_dma_address)
+		goto free;
+	*dma_handle = mapping;
 	return ret;
-
 free:
 	free_pages((unsigned long)ret, get_order(size));
 	ret = NULL;
@@ -1230,6 +1197,16 @@ static int __init calgary_init(void)
 			goto error;
 	} while (1);
 
+	dev = NULL;
+	for_each_pci_dev(dev) {
+		struct iommu_table *tbl;
+
+		tbl = find_iommu_table(&dev->dev);
+
+		if(translation_enabled(tbl))
+			dev->dev.archdata.dma_ops = &calgary_dma_ops;
+	}
+
 	return ret;
 
 error:
@@ -1251,6 +1228,7 @@ error:
 		calgary_disable_translation(dev);
 		calgary_free_bus(dev);
 		pci_dev_put(dev); /* Undo calgary_init_one()'s pci_dev_get() */
+		dev->dev.archdata.dma_ops = NULL;
 	} while (1);
 
 	return ret;
@@ -1430,6 +1408,10 @@ void __init detect_calgary(void)
 		printk(KERN_INFO "PCI-DMA: Calgary TCE table spec is %d, "
 		       "CONFIG_IOMMU_DEBUG is %s.\n", specified_table_size,
 		       debugging ? "enabled" : "disabled");
+
+		/* swiotlb for devices that aren't behind the Calgary. */
+		if (end_pfn > MAX_DMA32_PFN)
+			swiotlb = 1;
 	}
 	return;
 
@@ -1446,7 +1428,7 @@ int __init calgary_iommu_init(void)
 {
 	int ret;
 
-	if (no_iommu || swiotlb)
+	if (no_iommu || (swiotlb && !calgary_detected))
 		return -ENODEV;
 
 	if (!calgary_detected)
@@ -1459,15 +1441,15 @@ int __init calgary_iommu_init(void)
 	if (ret) {
 		printk(KERN_ERR "PCI-DMA: Calgary init failed %d, "
 		       "falling back to no_iommu\n", ret);
-		if (end_pfn > MAX_DMA32_PFN)
-			printk(KERN_ERR "WARNING more than 4GB of memory, "
-					"32bit PCI may malfunction.\n");
 		return ret;
 	}
 
 	force_iommu = 1;
 	bad_dma_address = 0x0;
-	dma_ops = &calgary_dma_ops;
+
+	/* dma_ops is set to swiotlb or nommu */
+	if (!dma_ops)
+		dma_ops = &nommu_dma_ops;
 
 	return 0;
 }
diff --git a/include/asm-x86/iommu.h b/include/asm-x86/iommu.h
index 07862fd..1a5e7df 100644
--- a/include/asm-x86/iommu.h
+++ b/include/asm-x86/iommu.h
@@ -3,6 +3,7 @@
 
 extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
+extern struct dma_mapping_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 #ifdef CONFIG_IOMMU
-- 
1.5.5.GIT


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbYFLQ6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbYFLQ6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 12:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYFLQ6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 12:58:17 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36860 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbYFLQ6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 12:58:15 -0400
Subject: Re: [PATCH -mm] x86 calgary: fix handling of devces that aren't
	behind the Calgary
From: Alexis Bruemmer <alexisb@us.ibm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, muli@il.ibm.com, mingo@elte.hu,
       akpm@linux-foundation.org
In-Reply-To: <20080612163403K.fujita.tomonori@lab.ntt.co.jp>
References: <20080531133114P.tomof@acm.org>
	 <1213233906.8567.146.camel@alexis>
	 <20080612163403K.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 09:58:06 -0700
Message-Id: <1213289886.8567.150.camel@alexis>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 16:29 +0900, FUJITA Tomonori wrote:
> On Wed, 11 Jun 2008 18:25:06 -0700
> Alexis Bruemmer <alexisb@us.ibm.com> wrote:
> 
> > On Sat, 2008-05-31 at 13:31 +0900, FUJITA Tomonori wrote:
> > > The calgary code can give drivers addresses above 4GB which is very
> > > bad for hardware that is only 32bit DMA addressable:
> > > 
> > > http://lkml.org/lkml/2008/5/8/423
> > > 
> > > This patch tries to fix the problem by using per-device
> > > dma_mapping_ops support. This fixes the calgary code to use swiotlb or
> > > nommu properly for devices which are not behind the Calgary/CalIOC2.
> > > 
> > > With this patch, the calgary code sets the global dma_ops to swiotlb
> > > or nommu, and the dma_ops of devices behind the Calgary/CalIOC2 to
> > > calgary_dma_ops. So the calgary code can handle devices safely that
> > > aren't behind the Calgary/CalIOC2.
> > > 
> > > I think that bus_register_notifier works nicely for hotplugging (the
> > > calgary code can register a hook to set the device-per ops to
> > > calgary_dma_ops) though I don't know the calgary code needs it.
> > > 
> > > This patch is against -mm (depends on the per-device dma_mapping_ops
> > > patchset in -mm).
> > > 
> > > This is only compile tested.
> > So this patch dose not completely work.  The problem is that devices
> > that are controlled by the CalIO2/calgary are not getting the calgary
> > dma_ops assigned to them.  Having the proper changes to pci-dma.c helped
> > (thank you) but still didn't quite get us there.  From what I could tell
> > having the per device dma_ops being assigned in calgary_init_one was not
> > correct.  The dev being past to calgary_init_one is only ever an IBM
> > CalIO2/calgary device which meant that many devices that are being
> > controlled by the CalI02/calgary, such as the the MegaRAID SAS
> > controller, were not getting the calgary based dma ops assigned to them.
> 
> Thanks, now I see what's wrong in my patch.

> > I have attached an updated patch that does assign the per device calgary
> > dma_ops correctly and have successfully tested it on an IBM x3950 M2.  I
> > think there is a better way to do this, but this does work.
> 
> Looks good though I have one minor comment.
> 

Updated and tested patch below.

> 
> > Thank you some much for your help and work on this problem!
> 
> You're welcome! I just want to improve IOMMUs and dma mapping code.
> 
> 
> > Alexis 
> > 
> > 
> > > Thanks,
> > > 
> > > ==
> > > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > Subject: [PATCH] x86 calgary: fix handling of devces that aren't behind the Calgary
> > > 
> > > The calgary code can give drivers addresses above 4GB which is very
> > > bad for hardware that is only 32bit DMA addressable.
> > > 
> > > With this patch, the calgary code sets the global dma_ops to swiotlb
> > > or nommu properly, and the dma_ops of devices behind the
> > > Calgary/CalIOC2 to calgary_dma_ops. So the calgary code can handle
> > > devices safely that aren't behind the Calgary/CalIOC2.
> > > 
> > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > ---
<snip>

Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>

Index: linux-2.6.26-rc4/arch/x86/kernel/pci-calgary_64.c
===================================================================
--- linux-2.6.26-rc4.orig/arch/x86/kernel/pci-calgary_64.c
+++ linux-2.6.26-rc4/arch/x86/kernel/pci-calgary_64.c
@@ -36,6 +36,7 @@
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
 #include <linux/iommu-helper.h>
+#include <asm/iommu.h>
 #include <asm/gart.h>
 #include <asm/calgary.h>
 #include <asm/tce.h>
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
@@ -436,9 +421,6 @@ static int calgary_map_sg(struct device 
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
@@ -483,12 +464,7 @@ static dma_addr_t calgary_map_single(str
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
@@ -497,9 +473,6 @@ static void calgary_unmap_single(struct 
 	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned int npages;
 
-	if (!translation_enabled(tbl))
-		return;
-
 	npages = num_dma_pages(dma_handle, size);
 	iommu_free(tbl, dma_handle, npages);
 }
@@ -522,18 +495,12 @@ static void* calgary_alloc_coherent(stru
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
Index: linux-2.6.26-rc4/include/asm-x86/iommu.h
===================================================================
--- linux-2.6.26-rc4.orig/include/asm-x86/iommu.h
+++ linux-2.6.26-rc4/include/asm-x86/iommu.h
@@ -3,6 +3,7 @@
 
 extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
+extern struct dma_mapping_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 #ifdef CONFIG_IOMMU


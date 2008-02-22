Return-Path: <linux-kernel-owner+w=401wt.eu-S936048AbYBVOYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936048AbYBVOYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932722AbYBVOXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:23:39 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:25369 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765164AbYBVOXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:23:38 -0500
From: Andi Kleen <ak@suse.de>
References: <20080222323.714291012@suse.de>
In-Reply-To: <20080222323.714291012@suse.de>
To: starvik@axis.com, dev-extrax@axis.com, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Subject: [PATCH] [2/3] Remove dma_declare_coherent_memory etc. from cris
Message-Id: <20080222142329.D9DDC1B4178@basil.firstfloor.org>
Date: Fri, 22 Feb 2008 15:23:29 +0100 (CET)
X-OriginalArrivalTime: 22 Feb 2008 14:17:04.0774 (UTC) FILETIME=[997F8A60:01C8755D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The DMA implementation seems to be only there for a single PCI driver and the
driver does not use these interfaces. So remove it.

I don't have cris cross compilers so uncompiled/untested.

Cc: starvik@axis.com
Cc: dev-extrax@axis.com
Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/cris/arch-v32/drivers/pci/dma.c
===================================================================
--- linux.orig/arch/cris/arch-v32/drivers/pci/dma.c
+++ linux/arch/cris/arch-v32/drivers/pci/dma.c
@@ -27,24 +27,10 @@ void *dma_alloc_coherent(struct device *
 			   dma_addr_t *dma_handle, gfp_t gfp)
 {
 	void *ret;
-	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
 	int order = get_order(size);
 	/* ignore region specifiers */
 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
 
-	if (mem) {
-		int page = bitmap_find_free_region(mem->bitmap, mem->size,
-						     order);
-		if (page >= 0) {
-			*dma_handle = mem->device_base + (page << PAGE_SHIFT);
-			ret = mem->virt_base + (page << PAGE_SHIFT);
-			memset(ret, 0, size);
-			return ret;
-		}
-		if (mem->flags & DMA_MEMORY_EXCLUSIVE)
-			return NULL;
-	}
-
 	if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
 		gfp |= GFP_DMA;
 
@@ -63,87 +49,6 @@ void dma_free_coherent(struct device *de
 	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
 	int order = get_order(size);
 
-	if (mem && vaddr >= mem->virt_base && vaddr < (mem->virt_base + (mem->size << PAGE_SHIFT))) {
-		int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
-
-		bitmap_release_region(mem->bitmap, page, order);
-	} else
-		free_pages((unsigned long)vaddr, order);
-}
-
-int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-				dma_addr_t device_addr, size_t size, int flags)
-{
-	void __iomem *mem_base;
-	int pages = size >> PAGE_SHIFT;
-	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
-
-	if ((flags & (DMA_MEMORY_MAP | DMA_MEMORY_IO)) == 0)
-		goto out;
-	if (!size)
-		goto out;
-	if (dev->dma_mem)
-		goto out;
-
-	/* FIXME: this routine just ignores DMA_MEMORY_INCLUDES_CHILDREN */
-
-	mem_base = ioremap(bus_addr, size);
-	if (!mem_base)
-		goto out;
-
-	dev->dma_mem = kzalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
-	if (!dev->dma_mem)
-		goto iounmap_out;
-	dev->dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
-	if (!dev->dma_mem->bitmap)
-		goto free1_out;
-
-	dev->dma_mem->virt_base = mem_base;
-	dev->dma_mem->device_base = device_addr;
-	dev->dma_mem->size = pages;
-	dev->dma_mem->flags = flags;
-
-	if (flags & DMA_MEMORY_MAP)
-		return DMA_MEMORY_MAP;
-
-	return DMA_MEMORY_IO;
-
- free1_out:
-	kfree(dev->dma_mem);
- iounmap_out:
-	iounmap(mem_base);
- out:
-	return 0;
+	free_pages((unsigned long)vaddr, order);
 }
-EXPORT_SYMBOL(dma_declare_coherent_memory);
 
-void dma_release_declared_memory(struct device *dev)
-{
-	struct dma_coherent_mem *mem = dev->dma_mem;
-
-	if(!mem)
-		return;
-	dev->dma_mem = NULL;
-	iounmap(mem->virt_base);
-	kfree(mem->bitmap);
-	kfree(mem);
-}
-EXPORT_SYMBOL(dma_release_declared_memory);
-
-void *dma_mark_declared_memory_occupied(struct device *dev,
-					dma_addr_t device_addr, size_t size)
-{
-	struct dma_coherent_mem *mem = dev->dma_mem;
-	int pages = (size + (device_addr & ~PAGE_MASK) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	int pos, err;
-
-	if (!mem)
-		return ERR_PTR(-EINVAL);
-
-	pos = (device_addr - mem->device_base) >> PAGE_SHIFT;
-	err = bitmap_allocate_region(mem->bitmap, pos, get_order(pages));
-	if (err != 0)
-		return ERR_PTR(err);
-	return mem->virt_base + (pos << PAGE_SHIFT);
-}
-EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
Index: linux/arch/cris/Kconfig
===================================================================
--- linux.orig/arch/cris/Kconfig
+++ linux/arch/cris/Kconfig
@@ -47,11 +47,6 @@ config GENERIC_CALIBRATE_DELAY
 config NO_IOPORT
 	def_bool y
 
-config HAS_DMA_DECLARE_COHERENT
-	# looks weird, but it really depends on that
-	depends on ETRAX_CARDBUS
-	def_bool y
-
 config FORCE_MAX_ZONEORDER
 	int
 	default 6

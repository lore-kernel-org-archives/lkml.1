Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbYGRJa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbYGRJa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbYGRJar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:30:47 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:57414 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbYGRJaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:30:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=e7ScBs5xEQh3XxHwk75kBKNIRWwuiQX7htqYtufkx1nN9lMi2XiQ6t6JQxCwukR4dt
         c+0WwOoy4n/FMW4d1WFplGN5w6pZpy/9rgqd8d/ZbuQXI++AHQ95kP6OCNZmN5EAQrHP
         rFDR3E2dpvcG9L5RKVeyZ+LJqGlymj5jP6LJI=
Date: Fri, 18 Jul 2008 13:30:31 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/3] Sh: use generic per-device coherent dma allocator
References: <f19d3499bb927f743672952b035895441e6bcafd.1216373338.git.dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19d3499bb927f743672952b035895441e6bcafd.1216373338.git.dbaryshkov@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Message-ID: <488062c4.205c4e0a.118c.05a2@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/Kconfig              |    1 +
 arch/sh/mm/consistent.c      |   98 +----------------------------------------
 include/asm-sh/dma-mapping.h |    1 +
 3 files changed, 5 insertions(+), 95 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 9a854c8..893df17 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -10,6 +10,7 @@ config SUPERH
 	select EMBEDDED
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_GENERIC_DMA_COHERENT
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
diff --git a/arch/sh/mm/consistent.c b/arch/sh/mm/consistent.c
index d3c33fc..3095d95 100644
--- a/arch/sh/mm/consistent.c
+++ b/arch/sh/mm/consistent.c
@@ -27,21 +27,10 @@ void *dma_alloc_coherent(struct device *dev, size_t size,
 			   dma_addr_t *dma_handle, gfp_t gfp)
 {
 	void *ret, *ret_nocache;
-	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
 	int order = get_order(size);
 
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
+	if (dma_alloc_from_coherent(dev, size, dma_handle, &ret))
+		return ret;
 
 	ret = (void *)__get_free_pages(gfp, order);
 	if (!ret)
@@ -71,11 +60,7 @@ void dma_free_coherent(struct device *dev, size_t size,
 	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
 	int order = get_order(size);
 
-	if (mem && vaddr >= mem->virt_base && vaddr < (mem->virt_base + (mem->size << PAGE_SHIFT))) {
-		int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
-
-		bitmap_release_region(mem->bitmap, page, order);
-	} else {
+	if (!dma_release_from_coherent(dev, order, vaddr)) {
 		WARN_ON(irqs_disabled());	/* for portability */
 		BUG_ON(mem && mem->flags & DMA_MEMORY_EXCLUSIVE);
 		free_pages((unsigned long)phys_to_virt(dma_handle), order);
@@ -84,83 +69,6 @@ void dma_free_coherent(struct device *dev, size_t size,
 }
 EXPORT_SYMBOL(dma_free_coherent);
 
-int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-				dma_addr_t device_addr, size_t size, int flags)
-{
-	void __iomem *mem_base = NULL;
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
-	mem_base = ioremap_nocache(bus_addr, size);
-	if (!mem_base)
-		goto out;
-
-	dev->dma_mem = kmalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
-	if (!dev->dma_mem)
-		goto out;
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
- out:
-	if (mem_base)
-		iounmap(mem_base);
-	return 0;
-}
-EXPORT_SYMBOL(dma_declare_coherent_memory);
-
-void dma_release_declared_memory(struct device *dev)
-{
-	struct dma_coherent_mem *mem = dev->dma_mem;
-
-	if (!mem)
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
-
 void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		    enum dma_data_direction direction)
 {
diff --git a/include/asm-sh/dma-mapping.h b/include/asm-sh/dma-mapping.h
index 22cc419..5956c5d 100644
--- a/include/asm-sh/dma-mapping.h
+++ b/include/asm-sh/dma-mapping.h
@@ -5,6 +5,7 @@
 #include <linux/scatterlist.h>
 #include <asm/cacheflush.h>
 #include <asm/io.h>
+#include <asm-generic/dma-coherent.h>
 
 extern struct bus_type pci_bus_type;
 
-- 
1.5.6.2


-- 
With best wishes
Dmitry


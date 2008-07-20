Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbYGTLAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbYGTLAr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 07:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbYGTLAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 07:00:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:14489 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbYGTLAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 07:00:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=gqEMTlFprc2ot4aFOvKEVAQYAWvpCWhIwyhOWC5YbHIirwGQ3T/IKGEzJNZ/3OXQVn
         KdLuXosTf3MSOIaVrdhYMOuZeoQvMUQQZ8BPLjgebxI5HN9VGEQAYBfSxD6Nr4iIvHMX
         Z+4IaAuWIe7JdvQ4b6Rdz0wm2TUaI6kBLiZhQ=
Date: Sun, 20 Jul 2008 15:00:32 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [PATCH 1/2] Cris: convert to using generic dma-coherent mem
	allocator
References: <20080720105822.GA4075@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080720105822.GA4075@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Message-ID: <48831ad3.1e35440a.3d9f.ffffbd98@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/cris/arch-v32/drivers/Kconfig   |    1 +
 arch/cris/arch-v32/drivers/pci/dma.c |  106 +---------------------------------
 include/asm-cris/dma-mapping.h       |    2 +
 3 files changed, 6 insertions(+), 103 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/Kconfig b/arch/cris/arch-v32/drivers/Kconfig
index 2a92cb1..7a64fce 100644
--- a/arch/cris/arch-v32/drivers/Kconfig
+++ b/arch/cris/arch-v32/drivers/Kconfig
@@ -641,6 +641,7 @@ config PCI
        bool
        depends on ETRAX_CARDBUS
        default y
+       select HAVE_GENERIC_DMA_COHERENT
 
 config ETRAX_IOP_FW_LOAD
 	tristate "IO-processor hotplug firmware loading support"
diff --git a/arch/cris/arch-v32/drivers/pci/dma.c b/arch/cris/arch-v32/drivers/pci/dma.c
index e036465..fbe6595 100644
--- a/arch/cris/arch-v32/drivers/pci/dma.c
+++ b/arch/cris/arch-v32/drivers/pci/dma.c
@@ -15,35 +15,16 @@
 #include <linux/pci.h>
 #include <asm/io.h>
 
-struct dma_coherent_mem {
-	void		*virt_base;
-	u32		device_base;
-	int		size;
-	int		flags;
-	unsigned long	*bitmap;
-};
-
 void *dma_alloc_coherent(struct device *dev, size_t size,
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
+	if (dma_alloc_from_coherent(dev, size, dma_handle, &ret))
+		return ret;
 
 	if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
 		gfp |= GFP_DMA;
@@ -60,90 +41,9 @@ void *dma_alloc_coherent(struct device *dev, size_t size,
 void dma_free_coherent(struct device *dev, size_t size,
 			 void *vaddr, dma_addr_t dma_handle)
 {
-	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
 	int order = get_order(size);
 
-	if (mem && vaddr >= mem->virt_base && vaddr < (mem->virt_base + (mem->size << PAGE_SHIFT))) {
-		int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
-
-		bitmap_release_region(mem->bitmap, page, order);
-	} else
+	if (!dma_release_from_coherent(dev, order, vaddr))
 		free_pages((unsigned long)vaddr, order);
 }
 
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
-}
-EXPORT_SYMBOL(dma_declare_coherent_memory);
-
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
diff --git a/include/asm-cris/dma-mapping.h b/include/asm-cris/dma-mapping.h
index edc8d1b..4f58670 100644
--- a/include/asm-cris/dma-mapping.h
+++ b/include/asm-cris/dma-mapping.h
@@ -14,6 +14,8 @@
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
 #ifdef CONFIG_PCI
+#include <asm-generic/dma-coherent.h>
+
 void *dma_alloc_coherent(struct device *dev, size_t size,
 			   dma_addr_t *dma_handle, gfp_t flag);
 
-- 
1.5.6.2


-- 
With best wishes
Dmitry


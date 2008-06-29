Return-Path: <linux-kernel-owner+w=401wt.eu-S1759889AbYF2KUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889AbYF2KUL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 06:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbYF2KT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 06:19:58 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:13344 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbYF2KT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 06:19:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=TcJLnSe3yT3SyEQs35c16M/SfR5ML6Msy5+tuBaAh32LhX2cekf43HtCa7rFCY26ji
         8V23r5B//OaCHq/w2xFAaTJpF4wRmgdD95FDXWfTKoK8ORCK295dEypxamSVbSKGVt8F
         ra6Pdsy59NxTpl0WlqFpgSTdcH8cm68hXnGmQ=
Date: Sun, 29 Jun 2008 14:19:31 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/2] x86: use generic per-device dma coherent allocator
Message-ID: <20080629101931.GA23375@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 arch/x86/Kconfig              |    1 +
 arch/x86/kernel/pci-dma.c     |  122 +----------------------------------------
 include/asm-x86/dma-mapping.h |   22 +-------
 3 files changed, 4 insertions(+), 141 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e0edaaa..9d4714e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -25,6 +25,7 @@ config X86
 	select HAVE_KRETPROBES
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
+	select HAVE_GENERIC_DMA_COHERENT if X86_32
 
 config ARCH_DEFCONFIG
 	string
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index dc00a13..b75c81a 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -197,124 +197,6 @@ static __init int iommu_setup(char *p)
 }
 early_param("iommu", iommu_setup);
 
-#ifdef CONFIG_X86_32
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
-	mem_base = ioremap(bus_addr, size);
-	if (!mem_base)
-		goto out;
-
-	dev->dma_mem = kzalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
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
-	int pos, err;
-	int pages = (size + (device_addr & ~PAGE_MASK) + PAGE_SIZE - 1);
-
-	pages >>= PAGE_SHIFT;
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
-static int dma_alloc_from_coherent_mem(struct device *dev, ssize_t size,
-				       dma_addr_t *dma_handle, void **ret)
-{
-	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
-	int order = get_order(size);
-
-	if (mem) {
-		int page = bitmap_find_free_region(mem->bitmap, mem->size,
-						     order);
-		if (page >= 0) {
-			*dma_handle = mem->device_base + (page << PAGE_SHIFT);
-			*ret = mem->virt_base + (page << PAGE_SHIFT);
-			memset(*ret, 0, size);
-		}
-		if (mem->flags & DMA_MEMORY_EXCLUSIVE)
-			*ret = NULL;
-	}
-	return (mem != NULL);
-}
-
-static int dma_release_coherent(struct device *dev, int order, void *vaddr)
-{
-	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
-
-	if (mem && vaddr >= mem->virt_base && vaddr <
-		   (mem->virt_base + (mem->size << PAGE_SHIFT))) {
-		int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
-
-		bitmap_release_region(mem->bitmap, page, order);
-		return 1;
-	}
-	return 0;
-}
-#else
-#define dma_alloc_from_coherent_mem(dev, size, handle, ret) (0)
-#define dma_release_coherent(dev, order, vaddr) (0)
-#endif /* CONFIG_X86_32 */
-
 int dma_supported(struct device *dev, u64 mask)
 {
 #ifdef CONFIG_PCI
@@ -383,7 +265,7 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	/* ignore region specifiers */
 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
 
-	if (dma_alloc_from_coherent_mem(dev, size, dma_handle, &memory))
+	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
 		return memory;
 
 	if (!dev) {
@@ -486,7 +368,7 @@ void dma_free_coherent(struct device *dev, size_t size,
 {
 	int order = get_order(size);
 	WARN_ON(irqs_disabled());	/* for portability */
-	if (dma_release_coherent(dev, order, vaddr))
+	if (dma_release_from_coherent(dev, order, vaddr))
 		return;
 	if (dma_ops->unmap_single)
 		dma_ops->unmap_single(dev, bus, size, 0);
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index a1a4dc7..c68f360 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -213,25 +213,5 @@ static inline int dma_get_cache_alignment(void)
 
 #define dma_is_consistent(d, h)	(1)
 
-#ifdef CONFIG_X86_32
-#  define ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
-struct dma_coherent_mem {
-	void		*virt_base;
-	u32		device_base;
-	int		size;
-	int		flags;
-	unsigned long	*bitmap;
-};
-
-extern int
-dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-			    dma_addr_t device_addr, size_t size, int flags);
-
-extern void
-dma_release_declared_memory(struct device *dev);
-
-extern void *
-dma_mark_declared_memory_occupied(struct device *dev,
-				  dma_addr_t device_addr, size_t size);
-#endif /* CONFIG_X86_32 */
+#include <asm-generic/dma-coherent.h>
 #endif
-- 
1.5.5.4


-- 
With best wishes
Dmitry


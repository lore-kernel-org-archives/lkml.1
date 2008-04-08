Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbYDHQcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbYDHQcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758723AbYDHQ2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:28:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758718AbYDHQ2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:28:36 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 15/28] x86: move dma_coherent functions to pci-dma.c
Date: Tue,  8 Apr 2008 13:20:57 -0300
Message-Id: <12076717701138-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are placed in an ifdef, since they are i386 specific
the structure definition goes to dma-mapping.h.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-dma.c     |   81 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/pci-dma_32.c  |   85 -----------------------------------------
 include/asm-x86/dma-mapping.h |    8 ++++
 3 files changed, 89 insertions(+), 85 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index e04f42c..d06d8df 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -47,6 +47,87 @@ int dma_set_mask(struct device *dev, u64 mask)
 }
 EXPORT_SYMBOL(dma_set_mask);
 
+#ifdef CONFIG_X86_32
+int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
+				dma_addr_t device_addr, size_t size, int flags)
+{
+	void __iomem *mem_base = NULL;
+	int pages = size >> PAGE_SHIFT;
+	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
+
+	if ((flags & (DMA_MEMORY_MAP | DMA_MEMORY_IO)) == 0)
+		goto out;
+	if (!size)
+		goto out;
+	if (dev->dma_mem)
+		goto out;
+
+	/* FIXME: this routine just ignores DMA_MEMORY_INCLUDES_CHILDREN */
+
+	mem_base = ioremap(bus_addr, size);
+	if (!mem_base)
+		goto out;
+
+	dev->dma_mem = kzalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
+	if (!dev->dma_mem)
+		goto out;
+	dev->dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
+	if (!dev->dma_mem->bitmap)
+		goto free1_out;
+
+	dev->dma_mem->virt_base = mem_base;
+	dev->dma_mem->device_base = device_addr;
+	dev->dma_mem->size = pages;
+	dev->dma_mem->flags = flags;
+
+	if (flags & DMA_MEMORY_MAP)
+		return DMA_MEMORY_MAP;
+
+	return DMA_MEMORY_IO;
+
+ free1_out:
+	kfree(dev->dma_mem);
+ out:
+	if (mem_base)
+		iounmap(mem_base);
+	return 0;
+}
+EXPORT_SYMBOL(dma_declare_coherent_memory);
+
+void dma_release_declared_memory(struct device *dev)
+{
+	struct dma_coherent_mem *mem = dev->dma_mem;
+
+	if (!mem)
+		return;
+	dev->dma_mem = NULL;
+	iounmap(mem->virt_base);
+	kfree(mem->bitmap);
+	kfree(mem);
+}
+EXPORT_SYMBOL(dma_release_declared_memory);
+
+void *dma_mark_declared_memory_occupied(struct device *dev,
+					dma_addr_t device_addr, size_t size)
+{
+	struct dma_coherent_mem *mem = dev->dma_mem;
+	int pos, err;
+	int pages = (size + (device_addr & ~PAGE_MASK) + PAGE_SIZE - 1);
+
+	pages >>= PAGE_SHIFT;
+
+	if (!mem)
+		return ERR_PTR(-EINVAL);
+
+	pos = (device_addr - mem->device_base) >> PAGE_SHIFT;
+	err = bitmap_allocate_region(mem->bitmap, pos, get_order(pages));
+	if (err != 0)
+		return ERR_PTR(err);
+	return mem->virt_base + (pos << PAGE_SHIFT);
+}
+EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
+#endif /* CONFIG_X86_32 */
+
 int dma_supported(struct device *dev, u64 mask)
 {
 #ifdef CONFIG_PCI
diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
index eea52df..818d95e 100644
--- a/arch/x86/kernel/pci-dma_32.c
+++ b/arch/x86/kernel/pci-dma_32.c
@@ -18,14 +18,6 @@
 dma_addr_t bad_dma_address __read_mostly = 0x0;
 EXPORT_SYMBOL(bad_dma_address);
 
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
@@ -76,80 +68,3 @@ void dma_free_coherent(struct device *dev, size_t size,
 		free_pages((unsigned long)vaddr, order);
 }
 EXPORT_SYMBOL(dma_free_coherent);
-
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
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 7580736..a1a4dc7 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -215,6 +215,14 @@ static inline int dma_get_cache_alignment(void)
 
 #ifdef CONFIG_X86_32
 #  define ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
+struct dma_coherent_mem {
+	void		*virt_base;
+	u32		device_base;
+	int		size;
+	int		flags;
+	unsigned long	*bitmap;
+};
+
 extern int
 dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
 			    dma_addr_t device_addr, size_t size, int flags);
-- 
1.5.0.6


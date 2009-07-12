Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbZGLNpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbZGLNpT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 09:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbZGLNpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 09:45:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:13126 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZGLNpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 09:45:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mM0tneJ+455LOdQrZXIEe4/o5aEsllN6TESFqf/tJWeaZ73mANWhiVLS6t0fPXngQJ
         95KF3UnGYgcvYdHo53o3wxqPUMZ73UjygYE4jy1iNYqGvoNh3DLPR1877aS7IQgc8aSS
         CtGe6Pp7pBRcEy4vbg2hgZfCIdRcBeMTy45Og=
From: tom.leiming@gmail.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
       akpm@linux-foundation.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] driver-core:move dma-coherent.c from kernel to driver/base
Date: Sun, 12 Jul 2009 21:44:55 +0800
Message-Id: <1247406295-5326-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

Placing dma-coherent.c in driver/base is better than in kernel,
since it contains code to do per-device coherent dma memory
handling.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/base/Makefile       |    1 +
 drivers/base/dma-coherent.c |  176 +++++++++++++++++++++++++++++++++++++++++++
 kernel/Makefile             |    1 -
 kernel/dma-coherent.c       |  176 -------------------------------------------
 4 files changed, 177 insertions(+), 177 deletions(-)
 create mode 100644 drivers/base/dma-coherent.c
 delete mode 100644 kernel/dma-coherent.c

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 68b225a..c12c7f2 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -7,6 +7,7 @@ obj-y			:= core.o sys.o bus.o dd.o \
 obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
+obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
 obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
diff --git a/drivers/base/dma-coherent.c b/drivers/base/dma-coherent.c
new file mode 100644
index 0000000..962a3b5
--- /dev/null
+++ b/drivers/base/dma-coherent.c
@@ -0,0 +1,176 @@
+/*
+ * Coherent per-device memory handling.
+ * Borrowed from i386
+ */
+#include <linux/kernel.h>
+#include <linux/dma-mapping.h>
+
+struct dma_coherent_mem {
+	void		*virt_base;
+	u32		device_base;
+	int		size;
+	int		flags;
+	unsigned long	*bitmap;
+};
+
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
+
+	size += device_addr & ~PAGE_MASK;
+
+	if (!mem)
+		return ERR_PTR(-EINVAL);
+
+	pos = (device_addr - mem->device_base) >> PAGE_SHIFT;
+	err = bitmap_allocate_region(mem->bitmap, pos, get_order(size));
+	if (err != 0)
+		return ERR_PTR(err);
+	return mem->virt_base + (pos << PAGE_SHIFT);
+}
+EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
+
+/**
+ * dma_alloc_from_coherent() - try to allocate memory from the per-device coherent area
+ *
+ * @dev:	device from which we allocate memory
+ * @size:	size of requested memory area
+ * @dma_handle:	This will be filled with the correct dma handle
+ * @ret:	This pointer will be filled with the virtual address
+ *		to allocated area.
+ *
+ * This function should be only called from per-arch dma_alloc_coherent()
+ * to support allocation from per-device coherent memory pools.
+ *
+ * Returns 0 if dma_alloc_coherent should continue with allocating from
+ * generic memory areas, or !0 if dma_alloc_coherent should return @ret.
+ */
+int dma_alloc_from_coherent(struct device *dev, ssize_t size,
+				       dma_addr_t *dma_handle, void **ret)
+{
+	struct dma_coherent_mem *mem;
+	int order = get_order(size);
+	int pageno;
+
+	if (!dev)
+		return 0;
+	mem = dev->dma_mem;
+	if (!mem)
+		return 0;
+
+	*ret = NULL;
+
+	if (unlikely(size > (mem->size << PAGE_SHIFT)))
+		goto err;
+
+	pageno = bitmap_find_free_region(mem->bitmap, mem->size, order);
+	if (unlikely(pageno < 0))
+		goto err;
+
+	/*
+	 * Memory was found in the per-device area.
+	 */
+	*dma_handle = mem->device_base + (pageno << PAGE_SHIFT);
+	*ret = mem->virt_base + (pageno << PAGE_SHIFT);
+	memset(*ret, 0, size);
+
+	return 1;
+
+err:
+	/*
+	 * In the case where the allocation can not be satisfied from the
+	 * per-device area, try to fall back to generic memory if the
+	 * constraints allow it.
+	 */
+	return mem->flags & DMA_MEMORY_EXCLUSIVE;
+}
+EXPORT_SYMBOL(dma_alloc_from_coherent);
+
+/**
+ * dma_release_from_coherent() - try to free the memory allocated from per-device coherent memory pool
+ * @dev:	device from which the memory was allocated
+ * @order:	the order of pages allocated
+ * @vaddr:	virtual address of allocated pages
+ *
+ * This checks whether the memory was allocated from the per-device
+ * coherent memory pool and if so, releases that memory.
+ *
+ * Returns 1 if we correctly released the memory, or 0 if
+ * dma_release_coherent() should proceed with releasing memory from
+ * generic pools.
+ */
+int dma_release_from_coherent(struct device *dev, int order, void *vaddr)
+{
+	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
+
+	if (mem && vaddr >= mem->virt_base && vaddr <
+		   (mem->virt_base + (mem->size << PAGE_SHIFT))) {
+		int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
+
+		bitmap_release_region(mem->bitmap, page, order);
+		return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(dma_release_from_coherent);
diff --git a/kernel/Makefile b/kernel/Makefile
index a00eb1c..8864a00 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -92,7 +92,6 @@ obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_MARKERS) += marker.o
 obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
-obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_X86_DS) += trace/
diff --git a/kernel/dma-coherent.c b/kernel/dma-coherent.c
deleted file mode 100644
index 962a3b5..0000000
--- a/kernel/dma-coherent.c
+++ /dev/null
@@ -1,176 +0,0 @@
-/*
- * Coherent per-device memory handling.
- * Borrowed from i386
- */
-#include <linux/kernel.h>
-#include <linux/dma-mapping.h>
-
-struct dma_coherent_mem {
-	void		*virt_base;
-	u32		device_base;
-	int		size;
-	int		flags;
-	unsigned long	*bitmap;
-};
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
-
-	size += device_addr & ~PAGE_MASK;
-
-	if (!mem)
-		return ERR_PTR(-EINVAL);
-
-	pos = (device_addr - mem->device_base) >> PAGE_SHIFT;
-	err = bitmap_allocate_region(mem->bitmap, pos, get_order(size));
-	if (err != 0)
-		return ERR_PTR(err);
-	return mem->virt_base + (pos << PAGE_SHIFT);
-}
-EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
-
-/**
- * dma_alloc_from_coherent() - try to allocate memory from the per-device coherent area
- *
- * @dev:	device from which we allocate memory
- * @size:	size of requested memory area
- * @dma_handle:	This will be filled with the correct dma handle
- * @ret:	This pointer will be filled with the virtual address
- *		to allocated area.
- *
- * This function should be only called from per-arch dma_alloc_coherent()
- * to support allocation from per-device coherent memory pools.
- *
- * Returns 0 if dma_alloc_coherent should continue with allocating from
- * generic memory areas, or !0 if dma_alloc_coherent should return @ret.
- */
-int dma_alloc_from_coherent(struct device *dev, ssize_t size,
-				       dma_addr_t *dma_handle, void **ret)
-{
-	struct dma_coherent_mem *mem;
-	int order = get_order(size);
-	int pageno;
-
-	if (!dev)
-		return 0;
-	mem = dev->dma_mem;
-	if (!mem)
-		return 0;
-
-	*ret = NULL;
-
-	if (unlikely(size > (mem->size << PAGE_SHIFT)))
-		goto err;
-
-	pageno = bitmap_find_free_region(mem->bitmap, mem->size, order);
-	if (unlikely(pageno < 0))
-		goto err;
-
-	/*
-	 * Memory was found in the per-device area.
-	 */
-	*dma_handle = mem->device_base + (pageno << PAGE_SHIFT);
-	*ret = mem->virt_base + (pageno << PAGE_SHIFT);
-	memset(*ret, 0, size);
-
-	return 1;
-
-err:
-	/*
-	 * In the case where the allocation can not be satisfied from the
-	 * per-device area, try to fall back to generic memory if the
-	 * constraints allow it.
-	 */
-	return mem->flags & DMA_MEMORY_EXCLUSIVE;
-}
-EXPORT_SYMBOL(dma_alloc_from_coherent);
-
-/**
- * dma_release_from_coherent() - try to free the memory allocated from per-device coherent memory pool
- * @dev:	device from which the memory was allocated
- * @order:	the order of pages allocated
- * @vaddr:	virtual address of allocated pages
- *
- * This checks whether the memory was allocated from the per-device
- * coherent memory pool and if so, releases that memory.
- *
- * Returns 1 if we correctly released the memory, or 0 if
- * dma_release_coherent() should proceed with releasing memory from
- * generic pools.
- */
-int dma_release_from_coherent(struct device *dev, int order, void *vaddr)
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
-EXPORT_SYMBOL(dma_release_from_coherent);
-- 
1.6.0.GIT


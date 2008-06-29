Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbYF2KTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbYF2KTW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 06:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbYF2KTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 06:19:14 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:12934 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbYF2KTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 06:19:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=bRrrpdsHy3nLRnAt+eyLRcTYz500XEUqH/6mLsjvOUJ6LOoHGERZKhHuWomJ7jRT8C
         vgxUt+dvWdNBMhAfEd6TsKmHat434spqX2OguSF+qVGUOMIPbOm5gg8xjId7OITa+ied
         +aR9IqemfrW2FtYwk3yZUYDAKBFr6gd5rVNy4=
Date: Sun, 29 Jun 2008 14:18:46 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/2] Generic per-device coherent dma allocator
Message-ID: <20080629101846.GA23362@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently x86_32, sh and cris-v32 provide per-device coherent dma
memory allocator.
However their implementation is nearly identical. Refactor out
common code to be reused by them.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 include/asm-generic/dma-coherent.h |   32 +++++++++
 init/Kconfig                       |    4 +
 kernel/Makefile                    |    1 +
 kernel/dma-coherent.c              |  127 ++++++++++++++++++++++++++++++++++++
 4 files changed, 164 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/dma-coherent.h
 create mode 100644 kernel/dma-coherent.c

diff --git a/include/asm-generic/dma-coherent.h b/include/asm-generic/dma-coherent.h
new file mode 100644
index 0000000..85a3ffa
--- /dev/null
+++ b/include/asm-generic/dma-coherent.h
@@ -0,0 +1,32 @@
+#ifndef DMA_COHERENT_H
+#define DMA_COHERENT_H
+
+#ifdef CONFIG_HAVE_GENERIC_DMA_COHERENT
+/*
+ * These two functions are only for dma allocator.
+ * Don't use them in device drivers.
+ */
+int dma_alloc_from_coherent(struct device *dev, ssize_t size,
+				       dma_addr_t *dma_handle, void **ret);
+int dma_release_from_coherent(struct device *dev, int order, void *vaddr);
+
+/*
+ * Standard interface
+ */
+#define ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
+extern int
+dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
+			    dma_addr_t device_addr, size_t size, int flags);
+
+extern void
+dma_release_declared_memory(struct device *dev);
+
+extern void *
+dma_mark_declared_memory_occupied(struct device *dev,
+				  dma_addr_t device_addr, size_t size);
+#else
+#define dma_alloc_from_coherent(dev, size, handle, ret) (0)
+#define dma_release_from_coherent(dev, order, vaddr) (0)
+#endif
+
+#endif
diff --git a/init/Kconfig b/init/Kconfig
index 6199d11..63cdbd8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -802,6 +802,10 @@ config PROC_PAGE_MONITOR
 
 endmenu		# General setup
 
+config HAVE_GENERIC_DMA_COHERENT
+	bool
+	default n
+
 config SLABINFO
 	bool
 	depends on PROC_FS
diff --git a/kernel/Makefile b/kernel/Makefile
index 1c9938a..9e287d8 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_MARKERS) += marker.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
+obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/dma-coherent.c b/kernel/dma-coherent.c
new file mode 100644
index 0000000..89a554c
--- /dev/null
+++ b/kernel/dma-coherent.c
@@ -0,0 +1,127 @@
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
+
+int dma_alloc_from_coherent(struct device *dev, ssize_t size,
+				       dma_addr_t *dma_handle, void **ret)
+{
+	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
+	int order = get_order(size);
+
+	if (mem) {
+		int page = bitmap_find_free_region(mem->bitmap, mem->size,
+						     order);
+		if (page >= 0) {
+			*dma_handle = mem->device_base + (page << PAGE_SHIFT);
+			*ret = mem->virt_base + (page << PAGE_SHIFT);
+			memset(*ret, 0, size);
+		}
+		if (mem->flags & DMA_MEMORY_EXCLUSIVE)
+			*ret = NULL;
+	}
+	return (mem != NULL);
+}
+
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
-- 
1.5.5.4


-- 
With best wishes
Dmitry


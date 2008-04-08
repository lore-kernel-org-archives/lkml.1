Return-Path: <linux-kernel-owner+w=401wt.eu-S1761312AbYDHQfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761312AbYDHQfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758346AbYDHQ3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:29:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759401AbYDHQ3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:29:53 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 28/28] x86: integrate pci-dma.c
Date: Tue,  8 Apr 2008 13:21:10 -0300
Message-Id: <12076718502146-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in pci-dma_{32,64}.c are now sufficiently
close to each other. We merge them in pci-dma.c.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/Makefile     |    2 +-
 arch/x86/kernel/pci-dma.c    |  175 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/pci-dma_32.c |  173 -----------------------------------------
 arch/x86/kernel/pci-dma_64.c |  154 -------------------------------------
 4 files changed, 176 insertions(+), 328 deletions(-)
 delete mode 100644 arch/x86/kernel/pci-dma_32.c
 delete mode 100644 arch/x86/kernel/pci-dma_64.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index b2a1358..423e1c4 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -23,7 +23,7 @@ obj-y			+= setup_$(BITS).o i8259_$(BITS).o setup.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o setup64.o
-obj-y			+= pci-dma_$(BITS).o  bootflag.o e820_$(BITS).o
+obj-y			+= bootflag.o e820_$(BITS).o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index d6734ed..5cc8d5a 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -38,6 +38,15 @@ EXPORT_SYMBOL(iommu_bio_merge);
 dma_addr_t bad_dma_address __read_mostly = 0;
 EXPORT_SYMBOL(bad_dma_address);
 
+/* Dummy device used for NULL arguments (normally ISA). Better would
+   be probably a smaller DMA mask, but this is bug-to-bug compatible
+   to older i386. */
+struct device fallback_dev = {
+	.bus_id = "fallback device",
+	.coherent_dma_mask = DMA_32BIT_MASK,
+	.dma_mask = &fallback_dev.coherent_dma_mask,
+};
+
 int dma_set_mask(struct device *dev, u64 mask)
 {
 	if (!dev->dma_mask || !dma_supported(dev, mask))
@@ -128,6 +137,43 @@ void *dma_mark_declared_memory_occupied(struct device *dev,
 	return mem->virt_base + (pos << PAGE_SHIFT);
 }
 EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
+
+static int dma_alloc_from_coherent_mem(struct device *dev, ssize_t size,
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
+static int dma_release_coherent(struct device *dev, int order, void *vaddr)
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
+#else
+#define dma_alloc_from_coherent_mem(dev, size, handle, ret) (0)
+#define dma_release_coherent(dev, order, vaddr) (0)
 #endif /* CONFIG_X86_32 */
 
 int dma_supported(struct device *dev, u64 mask)
@@ -171,6 +217,135 @@ int dma_supported(struct device *dev, u64 mask)
 }
 EXPORT_SYMBOL(dma_supported);
 
+/* Allocate DMA memory on node near device */
+noinline struct page *
+dma_alloc_pages(struct device *dev, gfp_t gfp, unsigned order)
+{
+	int node;
+
+	node = dev_to_node(dev);
+
+	return alloc_pages_node(node, gfp, order);
+}
+
+/*
+ * Allocate memory for a coherent mapping.
+ */
+void *
+dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
+		   gfp_t gfp)
+{
+	void *memory = NULL;
+	struct page *page;
+	unsigned long dma_mask = 0;
+	dma_addr_t bus;
+
+	/* ignore region specifiers */
+	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+
+	if (dma_alloc_from_coherent_mem(dev, size, dma_handle, &memory))
+		return memory;
+
+	if (!dev)
+		dev = &fallback_dev;
+	dma_mask = dev->coherent_dma_mask;
+	if (dma_mask == 0)
+		dma_mask = DMA_32BIT_MASK;
+
+	/* Device not DMA able */
+	if (dev->dma_mask == NULL)
+		return NULL;
+
+	/* Don't invoke OOM killer */
+	gfp |= __GFP_NORETRY;
+
+#ifdef CONFIG_X86_64
+	/* Why <=? Even when the mask is smaller than 4GB it is often
+	   larger than 16MB and in this case we have a chance of
+	   finding fitting memory in the next higher zone first. If
+	   not retry with true GFP_DMA. -AK */
+	if (dma_mask <= DMA_32BIT_MASK)
+		gfp |= GFP_DMA32;
+#endif
+
+ again:
+	page = dma_alloc_pages(dev, gfp, get_order(size));
+	if (page == NULL)
+		return NULL;
+
+	{
+		int high, mmu;
+		bus = page_to_phys(page);
+		memory = page_address(page);
+		high = (bus + size) >= dma_mask;
+		mmu = high;
+		if (force_iommu && !(gfp & GFP_DMA))
+			mmu = 1;
+		else if (high) {
+			free_pages((unsigned long)memory,
+				   get_order(size));
+
+			/* Don't use the 16MB ZONE_DMA unless absolutely
+			   needed. It's better to use remapping first. */
+			if (dma_mask < DMA_32BIT_MASK && !(gfp & GFP_DMA)) {
+				gfp = (gfp & ~GFP_DMA32) | GFP_DMA;
+				goto again;
+			}
+
+			/* Let low level make its own zone decisions */
+			gfp &= ~(GFP_DMA32|GFP_DMA);
+
+			if (dma_ops->alloc_coherent)
+				return dma_ops->alloc_coherent(dev, size,
+							   dma_handle, gfp);
+			return NULL;
+		}
+
+		memset(memory, 0, size);
+		if (!mmu) {
+			*dma_handle = bus;
+			return memory;
+		}
+	}
+
+	if (dma_ops->alloc_coherent) {
+		free_pages((unsigned long)memory, get_order(size));
+		gfp &= ~(GFP_DMA|GFP_DMA32);
+		return dma_ops->alloc_coherent(dev, size, dma_handle, gfp);
+	}
+
+	if (dma_ops->map_simple) {
+		*dma_handle = dma_ops->map_simple(dev, virt_to_phys(memory),
+					      size,
+					      PCI_DMA_BIDIRECTIONAL);
+		if (*dma_handle != bad_dma_address)
+			return memory;
+	}
+
+	if (panic_on_overflow)
+		panic("dma_alloc_coherent: IOMMU overflow by %lu bytes\n",
+		      (unsigned long)size);
+	free_pages((unsigned long)memory, get_order(size));
+	return NULL;
+}
+EXPORT_SYMBOL(dma_alloc_coherent);
+
+/*
+ * Unmap coherent memory.
+ * The caller must ensure that the device has finished accessing the mapping.
+ */
+void dma_free_coherent(struct device *dev, size_t size,
+			 void *vaddr, dma_addr_t bus)
+{
+	int order = get_order(size);
+	WARN_ON(irqs_disabled());	/* for portability */
+	if (dma_release_coherent(dev, order, vaddr))
+		return;
+	if (dma_ops->unmap_single)
+		dma_ops->unmap_single(dev, bus, size, 0);
+	free_pages((unsigned long)vaddr, order);
+}
+EXPORT_SYMBOL(dma_free_coherent);
 
 static int __init pci_iommu_init(void)
 {
diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
deleted file mode 100644
index d2f7074..0000000
--- a/arch/x86/kernel/pci-dma_32.c
+++ /dev/null
@@ -1,173 +0,0 @@
-/*
- * Dynamic DMA mapping support.
- *
- * On i386 there is no hardware dynamic DMA address translation,
- * so consistent alloc/free are merely page allocation/freeing.
- * The rest of the dynamic DMA mapping interface is implemented
- * in asm/pci.h.
- */
-
-#include <linux/types.h>
-#include <linux/mm.h>
-#include <linux/string.h>
-#include <linux/pci.h>
-#include <linux/module.h>
-#include <asm/io.h>
-
-/* Dummy device used for NULL arguments (normally ISA). Better would
-   be probably a smaller DMA mask, but this is bug-to-bug compatible
-   to i386. */
-struct device fallback_dev = {
-	.bus_id = "fallback device",
-	.coherent_dma_mask = DMA_32BIT_MASK,
-	.dma_mask = &fallback_dev.coherent_dma_mask,
-};
-
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
-
-/* Allocate DMA memory on node near device */
-noinline struct page *
-dma_alloc_pages(struct device *dev, gfp_t gfp, unsigned order)
-{
-	int node;
-
-	node = dev_to_node(dev);
-
-	return alloc_pages_node(node, gfp, order);
-}
-
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			   dma_addr_t *dma_handle, gfp_t gfp)
-{
-	void *ret = NULL;
-	struct page *page;
-	dma_addr_t bus;
-	int order = get_order(size);
-	unsigned long dma_mask = 0;
-
-	/* ignore region specifiers */
-	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
-
-	if (dma_alloc_from_coherent_mem(dev, size, dma_handle, &ret))
-		return ret;
-
-	if (!dev)
-		dev = &fallback_dev;
-
-	dma_mask = dev->coherent_dma_mask;
-	if (dma_mask == 0)
-		dma_mask = DMA_32BIT_MASK;
-
-	if (dev->dma_mask == NULL)
-		return NULL;
-
-	/* Don't invoke OOM killer */
-	gfp |= __GFP_NORETRY;
-again:
-	page = dma_alloc_pages(dev, gfp, order);
-	if (page == NULL)
-		return NULL;
-
-	{
-		int high, mmu;
-		bus = page_to_phys(page);
-		ret = page_address(page);
-		high = (bus + size) >= dma_mask;
-		mmu = high;
-		if (force_iommu && !(gfp & GFP_DMA))
-			mmu = 1;
-		else if (high) {
-			free_pages((unsigned long)ret,
-				   get_order(size));
-
-			/* Don't use the 16MB ZONE_DMA unless absolutely
-			   needed. It's better to use remapping first. */
-			if (dma_mask < DMA_32BIT_MASK && !(gfp & GFP_DMA)) {
-				gfp = (gfp & ~GFP_DMA32) | GFP_DMA;
-				goto again;
-			}
-
-			/* Let low level make its own zone decisions */
-			gfp &= ~(GFP_DMA32|GFP_DMA);
-
-			if (dma_ops->alloc_coherent)
-				return dma_ops->alloc_coherent(dev, size,
-							   dma_handle, gfp);
-			return NULL;
-
-		}
-		memset(ret, 0, size);
-		if (!mmu) {
-			*dma_handle = bus;
-			return ret;
-		}
-	}
-
-	if (dma_ops->alloc_coherent) {
-		free_pages((unsigned long)ret, get_order(size));
-		gfp &= ~(GFP_DMA|GFP_DMA32);
-		return dma_ops->alloc_coherent(dev, size, dma_handle, gfp);
-	}
-
-	if (dma_ops->map_simple) {
-		*dma_handle = dma_ops->map_simple(dev, virt_to_phys(ret),
-					      size,
-					      PCI_DMA_BIDIRECTIONAL);
-		if (*dma_handle != bad_dma_address)
-			return ret;
-	}
-
-	if (panic_on_overflow)
-		panic("dma_alloc_coherent: IOMMU overflow by %lu bytes\n",
-		      (unsigned long)size);
-	free_pages((unsigned long)ret, get_order(size));
-	return NULL;
-}
-EXPORT_SYMBOL(dma_alloc_coherent);
-
-void dma_free_coherent(struct device *dev, size_t size,
-			 void *vaddr, dma_addr_t dma_handle)
-{
-	int order = get_order(size);
-
-	WARN_ON(irqs_disabled());	/* for portability */
-	if (dma_release_coherent(dev, order, vaddr))
-		return;
-	if (dma_ops->unmap_single)
-		dma_ops->unmap_single(dev, dma_handle, size, 0);
-	free_pages((unsigned long)vaddr, order);
-}
-EXPORT_SYMBOL(dma_free_coherent);
diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
deleted file mode 100644
index 596c8c8..0000000
--- a/arch/x86/kernel/pci-dma_64.c
+++ /dev/null
@@ -1,154 +0,0 @@
-/*
- * Dynamic DMA mapping support.
- */
-
-#include <linux/types.h>
-#include <linux/mm.h>
-#include <linux/string.h>
-#include <linux/pci.h>
-#include <linux/module.h>
-#include <linux/dmar.h>
-#include <linux/bootmem.h>
-#include <asm/proto.h>
-#include <asm/io.h>
-#include <asm/gart.h>
-#include <asm/calgary.h>
-
-
-/* Dummy device used for NULL arguments (normally ISA). Better would
-   be probably a smaller DMA mask, but this is bug-to-bug compatible
-   to i386. */
-struct device fallback_dev = {
-	.bus_id = "fallback device",
-	.coherent_dma_mask = DMA_32BIT_MASK,
-	.dma_mask = &fallback_dev.coherent_dma_mask,
-};
-
-/* Allocate DMA memory on node near device */
-noinline static void *
-dma_alloc_pages(struct device *dev, gfp_t gfp, unsigned order)
-{
-	int node;
-
-	node = dev_to_node(dev);
-
-	return alloc_pages_node(node, gfp, order);
-}
-
-#define dma_alloc_from_coherent_mem(dev, size, handle, ret) (0)
-#define dma_release_coherent(dev, order, vaddr) (0)
-/*
- * Allocate memory for a coherent mapping.
- */
-void *
-dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
-		   gfp_t gfp)
-{
-	void *memory;
-	struct page *page;
-	unsigned long dma_mask = 0;
-	u64 bus;
-
-	/* ignore region specifiers */
-	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
-
-	if (dma_alloc_from_coherent_mem(dev, size, dma_handle, &memory))
-		return memory;
-
-	if (!dev)
-		dev = &fallback_dev;
-	dma_mask = dev->coherent_dma_mask;
-	if (dma_mask == 0)
-		dma_mask = DMA_32BIT_MASK;
-
-	/* Device not DMA able */
-	if (dev->dma_mask == NULL)
-		return NULL;
-
-	/* Don't invoke OOM killer */
-	gfp |= __GFP_NORETRY;
-
-	/* Why <=? Even when the mask is smaller than 4GB it is often
-	   larger than 16MB and in this case we have a chance of
-	   finding fitting memory in the next higher zone first. If
-	   not retry with true GFP_DMA. -AK */
-	if (dma_mask <= DMA_32BIT_MASK)
-		gfp |= GFP_DMA32;
-
- again:
-	page = dma_alloc_pages(dev, gfp, get_order(size));
-	if (page == NULL)
-		return NULL;
-
-	{
-		int high, mmu;
-		bus = page_to_phys(page);
-		memory = page_address(page);
-	        high = (bus + size) >= dma_mask;
-		mmu = high;
-		if (force_iommu && !(gfp & GFP_DMA))
-			mmu = 1;
-		else if (high) {
-			free_pages((unsigned long)memory,
-				   get_order(size));
-
-			/* Don't use the 16MB ZONE_DMA unless absolutely
-			   needed. It's better to use remapping first. */
-			if (dma_mask < DMA_32BIT_MASK && !(gfp & GFP_DMA)) {
-				gfp = (gfp & ~GFP_DMA32) | GFP_DMA;
-				goto again;
-			}
-
-			/* Let low level make its own zone decisions */
-			gfp &= ~(GFP_DMA32|GFP_DMA);
-
-			if (dma_ops->alloc_coherent)
-				return dma_ops->alloc_coherent(dev, size,
-							   dma_handle, gfp);
-			return NULL;
-		}
-
-		memset(memory, 0, size);
-		if (!mmu) {
-			*dma_handle = bus;
-			return memory;
-		}
-	}
-
-	if (dma_ops->alloc_coherent) {
-		free_pages((unsigned long)memory, get_order(size));
-		gfp &= ~(GFP_DMA|GFP_DMA32);
-		return dma_ops->alloc_coherent(dev, size, dma_handle, gfp);
-	}
-
-	if (dma_ops->map_simple) {
-		*dma_handle = dma_ops->map_simple(dev, virt_to_phys(memory),
-					      size,
-					      PCI_DMA_BIDIRECTIONAL);
-		if (*dma_handle != bad_dma_address)
-			return memory;
-	}
-
-	if (panic_on_overflow)
-		panic("dma_alloc_coherent: IOMMU overflow by %lu bytes\n",size);
-	free_pages((unsigned long)memory, get_order(size));
-	return NULL;
-}
-EXPORT_SYMBOL(dma_alloc_coherent);
-
-/*
- * Unmap coherent memory.
- * The caller must ensure that the device has finished accessing the mapping.
- */
-void dma_free_coherent(struct device *dev, size_t size,
-			 void *vaddr, dma_addr_t bus)
-{
-	int order = get_order(size);
-	WARN_ON(irqs_disabled());	/* for portability */
-	if (dma_release_coherent(dev, order, vaddr))
-		return;
-	if (dma_ops->unmap_single)
-		dma_ops->unmap_single(dev, bus, size, 0);
-	free_pages((unsigned long)vaddr, order);
-}
-EXPORT_SYMBOL(dma_free_coherent);
-- 
1.5.0.6


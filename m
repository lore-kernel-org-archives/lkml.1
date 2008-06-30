Return-Path: <linux-kernel-owner+w=401wt.eu-S1760925AbYF3K7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925AbYF3K7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 06:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbYF3K7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 06:59:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58850 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbYF3K67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 06:58:59 -0400
Date: Mon, 30 Jun 2008 12:58:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] Generic per-device coherent dma allocator
Message-ID: <20080630105835.GA27466@elte.hu>
References: <20080629101846.GA23362@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080629101846.GA23362@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:

> Currently x86_32, sh and cris-v32 provide per-device coherent dma 
> memory allocator. However their implementation is nearly identical. 
> Refactor out common code to be reused by them.

looks good to me in principle.

Andrew, Jesse: i've put this aside into the core/generic-dma-coherent 
git tree which you can check at:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/generic-dma-coherent

there's some interaction with other x86 bits so i guess it would be best 
to carry this in -tip.

Do the generic bits look good to you? (find the shortlog and diff below) 
It's not yet propagated into linux-next, pending your ack/nak and 
pending some test exposure.
 
Thanks,

	Ingo

------------------>
Dmitry Baryshkov (2):
      generic: per-device coherent dma allocator
      x86: use generic per-device dma coherent allocator

 arch/x86/Kconfig                   |    1 +
 arch/x86/kernel/pci-dma.c          |  122 +----------------------------------
 include/asm-generic/dma-coherent.h |   32 +++++++++
 include/asm-x86/dma-mapping.h      |   22 +------
 init/Kconfig                       |    4 +
 kernel/Makefile                    |    1 +
 kernel/dma-coherent.c              |  127 ++++++++++++++++++++++++++++++++++++
 7 files changed, 168 insertions(+), 141 deletions(-)
 create mode 100644 include/asm-generic/dma-coherent.h
 create mode 100644 kernel/dma-coherent.c

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

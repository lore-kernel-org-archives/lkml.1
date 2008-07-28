Return-Path: <linux-kernel-owner+w=401wt.eu-S1759127AbYG1WJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127AbYG1WJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbYG1WJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:09:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43081 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbYG1WJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:09:45 -0400
Date: Tue, 29 Jul 2008 00:09:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [git pull] generic coherent dma
Message-ID: <20080728220929.GA9845@elte.hu>
References: <20080720105822.GA4075@doriath.ww600.siemens.net> <20080720192558.GA6576@elte.hu> <200807281502.11427.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807281502.11427.jbarnes@virtuousgeek.org>
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

* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Sunday, July 20, 2008 12:25 pm Ingo Molnar wrote:
> > * Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> > > Hi,
> > >
> > > These two patches probably are the last for the tip
> > > core/generic-dma-coherent branch. The first one converts cris arch to
> > > use the generic allocator. The second one adds documentation for new
> > > interfaces. So, I think, the branch is ready to be scheduled for the
> > > merge (or at least testing in the linux-next).
> >
> > applied to tip/core/generic-dma-coherent.
> >
> > Jesse, please pull it into pci.git - the x86 bits are well-tested and
> > stable. See the pull coordinates below.
> >
> > 	Ingo
> >
> > ---------------------------------->
> > Please pull the latest core/generic-dma-coherent git tree from:
> >
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> > core/generic-dma-coherent
> 
> Just tried pulling this; I get conflicts in arch/x86/Kconfig.  Is your 
> branch not up to date?

hey, you tried to pull after 8 days in the merge window - that's a few 
thousand commits down the line ;-)

When i send pull requests the branches become generally immutable until 
they get pulled. (i.e. i dont change it under your foot)

i've merged up latest -git and pushed out the result - could you retry?

	Ingo

---------->
Please pull the latest core/generic-dma-coherent git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/generic-dma-coherent

 Thanks,

	Ingo

------------------>
Dmitry Baryshkov (7):
      generic: per-device coherent dma allocator
      x86: use generic per-device dma coherent allocator
      Generic dma-coherent: fix DMA_MEMORY_EXCLUSIVE
      ARM: support generic per-device coherent dma mem
      Sh: use generic per-device coherent dma allocator
      Cris: convert to using generic dma-coherent mem allocator
      dma-coherent: add documentation to new interfaces


 arch/arm/Kconfig                     |    1 +
 arch/arm/mm/consistent.c             |    8 ++
 arch/cris/arch-v32/drivers/Kconfig   |    1 +
 arch/cris/arch-v32/drivers/pci/dma.c |  106 +-----------------------
 arch/sh/Kconfig                      |    1 +
 arch/sh/mm/consistent.c              |   98 +---------------------
 arch/x86/Kconfig                     |    1 +
 arch/x86/kernel/pci-dma.c            |  122 +--------------------------
 include/asm-arm/dma-mapping.h        |    2 +
 include/asm-cris/dma-mapping.h       |    2 +
 include/asm-generic/dma-coherent.h   |   32 +++++++
 include/asm-sh/dma-mapping.h         |    1 +
 include/asm-x86/dma-mapping.h        |   22 +-----
 init/Kconfig                         |    4 +
 kernel/Makefile                      |    1 +
 kernel/dma-coherent.c                |  154 ++++++++++++++++++++++++++++++++++
 16 files changed, 217 insertions(+), 339 deletions(-)
 create mode 100644 include/asm-generic/dma-coherent.h
 create mode 100644 kernel/dma-coherent.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c8f5282..652cd32 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -17,6 +17,7 @@ config ARM
 	select HAVE_KRETPROBES if (HAVE_KPROBES)
 	select HAVE_FTRACE if (!XIP_KERNEL)
 	select HAVE_DYNAMIC_FTRACE if (HAVE_FTRACE)
+	select HAVE_GENERIC_DMA_COHERENT
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff --git a/arch/arm/mm/consistent.c b/arch/arm/mm/consistent.c
index 333a82a..db7b3e3 100644
--- a/arch/arm/mm/consistent.c
+++ b/arch/arm/mm/consistent.c
@@ -274,6 +274,11 @@ __dma_alloc(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp,
 void *
 dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp)
 {
+	void *memory;
+
+	if (dma_alloc_from_coherent(dev, size, handle, &memory))
+		return memory;
+
 	if (arch_is_coherent()) {
 		void *virt;
 
@@ -362,6 +367,9 @@ void dma_free_coherent(struct device *dev, size_t size, void *cpu_addr, dma_addr
 
 	WARN_ON(irqs_disabled());
 
+	if (dma_release_from_coherent(dev, get_order(size), cpu_addr))
+		return;
+
 	if (arch_is_coherent()) {
 		kfree(cpu_addr);
 		return;
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
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 7bfb0d2..0b88dc4 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -11,6 +11,7 @@ config SUPERH
 	select HAVE_CLK
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_GENERIC_DMA_COHERENT
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
diff --git a/arch/sh/mm/consistent.c b/arch/sh/mm/consistent.c
index 8277982..b2ce014 100644
--- a/arch/sh/mm/consistent.c
+++ b/arch/sh/mm/consistent.c
@@ -28,21 +28,10 @@ void *dma_alloc_coherent(struct device *dev, size_t size,
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
@@ -72,11 +61,7 @@ void dma_free_coherent(struct device *dev, size_t size,
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
@@ -85,83 +70,6 @@ void dma_free_coherent(struct device *dev, size_t size,
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
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b6fa287..3d0f2b6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -30,6 +30,7 @@ config X86
 	select HAVE_FTRACE
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
+	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 
 config ARCH_DEFCONFIG
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 3754412..8dbffb8 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -192,124 +192,6 @@ static __init int iommu_setup(char *p)
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
 	struct dma_mapping_ops *ops = get_dma_ops(dev);
@@ -379,7 +261,7 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	/* ignore region specifiers */
 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
 
-	if (dma_alloc_from_coherent_mem(dev, size, dma_handle, &memory))
+	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
 		return memory;
 
 	if (!dev) {
@@ -484,7 +366,7 @@ void dma_free_coherent(struct device *dev, size_t size,
 
 	int order = get_order(size);
 	WARN_ON(irqs_disabled());	/* for portability */
-	if (dma_release_coherent(dev, order, vaddr))
+	if (dma_release_from_coherent(dev, order, vaddr))
 		return;
 	if (ops->unmap_single)
 		ops->unmap_single(dev, bus, size, 0);
diff --git a/include/asm-arm/dma-mapping.h b/include/asm-arm/dma-mapping.h
index f41335b..45329fc 100644
--- a/include/asm-arm/dma-mapping.h
+++ b/include/asm-arm/dma-mapping.h
@@ -7,6 +7,8 @@
 
 #include <linux/scatterlist.h>
 
+#include <asm-generic/dma-coherent.h>
+
 /*
  * DMA-consistent mapping functions.  These allocate/free a region of
  * uncached, unwrite-buffered mapped memory space for use with DMA
diff --git a/include/asm-cris/dma-mapping.h b/include/asm-cris/dma-mapping.h
index cb2fb25..da8ef8e 100644
--- a/include/asm-cris/dma-mapping.h
+++ b/include/asm-cris/dma-mapping.h
@@ -14,6 +14,8 @@
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
 #ifdef CONFIG_PCI
+#include <asm-generic/dma-coherent.h>
+
 void *dma_alloc_coherent(struct device *dev, size_t size,
 			   dma_addr_t *dma_handle, gfp_t flag);
 
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
diff --git a/include/asm-sh/dma-mapping.h b/include/asm-sh/dma-mapping.h
index 6c0b8a2..627315e 100644
--- a/include/asm-sh/dma-mapping.h
+++ b/include/asm-sh/dma-mapping.h
@@ -5,6 +5,7 @@
 #include <linux/scatterlist.h>
 #include <asm/cacheflush.h>
 #include <asm/io.h>
+#include <asm-generic/dma-coherent.h>
 
 extern struct bus_type pci_bus_type;
 
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 0eaa9bf..ad9cd6d 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -249,25 +249,5 @@ static inline int dma_get_cache_alignment(void)
 
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
index 43d6989..250e02c 100644
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
index 54f6983..4e1d7df 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -84,6 +84,7 @@ obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_MARKERS) += marker.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
+obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
 obj-$(CONFIG_FTRACE) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
diff --git a/kernel/dma-coherent.c b/kernel/dma-coherent.c
new file mode 100644
index 0000000..7517115
--- /dev/null
+++ b/kernel/dma-coherent.c
@@ -0,0 +1,154 @@
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
+/**
+ * Try to allocate memory from the per-device coherent area.
+ *
+ * @dev:	device from which we allocate memory
+ * @size:	size of requested memory area
+ * @dma_handle:	This will be filled with the correct dma handle
+ * @ret:	This pointer will be filled with the virtual address
+ * 		to allocated area.
+ *
+ * This function should be only called from per-arch %dma_alloc_coherent()
+ * to support allocation from per-device coherent memory pools.
+ *
+ * Returns 0 if dma_alloc_coherent should continue with allocating from
+ * generic memory areas, or !0 if dma_alloc_coherent should return %ret.
+ */
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
+		} else if (mem->flags & DMA_MEMORY_EXCLUSIVE)
+			*ret = NULL;
+	}
+	return (mem != NULL);
+}
+
+/**
+ * Try to free the memory allocated from per-device coherent memory pool.
+ * @dev:	device from which the memory was allocated
+ * @order:	the order of pages allocated
+ * @vaddr:	virtual address of allocated pages
+ *
+ * This checks whether the memory was allocated from the per-device
+ * coherent memory pool and if so, releases that memory.
+ *
+ * Returns 1 if we correctly released the memory, or 0 if
+ * %dma_release_coherent() should proceed with releasing memory from
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

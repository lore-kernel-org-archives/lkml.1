Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbZA2UTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbZA2UTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 15:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbZA2US4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 15:18:56 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:41261 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbZA2USz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:18:55 -0500
Date: Thu, 29 Jan 2009 23:19:13 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, rth@twiddle.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: compile fixes
Message-ID: <20090129201913.GA22184@jurassic.park.msu.ru>
References: <20090127083823.GB15452@jurassic.park.msu.ru> <20090128115403R.fujita.tomonori@lab.ntt.co.jp> <20090129074101.GA13020@jurassic.park.msu.ru> <20090129181854K.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129181854K.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 06:18:13PM +0900, FUJITA Tomonori wrote:
> That's exactly what IA64 does. The generic kernel works for all IA64
> architectures. If you build an architecture specific IA64 kernel (such
> as IA64_DIG), IA64 uses ifdef and macro magics for dma mapping
> operations.
> 
> The ifdef and macro magics makes the code unreadable. I rewrote IA64
> dma operation code to use the standard way to handle multiple dma
> mapping operation sets so that non everyone can understand the code
> easily.

There are no multiple dma mapping operation sets or macro magic in
this case. All alphas use the same dma functions, except for jensen
(i486 class machine) which has "optimized" set for a machine specific
kernel. So adding an indirection here is just an overkill.

On the other hand, arch/alpha/include/asm/dma-mapping.h probably needs
a cleanup like this (untested).

Ivan.

 arch/alpha/include/asm/dma-mapping.h |   29 +----------
 arch/alpha/include/asm/pci.h         |   13 +++--
 arch/alpha/kernel/pci-noop.c         |   93 ++++++++++++++--------------------
 arch/alpha/kernel/pci_iommu.c        |    2 +-
 4 files changed, 50 insertions(+), 87 deletions(-)

diff --git a/arch/alpha/include/asm/dma-mapping.h b/arch/alpha/include/asm/dma-mapping.h
index 04eb568..e047af5 100644
--- a/arch/alpha/include/asm/dma-mapping.h
+++ b/arch/alpha/include/asm/dma-mapping.h
@@ -1,9 +1,6 @@
 #ifndef _ALPHA_DMA_MAPPING_H
 #define _ALPHA_DMA_MAPPING_H
 
-
-#ifdef CONFIG_PCI
-
 #include <linux/pci.h>
 
 #define dma_map_single(dev, va, size, dir)		\
@@ -11,7 +8,7 @@
 #define dma_unmap_single(dev, addr, size, dir)		\
 		pci_unmap_single(alpha_gendev_to_pci(dev), addr, size, dir)
 #define dma_alloc_coherent(dev, size, addr, gfp)	\
-	      __pci_alloc_consistent(alpha_gendev_to_pci(dev), size, addr, gfp)
+	      __pci_alloc_consistent(alpha_gendev_to_pci(dev), size, addr, gfp, dev)
 #define dma_free_coherent(dev, size, va, addr)		\
 		pci_free_consistent(alpha_gendev_to_pci(dev), size, va, addr)
 #define dma_map_page(dev, page, off, size, dir)		\
@@ -27,30 +24,6 @@
 #define dma_mapping_error(dev, addr)				\
 		pci_dma_mapping_error(alpha_gendev_to_pci(dev), addr)
 
-#else	/* no PCI - no IOMMU. */
-
-#include <asm/io.h>	/* for virt_to_phys() */
-
-struct scatterlist;
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			 dma_addr_t *dma_handle, gfp_t gfp);
-int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-	       enum dma_data_direction direction);
-
-#define dma_free_coherent(dev, size, va, addr)		\
-		free_pages((unsigned long)va, get_order(size))
-#define dma_supported(dev, mask)		(mask < 0x00ffffffUL ? 0 : 1)
-#define dma_map_single(dev, va, size, dir)	virt_to_phys(va)
-#define dma_map_page(dev, page, off, size, dir)	(page_to_pa(page) + off)
-
-#define dma_unmap_single(dev, addr, size, dir)	((void)0)
-#define dma_unmap_page(dev, addr, size, dir)	((void)0)
-#define dma_unmap_sg(dev, sg, nents, dir)	((void)0)
-
-#define dma_mapping_error(dev, addr)  (0)
-
-#endif	/* !CONFIG_PCI */
-
 #define dma_alloc_noncoherent(d, s, h, f)	dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h)	dma_free_coherent(d, s, v, h)
 #define dma_is_consistent(d, h)			(1)
diff --git a/arch/alpha/include/asm/pci.h b/arch/alpha/include/asm/pci.h
index dffa843..1765e22 100644
--- a/arch/alpha/include/asm/pci.h
+++ b/arch/alpha/include/asm/pci.h
@@ -77,11 +77,11 @@ static inline void pcibios_penalize_isa_irq(int irq, int active)
    else DMA_ADDRP is undefined.  */
 
 extern void *__pci_alloc_consistent(struct pci_dev *, size_t,
-				    dma_addr_t *, gfp_t);
+				    dma_addr_t *, gfp_t, struct device *);
 static inline void *
 pci_alloc_consistent(struct pci_dev *dev, size_t size, dma_addr_t *dma)
 {
-	return __pci_alloc_consistent(dev, size, dma, GFP_ATOMIC);
+	return __pci_alloc_consistent(dev, size, dma, GFP_ATOMIC, NULL);
 }
 
 /* Free and unmap a consistent DMA buffer.  CPU_ADDR and DMA_ADDR must
@@ -223,6 +223,13 @@ static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 	*strat = PCI_DMA_BURST_BOUNDARY;
 	*strategy_parameter = cacheline_size;
 }
+
+struct pci_dev *alpha_gendev_to_pci(struct device *dev);
+#else
+static inline struct pci_dev *alpha_gendev_to_pci(struct device *dev)
+{
+	return NULL;
+}
 #endif
 
 /* TODO: integrate with include/asm-generic/pci.h ? */
@@ -258,8 +265,6 @@ static inline int pci_proc_domain(struct pci_bus *bus)
 	return hose->need_domain_info;
 }
 
-struct pci_dev *alpha_gendev_to_pci(struct device *dev);
-
 #endif /* __KERNEL__ */
 
 /* Values for the `which' argument to sys_pciconfig_iobase.  */
diff --git a/arch/alpha/kernel/pci-noop.c b/arch/alpha/kernel/pci-noop.c
index c19a376..b8889a7 100644
--- a/arch/alpha/kernel/pci-noop.c
+++ b/arch/alpha/kernel/pci-noop.c
@@ -110,73 +110,48 @@ sys_pciconfig_write(unsigned long bus, unsigned long dfn,
 
 void *
 __pci_alloc_consistent(struct pci_dev *pdev, size_t size,
-		       dma_addr_t *dma_addrp, gfp_t gfp)
+		       dma_addr_t *dma_handle, gfp_t gfp, struct device *dev)
 {
-	return NULL;
+	void *ret;
+
+	if (!dev || *dev->dma_mask >= 0xffffffffUL)
+		gfp &= ~GFP_DMA;
+	ret = (void *)__get_free_pages(gfp, get_order(size));
+	if (ret) {
+		memset(ret, 0, size);
+		*dma_handle = virt_to_phys(ret);
+	}
+	return ret;
 }
+EXPORT_SYMBOL(__pci_alloc_consistent);
 
 void
 pci_free_consistent(struct pci_dev *pdev, size_t size, void *cpu_addr,
 		    dma_addr_t dma_addr)
 {
+	free_pages((unsigned long)cpu_addr, get_order(size));
 }
+EXPORT_SYMBOL(pci_free_consistent);
 
 dma_addr_t
 pci_map_single(struct pci_dev *pdev, void *cpu_addr, size_t size,
 	       int direction)
 {
-	return (dma_addr_t) 0;
+	return virt_to_phys(cpu_addr);
 }
+EXPORT_SYMBOL(pci_map_single);
 
 void
 pci_unmap_single(struct pci_dev *pdev, dma_addr_t dma_addr, size_t size,
 		 int direction)
 {
 }
+EXPORT_SYMBOL(pci_unmap_single);
 
 int
-pci_map_sg(struct pci_dev *pdev, struct scatterlist *sg, int nents,
+pci_map_sg(struct pci_dev *pdev, struct scatterlist *sgl, int nents,
 	   int direction)
 {
-	return 0;
-}
-
-void
-pci_unmap_sg(struct pci_dev *pdev, struct scatterlist *sg, int nents,
-	     int direction)
-{
-}
-
-int
-pci_dma_supported(struct pci_dev *hwdev, dma_addr_t mask)
-{
-	return 0;
-}
-
-/* Generic DMA mapping functions: */
-
-void *
-dma_alloc_coherent(struct device *dev, size_t size,
-		   dma_addr_t *dma_handle, gfp_t gfp)
-{
-	void *ret;
-
-	if (!dev || *dev->dma_mask >= 0xffffffffUL)
-		gfp &= ~GFP_DMA;
-	ret = (void *)__get_free_pages(gfp, get_order(size));
-	if (ret) {
-		memset(ret, 0, size);
-		*dma_handle = virt_to_phys(ret);
-	}
-	return ret;
-}
-
-EXPORT_SYMBOL(dma_alloc_coherent);
-
-int
-dma_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
-	   enum dma_data_direction direction)
-{
 	int i;
 	struct scatterlist *sg;
 
@@ -191,20 +166,21 @@ dma_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
 
 	return nents;
 }
+EXPORT_SYMBOL(pci_map_sg);
 
-EXPORT_SYMBOL(dma_map_sg);
+void
+pci_unmap_sg(struct pci_dev *pdev, struct scatterlist *sg, int nents,
+	     int direction)
+{
+}
+EXPORT_SYMBOL(pci_unmap_sg);
 
 int
-dma_set_mask(struct device *dev, u64 mask)
+pci_dma_supported(struct pci_dev *pdev, dma_addr_t mask)
 {
-	if (!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-
-	*dev->dma_mask = mask;
-
-	return 0;
+	return (mask < 0x00ffffffUL ? 0 : 1);
 }
-EXPORT_SYMBOL(dma_set_mask);
+EXPORT_SYMBOL(pci_dma_supported);
 
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
@@ -215,5 +191,14 @@ void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
 {
 }
 
-EXPORT_SYMBOL(pci_iomap);
-EXPORT_SYMBOL(pci_iounmap);
+int
+dma_set_mask(struct device *dev, u64 mask)
+{
+	if (!dev->dma_mask || !dma_supported(dev, mask))
+		return -EIO;
+
+	*dev->dma_mask = mask;
+
+	return 0;
+}
+EXPORT_SYMBOL(dma_set_mask);
diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index b9094da..93b0b94 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -414,7 +414,7 @@ EXPORT_SYMBOL(pci_unmap_page);
 
 void *
 __pci_alloc_consistent(struct pci_dev *pdev, size_t size,
-		       dma_addr_t *dma_addrp, gfp_t gfp)
+		       dma_addr_t *dma_addrp, gfp_t gfp, struct device *dev)
 {
 	void *cpu_addr;
 	long order = get_order(size);

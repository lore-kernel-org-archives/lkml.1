Return-Path: <linux-kernel-owner+w=401wt.eu-S1761462AbYBFDYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761462AbYBFDYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 22:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756604AbYBFDYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 22:24:11 -0500
Received: from relay1.sgi.com ([192.48.171.29]:60230 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750943AbYBFDYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 22:24:09 -0500
From: akepner@sgi.com
Date: Tue, 5 Feb 2008 19:22:42 -0800
To: Tony Luck <tony.luck@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jes Sorensen <jes@sgi.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] dma/ia64: update ia64 machvecs
Message-ID: <20080206032242.GP9904@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Change all ia64 machvecs to use the new dma_{un}map_*_attrs()
interfaces. Implement the old dma_{un}map_*() interfaces in
terms of the corresponding new interfaces. For ia64/sn, make
use of one dma attribute, DMA_ATTR_SYNC_ON_WRITE.

Signed-off-by: Arthur Kepner <akepner@sgi.com>

---

 arch/ia64/hp/common/hwsw_iommu.c         |   60 ++++++++++++------------
 arch/ia64/hp/common/sba_iommu.c          |   62 ++++++++++++++----------
 arch/ia64/sn/pci/pci_dma.c               |   77 ++++++++++++++++++++-----------
 include/asm-ia64/dma-mapping.h           |   28 +++++++++--
 include/asm-ia64/machvec.h               |   52 ++++++++++++--------
 include/asm-ia64/machvec_hpzx1.h         |   16 +++---
 include/asm-ia64/machvec_hpzx1_swiotlb.h |   16 +++---
 include/asm-ia64/machvec_sn2.h           |   16 +++---
 include/linux/dma-attrs.h                |   49 +++++++++++++++++++
 lib/swiotlb.c                            |   50 ++++++++++++++++----
 10 files changed, 290 insertions(+), 136 deletions(-)

diff --git a/arch/ia64/hp/common/hwsw_iommu.c b/arch/ia64/hp/common/hwsw_iommu.c
index 94e5710..8cedd6c 100644
--- a/arch/ia64/hp/common/hwsw_iommu.c
+++ b/arch/ia64/hp/common/hwsw_iommu.c
@@ -20,10 +20,10 @@
 extern int swiotlb_late_init_with_default_size (size_t size);
 extern ia64_mv_dma_alloc_coherent	swiotlb_alloc_coherent;
 extern ia64_mv_dma_free_coherent	swiotlb_free_coherent;
-extern ia64_mv_dma_map_single		swiotlb_map_single;
-extern ia64_mv_dma_unmap_single		swiotlb_unmap_single;
-extern ia64_mv_dma_map_sg		swiotlb_map_sg;
-extern ia64_mv_dma_unmap_sg		swiotlb_unmap_sg;
+extern ia64_mv_dma_map_single_attrs	swiotlb_map_single_attrs;
+extern ia64_mv_dma_unmap_single_attrs	swiotlb_unmap_single_attrs;
+extern ia64_mv_dma_map_sg_attrs		swiotlb_map_sg_attrs;
+extern ia64_mv_dma_unmap_sg_attrs	swiotlb_unmap_sg_attrs;
 extern ia64_mv_dma_supported		swiotlb_dma_supported;
 extern ia64_mv_dma_mapping_error	swiotlb_dma_mapping_error;
 
@@ -31,19 +31,19 @@ extern ia64_mv_dma_mapping_error	swiotlb_dma_mapping_error;
 
 extern ia64_mv_dma_alloc_coherent	sba_alloc_coherent;
 extern ia64_mv_dma_free_coherent	sba_free_coherent;
-extern ia64_mv_dma_map_single		sba_map_single;
-extern ia64_mv_dma_unmap_single		sba_unmap_single;
-extern ia64_mv_dma_map_sg		sba_map_sg;
-extern ia64_mv_dma_unmap_sg		sba_unmap_sg;
+extern ia64_mv_dma_map_single_attrs	sba_map_single_attrs;
+extern ia64_mv_dma_unmap_single_attrs	sba_unmap_single_attrs;
+extern ia64_mv_dma_map_sg_attrs		sba_map_sg_attrs;
+extern ia64_mv_dma_unmap_sg_attrs	sba_unmap_sg_attrs;
 extern ia64_mv_dma_supported		sba_dma_supported;
 extern ia64_mv_dma_mapping_error	sba_dma_mapping_error;
 
 #define hwiommu_alloc_coherent		sba_alloc_coherent
 #define hwiommu_free_coherent		sba_free_coherent
-#define hwiommu_map_single		sba_map_single
-#define hwiommu_unmap_single		sba_unmap_single
-#define hwiommu_map_sg			sba_map_sg
-#define hwiommu_unmap_sg		sba_unmap_sg
+#define hwiommu_map_single_attrs	sba_map_single_attrs
+#define hwiommu_unmap_single_attrs	sba_unmap_single_attrs
+#define hwiommu_map_sg_attrs		sba_map_sg_attrs
+#define hwiommu_unmap_sg_attrs		sba_unmap_sg_attrs
 #define hwiommu_dma_supported		sba_dma_supported
 #define hwiommu_dma_mapping_error	sba_dma_mapping_error
 #define hwiommu_sync_single_for_cpu	machvec_dma_sync_single
@@ -98,40 +98,44 @@ hwsw_free_coherent (struct device *dev, size_t size, void *vaddr, dma_addr_t dma
 }
 
 dma_addr_t
-hwsw_map_single (struct device *dev, void *addr, size_t size, int dir)
+hwsw_map_single_attrs (struct device *dev, void *addr, size_t size, int dir, 
+		       struct dma_attrs *attrs)
 {
 	if (use_swiotlb(dev))
-		return swiotlb_map_single(dev, addr, size, dir);
+		return swiotlb_map_single_attrs(dev, addr, size, dir, attrs);
 	else
-		return hwiommu_map_single(dev, addr, size, dir);
+		return hwiommu_map_single_attrs(dev, addr, size, dir, attrs);
 }
 
 void
-hwsw_unmap_single (struct device *dev, dma_addr_t iova, size_t size, int dir)
+hwsw_unmap_single_attrs (struct device *dev, dma_addr_t iova, size_t size, 
+			 int dir, struct dma_attrs *attrs)
 {
 	if (use_swiotlb(dev))
-		return swiotlb_unmap_single(dev, iova, size, dir);
+		return swiotlb_unmap_single_attrs(dev, iova, size, dir, attrs);
 	else
-		return hwiommu_unmap_single(dev, iova, size, dir);
+		return hwiommu_unmap_single_attrs(dev, iova, size, dir, attrs);
 }
 
 
 int
-hwsw_map_sg (struct device *dev, struct scatterlist *sglist, int nents, int dir)
+hwsw_map_sg_attrs (struct device *dev, struct scatterlist *sglist, int nents, 
+		   int dir, struct dma_attrs *attrs)
 {
 	if (use_swiotlb(dev))
-		return swiotlb_map_sg(dev, sglist, nents, dir);
+		return swiotlb_map_sg_attrs(dev, sglist, nents, dir, attrs);
 	else
-		return hwiommu_map_sg(dev, sglist, nents, dir);
+		return hwiommu_map_sg_attrs(dev, sglist, nents, dir, attrs);
 }
 
 void
-hwsw_unmap_sg (struct device *dev, struct scatterlist *sglist, int nents, int dir)
+hwsw_unmap_sg_attrs (struct device *dev, struct scatterlist *sglist, int nents, 
+		     int dir, struct dma_attrs *attrs)
 {
 	if (use_swiotlb(dev))
-		return swiotlb_unmap_sg(dev, sglist, nents, dir);
+		return swiotlb_unmap_sg_attrs(dev, sglist, nents, dir, attrs);
 	else
-		return hwiommu_unmap_sg(dev, sglist, nents, dir);
+		return hwiommu_unmap_sg_attrs(dev, sglist, nents, dir, attrs);
 }
 
 void
@@ -185,10 +189,10 @@ hwsw_dma_mapping_error (dma_addr_t dma_addr)
 }
 
 EXPORT_SYMBOL(hwsw_dma_mapping_error);
-EXPORT_SYMBOL(hwsw_map_single);
-EXPORT_SYMBOL(hwsw_unmap_single);
-EXPORT_SYMBOL(hwsw_map_sg);
-EXPORT_SYMBOL(hwsw_unmap_sg);
+EXPORT_SYMBOL(hwsw_map_single_attrs);
+EXPORT_SYMBOL(hwsw_unmap_single_attrs);
+EXPORT_SYMBOL(hwsw_map_sg_attrs);
+EXPORT_SYMBOL(hwsw_unmap_sg_attrs);
 EXPORT_SYMBOL(hwsw_dma_supported);
 EXPORT_SYMBOL(hwsw_alloc_coherent);
 EXPORT_SYMBOL(hwsw_free_coherent);
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 45bf04e..89128cf 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -877,16 +877,18 @@ sba_mark_invalid(struct ioc *ioc, dma_addr_t iova, size_t byte_cnt)
 }
 
 /**
- * sba_map_single - map one buffer and return IOVA for DMA
+ * sba_map_single_attrs - map one buffer and return IOVA for DMA
  * @dev: instance of PCI owned by the driver that's asking.
  * @addr:  driver buffer to map.
  * @size:  number of bytes to map in driver buffer.
  * @dir:  R/W or both.
+ * @attrs: optional dma attributes
  *
  * See Documentation/DMA-mapping.txt
  */
 dma_addr_t
-sba_map_single(struct device *dev, void *addr, size_t size, int dir)
+sba_map_single_attrs(struct device *dev, void *addr, size_t size, int dir, 
+		     struct dma_attrs *attrs)
 {
 	struct ioc *ioc;
 	dma_addr_t iovp;
@@ -910,7 +912,7 @@ sba_map_single(struct device *dev, void *addr, size_t size, int dir)
  		** Device is bit capable of DMA'ing to the buffer...
 		** just return the PCI address of ptr
  		*/
-		DBG_BYPASS("sba_map_single() bypass mask/addr: 0x%lx/0x%lx\n",
+		DBG_BYPASS("sba_map_single_attrs() bypass mask/addr: 0x%lx/0x%lx\n",
 		           to_pci_dev(dev)->dma_mask, pci_addr);
 		return pci_addr;
 	}
@@ -931,7 +933,7 @@ sba_map_single(struct device *dev, void *addr, size_t size, int dir)
 
 #ifdef ASSERT_PDIR_SANITY
 	spin_lock_irqsave(&ioc->res_lock, flags);
-	if (sba_check_pdir(ioc,"Check before sba_map_single()"))
+	if (sba_check_pdir(ioc,"Check before sba_map_single_attrs()"))
 		panic("Sanity check failed");
 	spin_unlock_irqrestore(&ioc->res_lock, flags);
 #endif
@@ -961,7 +963,7 @@ sba_map_single(struct device *dev, void *addr, size_t size, int dir)
 	/* form complete address */
 #ifdef ASSERT_PDIR_SANITY
 	spin_lock_irqsave(&ioc->res_lock, flags);
-	sba_check_pdir(ioc,"Check after sba_map_single()");
+	sba_check_pdir(ioc,"Check after sba_map_single_attrs()");
 	spin_unlock_irqrestore(&ioc->res_lock, flags);
 #endif
 	return SBA_IOVA(ioc, iovp, offset);
@@ -992,15 +994,17 @@ sba_mark_clean(struct ioc *ioc, dma_addr_t iova, size_t size)
 #endif
 
 /**
- * sba_unmap_single - unmap one IOVA and free resources
+ * sba_unmap_single_attrs - unmap one IOVA and free resources
  * @dev: instance of PCI owned by the driver that's asking.
  * @iova:  IOVA of driver buffer previously mapped.
  * @size:  number of bytes mapped in driver buffer.
  * @dir:  R/W or both.
+ * @attrs: optional dma attributes
  *
  * See Documentation/DMA-mapping.txt
  */
-void sba_unmap_single(struct device *dev, dma_addr_t iova, size_t size, int dir)
+void sba_unmap_single_attrs(struct device *dev, dma_addr_t iova, size_t size, 
+			    int dir, struct dma_attrs *attrs)
 {
 	struct ioc *ioc;
 #if DELAYED_RESOURCE_CNT > 0
@@ -1017,7 +1021,8 @@ void sba_unmap_single(struct device *dev, dma_addr_t iova, size_t size, int dir)
 		/*
 		** Address does not fall w/in IOVA, must be bypassing
 		*/
-		DBG_BYPASS("sba_unmap_single() bypass addr: 0x%lx\n", iova);
+		DBG_BYPASS("sba_unmap_single_atttrs() bypass addr: 0x%lx\n", 
+			   iova);
 
 #ifdef ENABLE_MARK_CLEAN
 		if (dir == DMA_FROM_DEVICE) {
@@ -1068,7 +1073,6 @@ void sba_unmap_single(struct device *dev, dma_addr_t iova, size_t size, int dir)
 #endif /* DELAYED_RESOURCE_CNT == 0 */
 }
 
-
 /**
  * sba_alloc_coherent - allocate/map shared mem for DMA
  * @dev: instance of PCI owned by the driver that's asking.
@@ -1124,7 +1128,8 @@ sba_alloc_coherent (struct device *dev, size_t size, dma_addr_t *dma_handle, gfp
 	 * If device can't bypass or bypass is disabled, pass the 32bit fake
 	 * device to map single to get an iova mapping.
 	 */
-	*dma_handle = sba_map_single(&ioc->sac_only_dev->dev, addr, size, 0);
+	*dma_handle = sba_map_single_attrs(&ioc->sac_only_dev->dev, addr, 
+					   size, 0, NULL);
 
 	return addr;
 }
@@ -1141,7 +1146,7 @@ sba_alloc_coherent (struct device *dev, size_t size, dma_addr_t *dma_handle, gfp
  */
 void sba_free_coherent (struct device *dev, size_t size, void *vaddr, dma_addr_t dma_handle)
 {
-	sba_unmap_single(dev, dma_handle, size, 0);
+	sba_unmap_single_attrs(dev, dma_handle, size, 0, NULL);
 	free_pages((unsigned long) vaddr, get_order(size));
 }
 
@@ -1386,10 +1391,12 @@ sba_coalesce_chunks( struct ioc *ioc,
  * @sglist:  array of buffer/length pairs
  * @nents:  number of entries in list
  * @dir:  R/W or both.
+ * @attrs: optional dma attributes
  *
  * See Documentation/DMA-mapping.txt
  */
-int sba_map_sg(struct device *dev, struct scatterlist *sglist, int nents, int dir)
+int sba_map_sg_attrs(struct device *dev, struct scatterlist *sglist, int nents, 
+		     int dir, struct dma_attrs *attrs)
 {
 	struct ioc *ioc;
 	int coalesced, filled = 0;
@@ -1417,16 +1424,16 @@ int sba_map_sg(struct device *dev, struct scatterlist *sglist, int nents, int di
 	/* Fast path single entry scatterlists. */
 	if (nents == 1) {
 		sglist->dma_length = sglist->length;
-		sglist->dma_address = sba_map_single(dev, sba_sg_address(sglist), sglist->length, dir);
+		sglist->dma_address = sba_map_single_attrs(dev, sba_sg_address(sglist), sglist->length, dir, attrs);
 		return 1;
 	}
 
 #ifdef ASSERT_PDIR_SANITY
 	spin_lock_irqsave(&ioc->res_lock, flags);
-	if (sba_check_pdir(ioc,"Check before sba_map_sg()"))
+	if (sba_check_pdir(ioc,"Check before sba_map_sg_attrs()"))
 	{
 		sba_dump_sg(ioc, sglist, nents);
-		panic("Check before sba_map_sg()");
+		panic("Check before sba_map_sg_attrs()");
 	}
 	spin_unlock_irqrestore(&ioc->res_lock, flags);
 #endif
@@ -1455,10 +1462,10 @@ int sba_map_sg(struct device *dev, struct scatterlist *sglist, int nents, int di
 
 #ifdef ASSERT_PDIR_SANITY
 	spin_lock_irqsave(&ioc->res_lock, flags);
-	if (sba_check_pdir(ioc,"Check after sba_map_sg()"))
+	if (sba_check_pdir(ioc,"Check after sba_map_sg_attrs()"))
 	{
 		sba_dump_sg(ioc, sglist, nents);
-		panic("Check after sba_map_sg()\n");
+		panic("Check after sba_map_sg_attrs()\n");
 	}
 	spin_unlock_irqrestore(&ioc->res_lock, flags);
 #endif
@@ -1471,15 +1478,17 @@ int sba_map_sg(struct device *dev, struct scatterlist *sglist, int nents, int di
 
 
 /**
- * sba_unmap_sg - unmap Scatter/Gather list
+ * sba_unmap_sg_attrs - unmap Scatter/Gather list
  * @dev: instance of PCI owned by the driver that's asking.
  * @sglist:  array of buffer/length pairs
  * @nents:  number of entries in list
  * @dir:  R/W or both.
+ * @attrs: optional dma attributes
  *
  * See Documentation/DMA-mapping.txt
  */
-void sba_unmap_sg (struct device *dev, struct scatterlist *sglist, int nents, int dir)
+void sba_unmap_sg_attrs (struct device *dev, struct scatterlist *sglist, 
+			 int nents, int dir, struct dma_attrs *attrs)
 {
 #ifdef ASSERT_PDIR_SANITY
 	struct ioc *ioc;
@@ -1494,13 +1503,14 @@ void sba_unmap_sg (struct device *dev, struct scatterlist *sglist, int nents, in
 	ASSERT(ioc);
 
 	spin_lock_irqsave(&ioc->res_lock, flags);
-	sba_check_pdir(ioc,"Check before sba_unmap_sg()");
+	sba_check_pdir(ioc,"Check before sba_unmap_sg_attrs()");
 	spin_unlock_irqrestore(&ioc->res_lock, flags);
 #endif
 
 	while (nents && sglist->dma_length) {
 
-		sba_unmap_single(dev, sglist->dma_address, sglist->dma_length, dir);
+		sba_unmap_single_attrs(dev, sglist->dma_address, 
+				       sglist->dma_length, dir, attrs);
 		sglist = sg_next(sglist);
 		nents--;
 	}
@@ -1509,7 +1519,7 @@ void sba_unmap_sg (struct device *dev, struct scatterlist *sglist, int nents, in
 
 #ifdef ASSERT_PDIR_SANITY
 	spin_lock_irqsave(&ioc->res_lock, flags);
-	sba_check_pdir(ioc,"Check after sba_unmap_sg()");
+	sba_check_pdir(ioc,"Check after sba_unmap_sg_attrs()");
 	spin_unlock_irqrestore(&ioc->res_lock, flags);
 #endif
 
@@ -2142,10 +2152,10 @@ sba_page_override(char *str)
 __setup("sbapagesize=",sba_page_override);
 
 EXPORT_SYMBOL(sba_dma_mapping_error);
-EXPORT_SYMBOL(sba_map_single);
-EXPORT_SYMBOL(sba_unmap_single);
-EXPORT_SYMBOL(sba_map_sg);
-EXPORT_SYMBOL(sba_unmap_sg);
+EXPORT_SYMBOL(sba_map_single_attrs);
+EXPORT_SYMBOL(sba_unmap_single_attrs);
+EXPORT_SYMBOL(sba_map_sg_attrs);
+EXPORT_SYMBOL(sba_unmap_sg_attrs);
 EXPORT_SYMBOL(sba_dma_supported);
 EXPORT_SYMBOL(sba_alloc_coherent);
 EXPORT_SYMBOL(sba_free_coherent);
diff --git a/arch/ia64/sn/pci/pci_dma.c b/arch/ia64/sn/pci/pci_dma.c
index 511db2f..bbdf1aa 100644
--- a/arch/ia64/sn/pci/pci_dma.c
+++ b/arch/ia64/sn/pci/pci_dma.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/dma-attrs.h>
 #include <asm/dma.h>
 #include <asm/sn/intr.h>
 #include <asm/sn/pcibus_provider_defs.h>
@@ -149,11 +150,12 @@ void sn_dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
 EXPORT_SYMBOL(sn_dma_free_coherent);
 
 /**
- * sn_dma_map_single - map a single page for DMA
+ * sn_dma_map_single_attrs - map a single page for DMA
  * @dev: device to map for
  * @cpu_addr: kernel virtual address of the region to map
  * @size: size of the region
  * @direction: DMA direction
+ * @attrs: optional dma attributes
  *
  * Map the region pointed to by @cpu_addr for DMA and return the
  * DMA address.
@@ -166,39 +168,47 @@ EXPORT_SYMBOL(sn_dma_free_coherent);
  * TODO: simplify our interface;
  *       figure out how to save dmamap handle so can use two step.
  */
-dma_addr_t sn_dma_map_single(struct device *dev, void *cpu_addr, size_t size,
-			     int direction)
+dma_addr_t sn_dma_map_single_attrs(struct device *dev, void *cpu_addr, 
+				  size_t size, int direction, 
+				  struct dma_attrs* attrs)
 {
 	dma_addr_t dma_addr;
 	unsigned long phys_addr;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
+	int dmasync, ret;
+
+	ret = dma_get_attr(attrs, DMA_ATTR_SYNC_ON_WRITE);
+	dmasync = (ret > 0);
 
 	BUG_ON(dev->bus != &pci_bus_type);
 
 	phys_addr = __pa(cpu_addr);
-	dma_addr = provider->dma_map(pdev, phys_addr, size, SN_DMA_ADDR_PHYS);
-	if (!dma_addr) {
-		printk(KERN_ERR "%s: out of ATEs\n", __FUNCTION__);
-		return 0;
-	}
+
+	if (dmasync)
+		dma_addr = provider->dma_map_consistent(pdev, phys_addr, 
+							size, SN_DMA_ADDR_PHYS);
+	else 
+		dma_addr = provider->dma_map(pdev, phys_addr, size, 							     SN_DMA_ADDR_PHYS);
 	return dma_addr;
 }
-EXPORT_SYMBOL(sn_dma_map_single);
+EXPORT_SYMBOL(sn_dma_map_single_attrs);
 
 /**
- * sn_dma_unmap_single - unamp a DMA mapped page
+ * sn_dma_unmap_single_attrs - unamp a DMA mapped page
  * @dev: device to sync
  * @dma_addr: DMA address to sync
  * @size: size of region
  * @direction: DMA direction
+ * @attrs: optional dma attributes
  *
  * This routine is supposed to sync the DMA region specified
  * by @dma_handle into the coherence domain.  On SN, we're always cache
  * coherent, so we just need to free any ATEs associated with this mapping.
  */
-void sn_dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-			 int direction)
+void sn_dma_unmap_single_attrs(struct device *dev, dma_addr_t dma_addr, 
+			       size_t size, int direction, 
+			       struct dma_attrs* attrs)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
@@ -207,19 +217,21 @@ void sn_dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 
 	provider->dma_unmap(pdev, dma_addr, direction);
 }
-EXPORT_SYMBOL(sn_dma_unmap_single);
+EXPORT_SYMBOL(sn_dma_unmap_single_attrs);
 
 /**
- * sn_dma_unmap_sg - unmap a DMA scatterlist
+ * sn_dma_unmap_sg_attrs - unmap a DMA scatterlist
  * @dev: device to unmap
  * @sg: scatterlist to unmap
  * @nhwentries: number of scatterlist entries
  * @direction: DMA direction
+ * @attrs: optional dma attributes
  *
  * Unmap a set of streaming mode DMA translations.
  */
-void sn_dma_unmap_sg(struct device *dev, struct scatterlist *sgl,
-		     int nhwentries, int direction)
+void sn_dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sgl,
+			   int nhwentries, int direction, 
+			   struct dma_attrs *attrs)
 {
 	int i;
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -234,25 +246,30 @@ void sn_dma_unmap_sg(struct device *dev, struct scatterlist *sgl,
 		sg->dma_length = 0;
 	}
 }
-EXPORT_SYMBOL(sn_dma_unmap_sg);
+EXPORT_SYMBOL(sn_dma_unmap_sg_attrs);
 
 /**
- * sn_dma_map_sg - map a scatterlist for DMA
+ * sn_dma_map_sg_attrs - map a scatterlist for DMA
  * @dev: device to map for
  * @sg: scatterlist to map
  * @nhwentries: number of entries
  * @direction: direction of the DMA transaction
+ * @attrs: optional dma attributes
  *
  * Maps each entry of @sg for DMA.
  */
-int sn_dma_map_sg(struct device *dev, struct scatterlist *sgl, int nhwentries,
-		  int direction)
+int sn_dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl, 
+			int nhwentries, int direction, struct dma_attrs *attrs)
 {
 	unsigned long phys_addr;
 	struct scatterlist *saved_sg = sgl, *sg;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
 	int i;
+	int dmasync, ret;
+
+	ret = dma_get_attr(attrs, DMA_ATTR_SYNC_ON_WRITE);
+	dmasync = (ret > 0);
 
 	BUG_ON(dev->bus != &pci_bus_type);
 
@@ -260,19 +277,27 @@ int sn_dma_map_sg(struct device *dev, struct scatterlist *sgl, int nhwentries,
 	 * Setup a DMA address for each entry in the scatterlist.
 	 */
 	for_each_sg(sgl, sg, nhwentries, i) {
+		dma_addr_t dma_addr;
 		phys_addr = SG_ENT_PHYS_ADDRESS(sg);
-		sg->dma_address = provider->dma_map(pdev,
-						    phys_addr, sg->length,
-						    SN_DMA_ADDR_PHYS);
+		if (dmasync)
+			dma_addr = provider->dma_map_consistent(pdev, 
+								phys_addr, 
+								sg->length,
+								SN_DMA_ADDR_PHYS);
+		else
+			dma_addr = provider->dma_map(pdev, phys_addr, 
+						     sg->length,
+						     SN_DMA_ADDR_PHYS);
 
-		if (!sg->dma_address) {
+		if(!(sg->dma_address = dma_addr)) {
 			printk(KERN_ERR "%s: out of ATEs\n", __FUNCTION__);
 
 			/*
 			 * Free any successfully allocated entries.
 			 */
 			if (i > 0)
-				sn_dma_unmap_sg(dev, saved_sg, i, direction);
+				sn_dma_unmap_sg_attrs(dev, saved_sg, i, 
+						      direction, attrs);
 			return 0;
 		}
 
@@ -281,7 +306,7 @@ int sn_dma_map_sg(struct device *dev, struct scatterlist *sgl, int nhwentries,
 
 	return nhwentries;
 }
-EXPORT_SYMBOL(sn_dma_map_sg);
+EXPORT_SYMBOL(sn_dma_map_sg_attrs);
 
 void sn_dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
 				size_t size, int direction)
diff --git a/include/asm-ia64/dma-mapping.h b/include/asm-ia64/dma-mapping.h
index f1735a2..3f15e80 100644
--- a/include/asm-ia64/dma-mapping.h
+++ b/include/asm-ia64/dma-mapping.h
@@ -23,10 +23,30 @@ dma_free_noncoherent(struct device *dev, size_t size, void *cpu_addr,
 {
 	dma_free_coherent(dev, size, cpu_addr, dma_handle);
 }
-#define dma_map_single		platform_dma_map_single
-#define dma_map_sg		platform_dma_map_sg
-#define dma_unmap_single	platform_dma_unmap_single
-#define dma_unmap_sg		platform_dma_unmap_sg
+#define dma_map_single_attrs	platform_dma_map_single_attrs
+static inline dma_addr_t dma_map_single(struct device * dev, void * cpu_addr, 
+					 size_t size, int dir)
+{
+	return dma_map_single_attrs(dev, cpu_addr, size, dir, NULL);
+}
+#define dma_map_sg_attrs	platform_dma_map_sg_attrs
+static inline int dma_map_sg(struct device *dev, struct scatterlist *sgl,
+			     int nents, int dir)
+{
+	return dma_map_sg_attrs(dev, sgl, nents, dir, NULL);
+}
+#define dma_unmap_single_attrs	platform_dma_unmap_single_attrs
+static inline void dma_unmap_single(struct device * dev, dma_addr_t cpu_addr, 
+				    size_t size, int dir)
+{
+	return dma_unmap_single_attrs(dev, cpu_addr, size, dir, NULL);
+}
+#define dma_unmap_sg_attrs	platform_dma_unmap_sg_attrs
+static inline void dma_unmap_sg(struct device *dev, struct scatterlist *sgl, 
+				int nents, int dir)
+{
+	return dma_unmap_sg_attrs(dev, sgl, nents, dir, NULL);
+}
 #define dma_sync_single_for_cpu	platform_dma_sync_single_for_cpu
 #define dma_sync_sg_for_cpu	platform_dma_sync_sg_for_cpu
 #define dma_sync_single_for_device platform_dma_sync_single_for_device
diff --git a/include/asm-ia64/machvec.h b/include/asm-ia64/machvec.h
index c201a20..20f64b4 100644
--- a/include/asm-ia64/machvec.h
+++ b/include/asm-ia64/machvec.h
@@ -22,6 +22,7 @@ struct pci_bus;
 struct task_struct;
 struct pci_dev;
 struct msi_desc;
+struct dma_attrs;
 
 typedef void ia64_mv_setup_t (char **);
 typedef void ia64_mv_cpu_init_t (void);
@@ -56,6 +57,13 @@ typedef void ia64_mv_dma_sync_sg_for_device (struct device *, struct scatterlist
 typedef int ia64_mv_dma_mapping_error (dma_addr_t dma_addr);
 typedef int ia64_mv_dma_supported (struct device *, u64);
 
+
+#define ARCH_USES_DMA_ATTRS
+typedef dma_addr_t ia64_mv_dma_map_single_attrs (struct device *, void *, size_t, int, struct dma_attrs *);
+typedef void ia64_mv_dma_unmap_single_attrs (struct device *, dma_addr_t, size_t, int, struct dma_attrs *);
+typedef int ia64_mv_dma_map_sg_attrs (struct device *, struct scatterlist *, int, int, struct dma_attrs *);
+typedef void ia64_mv_dma_unmap_sg_attrs (struct device *, struct scatterlist *, int, int, struct dma_attrs *);
+
 /*
  * WARNING: The legacy I/O space is _architected_.  Platforms are
  * expected to follow this architected model (see Section 10.7 in the
@@ -136,10 +144,10 @@ extern void machvec_tlb_migrate_finish (struct mm_struct *);
 #  define platform_dma_init		ia64_mv.dma_init
 #  define platform_dma_alloc_coherent	ia64_mv.dma_alloc_coherent
 #  define platform_dma_free_coherent	ia64_mv.dma_free_coherent
-#  define platform_dma_map_single	ia64_mv.dma_map_single
-#  define platform_dma_unmap_single	ia64_mv.dma_unmap_single
-#  define platform_dma_map_sg		ia64_mv.dma_map_sg
-#  define platform_dma_unmap_sg		ia64_mv.dma_unmap_sg
+#  define platform_dma_map_single_attrs	ia64_mv.dma_map_single_attrs
+#  define platform_dma_unmap_single_attrs	ia64_mv.dma_unmap_single_attrs
+#  define platform_dma_map_sg_attrs	ia64_mv.dma_map_sg_attrs
+#  define platform_dma_unmap_sg_attrs	ia64_mv.dma_unmap_sg_attrs
 #  define platform_dma_sync_single_for_cpu ia64_mv.dma_sync_single_for_cpu
 #  define platform_dma_sync_sg_for_cpu	ia64_mv.dma_sync_sg_for_cpu
 #  define platform_dma_sync_single_for_device ia64_mv.dma_sync_single_for_device
@@ -190,10 +198,10 @@ struct ia64_machine_vector {
 	ia64_mv_dma_init *dma_init;
 	ia64_mv_dma_alloc_coherent *dma_alloc_coherent;
 	ia64_mv_dma_free_coherent *dma_free_coherent;
-	ia64_mv_dma_map_single *dma_map_single;
-	ia64_mv_dma_unmap_single *dma_unmap_single;
-	ia64_mv_dma_map_sg *dma_map_sg;
-	ia64_mv_dma_unmap_sg *dma_unmap_sg;
+	ia64_mv_dma_map_single_attrs *dma_map_single_attrs;
+	ia64_mv_dma_unmap_single_attrs *dma_unmap_single_attrs;
+	ia64_mv_dma_map_sg_attrs *dma_map_sg_attrs;
+	ia64_mv_dma_unmap_sg_attrs *dma_unmap_sg_attrs;
 	ia64_mv_dma_sync_single_for_cpu *dma_sync_single_for_cpu;
 	ia64_mv_dma_sync_sg_for_cpu *dma_sync_sg_for_cpu;
 	ia64_mv_dma_sync_single_for_device *dma_sync_single_for_device;
@@ -240,10 +248,10 @@ struct ia64_machine_vector {
 	platform_dma_init,			\
 	platform_dma_alloc_coherent,		\
 	platform_dma_free_coherent,		\
-	platform_dma_map_single,		\
-	platform_dma_unmap_single,		\
-	platform_dma_map_sg,			\
-	platform_dma_unmap_sg,			\
+	platform_dma_map_single_attrs,		\
+	platform_dma_unmap_single_attrs,	\
+	platform_dma_map_sg_attrs,		\
+	platform_dma_unmap_sg_attrs,		\
 	platform_dma_sync_single_for_cpu,	\
 	platform_dma_sync_sg_for_cpu,		\
 	platform_dma_sync_single_for_device,	\
@@ -292,9 +300,13 @@ extern ia64_mv_dma_init			swiotlb_init;
 extern ia64_mv_dma_alloc_coherent	swiotlb_alloc_coherent;
 extern ia64_mv_dma_free_coherent	swiotlb_free_coherent;
 extern ia64_mv_dma_map_single		swiotlb_map_single;
+extern ia64_mv_dma_map_single_attrs	swiotlb_map_single_attrs;
 extern ia64_mv_dma_unmap_single		swiotlb_unmap_single;
+extern ia64_mv_dma_unmap_single_attrs	swiotlb_unmap_single_attrs;
 extern ia64_mv_dma_map_sg		swiotlb_map_sg;
+extern ia64_mv_dma_map_sg_attrs		swiotlb_map_sg_attrs;
 extern ia64_mv_dma_unmap_sg		swiotlb_unmap_sg;
+extern ia64_mv_dma_unmap_sg_attrs	swiotlb_unmap_sg_attrs;
 extern ia64_mv_dma_sync_single_for_cpu	swiotlb_sync_single_for_cpu;
 extern ia64_mv_dma_sync_sg_for_cpu	swiotlb_sync_sg_for_cpu;
 extern ia64_mv_dma_sync_single_for_device swiotlb_sync_single_for_device;
@@ -340,17 +352,17 @@ extern ia64_mv_dma_supported		swiotlb_dma_supported;
 #ifndef platform_dma_free_coherent
 # define platform_dma_free_coherent	swiotlb_free_coherent
 #endif
-#ifndef platform_dma_map_single
-# define platform_dma_map_single	swiotlb_map_single
+#ifndef platform_dma_map_single_attrs
+# define platform_dma_map_single_attrs	swiotlb_map_single_attrs
 #endif
-#ifndef platform_dma_unmap_single
-# define platform_dma_unmap_single	swiotlb_unmap_single
+#ifndef platform_dma_unmap_single_attrs
+# define platform_dma_unmap_single_attrs	swiotlb_unmap_single_attrs
 #endif
-#ifndef platform_dma_map_sg
-# define platform_dma_map_sg		swiotlb_map_sg
+#ifndef platform_dma_map_sg_attrs
+# define platform_dma_map_sg_attrs	swiotlb_map_sg_attrs
 #endif
-#ifndef platform_dma_unmap_sg
-# define platform_dma_unmap_sg		swiotlb_unmap_sg
+#ifndef platform_dma_unmap_sg_attrs
+# define platform_dma_unmap_sg_attrs	swiotlb_unmap_sg_attrs
 #endif
 #ifndef platform_dma_sync_single_for_cpu
 # define platform_dma_sync_single_for_cpu	swiotlb_sync_single_for_cpu
diff --git a/include/asm-ia64/machvec_hpzx1.h b/include/asm-ia64/machvec_hpzx1.h
index e90daf9..2f57f51 100644
--- a/include/asm-ia64/machvec_hpzx1.h
+++ b/include/asm-ia64/machvec_hpzx1.h
@@ -4,10 +4,10 @@
 extern ia64_mv_setup_t			dig_setup;
 extern ia64_mv_dma_alloc_coherent	sba_alloc_coherent;
 extern ia64_mv_dma_free_coherent	sba_free_coherent;
-extern ia64_mv_dma_map_single		sba_map_single;
-extern ia64_mv_dma_unmap_single		sba_unmap_single;
-extern ia64_mv_dma_map_sg		sba_map_sg;
-extern ia64_mv_dma_unmap_sg		sba_unmap_sg;
+extern ia64_mv_dma_map_single_attrs	sba_map_single_attrs;
+extern ia64_mv_dma_unmap_single_attrs	sba_unmap_single_attrs;
+extern ia64_mv_dma_map_sg_attrs		sba_map_sg_attrs;
+extern ia64_mv_dma_unmap_sg_attrs	sba_unmap_sg_attrs;
 extern ia64_mv_dma_supported		sba_dma_supported;
 extern ia64_mv_dma_mapping_error	sba_dma_mapping_error;
 
@@ -23,10 +23,10 @@ extern ia64_mv_dma_mapping_error	sba_dma_mapping_error;
 #define platform_dma_init			machvec_noop
 #define platform_dma_alloc_coherent		sba_alloc_coherent
 #define platform_dma_free_coherent		sba_free_coherent
-#define platform_dma_map_single			sba_map_single
-#define platform_dma_unmap_single		sba_unmap_single
-#define platform_dma_map_sg			sba_map_sg
-#define platform_dma_unmap_sg			sba_unmap_sg
+#define platform_dma_map_single_attrs		sba_map_single_attrs
+#define platform_dma_unmap_single_attrs		sba_unmap_single_attrs
+#define platform_dma_map_sg_attrs		sba_map_sg_attrs
+#define platform_dma_unmap_sg_attrs		sba_unmap_sg_attrs
 #define platform_dma_sync_single_for_cpu	machvec_dma_sync_single
 #define platform_dma_sync_sg_for_cpu		machvec_dma_sync_sg
 #define platform_dma_sync_single_for_device	machvec_dma_sync_single
diff --git a/include/asm-ia64/machvec_hpzx1_swiotlb.h b/include/asm-ia64/machvec_hpzx1_swiotlb.h
index f00a34a..a842cdd 100644
--- a/include/asm-ia64/machvec_hpzx1_swiotlb.h
+++ b/include/asm-ia64/machvec_hpzx1_swiotlb.h
@@ -4,10 +4,10 @@
 extern ia64_mv_setup_t				dig_setup;
 extern ia64_mv_dma_alloc_coherent		hwsw_alloc_coherent;
 extern ia64_mv_dma_free_coherent		hwsw_free_coherent;
-extern ia64_mv_dma_map_single			hwsw_map_single;
-extern ia64_mv_dma_unmap_single			hwsw_unmap_single;
-extern ia64_mv_dma_map_sg			hwsw_map_sg;
-extern ia64_mv_dma_unmap_sg			hwsw_unmap_sg;
+extern ia64_mv_dma_map_single_attrs		hwsw_map_single_attrs;
+extern ia64_mv_dma_unmap_single_attrs		hwsw_unmap_single_attrs;
+extern ia64_mv_dma_map_sg_attrs			hwsw_map_sg_attrs;
+extern ia64_mv_dma_unmap_sg_attrs		hwsw_unmap_sg_attrs;
 extern ia64_mv_dma_supported			hwsw_dma_supported;
 extern ia64_mv_dma_mapping_error		hwsw_dma_mapping_error;
 extern ia64_mv_dma_sync_single_for_cpu		hwsw_sync_single_for_cpu;
@@ -28,10 +28,10 @@ extern ia64_mv_dma_sync_sg_for_device		hwsw_sync_sg_for_device;
 #define platform_dma_init			machvec_noop
 #define platform_dma_alloc_coherent		hwsw_alloc_coherent
 #define platform_dma_free_coherent		hwsw_free_coherent
-#define platform_dma_map_single			hwsw_map_single
-#define platform_dma_unmap_single		hwsw_unmap_single
-#define platform_dma_map_sg			hwsw_map_sg
-#define platform_dma_unmap_sg			hwsw_unmap_sg
+#define platform_dma_map_single_attrs		hwsw_map_single_attrs
+#define platform_dma_unmap_single_attrs		hwsw_unmap_single_attrs
+#define platform_dma_map_sg_attrs		hwsw_map_sg_attrs
+#define platform_dma_unmap_sg_attrs		hwsw_unmap_sg_attrs
 #define platform_dma_supported			hwsw_dma_supported
 #define platform_dma_mapping_error		hwsw_dma_mapping_error
 #define platform_dma_sync_single_for_cpu	hwsw_sync_single_for_cpu
diff --git a/include/asm-ia64/machvec_sn2.h b/include/asm-ia64/machvec_sn2.h
index 61439a7..781308e 100644
--- a/include/asm-ia64/machvec_sn2.h
+++ b/include/asm-ia64/machvec_sn2.h
@@ -57,10 +57,10 @@ extern ia64_mv_readl_t __sn_readl_relaxed;
 extern ia64_mv_readq_t __sn_readq_relaxed;
 extern ia64_mv_dma_alloc_coherent	sn_dma_alloc_coherent;
 extern ia64_mv_dma_free_coherent	sn_dma_free_coherent;
-extern ia64_mv_dma_map_single		sn_dma_map_single;
-extern ia64_mv_dma_unmap_single		sn_dma_unmap_single;
-extern ia64_mv_dma_map_sg		sn_dma_map_sg;
-extern ia64_mv_dma_unmap_sg		sn_dma_unmap_sg;
+extern ia64_mv_dma_map_single_attrs	sn_dma_map_single_attrs;
+extern ia64_mv_dma_unmap_single_attrs	sn_dma_unmap_single_attrs;
+extern ia64_mv_dma_map_sg_attrs		sn_dma_map_sg_attrs;
+extern ia64_mv_dma_unmap_sg_attrs	sn_dma_unmap_sg_attrs;
 extern ia64_mv_dma_sync_single_for_cpu	sn_dma_sync_single_for_cpu;
 extern ia64_mv_dma_sync_sg_for_cpu	sn_dma_sync_sg_for_cpu;
 extern ia64_mv_dma_sync_single_for_device sn_dma_sync_single_for_device;
@@ -113,10 +113,10 @@ extern ia64_mv_pci_fixup_bus_t		sn_pci_fixup_bus;
 #define platform_dma_init		machvec_noop
 #define platform_dma_alloc_coherent	sn_dma_alloc_coherent
 #define platform_dma_free_coherent	sn_dma_free_coherent
-#define platform_dma_map_single		sn_dma_map_single
-#define platform_dma_unmap_single	sn_dma_unmap_single
-#define platform_dma_map_sg		sn_dma_map_sg
-#define platform_dma_unmap_sg		sn_dma_unmap_sg
+#define platform_dma_map_single_attrs	sn_dma_map_single_attrs
+#define platform_dma_unmap_single_attrs	sn_dma_unmap_single_attrs
+#define platform_dma_map_sg_attrs	sn_dma_map_sg_attrs
+#define platform_dma_unmap_sg_attrs	sn_dma_unmap_sg_attrs
 #define platform_dma_sync_single_for_cpu sn_dma_sync_single_for_cpu
 #define platform_dma_sync_sg_for_cpu	sn_dma_sync_sg_for_cpu
 #define platform_dma_sync_single_for_device sn_dma_sync_single_for_device
diff --git a/include/linux/dma-attrs.h b/include/linux/dma-attrs.h
index e69de29..43a6214 100644
--- a/include/linux/dma-attrs.h
+++ b/include/linux/dma-attrs.h
@@ -0,0 +1,49 @@
+#ifndef _DMA_ATTR_H
+#define _DMA_ATTR_H
+
+enum dma_attr {
+	DMA_ATTR_SYNC_ON_WRITE,
+	DMA_ATTR_MAX,
+};
+
+struct dma_attrs {
+	unsigned flags;
+};
+
+#define __DMA_ATTRS_INIT() { .flags = 0, }
+
+#define DECLARE_DMA_ATTRS(x) struct dma_attrs x = __DMA_ATTRS_INIT()
+
+#define INIT_DMA_ATTRS(x) (x)->flags = 0;
+
+#ifdef ARCH_USES_DMA_ATTRS
+/*
+ * dma_set_attr - set a specific attribute
+ * may be called with a null attrs
+ */
+static inline int dma_set_attr(struct dma_attrs *attrs, enum dma_attr attr) {
+	if (!attrs) return 0;
+	if (attr < DMA_ATTR_MAX) {
+		attrs->flags |= (1 << attr);
+		return 0;
+	}
+	return -EINVAL;
+}
+
+/*
+ * dma_get_attr - check for a specific attribute
+ * may be called with a null attrs
+ */
+static inline int dma_get_attr(struct dma_attrs *attrs, enum dma_attr attr) {
+	if (!attrs) return 0;
+	if (attr < DMA_ATTR_MAX) {
+		int ret = attrs->flags & (1 << attr);
+		return !!ret;
+	}
+	return -EINVAL;
+}
+#else /* !ARCH_USES_DMA_ATTRS */
+#define dma_set_attr(a, b)	do { } while (0)
+#define dma_get_attr(a, b)	do { } while (0)
+#endif /* ARCH_USES_DMA_ATTRS */
+#endif /* _DMA_ATTR_H */
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 1a8050a..59cb2b0 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -535,7 +535,8 @@ swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
  * either swiotlb_unmap_single or swiotlb_dma_sync_single is performed.
  */
 dma_addr_t
-swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir)
+swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size, 
+			 int dir, struct dma_attrs *attrs)
 {
 	dma_addr_t dev_addr = virt_to_bus(ptr);
 	void *map;
@@ -569,6 +570,12 @@ swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir)
 	return dev_addr;
 }
 
+dma_addr_t
+swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir)
+{
+	return swiotlb_map_single_attrs(hwdev, ptr, size, dir, NULL);
+}
+
 /*
  * Unmap a single streaming mode DMA translation.  The dma_addr and size must
  * match what was provided for in a previous swiotlb_map_single call.  All
@@ -578,8 +585,8 @@ swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir)
  * whatever the device wrote there.
  */
 void
-swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr, size_t size,
-		     int dir)
+swiotlb_unmap_single_attrs(struct device *hwdev, dma_addr_t dev_addr, 
+			   size_t size, int dir, struct dma_attrs *attrs)
 {
 	char *dma_addr = bus_to_virt(dev_addr);
 
@@ -590,6 +597,12 @@ swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr, size_t size,
 		dma_mark_clean(dma_addr, size);
 }
 
+void
+swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr, size_t size, 
+		     int dir)
+{
+	return swiotlb_unmap_single_attrs(hwdev, dev_addr, size, dir, NULL);
+}
 /*
  * Make physical memory consistent for a single streaming mode DMA translation
  * after a transfer.
@@ -660,6 +673,8 @@ swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
 				  SYNC_FOR_DEVICE);
 }
 
+void swiotlb_unmap_sg_attrs(struct device *, struct scatterlist *, int, int,
+			    struct dma_attrs *);
 /*
  * Map a set of buffers described by scatterlist in streaming mode for DMA.
  * This is the scatter-gather version of the above swiotlb_map_single
@@ -677,8 +692,8 @@ swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
  * same here.
  */
 int
-swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
-	       int dir)
+swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
+		     int dir, struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	void *addr;
@@ -696,7 +711,8 @@ swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
 				/* Don't panic here, we expect map_sg users
 				   to do proper error handling. */
 				swiotlb_full(hwdev, sg->length, dir, 0);
-				swiotlb_unmap_sg(hwdev, sgl, i, dir);
+				swiotlb_unmap_sg_attrs(hwdev, sgl, i, dir, 
+						       attrs);
 				sgl[0].dma_length = 0;
 				return 0;
 			}
@@ -708,13 +724,20 @@ swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
 	return nelems;
 }
 
+int
+swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
+	       int dir)
+{
+	return swiotlb_map_sg_attrs(hwdev, sgl, nelems, dir, NULL);
+}
+
 /*
  * Unmap a set of streaming mode DMA translations.  Again, cpu read rules
  * concerning calls here are the same as for swiotlb_unmap_single() above.
  */
 void
-swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
-		 int dir)
+swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl, 
+		       int nelems, int dir, struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -730,6 +753,13 @@ swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
 	}
 }
 
+void
+swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems, 
+		 int dir)
+{
+	return swiotlb_unmap_sg_attrs(hwdev, sgl, nelems, dir, NULL);
+}
+
 /*
  * Make physical memory consistent for a set of streaming mode DMA translations
  * after a transfer.
@@ -791,6 +821,10 @@ EXPORT_SYMBOL(swiotlb_map_single);
 EXPORT_SYMBOL(swiotlb_unmap_single);
 EXPORT_SYMBOL(swiotlb_map_sg);
 EXPORT_SYMBOL(swiotlb_unmap_sg);
+EXPORT_SYMBOL(swiotlb_map_single_attrs);
+EXPORT_SYMBOL(swiotlb_unmap_single_attrs);
+EXPORT_SYMBOL(swiotlb_map_sg_attrs);
+EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
 EXPORT_SYMBOL(swiotlb_sync_single_for_cpu);
 EXPORT_SYMBOL(swiotlb_sync_single_for_device);
 EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_cpu);

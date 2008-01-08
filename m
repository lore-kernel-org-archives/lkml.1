Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbYAHCji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbYAHCji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 21:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbYAHCja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 21:39:30 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46807 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755815AbYAHCj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 21:39:29 -0500
From: akepner@sgi.com
Date: Mon, 7 Jan 2008 18:38:00 -0800
To: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC/PARTIAL PATCH 2/3] dma: ia64/sn2 allow "attributes" to be used by dma_map_*
Message-ID: <20080108023800.GR23661@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Allow dma "attributes" to be used by dma_map_*/dma_unmap_* 
implementations on the ia64/sn2 architecture. (This one also 
includes some changes to lib/swiotlb.c which aren't specific 
to ia64/sn2.)

Signed-off-by: Arthur Kepner <akepner@sgi.com>

--

 arch/ia64/sn/pci/pci_dma.c |   45 ++++++++++++++++++++++++++++++++-------------
 include/asm-ia64/machvec.h |    8 ++++----
 lib/swiotlb.c              |   12 ++++++++----
 3 files changed, 44 insertions(+), 21 deletions(-)

diff --git a/arch/ia64/sn/pci/pci_dma.c b/arch/ia64/sn/pci/pci_dma.c
index 511db2f..57ddbcb 100644
--- a/arch/ia64/sn/pci/pci_dma.c
+++ b/arch/ia64/sn/pci/pci_dma.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/dma-direction.h>
 #include <asm/dma.h>
 #include <asm/sn/intr.h>
 #include <asm/sn/pcibus_provider_defs.h>
@@ -153,7 +154,7 @@ EXPORT_SYMBOL(sn_dma_free_coherent);
  * @dev: device to map for
  * @cpu_addr: kernel virtual address of the region to map
  * @size: size of the region
- * @direction: DMA direction
+ * @flags: DMA direction and attributes
  *
  * Map the region pointed to by @cpu_addr for DMA and return the
  * DMA address.
@@ -167,17 +168,23 @@ EXPORT_SYMBOL(sn_dma_free_coherent);
  *       figure out how to save dmamap handle so can use two step.
  */
 dma_addr_t sn_dma_map_single(struct device *dev, void *cpu_addr, size_t size,
-			     int direction)
+			     u32 flags)
 {
 	dma_addr_t dma_addr;
 	unsigned long phys_addr;
 	struct pci_dev *pdev = to_pci_dev(dev);
+	u32 attr = dma_flags_get_attr(flags);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
 
 	BUG_ON(dev->bus != &pci_bus_type);
 
 	phys_addr = __pa(cpu_addr);
-	dma_addr = provider->dma_map(pdev, phys_addr, size, SN_DMA_ADDR_PHYS);
+	if (attr & DMA_ATTR_BARRIER)
+		dma_addr = provider->dma_map_consistent(pdev, phys_addr, size, 
+							SN_DMA_ADDR_PHYS);
+	else
+		dma_addr = provider->dma_map(pdev, phys_addr, size, 
+					     SN_DMA_ADDR_PHYS);
 	if (!dma_addr) {
 		printk(KERN_ERR "%s: out of ATEs\n", __FUNCTION__);
 		return 0;
@@ -191,17 +198,18 @@ EXPORT_SYMBOL(sn_dma_map_single);
  * @dev: device to sync
  * @dma_addr: DMA address to sync
  * @size: size of region
- * @direction: DMA direction
+ * @flags: DMA direction and attributes
  *
  * This routine is supposed to sync the DMA region specified
  * by @dma_handle into the coherence domain.  On SN, we're always cache
  * coherent, so we just need to free any ATEs associated with this mapping.
  */
 void sn_dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-			 int direction)
+			 u32 flags)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
+	enum dma_data_direction direction = dma_flags_get_dir(flags);
 
 	BUG_ON(dev->bus != &pci_bus_type);
 
@@ -214,16 +222,17 @@ EXPORT_SYMBOL(sn_dma_unmap_single);
  * @dev: device to unmap
  * @sg: scatterlist to unmap
  * @nhwentries: number of scatterlist entries
- * @direction: DMA direction
+ * @flags: DMA direction and attributes
  *
  * Unmap a set of streaming mode DMA translations.
  */
 void sn_dma_unmap_sg(struct device *dev, struct scatterlist *sgl,
-		     int nhwentries, int direction)
+		     int nhwentries, u32 flags)
 {
 	int i;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
+	enum dma_data_direction direction = dma_flags_get_dir(flags);
 	struct scatterlist *sg;
 
 	BUG_ON(dev->bus != &pci_bus_type);
@@ -241,17 +250,19 @@ EXPORT_SYMBOL(sn_dma_unmap_sg);
  * @dev: device to map for
  * @sg: scatterlist to map
  * @nhwentries: number of entries
- * @direction: direction of the DMA transaction
+ * @flags: direction of the DMA transaction and DMA attributes
  *
  * Maps each entry of @sg for DMA.
  */
 int sn_dma_map_sg(struct device *dev, struct scatterlist *sgl, int nhwentries,
-		  int direction)
+		  u32 flags)
 {
 	unsigned long phys_addr;
 	struct scatterlist *saved_sg = sgl, *sg;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
+	enum dma_data_direction direction = dma_flags_get_dir(flags);
+	u32 attr = dma_flags_get_attr(flags);
 	int i;
 
 	BUG_ON(dev->bus != &pci_bus_type);
@@ -260,12 +271,20 @@ int sn_dma_map_sg(struct device *dev, struct scatterlist *sgl, int nhwentries,
 	 * Setup a DMA address for each entry in the scatterlist.
 	 */
 	for_each_sg(sgl, sg, nhwentries, i) {
+		dma_addr_t dma_addr;
 		phys_addr = SG_ENT_PHYS_ADDRESS(sg);
-		sg->dma_address = provider->dma_map(pdev,
-						    phys_addr, sg->length,
-						    SN_DMA_ADDR_PHYS);
 
-		if (!sg->dma_address) {
+		if (attr & DMA_ATTR_BARRIER)
+			dma_addr = provider->dma_map_consistent(pdev,
+								phys_addr,
+								sg->length,
+								SN_DMA_ADDR_PHYS);
+		else
+			dma_addr = provider->dma_map(pdev,
+						     phys_addr, sg->length,
+						     SN_DMA_ADDR_PHYS);
+
+		if (!(sg->dma_address = dma_addr)) {
 			printk(KERN_ERR "%s: out of ATEs\n", __FUNCTION__);
 
 			/*
diff --git a/include/asm-ia64/machvec.h b/include/asm-ia64/machvec.h
index c201a20..db3b805 100644
--- a/include/asm-ia64/machvec.h
+++ b/include/asm-ia64/machvec.h
@@ -45,10 +45,10 @@ typedef void ia64_mv_kernel_launch_event_t(void);
 typedef void ia64_mv_dma_init (void);
 typedef void *ia64_mv_dma_alloc_coherent (struct device *, size_t, dma_addr_t *, gfp_t);
 typedef void ia64_mv_dma_free_coherent (struct device *, size_t, void *, dma_addr_t);
-typedef dma_addr_t ia64_mv_dma_map_single (struct device *, void *, size_t, int);
-typedef void ia64_mv_dma_unmap_single (struct device *, dma_addr_t, size_t, int);
-typedef int ia64_mv_dma_map_sg (struct device *, struct scatterlist *, int, int);
-typedef void ia64_mv_dma_unmap_sg (struct device *, struct scatterlist *, int, int);
+typedef dma_addr_t ia64_mv_dma_map_single (struct device *, void *, size_t, u32);
+typedef void ia64_mv_dma_unmap_single (struct device *, dma_addr_t, size_t, u32);
+typedef int ia64_mv_dma_map_sg (struct device *, struct scatterlist *, int, u32);
+typedef void ia64_mv_dma_unmap_sg (struct device *, struct scatterlist *, int, u32);
 typedef void ia64_mv_dma_sync_single_for_cpu (struct device *, dma_addr_t, size_t, int);
 typedef void ia64_mv_dma_sync_sg_for_cpu (struct device *, struct scatterlist *, int, int);
 typedef void ia64_mv_dma_sync_single_for_device (struct device *, dma_addr_t, size_t, int);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 1a8050a..45780e9 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -535,10 +535,11 @@ swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
  * either swiotlb_unmap_single or swiotlb_dma_sync_single is performed.
  */
 dma_addr_t
-swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir)
+swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, u32 flags)
 {
 	dma_addr_t dev_addr = virt_to_bus(ptr);
 	void *map;
+	enum dma_data_direction dir = dma_flags_get_dir(flags);
 
 	BUG_ON(dir == DMA_NONE);
 	/*
@@ -579,9 +580,10 @@ swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir)
  */
 void
 swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr, size_t size,
-		     int dir)
+		     u32 flags)
 {
 	char *dma_addr = bus_to_virt(dev_addr);
+	enum dma_data_direction dir = dma_flags_get_dir(flags);
 
 	BUG_ON(dir == DMA_NONE);
 	if (dma_addr >= io_tlb_start && dma_addr < io_tlb_end)
@@ -678,12 +680,13 @@ swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
  */
 int
 swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
-	       int dir)
+	       u32 flags)
 {
 	struct scatterlist *sg;
 	void *addr;
 	dma_addr_t dev_addr;
 	int i;
+	enum dma_data_direction dir = dma_flags_get_dir(flags);
 
 	BUG_ON(dir == DMA_NONE);
 
@@ -714,10 +717,11 @@ swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
  */
 void
 swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
-		 int dir)
+		 u32 flags)
 {
 	struct scatterlist *sg;
 	int i;
+	enum dma_data_direction dir = dma_flags_get_dir(flags);
 
 	BUG_ON(dir == DMA_NONE);
 

-- 
Arthur


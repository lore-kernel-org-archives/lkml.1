Return-Path: <linux-kernel-owner+w=401wt.eu-S1761306AbXHRA3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761306AbXHRA3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 20:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758103AbXHRA2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 20:28:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59205 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758024AbXHRA2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 20:28:41 -0400
From: akepner@sgi.com
Date: Fri, 17 Aug 2007 17:27:46 -0700
To: linux-kernel@vger.kernel.org
Cc: jes@sgi.com, rdreier@cisco.com
Subject: [PATCH 2/3] dma: override "dma_flags_set_dmaflush" for sn-ia64
Message-ID: <20070818002746.GU1813@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Define ARCH_DOES_POSTED_DMA, and override the dma_flags_set_dmaflush 
function. Also define dma_flags_get_direction, dma_flags_get_dmaflush 
to retrieve the direction and "dmaflush attribute" from flags 
passed to the sn_dma_map_* functions.


Signed-off-by: Arthur Kepner <akepner@sgi.com>
--
 arch/ia64/sn/pci/pci_dma.c |   35 ++++++++++++++++++++++++++---------
 include/asm-ia64/sn/io.h   |   26 ++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/arch/ia64/sn/pci/pci_dma.c b/arch/ia64/sn/pci/pci_dma.c
index d79ddac..754240b 100644
--- a/arch/ia64/sn/pci/pci_dma.c
+++ b/arch/ia64/sn/pci/pci_dma.c
@@ -153,7 +153,7 @@ EXPORT_SYMBOL(sn_dma_free_coherent);
  * @dev: device to map for
  * @cpu_addr: kernel virtual address of the region to map
  * @size: size of the region
- * @direction: DMA direction
+ * @flags: DMA direction, and arch-specific attributes
  *
  * Map the region pointed to by @cpu_addr for DMA and return the
  * DMA address.
@@ -167,17 +167,23 @@ EXPORT_SYMBOL(sn_dma_free_coherent);
  *       figure out how to save dmamap handle so can use two step.
  */
 dma_addr_t sn_dma_map_single(struct device *dev, void *cpu_addr, size_t size,
-			     int direction)
+			     int flags)
 {
 	dma_addr_t dma_addr;
 	unsigned long phys_addr;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
+	int dmaflush = dma_flags_get_dmaflush(flags);
 
 	BUG_ON(dev->bus != &pci_bus_type);
 
 	phys_addr = __pa(cpu_addr);
-	dma_addr = provider->dma_map(pdev, phys_addr, size, SN_DMA_ADDR_PHYS);
+	if (dmaflush)
+		dma_addr = provider->dma_map_consistent(pdev, phys_addr, size, 
+							SN_DMA_ADDR_PHYS);
+	else
+		dma_addr = provider->dma_map(pdev, phys_addr, size, 
+					     SN_DMA_ADDR_PHYS);
 	if (!dma_addr) {
 		printk(KERN_ERR "%s: out of ATEs\n", __FUNCTION__);
 		return 0;
@@ -240,18 +246,20 @@ EXPORT_SYMBOL(sn_dma_unmap_sg);
  * @dev: device to map for
  * @sg: scatterlist to map
  * @nhwentries: number of entries
- * @direction: direction of the DMA transaction
+ * @flags: direction of the DMA transaction, and arch-specific attributes
  *
  * Maps each entry of @sg for DMA.
  */
 int sn_dma_map_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
-		  int direction)
+		  int flags)
 {
 	unsigned long phys_addr;
 	struct scatterlist *saved_sg = sg;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
 	int i;
+	int dmaflush = dma_flags_get_dmaflush(flags);
+	int direction = dma_flags_get_direction(flags);
 
 	BUG_ON(dev->bus != &pci_bus_type);
 
@@ -259,12 +267,21 @@ int sn_dma_map_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
 	 * Setup a DMA address for each entry in the scatterlist.
 	 */
 	for (i = 0; i < nhwentries; i++, sg++) {
+		dma_addr_t dma_addr;
 		phys_addr = SG_ENT_PHYS_ADDRESS(sg);
-		sg->dma_address = provider->dma_map(pdev,
-						    phys_addr, sg->length,
-						    SN_DMA_ADDR_PHYS);
 
-		if (!sg->dma_address) {
+		if (dmaflush) {
+			dma_addr = provider->dma_map_consistent(pdev,
+								phys_addr,
+								sg->length,
+								SN_DMA_ADDR_PHYS);
+		} else {
+			dma_addr = provider->dma_map(pdev,
+						     phys_addr, sg->length,
+						     SN_DMA_ADDR_PHYS);
+		}
+
+		if (!(sg->dma_address = dma_addr)) {
 			printk(KERN_ERR "%s: out of ATEs\n", __FUNCTION__);
 
 			/*
diff --git a/include/asm-ia64/sn/io.h b/include/asm-ia64/sn/io.h
index 41c73a7..c82eb90 100644
--- a/include/asm-ia64/sn/io.h
+++ b/include/asm-ia64/sn/io.h
@@ -271,4 +271,30 @@ sn_pci_set_vchan(struct pci_dev *pci_dev, unsigned long *addr, int vchan)
 	return 0;
 }
 
+#define ARCH_DOES_POSTED_DMA
+/* here we steal some upper bits from the "direction" argument to the 
+ * dma_map_* routines */
+#define DMA_ATTR_SHIFT	8
+/* bottom 8 bits for direction, remaining bits for additional "attributes" */
+#define DMA_FLUSH_ATTR	0x1
+/* For now the only attribute is "flush in-flight dma when writing to 
+ * this DMA mapped memory" */
+#define DMA_DIR_MASK   ((1 << DMA_ATTR_SHIFT) - 1)
+#define DMA_ATTR_MASK  ~DMA_DIR_MASK
+
+static inline int
+dma_flags_set_dmaflush(int dir) {
+	return (dir | (DMA_FLUSH_ATTR<< DMA_ATTR_SHIFT));
+}
+
+static inline int
+dma_flags_get_direction(int dir) {
+	return (dir & DMA_DIR_MASK);
+}
+
+static inline int
+dma_flags_get_dmaflush(int dir) {
+	return (((dir & DMA_ATTR_MASK) >> DMA_ATTR_SHIFT) & DMA_FLUSH_ATTR);
+}
+
 #endif	/* _ASM_SN_IO_H */
-- 
Arthur


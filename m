Return-Path: <linux-kernel-owner+w=401wt.eu-S935485AbXJQBoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935485AbXJQBoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 21:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760924AbXJQBob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 21:44:31 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51233 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760881AbXJQBoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 21:44:30 -0400
From: akepner@sgi.com
Date: Tue, 16 Oct 2007 18:43:16 -0700
To: akpm@linux-foundation.org
Cc: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] dma: redefine dma_flags_set/get_*() for sn-ia64
Message-ID: <20071017014316.GK5601@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Redefine dma_flags_set/get_*() for sn-ia64. 

dma_flags_set_attr() "borrows" bits from the dma_map_* routines' 
direction arguments (renamed "flags"). It uses the borrowed bits 
to pass additional attributes.

dma_flags_get_dir() and dma_flags_get_attr() return the direction 
and attributes that were set with dma_flags_set_attr().

Signed-off-by: Arthur Kepner <akepner@sgi.com>

--- 

 arch/ia64/sn/pci/pci_dma.c |   37 +++++++++++++++++++++++++++----------
 include/asm-ia64/sn/io.h   |   27 +++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 10 deletions(-)

diff --git a/arch/ia64/sn/pci/pci_dma.c b/arch/ia64/sn/pci/pci_dma.c
index ecd8a52..73d3897 100644
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
+	int dmabarrier = dma_flags_get_attr(flags) & DMA_BARRIER_ATTR;
 
 	BUG_ON(dev->bus != &pci_bus_type);
 
 	phys_addr = __pa(cpu_addr);
-	dma_addr = provider->dma_map(pdev, phys_addr, size, SN_DMA_ADDR_PHYS);
+	if (dmabarrier)
+		dma_addr = provider->dma_map_consistent(pdev, phys_addr, size, 
+							SN_DMA_ADDR_PHYS);
+	else
+		dma_addr = provider->dma_map(pdev, phys_addr, size, 
+					     SN_DMA_ADDR_PHYS);
 	if (!dma_addr) {
 		printk(KERN_ERR "%s: out of ATEs\n", __FUNCTION__);
 		return 0;
@@ -241,18 +247,20 @@ EXPORT_SYMBOL(sn_dma_unmap_sg);
  * @dev: device to map for
  * @sg: scatterlist to map
  * @nhwentries: number of entries
- * @direction: direction of the DMA transaction
+ * @flags: direction of the DMA transaction, and arch-specific attributes
  *
  * Maps each entry of @sg for DMA.
  */
 int sn_dma_map_sg(struct device *dev, struct scatterlist *sgl, int nhwentries,
-		  int direction)
+		  int flags)
 {
 	unsigned long phys_addr;
 	struct scatterlist *saved_sg = sgl, *sg;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
 	int i;
+	int dmabarrier = dma_flags_get_attr(flags) & DMA_BARRIER_ATTR;
+	int dir = dma_flags_get_dir(flags);
 
 	BUG_ON(dev->bus != &pci_bus_type);
 
@@ -260,19 +268,28 @@ int sn_dma_map_sg(struct device *dev, struct scatterlist *sgl, int nhwentries,
 	 * Setup a DMA address for each entry in the scatterlist.
 	 */
 	for_each_sg(sgl, sg, nhwentries, i) {
+		dma_addr_t dma_addr;
 		phys_addr = SG_ENT_PHYS_ADDRESS(sg);
-		sg->dma_address = provider->dma_map(pdev,
-						    phys_addr, sg->length,
-						    SN_DMA_ADDR_PHYS);
 
-		if (!sg->dma_address) {
+		if (dmabarrier) {
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
 			 * Free any successfully allocated entries.
 			 */
 			if (i > 0)
-				sn_dma_unmap_sg(dev, saved_sg, i, direction);
+				sn_dma_unmap_sg(dev, saved_sg, i, dir);
 			return 0;
 		}
 
diff --git a/include/asm-ia64/sn/io.h b/include/asm-ia64/sn/io.h
index 41c73a7..52a6fdb 100644
--- a/include/asm-ia64/sn/io.h
+++ b/include/asm-ia64/sn/io.h
@@ -271,4 +271,31 @@ sn_pci_set_vchan(struct pci_dev *pci_dev, unsigned long *addr, int vchan)
 	return 0;
 }
 
+#ifdef CONFIG_IA64_SGI_SN2
+/* we have to check for CONFIG_IA64_SGI_SN2 since at least one 
+ * driver directly includes this file for both IA64_GENERIC 
+ * and IA64_SGI_SN2 */
+#define ARCH_USES_DMA_ATTRS
+/* we pass additional dma attributes in the direction argument to the 
+ * dma_map_* routines */
+#define SN_DMA_ATTR_SHIFT	8
+/* bottom 8 bits for direction, remaining bits for dma attributes */
+#define SN_DMA_DIR_MASK   ((1 << SN_DMA_ATTR_SHIFT) - 1)
+#define SN_DMA_ATTR_MASK  ~SN_DMA_DIR_MASK
+
+static inline int dma_flags_set_attr(int attr, int dir)
+{
+	return (dir | (attr << SN_DMA_ATTR_SHIFT));
+}
+
+static inline int dma_flags_get_dir(int flags) 
+{
+	return (flags & SN_DMA_DIR_MASK);
+}
+
+static inline int dma_flags_get_attr(int flags) 
+{
+	return ((flags & SN_DMA_ATTR_MASK) >> SN_DMA_ATTR_SHIFT);
+}
+#endif /* CONFIG_IA64_SGI_SN2 */
 #endif	/* _ASM_SN_IO_H */

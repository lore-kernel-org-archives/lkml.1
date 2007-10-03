Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbXJCCru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbXJCCru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 22:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbXJCCrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 22:47:42 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38375 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753713AbXJCCrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 22:47:42 -0400
From: akepner@sgi.com
Date: Tue, 2 Oct 2007 19:46:41 -0700
To: Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       RolandDreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] dma: redefine dma_flags_set_attr() for sn-ia64
Message-ID: <20071003024641.GG26752@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


define dma_flags_set_attr() for sn-ia64 - it "borrows" bits from 
the direction argument (renamed "flags") to the dma_map_* routines 
to pass an additional attributes.  Also define routines to retrieve 
the original direction and attribute from "flags".

Signed-off-by: Arthur Kepner <akepner@sgi.com>

---

 arch/ia64/sn/pci/pci_dma.c |   37 +++++++++++++++++++++++++++----------
 include/asm-ia64/sn/io.h   |   23 +++++++++++++++++++++++
 2 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/arch/ia64/sn/pci/pci_dma.c b/arch/ia64/sn/pci/pci_dma.c
index d79ddac..84b6227 100644
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
+	int dmabarrier = dma_flags_get_attr(flags) & DMA_BARRIER_ATTR;
+	int dir = dma_flags_get_dir(flags);
 
 	BUG_ON(dev->bus != &pci_bus_type);
 
@@ -259,19 +267,28 @@ int sn_dma_map_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
 	 * Setup a DMA address for each entry in the scatterlist.
 	 */
 	for (i = 0; i < nhwentries; i++, sg++) {
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
index 41c73a7..d2b94ce 100644
--- a/include/asm-ia64/sn/io.h
+++ b/include/asm-ia64/sn/io.h
@@ -271,4 +271,27 @@ sn_pci_set_vchan(struct pci_dev *pci_dev, unsigned long *addr, int vchan)
 	return 0;
 }
 
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
+
 #endif	/* _ASM_SN_IO_H */

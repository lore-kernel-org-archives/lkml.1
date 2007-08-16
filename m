Return-Path: <linux-kernel-owner+w=401wt.eu-S1765261AbXHPW5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765261AbXHPW5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 18:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760983AbXHPW5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 18:57:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35573 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761567AbXHPW47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 18:56:59 -0400
From: akepner@sgi.com
Date: Thu, 16 Aug 2007 15:56:03 -0700
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, jes@sgi.com, rdreier@cisco.com
Subject: [PATCH] sn-ia64: allow drivers to flush in-flight DMA
Message-ID: <20070816225603.GJ1813@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Altix supports "posted DMA", so that DMA may complete out 
of order. In some cases it's necessary for a driver to 
ensure that in-flight DMA has been flushed to memory for 
correct operation.

In particular this can be a problem with Infiniband, where 
writes to Completion Queues can race with DMA of data.

The following patch addresses this problem by allowing a 
memory region to be mapped with a "barrier" attribute. (On 
Altix, writes to memory regions with the barrier attribute 
have the side effect that in-flight DMA gets flushed to host 
memory.)

The only change to core code is the addition of a no-op stub 
function "dma_flags_set_dmaflush()" in linux/dma-mapping.h. 
Everything else is handled in architecture-specific or 
driver code.

Signed-off-by: Arthur Kepner <akepner@sgi.com>
-- 

 arch/ia64/sn/pci/pci_dma.c                   |   35 ++++++++++++++++++++-------
 drivers/infiniband/core/umem.c               |    8 ++++--
 drivers/infiniband/hw/mthca/mthca_provider.c |   11 +++++++-
 drivers/infiniband/hw/mthca/mthca_user.h     |   10 ++++++-
 include/asm-ia64/dma-mapping.h               |    0
 include/asm-ia64/sn/io.h                     |   26 ++++++++++++++++++++
 include/linux/dma-mapping.h                  |    7 +++++
 include/rdma/ib_umem.h                       |    4 +--
 8 files changed, 86 insertions(+), 15 deletions(-)

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
diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 26d0470..c626d2c 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -64,9 +64,11 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
  * @addr: userspace virtual address to start at
  * @size: length of region to pin
  * @access: IB_ACCESS_xxx flags for memory being pinned
+ * @dmaflush: map this memory "coherently", if necessary 
+ *  (for architectures that support posted DMA)
  */
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
-			    size_t size, int access)
+			    size_t size, int access, int dmaflush)
 {
 	struct ib_umem *umem;
 	struct page **page_list;
@@ -78,6 +80,8 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	int ret;
 	int off;
 	int i;
+	int flags = dmaflush ? dma_flags_set_dmaflush(DMA_BIDIRECTIONAL): 
+			DMA_BIDIRECTIONAL;
 
 	if (!can_do_mlock())
 		return ERR_PTR(-EPERM);
@@ -155,7 +159,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 			chunk->nmap = ib_dma_map_sg(context->device,
 						    &chunk->page_list[0],
 						    chunk->nents,
-						    DMA_BIDIRECTIONAL);
+						    flags);
 			if (chunk->nmap <= 0) {
 				for (i = 0; i < chunk->nents; ++i)
 					put_page(chunk->page_list[i].page);
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 6bcde1c..a94d4cf 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1017,6 +1017,8 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	struct mthca_dev *dev = to_mdev(pd->device);
 	struct ib_umem_chunk *chunk;
 	struct mthca_mr *mr;
+	struct mthca_reg_mr ucmd;
+	int dmaflush;
 	u64 *pages;
 	int shift, n, len;
 	int i, j, k;
@@ -1027,7 +1029,14 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
-	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc);
+	if (ib_copy_from_udata(&ucmd, udata, sizeof ucmd)) {
+		err = -EFAULT;
+		goto err;
+	}
+	dmaflush = (int) ucmd.mr_attrs & MTHCA_MR_DMAFLUSH;
+
+	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc, 
+			       dmaflush);
 	if (IS_ERR(mr->umem)) {
 		err = PTR_ERR(mr->umem);
 		goto err;
diff --git a/drivers/infiniband/hw/mthca/mthca_user.h b/drivers/infiniband/hw/mthca/mthca_user.h
index 02cc0a7..fa8c339 100644
--- a/drivers/infiniband/hw/mthca/mthca_user.h
+++ b/drivers/infiniband/hw/mthca/mthca_user.h
@@ -41,7 +41,7 @@
  * Increment this value if any changes that break userspace ABI
  * compatibility are made.
  */
-#define MTHCA_UVERBS_ABI_VERSION	1
+#define MTHCA_UVERBS_ABI_VERSION	2
 
 /*
  * Make sure that all structs defined in this file remain laid out so
@@ -61,6 +61,14 @@ struct mthca_alloc_pd_resp {
 	__u32 reserved;
 };
 
+struct mthca_reg_mr {
+	__u32 mr_attrs;
+#define MTHCA_MR_DMAFLUSH 0x1	/* flush in-flight DMA on a write to 
+				 * memory region (IA64_SGI_SN2 only) */
+	__u32 reserved;
+};
+
+
 struct mthca_create_cq {
 	__u32 lkey;
 	__u32 pdn;
diff --git a/include/asm-ia64/dma-mapping.h b/include/asm-ia64/dma-mapping.h
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
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 2dc21cb..594a651 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -99,4 +99,11 @@ static inline void dmam_release_declared_memory(struct device *dev)
 }
 #endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
 
+#ifndef ARCH_DOES_POSTED_DMA
+static inline int
+dma_flags_set_dmaflush(int dir) {
+	return (dir);
+}
+#endif /* ARCH_DOES_POSTED_DMA */
+
 #endif
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index c533d6c..b7aaeb0 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -61,7 +61,7 @@ struct ib_umem_chunk {
 #ifdef CONFIG_INFINIBAND_USER_MEM
 
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
-			    size_t size, int access);
+			    size_t size, int access, int dmaflush);
 void ib_umem_release(struct ib_umem *umem);
 int ib_umem_page_count(struct ib_umem *umem);
 
@@ -71,7 +71,7 @@ int ib_umem_page_count(struct ib_umem *umem);
 
 static inline struct ib_umem *ib_umem_get(struct ib_ucontext *context,
 					  unsigned long addr, size_t size,
-					  int access) {
+					  int access, int dmaflush) {
 	return ERR_PTR(-EINVAL);
 }
 static inline void ib_umem_release(struct ib_umem *umem) { }


-- 
Arthur


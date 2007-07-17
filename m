Return-Path: <linux-kernel-owner+w=401wt.eu-S1759298AbXGQCSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbXGQCSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 22:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbXGQCSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 22:18:44 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60054 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752172AbXGQCSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 22:18:43 -0400
From: akepner@sgi.com
Date: Mon, 16 Jul 2007 19:18:12 -0700
To: linux-kernel@vger.kernel.org
Cc: Roland Dreier <rdreier@cisco.com>, Muli Ben-Yehuda <muli@il.ibm.com>,
       glebn@voltaire.com
Subject: [RFC/PATCH] allow memory to be tagged "coherent" via dma_map_sg()
Message-ID: <20070717021812.GH16538@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Altix supports "posted DMA", and DMA can complete out of
order due to reordering within the NUMA-interconnect.

One of the synchronization mechanisms to flush in-flight
DMA is to write to an address which has a special "barrier"
bit set. (The other mechanism is to generate an interrupt.)

For now, the only way to get memory with the barrier bit
set is to use dma_alloc_coherent(). This presents a problem
with Infiniband's libibverbs, which allocates Completion
Queues in user-space.

(In short the bug is that a CQ entry can be updated before
the DMA that it indicates has completed is actually in
memory. This can happen only when the CQ was allocated with
libibverbs, not when it was allocated in the kernel. 
There's a longer description at:
http://lists.openfabrics.org/pipermail/general/2006-December/030251.html)

The following patch is intended to address this by allowing
memory to be tagged "coherent" (i.e., to set the barrier
bit) when necessary. It "borrows" bits from the direction
parameter of dma_map_sg() to pass a flag indicating whether
to toggle the barrier bit.

Lightly tested on Altix. Compile-tested on x86_64.

Comments?

Signed-off-by: Arthur Kepner <akepner@sgi.com>
--

diff --git a/arch/ia64/sn/pci/pci_dma.c b/arch/ia64/sn/pci/pci_dma.c
index d79ddac..2a960e5 100644
--- a/arch/ia64/sn/pci/pci_dma.c
+++ b/arch/ia64/sn/pci/pci_dma.c
@@ -245,13 +245,15 @@ EXPORT_SYMBOL(sn_dma_unmap_sg);
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
+	int dmaflush = dma_data_direction_get_dmaflush(flags);
+	int direction = dma_data_direction_get_direction(flags);
 
 	BUG_ON(dev->bus != &pci_bus_type);
 
@@ -259,12 +261,21 @@ int sn_dma_map_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
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
index 26d0470..b192b25 100644
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
@@ -78,7 +80,8 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	int ret;
 	int off;
 	int i;
-
+	int flags = dma_data_direction_set_dmaflush(DMA_BIDIRECTIONAL, 
+						    dmaflush);	
 	if (!can_do_mlock())
 		return ERR_PTR(-EPERM);
 
@@ -155,7 +158,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
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
index 6299b51..22af26b 100644
--- a/include/asm-ia64/dma-mapping.h
+++ b/include/asm-ia64/dma-mapping.h
@@ -73,4 +73,26 @@ dma_cache_sync (struct device *dev, void *vaddr, size_t size,
 
 #define dma_is_consistent(d, h)	(1)	/* all we do is coherent memory... */
 
+#define ARCH_DOES_POSTED_DMA
+#define DMA_ATTR_SHIFT	8	/* bottom 8 bits for direction, upper bits 
+				 * for additional "attributes". For now the 
+				 * only attribute is "flush in-flight dma 
+				 * when writing to scatterlist" */
+#define DMA_DIR_MASK	((1 << DMA_ATTR_SHIFT) - 1)
+#define DMA_ATTR_MASK	~DMA_DIR_MASK
+static inline int
+dma_data_direction_set_dmaflush(enum dma_data_direction dir, int dmaflush) {
+	return (dir | (dmaflush << DMA_ATTR_SHIFT));
+}
+
+static inline int 
+dma_data_direction_get_direction(enum dma_data_direction dir) {
+	return (dir & DMA_DIR_MASK);
+}
+
+static inline int 
+dma_data_direction_get_dmaflush(enum dma_data_direction dir) {
+	return ((dir & DMA_ATTR_MASK) >> DMA_ATTR_SHIFT);
+}
+
 #endif /* _ASM_IA64_DMA_MAPPING_H */
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 9a663c6..885589a 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -95,4 +95,11 @@ static inline void dmam_release_declared_memory(struct device *dev)
 }
 #endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
 
+#ifndef ARCH_DOES_POSTED_DMA
+static inline int
+dma_data_direction_set_dmaflush(enum dma_data_direction dir, int dmaflush) {
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


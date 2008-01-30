Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbYA3F4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbYA3F4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 00:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbYA3Fz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 00:55:56 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52571 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756909AbYA3Fzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 00:55:55 -0500
From: akepner@sgi.com
Date: Tue, 29 Jan 2008 21:54:29 -0800
To: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] IB: introducing MTHCA_MR_DMABARRIER
Message-ID: <20080130055429.GV30022@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add MTHCA_MR_DMABARRIER to mthca's API, increment ABI version, 
and make use of MTHCA_MR_DMABARRIER when mapping a user-allocated 
memory region with ib_umem_get().


Signed-off-by: Arthur Kepner <akepner@sgi.com>

--

 drivers/infiniband/core/umem.c               |   15 +++++++++---
 drivers/infiniband/hw/mthca/mthca_provider.c |    7 ++++-
 drivers/infiniband/hw/mthca/mthca_user.h     |   10 +++++++-
 include/rdma/ib_verbs.h                      |   33 +++++++++++++++++++++++++++
 4 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 5b00408..57b5ce9 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -38,6 +38,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/sched.h>
 #include <linux/hugetlb.h>
+#include <linux/dma-attrs.h>
 
 #include "uverbs.h"
 
@@ -72,6 +73,8 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
  * @addr: userspace virtual address to start at
  * @size: length of region to pin
  * @access: IB_ACCESS_xxx flags for memory being pinned
+ * @dmabarrier: set a "dma barrier" so that in-flight DMA is 
+ *  flushed when the memory region is written to
  */
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 			    size_t size, int access, int dmabarrier)
@@ -87,6 +90,9 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	int ret;
 	int off;
 	int i;
+	struct dma_attrs attrs;
+
+	dma_set_attr(&attrs, dmabarrier ? DMA_ATTR_BARRIER : 0);
 
 	if (!can_do_mlock())
 		return ERR_PTR(-EPERM);
@@ -174,10 +180,11 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 				sg_set_page(&chunk->page_list[i], page_list[i + off], PAGE_SIZE, 0);
 			}
 
-			chunk->nmap = ib_dma_map_sg(context->device,
-						    &chunk->page_list[0],
-						    chunk->nents,
-						    DMA_BIDIRECTIONAL);
+			chunk->nmap = ib_dma_map_sg_attrs(context->device,
+							  &chunk->page_list[0],
+							  chunk->nents,
+							  DMA_BIDIRECTIONAL, 
+							  &attrs);
 			if (chunk->nmap <= 0) {
 				for (i = 0; i < chunk->nents; ++i)
 					put_page(sg_page(&chunk->page_list[i]));
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 704d8ef..e837cc9 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1017,17 +1017,22 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	struct mthca_dev *dev = to_mdev(pd->device);
 	struct ib_umem_chunk *chunk;
 	struct mthca_mr *mr;
+	struct mthca_reg_mr ucmd;
 	u64 *pages;
 	int shift, n, len;
 	int i, j, k;
 	int err = 0;
 	int write_mtt_size;
 
+	if (ib_copy_from_udata(&ucmd, udata, sizeof ucmd))
+		return ERR_PTR(-EFAULT);
+
 	mr = kmalloc(sizeof *mr, GFP_KERNEL);
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
-	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc, 0);
+	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc, 
+			       ucmd.mr_attrs & MTHCA_MR_DMABARRIER);
 
 	if (IS_ERR(mr->umem)) {
 		err = PTR_ERR(mr->umem);
diff --git a/drivers/infiniband/hw/mthca/mthca_user.h b/drivers/infiniband/hw/mthca/mthca_user.h
index 02cc0a7..701a430 100644
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
+#define MTHCA_MR_DMABARRIER 0x1  /* set a dma barrier in order to flush 
+				  * in-flight DMA on a write to memory 
+				  * region */
+	__u32 reserved;
+};
+
 struct mthca_create_cq {
 	__u32 lkey;
 	__u32 pdn;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 11f3960..ac869e2 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1507,6 +1507,24 @@ static inline void ib_dma_unmap_single(struct ib_device *dev,
 		dma_unmap_single(dev->dma_device, addr, size, direction);
 }
 
+static inline u64 ib_dma_map_single_attrs(struct ib_device *dev,
+					  void *cpu_addr, size_t size,
+					  enum dma_data_direction direction,
+					  struct dma_attrs *attrs)
+{
+	return dma_map_single_attrs(dev->dma_device, cpu_addr, size, 
+				    direction, attrs);
+}
+
+static inline void ib_dma_unmap_single_attrs(struct ib_device *dev,
+					     u64 addr, size_t size,
+					     enum dma_data_direction direction, 
+					     struct dma_attrs *attrs)
+{
+	return dma_unmap_single_attrs(dev->dma_device, addr, size, 
+				      direction, attrs);
+}
+
 /**
  * ib_dma_map_page - Map a physical page to DMA address
  * @dev: The device for which the dma_addr is to be created
@@ -1576,6 +1594,21 @@ static inline void ib_dma_unmap_sg(struct ib_device *dev,
 		dma_unmap_sg(dev->dma_device, sg, nents, direction);
 }
 
+static inline int ib_dma_map_sg_attrs(struct ib_device *dev,
+				      struct scatterlist *sg, int nents,
+				      enum dma_data_direction direction,
+				      struct dma_attrs *attrs)
+{
+	return dma_map_sg_attrs(dev->dma_device, sg, nents, direction, attrs);
+}
+
+static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev,
+					 struct scatterlist *sg, int nents,
+					 enum dma_data_direction direction, 
+					 struct dma_attrs *attrs)
+{
+	dma_unmap_sg_attrs(dev->dma_device, sg, nents, direction, attrs);
+}
 /**
  * ib_sg_dma_address - Return the DMA address from a scatter/gather entry
  * @dev: The device for which the DMA addresses were created


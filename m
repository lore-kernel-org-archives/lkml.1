Return-Path: <linux-kernel-owner+w=401wt.eu-S1763582AbYBFD0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763582AbYBFD0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 22:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758564AbYBFD0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 22:26:16 -0500
Received: from relay1.sgi.com ([192.48.171.29]:45940 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758168AbYBFD0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 22:26:14 -0500
From: akepner@sgi.com
Date: Tue, 5 Feb 2008 19:24:47 -0800
To: Tony Luck <tony.luck@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jes Sorensen <jes@sgi.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] IB: expand ib_umem_get() prototype
Message-ID: <20080206032447.GQ9904@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add a new parameter, dmasync, to the ib_umem_get() prototype. Use 
dmasync = 1 when mapping user-allocated CQs with ib_umem_get().

Signed-off-by: Arthur Kepner <akepner@sgi.com>

---

 drivers/infiniband/core/umem.c               |   17 +++++++++----
 drivers/infiniband/hw/amso1100/c2_provider.c |    2 -
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    2 -
 drivers/infiniband/hw/ehca/ehca_mrmw.c       |    2 -
 drivers/infiniband/hw/ipath/ipath_mr.c       |    3 +-
 drivers/infiniband/hw/mlx4/cq.c              |    2 -
 drivers/infiniband/hw/mlx4/doorbell.c        |    2 -
 drivers/infiniband/hw/mlx4/mr.c              |    3 +-
 drivers/infiniband/hw/mlx4/qp.c              |    2 -
 drivers/infiniband/hw/mlx4/srq.c             |    2 -
 drivers/infiniband/hw/mthca/mthca_provider.c |    8 +++++-
 drivers/infiniband/hw/mthca/mthca_user.h     |   10 +++++++-
 include/rdma/ib_umem.h                       |    4 +--
 include/rdma/ib_verbs.h                      |   33 +++++++++++++++++++++++++++
 14 files changed, 74 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 4e3128f..f0e0d10 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -38,6 +38,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/sched.h>
 #include <linux/hugetlb.h>
+#include <linux/dma-attrs.h>
 
 #include "uverbs.h"
 
@@ -72,9 +73,10 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
  * @addr: userspace virtual address to start at
  * @size: length of region to pin
  * @access: IB_ACCESS_xxx flags for memory being pinned
+ * @dmasync: flush in-flight DMA when the memory region is written 
  */
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
-			    size_t size, int access)
+			    size_t size, int access, int dmasync)
 {
 	struct ib_umem *umem;
 	struct page **page_list;
@@ -87,6 +89,10 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	int ret;
 	int off;
 	int i;
+	DECLARE_DMA_ATTRS(attrs);
+
+	if (dmasync)
+		dma_set_attr(&attrs, DMA_ATTR_SYNC_ON_WRITE);
 
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
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index 7a6cece..f571dff 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -449,7 +449,7 @@ static struct ib_mr *c2_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		return ERR_PTR(-ENOMEM);
 	c2mr->pd = c2pd;
 
-	c2mr->umem = ib_umem_get(pd->uobject->context, start, length, acc);
+	c2mr->umem = ib_umem_get(pd->uobject->context, start, length, acc, 0);
 	if (IS_ERR(c2mr->umem)) {
 		err = PTR_ERR(c2mr->umem);
 		kfree(c2mr);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index b5436ca..66d9d65 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -601,7 +601,7 @@ static struct ib_mr *iwch_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (!mhp)
 		return ERR_PTR(-ENOMEM);
 
-	mhp->umem = ib_umem_get(pd->uobject->context, start, length, acc);
+	mhp->umem = ib_umem_get(pd->uobject->context, start, length, acc, 0);
 	if (IS_ERR(mhp->umem)) {
 		err = PTR_ERR(mhp->umem);
 		kfree(mhp);
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index e239bbf..62a382c 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -325,7 +325,7 @@ struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	}
 
 	e_mr->umem = ib_umem_get(pd->uobject->context, start, length,
-				 mr_access_flags);
+				 mr_access_flags, 0);
 	if (IS_ERR(e_mr->umem)) {
 		ib_mr = (void *)e_mr->umem;
 		goto reg_user_mr_exit1;
diff --git a/drivers/infiniband/hw/ipath/ipath_mr.c b/drivers/infiniband/hw/ipath/ipath_mr.c
index db4ba92..7ffb392 100644
--- a/drivers/infiniband/hw/ipath/ipath_mr.c
+++ b/drivers/infiniband/hw/ipath/ipath_mr.c
@@ -195,7 +195,8 @@ struct ib_mr *ipath_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		goto bail;
 	}
 
-	umem = ib_umem_get(pd->uobject->context, start, length, mr_access_flags);
+	umem = ib_umem_get(pd->uobject->context, start, length, 
+			   mr_access_flags, 0);
 	if (IS_ERR(umem))
 		return (void *) umem;
 
diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 9d32c49..ea69d31 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -122,7 +122,7 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev, int entries, int vector
 		}
 
 		cq->umem = ib_umem_get(context, ucmd.buf_addr, buf_size,
-				       IB_ACCESS_LOCAL_WRITE);
+				       IB_ACCESS_LOCAL_WRITE, 1);
 		if (IS_ERR(cq->umem)) {
 			err = PTR_ERR(cq->umem);
 			goto err_cq;
diff --git a/drivers/infiniband/hw/mlx4/doorbell.c b/drivers/infiniband/hw/mlx4/doorbell.c
index 1c36087..0afde2d 100644
--- a/drivers/infiniband/hw/mlx4/doorbell.c
+++ b/drivers/infiniband/hw/mlx4/doorbell.c
@@ -181,7 +181,7 @@ int mlx4_ib_db_map_user(struct mlx4_ib_ucontext *context, unsigned long virt,
 	page->user_virt = (virt & PAGE_MASK);
 	page->refcnt    = 0;
 	page->umem      = ib_umem_get(&context->ibucontext, virt & PAGE_MASK,
-				      PAGE_SIZE, 0);
+				      PAGE_SIZE, 0, 0);
 	if (IS_ERR(page->umem)) {
 		err = PTR_ERR(page->umem);
 		kfree(page);
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 7dc91a3..bab6312 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -132,7 +132,8 @@ struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
-	mr->umem = ib_umem_get(pd->uobject->context, start, length, access_flags);
+	mr->umem = ib_umem_get(pd->uobject->context, start, length, 
+			       access_flags, 0);
 	if (IS_ERR(mr->umem)) {
 		err = PTR_ERR(mr->umem);
 		goto err_free;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 8cba9c5..a5dedd9 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -347,7 +347,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			goto err;
 
 		qp->umem = ib_umem_get(pd->uobject->context, ucmd.buf_addr,
-				       qp->buf_size, 0);
+				       qp->buf_size, 0, 0);
 		if (IS_ERR(qp->umem)) {
 			err = PTR_ERR(qp->umem);
 			goto err;
diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
index e7e9a3d..5456481 100644
--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -115,7 +115,7 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
 		}
 
 		srq->umem = ib_umem_get(pd->uobject->context, ucmd.buf_addr,
-					buf_size, 0);
+					buf_size, 0, 0);
 		if (IS_ERR(srq->umem)) {
 			err = PTR_ERR(srq->umem);
 			goto err_srq;
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 6bcde1c..7da7194 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1017,17 +1017,23 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
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
 
-	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc);
+	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc, 
+			       ucmd.mr_attrs & MTHCA_MR_DMASYNC);
+
 	if (IS_ERR(mr->umem)) {
 		err = PTR_ERR(mr->umem);
 		goto err;
diff --git a/drivers/infiniband/hw/mthca/mthca_user.h b/drivers/infiniband/hw/mthca/mthca_user.h
index 02cc0a7..b19259f 100644
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
+#define MTHCA_MR_DMASYNC 0x1  
+/* mark the memory region with a DMA attribute that causes
+ * in-flight DMA to be flushed when the region is written to */
+	__u32 reserved;
+};
+
 struct mthca_create_cq {
 	__u32 lkey;
 	__u32 pdn;
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 2229842..9ee0d2e 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -62,7 +62,7 @@ struct ib_umem_chunk {
 #ifdef CONFIG_INFINIBAND_USER_MEM
 
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
-			    size_t size, int access);
+			    size_t size, int access, int dmasync);
 void ib_umem_release(struct ib_umem *umem);
 int ib_umem_page_count(struct ib_umem *umem);
 
@@ -72,7 +72,7 @@ int ib_umem_page_count(struct ib_umem *umem);
 
 static inline struct ib_umem *ib_umem_get(struct ib_ucontext *context,
 					  unsigned long addr, size_t size,
-					  int access) {
+					  int access, int dmasync) {
 	return ERR_PTR(-EINVAL);
 }
 static inline void ib_umem_release(struct ib_umem *umem) { }
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

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbXIZAGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbXIZAGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 20:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbXIZAFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 20:05:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:32861 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752746AbXIZAFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 20:05:53 -0400
From: akepner@sgi.com
Date: Tue, 25 Sep 2007 17:04:53 -0700
To: Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>, Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] mthca: allow setting "dmaflush" attribute on user-allocated memory
Message-ID: <20070926000453.GO30013@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Use the dma_flags_set_dmaflush() interface to allow a "dmaflush" 
attribute to be associated with user-allocated memory. (For now, 
it's only implemented for mthca.)

Signed-off-by: Arthur Kepner <akepner@sgi.com>
--
 drivers/infiniband/core/umem.c               |    7 +++++--
 drivers/infiniband/hw/amso1100/c2_provider.c |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    2 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c       |    2 +-
 drivers/infiniband/hw/ipath/ipath_mr.c       |    2 +-
 drivers/infiniband/hw/mlx4/cq.c              |    2 +-
 drivers/infiniband/hw/mlx4/doorbell.c        |    2 +-
 drivers/infiniband/hw/mlx4/mr.c              |    3 ++-
 drivers/infiniband/hw/mlx4/qp.c              |    2 +-
 drivers/infiniband/hw/mlx4/srq.c             |    2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |    7 ++++++-
 drivers/infiniband/hw/mthca/mthca_user.h     |   10 +++++++++-
 include/rdma/ib_umem.h                       |    4 ++--
 13 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 664d2fa..e8a3dd4 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -69,9 +69,10 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
  * @addr: userspace virtual address to start at
  * @size: length of region to pin
  * @access: IB_ACCESS_xxx flags for memory being pinned
+ * @dmaflush: set "dmaflush" attribute on this memory, if necessary 
  */
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
-			    size_t size, int access)
+			    size_t size, int access, int dmaflush)
 {
 	struct ib_umem *umem;
 	struct page **page_list;
@@ -83,6 +84,8 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	int ret;
 	int off;
 	int i;
+	int flags = dmaflush ? dma_flags_set_dmaflush(DMA_BIDIRECTIONAL): 
+			DMA_BIDIRECTIONAL;
 
 	if (!can_do_mlock())
 		return ERR_PTR(-EPERM);
@@ -160,7 +163,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 			chunk->nmap = ib_dma_map_sg(context->device,
 						    &chunk->page_list[0],
 						    chunk->nents,
-						    DMA_BIDIRECTIONAL);
+						    flags);
 			if (chunk->nmap <= 0) {
 				for (i = 0; i < chunk->nents; ++i)
 					put_page(chunk->page_list[i].page);
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index 997cf15..17243b7 100644
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
index f0c7775..d0a514c 100644
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
index d97eda3..c13c11c 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -329,7 +329,7 @@ struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	}
 
 	e_mr->umem = ib_umem_get(pd->uobject->context, start, length,
-				 mr_access_flags);
+				 mr_access_flags, 0);
 	if (IS_ERR(e_mr->umem)) {
 		ib_mr = (void *)e_mr->umem;
 		goto reg_user_mr_exit1;
diff --git a/drivers/infiniband/hw/ipath/ipath_mr.c b/drivers/infiniband/hw/ipath/ipath_mr.c
index e442470..e351222 100644
--- a/drivers/infiniband/hw/ipath/ipath_mr.c
+++ b/drivers/infiniband/hw/ipath/ipath_mr.c
@@ -195,7 +195,7 @@ struct ib_mr *ipath_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		goto bail;
 	}
 
-	umem = ib_umem_get(pd->uobject->context, start, length, mr_access_flags);
+	umem = ib_umem_get(pd->uobject->context, start, length, mr_access_flags, 0);
 	if (IS_ERR(umem))
 		return (void *) umem;
 
diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 8bf44da..96ec149 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -122,7 +122,7 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev, int entries, int vector
 		}
 
 		cq->umem = ib_umem_get(context, ucmd.buf_addr, buf_size,
-				       IB_ACCESS_LOCAL_WRITE);
+				       IB_ACCESS_LOCAL_WRITE, 0);
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
index 85ae906..3e05eb6 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -133,7 +133,8 @@ struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
-	mr->umem = ib_umem_get(pd->uobject->context, start, length, access_flags);
+	mr->umem = ib_umem_get(pd->uobject->context, start, length, 
+			       access_flags, 0);
 	if (IS_ERR(mr->umem)) {
 		err = PTR_ERR(mr->umem);
 		goto err_free;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 85c51bd..f4dd553 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -335,7 +335,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			goto err;
 
 		qp->umem = ib_umem_get(pd->uobject->context, ucmd.buf_addr,
-				       qp->buf_size, 0);
+				       qp->buf_size, 0, 0);
 		if (IS_ERR(qp->umem)) {
 			err = PTR_ERR(qp->umem);
 			goto err;
diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
index 408748f..7c17b89 100644
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
index 6bcde1c..c818708 100644
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
 
-	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc);
+	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc, 
+			       ucmd.mr_attrs & MTHCA_MR_DMAFLUSH);
 	if (IS_ERR(mr->umem)) {
 		err = PTR_ERR(mr->umem);
 		goto err;
diff --git a/drivers/infiniband/hw/mthca/mthca_user.h b/drivers/infiniband/hw/mthca/mthca_user.h
index 02cc0a7..5662aea 100644
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
+				 * memory region */
+	__u32 reserved;
+};
+
+
 struct mthca_create_cq {
 	__u32 lkey;
 	__u32 pdn;
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

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbYA3Fyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbYA3Fyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 00:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYA3Fyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 00:54:47 -0500
Received: from relay2.sgi.com ([192.48.171.30]:35772 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753847AbYA3Fyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 00:54:46 -0500
From: akepner@sgi.com
Date: Tue, 29 Jan 2008 21:53:20 -0800
To: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] IB: add dmabarrier to ib_umem_get() prototype
Message-ID: <20080130055320.GU30022@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add a new parameter, dmabarrier, to the ib_umem_get() 
prototype.

Signed-off-by: Arthur Kepner <akepner@sgi.com>

-- 

 drivers/infiniband/core/umem.c               |    2 +-
 drivers/infiniband/hw/amso1100/c2_provider.c |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    2 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c       |    2 +-
 drivers/infiniband/hw/ipath/ipath_mr.c       |    3 ++-
 drivers/infiniband/hw/mlx4/cq.c              |    2 +-
 drivers/infiniband/hw/mlx4/doorbell.c        |    2 +-
 drivers/infiniband/hw/mlx4/mr.c              |    3 ++-
 drivers/infiniband/hw/mlx4/qp.c              |    2 +-
 drivers/infiniband/hw/mlx4/srq.c             |    2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |    3 ++-
 include/rdma/ib_umem.h                       |    4 ++--
 12 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 4e3128f..5b00408 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -74,7 +74,7 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
  * @access: IB_ACCESS_xxx flags for memory being pinned
  */
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
-			    size_t size, int access)
+			    size_t size, int access, int dmabarrier)
 {
 	struct ib_umem *umem;
 	struct page **page_list;
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
index 9d32c49..3adad6f 100644
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
index 6bcde1c..704d8ef 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1027,7 +1027,8 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
-	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc);
+	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc, 0);
+
 	if (IS_ERR(mr->umem)) {
 		err = PTR_ERR(mr->umem);
 		goto err;
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 2229842..ac3542e 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -62,7 +62,7 @@ struct ib_umem_chunk {
 #ifdef CONFIG_INFINIBAND_USER_MEM
 
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
-			    size_t size, int access);
+			    size_t size, int access, int dmabarrier);
 void ib_umem_release(struct ib_umem *umem);
 int ib_umem_page_count(struct ib_umem *umem);
 
@@ -72,7 +72,7 @@ int ib_umem_page_count(struct ib_umem *umem);
 
 static inline struct ib_umem *ib_umem_get(struct ib_ucontext *context,
 					  unsigned long addr, size_t size,
-					  int access) {
+					  int access, int dmabarrier) {
 	return ERR_PTR(-EINVAL);
 }
 static inline void ib_umem_release(struct ib_umem *umem) { }

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762088AbZEMWSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762088AbZEMWSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbZEMWSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:18:13 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:32522 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZEMWSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:18:12 -0400
X-IronPort-AV: E=Sophos;i="4.41,191,1241395200"; 
   d="scan'208";a="304007844"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Wed, 13 May 2009 15:18:13 -0700
Message-ID: <ada4ovoir4q.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 May 2009 22:18:13.0328 (UTC) FILETIME=[B4BBCD00:01C9D418]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a couple of fixes to low-level drivers that fix crashes
seen when running NFS/RDMA:

Jack Morgenstein (1):
      IB/mlx4: Don't overwrite fast registration page list when posting work request

Roland Dreier (1):
      Merge branches 'cxgb3' and 'mlx4' into for-linus

Steve Wise (1):
      RDMA/cxgb3: Don't complete flushed send work requests twice

 drivers/infiniband/hw/cxgb3/cxio_hal.c |    1 +
 drivers/infiniband/hw/mlx4/mlx4_ib.h   |    1 +
 drivers/infiniband/hw/mlx4/mr.c        |   10 ++++++++--
 drivers/infiniband/hw/mlx4/qp.c        |    2 +-
 4 files changed, 11 insertions(+), 3 deletions(-)


diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index 8d71086..62f9cf2 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -410,6 +410,7 @@ int cxio_flush_sq(struct t3_wq *wq, struct t3_cq *cq, int count)
 	ptr = wq->sq_rptr + count;
 	sqp = wq->sq + Q_PTR2IDX(ptr, wq->sq_size_log2);
 	while (ptr != wq->sq_wptr) {
+		sqp->signaled = 0;
 		insert_sq_cqe(wq, cq, sqp);
 		ptr++;
 		sqp = wq->sq + Q_PTR2IDX(ptr, wq->sq_size_log2);
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 9974e88..8a7dd67 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -86,6 +86,7 @@ struct mlx4_ib_mr {
 
 struct mlx4_ib_fast_reg_page_list {
 	struct ib_fast_reg_page_list	ibfrpl;
+	__be64			       *mapped_page_list;
 	dma_addr_t			map;
 };
 
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 8e4d26d..8f3666b 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -231,7 +231,11 @@ struct ib_fast_reg_page_list *mlx4_ib_alloc_fast_reg_page_list(struct ib_device
 	if (!mfrpl)
 		return ERR_PTR(-ENOMEM);
 
-	mfrpl->ibfrpl.page_list = dma_alloc_coherent(&dev->dev->pdev->dev,
+	mfrpl->ibfrpl.page_list = kmalloc(size, GFP_KERNEL);
+	if (!mfrpl->ibfrpl.page_list)
+		goto err_free;
+
+	mfrpl->mapped_page_list = dma_alloc_coherent(&dev->dev->pdev->dev,
 						     size, &mfrpl->map,
 						     GFP_KERNEL);
 	if (!mfrpl->ibfrpl.page_list)
@@ -242,6 +246,7 @@ struct ib_fast_reg_page_list *mlx4_ib_alloc_fast_reg_page_list(struct ib_device
 	return &mfrpl->ibfrpl;
 
 err_free:
+	kfree(mfrpl->ibfrpl.page_list);
 	kfree(mfrpl);
 	return ERR_PTR(-ENOMEM);
 }
@@ -252,8 +257,9 @@ void mlx4_ib_free_fast_reg_page_list(struct ib_fast_reg_page_list *page_list)
 	struct mlx4_ib_fast_reg_page_list *mfrpl = to_mfrpl(page_list);
 	int size = page_list->max_page_list_len * sizeof (u64);
 
-	dma_free_coherent(&dev->dev->pdev->dev, size, page_list->page_list,
+	dma_free_coherent(&dev->dev->pdev->dev, size, mfrpl->mapped_page_list,
 			  mfrpl->map);
+	kfree(mfrpl->ibfrpl.page_list);
 	kfree(mfrpl);
 }
 
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index f385a24..20724ae 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1365,7 +1365,7 @@ static void set_fmr_seg(struct mlx4_wqe_fmr_seg *fseg, struct ib_send_wr *wr)
 	int i;
 
 	for (i = 0; i < wr->wr.fast_reg.page_list_len; ++i)
-		wr->wr.fast_reg.page_list->page_list[i] =
+		mfrpl->mapped_page_list[i] =
 			cpu_to_be64(wr->wr.fast_reg.page_list->page_list[i] |
 				    MLX4_MTT_FLAG_PRESENT);
 

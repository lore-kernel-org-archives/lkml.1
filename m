Return-Path: <linux-kernel-owner+w=401wt.eu-S964976AbXC1RZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964976AbXC1RZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 13:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964978AbXC1RZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 13:25:37 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:12945 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964976AbXC1RZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 13:25:36 -0400
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 28 Mar 2007 10:25:24 -0700
Message-ID: <adavegll1q3.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Mar 2007 17:25:24.0538 (UTC) FILETIME=[11F371A0:01C7715E]
Authentication-Results: sj-dkim-7; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim7002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few small post-rc5 fixes.  I still have one more fix
to send that I am still reviewing -- I should be able to send it Thursday.

Erez Zilber (1):
      IB/iser: Handle aborting a command after it is sent

Michael S. Tsirkin (1):
      IB/mthca: Fix thinko in init_mr_table()

Steve Wise (1):
      RDMA/cxgb3: Fix resource leak in cxio_hal_init_ctrl_qp()

 drivers/infiniband/hw/cxgb3/cxio_hal.c       |   12 ++++++++----
 drivers/infiniband/hw/mthca/mthca_mr.c       |    4 ++--
 drivers/infiniband/ulp/iser/iser_initiator.c |   17 +++++++++--------
 3 files changed, 19 insertions(+), 14 deletions(-)


diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index 818cf1a..f5e9aee 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -498,9 +498,9 @@ static int cxio_hal_init_ctrl_qp(struct cxio_rdev *rdev_p)
 	u64 sge_cmd, ctx0, ctx1;
 	u64 base_addr;
 	struct t3_modify_qp_wr *wqe;
-	struct sk_buff *skb = alloc_skb(sizeof(*wqe), GFP_KERNEL);
-
+	struct sk_buff *skb;
 
+	skb = alloc_skb(sizeof(*wqe), GFP_KERNEL);
 	if (!skb) {
 		PDBG("%s alloc_skb failed\n", __FUNCTION__);
 		return -ENOMEM;
@@ -508,7 +508,7 @@ static int cxio_hal_init_ctrl_qp(struct cxio_rdev *rdev_p)
 	err = cxio_hal_init_ctrl_cq(rdev_p);
 	if (err) {
 		PDBG("%s err %d initializing ctrl_cq\n", __FUNCTION__, err);
-		return err;
+		goto err;
 	}
 	rdev_p->ctrl_qp.workq = dma_alloc_coherent(
 					&(rdev_p->rnic_info.pdev->dev),
@@ -518,7 +518,8 @@ static int cxio_hal_init_ctrl_qp(struct cxio_rdev *rdev_p)
 					GFP_KERNEL);
 	if (!rdev_p->ctrl_qp.workq) {
 		PDBG("%s dma_alloc_coherent failed\n", __FUNCTION__);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto err;
 	}
 	pci_unmap_addr_set(&rdev_p->ctrl_qp, mapping,
 			   rdev_p->ctrl_qp.dma_addr);
@@ -556,6 +557,9 @@ static int cxio_hal_init_ctrl_qp(struct cxio_rdev *rdev_p)
 	     rdev_p->ctrl_qp.workq, 1 << T3_CTRL_QP_SIZE_LOG2);
 	skb->priority = CPL_PRIORITY_CONTROL;
 	return (cxgb3_ofld_send(rdev_p->t3cdev_p, skb));
+err:
+	kfree_skb(skb);
+	return err;
 }
 
 static int cxio_hal_destroy_ctrl_qp(struct cxio_rdev *rdev_p)
diff --git a/drivers/infiniband/hw/mthca/mthca_mr.c b/drivers/infiniband/hw/mthca/mthca_mr.c
index 8e4846b..fdb576d 100644
--- a/drivers/infiniband/hw/mthca/mthca_mr.c
+++ b/drivers/infiniband/hw/mthca/mthca_mr.c
@@ -881,8 +881,8 @@ int mthca_init_mr_table(struct mthca_dev *dev)
 		}
 		mpts = mtts = 1 << i;
 	} else {
-		mpts = dev->limits.num_mtt_segs;
-		mtts = dev->limits.num_mpts;
+		mtts = dev->limits.num_mtt_segs;
+		mpts = dev->limits.num_mpts;
 	}
 
 	if (!mthca_is_memfree(dev) &&
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 89e3728..278fcbc 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -658,6 +658,7 @@ void iser_ctask_rdma_finalize(struct iscsi_iser_cmd_task *iser_ctask)
 {
 	int deferred;
 	int is_rdma_aligned = 1;
+	struct iser_regd_buf *regd;
 
 	/* if we were reading, copy back to unaligned sglist,
 	 * anyway dma_unmap and free the copy
@@ -672,20 +673,20 @@ void iser_ctask_rdma_finalize(struct iscsi_iser_cmd_task *iser_ctask)
 	}
 
 	if (iser_ctask->dir[ISER_DIR_IN]) {
-		deferred = iser_regd_buff_release
-			(&iser_ctask->rdma_regd[ISER_DIR_IN]);
+		regd = &iser_ctask->rdma_regd[ISER_DIR_IN];
+		deferred = iser_regd_buff_release(regd);
 		if (deferred) {
-			iser_err("References remain for BUF-IN rdma reg\n");
-			BUG();
+			iser_err("%d references remain for BUF-IN rdma reg\n",
+				 atomic_read(&regd->ref_count));
 		}
 	}
 
 	if (iser_ctask->dir[ISER_DIR_OUT]) {
-		deferred = iser_regd_buff_release
-			(&iser_ctask->rdma_regd[ISER_DIR_OUT]);
+		regd = &iser_ctask->rdma_regd[ISER_DIR_OUT];
+		deferred = iser_regd_buff_release(regd);
 		if (deferred) {
-			iser_err("References remain for BUF-OUT rdma reg\n");
-			BUG();
+			iser_err("%d references remain for BUF-OUT rdma reg\n",
+				 atomic_read(&regd->ref_count));
 		}
 	}
 

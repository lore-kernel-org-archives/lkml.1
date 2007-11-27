Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbXK0GVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbXK0GVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 01:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbXK0GV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 01:21:29 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:39039 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbXK0GV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 01:21:28 -0500
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 26 Nov 2007 22:21:26 -0800
Message-ID: <adahcj8qkd5.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Nov 2007 06:21:27.0428 (UTC) FILETIME=[BDF9DC40:01C830BD]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will pull some small fixes for 2.6.24:

Erez Zilber (1):
      IB/iser: Add missing counter increment in iser_data_buf_aligned_len()

Jack Morgenstein (1):
      mlx4_core: Fix state check in mlx4_qp_modify()

Joachim Fenkes (1):
      IB/ehca: Fix static rate regression

Ralph Campbell (4):
      IB/ipath: Fix offset returned to ibv_resize_cq()
      IB/ipath: Fix error path in QP creation
      IB/ipath: Fix offset returned to ibv_modify_srq()
      IB/ipath: Normalize error return codes for posting work requests

 drivers/infiniband/hw/ehca/ehca_qp.c      |    4 +-
 drivers/infiniband/hw/ipath/ipath_cq.c    |   19 +++++++++---
 drivers/infiniband/hw/ipath/ipath_qp.c    |   15 ++++++----
 drivers/infiniband/hw/ipath/ipath_srq.c   |   44 +++++++++++++++++------------
 drivers/infiniband/hw/ipath/ipath_verbs.c |    8 +++--
 drivers/infiniband/ulp/iser/iser_memory.c |    6 ++-
 drivers/net/mlx4/qp.c                     |    2 +-
 7 files changed, 61 insertions(+), 37 deletions(-)


diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 2e3e654..dd12668 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -1203,7 +1203,7 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 		mqpcb->service_level = attr->ah_attr.sl;
 		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_SERVICE_LEVEL, 1);
 
-		if (ehca_calc_ipd(shca, my_qp->init_attr.port_num,
+		if (ehca_calc_ipd(shca, mqpcb->prim_phys_port,
 				  attr->ah_attr.static_rate,
 				  &mqpcb->max_static_rate)) {
 			ret = -EINVAL;
@@ -1302,7 +1302,7 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 		mqpcb->source_path_bits_al = attr->alt_ah_attr.src_path_bits;
 		mqpcb->service_level_al = attr->alt_ah_attr.sl;
 
-		if (ehca_calc_ipd(shca, my_qp->init_attr.port_num,
+		if (ehca_calc_ipd(shca, mqpcb->alt_phys_port,
 				  attr->alt_ah_attr.static_rate,
 				  &mqpcb->max_static_rate_al)) {
 			ret = -EINVAL;
diff --git a/drivers/infiniband/hw/ipath/ipath_cq.c b/drivers/infiniband/hw/ipath/ipath_cq.c
index 08d8ae1..d1380c7 100644
--- a/drivers/infiniband/hw/ipath/ipath_cq.c
+++ b/drivers/infiniband/hw/ipath/ipath_cq.c
@@ -395,12 +395,9 @@ int ipath_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
 		goto bail;
 	}
 
-	/*
-	 * Return the address of the WC as the offset to mmap.
-	 * See ipath_mmap() for details.
-	 */
+	/* Check that we can write the offset to mmap. */
 	if (udata && udata->outlen >= sizeof(__u64)) {
-		__u64 offset = (__u64) wc;
+		__u64 offset = 0;
 
 		ret = ib_copy_to_udata(udata, &offset, sizeof(offset));
 		if (ret)
@@ -450,6 +447,18 @@ int ipath_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
 		struct ipath_mmap_info *ip = cq->ip;
 
 		ipath_update_mmap_info(dev, ip, sz, wc);
+
+		/*
+		 * Return the offset to mmap.
+		 * See ipath_mmap() for details.
+		 */
+		if (udata && udata->outlen >= sizeof(__u64)) {
+			ret = ib_copy_to_udata(udata, &ip->offset,
+					       sizeof(ip->offset));
+			if (ret)
+				goto bail;
+		}
+
 		spin_lock_irq(&dev->pending_lock);
 		if (list_empty(&ip->pending_mmaps))
 			list_add(&ip->pending_mmaps, &dev->pending_mmaps);
diff --git a/drivers/infiniband/hw/ipath/ipath_qp.c b/drivers/infiniband/hw/ipath/ipath_qp.c
index 6a41fdb..b997ff8 100644
--- a/drivers/infiniband/hw/ipath/ipath_qp.c
+++ b/drivers/infiniband/hw/ipath/ipath_qp.c
@@ -835,7 +835,8 @@ struct ib_qp *ipath_create_qp(struct ib_pd *ibpd,
 				      init_attr->qp_type);
 		if (err) {
 			ret = ERR_PTR(err);
-			goto bail_rwq;
+			vfree(qp->r_rq.wq);
+			goto bail_qp;
 		}
 		qp->ip = NULL;
 		ipath_reset_qp(qp);
@@ -863,7 +864,7 @@ struct ib_qp *ipath_create_qp(struct ib_pd *ibpd,
 					       sizeof(offset));
 			if (err) {
 				ret = ERR_PTR(err);
-				goto bail_rwq;
+				goto bail_ip;
 			}
 		} else {
 			u32 s = sizeof(struct ipath_rwq) +
@@ -875,7 +876,7 @@ struct ib_qp *ipath_create_qp(struct ib_pd *ibpd,
 						   qp->r_rq.wq);
 			if (!qp->ip) {
 				ret = ERR_PTR(-ENOMEM);
-				goto bail_rwq;
+				goto bail_ip;
 			}
 
 			err = ib_copy_to_udata(udata, &(qp->ip->offset),
@@ -907,9 +908,11 @@ struct ib_qp *ipath_create_qp(struct ib_pd *ibpd,
 	goto bail;
 
 bail_ip:
-	kfree(qp->ip);
-bail_rwq:
-	vfree(qp->r_rq.wq);
+	if (qp->ip)
+		kref_put(&qp->ip->ref, ipath_release_mmap_info);
+	else
+		vfree(qp->r_rq.wq);
+	ipath_free_qp(&dev->qp_table, qp);
 bail_qp:
 	kfree(qp);
 bail_swq:
diff --git a/drivers/infiniband/hw/ipath/ipath_srq.c b/drivers/infiniband/hw/ipath/ipath_srq.c
index 40c36ec..2fef36f 100644
--- a/drivers/infiniband/hw/ipath/ipath_srq.c
+++ b/drivers/infiniband/hw/ipath/ipath_srq.c
@@ -59,7 +59,7 @@ int ipath_post_srq_receive(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
 
 		if ((unsigned) wr->num_sge > srq->rq.max_sge) {
 			*bad_wr = wr;
-			ret = -ENOMEM;
+			ret = -EINVAL;
 			goto bail;
 		}
 
@@ -211,11 +211,11 @@ int ipath_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 		     struct ib_udata *udata)
 {
 	struct ipath_srq *srq = to_isrq(ibsrq);
+	struct ipath_rwq *wq;
 	int ret = 0;
 
 	if (attr_mask & IB_SRQ_MAX_WR) {
 		struct ipath_rwq *owq;
-		struct ipath_rwq *wq;
 		struct ipath_rwqe *p;
 		u32 sz, size, n, head, tail;
 
@@ -236,27 +236,20 @@ int ipath_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 			goto bail;
 		}
 
-		/*
-		 * Return the address of the RWQ as the offset to mmap.
-		 * See ipath_mmap() for details.
-		 */
+		/* Check that we can write the offset to mmap. */
 		if (udata && udata->inlen >= sizeof(__u64)) {
 			__u64 offset_addr;
-			__u64 offset = (__u64) wq;
+			__u64 offset = 0;
 
 			ret = ib_copy_from_udata(&offset_addr, udata,
 						 sizeof(offset_addr));
-			if (ret) {
-				vfree(wq);
-				goto bail;
-			}
+			if (ret)
+				goto bail_free;
 			udata->outbuf = (void __user *) offset_addr;
 			ret = ib_copy_to_udata(udata, &offset,
 					       sizeof(offset));
-			if (ret) {
-				vfree(wq);
-				goto bail;
-			}
+			if (ret)
+				goto bail_free;
 		}
 
 		spin_lock_irq(&srq->rq.lock);
@@ -277,10 +270,8 @@ int ipath_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 		else
 			n -= tail;
 		if (size <= n) {
-			spin_unlock_irq(&srq->rq.lock);
-			vfree(wq);
 			ret = -EINVAL;
-			goto bail;
+			goto bail_unlock;
 		}
 		n = 0;
 		p = wq->wq;
@@ -314,6 +305,18 @@ int ipath_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 			u32 s = sizeof(struct ipath_rwq) + size * sz;
 
 			ipath_update_mmap_info(dev, ip, s, wq);
+
+			/*
+			 * Return the offset to mmap.
+			 * See ipath_mmap() for details.
+			 */
+			if (udata && udata->inlen >= sizeof(__u64)) {
+				ret = ib_copy_to_udata(udata, &ip->offset,
+						       sizeof(ip->offset));
+				if (ret)
+					goto bail;
+			}
+
 			spin_lock_irq(&dev->pending_lock);
 			if (list_empty(&ip->pending_mmaps))
 				list_add(&ip->pending_mmaps,
@@ -328,7 +331,12 @@ int ipath_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 			srq->limit = attr->srq_limit;
 		spin_unlock_irq(&srq->rq.lock);
 	}
+	goto bail;
 
+bail_unlock:
+	spin_unlock_irq(&srq->rq.lock);
+bail_free:
+	vfree(wq);
 bail:
 	return ret;
 }
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 74f77e7..c4c9984 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -302,8 +302,10 @@ static int ipath_post_one_send(struct ipath_qp *qp, struct ib_send_wr *wr)
 	next = qp->s_head + 1;
 	if (next >= qp->s_size)
 		next = 0;
-	if (next == qp->s_last)
-		goto bail_inval;
+	if (next == qp->s_last) {
+		ret = -ENOMEM;
+		goto bail;
+	}
 
 	wqe = get_swqe_ptr(qp, qp->s_head);
 	wqe->wr = *wr;
@@ -404,7 +406,7 @@ static int ipath_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 
 		if ((unsigned) wr->num_sge > qp->r_rq.max_sge) {
 			*bad_wr = wr;
-			ret = -ENOMEM;
+			ret = -EINVAL;
 			goto bail;
 		}
 
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index d687980..4a17743 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -310,13 +310,15 @@ static unsigned int iser_data_buf_aligned_len(struct iser_data_buf *data,
 		if (i + 1 < data->dma_nents) {
 			next_addr = ib_sg_dma_address(ibdev, sg_next(sg));
 			/* are i, i+1 fragments of the same page? */
-			if (end_addr == next_addr)
+			if (end_addr == next_addr) {
+				cnt++;
 				continue;
-			else if (!IS_4K_ALIGNED(end_addr)) {
+			} else if (!IS_4K_ALIGNED(end_addr)) {
 				ret_len = cnt + 1;
 				break;
 			}
 		}
+		cnt++;
 	}
 	if (i == data->dma_nents)
 		ret_len = cnt;	/* loop ended */
diff --git a/drivers/net/mlx4/qp.c b/drivers/net/mlx4/qp.c
index 42b4763..fa24e65 100644
--- a/drivers/net/mlx4/qp.c
+++ b/drivers/net/mlx4/qp.c
@@ -113,7 +113,7 @@ int mlx4_qp_modify(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
 	struct mlx4_cmd_mailbox *mailbox;
 	int ret = 0;
 
-	if (cur_state >= MLX4_QP_NUM_STATE || cur_state >= MLX4_QP_NUM_STATE ||
+	if (cur_state >= MLX4_QP_NUM_STATE || new_state >= MLX4_QP_NUM_STATE ||
 	    !op[cur_state][new_state])
 		return -EINVAL;
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbXEYWGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbXEYWGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 18:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbXEYWGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 18:06:11 -0400
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:36075 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbXEYWGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 18:06:10 -0400
X-IronPort-AV: i="4.14,581,1170662400"; 
   d="scan'208"; a="1106023:sNHT25596678"
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 25 May 2007 15:06:06 -0700
Message-ID: <adahcq036ep.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 May 2007 22:06:06.0597 (UTC) FILETIME=[E48F3350:01C79F18]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few more 2.6.22-rc2 fixes:

Eli Cohen (1):
      IB/mlx4: Initialize send queue entry ownership bits

Michael S. Tsirkin (2):
      IPoIB/cm: Fix timeout check in ipoib_cm_dev_stop()
      IPoIB/cm: Drain cq in ipoib_cm_dev_stop()

Roland Dreier (1):
      IB/mlx4: Don't allocate RQ doorbell if using SRQ

Stefan Roscher (1):
      IB/ehca: Fix number of send WRs reported for new QP

 drivers/infiniband/hw/ehca/hcp_if.c     |    2 +-
 drivers/infiniband/hw/mlx4/qp.c         |   59 +++++++++++++++++++-----------
 drivers/infiniband/ulp/ipoib/ipoib.h    |    1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |    3 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |   31 ++++++++++------
 5 files changed, 60 insertions(+), 36 deletions(-)


diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
index 7f0beec..5766ae3 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.c
+++ b/drivers/infiniband/hw/ehca/hcp_if.c
@@ -331,7 +331,7 @@ u64 hipz_h_alloc_resource_qp(const struct ipz_adapter_handle adapter_handle,
 				0);
 	qp->ipz_qp_handle.handle = outs[0];
 	qp->real_qp_num = (u32)outs[1];
-	parms->act_nr_send_sges =
+	parms->act_nr_send_wqes =
 		(u16)EHCA_BMASK_GET(H_ALL_RES_QP_ACT_OUTST_SEND_WR, outs[2]);
 	parms->act_nr_recv_wqes =
 		(u16)EHCA_BMASK_GET(H_ALL_RES_QP_ACT_OUTST_RECV_WR, outs[2]);
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index a824bc5..dc137de 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -270,9 +270,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			    struct ib_qp_init_attr *init_attr,
 			    struct ib_udata *udata, int sqpn, struct mlx4_ib_qp *qp)
 {
-	struct mlx4_wqe_ctrl_seg *ctrl;
 	int err;
-	int i;
 
 	mutex_init(&qp->mutex);
 	spin_lock_init(&qp->sq.lock);
@@ -319,20 +317,24 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		if (err)
 			goto err_mtt;
 
-		err = mlx4_ib_db_map_user(to_mucontext(pd->uobject->context),
-					  ucmd.db_addr, &qp->db);
-		if (err)
-			goto err_mtt;
+		if (!init_attr->srq) {
+			err = mlx4_ib_db_map_user(to_mucontext(pd->uobject->context),
+						  ucmd.db_addr, &qp->db);
+			if (err)
+				goto err_mtt;
+		}
 	} else {
 		err = set_kernel_sq_size(dev, &init_attr->cap, init_attr->qp_type, qp);
 		if (err)
 			goto err;
 
-		err = mlx4_ib_db_alloc(dev, &qp->db, 0);
-		if (err)
-			goto err;
+		if (!init_attr->srq) {
+			err = mlx4_ib_db_alloc(dev, &qp->db, 0);
+			if (err)
+				goto err;
 
-		*qp->db.db = 0;
+			*qp->db.db = 0;
+		}
 
 		if (mlx4_buf_alloc(dev->dev, qp->buf_size, PAGE_SIZE * 2, &qp->buf)) {
 			err = -ENOMEM;
@@ -348,11 +350,6 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		if (err)
 			goto err_mtt;
 
-		for (i = 0; i < qp->sq.max; ++i) {
-			ctrl = get_send_wqe(qp, i);
-			ctrl->owner_opcode = cpu_to_be32(1 << 31);
-		}
-
 		qp->sq.wrid  = kmalloc(qp->sq.max * sizeof (u64), GFP_KERNEL);
 		qp->rq.wrid  = kmalloc(qp->rq.max * sizeof (u64), GFP_KERNEL);
 
@@ -386,7 +383,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 	return 0;
 
 err_wrid:
-	if (pd->uobject)
+	if (pd->uobject && !init_attr->srq)
 		mlx4_ib_db_unmap_user(to_mucontext(pd->uobject->context), &qp->db);
 	else {
 		kfree(qp->sq.wrid);
@@ -403,7 +400,7 @@ err_buf:
 		mlx4_buf_free(dev->dev, qp->buf_size, &qp->buf);
 
 err_db:
-	if (!pd->uobject)
+	if (!pd->uobject && !init_attr->srq)
 		mlx4_ib_db_free(dev, &qp->db);
 
 err:
@@ -481,14 +478,16 @@ static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
 	mlx4_mtt_cleanup(dev->dev, &qp->mtt);
 
 	if (is_user) {
-		mlx4_ib_db_unmap_user(to_mucontext(qp->ibqp.uobject->context),
-				      &qp->db);
+		if (!qp->ibqp.srq)
+			mlx4_ib_db_unmap_user(to_mucontext(qp->ibqp.uobject->context),
+					      &qp->db);
 		ib_umem_release(qp->umem);
 	} else {
 		kfree(qp->sq.wrid);
 		kfree(qp->rq.wrid);
 		mlx4_buf_free(dev->dev, qp->buf_size, &qp->buf);
-		mlx4_ib_db_free(dev, &qp->db);
+		if (!qp->ibqp.srq)
+			mlx4_ib_db_free(dev, &qp->db);
 	}
 }
 
@@ -852,7 +851,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	if (ibqp->srq)
 		context->srqn = cpu_to_be32(1 << 24 | to_msrq(ibqp->srq)->msrq.srqn);
 
-	if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
+	if (!ibqp->srq && cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
 		context->db_rec_addr = cpu_to_be64(qp->db.dma);
 
 	if (cur_state == IB_QPS_INIT &&
@@ -872,6 +871,21 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	else
 		sqd_event = 0;
 
+	/*
+	 * Before passing a kernel QP to the HW, make sure that the
+	 * ownership bits of the send queue are set so that the
+	 * hardware doesn't start processing stale work requests.
+	 */
+	if (!ibqp->uobject && cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT) {
+		struct mlx4_wqe_ctrl_seg *ctrl;
+		int i;
+
+		for (i = 0; i < qp->sq.max; ++i) {
+			ctrl = get_send_wqe(qp, i);
+			ctrl->owner_opcode = cpu_to_be32(1 << 31);
+		}
+	}
+
 	err = mlx4_qp_modify(dev->dev, &qp->mtt, to_mlx4_state(cur_state),
 			     to_mlx4_state(new_state), context, optpar,
 			     sqd_event, &qp->mqp);
@@ -919,7 +933,8 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		qp->rq.tail = 0;
 		qp->sq.head = 0;
 		qp->sq.tail = 0;
-		*qp->db.db  = 0;
+		if (!ibqp->srq)
+			*qp->db.db  = 0;
 	}
 
 out:
diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index a0b3782..158759e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -429,6 +429,7 @@ int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey);
 
 void ipoib_pkey_poll(struct work_struct *work);
 int ipoib_pkey_dev_delay_open(struct net_device *dev);
+void ipoib_drain_cq(struct net_device *dev);
 
 #ifdef CONFIG_INFINIBAND_IPOIB_CM
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index ffec794..f133b56 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -713,7 +713,7 @@ void ipoib_cm_dev_stop(struct net_device *dev)
 	while (!list_empty(&priv->cm.rx_error_list) ||
 	       !list_empty(&priv->cm.rx_flush_list) ||
 	       !list_empty(&priv->cm.rx_drain_list)) {
-		if (!time_after(jiffies, begin + 5 * HZ)) {
+		if (time_after(jiffies, begin + 5 * HZ)) {
 			ipoib_warn(priv, "RX drain timing out\n");
 
 			/*
@@ -726,6 +726,7 @@ void ipoib_cm_dev_stop(struct net_device *dev)
 		}
 		spin_unlock_irq(&priv->lock);
 		msleep(1);
+		ipoib_drain_cq(dev);
 		spin_lock_irq(&priv->lock);
 	}
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index c1aad06..8404f05 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -550,13 +550,30 @@ static int recvs_pending(struct net_device *dev)
 	return pending;
 }
 
+void ipoib_drain_cq(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	int i, n;
+	do {
+		n = ib_poll_cq(priv->cq, IPOIB_NUM_WC, priv->ibwc);
+		for (i = 0; i < n; ++i) {
+			if (priv->ibwc[i].wr_id & IPOIB_CM_OP_SRQ)
+				ipoib_cm_handle_rx_wc(dev, priv->ibwc + i);
+			else if (priv->ibwc[i].wr_id & IPOIB_OP_RECV)
+				ipoib_ib_handle_rx_wc(dev, priv->ibwc + i);
+			else
+				ipoib_ib_handle_tx_wc(dev, priv->ibwc + i);
+		}
+	} while (n == IPOIB_NUM_WC);
+}
+
 int ipoib_ib_dev_stop(struct net_device *dev, int flush)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ib_qp_attr qp_attr;
 	unsigned long begin;
 	struct ipoib_tx_buf *tx_req;
-	int i, n;
+	int i;
 
 	clear_bit(IPOIB_FLAG_INITIALIZED, &priv->flags);
 	netif_poll_disable(dev);
@@ -611,17 +628,7 @@ int ipoib_ib_dev_stop(struct net_device *dev, int flush)
 			goto timeout;
 		}
 
-		do {
-			n = ib_poll_cq(priv->cq, IPOIB_NUM_WC, priv->ibwc);
-			for (i = 0; i < n; ++i) {
-				if (priv->ibwc[i].wr_id & IPOIB_CM_OP_SRQ)
-					ipoib_cm_handle_rx_wc(dev, priv->ibwc + i);
-				else if (priv->ibwc[i].wr_id & IPOIB_OP_RECV)
-					ipoib_ib_handle_rx_wc(dev, priv->ibwc + i);
-				else
-					ipoib_ib_handle_tx_wc(dev, priv->ibwc + i);
-			}
-		} while (n == IPOIB_NUM_WC);
+		ipoib_drain_cq(dev);
 
 		msleep(1);
 	}

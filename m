Return-Path: <linux-kernel-owner+w=401wt.eu-S1752383AbXE2XUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbXE2XUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 19:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbXE2XUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 19:20:44 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:15416 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbXE2XUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 19:20:43 -0400
X-IronPort-AV: i="4.14,590,1170662400"; 
   d="scan'208"; a="158654020:sNHT55191492"
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 29 May 2007 16:20:39 -0700
Message-ID: <adaodk3rzco.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 May 2007 23:20:39.0505 (UTC) FILETIME=[F845CC10:01C7A247]
Authentication-Results: sj-dkim-8; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim8002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few more nicely balanced ("55 insertions(+), 55
deletions(-)") 2.6.22-rc3 fixes, mostly for IPoIB connected mode:

Michael S. Tsirkin (2):
      IB/mthca: Fix handling of send CQE with error for QPs connected to SRQ
      IPoIB/cm: Fix performance regression on Mellanox

Roland Dreier (1):
      IB/mlx4: Fix last allocated object tracking in bitmap allocator

Sean Hefty (1):
      IB/cm: Fix stale connection detection

 drivers/infiniband/core/cm.c            |   25 ++++++-----
 drivers/infiniband/hw/mthca/mthca_qp.c  |    6 +-
 drivers/infiniband/ulp/ipoib/ipoib.h    |    3 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |   74 +++++++++++++++----------------
 drivers/net/mlx4/alloc.c                |    2 +-
 5 files changed, 55 insertions(+), 55 deletions(-)


diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index e840434..40c004a 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1297,26 +1297,29 @@ static struct cm_id_private * cm_match_req(struct cm_work *work,
 
 	req_msg = (struct cm_req_msg *)work->mad_recv_wc->recv_buf.mad;
 
-	/* Check for duplicate REQ and stale connections. */
+	/* Check for possible duplicate REQ. */
 	spin_lock_irqsave(&cm.lock, flags);
 	timewait_info = cm_insert_remote_id(cm_id_priv->timewait_info);
-	if (!timewait_info)
-		timewait_info = cm_insert_remote_qpn(cm_id_priv->timewait_info);
-
 	if (timewait_info) {
 		cur_cm_id_priv = cm_get_id(timewait_info->work.local_id,
 					   timewait_info->work.remote_id);
-		cm_cleanup_timewait(cm_id_priv->timewait_info);
 		spin_unlock_irqrestore(&cm.lock, flags);
 		if (cur_cm_id_priv) {
 			cm_dup_req_handler(work, cur_cm_id_priv);
 			cm_deref_id(cur_cm_id_priv);
-		} else
-			cm_issue_rej(work->port, work->mad_recv_wc,
-				     IB_CM_REJ_STALE_CONN, CM_MSG_RESPONSE_REQ,
-				     NULL, 0);
-		listen_cm_id_priv = NULL;
-		goto out;
+		}
+		return NULL;
+	}
+
+	/* Check for stale connections. */
+	timewait_info = cm_insert_remote_qpn(cm_id_priv->timewait_info);
+	if (timewait_info) {
+		cm_cleanup_timewait(cm_id_priv->timewait_info);
+		spin_unlock_irqrestore(&cm.lock, flags);
+		cm_issue_rej(work->port, work->mad_recv_wc,
+			     IB_CM_REJ_STALE_CONN, CM_MSG_RESPONSE_REQ,
+			     NULL, 0);
+		return NULL;
 	}
 
 	/* Find matching listen request. */
diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index 0276649..eef415b 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -2284,10 +2284,10 @@ void mthca_free_err_wqe(struct mthca_dev *dev, struct mthca_qp *qp, int is_send,
 	struct mthca_next_seg *next;
 
 	/*
-	 * For SRQs, all WQEs generate a CQE, so we're always at the
-	 * end of the doorbell chain.
+	 * For SRQs, all receive WQEs generate a CQE, so we're always
+	 * at the end of the doorbell chain.
 	 */
-	if (qp->ibqp.srq) {
+	if (qp->ibqp.srq && !is_send) {
 		*new_wqe = 0;
 		return;
 	}
diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 158759e..285c143 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -156,7 +156,7 @@ struct ipoib_cm_data {
  * - and then invoke a Destroy QP or Reset QP.
  *
  * We use the second option and wait for a completion on the
- * rx_drain_qp before destroying QPs attached to our SRQ.
+ * same CQ before destroying QPs attached to our SRQ.
  */
 
 enum ipoib_cm_state {
@@ -199,7 +199,6 @@ struct ipoib_cm_dev_priv {
 	struct ib_srq  	       *srq;
 	struct ipoib_cm_rx_buf *srq_ring;
 	struct ib_cm_id        *id;
-	struct ib_qp           *rx_drain_qp;   /* generates WR described in 10.3.1 */
 	struct list_head        passive_ids;   /* state: LIVE */
 	struct list_head        rx_error_list; /* state: ERROR */
 	struct list_head        rx_flush_list; /* state: FLUSH, drain not started */
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index f133b56..076a0bb 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -69,8 +69,9 @@ static struct ib_qp_attr ipoib_cm_err_attr = {
 
 #define IPOIB_CM_RX_DRAIN_WRID 0x7fffffff
 
-static struct ib_recv_wr ipoib_cm_rx_drain_wr = {
-	.wr_id = IPOIB_CM_RX_DRAIN_WRID
+static struct ib_send_wr ipoib_cm_rx_drain_wr = {
+	.wr_id = IPOIB_CM_RX_DRAIN_WRID,
+	.opcode = IB_WR_SEND,
 };
 
 static int ipoib_cm_tx_handler(struct ib_cm_id *cm_id,
@@ -163,16 +164,22 @@ partial_error:
 
 static void ipoib_cm_start_rx_drain(struct ipoib_dev_priv* priv)
 {
-	struct ib_recv_wr *bad_wr;
+	struct ib_send_wr *bad_wr;
+	struct ipoib_cm_rx *p;
 
-	/* rx_drain_qp send queue depth is 1, so
+	/* We only reserved 1 extra slot in CQ for drain WRs, so
 	 * make sure we have at most 1 outstanding WR. */
 	if (list_empty(&priv->cm.rx_flush_list) ||
 	    !list_empty(&priv->cm.rx_drain_list))
 		return;
 
-	if (ib_post_recv(priv->cm.rx_drain_qp, &ipoib_cm_rx_drain_wr, &bad_wr))
-		ipoib_warn(priv, "failed to post rx_drain wr\n");
+	/*
+	 * QPs on flush list are error state.  This way, a "flush
+	 * error" WC will be immediately generated for each WR we post.
+	 */
+	p = list_entry(priv->cm.rx_flush_list.next, typeof(*p), list);
+	if (ib_post_send(p->qp, &ipoib_cm_rx_drain_wr, &bad_wr))
+		ipoib_warn(priv, "failed to post drain wr\n");
 
 	list_splice_init(&priv->cm.rx_flush_list, &priv->cm.rx_drain_list);
 }
@@ -199,10 +206,10 @@ static struct ib_qp *ipoib_cm_create_rx_qp(struct net_device *dev,
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ib_qp_init_attr attr = {
 		.event_handler = ipoib_cm_rx_event_handler,
-		.send_cq = priv->cq, /* does not matter, we never send anything */
+		.send_cq = priv->cq, /* For drain WR */
 		.recv_cq = priv->cq,
 		.srq = priv->cm.srq,
-		.cap.max_send_wr = 1, /* FIXME: 0 Seems not to work */
+		.cap.max_send_wr = 1, /* For drain WR */
 		.cap.max_send_sge = 1, /* FIXME: 0 Seems not to work */
 		.sq_sig_type = IB_SIGNAL_ALL_WR,
 		.qp_type = IB_QPT_RC,
@@ -242,6 +249,27 @@ static int ipoib_cm_modify_rx_qp(struct net_device *dev,
 		ipoib_warn(priv, "failed to modify QP to RTR: %d\n", ret);
 		return ret;
 	}
+
+	/*
+	 * Current Mellanox HCA firmware won't generate completions
+	 * with error for drain WRs unless the QP has been moved to
+	 * RTS first. This work-around leaves a window where a QP has
+	 * moved to error asynchronously, but this will eventually get
+	 * fixed in firmware, so let's not error out if modify QP
+	 * fails.
+	 */
+	qp_attr.qp_state = IB_QPS_RTS;
+	ret = ib_cm_init_qp_attr(cm_id, &qp_attr, &qp_attr_mask);
+	if (ret) {
+		ipoib_warn(priv, "failed to init QP attr for RTS: %d\n", ret);
+		return 0;
+	}
+	ret = ib_modify_qp(qp, &qp_attr, qp_attr_mask);
+	if (ret) {
+		ipoib_warn(priv, "failed to modify QP to RTS: %d\n", ret);
+		return 0;
+	}
+
 	return 0;
 }
 
@@ -623,38 +651,11 @@ static void ipoib_cm_tx_completion(struct ib_cq *cq, void *tx_ptr)
 int ipoib_cm_dev_open(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
-	struct ib_qp_init_attr qp_init_attr = {
-		.send_cq = priv->cq,   /* does not matter, we never send anything */
-		.recv_cq = priv->cq,
-		.cap.max_send_wr = 1,  /* FIXME: 0 Seems not to work */
-		.cap.max_send_sge = 1, /* FIXME: 0 Seems not to work */
-		.cap.max_recv_wr = 1,
-		.cap.max_recv_sge = 1, /* FIXME: 0 Seems not to work */
-		.sq_sig_type = IB_SIGNAL_ALL_WR,
-		.qp_type = IB_QPT_UC,
-	};
 	int ret;
 
 	if (!IPOIB_CM_SUPPORTED(dev->dev_addr))
 		return 0;
 
-	priv->cm.rx_drain_qp = ib_create_qp(priv->pd, &qp_init_attr);
-	if (IS_ERR(priv->cm.rx_drain_qp)) {
-		printk(KERN_WARNING "%s: failed to create CM ID\n", priv->ca->name);
-		ret = PTR_ERR(priv->cm.rx_drain_qp);
-		return ret;
-	}
-
-	/*
-	 * We put the QP in error state directly.  This way, a "flush
-	 * error" WC will be immediately generated for each WR we post.
-	 */
-	ret = ib_modify_qp(priv->cm.rx_drain_qp, &ipoib_cm_err_attr, IB_QP_STATE);
-	if (ret) {
-		ipoib_warn(priv, "failed to modify drain QP to error: %d\n", ret);
-		goto err_qp;
-	}
-
 	priv->cm.id = ib_create_cm_id(priv->ca, ipoib_cm_rx_handler, dev);
 	if (IS_ERR(priv->cm.id)) {
 		printk(KERN_WARNING "%s: failed to create CM ID\n", priv->ca->name);
@@ -676,8 +677,6 @@ err_listen:
 	ib_destroy_cm_id(priv->cm.id);
 err_cm:
 	priv->cm.id = NULL;
-err_qp:
-	ib_destroy_qp(priv->cm.rx_drain_qp);
 	return ret;
 }
 
@@ -740,7 +739,6 @@ void ipoib_cm_dev_stop(struct net_device *dev)
 		kfree(p);
 	}
 
-	ib_destroy_qp(priv->cm.rx_drain_qp);
 	cancel_delayed_work(&priv->cm.stale_task);
 }
 
diff --git a/drivers/net/mlx4/alloc.c b/drivers/net/mlx4/alloc.c
index dfbd580..f8d63d3 100644
--- a/drivers/net/mlx4/alloc.c
+++ b/drivers/net/mlx4/alloc.c
@@ -51,8 +51,8 @@ u32 mlx4_bitmap_alloc(struct mlx4_bitmap *bitmap)
 
 	if (obj < bitmap->max) {
 		set_bit(obj, bitmap->table);
+		bitmap->last = (obj + 1) & (bitmap->max - 1);
 		obj |= bitmap->top;
-		bitmap->last = obj + 1;
 	} else
 		obj = -1;
 

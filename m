Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbYEEXBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbYEEXBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbYEEXAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:00:24 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:44031 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbYEEXAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:00:20 -0400
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Mon, 05 May 2008 16:00:18 -0700
Message-ID: <adak5i8z799.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 May 2008 23:00:18.0524 (UTC) FILETIME=[C9C961C0:01C8AF03]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a fixes for:

 - mlx4 breakage introduced (by me) with the CQ resize support
 - mlx4 breakage with new FW that supports smaller adapter pages
 - IPoIB breakage introduced with the separate send CQ support
 - longstanding cxgb3 breakage uncovered by stress testing
 - ehca minor messiness

Eli Cohen (1):
      IB/ipoib: Fix transmit queue stalling forever

Oren Duer (1):
      mlx4_core: Support creation of FMRs with pages smaller than 4K

Roland Dreier (1):
      IB/mlx4: Fix off-by-one errors in calls to mlx4_ib_free_cq_buf()

Stefan Roscher (1):
      IB/ehca: Fix function return types

Steve Wise (3):
      RDMA/cxgb3: QP flush fixes
      RDMA/cxgb3: Silently ignore close reply after abort.
      RDMA/cxgb3: Bump up the MPA connection setup timeout.

 drivers/infiniband/hw/cxgb3/cxio_hal.c     |   13 ++++++--
 drivers/infiniband/hw/cxgb3/cxio_hal.h     |    4 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c      |    6 ++--
 drivers/infiniband/hw/cxgb3/iwch_qp.c      |   13 +++++---
 drivers/infiniband/hw/ehca/ehca_hca.c      |    7 ++--
 drivers/infiniband/hw/mlx4/cq.c            |    4 +-
 drivers/infiniband/ulp/ipoib/ipoib.h       |    2 +
 drivers/infiniband/ulp/ipoib/ipoib_ib.c    |   47 +++++++++++++++++++++++++---
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c |    3 +-
 drivers/net/mlx4/mr.c                      |    2 +-
 10 files changed, 75 insertions(+), 26 deletions(-)


diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index ed2ee4b..5fd8506 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -359,9 +359,10 @@ static void insert_recv_cqe(struct t3_wq *wq, struct t3_cq *cq)
 	cq->sw_wptr++;
 }
 
-void cxio_flush_rq(struct t3_wq *wq, struct t3_cq *cq, int count)
+int cxio_flush_rq(struct t3_wq *wq, struct t3_cq *cq, int count)
 {
 	u32 ptr;
+	int flushed = 0;
 
 	PDBG("%s wq %p cq %p\n", __func__, wq, cq);
 
@@ -369,8 +370,11 @@ void cxio_flush_rq(struct t3_wq *wq, struct t3_cq *cq, int count)
 	PDBG("%s rq_rptr %u rq_wptr %u skip count %u\n", __func__,
 	    wq->rq_rptr, wq->rq_wptr, count);
 	ptr = wq->rq_rptr + count;
-	while (ptr++ != wq->rq_wptr)
+	while (ptr++ != wq->rq_wptr) {
 		insert_recv_cqe(wq, cq);
+		flushed++;
+	}
+	return flushed;
 }
 
 static void insert_sq_cqe(struct t3_wq *wq, struct t3_cq *cq,
@@ -394,9 +398,10 @@ static void insert_sq_cqe(struct t3_wq *wq, struct t3_cq *cq,
 	cq->sw_wptr++;
 }
 
-void cxio_flush_sq(struct t3_wq *wq, struct t3_cq *cq, int count)
+int cxio_flush_sq(struct t3_wq *wq, struct t3_cq *cq, int count)
 {
 	__u32 ptr;
+	int flushed = 0;
 	struct t3_swsq *sqp = wq->sq + Q_PTR2IDX(wq->sq_rptr, wq->sq_size_log2);
 
 	ptr = wq->sq_rptr + count;
@@ -405,7 +410,9 @@ void cxio_flush_sq(struct t3_wq *wq, struct t3_cq *cq, int count)
 		insert_sq_cqe(wq, cq, sqp);
 		sqp++;
 		ptr++;
+		flushed++;
 	}
+	return flushed;
 }
 
 /*
diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.h b/drivers/infiniband/hw/cxgb3/cxio_hal.h
index 2bcff7f..69ab08e 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.h
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.h
@@ -173,8 +173,8 @@ u32 cxio_hal_get_pdid(struct cxio_hal_resource *rscp);
 void cxio_hal_put_pdid(struct cxio_hal_resource *rscp, u32 pdid);
 int __init cxio_hal_init(void);
 void __exit cxio_hal_exit(void);
-void cxio_flush_rq(struct t3_wq *wq, struct t3_cq *cq, int count);
-void cxio_flush_sq(struct t3_wq *wq, struct t3_cq *cq, int count);
+int cxio_flush_rq(struct t3_wq *wq, struct t3_cq *cq, int count);
+int cxio_flush_sq(struct t3_wq *wq, struct t3_cq *cq, int count);
 void cxio_count_rcqes(struct t3_cq *cq, struct t3_wq *wq, int *count);
 void cxio_count_scqes(struct t3_cq *cq, struct t3_wq *wq, int *count);
 void cxio_flush_hw_cq(struct t3_cq *cq);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index d44a6df..c325c44 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -67,10 +67,10 @@ int peer2peer = 0;
 module_param(peer2peer, int, 0644);
 MODULE_PARM_DESC(peer2peer, "Support peer2peer ULPs (default=0)");
 
-static int ep_timeout_secs = 10;
+static int ep_timeout_secs = 60;
 module_param(ep_timeout_secs, int, 0644);
 MODULE_PARM_DESC(ep_timeout_secs, "CM Endpoint operation timeout "
-				   "in seconds (default=10)");
+				   "in seconds (default=60)");
 
 static int mpa_rev = 1;
 module_param(mpa_rev, int, 0644);
@@ -1650,8 +1650,8 @@ static int close_con_rpl(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 		release = 1;
 		break;
 	case ABORTING:
-		break;
 	case DEAD:
+		break;
 	default:
 		BUG_ON(1);
 		break;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index 9b4be88..79dbe5b 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -655,6 +655,7 @@ static void __flush_qp(struct iwch_qp *qhp, unsigned long *flag)
 {
 	struct iwch_cq *rchp, *schp;
 	int count;
+	int flushed;
 
 	rchp = get_chp(qhp->rhp, qhp->attr.rcq);
 	schp = get_chp(qhp->rhp, qhp->attr.scq);
@@ -669,20 +670,22 @@ static void __flush_qp(struct iwch_qp *qhp, unsigned long *flag)
 	spin_lock(&qhp->lock);
 	cxio_flush_hw_cq(&rchp->cq);
 	cxio_count_rcqes(&rchp->cq, &qhp->wq, &count);
-	cxio_flush_rq(&qhp->wq, &rchp->cq, count);
+	flushed = cxio_flush_rq(&qhp->wq, &rchp->cq, count);
 	spin_unlock(&qhp->lock);
 	spin_unlock_irqrestore(&rchp->lock, *flag);
-	(*rchp->ibcq.comp_handler)(&rchp->ibcq, rchp->ibcq.cq_context);
+	if (flushed)
+		(*rchp->ibcq.comp_handler)(&rchp->ibcq, rchp->ibcq.cq_context);
 
 	/* locking heirarchy: cq lock first, then qp lock. */
 	spin_lock_irqsave(&schp->lock, *flag);
 	spin_lock(&qhp->lock);
 	cxio_flush_hw_cq(&schp->cq);
 	cxio_count_scqes(&schp->cq, &qhp->wq, &count);
-	cxio_flush_sq(&qhp->wq, &schp->cq, count);
+	flushed = cxio_flush_sq(&qhp->wq, &schp->cq, count);
 	spin_unlock(&qhp->lock);
 	spin_unlock_irqrestore(&schp->lock, *flag);
-	(*schp->ibcq.comp_handler)(&schp->ibcq, schp->ibcq.cq_context);
+	if (flushed)
+		(*schp->ibcq.comp_handler)(&schp->ibcq, schp->ibcq.cq_context);
 
 	/* deref */
 	if (atomic_dec_and_test(&qhp->refcnt))
@@ -880,7 +883,6 @@ int iwch_modify_qp(struct iwch_dev *rhp, struct iwch_qp *qhp,
 				ep = qhp->ep;
 				get_ep(&ep->com);
 			}
-			flush_qp(qhp, &flag);
 			break;
 		case IWCH_QP_STATE_TERMINATE:
 			qhp->attr.state = IWCH_QP_STATE_TERMINATE;
@@ -911,6 +913,7 @@ int iwch_modify_qp(struct iwch_dev *rhp, struct iwch_qp *qhp,
 		}
 		switch (attrs->next_state) {
 			case IWCH_QP_STATE_IDLE:
+				flush_qp(qhp, &flag);
 				qhp->attr.state = IWCH_QP_STATE_IDLE;
 				qhp->attr.llp_stream_handle = NULL;
 				put_ep(&qhp->ep->com);
diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index 2515cbd..bc3b37d 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -101,7 +101,6 @@ int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr *props)
 	props->max_ee          = limit_uint(rblock->max_rd_ee_context);
 	props->max_rdd         = limit_uint(rblock->max_rd_domain);
 	props->max_fmr         = limit_uint(rblock->max_mr);
-	props->local_ca_ack_delay  = limit_uint(rblock->local_ca_ack_delay);
 	props->max_qp_rd_atom  = limit_uint(rblock->max_rr_qp);
 	props->max_ee_rd_atom  = limit_uint(rblock->max_rr_ee_context);
 	props->max_res_rd_atom = limit_uint(rblock->max_rr_hca);
@@ -115,7 +114,7 @@ int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr *props)
 	}
 
 	props->max_pkeys           = 16;
-	props->local_ca_ack_delay  = limit_uint(rblock->local_ca_ack_delay);
+	props->local_ca_ack_delay  = min_t(u8, rblock->local_ca_ack_delay, 255);
 	props->max_raw_ipv6_qp     = limit_uint(rblock->max_raw_ipv6_qp);
 	props->max_raw_ethy_qp     = limit_uint(rblock->max_raw_ethy_qp);
 	props->max_mcast_grp       = limit_uint(rblock->max_mcast_grp);
@@ -136,7 +135,7 @@ query_device1:
 	return ret;
 }
 
-static int map_mtu(struct ehca_shca *shca, u32 fw_mtu)
+static enum ib_mtu map_mtu(struct ehca_shca *shca, u32 fw_mtu)
 {
 	switch (fw_mtu) {
 	case 0x1:
@@ -156,7 +155,7 @@ static int map_mtu(struct ehca_shca *shca, u32 fw_mtu)
 	}
 }
 
-static int map_number_of_vls(struct ehca_shca *shca, u32 vl_cap)
+static u8 map_number_of_vls(struct ehca_shca *shca, u32 vl_cap)
 {
 	switch (vl_cap) {
 	case 0x1:
diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 2f199c5..4521319 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -246,7 +246,7 @@ err_mtt:
 	if (context)
 		ib_umem_release(cq->umem);
 	else
-		mlx4_ib_free_cq_buf(dev, &cq->buf, entries);
+		mlx4_ib_free_cq_buf(dev, &cq->buf, cq->ibcq.cqe);
 
 err_db:
 	if (!context)
@@ -434,7 +434,7 @@ int mlx4_ib_destroy_cq(struct ib_cq *cq)
 		mlx4_ib_db_unmap_user(to_mucontext(cq->uobject->context), &mcq->db);
 		ib_umem_release(mcq->umem);
 	} else {
-		mlx4_ib_free_cq_buf(dev, &mcq->buf, cq->cqe + 1);
+		mlx4_ib_free_cq_buf(dev, &mcq->buf, cq->cqe);
 		mlx4_db_free(dev->dev, &mcq->db);
 	}
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 9044f88..ca126fc 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -334,6 +334,7 @@ struct ipoib_dev_priv {
 #endif
 	int	hca_caps;
 	struct ipoib_ethtool_st ethtool;
+	struct timer_list poll_timer;
 };
 
 struct ipoib_ah {
@@ -404,6 +405,7 @@ extern struct workqueue_struct *ipoib_workqueue;
 
 int ipoib_poll(struct napi_struct *napi, int budget);
 void ipoib_ib_completion(struct ib_cq *cq, void *dev_ptr);
+void ipoib_send_comp_handler(struct ib_cq *cq, void *dev_ptr);
 
 struct ipoib_ah *ipoib_create_ah(struct net_device *dev,
 				 struct ib_pd *pd, struct ib_ah_attr *attr);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 97b815c..f429bce 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -461,6 +461,26 @@ void ipoib_ib_completion(struct ib_cq *cq, void *dev_ptr)
 	netif_rx_schedule(dev, &priv->napi);
 }
 
+static void drain_tx_cq(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->tx_lock, flags);
+	while (poll_tx(priv))
+		; /* nothing */
+
+	if (netif_queue_stopped(dev))
+		mod_timer(&priv->poll_timer, jiffies + 1);
+
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
+}
+
+void ipoib_send_comp_handler(struct ib_cq *cq, void *dev_ptr)
+{
+	drain_tx_cq((struct net_device *)dev_ptr);
+}
+
 static inline int post_send(struct ipoib_dev_priv *priv,
 			    unsigned int wr_id,
 			    struct ib_ah *address, u32 qpn,
@@ -555,12 +575,22 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 	else
 		priv->tx_wr.send_flags &= ~IB_SEND_IP_CSUM;
 
+	if (++priv->tx_outstanding == ipoib_sendq_size) {
+		ipoib_dbg(priv, "TX ring full, stopping kernel net queue\n");
+		if (ib_req_notify_cq(priv->send_cq, IB_CQ_NEXT_COMP))
+			ipoib_warn(priv, "request notify on send CQ failed\n");
+		netif_stop_queue(dev);
+	}
+
 	if (unlikely(post_send(priv, priv->tx_head & (ipoib_sendq_size - 1),
 			       address->ah, qpn, tx_req, phead, hlen))) {
 		ipoib_warn(priv, "post_send failed\n");
 		++dev->stats.tx_errors;
+		--priv->tx_outstanding;
 		ipoib_dma_unmap_tx(priv->ca, tx_req);
 		dev_kfree_skb_any(skb);
+		if (netif_queue_stopped(dev))
+			netif_wake_queue(dev);
 	} else {
 		dev->trans_start = jiffies;
 
@@ -568,14 +598,11 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 		++priv->tx_head;
 		skb_orphan(skb);
 
-		if (++priv->tx_outstanding == ipoib_sendq_size) {
-			ipoib_dbg(priv, "TX ring full, stopping kernel net queue\n");
-			netif_stop_queue(dev);
-		}
 	}
 
 	if (unlikely(priv->tx_outstanding > MAX_SEND_CQE))
-		poll_tx(priv);
+		while (poll_tx(priv))
+			; /* nothing */
 }
 
 static void __ipoib_reap_ah(struct net_device *dev)
@@ -609,6 +636,11 @@ void ipoib_reap_ah(struct work_struct *work)
 				   round_jiffies_relative(HZ));
 }
 
+static void ipoib_ib_tx_timer_func(unsigned long ctx)
+{
+	drain_tx_cq((struct net_device *)ctx);
+}
+
 int ipoib_ib_dev_open(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
@@ -645,6 +677,10 @@ int ipoib_ib_dev_open(struct net_device *dev)
 	queue_delayed_work(ipoib_workqueue, &priv->ah_reap_task,
 			   round_jiffies_relative(HZ));
 
+	init_timer(&priv->poll_timer);
+	priv->poll_timer.function = ipoib_ib_tx_timer_func;
+	priv->poll_timer.data = (unsigned long)dev;
+
 	set_bit(IPOIB_FLAG_INITIALIZED, &priv->flags);
 
 	return 0;
@@ -810,6 +846,7 @@ int ipoib_ib_dev_stop(struct net_device *dev, int flush)
 	ipoib_dbg(priv, "All sends and receives done.\n");
 
 timeout:
+	del_timer_sync(&priv->poll_timer);
 	qp_attr.qp_state = IB_QPS_RESET;
 	if (ib_modify_qp(priv->qp, &qp_attr, IB_QP_STATE))
 		ipoib_warn(priv, "Failed to modify QP to RESET state\n");
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index c1e7ece..8766d29 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -187,7 +187,8 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 		goto out_free_mr;
 	}
 
-	priv->send_cq = ib_create_cq(priv->ca, NULL, NULL, dev, ipoib_sendq_size, 0);
+	priv->send_cq = ib_create_cq(priv->ca, ipoib_send_comp_handler, NULL,
+				     dev, ipoib_sendq_size, 0);
 	if (IS_ERR(priv->send_cq)) {
 		printk(KERN_WARNING "%s: failed to create send CQ\n", ca->name);
 		goto out_free_recv_cq;
diff --git a/drivers/net/mlx4/mr.c b/drivers/net/mlx4/mr.c
index cb46446..03a9abc 100644
--- a/drivers/net/mlx4/mr.c
+++ b/drivers/net/mlx4/mr.c
@@ -551,7 +551,7 @@ int mlx4_fmr_alloc(struct mlx4_dev *dev, u32 pd, u32 access, int max_pages,
 	u64 mtt_seg;
 	int err = -ENOMEM;
 
-	if (page_shift < 12 || page_shift >= 32)
+	if (page_shift < (ffs(dev->caps.page_size_cap) - 1) || page_shift >= 32)
 		return -EINVAL;
 
 	/* All MTTs must fit in the same page */

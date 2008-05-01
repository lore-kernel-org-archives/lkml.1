Return-Path: <linux-kernel-owner+w=401wt.eu-S1759938AbYEADqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbYEADqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 23:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755658AbYEADq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 23:46:28 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:14780 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbYEADq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 23:46:26 -0400
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Wed, 30 Apr 2008 20:46:24 -0700
Message-ID: <adamyna660f.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 May 2008 03:46:24.0878 (UTC) FILETIME=[EDAA60E0:01C8AB3D]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a couple of fixes for medium-impact bugs.  If they can go
into -rc1, great; otherwise the world won't end if they end up in -rc2.

Eli Cohen (1):
      IB/ipoib: Fix transmit queue stalling forever

Roland Dreier (1):
      IB/mlx4: Fix off-by-one errors in calls to mlx4_ib_free_cq_buf()

 drivers/infiniband/hw/mlx4/cq.c            |    4 +-
 drivers/infiniband/ulp/ipoib/ipoib.h       |    2 +
 drivers/infiniband/ulp/ipoib/ipoib_ib.c    |   47 +++++++++++++++++++++++++---
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c |    3 +-
 4 files changed, 48 insertions(+), 8 deletions(-)


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

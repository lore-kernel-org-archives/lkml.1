Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbXDZWps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbXDZWps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbXDZWps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:45:48 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:2153 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbXDZWpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:45:46 -0400
X-IronPort-AV: i="4.14,458,1170662400"; 
   d="scan'208"; a="141116097:sNHT77010939"
To: linux-kernel@vger.kernel.org
Cc: general@lists.openfabrics.org, netdev@vger.kernel.org
Subject: [PATCH][RFC] IPoIB: Convert to NAPI
X-Message-Flag: Warning: May contain useful information
References: <adaps5rro8v.fsf@cisco.com> <adaejm6pxiw.fsf@cisco.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 26 Apr 2007 15:45:44 -0700
In-Reply-To: <adaejm6pxiw.fsf@cisco.com> (Roland Dreier's message of "Thu, 26 Apr 2007 15:43:19 -0700")
Message-ID: <adaabwupxev.fsf_-_@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Apr 2007 22:45:44.0963 (UTC) FILETIME=[A0324D30:01C78854]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

And here's the patch to convert IPoIB over to using NAPI...

---

Convert the IP-over-InfiniBand network device driver over to using
NAPI to handle all completions (both receive and send).

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/infiniband/ulp/ipoib/ipoib.h      |    1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c   |   89 ++++++++++++++++++++++------
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    2 +
 4 files changed, 74 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index fd55826..15867af 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -311,6 +311,7 @@ extern struct workqueue_struct *ipoib_workqueue;
 
 /* functions */
 
+int ipoib_poll(struct net_device *dev, int *budget);
 void ipoib_ib_completion(struct ib_cq *cq, void *dev_ptr);
 
 struct ipoib_ah *ipoib_create_ah(struct net_device *dev,
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 2b242a4..e1fdae1 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -418,7 +418,7 @@ void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 	skb->dev = dev;
 	/* XXX get correct PACKET_ type here */
 	skb->pkt_type = PACKET_HOST;
-	netif_rx_ni(skb);
+	netif_receive_skb(skb);
 
 repost:
 	if (unlikely(ipoib_cm_post_receive(dev, wr_id)))
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index ba0ee5c..e3cc241 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -226,7 +226,7 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 		skb->dev = dev;
 		/* XXX get correct PACKET_ type here */
 		skb->pkt_type = PACKET_HOST;
-		netif_rx_ni(skb);
+		netif_receive_skb(skb);
 	} else {
 		ipoib_dbg_data(priv, "dropping loopback packet\n");
 		dev_kfree_skb_any(skb);
@@ -280,28 +280,65 @@ static void ipoib_ib_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 			   wc->status, wr_id, wc->vendor_err);
 }
 
-static void ipoib_ib_handle_wc(struct net_device *dev, struct ib_wc *wc)
+int ipoib_poll(struct net_device *dev, int *budget)
 {
-	if (wc->wr_id & IPOIB_CM_OP_SRQ)
-		ipoib_cm_handle_rx_wc(dev, wc);
-	else if (wc->wr_id & IPOIB_OP_RECV)
-		ipoib_ib_handle_rx_wc(dev, wc);
-	else
-		ipoib_ib_handle_tx_wc(dev, wc);
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	int max = min(*budget, dev->quota);
+	int done;
+	int t;
+	int empty;
+	int n, i;
+
+repoll:
+	done  = 0;
+	empty = 0;
+
+	while (max) {
+		t = min(IPOIB_NUM_WC, max);
+		n = ib_poll_cq(priv->cq, t, priv->ibwc);
+
+		for (i = 0; i < n; ++i) {
+			struct ib_wc *wc = priv->ibwc + i;
+
+			if (wc->wr_id & IPOIB_CM_OP_SRQ) {
+				++done;
+				--max;
+				ipoib_cm_handle_rx_wc(dev, wc);
+			} else if (wc->wr_id & IPOIB_OP_RECV) {
+				++done;
+				--max;
+				ipoib_ib_handle_rx_wc(dev, wc);
+			} else
+				ipoib_ib_handle_tx_wc(dev, wc);
+		}
+
+		if (n != t) {
+			empty = 1;
+			break;
+		}
+	}
+
+	dev->quota -= done;
+	*budget    -= done;
+
+	if (empty) {
+		netif_rx_complete(dev);
+		if (unlikely(ib_req_notify_cq(priv->cq,
+					      IB_CQ_NEXT_COMP |
+					      IB_CQ_REPORT_MISSED_EVENTS))) {
+			netif_rx_reschedule(dev, 0);
+			return 1;
+		}
+
+		return 0;
+	}
+
+	return 1;
 }
 
 void ipoib_ib_completion(struct ib_cq *cq, void *dev_ptr)
 {
-	struct net_device *dev = (struct net_device *) dev_ptr;
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
-	int n, i;
-
-	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
-	do {
-		n = ib_poll_cq(cq, IPOIB_NUM_WC, priv->ibwc);
-		for (i = 0; i < n; ++i)
-			ipoib_ib_handle_wc(dev, priv->ibwc + i);
-	} while (n == IPOIB_NUM_WC);
+	netif_rx_schedule(dev_ptr);
 }
 
 static inline int post_send(struct ipoib_dev_priv *priv,
@@ -514,9 +551,10 @@ int ipoib_ib_dev_stop(struct net_device *dev)
 	struct ib_qp_attr qp_attr;
 	unsigned long begin;
 	struct ipoib_tx_buf *tx_req;
-	int i;
+	int i, n;
 
 	clear_bit(IPOIB_FLAG_INITIALIZED, &priv->flags);
+	netif_poll_disable(dev);
 
 	ipoib_cm_dev_stop(dev);
 
@@ -568,6 +606,16 @@ int ipoib_ib_dev_stop(struct net_device *dev)
 			goto timeout;
 		}
 
+		do {
+			n = ib_poll_cq(priv->cq, IPOIB_NUM_WC, priv->ibwc);
+			for (i = 0; i < n; ++i) {
+				if (priv->ibwc[i].wr_id & IPOIB_OP_RECV)
+					ipoib_ib_handle_rx_wc(dev, priv->ibwc + i);
+				else
+					ipoib_ib_handle_tx_wc(dev, priv->ibwc + i);
+			}
+		} while (n == IPOIB_NUM_WC);
+
 		msleep(1);
 	}
 
@@ -596,6 +644,9 @@ timeout:
 		msleep(1);
 	}
 
+	netif_poll_enable(dev);
+	ib_req_notify_cq(priv->cq, IB_CQ_NEXT_COMP);
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index f2a40ae..a69c472 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -952,6 +952,8 @@ static void ipoib_setup(struct net_device *dev)
 	dev->hard_header 	 = ipoib_hard_header;
 	dev->set_multicast_list  = ipoib_set_mcast_list;
 	dev->neigh_setup         = ipoib_neigh_setup_dev;
+	dev->poll                = ipoib_poll;
+	dev->weight              = 100;
 
 	dev->watchdog_timeo 	 = HZ;
 
-- 
1.5.1.2

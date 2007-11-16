Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbXKPTZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbXKPTZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 14:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932722AbXKPTW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 14:22:29 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:23379 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641AbXKPTW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 14:22:27 -0500
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH 9/9] cxgb3 - Fix I/O synchronization
To: jeff@garzik.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com, wenxiong@us.ibm.com
Date: Fri, 16 Nov 2007 11:22:21 -0800
Message-ID: <20071116192221.31168.15389.stgit@speedy5>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Synchronize memory access before ringing 
the Tx door bell.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/sge.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/cxgb3/sge.c b/drivers/net/cxgb3/sge.c
index 7b13d8a..666c317 100644
--- a/drivers/net/cxgb3/sge.c
+++ b/drivers/net/cxgb3/sge.c
@@ -174,6 +174,7 @@ static inline struct sge_qset *txq_to_qset(const struct sge_txq *q, int qidx)
 static inline void refill_rspq(struct adapter *adapter,
 			       const struct sge_rspq *q, unsigned int credits)
 {
+	rmb();
 	t3_write_reg(adapter, A_SG_RSPQ_CREDIT_RETURN,
 		     V_RSPQ(q->cntxt_id) | V_CREDITS(credits));
 }
@@ -458,7 +459,7 @@ nomem:				q->alloc_failed++;
 		}
 		q->credits++;
 	}
-
+	wmb();
 	t3_write_reg(adap, A_SG_KDOORBELL, V_EGRCNTX(q->cntxt_id));
 }
 
@@ -1353,6 +1354,7 @@ static void restart_ctrlq(unsigned long data)
 	}
 
 	spin_unlock(&q->lock);
+	wmb();
 	t3_write_reg(qs->adap, A_SG_KDOORBELL,
 		     F_SELEGRCNTX | V_EGRCNTX(q->cntxt_id));
 }
@@ -1572,6 +1574,7 @@ static void restart_offloadq(unsigned long data)
 	set_bit(TXQ_RUNNING, &q->flags);
 	set_bit(TXQ_LAST_PKT_DB, &q->flags);
 #endif
+	wmb();
 	t3_write_reg(adap, A_SG_KDOORBELL,
 		     F_SELEGRCNTX | V_EGRCNTX(q->cntxt_id));
 }
@@ -1737,7 +1740,6 @@ static inline int rx_offload(struct t3cdev *tdev, struct sge_rspq *rq,
 			     struct sk_buff *skb, struct sk_buff *rx_gather[],
 			     unsigned int gather_idx)
 {
-	rq->offload_pkts++;
 	skb_reset_mac_header(skb);
 	skb_reset_network_header(skb);
 	skb_reset_transport_header(skb);
@@ -2031,6 +2033,7 @@ no_mem:
 			if (eth)
 				rx_eth(adap, q, skb, ethpad);
 			else {
+				q->offload_pkts++;
 				/* Preserve the RSS info in csum & priority */
 				skb->csum = rss_hi;
 				skb->priority = rss_lo;

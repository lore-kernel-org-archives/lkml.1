Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab0BAU3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 15:29:37 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:32240 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab0BAU3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 15:29:35 -0500
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH net-next-2.6] cxgb3: add memory barriers
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com, wenxiong@us.ibm.com
Date: Mon, 01 Feb 2010 12:29:29 -0800
Message-ID: <20100201202929.23037.68116.stgit@speedy5.asicdesigners.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Add memory barriers to fix crashes observed on newest PowerPC platforms.
The HW and driver state of the receive rings were getting out of sync.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/sge.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)


diff --git a/drivers/net/cxgb3/sge.c b/drivers/net/cxgb3/sge.c
index bdbd147..4cf9b79 100644
--- a/drivers/net/cxgb3/sge.c
+++ b/drivers/net/cxgb3/sge.c
@@ -480,6 +480,7 @@ static inline void ring_fl_db(struct adapter *adap, struct sge_fl *q)
 {
 	if (q->pend_cred >= q->credits / 4) {
 		q->pend_cred = 0;
+		wmb();
 		t3_write_reg(adap, A_SG_KDOORBELL, V_EGRCNTX(q->cntxt_id));
 	}
 }
@@ -2282,11 +2283,14 @@ static int process_responses(struct adapter *adap, struct sge_qset *qs,
 	while (likely(budget_left && is_new_response(r, q))) {
 		int packet_complete, eth, ethpad = 2, lro = qs->lro_enabled;
 		struct sk_buff *skb = NULL;
-		u32 len, flags = ntohl(r->flags);
-		__be32 rss_hi = *(const __be32 *)r,
-		       rss_lo = r->rss_hdr.rss_hash_val;
+		u32 len, flags;
+		__be32 rss_hi, rss_lo;
 
+		rmb();
 		eth = r->rss_hdr.opcode == CPL_RX_PKT;
+		rss_hi = *(const __be32 *)r;
+		rss_lo = r->rss_hdr.rss_hash_val;
+		flags = ntohl(r->flags);
 
 		if (unlikely(flags & F_RSPD_ASYNC_NOTIF)) {
 			skb = alloc_skb(AN_PKT_SIZE, GFP_ATOMIC);
@@ -2497,7 +2501,10 @@ static int process_pure_responses(struct adapter *adap, struct sge_qset *qs,
 			refill_rspq(adap, q, q->credits);
 			q->credits = 0;
 		}
-	} while (is_new_response(r, q) && is_pure_response(r));
+		if (!is_new_response(r, q))
+			break;
+		rmb();
+	} while (is_pure_response(r));
 
 	if (sleeping)
 		check_ring_db(adap, qs, sleeping);
@@ -2531,6 +2538,7 @@ static inline int handle_responses(struct adapter *adap, struct sge_rspq *q)
 
 	if (!is_new_response(r, q))
 		return -1;
+	rmb();
 	if (is_pure_response(r) && process_pure_responses(adap, qs, r) == 0) {
 		t3_write_reg(adap, A_SG_GTS, V_RSPQ(q->cntxt_id) |
 			     V_NEWTIMER(q->holdoff_tmr) | V_NEWINDEX(q->cidx));


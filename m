Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab0BIAzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 19:55:51 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:23255 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab0BIAzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 19:55:50 -0500
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH net-2.6] cxgb3: fix GRO checksum check
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Mon, 08 Feb 2010 16:55:44 -0800
Message-ID: <20100209005544.12679.3987.stgit@speedy5.asicdesigners.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Verify the HW checksum state for frames handed to GRO processing.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/sge.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)


diff --git a/drivers/net/cxgb3/sge.c b/drivers/net/cxgb3/sge.c
index bdbd147..318a018 100644
--- a/drivers/net/cxgb3/sge.c
+++ b/drivers/net/cxgb3/sge.c
@@ -2079,6 +2079,7 @@ static void lro_add_page(struct adapter *adap, struct sge_qset *qs,
 			 struct sge_fl *fl, int len, int complete)
 {
 	struct rx_sw_desc *sd = &fl->sdesc[fl->cidx];
+	struct port_info *pi = netdev_priv(qs->netdev);
 	struct sk_buff *skb = NULL;
 	struct cpl_rx_pkt *cpl;
 	struct skb_frag_struct *rx_frag;
@@ -2116,11 +2117,18 @@ static void lro_add_page(struct adapter *adap, struct sge_qset *qs,
 
 	if (!nr_frags) {
 		offset = 2 + sizeof(struct cpl_rx_pkt);
-		qs->lro_va = sd->pg_chunk.va + 2;
-	}
-	len -= offset;
+		cpl = qs->lro_va = sd->pg_chunk.va + 2;
 
-	prefetch(qs->lro_va);
+		if ((pi->rx_offload & T3_RX_CSUM) &&
+		     cpl->csum_valid && cpl->csum == htons(0xffff)) {
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+			qs->port_stats[SGE_PSTAT_RX_CSUM_GOOD]++;
+		} else
+			skb->ip_summed = CHECKSUM_NONE;
+	} else
+		cpl = qs->lro_va;
+
+	len -= offset;
 
 	rx_frag += nr_frags;
 	rx_frag->page = sd->pg_chunk.page;
@@ -2136,12 +2144,8 @@ static void lro_add_page(struct adapter *adap, struct sge_qset *qs,
 		return;
 
 	skb_record_rx_queue(skb, qs - &adap->sge.qs[0]);
-	skb->ip_summed = CHECKSUM_UNNECESSARY;
-	cpl = qs->lro_va;
 
 	if (unlikely(cpl->vlan_valid)) {
-		struct net_device *dev = qs->netdev;
-		struct port_info *pi = netdev_priv(dev);
 		struct vlan_group *grp = pi->vlan_grp;
 
 		if (likely(grp != NULL)) {


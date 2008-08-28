Return-Path: <linux-kernel-owner+w=401wt.eu-S1751869AbYH1EJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbYH1EJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 00:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYH1EJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 00:09:25 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:27986 "EHLO
	stargate.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750915AbYH1EJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 00:09:22 -0400
Date: Wed, 27 Aug 2008 21:21:58 -0700
From: Karen Xie <kxie@chelsio.com>
Message-Id: <200808280421.m7S4Lw4r006465@localhost.localdomain>
To: netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4 2.6.28] cxgb3 - handle ARP replies for private iSCSI IP address
Cc: jgarzik@pobox.com, davem@davemloft.net, michaelc@cs.wisc.edu,
       swise@opengridcomputing.com, rdreier@cisco.com, daisyc@us.ibm.com,
       wenxiong@us.ibm.com, bhua@us.ibm.com, divy@chelsio.com, dm@chelsio.com,
       leedom@chelsio.com, kxie@chelsio.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 2/4 2.6.28] cxgb3 - handle ARP replies for private iSCSI IP address

From: Karen Xie <kxie@chelsio.com>

The accelerated iSCSI traffic uses a private IP address unknown to the OS.
The driver has to reply to ARP requests dedicated to the private IP address.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/sge.c |   72 ++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 67 insertions(+), 5 deletions(-)


diff --git a/drivers/net/cxgb3/sge.c b/drivers/net/cxgb3/sge.c
index 1b0861d..2f17cf3 100644
--- a/drivers/net/cxgb3/sge.c
+++ b/drivers/net/cxgb3/sge.c
@@ -36,6 +36,7 @@
 #include <linux/ip.h>
 #include <linux/tcp.h>
 #include <linux/dma-mapping.h>
+#include <net/arp.h>
 #include "common.h"
 #include "regs.h"
 #include "sge_defs.h"
@@ -1859,6 +1860,54 @@ static void restart_tx(struct sge_qset *qs)
 }
 
 /**
+ *	cxgb3_arp_process - process an ARP request probing a private IP address
+ *	@adapter: the adapter
+ *	@skb: the skbuff containing the ARP request
+ *
+ *	Check if the ARP request is probing the private IP address
+ *	dedicated to iSCSI, generate an ARP reply if so.
+ */
+static void cxgb3_arp_process(struct adapter *adapter, struct sk_buff *skb)
+{
+	struct net_device *dev = skb->dev;
+	struct port_info *pi;
+	struct arphdr *arp;
+	unsigned char *arp_ptr;
+	unsigned char *sha;
+	__be32 sip, tip;
+
+	if (!dev)
+		return;
+
+	skb_reset_network_header(skb);
+	arp = arp_hdr(skb);
+
+	if (arp->ar_op != htons(ARPOP_REQUEST))
+		return;
+
+	arp_ptr = (unsigned char *)(arp + 1);
+	sha = arp_ptr;
+	arp_ptr += dev->addr_len;
+	memcpy(&sip, arp_ptr, sizeof(sip));
+	arp_ptr += sizeof(sip);
+	arp_ptr += dev->addr_len;
+	memcpy(&tip, arp_ptr, sizeof(tip));
+
+	pi = netdev_priv(dev);
+	if (tip != pi->iscsi_ipv4addr)
+		return;
+
+	arp_send(ARPOP_REPLY, ETH_P_ARP, sip, dev, tip, sha,
+		 dev->dev_addr, sha);
+
+}
+
+static inline int is_arp(struct sk_buff *skb)
+{
+	return skb->protocol == htons(ETH_P_ARP);
+}
+
+/**
  *	rx_eth - process an ingress ethernet packet
  *	@adap: the adapter
  *	@rq: the response queue that received the packet
@@ -1882,7 +1931,7 @@ static void rx_eth(struct adapter *adap, struct sge_rspq *rq,
 	pi = netdev_priv(skb->dev);
 	if (pi->rx_csum_offload && p->csum_valid && p->csum == htons(0xffff) &&
 	    !p->fragment) {
-		rspq_to_qset(rq)->port_stats[SGE_PSTAT_RX_CSUM_GOOD]++;
+		qs->port_stats[SGE_PSTAT_RX_CSUM_GOOD]++;
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 	} else
 		skb->ip_summed = CHECKSUM_NONE;
@@ -1891,22 +1940,35 @@ static void rx_eth(struct adapter *adap, struct sge_rspq *rq,
 		struct vlan_group *grp = pi->vlan_grp;
 
 		qs->port_stats[SGE_PSTAT_VLANEX]++;
-		if (likely(grp))
+
+		if (likely(grp)) {
 			if (lro)
 				lro_vlan_hwaccel_receive_skb(&qs->lro_mgr, skb,
 							     grp,
 							     ntohs(p->vlan),
 							     p);
-			else
+			else {
+				if (unlikely(pi->iscsi_ipv4addr &&
+					     is_arp(skb))) {
+					unsigned short vtag = ntohs(p->vlan) &
+							VLAN_VID_MASK;
+					skb->dev = vlan_group_get_device(grp,
+									 vtag);
+					cxgb3_arp_process(adap, skb);
+				}
 				__vlan_hwaccel_rx(skb, grp, ntohs(p->vlan),
 					  	  rq->polling);
-		else
+			}
+		} else
 			dev_kfree_skb_any(skb);
 	} else if (rq->polling) {
 		if (lro)
 			lro_receive_skb(&qs->lro_mgr, skb, p);
-		else
+		else {
+			if (unlikely(pi->iscsi_ipv4addr && is_arp(skb)))
+				cxgb3_arp_process(adap, skb);
 			netif_receive_skb(skb);
+		}
 	} else
 		netif_rx(skb);
 }

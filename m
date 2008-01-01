Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbYAACMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbYAACMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 21:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbYAACF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 21:05:59 -0500
Received: from fmailhost03.isp.att.net ([207.115.11.53]:43882 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYAACFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 21:05:40 -0500
X-Originating-IP: [68.222.90.230]
From: jacliburn@bellsouth.net
To: jeff@garzik.org
Cc: csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH 03/26] atl1: fix broken TSO
Date: Mon, 31 Dec 2007 19:59:41 -0600
Message-Id: <1199152804-3889-4-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cliburn <jacliburn@bellsouth.net>

The L1 tx packet descriptor expects TCP Header Length to be expressed as a
number of 32-bit dwords.  The atl1 driver uses tcp_hdrlen() to populate the
field, but tcp_hdrlen() returns the header length in bytes, not in dwords.
Add a shift to convert tcp_hdrlen() to dwords when we write it to the tpd.

Also, some of our bit assignments are made to the wrong tpd words.  Change
those to the correct words.

Finally, since all this fixes TSO, enable TSO by default.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---
 drivers/net/atlx/atl1.c |   29 +++++++++++------------------
 1 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 0df3f32..4e98c16 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -36,7 +36,6 @@
  * A very incomplete list of things that need to be dealt with:
  *
  * TODO:
- * Fix TSO; tx performance is horrible with TSO enabled.
  * Wake on LAN.
  * Add more ethtool functions.
  * Fix abstruse irq enable/disable condition described here:
@@ -1308,8 +1307,8 @@ static int atl1_tso(struct atl1_adapter *adapter, struct sk_buff *skb,
 				tso->tsopl |= 1 << TSO_PARAM_ETHTYPE_SHIFT;
 
 			tso->tsopl |= (iph->ihl &
-				CSUM_PARAM_IPHL_MASK) << CSUM_PARAM_IPHL_SHIFT;
-			tso->tsopl |= (tcp_hdrlen(skb) &
+				TSO_PARAM_IPHL_MASK) << TSO_PARAM_IPHL_SHIFT;
+			tso->tsopl |= ((tcp_hdrlen(skb) >> 2) &
 				TSO_PARAM_TCPHDRLEN_MASK) <<
 				TSO_PARAM_TCPHDRLEN_SHIFT;
 			tso->tsopl |= (skb_shinfo(skb)->gso_size &
@@ -1472,8 +1471,8 @@ static void atl1_tx_queue(struct atl1_adapter *adapter, int count,
 		tpd->desc.tso.tsopl = descr->tso.tsopl;
 		tpd->buffer_addr = cpu_to_le64(buffer_info->dma);
 		tpd->desc.data = descr->data;
-		tpd->desc.csum.csumpu |= (cpu_to_le16(buffer_info->length) &
-			CSUM_PARAM_BUFLEN_MASK) << CSUM_PARAM_BUFLEN_SHIFT;
+		tpd->desc.tso.tsopu |= (cpu_to_le16(buffer_info->length) &
+			TSO_PARAM_BUFLEN_MASK) << TSO_PARAM_BUFLEN_SHIFT;
 
 		val = (descr->tso.tsopl >> TSO_PARAM_SEGMENT_SHIFT) &
 			TSO_PARAM_SEGMENT_MASK;
@@ -1481,7 +1480,7 @@ static void atl1_tx_queue(struct atl1_adapter *adapter, int count,
 			tpd->desc.tso.tsopl |= 1 << TSO_PARAM_HDRFLAG_SHIFT;
 
 		if (j == (count - 1))
-			tpd->desc.csum.csumpl |= 1 << CSUM_PARAM_EOP_SHIFT;
+			tpd->desc.tso.tsopl |= 1 << TSO_PARAM_EOP_SHIFT;
 
 		if (++tpd_next_to_use == tpd_ring->count)
 			tpd_next_to_use = 0;
@@ -1574,9 +1573,9 @@ static int atl1_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 		vlan_tag = vlan_tx_tag_get(skb);
 		vlan_tag = (vlan_tag << 4) | (vlan_tag >> 13) |
 			((vlan_tag >> 9) & 0x8);
-		param.csum.csumpl |= 1 << CSUM_PARAM_INSVLAG_SHIFT;
-		param.csum.csumpu |= (vlan_tag & CSUM_PARAM_VALANTAG_MASK) <<
-			CSUM_PARAM_VALAN_SHIFT;
+		param.tso.tsopl |= 1 << TSO_PARAM_INSVLAG_SHIFT;
+		param.tso.tsopu |= (vlan_tag & TSO_PARAM_VLANTAG_MASK) <<
+			TSO_PARAM_VLAN_SHIFT;
 	}
 
 	tso = atl1_tso(adapter, skb, &param.tso);
@@ -1595,8 +1594,8 @@ static int atl1_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 		}
 	}
 
-	val = (param.csum.csumpl >> CSUM_PARAM_SEGMENT_SHIFT) &
-		CSUM_PARAM_SEGMENT_MASK;
+	val = (param.tso.tsopl >> TSO_PARAM_SEGMENT_SHIFT) &
+		TSO_PARAM_SEGMENT_MASK;
 	atl1_tx_map(adapter, skb, 1 == val);
 	atl1_tx_queue(adapter, count, &param);
 	netdev->trans_start = jiffies;
@@ -2091,13 +2090,7 @@ static int __devinit atl1_probe(struct pci_dev *pdev,
 	netdev->features = NETIF_F_HW_CSUM;
 	netdev->features |= NETIF_F_SG;
 	netdev->features |= (NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX);
-
-	/*
-	 * FIXME - Until tso performance gets fixed, disable the feature.
-	 * Enable it with ethtool -K if desired.
-	 */
-	/* netdev->features |= NETIF_F_TSO; */
-
+	netdev->features |= NETIF_F_TSO;
 	netdev->features |= NETIF_F_LLTX;
 
 	/*
-- 
1.5.3.3


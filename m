Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbXKKAv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbXKKAv1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 19:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbXKKAvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 19:51:13 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:61683 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbXKKAvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 19:51:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:thread-index:message-id;
        b=Rs6cblkCJ1dfZpKSmA6QGXXaf57n5dRvaSXb+w6SpSpMe1N0jKWKQexyrie7tzNgn4lUjzc3Vf/pO8U3X2G9kjGXC9UcJk/NRsDtBldOXYGaTofH5+wpIHy0oAqpen3TBkSGdITLc6nZVDerPUy/BSoakI/u2N9tMnm4XRVsiwo=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "'David Miller'" <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: "'Dave Johnson'" <djohnson+linux-kernel@sw.starentnetworks.com>,
       <linux-kernel@vger.kernel.org>, <e1000-devel@lists.sourceforge.net>
Subject: [PATCH 1/2] [VLAN] Don't drop an unclassfied vlan packet as PACKET_OTHERHOST
Date: Sun, 11 Nov 2007 09:51:20 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook, Build 11.0.5510
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: Acgj/PXFq+o2L5kUQCqZnyixrdZtmw==
Message-ID: <473651fd.0f10240a.0686.2169@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

IMHO linux should not drop unclassified vlan packets to pass these to sniffers. isn't it?
But, since the __vlan_hwaccel_rx drops unclassified vlan packets, sniffers cannot see them.
This make the __vlan_hwaccel_rx receive and process an unclassified vlan packet as a PACKET_OTHERHOST.
Any check, comments will be appreciated.
Thanks.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com> 
---
 include/linux/if_vlan.h |   61 ++++++++++++++++++++++++++--------------------
 1 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 976d4b1..e1db5bc 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -170,21 +170,26 @@ static inline int __vlan_hwaccel_rx(struct sk_buff *skb,
 				    unsigned short vlan_tag, int polling)
 {
 	struct net_device_stats *stats;
+	struct net_device *vlan_dev;
 
 	if (skb_bond_should_drop(skb)) {
 		dev_kfree_skb_any(skb);
 		return NET_RX_DROP;
 	}
 
-	skb->dev = vlan_group_get_device(grp, vlan_tag & VLAN_VID_MASK);
-	if (skb->dev == NULL) {
-		dev_kfree_skb_any(skb);
+	vlan_dev = vlan_group_get_device(grp, vlan_tag & VLAN_VID_MASK);
+	if (vlan_dev == NULL) {
+		if (skb->dev == NULL) {
+			dev_kfree_skb_any(skb);
 
-		/* Not NET_RX_DROP, this is not being dropped
-		 * due to congestion.
-		 */
-		return 0;
-	}
+			/* Not NET_RX_DROP, this is not being dropped
+			 * due to congestion.
+			 */
+			return 0;
+		}
+		skb->pkt_type = PACKET_OTHERHOST;
+	} else
+		skb->dev = vlan_dev;
 
 	skb->dev->last_rx = jiffies;
 
@@ -192,25 +197,27 @@ static inline int __vlan_hwaccel_rx(struct sk_buff *skb,
 	stats->rx_packets++;
 	stats->rx_bytes += skb->len;
 
-	skb->priority = vlan_get_ingress_priority(skb->dev, vlan_tag);
-	switch (skb->pkt_type) {
-	case PACKET_BROADCAST:
-		break;
-
-	case PACKET_MULTICAST:
-		stats->multicast++;
-		break;
-
-	case PACKET_OTHERHOST:
-		/* Our lower layer thinks this is not local, let's make sure.
-		 * This allows the VLAN to have a different MAC than the underlying
-		 * device, and still route correctly.
-		 */
-		if (!compare_ether_addr(eth_hdr(skb)->h_dest,
-				       	skb->dev->dev_addr))
-			skb->pkt_type = PACKET_HOST;
-		break;
-	};
+	if (vlan_dev) {
+		skb->priority = vlan_get_ingress_priority(skb->dev, vlan_tag);
+		switch (skb->pkt_type) {
+		case PACKET_BROADCAST:
+			break;
+
+		case PACKET_MULTICAST:
+			stats->multicast++;
+			break;
+
+		case PACKET_OTHERHOST:
+			/* Our lower layer thinks this is not local, let's make sure.
+			 * This allows the VLAN to have a different MAC than the underlying
+			 * device, and still route correctly.
+			 */
+			if (!compare_ether_addr(eth_hdr(skb)->h_dest,
+							skb->dev->dev_addr))
+				skb->pkt_type = PACKET_HOST;
+			break;
+		};
+	}
 
 	return (polling ? netif_receive_skb(skb) : netif_rx(skb));
 }
---


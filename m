Return-Path: <linux-kernel-owner+w=401wt.eu-S1423064AbXEDXqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423064AbXEDXqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423001AbXEDXo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:44:26 -0400
Received: from 116.sub-75-210-58.myvzw.com ([75.210.58.116]:46310 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423064AbXEDXn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:43:29 -0400
Message-Id: <20070504232121.554055808@goop.org>
References: <20070504232051.411946839@goop.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 May 2007 16:21:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 26/29] xen: fix netfront checksums
Content-Disposition: inline; filename=xen-netfront-csum-fixes.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If we receive a partially checksummed packed, we need to work out how
much of it was checksummed based on its protocol.  The ideal would be
that Xen could tell us how much is checksummed, but in the meantime
we'll make do with this.

[ This is a separate patch for review; will be folded into
  xen-netfront later. ]

From: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/xen-netfront.c |   76 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 68 insertions(+), 8 deletions(-)

===================================================================
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -35,10 +35,12 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/ethtool.h>
-#include <linux/in.h>
 #include <linux/if_ether.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
 #include <linux/moduleparam.h>
 #include <linux/mm.h>
+#include <net/ip.h>
 
 #include <xen/xenbus.h>
 #include <xen/events.h>
@@ -564,8 +566,12 @@ static int xennet_start_xmit(struct sk_b
 	extra = NULL;
 
  	tx->flags = 0;
- 	if (skb->ip_summed == CHECKSUM_PARTIAL) /* local packet? */
+ 	if (skb->ip_summed == CHECKSUM_PARTIAL)
+ 		/* local packet? */
  		tx->flags |= NETTXF_csum_blank | NETTXF_data_validated;
+ 	else if (skb->ip_summed == CHECKSUM_UNNECESSARY)
+ 		/* remote but checksummed. */
+ 		tx->flags |= NETTXF_data_validated;
 
 	if (skb_shinfo(skb)->gso_size) {
 		struct xen_netif_extra_info *gso;
@@ -867,9 +873,50 @@ static RING_IDX xennet_fill_frags(struct
 	return cons;
 }
 
-static void handle_incoming_queue(struct net_device *dev,
+static int skb_checksum_setup(struct sk_buff *skb)
+{
+	struct iphdr *iph;
+	unsigned char *th;
+	int err = -EPROTO;
+
+	if (skb->protocol != htons(ETH_P_IP))
+		goto out;
+
+	iph = (void *)skb->data;
+	th = skb->data + 4 * iph->ihl;
+	if (th >= skb_tail_pointer(skb))
+		goto out;
+
+	skb->csum_start = th - skb->head;
+	switch (iph->protocol) {
+	case IPPROTO_TCP:
+		skb->csum_offset = offsetof(struct tcphdr, check);
+		break;
+	case IPPROTO_UDP:
+		skb->csum_offset = offsetof(struct udphdr, check);
+		break;
+	default:
+		if (net_ratelimit())
+			printk(KERN_ERR "Attempting to checksum a non-"
+			       "TCP/UDP packet, dropping a protocol"
+			       " %d packet", iph->protocol);
+		goto out;
+	}
+
+	if ((th + skb->csum_offset + 2) > skb_tail_pointer(skb))
+		goto out;
+
+	err = 0;
+
+out:
+	return err;
+}
+
+static int handle_incoming_queue(struct net_device *dev,
 				  struct sk_buff_head *rxq)
 {
+	struct netfront_info *np = netdev_priv(dev);
+	int packets_dropped = 0;
 	struct sk_buff *skb;
 
 	while ((skb = __skb_dequeue(rxq)) != NULL) {
@@ -886,10 +933,24 @@ static void handle_incoming_queue(struct
 		/* Ethernet work: Delayed to here as it peeks the header. */
 		skb->protocol = eth_type_trans(skb, dev);
 
+		if (skb->ip_summed == CHECKSUM_PARTIAL) {
+			if (skb_checksum_setup(skb)) {
+				kfree_skb(skb);
+				packets_dropped++;
+				np->stats.rx_errors++;
+				continue;
+			}
+		}
+
+		np->stats.rx_packets++;
+		np->stats.rx_bytes += skb->len;
+
 		/* Pass it up. */
 		netif_receive_skb(skb);
 		dev->last_rx = jiffies;
 	}
+
+	return packets_dropped;
 }
 
 static int xennet_poll(struct net_device *dev, int *pbudget)
@@ -1003,11 +1064,10 @@ err:
 		skb->truesize += skb->data_len - (RX_COPY_THRESHOLD - len);
 		skb->len += skb->data_len;
 
-		if (rx->flags & NETRXF_data_validated)
+		if (rx->flags & NETRXF_csum_blank)
+			skb->ip_summed = CHECKSUM_PARTIAL;
+		else if (rx->flags & NETRXF_data_validated)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
-
-		np->stats.rx_packets++;
-		np->stats.rx_bytes += skb->len;
 
 		__skb_queue_tail(&rxq, skb);
 
@@ -1029,7 +1089,7 @@ err:
 	while ((skb = __skb_dequeue(&errq)))
 		kfree_skb(skb);
 
-	handle_incoming_queue(dev, &rxq);
+	work_done -= handle_incoming_queue(dev, &rxq);
 
 	/* If we get a callback with very few responses, reduce fill target. */
 	/* NB. Note exponential increase, linear decrease. */

-- 


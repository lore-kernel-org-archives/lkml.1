Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbXEGBMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbXEGBMZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 21:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbXEGBMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 21:12:25 -0400
Received: from ozlabs.org ([203.10.76.45]:56263 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbXEGBMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 21:12:24 -0400
Subject: [PATCH 3/3] lguest: 2.6.21-mm1 update:
	lguest-net-stats-inline.patch
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <1178500252.7731.26.camel@localhost.localdomain>
References: <1178500168.7731.23.camel@localhost.localdomain>
	 <1178500252.7731.26.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 07 May 2007 11:12:10 +1000
Message-Id: <1178500330.7731.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now inline net_device_stats is upstream, we can use it in the lguest
net driver.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/net/lguest_net.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

===================================================================
--- a/drivers/net/lguest_net.c
+++ b/drivers/net/lguest_net.c
@@ -38,8 +38,6 @@ struct lguestnet_info
 	/* My peerid. */
 	unsigned int me;
 
-	struct net_device_stats stats;
-
 	/* Receive queue. */
 	struct sk_buff *skb[NUM_SKBS];
 	struct lguest_dma dma[NUM_SKBS];
@@ -120,13 +118,13 @@ static void transfer_packet(struct net_d
 
 	hcall(LHCALL_SEND_DMA, peer_key(info,peernum), __pa(&dma), 0);
 	if (dma.used_len != skb->len) {
-		info->stats.tx_carrier_errors++;
+		dev->stats.tx_carrier_errors++;
 		pr_debug("Bad xfer to peer %i: %i of %i (dma %p/%i)\n",
 			 peernum, dma.used_len, skb->len,
 			 (void *)dma.addr[0], dma.len[0]);
 	} else {
-		info->stats.tx_bytes += skb->len;
-		info->stats.tx_packets++;
+		dev->stats.tx_bytes += skb->len;
+		dev->stats.tx_packets++;
 	}
 }
 
@@ -212,8 +210,8 @@ static irqreturn_t lguestnet_rcv(int irq
 		pr_debug("Receiving skb proto 0x%04x len %i type %i\n",
 			 ntohs(skb->protocol), skb->len, skb->pkt_type);
 
-		info->stats.rx_bytes += skb->len;
-		info->stats.rx_packets++;
+		dev->stats.rx_bytes += skb->len;
+		dev->stats.rx_packets++;
 		netif_rx(skb);
 	}
 	return done ? IRQ_HANDLED : IRQ_NONE;
@@ -258,13 +256,6 @@ static int lguestnet_close(struct net_de
 	for (i = 0; i < ARRAY_SIZE(info->dma); i++)
 		dev_kfree_skb(info->skb[i]);
 	return 0;
-}
-
-static struct net_device_stats *lguestnet_get_stats(struct net_device *dev)
-{
-	struct lguestnet_info *info = dev->priv;
-
-	return &info->stats;
 }
 
 static int lguestnet_probe(struct lguest_device *lgdev)
@@ -295,7 +286,6 @@ static int lguestnet_probe(struct lguest
 	dev->open = lguestnet_open;
 	dev->stop = lguestnet_close;
 	dev->hard_start_xmit = lguestnet_start_xmit;
-	dev->get_stats = lguestnet_get_stats;
 
 	/* Turning on/off promisc will call dev->set_multicast_list.
 	 * We don't actually support multicast yet */



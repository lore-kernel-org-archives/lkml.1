Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbXJJBOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbXJJBOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 21:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbXJJBON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 21:14:13 -0400
Received: from gw.goop.org ([64.81.55.164]:47753 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbXJJBOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 21:14:12 -0400
Message-ID: <470C2737.60403@goop.org>
Date: Tue, 09 Oct 2007 18:13:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] xen-netfront: use net_device's stats structure
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

struct net_device has its own stats structure, so use that instead.
Also, we can use the default get_stats function.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/net/xen-netfront.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

===================================================================
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -72,8 +72,6 @@ struct netfront_info {
 	struct list_head list;
 	struct net_device *netdev;
 
-	struct net_device_stats stats;
-
 	struct xen_netif_tx_front_ring tx;
 	struct xen_netif_rx_front_ring rx;
 
@@ -339,8 +337,6 @@ static int xennet_open(struct net_device
 static int xennet_open(struct net_device *dev)
 {
 	struct netfront_info *np = netdev_priv(dev);
-
-	memset(&np->stats, 0, sizeof(np->stats));
 
 	spin_lock_bh(&np->rx_lock);
 	if (netif_carrier_ok(dev)) {
@@ -566,8 +562,8 @@ static int xennet_start_xmit(struct sk_b
 	if (notify)
 		notify_remote_via_irq(np->netdev->irq);
 
-	np->stats.tx_bytes += skb->len;
-	np->stats.tx_packets++;
+	np->netdev->stats.tx_bytes += skb->len;
+	np->netdev->stats.tx_packets++;
 
 	/* Note: It is not safe to access skb after xennet_tx_buf_gc()! */
 	xennet_tx_buf_gc(dev);
@@ -580,7 +576,7 @@ static int xennet_start_xmit(struct sk_b
 	return 0;
 
  drop:
-	np->stats.tx_dropped++;
+	np->netdev->stats.tx_dropped++;
 	dev_kfree_skb(skb);
 	return 0;
 }
@@ -590,12 +586,6 @@ static int xennet_close(struct net_devic
 	struct netfront_info *np = netdev_priv(dev);
 	netif_stop_queue(np->netdev);
 	return 0;
-}
-
-static struct net_device_stats *xennet_get_stats(struct net_device *dev)
-{
-	struct netfront_info *np = netdev_priv(dev);
-	return &np->stats;
 }
 
 static void xennet_move_rx_slot(struct netfront_info *np, struct sk_buff *skb,
@@ -856,13 +846,13 @@ static int handle_incoming_queue(struct 
 			if (skb_checksum_setup(skb)) {
 				kfree_skb(skb);
 				packets_dropped++;
-				np->stats.rx_errors++;
+				np->netdev->stats.rx_errors++;
 				continue;
 			}
 		}
 
-		np->stats.rx_packets++;
-		np->stats.rx_bytes += skb->len;
+		np->netdev->stats.rx_packets++;
+		np->netdev->stats.rx_bytes += skb->len;
 
 		/* Pass it up. */
 		netif_receive_skb(skb);
@@ -917,7 +907,7 @@ err:
 err:
 			while ((skb = __skb_dequeue(&tmpq)))
 				__skb_queue_tail(&errq, skb);
-			np->stats.rx_errors++;
+			np->netdev->stats.rx_errors++;
 			i = np->rx.rsp_cons;
 			continue;
 		}
@@ -1200,7 +1190,6 @@ static struct net_device * __devinit xen
 	netdev->open            = xennet_open;
 	netdev->hard_start_xmit = xennet_start_xmit;
 	netdev->stop            = xennet_close;
-	netdev->get_stats       = xennet_get_stats;
 	netdev->poll            = xennet_poll;
 	netdev->uninit          = xennet_uninit;
 	netdev->change_mtu	= xennet_change_mtu;


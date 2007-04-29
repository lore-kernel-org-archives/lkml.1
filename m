Return-Path: <linux-kernel-owner+w=401wt.eu-S1031002AbXD2RjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031002AbXD2RjF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbXD2Rb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:31:26 -0400
Received: from gw.goop.org ([64.81.55.164]:58978 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965052AbXD2Ra2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:30:28 -0400
Message-Id: <20070429172916.520838000@goop.org>
References: <20070429172835.284784000@goop.org>
User-Agent: quilt/0.46-1
Date: Sun, 29 Apr 2007 10:29:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: [patch 29/32] xen: Lockdep fixes for xen-netfront
Content-Disposition: inline; filename=xen-netfront-lockdep-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

netfront contains two locking problems found by lockdep:

1. rx_lock is a normal spinlock, and tx_lock is an irq spinlock.  This
   means that in normal use, tx_lock may be taken by an interrupt routine
   while rx_lock is held.  However, netif_disconnect_backend takes them
   in the order tx_lock->rx_lock, which could lead to a deadlock.  Reverse
   them
2. rx_lock can also be taken in softirq context, so it should be taken/released
   with spin_(un)lock_bh.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>

---
 drivers/net/xen-netfront.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

===================================================================
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -515,14 +515,14 @@ static int network_open(struct net_devic
 
 	memset(&np->stats, 0, sizeof(np->stats));
 
-	spin_lock(&np->rx_lock);
+	spin_lock_bh(&np->rx_lock);
 	if (netfront_carrier_ok(np)) {
 		network_alloc_rx_buffers(dev);
 		np->rx.sring->rsp_event = np->rx.rsp_cons + 1;
 		if (RING_HAS_UNCONSUMED_RESPONSES(&np->rx))
 			netif_rx_schedule(dev);
 	}
-	spin_unlock(&np->rx_lock);
+	spin_unlock_bh(&np->rx_lock);
 
 	network_maybe_wake_tx(dev);
 
@@ -1212,10 +1212,10 @@ static int netif_poll(struct net_device 
 	int pages_flipped = 0;
 	int err;
 
-	spin_lock(&np->rx_lock);
+	spin_lock_bh(&np->rx_lock);
 
 	if (unlikely(!netfront_carrier_ok(np))) {
-		spin_unlock(&np->rx_lock);
+		spin_unlock_bh(&np->rx_lock);
 		return 0;
 	}
 
@@ -1356,7 +1356,7 @@ err:
 		local_irq_restore(flags);
 	}
 
-	spin_unlock(&np->rx_lock);
+	spin_unlock_bh(&np->rx_lock);
 
 	return more_to_do;
 }
@@ -1399,7 +1399,7 @@ static void netif_release_rx_bufs(struct
 
 	skb_queue_head_init(&free_list);
 
-	spin_lock(&np->rx_lock);
+	spin_lock_bh(&np->rx_lock);
 
 	for (id = 0; id < NET_RX_RING_SIZE; id++) {
 		if ((ref = np->grant_rx_ref[id]) == GRANT_INVALID_REF) {
@@ -1469,7 +1469,7 @@ static void netif_release_rx_bufs(struct
 	while ((skb = __skb_dequeue(&free_list)) != NULL)
 		dev_kfree_skb(skb);
 
-	spin_unlock(&np->rx_lock);
+	spin_unlock_bh(&np->rx_lock);
 }
 
 static int network_close(struct net_device *dev)
@@ -1579,8 +1579,8 @@ static int network_connect(struct net_de
 	dev_info(&dev->dev, "has %sing receive path.\n",
 		 np->copying_receiver ? "copy" : "flipp");
 
+	spin_lock_bh(&np->rx_lock);
 	spin_lock_irq(&np->tx_lock);
-	spin_lock(&np->rx_lock);
 
 	/*
 	 * Recovery procedure:
@@ -1632,8 +1632,8 @@ static int network_connect(struct net_de
 	network_tx_buf_gc(dev);
 	network_alloc_rx_buffers(dev);
 
-	spin_unlock(&np->rx_lock);
 	spin_unlock_irq(&np->tx_lock);
+	spin_unlock_bh(&np->rx_lock);
 
 	return 0;
 }
@@ -1689,7 +1689,7 @@ static ssize_t store_rxbuf_min(struct de
 	if (target > RX_MAX_TARGET)
 		target = RX_MAX_TARGET;
 
-	spin_lock(&np->rx_lock);
+	spin_lock_bh(&np->rx_lock);
 	if (target > np->rx_max_target)
 		np->rx_max_target = target;
 	np->rx_min_target = target;
@@ -1698,7 +1698,7 @@ static ssize_t store_rxbuf_min(struct de
 
 	network_alloc_rx_buffers(netdev);
 
-	spin_unlock(&np->rx_lock);
+	spin_unlock_bh(&np->rx_lock);
 	return len;
 }
 
@@ -1732,7 +1732,7 @@ static ssize_t store_rxbuf_max(struct de
 	if (target > RX_MAX_TARGET)
 		target = RX_MAX_TARGET;
 
-	spin_lock(&np->rx_lock);
+	spin_lock_bh(&np->rx_lock);
 	if (target < np->rx_min_target)
 		np->rx_min_target = target;
 	np->rx_max_target = target;
@@ -1741,7 +1741,7 @@ static ssize_t store_rxbuf_max(struct de
 
 	network_alloc_rx_buffers(netdev);
 
-	spin_unlock(&np->rx_lock);
+	spin_unlock_bh(&np->rx_lock);
 	return len;
 }
 
@@ -1885,11 +1885,11 @@ static void netif_disconnect_backend(str
 static void netif_disconnect_backend(struct netfront_info *info)
 {
 	/* Stop old i/f to prevent errors whilst we rebuild the state. */
+	spin_lock_bh(&info->rx_lock);
 	spin_lock_irq(&info->tx_lock);
-	spin_lock(&info->rx_lock);
 	netfront_carrier_off(info);
-	spin_unlock(&info->rx_lock);
 	spin_unlock_irq(&info->tx_lock);
+	spin_unlock_bh(&info->rx_lock);
 
 	if (info->irq)
 		unbind_from_irqhandler(info->irq, info->netdev);

-- 


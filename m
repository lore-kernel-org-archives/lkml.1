Return-Path: <linux-kernel-owner+w=401wt.eu-S932555AbYGQTYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbYGQTYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932236AbYGQTWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:22:47 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:34835 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758959AbYGQTWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:43 -0400
Message-Id: <20080717191749.977933994@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:09 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-net@vger.kernel.org,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: [patch 02/29] ariadne: use netstats in net_device structure
Content-Disposition: inline; filename=m68k-ariadne-use-netstats-in-net_device-structure.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>

Use net_device_stats from net_device structure instead of local.

Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/ariadne.c |   47 ++++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

--- a/drivers/net/ariadne.c
+++ b/drivers/net/ariadne.c
@@ -98,7 +98,6 @@ struct ariadne_private {
     volatile u_short *rx_buff[RX_RING_SIZE];
     int cur_tx, cur_rx;			/* The next free ring entry */
     int dirty_tx;			/* The ring entries to be free()ed. */
-    struct net_device_stats stats;
     char tx_full;
 };
 
@@ -378,20 +377,19 @@ static void ariadne_init_ring(struct net
 
 static int ariadne_close(struct net_device *dev)
 {
-    struct ariadne_private *priv = netdev_priv(dev);
     volatile struct Am79C960 *lance = (struct Am79C960*)dev->base_addr;
 
     netif_stop_queue(dev);
 
     lance->RAP = CSR112;	/* Missed Frame Count */
-    priv->stats.rx_missed_errors = swapw(lance->RDP);
+    dev->stats.rx_missed_errors = swapw(lance->RDP);
     lance->RAP = CSR0;		/* PCnet-ISA Controller Status */
 
     if (ariadne_debug > 1) {
 	printk(KERN_DEBUG "%s: Shutting down ethercard, status was %2.2x.\n",
 	       dev->name, lance->RDP);
 	printk(KERN_DEBUG "%s: %lu packets missed\n", dev->name,
-	       priv->stats.rx_missed_errors);
+	       dev->stats.rx_missed_errors);
     }
 
     /* We stop the LANCE here -- it occasionally polls memory if we don't. */
@@ -502,16 +500,16 @@ static irqreturn_t ariadne_interrupt(int
 		if (status & TF_ERR) {
 		    /* There was an major error, log it. */
 		    int err_status = priv->tx_ring[entry]->TMD3;
-		    priv->stats.tx_errors++;
+		    dev->stats.tx_errors++;
 		    if (err_status & EF_RTRY)
-			priv->stats.tx_aborted_errors++;
+			dev->stats.tx_aborted_errors++;
 		    if (err_status & EF_LCAR)
-			priv->stats.tx_carrier_errors++;
+			dev->stats.tx_carrier_errors++;
 		    if (err_status & EF_LCOL)
-			priv->stats.tx_window_errors++;
+			dev->stats.tx_window_errors++;
 		    if (err_status & EF_UFLO) {
 			/* Ackk!  On FIFO errors the Tx unit is turned off! */
-			priv->stats.tx_fifo_errors++;
+			dev->stats.tx_fifo_errors++;
 			/* Remove this verbosity later! */
 			printk(KERN_ERR "%s: Tx FIFO error! Status %4.4x.\n",
 			       dev->name, csr0);
@@ -520,8 +518,8 @@ static irqreturn_t ariadne_interrupt(int
 		    }
 		} else {
 		    if (status & (TF_MORE|TF_ONE))
-			priv->stats.collisions++;
-		    priv->stats.tx_packets++;
+			dev->stats.collisions++;
+		    dev->stats.tx_packets++;
 		}
 		dirty_tx++;
 	    }
@@ -547,11 +545,11 @@ static irqreturn_t ariadne_interrupt(int
 	/* Log misc errors. */
 	if (csr0 & BABL) {
 	    handled = 1;
-	    priv->stats.tx_errors++;	/* Tx babble. */
+	    dev->stats.tx_errors++;	/* Tx babble. */
 	}
 	if (csr0 & MISS) {
 	    handled = 1;
-	    priv->stats.rx_errors++;	/* Missed a Rx frame. */
+	    dev->stats.rx_errors++;	/* Missed a Rx frame. */
 	}
 	if (csr0 & MERR) {
 	    handled = 1;
@@ -672,7 +670,7 @@ static int ariadne_start_xmit(struct sk_
 	priv->cur_tx -= TX_RING_SIZE;
 	priv->dirty_tx -= TX_RING_SIZE;
     }
-    priv->stats.tx_bytes += len;
+    dev->stats.tx_bytes += len;
 
     /* Trigger an immediate send poll. */
     lance->RAP = CSR0;		/* PCnet-ISA Controller Status */
@@ -707,15 +705,15 @@ static int ariadne_rx(struct net_device 
 		buffers, with only the last correctly noting the error. */
 	    if (status & RF_ENP)
 		/* Only count a general error at the end of a packet.*/
-		priv->stats.rx_errors++;
+		dev->stats.rx_errors++;
 	    if (status & RF_FRAM)
-		priv->stats.rx_frame_errors++;
+		dev->stats.rx_frame_errors++;
 	    if (status & RF_OFLO)
-		priv->stats.rx_over_errors++;
+		dev->stats.rx_over_errors++;
 	    if (status & RF_CRC)
-		priv->stats.rx_crc_errors++;
+		dev->stats.rx_crc_errors++;
 	    if (status & RF_BUFF)
-		priv->stats.rx_fifo_errors++;
+		dev->stats.rx_fifo_errors++;
 	    priv->rx_ring[entry]->RMD1 &= 0xff00|RF_STP|RF_ENP;
 	} else {
 	    /* Malloc up new buffer, compatible with net-3. */
@@ -731,7 +729,7 @@ static int ariadne_rx(struct net_device 
 			break;
 
 		if (i > RX_RING_SIZE-2) {
-		    priv->stats.rx_dropped++;
+		    dev->stats.rx_dropped++;
 		    priv->rx_ring[entry]->RMD1 |= RF_OWN;
 		    priv->cur_rx++;
 		}
@@ -764,8 +762,8 @@ static int ariadne_rx(struct net_device 
 
 	    netif_rx(skb);
 	    dev->last_rx = jiffies;
-	    priv->stats.rx_packets++;
-	    priv->stats.rx_bytes += pkt_len;
+	    dev->stats.rx_packets++;
+	    dev->stats.rx_bytes += pkt_len;
 	}
 
 	priv->rx_ring[entry]->RMD1 |= RF_OWN;
@@ -783,7 +781,6 @@ static int ariadne_rx(struct net_device 
 
 static struct net_device_stats *ariadne_get_stats(struct net_device *dev)
 {
-    struct ariadne_private *priv = netdev_priv(dev);
     volatile struct Am79C960 *lance = (struct Am79C960*)dev->base_addr;
     short saved_addr;
     unsigned long flags;
@@ -791,11 +788,11 @@ static struct net_device_stats *ariadne_
     local_irq_save(flags);
     saved_addr = lance->RAP;
     lance->RAP = CSR112;		/* Missed Frame Count */
-    priv->stats.rx_missed_errors = swapw(lance->RDP);
+    dev->stats.rx_missed_errors = swapw(lance->RDP);
     lance->RAP = saved_addr;
     local_irq_restore(flags);
 
-    return &priv->stats;
+    return &dev->stats;
 }
 
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds


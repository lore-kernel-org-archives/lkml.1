Return-Path: <linux-kernel-owner+w=401wt.eu-S1764279AbYF3V1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764279AbYF3V1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762068AbYF3V1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:27:03 -0400
Received: from khc.piap.pl ([195.187.100.11]:46396 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760799AbYF3V06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:26:58 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] WAN: convert drivers to use built-in netdev_stats
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 30 Jun 2008 23:26:53 +0200
Message-ID: <m3d4ly4ns2.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in using separate net_device_stats structs when
the one in struct net_device is present. Compiles.

Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 1dd0e99..fb2fb15 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -3886,9 +3886,8 @@ static bool rx_get_frame(MGSLPC_INFO *info)
 		framesize = 0;
 #if SYNCLINK_GENERIC_HDLC
 		{
-			struct net_device_stats *stats = hdlc_stats(info->netdev);
-			stats->rx_errors++;
-			stats->rx_frame_errors++;
+			info->netdev->stats.rx_errors++;
+			info->netdev->stats.rx_frame_errors++;
 		}
 #endif
 	} else
@@ -4144,7 +4143,6 @@ static int hdlcdev_attach(struct net_device *dev, unsigned short encoding,
 static int hdlcdev_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	MGSLPC_INFO *info = dev_to_port(dev);
-	struct net_device_stats *stats = hdlc_stats(dev);
 	unsigned long flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
@@ -4159,8 +4157,8 @@ static int hdlcdev_xmit(struct sk_buff *skb, struct net_device *dev)
 	info->tx_put = info->tx_count = skb->len;
 
 	/* update network statistics */
-	stats->tx_packets++;
-	stats->tx_bytes += skb->len;
+	dev->stats.tx_packets++;
+	dev->stats.tx_bytes += skb->len;
 
 	/* done with socket buffer, so free it */
 	dev_kfree_skb(skb);
@@ -4376,14 +4374,13 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 static void hdlcdev_tx_timeout(struct net_device *dev)
 {
 	MGSLPC_INFO *info = dev_to_port(dev);
-	struct net_device_stats *stats = hdlc_stats(dev);
 	unsigned long flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("hdlcdev_tx_timeout(%s)\n",dev->name);
 
-	stats->tx_errors++;
-	stats->tx_aborted_errors++;
+	dev->stats.tx_errors++;
+	dev->stats.tx_aborted_errors++;
 
 	spin_lock_irqsave(&info->lock,flags);
 	tx_stop(info);
@@ -4416,27 +4413,26 @@ static void hdlcdev_rx(MGSLPC_INFO *info, char *buf, int size)
 {
 	struct sk_buff *skb = dev_alloc_skb(size);
 	struct net_device *dev = info->netdev;
-	struct net_device_stats *stats = hdlc_stats(dev);
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("hdlcdev_rx(%s)\n",dev->name);
 
 	if (skb == NULL) {
 		printk(KERN_NOTICE "%s: can't alloc skb, dropping packet\n", dev->name);
-		stats->rx_dropped++;
+		dev->stats.rx_dropped++;
 		return;
 	}
 
-	memcpy(skb_put(skb, size),buf,size);
+	memcpy(skb_put(skb, size), buf, size);
 
-	skb->protocol = hdlc_type_trans(skb, info->netdev);
+	skb->protocol = hdlc_type_trans(skb, dev);
 
-	stats->rx_packets++;
-	stats->rx_bytes += size;
+	dev->stats.rx_packets++;
+	dev->stats.rx_bytes += size;
 
 	netif_rx(skb);
 
-	info->netdev->last_rx = jiffies;
+	dev->last_rx = jiffies;
 }
 
 /**
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index ac5080d..9d247d8 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -6640,9 +6640,8 @@ static bool mgsl_get_rx_frame(struct mgsl_struct *info)
 		framesize = 0;
 #if SYNCLINK_GENERIC_HDLC
 		{
-			struct net_device_stats *stats = hdlc_stats(info->netdev);
-			stats->rx_errors++;
-			stats->rx_frame_errors++;
+			info->netdev->stats.rx_errors++;
+			info->netdev->stats.rx_frame_errors++;
 		}
 #endif
 	} else
@@ -7753,7 +7752,6 @@ static int hdlcdev_attach(struct net_device *dev, unsigned short encoding,
 static int hdlcdev_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct mgsl_struct *info = dev_to_port(dev);
-	struct net_device_stats *stats = hdlc_stats(dev);
 	unsigned long flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
@@ -7767,8 +7765,8 @@ static int hdlcdev_xmit(struct sk_buff *skb, struct net_device *dev)
 	mgsl_load_tx_dma_buffer(info, skb->data, skb->len);
 
 	/* update network statistics */
-	stats->tx_packets++;
-	stats->tx_bytes += skb->len;
+	dev->stats.tx_packets++;
+	dev->stats.tx_bytes += skb->len;
 
 	/* done with socket buffer, so free it */
 	dev_kfree_skb(skb);
@@ -7984,14 +7982,13 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 static void hdlcdev_tx_timeout(struct net_device *dev)
 {
 	struct mgsl_struct *info = dev_to_port(dev);
-	struct net_device_stats *stats = hdlc_stats(dev);
 	unsigned long flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("hdlcdev_tx_timeout(%s)\n",dev->name);
 
-	stats->tx_errors++;
-	stats->tx_aborted_errors++;
+	dev->stats.tx_errors++;
+	dev->stats.tx_aborted_errors++;
 
 	spin_lock_irqsave(&info->irq_spinlock,flags);
 	usc_stop_transmitter(info);
@@ -8024,27 +8021,27 @@ static void hdlcdev_rx(struct mgsl_struct *info, char *buf, int size)
 {
 	struct sk_buff *skb = dev_alloc_skb(size);
 	struct net_device *dev = info->netdev;
-	struct net_device_stats *stats = hdlc_stats(dev);
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk("hdlcdev_rx(%s)\n",dev->name);
+		printk("hdlcdev_rx(%s)\n", dev->name);
 
 	if (skb == NULL) {
-		printk(KERN_NOTICE "%s: can't alloc skb, dropping packet\n", dev->name);
-		stats->rx_dropped++;
+		printk(KERN_NOTICE "%s: can't alloc skb, dropping packet\n",
+		       dev->name);
+		dev->stats.rx_dropped++;
 		return;
 	}
 
-	memcpy(skb_put(skb, size),buf,size);
+	memcpy(skb_put(skb, size), buf, size);
 
-	skb->protocol = hdlc_type_trans(skb, info->netdev);
+	skb->protocol = hdlc_type_trans(skb, dev);
 
-	stats->rx_packets++;
-	stats->rx_bytes += size;
+	dev->stats.rx_packets++;
+	dev->stats.rx_bytes += size;
 
 	netif_rx(skb);
 
-	info->netdev->last_rx = jiffies;
+	dev->last_rx = jiffies;
 }
 
 /**
diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index 55c1653..d88a607 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -1544,7 +1544,6 @@ static int hdlcdev_attach(struct net_device *dev, unsigned short encoding,
 static int hdlcdev_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct slgt_info *info = dev_to_port(dev);
-	struct net_device_stats *stats = hdlc_stats(dev);
 	unsigned long flags;
 
 	DBGINFO(("%s hdlc_xmit\n", dev->name));
@@ -1557,8 +1556,8 @@ static int hdlcdev_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx_load(info, skb->data, skb->len);
 
 	/* update network statistics */
-	stats->tx_packets++;
-	stats->tx_bytes += skb->len;
+	dev->stats.tx_packets++;
+	dev->stats.tx_bytes += skb->len;
 
 	/* done with socket buffer, so free it */
 	dev_kfree_skb(skb);
@@ -1775,13 +1774,12 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 static void hdlcdev_tx_timeout(struct net_device *dev)
 {
 	struct slgt_info *info = dev_to_port(dev);
-	struct net_device_stats *stats = hdlc_stats(dev);
 	unsigned long flags;
 
 	DBGINFO(("%s hdlcdev_tx_timeout\n", dev->name));
 
-	stats->tx_errors++;
-	stats->tx_aborted_errors++;
+	dev->stats.tx_errors++;
+	dev->stats.tx_aborted_errors++;
 
 	spin_lock_irqsave(&info->lock,flags);
 	tx_stop(info);
@@ -1814,26 +1812,25 @@ static void hdlcdev_rx(struct slgt_info *info, char *buf, int size)
 {
 	struct sk_buff *skb = dev_alloc_skb(size);
 	struct net_device *dev = info->netdev;
-	struct net_device_stats *stats = hdlc_stats(dev);
 
 	DBGINFO(("%s hdlcdev_rx\n", dev->name));
 
 	if (skb == NULL) {
 		DBGERR(("%s: can't alloc skb, drop packet\n", dev->name));
-		stats->rx_dropped++;
+		dev->stats.rx_dropped++;
 		return;
 	}
 
-	memcpy(skb_put(skb, size),buf,size);
+	memcpy(skb_put(skb, size), buf, size);
 
-	skb->protocol = hdlc_type_trans(skb, info->netdev);
+	skb->protocol = hdlc_type_trans(skb, dev);
 
-	stats->rx_packets++;
-	stats->rx_bytes += size;
+	dev->stats.rx_packets++;
+	dev->stats.rx_bytes += size;
 
 	netif_rx(skb);
 
-	info->netdev->last_rx = jiffies;
+	dev->last_rx = jiffies;
 }
 
 /**
@@ -4577,9 +4574,8 @@ check_again:
 
 #if SYNCLINK_GENERIC_HDLC
 	if (framesize == 0) {
-		struct net_device_stats *stats = hdlc_stats(info->netdev);
-		stats->rx_errors++;
-		stats->rx_frame_errors++;
+		info->netdev->stats.rx_errors++;
+		info->netdev->stats.rx_frame_errors++;
 	}
 #endif
 
diff --git a/drivers/char/synclinkmp.c b/drivers/char/synclinkmp.c
index bec5486..10241ed 100644
--- a/drivers/char/synclinkmp.c
+++ b/drivers/char/synclinkmp.c
@@ -1678,7 +1678,6 @@ static int hdlcdev_attach(struct net_device *dev, unsigned short encoding,
 static int hdlcdev_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	SLMP_INFO *info = dev_to_port(dev);
-	struct net_device_stats *stats = hdlc_stats(dev);
 	unsigned long flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
@@ -1692,8 +1691,8 @@ static int hdlcdev_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx_load_dma_buffer(info, skb->data, skb->len);
 
 	/* update network statistics */
-	stats->tx_packets++;
-	stats->tx_bytes += skb->len;
+	dev->stats.tx_packets++;
+	dev->stats.tx_bytes += skb->len;
 
 	/* done with socket buffer, so free it */
 	dev_kfree_skb(skb);
@@ -1909,14 +1908,13 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 static void hdlcdev_tx_timeout(struct net_device *dev)
 {
 	SLMP_INFO *info = dev_to_port(dev);
-	struct net_device_stats *stats = hdlc_stats(dev);
 	unsigned long flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("hdlcdev_tx_timeout(%s)\n",dev->name);
 
-	stats->tx_errors++;
-	stats->tx_aborted_errors++;
+	dev->stats.tx_errors++;
+	dev->stats.tx_aborted_errors++;
 
 	spin_lock_irqsave(&info->lock,flags);
 	tx_stop(info);
@@ -1949,27 +1947,27 @@ static void hdlcdev_rx(SLMP_INFO *info, char *buf, int size)
 {
 	struct sk_buff *skb = dev_alloc_skb(size);
 	struct net_device *dev = info->netdev;
-	struct net_device_stats *stats = hdlc_stats(dev);
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("hdlcdev_rx(%s)\n",dev->name);
 
 	if (skb == NULL) {
-		printk(KERN_NOTICE "%s: can't alloc skb, dropping packet\n", dev->name);
-		stats->rx_dropped++;
+		printk(KERN_NOTICE "%s: can't alloc skb, dropping packet\n",
+		       dev->name);
+		dev->stats.rx_dropped++;
 		return;
 	}
 
-	memcpy(skb_put(skb, size),buf,size);
+	memcpy(skb_put(skb, size), buf, size);
 
-	skb->protocol = hdlc_type_trans(skb, info->netdev);
+	skb->protocol = hdlc_type_trans(skb, dev);
 
-	stats->rx_packets++;
-	stats->rx_bytes += size;
+	dev->stats.rx_packets++;
+	dev->stats.rx_bytes += size;
 
 	netif_rx(skb);
 
-	info->netdev->last_rx = jiffies;
+	dev->last_rx = jiffies;
 }
 
 /**
@@ -4983,9 +4981,8 @@ CheckAgain:
 		framesize = 0;
 #if SYNCLINK_GENERIC_HDLC
 		{
-			struct net_device_stats *stats = hdlc_stats(info->netdev);
-			stats->rx_errors++;
-			stats->rx_frame_errors++;
+			info->netdev->stats.rx_errors++;
+			info->netdev->stats.rx_frame_errors++;
 		}
 #endif
 	}
diff --git a/drivers/net/wan/c101.c b/drivers/net/wan/c101.c
index c2cc42f..c8e5631 100644
--- a/drivers/net/wan/c101.c
+++ b/drivers/net/wan/c101.c
@@ -133,9 +133,9 @@ static void sca_msci_intr(port_t *port)
 	sca_out(stat & (ST1_UDRN | ST1_CDCD), MSCI0_OFFSET + ST1, port);
 
 	if (stat & ST1_UDRN) {
-		struct net_device_stats *stats = hdlc_stats(port_to_dev(port));
-		stats->tx_errors++; /* TX Underrun error detected */
-		stats->tx_fifo_errors++;
+		/* TX Underrun error detected */
+		port_to_dev(port)->stats.tx_errors++;
+		port_to_dev(port)->stats.tx_fifo_errors++;
 	}
 
 	stat = sca_in(MSCI1_OFFSET + ST1, port); /* read MSCI1 ST1 status */
diff --git a/drivers/net/wan/dscc4.c b/drivers/net/wan/dscc4.c
index c6f26e2..50ef5b4 100644
--- a/drivers/net/wan/dscc4.c
+++ b/drivers/net/wan/dscc4.c
@@ -642,7 +642,6 @@ static inline void dscc4_rx_skb(struct dscc4_dev_priv *dpriv,
 				struct net_device *dev)
 {
 	struct RxFD *rx_fd = dpriv->rx_fd + dpriv->rx_current%RX_RING_SIZE;
-	struct net_device_stats *stats = hdlc_stats(dev);
 	struct pci_dev *pdev = dpriv->pci_priv->pdev;
 	struct sk_buff *skb;
 	int pkt_len;
@@ -656,8 +655,8 @@ static inline void dscc4_rx_skb(struct dscc4_dev_priv *dpriv,
 	pci_unmap_single(pdev, le32_to_cpu(rx_fd->data),
 			 RX_MAX(HDLC_MAX_MRU), PCI_DMA_FROMDEVICE);
 	if ((skb->data[--pkt_len] & FrameOk) == FrameOk) {
-		stats->rx_packets++;
-		stats->rx_bytes += pkt_len;
+		dev->stats.rx_packets++;
+		dev->stats.rx_bytes += pkt_len;
 		skb_put(skb, pkt_len);
 		if (netif_running(dev))
 			skb->protocol = hdlc_type_trans(skb, dev);
@@ -665,13 +664,13 @@ static inline void dscc4_rx_skb(struct dscc4_dev_priv *dpriv,
 		netif_rx(skb);
 	} else {
 		if (skb->data[pkt_len] & FrameRdo)
-			stats->rx_fifo_errors++;
+			dev->stats.rx_fifo_errors++;
 		else if (!(skb->data[pkt_len] | ~FrameCrc))
-			stats->rx_crc_errors++;
+			dev->stats.rx_crc_errors++;
 		else if (!(skb->data[pkt_len] | ~(FrameVfr | FrameRab)))
-			stats->rx_length_errors++;
+			dev->stats.rx_length_errors++;
 		else
-			stats->rx_errors++;
+			dev->stats.rx_errors++;
 		dev_kfree_skb_irq(skb);
 	}
 refill:
@@ -1569,7 +1568,6 @@ try:
 
 	if (state & SccEvt) {
 		if (state & Alls) {
-			struct net_device_stats *stats = hdlc_stats(dev);
 			struct sk_buff *skb;
 			struct TxFD *tx_fd;
 
@@ -1586,8 +1584,8 @@ try:
 				pci_unmap_single(ppriv->pdev, le32_to_cpu(tx_fd->data),
 						 skb->len, PCI_DMA_TODEVICE);
 				if (tx_fd->state & FrameEnd) {
-					stats->tx_packets++;
-					stats->tx_bytes += skb->len;
+					dev->stats.tx_packets++;
+					dev->stats.tx_bytes += skb->len;
 				}
 				dev_kfree_skb_irq(skb);
 				dpriv->tx_skbuff[cur] = NULL;
@@ -1698,7 +1696,7 @@ try:
 		}
 		if (state & Err) {
 			printk(KERN_INFO "%s: Tx ERR\n", dev->name);
-			hdlc_stats(dev)->tx_errors++;
+			dev->stats.tx_errors++;
 			state &= ~Err;
 		}
 	}
@@ -1834,7 +1832,7 @@ try:
 				if (!(rx_fd->state2 & DataComplete))
 					break;
 				if (rx_fd->state2 & FrameAborted) {
-					hdlc_stats(dev)->rx_over_errors++;
+					dev->stats.rx_over_errors++;
 					rx_fd->state1 |= Hold;
 					rx_fd->state2 = 0x00000000;
 					rx_fd->end = cpu_to_le32(0xbabeface);
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index 547368e..754f008 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -845,7 +845,6 @@ fst_tx_dma_complete(struct fst_card_info *card, struct fst_port_info *port,
 		    int len, int txpos)
 {
 	struct net_device *dev = port_to_dev(port);
-	struct net_device_stats *stats = hdlc_stats(dev);
 
 	/*
 	 * Everything is now set, just tell the card to go
@@ -853,8 +852,8 @@ fst_tx_dma_complete(struct fst_card_info *card, struct fst_port_info *port,
 	dbg(DBG_TX, "fst_tx_dma_complete\n");
 	FST_WRB(card, txDescrRing[port->index][txpos].bits,
 		DMA_OWN | TX_STP | TX_ENP);
-	stats->tx_packets++;
-	stats->tx_bytes += len;
+	dev->stats.tx_packets++;
+	dev->stats.tx_bytes += len;
 	dev->trans_start = jiffies;
 }
 
@@ -876,7 +875,6 @@ fst_rx_dma_complete(struct fst_card_info *card, struct fst_port_info *port,
 		    int len, struct sk_buff *skb, int rxp)
 {
 	struct net_device *dev = port_to_dev(port);
-	struct net_device_stats *stats = hdlc_stats(dev);
 	int pi;
 	int rx_status;
 
@@ -888,8 +886,8 @@ fst_rx_dma_complete(struct fst_card_info *card, struct fst_port_info *port,
 	FST_WRB(card, rxDescrRing[pi][rxp].bits, DMA_OWN);
 
 	/* Update stats */
-	stats->rx_packets++;
-	stats->rx_bytes += len;
+	dev->stats.rx_packets++;
+	dev->stats.rx_bytes += len;
 
 	/* Push upstream */
 	dbg(DBG_RX, "Pushing the frame up the stack\n");
@@ -900,7 +898,7 @@ fst_rx_dma_complete(struct fst_card_info *card, struct fst_port_info *port,
 	rx_status = netif_rx(skb);
 	fst_process_rx_status(rx_status, port_to_dev(port)->name);
 	if (rx_status == NET_RX_DROP)
-		stats->rx_dropped++;
+		dev->stats.rx_dropped++;
 	dev->last_rx = jiffies;
 }
 
@@ -1163,29 +1161,28 @@ fst_log_rx_error(struct fst_card_info *card, struct fst_port_info *port,
 		 unsigned char dmabits, int rxp, unsigned short len)
 {
 	struct net_device *dev = port_to_dev(port);
-	struct net_device_stats *stats = hdlc_stats(dev);
 
-	/* 
+	/*
 	 * Increment the appropriate error counter
 	 */
-	stats->rx_errors++;
+	dev->stats.rx_errors++;
 	if (dmabits & RX_OFLO) {
-		stats->rx_fifo_errors++;
+		dev->stats.rx_fifo_errors++;
 		dbg(DBG_ASS, "Rx fifo error on card %d port %d buffer %d\n",
 		    card->card_no, port->index, rxp);
 	}
 	if (dmabits & RX_CRC) {
-		stats->rx_crc_errors++;
+		dev->stats.rx_crc_errors++;
 		dbg(DBG_ASS, "Rx crc error on card %d port %d\n",
 		    card->card_no, port->index);
 	}
 	if (dmabits & RX_FRAM) {
-		stats->rx_frame_errors++;
+		dev->stats.rx_frame_errors++;
 		dbg(DBG_ASS, "Rx frame error on card %d port %d\n",
 		    card->card_no, port->index);
 	}
 	if (dmabits == (RX_STP | RX_ENP)) {
-		stats->rx_length_errors++;
+		dev->stats.rx_length_errors++;
 		dbg(DBG_ASS, "Rx length error (%d) on card %d port %d\n",
 		    len, card->card_no, port->index);
 	}
@@ -1242,7 +1239,6 @@ fst_intr_rx(struct fst_card_info *card, struct fst_port_info *port)
 	unsigned short len;
 	struct sk_buff *skb;
 	struct net_device *dev = port_to_dev(port);
-	struct net_device_stats *stats = hdlc_stats(dev);
 
 	/* Check we have a buffer to process */
 	pi = port->index;
@@ -1291,7 +1287,7 @@ fst_intr_rx(struct fst_card_info *card, struct fst_port_info *port)
 	if ((skb = dev_alloc_skb(len)) == NULL) {
 		dbg(DBG_RX, "intr_rx: can't allocate buffer\n");
 
-		stats->rx_dropped++;
+		dev->stats.rx_dropped++;
 
 		/* Return descriptor to card */
 		FST_WRB(card, rxDescrRing[pi][rxp].bits, DMA_OWN);
@@ -1316,8 +1312,8 @@ fst_intr_rx(struct fst_card_info *card, struct fst_port_info *port)
 		FST_WRB(card, rxDescrRing[pi][rxp].bits, DMA_OWN);
 
 		/* Update stats */
-		stats->rx_packets++;
-		stats->rx_bytes += len;
+		dev->stats.rx_packets++;
+		dev->stats.rx_bytes += len;
 
 		/* Push upstream */
 		dbg(DBG_RX, "Pushing frame up the stack\n");
@@ -1327,9 +1323,8 @@ fst_intr_rx(struct fst_card_info *card, struct fst_port_info *port)
 			skb->protocol = hdlc_type_trans(skb, dev);
 		rx_status = netif_rx(skb);
 		fst_process_rx_status(rx_status, port_to_dev(port)->name);
-		if (rx_status == NET_RX_DROP) {
-			stats->rx_dropped++;
-		}
+		if (rx_status == NET_RX_DROP)
+			dev->stats.rx_dropped++;
 		dev->last_rx = jiffies;
 	} else {
 		card->dma_skb_rx = skb;
@@ -1361,7 +1356,6 @@ do_bottom_half_tx(struct fst_card_info *card)
 	struct sk_buff *skb;
 	unsigned long flags;
 	struct net_device *dev;
-	struct net_device_stats *stats;
 
 	/*
 	 *  Find a free buffer for the transmit
@@ -1373,12 +1367,10 @@ do_bottom_half_tx(struct fst_card_info *card)
 		if (!port->run)
 			continue;
 
-                dev = port_to_dev(port);
-                stats = hdlc_stats(dev);
-		while (!
-		       (FST_RDB(card, txDescrRing[pi][port->txpos].bits) &
-			DMA_OWN)
-                       && !(card->dmatx_in_progress)) {
+		dev = port_to_dev(port);
+		while (!(FST_RDB(card, txDescrRing[pi][port->txpos].bits) &
+			 DMA_OWN)
+		       && !(card->dmatx_in_progress)) {
 			/*
 			 * There doesn't seem to be a txdone event per-se
 			 * We seem to have to deduce it, by checking the DMA_OWN
@@ -1422,8 +1414,8 @@ do_bottom_half_tx(struct fst_card_info *card)
 						txDescrRing[pi][port->txpos].
 						bits,
 						DMA_OWN | TX_STP | TX_ENP);
-					stats->tx_packets++;
-					stats->tx_bytes += skb->len;
+					dev->stats.tx_packets++;
+					dev->stats.tx_bytes += skb->len;
 					dev->trans_start = jiffies;
 				} else {
 					/* Or do it through dma */
@@ -1628,8 +1620,8 @@ fst_intr(int dummy, void *dev_id)
 			 * always load up the entire packet for DMA.
 			 */
 			dbg(DBG_TX, "Tx underflow port %d\n", port->index);
-                        hdlc_stats(port_to_dev(port))->tx_errors++;
-                        hdlc_stats(port_to_dev(port))->tx_fifo_errors++;
+			port_to_dev(port)->stats.tx_errors++;
+			port_to_dev(port)->stats.tx_fifo_errors++;
 			dbg(DBG_ASS, "Tx underflow on card %d port %d\n",
 			    card->card_no, port->index);
 			break;
@@ -2292,12 +2284,11 @@ fst_tx_timeout(struct net_device *dev)
 {
 	struct fst_port_info *port;
 	struct fst_card_info *card;
-	struct net_device_stats *stats = hdlc_stats(dev);
 
 	port = dev_to_port(dev);
 	card = port->card;
-	stats->tx_errors++;
-	stats->tx_aborted_errors++;
+	dev->stats.tx_errors++;
+	dev->stats.tx_aborted_errors++;
 	dbg(DBG_ASS, "Tx timeout card %d port %d\n",
 	    card->card_no, port->index);
 	fst_issue_cmd(port, ABORTTX);
@@ -2312,7 +2303,6 @@ fst_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct fst_card_info *card;
 	struct fst_port_info *port;
-	struct net_device_stats *stats = hdlc_stats(dev);
 	unsigned long flags;
 	int txq_length;
 
@@ -2323,8 +2313,8 @@ fst_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* Drop packet with error if we don't have carrier */
 	if (!netif_carrier_ok(dev)) {
 		dev_kfree_skb(skb);
-		stats->tx_errors++;
-		stats->tx_carrier_errors++;
+		dev->stats.tx_errors++;
+		dev->stats.tx_carrier_errors++;
 		dbg(DBG_ASS,
 		    "Tried to transmit but no carrier on card %d port %d\n",
 		    card->card_no, port->index);
@@ -2336,7 +2326,7 @@ fst_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		dbg(DBG_ASS, "Packet too large %d vs %d\n", skb->len,
 		    LEN_TX_BUFFER);
 		dev_kfree_skb(skb);
-		stats->tx_errors++;
+		dev->stats.tx_errors++;
 		return 0;
 	}
 
@@ -2368,7 +2358,7 @@ fst_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		 * This shouldn't have happened but such is life
 		 */
 		dev_kfree_skb(skb);
-		stats->tx_errors++;
+		dev->stats.tx_errors++;
 		dbg(DBG_ASS, "Tx queue overflow card %d port %d\n",
 		    card->card_no, port->index);
 		return 0;
diff --git a/drivers/net/wan/hd6457x.c b/drivers/net/wan/hd6457x.c
index 8d0a1f2..591fb45 100644
--- a/drivers/net/wan/hd6457x.c
+++ b/drivers/net/wan/hd6457x.c
@@ -271,9 +271,9 @@ static inline void sca_msci_intr(port_t *port)
 	sca_out(stat & (ST1_UDRN | ST1_CDCD), msci + ST1, card);
 
 	if (stat & ST1_UDRN) {
-		struct net_device_stats *stats = hdlc_stats(port_to_dev(port));
-		stats->tx_errors++; /* TX Underrun error detected */
-		stats->tx_fifo_errors++;
+		/* TX Underrun error detected */
+		port_to_dev(port)->stats.tx_errors++;
+		port_to_dev(port)->stats.tx_fifo_errors++;
 	}
 
 	if (stat & ST1_CDCD)
@@ -286,7 +286,6 @@ static inline void sca_msci_intr(port_t *port)
 static inline void sca_rx(card_t *card, port_t *port, pkt_desc __iomem *desc, u16 rxin)
 {
 	struct net_device *dev = port_to_dev(port);
-	struct net_device_stats *stats = hdlc_stats(dev);
 	struct sk_buff *skb;
 	u16 len;
 	u32 buff;
@@ -298,7 +297,7 @@ static inline void sca_rx(card_t *card, port_t *port, pkt_desc __iomem *desc, u1
 	len = readw(&desc->len);
 	skb = dev_alloc_skb(len);
 	if (!skb) {
-		stats->rx_dropped++;
+		dev->stats.rx_dropped++;
 		return;
 	}
 
@@ -327,8 +326,8 @@ static inline void sca_rx(card_t *card, port_t *port, pkt_desc __iomem *desc, u1
 	printk(KERN_DEBUG "%s RX(%i):", dev->name, skb->len);
 	debug_frame(skb);
 #endif
-	stats->rx_packets++;
-	stats->rx_bytes += skb->len;
+	dev->stats.rx_packets++;
+	dev->stats.rx_bytes += skb->len;
 	dev->last_rx = jiffies;
 	skb->protocol = hdlc_type_trans(skb, dev);
 	netif_rx(skb);
@@ -339,17 +338,18 @@ static inline void sca_rx(card_t *card, port_t *port, pkt_desc __iomem *desc, u1
 /* Receive DMA interrupt service */
 static inline void sca_rx_intr(port_t *port)
 {
+	struct net_device *dev = port_to_dev(port);
 	u16 dmac = get_dmac_rx(port);
 	card_t *card = port_to_card(port);
 	u8 stat = sca_in(DSR_RX(phy_node(port)), card); /* read DMA Status */
-	struct net_device_stats *stats = hdlc_stats(port_to_dev(port));
 
 	/* Reset DSR status bits */
 	sca_out((stat & (DSR_EOT | DSR_EOM | DSR_BOF | DSR_COF)) | DSR_DWE,
 		DSR_RX(phy_node(port)), card);
 
 	if (stat & DSR_BOF)
-		stats->rx_over_errors++; /* Dropped one or more frames */
+		/* Dropped one or more frames */
+		dev->stats.rx_over_errors++;
 
 	while (1) {
 		u32 desc_off = desc_offset(port, port->rxin, 0);
@@ -364,12 +364,14 @@ static inline void sca_rx_intr(port_t *port)
 		if (!(stat & ST_RX_EOM))
 			port->rxpart = 1; /* partial frame received */
 		else if ((stat & ST_ERROR_MASK) || port->rxpart) {
-			stats->rx_errors++;
-			if (stat & ST_RX_OVERRUN) stats->rx_fifo_errors++;
+			dev->stats.rx_errors++;
+			if (stat & ST_RX_OVERRUN)
+				dev->stats.rx_fifo_errors++;
 			else if ((stat & (ST_RX_SHORT | ST_RX_ABORT |
 					  ST_RX_RESBIT)) || port->rxpart)
-				stats->rx_frame_errors++;
-			else if (stat & ST_RX_CRC) stats->rx_crc_errors++;
+				dev->stats.rx_frame_errors++;
+			else if (stat & ST_RX_CRC)
+				dev->stats.rx_crc_errors++;
 			if (stat & ST_RX_EOM)
 				port->rxpart = 0; /* received last fragment */
 		} else
@@ -390,7 +392,6 @@ static inline void sca_rx_intr(port_t *port)
 static inline void sca_tx_intr(port_t *port)
 {
 	struct net_device *dev = port_to_dev(port);
-	struct net_device_stats *stats = hdlc_stats(dev);
 	u16 dmac = get_dmac_tx(port);
 	card_t* card = port_to_card(port);
 	u8 stat;
@@ -412,8 +413,8 @@ static inline void sca_tx_intr(port_t *port)
 			break;	/* Transmitter is/will_be sending this frame */
 
 		desc = desc_address(port, port->txlast, 1);
-		stats->tx_packets++;
-		stats->tx_bytes += readw(&desc->len);
+		dev->stats.tx_packets++;
+		dev->stats.tx_bytes += readw(&desc->len);
 		writeb(0, &desc->stat);	/* Free descriptor */
 		port->txlast = next_desc(port, port->txlast, 1);
 	}
diff --git a/drivers/net/wan/hdlc.c b/drivers/net/wan/hdlc.c
index 7f98489..e3a5364 100644
--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -57,7 +57,7 @@ static int hdlc_change_mtu(struct net_device *dev, int new_mtu)
 
 static struct net_device_stats *hdlc_get_stats(struct net_device *dev)
 {
-	return hdlc_stats(dev);
+	return &dev->stats;
 }
 
 
diff --git a/drivers/net/wan/hdlc_cisco.c b/drivers/net/wan/hdlc_cisco.c
index 762d21c..849819c 100644
--- a/drivers/net/wan/hdlc_cisco.c
+++ b/drivers/net/wan/hdlc_cisco.c
@@ -252,8 +252,8 @@ static int cisco_rx(struct sk_buff *skb)
 	dev_kfree_skb_any(skb);
 	return NET_RX_DROP;
 
- rx_error:
-	dev_to_hdlc(dev)->stats.rx_errors++; /* Mark error */
+rx_error:
+	dev->stats.rx_errors++; /* Mark error */
 	dev_kfree_skb_any(skb);
 	return NET_RX_DROP;
 }
diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 520bb0b..cb1b415 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -136,7 +136,6 @@ typedef struct pvc_device_struct {
 }pvc_device;
 
 struct pvc_desc {
-	struct net_device_stats stats;
 	pvc_device *pvc;
 };
 
@@ -184,11 +183,6 @@ static inline struct pvc_desc* pvcdev_to_desc(struct net_device *dev)
 	return dev->priv;
 }
 
-static inline struct net_device_stats* pvc_get_stats(struct net_device *dev)
-{
-	return &pvcdev_to_desc(dev)->stats;
-}
-
 static inline pvc_device* find_pvc(hdlc_device *hdlc, u16 dlci)
 {
 	pvc_device *pvc = state(hdlc)->first_pvc;
@@ -425,7 +419,6 @@ static int pvc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 static int pvc_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	pvc_device *pvc = pvcdev_to_desc(dev)->pvc;
-	struct net_device_stats *stats = pvc_get_stats(dev);
 
 	if (pvc->state.active) {
 		if (dev->type == ARPHRD_ETHER) {
@@ -435,7 +428,7 @@ static int pvc_xmit(struct sk_buff *skb, struct net_device *dev)
 				if (skb_tailroom(skb) < pad)
 					if (pskb_expand_head(skb, 0, pad,
 							     GFP_ATOMIC)) {
-						stats->tx_dropped++;
+						dev->stats.tx_dropped++;
 						dev_kfree_skb(skb);
 						return 0;
 					}
@@ -445,17 +438,17 @@ static int pvc_xmit(struct sk_buff *skb, struct net_device *dev)
 			skb->protocol = __constant_htons(ETH_P_802_3);
 		}
 		if (!fr_hard_header(&skb, pvc->dlci)) {
-			stats->tx_bytes += skb->len;
-			stats->tx_packets++;
+			dev->stats.tx_bytes += skb->len;
+			dev->stats.tx_packets++;
 			if (pvc->state.fecn) /* TX Congestion counter */
-				stats->tx_compressed++;
+				dev->stats.tx_compressed++;
 			skb->dev = pvc->frad;
 			dev_queue_xmit(skb);
 			return 0;
 		}
 	}
 
-	stats->tx_dropped++;
+	dev->stats.tx_dropped++;
 	dev_kfree_skb(skb);
 	return 0;
 }
@@ -955,7 +948,7 @@ static int fr_rx(struct sk_buff *skb)
 
 
 	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL) {
-		dev_to_hdlc(frad)->stats.rx_dropped++;
+		frad->stats.rx_dropped++;
 		return NET_RX_DROP;
 	}
 
@@ -1003,11 +996,10 @@ static int fr_rx(struct sk_buff *skb)
 	}
 
 	if (dev) {
-		struct net_device_stats *stats = pvc_get_stats(dev);
-		stats->rx_packets++; /* PVC traffic */
-		stats->rx_bytes += skb->len;
+		dev->stats.rx_packets++; /* PVC traffic */
+		dev->stats.rx_bytes += skb->len;
 		if (pvc->state.becn)
-			stats->rx_compressed++;
+			dev->stats.rx_compressed++;
 		netif_rx(skb);
 		return NET_RX_SUCCESS;
 	} else {
@@ -1016,7 +1008,7 @@ static int fr_rx(struct sk_buff *skb)
 	}
 
  rx_error:
-	dev_to_hdlc(frad)->stats.rx_errors++; /* Mark error */
+	frad->stats.rx_errors++; /* Mark error */
 	dev_kfree_skb_any(skb);
 	return NET_RX_DROP;
 }
@@ -1122,7 +1114,6 @@ static int fr_add_pvc(struct net_device *frad, unsigned int dlci, int type)
 		dlci_to_q922(dev->broadcast, dlci);
 	}
 	dev->hard_start_xmit = pvc_xmit;
-	dev->get_stats = pvc_get_stats;
 	dev->open = pvc_open;
 	dev->stop = pvc_close;
 	dev->do_ioctl = pvc_ioctl;
diff --git a/drivers/net/wan/hdlc_raw_eth.c b/drivers/net/wan/hdlc_raw_eth.c
index d20c685..26dee60 100644
--- a/drivers/net/wan/hdlc_raw_eth.c
+++ b/drivers/net/wan/hdlc_raw_eth.c
@@ -33,7 +33,7 @@ static int eth_tx(struct sk_buff *skb, struct net_device *dev)
 		int len = skb->len;
 		if (skb_tailroom(skb) < pad)
 			if (pskb_expand_head(skb, 0, pad, GFP_ATOMIC)) {
-				hdlc_stats(dev)->tx_dropped++;
+				dev->stats.tx_dropped++;
 				dev_kfree_skb(skb);
 				return 0;
 			}
diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index c15cc11..e808720 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -164,17 +164,15 @@ static void x25_close(struct net_device *dev)
 
 static int x25_rx(struct sk_buff *skb)
 {
-	struct hdlc_device *hdlc = dev_to_hdlc(skb->dev);
-
 	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL) {
-		hdlc->stats.rx_dropped++;
+		skb->dev->stats.rx_dropped++;
 		return NET_RX_DROP;
 	}
 
 	if (lapb_data_received(skb->dev, skb) == LAPB_OK)
 		return NET_RX_SUCCESS;
 
-	hdlc->stats.rx_errors++;
+	skb->dev->stats.rx_errors++;
 	dev_kfree_skb_any(skb);
 	return NET_RX_DROP;
 }
diff --git a/drivers/net/wan/pc300_drv.c b/drivers/net/wan/pc300_drv.c
index 57914fb..3341705 100644
--- a/drivers/net/wan/pc300_drv.c
+++ b/drivers/net/wan/pc300_drv.c
@@ -285,7 +285,6 @@ static void rx_dma_buf_init(pc300_t *, int);
 static void tx_dma_buf_check(pc300_t *, int);
 static void rx_dma_buf_check(pc300_t *, int);
 static irqreturn_t cpc_intr(int, void *);
-static struct net_device_stats *cpc_get_stats(struct net_device *);
 static int clock_rate_calc(uclong, uclong, int *);
 static uclong detect_ram(pc300_t *);
 static void plx_init(pc300_t *);
@@ -1775,13 +1774,12 @@ static void cpc_tx_timeout(struct net_device *dev)
 	pc300dev_t *d = (pc300dev_t *) dev->priv;
 	pc300ch_t *chan = (pc300ch_t *) d->chan;
 	pc300_t *card = (pc300_t *) chan->card;
-	struct net_device_stats *stats = hdlc_stats(dev);
 	int ch = chan->channel;
 	unsigned long flags;
 	ucchar ilar;
 
-	stats->tx_errors++;
-	stats->tx_aborted_errors++;
+	dev->stats.tx_errors++;
+	dev->stats.tx_aborted_errors++;
 	CPC_LOCK(card, flags);
 	if ((ilar = cpc_readb(card->hw.scabase + ILAR)) != 0) {
 		printk("%s: ILAR=0x%x\n", dev->name, ilar);
@@ -1803,7 +1801,6 @@ static int cpc_queue_xmit(struct sk_buff *skb, struct net_device *dev)
 	pc300dev_t *d = (pc300dev_t *) dev->priv;
 	pc300ch_t *chan = (pc300ch_t *) d->chan;
 	pc300_t *card = (pc300_t *) chan->card;
-	struct net_device_stats *stats = hdlc_stats(dev);
 	int ch = chan->channel;
 	unsigned long flags;
 #ifdef PC300_DEBUG_TX
@@ -1817,13 +1814,13 @@ static int cpc_queue_xmit(struct sk_buff *skb, struct net_device *dev)
 	} else if (!netif_carrier_ok(dev)) {
 		/* DCD must be OFF: drop packet */
 		dev_kfree_skb(skb);
-		stats->tx_errors++;
-		stats->tx_carrier_errors++;
+		dev->stats.tx_errors++;
+		dev->stats.tx_carrier_errors++;
 		return 0;
 	} else if (cpc_readb(card->hw.scabase + M_REG(ST3, ch)) & ST3_DCD) {
 		printk("%s: DCD is OFF. Going administrative down.\n", dev->name);
-		stats->tx_errors++;
-		stats->tx_carrier_errors++;
+		dev->stats.tx_errors++;
+		dev->stats.tx_carrier_errors++;
 		dev_kfree_skb(skb);
 		netif_carrier_off(dev);
 		CPC_LOCK(card, flags);
@@ -1843,8 +1840,8 @@ static int cpc_queue_xmit(struct sk_buff *skb, struct net_device *dev)
 //		printk("%s: write error. Dropping TX packet.\n", dev->name);
 		netif_stop_queue(dev);
 		dev_kfree_skb(skb);
-		stats->tx_errors++;
-		stats->tx_dropped++;
+		dev->stats.tx_errors++;
+		dev->stats.tx_dropped++;
 		return 0;
 	}
 #ifdef PC300_DEBUG_TX
@@ -1886,7 +1883,6 @@ static void cpc_net_rx(struct net_device *dev)
 	pc300dev_t *d = (pc300dev_t *) dev->priv;
 	pc300ch_t *chan = (pc300ch_t *) d->chan;
 	pc300_t *card = (pc300_t *) chan->card;
-	struct net_device_stats *stats = hdlc_stats(dev);
 	int ch = chan->channel;
 #ifdef PC300_DEBUG_RX
 	int i;
@@ -1922,24 +1918,24 @@ static void cpc_net_rx(struct net_device *dev)
 #endif
 			if ((skb == NULL) && (rxb > 0)) {
 				/* rxb > dev->mtu */
-				stats->rx_errors++;
-				stats->rx_length_errors++;
+				dev->stats.rx_errors++;
+				dev->stats.rx_length_errors++;
 				continue;
 			}
 
 			if (rxb < 0) {	/* Invalid frame */
 				rxb = -rxb;
 				if (rxb & DST_OVR) {
-					stats->rx_errors++;
-					stats->rx_fifo_errors++;
+					dev->stats.rx_errors++;
+					dev->stats.rx_fifo_errors++;
 				}
 				if (rxb & DST_CRC) {
-					stats->rx_errors++;
-					stats->rx_crc_errors++;
+					dev->stats.rx_errors++;
+					dev->stats.rx_crc_errors++;
 				}
 				if (rxb & (DST_RBIT | DST_SHRT | DST_ABT)) {
-					stats->rx_errors++;
-					stats->rx_frame_errors++;
+					dev->stats.rx_errors++;
+					dev->stats.rx_frame_errors++;
 				}
 			}
 			if (skb) {
@@ -1948,7 +1944,7 @@ static void cpc_net_rx(struct net_device *dev)
 			continue;
 		}
 
-		stats->rx_bytes += rxb;
+		dev->stats.rx_bytes += rxb;
 
 #ifdef PC300_DEBUG_RX
 		printk("%s R:", dev->name);
@@ -1959,7 +1955,7 @@ static void cpc_net_rx(struct net_device *dev)
 		if (d->trace_on) {
 			cpc_trace(dev, skb, 'R');
 		}
-		stats->rx_packets++;
+		dev->stats.rx_packets++;
 		skb->protocol = hdlc_type_trans(skb, dev);
 		netif_rx(skb);
 	}
@@ -1974,16 +1970,15 @@ static void sca_tx_intr(pc300dev_t *dev)
 	pc300_t *card = (pc300_t *)chan->card; 
 	int ch = chan->channel; 
 	volatile pcsca_bd_t __iomem * ptdescr; 
-	struct net_device_stats *stats = hdlc_stats(dev->dev);
 
     /* Clean up descriptors from previous transmission */
 	ptdescr = (card->hw.rambase +
 						TX_BD_ADDR(ch,chan->tx_first_bd));
-	while ((cpc_readl(card->hw.scabase + DTX_REG(CDAL,ch)) != 
-							TX_BD_ADDR(ch,chan->tx_first_bd)) && 
-			(cpc_readb(&ptdescr->status) & DST_OSB)) {
-		stats->tx_packets++;
-		stats->tx_bytes += cpc_readw(&ptdescr->len);
+	while ((cpc_readl(card->hw.scabase + DTX_REG(CDAL,ch)) !=
+		TX_BD_ADDR(ch,chan->tx_first_bd)) &&
+	       (cpc_readb(&ptdescr->status) & DST_OSB)) {
+		dev->dev->stats.tx_packets++;
+		dev->dev->stats.tx_bytes += cpc_readw(&ptdescr->len);
 		cpc_writeb(&ptdescr->status, DST_OSB);
 		cpc_writew(&ptdescr->len, 0);
 		chan->nfree_tx_bd++;
@@ -2048,8 +2043,8 @@ static void sca_intr(pc300_t * card)
 							}
 							cpc_net_rx(dev);
 							/* Discard invalid frames */
-							hdlc_stats(dev)->rx_errors++;
-							hdlc_stats(dev)->rx_over_errors++;
+							dev->stats.rx_errors++;
+							dev->stats.rx_over_errors++;
 							chan->rx_first_bd = 0;
 							chan->rx_last_bd = N_DMA_RX_BUF - 1;
 							rx_dma_start(card, ch);
@@ -2115,8 +2110,8 @@ static void sca_intr(pc300_t * card)
 										   card->hw.cpld_reg2) &
 								   ~ (CPLD_REG2_FALC_LED1 << (2 * ch)));
 						}
-						hdlc_stats(dev)->tx_errors++;
-						hdlc_stats(dev)->tx_fifo_errors++;
+						dev->stats.tx_errors++;
+						dev->stats.tx_fifo_errors++;
 						sca_tx_intr(d);
 					}
 				}
@@ -2604,7 +2599,7 @@ static int cpc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		case SIOCGPC300UTILSTATS:
 			{
 				if (!arg) {	/* clear statistics */
-					memset(hdlc_stats(dev), 0, sizeof(struct net_device_stats));
+					memset(&dev->stats, 0, sizeof(dev->stats));
 					if (card->hw.type == PC300_TE) {
 						memset(&chan->falc, 0, sizeof(falc_t));
 					}
@@ -2615,8 +2610,8 @@ static int cpc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 					pc300stats.hw_type = card->hw.type;
 					pc300stats.line_on = card->chan[ch].d.line_on;
 					pc300stats.line_off = card->chan[ch].d.line_off;
-					memcpy(&pc300stats.gen_stats, hdlc_stats(dev),
-					       sizeof(struct net_device_stats));
+					memcpy(&pc300stats.gen_stats, &dev->stats,
+					       sizeof(dev->stats));
 					if (card->hw.type == PC300_TE)
 						memcpy(&pc300stats.te_stats,&chan->falc,sizeof(falc_t));
 				    	if (copy_to_user(arg, &pc300stats, sizeof(pc300stats_t)))
@@ -2823,11 +2818,6 @@ static int cpc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	}
 }
 
-static struct net_device_stats *cpc_get_stats(struct net_device *dev)
-{
-	return hdlc_stats(dev);
-}
-
 static int clock_rate_calc(uclong rate, uclong clock, int *br_io)
 {
 	int br, tc;
@@ -3394,7 +3384,6 @@ static void cpc_init_card(pc300_t * card)
 		dev->stop = cpc_close;
 		dev->tx_timeout = cpc_tx_timeout;
 		dev->watchdog_timeo = PC300_TX_TIMEOUT;
-		dev->get_stats = cpc_get_stats;
 		dev->set_multicast_list = NULL;
 		dev->set_mac_address = NULL;
 		dev->change_mtu = cpc_change_mtu;
diff --git a/drivers/net/wan/pc300_tty.c b/drivers/net/wan/pc300_tty.c
index e03eef2..eae94ab 100644
--- a/drivers/net/wan/pc300_tty.c
+++ b/drivers/net/wan/pc300_tty.c
@@ -458,7 +458,7 @@ static int cpc_tty_write(struct tty_struct *tty, const unsigned char *buf, int c
 	CPC_TTY_DBG("%s: cpc_tty_write data len=%i\n",cpc_tty->name,count);
 	
 	pc300chan = (pc300ch_t *)((pc300dev_t*)cpc_tty->pc300dev)->chan; 
-	stats = hdlc_stats(((pc300dev_t*)cpc_tty->pc300dev)->dev);
+	stats = &cpc_tty->pc300dev->dev->stats;
 	card = (pc300_t *) pc300chan->card;
 	ch = pc300chan->channel; 
 
@@ -743,7 +743,7 @@ void cpc_tty_receive(pc300dev_t *pc300dev)
 	pc300_t *card = (pc300_t *)pc300chan->card; 
 	int ch = pc300chan->channel; 
 	volatile pcsca_bd_t  __iomem * ptdescr; 
-	struct net_device_stats *stats = hdlc_stats(pc300dev->dev);
+	struct net_device_stats *stats = &pc300dev->dev->stats;
 	int rx_len, rx_aux; 
 	volatile unsigned char status; 
 	unsigned short first_bd = pc300chan->rx_first_bd;
@@ -917,7 +917,7 @@ static int cpc_tty_send_to_card(pc300dev_t *dev,void* buf, int len)
 	pc300ch_t *chan = (pc300ch_t *)dev->chan; 
 	pc300_t *card = (pc300_t *)chan->card; 
 	int ch = chan->channel; 
-	struct net_device_stats *stats = hdlc_stats(dev->dev);
+	struct net_device_stats *stats = &dev->dev->stats;
 	unsigned long flags; 
 	volatile pcsca_bd_t __iomem *ptdescr; 
 	int i, nchar;
diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
index d4aab8a..a8a5ca0 100644
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -161,7 +161,6 @@ static inline void wanxl_cable_intr(port_t *port)
 static inline void wanxl_tx_intr(port_t *port)
 {
 	struct net_device *dev = port->dev;
-	struct net_device_stats *stats = hdlc_stats(dev);
 	while (1) {
                 desc_t *desc = &get_status(port)->tx_descs[port->tx_in];
 		struct sk_buff *skb = port->tx_skbs[port->tx_in];
@@ -173,13 +172,13 @@ static inline void wanxl_tx_intr(port_t *port)
 			return;
 
 		case PACKET_UNDERRUN:
-			stats->tx_errors++;
-			stats->tx_fifo_errors++;
+			dev->stats.tx_errors++;
+			dev->stats.tx_fifo_errors++;
 			break;
 
 		default:
-			stats->tx_packets++;
-			stats->tx_bytes += skb->len;
+			dev->stats.tx_packets++;
+			dev->stats.tx_bytes += skb->len;
 		}
                 desc->stat = PACKET_EMPTY; /* Free descriptor */
 		pci_unmap_single(port->card->pdev, desc->address, skb->len,
@@ -205,10 +204,9 @@ static inline void wanxl_rx_intr(card_t *card)
 			port_t *port = &card->ports[desc->stat &
 						    PACKET_PORT_MASK];
 			struct net_device *dev = port->dev;
-			struct net_device_stats *stats = hdlc_stats(dev);
 
 			if (!skb)
-				stats->rx_dropped++;
+				dev->stats.rx_dropped++;
 			else {
 				pci_unmap_single(card->pdev, desc->address,
 						 BUFFER_LENGTH,
@@ -220,8 +218,8 @@ static inline void wanxl_rx_intr(card_t *card)
 				       skb->len);
 				debug_frame(skb);
 #endif
-				stats->rx_packets++;
-				stats->rx_bytes += skb->len;
+				dev->stats.rx_packets++;
+				dev->stats.rx_bytes += skb->len;
 				dev->last_rx = jiffies;
 				skb->protocol = hdlc_type_trans(skb, dev);
 				netif_rx(skb);
@@ -468,13 +466,13 @@ static int wanxl_close(struct net_device *dev)
 
 static struct net_device_stats *wanxl_get_stats(struct net_device *dev)
 {
-	struct net_device_stats *stats = hdlc_stats(dev);
 	port_t *port = dev_to_port(dev);
 
-	stats->rx_over_errors = get_status(port)->rx_overruns;
-	stats->rx_frame_errors = get_status(port)->rx_frame_errors;
-	stats->rx_errors = stats->rx_over_errors + stats->rx_frame_errors;
-        return stats;
+	dev->stats.rx_over_errors = get_status(port)->rx_overruns;
+	dev->stats.rx_frame_errors = get_status(port)->rx_frame_errors;
+	dev->stats.rx_errors = dev->stats.rx_over_errors +
+		dev->stats.rx_frame_errors;
+	return &dev->stats;
 }
 
 
diff --git a/include/linux/hdlc.h b/include/linux/hdlc.h
index 6115545..c597696 100644
--- a/include/linux/hdlc.h
+++ b/include/linux/hdlc.h
@@ -45,7 +45,6 @@ struct hdlc_proto {
 
 /* Pointed to by dev->priv */
 typedef struct hdlc_device {
-	struct net_device_stats stats;
 	/* used by HDLC layer to take control over HDLC device from hw driver*/
 	int (*attach)(struct net_device *dev,
 		      unsigned short encoding, unsigned short parity);
@@ -109,12 +108,6 @@ int attach_hdlc_protocol(struct net_device *dev, struct hdlc_proto *proto,
 /* May be used by hardware driver to gain control over HDLC device */
 void detach_hdlc_protocol(struct net_device *dev);
 
-static __inline__ struct net_device_stats *hdlc_stats(struct net_device *dev)
-{
-	return &dev_to_hdlc(dev)->stats;
-}
-
-
 static __inline__ __be16 hdlc_type_trans(struct sk_buff *skb,
 					 struct net_device *dev)
 {

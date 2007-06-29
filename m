Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbXF2U3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbXF2U3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 16:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbXF2U2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 16:28:53 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:58145 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbXF2U2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 16:28:52 -0400
Date: Fri, 29 Jun 2007 13:30:36 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 2/2] net: make net and forcedeth to use kmalloc_node
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200706291330.37070.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 2/2] net: make net and forcedeth to use kmalloc_node

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 42ba1c0..6d53b52 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -1383,7 +1383,7 @@ static int nv_alloc_rx(struct net_device *dev)
 		less_rx = np->last_rx.orig;
 
 	while (np->put_rx.orig != less_rx) {
-		struct sk_buff *skb = dev_alloc_skb(np->rx_buf_sz + NV_RX_ALLOC_PAD);
+		struct sk_buff *skb = dev_alloc_skb_node(np->rx_buf_sz + NV_RX_ALLOC_PAD, dev_to_node(&dev->dev));
 		if (skb) {
 			np->put_rx_ctx->skb = skb;
 			np->put_rx_ctx->dma = pci_map_single(np->pci_dev,
@@ -1415,7 +1415,7 @@ static int nv_alloc_rx_optimized(struct net_device *dev)
 		less_rx = np->last_rx.ex;
 
 	while (np->put_rx.ex != less_rx) {
-		struct sk_buff *skb = dev_alloc_skb(np->rx_buf_sz + NV_RX_ALLOC_PAD);
+		struct sk_buff *skb = dev_alloc_skb_node(np->rx_buf_sz + NV_RX_ALLOC_PAD, dev_to_node(&dev->dev));
 		if (skb) {
 			np->put_rx_ctx->skb = skb;
 			np->put_rx_ctx->dma = pci_map_single(np->pci_dev,
@@ -3976,8 +3976,8 @@ static int nv_set_ringparam(struct net_device *dev, struct ethtool_ringparam* ri
 					    sizeof(struct ring_desc_ex) * (ring->rx_pending + ring->tx_pending),
 					    &ring_addr);
 	}
-	rx_skbuff = kmalloc(sizeof(struct nv_skb_map) * ring->rx_pending, GFP_KERNEL);
-	tx_skbuff = kmalloc(sizeof(struct nv_skb_map) * ring->tx_pending, GFP_KERNEL);
+	rx_skbuff = kmalloc_node(sizeof(struct nv_skb_map) * ring->rx_pending, GFP_KERNEL, dev_to_node(&dev->dev));
+	tx_skbuff = kmalloc_node(sizeof(struct nv_skb_map) * ring->tx_pending, GFP_KERNEL, dev_to_node(&dev->dev));
 	if (!rxtx_ring || !rx_skbuff || !tx_skbuff) {
 		/* fall back to old rings */
 		if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2) {
@@ -4372,7 +4372,7 @@ static int nv_loopback_test(struct net_device *dev)
 
 	/* setup packet for tx */
 	pkt_len = ETH_DATA_LEN;
-	tx_skb = dev_alloc_skb(pkt_len);
+	tx_skb = dev_alloc_skb_node(pkt_len, dev_to_node(&dev->dev));
 	if (!tx_skb) {
 		printk(KERN_ERR "dev_alloc_skb() failed during loopback test"
 			 " of %s\n", dev->name);
@@ -4976,6 +4976,7 @@ static int __devinit nv_probe(struct pci_dev *pci_dev, const struct pci_device_i
 	dev->base_addr = (unsigned long)np->base;
 
 	dev->irq = pci_dev->irq;
+	printk(KERN_INFO "nv_probe: numa_node : %02d\n", dev_to_node(&pci_dev->dev));
 
 	np->rx_ring_size = RX_RING_DEFAULT;
 	np->tx_ring_size = TX_RING_DEFAULT;
@@ -4995,8 +4996,9 @@ static int __devinit nv_probe(struct pci_dev *pci_dev, const struct pci_device_i
 			goto out_unmap;
 		np->tx_ring.ex = &np->rx_ring.ex[np->rx_ring_size];
 	}
-	np->rx_skb = kmalloc(sizeof(struct nv_skb_map) * np->rx_ring_size, GFP_KERNEL);
-	np->tx_skb = kmalloc(sizeof(struct nv_skb_map) * np->tx_ring_size, GFP_KERNEL);
+	np->rx_skb = kmalloc_node(sizeof(struct nv_skb_map) * np->rx_ring_size, GFP_KERNEL, dev_to_node(&pci_dev->dev));
+	np->tx_skb = kmalloc_node(sizeof(struct nv_skb_map) * np->tx_ring_size, GFP_KERNEL, dev_to_node(&pci_dev->dev));
+
 	if (!np->rx_skb || !np->tx_skb)
 		goto out_freering;
 	memset(np->rx_skb, 0, sizeof(struct nv_skb_map) * np->rx_ring_size);
@@ -5204,6 +5206,13 @@ static int __devinit nv_probe(struct pci_dev *pci_dev, const struct pci_device_i
 	np->autoneg = 1;
 
 	err = register_netdev(dev);
+
+	/*
+	 * store numa_node in dev->dev, so we don't need to use
+	 * netdev_priv(dev)->pci_dev->dev
+	 */
+	set_dev_node(&dev->dev, dev_to_node(&pci_dev->dev));
+
 	if (err) {
 		printk(KERN_INFO "forcedeth: unable to register netdev: %d\n", err);
 		goto out_error;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6f0b2f7..747588c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -333,11 +333,22 @@ static inline struct sk_buff *alloc_skb(unsigned int size,
 	return __alloc_skb(size, priority, 0, -1);
 }
 
+static inline struct sk_buff *alloc_skb_node(unsigned int size,
+					gfp_t priority, int node)
+{
+	return __alloc_skb(size, priority, 0, node);
+}
+
 static inline struct sk_buff *alloc_skb_fclone(unsigned int size,
 					       gfp_t priority)
 {
 	return __alloc_skb(size, priority, 1, -1);
 }
+static inline struct sk_buff *alloc_skb_fclone_node(unsigned int size,
+					       gfp_t priority, int node)
+{
+	return __alloc_skb(size, priority, 1, node);
+}
 
 extern void	       kfree_skbmem(struct sk_buff *skb);
 extern struct sk_buff *skb_clone(struct sk_buff *skb,
@@ -1282,6 +1293,16 @@ static inline struct sk_buff *__dev_alloc_skb(unsigned int length,
 	return skb;
 }
 
+static inline struct sk_buff *__dev_alloc_skb_node(unsigned int length,
+					      gfp_t gfp_mask, int node)
+{
+	struct sk_buff *skb = alloc_skb_node(length + NET_SKB_PAD, gfp_mask, node);
+	if (likely(skb))
+		skb_reserve(skb, NET_SKB_PAD);
+	return skb;
+}
+
+
 /**
  *	dev_alloc_skb - allocate an skbuff for receiving
  *	@length: length to allocate
@@ -1299,6 +1320,11 @@ static inline struct sk_buff *dev_alloc_skb(unsigned int length)
 	return __dev_alloc_skb(length, GFP_ATOMIC);
 }
 
+static inline struct sk_buff *dev_alloc_skb_node(unsigned int length, int node)
+{
+	return __dev_alloc_skb_node(length, GFP_ATOMIC, node);
+}
+
 extern struct sk_buff *__netdev_alloc_skb(struct net_device *dev,
 		unsigned int length, gfp_t gfp_mask);
 

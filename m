Return-Path: <linux-kernel-owner+w=401wt.eu-S1764440AbXGKABY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764440AbXGKABY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 20:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760526AbXGKABB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 20:01:01 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:58511 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758055AbXGKAA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 20:00:59 -0400
Date: Tue, 10 Jul 2007 16:48:05 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 3/5] net: make forcedeth to use kmalloc_node and
 netdev_alloc_skb for skb allocation
In-reply-to: <200707101641.17672.yinghai.lu@sun.com>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, rientjes@google.com,
       Christoph Lameter <clameter@sgi.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200707101648.05873.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200707101641.17672.yinghai.lu@sun.com>
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 3/5] net: make forcedeth to use kmalloc_node and netdev_alloc_skb for skb allocation

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 42ba1c0..3f4f559 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -1383,7 +1383,8 @@ static int nv_alloc_rx(struct net_device *dev)
 		less_rx = np->last_rx.orig;
 
 	while (np->put_rx.orig != less_rx) {
-		struct sk_buff *skb = dev_alloc_skb(np->rx_buf_sz + NV_RX_ALLOC_PAD);
+		struct sk_buff *skb = netdev_alloc_skb(dev, np->rx_buf_sz +
+						NV_RX_ALLOC_PAD);
 		if (skb) {
 			np->put_rx_ctx->skb = skb;
 			np->put_rx_ctx->dma = pci_map_single(np->pci_dev,
@@ -1415,7 +1416,8 @@ static int nv_alloc_rx_optimized(struct net_device *dev)
 		less_rx = np->last_rx.ex;
 
 	while (np->put_rx.ex != less_rx) {
-		struct sk_buff *skb = dev_alloc_skb(np->rx_buf_sz + NV_RX_ALLOC_PAD);
+		struct sk_buff *skb = netdev_alloc_skb(dev, np->rx_buf_sz +
+						NV_RX_ALLOC_PAD);
 		if (skb) {
 			np->put_rx_ctx->skb = skb;
 			np->put_rx_ctx->dma = pci_map_single(np->pci_dev,
@@ -3976,8 +3978,10 @@ static int nv_set_ringparam(struct net_device *dev, struct ethtool_ringparam* ri
 					    sizeof(struct ring_desc_ex) * (ring->rx_pending + ring->tx_pending),
 					    &ring_addr);
 	}
-	rx_skbuff = kmalloc(sizeof(struct nv_skb_map) * ring->rx_pending, GFP_KERNEL);
-	tx_skbuff = kmalloc(sizeof(struct nv_skb_map) * ring->tx_pending, GFP_KERNEL);
+	rx_skbuff = kmalloc_node(sizeof(struct nv_skb_map) * ring->rx_pending,
+				 GFP_KERNEL, dev_to_node(&dev->dev));
+	tx_skbuff = kmalloc_node(sizeof(struct nv_skb_map) * ring->tx_pending,
+				 GFP_KERNEL, dev_to_node(&dev->dev));
 	if (!rxtx_ring || !rx_skbuff || !tx_skbuff) {
 		/* fall back to old rings */
 		if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2) {
@@ -4372,9 +4376,9 @@ static int nv_loopback_test(struct net_device *dev)
 
 	/* setup packet for tx */
 	pkt_len = ETH_DATA_LEN;
-	tx_skb = dev_alloc_skb(pkt_len);
+	tx_skb = netdev_alloc_skb(dev, pkt_len);
 	if (!tx_skb) {
-		printk(KERN_ERR "dev_alloc_skb() failed during loopback test"
+		printk(KERN_ERR "netdev_alloc_skb() failed during loopback test"
 			 " of %s\n", dev->name);
 		ret = 0;
 		goto out;
@@ -4976,6 +4980,8 @@ static int __devinit nv_probe(struct pci_dev *pci_dev, const struct pci_device_i
 	dev->base_addr = (unsigned long)np->base;
 
 	dev->irq = pci_dev->irq;
+	printk(KERN_INFO "nv_probe: numa_node : %02d\n",
+		dev_to_node(&pci_dev->dev));
 
 	np->rx_ring_size = RX_RING_DEFAULT;
 	np->tx_ring_size = TX_RING_DEFAULT;
@@ -4995,8 +5001,11 @@ static int __devinit nv_probe(struct pci_dev *pci_dev, const struct pci_device_i
 			goto out_unmap;
 		np->tx_ring.ex = &np->rx_ring.ex[np->rx_ring_size];
 	}
-	np->rx_skb = kmalloc(sizeof(struct nv_skb_map) * np->rx_ring_size, GFP_KERNEL);
-	np->tx_skb = kmalloc(sizeof(struct nv_skb_map) * np->tx_ring_size, GFP_KERNEL);
+	np->rx_skb = kmalloc_node(sizeof(struct nv_skb_map) * np->rx_ring_size,
+				  GFP_KERNEL, dev_to_node(&pci_dev->dev));
+	np->tx_skb = kmalloc_node(sizeof(struct nv_skb_map) * np->tx_ring_size,
+				  GFP_KERNEL, dev_to_node(&pci_dev->dev));
+
 	if (!np->rx_skb || !np->tx_skb)
 		goto out_freering;
 	memset(np->rx_skb, 0, sizeof(struct nv_skb_map) * np->rx_ring_size);

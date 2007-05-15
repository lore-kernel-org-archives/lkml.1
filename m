Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbXEOBU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbXEOBU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 21:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758566AbXEOBUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 21:20:50 -0400
Received: from ozlabs.org ([203.10.76.45]:34464 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758108AbXEOBUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 21:20:49 -0400
Subject: [PATCH 4/6] lguest: netdriver tidyups and a bugfix
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <1179191979.10836.29.camel@localhost.localdomain>
References: <1179191827.10836.24.camel@localhost.localdomain>
	 <1179191888.10836.26.camel@localhost.localdomain>
	 <1179191979.10836.29.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 15 May 2007 11:20:35 +1000
Message-Id: <1179192035.10836.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Feedback from Jeff Garzik:
1) Use netdev_priv instead of dev->priv.
2) Check for ioremap failure
3) iounmap on failure.
4) Wrap SEND_DMA and BIND_DMA calls
5) Don't set NETIF_F_SG unless we set NETIF_F_NO_CSUM
6) Use SET_NETDEV_DEV()
7) Don't set dev->irq, mem_start & mem_end (deprecated)

Feedback from Chrisoph Hellwig:
8) Use lguest_map()/lguest_unmap() helpers instead of ioremap/iounmap.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/net/lguest_net.c |   54 ++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

===================================================================
--- a/drivers/net/lguest_net.c
+++ b/drivers/net/lguest_net.c
@@ -22,7 +22,6 @@
 #include <linux/module.h>
 #include <linux/mm_types.h>
 #include <linux/lguest_bus.h>
-#include <asm/io.h>
 
 #define SHARED_SIZE		PAGE_SIZE
 #define MAX_LANS		4
@@ -34,6 +33,9 @@ struct lguestnet_info
 	struct lguest_net *peer;
 	unsigned long peer_phys;
 	unsigned long mapsize;
+
+	/* The lguest_device I come from */
+	struct lguest_device *lgdev;
 
 	/* My peerid. */
 	unsigned int me;
@@ -84,7 +86,7 @@ static void skb_to_dma(const struct sk_b
 
 static void lguestnet_set_multicast(struct net_device *dev)
 {
-	struct lguestnet_info *info = dev->priv;
+	struct lguestnet_info *info = netdev_priv(dev);
 
 	if ((dev->flags & (IFF_PROMISC|IFF_ALLMULTI)) || dev->mc_count)
 		info->peer[info->me].mac[0] |= PROMISC_BIT;
@@ -110,13 +112,13 @@ static void transfer_packet(struct net_d
 			    struct sk_buff *skb,
 			    unsigned int peernum)
 {
-	struct lguestnet_info *info = dev->priv;
+	struct lguestnet_info *info = netdev_priv(dev);
 	struct lguest_dma dma;
 
 	skb_to_dma(skb, skb_headlen(skb), &dma);
 	pr_debug("xfer length %04x (%u)\n", htons(skb->len), skb->len);
 
-	hcall(LHCALL_SEND_DMA, peer_key(info,peernum), __pa(&dma), 0);
+	lguest_send_dma(peer_key(info, peernum), &dma);
 	if (dma.used_len != skb->len) {
 		dev->stats.tx_carrier_errors++;
 		pr_debug("Bad xfer to peer %i: %i of %i (dma %p/%i)\n",
@@ -137,7 +139,7 @@ static int lguestnet_start_xmit(struct s
 {
 	unsigned int i;
 	int broadcast;
-	struct lguestnet_info *info = dev->priv;
+	struct lguestnet_info *info = netdev_priv(dev);
 	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
 
 	pr_debug("%s: xmit %02x:%02x:%02x:%02x:%02x:%02x\n",
@@ -162,7 +164,7 @@ static int lguestnet_start_xmit(struct s
 /* Find a new skb to put in this slot in shared mem. */
 static int fill_slot(struct net_device *dev, unsigned int slot)
 {
-	struct lguestnet_info *info = dev->priv;
+	struct lguestnet_info *info = netdev_priv(dev);
 	/* Try to create and register a new one. */
 	info->skb[slot] = netdev_alloc_skb(dev, ETH_HLEN + ETH_DATA_LEN);
 	if (!info->skb[slot]) {
@@ -180,7 +182,7 @@ static irqreturn_t lguestnet_rcv(int irq
 static irqreturn_t lguestnet_rcv(int irq, void *dev_id)
 {
 	struct net_device *dev = dev_id;
-	struct lguestnet_info *info = dev->priv;
+	struct lguestnet_info *info = netdev_priv(dev);
 	unsigned int i, done = 0;
 
 	for (i = 0; i < ARRAY_SIZE(info->dma); i++) {
@@ -220,7 +222,7 @@ static int lguestnet_open(struct net_dev
 static int lguestnet_open(struct net_device *dev)
 {
 	int i;
-	struct lguestnet_info *info = dev->priv;
+	struct lguestnet_info *info = netdev_priv(dev);
 
 	/* Set up our MAC address */
 	memcpy(info->peer[info->me].mac, dev->dev_addr, ETH_ALEN);
@@ -232,8 +234,8 @@ static int lguestnet_open(struct net_dev
 		if (fill_slot(dev, i) != 0)
 			goto cleanup;
 	}
-	if (!hcall(LHCALL_BIND_DMA, peer_key(info, info->me), __pa(info->dma),
-		   (NUM_SKBS << 8) | dev->irq))
+	if (lguest_bind_dma(peer_key(info,info->me), info->dma,
+			    NUM_SKBS, lgdev_irq(info->lgdev)) != 0)
 		goto cleanup;
 	return 0;
 
@@ -246,13 +248,13 @@ static int lguestnet_close(struct net_de
 static int lguestnet_close(struct net_device *dev)
 {
 	unsigned int i;
-	struct lguestnet_info *info = dev->priv;
+	struct lguestnet_info *info = netdev_priv(dev);
 
 	/* Clear all trace: others might deliver packets, we'll ignore it. */
 	memset(&info->peer[info->me], 0, sizeof(info->peer[info->me]));
 
 	/* Deregister sg lists. */
-	hcall(LHCALL_BIND_DMA, peer_key(info, info->me), __pa(info->dma), 0);
+	lguest_unbind_dma(peer_key(info, info->me), info->dma);
 	for (i = 0; i < ARRAY_SIZE(info->dma); i++)
 		dev_kfree_skb(info->skb[i]);
 	return 0;
@@ -290,30 +292,34 @@ static int lguestnet_probe(struct lguest
 	/* Turning on/off promisc will call dev->set_multicast_list.
 	 * We don't actually support multicast yet */
 	dev->set_multicast_list = lguestnet_set_multicast;
-	dev->mem_start = ((unsigned long)desc->pfn << PAGE_SHIFT);
-	dev->mem_end = dev->mem_start + PAGE_SIZE * desc->num_pages;
-	dev->irq = lgdev->index+1;
-	dev->features = NETIF_F_SG;
+	SET_NETDEV_DEV(dev, &lgdev->dev);
 	if (desc->features & LGUEST_NET_F_NOCSUM)
-		dev->features |= NETIF_F_NO_CSUM;
-
-	info = dev->priv;
+		dev->features = NETIF_F_SG|NETIF_F_NO_CSUM;
+
+	info = netdev_priv(dev);
 	info->mapsize = PAGE_SIZE * desc->num_pages;
 	info->peer_phys = ((unsigned long)desc->pfn << PAGE_SHIFT);
-	info->peer = (void *)ioremap(info->peer_phys, info->mapsize);
+	info->lgdev = lgdev;
+	info->peer = lguest_map(info->peer_phys, desc->num_pages);
+	if (!info->peer) {
+		err = -ENOMEM;
+		goto free;
+	}
+
 	/* This stores our peerid (upper bits reserved for future). */
 	info->me = (desc->features & (info->mapsize-1));
 
 	err = register_netdev(dev);
 	if (err) {
 		pr_debug("lguestnet: registering device failed\n");
-		goto free;
+		goto unmap;
 	}
 
 	if (lguest_devices[lgdev->index].features & LGUEST_DEVICE_F_RANDOMNESS)
 		irqf |= IRQF_SAMPLE_RANDOM;
-	if (request_irq(dev->irq, lguestnet_rcv, irqf, "lguestnet", dev) != 0) {
-		pr_debug("lguestnet: could not get net irq %i\n", dev->irq);
+	if (request_irq(lgdev_irq(lgdev), lguestnet_rcv, irqf, "lguestnet",
+			dev) != 0) {
+		pr_debug("lguestnet: cannot get irq %i\n", lgdev_irq(lgdev));
 		goto unregister;
 	}
 
@@ -323,6 +329,8 @@ static int lguestnet_probe(struct lguest
 
 unregister:
 	unregister_netdev(dev);
+unmap:
+	lguest_unmap(info->peer);
 free:
 	free_netdev(dev);
 	return err;



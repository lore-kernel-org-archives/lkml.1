Return-Path: <linux-kernel-owner+w=401wt.eu-S1760859AbXEJKOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760859AbXEJKOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760736AbXEJKNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:13:41 -0400
Received: from ozlabs.org ([203.10.76.45]:57023 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760726AbXEJKNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:13:39 -0400
Subject: Re: [patch 7/9] lguest: the net driver
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, ak@suse.de, jmorris@namei.org
In-Reply-To: <4642AEB2.5090303@garzik.org>
References: <200705090951.l499pdOr020406@shell0.pdx.osdl.net>
	 <4641BE65.3030807@garzik.org>
	 <1178723695.7286.164.camel@localhost.localdomain>
	 <4642AEB2.5090303@garzik.org>
Content-Type: text/plain
Date: Thu, 10 May 2007 20:12:56 +1000
Message-Id: <1178791976.7286.221.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-10 at 01:33 -0400, Jeff Garzik wrote:
> Rusty Russell wrote:
> > 	I realize your continual battle with this, but adding a layer of
> > indirection doesn't seem like it will add clarity.  The issues with
> > __pa() are reasonably known (don't hand it a vmalloc address, for
> > example).  Any wrapper I create would be another hurdle to jump 8(
> 
> You don't want this low level stuff in drivers.
[snip answers]

Hi Jeff,

	This email was illuminating, thanks.  I've put NAPI, set_mac_address
and module unload in the documentation patch for future enthusiasts.
The rest is implemented here.

Here's the extract from my current "feedback" patch:

...
2) Jeff Garzik
    - Use netdev_priv instead of dev->priv.
    - Check for ioremap failure
    - iounmap on failure.
    - Wrap SEND_DMA and BIND_DMA calls
    - Don't set NETIF_F_SG unless we set NETIF_F_NO_CSUM
    - Use SET_NETDEV_DEV()
    - Don't set dev->irq, mem_start & mem_end (deprecated)

diff -r 35c8b37f8d3c drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c	Wed May 09 23:23:56 2007 +1000
+++ b/drivers/lguest/lguest.c	Thu May 10 20:06:25 2007 +1000
@@ -27,6 +27,7 @@
 #include <linux/interrupt.h>
 #include <linux/lguest.h>
 #include <linux/lguest_launcher.h>
+#include <linux/lguest_bus.h>
 #include <asm/paravirt.h>
 #include <asm/param.h>
 #include <asm/page.h>
@@ -99,6 +100,25 @@ void async_hcall(unsigned long call,
 			next_call = 0;
 	}
 	local_irq_restore(flags);
+}
+
+void lguest_send_dma(unsigned long key, struct lguest_dma *dma)
+{
+	dma->used_len = 0;
+	hcall(LHCALL_SEND_DMA, key, __pa(dma), 0);
+}
+
+int lguest_bind_dma(unsigned long key, struct lguest_dma *dmas,
+		    unsigned int num, u8 irq)
+{
+	if (!hcall(LHCALL_BIND_DMA, key, __pa(dmas), (num << 8) | irq))
+		return -ENOMEM;
+	return 0;
+}
+
+void lguest_unbind_dma(unsigned long key, struct lguest_dma *dmas)
+{
+	hcall(LHCALL_BIND_DMA, key, __pa(dmas), 0);
 }
 
 static unsigned long save_fl(void)
diff -r 35c8b37f8d3c drivers/net/lguest_net.c
--- a/drivers/net/lguest_net.c	Wed May 09 23:23:56 2007 +1000
+++ b/drivers/net/lguest_net.c	Thu May 10 19:30:21 2007 +1000
@@ -35,6 +35,9 @@ struct lguestnet_info
 	unsigned long peer_phys;
 	unsigned long mapsize;
 
+	/* The lguest_device I come from */
+	struct lguest_device *lgdev;
+
 	/* My peerid. */
 	unsigned int me;
 
@@ -84,7 +87,7 @@ static void skb_to_dma(const struct sk_b
 
 static void lguestnet_set_multicast(struct net_device *dev)
 {
-	struct lguestnet_info *info = dev->priv;
+	struct lguestnet_info *info = netdev_priv(dev);
 
 	if ((dev->flags & (IFF_PROMISC|IFF_ALLMULTI)) || dev->mc_count)
 		info->peer[info->me].mac[0] |= PROMISC_BIT;
@@ -110,13 +113,13 @@ static void transfer_packet(struct net_d
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
@@ -137,7 +140,7 @@ static int lguestnet_start_xmit(struct s
 {
 	unsigned int i;
 	int broadcast;
-	struct lguestnet_info *info = dev->priv;
+	struct lguestnet_info *info = netdev_priv(dev);
 	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
 
 	pr_debug("%s: xmit %02x:%02x:%02x:%02x:%02x:%02x\n",
@@ -162,7 +165,7 @@ static int lguestnet_start_xmit(struct s
 /* Find a new skb to put in this slot in shared mem. */
 static int fill_slot(struct net_device *dev, unsigned int slot)
 {
-	struct lguestnet_info *info = dev->priv;
+	struct lguestnet_info *info = netdev_priv(dev);
 	/* Try to create and register a new one. */
 	info->skb[slot] = netdev_alloc_skb(dev, ETH_HLEN + ETH_DATA_LEN);
 	if (!info->skb[slot]) {
@@ -180,7 +183,7 @@ static irqreturn_t lguestnet_rcv(int irq
 static irqreturn_t lguestnet_rcv(int irq, void *dev_id)
 {
 	struct net_device *dev = dev_id;
-	struct lguestnet_info *info = dev->priv;
+	struct lguestnet_info *info = netdev_priv(dev);
 	unsigned int i, done = 0;
 
 	for (i = 0; i < ARRAY_SIZE(info->dma); i++) {
@@ -220,7 +223,7 @@ static int lguestnet_open(struct net_dev
 static int lguestnet_open(struct net_device *dev)
 {
 	int i;
-	struct lguestnet_info *info = dev->priv;
+	struct lguestnet_info *info = netdev_priv(dev);
 
 	/* Set up our MAC address */
 	memcpy(info->peer[info->me].mac, dev->dev_addr, ETH_ALEN);
@@ -232,8 +235,8 @@ static int lguestnet_open(struct net_dev
 		if (fill_slot(dev, i) != 0)
 			goto cleanup;
 	}
-	if (!hcall(LHCALL_BIND_DMA, peer_key(info, info->me), __pa(info->dma),
-		   (NUM_SKBS << 8) | dev->irq))
+	if (lguest_bind_dma(peer_key(info,info->me), info->dma,
+			    NUM_SKBS, lgdev_irq(info->lgdev)) != 0)
 		goto cleanup;
 	return 0;
 
@@ -246,13 +249,13 @@ static int lguestnet_close(struct net_de
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
@@ -290,30 +293,34 @@ static int lguestnet_probe(struct lguest
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
+	info->peer = (__force void *)ioremap(info->peer_phys, info->mapsize);
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
 
@@ -323,6 +330,8 @@ static int lguestnet_probe(struct lguest
 
 unregister:
 	unregister_netdev(dev);
+unmap:
+	iounmap((__force void __iomem *)info->peer);
 free:
 	free_netdev(dev);
 	return err;
diff -r 35c8b37f8d3c include/linux/lguest_bus.h
--- a/include/linux/lguest_bus.h	Wed May 09 23:23:56 2007 +1000
+++ b/include/linux/lguest_bus.h	Thu May 10 19:29:14 2007 +1000
@@ -7,7 +7,6 @@
 
 struct lguest_device {
 	/* Unique busid, and index into lguest_page->devices[] */
-	/* By convention, each device can use irq index+1 if it wants to. */
 	unsigned int index;
 
 	struct device dev;
@@ -15,6 +14,18 @@ struct lguest_device {
 	/* Driver can hang data off here. */
 	void *private;
 };
+
+/* By convention, each device can use irq index+1 if it wants to. */
+static inline int lgdev_irq(const struct lguest_device *dev)
+{
+	return dev->index + 1;
+}
+
+/* dma args must not be vmalloced! */
+void lguest_send_dma(unsigned long key, struct lguest_dma *dma);
+int lguest_bind_dma(unsigned long key, struct lguest_dma *dmas,
+		    unsigned int num, u8 irq);
+void lguest_unbind_dma(unsigned long key, struct lguest_dma *dmas);
 
 struct lguest_driver {
 	const char *name;



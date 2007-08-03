Return-Path: <linux-kernel-owner+w=401wt.eu-S1763967AbXHCRgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763967AbXHCRgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760624AbXHCRfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:35:30 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:37202 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763579AbXHCRf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:35:26 -0400
Date: Fri, 3 Aug 2007 19:33:58 +0200 (MEST)
Message-Id: <200708031733.TAA00764@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 05/13] dev->priv to netdev_priv(dev), for drivers/net/cris
Cc: starvik@axis.com, dev-etrax@axis.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
From: Yoann Padioleau <padator@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Replacing accesses to dev->priv to netdev_priv(dev). The replacment
is safe when netdev_priv is used to access a private structure that is
right next to the net_device structure in memory. Cf
http://groups.google.com/group/comp.os.linux.development.system/browse_thread/thread/de19321bcd94dbb8/0d74a4adcd6177bd
This is the case when the net_device structure was allocated with
a call to alloc_netdev or one of its derivative.

Here is an excerpt of the semantic patch that performs the transformation

@ rule1 @
type T;
struct net_device *dev;
@@

 dev = 
(
        alloc_netdev
|         
        alloc_etherdev
|
        alloc_trdev
)
   (sizeof(T), ...)

@ rule1bis @
struct net_device *dev;
expression E;
@@
 dev->priv = E

@ rule2 depends on rule1 && !rule1bis  @
struct net_device *dev;
type rule1.T;
@@

- (T*) dev->priv
+ netdev_priv(dev)

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: starvik@axis.com
Cc: dev-etrax@axis.com
Cc: akpm@linux-foundation.org
---

 drivers/net/cris/eth_v10.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/cris/eth_v10.c b/drivers/net/cris/eth_v10.c
index 5bdf5ca..39afed7 100644
--- a/drivers/net/cris/eth_v10.c
+++ b/drivers/net/cris/eth_v10.c
@@ -474,7 +474,7 @@ etrax_ethernet_init(void)
 	       "ETRAX 100LX 10/100MBit ethernet v2.0 (c) 2000-2003 Axis Communications AB\n");
 
 	dev = alloc_etherdev(sizeof(struct net_local));
-	np = dev->priv;
+	np = netdev_priv(dev);
 
 	if (!dev)
 		return -ENOMEM;
@@ -595,7 +595,7 @@ etrax_ethernet_init(void)
 static int
 e100_set_mac_address(struct net_device *dev, void *p)
 {
-	struct net_local *np = (struct net_local *)dev->priv;
+	struct net_local *np = netdev_priv(dev);
 	struct sockaddr *addr = p;
 	int i;
 
@@ -911,7 +911,7 @@ static void
 e100_check_duplex(unsigned long priv)
 {
 	struct net_device *dev = (struct net_device *)priv;
-	struct net_local *np = (struct net_local *)dev->priv;
+	struct net_local *np = netdev_priv(dev);
 	int old_duplex = full_duplex;
 	transceiver->check_duplex(dev);
 	if (old_duplex != full_duplex) {
@@ -1116,7 +1116,7 @@ e100_reset_transceiver(struct net_device
 static void
 e100_tx_timeout(struct net_device *dev)
 {
-	struct net_local *np = (struct net_local *)dev->priv;
+	struct net_local *np = netdev_priv(dev);
 	unsigned long flags;
 
 	spin_lock_irqsave(&np->lock, flags);
@@ -1165,7 +1165,7 @@ e100_tx_timeout(struct net_device *dev)
 static int
 e100_send_packet(struct sk_buff *skb, struct net_device *dev)
 {
-	struct net_local *np = (struct net_local *)dev->priv;
+	struct net_local *np = netdev_priv(dev);
 	unsigned char *buf = skb->data;
 	unsigned long flags;
 
@@ -1201,7 +1201,7 @@ static irqreturn_t
 e100rxtx_interrupt(int irq, void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
-	struct net_local *np = (struct net_local *)dev->priv;
+	struct net_local *np = netdev_priv(dev);
 	unsigned long irqbits = *R_IRQ_MASK2_RD;
 
 	/* Disable RX/TX IRQs to avoid reentrancy */
@@ -1223,7 +1223,7 @@ e100rxtx_interrupt(int irq, void *dev_id
 			 * allocate a new buffer to put a packet in.
 			 */
 			e100_rx(dev);
-			((struct net_local *)dev->priv)->stats.rx_packets++;
+			((struct net_local *)netdev_priv(dev))->stats.rx_packets++;
 			/* restart/continue on the channel, for safety */
 			*R_DMA_CH1_CMD = IO_STATE(R_DMA_CH1_CMD, cmd, restart);
 			/* clear dma channel 1 eop/descr irq bits */
@@ -1268,7 +1268,7 @@ static irqreturn_t
 e100nw_interrupt(int irq, void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
-	struct net_local *np = (struct net_local *)dev->priv;
+	struct net_local *np = netdev_priv(dev);
 	unsigned long irqbits = *R_IRQ_MASK0_RD;
 
 	/* check for underrun irq */
@@ -1303,7 +1303,7 @@ e100_rx(struct net_device *dev)
 {
 	struct sk_buff *skb;
 	int length = 0;
-	struct net_local *np = (struct net_local *)dev->priv;
+	struct net_local *np = netdev_priv(dev);
 	unsigned char *skb_data_ptr;
 #ifdef ETHDEBUG
 	int i;
@@ -1320,7 +1320,7 @@ #endif
 	}
 
 	length = myNextRxDesc->descr.hw_len - 4;
-	((struct net_local *)dev->priv)->stats.rx_bytes += length;
+	((struct net_local *)netdev_priv(dev))->stats.rx_bytes += length;
 
 #ifdef ETHDEBUG
 	printk("Got a packet of length %d:\n", length);
@@ -1402,7 +1402,7 @@ #endif
 static int
 e100_close(struct net_device *dev)
 {
-	struct net_local *np = (struct net_local *)dev->priv;
+	struct net_local *np = netdev_priv(dev);
 
 	printk(KERN_INFO "Closing %s.\n", dev->name);
 
@@ -1564,7 +1564,7 @@ static const struct ethtool_ops e100_eth
 static int
 e100_set_config(struct net_device *dev, struct ifmap *map)
 {
-	struct net_local *np = (struct net_local *)dev->priv;
+	struct net_local *np = netdev_priv(dev);
 	spin_lock(&np->lock); /* Preempt protection */
 
 	switch(map->port) {
@@ -1626,7 +1626,7 @@ update_tx_stats(struct net_device_stats 
 static struct net_device_stats *
 e100_get_stats(struct net_device *dev)
 {
-	struct net_local *lp = (struct net_local *)dev->priv;
+	struct net_local *lp = netdev_priv(dev);
 	unsigned long flags;
 	spin_lock_irqsave(&lp->lock, flags);
 
@@ -1647,7 +1647,7 @@ e100_get_stats(struct net_device *dev)
 static void
 set_multicast_list(struct net_device *dev)
 {
-	struct net_local *lp = (struct net_local *)dev->priv;
+	struct net_local *lp = netdev_priv(dev);
 	int num_addr = dev->mc_count;
 	unsigned long int lo_bits;
 	unsigned long int hi_bits;


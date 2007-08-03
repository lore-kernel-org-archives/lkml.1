Return-Path: <linux-kernel-owner+w=401wt.eu-S1763891AbXHCRh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763891AbXHCRh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763917AbXHCRfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:35:55 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:37232 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763756AbXHCRfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:35:51 -0400
Date: Fri, 3 Aug 2007 19:34:24 +0200 (MEST)
Message-Id: <200708031734.TAA00780@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 07/13] dev->priv to netdev_priv(dev), for drivers/net/irda
Cc: samuel@sortiz.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
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
Cc: samuel@sortiz.org
Cc: akpm@linux-foundation.org
---

 drivers/net/irda/ali-ircc.c    |   16 ++++++++--------
 drivers/net/irda/donauboe.c    |    8 ++++----
 drivers/net/irda/irda-usb.c    |   14 +++++++-------
 drivers/net/irda/irport.c      |   20 ++++++++++----------
 drivers/net/irda/nsc-ircc.c    |   16 ++++++++--------
 drivers/net/irda/sa1100_ir.c   |   26 +++++++++++++-------------
 drivers/net/irda/sir_dev.c     |   12 ++++++------
 drivers/net/irda/via-ircc.c    |   16 ++++++++--------
 drivers/net/irda/vlsi_ir.c     |   36 ++++++++++++++++++------------------
 drivers/net/irda/w83977af_ir.c |   14 +++++++-------
 10 files changed, 89 insertions(+), 89 deletions(-)

diff --git a/drivers/net/irda/ali-ircc.c b/drivers/net/irda/ali-ircc.c
index f9c889c..0300aac 100644
--- a/drivers/net/irda/ali-ircc.c
+++ b/drivers/net/irda/ali-ircc.c
@@ -291,7 +291,7 @@ static int ali_ircc_open(int i, chipio_t
 		return -ENOMEM;
 	}
 
-	self = dev->priv;
+	self = netdev_priv(dev);
 	self->netdev = dev;
 	spin_lock_init(&self->lock);
    
@@ -668,7 +668,7 @@ static irqreturn_t ali_ircc_interrupt(in
 		
 	IRDA_DEBUG(2, "%s(), ---------------- Start ----------------\n", __FUNCTION__);
 		
-	self = dev->priv;
+	self = netdev_priv(dev);
 	
 	spin_lock(&self->lock);
 	
@@ -1336,7 +1336,7 @@ static int ali_ircc_net_open(struct net_
 	
 	IRDA_ASSERT(dev != NULL, return -1;);
 	
-	self = (struct ali_ircc_cb *) dev->priv;
+	self = netdev_priv(dev);
 	
 	IRDA_ASSERT(self != NULL, return 0;);
 	
@@ -1399,7 +1399,7 @@ static int ali_ircc_net_close(struct net
 		
 	IRDA_ASSERT(dev != NULL, return -1;);
 
-	self = (struct ali_ircc_cb *) dev->priv;
+	self = netdev_priv(dev);
 	IRDA_ASSERT(self != NULL, return 0;);
 
 	/* Stop device */
@@ -1439,7 +1439,7 @@ static int ali_ircc_fir_hard_xmit(struct
 	
 	IRDA_DEBUG(1, "%s(), ---------------- Start -----------------\n", __FUNCTION__ );	
 	
-	self = (struct ali_ircc_cb *) dev->priv;
+	self = netdev_priv(dev);
 	iobase = self->io.fir_base;
 
 	netif_stop_queue(dev);
@@ -1963,7 +1963,7 @@ static int ali_ircc_sir_hard_xmit(struct
 	
 	IRDA_ASSERT(dev != NULL, return 0;);
 	
-	self = (struct ali_ircc_cb *) dev->priv;
+	self = netdev_priv(dev);
 	IRDA_ASSERT(self != NULL, return 0;);
 
 	iobase = self->io.sir_base;
@@ -2031,7 +2031,7 @@ static int ali_ircc_net_ioctl(struct net
 	
 	IRDA_ASSERT(dev != NULL, return -1;);
 
-	self = dev->priv;
+	self = netdev_priv(dev);
 
 	IRDA_ASSERT(self != NULL, return -1;);
 
@@ -2117,7 +2117,7 @@ static int ali_ircc_is_receiving(struct 
 
 static struct net_device_stats *ali_ircc_net_get_stats(struct net_device *dev)
 {
-	struct ali_ircc_cb *self = (struct ali_ircc_cb *) dev->priv;
+	struct ali_ircc_cb *self = netdev_priv(dev);
 	
 	IRDA_DEBUG(2, "%s(), ---------------- Start ----------------\n", __FUNCTION__ );
 		
diff --git a/drivers/net/irda/donauboe.c b/drivers/net/irda/donauboe.c
index 3ca47bf..fd7602e 100644
--- a/drivers/net/irda/donauboe.c
+++ b/drivers/net/irda/donauboe.c
@@ -983,7 +983,7 @@ toshoboe_hard_xmit (struct sk_buff *skb,
   unsigned long flags;
   struct irda_skb_cb *cb = (struct irda_skb_cb *) skb->cb;
 
-  self = (struct toshoboe_cb *) dev->priv;
+  self = netdev_priv(dev);
 
   IRDA_ASSERT (self != NULL, return 0; );
 
@@ -1388,7 +1388,7 @@ toshoboe_net_close (struct net_device *d
   IRDA_DEBUG (4, "%s()\n", __FUNCTION__);
 
   IRDA_ASSERT (dev != NULL, return -1; );
-  self = (struct toshoboe_cb *) dev->priv;
+  self = netdev_priv(dev);
 
   /* Stop device */
   netif_stop_queue(dev);
@@ -1426,7 +1426,7 @@ toshoboe_net_ioctl (struct net_device *d
 
   IRDA_ASSERT (dev != NULL, return -1; );
 
-  self = dev->priv;
+  self = netdev_priv(dev);
 
   IRDA_ASSERT (self != NULL, return -1; );
 
@@ -1550,7 +1550,7 @@ toshoboe_open (struct pci_dev *pci_dev, 
       return -ENOMEM;
     }
 
-  self = dev->priv;
+  self = netdev_priv(dev);
   self->netdev = dev;
   self->pdev = pci_dev;
   self->base = pci_resource_start(pci_dev,0);
diff --git a/drivers/net/irda/irda-usb.c b/drivers/net/irda/irda-usb.c
index 0ac240c..bda204b 100644
--- a/drivers/net/irda/irda-usb.c
+++ b/drivers/net/irda/irda-usb.c
@@ -384,7 +384,7 @@ static void speed_bulk_callback(struct u
  */
 static int irda_usb_hard_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
-	struct irda_usb_cb *self = netdev->priv;
+	struct irda_usb_cb *self = netdev_priv(netdev);
 	struct urb *urb = self->tx_urb;
 	unsigned long flags;
 	s32 speed;
@@ -628,7 +628,7 @@ static void write_bulk_callback(struct u
 static void irda_usb_net_timeout(struct net_device *netdev)
 {
 	unsigned long flags;
-	struct irda_usb_cb *self = netdev->priv;
+	struct irda_usb_cb *self = netdev_priv(netdev);
 	struct urb *urb;
 	int	done = 0;	/* If we have made any progress */
 
@@ -1174,7 +1174,7 @@ static int irda_usb_net_open(struct net_
 	IRDA_DEBUG(1, "%s()\n", __FUNCTION__);
 
 	IRDA_ASSERT(netdev != NULL, return -1;);
-	self = (struct irda_usb_cb *) netdev->priv;
+	self = netdev_priv(netdev);
 	IRDA_ASSERT(self != NULL, return -1;);
 
 	/* Can only open the device if it's there */
@@ -1252,7 +1252,7 @@ static int irda_usb_net_close(struct net
 	IRDA_DEBUG(1, "%s()\n", __FUNCTION__);
 
 	IRDA_ASSERT(netdev != NULL, return -1;);
-	self = (struct irda_usb_cb *) netdev->priv;
+	self = netdev_priv(netdev);
 	IRDA_ASSERT(self != NULL, return -1;);
 
 	/* Clear this flag *before* unlinking the urbs and *before*
@@ -1301,7 +1301,7 @@ static int irda_usb_net_ioctl(struct net
 	int ret = 0;
 
 	IRDA_ASSERT(dev != NULL, return -1;);
-	self = dev->priv;
+	self = netdev_priv(dev);
 	IRDA_ASSERT(self != NULL, return -1;);
 
 	IRDA_DEBUG(2, "%s(), %s, (cmd=0x%X)\n", __FUNCTION__, dev->name, cmd);
@@ -1343,7 +1343,7 @@ static int irda_usb_net_ioctl(struct net
  */
 static struct net_device_stats *irda_usb_net_get_stats(struct net_device *dev)
 {
-	struct irda_usb_cb *self = dev->priv;
+	struct irda_usb_cb *self = netdev_priv(dev);
 	return &self->stats;
 }
 
@@ -1638,7 +1638,7 @@ static int irda_usb_probe(struct usb_int
 
 	SET_MODULE_OWNER(net);
 	SET_NETDEV_DEV(net, &intf->dev);
-	self = net->priv;
+	self = netdev_priv(net);
 	self->netdev = net;
 	spin_lock_init(&self->lock);
 	init_timer(&self->rx_defer_timer);
diff --git a/drivers/net/irda/irport.c b/drivers/net/irda/irport.c
index 2073245..3ee9a55 100644
--- a/drivers/net/irda/irport.c
+++ b/drivers/net/irda/irport.c
@@ -118,7 +118,7 @@ irport_open(int i, unsigned int iobase, 
 		goto err_out2;
 	}
 
-	self = dev->priv;
+	self = netdev_priv(dev);
 	spin_lock_init(&self->lock);
 
 	/* Need to store self somewhere */
@@ -491,7 +491,7 @@ static void irport_timeout(struct net_de
 	int iir, lsr;
 	unsigned long flags;
 
-	self = (struct irport_cb *) dev->priv;
+	self = netdev_priv(dev);
 	IRDA_ASSERT(self != NULL, return;);
 	iobase = self->io.sir_base;
 	
@@ -579,7 +579,7 @@ static int irport_hard_xmit(struct sk_bu
 
 	IRDA_ASSERT(dev != NULL, return 0;);
 	
-	self = (struct irport_cb *) dev->priv;
+	self = netdev_priv(dev);
 	IRDA_ASSERT(self != NULL, return 0;);
 
 	iobase = self->io.sir_base;
@@ -772,7 +772,7 @@ static irqreturn_t irport_interrupt(int 
 	int iir, lsr;
 	int handled = 0;
 
-	self = dev->priv;
+	self = netdev_priv(dev);
 
 	spin_lock(&self->lock);
 
@@ -843,7 +843,7 @@ static int irport_net_open(struct net_de
 	IRDA_DEBUG(2, "%s()\n", __FUNCTION__);
 
 	IRDA_ASSERT(dev != NULL, return -1;);
-	self = (struct irport_cb *) dev->priv;
+	self = netdev_priv(dev);
 
 	iobase = self->io.sir_base;
 
@@ -895,7 +895,7 @@ static int irport_net_close(struct net_d
 	IRDA_DEBUG(4, "%s()\n", __FUNCTION__);
 
 	IRDA_ASSERT(dev != NULL, return -1;);
-	self = (struct irport_cb *) dev->priv;
+	self = netdev_priv(dev);
 
 	IRDA_ASSERT(self != NULL, return -1;);
 
@@ -937,7 +937,7 @@ static inline int irport_is_receiving(st
  */
 static int irport_set_dtr_rts(struct net_device *dev, int dtr, int rts)
 {
-	struct irport_cb *self = dev->priv;
+	struct irport_cb *self = netdev_priv(dev);
 	int iobase;
 
 	IRDA_ASSERT(self != NULL, return -1;);
@@ -956,7 +956,7 @@ static int irport_set_dtr_rts(struct net
 
 static int irport_raw_write(struct net_device *dev, __u8 *buf, int len)
 {
-	struct irport_cb *self = (struct irport_cb *) dev->priv;
+	struct irport_cb *self = netdev_priv(dev);
 	int actual = 0;
 	int iobase;
 
@@ -996,7 +996,7 @@ static int irport_net_ioctl(struct net_d
 
 	IRDA_ASSERT(dev != NULL, return -1;);
 
-	self = dev->priv;
+	self = netdev_priv(dev);
 
 	IRDA_ASSERT(self != NULL, return -1;);
 
@@ -1074,7 +1074,7 @@ static int irport_net_ioctl(struct net_d
 
 static struct net_device_stats *irport_net_get_stats(struct net_device *dev)
 {
-	struct irport_cb *self = (struct irport_cb *) dev->priv;
+	struct irport_cb *self = netdev_priv(dev);
 	
 	return &self->stats;
 }
diff --git a/drivers/net/irda/nsc-ircc.c b/drivers/net/irda/nsc-ircc.c
index d96c897..afa8d86 100644
--- a/drivers/net/irda/nsc-ircc.c
+++ b/drivers/net/irda/nsc-ircc.c
@@ -368,7 +368,7 @@ static int __init nsc_ircc_open(chipio_t
 		return -ENOMEM;
 	}
 
-	self = dev->priv;
+	self = netdev_priv(dev);
 	self->netdev = dev;
 	spin_lock_init(&self->lock);
    
@@ -1345,7 +1345,7 @@ static int nsc_ircc_hard_xmit_sir(struct
 	__s32 speed;
 	__u8 bank;
 	
-	self = (struct nsc_ircc_cb *) dev->priv;
+	self = netdev_priv(dev);
 
 	IRDA_ASSERT(self != NULL, return 0;);
 
@@ -1418,7 +1418,7 @@ static int nsc_ircc_hard_xmit_fir(struct
 	__u8 bank;
 	int mtt, diff;
 	
-	self = (struct nsc_ircc_cb *) dev->priv;
+	self = netdev_priv(dev);
 	iobase = self->io.fir_base;
 
 	netif_stop_queue(dev);
@@ -2076,7 +2076,7 @@ static irqreturn_t nsc_ircc_interrupt(in
 	__u8 bsr, eir;
 	int iobase;
 
-	self = dev->priv;
+	self = netdev_priv(dev);
 
 	spin_lock(&self->lock);	
 
@@ -2157,7 +2157,7 @@ static int nsc_ircc_net_open(struct net_
 	IRDA_DEBUG(4, "%s()\n", __FUNCTION__);
 	
 	IRDA_ASSERT(dev != NULL, return -1;);
-	self = (struct nsc_ircc_cb *) dev->priv;
+	self = netdev_priv(dev);
 	
 	IRDA_ASSERT(self != NULL, return 0;);
 	
@@ -2220,7 +2220,7 @@ static int nsc_ircc_net_close(struct net
 	
 	IRDA_ASSERT(dev != NULL, return -1;);
 
-	self = (struct nsc_ircc_cb *) dev->priv;
+	self = netdev_priv(dev);
 	IRDA_ASSERT(self != NULL, return 0;);
 
 	/* Stop device */
@@ -2266,7 +2266,7 @@ static int nsc_ircc_net_ioctl(struct net
 
 	IRDA_ASSERT(dev != NULL, return -1;);
 
-	self = dev->priv;
+	self = netdev_priv(dev);
 
 	IRDA_ASSERT(self != NULL, return -1;);
 
@@ -2301,7 +2301,7 @@ static int nsc_ircc_net_ioctl(struct net
 
 static struct net_device_stats *nsc_ircc_net_get_stats(struct net_device *dev)
 {
-	struct nsc_ircc_cb *self = (struct nsc_ircc_cb *) dev->priv;
+	struct nsc_ircc_cb *self = netdev_priv(dev);
 	
 	return &self->stats;
 }
diff --git a/drivers/net/irda/sa1100_ir.c b/drivers/net/irda/sa1100_ir.c
index 056639f..1dd2809 100644
--- a/drivers/net/irda/sa1100_ir.c
+++ b/drivers/net/irda/sa1100_ir.c
@@ -298,7 +298,7 @@ static int sa1100_irda_suspend(struct pl
 	if (!dev)
 		return 0;
 
-	si = dev->priv;
+	si = netdev_priv(dev);
 	if (si->open) {
 		/*
 		 * Stop the transmit queue
@@ -323,7 +323,7 @@ static int sa1100_irda_resume(struct pla
 	if (!dev)
 		return 0;
 
-	si = dev->priv;
+	si = netdev_priv(dev);
 	if (si->open) {
 		/*
 		 * If we missed a speed change, initialise at the new speed
@@ -359,7 +359,7 @@ #endif
  */
 static void sa1100_irda_hpsir_irq(struct net_device *dev)
 {
-	struct sa1100_irda *si = dev->priv;
+	struct sa1100_irda *si = netdev_priv(dev);
 	int status;
 
 	status = Ser2UTSR0;
@@ -534,7 +534,7 @@ static void sa1100_irda_fir_error(struct
  */
 static void sa1100_irda_fir_irq(struct net_device *dev)
 {
-	struct sa1100_irda *si = dev->priv;
+	struct sa1100_irda *si = netdev_priv(dev);
 
 	/*
 	 * Stop RX DMA
@@ -582,7 +582,7 @@ static void sa1100_irda_fir_irq(struct n
 static irqreturn_t sa1100_irda_irq(int irq, void *dev_id)
 {
 	struct net_device *dev = dev_id;
-	if (IS_FIR(((struct sa1100_irda *)dev->priv)))
+	if (IS_FIR((netdev_priv(dev))))
 		sa1100_irda_fir_irq(dev);
 	else
 		sa1100_irda_hpsir_irq(dev);
@@ -595,7 +595,7 @@ static irqreturn_t sa1100_irda_irq(int i
 static void sa1100_irda_txdma_irq(void *id)
 {
 	struct net_device *dev = id;
-	struct sa1100_irda *si = dev->priv;
+	struct sa1100_irda *si = netdev_priv(dev);
 	struct sk_buff *skb = si->txskb;
 
 	si->txskb = NULL;
@@ -649,7 +649,7 @@ static void sa1100_irda_txdma_irq(void *
 
 static int sa1100_irda_hard_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct sa1100_irda *si = dev->priv;
+	struct sa1100_irda *si = netdev_priv(dev);
 	int speed = irda_get_next_speed(skb);
 
 	/*
@@ -724,7 +724,7 @@ static int
 sa1100_irda_ioctl(struct net_device *dev, struct ifreq *ifreq, int cmd)
 {
 	struct if_irda_req *rq = (struct if_irda_req *)ifreq;
-	struct sa1100_irda *si = dev->priv;
+	struct sa1100_irda *si = netdev_priv(dev);
 	int ret = -EOPNOTSUPP;
 
 	switch (cmd) {
@@ -766,13 +766,13 @@ sa1100_irda_ioctl(struct net_device *dev
 
 static struct net_device_stats *sa1100_irda_stats(struct net_device *dev)
 {
-	struct sa1100_irda *si = dev->priv;
+	struct sa1100_irda *si = netdev_priv(dev);
 	return &si->stats;
 }
 
 static int sa1100_irda_start(struct net_device *dev)
 {
-	struct sa1100_irda *si = dev->priv;
+	struct sa1100_irda *si = netdev_priv(dev);
 	int err;
 
 	si->speed = 9600;
@@ -835,7 +835,7 @@ err_irq:
 
 static int sa1100_irda_stop(struct net_device *dev)
 {
-	struct sa1100_irda *si = dev->priv;
+	struct sa1100_irda *si = netdev_priv(dev);
 
 	disable_irq(dev->irq);
 	sa1100_irda_shutdown(si);
@@ -908,7 +908,7 @@ static int sa1100_irda_probe(struct plat
 	if (!dev)
 		goto err_mem_4;
 
-	si = dev->priv;
+	si = netdev_priv(dev);
 	si->dev = &pdev->dev;
 	si->pdata = pdev->dev.platform_data;
 
@@ -987,7 +987,7 @@ static int sa1100_irda_remove(struct pla
 	struct net_device *dev = platform_get_drvdata(pdev);
 
 	if (dev) {
-		struct sa1100_irda *si = dev->priv;
+		struct sa1100_irda *si = netdev_priv(dev);
 		unregister_netdev(dev);
 		kfree(si->tx_buff.head);
 		kfree(si->rx_buff.head);
diff --git a/drivers/net/irda/sir_dev.c b/drivers/net/irda/sir_dev.c
index 9d6c8f3..ef26c16 100644
--- a/drivers/net/irda/sir_dev.c
+++ b/drivers/net/irda/sir_dev.c
@@ -583,14 +583,14 @@ EXPORT_SYMBOL(sirdev_receive);
 
 static struct net_device_stats *sirdev_get_stats(struct net_device *ndev)
 {
-	struct sir_dev *dev = ndev->priv;
+	struct sir_dev *dev = netdev_priv(ndev);
 
 	return (dev) ? &dev->stats : NULL;
 }
 
 static int sirdev_hard_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
-	struct sir_dev *dev = ndev->priv;
+	struct sir_dev *dev = netdev_priv(ndev);
 	unsigned long flags;
 	int actual = 0;
 	int err;
@@ -682,7 +682,7 @@ static int sirdev_hard_xmit(struct sk_bu
 static int sirdev_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
 {
 	struct if_irda_req *irq = (struct if_irda_req *) rq;
-	struct sir_dev *dev = ndev->priv;
+	struct sir_dev *dev = netdev_priv(ndev);
 	int ret = 0;
 
 	IRDA_ASSERT(dev != NULL, return -1;);
@@ -794,7 +794,7 @@ static void sirdev_free_buffers(struct s
 
 static int sirdev_open(struct net_device *ndev)
 {
-	struct sir_dev *dev = ndev->priv;
+	struct sir_dev *dev = netdev_priv(ndev);
 	const struct sir_driver *drv = dev->drv;
 
 	if (!drv)
@@ -839,7 +839,7 @@ errout_dec:
 
 static int sirdev_close(struct net_device *ndev)
 {
-	struct sir_dev *dev = ndev->priv;
+	struct sir_dev *dev = netdev_priv(ndev);
 	const struct sir_driver *drv;
 
 //	IRDA_DEBUG(0, "%s\n", __FUNCTION__);
@@ -895,7 +895,7 @@ struct sir_dev * sirdev_get_instance(con
 		IRDA_ERROR("%s - Can't allocate memory for IrDA control block!\n", __FUNCTION__);
 		goto out;
 	}
-	dev = ndev->priv;
+	dev = netdev_priv(ndev);
 
 	irda_init_max_qos_capabilies(&dev->qos);
 	dev->qos.baud_rate.bits = IR_9600|IR_19200|IR_38400|IR_57600|IR_115200;
diff --git a/drivers/net/irda/via-ircc.c b/drivers/net/irda/via-ircc.c
index ff53585..6e09706 100644
--- a/drivers/net/irda/via-ircc.c
+++ b/drivers/net/irda/via-ircc.c
@@ -334,7 +334,7 @@ static __devinit int via_ircc_open(int i
 	if (dev == NULL) 
 		return -ENOMEM;
 
-	self = dev->priv;
+	self = netdev_priv(dev);
 	self->netdev = dev;
 	spin_lock_init(&self->lock);
 
@@ -827,7 +827,7 @@ static int via_ircc_hard_xmit_sir(struct
 	u16 iobase;
 	__u32 speed;
 
-	self = (struct via_ircc_cb *) dev->priv;
+	self = netdev_priv(dev);
 	IRDA_ASSERT(self != NULL, return 0;);
 	iobase = self->io.fir_base;
 
@@ -899,7 +899,7 @@ static int via_ircc_hard_xmit_fir(struct
 	__u32 speed;
 	unsigned long flags;
 
-	self = (struct via_ircc_cb *) dev->priv;
+	self = netdev_priv(dev);
 	iobase = self->io.fir_base;
 
 	if (self->st_fifo.len)
@@ -1361,7 +1361,7 @@ static irqreturn_t via_ircc_interrupt(in
 			     irq);
 		return IRQ_NONE;
 	}
-	self = (struct via_ircc_cb *) dev->priv;
+	self = netdev_priv(dev);
 	iobase = self->io.fir_base;
 	spin_lock(&self->lock);
 	iHostIntType = GetHostStatus(iobase);
@@ -1531,7 +1531,7 @@ static int via_ircc_net_open(struct net_
 	IRDA_DEBUG(3, "%s()\n", __FUNCTION__);
 
 	IRDA_ASSERT(dev != NULL, return -1;);
-	self = (struct via_ircc_cb *) dev->priv;
+	self = netdev_priv(dev);
 	self->stats.rx_packets = 0;
 	IRDA_ASSERT(self != NULL, return 0;);
 	iobase = self->io.fir_base;
@@ -1597,7 +1597,7 @@ static int via_ircc_net_close(struct net
 	IRDA_DEBUG(3, "%s()\n", __FUNCTION__);
 
 	IRDA_ASSERT(dev != NULL, return -1;);
-	self = (struct via_ircc_cb *) dev->priv;
+	self = netdev_priv(dev);
 	IRDA_ASSERT(self != NULL, return 0;);
 
 	/* Stop device */
@@ -1634,7 +1634,7 @@ static int via_ircc_net_ioctl(struct net
 	int ret = 0;
 
 	IRDA_ASSERT(dev != NULL, return -1;);
-	self = dev->priv;
+	self = netdev_priv(dev);
 	IRDA_ASSERT(self != NULL, return -1;);
 	IRDA_DEBUG(1, "%s(), %s, (cmd=0x%X)\n", __FUNCTION__, dev->name,
 		   cmd);
@@ -1669,7 +1669,7 @@ static int via_ircc_net_ioctl(struct net
 static struct net_device_stats *via_ircc_net_get_stats(struct net_device
 						       *dev)
 {
-	struct via_ircc_cb *self = (struct via_ircc_cb *) dev->priv;
+	struct via_ircc_cb *self = netdev_priv(dev);
 
 	return &self->stats;
 }
diff --git a/drivers/net/irda/vlsi_ir.c b/drivers/net/irda/vlsi_ir.c
index 0538ca9..4f9fa4a 100644
--- a/drivers/net/irda/vlsi_ir.c
+++ b/drivers/net/irda/vlsi_ir.c
@@ -178,7 +178,7 @@ static void vlsi_proc_pdev(struct seq_fi
 		
 static void vlsi_proc_ndev(struct seq_file *seq, struct net_device *ndev)
 {
-	vlsi_irda_dev_t *idev = ndev->priv;
+	vlsi_irda_dev_t *idev = netdev_priv(ndev);
 	u8 byte;
 	u16 word;
 	unsigned delta1, delta2;
@@ -346,7 +346,7 @@ static void vlsi_proc_ring(struct seq_fi
 static int vlsi_seq_show(struct seq_file *seq, void *v)
 {
 	struct net_device *ndev = seq->private;
-	vlsi_irda_dev_t *idev = ndev->priv;
+	vlsi_irda_dev_t *idev = netdev_priv(ndev);
 	unsigned long flags;
 
 	seq_printf(seq, "\n%s %s\n\n", DRIVER_NAME, DRIVER_VERSION);
@@ -543,7 +543,7 @@ static int vlsi_process_rx(struct vlsi_r
 	struct sk_buff	*skb;
 	int		ret = 0;
 	struct net_device *ndev = (struct net_device *)pci_get_drvdata(r->pdev);
-	vlsi_irda_dev_t *idev = ndev->priv;
+	vlsi_irda_dev_t *idev = netdev_priv(ndev);
 
 	pci_dma_sync_single_for_cpu(r->pdev, rd_get_addr(rd), r->len, r->dir);
 	/* dma buffer now owned by the CPU */
@@ -638,7 +638,7 @@ static void vlsi_fill_rx(struct vlsi_rin
 
 static void vlsi_rx_interrupt(struct net_device *ndev)
 {
-	vlsi_irda_dev_t *idev = ndev->priv;
+	vlsi_irda_dev_t *idev = netdev_priv(ndev);
 	struct vlsi_ring *r = idev->rx_ring;
 	struct ring_descr *rd;
 	int ret;
@@ -856,7 +856,7 @@ static int vlsi_set_baud(vlsi_irda_dev_t
 
 static int vlsi_hard_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
-	vlsi_irda_dev_t *idev = ndev->priv;
+	vlsi_irda_dev_t *idev = netdev_priv(ndev);
 	struct vlsi_ring	*r = idev->tx_ring;
 	struct ring_descr *rd;
 	unsigned long flags;
@@ -1063,7 +1063,7 @@ drop:
 
 static void vlsi_tx_interrupt(struct net_device *ndev)
 {
-	vlsi_irda_dev_t *idev = ndev->priv;
+	vlsi_irda_dev_t *idev = netdev_priv(ndev);
 	struct vlsi_ring	*r = idev->tx_ring;
 	struct ring_descr	*rd;
 	unsigned	iobase;
@@ -1262,7 +1262,7 @@ static inline void vlsi_clear_regs(unsig
 static int vlsi_init_chip(struct pci_dev *pdev)
 {
 	struct net_device *ndev = pci_get_drvdata(pdev);
-	vlsi_irda_dev_t *idev = ndev->priv;
+	vlsi_irda_dev_t *idev = netdev_priv(ndev);
 	unsigned	iobase;
 	u16 ptr;
 
@@ -1376,14 +1376,14 @@ static int vlsi_stop_hw(vlsi_irda_dev_t 
 
 static struct net_device_stats * vlsi_get_stats(struct net_device *ndev)
 {
-	vlsi_irda_dev_t *idev = ndev->priv;
+	vlsi_irda_dev_t *idev = netdev_priv(ndev);
 
 	return &idev->stats;
 }
 
 static void vlsi_tx_timeout(struct net_device *ndev)
 {
-	vlsi_irda_dev_t *idev = ndev->priv;
+	vlsi_irda_dev_t *idev = netdev_priv(ndev);
 
 
 	vlsi_reg_debug(ndev->base_addr, __FUNCTION__);
@@ -1408,7 +1408,7 @@ static void vlsi_tx_timeout(struct net_d
 
 static int vlsi_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
 {
-	vlsi_irda_dev_t *idev = ndev->priv;
+	vlsi_irda_dev_t *idev = netdev_priv(ndev);
 	struct if_irda_req *irq = (struct if_irda_req *) rq;
 	unsigned long flags;
 	u16 fifocnt;
@@ -1458,7 +1458,7 @@ static int vlsi_ioctl(struct net_device 
 static irqreturn_t vlsi_interrupt(int irq, void *dev_instance)
 {
 	struct net_device *ndev = dev_instance;
-	vlsi_irda_dev_t *idev = ndev->priv;
+	vlsi_irda_dev_t *idev = netdev_priv(ndev);
 	unsigned	iobase;
 	u8		irintr;
 	int 		boguscount = 5;
@@ -1499,7 +1499,7 @@ static irqreturn_t vlsi_interrupt(int ir
 
 static int vlsi_open(struct net_device *ndev)
 {
-	vlsi_irda_dev_t *idev = ndev->priv;
+	vlsi_irda_dev_t *idev = netdev_priv(ndev);
 	int	err = -EAGAIN;
 	char	hwname[32];
 
@@ -1558,7 +1558,7 @@ errout:
 
 static int vlsi_close(struct net_device *ndev)
 {
-	vlsi_irda_dev_t *idev = ndev->priv;
+	vlsi_irda_dev_t *idev = netdev_priv(ndev);
 
 	netif_stop_queue(ndev);
 
@@ -1581,7 +1581,7 @@ static int vlsi_close(struct net_device 
 
 static int vlsi_irda_init(struct net_device *ndev)
 {
-	vlsi_irda_dev_t *idev = ndev->priv;
+	vlsi_irda_dev_t *idev = netdev_priv(ndev);
 	struct pci_dev *pdev = idev->pdev;
 
 	SET_MODULE_OWNER(ndev);
@@ -1658,7 +1658,7 @@ vlsi_irda_probe(struct pci_dev *pdev, co
 		goto out_disable;
 	}
 
-	idev = ndev->priv;
+	idev = netdev_priv(ndev);
 
 	spin_lock_init(&idev->lock);
 	mutex_init(&idev->mtx);
@@ -1716,7 +1716,7 @@ static void __devexit vlsi_irda_remove(s
 
 	unregister_netdev(ndev);
 
-	idev = ndev->priv;
+	idev = netdev_priv(ndev);
 	mutex_lock(&idev->mtx);
 	if (idev->proc_entry) {
 		remove_proc_entry(ndev->name, vlsi_proc_root);
@@ -1751,7 +1751,7 @@ static int vlsi_irda_suspend(struct pci_
 			   __FUNCTION__, pci_name(pdev));
 		return 0;
 	}
-	idev = ndev->priv;	
+	idev = netdev_priv(ndev);	
 	mutex_lock(&idev->mtx);
 	if (pdev->current_state != 0) {			/* already suspended */
 		if (state.event > pdev->current_state) {	/* simply go deeper */
@@ -1790,7 +1790,7 @@ static int vlsi_irda_resume(struct pci_d
 			   __FUNCTION__, pci_name(pdev));
 		return 0;
 	}
-	idev = ndev->priv;	
+	idev = netdev_priv(ndev);	
 	mutex_lock(&idev->mtx);
 	if (pdev->current_state == 0) {
 		mutex_unlock(&idev->mtx);
diff --git a/drivers/net/irda/w83977af_ir.c b/drivers/net/irda/w83977af_ir.c
index 5182e80..51f645f 100644
--- a/drivers/net/irda/w83977af_ir.c
+++ b/drivers/net/irda/w83977af_ir.c
@@ -178,7 +178,7 @@ int w83977af_open(int i, unsigned int io
 		goto err_out;
 	}
 
-	self = dev->priv;
+	self = netdev_priv(dev);
 	spin_lock_init(&self->lock);
    
 
@@ -500,7 +500,7 @@ int w83977af_hard_xmit(struct sk_buff *s
 	__u8 set;
 	int mtt;
 	
-	self = (struct w83977af_ir *) dev->priv;
+	self = netdev_priv(dev);
 
 	iobase = self->io.fir_base;
 
@@ -1122,7 +1122,7 @@ static irqreturn_t w83977af_interrupt(in
 	__u8 set, icr, isr;
 	int iobase;
 
-	self = dev->priv;
+	self = netdev_priv(dev);
 
 	iobase = self->io.fir_base;
 
@@ -1195,7 +1195,7 @@ static int w83977af_net_open(struct net_
 	IRDA_DEBUG(0, "%s()\n", __FUNCTION__ );
 	
 	IRDA_ASSERT(dev != NULL, return -1;);
-	self = (struct w83977af_ir *) dev->priv;
+	self = netdev_priv(dev);
 	
 	IRDA_ASSERT(self != NULL, return 0;);
 	
@@ -1259,7 +1259,7 @@ static int w83977af_net_close(struct net
 
 	IRDA_ASSERT(dev != NULL, return -1;);
 	
-	self = (struct w83977af_ir *) dev->priv;
+	self = netdev_priv(dev);
 	
 	IRDA_ASSERT(self != NULL, return 0;);
 	
@@ -1306,7 +1306,7 @@ static int w83977af_net_ioctl(struct net
 
 	IRDA_ASSERT(dev != NULL, return -1;);
 
-	self = dev->priv;
+	self = netdev_priv(dev);
 
 	IRDA_ASSERT(self != NULL, return -1;);
 
@@ -1342,7 +1342,7 @@ out:
 
 static struct net_device_stats *w83977af_net_get_stats(struct net_device *dev)
 {
-	struct w83977af_ir *self = (struct w83977af_ir *) dev->priv;
+	struct w83977af_ir *self = netdev_priv(dev);
 	
 	return &self->stats;
 }


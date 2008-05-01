Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbYEAEJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbYEAEJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 00:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbYEAEJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 00:09:14 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:50583 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751173AbYEAEJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 00:09:14 -0400
Date: Thu, 1 May 2008 14:08:12 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200805010408.m4148Cp0004875@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: fix FEC driver locking
Cc: akpm@linux-foundation.org, gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Siewior <bigeasy@linutronix.de>

It's easy: grab locks before talking to hardware and realease
them afterwards. The one big lock has been splitted into a hw_lock
and mii_lock.

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.25/drivers/net/fec.c linux-2.6.25-uc0/drivers/net/fec.c
--- linux-2.6.25/drivers/net/fec.c	2008-04-17 12:49:44.000000000 +1000
+++ linux-2.6.25-uc0/drivers/net/fec.c	2008-04-30 13:39:06.000000000 +1000
@@ -209,7 +209,10 @@ struct fec_enet_private {
 	cbd_t	*cur_rx, *cur_tx;		/* The next free ring entry */
 	cbd_t	*dirty_tx;	/* The ring entries to be free()ed. */
 	uint	tx_full;
-	spinlock_t lock;
+	/* hold while accessing the HW like ringbuffer for tx/rx but not MAC */
+	spinlock_t hw_lock;
+	/* hold while accessing the mii_list_t() elements */
+	spinlock_t mii_lock;
 
 	uint	phy_id;
 	uint	phy_id_done;
@@ -313,6 +316,7 @@ fec_enet_start_xmit(struct sk_buff *skb,
 	volatile fec_t	*fecp;
 	volatile cbd_t	*bdp;
 	unsigned short	status;
+	unsigned long flags;
 
 	fep = netdev_priv(dev);
 	fecp = (volatile fec_t*)dev->base_addr;
@@ -322,6 +326,7 @@ fec_enet_start_xmit(struct sk_buff *skb,
 		return 1;
 	}
 
+	spin_lock_irqsave(&fep->hw_lock, flags);
 	/* Fill in a Tx ring entry */
 	bdp = fep->cur_tx;
 
@@ -332,6 +337,7 @@ fec_enet_start_xmit(struct sk_buff *skb,
 		 * This should not happen, since dev->tbusy should be set.
 		 */
 		printk("%s: tx queue full!.\n", dev->name);
+		spin_unlock_irqrestore(&fep->hw_lock, flags);
 		return 1;
 	}
 #endif
@@ -370,8 +376,6 @@ fec_enet_start_xmit(struct sk_buff *skb,
 	flush_dcache_range((unsigned long)skb->data,
 			   (unsigned long)skb->data + skb->len);
 
-	spin_lock_irq(&fep->lock);
-
 	/* Send it on its way.  Tell FEC it's ready, interrupt when done,
 	 * it's the last BD of the frame, and to put the CRC on the end.
 	 */
@@ -400,7 +404,7 @@ fec_enet_start_xmit(struct sk_buff *skb,
 
 	fep->cur_tx = (cbd_t *)bdp;
 
-	spin_unlock_irq(&fep->lock);
+	spin_unlock_irqrestore(&fep->hw_lock, flags);
 
 	return 0;
 }
@@ -458,19 +462,20 @@ fec_enet_interrupt(int irq, void * dev_i
 	struct	net_device *dev = dev_id;
 	volatile fec_t	*fecp;
 	uint	int_events;
-	int handled = 0;
+	irqreturn_t ret = IRQ_NONE;
 
 	fecp = (volatile fec_t*)dev->base_addr;
 
 	/* Get the interrupt events that caused us to be here.
 	*/
-	while ((int_events = fecp->fec_ievent) != 0) {
+	do {
+		int_events = fecp->fec_ievent;
 		fecp->fec_ievent = int_events;
 
 		/* Handle receive event in its own function.
 		 */
 		if (int_events & FEC_ENET_RXF) {
-			handled = 1;
+			ret = IRQ_HANDLED;
 			fec_enet_rx(dev);
 		}
 
@@ -479,17 +484,18 @@ fec_enet_interrupt(int irq, void * dev_i
 		   them as part of the transmit process.
 		*/
 		if (int_events & FEC_ENET_TXF) {
-			handled = 1;
+			ret = IRQ_HANDLED;
 			fec_enet_tx(dev);
 		}
 
 		if (int_events & FEC_ENET_MII) {
-			handled = 1;
+			ret = IRQ_HANDLED;
 			fec_enet_mii(dev);
 		}
 
-	}
-	return IRQ_RETVAL(handled);
+	} while (int_events);
+
+	return ret;
 }
 
 
@@ -502,7 +508,7 @@ fec_enet_tx(struct net_device *dev)
 	struct	sk_buff	*skb;
 
 	fep = netdev_priv(dev);
-	spin_lock(&fep->lock);
+	spin_lock_irq(&fep->hw_lock);
 	bdp = fep->dirty_tx;
 
 	while (((status = bdp->cbd_sc) & BD_ENET_TX_READY) == 0) {
@@ -561,7 +567,7 @@ fec_enet_tx(struct net_device *dev)
 		}
 	}
 	fep->dirty_tx = (cbd_t *)bdp;
-	spin_unlock(&fep->lock);
+	spin_unlock_irq(&fep->hw_lock);
 }
 
 
@@ -588,6 +594,8 @@ fec_enet_rx(struct net_device *dev)
 	fep = netdev_priv(dev);
 	fecp = (volatile fec_t*)dev->base_addr;
 
+	spin_lock_irq(&fep->hw_lock);
+
 	/* First, grab all of the stats for the incoming packet.
 	 * These get messed up if we get called due to a busy condition.
 	 */
@@ -693,6 +701,8 @@ while (!((status = bdp->cbd_sc) & BD_ENE
 	 */
 	fecp->fec_r_des_active = 0;
 #endif
+
+	spin_unlock_irq(&fep->hw_lock);
 }
 
 
@@ -706,11 +716,11 @@ fec_enet_mii(struct net_device *dev)
 	uint		mii_reg;
 
 	fep = netdev_priv(dev);
+	spin_lock_irq(&fep->mii_lock);
+
 	ep = fep->hwp;
 	mii_reg = ep->fec_mii_data;
 
-	spin_lock(&fep->lock);
-
 	if ((mip = mii_head) == NULL) {
 		printk("MII and no head!\n");
 		goto unlock;
@@ -727,7 +737,7 @@ fec_enet_mii(struct net_device *dev)
 		ep->fec_mii_data = mip->mii_regval;
 
 unlock:
-	spin_unlock(&fep->lock);
+	spin_unlock_irq(&fep->mii_lock);
 }
 
 static int
@@ -741,12 +751,11 @@ mii_queue(struct net_device *dev, int re
 	/* Add PHY address to register command.
 	*/
 	fep = netdev_priv(dev);
-	regval |= fep->phy_addr << 23;
+	spin_lock_irqsave(&fep->mii_lock, flags);
 
+	regval |= fep->phy_addr << 23;
 	retval = 0;
 
-	spin_lock_irqsave(&fep->lock,flags);
-
 	if ((mip = mii_free) != NULL) {
 		mii_free = mip->mii_next;
 		mip->mii_regval = regval;
@@ -763,9 +772,8 @@ mii_queue(struct net_device *dev, int re
 		retval = 1;
 	}
 
-	spin_unlock_irqrestore(&fep->lock,flags);
-
-	return(retval);
+	spin_unlock_irqrestore(&fep->mii_lock, flags);
+	return retval;
 }
 
 static void mii_do_cmd(struct net_device *dev, const phy_cmd_t *c)
@@ -2308,6 +2316,9 @@ int __init fec_enet_init(struct net_devi
 		return -ENOMEM;
 	}
 
+	spin_lock_init(&fep->hw_lock);
+	spin_lock_init(&fep->mii_lock);
+
 	/* Create an Ethernet device instance.
 	*/
 	fecp = (volatile fec_t *) fec_hw[index];

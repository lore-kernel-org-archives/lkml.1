Return-Path: <linux-kernel-owner+w=401wt.eu-S1030888AbXCNUIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030888AbXCNUIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030884AbXCNUIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:08:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3939 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030885AbXCNUIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:08:09 -0400
Message-Id: <20070314195157.395275000@sirena.org.uk>
References: <20070314194912.414925000@sirena.org.uk>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 19:49:14 +0000
From: broonie@sirena.org.uk
To: Jeff Garzik <jeff@garzik.org>, Tim Hockin <thockin@hockin.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Simon Blake <simon@citylink.co.nz>
Subject: [patch 2/3] natsemi: Fix NAPI for interrupt sharing
Content-Disposition: inline; filename=natsemi-fix-napi-shared-interrupt
X-Spam-Score: -2.8 (--)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt status register for the natsemi chips is clear on read and
was read unconditionally from both the interrupt and from the NAPI poll
routine, meaning that if the interrupt service routine was called (for 
example, due to a shared interrupt) while a NAPI poll was scheduled
interrupts could be missed.  This patch fixes that by ensuring that the
interrupt status register is only read by the interrupt handler when
interrupts are enabled from the chip.

It also reverts a workaround for this problem from the netpoll hook and
improves the trace for interrupt events.

Thanks to Sergei Shtylyov <sshtylyov@ru.mvista.com> for spotting the
issue, Mark Huth <mhuth@mvista.com> for a simpler method and Simon
Blake <simon@citylink.co.nz> for testing resources.

Signed-Off-By: Mark Brown <broonie@sirena.org.uk>

Index: linux-2.6/drivers/net/natsemi.c
===================================================================
--- linux-2.6.orig/drivers/net/natsemi.c	2007-03-11 02:32:43.000000000 +0000
+++ linux-2.6/drivers/net/natsemi.c	2007-03-13 19:38:31.000000000 +0000
@@ -2119,28 +2119,35 @@
 	struct netdev_private *np = netdev_priv(dev);
 	void __iomem * ioaddr = ns_ioaddr(dev);
 
-	if (np->hands_off)
+	/* Reading IntrStatus automatically acknowledges so don't do
+	 * that while interrupts are disabled, (for example, while a
+	 * poll is scheduled).  */
+	if (np->hands_off || !readl(ioaddr + IntrEnable))
 		return IRQ_NONE;
 
-	/* Reading automatically acknowledges. */
 	np->intr_status = readl(ioaddr + IntrStatus);
 
+	if (!np->intr_status)
+		return IRQ_NONE;
+
 	if (netif_msg_intr(np))
 		printk(KERN_DEBUG
 		       "%s: Interrupt, status %#08x, mask %#08x.\n",
 		       dev->name, np->intr_status,
 		       readl(ioaddr + IntrMask));
 
-	if (!np->intr_status)
-		return IRQ_NONE;
-
 	prefetch(&np->rx_skbuff[np->cur_rx % RX_RING_SIZE]);
 
 	if (netif_rx_schedule_prep(dev)) {
 		/* Disable interrupts and register for poll */
 		natsemi_irq_disable(dev);
 		__netif_rx_schedule(dev);
-	}
+	} else
+		printk(KERN_WARNING
+	       	       "%s: Ignoring interrupt, status %#08x, mask %#08x.\n",
+		       dev->name, np->intr_status,
+		       readl(ioaddr + IntrMask));
+
 	return IRQ_HANDLED;
 }
 
@@ -2156,6 +2163,12 @@
 	int work_done = 0;
 
 	do {
+		if (netif_msg_intr(np))
+			printk(KERN_DEBUG
+			       "%s: Poll, status %#08x, mask %#08x.\n",
+			       dev->name, np->intr_status,
+			       readl(ioaddr + IntrMask));
+
 		if (np->intr_status &
 		    (IntrTxDone | IntrTxIntr | IntrTxIdle | IntrTxErr)) {
 			spin_lock(&np->lock);
@@ -2399,19 +2412,8 @@
 #ifdef CONFIG_NET_POLL_CONTROLLER
 static void natsemi_poll_controller(struct net_device *dev)
 {
-	struct netdev_private *np = netdev_priv(dev);
-
 	disable_irq(dev->irq);
-
-	/*
-	 * A real interrupt might have already reached us at this point
-	 * but NAPI might still haven't called us back.  As the interrupt
-	 * status register is cleared by reading, we should prevent an
-	 * interrupt loss in this case...
-	 */
-	if (!np->intr_status)
-		intr_handler(dev->irq, dev);
-
+	intr_handler(dev->irq, dev);
 	enable_irq(dev->irq);
 }
 #endif

--
"You grabbed my hand and we fell into it, like a daydream - or a fever."

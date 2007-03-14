Return-Path: <linux-kernel-owner+w=401wt.eu-S1030881AbXCNUI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030881AbXCNUI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030882AbXCNUI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:08:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3954 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030881AbXCNUIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:08:55 -0400
Message-Id: <20070314195156.690711000@sirena.org.uk>
References: <20070314194912.414925000@sirena.org.uk>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 19:49:13 +0000
From: broonie@sirena.org.uk
To: Jeff Garzik <jeff@garzik.org>, Tim Hockin <thockin@hockin.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 1/3] natsemi: Consistently use interrupt enable/disable functions
Content-Disposition: inline; filename=natsemi-consistent-irq-enable
X-Spam-Score: -2.8 (--)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The natsemi drivers include functions for enabling and disabling
interrupts from the chip but these are not used in all code paths.  This
patch changes the code paths that touch the interrupt enable register to
use the functions.  In all cases this adds an extra PCI read to post the
operation but since none of these are in fast paths this shouldn't be
too much of a problem.

Signed-Off-By: Mark Brown <broonie@sirena.org.uk>
Index: linux-2.6/drivers/net/natsemi.c
===================================================================
--- linux-2.6.orig/drivers/net/natsemi.c	2007-03-11 02:27:34.000000000 +0000
+++ linux-2.6/drivers/net/natsemi.c	2007-03-11 02:32:43.000000000 +0000
@@ -1712,7 +1712,7 @@
 
 	/* Enable interrupts by setting the interrupt mask. */
 	writel(DEFAULT_INTR, ioaddr + IntrMask);
-	writel(1, ioaddr + IntrEnable);
+	natsemi_irq_enable(dev);
 
 	writel(RxOn | TxOn, ioaddr + ChipCmd);
 	writel(StatsClear, ioaddr + StatsCtrl); /* Clear Stats */
@@ -3071,7 +3071,7 @@
 		 * Could be used to send a netlink message.
 		 */
 		writel(WOLPkt | LinkChange, ioaddr + IntrMask);
-		writel(1, ioaddr + IntrEnable);
+		natsemi_irq_enable(dev);
 	}
 }
 
@@ -3202,7 +3202,7 @@
 		disable_irq(dev->irq);
 		spin_lock_irq(&np->lock);
 
-		writel(0, ioaddr + IntrEnable);
+		natsemi_irq_disable(dev);
 		np->hands_off = 1;
 		natsemi_stop_rxtx(dev);
 		netif_stop_queue(dev);

--
"You grabbed my hand and we fell into it, like a daydream - or a fever."

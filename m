Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbYCaXW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbYCaXW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 19:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYCaXWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 19:22:47 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:57314 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYCaXWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 19:22:46 -0400
Date: Tue, 1 Apr 2008 01:22:45 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] plip: replace spin_lock_irq with spin_lock_irqsave in irq
 context
Message-ID: <Pine.LNX.4.64.0804010113040.29068@artax.karlin.mff.cuni.cz>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Plip uses spin_lock_irq/spin_unlock_irq in its IRQ handler (called from 
parport IRQ handler), the latter enables interrupts without parport 
subsystem IRQ handler expecting it.

The bug can be seen if you compile kernel with lock dependency checking 
and use plip --- it produces a warning.

This patch changes it to spin_lock_irqsave/spin_lock_irqrestore, so that 
it doesn't enable interrupts when already disabled.

Mikulas

--- linux-2.6.24.4/drivers/net/plip.c_	2008-03-31 23:47:27.000000000 +0200
+++ linux-2.6.24.4/drivers/net/plip.c	2008-03-31 23:48:06.000000000 +0200
@@ -903,17 +903,18 @@ plip_interrupt(void *dev_id)
 	struct net_local *nl;
 	struct plip_local *rcv;
 	unsigned char c0;
+	unsigned long flags;
 
 	nl = netdev_priv(dev);
 	rcv = &nl->rcv_data;
 
-	spin_lock_irq (&nl->lock);
+	spin_lock_irqsave (&nl->lock, flags);
 
 	c0 = read_status(dev);
 	if ((c0 & 0xf8) != 0xc0) {
 		if ((dev->irq != -1) && (net_debug > 1))
 			printk(KERN_DEBUG "%s: spurious interrupt\n", dev->name);
-		spin_unlock_irq (&nl->lock);
+		spin_unlock_irqrestore (&nl->lock, flags);
 		return;
 	}
 
@@ -942,7 +943,7 @@ plip_interrupt(void *dev_id)
 		break;
 	}
 
-	spin_unlock_irq(&nl->lock);
+	spin_unlock_irqrestore(&nl->lock, flags);
 }
 
 static int

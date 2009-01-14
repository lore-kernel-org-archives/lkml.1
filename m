Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbZANHsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbZANHsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 02:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZANHsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 02:48:06 -0500
Received: from mail.konftel.com ([83.68.233.85]:22009 "EHLO mail.konftel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbZANHsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 02:48:04 -0500
Subject: Re: [PATCH] macb: RLE and BNA handling
From: Erik Waling <erik.waling@konftel.se>
To: "hskinnemoen@atmel.com" <hskinnemoen@atmel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1231863713.10152.11.camel@konftel>
References: <1231863713.10152.11.camel@konftel>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 08:47:52 +0100
Message-ID: <1231919272.10152.21.camel@konftel>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1027-16400.005
X-TM-AS-Result: No--3.233700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Woops, just realized that the tabs in my previous post might have been
messed up. One more try...

Signed-off-by: Erik Waling <erik.waling@konftel.com>

---

diff -urpN linux-2.6.28.orig/drivers/net/macb.c linux-2.6.28.rle_and_bna_fix/drivers/net/macb.c
--- linux-2.6.28.orig/drivers/net/macb.c	2009-01-13 10:36:13.000000000 +0100
+++ linux-2.6.28.rle_and_bna_fix/drivers/net/macb.c	2009-01-13 16:50:34.000000000 +0100
@@ -2,6 +2,7 @@
  * Atmel MACB Ethernet Controller driver
  *
  * Copyright (C) 2004-2006 Atmel Corporation
+ * Copyright (C) 2008-2009 Konftel AB
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -316,10 +317,11 @@ static void macb_tx(struct macb *bp)
 	dev_dbg(&bp->pdev->dev, "macb_tx status = %02lx\n",
 		(unsigned long)status);
 
-	if (status & MACB_BIT(UND)) {
+	if (status & (MACB_BIT(UND) | MACB_BIT(TSR_RLE))) {
 		int i;
-		printk(KERN_ERR "%s: TX underrun, resetting buffers\n",
-			bp->dev->name);
+		printk(KERN_ERR "%s: TX %s, resetting buffers\n",
+			bp->dev->name, status & MACB_BIT(UND) ? 
+			"underrun" : "retry limit exceeded");
 
 		head = bp->tx_head;
 
@@ -527,18 +529,31 @@ static int macb_poll(struct napi_struct 
 	dev_dbg(&bp->pdev->dev, "poll: status = %08lx, budget = %d\n",
 		(unsigned long)status, budget);
 
-	if (!(status & MACB_BIT(REC))) {
+	if (status & MACB_BIT(REC)) {
+		work_done = macb_rx(bp, budget);
+		if (work_done < budget)
+			netif_rx_complete(dev, napi);
+	} else if (status & MACB_BIT(BNA)) {
+		/* No slots available in RX ring. Mark all slots
+		 * as unused.
+		 */
+		int i;
+
+		dev_warn(&bp->pdev->dev, 
+				"No free RX buffers. Marking all as unused.\n");
+
+		for (i = 0; i < RX_RING_SIZE; i++) 
+			bp->rx_ring[i].addr &= ~MACB_BIT(RX_USED);
+		
+		wmb();
+		netif_rx_complete(dev, napi);
+	} else if (!(status & MACB_BIT(REC))) {
 		dev_warn(&bp->pdev->dev,
 			 "No RX buffers complete, status = %02lx\n",
 			 (unsigned long)status);
 		netif_rx_complete(dev, napi);
-		goto out;
 	}
 
-	work_done = macb_rx(bp, budget);
-	if (work_done < budget)
-		netif_rx_complete(dev, napi);
-
 	/*
 	 * We've done what we can to clean the buffers. Make sure we
 	 * get notified when new packets arrive.
@@ -584,7 +599,8 @@ static irqreturn_t macb_interrupt(int ir
 			}
 		}
 
-		if (status & (MACB_BIT(TCOMP) | MACB_BIT(ISR_TUND)))
+		if (status & (MACB_BIT(TCOMP) | MACB_BIT(ISR_TUND) | 
+                            MACB_BIT(ISR_RLE)))
 			macb_tx(bp);
 
 		/*



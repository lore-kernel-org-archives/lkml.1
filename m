Return-Path: <linux-kernel-owner+w=401wt.eu-S1764962AbZAONiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764962AbZAONiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757204AbZAONiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:38:09 -0500
Received: from mail.konftel.com ([83.68.233.85]:27961 "EHLO mail.konftel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434AbZAONiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:38:07 -0500
Subject: Re: [PATCH] macb: RLE and BNA handling
From: Erik Waling <erik.waling@konftel.se>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090114130322.483a7830@hskinnemoen-d830>
References: <1231863713.10152.11.camel@konftel>
	 <20090114111505.48d34949@hskinnemoen-d830>
	 <1231928868.10152.31.camel@konftel>
	 <20090114130322.483a7830@hskinnemoen-d830>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 14:37:50 +0100
Message-ID: <1232026671.10152.52.camel@konftel>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1027-16402.007
X-TM-AS-Result: No--28.836700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 13:03 +0100, Haavard Skinnemoen wrote:

[...]

> >
> > This was the only solution I could think of since all slots are marked
> > as used and we are not able to assemble a complete frame. Do you think
> > there is a better solution?
> 
> No, I guess that might be a good fallback solution if we really can't
> seem to make any progress...
> 
> However, I'm wondering if there might be a different bug in the code
> above: Suppose that we receive lots of frames, start processing them,
> but exhaust our budget so that we return before we had a chance to look
> at all of them.

True. That could probably happen.

> Then, when the network layer calls us again, we will only continue
> processing the buffers if the REC bit was set in the mean time, which
> it might not be if there was a brief pause in the flow of packets. If
> this happens, we'll simply display a warning and call
> netif_rx_complete() with potentially lots of unprocessed packets in the
> RX ring...
> 
> So I'm wondering if the right thing to do is to just call macb_rx()
> regardless of the state of the REC bit. If it exhausts the budget, and
> the BNA bit is set, we could flush the ring in order to sort of relieve
> the pressure a bit...

I agree. The best solution would probably be one that does not depend on
the REC bit.

I did some quick tests and modified macb_poll() so that it calls
macb_rx() before anything else is checked. When macb_rx() returns the
poll routine checks if the BNA bit was set in RSR. If that is the case
and macb_rx() was not able to process any complete frames we flush the
whole ring. In the case were we manage to process at least one frame and
BNA is set we just clear the bit without flushing the ring since the
processed frame(s) will leave one or more empty slots in the ring. 

I also had to modify macb_rx() slightly since we, after a buffer flush,
might receive an EOF fragment before any SOF frags are received (the
case were we received the SOF and then flushed the buffer). 

In order to test this quickly I changed the size of the RX ring to 16
slots since it is quite hard to reproduce the BNA issue using the
standard size of 512.

I have been testing (by constant bi-directional transfer) for an hour or
so and the driver always seems recover after BNA. Anyway, I think the
BNA part of this patch needs some more review and testing before even
thinking about sending it upstream.

> Btw, I suspect you'll need to update rx_tail when you do that, or it
> might not point to where the next used buffer will be.

Are you sure rx_tail needs updating? If I understand the specs correctly
the EMAC module will continue writing to the address currently stored in
RBQP. This address should be the same as before the flush (if no new
fragments has been recvd). Right?

> Haavard

Erik


Signed-off-by: Erik Waling <erik.waling@konftel.com>


---

diff -urpN linux-2.6.28.orig/drivers/net/macb.c linux-2.6.28.rle_and_bna_fix/drivers/net/macb.c
--- linux-2.6.28.orig/drivers/net/macb.c	2009-01-13 10:36:13.000000000 +0100
+++ linux-2.6.28.rle_and_bna_fix/drivers/net/macb.c	2009-01-15 14:23:52.000000000 +0100
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
 
@@ -484,13 +486,28 @@ static int macb_rx(struct macb *bp, int 
 
 		if (ctrl & MACB_BIT(RX_EOF)) {
 			int dropped;
-			BUG_ON(first_frag == -1);
-
-			dropped = macb_rx_frame(bp, first_frag, tail);
-			first_frag = -1;
-			if (!dropped) {
-				received++;
-				budget--;
+			if (first_frag != -1) {
+				dropped = macb_rx_frame(bp, first_frag, tail);
+				first_frag = -1;
+				
+				if (!dropped) {
+					received++;
+					budget--;
+				}
+			} else {
+				/* We might end up here if we previously
+				 * flushed the RX buffer ring because of 
+				 * no available buffers.
+				 */
+				printk(KERN_INFO 
+					"%s: Found EOF frag without any "
+					"previous SOF frag. Discarding "
+					"everything up until EOF.\n",
+					bp->dev->name);
+				/* This might also "discard" a couple of 
+				 * fragments that are already marked as unused.
+				 */
+				discard_partial_frame(bp, bp->rx_tail, tail);
 			}
 		}
 	}
@@ -514,28 +531,39 @@ static int macb_poll(struct napi_struct 
 	macb_writel(bp, RSR, status);
 
 	work_done = 0;
-	if (!status) {
-		/*
-		 * This may happen if an interrupt was pending before
-		 * this function was called last time, and no packets
-		 * have been received since.
-		 */
-		netif_rx_complete(dev, napi);
-		goto out;
-	}
 
 	dev_dbg(&bp->pdev->dev, "poll: status = %08lx, budget = %d\n",
 		(unsigned long)status, budget);
 
-	if (!(status & MACB_BIT(REC))) {
-		dev_warn(&bp->pdev->dev,
-			 "No RX buffers complete, status = %02lx\n",
-			 (unsigned long)status);
-		netif_rx_complete(dev, napi);
-		goto out;
+	work_done = macb_rx(bp, budget);
+	
+	if (status & MACB_BIT(BNA)) {
+		
+		printk(KERN_INFO
+			"%s: No RX buffers available. "
+			"Packets processed = %d\n", dev->name, work_done);
+
+		/* Only flush buffers if we did not manage to assemble
+		 * any complete frames in macb_rx() since each assembled
+		 * frame will result in free slots in the ring buffer.
+		 */
+		if (!work_done) {
+			/* No slots available in RX ring and no frames were
+			 * assembled. Mark all slots as unused. 
+			 * Hopefully this will let us recover... 
+			 */
+			int i;
+
+			printk(KERN_INFO "%s: No free RX buffers. "
+				"Flushing everything.\n", dev->name);
+
+			for (i = 0; i < RX_RING_SIZE; i++) 
+				bp->rx_ring[i].addr &= ~MACB_BIT(RX_USED);
+
+			wmb();
+		}
 	}
 
-	work_done = macb_rx(bp, budget);
 	if (work_done < budget)
 		netif_rx_complete(dev, napi);
 
@@ -543,7 +571,6 @@ static int macb_poll(struct napi_struct 
 	 * We've done what we can to clean the buffers. Make sure we
 	 * get notified when new packets arrive.
 	 */
-out:
 	macb_writel(bp, IER, MACB_RX_INT_FLAGS);
 
 	/* TODO: Handle errors */
@@ -584,7 +611,8 @@ static irqreturn_t macb_interrupt(int ir
 			}
 		}
 
-		if (status & (MACB_BIT(TCOMP) | MACB_BIT(ISR_TUND)))
+		if (status & (MACB_BIT(TCOMP) | MACB_BIT(ISR_TUND) | 
+                            MACB_BIT(ISR_RLE)))
 			macb_tx(bp);
 
 		/*



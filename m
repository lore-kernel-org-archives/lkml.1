Return-Path: <linux-kernel-owner+w=401wt.eu-S1761119AbZCaOuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761119AbZCaOuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757677AbZCaOup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:50:45 -0400
Received: from konftel.com ([83.68.233.82]:42020 "EHLO mail.konftel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756175AbZCaOun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:50:43 -0400
Subject: Re: [PATCH] macb: RLE and BNA handling
From: Erik Waling <erik.waling@konftel.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1231863713.10152.11.camel@konftel>
	 <20090114111505.48d34949@hskinnemoen-d830>
	 <1231928868.10152.31.camel@konftel>
	 <20090114130322.483a7830@hskinnemoen-d830>
	 <1232026671.10152.52.camel@konftel>	<1238060296.23641.8.camel@konftel>
	 <20090330140456.07eb48b8@hskinnemoen-d830>
In-Reply-To: <20090330140456.07eb48b8@hskinnemoen-d830>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain
Date: Tue, 31 Mar 2009 16:50:36 +0200
Message-ID: <1238511036.3677.16.camel@konftel>
MIME-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.600.1016-16552.007
X-TM-AS-Result: No--34.018400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haavard,

Thanks for your reply. See my comments below.

On Mon, 2009-03-30 at 14:04 +0200, Haavard Skinnemoen wrote: 
> Erik Waling wrote:
> > Have you had the time to check the patch below? These two issues still
> > needs to be addressed.
> 
> Yeah...sorry for not responding earlier.
> 
> > If you are unsure of the BNA part you could at least pass the RLE part
> > upstreams since it happens more frequently.
> 
> Right. I have to admit I'm not at all convinced about the BNA part...it
> seems to me like the only scenario when it makes a difference is when
> the ring is so small that it can't hold an entire frame. And if that's
> the case, isn't the easiest solution to just increase the size of the
> ring?


Regarding BNA I think there will always be a possibility that we will
fill the entire ring with start and mid fragments and no actual complete
frame can be assembled. The probability that it happens will decrease
with a larger buffer, but I still think there is a chance of it
happening no matter the size of the buffer. I think we have two options:

Option 1 - Discard one or a couple of fragments to enable us to receive
a new fragment. Hopefully this will be an EOF fragment for a partial
frame in our ring and we could assemble a complete frame and hence free
some more space in the buffer. This option would however require some
kind of an algorithm for choosing which fragment(s) to discard.

Option 2 - Flush the entire ring. This will result in loss of more data
than in option 1, but higher layers should be able to handle this. This
option will not require any algorithm for choosing fragments to discard
and will be easier to implement. I would vote for this option since BNA
seems to happen very rarely with the current buffer ring size.

> So, could you please split the patch up into the following parts:
>   1. TX RLE handling
>   2. Call macb_rx() regardless of the status
>   3. Handle incomplete RX frames
>   4. Special case for RX BNA

I did as you suggested and split my patches:

Patch 1: TX RLE handling
Patch 2: Call macb_rx() regardless of the status
Patch 3: BNA and incomplete RX frame handling

I didn't think it made any sense to make separate patches for incomplete
RX frames and BNA handling since the only time we will encounter
incomplete RX frames is if we have nuked some fragments in the buffer
during BNA handling.


> Then I can pass on the first three, and we can keep discussing the last
> one, which is the one I'm not sure about.
> 
> Haavard

All patches should apply against 2.6.29.

Signed-off-by: Erik Waling <erik.waling@konftel.com>


---

diff -urN linux-2.6.29/drivers/net/macb.c linux-2.6.29_p1_rle_fix/drivers/net/macb.c
--- linux-2.6.29/drivers/net/macb.c	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.29_p1_rle_fix/drivers/net/macb.c	2009-03-31 13:31:39.000000000 +0200
@@ -2,6 +2,7 @@
  * Atmel MACB Ethernet Controller driver
  *
  * Copyright (C) 2004-2006 Atmel Corporation
+ * Copyright (C) 2008-2009 Konftel AB
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -316,10 +317,11 @@
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
 
 		/* Transfer ongoing, disable transmitter, to avoid confusion */
 		if (status & MACB_BIT(TGO))
@@ -591,7 +593,8 @@
 			}
 		}
 
-		if (status & (MACB_BIT(TCOMP) | MACB_BIT(ISR_TUND)))
+		if (status & (MACB_BIT(TCOMP) | MACB_BIT(ISR_TUND) | 
+			    MACB_BIT(ISR_RLE)))
 			macb_tx(bp);
 
 		/*







diff -urN linux-2.6.29/drivers/net/macb.c linux-2.6.29_p2_no_rx_status_check/drivers/net/macb.c
--- linux-2.6.29/drivers/net/macb.c	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.29_p2_no_rx_status_check/drivers/net/macb.c	2009-03-31 13:45:01.000000000 +0200
@@ -521,27 +521,10 @@
 	macb_writel(bp, RSR, status);
 
 	work_done = 0;
-	if (!status) {
-		/*
-		 * This may happen if an interrupt was pending before
-		 * this function was called last time, and no packets
-		 * have been received since.
-		 */
-		netif_rx_complete(napi);
-		goto out;
-	}
 
 	dev_dbg(&bp->pdev->dev, "poll: status = %08lx, budget = %d\n",
 		(unsigned long)status, budget);
 
-	if (!(status & MACB_BIT(REC))) {
-		dev_warn(&bp->pdev->dev,
-			 "No RX buffers complete, status = %02lx\n",
-			 (unsigned long)status);
-		netif_rx_complete(napi);
-		goto out;
-	}
-
 	work_done = macb_rx(bp, budget);
 	if (work_done < budget)
 		netif_rx_complete(napi);
@@ -550,7 +533,6 @@
 	 * We've done what we can to clean the buffers. Make sure we
 	 * get notified when new packets arrive.
 	 */
-out:
 	macb_writel(bp, IER, MACB_RX_INT_FLAGS);
 
 	/* TODO: Handle errors */






diff -urN linux-2.6.29/drivers/net/macb.c linux-2.6.29_p3_handle_bna_and_incomplete_rx_frames/drivers/net/macb.c
--- linux-2.6.29/drivers/net/macb.c	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.29_p3_handle_bna_and_incomplete_rx_frames/drivers/net/macb.c	2009-03-31 13:44:33.000000000 +0200
@@ -491,13 +491,28 @@
 
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
@@ -543,6 +558,34 @@
 	}
 
 	work_done = macb_rx(bp, budget);
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
+	 	 */
+		if (!work_done) {
+			/* No slots available in RX ring and no frames were
+		         * assembled. Mark all slots as unused. 
+		 	 * Hopefully this will let us recover... 
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
+	}
+
 	if (work_done < budget)
 		netif_rx_complete(napi);
 



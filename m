Return-Path: <linux-kernel-owner+w=401wt.eu-S1761114AbZDAJcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761114AbZDAJcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 05:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbZDAJbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 05:31:53 -0400
Received: from relay.atmel.no ([80.232.32.139]:62920 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbZDAJbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 05:31:51 -0400
Date: Wed, 1 Apr 2009 11:31:46 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Erik Waling <erik.waling@konftel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] macb: RLE and BNA handling
Message-ID: <20090401113146.3c155a60@hskinnemoen-d830>
In-Reply-To: <1238511036.3677.16.camel@konftel>
References: <1231863713.10152.11.camel@konftel>
	<20090114111505.48d34949@hskinnemoen-d830>
	<1231928868.10152.31.camel@konftel>
	<20090114130322.483a7830@hskinnemoen-d830>
	<1232026671.10152.52.camel@konftel>
	<1238060296.23641.8.camel@konftel>
	<20090330140456.07eb48b8@hskinnemoen-d830>
	<1238511036.3677.16.camel@konftel>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erik Waling wrote:
> Regarding BNA I think there will always be a possibility that we will
> fill the entire ring with start and mid fragments and no actual complete
> frame can be assembled. The probability that it happens will decrease
> with a larger buffer, but I still think there is a chance of it
> happening no matter the size of the buffer. I think we have two options:

Right, but the existing code will already discard frames which don't
have an end marker, won't it? So the only way things will get stuck is
if the ring is so small that the last incomplete frame will prevent the
next full frame to be stored.

> Option 1 - Discard one or a couple of fragments to enable us to receive
> a new fragment. Hopefully this will be an EOF fragment for a partial
> frame in our ring and we could assemble a complete frame and hence free
> some more space in the buffer. This option would however require some
> kind of an algorithm for choosing which fragment(s) to discard.

I'm not sure if I understand. We shouldn't kill the last frame even if
it doesn't have an EOF marker because it could be that it's still under
transfer. And as for other frames, they are either delivered or
discarded.

> Option 2 - Flush the entire ring. This will result in loss of more data
> than in option 1, but higher layers should be able to handle this. This
> option will not require any algorithm for choosing fragments to discard
> and will be easier to implement. I would vote for this option since BNA
> seems to happen very rarely with the current buffer ring size.

Ok...if BNA still happens with the other fixes applied, I guess we
should still consider this.

> > So, could you please split the patch up into the following parts:
> >   1. TX RLE handling
> >   2. Call macb_rx() regardless of the status
> >   3. Handle incomplete RX frames
> >   4. Special case for RX BNA
> 
> I did as you suggested and split my patches:
> 
> Patch 1: TX RLE handling
> Patch 2: Call macb_rx() regardless of the status
> Patch 3: BNA and incomplete RX frame handling
> 
> I didn't think it made any sense to make separate patches for incomplete
> RX frames and BNA handling since the only time we will encounter
> incomplete RX frames is if we have nuked some fragments in the buffer
> during BNA handling.

Ok, I was sort of thinking it might be better to handle such frames
properly instead BUG()ing in any case, but I agree it isn't actually
_supposed_ to happen without the BNA stuff applied as well.

> diff -urN linux-2.6.29/drivers/net/macb.c linux-2.6.29_p1_rle_fix/drivers/net/macb.c
> --- linux-2.6.29/drivers/net/macb.c	2009-03-24 00:12:14.000000000 +0100
> +++ linux-2.6.29_p1_rle_fix/drivers/net/macb.c	2009-03-31 13:31:39.000000000 +0200
> @@ -2,6 +2,7 @@
>   * Atmel MACB Ethernet Controller driver
>   *
>   * Copyright (C) 2004-2006 Atmel Corporation
> + * Copyright (C) 2008-2009 Konftel AB

I'm no copyright expert, but are you sure this stuff is significant
enough to claim copyright in the whole thing?

>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -316,10 +317,11 @@
>  	dev_dbg(&bp->pdev->dev, "macb_tx status = %02lx\n",
>  		(unsigned long)status);
>  
> -	if (status & MACB_BIT(UND)) {
> +	if (status & (MACB_BIT(UND) | MACB_BIT(TSR_RLE))) {
>  		int i;
> -		printk(KERN_ERR "%s: TX underrun, resetting buffers\n",
> -			bp->dev->name);
> +		printk(KERN_ERR "%s: TX %s, resetting buffers\n",
> +			bp->dev->name, status & MACB_BIT(UND) ? 
> +			"underrun" : "retry limit exceeded");
>  
>  		/* Transfer ongoing, disable transmitter, to avoid confusion */
>  		if (status & MACB_BIT(TGO))
> @@ -591,7 +593,8 @@
>  			}
>  		}
>  
> -		if (status & (MACB_BIT(TCOMP) | MACB_BIT(ISR_TUND)))
> +		if (status & (MACB_BIT(TCOMP) | MACB_BIT(ISR_TUND) | 
> +			    MACB_BIT(ISR_RLE)))
>  			macb_tx(bp);
>  
>  		/*

I'll call this "macb: Handle Retry Limit Exceeded errors"

> diff -urN linux-2.6.29/drivers/net/macb.c linux-2.6.29_p2_no_rx_status_check/drivers/net/macb.c
> --- linux-2.6.29/drivers/net/macb.c	2009-03-24 00:12:14.000000000 +0100
> +++ linux-2.6.29_p2_no_rx_status_check/drivers/net/macb.c	2009-03-31 13:45:01.000000000 +0200
> @@ -521,27 +521,10 @@
>  	macb_writel(bp, RSR, status);
>  
>  	work_done = 0;
> -	if (!status) {
> -		/*
> -		 * This may happen if an interrupt was pending before
> -		 * this function was called last time, and no packets
> -		 * have been received since.
> -		 */
> -		netif_rx_complete(napi);
> -		goto out;
> -	}
>  
>  	dev_dbg(&bp->pdev->dev, "poll: status = %08lx, budget = %d\n",
>  		(unsigned long)status, budget);
>  
> -	if (!(status & MACB_BIT(REC))) {
> -		dev_warn(&bp->pdev->dev,
> -			 "No RX buffers complete, status = %02lx\n",
> -			 (unsigned long)status);
> -		netif_rx_complete(napi);
> -		goto out;
> -	}
> -
>  	work_done = macb_rx(bp, budget);
>  	if (work_done < budget)
>  		netif_rx_complete(napi);
> @@ -550,7 +533,6 @@
>  	 * We've done what we can to clean the buffers. Make sure we
>  	 * get notified when new packets arrive.
>  	 */
> -out:
>  	macb_writel(bp, IER, MACB_RX_INT_FLAGS);
>  
>  	/* TODO: Handle errors */

Hmm...I'm not sure how valid that TODO is. Should probably look into
that.

Anyway, I'll call this "macb: process the RX ring regardless of
interrupt status" and include some of the discussion.

> diff -urN linux-2.6.29/drivers/net/macb.c linux-2.6.29_p3_handle_bna_and_incomplete_rx_frames/drivers/net/macb.c
> --- linux-2.6.29/drivers/net/macb.c	2009-03-24 00:12:14.000000000 +0100
> +++ linux-2.6.29_p3_handle_bna_and_incomplete_rx_frames/drivers/net/macb.c	2009-03-31 13:44:33.000000000 +0200
> @@ -491,13 +491,28 @@
>  
>  		if (ctrl & MACB_BIT(RX_EOF)) {
>  			int dropped;
> -			BUG_ON(first_frag == -1);
> -
> -			dropped = macb_rx_frame(bp, first_frag, tail);
> -			first_frag = -1;
> -			if (!dropped) {
> -				received++;
> -				budget--;
> +			if (first_frag != -1) {
> +				dropped = macb_rx_frame(bp, first_frag, tail);
> +				first_frag = -1;
> +
> +				if (!dropped) {
> +					received++;
> +					budget--;
> +				}
> +			} else {
> +				/* We might end up here if we previously
> +				 * flushed the RX buffer ring because of 
> +				 * no available buffers.
> +				 */
> +				printk(KERN_INFO
> +					"%s: Found EOF frag without any "
> +					"previous SOF frag. Discarding "
> +					"everything up until EOF.\n",
> +					bp->dev->name);
> +				/* This might also "discard" a couple of 
> +				 * fragments that are already marked as unused.
> +				 */
> +				discard_partial_frame(bp, bp->rx_tail, tail);
>  			}
>  		}
>  	}
> @@ -543,6 +558,34 @@
>  	}
>  
>  	work_done = macb_rx(bp, budget);
> +
> +	if (status & MACB_BIT(BNA)) {
> +
> +		printk(KERN_INFO
> +			"%s: No RX buffers available. "
> +			"Packets processed = %d\n", dev->name, work_done);
> +
> +		/* Only flush buffers if we did not manage to assemble
> +		 * any complete frames in macb_rx() since each assembled
> +		 * frame will result in free slots in the ring buffer.
> +	 	 */
> +		if (!work_done) {
> +			/* No slots available in RX ring and no frames were
> +		         * assembled. Mark all slots as unused. 
> +		 	 * Hopefully this will let us recover... 
> +			 */
> +			int i;
> +
> +			printk(KERN_INFO "%s: No free RX buffers. "
> +				"Flushing everything.\n", dev->name);
> +
> +			for (i = 0; i < RX_RING_SIZE; i++)
> +				bp->rx_ring[i].addr &= ~MACB_BIT(RX_USED);

Hmm...ok, I guess this is reasonably safe, but I still suspect a race
which might mark a buffer as unused right after it was filled by the
macb. It's very unlikely to happen, but a nasty long-running interrupt
handler could cause problems if it happens at _just_ the wrong time...

And if it happens, I suspect the ring indices in the driver will get
out of sync with the hardware, which is very bad. So if you really need
to do this, I think it's safest to disable RX while flushing the ring
and reset all the pointers afterwards.

Haavard

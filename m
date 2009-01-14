Return-Path: <linux-kernel-owner+w=401wt.eu-S1761024AbZANKQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761024AbZANKQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756416AbZANKPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:15:15 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53621 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755542AbZANKPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:15:11 -0500
Date: Wed, 14 Jan 2009 11:15:05 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Erik Waling <erik.waling@konftel.se>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] macb: RLE and BNA handling
Message-ID: <20090114111505.48d34949@hskinnemoen-d830>
In-Reply-To: <1231863713.10152.11.camel@konftel>
References: <1231863713.10152.11.camel@konftel>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erik Waling wrote:
> This patch (against 2.6.28) solves two issues we have been experiencing
> when connecting the EMAC module on our AT91SAM9260 board to an ethernet
> repeater hub. When transfering large amounts of data we sometimes
> experienced that the Retry Limit Exceeded (RLE) bit got set in TSR
> during transmission attempts. When this happened the driver would stall
> in a state that prevented any more data from being sent.

Right. This part of your patch looks good...

> The other issue experienced was in the RX part of the driver. Sometimes
> the driver runs out of unused slots in the RX ring buffer. All slots
> will be filled with data but the driver is not able to extract a
> complete frame from the fragments in the buffer. When this happens the
> Buffer Not Available (BNA) bit is set in RSR.

This part also looks like a real problem, however...

> @@ -527,18 +529,31 @@ static int macb_poll(struct napi_struct
>         dev_dbg(&bp->pdev->dev, "poll: status = %08lx, budget = %d\n",
>                 (unsigned long)status, budget);
> 
> -       if (!(status & MACB_BIT(REC))) {
> +       if (status & MACB_BIT(REC)) {
> +               work_done = macb_rx(bp, budget);
> +               if (work_done < budget)
> +                       netif_rx_complete(dev, napi);
> +       } else if (status & MACB_BIT(BNA)) {
> +               /* No slots available in RX ring. Mark all slots
> +                * as unused.
> +                */
> +               int i;
> +
> +               dev_warn(&bp->pdev->dev,
> +                               "No free RX buffers. Marking all as unused.\n");
> +
> +               for (i = 0; i < RX_RING_SIZE; i++)
> +                       bp->rx_ring[i].addr &= ~MACB_BIT(RX_USED);
> +
> +               wmb();
> +               netif_rx_complete(dev, napi);

I'm not sure if nuking all the buffers that were received successfully
is the right thing to do here...?

> +       } else if (!(status & MACB_BIT(REC))) {

This should probably be just "else", since you checked the REC bit
above.

Haavard

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbZANMDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbZANMDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 07:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761956AbZANMD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 07:03:29 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:58098 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761931AbZANMD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 07:03:27 -0500
Date: Wed, 14 Jan 2009 13:03:22 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Erik Waling <erik.waling@konftel.se>
Cc: Erik Waling <Erik.Waling@konftel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] macb: RLE and BNA handling
Message-ID: <20090114130322.483a7830@hskinnemoen-d830>
In-Reply-To: <1231928868.10152.31.camel@konftel>
References: <1231863713.10152.11.camel@konftel>
	<20090114111505.48d34949@hskinnemoen-d830>
	<1231928868.10152.31.camel@konftel>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erik Waling wrote:
> > > @@ -527,18 +529,31 @@ static int macb_poll(struct napi_struct
> > >         dev_dbg(&bp->pdev->dev, "poll: status = %08lx, budget = %d\n",
> > >                 (unsigned long)status, budget);
> > >
> > > -       if (!(status & MACB_BIT(REC))) {
> > > +       if (status & MACB_BIT(REC)) {
> > > +               work_done = macb_rx(bp, budget);
> > > +               if (work_done < budget)
> > > +                       netif_rx_complete(dev, napi);
> > > +       } else if (status & MACB_BIT(BNA)) {
> > > +               /* No slots available in RX ring. Mark all slots
> > > +                * as unused.
> > > +                */
> > > +               int i;
> > > +
> > > +               dev_warn(&bp->pdev->dev,
> > > +                               "No free RX buffers. Marking all as unused.\n");
> > > +
> > > +               for (i = 0; i < RX_RING_SIZE; i++)
> > > +                       bp->rx_ring[i].addr &= ~MACB_BIT(RX_USED);
> > > +
> > > +               wmb();
> > > +               netif_rx_complete(dev, napi);  
> > 
> > I'm not sure if nuking all the buffers that were received successfully
> > is the right thing to do here...?
> >   
> 
> This was the only solution I could think of since all slots are marked
> as used and we are not able to assemble a complete frame. Do you think
> there is a better solution?

No, I guess that might be a good fallback solution if we really can't
seem to make any progress...

However, I'm wondering if there might be a different bug in the code
above: Suppose that we receive lots of frames, start processing them,
but exhaust our budget so that we return before we had a chance to look
at all of them.

Then, when the network layer calls us again, we will only continue
processing the buffers if the REC bit was set in the mean time, which
it might not be if there was a brief pause in the flow of packets. If
this happens, we'll simply display a warning and call
netif_rx_complete() with potentially lots of unprocessed packets in the
RX ring...

So I'm wondering if the right thing to do is to just call macb_rx()
regardless of the state of the REC bit. If it exhausts the budget, and
the BNA bit is set, we could flush the ring in order to sort of relieve
the pressure a bit...

Btw, I suspect you'll need to update rx_tail when you do that, or it
might not point to where the next used buffer will be.

Haavard

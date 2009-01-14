Return-Path: <linux-kernel-owner+w=401wt.eu-S1761665AbZANK2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761665AbZANK2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbZANK17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:27:59 -0500
Received: from mail.konftel.com ([83.68.233.85]:22648 "EHLO mail.konftel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbZANK16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:27:58 -0500
Subject: Re: [PATCH] macb: RLE and BNA handling
From: Erik Waling <erik.waling@konftel.se>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: Erik Waling <Erik.Waling@konftel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090114111505.48d34949@hskinnemoen-d830>
References: <1231863713.10152.11.camel@konftel>
	 <20090114111505.48d34949@hskinnemoen-d830>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 11:27:47 +0100
Message-ID: <1231928868.10152.31.camel@konftel>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1027-16400.006
X-TM-AS-Result: No--15.603400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See comments below...

On Wed, 2009-01-14 at 11:15 +0100, Haavard Skinnemoen wrote:
> Erik Waling wrote:
> > This patch (against 2.6.28) solves two issues we have been experiencing
> > when connecting the EMAC module on our AT91SAM9260 board to an ethernet
> > repeater hub. When transfering large amounts of data we sometimes
> > experienced that the Retry Limit Exceeded (RLE) bit got set in TSR
> > during transmission attempts. When this happened the driver would stall
> > in a state that prevented any more data from being sent.
> 
> Right. This part of your patch looks good...
> 
> > The other issue experienced was in the RX part of the driver. Sometimes
> > the driver runs out of unused slots in the RX ring buffer. All slots
> > will be filled with data but the driver is not able to extract a
> > complete frame from the fragments in the buffer. When this happens the
> > Buffer Not Available (BNA) bit is set in RSR.
> 
> This part also looks like a real problem, however...
> 
> > @@ -527,18 +529,31 @@ static int macb_poll(struct napi_struct
> >         dev_dbg(&bp->pdev->dev, "poll: status = %08lx, budget = %d\n",
> >                 (unsigned long)status, budget);
> >
> > -       if (!(status & MACB_BIT(REC))) {
> > +       if (status & MACB_BIT(REC)) {
> > +               work_done = macb_rx(bp, budget);
> > +               if (work_done < budget)
> > +                       netif_rx_complete(dev, napi);
> > +       } else if (status & MACB_BIT(BNA)) {
> > +               /* No slots available in RX ring. Mark all slots
> > +                * as unused.
> > +                */
> > +               int i;
> > +
> > +               dev_warn(&bp->pdev->dev,
> > +                               "No free RX buffers. Marking all as unused.\n");
> > +
> > +               for (i = 0; i < RX_RING_SIZE; i++)
> > +                       bp->rx_ring[i].addr &= ~MACB_BIT(RX_USED);
> > +
> > +               wmb();
> > +               netif_rx_complete(dev, napi);
> 
> I'm not sure if nuking all the buffers that were received successfully
> is the right thing to do here...?
> 

This was the only solution I could think of since all slots are marked
as used and we are not able to assemble a complete frame. Do you think
there is a better solution?

> > +       } else if (!(status & MACB_BIT(REC))) {
> 
> This should probably be just "else", since you checked the REC bit
> above.

You are right. That is probably more correct.

> Haavard

Erik


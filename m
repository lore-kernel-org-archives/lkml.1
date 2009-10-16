Return-Path: <linux-kernel-owner+w=401wt.eu-S1760453AbZJPPeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760453AbZJPPeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760296AbZJPPeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:34:12 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:55685 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759471AbZJPPeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:34:12 -0400
Date: Fri, 16 Oct 2009 08:33:34 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishnu Suresh <Vishnu@freescale.com>, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-crypto@vger.kernel.org,
       Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH v0 1/2] DMA: fsldma: Disable DMA_INTERRUPT when
 Async_tx enabled
Message-ID: <20091016153334.GA27401@ovro.caltech.edu>
References: <1255588866-4133-1-git-send-email-Vishnu@freescale.com>
 <e9c3a7c20910151825o67cd2712id91aead70f84987c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e9c3a7c20910151825o67cd2712id91aead70f84987c@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Fri, 16 Oct 2009 08:33:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 06:25:14PM -0700, Dan Williams wrote:
> [ added Leo and Timur to the Cc ]
> 
> On Wed, Oct 14, 2009 at 11:41 PM, Vishnu Suresh <Vishnu@freescale.com> wrote:
> > This patch disables the use of DMA_INTERRUPT capability with Async_tx
> >
> > The fsldma produces a null transfer with DMA_INTERRUPT
> > capability when used with Async_tx. When RAID devices queue
> > a transaction via Async_tx, this  results in a hang.
> >
> > Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
> > ---
> >  drivers/dma/fsldma.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> > index 296f9e7..66d9b39 100644
> > --- a/drivers/dma/fsldma.c
> > +++ b/drivers/dma/fsldma.c
> > @@ -1200,7 +1200,13 @@ static int __devinit of_fsl_dma_probe(struct of_device *dev,
> >                                                - fdev->reg.start + 1);
> >
> >        dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
> > +#ifndef CONFIG_ASYNC_CORE
> > +       /*
> > +        * The DMA_INTERRUPT async_tx is a NULL transfer, which will
> > +        * triger a PE interrupt.
> > +        */
> >        dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask);
> > +#endif
> >        dma_cap_set(DMA_SLAVE, fdev->common.cap_mask);
> >        fdev->common.device_alloc_chan_resources = fsl_dma_alloc_chan_resources;
> >        fdev->common.device_free_chan_resources = fsl_dma_free_chan_resources;
> 
> You are basically saying that fsl_dma_prep_interrupt() is buggy.  Can
> that routine be fixed rather than this piecemeal solution?  If it
> cannot be fixed (i.e. hardware issue) then fsl_dma_prep_interrupt()
> should just be disabled/deleted altogether.
> 

For what it's worth, I've used the following code in the recent past,
without any issues. This was on an 83xx, within the last few kernel
releases. I haven't tried it on the latest -rc.

Using device_prep_dma_memcpy() can trigger a callback as well, so the
interrupt feature isn't strictly needed. Just attach the callback to the
last memcpy operation.

static dma_cookie_t dma_async_interrupt(struct dma_chan *chan,
                                        dma_async_tx_callback callback,
                                        void *data)
{
        struct dma_device *dev = chan->device;
        struct dma_async_tx_descriptor *tx; 

        /* Set up the DMA */
        tx = dev->device_prep_dma_interrupt(chan, DMA_PREP_INTERRUPT);
        if (!tx)
                return -ENOMEM;

        tx->callback = callback;
        tx->callback_param = data;

        return tx->tx_submit(tx);
}

Ira

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758240AbYCMXIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbYCMXIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 19:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbYCMXII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 19:08:08 -0400
Received: from lixom.net ([66.141.50.11]:47673 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbYCMXIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 19:08:06 -0400
Date: Thu, 13 Mar 2008 18:14:42 -0500
From: Olof Johansson <olof@lixom.net>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linuxppc-dev@ozlabs.org, pasemi-linux@ozlabs.org,
       "Nelson, Shannon" <shannon.nelson@intel.com>,
       linux-kernel@vger.kernel.org, hskinnemoen@atmel.com
Subject: Re: [PATCH] pasemi_dma: Driver for PA Semi PWRficient on-chip
	DMAengine
Message-ID: <20080313231442.GA4639@lixom.net>
References: <20080306233900.GA3969@lixom.net> <1205255051.26723.19.camel@dwillia2-linux.ch.intel.com> <20080313195431.GA1449@lixom.net> <e9c3a7c20803131529j22db434aqdab0ef6f18891d67@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9c3a7c20803131529j22db434aqdab0ef6f18891d67@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 03:29:29PM -0700, Dan Williams wrote:
> On Thu, Mar 13, 2008 at 12:54 PM, Olof Johansson <olof@lixom.net> wrote:
> > On Tue, Mar 11, 2008 at 10:04:11AM -0700, Dan Williams wrote:
> >
> >  > I notice that the driver does not handle callbacks in its descriptor
> >  > cleanup path.  This could be ok if your intent is only to support the
> >  > net_dma style polled operations, but this will not work for the
> >  > raid-offload async_tx case.  I think the solution is for async_tx to
> >  > ignore channels without the DMA_INTERRUPT capability.
> >
> >  Good point, and correct - I have mostly been testing this with the
> >  NET_DMA offload. async_tx doesn't make use of just memcpy, does it?
> >
> 
> Right, it makes use of any capability it can get its hands on,
> otherwise fall back to software.

Badly worded question, but it got answered anyway. What I really meant
to as was "does async_tx use memcpy", I thought it only used xor. Good
to know.

> >  Also, how is DMA_INTERRUPT supposed to work? I see there's a separate
> >  "prep_dma_interrupt" function, but that doesn't make sense to me. Don't
> >  you want the interrupt associated with a specific transaction instead
> >  of added as a separate (empty) transaction?
> >
> 
> Yes, and that is what happens in most cases.  The additional
> prep_dma_interrupt method is for two special cases:
> 1/ Locations where code is submitting an indeterminate number of
> operations and wants an interrupt (callback) at the completion of the
> chain.  Someting like:
> list_for_each_entry()
>      async_memcpy()
> async_trigger_callback()

Ok, one could argue that it'd make more sense to have a way to issue a
memcpy (or other op) with a callback. Anyway, both methods work.

> 2/ For supporting channel switching on, for instance, a memcpy->xor
> chain where chan1 supports memcpy and chan2 supports xor.  When
> async_tx sees this it injects an interrupt for chan1.  The xor
> operation gets kicked off by the bottom half of the chan1 interrupt
> handler.  However, if chan1 can do both operations no interrupt is
> needed.
> 
> >  Once I add the descriptor to the ring, I can't change it to set the
> >  interrupt request bit on it. I suppose I could just add a dummy descriptor
> >  to the ring, but that doesn't seem quite right either.
> >
> 
> Dummy descriptors that do nothing but cause an interrupt is the intent.

Well, it'd be slightly more efficient to do add the interrupt attribute
to the last issued descriptor when it's known in advance. If the
underlying driver doesn't support it, adding a separate descriptor would
be a good fallback.

Anyway, this isn't likely to be a performance bottleneck. If it turns
out to be, I'll refactor it and submit patches.

> >  > > +static void pasemi_dma_clean(struct pasemi_dma_chan *chan)
> >  > > +{
> >  > > +       int old, new, i;
> >  > > +       unsigned long flags;
> >  > > +       struct pasemi_dma_desc *desc;
> >  > > +       spin_lock_irqsave(&chan->desc_lock, flags);
> >  >
> >  > Is spin_lock_bh() insufficient here?
> >  >
> >  > ...that's all that jumps out at the moment.
> >
> >  Can't do that if it's called both from the polling as well as the IRQ
> >  context, it'd need to hold off irqs. I.e. once I add the DMA_INTERRUPT
> >  support it will be needed.
> >
> 
> ...do it in a tasklet.

Why? That just adds overhead and latency.


-Olof

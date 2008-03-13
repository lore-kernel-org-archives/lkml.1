Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbYCMWaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbYCMWaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758102AbYCMW3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:29:32 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:33985 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037AbYCMW3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:29:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=M8EZs3H5Ay3VFPIaV9Mhu+BlK0BZDCBPh4m348uVkvzMGFxQv+oa6EINnOxjy9iFE4N7ajvqlVeykZF8sbpsksp2H6Fb8adOpT6jYAd2EqobnMTyfzpH/8gUykFFAFOFfn4CdFmZN0zTediOvmJbHB1WmKHMaONWXGTwyJQQhbg=
Message-ID: <e9c3a7c20803131529j22db434aqdab0ef6f18891d67@mail.gmail.com>
Date: Thu, 13 Mar 2008 15:29:29 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Olof Johansson" <olof@lixom.net>
Subject: Re: [PATCH] pasemi_dma: Driver for PA Semi PWRficient on-chip DMAengine
Cc: "Nelson, Shannon" <shannon.nelson@intel.com>, linux-kernel@vger.kernel.org,
       pasemi-linux@ozlabs.org, linuxppc-dev@ozlabs.org, hskinnemoen@atmel.com
In-Reply-To: <20080313195431.GA1449@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080306233900.GA3969@lixom.net>
	 <1205255051.26723.19.camel@dwillia2-linux.ch.intel.com>
	 <20080313195431.GA1449@lixom.net>
X-Google-Sender-Auth: a08469dc7d2de135
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 12:54 PM, Olof Johansson <olof@lixom.net> wrote:
> On Tue, Mar 11, 2008 at 10:04:11AM -0700, Dan Williams wrote:
>
>  > I notice that the driver does not handle callbacks in its descriptor
>  > cleanup path.  This could be ok if your intent is only to support the
>  > net_dma style polled operations, but this will not work for the
>  > raid-offload async_tx case.  I think the solution is for async_tx to
>  > ignore channels without the DMA_INTERRUPT capability.
>
>  Good point, and correct - I have mostly been testing this with the
>  NET_DMA offload. async_tx doesn't make use of just memcpy, does it?
>

Right, it makes use of any capability it can get its hands on,
otherwise fall back to software.

>  Also, how is DMA_INTERRUPT supposed to work? I see there's a separate
>  "prep_dma_interrupt" function, but that doesn't make sense to me. Don't
>  you want the interrupt associated with a specific transaction instead
>  of added as a separate (empty) transaction?
>

Yes, and that is what happens in most cases.  The additional
prep_dma_interrupt method is for two special cases:
1/ Locations where code is submitting an indeterminate number of
operations and wants an interrupt (callback) at the completion of the
chain.  Someting like:
list_for_each_entry()
     async_memcpy()
async_trigger_callback()

2/ For supporting channel switching on, for instance, a memcpy->xor
chain where chan1 supports memcpy and chan2 supports xor.  When
async_tx sees this it injects an interrupt for chan1.  The xor
operation gets kicked off by the bottom half of the chan1 interrupt
handler.  However, if chan1 can do both operations no interrupt is
needed.

>  Once I add the descriptor to the ring, I can't change it to set the
>  interrupt request bit on it. I suppose I could just add a dummy descriptor
>  to the ring, but that doesn't seem quite right either.
>

Dummy descriptors that do nothing but cause an interrupt is the intent.

>
>  > > +static void pasemi_dma_clean(struct pasemi_dma_chan *chan)
>  > > +{
>  > > +       int old, new, i;
>  > > +       unsigned long flags;
>  > > +       struct pasemi_dma_desc *desc;
>  > > +       spin_lock_irqsave(&chan->desc_lock, flags);
>  >
>  > Is spin_lock_bh() insufficient here?
>  >
>  > ...that's all that jumps out at the moment.
>
>  Can't do that if it's called both from the polling as well as the IRQ
>  context, it'd need to hold off irqs. I.e. once I add the DMA_INTERRUPT
>  support it will be needed.
>

...do it in a tasklet.

>
>  -Olof
>

Regards,
Dan

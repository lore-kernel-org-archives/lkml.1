Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbYCMBMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbYCMBMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 21:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYCMBMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 21:12:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbYCMBMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 21:12:17 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: fw-ohci: sync AT dma buffer before use
Date: Wed, 12 Mar 2008 21:11:55 -0400
User-Agent: KMail/1.9.9
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200803121743.29438.jwilson@redhat.com> <47D8645B.5040305@s5r6.in-berlin.de>
In-Reply-To: <47D8645B.5040305@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803122111.55754.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008 07:16:43 pm Stefan Richter wrote:
> Jarod Wilson wrote:
> > At least on my setup, where I could within seconds reliably reproduce a
> > panic in handle_at_packet() by simply dd'ing from two drives on different
> > controllers, the panic is gone.
> >
> > See http://bugzilla.kernel.org/show_bug.cgi?id=9617
>
> Alas the panic from comment #10 is still there, i.e. instant crash when
> plugging in an LSI based CD-RW (shortly after SCSI inquiry) --- but only
> if CONFIG_DEBUG_PAGEALLOC=y.
>
> Jarod, did your crashes happen with CONFIG_DEBUG_PAGEALLOC=n?

No, they're with it turned on (and still on w/this change where it doesn't 
panic). If I run with CONFIG_DEBUG_PAGEALLOC=n, no panic.

> > --- a/drivers/firewire/fw-ohci.c
> > +++ b/drivers/firewire/fw-ohci.c
> > @@ -780,6 +780,10 @@ at_context_queue_packet(struct context *ctx, struct
> > fw_packet *packet)
> >
> >  	context_append(ctx, d, z, 4 - z);
> >
> > +	/* Sync the DMA buffer up for the device to read from */
> > +	dma_sync_single_for_device(ohci->card.device, payload_bus,
> > +				   packet->payload_length, DMA_TO_DEVICE);
> > +
> >  	/* If the context isn't already running, start it up. */
> >  	reg = reg_read(ctx->ohci, CONTROL_SET(ctx->regs));
> >  	if ((reg & CONTEXT_RUN) == 0)
>
> The dma_sync_single_ call should be conditional for
> packet->payload_length > 0.  You would have noticed that if my patch
> "firewire: fw-ohci: shut up false compiler warning on PPC32" wouldn't
> have shadowed the corresponding compiler warning, which would be for
> real after your patch.  And, as David wrote, the call should come before
> context_append.
>
> However, we actually don't need it at all.
>
> The dma_map_single(...) already syncs the payload for the device, and we
> don't access the payload after that anymore.

D'oh, got overzealous reading dma docs, missed the fact that we didn't 
actually touch it on the host side, so nothing to actually sync...

> So this patch shouldn't do 
> anything, except that it inserts a call which happens to have barrier
> characteristics on some platforms.

...but got lucky in that it actually helps this particular setup (x86_64 
kernel, dual quad-core opteron, 8G RAM, 3 FireWire controllers). Hrm.

> What we rather have to check is:
>
>    - Are we really writing into the context program the order that we
>      need to?  This includes ordering WRT MMIO writes.
>
>    - Are we writing the branch address atomically?  (No, we don't enforce
>      an atomic access at the moment, although it is very likely that the
>      compiler uses an atomic access.)
>
> (We have to expect that the controller reads a descriptor while we write
> into it.)

More investigative fun for tomorrow...

>    - Is there a use-after-free problem somewhere?
>
> (A pattern in the original report and in a crash that you mentioned
> looked like use of freed memory: "Faulting instruction address:
> 0x6b6b6b68" in comment #1.)

Seems both of the ones that looked like slab poison were on PowerPC. I'll have 
to spin up a ppc kernel on the old powerbook and poke around more.

-- 
Jarod Wilson
jwilson@redhat.com

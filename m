Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbXFVM2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbXFVM2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 08:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbXFVM2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 08:28:47 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:33902 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbXFVM2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 08:28:47 -0400
Date: Fri, 22 Jun 2007 13:00:23 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Marc Pignat <marc.pignat@hevs.ch>
cc: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <andrew@sanpeople.com>, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [PATCH] mmc-atmel : fix kunmap wrong usage
In-Reply-To: <200706220828.18750.marc.pignat@hevs.ch>
Message-ID: <Pine.LNX.4.64.0706221237330.26363@blonde.wat.veritas.com>
References: <467A4532.40301@rfo.atmel.com> <200706211657.49427.marc.pignat@hevs.ch>
 <467A9F43.1050007@rfo.atmel.com> <200706220828.18750.marc.pignat@hevs.ch>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYW5kcmV3QHNhbnBlb3BsZS5jb20Abmljb2xhcy5mZXJyZUByZm8uYXRtZWwuY29tAGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuYXJtLmxpbnV4Lm9yZy51awBtYXJjLnBpZ25hdEBoZXZzLmNoAGRyemV1c0BkcnpldXMuY3gA
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Marc Pignat wrote:
> from: Marc Pignat <marc.pignat@hevs.ch>
> 
> kunmap must be called on the pointer returned by kmap.

Not necessarily: an offset within the same page is acceptable.

> 
> Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
> 
> ---
> 
> N.B: This is the same patch as yesterday, with proper Signed-off-by and more 
> comments.
> 
> The buffer variable is used this way:
> 		buffer = kmap_atomic(sg->page, KM_BIO_SRC_IRQ) + sg->offset;
> So we can't do
> 		kunmap_atomic(buffer, KM_BIO_SRC_IRQ);
> we must do
> 		kunmap_atomic(buffer - sg->offset, KM_BIO_SRC_IRQ);
> 		
> Strangely this misuse showed no problem using CONFIG_SLAB, but oops using
> CONFIG_SLUB, (lkml ''Oops in a driver while using SLUB as a SLAB allocator").

Aren't you just guessing there?  Those kunmap_atomics in at91_mci.c
may look wrong to you, but they're not incorrect (so long as sg->offset
falls within the page, as it must do here to make sense of the page).
Especially not on ARM, where kunmap_atomic actually has no interest
in the argument passed.  And the oops was in the flush_dcache_page.

If you actually reproduced Nicolas' problem on ARM, and verified
that your patch then fixes it, please let us know: that will be
remarkably interesting.

I believe I posted the correct fix last night (or at least a safe fix
for now: Christoph Lameter may prefer to undo it and change ARM's
dma_mapping at leisure later), checking PageSlab in page_mapping;
and Linus has already put that one into his git tree.

But it would be good to hear from Nicolas whether that indeed fixes
his oops: I couldn't actually try my patch on ARM either.

Hugh

> 
> Regards
> 
> Marc
> 
> --- drivers/mmc/host/at91_mci.c-2.6.22-rc5.orig	2007-06-21 16:27:31.000000000 +0200
> +++ drivers/mmc/host/at91_mci.c-2.6.22-rc5	2007-06-21 16:42:48.000000000 +0200
> @@ -164,7 +164,7 @@ static inline void at91mci_sg_to_dma(str
>  		else
>  			memcpy(dmabuf, sgbuffer, amount);
> 
> -		kunmap_atomic(sgbuffer, KM_BIO_SRC_IRQ);
> +		kunmap_atomic(sgbuffer - sg->offset, KM_BIO_SRC_IRQ);
> 
>  		if (size == 0)
>  			break;
> @@ -293,7 +293,7 @@ static void at91mci_post_dma_read(struct
>  				buffer[index] = swab32(buffer[index]);
>  		}
> 
> -		kunmap_atomic(buffer, KM_BIO_SRC_IRQ);
> +		kunmap_atomic(buffer - sg->offset, KM_BIO_SRC_IRQ);
>  		flush_dcache_page(sg->page);

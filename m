Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbXHRRXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbXHRRXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 13:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbXHRRXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 13:23:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39296 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174AbXHRRXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 13:23:04 -0400
Date: Sat, 18 Aug 2007 10:22:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>, Muli Ben-Yehuda <muli@il.ibm.com>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Andrew Morton <akpm@linux-foundation.org>
cc: patches@x86-64.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [1/4] x86_64: Fail dma_alloc_coherent on dma less devices
In-Reply-To: <20070815004034.4AB7814DC8@wotan.suse.de>
Message-ID: <alpine.LFD.0.999.0708181003430.30176@woody.linux-foundation.org>
References: <20070815240.194452000@suse.de>
 <20070815004034.4AB7814DC8@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hmm. I think this is wrong. 

Why? Because the regular 32-bit x86 code does this all completely 
differently, and doesn't use dma_mask at all. Instead, it _only_ uses 
dev->coherent_dma_mask (which, considering the name of the function, 
would seem to make sense).

Considering that the oops comes from this:

        /* Kludge to make it bug-to-bug compatible with i386. i386
           uses the normal dma_mask for alloc_coherent. */
        dma_mask &= *dev->dma_mask;

and that that code is *old*, and comes from when this file was called 
arch/x86_64/kernel/pci-gart.c, and the comment doesn't seem to even be 
correct any more, I really think the proper fix is likely to just *remove* 
that kludge that causes the oops entirely.

Anyway, I'll apply the patch, because clearly it's not going to make 
things *worse* (it does avoid the oops that we get now), but I don't think 
it's really even "probably still the right thing to do". I really think we 
should just remove the line that causes the oops instead, but that might 
change behaviour for non-oopsing cases, so I'm not ready to do that at 
this point.

Hmm? Who feels in charge of the DMA mapping stuff? Muli? James? Anybody?

		Linus

On Wed, 15 Aug 2007, Andi Kleen wrote:
> 
> This should fix an oops with PCMCIA PATA devices
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=8424
> 
> This is not a full fix for the problem, but probably
> still the right thing to do.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86_64/kernel/pci-dma.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux/arch/x86_64/kernel/pci-dma.c
> ===================================================================
> --- linux.orig/arch/x86_64/kernel/pci-dma.c
> +++ linux/arch/x86_64/kernel/pci-dma.c
> @@ -82,6 +82,10 @@ dma_alloc_coherent(struct device *dev, s
>  	if (dma_mask == 0)
>  		dma_mask = DMA_32BIT_MASK;
>  
> +	/* Device not DMA able */
> +	if (dev->dma_mask == NULL)
> +		return NULL;
> +
>  	/* Don't invoke OOM killer */
>  	gfp |= __GFP_NORETRY;
>  
> 

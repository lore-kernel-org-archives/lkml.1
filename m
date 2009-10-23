Return-Path: <linux-kernel-owner+w=401wt.eu-S1752012AbZJWLsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbZJWLsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 07:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZJWLsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 07:48:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43694 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbZJWLsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 07:48:36 -0400
Date: Fri, 23 Oct 2009 13:48:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86: adjust GFP mask handling for coherent allocations
Message-ID: <20091023114825.GH5886@elte.hu>
References: <4AE06644020000780001B4AD@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE06644020000780001B4AD@vpn.id2.novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> Rather than forcing GFP flags and DMA mask to be inconsistent, GFP
> flags should be determined even for the fallback device through
> dma_alloc_coherent_mask()/dma_alloc_coherent_gfp_flags(). This
> restores 64-bit behavior as it was prior to commits
> 8965eb19386fdf5ccd0ef8b02593eb8560aa3416 and
> 4a367f3a9dbf2e7ffcee4702203479809236ee6e (not sure why there are two of
> them), where GFP_DMA was forced on for 32-bit, but not for 64-bit, with
> the slight adjustment that afaict even 32-bit doesn't need this without
> CONFIG_ISA.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> ---
>  arch/x86/include/asm/dma-mapping.h |    4 +---
>  arch/x86/kernel/pci-dma.c          |    8 +++++---
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> --- linux-2.6.32-rc5/arch/x86/include/asm/dma-mapping.h	2009-10-19 13:09:44.000000000 +0200
> +++ 2.6.32-rc5-x86-dma-mask-gfp/arch/x86/include/asm/dma-mapping.h	2009-10-22 10:54:08.000000000 +0200
> @@ -124,10 +124,8 @@ dma_alloc_coherent(struct device *dev, s
>  	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
>  		return memory;
>  
> -	if (!dev) {
> +	if (!dev)
>  		dev = &x86_dma_fallback_dev;
> -		gfp |= GFP_DMA;
> -	}
>  
>  	if (!is_device_dma_capable(dev))
>  		return NULL;
> --- linux-2.6.32-rc5/arch/x86/kernel/pci-dma.c	2009-10-19 13:09:45.000000000 +0200
> +++ 2.6.32-rc5-x86-dma-mask-gfp/arch/x86/kernel/pci-dma.c	2009-10-22 10:56:46.000000000 +0200
> @@ -45,12 +45,14 @@ int iommu_pass_through __read_mostly;
>  dma_addr_t bad_dma_address __read_mostly = 0;
>  EXPORT_SYMBOL(bad_dma_address);
>  
> -/* Dummy device used for NULL arguments (normally ISA). Better would
> -   be probably a smaller DMA mask, but this is bug-to-bug compatible
> -   to older i386. */
> +/* Dummy device used for NULL arguments (normally ISA). */
>  struct device x86_dma_fallback_dev = {
>  	.init_name = "fallback device",
> +#ifdef CONFIG_ISA
> +	.coherent_dma_mask = DMA_BIT_MASK(24),
> +#else
>  	.coherent_dma_mask = DMA_BIT_MASK(32),
> +#endif
>  	.dma_mask = &x86_dma_fallback_dev.coherent_dma_mask,
>  };
>  EXPORT_SYMBOL(x86_dma_fallback_dev);

makes sense (although there were a few odd ends in various ISA sound 
driver details so this should go on the .33 not .32), but please 
introduce a cleaner construct, like a new DMA_ISA_BIT_MASK() or so.

Thanks,

	Ingo

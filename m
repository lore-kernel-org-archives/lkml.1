Return-Path: <linux-kernel-owner+w=401wt.eu-S1760406AbYEMRBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760406AbYEMRBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760621AbYEMRBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:01:07 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:16000 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013AbYEMRBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:01:04 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.26-rc1 regression: ISA DMA broken (bisected)
Date: Tue, 13 May 2008 10:59:32 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Rene Herman <rene.herman@keyaccess.nl>, Glauber Costa <gcosta@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Pete Clements <clem@clem.clem-digital.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
References: <4823AAF2.7070102@keyaccess.nl> <s5hzlr0105c.wl%tiwai@suse.de>
In-Reply-To: <s5hzlr0105c.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805131059.32911.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 May 2008 12:06:55 am Takashi Iwai wrote:
> Thanks for catching it.  Yeah, the patch looks buggy.  We had an
> implicit assumption that dev = NULL for ISA devices that require 24bit
> DMA.

Naive question #1:  Why don't we have a struct device for these
ISA devices?  PNP builds a struct device with DMA_24BIT_MASK
for ISAPNP devices.

Naive question #2:  Do other architectures need similar fixes in
dma_alloc_coherent()?

> [PATCH] x86: Fix dma_alloc_coherent() for ISA devices
> 
> The recent work on x86 dma_alloc_coherent() breaks the ISA DMA buffer
> allocation, which is represented by "dev = NULL" and requires 24bit
> DMA implicitly.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> 
> ---
> 
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index 0c37f16..c5ef1af 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -385,11 +385,13 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
>  	if (dma_alloc_from_coherent_mem(dev, size, dma_handle, &memory))
>  		return memory;
>  
> -	if (!dev)
> +	if (!dev) {
>  		dev = &fallback_dev;
> +		gfp |= GFP_DMA;
> +	}
>  	dma_mask = dev->coherent_dma_mask;
>  	if (dma_mask == 0)
> -		dma_mask = DMA_32BIT_MASK;
> +		dma_mask = (gfp & GFP_DMA) ? DMA_24BIT_MASK : DMA_32BIT_MASK;
>  
>  	/* Device not DMA able */
>  	if (dev->dma_mask == NULL)
> @@ -403,7 +405,7 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
>  	   larger than 16MB and in this case we have a chance of
>  	   finding fitting memory in the next higher zone first. If
>  	   not retry with true GFP_DMA. -AK */
> -	if (dma_mask <= DMA_32BIT_MASK)
> +	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA))
>  		gfp |= GFP_DMA32;
>  #endif
>  


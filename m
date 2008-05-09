Return-Path: <linux-kernel-owner+w=401wt.eu-S1762861AbYEIMu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762861AbYEIMu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 08:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174AbYEIMuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 08:50:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbYEIMuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 08:50:12 -0400
Message-ID: <4824483B.9070906@redhat.com>
Date: Fri, 09 May 2008 09:48:59 -0300
From: Glauber Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pete Clements <clem@clem.clem-digital.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: 2.6.26-rc1 regression: ISA DMA broken (bisected)
References: <4823AAF2.7070102@keyaccess.nl> <s5hzlr0105c.wl%tiwai@suse.de>
In-Reply-To: <s5hzlr0105c.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Fri, 09 May 2008 03:37:54 +0200,
> Rene Herman wrote:
>> Good day.
>>
>> commit 8779f2fc3b84ebb6c5181fb13d702e9944c16069
>>
>> "x86: don't try to allocate from DMA zone at first"
>>
>> breaks all of ISA DMA. Or all of ALSA ISA DMA at least. All
>> ISA soundcards are silent following that commit -- no error
>> messages, everything appears fine, just silence.
>>
>> It won't just revert due to 32/64 merge.
>>
>> Rene.
> 
> Thanks for catching it.  Yeah, the patch looks buggy.  We had an
> implicit assumption that dev = NULL for ISA devices that require 24bit
> DMA.
> 
> How about the patch below?  It's against the latest Linus git tree.
> 
> 
> thanks,
> 
> Takashi
> 
> 
> [PATCH] x86: Fix dma_alloc_coherent() for ISA devices
> 
> The recent work on x86 dma_alloc_coherent() breaks the ISA DMA buffer
> allocation, which is represented by "dev = NULL" and requires 24bit
> DMA implicitly.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Woke up and saw it, got worried, but there is already a fix. ;-)

Nice work! And thank you

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


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbZJPBZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbZJPBZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 21:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758267AbZJPBZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 21:25:52 -0400
Received: from mail-vw0-f184.google.com ([209.85.212.184]:42941 "EHLO
	mail-vw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbZJPBZv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 21:25:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=aCoVfR1AKfobkpzc3jLOPc2Vk/QyK4kZyypU9IX+goPQqWl/RB9hwbcbxM30JAEq8y
         h+3nbNw2n4MTvq+MJ1Y+GrgH2P5EZ3jjeAFgJJjkX07G0bfHuxMgVd0yG/EaVMM0Xd+0
         T8HPjCmtu+0D32OaQVYDZU+UY+48140oSUxp4=
MIME-Version: 1.0
In-Reply-To: <1255588866-4133-1-git-send-email-Vishnu@freescale.com>
References: <1255588866-4133-1-git-send-email-Vishnu@freescale.com>
Date: Thu, 15 Oct 2009 18:25:14 -0700
X-Google-Sender-Auth: d87190c6c2be1d60
Message-ID: <e9c3a7c20910151825o67cd2712id91aead70f84987c@mail.gmail.com>
Subject: Re: [PATCH v0 1/2] DMA: fsldma: Disable DMA_INTERRUPT when Async_tx 
	enabled
From: Dan Williams <dan.j.williams@intel.com>
To: Vishnu Suresh <Vishnu@freescale.com>
Cc: linuxppc-dev@ozlabs.org, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       herbert@gondor.apana.org.au, Li Yang <leoli@freescale.com>,
       Timur Tabi <timur@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ added Leo and Timur to the Cc ]

On Wed, Oct 14, 2009 at 11:41 PM, Vishnu Suresh <Vishnu@freescale.com> wrote:
> This patch disables the use of DMA_INTERRUPT capability with Async_tx
>
> The fsldma produces a null transfer with DMA_INTERRUPT
> capability when used with Async_tx. When RAID devices queue
> a transaction via Async_tx, this  results in a hang.
>
> Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
> ---
>  drivers/dma/fsldma.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index 296f9e7..66d9b39 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -1200,7 +1200,13 @@ static int __devinit of_fsl_dma_probe(struct of_device *dev,
>                                                - fdev->reg.start + 1);
>
>        dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
> +#ifndef CONFIG_ASYNC_CORE
> +       /*
> +        * The DMA_INTERRUPT async_tx is a NULL transfer, which will
> +        * triger a PE interrupt.
> +        */
>        dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask);
> +#endif
>        dma_cap_set(DMA_SLAVE, fdev->common.cap_mask);
>        fdev->common.device_alloc_chan_resources = fsl_dma_alloc_chan_resources;
>        fdev->common.device_free_chan_resources = fsl_dma_free_chan_resources;

You are basically saying that fsl_dma_prep_interrupt() is buggy.  Can
that routine be fixed rather than this piecemeal solution?  If it
cannot be fixed (i.e. hardware issue) then fsl_dma_prep_interrupt()
should just be disabled/deleted altogether.

--
Dan

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbZHKNN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbZHKNN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 09:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbZHKNNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 09:13:25 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:57928 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZHKNNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 09:13:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=mWIodxFTcjZNbAevxur+xHFOu8MeNSdK2XM51ykecOkPo7NVW+Ew3SMl+C2t1StHC5
         ugSPYlvb10Zwt1UOU+GinmCdOiQiBc+K5vgx8/lmMqiLVhR63Nqb7PhoZp5gryq4PHOX
         byo06ij8hr6WUQYl8RoLj4uOOe2fX9ofYCneE=
Date: Tue, 11 Aug 2009 09:42:48 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Tony Lindgren <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 3/3 v2] ASoC: OMAP: Enhance OMAP1510 DMA progress
 software counter
Message-Id: <20090811094248.3b869f09.jhnikula@gmail.com>
In-Reply-To: <200908110107.11485.jkrzyszt@tis.icnet.pl>
References: <200908101050.08074.jkrzyszt@tis.icnet.pl>
	<200908110107.11485.jkrzyszt@tis.icnet.pl>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009 01:07:10 +0200
Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> wrote:

> Enhance period index accuracy, particularly just before buffer rewind, by
> making use of DMA interrupt status flags in addition to simply counting up
> interrupts.
> 
> Corrections since v1:
> 1. Fix buggy DMA interrupt handling in case of multiple status flags set in
>    parallel.
> 2. Enable OMAP_DMA_LAST_IRQ only for playback on OMAP1510.
> 
> This patch applies on top of patch 2 from this series:
> [RFC][PATCH 2/3] ASoC: OMAP: Make use of DMA channel self linking on OMAP1510
> 
> Created against linux-2.6.31-rc5.
> 
> Tested on Amstrad Delta.
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> 
> ---
> --- linux-2.6.31-rc5/sound/soc/omap/omap-pcm.c.orig	2009-08-10 22:41:25.000000000 +0200
> +++ linux-2.6.31-rc5/sound/soc/omap/omap-pcm.c	2009-08-10 23:15:46.000000000 +0200
> @@ -68,13 +68,27 @@ static void omap_pcm_dma_irq(int ch, u16
>  		 * that can be used by omap_pcm_pointer() instead.
>  		 */
>  		spin_lock_irqsave(&prtd->lock, flags);
> +		if ((stat == OMAP_DMA_LAST_IRQ) &&
> +				(prtd->period_index == runtime->periods - 1)) {
> +			/* we are in sync, do nothing */
> +			spin_unlock_irqrestore(&prtd->lock, flags);
> +			return;
> +		}
>  		if (prtd->period_index >= 0) {
> -			if (++prtd->period_index == runtime->periods) {
> +			if (stat & OMAP_DMA_BLOCK_IRQ) {
> +				/* end of buffer reached, loop back */
> +				prtd->period_index = 0;
> +			} else if (stat & OMAP_DMA_LAST_IRQ) {
> +				/* update the counter for the last period */
> +				prtd->period_index = runtime->periods - 1;
> +			} else if (++prtd->period_index >= runtime->periods) {
> +				/* end of buffer missed? loop back */
>  				prtd->period_index = 0;
>  			}
>  		}
>  		spin_unlock_irqrestore(&prtd->lock, flags);
> -	}
> +	} else if (stat == OMAP_DMA_LAST_IRQ)
> +		return;
>  
Is this test needed? This interrupt is set only for playback on
omap1510 so this looks null-op.

>  	snd_pcm_period_elapsed(substream);
>  }
> @@ -175,7 +189,12 @@ static int omap_pcm_prepare(struct snd_p
>  	dma_params.frame_count	= runtime->periods;
>  	omap_set_dma_params(prtd->dma_ch, &dma_params);
>  
> -	omap_enable_dma_irq(prtd->dma_ch, OMAP_DMA_FRAME_IRQ);
> +	if ((cpu_is_omap1510()) &&
> +			(substream->stream == SNDRV_PCM_STREAM_PLAYBACK))
> +		omap_enable_dma_irq(prtd->dma_ch, OMAP_DMA_FRAME_IRQ |
> +							OMAP_DMA_LAST_IRQ);

Indent OMAP_DMA_LAST_IRQ with tab(s) and spaces to the same column
than OMAP_DMA_FRAME_IRQ. Looks nicer then. Should the
OMAP_DMA_BLOCK_IRQ to be set since it is handled in omap_pcm_dma_irq?


-- 
Jarkko

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762979AbYCGMOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762979AbYCGMOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 07:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbYCGMOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 07:14:32 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:55579 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750918AbYCGMOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 07:14:31 -0500
Message-ID: <47D13185.4080803@atmel.com>
Date: Fri, 07 Mar 2008 13:13:57 +0100
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: linux-kernel@vger.kernel.org, Hans-Christian Egtvedt <hcegtvedt@atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <avictor.za@gmail.com>
Subject: Re: [PATCH] at73c213: Monaural support
References: <20080307.190234.55730878.nemoto@toshiba-tops.co.jp>
In-Reply-To: <20080307.190234.55730878.nemoto@toshiba-tops.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto wrote:
> This patch add support for monaural playback to at73c213 driver.  The
> sound will be apear on L-channel.  Tested on AT91SAM9260-EK.
> 

This works fine for me on AT32AP7000 on STK1000 as well.

Although, I had to use 32 * 1024 buffer_bytes_max and 16 * 1024
period_bytes_max. Higher buffer_bytes_max resulted in glitching sound
when only using one channel. Nothing to do with this patch.

> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

> ---
> diff --git a/sound/spi/at73c213.c b/sound/spi/at73c213.c
> index 89d6e9c..a7839cc 100644
> --- a/sound/spi/at73c213.c
> +++ b/sound/spi/at73c213.c
> @@ -118,7 +118,7 @@ static struct snd_pcm_hardware snd_at73c213_playback_hw = {
>  	.rates		= SNDRV_PCM_RATE_CONTINUOUS,
>  	.rate_min	= 8000,  /* Replaced by chip->bitrate later. */
>  	.rate_max	= 50000, /* Replaced by chip->bitrate later. */
> -	.channels_min	= 2,
> +	.channels_min	= 1,
>  	.channels_max	= 2,
>  	.buffer_bytes_max = 64 * 1024 - 1,
>  	.period_bytes_min = 512,
> @@ -228,6 +228,14 @@ static int snd_at73c213_pcm_close(struct snd_pcm_substream *substream)
>  static int snd_at73c213_pcm_hw_params(struct snd_pcm_substream *substream,
>  				 struct snd_pcm_hw_params *hw_params)
>  {
> +	struct snd_at73c213 *chip = snd_pcm_substream_chip(substream);
> +	int channels = params_channels(hw_params);
> +	int val;
> +
> +	val = ssc_readl(chip->ssc->regs, TFMR);
> +	val = SSC_BFINS(TFMR_DATNB, channels - 1, val);
> +	ssc_writel(chip->ssc->regs, TFMR, val);
> +
>  	return snd_pcm_lib_malloc_pages(substream,
>  					params_buffer_bytes(hw_params));
>  }
> @@ -249,10 +257,12 @@ static int snd_at73c213_pcm_prepare(struct snd_pcm_substream *substream)
>  
>  	ssc_writel(chip->ssc->regs, PDC_TPR,
>  			(long)runtime->dma_addr);
> -	ssc_writel(chip->ssc->regs, PDC_TCR, runtime->period_size * 2);
> +	ssc_writel(chip->ssc->regs, PDC_TCR,
> +			runtime->period_size * runtime->channels);
>  	ssc_writel(chip->ssc->regs, PDC_TNPR,
>  			(long)runtime->dma_addr + block_size);
> -	ssc_writel(chip->ssc->regs, PDC_TNCR, runtime->period_size * 2);
> +	ssc_writel(chip->ssc->regs, PDC_TNCR,
> +			runtime->period_size * runtime->channels);
>  
>  	return 0;
>  }
> @@ -375,7 +385,8 @@ static irqreturn_t snd_at73c213_interrupt(int irq, void *dev_id)
>  
>  		ssc_writel(chip->ssc->regs, PDC_TNPR,
>  				(long)runtime->dma_addr + offset);
> -		ssc_writel(chip->ssc->regs, PDC_TNCR, runtime->period_size * 2);
> +		ssc_writel(chip->ssc->regs, PDC_TNCR,
> +				runtime->period_size * runtime->channels);
>  		retval = IRQ_HANDLED;
>  	}
>  


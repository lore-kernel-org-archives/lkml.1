Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357AbYCJJn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbYCJJn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 05:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbYCJJns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 05:43:48 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:64575 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750790AbYCJJnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 05:43:47 -0400
Subject: Re: [PATCH] at73c213: Remove redundant private_free routine
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org, hcegtvedt@atmel.com, hskinnemoen@atmel.com,
       avictor.za@gmail.com
In-Reply-To: <20080310.164946.76452619.nemoto@toshiba-tops.co.jp>
References: <20080310.161354.42213512.nemoto@toshiba-tops.co.jp>
	 <20080310.164946.76452619.nemoto@toshiba-tops.co.jp>
Content-Type: text/plain
Date: Mon, 10 Mar 2008 10:43:36 +0100
Message-Id: <1205142216.8634.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-10 at 16:49 +0900, Atsushi Nemoto wrote:
> On Mon, 10 Mar 2008 16:13:54 +0900 (JST), Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> > snd_pcm_lib_preallocate_free_for_all() is called from snd_pcm_free()
> > just after calling the private_free routine.  So there should be no
> > need to call it in driver's private_free routine.
> ...
> > -	pcm->private_data = chip;
> > -	pcm->private_free = snd_at73c213_pcm_free;
> >  	pcm->info_flags = SNDRV_PCM_INFO_BLOCK_TRANSFER;
> >  	strcpy(pcm->name, "at73c213");
> >  	chip->pcm = pcm;
> 
> Sorry, the patch was wrong.  The private_data field should still be
> initialized.  Revised.
> 

I spun this around, and it works fine on my system (AVR32 AT32AP7000 on
STK1000).

> ------------------------------------------------------
> Subject: [PATCH] at73c213: Remove redundant private_free routine
> From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> 
> snd_pcm_lib_preallocate_free_for_all() is called from snd_pcm_free()
> just after calling the private_free routine.  So there should be no
> need to call it in driver's private_free routine.
> 

Thanks for debugging the driver.

> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

> ---
> diff --git a/sound/spi/at73c213.c b/sound/spi/at73c213.c
> index 89d6e9c..bf3ea43 100644
> --- a/sound/spi/at73c213.c
> +++ b/sound/spi/at73c213.c
> @@ -314,15 +314,6 @@ static struct snd_pcm_ops at73c213_playback_ops = {
>  	.pointer	= snd_at73c213_pcm_pointer,
>  };
>  
> -static void snd_at73c213_pcm_free(struct snd_pcm *pcm)
> -{
> -	struct snd_at73c213 *chip = snd_pcm_chip(pcm);
> -	if (chip->pcm) {
> -		snd_pcm_lib_preallocate_free_for_all(chip->pcm);
> -		chip->pcm = NULL;
> -	}
> -}
> -
>  static int __devinit snd_at73c213_pcm_new(struct snd_at73c213 *chip, int device)
>  {
>  	struct snd_pcm *pcm;
> @@ -334,7 +325,6 @@ static int __devinit snd_at73c213_pcm_new(struct snd_at73c213 *chip, int device)
>  		goto out;
>  
>  	pcm->private_data = chip;
> -	pcm->private_free = snd_at73c213_pcm_free;
>  	pcm->info_flags = SNDRV_PCM_INFO_BLOCK_TRANSFER;
>  	strcpy(pcm->name, "at73c213");
>  	chip->pcm = pcm;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
With kind regards,
Hans-Christian Egtvedt, Applications Engineer


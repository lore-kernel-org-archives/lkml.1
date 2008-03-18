Return-Path: <linux-kernel-owner+w=401wt.eu-S1163415AbYCTAe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163415AbYCTAe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161271AbYCTAIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:08:21 -0400
Received: from v320-147-lb.its.uwo.ca ([129.100.74.147]:64640 "EHLO uwo.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161259AbYCTAIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:08:18 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Message-id: <47DFCEDA.2020307@uwo.ca>
Date: Tue, 18 Mar 2008 10:16:58 -0400
From: Tyson Whitehead <twhitehe@uwo.ca>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
To: Takashi Iwai <tiwai@suse.de>
Cc: ALSA devel <alsa-devel@alsa-project.org>,
       Michael Cree <mcree@orcon.net.nz>, Krzysztof Helt <krzysztof.h1@wp.pl>,
       Rene Herman <rene.herman@keyaccess.nl>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
References: <20080314131344.62A59DBA2@gherkin.frus.com>
 <200803142118.31974.twhitehe@uwo.ca> <s5hskypnwp8.wl%tiwai@suse.de>
In-reply-to: <s5hskypnwp8.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Fri, 14 Mar 2008 21:18:19 -0400,
> 
>>  Even 
>> then, though, I believe it still only works in 8bit mode.
> 
> Maybe the problem is in a different place, then...

It certainly doesn't work at all without it.  It is definetly not 
managing to figure out that the generated interupt is for itself.

> ---
> 
> diff -r 82e6201fc907 sound/isa/es18xx.c
> --- a/sound/isa/es18xx.c	Mon Mar 17 14:36:24 2008 +0100
> +++ b/sound/isa/es18xx.c	Mon Mar 17 17:32:59 2008 +0100
> @@ -765,9 +765,10 @@ static irqreturn_t snd_es18xx_interrupt(
>  		/* Read Interrupt status */
>  		status = snd_es18xx_mixer_read(chip, 0x7f) >> 4;
>  	}
> -#if 0
> -	else {
> -		status = 0;
> +
> +#ifdef CONFIG_ALPHA
> +	if (!(status & (AUDIO1_IRQ | AUDIO2_IRQ))) {
> +		/* status = 0; */
>  		if (inb(chip->port + 0x0C) & 0x01)
>  			status |= AUDIO1_IRQ;
>  		if (snd_es18xx_mixer_read(chip, 0x7A) & 0x80)
> @@ -777,7 +778,6 @@ static irqreturn_t snd_es18xx_interrupt(
>  			status |= HWV_IRQ;
>  	}
>  #endif
> -
>  	/* Audio 1 & Audio 2 */
>          if (status & AUDIO2_IRQ) {
>                  if (chip->active & DAC2)

This looks like it should accomplish the same thing (assuming not bits 
get set in status on the initial attempt to read it), without affecting 
other platforms and possible the alpha if anyone has a card that just 
works for whatever reason.  A better patch all around.  : )

Cheers!  -Tyson

PS:  I've managed to recover my disks, and the machine is compiling 
2.25-rc5 even as I write.

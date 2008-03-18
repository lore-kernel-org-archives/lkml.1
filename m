Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbYCRDYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbYCRDYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 23:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYCRDYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 23:24:35 -0400
Received: from gherkin.frus.com ([192.158.254.49]:32979 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbYCRDYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 23:24:34 -0400
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
In-Reply-To: <47DEEA09.9000108@keyaccess.nl> "from Rene Herman at Mar 17, 2008
 11:00:41 pm"
To: Rene Herman <rene.herman@keyaccess.nl>
Date: Mon, 17 Mar 2008 22:24:27 -0500 (CDT)
CC: Bob Tracy <rct@frus.com>, Michael Cree <mcree@orcon.net.nz>,
       Takashi Iwai <tiwai@suse.de>, ALSA devel <alsa-devel@alsa-project.org>,
       linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080318032427.298BCDBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll try the below when I get back from my business trip (in approx.
two weeks).  Apologies for the inconvenience, but the Alpha hardly
qualifies as a laptop :-).  If someone else with a Miata (or other
Alpha with the ES1888 sound device) cares to give this a try, I *will*
be keeping up with my e-mail.

--Bob

Rene Herman wrote:
> Okay, thought I'd stare at this thing a bit -- there's no specific 1888 
> documentation available it seems but I did notice something in the 1878 
> datasheet which might mean something. The docs says that bits 0-1 are don't 
> care for DMA but don't for IRQ, so could it possibly be as simple as the 
> attached?
> 
> 1878 sheet doesn't document register 0x7f, it seems...
> 
> Assuming it's not just this, this thing is going to require quite a bit of 
> trial and error and without the hardware this will be troublesome. I expect 
> this is not it, since the arch init code also doesn't care about bit 0 when 
> setting that same register for IRQ 5.
> 
> If this is not it -- I'd try s/0x50/0x10/ in that line, even completely 
> commenting out the IRQ setting line (with the arch code built in) and just 
> generally frolic around 'till something blows up...
> 
> Rene.
> 

> diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
> index 90498e4..71d1b96 100644
> --- a/sound/isa/es18xx.c
> +++ b/sound/isa/es18xx.c
> @@ -1449,16 +1449,16 @@ static int __devinit snd_es18xx_initialize(struct snd_es18xx *chip)
>  		switch (chip->irq) {
>  		case 2:
>  		case 9:
> -			irqmask = 0;
> +			irqmask = 0x0;
>  			break;
>  		case 5:
> -			irqmask = 1;
> +			irqmask = 0x5;
>  			break;
>  		case 7:
> -			irqmask = 2;
> +			irqmask = 0xa;
>  			break;
>  		case 10:
> -			irqmask = 3;
> +			irqmask = 0xf;
>  			break;
>  		default:
>  			snd_printk(KERN_ERR "invalid irq %d\n", chip->irq);
> @@ -1497,7 +1497,7 @@ static int __devinit snd_es18xx_initialize(struct snd_es18xx *chip)
>  		}
>  
>  		/* Enable and set Audio 1 IRQ */
> -		snd_es18xx_write(chip, 0xB1, 0x50 | (irqmask << 2));
> +		snd_es18xx_write(chip, 0xB1, 0x50 | irqmask);
>  		/* Enable and set Audio 1 DMA */
>  		snd_es18xx_write(chip, 0xB2, 0x50 | (dma1mask << 2));
>  		/* Set Audio 2 DMA */
> @@ -1513,7 +1513,9 @@ static int __devinit snd_es18xx_initialize(struct snd_es18xx *chip)
>  			   FM enabled */
>  			snd_es18xx_mixer_write(chip, 0x40, 0x43 | (chip->mpu_port & 0xf0) >> 1);
>  		}
> +#if 0
>  		snd_es18xx_mixer_write(chip, 0x7f, ((irqmask + 1) << 1) | 0x01);
> +#endif
>  	}
>  	if (chip->caps & ES18XX_NEW_RATE) {
>  		/* Change behaviour of register A1

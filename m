Return-Path: <linux-kernel-owner+w=401wt.eu-S1766984AbXDSUFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766984AbXDSUFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 16:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767009AbXDSUFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 16:05:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:44129 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766984AbXDSUF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 16:05:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=W2EshOcYcHP/9K111yr0O+JTWtLOut5fH2rwy1aikaZCZmK5GmuiOJsLWPnZLTMMIeuFv6m00vaUfJmO7P73/35XcG00Mhe8+4XrxqMyc87E2cH1pLR6jWffcB93zdTjXpjARUYXWiwkEeBWcr102+NwvL69pZ1058aw33dcnj4=
Message-ID: <4627CB04.4060401@googlemail.com>
Date: Thu, 19 Apr 2007 22:03:16 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Chuck Ebbert <cebbert@redhat.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>, perex@suse.cz,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [1/2] 2.6.21-rc7: known regressions
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>	<20070416003714.GL3691@stusta.de>	<4623EE59.7090005@redhat.com> <s5hk5wbcny7.wl%tiwai@suse.de>
In-Reply-To: <s5hk5wbcny7.wl%tiwai@suse.de>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

Takashi Iwai napisał(a):
> At Mon, 16 Apr 2007 17:44:57 -0400,
> Chuck Ebbert wrote:
>> Adrian Bunk wrote:
>>
>>> This email lists some known regressions in Linus' tree compared to 2.6.20.
>>>
>>> Subject    : snd_intel8x0: divide error: 0000
>>> References : http://lkml.org/lkml/2007/3/5/252
>>> Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
>>> Status     : unknown
>>>
>> Oops is in sound/pci/intel8x0.c::snd_intel8x0_update(), part of
>> the interrupt handler:
>>
>> Line 751:
>>
>>         ichdev->position += step * ichdev->fragsize1;
>>         if (! chip->in_measurement)
>>                 ichdev->position %= ichdev->size;
>>
>> ichdev->size is 0. Interrupt happened upon request_irq().
>>
>> Does chip->in_measurement need to be reset because this is a
>> crashdump kernel?
> 
> No, the problem seems to be the timing of request_irq() and the
> initialization of hardware.  The irq handler shouldn't get called
> there at all.
> 
> How about the patch below?
> 
> 
> Takashi
> 
> diff -r 4b6ed4ef4820 sound/pci/intel8x0.c
> --- a/sound/pci/intel8x0.c	Mon Apr 16 19:20:17 2007 +0200
> +++ b/sound/pci/intel8x0.c	Tue Apr 17 11:02:49 2007 +0200
> @@ -2493,6 +2493,7 @@ static int intel8x0_resume(struct pci_de
>  		return -EIO;
>  	}
>  	pci_set_master(pci);
> +	snd_intel8x0_chip_init(chip, 0);
>  	if (request_irq(pci->irq, snd_intel8x0_interrupt,
>  			IRQF_SHARED, card->shortname, chip)) {
>  		printk(KERN_ERR "intel8x0: unable to grab IRQ %d, "
> @@ -2502,7 +2503,6 @@ static int intel8x0_resume(struct pci_de
>  	}
>  	chip->irq = pci->irq;
>  	synchronize_irq(chip->irq);
> -	snd_intel8x0_chip_init(chip, 0);
>  
>  	/* re-initialize mixer stuff */
>  	if (chip->device_type == DEVICE_INTEL_ICH4 && !spdif_aclink) {
> @@ -2862,16 +2862,7 @@ static int __devinit snd_intel8x0_create
>  		ICH_REG_ALI_INTERRUPTSR : ICH_REG_GLOB_STA;
>  	chip->int_sta_mask = int_sta_masks;
>  
> -	/* request irq after initializaing int_sta_mask, etc */
> -	if (request_irq(pci->irq, snd_intel8x0_interrupt,
> -			IRQF_SHARED, card->shortname, chip)) {
> -		snd_printk(KERN_ERR "unable to grab IRQ %d\n", pci->irq);
> -		snd_intel8x0_free(chip);
> -		return -EBUSY;
> -	}
> -	chip->irq = pci->irq;
>  	pci_set_master(pci);
> -	synchronize_irq(chip->irq);
>  
>  	switch(chip->device_type) {
>  	case DEVICE_INTEL_ICH4:
> @@ -2900,6 +2891,15 @@ static int __devinit snd_intel8x0_create
>  		snd_intel8x0_free(chip);
>  		return err;
>  	}
> +
> +	/* request irq after initializaing int_sta_mask, etc */
> +	if (request_irq(pci->irq, snd_intel8x0_interrupt,
> +			IRQF_SHARED, card->shortname, chip)) {
> +		snd_printk(KERN_ERR "unable to grab IRQ %d\n", pci->irq);
> +		snd_intel8x0_free(chip);
> +		return -EBUSY;
> +	}
> +	chip->irq = pci->irq;
>  
>  	if ((err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops)) < 0) {
>  		snd_intel8x0_free(chip);
> 

This patch solves the problem for me. Thanks!

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)

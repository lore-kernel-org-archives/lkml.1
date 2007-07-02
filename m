Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbXGBNcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbXGBNcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 09:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbXGBNcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 09:32:05 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:49117 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbXGBNcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 09:32:04 -0400
Message-ID: <4688FE50.7050806@drzeus.cx>
Date: Mon, 02 Jul 2007 15:32:00 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
CC: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <andrew@sanpeople.com>, Andreas Beier <mughat@gmail.com>,
       Hamish Guthrie <hamish@prodigi.ch>, Marc Pignat <marc.pignat@hevs.ch>,
       wux@landicorp.com, Patrice Vilchez <patrice.vilchez@rfo.atmel.com>
Subject: Re: [PATCH] mmc: at91_mci: fix hanging and rework to match flowcharts
References: <4688EC94.1090901@rfo.atmel.com>
In-Reply-To: <4688EC94.1090901@rfo.atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre wrote:
> Fixes hanging using multi block operations (seen during CMD25).
> Follows closely the datasheet flowcharts.
> 
> This piece of code handles better big file writing. I had to take care
> of the notbusy signal during write (at91_mci_handle_cmdrdy function) and
> to rearrange the AT91_MCI_ENDRX and AT91_MCI_RXBUFF flag usage.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
> ---

Most of the patch looks ok. Do you want to wait for some more tests or should I
chuck this into the imminent merge window?

> @@ -817,7 +834,11 @@ static int __init at91_mci_probe(struct
>     mmc->ops = &at91_mci_ops;
>     mmc->f_min = 375000;
> -    mmc->f_max = 25000000;
> +    if (cpu_is_at91sam9263())
> +        mmc->f_max = 50000000;
> +    else
> +        mmc->f_max = 25000000;
> +
>     mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
>     mmc->caps = MMC_CAP_BYTEBLOCK | MMC_CAP_MULTIWRITE;
> 

This seems unrelated to the rest of the patch. Also, high-speed won't be enabled
unless you set the appropriate caps (which should be checked against timing
specifications, not just assigned and hope for the best).

> @@ -830,11 +851,11 @@ static int __init at91_mci_probe(struct
>     host->bus_mode = 0;
>     host->board = pdev->dev.platform_data;
>     if (host->board->wire4) {
> -#ifdef SUPPORT_4WIRE
> -        mmc->caps |= MMC_CAP_4_BIT_DATA;
> -#else
> -        printk("AT91 MMC: 4 wire bus mode not supported by this driver
> - using 1 wire\n");
> -#endif
> +        if (cpu_is_at91sam9260() || cpu_is_at91sam9263())
> +            mmc->caps |= MMC_CAP_4_BIT_DATA;
> +        else
> +            printk("AT91 MMC: 4 wire bus mode not supported"
> +                " - using 1 wire\n");
>     }
> 
>     /*
> 

This also looks unrelated.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

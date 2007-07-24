Return-Path: <linux-kernel-owner+w=401wt.eu-S1760080AbXGXPCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080AbXGXPCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbXGXPCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:02:44 -0400
Received: from h155.mvista.com ([63.81.120.155]:13184 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750903AbXGXPCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:02:43 -0400
Message-ID: <46A6150B.2030809@ru.mvista.com>
Date: Tue, 24 Jul 2007 19:04:43 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       jeff@garzik.org
Subject: Re: [PATCH] pata_hpt37x: Fix 2.6.22 clock PLL regression
References: <20070724151748.7e99f4f0@the-village.bc.nu>
In-Reply-To: <20070724151748.7e99f4f0@the-village.bc.nu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Cox wrote:

> 	Just one version of Linux ago
> 	The PLL code broke - oh no!
> 	But set the right mode
> 	And fix up the code
> 	Makes the PLL timing sync go

/me applauds :-)

> Closes-bug: #8791
> Signed-off-by: Alan Cox <alan@redhat.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

    However, I found it strange that HPT374 against which was that bug report 
works with 66 MHz DPLL clock -- while I've recently forbidden that clock in 
the IDE driver because it was causing DMA timeouts.

> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1/drivers/ata/pata_hpt37x.c linux-2.6.23rc1/drivers/ata/pata_hpt37x.c
> --- linux.vanilla-2.6.23rc1/drivers/ata/pata_hpt37x.c	2007-07-23 12:56:11.000000000 +0100
> +++ linux-2.6.23rc1/drivers/ata/pata_hpt37x.c	2007-07-23 14:44:39.000000000 +0100
> @@ -26,7 +26,7 @@
>  #include <linux/libata.h>
>  
>  #define DRV_NAME	"pata_hpt37x"
> -#define DRV_VERSION	"0.6.6"
> +#define DRV_VERSION	"0.6.7"
>  
>  struct hpt_clock {
>  	u8	xfer_speed;
> @@ -1103,17 +1103,17 @@
>  
>  		/* Select the DPLL clock. */
>  		pci_write_config_byte(dev, 0x5b, 0x21);
> -		pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low);
> +		pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low | 0x100);

    Heh, was quite a silly mistake. :-)

 >  		for(adjust = 0; adjust < 8; adjust++) {
 >  			if (hpt37x_calibrate_dpll(dev))
 >  				break;
 >  			/* See if it'll settle at a fractionally different clock */
 > -			if ((adjust & 3) == 3) {
 > -				f_low --;
 > -				f_high ++;
 > -			}
 > -			pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low);
 > +			if (adjust & 1)
 > +				f_low -= adjust >> 1;
 > +			else
 > +				f_high += adjust >> 1;
 > +			pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low | 0x100);

    OK, I'm seeing that the "oldie but goodie" calibration algrithm has 
finally found its way to the libata driver too. :-)

MBR, Sergei

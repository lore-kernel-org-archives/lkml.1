Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbXCERac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbXCERac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 12:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbXCERac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 12:30:32 -0500
Received: from h155.mvista.com ([63.81.120.155]:60480 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752820AbXCERa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 12:30:29 -0500
Message-ID: <45EC53AE.30808@ru.mvista.com>
Date: Mon, 05 Mar 2007 20:30:22 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][pata-2.6 tree] pdc202xx_old: rewrite mode programming
 code
References: <200703040149.46186.bzolnier@gmail.com>
In-Reply-To: <200703040149.46186.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:
> [PATCH] pdc202xx_old: rewrite mode programming code

> This patch is based on the documentation (I would like to thank Promise
> for it) and also partially on the older vendor driver.

> Rewrite mode programming code:

> * fix XFER_MW_DMA0 timings (they were overclocked, use the official ones)

    Erm, those look a bit doubtful...

> * fix bitmasks for clearing bits of register B:
> 
>   - when programming DMA mode bit 0x10 of register B was cleared which
>     resulted in overclocked PIO timing setting (iff PIO0 was used)

>   - when programming PIO mode bits 0x18 weren't cleared so suboptimal
>     timings were used for PIO1-4 if PIO0 was previously set (bit 0x10)
>     and for PIO0/3/4 if PIO1/2 was previously set (bit 0x08)

   I'm glad that somebody fixed those pesky masks at last. :-)
   I've noticed that issue more than a year ago but lacking time, 
documentation and access to hardware, have never got to really fixing it... :-(

> Index: b/drivers/ide/pci/pdc202xx_old.c
> ===================================================================
> --- a/drivers/ide/pci/pdc202xx_old.c
> +++ b/drivers/ide/pci/pdc202xx_old.c
[...]
> @@ -107,52 +70,23 @@ static int pdc202xx_tune_chipset (ide_dr
>  	u8 drive_pci		= 0x60 + (drive->dn << 2);
>  	u8 speed		= ide_rate_filter(drive, xferspeed);
>  
> -	u32			drive_conf;
> -	u8			AP, BP, CP, DP;
> +	u32			drive_conf = 0;
> +	u8			AP = 0, BP = 0, CP = 0;
>  	u8			TA = 0, TB = 0, TC = 0;
>  
> -	if (drive->media != ide_disk &&
> -		drive->media != ide_cdrom && speed < XFER_SW_DMA_0)
> -		return -1;
> +	/*
> +	 * TODO: do this once per channel
> +	 */
> +	if (dev->device != PCI_DEVICE_ID_PROMISE_20246)
> +		pdc_old_disable_66MHz_clock(hwif);
>  
>  	pci_read_config_dword(dev, drive_pci, &drive_conf);

    This function never uses it as u32 entity, I wonder why read it? Just to 
hush a warning? :-)

>  	switch(speed) {
> -		case XFER_UDMA_6:	speed = XFER_UDMA_5;
>  		case XFER_UDMA_5:
>  		case XFER_UDMA_4:	TB = 0x20; TC = 0x01; break;

    The same clocks for UDMA4/5... I wonder if PDC20265/7 indeed supported 
UDMA5 (as I'm not seeing any extra clock switching for this mode)?

>  		case XFER_UDMA_2:	TB = 0x20; TC = 0x01; break;
> @@ -161,7 +95,7 @@ static int pdc202xx_tune_chipset (ide_dr
>  		case XFER_UDMA_0:
>  		case XFER_MW_DMA_2:	TB = 0x60; TC = 0x03; break;
>  		case XFER_MW_DMA_1:	TB = 0x60; TC = 0x04; break;
> -		case XFER_MW_DMA_0:
> +		case XFER_MW_DMA_0:	TB = 0xE0; TC = 0x0F; break;

    This seems even slower than SWDMA0!
    Let's assume that means 7 active cycles and 15 recovery cycles (MWDMA1/2 
settings seem to confirm this hypothesis) -- this would give us 720 ns vs the 
specified 480. Could you shed some light on what these fields mean? :-/

>  		case XFER_SW_DMA_2:	TB = 0x60; TC = 0x05; break;

    Well, this don't look right to me -- we need longer active time (given 
that my hypothesis is true)

>  		case XFER_SW_DMA_1:	TB = 0x80; TC = 0x06; break;

    This looks more fitting for SWDMA1 -- however, the recovery time seems to 
be overly long. It certainly doesn't look like SWDMA1 unless the 
active/recover times are not in clock cycles (should be 8 cycles, not 4 or 6).

>  		case XFER_SW_DMA_0:	TB = 0xC0; TC = 0x0B; break;

    Same here -- should be 16 cycles both for active and recovery...

MBR, Sergei

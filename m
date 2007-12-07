Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbXLGQgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbXLGQgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 11:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbXLGQgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 11:36:16 -0500
Received: from h155.mvista.com ([63.81.120.155]:26232 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750900AbXLGQgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 11:36:14 -0500
Message-ID: <47597612.4080508@ru.mvista.com>
Date: Fri, 07 Dec 2007 19:34:26 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Mark Lord <lkml@rtr.ca>,
       Nick Warne <nick@ukfsn.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Peculiar out-of-sync boot log lines
References: <20071129193728.2f1c237e@linuxamd.linicks.net> <200712012259.35152.bzolnier@gmail.com> <20071201151419.39a169f1.randy.dunlap@oracle.com> <200712021930.34413.bzolnier@gmail.com>
In-Reply-To: <200712021930.34413.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> [PATCH] ide: DMA reporting and validity checking fixes (take 2)

> * ide_xfer_verbose() fixups:
>   - beautify returned mode names
>   - fix PIO5 reporting
>   - make it return 'const char *'

> * Change printk() level from KERN_DEBUG to KERN_INFO in ide_find_dma_mode().

> * Add ide_id_dma_bug() helper based on ide_dma_verbose() to check for invalid
>   DMA info in identify block.

> * Use ide_id_dma_bug() in ide_tune_dma() and ide_driveid_update().

>   As a result DMA won't be tuned or will be disabled after tuning if device
>   reports inconsistent info about enabled DMA mode (ide_dma_verbose() does the
>   same checks while the IDE device is probed by ide-{cd,disk} device driver).

> * Since (id->capability & 1) && id->tDMA is a valid configuration handle
>   it correctly in ide_id_dma_bug().

    Huh? You don't check (id->capability & 1) there...

> * Remove no longer needed ide_dma_verbose().

> This patch should fix the following problem with out-of-sync IDE messages
> reported by Nick Warne:

>        hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache<7>hdd:
>        skipping word 93 validity check
>         , UDMA(66)

> and later debugged by Mark Lord to be caused by:

>         ide_dma_verbose()
>                 printk( ... "2048kB Cache");
>         eighty_ninty_three()
>                 printk(KERN_DEBUG "%s: skipping word 93 validity check\n");
>         ide_dma_verbose()
>                 printk(", UDMA(66)"

> Please note that as a result ide-{cd,disk} device drivers won't report the
> DMA speed used but this is intended since now DMA mode being used is always
> reported by IDE core code.

> v2:
> * fixes suggested by Randy:
>   - use KERN_CONT for printk()-s in ide-{cd,disk}.c
>   - don't remove argument name from ide_xfer_verbose() declaration

> Cc: Nick Warne <nick@ukfsn.org>
> Cc: Mark Lord <lkml@rtr.ca>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

[...]

> Index: b/drivers/ide/ide-dma.c
> ===================================================================
> --- a/drivers/ide/ide-dma.c
> +++ b/drivers/ide/ide-dma.c
> @@ -806,58 +809,26 @@ static int ide_dma_check(ide_drive_t *dr
>  	return vdma ? 0 : -1;
>  }
>  
> -void ide_dma_verbose(ide_drive_t *drive)
> +int ide_id_dma_bug(ide_drive_t *drive)
>  {
> -	struct hd_driveid *id	= drive->id;
> -	ide_hwif_t *hwif	= HWIF(drive);
> +	struct hd_driveid *id = drive->id;
>  
>  	if (id->field_valid & 4) {
>  		if ((id->dma_ultra >> 8) && (id->dma_mword >> 8))
[...]
> +			goto err_out;
>  	} else if (id->field_valid & 2) {
>  		if ((id->dma_mword >> 8) && (id->dma_1word >> 8))
> -			goto bug_dma_off;
> -		printk(", DMA");
> +			goto err_out;
>  	} else if (id->field_valid & 1) {

    Hm, bit 0 only gurantees that current translation

> -		goto bug_dma_off;
> +		if (id->tDMA == 0)

    Despite the name, this is not a transfer period but SW DMA mode number, so 
why mode 0 is bad?

> +			goto err_out;
>  	}
> -	return;
> -bug_dma_off:
> -	printk(", BUG DMA OFF");
> -	hwif->dma_off_quietly(drive);
> -	return;
> +	return 0;
> +err_out:
> +	printk(KERN_ERR "%s: bad DMA info in identify block\n", drive->name);
> +	return 1;
>  }
>  
> Index: b/drivers/ide/ide-lib.c
> ===================================================================
> --- a/drivers/ide/ide-lib.c
> +++ b/drivers/ide/ide-lib.c
> @@ -29,41 +29,44 @@
>   *	Add common non I/O op stuff here. Make sure it has proper
>   *	kernel-doc function headers or your patch will be rejected
>   */
> - 
> +
> +static const char *udma_str[] =
> +	 { "UDMA/16", "UDMA/25",  "UDMA/33",  "UDMA/44",
> +	   "UDMA/66", "UDMA/100", "UDMA/133", "UDMA7" };
> +static const char *mwdma_str[] =
> +	{ "MWDMA0", "MWDMA1", "MWDMA2" };
> +static const char *swdma_str[] =
> +	{ "SWDMA0", "SWDMA1", "SWDMA2" };
> +static const char *pio_str[] =
> +	{ "PIO0", "PIO1", "PIO2", "PIO3", "PIO4", "PIO5" };
>  
>  /**
>   *	ide_xfer_verbose	-	return IDE mode names
> - *	@xfer_rate: rate to name
> + *	@mode: transfer mode
>   *
>   *	Returns a constant string giving the name of the mode
>   *	requested.
>   */
>  
> -char *ide_xfer_verbose (u8 xfer_rate)
> +const char *ide_xfer_verbose(u8 mode)
>  {
[...]
> +	const char *s;
> +	u8 i = mode & 0xf;
> +
> +	if (mode >= XFER_UDMA_0 && mode <= XFER_UDMA_7)
> +		s = udma_str[i];
> +	else if (mode >= XFER_MW_DMA_0 && mode <= XFER_MW_DMA_2)
> +		s = mwdma_str[i];
> +	else if (mode >= XFER_SW_DMA_0 && mode <= XFER_SW_DMA_2)
> +		s = swdma_str[i];
> +	else if (mode >= XFER_PIO_0 && mode <= XFER_PIO_5)
> +		s = pio_str[i & 0x7];
> +	else if (mode == XFER_PIO_SLOW)
> +		s = "XFER SLOW";

    Not "PIO SLOW"?

> +	else
> +		s = "XFER ERROR";
> +
> +	return s;
>  }

MBR, Sergei

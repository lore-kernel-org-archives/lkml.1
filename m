Return-Path: <linux-kernel-owner+w=401wt.eu-S932123AbXAVTs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbXAVTs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 14:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932411AbXAVTs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 14:48:27 -0500
Received: from h155.mvista.com ([63.81.120.155]:36534 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932405AbXAVTsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 14:48:25 -0500
Message-ID: <45B51505.4040905@ru.mvista.com>
Date: Mon, 22 Jan 2007 22:48:21 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/15] ide: rework the code for selecting the best DMA
 transfer mode
References: <20070119003058.14846.43637.sendpatchset@localhost.localdomain> <20070119003233.14846.5450.sendpatchset@localhost.localdomain>
In-Reply-To: <20070119003233.14846.5450.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> [PATCH] ide: rework the code for selecting the best DMA transfer mode 

    Here's another portion of comments...

> Depends on the "ide: fix UDMA/MWDMA/SWDMA masks" patch.

> * add ide_hwif_t.filter_udma_mask hook for filtering UDMA mask

    Erm, maybe a shorter method name like udma_filter would go with the others 
better.  But well, that's my taste. :-)

>   (use it in alim15x3, hpt366, siimage and serverworks drivers)
> * add ide_max_dma_mode() for finding best DMA mode for the device
>   (loosely based on some older libata-core.c code)
> * convert ide_dma_speed() users to use ide_max_dma_mode()
> * make ide_rate_filter() take "ide_drive_t *drive" as an argument instead
>   of "u8 mode" and teach it to how to use UDMA mask to do filtering
> * use ide_rate_filter() in hpt366 driver
> * remove no longer needed ide_dma_speed() and *_ratemask()
> * unexport eighty_ninty_three()

> Index: b/drivers/ide/ide-dma.c
> ===================================================================
> --- a/drivers/ide/ide-dma.c
> +++ b/drivers/ide/ide-dma.c
> @@ -705,6 +705,80 @@ int ide_use_dma(ide_drive_t *drive)
>  
>  EXPORT_SYMBOL_GPL(ide_use_dma);
>  
> +static const u8 xfer_mode_bases[] = {
> +	XFER_UDMA_0,
> +	XFER_MW_DMA_0,
> +	XFER_SW_DMA_0,
> +};
> +
> +static unsigned int ide_get_mode_mask(ide_drive_t *drive, u8 base)
> +{
> +	struct hd_driveid *id = drive->id;
> +	ide_hwif_t *hwif = drive->hwif;
> +	unsigned int mask = 0;
> +
> +	switch(base) {
> +	case XFER_UDMA_0:
> +		if ((id->field_valid & 4) == 0)
> +			break;
> +
> +		mask = id->dma_ultra & hwif->ultra_mask;
> +
> +		if (hwif->filter_udma_mask)
> +			mask &= hwif->filter_udma_mask(drive);
> +
> +		if ((mask & 0x78) && (eighty_ninty_three(drive) == 0))
> +			mask &= 0x07;
> +		break;
> +	case XFER_MW_DMA_0:
> +		mask = id->dma_mword & hwif->mwdma_mask;
> +		break;
> +	case XFER_SW_DMA_0:
> +		mask = id->dma_1word & hwif->swdma_mask;
> +		break;
> +	default:
> +		BUG();
> +		break;
> +	}
> +
> +	return mask;
> +}
> +
> +/**
> + *	ide_max_dma_mode	-	compute DMA speed
> + *	@drive: IDE device
> + *
> + *	Checks the drive capabilities and returns the speed to use
> + *	for the DMA transfer.  Returns 0 if the drive is incapable
> + *	of DMA transfers.
> + */
> +
> +u8 ide_max_dma_mode(ide_drive_t *drive)
> +{
> +	ide_hwif_t *hwif = drive->hwif;
> +	unsigned int mask;
> +	int x, i;
> +	u8 mode = 0;
> +
> +	if (drive->media != ide_disk && hwif->atapi_dma == 0)
> +		return 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(xfer_mode_bases); i++) {
> +		mask = ide_get_mode_mask(drive, xfer_mode_bases[i]);
> +		x = fls(mask) - 1;
> +		if (x >= 0) {
> +			mode = xfer_mode_bases[i] + x;
> +			break;
> +		}
> +	}
> +
> +	printk(KERN_DEBUG "%s: selected mode 0x%x\n", drive->name, mode);
> +
> +	return mode;
> +}
> +
> +EXPORT_SYMBOL_GPL(ide_max_dma_mode);
> +

    I didn't quite like the array/loop approach but well, that's my taste (I'd
rather put the mode-from-mask evaluation to the function and call it thrice)...

> Index: b/drivers/ide/ide-lib.c
> ===================================================================
> --- a/drivers/ide/ide-lib.c
> +++ b/drivers/ide/ide-lib.c
> @@ -69,123 +69,34 @@ char *ide_xfer_verbose (u8 xfer_rate)
>  EXPORT_SYMBOL(ide_xfer_verbose);
>  
>  /**
> - *	ide_dma_speed	-	compute DMA speed
> - *	@drive: drive
> - *	@mode:	modes available
> - *
> - *	Checks the drive capabilities and returns the speed to use
> - *	for the DMA transfer.  Returns 0 if the drive is incapable
> - *	of DMA transfers.
> - */
> - 
> -u8 ide_dma_speed(ide_drive_t *drive, u8 mode)

[...]

> -EXPORT_SYMBOL(ide_dma_speed);

    Alas, my ide_dma_speed() fix is going to be oudated rather quickly... :-)

> Index: b/drivers/ide/pci/hpt366.c
> ===================================================================
> --- a/drivers/ide/pci/hpt366.c
> +++ b/drivers/ide/pci/hpt366.c
> @@ -513,43 +513,31 @@ static int check_in_drive_list(ide_drive
>  	return 0;
>  }
>  
> -static u8 hpt3xx_ratemask(ide_drive_t *drive)
> -{
> -	struct hpt_info *info	= pci_get_drvdata(HWIF(drive)->pci_dev);
> -	u8 mode			= info->max_mode;
> -
> -	if (!eighty_ninty_three(drive) && mode)
> -		mode = min(mode, (u8)1);
> -	return mode;
> -}
> -
>  /*
>   *	Note for the future; the SATA hpt37x we must set
>   *	either PIO or UDMA modes 0,4,5
>   */
> - 
> -static u8 hpt3xx_ratefilter(ide_drive_t *drive, u8 speed)
> +
> +static u8 hpt3xx_filter_udma_mask(ide_drive_t *drive)
>  {
>  	struct hpt_info *info	= pci_get_drvdata(HWIF(drive)->pci_dev);
>  	u8 chip_type		= info->chip_type;
> -	u8 mode			= hpt3xx_ratemask(drive);
> -
> -	if (drive->media != ide_disk)
> -		return min(speed, (u8)XFER_PIO_4);
> +	u8 mode			= info->max_mode;
> +	u8 mask;
>  
>  	switch (mode) {
>  		case 0x04:
> -			speed = min_t(u8, speed, XFER_UDMA_6);
> +			mask = 0x7f;
>  			break;
>  		case 0x03:
> -			speed = min_t(u8, speed, XFER_UDMA_5);
> +			mask = 0x3f;
>  			if (chip_type >= HPT374)
>  				break;
>  			if (!check_in_drive_list(drive, bad_ata100_5))
>  				goto check_bad_ata33;
>  			/* fall thru */
>  		case 0x02:
> -			speed = min_t(u8, speed, XFER_UDMA_4);
> +			mask = 0x1f;
>  
>  			/*
>  			 * CHECK ME, Does this need to be changed to HPT374 ??
> @@ -560,13 +548,13 @@ static u8 hpt3xx_ratefilter(ide_drive_t 
>  			    !check_in_drive_list(drive, bad_ata66_4))
>  				goto check_bad_ata33;
>  
> -			speed = min_t(u8, speed, XFER_UDMA_3);
> +			mask = 0x0f;
>  			if (HPT366_ALLOW_ATA66_3 &&
>  			    !check_in_drive_list(drive, bad_ata66_3))
>  				goto check_bad_ata33;
>  			/* fall thru */
>  		case 0x01:
> -			speed = min_t(u8, speed, XFER_UDMA_2);
> +			mask = 0x07;
>  
>  		check_bad_ata33:
>  			if (chip_type >= HPT370A)
> @@ -576,10 +564,10 @@ static u8 hpt3xx_ratefilter(ide_drive_t 
>  			/* fall thru */
>  		case 0x00:
>  		default:
> -			speed = min_t(u8, speed, XFER_MW_DMA_2);
> +			mask = 0x00;
>  			break;
>  	}
> -	return speed;
> +	return mask;
>  }

    Erm, I see.  This driver will need some redesign because 'struct hpt_info' 
was fitted for the old rate filtering model.  Looks like the 'max_mode' field 
should be replaced by 'ultra_mask' there...

>  static u32 get_speed_setting(u8 speed, struct hpt_info *info)
> @@ -607,12 +595,19 @@ static int hpt36x_tune_chipset(ide_drive
>  	ide_hwif_t *hwif	= HWIF(drive);
>  	struct pci_dev  *dev	= hwif->pci_dev;
>  	struct hpt_info	*info	= pci_get_drvdata(dev);
> -	u8  speed		= hpt3xx_ratefilter(drive, xferspeed);
> +	u8  speed		= ide_rate_filter(drive, xferspeed);
>  	u8  itr_addr		= drive->dn ? 0x44 : 0x40;
> -	u32 itr_mask		= speed < XFER_MW_DMA_0 ? 0x30070000 :
> -				 (speed < XFER_UDMA_0   ? 0xc0070000 : 0xc03800ff);
> -	u32 new_itr		= get_speed_setting(speed, info);
>  	u32 old_itr		= 0;
> +	u32 itr_mask, new_itr;
> +
> +	/* TODO: move this to ide_rate_filter() [ check ->atapi_dma ] */
> +	if (drive->media != ide_disk)
> +		speed = min_t(u8, speed, XFER_PIO_4);
> +

    When I think about it, it seems quite stupid to set a PIO mode instead of 
a requested DMA one.  So, this is actually a questionable piece of code in 
this driver...

    Well, I must note the sorrow fact that both the IDE susbsytem as a whole 
doesn't keep track of PIO/DMA modes separately (having only current_mode) and 
the many drivers also fail to handle the timing registers shared by PIO/DMA 
modes correctly (well, it's actually also a hardware design issue :-).

> +	itr_mask = speed < XFER_MW_DMA_0 ? 0x30070000 :
> +		  (speed < XFER_UDMA_0   ? 0xc0070000 : 0xc03800ff);
> +
> +	new_itr = get_speed_setting(speed, info);

    Well, I liked this code where it was. But anyway, it's going to be 
replaced RSN...

> @@ -632,12 +627,19 @@ static int hpt37x_tune_chipset(ide_drive
>  	ide_hwif_t *hwif	= HWIF(drive);
>  	struct pci_dev  *dev	= hwif->pci_dev;
>  	struct hpt_info	*info	= pci_get_drvdata(dev);
> -	u8  speed		= hpt3xx_ratefilter(drive, xferspeed);
> +	u8  speed		= ide_rate_filter(drive, xferspeed);
>  	u8  itr_addr		= 0x40 + (drive->dn * 4);
> -	u32 itr_mask		= speed < XFER_MW_DMA_0 ? 0x303c0000 :
> -				 (speed < XFER_UDMA_0   ? 0xc03c0000 : 0xc1c001ff);
> -	u32 new_itr		= get_speed_setting(speed, info);
>  	u32 old_itr		= 0;
> +	u32 itr_mask, new_itr;
> +
> +	/* TODO: move this to ide_rate_filter() [ check ->atapi_dma ] */
> +	if (drive->media != ide_disk)
> +		speed = min_t(u8, speed, XFER_PIO_4);
> +
> +	itr_mask = speed < XFER_MW_DMA_0 ? 0x303c0000 :
> +		  (speed < XFER_UDMA_0   ? 0xc03c0000 : 0xc1c001ff);
> +
> +	new_itr = get_speed_setting(speed, info);

    Same comments here...

> Index: b/drivers/ide/pci/serverworks.c
> ===================================================================
> --- a/drivers/ide/pci/serverworks.c
> +++ b/drivers/ide/pci/serverworks.c
> @@ -65,16 +65,16 @@ static int check_in_drive_lists (ide_dri
>  	return 0;
>  }
>  
> -static u8 svwks_ratemask (ide_drive_t *drive)
> +static u8 svwks_filter_udma_mask(ide_drive_t *drive)
>  {
>  	struct pci_dev *dev     = HWIF(drive)->pci_dev;
> -	u8 mode = 0;
> +	u8 mask = 0;

    Hm, this looks like it needs rework...

>  	if (!svwks_revision)
>  		pci_read_config_byte(dev, PCI_REVISION_ID, &svwks_revision);
>  
>  	if (dev->device == PCI_DEVICE_ID_SERVERWORKS_HT1000IDE)
> -		return 2;
> +		return 0x1f;
>  	if (dev->device == PCI_DEVICE_ID_SERVERWORKS_OSB4IDE) {
>  		u32 reg = 0;
>  		if (isa_dev)
> @@ -86,25 +86,31 @@ static u8 svwks_ratemask (ide_drive_t *d
>  		if(drive->media == ide_disk)
>  			return 0;
>  		/* Check the OSB4 DMA33 enable bit */
> -		return ((reg & 0x00004000) == 0x00004000) ? 1 : 0;
> +		return ((reg & 0x00004000) == 0x00004000) ? 0x07 : 0;
>  	} else if (svwks_revision < SVWKS_CSB5_REVISION_NEW) {
> -		return 1;
> +		return 0x07;
>  	} else if (svwks_revision >= SVWKS_CSB5_REVISION_NEW) {
> -		u8 btr = 0;
> +		u8 btr = 0, mode;
>  		pci_read_config_byte(dev, 0x5A, &btr);
>  		mode = btr & 0x3;
> -		if (!eighty_ninty_three(drive))
> -			mode = min(mode, (u8)1);
> +
>  		/* If someone decides to do UDMA133 on CSB5 the same
>  		   issue will bite so be inclusive */
>  		if (mode > 2 && check_in_drive_lists(drive, svwks_bad_ata100))
>  			mode = 2;
> +
> +		switch(mode) {
> +		case 2:	 mask = 0x1f; break;
> +		case 1:	 mask = 0x07; break;
> +		default: mask = 0x00; break;
> +		}
>  	}
>  	if (((dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE) ||
>  	     (dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2)) &&
>  	    (!(PCI_FUNC(dev->devfn) & 1)))
> -		mode = 2;
> -	return mode;
> +		mask = 0x1f;
> +
> +	return mask;
>  }

    Hm, what was the problem with setting the proper masks based on PCI device 
ID in the init. code?
That'd have greatly simplified the filter...

> Index: b/drivers/ide/pci/siimage.c
> ===================================================================
> --- a/drivers/ide/pci/siimage.c
> +++ b/drivers/ide/pci/siimage.c
> @@ -116,45 +116,41 @@ static inline unsigned long siimage_seld
>  }
>  
>  /**
> - *	siimage_ratemask	-	Compute available modes
> - *	@drive: IDE drive
> + *	sil_filter_udma_mask	-	compute UDMA mask
> + *	@drive: IDE device
> + *
> + *	Compute the available UDMA speeds for the device on the interface.
>   *
> - *	Compute the available speeds for the devices on the interface.
>   *	For the CMD680 this depends on the clocking mode (scsc), for the
> - *	SI3312 SATA controller life is a bit simpler. Enforce UDMA33
> - *	as a limit if there is no 80pin cable present.
> + *	SI3112 SATA controller life is a bit simpler.
>   */
> - 
> -static byte siimage_ratemask (ide_drive_t *drive)
> +
> +static u8 sil_filter_udma_mask(ide_drive_t *drive)
>  {
> -	ide_hwif_t *hwif	= HWIF(drive);
> -	u8 mode	= 0, scsc = 0;
> +	ide_hwif_t *hwif = drive->hwif;
>  	unsigned long base = (unsigned long) hwif->hwif_data;
> +	u8 mask = 0, scsc = 0;
>  
>  	if (hwif->mmio)
>  		scsc = hwif->INB(base + 0x4A);
>  	else
>  		pci_read_config_byte(hwif->pci_dev, 0x8A, &scsc);
>  
> -	if(is_sata(hwif))
> -	{
> -		if(strstr(drive->id->model, "Maxtor"))
> -			return 3;
> -		return 4;
> +	if (is_sata(hwif)) {
> +		mask = strstr(drive->id->model, "Maxtor") ? 0x3f : 0x7f;
> +		goto out;
>  	}
> -	
> +
>  	if ((scsc & 0x30) == 0x10)	/* 133 */
> -		mode = 4;
> +		mask = 0x7f;
>  	else if ((scsc & 0x30) == 0x20)	/* 2xPCI */
> -		mode = 4;
> +		mask = 0x7f;
>  	else if ((scsc & 0x30) == 0x00)	/* 100 */
> -		mode = 3;
> +		mask = 0x3f;
>  	else 	/* Disabled ? */
>  		BUG();

    Most probably this is doable at init. time also...

MBR, Sergei

PS: I understand that the intent wasn not to make this rewrite optimal but
do it quick and with least affect.  And I certainly may handle hpt366.c 
redesign... :-)


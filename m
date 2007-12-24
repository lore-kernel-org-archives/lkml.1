Return-Path: <linux-kernel-owner+w=401wt.eu-S1753031AbXLXPsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbXLXPsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 10:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbXLXPs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 10:48:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:4362 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbXLXPs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 10:48:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=xCAcCFSAeXRT4jY0Lak81pb/PsYu543NDm/U2SZ1jZbUp9muz9KAIqDPghAje5Bg5DocpFmWfBek9CQekl+Yi3vdPTBGeDv6IkOmk49QXP2Bsmq5/z1GtWrrK6lOEBd4YNM7td5ubSGnHYqVXY5RmT4TXPxhPE5nmD3Ouu8LjvE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: Re: [git patches] IDE fixes
Date: Mon, 24 Dec 2007 16:57:53 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200712241537.01806.bzolnier@gmail.com>
In-Reply-To: <200712241537.01806.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712241657.53466.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added Linus to Cc: ]

On Monday 24 December 2007, Bartlomiej Zolnierkiewicz wrote:
> 
> cmd64x regression bugfix, few obvious ide-cd fixes from the "redux" patch
> peries and ide-cd MAINTAINERS entry update (Borislav, welcome on board!).
> 
> Oh yes, I would forget...
> 
> Merry Christmas!

Well, I forgot to send this to Linus instead...  :-)

> Linus, please pull from:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/
> 
> to receive the following updates:
> 
>  MAINTAINERS              |    4 ++-
>  drivers/ide/ide-cd.c     |   66 +++++++++++++++++++++++----------------------
>  drivers/ide/ide-cd.h     |    3 +-
>  drivers/ide/pci/cmd64x.c |    4 +-
>  drivers/ide/pci/cs5535.c |    2 +-
>  5 files changed, 42 insertions(+), 37 deletions(-)
> 
> 
> Bartlomiej Zolnierkiewicz (10):
>       ide-cd: fix SAMSUNG CD-ROM SCR-3231 quirk
>       ide-cd: fix ACER/AOpen 24X CDROM speed reporting on big-endian machines
>       ide-cd: use ide_cd_release() in ide_cd_probe()
>       ide-cd: fix error messages in cdrom_{read,write}_check_ireason()
>       ide-cd: add missing 'ireason' masking to cdrom_write_intr()
>       ide-cd: fix error messages in cdrom_write_intr()
>       ide-cd: add error message for DMA error to cdrom_read_intr()
>       ide-cd: fix error message in cdrom_pc_intr()
>       ide-cd: fix 'ireason' reporting in cdrom_pc_intr()
>       cmd64x: fix hwif->chipset setup
> 
> Borislav Petkov (1):
>       MAINTAINERS: update ide-cd entry
> 
> Joe Perches (1):
>       drivers/ide/: Spelling fixes
> 
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3d567fd..79c711e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1870,8 +1870,10 @@ T:	quilt kernel.org/pub/linux/kernel/people/bart/pata-2.6/
>  S:	Maintained
>  
>  IDE/ATAPI CDROM DRIVER
> +P:	Borislav Petkov
> +M:	bbpetkov@yahoo.de
>  L:	linux-ide@vger.kernel.org
> -S:	Unmaintained
> +S:	Maintained
>  
>  IDE/ATAPI FLOPPY DRIVERS
>  P:	Paul Bristow
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index 92ac658..c7d77f0 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -1068,8 +1068,8 @@ int cdrom_read_check_ireason (ide_drive_t *drive, int len, int ireason)
>  		return 0;
>  	else if (ireason == 0) {
>  		/* Whoops... The drive is expecting to receive data from us! */
> -		printk(KERN_ERR "%s: read_intr: Drive wants to transfer data the "
> -						"wrong way!\n", drive->name);
> +		printk(KERN_ERR "%s: %s: wrong transfer direction!\n",
> +				drive->name, __FUNCTION__);
>  
>  		/* Throw some data at the drive so it doesn't hang
>  		   and quit this request. */
> @@ -1086,8 +1086,8 @@ int cdrom_read_check_ireason (ide_drive_t *drive, int len, int ireason)
>  		return 0;
>  	} else {
>  		/* Drive wants a command packet, or invalid ireason... */
> -		printk(KERN_ERR "%s: read_intr: bad interrupt reason %x\n", drive->name,
> -								ireason);
> +		printk(KERN_ERR "%s: %s: bad interrupt reason 0x%02x\n",
> +				drive->name, __FUNCTION__, ireason);
>  	}
>  
>  	cdrom_end_request(drive, 0);
> @@ -1112,8 +1112,11 @@ static ide_startstop_t cdrom_read_intr (ide_drive_t *drive)
>  	 */
>  	if (dma) {
>  		info->dma = 0;
> -		if ((dma_error = HWIF(drive)->ide_dma_end(drive)))
> +		dma_error = HWIF(drive)->ide_dma_end(drive);
> +		if (dma_error) {
> +			printk(KERN_ERR "%s: DMA read error\n", drive->name);
>  			ide_dma_off(drive);
> +		}
>  	}
>  
>  	if (cdrom_decode_status(drive, 0, &stat))
> @@ -1443,7 +1446,7 @@ static ide_startstop_t cdrom_pc_intr (ide_drive_t *drive)
>  		return ide_stopped;
>  
>  	/* Read the interrupt reason and the transfer length. */
> -	ireason = HWIF(drive)->INB(IDE_IREASON_REG);
> +	ireason = HWIF(drive)->INB(IDE_IREASON_REG) & 0x3;
>  	lowcyl  = HWIF(drive)->INB(IDE_BCOUNTL_REG);
>  	highcyl = HWIF(drive)->INB(IDE_BCOUNTH_REG);
>  
> @@ -1484,7 +1487,7 @@ static ide_startstop_t cdrom_pc_intr (ide_drive_t *drive)
>  	if (thislen > len) thislen = len;
>  
>  	/* The drive wants to be written to. */
> -	if ((ireason & 3) == 0) {
> +	if (ireason == 0) {
>  		if (!rq->data) {
>  			blk_dump_rq_flags(rq, "cdrom_pc_intr, write");
>  			goto confused;
> @@ -1506,9 +1509,9 @@ static ide_startstop_t cdrom_pc_intr (ide_drive_t *drive)
>  	}
>  
>  	/* Same drill for reading. */
> -	else if ((ireason & 3) == 2) {
> +	else if (ireason == 2) {
>  		if (!rq->data) {
> -			blk_dump_rq_flags(rq, "cdrom_pc_intr, write");
> +			blk_dump_rq_flags(rq, "cdrom_pc_intr, read");
>  			goto confused;
>  		}
>  		/* Transfer the data. */
> @@ -1632,8 +1635,8 @@ static int cdrom_write_check_ireason(ide_drive_t *drive, int len, int ireason)
>  		return 0;
>  	else if (ireason == 2) {
>  		/* Whoops... The drive wants to send data. */
> -		printk(KERN_ERR "%s: write_intr: wrong transfer direction!\n",
> -							drive->name);
> +		printk(KERN_ERR "%s: %s: wrong transfer direction!\n",
> +				drive->name, __FUNCTION__);
>  
>  		while (len > 0) {
>  			int dum = 0;
> @@ -1642,8 +1645,8 @@ static int cdrom_write_check_ireason(ide_drive_t *drive, int len, int ireason)
>  		}
>  	} else {
>  		/* Drive wants a command packet, or invalid ireason... */
> -		printk(KERN_ERR "%s: write_intr: bad interrupt reason %x\n",
> -							drive->name, ireason);
> +		printk(KERN_ERR "%s: %s: bad interrupt reason 0x%02x\n",
> +				drive->name, __FUNCTION__, ireason);
>  	}
>  
>  	cdrom_end_request(drive, 0);
> @@ -1805,8 +1808,9 @@ static ide_startstop_t cdrom_write_intr(ide_drive_t *drive)
>  	/* Check for errors. */
>  	if (dma) {
>  		info->dma = 0;
> -		if ((dma_error = HWIF(drive)->ide_dma_end(drive))) {
> -			printk(KERN_ERR "ide-cd: write dma error\n");
> +		dma_error = HWIF(drive)->ide_dma_end(drive);
> +		if (dma_error) {
> +			printk(KERN_ERR "%s: DMA write error\n", drive->name);
>  			ide_dma_off(drive);
>  		}
>  	}
> @@ -1826,7 +1830,7 @@ static ide_startstop_t cdrom_write_intr(ide_drive_t *drive)
>  	}
>  
>  	/* Read the interrupt reason and the transfer length. */
> -	ireason = HWIF(drive)->INB(IDE_IREASON_REG);
> +	ireason = HWIF(drive)->INB(IDE_IREASON_REG) & 0x3;
>  	lowcyl  = HWIF(drive)->INB(IDE_BCOUNTL_REG);
>  	highcyl = HWIF(drive)->INB(IDE_BCOUNTH_REG);
>  
> @@ -1839,8 +1843,9 @@ static ide_startstop_t cdrom_write_intr(ide_drive_t *drive)
>  		 */
>  		uptodate = 1;
>  		if (rq->current_nr_sectors > 0) {
> -			printk(KERN_ERR "%s: write_intr: data underrun (%d blocks)\n",
> -			drive->name, rq->current_nr_sectors);
> +			printk(KERN_ERR "%s: %s: data underrun (%d blocks)\n",
> +					drive->name, __FUNCTION__,
> +					rq->current_nr_sectors);
>  			uptodate = 0;
>  		}
>  		cdrom_end_request(drive, uptodate);
> @@ -1860,7 +1865,8 @@ static ide_startstop_t cdrom_write_intr(ide_drive_t *drive)
>  		int this_transfer;
>  
>  		if (!rq->current_nr_sectors) {
> -			printk(KERN_ERR "ide-cd: write_intr: oops\n");
> +			printk(KERN_ERR "%s: %s: confused, missing data\n",
> +					drive->name, __FUNCTION__);
>  			break;
>  		}
>  
> @@ -2688,14 +2694,14 @@ void ide_cdrom_update_speed (ide_drive_t *drive, struct atapi_capabilities_page
>  	if (!drive->id->model[0] &&
>  	    !strncmp(drive->id->fw_rev, "241N", 4)) {
>  		CDROM_STATE_FLAGS(drive)->current_speed  =
> -			(((unsigned int)cap->curspeed) + (176/2)) / 176;
> +			(le16_to_cpu(cap->curspeed) + (176/2)) / 176;
>  		CDROM_CONFIG_FLAGS(drive)->max_speed =
> -			(((unsigned int)cap->maxspeed) + (176/2)) / 176;
> +			(le16_to_cpu(cap->maxspeed) + (176/2)) / 176;
>  	} else {
>  		CDROM_STATE_FLAGS(drive)->current_speed  =
> -			(ntohs(cap->curspeed) + (176/2)) / 176;
> +			(be16_to_cpu(cap->curspeed) + (176/2)) / 176;
>  		CDROM_CONFIG_FLAGS(drive)->max_speed =
> -			(ntohs(cap->maxspeed) + (176/2)) / 176;
> +			(be16_to_cpu(cap->maxspeed) + (176/2)) / 176;
>  	}
>  }
>  
> @@ -2909,6 +2915,9 @@ static int ide_cdrom_register (ide_drive_t *drive, int nslots)
>  	if (!CDROM_CONFIG_FLAGS(drive)->ram)
>  		devinfo->mask |= CDC_RAM;
>  
> +	if (CDROM_CONFIG_FLAGS(drive)->no_speed_select)
> +		devinfo->mask |= CDC_SELECT_SPEED;
> +
>  	devinfo->disk = info->disk;
>  	return register_cdrom(devinfo);
>  }
> @@ -3161,7 +3170,7 @@ int ide_cdrom_setup (ide_drive_t *drive)
>  		CDROM_CONFIG_FLAGS(drive)->limit_nframes = 1;
>  	/* the 3231 model does not support the SET_CD_SPEED command */
>  	else if (!strcmp(drive->id->model, "SAMSUNG CD-ROM SCR-3231"))
> -		cdi->mask |= CDC_SELECT_SPEED;
> +		CDROM_CONFIG_FLAGS(drive)->no_speed_select = 1;
>  
>  #if ! STANDARD_ATAPI
>  	/* by default Sanyo 3 CD changer support is turned off and
> @@ -3504,15 +3513,8 @@ static int ide_cd_probe(ide_drive_t *drive)
>  	g->driverfs_dev = &drive->gendev;
>  	g->flags = GENHD_FL_CD | GENHD_FL_REMOVABLE;
>  	if (ide_cdrom_setup(drive)) {
> -		struct cdrom_device_info *devinfo = &info->devinfo;
>  		ide_proc_unregister_driver(drive, &ide_cdrom_driver);
> -		kfree(info->buffer);
> -		kfree(info->toc);
> -		kfree(info->changer_info);
> -		if (devinfo->handle == drive && unregister_cdrom(devinfo))
> -			printk (KERN_ERR "%s: ide_cdrom_cleanup failed to unregister device from the cdrom 
> driver.\n", drive->name);
> -		kfree(info);
> -		drive->driver_data = NULL;
> +		ide_cd_release(&info->kref);
>  		goto failed;
>  	}
>  
> diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
> index 228b29c..1b302fe 100644
> --- a/drivers/ide/ide-cd.h
> +++ b/drivers/ide/ide-cd.h
> @@ -91,7 +91,8 @@ struct ide_cd_config_flags {
>  	__u8 close_tray		: 1; /* can close the tray */
>  	__u8 writing		: 1; /* pseudo write in progress */
>  	__u8 mo_drive		: 1; /* drive is an MO device */
> -	__u8 reserved		: 2;
> +	__u8 no_speed_select	: 1; /* SET_CD_SPEED command is unsupported. */
> +	__u8 reserved		: 1;
>  	byte max_speed;		     /* Max speed of the drive */
>  };
>  #define CDROM_CONFIG_FLAGS(drive) (&(((struct cdrom_info *)(drive->driver_data))->config_flags))
> diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
> index 51fca44..bc55333 100644
> --- a/drivers/ide/pci/cmd64x.c
> +++ b/drivers/ide/pci/cmd64x.c
> @@ -1,5 +1,5 @@
>  /*
> - * linux/drivers/ide/pci/cmd64x.c		Version 1.51	Nov 8, 2007
> + * linux/drivers/ide/pci/cmd64x.c		Version 1.52	Dec 24, 2007
>   *
>   * cmd64x.c: Enable interrupts at initialization time on Ultra/PCI machines.
>   *           Due to massive hardware bugs, UltraDMA is only supported
> @@ -564,6 +564,7 @@ static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
>  		.init_chipset	= init_chipset_cmd64x,
>  		.init_hwif	= init_hwif_cmd64x,
>  		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
> +		.chipset	= ide_cmd646,
>  		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH | IDE_HFLAG_BOOTABLE,
>  		.pio_mask	= ATA_PIO5,
>  		.mwdma_mask	= ATA_MWDMA2,
> @@ -573,7 +574,6 @@ static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
>  		.init_chipset	= init_chipset_cmd64x,
>  		.init_hwif	= init_hwif_cmd64x,
>  		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
> -		.chipset	= ide_cmd646,
>  		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH | IDE_HFLAG_BOOTABLE,
>  		.pio_mask	= ATA_PIO5,
>  		.mwdma_mask	= ATA_MWDMA2,
> diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
> index 9094916..ddcbeba 100644
> --- a/drivers/ide/pci/cs5535.c
> +++ b/drivers/ide/pci/cs5535.c
> @@ -49,7 +49,7 @@
>  #define ATAC_BM0_PRD		0x04
>  #define CS5535_CABLE_DETECT	0x48
>  
> -/* Format I PIO settings. We seperate out cmd and data for safer timings */
> +/* Format I PIO settings. We separate out cmd and data for safer timings */
>  
>  static unsigned int cs5535_pio_cmd_timings[5] =
>  { 0xF7F4, 0x53F3, 0x13F1, 0x5131, 0x1131 };

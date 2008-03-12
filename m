Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbYCLT0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbYCLT0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 15:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYCLT0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 15:26:39 -0400
Received: from h155.mvista.com ([63.81.120.155]:17891 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751756AbYCLT0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 15:26:37 -0400
Message-ID: <47D82EB9.1060603@ru.mvista.com>
Date: Wed, 12 Mar 2008 22:27:53 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ide: add struct ide_dma_ops
References: <200803091700.46136.bzolnier@gmail.com>
In-Reply-To: <200803091700.46136.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again. :-)

Bartlomiej Zolnierkiewicz wrote:

> Add struct ide_dma_ops and convert core code + drivers to use it.

> While at it:

> * Drop "ide_" prefix from ->ide_dma_end and ->ide_dma_test_irq methods.

    I have expect you to drop the prefix from the method implementations which 
didn't happen...

> * siimage.c:
>   - add siimage_ide_dma_test_irq() helper

    ... at least you shouldn't have added the new ones. :-)

>   - print SATA warning in siimage_init_one()

> * Remove no longer needed ->init_hwif implementations.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

    I'd expect some init code weight loss at the expense of one more 
indirection when calling the methods... :-)
    Unfortunately, the patch is not entirely correct...

> Index: b/drivers/ide/ide-cd.c
> ===================================================================
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
[...]
> @@ -929,7 +929,7 @@ static ide_startstop_t cdrom_newpc_intr(
>  	dma = info->dma;
>  	if (dma) {
>  		info->dma = 0;
> -		dma_error = HWIF(drive)->ide_dma_end(drive);
> +		dma_error = hwif->dma_ops->dma_end(drive);

    Erm, I don't see 'hwif' declared in that function -- this won't compile.
Though wait, some patch adds it... OK.

> Index: b/drivers/ide/ide-floppy.c
> ===================================================================
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c
> @@ -411,7 +411,7 @@ static ide_startstop_t idefloppy_pc_intr
>  	debug_log("Reached %s interrupt handler\n", __func__);
>  
>  	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
> -		dma_error = hwif->ide_dma_end(drive);
> +		dma_error = drive->hwif->dma_ops->dma_end(drive);

    Here we, contrarily, already have 'hwif', so no need for extra indirection...

> Index: b/drivers/ide/mips/au1xxx-ide.c
> ===================================================================
> --- a/drivers/ide/mips/au1xxx-ide.c
> +++ b/drivers/ide/mips/au1xxx-ide.c
> @@ -371,21 +371,31 @@ static void auide_init_dbdma_dev(dbdev_t
>  	dev->dev_devwidth    = devwidth;
>  	dev->dev_flags       = flags;
>  }
> -  
> -#if defined(CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA)
>  
> +#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
>  static void auide_dma_timeout(ide_drive_t *drive)
>  {
>  	ide_hwif_t *hwif = HWIF(drive);
>  
>  	printk(KERN_ERR "%s: DMA timeout occurred: ", drive->name);
>  
> -	if (hwif->ide_dma_test_irq(drive))
> +	if (auide_dma_test_irq(drive))
>  		return;
>  
> -	hwif->ide_dma_end(drive);
> +	auide_dma_end(drive);
>  }

    Probably worth noting under "while at it"?

> +static struct ide_dma_ops auide_dma_ops = {
> +	.dma_host_set		= auide_dma_host_set,
> +	.dma_setup		= auide_dma_setup,
> +	.dma_exec_cmd		= auide_dma_exec_cmd,
> +	.dma_start		= auide_dma_start,
> +	.dma_end		= auide_dma_end,
> +	.dma_test_irq		= auide_dma_test_irq,
> +	.dma_lost_irq		= auide_dma_lost_irq,
> +	.dma_timeout		= auide_dma_timeout,
> +};
> +
>  static int auide_ddma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
>  {
>  	_auide_hwif *auide = (_auide_hwif *)hwif->hwif_data;
> @@ -516,6 +526,9 @@ static const struct ide_port_ops au1xxx_
>  static const struct ide_port_info au1xxx_port_info = {
>  	.init_dma		= auide_ddma_init,
>  	.port_ops		= &au1xxx_port_ops,
> +#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
> +	.dma_ops		= &au1xxx_dma_ops,

    You need to decide between au1xxx_ and auide_ prefixes, or the file won't 
compile... ;-)

> Index: b/drivers/ide/pci/cmd64x.c
> ===================================================================
> --- a/drivers/ide/pci/cmd64x.c
> +++ b/drivers/ide/pci/cmd64x.c
> @@ -385,62 +385,33 @@ static u8 __devinit cmd64x_cable_detect(
[...]

> +static struct ide_dma_ops cmd643_dma_ops = {

    Perhaps cmd64x_ prefix would match better here...

> +	.dma_end		= cmd64x_ide_dma_end,
> +	.dma_test_irq		= cmd64x_ide_dma_test_irq,
> +};
> +
> +static struct ide_dma_ops cmd646_rev1_dma_ops = {
> +	.dma_end		= cmd646_1_ide_dma_end,
> +};
> +
> +static struct ide_dma_ops cmd64x_dma_ops = {
> +	.dma_end		= cmd648_ide_dma_end,
> +	.dma_test_irq		= cmd648_ide_dma_test_irq,
> +};

    ... and cmd648_ prefix here.
    And why not drop the remaning ide_ "infixes" from functions while at it?

> Index: b/drivers/ide/pci/hpt366.c
> ===================================================================
> --- a/drivers/ide/pci/hpt366.c
> +++ b/drivers/ide/pci/hpt366.c

    Alas, this part looks incorrect...

> @@ -1312,19 +1312,6 @@ static void __devinit init_hwif_hpt366(i
>  
>  	if (new_mcr != old_mcr)
>  		pci_write_config_byte(dev, hwif->select_data + 1, new_mcr);
> -
> -	if (hwif->dma_base == 0)
> -		return;
> -
> -	if (chip_type >= HPT374) {
> -		hwif->ide_dma_test_irq	= &hpt374_ide_dma_test_irq;
> -		hwif->ide_dma_end	= &hpt374_ide_dma_end;
> -	} else if (chip_type >= HPT370) {
> -		hwif->dma_start 	= &hpt370_ide_dma_start;
> -		hwif->ide_dma_end	= &hpt370_ide_dma_end;
> -		hwif->dma_timeout	= &hpt370_dma_timeout;
> -	} else
> -		hwif->dma_lost_irq	= &hpt366_dma_lost_irq;
>  }
>  
>  static int __devinit init_dma_hpt366(ide_hwif_t *hwif,
[...]
> @@ -1428,6 +1415,21 @@ static const struct ide_port_ops hpt3xx_
>  	.cable_detect		= hpt3xx_cable_detect,
>  };
>  
> +static struct ide_dma_ops hpt3xxx_dma_ops = {

    HPT3xxx is a RAID chip I heard. :-) Keep the prefix hpt37x_ please

> +	.dma_end		= hpt374_ide_dma_end,
> +	.dma_test_irq		= hpt374_ide_dma_test_irq,
> +};
> +
> +static struct ide_dma_ops hpt370x_dma_ops = {

    ... and this one just hpt370_.

> +	.dma_start		= hpt370_ide_dma_start,
> +	.dma_end		= hpt370_ide_dma_end,
> +	.dma_timeout		= hpt370_dma_timeout,
> +};
> +
> +static struct ide_dma_ops hpt36x_dma_ops = {
> +	.dma_lost_irq		= hpt366_dma_lost_irq,
> +};
> +
>  static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
>  	{	/* 0 */
>  		.name		= "HPT36x",
[...]
> @@ -1452,6 +1455,7 @@ static const struct ide_port_info hpt366
>  		.init_dma	= init_dma_hpt366,
>  		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
>  		.port_ops	= &hpt3xx_port_ops,
> +		.dma_ops	= &hpt3xxx_dma_ops,

    For HPT372A/N it should be hpt37x_. Correct.

>  		.host_flags	= IDE_HFLAGS_HPT3XX,
>  		.pio_mask	= ATA_PIO4,
>  		.mwdma_mask	= ATA_MWDMA2,
> @@ -1472,6 +1476,7 @@ static const struct ide_port_info hpt366
>  		.init_dma	= init_dma_hpt366,
>  		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
>  		.port_ops	= &hpt3xx_port_ops,
> +		.dma_ops	= &hpt370x_dma_ops,

    For HPT302/N it should be hpt37x_. Incorrect.

>  		.host_flags	= IDE_HFLAGS_HPT3XX,
>  		.pio_mask	= ATA_PIO4,
>  		.mwdma_mask	= ATA_MWDMA2,
> @@ -1483,6 +1488,7 @@ static const struct ide_port_info hpt366
>  		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
>  		.udma_mask	= ATA_UDMA5,
>  		.port_ops	= &hpt3xx_port_ops,
> +		.dma_ops	= &hpt370x_dma_ops,

    For HPT371/N it should be hpt37x_. Incorrect.

>  		.host_flags	= IDE_HFLAGS_HPT3XX,
>  		.pio_mask	= ATA_PIO4,
>  		.mwdma_mask	= ATA_MWDMA2,
> @@ -1493,6 +1499,7 @@ static const struct ide_port_info hpt366
>  		.init_dma	= init_dma_hpt366,
>  		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
>  		.port_ops	= &hpt3xx_port_ops,
> +		.dma_ops	= &hpt3xxx_dma_ops,

    For HPT34 it should be hpt37x_. Correct.

>  		.host_flags	= IDE_HFLAGS_HPT3XX,
>  		.pio_mask	= ATA_PIO4,
>  		.mwdma_mask	= ATA_MWDMA2,

    Now where is the code which selects the correct dma_ops for the 
HPT36x/370/372/372N chip with device ID 4 I'm asking you? :-)

> Index: b/drivers/ide/pci/it821x.c
> ===================================================================
> --- a/drivers/ide/pci/it821x.c
> +++ b/drivers/ide/pci/it821x.c
> @@ -511,6 +511,11 @@ static void __devinit it821x_quirkproc(i
>  
>  }
>  
> +static struct ide_dma_ops it821x_smart_dma_ops = {

    I've got an impression that the mode is contrarywise -- non-SMART...

> +	.dma_start		= it821x_dma_start,
> +	.dma_end		= it821x_dma_end,
> +};
> +
>  /**
>   *	init_hwif_it821x	-	set up hwif structs
>   *	@hwif: interface to set up
> @@ -562,8 +567,7 @@ static void __devinit init_hwif_it821x(i
>  
>  	if (idev->smart == 0) {
>  		/* MWDMA/PIO clock switching for pass through mode */
> -		hwif->dma_start = &it821x_dma_start;
> -		hwif->ide_dma_end = &it821x_dma_end;
> +		hwif->dma_ops = &it821x_smart_dma_ops;
>  	} else
>  		hwif->host_flags |= IDE_HFLAG_NO_SET_MODE;

    See for yourself...

> Index: b/drivers/ide/pci/ns87415.c
> ===================================================================
> --- a/drivers/ide/pci/ns87415.c
> +++ b/drivers/ide/pci/ns87415.c
> @@ -252,14 +252,17 @@ static void __devinit init_hwif_ns87415 
>  		return;
>  
>  	outb(0x60, hwif->dma_status);
> -	hwif->dma_setup = &ns87415_ide_dma_setup;
> -	hwif->ide_dma_end = &ns87415_ide_dma_end;
>  }
>  
>  static const struct ide_port_ops ns87415_port_ops = {
>  	.selectproc		= ns87415_selectproc,
>  };
>  
> +static struct ide_dma_ops ns87415_dma_ops = {
> +	.dma_setup		= ns87415_ide_dma_setup,
> +	.dma_end		= ns87415_ide_dma_end,
> +};
> +

    Time to drop ide_ "infixes" here too?

> Index: b/drivers/ide/pci/pdc202xx_old.c
> ===================================================================
> --- a/drivers/ide/pci/pdc202xx_old.c
> +++ b/drivers/ide/pci/pdc202xx_old.c
> @@ -263,23 +263,6 @@ static void pdc202xx_dma_timeout(ide_dri
>  	ide_dma_timeout(drive);
>  }
>  
> -static void __devinit init_hwif_pdc202xx(ide_hwif_t *hwif)
> -{
> -	struct pci_dev *dev = to_pci_dev(hwif->dev);
> -
> -	if (hwif->dma_base == 0)
> -		return;
> -
> -	hwif->dma_lost_irq = &pdc202xx_dma_lost_irq;
> -	hwif->dma_timeout = &pdc202xx_dma_timeout;
> -
> -	if (dev->device != PCI_DEVICE_ID_PROMISE_20246) {
> -		hwif->dma_start = &pdc202xx_old_ide_dma_start;
> -		hwif->ide_dma_end = &pdc202xx_old_ide_dma_end;
> -	} 
> -	hwif->ide_dma_test_irq = &pdc202xx_old_ide_dma_test_irq;
> -}
> -
>  static unsigned int __devinit init_chipset_pdc202xx(struct pci_dev *dev,
>  						    const char *name)
>  {
> @@ -346,12 +329,26 @@ static const struct ide_port_ops pdc2026
>  	.cable_detect		= pdc2026x_cable_detect,
>  };
>  
> +static struct ide_dma_ops pdc20246_dma_ops = {
> +	.dma_test_irq		= pdc202xx_old_ide_dma_test_irq,

    Infixes galore! I'd killed both old_ and ide_ (but not Old IDE :-).
Much shorter and uniform name.

> +	.dma_lost_irq		= pdc202xx_dma_lost_irq,
> +	.dma_timeout		= pdc202xx_dma_timeout,
> +};
> +
> +static struct ide_dma_ops pdc2026x_dma_ops = {
> +	.dma_start		= pdc202xx_old_ide_dma_start,
> +	.dma_end		= pdc202xx_old_ide_dma_end,
> +	.dma_test_irq		= pdc202xx_old_ide_dma_test_irq,

    Drop 'em both! :-)

> Index: b/drivers/ide/pci/sc1200.c
> ===================================================================
> --- a/drivers/ide/pci/sc1200.c
> +++ b/drivers/ide/pci/sc1200.c
> @@ -214,7 +214,7 @@ static void sc1200_set_pio_mode(ide_driv
>  		printk("SC1200: %s: changing (U)DMA mode\n", drive->name);
>  		ide_dma_off_quietly(drive);
>  		if (ide_set_dma_mode(drive, mode) == 0 && drive->using_dma)
> -			hwif->dma_host_set(drive, 1);
> +			hwif->dma_ops->dma_host_set(drive, 1);
>  		return;
>  	}
>  
> @@ -286,28 +286,20 @@ static int sc1200_resume (struct pci_dev
>  }
>  #endif
>  
> -/*
> - * This gets invoked by the IDE driver once for each channel,
> - * and performs channel-specific pre-initialization before drive probing.
> - */
> -static void __devinit init_hwif_sc1200 (ide_hwif_t *hwif)
> -{
> -	if (hwif->dma_base == 0)
> -		return;
> -
> -	hwif->ide_dma_end   = &sc1200_ide_dma_end;
> -}
> -
>  static const struct ide_port_ops sc1200_port_ops = {
>  	.set_pio_mode		= sc1200_set_pio_mode,
>  	.set_dma_mode		= sc1200_set_dma_mode,
>  	.udma_filter		= sc1200_udma_filter,
>  };
>  
> +static struct ide_dma_ops sc1200_dma_ops = {
> +	.dma_end		= sc1200_ide_dma_end,

    Again, dropping "infix" is possible...

> Index: b/drivers/ide/pci/scc_pata.c
> ===================================================================
> --- a/drivers/ide/pci/scc_pata.c
> +++ b/drivers/ide/pci/scc_pata.c
> @@ -659,10 +659,6 @@ static void __devinit init_hwif_scc(ide_
>  	/* PTERADD */
>  	out_be32((void __iomem *)(hwif->dma_base + 0x018), hwif->dmatable_dma);
>  
> -	hwif->dma_setup = scc_dma_setup;
> -	hwif->ide_dma_end = scc_ide_dma_end;
> -	hwif->ide_dma_test_irq = scc_dma_test_irq;
> -
>  	if (in_be32((void __iomem *)(hwif->config_data + 0xff0)) & CCKCTRL_ATACLKOEN)
>  		hwif->ultra_mask = ATA_UDMA6; /* 133MHz */
>  	else
> @@ -676,12 +672,19 @@ static const struct ide_port_ops scc_por
>  	.cable_detect		= scc_cable_detect,
>  };
>  
> +static struct ide_dma_ops scc_dma_ops = {
> +	.dma_setup		= scc_dma_setup,
> +	.dma_end		= scc_ide_dma_end,

    And here too.

> Index: b/drivers/ide/pci/sgiioc4.c
> ===================================================================
> --- a/drivers/ide/pci/sgiioc4.c
> +++ b/drivers/ide/pci/sgiioc4.c
[...]
> @@ -575,10 +560,21 @@ static const struct ide_port_ops sgiioc4
>  	.maskproc		= sgiioc4_maskproc,
>  };
>  
> +static struct ide_dma_ops sgiioc4_dma_ops = {
> +	.dma_host_set		= sgiioc4_dma_host_set,
> +	.dma_setup		= sgiioc4_ide_dma_setup,
> +	.dma_start		= sgiioc4_ide_dma_start,
> +	.dma_end		= sgiioc4_ide_dma_end,
> +	.dma_test_irq		= sgiioc4_ide_dma_test_irq,
> +	.dma_lost_irq		= sgiioc4_dma_lost_irq,
> +	.dma_timeout		= ide_dma_timeout,
> +};
> +

    Wow, a lot of survived infixes! :-)

> Index: b/drivers/ide/pci/siimage.c
> ===================================================================
> --- a/drivers/ide/pci/siimage.c
> +++ b/drivers/ide/pci/siimage.c
> @@ -369,6 +369,14 @@ static int siimage_mmio_ide_dma_test_irq
>  	return 0;
>  }
>  
> +static int siimage_ide_dma_test_irq(ide_drive_t *drive)
> +{
> +	if (drive->hwif->mmio)
> +		return siimage_mmio_ide_dma_test_irq(drive);
> +	else
> +		return siimage_io_ide_dma_test_irq(drive);
> +}
> +

    I suggest removing infixes from the above functions instead of adding 
another one...

> Index: b/include/linux/ide.h
> ===================================================================
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
[...]
> @@ -459,15 +471,7 @@ typedef struct hwif_s {
>  	void (*atapi_input_bytes)(ide_drive_t *, void *, u32);
>  	void (*atapi_output_bytes)(ide_drive_t *, void *, u32);
>  
> -	void (*dma_host_set)(ide_drive_t *, int);
> -	int (*dma_setup)(ide_drive_t *);
> -	void (*dma_exec_cmd)(ide_drive_t *, u8);
> -	void (*dma_start)(ide_drive_t *);
> -	int (*ide_dma_end)(ide_drive_t *drive);
> -	int (*ide_dma_test_irq)(ide_drive_t *drive);
>  	void (*ide_dma_clear_irq)(ide_drive_t *drive);

    Now what about this lonely method? It belongs to dma_ops I think...

MBR, Sergei

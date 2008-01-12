Return-Path: <linux-kernel-owner+w=401wt.eu-S1761377AbYALUEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761377AbYALUEz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 15:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756907AbYALUEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 15:04:46 -0500
Received: from h155.mvista.com ([63.81.120.155]:64203 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755659AbYALUEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 15:04:44 -0500
Message-ID: <47891D8D.4010609@ru.mvista.com>
Date: Sat, 12 Jan 2008 23:05:33 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] ide: add ->cable_detect method to ide_hwif_t
References: <20080106170220.6861.4814.sendpatchset@localhost.localdomain> <20080106170317.6861.77734.sendpatchset@localhost.localdomain>
In-Reply-To: <20080106170317.6861.77734.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> * Add ->cable_detect method to ide_hwif_t.

> * Call the new method in ide_init_port() if:
>   - the host supports UDMA modes > UDMA2 ('hwif->ultra_mask & 78')
>   - DMA initialization was successful (if hwif->dma_base is not set
>     ide_init_port() sets hwif->ultra_mask to zero)
>   - "idex=ata66" is not used ('hwif->cbl != ATA_CBL_PATA40_SHORT')

> * Convert PCI host drivers to use ->cable_detect method.

> While at it:

> * Factor out cable detection to separate functions (if not already done).

> * hpt366.c/it8213.c/slc90e66.c:
>   - don't check cable type if "idex=ata66" is used

> * pdc202xx_new.c:
>   - add __devinit tag to pdcnew_cable_detect()

> * pdc202xx_old.c:
>   - rename pdc202xx_old_cable_detect() to pdc2026x_old_cable_detect()
>   - add __devinit tag to pdc2026x_old_cable_detect()

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> Index: b/drivers/ide/ide-probe.c
> ===================================================================
> --- a/drivers/ide/ide-probe.c
> +++ b/drivers/ide/ide-probe.c
> @@ -1343,6 +1343,11 @@ static void ide_init_port(ide_hwif_t *hw
>  	/* call chipset specific routine for each enabled port */
>  	if (d->init_hwif)
>  		d->init_hwif(hwif);
> +
> +	if (hwif->cable_detect && (hwif->ultra_mask & 0x78)) {
> +		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
> +			hwif->cbl = hwif->cable_detect(hwif);
> +	}

    Could be collapsed to a single *if* statement...

> Index: b/drivers/ide/pci/alim15x3.c
> ===================================================================
> --- a/drivers/ide/pci/alim15x3.c
> +++ b/drivers/ide/pci/alim15x3.c
> @@ -666,13 +666,12 @@ static void __devinit init_hwif_common_a
>  	hwif->set_dma_mode = &ali_set_dma_mode;
>  	hwif->udma_filter = &ali_udma_filter;
>  
> +	hwif->cable_detect = ata66_ali15x3;

    Why not give that function a "standard" name while at it?

>  static const struct ide_port_info atiixp_pci_info[] __devinitdata = {
> Index: b/drivers/ide/pci/cmd64x.c
> ===================================================================
> --- a/drivers/ide/pci/cmd64x.c
> +++ b/drivers/ide/pci/cmd64x.c
> @@ -393,6 +393,8 @@ static void __devinit init_hwif_cmd64x(i
>  	hwif->set_pio_mode = &cmd64x_set_pio_mode;
>  	hwif->set_dma_mode = &cmd64x_set_dma_mode;
>  
> +	hwif->cable_detect = ata66_cmd64x;
> +

    Same question...

> Index: b/drivers/ide/pci/hpt366.c
> ===================================================================
> --- a/drivers/ide/pci/hpt366.c
> +++ b/drivers/ide/pci/hpt366.c
> @@ -1279,12 +1279,55 @@ static unsigned int __devinit init_chips
>  	return dev->irq;
>  }
>  
> +static u8 __devinit hpt3xx_cable_detect(ide_hwif_t *hwif)
> +{
> +	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
> +	struct hpt_info *info	= pci_get_drvdata(dev);
> +	u8 chip_type		= info->chip_type;
> +	u8 scr1 = 0, ata66	= hwif->channel ? 0x01 : 0x02;

    The 'ata66' is pretty bad name for this variable (reversed sense), let's 
go with 'mask'...

> +
> +	/*
> +	 * The HPT37x uses the CBLID pins as outputs for MA15/MA16
> +	 * address lines to access an external EEPROM.  To read valid
> +	 * cable detect state the pins must be enabled as inputs.
> +	 */
> +	if (chip_type == HPT374 && (PCI_FUNC(dev->devfn) & 1)) {
> +		/*
> +		 * HPT374 PCI function 1
> +		 * - set bit 15 of reg 0x52 to enable TCBLID as input
> +		 * - set bit 15 of reg 0x56 to enable FCBLID as input
> +		 */
> +		u8  mcr_addr = hwif->select_data + 2;
> +		u16 mcr;
> +
> +		pci_read_config_word(dev, mcr_addr, &mcr);
> +		pci_write_config_word(dev, mcr_addr, (mcr | 0x8000));
> +		/* now read cable id register */
> +		pci_read_config_byte(dev, 0x5a, &scr1);
> +		pci_write_config_word(dev, mcr_addr, mcr);
> +	} else if (chip_type >= HPT370) {
> +		/*
> +		 * HPT370/372 and 374 pcifn 0
> +		 * - clear bit 0 of reg 0x5b to enable P/SCBLID as inputs
> +		 */
> +		u8 scr2 = 0;
> +
> +		pci_read_config_byte(dev, 0x5b, &scr2);
> +		pci_write_config_byte(dev, 0x5b, (scr2 & ~1));
> +		/* now read cable id register */
> +		pci_read_config_byte(dev, 0x5a, &scr1);
> +		pci_write_config_byte(dev, 0x5b,  scr2);

    Sigh, my pretty formatting is gone... at least don't leave double spaces 
and needless parens. :-)

> +	} else
> +		pci_read_config_byte(dev, 0x5a, &scr1);
> +
> +	return (scr1 & ata66) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
> +}
> +
[...]
> --- a/drivers/ide/pci/it8213.c
> +++ b/drivers/ide/pci/it8213.c
> Index: b/drivers/ide/pci/it821x.c
> ===================================================================
> --- a/drivers/ide/pci/it821x.c
> +++ b/drivers/ide/pci/it821x.c
> @@ -579,14 +579,13 @@ static void __devinit init_hwif_it821x(i
>  	} else
>  		hwif->host_flags |= IDE_HFLAG_NO_SET_MODE;
>  
> +	hwif->cable_detect = ata66_it821x;
> +

    I think the function is really worth renaming...

>  static void __devinit it8212_disable_raid(struct pci_dev *dev)
> Index: b/drivers/ide/pci/jmicron.c
> ===================================================================
> --- a/drivers/ide/pci/jmicron.c
> +++ b/drivers/ide/pci/jmicron.c
> @@ -111,11 +111,7 @@ static void __devinit init_hwif_jmicron(
>  	hwif->set_pio_mode = &jmicron_set_pio_mode;
>  	hwif->set_dma_mode = &jmicron_set_dma_mode;
>  
> -	if (hwif->dma_base == 0)
> -		return;
> -
> -	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
> -		hwif->cbl = ata66_jmicron(hwif);
> +	hwif->cable_detect = ata66_jmicron;

    And this one too...

> Index: b/drivers/ide/pci/pdc202xx_old.c
> ===================================================================
> --- a/drivers/ide/pci/pdc202xx_old.c
> +++ b/drivers/ide/pci/pdc202xx_old.c
> @@ -140,7 +140,7 @@ static void pdc202xx_set_pio_mode(ide_dr
>  	pdc202xx_set_mode(drive, XFER_PIO_0 + pio);
>  }
>  
> -static u8 pdc202xx_old_cable_detect (ide_hwif_t *hwif)
> +static u8 __devinit pdc2026x_old_cable_detect(ide_hwif_t *hwif)

    I suggest just pdc2026x_ without old_.

>  #define DECLARE_SCC_DEV(name_str)			\
> Index: b/drivers/ide/pci/serverworks.c
> ===================================================================
> --- a/drivers/ide/pci/serverworks.c
> +++ b/drivers/ide/pci/serverworks.c
> @@ -346,13 +346,8 @@ static void __devinit init_hwif_svwks (i
>  	hwif->set_dma_mode = &svwks_set_dma_mode;
>  	hwif->udma_filter = &svwks_udma_filter;
>  
> -	if (!hwif->dma_base)
> -		return;
> -
> -	if (dev->device != PCI_DEVICE_ID_SERVERWORKS_OSB4IDE) {
> -		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
> -			hwif->cbl = ata66_svwks(hwif);
> -	}
> +	if (dev->device != PCI_DEVICE_ID_SERVERWORKS_OSB4IDE)
> +		hwif->cable_detect = ata66_svwks;

    Worth renaming...

> Index: b/drivers/ide/pci/siimage.c
> ===================================================================
> --- a/drivers/ide/pci/siimage.c
> +++ b/drivers/ide/pci/siimage.c
> @@ -827,15 +827,14 @@ static void __devinit init_hwif_siimage(
>  	} else
>  		hwif->udma_filter = &sil_pata_udma_filter;
>  
> +	hwif->cable_detect = ata66_siimage;
> +

    That one too...

> Index: b/drivers/ide/pci/sis5513.c
> ===================================================================
> --- a/drivers/ide/pci/sis5513.c
> +++ b/drivers/ide/pci/sis5513.c
> @@ -565,13 +565,12 @@ static void __devinit init_hwif_sis5513 
>  	if (chipset_family >= ATA_133)
>  		hwif->udma_filter = sis5513_ata133_udma_filter;
>  
> +	hwif->cable_detect = ata66_sis5513;
> +

   Another one...

MBR, Sergei

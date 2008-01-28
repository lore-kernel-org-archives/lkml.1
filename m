Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbYA1U1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbYA1U1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYA1U1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:27:34 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:64774 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751321AbYA1U1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:27:32 -0500
Message-ID: <479E3AEA.5090600@ru.mvista.com>
Date: Mon, 28 Jan 2008 23:28:26 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] ide: add struct ide_port_info instances to legacy
 host drivers
References: <20080106170220.6861.4814.sendpatchset@localhost.localdomain> <20080106170310.6861.14522.sendpatchset@localhost.localdomain>
In-Reply-To: <20080106170310.6861.14522.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> * Remove 'struct pci_dev *dev' argument from ide_hwif_setup_dma().

> * Un-static ide_hwif_setup_dma() and add CONFIG_BLK_DEV_IDEDMA_PCI=n version.

> * Add 'const struct ide_port_info *d' argument to ide_device_add[_all]().

> * Factor out generic ports init from ide_pci_setup_ports() to ide_init_port(),
>   move it to ide-probe.c and call it in in ide_device_add_all() instead of
>   ide_pci_setup_ports().

> * Move ->mate setup to ide_device_add_all() from ide_port_init().

> * Add IDE_HFLAG_NO_AUTOTUNE host flag for host drivers that don't enable
>   ->autotune currently.

> * Setup hwif->chipset in ide_init_port() but iff pi->chipset is set
>   (to not override setup done by ide_hwif_configure()).

> * Add ETRAX host handling to ide_device_add_all().

> * cmd640.c: set IDE_HFLAG_ABUSE_* also for CONFIG_BLK_DEV_CMD640_ENHANCED=n.

> * pmac.c: make pmac_ide_setup_dma() return an error value and move DMA masks
>   setup to pmac_ide_setup_device().

> * Add 'struct ide_port_info' instances to legacy host drivers, pass them to
>   ide_device_add() calls and then remove open-coded ports initialization.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> Index: b/drivers/ide/arm/icside.c
> ===================================================================
> --- a/drivers/ide/arm/icside.c
> +++ b/drivers/ide/arm/icside.c
> @@ -459,11 +456,19 @@ icside_register_v5(struct icside_state *
>  
>  	idx[0] = hwif->index;
>  
> -	ide_device_add(idx);
> +	ide_device_add(idx, NULL);
>  
>  	return 0;
>  }
>  
> +static const struct ide_port_info icside_v6_port_info __initdata = {
> +	.host_flags		= IDE_HFLAG_SERIALIZE |
> +				  IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
> +				  IDE_HFLAG_NO_AUTOTUNE,
> +	.mwdma_mask		= ATA_MWDMA2,
> +	.swdma_mask		= ATA_SWDMA2,
> +};
> +

    Interesting... this driver's support for SWDMA0 is broken since the cycle 
should be 960 ns long, not 480, and SWDMA2 is underclocked using the same 
cycle as SWDMA1, 480 ns...

> Index: b/drivers/ide/cris/ide-cris.c
> ===================================================================
> --- a/drivers/ide/cris/ide-cris.c
> +++ b/drivers/ide/cris/ide-cris.c
> @@ -753,6 +753,15 @@ static void cris_set_dma_mode(ide_drive_
>  		cris_ide_set_speed(TYPE_DMA, 0, strobe, hold);
>  }
>  
> +static const struct ide_port_info cris_port_info __initdata = {
> +	.chipset		= ide_etrax100,
> +	.host_flags		= IDE_HFLAG_NO_ATAPI_DMA |
> +				  IDE_HFLAG_NO_DMA, /* no SFF-style DMA */
> +	.pio_mask		= ATA_PIO4,
> +	.udma_mask		= cris_ultra_mask,

    Hm, I wonder which value it will assume, 0x07 or 0?  Not sure even after 
looking at the source... :-)

> +	.mwdma_mask		= ATA_MWDMA2,
> +};
> +
>  static int __init init_e100_ide(void)
>  {
>  	hw_regs_t hw;
> Index: b/drivers/ide/ide-probe.c
> ===================================================================
> --- a/drivers/ide/ide-probe.c
> +++ b/drivers/ide/ide-probe.c
> @@ -1289,12 +1289,86 @@ static void hwif_register_devices(ide_hw
>  	}
>  }
>  
> -int ide_device_add_all(u8 *idx)
> +static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
> +			  const struct ide_port_info *d)
>  {
> -	ide_hwif_t *hwif;
> +	if (d->chipset != ide_etrax100)
> +		hwif->channel = port;

   Hm, what's so special about ide_etrax100?

> +int ide_device_add_all(u8 idx[MAX_HWIFS], const struct ide_port_info *d)

    Function prototype doesn't match with one from <linux/ide.h> which has the 
first argument as a pointer...

> +{
> +	ide_hwif_t *hwif, *mate = NULL;
>  	int i, rc = 0;
>  
>  	for (i = 0; i < MAX_HWIFS; i++) {
> +		if (d == NULL || idx[i] == 0xff) {

    Why check for (d == NULL) every time and not do it once and break from the 
loop or even do it before the loop?

> +			mate = NULL;
> +			continue;
> +		}
> +
> +		hwif = &ide_hwifs[idx[i]];
> +
> +		if (d->chipset != ide_etrax100 && (i & 1) && mate) {
> +			hwif->mate = mate;
> +			mate->mate = hwif;
> +		}
> +
> +		mate = (i & 1) ? NULL : hwif;
> +
> +		ide_init_port(hwif, i & 1, d);
> +	}
> +
> +	for (i = 0; i < MAX_HWIFS; i++) {
>  		if (idx[i] == 0xff)
>  			continue;

MBR, Sergei


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbZFBTlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbZFBTlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 15:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbZFBTlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 15:41:16 -0400
Received: from h155.mvista.com ([63.81.120.155]:28537 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750776AbZFBTlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 15:41:15 -0400
Message-ID: <4A2580AA.7090308@ru.mvista.com>
Date: Tue, 02 Jun 2009 23:42:34 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ide: add struct ide_port_ops
References: <200802232116.31811.bzolnier@gmail.com>
In-Reply-To: <200802232116.31811.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Move hooks for port/host specific methods from ide_hwif_t to
>   'struct ide_port_ops'.

> * Add 'const struct ide_port_ops *port_ops' to 'struct ide_port_info'
>   and ide_hwif_t.

> * Update host drivers and core code accordingly.

> While at it:

> * Rename ata66_*() cable detect functions to *_cable_detect() to match
>   the standard naming. (Suggested by Sergei Shtylyov)

> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

    Noticed an issue in pdc202xx_old.c:

> Index: b/drivers/ide/pci/pdc202xx_old.c
> ===================================================================
> --- a/drivers/ide/pci/pdc202xx_old.c
> +++ b/drivers/ide/pci/pdc202xx_old.c
> @@ -115,7 +115,7 @@ static void pdc202xx_set_pio_mode(ide_dr
>  	pdc202xx_set_mode(drive, XFER_PIO_0 + pio);
>  }
>  
> -static u8 __devinit pdc2026x_old_cable_detect(ide_hwif_t *hwif)
> +static u8 __devinit pdc2026x_cable_detect(ide_hwif_t *hwif)
>  {
>  	struct pci_dev *dev = to_pci_dev(hwif->dev);
>  	u16 CIS, mask = hwif->channel ? (1 << 11) : (1 << 10);
> @@ -226,26 +226,6 @@ somebody_else:
>  	return (dma_stat & 4) == 4;	/* return 1 if INTR asserted */
>  }
>  
> -static void pdc202xx_dma_lost_irq(ide_drive_t *drive)
> -{
> -	ide_hwif_t *hwif = HWIF(drive);
> -
> -	if (hwif->resetproc != NULL)
> -		hwif->resetproc(drive);
> -
> -	ide_dma_lost_irq(drive);
> -}
> -
> -static void pdc202xx_dma_timeout(ide_drive_t *drive)
> -{
> -	ide_hwif_t *hwif = HWIF(drive);
> -
> -	if (hwif->resetproc != NULL)
> -		hwif->resetproc(drive);
> -
> -	ide_dma_timeout(drive);
> -}
> -
>  static void pdc202xx_reset_host (ide_hwif_t *hwif)
>  {
>  	unsigned long high_16	= hwif->extra_base - 16;
> @@ -271,6 +251,18 @@ static void pdc202xx_reset (ide_drive_t 
>  	ide_set_max_pio(drive);
>  }
>  
> +static void pdc202xx_dma_lost_irq(ide_drive_t *drive)
> +{
> +	pdc202xx_reset(drive);
> +	ide_dma_lost_irq(drive);
> +}
> +
> +static void pdc202xx_dma_timeout(ide_drive_t *drive)
> +{
> +	pdc202xx_reset(drive);
> +	ide_dma_timeout(drive);
> +}
> +

    Oops, missed this illegetimate change while reviewing: PDC20246 doesn't 
have the resetproc() method, hence this switch to direct calling of 
pdc202xx_reset() directly was wrong...

>  static unsigned int __devinit init_chipset_pdc202xx(struct pci_dev *dev,
>  							const char *name)
>  {
> @@ -281,17 +273,6 @@ static void __devinit init_hwif_pdc202xx
>  {
>  	struct pci_dev *dev = to_pci_dev(hwif->dev);
>  
> -	hwif->set_pio_mode = &pdc202xx_set_pio_mode;
> -	hwif->set_dma_mode = &pdc202xx_set_mode;
> -
> -	hwif->quirkproc = &pdc202xx_quirkproc;
> -
> -	if (dev->device != PCI_DEVICE_ID_PROMISE_20246) {
> -		hwif->resetproc = &pdc202xx_reset;
> -
> -		hwif->cable_detect = pdc2026x_old_cable_detect;
> -	}
> -
>  	if (hwif->dma_base == 0)
>  		return;
>  
> @@ -357,6 +338,20 @@ static void __devinit pdc202ata4_fixup_i
>  	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
>  	 IDE_HFLAG_OFF_BOARD)
>  
> +static const struct ide_port_ops pdc20246_port_ops = {
> +	.set_pio_mode		= pdc202xx_set_pio_mode,
> +	.set_dma_mode		= pdc202xx_set_mode,
> +	.quirkproc		= pdc202xx_quirkproc,
> +};
> +
> +static const struct ide_port_ops pdc2026x_port_ops = {
> +	.set_pio_mode		= pdc202xx_set_pio_mode,
> +	.set_dma_mode		= pdc202xx_set_mode,
> +	.quirkproc		= pdc202xx_quirkproc,
> +	.resetproc		= pdc202xx_reset,
> +	.cable_detect		= pdc2026x_cable_detect,
> +};
> +
>  #define DECLARE_PDC2026X_DEV(name_str, udma, extra_flags) \
>  	{ \
>  		.name		= name_str, \
> @@ -364,6 +359,7 @@ static void __devinit pdc202ata4_fixup_i
>  		.init_hwif	= init_hwif_pdc202xx, \
>  		.init_dma	= init_dma_pdc202xx, \
>  		.extra		= 48, \
> +		.port_ops	= &pdc2026x_port_ops, \
>  		.host_flags	= IDE_HFLAGS_PDC202XX | extra_flags, \
>  		.pio_mask	= ATA_PIO4, \
>  		.mwdma_mask	= ATA_MWDMA2, \
> @@ -376,6 +372,7 @@ static const struct ide_port_info pdc202
>  		.init_chipset	= init_chipset_pdc202xx,
>  		.init_hwif	= init_hwif_pdc202xx,
>  		.init_dma	= init_dma_pdc202xx,
> +		.port_ops	= &pdc20246_port_ops,
>  		.extra		= 16,
>  		.host_flags	= IDE_HFLAGS_PDC202XX,
>  		.pio_mask	= ATA_PIO4,

MBR, Sergei

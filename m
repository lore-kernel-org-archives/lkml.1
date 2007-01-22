Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbXAVSRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbXAVSRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 13:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932193AbXAVSRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 13:17:38 -0500
Received: from h155.mvista.com ([63.81.120.155]:35993 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932180AbXAVSRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 13:17:36 -0500
Message-ID: <45B4FFBD.40507@ru.mvista.com>
Date: Mon, 22 Jan 2007 21:17:33 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] ide: fix UDMA/MWDMA/SWDMA masks
References: <20070119003058.14846.43637.sendpatchset@localhost.localdomain> <20070119003226.14846.87052.sendpatchset@localhost.localdomain>
In-Reply-To: <20070119003226.14846.87052.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> [PATCH] ide: fix UDMA/MWDMA/SWDMA masks

> * use 0x00 instead of 0x80 to disable ->{ultra,mwdma,swdma}_mask
> * add udma_mask field to ide_pci_device_t and use it to initialize
>   ->ultra_mask in aec62xx, pdc202xx_new and pdc202xx_old drivers
> * fix UDMA masks to match with chipset specific *_ratemask()
>   (alim15x3, hpt366, serverworks and siimage drivers need UDMA mask
>    filtering method - done in the next patch)

    More issues with aec62xx.c driver, found after looking at the next patch...

> Index: b/drivers/ide/pci/aec62xx.c
> ===================================================================
> --- a/drivers/ide/pci/aec62xx.c
> +++ b/drivers/ide/pci/aec62xx.c
> @@ -270,11 +270,13 @@ static unsigned int __devinit init_chips
>  
>  static void __devinit init_hwif_aec62xx(ide_hwif_t *hwif)
>  {
> +	struct pci_dev *dev = hwif->pci_dev;
> +
>  	hwif->autodma = 0;
>  	hwif->tuneproc = &aec62xx_tune_drive;
>  	hwif->speedproc = &aec62xx_tune_chipset;
>  
> -	if (hwif->pci_dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF)
> +	if (dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF)
>  		hwif->serialized = hwif->channel;
>  
>  	if (hwif->mate)
> @@ -286,7 +288,16 @@ static void __devinit init_hwif_aec62xx(
>  		return;
>  	}
>  
> -	hwif->ultra_mask = 0x7f;
> +	hwif->ultra_mask = hwif->cds->udma_mask;
> +
> +	/* atp865 and atp865r */
> +	if (hwif->ultra_mask == 0x3f) {
> +		unsigned long io = pci_resource_start(dev, 4);
> +
> +		if (inb(io) & 0x10)
> + 			hwif->ultra_mask = 0x7f; /* udma0-6 */
> +	}
> +

    Looks like another intruduced buglet: you're reading DMA command, but 
aec62xx_ratemask() was reading DMA status originally for this bit.

>  	hwif->mwdma_mask = 0x07;
>  	hwif->swdma_mask = 0x07;

    Hm, caught another nit: this driver doesn't actually support single-word 
DMA modes... :-)

> Index: b/drivers/ide/pci/alim15x3.c
> ===================================================================
> --- a/drivers/ide/pci/alim15x3.c
> +++ b/drivers/ide/pci/alim15x3.c
> @@ -765,8 +765,17 @@ static void __devinit init_hwif_common_a
>  
>  	hwif->atapi_dma = 1;
>  
> -	if (m5229_revision > 0x20)
> -		hwif->ultra_mask = 0x7f;
> +	if (m5229_revision <= 0x20)
> +		hwif->ultra_mask = 0x00; /* no udma */
> +	else if (m5229_revision < 0xC2)
> +		hwif->ultra_mask = 0x07; /* udma0-2 */
> +	else if (m5229_revision == 0xC2 || m5229_revision == 0xC3)
> +		hwif->ultra_mask = 0x1f; /* udma0-4 */
> +	else if (m5229_revision == 0xC4)
> +		hwif->ultra_mask = 0x3f; /* udma0-5 */
> +	else
> +		hwif->ultra_mask = 0x7f; /* udma0-6 */
> +
>  	hwif->mwdma_mask = 0x07;
>  	hwif->swdma_mask = 0x07;

    Ugh, I'm not seeing any *actual* support for MW/SW DMA in this driver... 
And PIO setting via speedproc() method is broken -- it passes to tuneproc() 
method mode number not biased by -XFER_PIO_0 beforehand.  Will cook up some 
patch, maybe... :-/

MBR, Sergei

Return-Path: <linux-kernel-owner+w=401wt.eu-S1161362AbXDVQSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161362AbXDVQSw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 12:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161374AbXDVQSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 12:18:52 -0400
Received: from h155.mvista.com ([63.81.120.155]:55955 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161362AbXDVQSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 12:18:51 -0400
Message-ID: <462B8B21.1030805@ru.mvista.com>
Date: Sun, 22 Apr 2007 20:19:45 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] ide: fix UDMA/MWDMA/SWDMA masks
References: <20070203172415.4926.29574.sendpatchset@localhost.localdomain>
In-Reply-To: <20070203172415.4926.29574.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> [PATCH] ide: fix UDMA/MWDMA/SWDMA masks

> * use 0x00 instead of 0x80 to disable ->{ultra,mwdma,swdma}_mask
> * add udma_mask field to ide_pci_device_t and use it to initialize
>   ->ultra_mask in aec62xx, cmd64x, pdc202xx_{new,old} and piix drivers
> * fix UDMA masks to match with chipset specific *_ratemask()
>   (alim15x3, hpt366, serverworks and siimage drivers need UDMA mask
>    filtering method - done in the next patch)
> 
> v2:
> * piix: fix cable detection for 82801AA_1 and 82372FB_1
>   [ Noticed by Sergei Shtylyov <sshtylyov@ru.mvista.com>. ]
> * cmd64x: use hwif->cds->udma_mask
>   [ Suggested by Sergei Shtylyov <sshtylyov@ru.mvista.com>. ]
> * aec62xx: fix newly introduced bug - check DMA status not command register
>   [ Noticed by Sergei Shtylyov <sshtylyov@ru.mvista.com>. ]

> v3:
> * piix: use hwif->cds->udma_mask
>   [ Suggested by Sergei Shtylyov <sshtylyov@ru.mvista.com>. ]

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
> @@ -286,7 +288,15 @@ static void __devinit init_hwif_aec62xx(
>  		return;
>  	}
>  
> -	hwif->ultra_mask = 0x7f;
> +	hwif->ultra_mask = hwif->cds->udma_mask;
> +
> +	/* atp865 and atp865r */
> +	if (hwif->ultra_mask == 0x3f) {
> +		/* check bit 0x10 of DMA status register */
> +		if (inb(pci_resource_start(dev, 4) + 2) & 0x10)
> + 			hwif->ultra_mask = 0x7f; /* udma0-6 */
> +	}
> +
 
   IMO, this asks to be put into init_setup_aec6x80() instead but since I'm already cleaning up that function, I'll move it there myself.

MBR, Sergei

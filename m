Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbYHURQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbYHURQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYHURP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:15:59 -0400
Received: from h155.mvista.com ([63.81.120.155]:61730 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751792AbYHURP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:15:57 -0400
Message-ID: <48ADA2DB.3060306@ru.mvista.com>
Date: Thu, 21 Aug 2008 21:16:11 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/18] ide: remove ide_setup_dma()
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <20080620213350.13202.73557.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213350.13202.73557.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Export sff_dma_ops and then remove ide_setup_dma().

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> Index: b/drivers/ide/arm/palm_bk3710.c
> ===================================================================
> --- a/drivers/ide/arm/palm_bk3710.c
> +++ b/drivers/ide/arm/palm_bk3710.c
> @@ -318,15 +318,14 @@ static u8 __devinit palm_bk3710_cable_de
>  static int __devinit palm_bk3710_init_dma(ide_hwif_t *hwif,
>  					  const struct ide_port_info *d)
>  {
> -	unsigned long base =
> -		hwif->io_ports.data_addr - IDE_PALM_ATA_PRI_REG_OFFSET;
> -
>  	printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
>  
>  	if (ide_allocate_dma_engine(hwif))
>  		return -1;
>  
> -	ide_setup_dma(hwif, base);
> +	hwif->dma_base = hwif->io_ports.data_addr - IDE_PALM_ATA_PRI_REG_OFFSET;
> +
> +	hwif->dma_ops = &sff_dma_ops;
>  
>  	return 0;
>  }

    Unfortunately, this patch broke this driver:

drivers/ide/arm/palm_bk3710.c:327: error: ‘sff_dma_ops’ undeclared (first use 
in this function). The declatation of sff_dma_ops should've been surrounded by:

#ifdef CONFIG_BLK_DEV_IDEDMA_SFF

not by:

#ifdef CONFIG_BLK_DEV_IDEDMA_PCI

the same as its definition is in ide-dma.c...

MBR, Sergei

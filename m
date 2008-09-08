Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbYIHPsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbYIHPsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbYIHPsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:48:33 -0400
Received: from h155.mvista.com ([63.81.120.155]:34089 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752583AbYIHPsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:48:32 -0400
Message-ID: <48C54977.6030801@ru.mvista.com>
Date: Mon, 08 Sep 2008 19:49:11 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/18] ide: use I/O ops directly in ide-dma.c
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <20080620213330.13202.11017.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213330.13202.11017.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Use I/O ops directly in ide_dma_host_set(), ide_dma_setup(),
> ide_dma_start() and __ide_dma_end().

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
[...]
> Index: b/drivers/ide/ide-dma.c
> ===================================================================
> --- a/drivers/ide/ide-dma.c
> +++ b/drivers/ide/ide-dma.c
> @@ -376,7 +376,10 @@ void ide_dma_host_set(ide_drive_t *drive
>  	else
>  		dma_stat &= ~(1 << (5 + unit));
>  
> -	hwif->OUTB(dma_stat, hwif->dma_status);
> +	if (hwif->host_flags & IDE_HFLAG_MMIO)
> +		writeb(dma_stat, (void __iomem *)hwif->dma_status);
> +	else
> +		outb(dma_stat, hwif->dma_status);
>  }
>  
>  EXPORT_SYMBOL_GPL(ide_dma_host_set);
> @@ -470,13 +474,20 @@ int ide_dma_setup(ide_drive_t *drive)
[...]
>  	/* read DMA status for INTR & ERROR flags */
>  	dma_stat = hwif->read_sff_dma_status(hwif);
>  
>  	/* clear INTR & ERROR flags */
> -	hwif->OUTB(dma_stat|6, hwif->dma_status);
> +	if (mmio)
> +		writeb(dma_stat | 6, (void __iomem *)hwif->dma_status);
> +	else
> +		outb(dma_stat | 6, hwif->dma_status);
> +
>  	drive->waiting_for_dma = 1;
>  	return 0;
>  }
> @@ -511,18 +529,31 @@ EXPORT_SYMBOL_GPL(ide_dma_start);
[...]
>  	/* get DMA status */
>  	dma_stat = hwif->read_sff_dma_status(hwif);
> -	/* clear the INTR & ERROR bits */
> -	hwif->OUTB(dma_stat|6, hwif->dma_status);
> +
> +	if (mmio)
> +		/* clear the INTR & ERROR bits */
> +		writeb(dma_stat | 6, (void __iomem *)hwif->dma_status);
> +	else
> +		outb(dma_stat | 6, hwif->dma_status);
> +

    Seems like the above 3 sequences are asking to be factored out into 
ide_dma_write_status(); with the latter two possibly factored out into 
ide_dma_clear_status(). I'm making a notch if you don't mind (or beat me to it 
:-)...

MBR, Sergei

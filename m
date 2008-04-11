Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbYDKNME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbYDKNME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 09:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYDKNLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 09:11:53 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:33743 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751767AbYDKNLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 09:11:52 -0400
Message-ID: <47FF636E.4070903@ru.mvista.com>
Date: Fri, 11 Apr 2008 17:11:10 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ide: add struct ide_dma_ops
References: <200803091700.46136.bzolnier@gmail.com> <47D82EB9.1060603@ru.mvista.com> <200803181512.50134.bzolnier@gmail.com>
In-Reply-To: <200803181512.50134.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>    Now where is the code which selects the correct dma_ops for the 
>>> HPT36x/370/372/372N chip with device ID 4 I'm asking you?  :-) 

> fixed

    Not actually... :-/

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: add struct ide_dma_ops (take 2)

> Add struct ide_dma_ops and convert core code + drivers to use it.

> While at it:

> * Drop "ide_" prefix from ->ide_dma_end and ->ide_dma_test_irq methods.

> * Drop "ide_" "infixes" from DMA methods.

> * au1xxx-ide.c:
>   - use auide_dma_{test_irq,end}() directly in auide_dma_timeout()

> * pdc202xx_old.c:
>   - drop "old_" "infixes" from DMA methods

> * siimage.c:
>   - add siimage_dma_test_irq() helper
>   - print SATA warning in siimage_init_one()

> * Remove no longer needed ->init_hwif implementations.

> v2:
> * Changes based on review from Sergei:
>   - s/siimage_ide_dma_test_irq/siimage_dma_test_irq/
>   - s/drive->hwif/hwif/ in idefloppy_pc_intr().
>   - fix patch description w.r.t. au1xxx-ide changes
>   - fix au1xxx-ide build
>   - fix naming for cmd64*_dma_ops
>   - drop "ide_" and "old_" infixes
>   - s/hpt3xxx_dma_ops/hpt37x_dma_ops/
>   - s/hpt370x_dma_ops/hpt370_dma_ops/
>   - use correct DMA ops for HPT302/N, HPT371/N and HPT374
>   - s/it821x_smart_dma_ops/it821x_pass_through_dma_ops/

> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

    Unfortunately, you'll have to try one more... ;-)

> Index: b/drivers/ide/pci/hpt366.c
> ===================================================================
> --- a/drivers/ide/pci/hpt366.c
> +++ b/drivers/ide/pci/hpt366.c
[...]
> @@ -1428,6 +1415,21 @@ static const struct ide_port_ops hpt3xx_
>  	.cable_detect		= hpt3xx_cable_detect,
>  };
>  
> +static struct ide_dma_ops hpt37x_dma_ops = {
> +	.dma_end		= hpt374_dma_end,
> +	.dma_test_irq		= hpt374_dma_test_irq,
> +};
> +
> +static struct ide_dma_ops hpt370_dma_ops = {
> +	.dma_start		= hpt370_dma_start,
> +	.dma_end		= hpt370_dma_end,
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
> @@ -1442,6 +1444,7 @@ static const struct ide_port_info hpt366
>  		 */
>  		.enablebits	= {{0x50,0x10,0x10}, {0x54,0x04,0x04}},
>  		.port_ops	= &hpt3xx_port_ops,
> +		.dma_ops	= &hpt36x_dma_ops,
>  		.host_flags	= IDE_HFLAGS_HPT3XX | IDE_HFLAG_SINGLE,
>  		.pio_mask	= ATA_PIO4,
>  		.mwdma_mask	= ATA_MWDMA2,

    I'm still not seeing the code to deals with the PCI device ID 4 which may 
be HPT36x, or HPT370, or HPT372[N] depending on revision -- you're always 
giving hpt36x_dma_ops to it...

> @@ -1483,6 +1489,7 @@ static const struct ide_port_info hpt366
>  		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
>  		.udma_mask	= ATA_UDMA5,
>  		.port_ops	= &hpt3xx_port_ops,
> +		.dma_ops	= &hpt370_dma_ops,

    Wrong -- HPT374 should have hpt37x_dma_ops...

MBR, Sergei

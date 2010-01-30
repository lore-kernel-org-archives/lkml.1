Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918Ab0A3Vzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0A3Vzv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 16:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267Ab0A3Vzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 16:55:50 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:52280 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab0A3Vzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 16:55:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=v78gClJY0isN1e9YExBxxPoS80d44MgXSndGQQyJu6vnlbsETxPgq/QO7TRw8otzT9
         UFIumQYHkFvrL1298POOt5MjRBiVeoYVyZ0oUoz/b4OU6eEmAUfFLujFHTXsR3h1E3ms
         qe+pz3sEUqk1bXaIpdEyKMmgp8UzfhgNJN+oo=
Message-ID: <4B64AAE3.5040501@garzik.org>
Date: Sat, 30 Jan 2010 16:55:47 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] cs5536: convert to ide2libata
References: <20100130194918.30779.25485.sendpatchset@localhost> <20100130195004.30779.89524.sendpatchset@localhost>
In-Reply-To: <20100130195004.30779.89524.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2010 02:50 PM, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] cs5536: convert to ide2libata
>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
>   drivers/ata/pata_cs5536.h |   22 +++++
>   drivers/ide/cs5536.c      |  189 +---------------------------------------------
>   2 files changed, 26 insertions(+), 185 deletions(-)
>
> Index: b/drivers/ata/pata_cs5536.h
> ===================================================================
> --- a/drivers/ata/pata_cs5536.h
> +++ b/drivers/ata/pata_cs5536.h
> @@ -64,7 +64,11 @@ static int cs5536_write(struct pci_dev *
>
>   static void cs5536_program_dtc(struct ata_device *adev, u8 tim)
>   {
> +#ifndef __IDE2LIBATA
>   	struct pci_dev *pdev = to_pci_dev(adev->link->ap->host->dev);
> +#else
> +	struct pci_dev *pdev = to_pci_dev(adev->hwif->dev);
> +#endif
>   	int dshift = adev->devno ? IDE_D1_SHIFT : IDE_D0_SHIFT;
>   	u32 dtc;
>
> @@ -121,11 +125,19 @@ static void cs5536_set_piomode(struct at
>   	int mode = adev->pio_mode - XFER_PIO_0;
>   	int cmdmode = mode;
>   	int cshift = adev->devno ? IDE_CAST_D1_SHIFT : IDE_CAST_D0_SHIFT;
> +#ifdef __IDE2LIBATA
> +	unsigned long timings = (unsigned long)ide_get_drivedata(adev);
> +#endif
>   	u32 cast;
>
>   	if (pair)
>   		cmdmode = min(mode, pair->pio_mode - XFER_PIO_0);
>
> +#ifdef __IDE2LIBATA
> +	timings&= (IDE_DRV_MASK<<  8);
> +	timings |= drv_timings[mode];
> +	ide_set_drivedata(adev, (void *)timings);
> +#endif
>   	cs5536_program_dtc(adev, drv_timings[mode]);
>
>   	cs5536_read(pdev, CAST,&cast);
> @@ -160,7 +172,9 @@ static void cs5536_set_dmamode(struct at
>   	u32 etc;
>   	int mode = adev->dma_mode;
>   	int dshift = adev->devno ? IDE_D1_SHIFT : IDE_D0_SHIFT;
> -
> +#ifdef __IDE2LIBATA
> +	unsigned long timings = (unsigned long)ide_get_drivedata(adev);
> +#endif
>   	cs5536_read(pdev, ETC,&etc);
>
>   	if (mode>= XFER_UDMA_0) {
> @@ -168,7 +182,13 @@ static void cs5536_set_dmamode(struct at
>   		etc |= udma_timings[mode - XFER_UDMA_0]<<  dshift;
>   	} else { /* MWDMA */
>   		etc&= ~(IDE_ETC_UDMA_MASK<<  dshift);
> +#ifndef __IDE2LIBATA
>   		cs5536_program_dtc(adev, mwdma_timings[mode - XFER_MW_DMA_0]);
> +#else
> +		timings&= IDE_DRV_MASK;
> +		timings |= mwdma_timings[mode - XFER_MW_DMA_0]<<  8;
> +		ide_set_drivedata(adev, (void *)timings);
> +#endif
>   	}
>
>   	cs5536_write(pdev, ETC, etc);

Wow, that's really turning into a rat's nest of ifdefs, isn't it?

	Jeff




Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbYABIet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbYABIet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 03:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbYABIel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 03:34:41 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:21584 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbYABIej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 03:34:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gmjT2U8N8Exn9bVyML408TMxJ1qM0uPxVbfkR+wwpHjWqhRBW6O4tmhT8p0j0TdLdimc3G4lmTfKz+kBilMcSh7QZqtBsB/ygQhzAQH+YjBt603WG+wZoV12tAUnmtzwYt3IpLHbk3s1Fze60DIf4+Ka0vcgLRp6qGkk15zsO8E=
Message-ID: <386072610801020034u325d3c37y40400aef4613c9@mail.gmail.com>
Date: Wed, 2 Jan 2008 16:34:38 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 8/9] ide: switch to DMA-mapping API
Cc: linux-ide@vger.kernel.org, "Bryan Wu" <bryan.wu@analog.com>,
       linux-kernel@vger.kernel.org, "Russell King" <rmk@arm.linux.org.uk>
In-Reply-To: <20071227191252.1357.76726.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071227191153.1357.63211.sendpatchset@localhost.localdomain>
	 <20071227191252.1357.76726.sendpatchset@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 28, 2007 3:12 AM, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> * pci_map_sg() -> dma_map_sg() in ide_build_sglist().
>
> * pci_unmap_sg() -> dma_unmap_sg() in ide_destroy_dmatable().
>
> There should be no functionality changes caused by this patch except
> for blackfin arch whose dma_[un]map_sg() implementation differs from
> pci_[un]map_sg() one (on s390 arch there is no PCI, on avr32 and h8300
> archs PCI is currently unsupported, on m32r arch PCI support depends
> on BROKEN, on m68k arch PCI support depends on HADES which in turn
> depends on BROKEN, on all other archs dma_[un]map_sg() functionality
> matches with pci_[un]map_sg() one).
>

Thanks a lot for this carefully check with Blackfin.
Please go ahead with this patch change, we plan to remove PCI useless
header file in Blackfin like AVR32

-Bryan

> Cc: Bryan Wu <bryan.wu@analog.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> It seems like blackfin arch should be using <asm-generic/pci-dma-compat.h>
> in <asm-blackfin/pci.h> or drivers still using PCI DMA-mapping API instead
> of the generic one won't work but I'll leave this to blackfin gurus...
>
> [ Bryan, could you please take a look?  Thanks. ]
>
>  drivers/ide/ide-dma.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> Index: b/drivers/ide/ide-dma.c
> ===================================================================
> --- a/drivers/ide/ide-dma.c
> +++ b/drivers/ide/ide-dma.c
> @@ -85,6 +85,7 @@
>  #include <linux/ide.h>
>  #include <linux/delay.h>
>  #include <linux/scatterlist.h>
> +#include <linux/dma-mapping.h>
>
>  #include <asm/io.h>
>  #include <asm/irq.h>
> @@ -175,26 +176,26 @@ static int ide_dma_good_drive(ide_drive_
>   *     @drive: the drive to build the DMA table for
>   *     @rq: the request holding the sg list
>   *
> - *     Perform the PCI mapping magic necessary to access the source or
> - *     target buffers of a request via PCI DMA. The lower layers of the
> + *     Perform the DMA mapping magic necessary to access the source or
> + *     target buffers of a request via DMA.  The lower layers of the
>   *     kernel provide the necessary cache management so that we can
> - *     operate in a portable fashion
> + *     operate in a portable fashion.
>   */
>
>  int ide_build_sglist(ide_drive_t *drive, struct request *rq)
>  {
>         ide_hwif_t *hwif = HWIF(drive);
> -       struct pci_dev *pdev = to_pci_dev(hwif->dev);
>         struct scatterlist *sg = hwif->sg_table;
>
>         ide_map_sg(drive, rq);
>
>         if (rq_data_dir(rq) == READ)
> -               hwif->sg_dma_direction = PCI_DMA_FROMDEVICE;
> +               hwif->sg_dma_direction = DMA_FROM_DEVICE;
>         else
> -               hwif->sg_dma_direction = PCI_DMA_TODEVICE;
> +               hwif->sg_dma_direction = DMA_TO_DEVICE;
>
> -       return pci_map_sg(pdev, sg, hwif->sg_nents, hwif->sg_dma_direction);
> +       return dma_map_sg(hwif->dev, sg, hwif->sg_nents,
> +                         hwif->sg_dma_direction);
>  }
>
>  EXPORT_SYMBOL_GPL(ide_build_sglist);
> @@ -308,9 +309,8 @@ EXPORT_SYMBOL_GPL(ide_build_dmatable);
>  void ide_destroy_dmatable (ide_drive_t *drive)
>  {
>         ide_hwif_t *hwif = drive->hwif;
> -       struct pci_dev *pdev = to_pci_dev(hwif->dev);
>
> -       pci_unmap_sg(pdev, hwif->sg_table, hwif->sg_nents,
> +       dma_unmap_sg(hwif->dev, hwif->sg_table, hwif->sg_nents,
>                      hwif->sg_dma_direction);
>  }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

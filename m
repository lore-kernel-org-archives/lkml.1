Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYICNTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYICNTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 09:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYICNT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 09:19:27 -0400
Received: from h155.mvista.com ([63.81.120.155]:23457 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751687AbYICNT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 09:19:26 -0400
Message-ID: <48BE8EFD.70103@ru.mvista.com>
Date: Wed, 03 Sep 2008 17:19:57 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/18] ide: add ->read_sff_dma_status method
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Add ->read_sff_dma_status method for reading DMA Status register
> and use it instead of ->INB.

> While at it:

> * Use inb() directly in ns87415.c::ns87415_dma_end().

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> Index: b/drivers/ide/ide-iops.c
> ===================================================================
> --- a/drivers/ide/ide-iops.c
> +++ b/drivers/ide/ide-iops.c
> @@ -103,6 +103,14 @@ void SELECT_MASK(ide_drive_t *drive, int
>  		port_ops->maskproc(drive, mask);
>  }
>  
> +static u8 ide_read_sff_dma_status(ide_hwif_t *hwif)
> +{
> +	if (hwif->host_flags & IDE_HFLAG_MMIO)
> +		return readb((void __iomem *)hwif->dma_status);
> +	else
> +		return inb(hwif->dma_status);
> +}
> +

    It's probably too late to object now (and I've been busy before) but I 
don't understand how reading DMA status ended up here ISO ide-dma.c...

>  static void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
>  {
>  	ide_hwif_t *hwif = drive->hwif;
> @@ -323,6 +331,8 @@ static void ata_output_data(ide_drive_t 
>  
>  void default_hwif_transport(ide_hwif_t *hwif)
>  {
> +	hwif->read_sff_dma_status = ide_read_sff_dma_status;
> +
>  	hwif->tf_load	  = ide_tf_load;
>  	hwif->tf_read	  = ide_tf_read;

    I also didn't understand the motivation behind putting this method 
together with the transport operations... IMO, DMA programming interface 
hardly has anything to do with transporting the data over IDE bus.

MBR, Sergei

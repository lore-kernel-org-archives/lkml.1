Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbZCNHNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbZCNHNU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 03:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbZCNHNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 03:13:04 -0400
Received: from smtp-out.google.com ([216.239.45.13]:5867 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbZCNHND convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 03:13:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=r65HMad5GvsCIdU7e2n0Qi2VlN0+CJrkzJZjnvWWVV57aHN9jWMEHpxvGpuvVWQQU
	hr0SG3jEdeXbcjH2oe8Kw==
MIME-Version: 1.0
In-Reply-To: <20090220171201.25429.29473.sendpatchset@localhost.localdomain>
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain>
	 <20090220171201.25429.29473.sendpatchset@localhost.localdomain>
Date: Sat, 14 Mar 2009 08:12:57 +0100
Message-ID: <da824cf30903140012g1565696kd6c69b4cd513f15b@mail.gmail.com>
Subject: Re: [PATCH 03/10] ide: destroy DMA mappings after ending DMA
From: Grant Grundler <grundler@google.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 6:12 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: destroy DMA mappings after ending DMA
>
> Move ide_destroy_dmatable() call out from ->dma_end method to
> {ide_pc,cdrom_newpc,ide_dma}_intr(), ide_dma_timeout_retry()
> and sgiioc4_resetproc().
...
> --- a/drivers/ide/ide-dma-sff.c
> +++ b/drivers/ide/ide-dma-sff.c
> @@ -310,8 +310,6 @@ int ide_dma_end(ide_drive_t *drive)
>        /* clear INTR & ERROR bits */
>        ide_dma_sff_write_status(hwif, dma_stat | ATA_DMA_ERR | ATA_DMA_INTR);
>
> -       /* purge DMA mappings */
> -       ide_destroy_dmatable(drive);
>        wmb();

Bartlomiej,
I think the wmb() could removed as well. The outb/writeb functions are
required to be strongly ordered and I don't see anything else touching
DMA-able memory here.

BTW, care to remove "mask" usage from this function?
It's really not needed (can be replaced with #define).

I can create separate patches for both. Which git tree should I base
them against?

...
> --- a/drivers/ide/scc_pata.c
> +++ b/drivers/ide/scc_pata.c
> @@ -365,8 +365,6 @@ static int __scc_dma_end(ide_drive_t *dr
>        dma_stat = scc_dma_sff_read_status(hwif);
>        /* clear the INTR & ERROR bits */
>        scc_ide_outb(dma_stat | 6, hwif->dma_base + 4);
> -       /* purge DMA mappings */
> -       ide_destroy_dmatable(drive);
>        /* verify good DMA status */
>        wmb();

I think this wmb() can be removed too.

....
> --- a/drivers/ide/tx4939ide.c
> +++ b/drivers/ide/tx4939ide.c
> @@ -335,11 +335,9 @@ static int tx4939ide_dma_end(ide_drive_t
>        /* read and clear the INTR & ERROR bits */
>        dma_stat = tx4939ide_clear_dma_status(base);
>
> -       /* purge DMA mappings */
> -       ide_destroy_dmatable(drive);
> -       /* verify good DMA status */
>        wmb();

and this one as well.

hth,
grant

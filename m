Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbYKDSaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbYKDSaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbYKDSaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:30:18 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:47973 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754109AbYKDSaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:30:16 -0500
Message-ID: <491094B2.4090107@ru.mvista.com>
Date: Tue, 04 Nov 2008 21:30:10 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] ide: rework handling of serialized ports
References: <20081103200244.5098.29817.sendpatchset@localhost.localdomain> <20081103200326.5098.2058.sendpatchset@localhost.localdomain>
In-Reply-To: <20081103200326.5098.2058.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: rework handling of serialized ports

> * hpt366: set IDE_HFLAG_SERIALIZE in hwif->host_flags if needed
>   in init_hwif_hpt366().  Remove HPT_SERIALIZE_IO while at it.

> * Set IDE_HFLAG_SERIALIZE in hwif->host_flags if needed in
>   ide_init_port().

> * Convert init_irq() to use IDE_HFLAG_SERIALIZE together with
>   hwif->host to find out ports which need to be serialized.

> * Remove no longer needed save_match() and ide_hwif_t.serialized.

> This patch should fix the incorrect grouping of port(s) from
> host(s) that need serialization with port(s) that happen to use
> the same IRQ(s) but are from the host(s) that don't need it.

> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

>  static int __devinit init_dma_hpt366(ide_hwif_t *hwif,
> Index: b/drivers/ide/ide-probe.c
> ===================================================================
> --- a/drivers/ide/ide-probe.c
> +++ b/drivers/ide/ide-probe.c
[...]
> +			if (hwif->host_flags & IDE_HFLAG_SERIALIZE) {
> +				if (hwif->host == h->host)
> +					match = h;

    Can be collapsed into a single *if*, and braces not needed either way.

> @@ -1436,10 +1398,8 @@ static void ide_init_port(ide_hwif_t *hw
>  	}
>  
>  	if ((d->host_flags & IDE_HFLAG_SERIALIZE) ||
> -	    ((d->host_flags & IDE_HFLAG_SERIALIZE_DMA) && hwif->dma_base)) {
> -		if (hwif->mate)
> -			hwif->mate->serialized = hwif->serialized = 1;
> -	}
> +	    ((d->host_flags & IDE_HFLAG_SERIALIZE_DMA) && hwif->dma_base))
> +		hwif->host_flags |= IDE_HFLAG_SERIALIZE;

    I don't see what use is forcing this flag at all here -- it doesn't seem 
to be checked only in init_irq() now, so this *if* could just be moved there...

MBR, Sergei

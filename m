Return-Path: <linux-kernel-owner+w=401wt.eu-S1762014AbXH0Rff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762014AbXH0Rff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 13:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbXH0RfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 13:35:05 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:51044 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676AbXH0RfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 13:35:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=b3eClNu/IqPlu1qZDpVpoJe2StErSSMdGMbkxtrZqkuC80stmRXGJ30ruFetGPfjL/Cm04aCNZetQ54Pukl8XP33nQJGkuNivVhHz3KQBR47IrRT51+N6SVtaOCJedAnUDIFEgI4T/hixti19/SwGavxwozv2dxdRzky1WPs3b8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 2/4] hpt366: UltraDMA filter for SATA cards (take 3)
Date: Mon, 27 Aug 2007 19:22:23 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200708252328.03826.sshtylyov@ru.mvista.com>
In-Reply-To: <200708252328.03826.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200708271922.23349.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

On Saturday 25 August 2007, Sergei Shtylyov wrote:
> The Marvell bridge chips used on HighPoint SATA cards do not seem to support
> the UltraDMA modes 1, 2, and 3 as well as any MWDMA modes, so the driver needs
> to account for this in the udma_filter() method.  In order to achieve that, do
> the following changes:
> 
> - install the method for all chips, not only HPT36x/370 and impove the code
>   formatting by killing the extra tabs while at it;
> 
> - add to the end of the 'switch' statement in the method cases for HPT372[AN]
>   and HPT374 chips upon which the known SATA cards are based;
> 
> - use hwif->ultra_mask as a default mask for the ide_dma_filter() method to
>   behave correctly;
> 
> - move the HPT370[A] cases below the HPT36x case for consistency...
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 
> ---
> Argh!  I've managed to put = instead of &= here and there, so please disregard
> the take #2... :-/

Not to mention that there was already take #2 on Aug 19 2007
(the version of the patch which is currently in IDE quilt tree)...

> This version doesn't use explicit UltraDMA masks, so converting them to the
> ATA_UDMA* is left for another, global patch.  This patch against the current

I have already other patches which are based on the previous version of the
patch and I don't find the idea of re-doing them especially tempting...

> Linus' tree and unfortunately I was able to only compile test it since that
> tree gives MODPOST warning and dies early on bootup.
> 
>  drivers/ide/pci/hpt366.c |   78 ++++++++++++++++++++++++-----------------------
>  1 files changed, 40 insertions(+), 38 deletions(-)
> 
> Index: linux-2.6/drivers/ide/pci/hpt366.c
> ===================================================================
> --- linux-2.6.orig/drivers/ide/pci/hpt366.c
> +++ linux-2.6/drivers/ide/pci/hpt366.c
> @@ -1,5 +1,5 @@
>  /*
> - * linux/drivers/ide/pci/hpt366.c		Version 1.11	Aug 11, 2007
> + * linux/drivers/ide/pci/hpt366.c		Version 1.12	Aug 25, 2007
>   *
>   * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
>   * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
> @@ -114,6 +114,7 @@
>   *   unify HPT36x/37x timing setup code and the speedproc handlers by joining
>   *   the register setting lists into the table indexed by the clock selected
>   * - set the correct hwif->ultra_mask for each individual chip
> + * - add UltraDMA mode filtering for the HPT37[24] based SATA cards
>   *	Sergei Shtylyov, <sshtylyov@ru.mvista.com> or <source@mvista.com>
>   */
>  
> @@ -524,36 +525,38 @@ static int check_in_drive_list(ide_drive

(the real) take #2 also updated hpt3xx_udma_filter() comment

>  static u8 hpt3xx_udma_filter(ide_drive_t *drive)
>  {
> -	struct hpt_info *info	= pci_get_drvdata(HWIF(drive)->pci_dev);
> -	u8 mask;
> +	ide_hwif_t *hwif	= HWIF(drive);
> +	struct hpt_info *info	= pci_get_drvdata(hwif->pci_dev);
> +	u8 mask 		= hwif->ultra_mask;
>  
>  	switch (info->chip_type) {
> -	case HPT370A:
> -		if (!HPT370_ALLOW_ATA100_5 ||
> -		    check_in_drive_list(drive, bad_ata100_5))
> -			return 0x1f;
> -		else
> -			return 0x3f;
> -	case HPT370:
> -		if (!HPT370_ALLOW_ATA100_5 ||
> -		    check_in_drive_list(drive, bad_ata100_5))
> -			mask = 0x1f;
> -		else
> -			mask = 0x3f;
> -		break;
>  	case HPT36x:
> -		if (!HPT366_ALLOW_ATA66_4 ||
> +		if (HPT366_ALLOW_ATA66_4 &&
>  		    check_in_drive_list(drive, bad_ata66_4))
> -			mask = 0x0f;
> -		else
> -			mask = 0x1f;
> +			mask &= ~0x10;
>  
> -		if (!HPT366_ALLOW_ATA66_3 ||
> +		if (HPT366_ALLOW_ATA66_3 &&
>  		    check_in_drive_list(drive, bad_ata66_3))
> -			mask = 0x07;
> +			mask &= ~0x08;
>  		break;
> +	case HPT370 :
> +	case HPT370A:
> +		if (HPT370_ALLOW_ATA100_5 &&
> +		    check_in_drive_list(drive, bad_ata100_5))
> +			mask &= ~0x20;
> +
> +		if (info->chip_type == HPT370A)
> +			return mask;
> +		break;
> +	case HPT372 :
> +	case HPT372A:
> +	case HPT372N:
> +	case HPT374 :
> +		if (ide_dev_is_sata(drive->id))
> +			mask &= ~0x0e;
> +		/* Fall thru */
>  	default:
> -		return 0x7f;
> +		return mask;
>  	}

I really don't see the advantage of "mask &=" over the previous
code ("mask = ATA_UDMA*") which was just more readable IMO.

I'm staying with (the real) take #2 of this patch for now.

Bart

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbXICSun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbXICSun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 14:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbXICSuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 14:50:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:43208 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbXICSub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 14:50:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=mbx9KB6U/YapM3cXTgqTjINGO50+pDKkuapsSU8pgvpzR4ZgNz4dEj7youW9z47sRBwUI4d0vFlIFrpx/YqxvOs5cA5kgqDz+4gdqMODCKVT/32oskYa/Y8aLbggsvI7cTR8MSE8cH/XRc9AP87QcsrK9LV5ejz2tKoHrpHLjC8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 3/4] ide: make ide_rate_filter() also respect PIO and SW/MW DMA mode masks (take 2)
Date: Mon, 3 Sep 2007 20:50:27 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200709022344.18565.sshtylyov@ru.mvista.com>
In-Reply-To: <200709022344.18565.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709032050.28121.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Sunday 02 September 2007, Sergei Shtylyov wrote:
> Make ide_rate_filter() also respect PIO/SWDMA/MWDMA mode masks.  While at it,

Hm, this seems to be already dealt with by:

http://kernel.org/pub/linux/kernel/people/bart/pata-2.6/patches/ide-mode-limiting-fixes-for-user-requested-speed-changes.patch

after applying the above patch ide_rate_filter() looks like this:

/**
 *      ide_rate_filter         -       filter transfer mode
 *      @drive: IDE device
 *      @speed: desired speed
 *
 *      Given the available transfer modes this function returns
 *      the best available speed at or below the speed requested.
 *
 *      TODO: check device PIO capabilities
 */

u8 ide_rate_filter(ide_drive_t *drive, u8 speed)
{
        ide_hwif_t *hwif = drive->hwif;
        u8 mode = ide_find_dma_mode(drive, speed);

        if (mode == 0) {
                if (hwif->pio_mask)
                        mode = fls(hwif->pio_mask) - 1 + XFER_PIO_0;
                else
                        mode = XFER_PIO_4;
        }

//      printk("%s: mode 0x%02x, speed 0x%02x\n", __FUNCTION__, mode, speed);

        return min(speed, mode);
}

What is still missing from IDE tree is "respecting device PIO limits" (sorry
I was quoting from memory it is TODO not FIXME [1]) which probably comes down
to adding ide_get_best_pio_mode() call to ide_rate_filter() (IMO this should
be done before ide-mode-limiting-fixes-for-user-requested-speed-changes.patch
changes).

[1] http://www.mail-archive.com/linux-ide@vger.kernel.org/msg09750.html

Ah, I see the source of the confusion now, I misunderstood your remark about
->mwdma_mask being ignored (for some reason I though that you were referring
to MWDMA mode not being tried if device refuses SET_XFER command w/ UDMA).

ide_find_dma_mode() is a bit tricky because it used also by ide_max_dma_mode()
but it should take care of ->mwdma_mask if ->udma_mask is zero just fine.

> make the udma_filter() method calls take precedence over using the mode masks.

This change is OK - could you make a new patch?

> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 
> ---
> Alas, the previous version of the patch wasn't even worth signing it off --
> the code had to be much trickier. The patch against the current Linus' tree and

take #1 was correct - i.e. if UDMA0 is not available we want to go down
to MWDMA2 and not MWDMA0 (this is what the old code was doing BTW)

> unfortunately I was able to only compile test it since that tree gives MODPOST
> warning and dies early on bootup. I'm hoping to give it more tesring when/if
> I have time... :-)
> 
>  drivers/ide/ide-dma.c |    7 +++---
>  drivers/ide/ide-lib.c |   57 ++++++++++++++++++++++++++++++--------------------
>  2 files changed, 39 insertions(+), 25 deletions(-)
> 
> Index: linux-2.6/drivers/ide/ide-dma.c
> ===================================================================
> --- linux-2.6.orig/drivers/ide/ide-dma.c
> +++ linux-2.6/drivers/ide/ide-dma.c
> @@ -664,10 +664,11 @@ static unsigned int ide_get_mode_mask(id
>  		if ((id->field_valid & 4) == 0)
>  			break;
>  
> -		mask = id->dma_ultra & hwif->ultra_mask;
> -
>  		if (hwif->udma_filter)
> -			mask &= hwif->udma_filter(drive);
> +			mask = hwif->udma_filter(drive);
> +		else
> +			mask = hwif->ultra_mask;
> +		mask &= id->dma_ultra;
>  
>  		if ((mask & 0x78) && (eighty_ninty_three(drive) == 0))
>  			mask &= 0x07;
> Index: linux-2.6/drivers/ide/ide-lib.c
> ===================================================================
> --- linux-2.6.orig/drivers/ide/ide-lib.c
> +++ linux-2.6/drivers/ide/ide-lib.c
> @@ -75,38 +75,51 @@ EXPORT_SYMBOL(ide_xfer_verbose);
>   *
>   *	Given the available transfer modes this function returns
>   *	the best available speed at or below the speed requested.
> - *
> - *	FIXME: filter also PIO/SWDMA/MWDMA modes
>   */
>  
>  u8 ide_rate_filter(ide_drive_t *drive, u8 speed)
>  {
> -#ifdef CONFIG_BLK_DEV_IDEDMA
>  	ide_hwif_t *hwif = drive->hwif;
> -	u8 mask = hwif->ultra_mask, mode = XFER_MW_DMA_2;
> +	u8 mask, base = speed & 0xf8, bit = 1 << (speed & 0x07);
>  
> -	if (hwif->udma_filter)
> -		mask = hwif->udma_filter(drive);
> +	switch (base) {
> +#ifdef CONFIG_BLK_DEV_IDEDMA
> +	case XFER_UDMA_0:
> +		mask = hwif->udma_filter ? hwif->udma_filter(drive) :
> +					   hwif->ultra_mask;
>  
> -	/*
> -	 * TODO: speed > XFER_UDMA_2 extra check is needed to avoid false
> -	 * cable warning from eighty_ninty_three(), moving ide_rate_filter()
> -	 * calls from ->speedproc to core code will make this hack go away
> -	 */
> -	if (speed > XFER_UDMA_2) {
> -		if ((mask & 0x78) && (eighty_ninty_three(drive) == 0))
> +		/*
> +		 * TODO: if speed > XFER_UDMA_2, an extra check is needed to
> +		 * avoid a false cable warning from eighty_ninty_three() --
> +		 * moving ide_rate_filter() calls from ->speedproc to core
> +		 * code will make this hack go away...
> +		 */
> +		if (speed > XFER_UDMA_2 && (mask & 0x78) &&
> +		    eighty_ninty_three(drive) == 0)
>  			mask &= 0x07;
> -	}
> -
> -	if (mask)
> -		mode = fls(mask) - 1 + XFER_UDMA_0;
>  
> -//	printk("%s: mode 0x%02x, speed 0x%02x\n", __FUNCTION__, mode, speed);
> -
> -	return min(speed, mode);
> -#else /* !CONFIG_BLK_DEV_IDEDMA */
> -	return min(speed, (u8)XFER_PIO_4);
> +		if (mask & bit)
> +			break;
> +		base = XFER_MW_DMA_0;
> +		/* Fall thru */
> +	case XFER_MW_DMA_0:
> +		if (hwif->mwdma_mask & bit)
> +			break;
> +		base = XFER_SW_DMA_0;
> +		/* Fall thru */
> +	case XFER_SW_DMA_0:
> +		if (hwif->swdma_mask & bit)
> +			break;
> +		base = XFER_PIO_0;
> +		/* Fall thru */
>  #endif /* CONFIG_BLK_DEV_IDEDMA */
> +	case XFER_PIO_0:
> +		if (hwif->pio_mask & bit)
> +			break;
> +	default:
> +		BUG();
> +	}
> +	return base | bit;
>  }
>  
>  EXPORT_SYMBOL(ide_rate_filter);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764838AbXHDNau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764838AbXHDNau (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 09:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759464AbXHDNan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 09:30:43 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:34990 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758938AbXHDNam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 09:30:42 -0400
Date: Sat, 4 Aug 2007 15:30:40 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org, David Vrabel <david.vrabel@csr.com>
Subject: Re: sdio: set the functions' block size
Message-ID: <20070804153040.73668e4e@poseidon.drzeus.cx>
In-Reply-To: <1185896193612-git-send-email-david.vrabel@csr.com>
References: <11858961933491-git-send-email-david.vrabel@csr.com>
	<1185896193612-git-send-email-david.vrabel@csr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 16:36:32 +0100
David Vrabel <david.vrabel@csr.com> wrote:

> Prior to calling the driver's probe(), set the functions' block size
> to the largest that's supported by both the card and the driver.
> 
> Signed-off-by: David Vrabel <david.vrabel@csr.com>
> 

Why a maximum size for the driver?

> diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
> index 8aa4666..c16c536 100644
> --- a/drivers/mmc/core/sdio_cis.c
> +++ b/drivers/mmc/core/sdio_cis.c
> @@ -93,9 +93,9 @@ static int cistpl_funce(struct sdio_func *func,
> unsigned fn, if (size < 0x04 || buf[0] != 0)
>  			goto bad;
>  		/* TPLFE_FN0_BLK_SIZE */
> -		val = buf[1] | (buf[2] << 8);
> +		func->max_block_size = buf[1] | (buf[2] << 8);
>  		printk(KERN_DEBUG "%s: TPLFE_FN0_BLK_SIZE = %u\n",
> -		       sdio_func_id(func), val);
> +		       sdio_func_id(func), func->max_block_size);
>  		/* TPLFE_MAX_TRAN_SPEED */
>  		val = speed_val[(buf[3] >> 3) & 15] *
> speed_unit[buf[3] & 7]; printk(KERN_DEBUG "%s: max speed = %u kbps\n",

I guess you aren't working against the latest tree as this code is
already there.

> @@ -126,9 +126,9 @@ static int cistpl_funce(struct sdio_func *func,
> unsigned fn, printk(KERN_DEBUG "%s: TPLFE_CSA_PROPERTY = 0x%02x\n",
>  		       sdio_func_id(func), val);
>  		/* TPLFE_MAX_BLK_SIZE */
> -		val = buf[12] | (buf[13] << 8);
> +		func->max_block_size = buf[12] | (buf[13] << 8);
>  		printk(KERN_DEBUG "%s: TPLFE_MAX_BLK_SIZE = %u\n",
> -		       sdio_func_id(func), val);
> +		       sdio_func_id(func), func->max_block_size);
>  		/* TPLFE_OCR */
>  		val = buf[14] | (buf[15] << 8) | (buf[16] << 16) |
> (buf[17] << 24); printk(KERN_DEBUG "%s: TPLFE_OCR = 0x%08x\n",

Ditto.

> diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
> index cc62ff7..e74e605 100644
> --- a/drivers/mmc/core/sdio_io.c
> +++ b/drivers/mmc/core/sdio_io.c
> @@ -148,6 +148,29 @@ err:
>  EXPORT_SYMBOL_GPL(sdio_disable_func);
>  
>  /**
> + *	sdio_set_block_size - set the block size of an SDIO
> function
> + *	@func: SDIO function to change
> + *	@blksz: new block size
> + */
> +int sdio_set_block_size(struct sdio_func *func, unsigned short blksz)
> +{
> +	int ret;
> +
> +	ret = mmc_io_rw_direct(func->card, 1, 0,
> SDIO_FBR_BLKSIZE(func->num),
> +			       blksz & 0xff, NULL);
> +	if (ret)
> +		return ret;
> +	ret = mmc_io_rw_direct(func->card, 1, 0,
> SDIO_FBR_BLKSIZE(func->num) + 1,
> +			       (blksz >> 8) & 0xff, NULL);
> +	if (ret)
> +		return ret;
> +	func->block_size = blksz;
> +	return 0;
> +}
> +
> +EXPORT_SYMBOL_GPL(sdio_set_block_size);
> +

You also need to check that the host supports that block size.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

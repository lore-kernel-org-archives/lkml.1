Return-Path: <linux-kernel-owner+w=401wt.eu-S934694AbXHGNm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934694AbXHGNm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932819AbXHGNms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:42:48 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:44927 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932625AbXHGNmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:42:47 -0400
Date: Tue, 7 Aug 2007 15:42:45 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] sdio: extend sdio_readsb() and friends to handle
 any length of buffer
Message-ID: <20070807154245.6e85f621@poseidon.drzeus.cx>
In-Reply-To: <46B86BB0.4000100@csr.com>
References: <11858961933491-git-send-email-david.vrabel@csr.com>
	<20070804152304.65ed8f1b@poseidon.drzeus.cx>
	<46B6F877.7060504@csr.com>
	<20070806171207.59fafa18@poseidon.drzeus.cx>
	<46B73F18.5030109@csr.com>
	<20070806220145.66b97559@poseidon.drzeus.cx>
	<46B86ADB.90000@csr.com>
	<46B86BB0.4000100@csr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007 13:55:12 +0100
David Vrabel <david.vrabel@csr.com> wrote:

> sdio: extend sdio_readsb() and friends to handle any length of buffer
> 
> Extend sdio_readsb(), sdio_writesb(), sdio_memcpy_fromio(), and
> sdio_memcpy_toio() to handle any length of buffer by splitting the
> transfer into several IO_RW_EXTENDED commands. Typically, a transfer
> would be split into a single block mode transfer followed by a byte
> mode transfer for the remainder.
> 
> For this to work the block size must be limited to the maximum size
> of a byte mode transfer (512 bytes).  This limitation could be
> revisited if there are any cards out there that require a block size
> > 512.
> 
> host->max_seg_size <= host->max_req_size so there's no need to check
> both when determining the maximum data size for a single command.
> 
> Signed-off-by: David Vrabel <david.vrabel@csr.com>
> ---
> Index: mmc/drivers/mmc/core/sdio_io.c
> ===================================================================
> --- mmc.orig/drivers/mmc/core/sdio_io.c	2007-08-07
> 07:27:31.000000000 +0100 +++ mmc/drivers/mmc/core/sdio_io.c
> 2007-08-07 07:35:02.000000000 +0100 @@ -153,6 +153,13 @@
>  {
>  	int ret;
>  
> +	/* The standard permits block sizes up to 2048 bytes, but
> +	 * sdio_readsb() etc. can only work with block size <= 512.
> */
> +	if (blksz > 512) {
> +		blksz = 512;
> +		dev_warn(&func->dev, "block size limited to 512
> bytes\n");
> +	}
> +

I'm not sure about not returning an error here. What if a driver calls
it and relies on being able to transfer >512 blocks?

>  	ret = mmc_io_rw_direct(func->card, 1, 0,
>  		SDIO_FBR_BASE(func->num) + SDIO_FBR_BLKSIZE,
>  		blksz & 0xff, NULL);
> @@ -227,6 +234,48 @@
>  
>  EXPORT_SYMBOL_GPL(sdio_writeb);
>  
> +/* Split an arbitrarily sized data transfer into several
> + * IO_RW_EXTENDED commands. */
> +static int sdio_io_rw_ext_helper(struct sdio_func *func, int write,
> +	unsigned fn, unsigned addr, int incr_addr, u8 *buf, unsigned
> size) +{
> +	unsigned remainder = size;
> +	unsigned max_blocks;
> +	int ret;
> +

We need to check support for block transfers here as well.

Also, the parameter fn is redundant.

> @@ -109,18 +109,22 @@
>  	cmd.opcode = SD_IO_RW_EXTENDED;
>  	cmd.arg = write ? 0x80000000 : 0x00000000;
>  	cmd.arg |= fn << 28;
> -	cmd.arg |= bang ? 0x00000000 : 0x04000000;
> +	cmd.arg |= incr_addr ? 0x04000000 : 0x00000000;
>  	cmd.arg |= addr << 9;
> -	cmd.arg |= (size == 512) ? 0 : size;
> +	if (blocks > 1) {

|| blksz > 512

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

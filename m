Return-Path: <linux-kernel-owner+w=401wt.eu-S1764866AbXHDNfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764866AbXHDNfS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 09:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759572AbXHDNfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 09:35:07 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:46858 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759464AbXHDNfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 09:35:05 -0400
Date: Sat, 4 Aug 2007 15:35:02 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org, David Vrabel <david.vrabel@csr.com>
Subject: Re: sdio: extend sdio_readsb() and friends to handle any length of
 buffer
Message-ID: <20070804153502.69bc1cc0@poseidon.drzeus.cx>
In-Reply-To: <1185896193650-git-send-email-david.vrabel@csr.com>
References: <11858961933491-git-send-email-david.vrabel@csr.com>
	<1185896193650-git-send-email-david.vrabel@csr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 16:36:33 +0100
David Vrabel <david.vrabel@csr.com> wrote:

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
> Signed-off-by: David Vrabel <david.vrabel@csr.com>
> 

*snip*

> @@ -228,6 +235,39 @@ void sdio_writeb(struct sdio_func *func,
> unsigned char b, unsigned int addr, 
>  EXPORT_SYMBOL_GPL(sdio_writeb);
>  
> +/* Split an arbitrarily sized data transfer into several
> + * IO_RW_EXTENDED commands. */
> +static int sdio_io_rw_ext_helper(struct sdio_func *func, int write,
> +	unsigned fn, unsigned addr, int incr_addr, u8 *buf, unsigned
> size) +{
> +	unsigned remainder = size;
> +	int ret;
> +
> +	while (remainder > func->block_size) {
> +		unsigned blocks;
> +
> +		blocks = remainder % func->block_size;
> +		if (blocks > 511)
> +			blocks = 511;

You need to check how many blocks the host supports in one go. Also,
the total size of the transfer might exceed the host's capabilities.

> @@ -113,18 +112,22 @@ int mmc_io_rw_extended(struct mmc_card *card,
> int write, unsigned fn, cmd.opcode = SD_IO_RW_EXTENDED;
>  	cmd.arg = write ? 0x80000000 : 0x00000000;
>  	cmd.arg |= fn << 28;
> -	cmd.arg |= bang ? 0x00000000 : 0x04000000;
> +	cmd.arg |= incr_addr ? 0x04000000 : 0x00000000;
>  	cmd.arg |= addr << 9;
> -	cmd.arg |= (size == 512) ? 0 : size;
> +	if (blocks > 1) {
> +		cmd.arg |= 0x08000000;
> +		cmd.arg |= blocks;
> +	} else
> +		cmd.arg |= (blksz == 512) ? 0 : blksz;
>  	cmd.flags = MMC_RSP_R5 | MMC_CMD_ADTC;
>  

Until this function is made complete, I'd like some kind of test that
blksz <= 512 when blocks == 1.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

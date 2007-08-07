Return-Path: <linux-kernel-owner+w=401wt.eu-S1764736AbXHGMwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764736AbXHGMwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 08:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbXHGMwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 08:52:36 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:51915 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbXHGMwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 08:52:35 -0400
Message-ID: <46B86ADB.90000@csr.com>
Date: Tue, 07 Aug 2007 13:51:39 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: linux-kernel@vger.kernel.org, david.vrabel@csr.com
Subject: Re: sdio: enhance IO_RW_EXTENDED support
References: <11858961933491-git-send-email-david.vrabel@csr.com>	<20070804152304.65ed8f1b@poseidon.drzeus.cx>	<46B6F877.7060504@csr.com>	<20070806171207.59fafa18@poseidon.drzeus.cx>	<46B73F18.5030109@csr.com> <20070806220145.66b97559@poseidon.drzeus.cx>
In-Reply-To: <20070806220145.66b97559@poseidon.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2007 12:51:45.0094 (UTC) FILETIME=[B5BA1E60:01C7D8F1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> This is essentially what I mean.

It does not behave very well, see the specific comments at the end.

When considering optimizing SDIO it is important to always keep in mind
that a command is very expensive.  They're some 100-150 clocks long and
there's also overheads in interrupt handling/scheduling, this can add to
up to 10s of us.  Therefore, when selecting an optimum block size one
should aim to reduce the number of commands before attempting to
maximize the block size.

There are two cases to consider.

1. Card's max block_size <= 512.

In this case the optimum block size is /always/ the card's maximum.
This means we can do all transfers in two commands (and if the driver is
aware of the block size it may choose to pad transfers so only one
command is done).

2. Card's max block size > 512.

We can't handle arbitrary sized transfers with a block size > 512 (since
512 is maximum length of a byte mode transfer), so if we wish to use a
block size of 1024 (say) some transfers will require three commands (a
block mode, and two byte mode transfers).  For a block size of 2048 (the
maximum possible) some transfer may require 5 commands!

We could attempt to set the block size as follows:

transfer size % 1024 == 0 => block size = 1024
transfer size % 2048 == 0 => block size = 2048
otherwise                 => block size = 512

However, without knowing what sizes of transfers the driver is going to
use we cannot intelligently know when it's best to switch the block
size.  A block size change is expensive (two commands).

The change in block size from 512 to 2048 improves performance (for an
individual command) by 2.0% [1].  I don't believe this performance
benefit is worth the possible overhead of frequent block size changes
nor the cost of potentially more than 2 commands per transfer.

  [1] The real performance benefit will be much less due to per command
  overhead and other non IO_RW_EXTENDED traffic on the bus.

In conclusion, the optimum block size is based solely on the card and
host capabilities and should be limited to at most 512.  Hence the block
size can (and should) only be set once during card initialization.

This has the added benefit of making the code simpler and hence easier
to understand and maintain.

> +/*
> + * Internal function. Splits an arbitrarily sized data transfer 
> + * into several IO_RW_EXTENDED commands.
> + */
> +static int sdio_io_rw_ext_helper(struct sdio_func *func, int write,
> +	unsigned addr, int incr_addr, u8 *buf, unsigned size)
> +{
> +	unsigned remainder = size;
> +	int ret;
> +	unsigned short blksz;
> +	struct mmc_host *host = func->card->host;
> +
> +	if (func->forced_blksz)
> +		blksz = func->forced_blksz;
> +	else {
> +		if (size <= 512)
> +			goto byte_remainder;

The maximum size for a byte mode transfer is the block size set in the card.

> +
> +		blksz = size;
> +		if (size > 0xffff)
> +			blksz = 0xffff;

The largest possible block size is 2048.  I'd also not be keen on using
a block size which isn't a power of 2 -- hardware is unlikely to have
been exercised with unusual block sizes.

> +		if (blksz > func->blksize)
> +			blksz = func->blksize;
> +		if (blksz > host->max_blk_size)
> +			blksz = host->max_blk_size;
> +
> +		/* avoid changing blksize needlessly */
> +		if (func->cur_blksz && ((blksz % func->cur_blksz) == 0))
> +			blksz = func->cur_blksz;

If func->blksize == 1024 and we perform transfers in the 512 to 1024
range, this would set the block size on every transfer.

> +	}

David
-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.

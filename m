Return-Path: <linux-kernel-owner+w=401wt.eu-S933921AbXHHKVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933921AbXHHKVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbXHHKVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:21:31 -0400
Received: from cluster-g.mailcontrol.com ([85.115.41.190]:47604 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbXHHKVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:21:30 -0400
Message-ID: <46B998B5.9040203@csr.com>
Date: Wed, 08 Aug 2007 11:19:33 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] sdio: extend sdio_readsb() and friends to handle
 any length of buffer
References: <11858961933491-git-send-email-david.vrabel@csr.com>	<20070804152304.65ed8f1b@poseidon.drzeus.cx>	<46B6F877.7060504@csr.com>	<20070806171207.59fafa18@poseidon.drzeus.cx>	<46B73F18.5030109@csr.com>	<20070806220145.66b97559@poseidon.drzeus.cx>	<46B86ADB.90000@csr.com>	<46B86BB0.4000100@csr.com> <20070807221719.7c89e5b6@poseidon.drzeus.cx>
In-Reply-To: <20070807221719.7c89e5b6@poseidon.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Aug 2007 10:19:44.0299 (UTC) FILETIME=[A3B8FFB0:01C7D9A5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
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
> +		blksz = func->max_blksz;
> +		if (blksz > host->max_blk_size)
> +			blksz = host->max_blk_size;
> +		if (blksz > 512)
> +			blksz = 512;
> +	}
> +
> +	WARN_ON(blksz > 512);
> +
> +	ret = sdio_set_block_size(func, blksz);
> +	if (ret)
> +		return ret;

We need to know the block size in use /before/ the start of the transfer
as we would like drivers to be able to perform transfers with single
commands as this can result in significantly better performance[1].  The
drivers for our (CSR's) WiFi chips should do this.  This isn't some (as
you suggested in a previous post) 'rare' requirement.

Therefore, we should not change the block size here.

We can also support block sizes > 512 and have this function do the
correct thing (as you'll see when I post my final patches).

David

[1] Consider a chip with a block size of 64 that regularly does short
transfers of between 64 - 128 bytes.  Without padding, this would
require two commands per transfer instead of just one, cutting
performance by 50%!  This scenario could be a WiFi chip doing VoIP.
-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.

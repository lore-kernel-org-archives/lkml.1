Return-Path: <linux-kernel-owner+w=401wt.eu-S1751778AbZIGT7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbZIGT7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 15:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbZIGT7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 15:59:36 -0400
Received: from r00tworld.com ([212.85.137.21]:54801 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbZIGT7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 15:59:36 -0400
X-Greylist: delayed 3405 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Sep 2009 15:59:35 EDT
From: pageexec@freemail.hu
To: linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Mon, 07 Sep 2009 21:02:55 +0200
MIME-Version: 1.0
Subject: Re: [PATCH 1/6] firewire: core: reduce stack usage in bus reset tasklet
Reply-to: pageexec@freemail.hu
CC: linux-kernel@vger.kernel.org
Message-ID: <4AA558DF.5024.3D1AC09D@pageexec.freemail.hu>
In-reply-to: <tkrat.3db711855693c0e5@s5r6.in-berlin.de>
References: <tkrat.85bb80d9295444c1@s5r6.in-berlin.de>, <tkrat.3db711855693c0e5@s5r6.in-berlin.de>
X-mailer: Pegasus Mail for Windows (4.51)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Mon, 07 Sep 2009 21:02:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Sep 2009 at 18:48, Stefan Richter wrote:

> Index: linux-2.6.31-rc9/drivers/firewire/core-card.c
> ===================================================================
> --- linux-2.6.31-rc9.orig/drivers/firewire/core-card.c
> +++ linux-2.6.31-rc9/drivers/firewire/core-card.c
> @@ -38,16 +38,21 @@
>  
>  #include "core.h"
>  
> -int fw_compute_block_crc(u32 *block)
> +int fw_compute_block_crc(u32 *block, gfp_t flags)
>  {
> -	__be32 be32_block[256];
> -	int i, length;
> +	static __be32 *be32_block;
       ^^^^^^

did you actually mean that to be static? if so, then you might as well allocate the
buffer statically and not worry about a runtime allocation failure.

> +	int i, length = (*block >> 16) & 0xff;
> +
> +	be32_block = kmalloc(length * 4, flags);
> +	if (WARN_ON(!be32_block))
> +		goto out;
>  
> -	length = (*block >> 16) & 0xff;
>  	for (i = 0; i < length; i++)
>  		be32_block[i] = cpu_to_be32(block[i + 1]);
>  	*block |= crc_itu_t(0, (u8 *) be32_block, length * 4);
>  
> +	kfree(be32_block);
> + out:
>  	return length;
>  }




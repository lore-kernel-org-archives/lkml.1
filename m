Return-Path: <linux-kernel-owner+w=401wt.eu-S1753703AbZBHVlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbZBHVlX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbZBHVlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:41:14 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:55211 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbZBHVlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:41:13 -0500
Date: Sun, 8 Feb 2009 21:12:53 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, rjw@sisk.pl
Subject: Re: [PATCH] libata-sff: fix 32-bit PIO regression
In-Reply-To: <200902082253.07438.sshtylyov@ru.mvista.com>
Message-ID: <Pine.LNX.4.64.0902082108290.18661@blonde.anvils>
References: <200902082253.07438.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Feb 2009, Sergei Shtylyov wrote:

> Commit 871af1210f13966ab911ed2166e4ab2ce775b99d (libata: Add 32bit PIO support)
> caused all kind of errors on the ATAPI devices, so it's been empirically proven
> that one shouldn't read/write an extra data word when a device isn't expecting
> it already. "Don't do it then"; however still taking a chance to use 32-bit I/O
> one last  time when there are exactly 3 trailing bytes.  Oh, and stop pointless
> swapping bytes to and fro as well by using io*_rep() which shouldn't byte-swap.
> 
> This should fix the kernel.org bug #12609.
> 
> ---
> This is hopefully better replacement for Hugh Dickins most recent patch
> (http://marc.info/?l=linux-ide&m=123352294619281)...

Yes, looks nice, and works for me.  My only criticism would be,
minor issue unchanged by your patch, that actually "slop" isn't
unlikely enough to deserve an "unlikely" - slop of 1 or 3 is
unlikely, but slop of 2 is quite common.

Hugh

> 
>  drivers/ata/libata-sff.c |   23 ++++++++++++++++-------
>  1 files changed, 16 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6/drivers/ata/libata-sff.c
> ===================================================================
> --- linux-2.6.orig/drivers/ata/libata-sff.c
> +++ linux-2.6/drivers/ata/libata-sff.c
> @@ -773,18 +773,27 @@ unsigned int ata_sff_data_xfer32(struct 
>  	else
>  		iowrite32_rep(data_addr, buf, words);
>  
> +	/* Transfer trailing bytes, if any */
>  	if (unlikely(slop)) {
> -		__le32 pad;
> +		unsigned char pad[4];
> +
> +		/* Point buf to the tail of buffer */
> +		buf += buflen - slop;
>  		if (rw == READ) {
> -			pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
> -			memcpy(buf + buflen - slop, &pad, slop);
> +			if (slop < 3)
> +				ioread16_rep(data_addr, pad, 1);
> +			else
> +				ioread32_rep(data_addr, pad, 1);
> +			memcpy(buf, pad, slop);
>  		} else {
> -			memcpy(&pad, buf + buflen - slop, slop);
> -			iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
> +			memcpy(pad, buf, slop);
> +			if (slop < 3)
> +				iowrite16_rep(data_addr, pad, 1);
> +			else
> +				iowrite32_rep(data_addr, pad, 1);
>  		}
> -		words++;
>  	}
> -	return words << 2;
> +	return (buflen + 1) & ~1;
>  }
>  EXPORT_SYMBOL_GPL(ata_sff_data_xfer32);
>  

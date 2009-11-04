Return-Path: <linux-kernel-owner+w=401wt.eu-S1752471AbZKDAh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbZKDAh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZKDAh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:37:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751920AbZKDAh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:37:57 -0500
Date: Tue, 3 Nov 2009 16:37:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: phorton@bitbox.co.uk (Peter Horton)
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] prevent AoE causing cache aliases
Message-Id: <20091103163755.57d3530c.akpm@linux-foundation.org>
In-Reply-To: <20091022142228.GA18986@bitbox.co.uk>
References: <20091022142228.GA18986@bitbox.co.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009 15:22:28 +0100
phorton@bitbox.co.uk (Peter Horton) wrote:

> To: ecashin@coraid.com

Have you heard back from Ed on this?

> Cc: linux-kernel@vger.kernel.org
> Subject: [PATCH] prevent AoE causing cache aliases
> Date: 	Thu, 22 Oct 2009 15:22:28 +0100
> Sender: linux-kernel-owner@vger.kernel.org
> User-Agent: Mutt/1.5.9i
> 
> This patch prevents the AoE block driver from creating cache aliases of
> page cache pages on machines with virtually indexed caches.
> 
> Building kernels on an AT91SAM9G20 board without this patch fails with
> segmentation faults after a couple of passes.
> 
> 
> Index: linux-2.6.31/drivers/block/aoe/aoecmd.c
> ===================================================================
> --- linux-2.6.31.orig/drivers/block/aoe/aoecmd.c	2009-09-09 23:13:59.000000000 +0100
> +++ linux-2.6.31/drivers/block/aoe/aoecmd.c	2009-10-22 10:24:50.000000000 +0100
> @@ -735,6 +735,21 @@
>  	part_stat_unlock();
>  }
>  
> +/*
> + * Ensure we don't create aliases in VI caches
> + */
> +static inline void
> +killalias(struct bio *bio)
> +{
> +	struct bio_vec *bv;
> +	int i;
> +
> +	if (bio_data_dir(bio) == READ)
> +		__bio_for_each_segment(bv, bio, i, 0) {
> +			flush_dcache_page(bv->bv_page);
> +		}
> +}
> +
>  void
>  aoecmd_ata_rsp(struct sk_buff *skb)
>  {
> @@ -853,8 +868,12 @@
>  
>  	if (buf && --buf->nframesout == 0 && buf->resid == 0) {
>  		diskstats(d->gd, buf->bio, jiffies - buf->stime, buf->sector);
> -		n = (buf->flags & BUFFL_FAIL) ? -EIO : 0;
> -		bio_endio(buf->bio, n);
> +		if (buf->flags & BUFFL_FAIL)
> +			bio_endio(buf->bio, -EIO);
> +		else {
> +			killalias(buf->bio);
> +			bio_endio(buf->bio, 0);
> +		}
>  		mempool_free(buf, d->bufpool);
>  	}

Looks OK.

This bugfix will cause a pointless __bio_for_each_segment() busywait
loop to be executed on architectures for which flush_dcache_page() is a
no-op.

We don't have infrastructure to fix that.

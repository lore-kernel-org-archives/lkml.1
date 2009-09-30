Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbZI3G5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbZI3G5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 02:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZI3G5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 02:57:19 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54252 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbZI3G5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 02:57:19 -0400
Date: Wed, 30 Sep 2009 08:57:22 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] swapfile: avoid NULL pointer dereference in swapon
	when s_bdev  is NULL
Message-ID: <20090930065722.GN23126@kernel.dk>
References: <4AC1FC41.2060807@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC1FC41.2060807@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29 2009, Suresh Jayaraman wrote:
> While testing Swap over NFS patchset, I noticed an oops that was triggered
> during swapon. Investigating further, the NULL pointer deference is due to the
> SSD device check/optimization in the swapon code that assumes s_bdev could never
> be NULL.
> 
> inode->i_sb->s_bdev could be NULL in a few cases. For e.g. one such case is
> loopback NFS mount, there could be others as well. Fix this by ensuring s_bdev
> is not NULL before we try to deference s_bdev.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
> ---
>  mm/swapfile.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 4de7f02..a1bc6b9 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1974,12 +1974,14 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  		goto bad_swap;
>  	}
>  
> -	if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
> -		p->flags |= SWP_SOLIDSTATE;
> -		p->cluster_next = 1 + (random32() % p->highest_bit);
> +	if (p->bdev) {
> +		if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
> +			p->flags |= SWP_SOLIDSTATE;
> +			p->cluster_next = 1 + (random32() % p->highest_bit);
> +		}
> +		if (discard_swap(p) == 0)
> +			p->flags |= SWP_DISCARDABLE;
>  	}
> -	if (discard_swap(p) == 0)
> -		p->flags |= SWP_DISCARDABLE;
>  
>  	mutex_lock(&swapon_mutex);
>  	spin_lock(&swap_lock);

Thanks for the patch, looks correct.

-- 
Jens Axboe


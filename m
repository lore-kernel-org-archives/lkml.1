Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbYKNIme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbYKNIme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 03:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbYKNImZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 03:42:25 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:33044 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbYKNImZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 03:42:25 -0500
Date: Fri, 14 Nov 2008 09:40:45 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, jeremy@xensource.com
Subject: Re: [PATCH] Release old elevator on change elevator
Message-ID: <20081114084045.GO26778@kernel.dk>
References: <491D387D.1000501@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491D387D.1000501@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14 2008, Zhaolei wrote:
> We should release old elevator when change to use a new one.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  drivers/block/xen-blkfront.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index b220c68..2d19f0c 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -338,12 +338,18 @@ wait:
>  static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size)
>  {
>  	struct request_queue *rq;
> +	elevator_t *old_e;
>  
>  	rq = blk_init_queue(do_blkif_request, &blkif_io_lock);
>  	if (rq == NULL)
>  		return -1;
>  
> -	elevator_init(rq, "noop");
> +	old_e = rq->elevator;
> +	if (IS_ERR_VALUE(elevator_init(rq, "noop")))
> +		printk(KERN_WARNING
> +			"blkfront: Switch elevator failed, use default\n");
> +	else
> +		elevator_exit(old_e);
>  
>  	/* Hard sector size and max sectors impersonate the equiv. hardware. */
>  	blk_queue_hardsect_size(rq, sector_size);
> -- 
> 1.5.5.3

I thought we'd already switched that to the nonrot flag, but that is
merged up for 2.6.29. So this looks appropriate for 2.6.28, I'll queue
it up.

-- 
Jens Axboe


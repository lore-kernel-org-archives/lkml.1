Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab0BUQHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 11:07:34 -0500
Received: from adelie.canonical.com ([91.189.90.139]:34222 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab0BUQHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 11:07:30 -0500
Message-ID: <4B815A3D.9040402@canonical.com>
Date: Sun, 21 Feb 2010 17:07:25 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Alasdair G Kergon <agk@redhat.com>,
       Junichi Nomura <j-nomura@ce.jp.nec.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [93/93] dm mpath: fix stall when requeueing io
References: <20100219163257.186977438@kvm.kroah.org>
In-Reply-To: <20100219163257.186977438@kvm.kroah.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> 
> commit 9eef87da2a8ea4920e0d913ff977cac064b68ee0 upstream.
> 
> This patch fixes the problem that system may stall if target's ->map_rq
> returns DM_MAPIO_REQUEUE in map_request().
> E.g. stall happens on 1 CPU box when a dm-mpath device with queue_if_no_path
>      bounces between all-paths-down and paths-up on I/O load.
> 
> When target's ->map_rq returns DM_MAPIO_REQUEUE, map_request() requeues
> the request and returns to dm_request_fn().  Then, dm_request_fn()
> doesn't exit the I/O dispatching loop and continues processing
> the requeued request again.
> This map and requeue loop can be done with interrupt disabled,
> so 1 CPU system can be stalled if this situation happens.
> 
> For example, commands below can stall my 1 CPU box within 1 minute or so:
>   # dmsetup table mp
>   mp: 0 2097152 multipath 1 queue_if_no_path 0 1 1 service-time 0 1 2 8:144 1 1
>   # while true; do dd if=/dev/mapper/mp of=/dev/null bs=1M count=100; done &
>   # while true; do \
>   > dmsetup message mp 0 "fail_path 8:144" \
>   > dmsetup suspend --noflush mp \
>   > dmsetup resume mp \
>   > dmsetup message mp 0 "reinstate_path 8:144" \
>   > done
> 
> To fix the problem above, this patch changes dm_request_fn() to exit
> the I/O dispatching loop once if a request is requeued in map_request().
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Signed-off-by: Alasdair G Kergon <agk@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/md/dm.c |   21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1487,11 +1487,15 @@ static int dm_prep_fn(struct request_que
>  	return BLKPREP_OK;
>  }
>  
> -static void map_request(struct dm_target *ti, struct request *rq,
> -			struct mapped_device *md)
> +/*
> + * Returns:
> + * 0  : the request has been processed (not requeued)
> + * !0 : the request has been requeued
> + */
> +static int map_request(struct dm_target *ti, struct request *clone,
> +		       struct mapped_device *md)
>  {
> -	int r;
> -	struct request *clone = rq->special;

This change requires the argument to this function to be a rq->special
pointer. This is changed in the map_request function by the following
patch:

commit b4324feeae304ae39e631a254d238a7d63be004b
Author: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Date:   Thu Dec 10 23:52:16 2009 +0000

    dm: use md pending for in flight IO counting

> +	int r, requeued = 0;
>  	struct dm_rq_target_io *tio = clone->end_io_data;
>  
>  	/*
> @@ -1516,6 +1520,7 @@ static void map_request(struct dm_target
>  	case DM_MAPIO_REQUEUE:
>  		/* The target wants to requeue the I/O */
>  		dm_requeue_unmapped_request(clone);
> +		requeued = 1;
>  		break;
>  	default:
>  		if (r > 0) {
> @@ -1527,6 +1532,8 @@ static void map_request(struct dm_target
>  		dm_kill_unmapped_request(clone, r);
>  		break;
>  	}
> +
> +	return requeued;
>  }
>  
>  /*
> @@ -1568,12 +1575,16 @@ static void dm_request_fn(struct request
>  
>  		blk_start_request(rq);
>  		spin_unlock(q->queue_lock);
> -		map_request(ti, rq, md);
> +		if (map_request(ti, rq, md))
> +			goto requeued;
>  		spin_lock_irq(q->queue_lock);
>  	}

That is the current state of dm_request_function:

                clone = rq->special;
                atomic_inc(&md->pending[rq_data_dir(clone)]);

                spin_unlock(q->queue_lock);
                if (map_request(ti, clone, md))

While looking over the code I also noticed that the spinlock is dropped with
spin_unlock and then reacquired with spin_lock_irq. Isn't the irq version too
much in that case? Or was the intention to have interrupts enabled when unlocking?

-Stefan

>  	goto out;
>  
> +requeued:
> +	spin_lock_irq(q->queue_lock);
> +
>  plug_and_out:
>  	if (!elv_queue_empty(q))
>  		/* Some requests still remain, retry later */
> 
> 
> _______________________________________________
> Stable-review mailing list
> Stable-review@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable-review


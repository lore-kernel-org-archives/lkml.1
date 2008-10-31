Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbYJaHfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbYJaHfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 03:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbYJaHey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 03:34:54 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52690 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbYJaHex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 03:34:53 -0400
Date: Fri, 31 Oct 2008 08:33:39 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] elevator.c: prevent flushing small requests to device
Message-ID: <20081031073338.GZ31673@kernel.dk>
References: <20081023161333.GA28155@xs4all.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023161333.GA28155@xs4all.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23 2008, Miquel van Smoorenburg wrote:
> While tracing I/O patterns with blktrace (a great tool) a few
> weeks ago I identified a minor issue in elevator.c
> 
> [PATCH] elevator.c: prevent flushing small requests to device
> 
> When elv_insert() is called to insert a new request, and the
> device is plugged,  bit of code at the end of the function
> will unplug the device if the number of pending requests >= q->unplug_thresh.
> 
> This means the current request is also sent to the device immidiately
> while it is potentially mergeable with the next request. This has been
> observed when a lot of small sequential requests are made.
> 
> By unplugging the device before we add the new request to the
> queue this can be prevented.
> 
> Signed-off-by: Miquel van Smoorenburg <mikevs@xs4all.net>
> 
> diff -ruN linux-2.6.26.5.orig/block/elevator.c linux-2.6.26.5/block/elevator.c
> --- linux-2.6.26.5.orig/block/elevator.c	2008-09-08 19:40:20.000000000 +0200
> +++ linux-2.6.26.5/block/elevator.c	2008-10-23 00:33:21.000000000 +0200
> @@ -602,6 +602,20 @@
>  
>  	case ELEVATOR_INSERT_SORT:
>  		BUG_ON(!blk_fs_request(rq));
> +		/*
> +		 * If we're going to unplug the device, do it now before
> +		 * we put a potentially small and mergeable new
> +		 * request on the queue, instead of just after it.
> +		 */
> +		if (blk_queue_plugged(q)) {
> +			int nrq = q->rq.count[READ] + q->rq.count[WRITE]
> +				- q->in_flight;
> +			if (nrq >= q->unplug_thresh)
> +				__generic_unplug_device(q);
> +			if (elv_queue_empty(q))
> +				blk_plug_device(q);
> +			unplug_it = 0;
> +		}
>  		rq->cmd_flags |= REQ_SORTED;
>  		q->nr_sorted++;
>  		if (rq_mergeable(rq)) {

This makes sense, I'll throw it into the 2.6.29 mix for some testing.
I've slightly modified your patch, there's no need to check for queue
empty and plug on your own, __make_request() will do that.

-- 
Jens Axboe


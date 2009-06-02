Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbZFBGnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbZFBGnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 02:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbZFBGnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 02:43:07 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40802 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126AbZFBGnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 02:43:05 -0400
Date: Tue, 2 Jun 2009 08:43:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH block#for-2.6.31] block: fix a possible oops on
	elv_abort_queue()
Message-ID: <20090602064307.GX11363@kernel.dk>
References: <4A246772.1090304@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A246772.1090304@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02 2009, Kiyoshi Ueda wrote:
> Hi Jens,
> 
> I found one more mis-conversion to the 'request is always dequeued
> when completing' model in elv_abort_queue() during code inspection.
> Although I haven't hit any problem caused by this mis-conversion yet
> and just done compile/boot test, please apply if you have no problem.
> 
> 
> Request must be dequeued when it completes.
> However, elv_abort_queue() completes requests without dequeueing.
> This will cause oops in the __blk_end_request_all().
> This patch fixes the oops.

Thanks, applied!

> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> ---
>  block/elevator.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> Index: linux-2.6-block/block/elevator.c
> ===================================================================
> --- linux-2.6-block.orig/block/elevator.c
> +++ linux-2.6-block/block/elevator.c
> @@ -813,6 +813,11 @@ void elv_abort_queue(struct request_queu
>  		rq = list_entry_rq(q->queue_head.next);
>  		rq->cmd_flags |= REQ_QUIET;
>  		trace_block_rq_abort(q, rq);
> +		/*
> +		 * Mark this request as started so we don't trigger
> +		 * any debug logic in the end I/O path.
> +		 */
> +		blk_start_request(rq);
>  		__blk_end_request_all(rq, -EIO);
>  	}
>  }

-- 
Jens Axboe


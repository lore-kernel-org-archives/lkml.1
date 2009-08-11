Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbZHKM47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbZHKM47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbZHKM46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:56:58 -0400
Received: from brick.kernel.dk ([93.163.65.50]:43300 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbZHKM45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:56:57 -0400
Date: Tue, 11 Aug 2009 08:22:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CFQ: mark must_alloc flag when a cfqq doesn't allocate
	any  request
Message-ID: <20090811062243.GP12579@kernel.dk>
References: <4A7B930D.6060206@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7B930D.6060206@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07 2009, Gui Jianfeng wrote:
> Hi Jens,
> 
> CFQ judges whether must_alloc flag is set, but never marks this flag.
> This patch set must_alloc flag when there is no request allocated by
> a cfqq. This change ensures cfqq will get at least one request even
> if the queue is full.
> Hope it helps.

The flag became redundant with the fix to not fail in set_request(). I
don't think your below patch is a very good idea, it would basically
mark any queue that has previously had a request allocated as a must
alloc queue. It would make more sense to mark an idling queue as must
alloc, since it's critical that this queue is allowed to allocate a
request once we idle a queue on its behalf. But we already check for the
wait_request flag in ->may_queue, so that part is already covered. So
I'd suggest we just delete any reference to must_alloc instead.


> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/cfq-iosched.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index fd7080e..531a404 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -2279,6 +2279,9 @@ static void cfq_put_request(struct request *rq)
>  		BUG_ON(!cfqq->allocated[rw]);
>  		cfqq->allocated[rw]--;
>  
> +		if (!(cfqq->allocated[0] + cfqq->allocated[1]))
> +			cfq_mark_cfqq_must_alloc(cfqq);
> +
>  		put_io_context(RQ_CIC(rq)->ioc);
>  
>  		rq->elevator_private = NULL;
> -- 
> 1.5.4.rc3
> 
> 

-- 
Jens Axboe


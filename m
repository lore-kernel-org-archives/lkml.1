Return-Path: <linux-kernel-owner+w=401wt.eu-S1763820AbYBBAz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763820AbYBBAz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762122AbYBBAzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:55:14 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:27827 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762029AbYBBAzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:55:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=sdeFPyn6ZKgPuf+0VVKLesU9f/4HmZFodcI0NXByEmj6ODKxaZ3y5KIuzPJDAz6FfS1lPeg+7RTscjQeR2Oi4PHkRztro1WUsDE6Rqhfu+pPcFCjX5Jl1p6L/lIf1N3J+3bineVHvSsKGoY8+G6/wFAZreooCmvvceIFzgz7qUw=  ;
X-YMail-OSG: qzcdrCUVM1lCbTUDIh4qLhjBvslfoyFbm2ZwHIQ4XMmMqQ15kXZRd7V90rQZfLeQTSuTPywVBA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [bug] as_merged_requests(): possible recursive locking detected
Date: Sat, 2 Feb 2008 11:54:49 +1100
User-Agent: KMail/1.9.5
Cc: Nikanth Karthikesan <knikanth@suse.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <20080131221436.GA3760@elte.hu> <20080201101212.GK15220@kernel.dk> <20080201103151.GL15220@kernel.dk>
In-Reply-To: <20080201103151.GL15220@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802021154.50174.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 February 2008 21:31, Jens Axboe wrote:
> On Fri, Feb 01 2008, Jens Axboe wrote:

> > I think the right solution is to remove swap_io_context() and fix the io
> > context referencing in as-iosched.c instead.
>
> IOW, the below. I don't know why Nick originally wanted to swap io
> contexts for a rq <-> rq merge, there seems little (if any) benefit to
> doing so.

Yeah, I guess this patch is fine. Simpler is better.

>
> diff --git a/block/as-iosched.c b/block/as-iosched.c
> index 9603684..852803e 100644
> --- a/block/as-iosched.c
> +++ b/block/as-iosched.c
> @@ -1266,22 +1266,8 @@ static void as_merged_requests(struct request_queue
> *q, struct request *req, */
>  	if (!list_empty(&req->queuelist) && !list_empty(&next->queuelist)) {
>  		if (time_before(rq_fifo_time(next), rq_fifo_time(req))) {
> -			struct io_context *rioc = RQ_IOC(req);
> -			struct io_context *nioc = RQ_IOC(next);
> -
>  			list_move(&req->queuelist, &next->queuelist);
>  			rq_set_fifo_time(req, rq_fifo_time(next));
> -			/*
> -			 * Don't copy here but swap, because when anext is
> -			 * removed below, it must contain the unused context
> -			 */
> -			if (rioc != nioc) {
> -				double_spin_lock(&rioc->lock, &nioc->lock,
> -								rioc < nioc);
> -				swap_io_context(&rioc, &nioc);
> -				double_spin_unlock(&rioc->lock, &nioc->lock,
> -								rioc < nioc);
> -			}
>  		}
>  	}
>
> diff --git a/block/blk-ioc.c b/block/blk-ioc.c
> index 6d16755..80245dc 100644
> --- a/block/blk-ioc.c
> +++ b/block/blk-ioc.c
> @@ -176,15 +176,6 @@ void copy_io_context(struct io_context **pdst, struct
> io_context **psrc) }
>  EXPORT_SYMBOL(copy_io_context);
>
> -void swap_io_context(struct io_context **ioc1, struct io_context **ioc2)
> -{
> -	struct io_context *temp;
> -	temp = *ioc1;
> -	*ioc1 = *ioc2;
> -	*ioc2 = temp;
> -}
> -EXPORT_SYMBOL(swap_io_context);
> -
>  int __init blk_ioc_init(void)
>  {
>  	iocontext_cachep = kmem_cache_create("blkdev_ioc",
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index baba233..bbe3cf4 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -39,7 +39,6 @@ void exit_io_context(void);
>  struct io_context *get_io_context(gfp_t gfp_flags, int node);
>  struct io_context *alloc_io_context(gfp_t gfp_flags, int node);
>  void copy_io_context(struct io_context **pdst, struct io_context **psrc);
> -void swap_io_context(struct io_context **ioc1, struct io_context **ioc2);
>
>  struct request;
>  typedef void (rq_end_io_fn)(struct request *, int);

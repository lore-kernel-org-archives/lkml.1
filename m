Return-Path: <linux-kernel-owner+w=401wt.eu-S1759000AbYBAKMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000AbYBAKMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbYBAKMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:12:16 -0500
Received: from brick.kernel.dk ([87.55.233.238]:24333 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554AbYBAKMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:12:15 -0500
Date: Fri, 1 Feb 2008 11:12:12 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [bug] as_merged_requests(): possible recursive locking detected
Message-ID: <20080201101212.GK15220@kernel.dk>
References: <20080131221436.GA3760@elte.hu> <1201860191.10128.0.camel@nikanth-laptop.blr.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201860191.10128.0.camel@nikanth-laptop.blr.novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01 2008, Nikanth Karthikesan wrote:
> On Thu, 2008-01-31 at 23:14 +0100, Ingo Molnar wrote:
> > 
> > Jens,
> > 
> > AS still has some locking issues - see the lockdep warning below that 
> > the x86 test-rig just triggered. Config attached. Never saw this one 
> > before. Can send more info if needed.
> > 
> 
> The io_contexts are swapped. And while swapping, the locks were also
> getting swapped, which will change the order of locking after that. This
> may be the cause of these warning. I am not sure whether not swapping
> the locks is the right way to fix this. Using a field of spinlock_t
> itself to order locking might be better, instead of the address of the
> container.
> 
> Now while adding a new member to io_context, one should not forget to
> add it here. Also copying whole io_context and then restoring the locks
> might have a window where this warning could be triggered.

Oops, the locks should definitely be left alone. It's not just the
locking order, but also it would confuse lockdep.

> diff --git a/block/blk-ioc.c b/block/blk-ioc.c
> index 6d16755..b9c6e39 100644
> --- a/block/blk-ioc.c
> +++ b/block/blk-ioc.c
> @@ -179,9 +179,32 @@ EXPORT_SYMBOL(copy_io_context);
>  void swap_io_context(struct io_context **ioc1, struct io_context **ioc2)
>  {
>  	struct io_context *temp;
> +
> +	/*
> +	 * Do not swap the locks to preserve locking order
> +	 */
> +
>  	temp = *ioc1;
> -	*ioc1 = *ioc2;
> -	*ioc2 = temp;
> +
> +	(*ioc1)->refcount = (*ioc2)->refcount;
> +	(*ioc1)->nr_tasks = (*ioc2)->nr_tasks;
> +	(*ioc1)->ioprio = (*ioc2)->ioprio;
> +	(*ioc1)->ioprio_changed = (*ioc2)->ioprio_changed;
> +	(*ioc1)->last_waited = (*ioc2)->last_waited;
> +	(*ioc1)->nr_batch_requests = (*ioc2)->nr_batch_requests;
> +	(*ioc1)->aic = (*ioc2)->aic;
> +	(*ioc1)->radix_root = (*ioc2)->radix_root;
> +	(*ioc1)->ioc_data = (*ioc2)->ioc_data;
> +
> +	(*ioc2)->refcount = (temp)->refcount;
> +	(*ioc2)->nr_tasks = (temp)->nr_tasks;
> +	(*ioc2)->ioprio = (temp)->ioprio;
> +	(*ioc2)->ioprio_changed = (temp)->ioprio_changed;
> +	(*ioc2)->last_waited = (temp)->last_waited;
> +	(*ioc2)->nr_batch_requests = (temp)->nr_batch_requests;
> +	(*ioc2)->aic = (temp)->aic;
> +	(*ioc2)->radix_root = (temp)->radix_root;
> +	(*ioc2)->ioc_data = (temp)->ioc_data;
>  }
>  EXPORT_SYMBOL(swap_io_context);

Ugh, that's pretty horrible. How about moving the lock first in the
struct and just doing memcpy()? Still ugly, but better.

I think the right solution is to remove swap_io_context() and fix the io
context referencing in as-iosched.c instead.

-- 
Jens Axboe


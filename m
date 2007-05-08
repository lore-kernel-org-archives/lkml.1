Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbXEHHJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbXEHHJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 03:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbXEHHJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 03:09:27 -0400
Received: from mx12.go2.pl ([193.17.41.142]:56146 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755186AbXEHHJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 03:09:26 -0400
Date: Tue, 8 May 2007 09:15:44 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
Message-ID: <20070508071544.GA1772@ff.dom.local>
References: <20070503204226.GA212@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503204226.GA212@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Below are some of my suggestions:


On Fri, May 04, 2007 at 12:42:26AM +0400, Oleg Nesterov wrote:
...
> --- OLD/kernel/workqueue.c~1_CRDW	2007-05-02 23:29:07.000000000 +0400
> +++ OLD/kernel/workqueue.c	2007-05-03 22:42:29.000000000 +0400
> @@ -120,6 +120,11 @@ static void insert_work(struct cpu_workq
>  				struct work_struct *work, int tail)
>  {
>  	set_wq_data(work, cwq);
> +	/*
> +	 * Ensure that we get the right work->data if we see the
> +	 * result of list_add() below, see try_to_grab_pending().
> +	 */
> +	smp_wmb();
>  	if (tail)
>  		list_add_tail(&work->entry, &cwq->worklist);
>  	else
> @@ -381,7 +386,46 @@ void fastcall flush_workqueue(struct wor
>  }
>  EXPORT_SYMBOL_GPL(flush_workqueue);
>  
> -static void wait_on_work(struct cpu_workqueue_struct *cwq,
> +/*
> + * Upon a successfull return, the caller "owns" WORK_STRUCT_PENDING bit,
> + * so this work can't be re-armed in any way.
> + */
> +static int try_to_grab_pending(struct work_struct *work)
> +{
> +	struct cpu_workqueue_struct *cwq;
> +	int ret = 0;
> +
> +	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work)))
> +		return 1;

Previous version used this check to run del_timer, and I think, it
was good idea. So, maybe, try something like this:

- run once del_timer before the loop (in cancel_rearming_ only),
- add a parmeter to try_to_grab_pending, e.g. "rearming",
- add here something like this:

	else if (rearming && del_timer(&work->timer)
		return 1;

> +
> +	/*
> +	 * The queueing is in progress, or it is already queued. Try to
> +	 * steal it from ->worklist without clearing WORK_STRUCT_PENDING.
> +	 */
> +
> +	cwq = get_wq_data(work);
> +	if (!cwq)
> +		return ret;

Probably you meant: 
		return 1;

BTW, probably there is some special reason it's in the loop now,
so maybe you should add a comment, why the old way (at the beginning
of a cancel_ function) is not enough.

I think adding the first check:

   if (!list_empty(&work->entry)) {

without the lock is usable here.

> +
> +	spin_lock_irq(&cwq->lock);
> +	if (!list_empty(&work->entry)) {
> +		/*
> +		 * This work is queued, but perhaps we locked the wrong cwq.
> +		 * In that case we must see the new value after rmb(), see
> +		 * insert_work()->wmb().
> +		 */
> +		smp_rmb();
> +		if (cwq == get_wq_data(work)) {
> +			list_del_init(&work->entry);
> +			ret = 1;
> +		}
> +	}
> +	spin_unlock_irq(&cwq->lock);
> +
> +	return ret;
> +}
> +

...
> +void cancel_work_sync(struct work_struct *work)
> +{
> +	while (!try_to_grab_pending(work))

So this could be:
	while (!try_to_grab_pending(work, 0))

> +		;
> +	wait_on_work(work);
> +	work_clear_pending(work);
>  }
>  EXPORT_SYMBOL_GPL(cancel_work_sync);
>  
> +/**
> + * cancel_rearming_delayed_work - reliably kill off a delayed work.
> + * @dwork: the delayed work struct
> + *
> + * It is possible to use this function if dwork rearms itself via queue_work()
> + * or queue_delayed_work(). See also the comment for cancel_work_sync().
> + */
> +void cancel_rearming_delayed_work(struct delayed_work *dwork)
> +{
> +	while (!del_timer(&dwork->timer) &&
> +	       !try_to_grab_pending(&dwork->work))

...and this like here:

  if (!del_timer(&dwork->timer)
	while (!try_to_grab_pending(&dwork->work, 1))


> +		;
> +	wait_on_work(&dwork->work);
> +	work_clear_pending(&dwork->work);
> +}
> +EXPORT_SYMBOL(cancel_rearming_delayed_work);


I didn't have as much time as needed, so I'll try to look
at this yet.

Cheers,
Jarek P.

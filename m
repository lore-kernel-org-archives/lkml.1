Return-Path: <linux-kernel-owner+w=401wt.eu-S1761192AbXEKOl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761192AbXEKOl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 10:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757970AbXEKOlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 10:41:51 -0400
Received: from mail.screens.ru ([213.234.233.54]:58527 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906AbXEKOlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 10:41:50 -0400
Date: Fri, 11 May 2007 17:47:14 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
Message-ID: <20070511134714.GA191@tv-sign.ru>
References: <20070503204226.GA212@tv-sign.ru> <464475EB.3000408@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464475EB.3000408@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11, Tejun Heo wrote:
> 
> Oleg Nesterov wrote:
> > +	/*
> > +	 * Ensure that we get the right work->data if we see the
> > +	 * result of list_add() below, see try_to_grab_pending().
> > +	 */
> > +	smp_wmb();
> 
> I don't think we need this
> 
> > +	if (!list_empty(&work->entry)) {
> > +		/*
> > +		 * This work is queued, but perhaps we locked the wrong cwq.
> > +		 * In that case we must see the new value after rmb(), see
> > +		 * insert_work()->wmb().
> > +		 */
> > +		smp_rmb();
> > +		if (cwq == get_wq_data(work)) {
> > +			list_del_init(&work->entry);
> > +			ret = 1;
> > +		}
> 
> and this.  After grabbing cwq lock, compare it to get_wq_data() first,
> if they are the same, both are using the same lock so there's no
> reason for the barriers.  If they are different, it doesn't matter
> anyway.  We need to retry the locking.

I think this is not right. The problem is that work->data (its
WORK_STRUCT_WQ_DATA_MASK part, cwq) could be changed _without_ holding
the old cwq->lock.

Suppose that CPU_0 does queue_delayed_work(dwork). We start the timer,
work->data points to cwq_0. CPU_DEAD comes, the timer migrates to
CPU_1, but work->data was not changed yet.

>   retry:
> 	cwq = get_sw_data(work);
> 	if (!cwq)
> 		return ret;
> 
> 	spin_lock_irq(&cwq->lock);
> 	if (unlikely(cwq != get_wq_data(work))) {
> 		/* oops wrong cwq */
> 		spin_unlock_irq(&cwq->lock);
> 		goto retry;	/* or just return 0; */
> 	}

dwork->timer fires, delayed_work_timer_fn() changes work->data to cwq_1
and queues this work on cwq_1.

> 	if (!list_empty(&work->entry)) {
> 		list_del_init(&work->entry);

Oops! we are holding cwq_0->lock, but modify cwq_1->worklist.

Actually, we have the same problem with a plain queue_work() if _cpu_down()
comes at "right" time.

However, I agree, this smp_wmb() in insert_work() should die. We can
introduce "smp_mb__before_spinlock()" (no-op on x86 at least) to kill it.

> > + * It is possible to use this function if the work re-queues itself. It can
> > + * cancel the work even if it migrates to another workqueue, however in that
> > + * case it only garantees that work->func() has completed on the last queued
> > + * workqueue.
> 
> We first prevent requeueing from happening; then, wait for each cwq to
> finish the work, so I think we're guaranteed that they're finished on
> all cpus.  Otherwise, the 'sync' part isn't too useful as it means all
> rearming tasks might be running on completion of cancel_work_sync().

Yes, sure, you are right. What I meant was:

	struct workqueue_struct *WQ1, *WQ1;

	void work_func(struct work_struct *self)
	{
		// migrate on another workqueue
		queue_work(WQ2, self);

		do_something();
	}

	queue_work(WQ1, work);

Now, cancel_work_sync() can't guarantee that this work has finished
its execution on WQ1.

Thanks for looking at this!

Oleg.


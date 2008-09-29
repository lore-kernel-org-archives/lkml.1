Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbYI2OVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbYI2OVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 10:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYI2OV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 10:21:27 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:57730 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbYI2OV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 10:21:26 -0400
Date: Mon, 29 Sep 2008 18:27:34 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Krishna Kumar <krkumar2@in.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REV2: PATCH 1/2]: workqueue: Implement the kernel API
Message-ID: <20080929142734.GB85@tv-sign.ru>
References: <20080929070302.7386.72726.sendpatchset@localhost.localdomain> <20080929070314.7386.28163.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929070314.7386.28163.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29, Krishna Kumar wrote:
>
> +static inline void __queue_delayed_work(int cpu, struct delayed_work *dwork,
> +                                     struct work_struct *work,
> +                                     struct workqueue_struct *wq,
> +                                     unsigned long delay)

A bit fat for inline, imho.

> +int queue_update_delayed_work(struct workqueue_struct *wq,
> +			      struct delayed_work *dwork, unsigned long delay)
> +{
> +	struct work_struct *work = &dwork->work;
> +
> +	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
> +		__queue_delayed_work(-1, dwork, work, wq, delay);
> +		return 1;

Please note that the above is the open-coded queue_delayed_work().
I'd suggest to just start with

	if (queue_delayed_work(...))
		return 1;

	... slow path ...

see also below.

> +	} else {
> +		struct timer_list *timer = &dwork->timer;
> +		unsigned long when = jiffies + delay;
> +		int ret;
> +
> +		/*
> +		 * Work is already scheduled. There is nothing to be done if
> +		 * the work is being modified to run at the same time.
> +		 */
> +		if (timer->expires == when)
> +			return 0;

I can't understand why do you want to optimize this very unlikely case.
Afaics, it can only improve the benchmark, when we are doing
queue_update_delayed_work() in a loop with the same timeout, no?

But more importantly, this is not right. We can not trust timer->expires.
For example, let's suppose we are doing

	queue_delayed_work(dwork, delay);
	cancel_delayed_work_sync(dwork);	// does not clear ->expires
	queue_work(&dwork->work);		// the same

Now, queue_update_delayed_work(new_delay) sees the pending dwork, and
it is possible that timer->expires == jiffies + new_delay.

Note also that INIT_DELAYED_WORK() does not initialize ->expires. Now,
again, if we do queue_work(&dwork->work) and then update(), we may have
problems.

Otherwise I think the patch is correct, but please see below.

> +
> +		do {
> +			/*
> +			 * If the timer has been added and it has not fired,
> +			 * update_timer_expiry will update it with the correct
> +			 * expiry. Otherwise timer has either not yet been
> +			 * added or it has already fired - we need to try again.
> +			 */
> +			if (likely(update_timer_expiry(timer, when)))
> +				return 0;
> +
> +			ret = try_to_grab_pending(work);
> +			if (ret < 0)
> +				wait_on_work(work);
> +		} while (ret < 0);

It is a bit silly we are checking "ret < 0" twice, I'd suggest to just
kill "int ret" and do

	for (;;) {
		...
		if (try_to_grab_pending(work) >= 0)
			break;
		wait_on_work(work);
	}

But this needs a comment. Why wait_on_work() is needed? "ret < 0" means that
the queueing is in progress, and it is not necessary to "flush" this work.

Note!!! queue_update_delayed_work() is _not_ equal to cancel() + queue()
anyway, the fastpath doesn't cancel the work if it is active (I mean,
it is ->current_work and running).

But yes, we do need wait_on_work(). Let's suppose that some rt thread
does queue_update_delayed_work() and preempts work->func() which tries
to re-queue itself, right after it sets WORK_STRUCT_PENDING. This is
livelockable.

But: this also means that 2 concurrent queue_update_delayed_work()s can
livelock in the same manner, perhaps this deserves a note.


I am not really sure it is worth to play with WORK_STRUCT_PENDING,
the simple

	int requeue_delayed_work(...)
	{
		int ret = 1;
	
		while (queue_delayed_work(...)) {
			ret = 0;
			if (update_timer_expiry(...))
				break;
			cancel_delayed_work_sync(...);
		}

		return ret;
	}

does not need any modifications in workqueue.c, but its slow-path is a bit
slower. Should we really care about the slow-path?

I won't insist, but could you please comment this?


Final note. What about the special "delay == 0" case? Actually, I don't
understand why queue_delayed_work() has this special case, and I have
no opinion on what update_() should do.

But, if we should care, then the code above can be fixed trivially:

	-	if (update_timer_expiry(...))
	+	if (delay && update_timer_expiry(...))

but with your patch we need the further complications.

Oleg.


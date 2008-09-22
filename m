Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897AbYIVOFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbYIVOFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 10:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbYIVOFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 10:05:04 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:58927 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbYIVOFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 10:05:03 -0400
Date: Mon, 22 Sep 2008 18:10:51 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Krishna Kumar <krkumar2@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2]: workqueue: Implement the kernel API
Message-ID: <20080922141051.GA252@tv-sign.ru>
References: <20080922040404.10477.24678.sendpatchset@localhost.localdomain> <20080922040417.10477.35834.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922040417.10477.35834.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22, Krishna Kumar wrote:
>
> Implement two API's for quickly updating delayed works:
> 	void schedule_update_delayed_work(struct delayed_work *dwork,
> 					  unsigned long delay);
> 	void queue_update_delayed_work(struct workqueue_struct *wq,
> 				       struct delayed_work *dwork,
> 				       unsigned long delay);
>
> These API's are useful to update an existing work entry more efficiently (but
> can be used to queue a new work entry too) when the operation is done very
> frequently. The rationale is to save time of first cancelling work/timer and
> adding work/timer when the same work is added many times in quick succession.

I agree, this looks like a useful helper. But, afaics, it is not as quick
as it could, please see below.

> + * Passing delay=0 will result in immediate queueing of the entry, whether
> + * queue'd earlier or otherwise.

The comment doesn't match the code ;)

> + * Always succeeds.

minor, but perhaps it would be nice to change this helper to return 0/1 to
indicate was the work pending or not. like __mod_timer().

> +void queue_update_delayed_work(struct workqueue_struct *wq,
> +			       struct delayed_work *dwork, unsigned long delay)
> +{
> +	struct work_struct *work = &dwork->work;
> +
> +	if (likely(test_and_set_bit(WORK_STRUCT_PENDING,
> +				    work_data_bits(work)))) {
> +		struct timer_list *timer = &dwork->timer;
> +
> +		/*
> +		 * Already present in workqueue. Check if the timer expiry is
> +		 * the same. Also, optimize in case requests are within one
> +		 * jiffy beyond the set expiry.
> +		 */
> +		if (time_in_range(jiffies + delay, timer->expires,
> +				  timer->expires + 1))
> +			return;

Not that I argue, but do we really need to optimize this very unlikely case?

> +		__cancel_work_timer_internal(work, timer);

__cancel_work_timer_internal() is slow, mostly due to
wait_on_work()->for_each_cpu_mask_nr(). And please note we don't really
need wait_on_work() once del_timer() || try_to_grab_pending() succeeds.

Can't we take another approach? First, let's add the new helper:

	int __update_timer(struct timer_list *timer, unsigned long expires)
	{
		struct tvec_base *base;
		unsigned long flags;
		int ret = 0;

		base = lock_timer_base(timer, &flags);
		if (timer_pending(timer)) {
			detach_timer(timer, 0);
			timer->expires = expires;
			internal_add_timer(base, timer);
			ret = 1;
		}
		spin_unlock_irqrestore(&base->lock, flags);

		return ret;
	}

Now, something like

	int update_delayed_work(...)
	{
		ret = 0;
		for (;;) {
			if (queue_delayed_work(...))
				break;

			ret = 1;
			if (__update_timer(...))
				break;
			cancel_work_sync(...);
		}

		return ret;
	}

This way the fast path is really fast, and the patch becomes simpler.

What do you think? We can optimize the code (the usage of cancel_work_sync)
further, but perhaps this is enough.

Oleg.


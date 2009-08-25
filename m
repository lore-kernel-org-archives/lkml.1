Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbZHYJmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbZHYJmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZHYJmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:42:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbZHYJmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:42:42 -0400
Date: Tue, 25 Aug 2009 11:39:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: Is adding requeue_delayed_work() a good idea
Message-ID: <20090825093906.GA3020@redhat.com>
References: <adazl9uw3w1.fsf@cisco.com> <20090821115547.GA6901@redhat.com> <adaab1sx29p.fsf@cisco.com> <20090824180112.GC16202@redhat.com> <ada4orwvrx7.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada4orwvrx7.fsf@cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now I noticed I forgot to CC Dmitry yesterday...

On 08/24, Roland Dreier wrote:
>
>  > > In my particular case it doesn't really matter.  In the queued case it
>  > > could leave it to run whenever it gets to the head of the workqueue.  In
>  > > the already running case then I think the timer should be reset.  The
>  > > main point is that if I do requeue_delayed_work() I want to make sure
>  > > the work runs all the way through from the beginning at some point in
>  > > the future.  The pattern I have in mind is something like:
>  > >
>  > > 	spin_lock_irqsave(&mydata_lock);
>  > > 	new_timeout = add_item_to_timeout_list();
>  > > 	requeue_delayed_work(wq, &process_timeout_list_work, new_timeout);
>  > > 	spin_unlock_irqsave(&mydata_lock);
>  > >
>  > > so if the process_timeout_list_work runs early or twice it doesn't
>  > > matter; I just want to make sure that the work runs from the beginning
>  > > and sees the new item I added to the list at some point after the
>  > > requeue.
>  >
>  > Hmm. But, asuming that process_timeout_list_work->func() takes mydata_lock
>  > too, you can just use queue_delayed_work() ?
>  >
>  > process_timeout_list_work can't miss new items, queue_delayed_work()
>  > can only fail if dwork is pending and its ->func has not started yet.
>
> Maybe I misunderstand the code or misunderstand you,

No, sorry. I misunderstood you (and sorry for delays btw).

I have read "I just want to make sure" above but forgot you also need
to shorten the timeout.

OK, in this case I think we have a simple solution,

	// like cancel_delayed_work, but uses del_timer().
	// this means, if it returns 0 the timer function may be
	// running and the queueing is in progress. The caller
	// can't rely on flush_workqueue/etc
	static inline int __cancel_delayed_work(struct delayed_work *work)
	{
		int ret;

		ret = del_timer(&work->timer);
		if (ret)
			work_clear_pending(&work->work);
		return ret;
	}

Now, you can do

	spin_lock_irqsave(&mydata_lock);
	new_timeout = add_item_to_timeout_list();

	__cancel_delayed_work(&process_timeout_list_work);
	queue_delayed_work(wq, &process_timeout_list_work, new_timeout);

	spin_unlock_irqsave(&mydata_lock);

If queue_delayed_work() fails, this means that WORK_STRUCT_PENDING is set,
dwork->work is already queued or the queueing is in progress. In both
cases it will run "soon" as if we just called queue_work(&dwork->work).

But this assumes nobody else does queue_delayed_work(dwork, HUGE_DELAY) in
parallel, otherwise we can lose the race and another caller can setup
HUGE_DELAY timeout.

In particular, if process_timeout_list_work->func() itself uses
queue_delay_work() to re-arm itself we can race. Bu t I think it is always
possible to do something to synchronize with work->func, for example
work->func() can re-arm itself _before_ it scans timeout_list (under the
same lock). This way, if re-queue code above fails because work->func()
wins, work->func() must see the new additions to timeout_list.

Can this work for you?

Oleg.


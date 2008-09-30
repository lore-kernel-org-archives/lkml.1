Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbYI3LJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbYI3LJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 07:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYI3LJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 07:09:41 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:33621 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752252AbYI3LJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 07:09:41 -0400
In-Reply-To: <20080929142734.GB85@tv-sign.ru>
References: <20080929070302.7386.72726.sendpatchset@localhost.localdomain> <20080929070314.7386.28163.sendpatchset@localhost.localdomain> <20080929142734.GB85@tv-sign.ru>
Subject: Re: [REV2: PATCH 1/2]: workqueue: Implement the kernel API
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.0.1 February 07, 2008
Message-ID: <OFA3316176.447F329E-ON652574D4.001B02A6-652574D4.003D36A8@in.ibm.com>
From: Krishna Kumar2 <krkumar2@in.ibm.com>
Date: Tue, 30 Sep 2008 16:38:36 +0530
X-MIMETrack: Serialize by Router on d23ml172/23/M/IBM(Release 7.0.2FP2HF300 | September
 14, 2007) at 09/30/2008 16:41:56
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> wrote on 09/29/2008 07:57:34 PM:

Thanks once again for your feedback.

> > +static inline void __queue_delayed_work(int cpu, struct delayed_work
*dwork,
> > +                                     struct work_struct *work,
> > +                                     struct workqueue_struct *wq,
> > +                                     unsigned long delay)
>
> A bit fat for inline, imho.

Yes. I will change that.

> > +int queue_update_delayed_work(struct workqueue_struct *wq,
> > +               struct delayed_work *dwork, unsigned long delay)
> > +{
> > +   struct work_struct *work = &dwork->work;
> > +
> > +   if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
> > +      __queue_delayed_work(-1, dwork, work, wq, delay);
> > +      return 1;
>
> Please note that the above is the open-coded queue_delayed_work().
> I'd suggest to just start with
>
>    if (queue_delayed_work(...))
>       return 1;
>
>    ... slow path ...

The reason I had coded this way was to avoid an unnecessary call -
unnecessary
since the update function should be usually called to update a work and
hence
the work is almost always pending. But I will make this change as it is
more
readable (maintainable) without losing much.

> > +   } else {
> > +      struct timer_list *timer = &dwork->timer;
> > +      unsigned long when = jiffies + delay;
> > +      int ret;
> > +
> > +      /*
> > +       * Work is already scheduled. There is nothing to be done if
> > +       * the work is being modified to run at the same time.
> > +       */
> > +      if (timer->expires == when)
> > +         return 0;
>
> I can't understand why do you want to optimize this very unlikely case.
> Afaics, it can only improve the benchmark, when we are doing
> queue_update_delayed_work() in a loop with the same timeout, no?
>
> But more importantly, this is not right. We can not trust timer->expires.
> For example, let's suppose we are doing
>
>    queue_delayed_work(dwork, delay);
>    cancel_delayed_work_sync(dwork);   // does not clear ->expires
>    queue_work(&dwork->work);      // the same
>
> Now, queue_update_delayed_work(new_delay) sees the pending dwork, and
> it is possible that timer->expires == jiffies + new_delay.
>
> Note also that INIT_DELAYED_WORK() does not initialize ->expires. Now,
> again, if we do queue_work(&dwork->work) and then update(), we may have
> problems.

Good point! I will remove this check.

> Otherwise I think the patch is correct, but please see below.
>
> > +
> > +      do {
> > +         /*
> > +          * If the timer has been added and it has not fired,
> > +          * update_timer_expiry will update it with the correct
> > +          * expiry. Otherwise timer has either not yet been
> > +          * added or it has already fired - we need to try again.
> > +          */
> > +         if (likely(update_timer_expiry(timer, when)))
> > +            return 0;
> > +
> > +         ret = try_to_grab_pending(work);
> > +         if (ret < 0)
> > +            wait_on_work(work);
> > +      } while (ret < 0);
>
> It is a bit silly we are checking "ret < 0" twice, I'd suggest to just
> kill "int ret" and do
>
>    for (;;) {
>       ...
>       if (try_to_grab_pending(work) >= 0)
>          break;
>       wait_on_work(work);
>    }

Thanks for pointing this out, now it definitely looks better.

> But this needs a comment. Why wait_on_work() is needed? "ret < 0" means
that
> the queueing is in progress, and it is not necessary to "flush" this
work.

I had tried to capture this information in the comment above, maybe it
needs
to be more clear.

> Note!!! queue_update_delayed_work() is _not_ equal to cancel() + queue()
> anyway, the fastpath doesn't cancel the work if it is active (I mean,
> it is ->current_work and running).

Correct. But the behavior is the same as the existing (say driver) code
which
calls cancel (which also doesn't cancel as the work is already running) and
then calls queue. In both cases, the work is running and we wait for the
work
to complete, and then do a fresh queue.

> But: this also means that 2 concurrent queue_update_delayed_work()s can
> livelock in the same manner, perhaps this deserves a note.

Assuming the work is already pending (which is why both calls are in the
middle
of this new API):

1. Timer is pending (work is not executing) - update_timer will break out
for
   both calls in any order.
2. Timer is not pending due to timer not yet been added - we loop until
either
   update_timer or try_to_grab_pending() breaks out, which happens when the
   timer is added or fired (if delay=0) and is almost instantaneous.
3. If timer is not pending due to timer handler already having got called -
   try_to_grab_pending returns 0 when run_workqueue clears the PENDING bit.
   This also breaks from the loop before work is finished executing (since
the
   bit is cleared before the work->func() is called).

> I am not really sure it is worth to play with WORK_STRUCT_PENDING,
> the simple
> (snip code) ...
> does not need any modifications in workqueue.c, but its slow-path is a
bit
> slower. Should we really care about the slow-path?

I am not insisting either way since both approaches achieve a big
improvement in
time saved. I am open to which way to go, please suggest. Here is the
updated
function. If you feel it is too complicated, I will go with the above
approach.

int queue_update_delayed_work(struct workqueue_struct *wq,
                              struct delayed_work *dwork, unsigned long delay)
{
      int ret = 1;

      if (!queue_delayed_work(wq, dwork, delay)) {
            struct work_struct *work = &dwork->work;
            struct timer_list *timer = &dwork->timer;

            ret = 0;
            for (;;) {
                  unsigned long when = jiffies + delay;

                  if (update_timer_expiry(timer, when))
                        break;

                  if (try_to_grab_pending(work) >= 0) {
                        __queue_delayed_work(-1, dwork, work, wq,
                                         delay);
                        break;
                  }
                  wait_on_work(work);
            }
      }
      return ret;
}

> Final note. What about the special "delay == 0" case? Actually, I don't
> understand why queue_delayed_work() has this special case, and I have
> no opinion on what update_() should do.
>
> But, if we should care, then the code above can be fixed trivially:
>
>    -   if (update_timer_expiry(...))
>    +   if (delay && update_timer_expiry(...))

Without that change, update_timer should still return success after
updating the
timer to run at 'jiffies' (internal_add_timer handles negative expiry). If
the
timer is not yet added or already fired, we loop till either timer is
updated
or grab_pending returns >= 0. I think both codes handles delay==0 case, or
did
I misunderstand your point?

Thanks,

- KK


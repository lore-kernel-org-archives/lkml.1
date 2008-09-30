Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbYI3NJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbYI3NJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 09:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbYI3NJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 09:09:41 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:46639 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbYI3NJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 09:09:41 -0400
Date: Tue, 30 Sep 2008 17:15:50 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Krishna Kumar2 <krkumar2@in.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REV2: PATCH 1/2]: workqueue: Implement the kernel API
Message-ID: <20080930131550.GA267@tv-sign.ru>
References: <20080929070302.7386.72726.sendpatchset@localhost.localdomain> <20080929070314.7386.28163.sendpatchset@localhost.localdomain> <20080929142734.GB85@tv-sign.ru> <OFA3316176.447F329E-ON652574D4.001B02A6-652574D4.003D36A8@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFA3316176.447F329E-ON652574D4.001B02A6-652574D4.003D36A8@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30, Krishna Kumar2 wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> wrote on 09/29/2008 07:57:34 PM:
>
> > > +   if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
> > > +      __queue_delayed_work(-1, dwork, work, wq, delay);
> > > +      return 1;
> >
> > Please note that the above is the open-coded queue_delayed_work().
> > I'd suggest to just start with
> >
> >    if (queue_delayed_work(...))
> >       return 1;
> >
> >    ... slow path ...
>
> The reason I had coded this way was to avoid an unnecessary call -
> unnecessary

Yes I see. But actually I meant "see below, I don't think we need
__queue_delayed_work()".

> since the update function should be usually called to update a work and
> hence
> the work is almost always pending.

Exactly! And in that case update_timer_expiry() will do its work.

Yes, the games with __queue_delayed_work() can save a couple of clear/set
bit, but this is the slow an unlikely path, that was my point.

And, if we are talking about the function call overhead. Please note
that __queue_delayed_work() adds the "unnecessary" call to the "normal"
queue_delayed_work(), and this path is more common.

But see below.

> > Note!!! queue_update_delayed_work() is _not_ equal to cancel() + queue()
> > anyway, the fastpath doesn't cancel the work if it is active (I mean,
> > it is ->current_work and running).
>
> Correct. But the behavior is the same as the existing (say driver) code
> which
> calls cancel (which also doesn't cancel as the work is already running)

Hmm. How so? cancel() always cancells the work.

OK, let's suppose we have

	cancel_delayed_work(dwork);
	queue_delayed_work(dwork, delay);

and now (the next patch you sent) we turn this code into

	queue_update_delayed_work(dwork, delay);

Now we have a subtle difference which _may_ be important for some users.

Suppose that this dwork was queued before, the timer has expired, and
now cwq->thread runs dwork->work->func(). Note that this dwork is not
pending (WORK_STRUCT_PENDING is cleared).

Before the change above, cancel_delayed_work() waits until work->func()
completes, then we re-queue the work.

After the change, the fast path just queues the same dwork again.
If the workqueue is not singlethreaded, it is possible that both
old and new "instances" will run on the different CPUs at the same
time.

(that is why I think these changes need the review from maintainer).

> > But: this also means that 2 concurrent queue_update_delayed_work()s can
> > livelock in the same manner, perhaps this deserves a note.
>
> Assuming the work is already pending (which is why both calls are in the
> middle
> of this new API):
>
> [...]

No.

dwork is not pending, L is a lower priority thread, H - real time.

L calls queue_update_delayed_work(), and sets WORK_STRUCT_PENDING
successfully(). It is going to do __queue_delayed_work(), but it
is preempted by H.

H does queue_update_delayed_work(), WORK_STRUCT_PENDING is already
set and the timer is not pending. Now it will do try_to_grab_pending()
in a loop "forever".

> > I am not really sure it is worth to play with WORK_STRUCT_PENDING,
> > the simple
> > (snip code) ...
> > does not need any modifications in workqueue.c, but its slow-path is a
> bit
> > slower. Should we really care about the slow-path?
>
> I am not insisting either way since both approaches achieve a big
> improvement in
> time saved. I am open to which way to go, please suggest. Here is the
> updated
> function. If you feel it is too complicated,

Yes. I must admit, I prefer the simple, non-intrusive code I suggested
much more.

Once again, the slow path is (at least, supposed to be) unlikely, and
the difference is not that large. (I mean the slow path is when both
queue() and update_timer() fail).

Should we complicate the code to add this minor optimization (and
btw pessimize the "normal" queue_delayed_work) ?

And, once we have the correct and simple code, we can optimize it
later.

> I will go with the above
> approach.

No. Please do what _you_ think right ;)

But, if possible, please explain why do this think this optimization
is worthwhile.

> > Final note. What about the special "delay == 0" case? Actually, I don't
> > understand why queue_delayed_work() has this special case, and I have
> > no opinion on what update_() should do.
> >
> > But, if we should care, then the code above can be fixed trivially:
> >
> >    -   if (update_timer_expiry(...))
> >    +   if (delay && update_timer_expiry(...))
>
> Without that change, update_timer should still return success after
> updating the
> timer to run at 'jiffies' (internal_add_timer handles negative expiry). If
> the
> timer is not yet added or already fired, we loop till either timer is
> updated
> or grab_pending returns >= 0. I think both codes handles delay==0 case, or
> did
> I misunderstand your point?

Yes. Please note that queue_delayed_work(work, 0) does not use the timer
at all. IOW, queue_delayed_work(wq, work, 0) == queue_work(wq, &dwork->work).
Perhaps (I don't know) update_queue_delayed_work() should do the same.

>From the next patch:

	-       cancel_delayed_work(&afs_vlocation_reap);
	-       schedule_delayed_work(&afs_vlocation_reap, 0);
	+       schedule_update_delayed_work(&afs_vlocation_reap, 0);

Again, I don't claim this is wrong, but please note that delay == 0.

Oleg.


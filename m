Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbZHXRys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbZHXRys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 13:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbZHXRyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 13:54:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbZHXRyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 13:54:47 -0400
Date: Mon, 24 Aug 2009 19:51:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: cancel_delayed_work and its use of del_timer_sync
Message-ID: <20090824175101.GB16202@redhat.com>
References: <20090824065111.A51D8526EC9@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824065111.A51D8526EC9@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damn, forgot to update CC, re-sending...

Hi Dmitry,

(add Roland and Stefan)

On 08/23, Dmitry Torokhov wrote:
>
> I noticed that you went back and forth on using del_timer() vs.
> del_timer_sync() in cancel_delayed_work(), finally settling on using
> del_timer_sync().

Yes. del_timer() can't work when the user does something like

	cancel_delayed_work(dw);
	flush_workqueue();

	kfree(dw);

Perhaps we can add __cancel_delayed_work() which uses del_timer(), most
callers don't really need del_timer_sync. I dunno.

> I must say that the fact that cancel_delayed_work()
> might sleep

Just in case, it can spin, but not sleep

> (given that there exists cancel_delayed_work_sync) catches a
> few drivers writers by surprise. Moreover it makes delayed works
> unsuitable in cases when we do want to cancel (so we can reschedule)
> work in an interrupt context.

Yep. it is not useable from irq. But only because nobody removed
"#ifdef CONFIG_SMP" from set_running_timer(). I guess I should send a
patch finally.

> it is possible to have a reschedule_delayed_work() taht would do a
> "soft" cancel and [re]submit the work. In the use cases I am concerned
> about we don't really care if work is not reliably cancelled, we just
> need to be able to schedule it earlier if it has already been scheduled
> for execution in some point in the future.

Well. this depends on how "soft" should be that cancel.

Consider the auto-rearming delayed work, its work->func() calls
queue_delayed_work(self, BIG_DELAY). The caller of requeue_work(SMALL_DELAY)
preempts cwq->thread right after it sets _PENDING.

Now, what should requeue_work() do ? Even if the requeue_work() and
work->func() run on different CPUs, in this case requeue_ must spin.

So. It is easy to create requeue_work() which never sleeps/spins, but
it can return the error in case it hits the queueing in progress.

Is it OK?

And another question, should it cancel (without sleep/spin) this dwork
if the timer has expired, the work is pending, but its ->func() has not
started yet?

Oleg.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbYGTGwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbYGTGwz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 02:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYGTGwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 02:52:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYGTGwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 02:52:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Mark McLoughlin <markmc@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] posix-timers: Do not modify an already queued timer signal
In-Reply-To: Oleg Nesterov's message of  Saturday, 19 July 2008 20:37:34 +0400 <20080719163734.GA389@tv-sign.ru>
References: <1216219846-663-1-git-send-email-markmc@redhat.com>
	<20080716162131.GA1785@tv-sign.ru>
	<1216292911.28332.12.camel@muff>
	<20080717135556.GA770@tv-sign.ru>
	<1216377558.12300.13.camel@muff>
	<20080719163734.GA389@tv-sign.ru>
X-Windows: putting new limits on productivity.
Message-Id: <20080720065240.B3D3715421D@magilla.localdomain>
Date: Sat, 19 Jul 2008 23:52:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the solution we want is to make sure that a timer whose
expiration signal is still pending never gets a second notification.

POSIX says, "The effect of disarming or resetting a timer with pending
expiration notifications is unspecified."  This gives us lots of
latitude.  I think the best behavior is the one that comports with the
general specification, "Only a single signal shall be queued to the
process for a given timer at any point in time."

The it_requeue_pending/si_sys_private logic is indeed intended to
address this case.  It predates my involvement of the code, and I
agree it has always looked oddly hairy.  Its plan is to make sure that
dequeue_signal's call to do_schedule_next_timer does not re-arm the
timer when an intervening timer_settime call has already done so.  As
Mark found, this is buggy because it's not really safe for the timer
to go off (call posix_timer_event again) before the dequeue.

In the signals code, si_sys_private is used purely as a flag that
dequeue_signal needs to bother with dropping the siglock to call
do_schedule_next_timer.  Its use as a serialization counter between
timer_settime and do_schedule_next_timer is entirely local to the
posix-timers code.

What userland should observe is that when the new timer expiration
time arrives while the previously-fired timer signal is still pending,
there is no new signal, and the timer accrues an overrun.

An obvious idea is simply not to re-arm in timer_settime when the
timer already has a pending notification.  When the signal gets
dequeued, do_schedule_next_timer will arm it then.  However, the way
we dispatch to different clocks' timer_set functions makes it awkward
to validate and store a new setting and fetch the old value without
actually arming the timer.  Also, the logic for one-shot timers has
more wrinkles.

So I think the thing to do is arm the timer in timer_settime even when
it's already pending (as we do now), but have posix_timer_event detect
a firing when already queued and just bump the overrun count.

We can do away with it_requeue_pending, and make si_sys_private purely
a simple 0/1 flag for whether to call do_schedule_next_timer.  To
optimize the extra checks, we use different bookkeeping fields in
struct k_itimer.

Have a flag that means "might be queued".  do_schedule_next_timer
replaces:

	if (timr && timr->it_requeue_pending == info->si_sys_private) {
		...
	}

with:

	if (timr && timr->fired) {
		timr->fired = 0;
		...
	}

That avoids races with timer_settime, which does (after timer_set
call, timer still locked):

	if (timr->fired) {
		spin_lock(&current->sighand->siglock);
		if (list_empty(&timr->sigq->list))
			timr->fired = 0;
		spin_unlock(&current->sighand->siglock);
	}

In posix_timer_event (timer is locked), check:

	if (timr->fired) {
		spin_lock(&current->sighand->siglock);
		if (list_empty(&timr->sigq->list))
			timr->fired = 0;
		spin_unlock(&current->sighand->siglock);
		if (timr->fired) {
			timr->it_overrun++;
			return 0;
		}
	}
	timr->fired = 1;

The siglock'd double-check is in case of a one-shot firing that didn't
ever call do_schedule_next_timer to reset the flag.

This bookkeeping plan may need more thought.  I think the idea is
sound: "firing", meaning notification and reload, only occurs when
both the expiration time has passed and the previous expiration
notification signal has been dequeued.  When the expiration time
passes but the other criterion is unmet, there's an overrun and no new
notification or reload.


Thanks,
Roland

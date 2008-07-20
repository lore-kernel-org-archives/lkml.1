Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbYGTLFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbYGTLFc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 07:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756349AbYGTLFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 07:05:23 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51948 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021AbYGTLFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 07:05:22 -0400
Date: Sun, 20 Jul 2008 15:08:56 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Mark McLoughlin <markmc@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] posix-timers: Do not modify an already queued timer signal
Message-ID: <20080720110856.GC143@tv-sign.ru>
References: <1216219846-663-1-git-send-email-markmc@redhat.com> <20080716162131.GA1785@tv-sign.ru> <1216292911.28332.12.camel@muff> <20080717135556.GA770@tv-sign.ru> <1216377558.12300.13.camel@muff> <20080719163734.GA389@tv-sign.ru> <20080720065240.B3D3715421D@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080720065240.B3D3715421D@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19, Roland McGrath wrote:
>
> I think the solution we want is to make sure that a timer whose
> expiration signal is still pending never gets a second notification.
>
> POSIX says, "The effect of disarming or resetting a timer with pending
> expiration notifications is unspecified."  This gives us lots of
> latitude.  I think the best behavior is the one that comports with the
> general specification, "Only a single signal shall be queued to the
> process for a given timer at any point in time."
>
> The it_requeue_pending/si_sys_private logic is indeed intended to
> address this case.  It predates my involvement of the code, and I
> agree it has always looked oddly hairy.  Its plan is to make sure that
> dequeue_signal's call to do_schedule_next_timer does not re-arm the
> timer when an intervening timer_settime call has already done so.  As
> Mark found, this is buggy because it's not really safe for the timer
> to go off (call posix_timer_event again) before the dequeue.
>
> In the signals code, si_sys_private is used purely as a flag that
> dequeue_signal needs to bother with dropping the siglock to call
> do_schedule_next_timer.  Its use as a serialization counter between
> timer_settime and do_schedule_next_timer is entirely local to the
> posix-timers code.

Yes, thanks, I see. But does it have any meaning for the user-space?

Let me repeat. Can't we make a simple fix for now for this nasty and
ancient bug, before we do the more clever changes,

	--- kernel/posix-timers.c
	+++ kernel/posix-timers.c
	@@ -298,12 +298,10 @@ void do_schedule_next_timer(struct sigin
	 
	 int posix_timer_event(struct k_itimer *timr,int si_private)
	 {
	-	memset(&timr->sigq->info, 0, sizeof(siginfo_t));
		timr->sigq->info.si_sys_private = si_private;
		/* Send signal to the process that owns this timer.*/
	 
		timr->sigq->info.si_signo = timr->it_sigev_signo;
	-	timr->sigq->info.si_errno = 0;
		timr->sigq->info.si_code = SI_TIMER;
		timr->sigq->info.si_tid = timr->it_id;
		timr->sigq->info.si_value = timr->it_sigev_value;
	@@ -435,6 +433,7 @@ static struct k_itimer * alloc_posix_tim
			kmem_cache_free(posix_timers_cache, tmr);
			tmr = NULL;
		}
	+	memset(&timr->sigq->info, 0, sizeof(siginfo_t));
		return tmr;
	 }
	 

?

Suppose ->sigq is queued. In that case "si_sys_private = si_private"
can race with dequeue_signal/do_schedule_next_timer, but everything
looks OK because the timer is locked.

If dequeue_signal() sees the old value of si_sys_private, it won't
call do_schedule_next_timer(). If it sees the new value, do_schedule_next_timer()
will wait for ->it_lock.

Yes, in both cases we can queue ->sigq again instead of incrementing
info.si_overrun. But this is not worse than we have now, and afaics
this is also possible with timr->fired, please see below.

> What userland should observe is that when the new timer expiration
> time arrives while the previously-fired timer signal is still pending,
> there is no new signal, and the timer accrues an overrun.
>
> An obvious idea is simply not to re-arm in timer_settime when the
> timer already has a pending notification.  When the signal gets
> dequeued, do_schedule_next_timer will arm it then.  However, the way
> we dispatch to different clocks' timer_set functions makes it awkward
> to validate and store a new setting and fetch the old value without
> actually arming the timer.  Also, the logic for one-shot timers has
> more wrinkles.
>
> So I think the thing to do is arm the timer in timer_settime even when
> it's already pending (as we do now), but have posix_timer_event detect
> a firing when already queued and just bump the overrun count.
>
> We can do away with it_requeue_pending, and make si_sys_private purely
> a simple 0/1 flag for whether to call do_schedule_next_timer.  To
> optimize the extra checks, we use different bookkeeping fields in
> struct k_itimer.
>
> Have a flag that means "might be queued".  do_schedule_next_timer
> replaces:
>
> 	if (timr && timr->it_requeue_pending == info->si_sys_private) {
> 		...
> 	}
>
> with:
>
> 	if (timr && timr->fired) {
> 		timr->fired = 0;
> 		...
> 	}
>
> That avoids races with timer_settime, which does (after timer_set
> call, timer still locked):
>
> 	if (timr->fired) {
> 		spin_lock(&current->sighand->siglock);
> 		if (list_empty(&timr->sigq->list))
> 			timr->fired = 0;
> 		spin_unlock(&current->sighand->siglock);
> 	}
>
> In posix_timer_event (timer is locked), check:
>
> 	if (timr->fired) {
> 		spin_lock(&current->sighand->siglock);
> 		if (list_empty(&timr->sigq->list))
> 			timr->fired = 0;
> 		spin_unlock(&current->sighand->siglock);

(we can't use current->sighand->siglock, this is irq context, we should
 use timr->it_process->group_leader...)

Suppose that the signal was already dequeued but sigq->info wasn't copied
to the user-space. The thread which does dequeue_signal() unlocked siglock
and waits for ->it_lock.

posix_timer_event() sees list_empty(), proceeds and calls send_sigqueue().
Now we requeue this ->sigq instead of incrementing si_overrun.

The thread which does dequeue_signal() continues and re-schedules the
timer while ->sigq is queued. Then it copies sigq->info to the user space.

The same problem as with the simple patch above. Not very bad though,
afaics. The user space just recieves 2 signals instead of one with
the right value of si_overrun.



While we are here, off-topics question. posix_timer_event() does

	if (timr->it_sigev_notify & SIGEV_THREAD_ID) {
		struct task_struct *leader;
		int ret = send_sigqueue(timr->sigq, timr->it_process, 0);

		if (likely(ret >= 0))
			return ret;

		timr->it_sigev_notify = SIGEV_SIGNAL;
		leader = timr->it_process->group_leader;
		put_task_struct(timr->it_process);
		timr->it_process = leader;
	}

	return send_sigqueue(timr->sigq, timr->it_process, 1);

Is it really useful to convert the SIGEV_THREAD_ID timer to the group-wide
timer when the thread dies?

This uglifies de_thread(), but more importantly this doesn't work reliably.
Suppose that timr->it_process dies with the pending ->sigq. In that case
the timer stops anyway.

Oleg.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbYGSQeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbYGSQeS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 12:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbYGSQeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 12:34:06 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:50075 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443AbYGSQeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 12:34:04 -0400
Date: Sat, 19 Jul 2008 20:37:34 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Mark McLoughlin <markmc@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] posix-timers: Do not modify an already queued timer signal
Message-ID: <20080719163734.GA389@tv-sign.ru>
References: <1216219846-663-1-git-send-email-markmc@redhat.com> <20080716162131.GA1785@tv-sign.ru> <1216292911.28332.12.camel@muff> <20080717135556.GA770@tv-sign.ru> <1216377558.12300.13.camel@muff>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216377558.12300.13.camel@muff>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18, Mark McLoughlin wrote:
>
> On Thu, 2008-07-17 at 17:55 +0400, Oleg Nesterov wrote:
>
> > I forgot (if ever knew ;) this code completely, but can't we make a simpler
> > fix? posix_timer_event() can check list_empty() lockless,
> >
> >         posix_timer_event()
> >         {
> >                 if (!list_emtpy(sigq->list))
> >                         return 0;
> >
> >                 ... fill and send ->sigq...
> >         }
>
> Well, one issue with this is that we need to set the si_private supplied
> to posix_timer_event() on the queued siginfo. See updated version of the
> original patch below.
>
> So, for that reason, we can't currently do it lockless.
>
> Now, I've spent a while looking at the it_requeue_pending code and I
> can't fully satisfy myself that we need it to be a modification counter
> that we match up via si_sys_private. Do you know why this is needed? It
> seems to me that it could be seriously simplified.

No, I don't understand what does si_sys_private mean. In fact I don't even
understand what should we do with info.si_overrun in this corner case.

We have the active timer, the app does sys_timer_settime() which changes the
timer. This looks like creating the new timer which "inherits" ->it_id and
->it_sigev_value. But the queued siginfo is connected to the "old" timer...
OK, I just don't understand this all.

> Subject: [PATCH] posix-timers: Do not modify an already queued timer signal
>
> When a timer fires, posix_timer_event() zeroes out its
> pre-allocated siginfo structure, initialises it and then
> queues up the signal with send_sigqueue().
>
> However, we may have previously queued up this signal, in
> which case we only want to increment si_overrun and
> re-initialising the siginfo structure is incorrect.
>
> Also, since we are modifying an already queued signal
> without the protection of the sighand spinlock, we may also
> race with e.g. collect_signal() causing it to fail to find
> a signal on the pending list because it happens to look at
> the siginfo struct after it was zeroed and before it was
> re-initialised.
>
> The race was observed with a modified kvm-userspace when
> running a guest under heavy network load. When it occurs,
> KVM never sees another SIGALRM signal because although
> the signal is queued up the appropriate bit is never set
> in the pending mask. Manually sending the process a SIGALRM
> kicks it out of this state.

Please update the changelog to explain how it is possible to hit the
already queued siginfo.

> -int posix_timer_event(struct k_itimer *timr,int si_private)
> +int posix_timer_event(struct k_itimer *timr, int si_private)
>  {
> -	memset(&timr->sigq->info, 0, sizeof(siginfo_t));
> -	timr->sigq->info.si_sys_private = si_private;
> -	/* Send signal to the process that owns this timer.*/
> +	siginfo_t info;
>
> -	timr->sigq->info.si_signo = timr->it_sigev_signo;
> -	timr->sigq->info.si_errno = 0;
> -	timr->sigq->info.si_code = SI_TIMER;
> -	timr->sigq->info.si_tid = timr->it_id;
> -	timr->sigq->info.si_value = timr->it_sigev_value;
> +	memset(&info, 0, sizeof(siginfo_t));
> +
> +	info.si_sys_private = si_private;
> +	info.si_signo = timr->it_sigev_signo;
> +	info.si_errno = 0;
> +	info.si_code = SI_TIMER;
> +	info.si_tid = timr->it_id;
> +	info.si_value = timr->it_sigev_value;
>
>  	if (timr->it_sigev_notify & SIGEV_THREAD_ID) {
>  		struct task_struct *leader;
> -		int ret = send_sigqueue(timr->sigq, timr->it_process, 0);
> +		int ret = send_sigqueue(timr->sigq, &info, timr->it_process, 0);

I think this is a bit overkill. Note that (unless I missed something)
posix_timer_event() populates timr->sigq->info with the same numbers
every time, so afaics we can do

	--- kernel/posix-timers.c
	+++ kernel/posix-timers.c
	@@ -298,19 +298,14 @@ void do_schedule_next_timer(struct sigin
	 
	 int posix_timer_event(struct k_itimer *timr,int si_private)
	 {
	-	memset(&timr->sigq->info, 0, sizeof(siginfo_t));
	-	timr->sigq->info.si_sys_private = si_private;
	-	/* Send signal to the process that owns this timer.*/
	-
		timr->sigq->info.si_signo = timr->it_sigev_signo;
	-	timr->sigq->info.si_errno = 0;
		timr->sigq->info.si_code = SI_TIMER;
		timr->sigq->info.si_tid = timr->it_id;
		timr->sigq->info.si_value = timr->it_sigev_value;
	 
		if (timr->it_sigev_notify & SIGEV_THREAD_ID) {
			struct task_struct *leader;
	-		int ret = send_sigqueue(timr->sigq, timr->it_process, 0);
	+		int ret = send_sigqueue(timr->sigq, si_private, timr->it_process, 0);
	 
			if (likely(ret >= 0))
				return ret;
	@@ -321,7 +316,7 @@ int posix_timer_event(struct k_itimer *t
			timr->it_process = leader;
		}
	 
	-	return send_sigqueue(timr->sigq, timr->it_process, 1);
	+	return send_sigqueue(timr->sigq, si_private, timr->it_process, 1);
	 }
	 EXPORT_SYMBOL_GPL(posix_timer_event);
	 
	@@ -435,6 +430,7 @@ static struct k_itimer * alloc_posix_tim
			kmem_cache_free(posix_timers_cache, tmr);
			tmr = NULL;
		}
	+	memset(&timr->sigq->info, 0, sizeof(siginfo_t));
		return tmr;
	 }
	 
	--- kernel/signal.c
	+++ kernel/signal.c
	@@ -1283,7 +1283,7 @@ void sigqueue_free(struct sigqueue *q)
			__sigqueue_free(q);
	 }
	 
	-int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
	+int send_sigqueue(struct sigqueue *q, int si_private, struct task_struct *t, int group)
	 {
		int sig = q->info.si_signo;
		struct sigpending *pending;
	@@ -1300,6 +1300,8 @@ int send_sigqueue(struct sigqueue *q, st
		if (!prepare_signal(sig, t))
			goto out;
	 
	+	q->info.si_sys_private = info->si_sys_private;
	+
		ret = 0;
		if (unlikely(!list_empty(&q->list))) {
			/*

But can't we do a simpler change?

	--- kernel/posix-timers.c
	+++ kernel/posix-timers.c
	@@ -298,7 +298,6 @@ void do_schedule_next_timer(struct sigin
	 
	 int posix_timer_event(struct k_itimer *timr,int si_private)
	 {
	-	memset(&timr->sigq->info, 0, sizeof(siginfo_t));
		timr->sigq->info.si_sys_private = si_private;
		/* Send signal to the process that owns this timer.*/
	 
	@@ -435,6 +434,7 @@ static struct k_itimer * alloc_posix_tim
			kmem_cache_free(posix_timers_cache, tmr);
			tmr = NULL;
		}
	+	memset(&timr->sigq->info, 0, sizeof(siginfo_t));
		return tmr;
	 }

Yes, if sigq->info is queued, it can be dequeued right after
".si_sys_private = si_private" and before we send the signal. As I said,
I don't know what si_sys_private means for the user-level, is this bad?

Note that the we can't race with do_schedule_next_timer(), the timer is
locked.

Thoughts?

Oleg.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbYGQLJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbYGQLJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 07:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbYGQLIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 07:08:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124AbYGQLIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 07:08:53 -0400
Subject: Re: [PATCH] posix-timers: Do not modify an already queued timer
	signal
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080716162131.GA1785@tv-sign.ru>
References: <1216219846-663-1-git-send-email-markmc@redhat.com>
	 <20080716162131.GA1785@tv-sign.ru>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 12:08:31 +0100
Message-Id: <1216292911.28332.12.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Wed, 2008-07-16 at 20:21 +0400, Oleg Nesterov wrote:
> On 07/16, Mark McLoughlin wrote:
> >
> > When a timer fires, posix_timer_event() zeroes out its
> > pre-allocated siginfo structure, initialises it and then
> > queues up the signal with send_sigqueue().
> >
> > However, we may have previously queued up this signal, in
> > which case we only want to increment si_overrun and
> > re-initialising the siginfo structure is incorrect.
> 
> Quoting Roland McGrath:
> 	>
> 	> I'm not clear on how the already-queued case could ever happen.  Do we
> 	> really need that check at all?  It shouldn't be possible for the timer to
> 	> be firing when it's already queued, because it won't have been reloaded.
> 	> It only reloads via do_schedule_next_timer after it's dequeued, or because
> 	> a 1 return value said it never was queued.

The app can reload the timer itself before the signal has been dequeued
via signalfd ...

> > Also, since we are modifying an already queued signal
> > without the protection of the sighand spinlock, we may also
> > race with e.g. collect_signal() causing it to fail to find
> > a signal on the pending list because it happens to look at
> > the siginfo struct after it was zeroed and before it was
> > re-initialised.
> >
> > The race was observed with a modified kvm-userspace when
> > running a guest under heavy network load. When it occurs,
> > KVM never sees another SIGALRM signal because although
> > the signal is queued up the appropriate bit is never set
> > in the pending mask.
> 
> Hmm. Yes, if collect_signal() races with posix_timer_event()->memset(),
> we dequeue SIGALRM but leave the siginfo on list. I can't see how
> this is possible though...
> 
> Could you verify that we don't have another bug? Say, add
> WARN_ON(!list_empty()) to posix_timer_event().

Yes, this case definitely occurs.

Now that I know what's going on, I've finally managed to extract a
standalone test case. Try this:

  http://markmc.fedorapeople.org/test-posix-timer-race.c

On my quad-core machine it triggers the race fairly readily.

> If we need this fix, perhaps it is better to modify posix_timer_event()
> to check !list_empty()?

Yeah, I had considered that, but it's a tad more invasive. See below.

I mainly don't like this patch because we may lock the sighand from one
thread's task_struct and then unlock it via the group leader's sighand.
That probably is safe, but is pretty nasty.

Cheers,
Mark.

Subject: [PATCH] posix-timers: Do not modify an already queued timer signal

When a timer fires, posix_timer_event() zeroes out its
pre-allocated siginfo structure, initialises it and then
queues up the signal with send_sigqueue().

However, we may have previously queued up this signal, in
which case we only want to increment si_overrun and
re-initialising the siginfo structure is incorrect.

Also, since we are modifying an already queued signal
without the protection of the sighand spinlock, we may also
race with e.g. collect_signal() causing it to fail to find
a signal on the pending list because it happens to look at
the siginfo struct after it was zeroed and before it was
re-initialised.

The race was observed with a modified kvm-userspace when
running a guest under heavy network load. When it occurs,
KVM never sees another SIGALRM signal because although
the signal is queued up the appropriate bit is never set
in the pending mask. Manually sending the process a SIGALRM
kicks it out of this state.

The fix is simple - only modify the pre-allocated sigqueue
once we're sure that it hasn't already been queued.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
---
 kernel/posix-timers.c |   23 ++++++++++++++++++++---
 kernel/signal.c       |   27 ++++-----------------------
 2 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index dbd8398..65ce122 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -298,6 +298,19 @@ void do_schedule_next_timer(struct siginfo *info)
 
 int posix_timer_event(struct k_itimer *timr,int si_private)
 {
+	unsigned long flags;
+	int ret = -1;
+
+	if (!likely(lock_task_sighand(timr->it_process, &flags)))
+		goto ret;
+
+	ret = 0;
+	if (unlikely(!list_empty(&timr->sigq->list))) {
+		/* Already queued; just increment the overrun count */
+		timr->sigq->info.si_overrun++;
+		goto out;
+	}
+
 	memset(&timr->sigq->info, 0, sizeof(siginfo_t));
 	timr->sigq->info.si_sys_private = si_private;
 	/* Send signal to the process that owns this timer.*/
@@ -310,10 +323,10 @@ int posix_timer_event(struct k_itimer *timr,int si_private)
 
 	if (timr->it_sigev_notify & SIGEV_THREAD_ID) {
 		struct task_struct *leader;
-		int ret = send_sigqueue(timr->sigq, timr->it_process, 0);
+		ret = send_sigqueue(timr->sigq, timr->it_process, 0);
 
 		if (likely(ret >= 0))
-			return ret;
+			goto out;
 
 		timr->it_sigev_notify = SIGEV_SIGNAL;
 		leader = timr->it_process->group_leader;
@@ -321,7 +334,11 @@ int posix_timer_event(struct k_itimer *timr,int si_private)
 		timr->it_process = leader;
 	}
 
-	return send_sigqueue(timr->sigq, timr->it_process, 1);
+	ret = send_sigqueue(timr->sigq, timr->it_process, 1);
+out:
+	unlock_task_sighand(timr->it_process, &flags);
+ret:
+	return ret;
 }
 EXPORT_SYMBOL_GPL(posix_timer_event);
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 6c0958e..62eb972 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1296,39 +1296,20 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 {
 	int sig = q->info.si_signo;
 	struct sigpending *pending;
-	unsigned long flags;
-	int ret;
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
+	BUG_ON(!list_empty(&q->list));
 
-	ret = -1;
-	if (!likely(lock_task_sighand(t, &flags)))
-		goto ret;
-
-	ret = 1; /* the signal is ignored */
 	if (!prepare_signal(sig, t))
-		goto out;
-
-	ret = 0;
-	if (unlikely(!list_empty(&q->list))) {
-		/*
-		 * If an SI_TIMER entry is already queue just increment
-		 * the overrun count.
-		 */
-		BUG_ON(q->info.si_code != SI_TIMER);
-		q->info.si_overrun++;
-		goto out;
-	}
+		return 1; /* the signal is ignored */
 
 	signalfd_notify(t, sig);
 	pending = group ? &t->signal->shared_pending : &t->pending;
 	list_add_tail(&q->list, &pending->list);
 	sigaddset(&pending->signal, sig);
 	complete_signal(sig, t, group);
-out:
-	unlock_task_sighand(t, &flags);
-ret:
-	return ret;
+
+	return 0;
 }
 
 /*
-- 
1.5.4.1




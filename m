Return-Path: <linux-kernel-owner+w=401wt.eu-S1755118AbYGRKjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbYGRKjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 06:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbYGRKjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 06:39:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704AbYGRKje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 06:39:34 -0400
Subject: Re: [PATCH] posix-timers: Do not modify an already queued timer
	signal
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080717135556.GA770@tv-sign.ru>
References: <1216219846-663-1-git-send-email-markmc@redhat.com>
	 <20080716162131.GA1785@tv-sign.ru> <1216292911.28332.12.camel@muff>
	 <20080717135556.GA770@tv-sign.ru>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 11:39:18 +0100
Message-Id: <1216377558.12300.13.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 17:55 +0400, Oleg Nesterov wrote:

> I forgot (if ever knew ;) this code completely, but can't we make a simpler
> fix? posix_timer_event() can check list_empty() lockless,
> 
>         posix_timer_event()
>         {
>                 if (!list_emtpy(sigq->list))
>                         return 0;
> 
>                 ... fill and send ->sigq...
>         }

Well, one issue with this is that we need to set the si_private supplied
to posix_timer_event() on the queued siginfo. See updated version of the
original patch below. 

So, for that reason, we can't currently do it lockless.

Now, I've spent a while looking at the it_requeue_pending code and I
can't fully satisfy myself that we need it to be a modification counter
that we match up via si_sys_private. Do you know why this is needed? It
seems to me that it could be seriously simplified.

The explanation in the pre-2.6 code I could find was:

  * An interesting problem can occure if, while a signal, and thus a call
  * back is pending, the timer is rearmed, i.e. stopped and restarted.
  * We then need to sort out the call back and do the right thing.  What
  * we do is to put a counter in the info block and match it with the
  * timers copy on the call back. 

> When the signal will be dequeued, schedule_next_timer() should afaics
> set ->it_overrun_last which is copied to ->si_overrun then. Or we can
> increment timr->it_overrun before return if I misread hrtimer_forward().

Yep; that sounds reasonable to me - i.e. do all the overrun accounting
in a callback just before the signal is to be delivered.

However, since the race condition I identified basically breaks the
timer permanently for the app (i.e. it will never fire again unless the
signal is delivered to the process for another reason) I do think the
fix below makes sense in advance of simplifying all this long standing
code and correcting overrun accounting.

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
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h |    2 +-
 kernel/posix-timers.c |   23 ++++++++++++-----------
 kernel/signal.c       |    6 ++++--
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c5d3f84..f260585 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1786,7 +1786,7 @@ extern void zap_other_threads(struct task_struct *p);
 extern int kill_proc(pid_t, int, int);
 extern struct sigqueue *sigqueue_alloc(void);
 extern void sigqueue_free(struct sigqueue *);
-extern int send_sigqueue(struct sigqueue *,  struct task_struct *, int group);
+extern int send_sigqueue(struct sigqueue *, siginfo_t *, struct task_struct *, int group);
 extern int do_sigaction(int, struct k_sigaction *, struct k_sigaction *);
 extern int do_sigaltstack(const stack_t __user *, stack_t __user *, unsigned long);
 
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index dbd8398..d3a8561 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -296,21 +296,22 @@ void do_schedule_next_timer(struct siginfo *info)
 		unlock_timer(timr, flags);
 }
 
-int posix_timer_event(struct k_itimer *timr,int si_private)
+int posix_timer_event(struct k_itimer *timr, int si_private)
 {
-	memset(&timr->sigq->info, 0, sizeof(siginfo_t));
-	timr->sigq->info.si_sys_private = si_private;
-	/* Send signal to the process that owns this timer.*/
+	siginfo_t info;
 
-	timr->sigq->info.si_signo = timr->it_sigev_signo;
-	timr->sigq->info.si_errno = 0;
-	timr->sigq->info.si_code = SI_TIMER;
-	timr->sigq->info.si_tid = timr->it_id;
-	timr->sigq->info.si_value = timr->it_sigev_value;
+	memset(&info, 0, sizeof(siginfo_t));
+
+	info.si_sys_private = si_private;
+	info.si_signo = timr->it_sigev_signo;
+	info.si_errno = 0;
+	info.si_code = SI_TIMER;
+	info.si_tid = timr->it_id;
+	info.si_value = timr->it_sigev_value;
 
 	if (timr->it_sigev_notify & SIGEV_THREAD_ID) {
 		struct task_struct *leader;
-		int ret = send_sigqueue(timr->sigq, timr->it_process, 0);
+		int ret = send_sigqueue(timr->sigq, &info, timr->it_process, 0);
 
 		if (likely(ret >= 0))
 			return ret;
@@ -321,7 +322,7 @@ int posix_timer_event(struct k_itimer *timr,int si_private)
 		timr->it_process = leader;
 	}
 
-	return send_sigqueue(timr->sigq, timr->it_process, 1);
+	return send_sigqueue(timr->sigq, &info, timr->it_process, 1);
 }
 EXPORT_SYMBOL_GPL(posix_timer_event);
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 6c0958e..95a34ff 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1292,9 +1292,9 @@ void sigqueue_free(struct sigqueue *q)
 		__sigqueue_free(q);
 }
 
-int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
+int send_sigqueue(struct sigqueue *q, siginfo_t *info, struct task_struct *t, int group)
 {
-	int sig = q->info.si_signo;
+	int sig = info->si_signo;
 	struct sigpending *pending;
 	unsigned long flags;
 	int ret;
@@ -1317,12 +1317,13 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 		 */
 		BUG_ON(q->info.si_code != SI_TIMER);
 		q->info.si_overrun++;
+		q->info.si_sys_private = info->si_sys_private;
 		goto out;
 	}
 
 	signalfd_notify(t, sig);
 	pending = group ? &t->signal->shared_pending : &t->pending;
+	copy_siginfo(&q->info, info);
 	list_add_tail(&q->list, &pending->list);
 	sigaddset(&pending->signal, sig);
 	complete_signal(sig, t, group);
-- 
1.5.5.1




Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYGWQtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYGWQtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 12:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbYGWQss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 12:48:48 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:49530 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbYGWQsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 12:48:47 -0400
Date: Wed, 23 Jul 2008 20:52:05 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mark McLoughlin <markmc@redhat.com>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: [PATCH 1/2] posix-timers: fix posix_timer_event() vs dequeue_signal() race
Message-ID: <20080723165205.GA4292@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bug was reported and analysed by Mark McLoughlin <markmc@redhat.com>,
the patch is based on his and Roland's suggestions.

posix_timer_event() always rewrites the pre-allocated siginfo before sending
the signal. Most of the written info is the same all the time, but memset(0)
is very wrong. If ->sigq is queued we can race with collect_signal() which
can fail to find this siginfo looking at .si_signo, or copy_siginfo() can
copy the wrong .si_code/si_tid/etc.

In short, sys_timer_settime() can in fact stop the active timer, or the user
can receive the siginfo with the wrong .si_xxx values.

Move "memset(->info, 0)" from posix_timer_event() to alloc_posix_timer(),
change send_sigqueue() to set .si_overrun = 0 when ->sigq is not queued.
It would be nice to move the whole sigq->info initialization from send to
create path, but this is not easy to do without uglifying timer_create()
further.

As Roland rightly pointed out, we need more cleanups/fixes here, see the
"FIXME" comment in the patch. Hopefully this patch makes sense anyway, and
it can mask the most bad implications.

Reported-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 posix-timers.c |   17 +++++++++++++----
 signal.c       |    1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

--- 26-rc2/kernel/posix-timers.c~1_PTE_QUEUED	2008-07-20 14:47:53.000000000 +0400
+++ 26-rc2/kernel/posix-timers.c	2008-07-23 15:04:18.000000000 +0400
@@ -296,14 +296,22 @@ void do_schedule_next_timer(struct sigin
 		unlock_timer(timr, flags);
 }
 
-int posix_timer_event(struct k_itimer *timr,int si_private)
+int posix_timer_event(struct k_itimer *timr, int si_private)
 {
-	memset(&timr->sigq->info, 0, sizeof(siginfo_t));
+	/*
+	 * FIXME: if ->sigq is queued we can race with
+	 * dequeue_signal()->do_schedule_next_timer().
+	 *
+	 * If dequeue_signal() sees the "right" value of
+	 * si_sys_private it calls do_schedule_next_timer().
+	 * We re-queue ->sigq and drop ->it_lock().
+	 * do_schedule_next_timer() locks the timer
+	 * and re-schedules it while ->sigq is pending.
+	 * Not really bad, but not that we want.
+	 */
 	timr->sigq->info.si_sys_private = si_private;
-	/* Send signal to the process that owns this timer.*/
 
 	timr->sigq->info.si_signo = timr->it_sigev_signo;
-	timr->sigq->info.si_errno = 0;
 	timr->sigq->info.si_code = SI_TIMER;
 	timr->sigq->info.si_tid = timr->it_id;
 	timr->sigq->info.si_value = timr->it_sigev_value;
@@ -435,6 +443,7 @@ static struct k_itimer * alloc_posix_tim
 		kmem_cache_free(posix_timers_cache, tmr);
 		tmr = NULL;
 	}
+	memset(&tmr->sigq->info, 0, sizeof(siginfo_t));
 	return tmr;
 }
 
--- 26-rc2/kernel/signal.c~1_PTE_QUEUED	2008-07-06 19:29:27.000000000 +0400
+++ 26-rc2/kernel/signal.c	2008-07-23 13:55:11.000000000 +0400
@@ -1310,6 +1310,7 @@ int send_sigqueue(struct sigqueue *q, st
 		q->info.si_overrun++;
 		goto out;
 	}
+	q->info.si_overrun = 0;
 
 	signalfd_notify(t, sig);
 	pending = group ? &t->signal->shared_pending : &t->pending;


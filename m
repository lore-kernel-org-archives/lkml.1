Return-Path: <linux-kernel-owner+w=401wt.eu-S1758969AbYHRStS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969AbYHRStS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758771AbYHRSsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:48:45 -0400
Received: from ns2.suse.de ([195.135.220.15]:34694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758760AbYHRSso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:48:44 -0400
Date: Mon, 18 Aug 2008 11:41:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Oleg Nesterov <oleg@tv-sign.ru>,
       Mark McLoughlin <markmc@redhat.com>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 10/60] posix-timers: fix posix_timer_event() vs
	dequeue_signal() race
Message-ID: <20080818184146.GK29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="posix-timers-fix-posix_timer_event-vs-dequeue_signal-race.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Oleg Nesterov <oleg@tv-sign.ru>

commit ba661292a2bc6ddd305a212b0526e5dc22195fe7 upstream

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
Cc: Mark McLoughlin <markmc@redhat.com>
Cc: Oliver Pinter <oliver.pntr@gmail.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/posix-timers.c |   17 +++++++++++++----
 kernel/signal.c       |    1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
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
 
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1319,6 +1319,7 @@ int send_sigqueue(struct sigqueue *q, st
 		q->info.si_overrun++;
 		goto out;
 	}
+	q->info.si_overrun = 0;
 
 	signalfd_notify(t, sig);
 	pending = group ? &t->signal->shared_pending : &t->pending;

-- 

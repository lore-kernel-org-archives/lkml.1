Return-Path: <linux-kernel-owner+w=401wt.eu-S1759148AbYG0URa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148AbYG0URa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 16:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757773AbYG0URW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 16:17:22 -0400
Received: from www.tglx.de ([62.245.132.106]:48239 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757740AbYG0URV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 16:17:21 -0400
Date: Sun, 27 Jul 2008 22:15:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [GIT pull] timer fixes for .27
Message-ID: <alpine.LFD.1.10.0807272213420.574@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull timer fixes from

  ssh://master.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git timers/urgent

Thanks,

	tglx

----
Oleg Nesterov (2):
      posix-timers: fix posix_timer_event() vs dequeue_signal() race
      posix-timers: do_schedule_next_timer: fix the setting of ->si_overrun

 posix-timers.c |   19 ++++++++++++++-----
 signal.c       |    1 +
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index dbd8398..0ffaeb0 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -289,21 +289,29 @@ void do_schedule_next_timer(struct siginfo *info)
 		else
 			schedule_next_timer(timr);
 
-		info->si_overrun = timr->it_overrun_last;
+		info->si_overrun += timr->it_overrun_last;
 	}
 
 	if (timr)
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
@@ -435,6 +443,7 @@ static struct k_itimer * alloc_posix_timer(void)
 		kmem_cache_free(posix_timers_cache, tmr);
 		tmr = NULL;
 	}
+	memset(&tmr->sigq->info, 0, sizeof(siginfo_t));
 	return tmr;
 }
 
diff --git a/kernel/signal.c b/kernel/signal.c
index 72bb4f5..13fab98 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1280,6 +1280,7 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 		q->info.si_overrun++;
 		goto out;
 	}
+	q->info.si_overrun = 0;
 
 	signalfd_notify(t, sig);
 	pending = group ? &t->signal->shared_pending : &t->pending;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbYHKWXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbYHKWXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYHKWXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:23:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58611 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbYHKWXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:23:32 -0400
Date: Tue, 12 Aug 2008 00:23:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] timer fixes for -rc3
Message-ID: <20080811222316.GA22610@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Thanks,

	Ingo

------------------>
Oleg Nesterov (2):
      posix-timers: do_schedule_next_timer: fix the setting of ->si_overrun
      posix-timers: fix posix_timer_event() vs dequeue_signal() race


 kernel/posix-timers.c |   19 ++++++++++++++-----
 kernel/signal.c       |    1 +
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
index 6c0958e..c5bf0c0 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1319,6 +1319,7 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 		q->info.si_overrun++;
 		goto out;
 	}
+	q->info.si_overrun = 0;
 
 	signalfd_notify(t, sig);
 	pending = group ? &t->signal->shared_pending : &t->pending;

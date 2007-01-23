Return-Path: <linux-kernel-owner+w=401wt.eu-S965541AbXAWWDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965541AbXAWWDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965531AbXAWWC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:02:57 -0500
Received: from www.osadl.org ([213.239.205.134]:35967 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965526AbXAWWB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:01:26 -0500
Message-Id: <20070123211209.737922000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 43/46] hrtimers: prevent possible itimer DoS
Content-Disposition: inline;
	filename=high-res-timers-core-do-itimer-rearming-in-process-context.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Fix potential setitimer DoS with high-res timers by pushing itimer rearm
processing to process context.

[Fixes from: Ingo Molnar <mingo@elte.hu>]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/itimer.c |   14 +++++--------
 kernel/signal.c |   58 +++++++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 47 insertions(+), 25 deletions(-)

Index: linux-2.6.20-rc4-mm1-bo/kernel/itimer.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/itimer.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/itimer.c
@@ -135,11 +135,6 @@ enum hrtimer_restart it_real_fn(struct h
 
 	send_group_sig_info(SIGALRM, SEND_SIG_PRIV, sig->tsk);
 
-	if (sig->it_real_incr.tv64 != 0) {
-		hrtimer_forward(timer, hrtimer_cb_get_time(timer),
-				sig->it_real_incr);
-		return HRTIMER_RESTART;
-	}
 	return HRTIMER_NORESTART;
 }
 
@@ -231,11 +226,14 @@ again:
 			spin_unlock_irq(&tsk->sighand->siglock);
 			goto again;
 		}
-		tsk->signal->it_real_incr =
-			timeval_to_ktime(value->it_interval);
 		expires = timeval_to_ktime(value->it_value);
-		if (expires.tv64 != 0)
+		if (expires.tv64 != 0) {
+			tsk->signal->it_real_incr =
+				timeval_to_ktime(value->it_interval);
 			hrtimer_start(timer, expires, HRTIMER_MODE_REL);
+		} else
+			tsk->signal->it_real_incr.tv64 = 0;
+
 		spin_unlock_irq(&tsk->sighand->siglock);
 		break;
 	case ITIMER_VIRTUAL:
Index: linux-2.6.20-rc4-mm1-bo/kernel/signal.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/signal.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/signal.c
@@ -456,26 +456,50 @@ static int __dequeue_signal(struct sigpe
 int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 {
 	int signr = __dequeue_signal(&tsk->pending, mask, info);
-	if (!signr)
+	if (!signr) {
 		signr = __dequeue_signal(&tsk->signal->shared_pending,
 					 mask, info);
+		/*
+		 * itimer signal ?
+		 *
+		 * itimers are process shared and we restart periodic
+		 * itimers in the signal delivery path to prevent DoS
+		 * attacks in the high resolution timer case. This is
+		 * compliant with the old way of self restarting
+		 * itimers, as the SIGALRM is a legacy signal and only
+		 * queued once. Changing the restart behaviour to
+		 * restart the timer in the signal dequeue path is
+		 * reducing the timer noise on heavy loaded !highres
+		 * systems too.
+		 */
+		if (unlikely(signr == SIGALRM)) {
+			struct hrtimer *tmr = &tsk->signal->real_timer;
+
+			if (!hrtimer_is_queued(tmr) &&
+			    tsk->signal->it_real_incr.tv64 != 0) {
+				hrtimer_forward(tmr, tmr->base->get_time(),
+						tsk->signal->it_real_incr);
+				hrtimer_restart(tmr);
+			}
+		}
+	}
 	recalc_sigpending_tsk(tsk);
- 	if (signr && unlikely(sig_kernel_stop(signr))) {
- 		/*
- 		 * Set a marker that we have dequeued a stop signal.  Our
- 		 * caller might release the siglock and then the pending
- 		 * stop signal it is about to process is no longer in the
- 		 * pending bitmasks, but must still be cleared by a SIGCONT
- 		 * (and overruled by a SIGKILL).  So those cases clear this
- 		 * shared flag after we've set it.  Note that this flag may
- 		 * remain set after the signal we return is ignored or
- 		 * handled.  That doesn't matter because its only purpose
- 		 * is to alert stop-signal processing code when another
- 		 * processor has come along and cleared the flag.
- 		 */
- 		if (!(tsk->signal->flags & SIGNAL_GROUP_EXIT))
- 			tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
- 	}
+	if (signr && unlikely(sig_kernel_stop(signr))) {
+		/*
+		 * Set a marker that we have dequeued a stop signal.  Our
+		 * caller might release the siglock and then the pending
+		 * stop signal it is about to process is no longer in the
+		 * pending bitmasks, but must still be cleared by a SIGCONT
+		 * (and overruled by a SIGKILL).  So those cases clear this
+		 * shared flag after we've set it.  Note that this flag may
+		 * remain set after the signal we return is ignored or
+		 * handled.  That doesn't matter because its only purpose
+		 * is to alert stop-signal processing code when another
+		 * processor has come along and cleared the flag.
+		 */
+		if (!(tsk->signal->flags & SIGNAL_GROUP_EXIT))
+			tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
+	}
 	if ( signr &&
 	     ((info->si_code & __SI_MASK) == __SI_TIMER) &&
 	     info->si_sys_private){

--


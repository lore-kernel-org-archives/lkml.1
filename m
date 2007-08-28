Return-Path: <linux-kernel-owner+w=401wt.eu-S1759023AbXH1JNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759023AbXH1JNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 05:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbXH1JNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 05:13:05 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60727 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758308AbXH1JND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 05:13:03 -0400
Date: Tue, 28 Aug 2007 13:13:18 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SIGNAL_STOP_DEQUEUED
Message-ID: <20070828091318.GA307@tv-sign.ru>
References: <20070813082615.GA90@tv-sign.ru> <20070828043528.A86814D04CC@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828043528.A86814D04CC@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27, Roland McGrath wrote:
>
> > But SIGNAL_STOP_DEQUEUED code should be OK, afaics. We only need it to
> > make sure do_signal_stop() can't miss SIGNAL_STOP_CONTINUED/GROUP_EXIT.
> > 
> > Can't we remove SIGNAL_STOP_DEQUEUED, btw?
> 
> No, we can't.
> 
> > 	dequeue_signal:
> > 
> > 		if (sig_kernel_stop(sig))
> > 			->flags &= ~SIGNAL_STOP_CONTINUED;
> > 
> > 	do_signal_stop:
> > 
> > 		if (flags & (SIGNAL_STOP_CONTINUED | SIGNAL_GROUP_EXIT))
> > 			return 0;
> > 
> > Possible?
> 
> SIGNAL_STOP_CONTINUED exists to keep track of whether CLD_CONTINUED has
> been reported to the parent's wait* call using the WCONTINUED flag.
> wait_task_continued (kernel/exit.c) clears it.  It should only be cleared
> by the signals code when a job control stop actually happens before a wait*
> call clears it.  In dequeue_signal, you do not yet know whether it will
> actually lead to a stop.

Yes. do_wait(WCONTINUED) can miss SIGNAL_STOP_CONTINUED task if the task
dequeues another sig_kernel_stop() signal. I thought this is harmless, but
it turns out I misunderstood the needed semantics.

Thanks for your explanation.

This is easy to fix, but we have to split SIGNAL_STOP_CONTINUED into 2 flags,
one for do_wait(), another to indicate that do_signal_stop() should abort.

> SIGNAL_STOP_DEQUEUED exists to fix a particular race, when we dequeue a
> signal and then unlock the siglock before acting on it.  This happens when
> we call is_current_pgrp_orphaned(), and there might be other cases that
> arise.  In the window while we do not hold the lock, a kill or suchlike can
> take the long to post a SIGCONT.  The generation of a SIGCONT must clear
> all pending stop signals from all the queues.  But, the thread that
> dequeued the signal and then released the lock effectively has that signal
> still "pending" in its stack state, where it cannot be cleared.  So, when
> clearing stop signals from queues, we also clear the SIGNAL_STOP_DEQUEUED
> flag.  After retaking the siglock and considering the previously dequeued
> stop signal, we check that SIGNAL_STOP_DEQUEUED is still set.

Yes. But please look at the pseudo code above. do_signal_stop() checks
"flags & (SIGNAL_STOP_CONTINUED | SIGNAL_GROUP_EXIT)" to prevent exactly
this race. Actually we need this check even if we don't temporary drop
->siglock, we shouldn't rely on the fact that SIGKILL < SIGSTOP and so
it will be dequeued first.

But, as you pointed out, this breaks do_wait(WCONTINUED), and the fix
needs another flag, so please forget.



However, is it all correct currently ? Consider 2 threads, T1 and T2,
SIGTTIN is SIG_DFL, SIGTTOU has a handler.

	T1 does get_signal_to_deliver(), dequeus SIGTTIN, unlocks ->siglock.

	SIGCONT comes in, nothing to do yet, just clear SIGNAL_STOP_DEQUEUED.

	SIGTTOU is sent, T2 dequeues it and sets SIGNAL_STOP_DEQUEUED again.
	It has a handler, we shouldn't stop, but

	T1 continues, takes ->siglock, and calls do_signal_stop().

What do you think about something like the patch below? It moves the setting of
SIGNAL_STOP_DEQUEUED from dequeue_signal() to get_signal_to_deliver(), and the
flag is set only if the sig_kernel_stop() signal doesn't have a handler.

Oleg.

--- kernel/signal.c	2007-08-13 22:20:50.000000000 +0400
+++ -	2007-08-28 12:58:53.765332579 +0400
@@ -409,22 +409,7 @@ int dequeue_signal(struct task_struct *t
 	}
 	if (likely(tsk == current))
 		recalc_sigpending();
-	if (signr && unlikely(sig_kernel_stop(signr))) {
-		/*
-		 * Set a marker that we have dequeued a stop signal.  Our
-		 * caller might release the siglock and then the pending
-		 * stop signal it is about to process is no longer in the
-		 * pending bitmasks, but must still be cleared by a SIGCONT
-		 * (and overruled by a SIGKILL).  So those cases clear this
-		 * shared flag after we've set it.  Note that this flag may
-		 * remain set after the signal we return is ignored or
-		 * handled.  That doesn't matter because its only purpose
-		 * is to alert stop-signal processing code when another
-		 * processor has come along and cleared the flag.
-		 */
-		if (!(tsk->signal->flags & SIGNAL_GROUP_EXIT))
-			tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
-	}
+
 	if ( signr &&
 	     ((info->si_code & __SI_MASK) == __SI_TIMER) &&
 	     info->si_sys_private){
@@ -1853,6 +1838,10 @@ relock:
 			continue;
 
 		if (sig_kernel_stop(signr)) {
+			if (current->signal->flags & SIGNAL_GROUP_EXIT)
+				continue;
+			current->signal->flags |= SIGNAL_STOP_DEQUEUED;
+
 			/*
 			 * The default action is to stop all threads in
 			 * the thread group.  The job control signals


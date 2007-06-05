Return-Path: <linux-kernel-owner+w=401wt.eu-S1762214AbXFEBZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762214AbXFEBZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 21:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbXFEBZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 21:25:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:46912 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbXFEBZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 21:25:22 -0400
Subject: [PATCH/RFC] signal races/bugs, losing TIF_SIGPENDING and other woes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 11:25:11 +1000
Message-Id: <1181006711.31677.97.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The story starts with...

We've been seeing some occasional reports of -ERESTARTSYS and friends
being returned to userland from syscalls like accept(). After some
digging, we beleive that the signal code is inherently racy vs. the
way one task (or interrupt) can cause another task TIG_SIGPENDING
to be cleared.

(And while looking at the code, found more potential issues with
signalfd, see later for that one)

The circumstances are a bit hard to trigger (and thus we haven't yet
made a proper repro-case, the field problem happens every now and then),
but basically, the idea is something around the lines of:

 - thread A does accept() or select() or some other syscall that can
   restart upon reception of a signal. It also has signal S1 unblocked
   and signal S2 blocked.

 - Something sends S1 to the process (shared signal), thread A is the
   selected victim from the signal code and gets TIF_SIGPENDING set.

 - thread A decides to return -ERESTARTSYS. On the way to userland, to
   make the race more likely, we also end up rescheduling, thus we
   call schedule() before we actually call do_signal().

 - thread B has TIF_SIGPENDING set (for some other signal) and ends up
   handling and dequeuing both that other signal and S1, thus there is
   no more shared signal pending

 - something calls recalc_sigpending_tsk() on thread A (for example,
   something try to sends it S2 which is blocked). There is no longer
   an active signal and thus TIF_SIGPENDING is cleared on thread A

 - thread A gets back out of schedule(), there is no more TIF_SIGPENDING,
   thus it goes back to userland returning -ERESTARTSYS and never restarts
   the syscall

There might be variations on the above scenario. We beleive that the
base problem is that the only one who should ever be able to clear
TIF_SIGPENDING is the task who has it set, nobody else, since it might
have been "seen" by that task long enough to make decisions such as
returning -ERESTARTSYS, at which point it must not be cleared until
do_signal() is called.

In fact, it makes a lot of sense to only ever clear that flag on yourself
anyway.

The patch below does that by making recalc_sigpending() be the only one to
clear it, not recalc_sigpending_tsk(). I also added a WARN_ON in case
we ever call recalc_sigpending() without the siglock since that would mean
a race causing a potential loss of TIF_SIGPENDING.

Note that the code in dequeue_signal() is a bit uglier than I would have
liked. I would have much preferred making dequeue_signal() not take a task
argument anymore and just always operate on "current" but that's being 
defeated by signalfd, which seems to be only one to potentially dequeue
signals off another task. So I leave it alone for now.

However, I find that very dodgy since dequeue_signal() calls
__dequeue_signal() which does things vs. a notifier which I don't quite
know what it's for, but it's definitely not going to fly if dequeue_signal()
is called for somebody else than current... and potentially cause another
spurrious clearing of TIF_SIGPENDING.

Thus, I think that signalfd probably needs fixing to only ever allow
read() to be called from the task that created the fd in the first place
thus only allowing a thread to dequeue itself.

Any better idea ? Comments ?

(Patch built & booted on a pSeries box)

Cheers,
Ben.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Index: linux-work/kernel/signal.c
===================================================================
--- linux-work.orig/kernel/signal.c	2007-06-05 10:56:53.000000000 +1000
+++ linux-work/kernel/signal.c	2007-06-05 11:15:14.000000000 +1000
@@ -105,7 +105,6 @@ static int recalc_sigpending_tsk(struct 
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
 		return 1;
 	}
-	clear_tsk_thread_flag(t, TIF_SIGPENDING);
 	return 0;
 }
 
@@ -119,9 +118,22 @@ void recalc_sigpending_and_wake(struct t
 		signal_wake_up(t, 0);
 }
 
+/*
+ * Only when recalculating on yourself are you allowed to clear TIF_SIGPENDING
+ * never when recalculating somebody else. If you were to allow it, then
+ * a syscall could see signal_pending(), decide to return -ERESTARTSYS, and
+ * lose TIF_SIGPENDING before actually hitting do_signal(), thus effectively
+ * returning -ERESTARTSYS to userland and failing to restart the syscall.
+ */
 void recalc_sigpending(void)
 {
-	recalc_sigpending_tsk(current);
+	/* This must be called with the siglock or we might lose
+	 * TIF_SIGPENDING
+	 */
+	WARN_ON(!spin_is_locked(&current->sighand->siglock));
+
+	if (!recalc_sigpending_tsk(current))
+		clear_thread_flag(TIF_SIGPENDING);
 }
 
 /* Given the mask, find the first available signal that should be serviced. */
@@ -385,7 +397,18 @@ int dequeue_signal(struct task_struct *t
 			}
 		}
 	}
-	recalc_sigpending_tsk(tsk);
+	/* We need to call recalc_sigpending() when recalculating ourselves
+	 * so that TIF_SIGPENDING is cleated when appropriate. The only reason
+	 * we actually have to compare against current rather than
+	 * unconditionally doing recalc_sigpending() is the same that prevents
+	 * me from removing the task argument from dequeue_signal() and is
+	 * signalfd which can dequeue signals of another task (yuck)
+	 */
+	if (tsk == current)
+		recalc_sigpending();
+	else
+		recalc_sigpending_tsk(tsk);
+
 	if (signr && unlikely(sig_kernel_stop(signr))) {
 		/*
 		 * Set a marker that we have dequeued a stop signal.  Our



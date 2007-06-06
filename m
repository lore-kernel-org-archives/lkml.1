Return-Path: <linux-kernel-owner+w=401wt.eu-S1762304AbXFFK7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762304AbXFFK7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbXFFK7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:59:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbXFFK7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:59:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel internal
 errnos
In-Reply-To: Satoru Takeuchi's message of  Wednesday, 6 June 2007 14:47:54 +0900 <87hcplvdkl.wl%takeuchi_satoru@jp.fujitsu.com>
X-Zippy-Says: Yow!  Legally-imposed CULTURE-reduction is CABBAGE-BRAINED!
Message-Id: <20070606105900.DE5E94D0592@magilla.localdomain>
Date: Wed,  6 Jun 2007 03:59:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg and I were just discussing this issue in relation to other problems.
We established that it is never safe to clear TIF_SIGPENDING on another
thread.  But I hadn't really thought through that it's sometimes not safe
to clear your own TIF_SIGPENDING either.  That is, any time you are not
positive you cannot be in a syscall that will return a -ERESTART* code.
(I had the ptrace_stop case lurking in the back of my mind but hadn't
considered how it would really come up.)

I have a general recollection of thinking that dequeue_signal could only
be called on current and that it mattered somehow.  But aside from
avoiding recalc_sigpending, and kernel threads with notifier_mask set, I
can't see off hand what it is.  I won't testify that I think signalfd is
necessarily on safe ground, though.


Thanks,
Roland

---

[PATCH] Restrict clearing TIF_SIGPENDING

This patch should get a few birds.  It prevents sigaction calls from
clearing TIF_SIGPENDING in other threads, which could leak -ERESTART*.
It fixes ptrace_stop not to clear it, which done at the syscall exit
stop could leak -ERESTART*.  It probably removes the harm from
signalfd, at least assuming it never calls dequeue_signal on kernel
threads that might have used block_all_signals.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/signal.c |   40 ++++++++++++++++++++++++----------------
 1 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index acdfc05..dc5797c 100644  
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -105,7 +105,11 @@ static int recalc_sigpending_tsk(struct 
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
 		return 1;
 	}
-	clear_tsk_thread_flag(t, TIF_SIGPENDING);
+	/*
+	 * We must never clear the flag in another thread, or in current
+	 * when it's possible the current syscall is returning -ERESTART*.
+	 * So we don't clear it here, and only callers who know they should do.
+	 */
 	return 0;
 }
 
@@ -121,7 +125,9 @@ void recalc_sigpending_and_wake(struct t
 
 void recalc_sigpending(void)
 {
-	recalc_sigpending_tsk(current);
+	if (!recalc_sigpending_tsk(current))
+		clear_thread_flag(TIF_SIGPENDING);
+
 }
 
 /* Given the mask, find the first available signal that should be serviced. */
@@ -385,7 +391,8 @@ int dequeue_signal(struct task_struct *t
 			}
 		}
 	}
-	recalc_sigpending_tsk(tsk);
+	if (likely(tsk == current))
+		recalc_sigpending();
 	if (signr && unlikely(sig_kernel_stop(signr))) {
 		/*
 		 * Set a marker that we have dequeued a stop signal.  Our
@@ -1580,8 +1587,9 @@ static void ptrace_stop(int exit_code, i
 	/*
 	 * Queued signals ignored us while we were stopped for tracing.
 	 * So check for any that we should take before resuming user mode.
+	 * This sets TIF_SIGPENDING, but never clears it.
 	 */
-	recalc_sigpending();
+	recalc_sigpending_tsk(current);
 }
 
 void ptrace_notify(int exit_code)

Return-Path: <linux-kernel-owner+w=401wt.eu-S934531AbXFFPgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934531AbXFFPgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 11:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758717AbXFFPgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 11:36:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47008 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751098AbXFFPgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 11:36:31 -0400
Date: Wed, 6 Jun 2007 08:35:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel
 internal errnos
In-Reply-To: <20070606105900.DE5E94D0592@magilla.localdomain>
Message-ID: <alpine.LFD.0.98.0706060811470.4205@woody.linux-foundation.org>
References: <20070606105900.DE5E94D0592@magilla.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Jun 2007, Roland McGrath wrote:
> 
> [PATCH] Restrict clearing TIF_SIGPENDING
> 
> This patch should get a few birds.  It prevents sigaction calls from
> clearing TIF_SIGPENDING in other threads, which could leak -ERESTART*.
> It fixes ptrace_stop not to clear it, which done at the syscall exit
> stop could leak -ERESTART*.  It probably removes the harm from
> signalfd, at least assuming it never calls dequeue_signal on kernel
> threads that might have used block_all_signals.

Ok, this one is more complex than my suggested one-liner, but seems to fix 
another bug. And it's logic in dequeue_signal() is a bit prettier than 
Ben's (otherwise somewhat similar) patch.

HOWEVER: I'm still a bit worried about the fact that we have about ~180 
calls to "recalc_sigpending()" around the kernel, and I'm not AT ALL sure 
that they are all supposed to possibly clear the TIF_SIGPENDING flag. The 
fact that we had basically two independent bugs in this area really makes 
me more convinced that we probably should clear TIF_SIGPENDING in the only 
path that really matters, namely the one that _depends_ on it being right 
(the "do_signal()" path).

So I think that the *right* place to clear TIF_SIGPENDING is actually in 
"get_signal_to_deliver()", because that function is called _only_ by the 
actual per-architecture "I'm going to deliver a signal now".

(Oh, and we do need to handle it in the "notifier()" case too - ugly hack 
for DRM).

So how does *this* patch look? It:

 - totally removes the "clear_tsk_thread_flag()" from the signal pending 
   recalculations (ie now both "recalc_sigpending()" _and_ 
   "recalc_sigpending_tsk()" will ever only _set_ that bit)

 - in get_signal_to_deliver(), it adds a

	if (!recalc_sigpending_tsk(current))
		d_flag(TIF_SIGPENDING);

   at the end.

 - it removes the "recalc_sigpending_tsk()" from dequeue_signal(), since 
   that can never clear the signal any more.

So now we should do "recalc_sigpending()" only when signals may be *added* 
(where messing with the "blocked" mask obviously is a form of adding 
signals, and possibly the most common reason for having to recalculate the 
sigpending mask).

Comments? This patch is _entirely_ and utterly untested, so I'm only 
saying that this "feels" safer and more correct to me.

		Linus

---
 kernel/signal.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index acdfc05..82b3c1a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -105,7 +105,6 @@ static int recalc_sigpending_tsk(struct task_struct *t)
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
 		return 1;
 	}
-	clear_tsk_thread_flag(t, TIF_SIGPENDING);
 	return 0;
 }
 
@@ -385,7 +384,6 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 			}
 		}
 	}
-	recalc_sigpending_tsk(tsk);
 	if (signr && unlikely(sig_kernel_stop(signr))) {
 		/*
 		 * Set a marker that we have dequeued a stop signal.  Our
@@ -1859,6 +1857,8 @@ relock:
 		do_group_exit(signr);
 		/* NOTREACHED */
 	}
+	if (!recalc_sigpending_tsk(current))
+		clear_thread_flag(TIF_SIGPENDING);
 	spin_unlock_irq(&current->sighand->siglock);
 	return signr;
 }

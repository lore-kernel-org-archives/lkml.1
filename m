Return-Path: <linux-kernel-owner+w=401wt.eu-S933079AbYEUXCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079AbYEUXCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 19:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758372AbYEUXC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:02:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360AbYEUXC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:02:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signals: sigqueue_free: don't free sigqueue if it
 is queued
In-Reply-To: Linus Torvalds's message of  Wednesday, 21 May 2008 13:07:50 -0700 <alpine.LFD.1.10.0805211245131.3081@woody.linux-foundation.org>
References: <20080517151420.GA9496@tv-sign.ru>
	<20080521022046.1501F26FA1C@magilla.localdomain>
	<20080521115414.GA147@tv-sign.ru>
	<20080521184245.5BABF26FA24@magilla.localdomain>
	<alpine.LFD.1.10.0805211146350.3081@woody.linux-foundation.org>
	<20080521193348.64E8C26FA24@magilla.localdomain>
	<alpine.LFD.1.10.0805211245131.3081@woody.linux-foundation.org>
X-Shopping-List: (1) Scrumptious benedictions
   (2) Public reinforcements
   (3) Synonymous self-propelled circumlocutions
   (4) Elegant scorpions
   (5) Quixotic temptations
Message-Id: <20080521230135.BF65A26FA24@magilla.localdomain>
Date: Wed, 21 May 2008 16:01:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timer_delete/sigqueue_free behavior predates my involvement with the
code.  I think it is fine to leave pending signals queued.  (POSIX makes it
unspecified for deleted timers.  A robust application cannot even assume
that they will or won't be removed consistently on one running system.)

What I think everyone agrees is wrong in the abstract is the status quo,
where (effectively) signals stay queued but with zeroed siginfo_t values.
(This violates POSIX.)  If there is a signal, its siginfo_t must be intact.

A robust application has to drain any pending timer signals by unblocking
the signal or using sigwait.  This is true if signals might remain
properly queued as POSIX permits.  It's also true of existing Linux
kernels, where a bogus infoless signal remains pending.

There is also the caveat I mentioned before about RLIMIT_SIGPENDING.
An existing dumb application might do many iterations of timer_create,
timer_settime, (timer fires), timer_delete, all with the timer signal
blocked, and not expect that it can hit its rlimit and not be able to
create more timers until it drains those signals.  I don't mind breaking
any such application.  It's dumb.

As I read it, POSIX leaves it the same unspecified what is the
disposition of pending timer signals at the time of the implicit timer
deletion at exec.  But people sure find it surprising on exec.

So maybe this (wholly untested)?
The last hunk could go alone (just keep queued) before the rest (exec flush).


Thanks,
Roland


diff --git a/kernel/signal.c b/kernel/signal.c
index 72bb4f5..0000000 100644  
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -205,18 +205,25 @@ static void __sigqueue_free(struct sigqu
 	kmem_cache_free(sigqueue_cachep, q);
 }
 
-void flush_sigqueue(struct sigpending *queue)
+static void __flush_sigqueue(struct sigpending *queue, int timers)
 {
 	struct sigqueue *q;
 
 	sigemptyset(&queue->signal);
 	while (!list_empty(&queue->list)) {
 		q = list_entry(queue->list.next, struct sigqueue , list);
+		if (timers && q->info.si_code != SI_TIMER)
+			continue;
 		list_del_init(&q->list);
 		__sigqueue_free(q);
 	}
 }
 
+void flush_sigqueue(struct sigpending *queue)
+{
+	__flush_sigqueue(queue, 0);
+}
+
 /*
  * Flush all pending signals for a task.
  */
@@ -243,6 +250,7 @@ void ignore_signals(struct task_struct *
 
 /*
  * Flush all handlers for a task.
+ * Also flush all SI_TIMER signals from the queues.
  */
 
 void
@@ -257,6 +265,9 @@ flush_signal_handlers(struct task_struct
 		sigemptyset(&ka->sa.sa_mask);
 		ka++;
 	}
+
+	__flush_sigqueue(&t->pending, 1);
+	__flush_sigqueue(&t->signal->shared_pending, 1);
 }
 
 int unhandled_signal(struct task_struct *tsk, int sig)
@@ -1240,17 +1251,18 @@ void sigqueue_free(struct sigqueue *q)
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 	/*
-	 * If the signal is still pending remove it from the
-	 * pending queue. We must hold ->siglock while testing
+	 * If the signal is still pending, leave it to be dequeued.
+	 * We must hold ->siglock while testing
 	 * q->list to serialize with collect_signal().
 	 */
 	spin_lock_irqsave(lock, flags);
+	q->flags &= ~SIGQUEUE_PREALLOC;
 	if (!list_empty(&q->list))
-		list_del_init(&q->list);
+		q = NULL;
 	spin_unlock_irqrestore(lock, flags);
 
-	q->flags &= ~SIGQUEUE_PREALLOC;
-	__sigqueue_free(q);
+	if (q)
+		__sigqueue_free(q);
 }
 
 int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)

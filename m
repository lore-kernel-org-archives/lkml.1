Return-Path: <linux-kernel-owner+w=401wt.eu-S1759947AbYDVQeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbYDVQeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYDVQdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:33:41 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41848 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbYDVQdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:33:39 -0400
Date: Tue, 22 Apr 2008 19:38:20 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] posix timers: (BUG 10460) discard the pending signal when the timer is destroyed
Message-ID: <20080422153820.GA19900@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently sigqueue_free() removes sigqueue from list, but doesn't cancel the
pending signal. This is indeed strange, the task should either receive the
"full" signal along with siginfo_t, or it shouldn't see the signal at all.

Change sigqueue_free(q) to do sigdelset() if q is queued. There is a little
complication. Looking at "struct sigqueue*" we can't figure out where it is
pending, in ->pending or ->shared_pending. So this patch adds a new flag,
SIGQUEUE_SHARED_PENDING, which is set/cleared by send_sigqueue().

Alternatively, we can add a new parameter to sigqueue_free(), and the caller
can check SIGEV_THREAD_ID. But I think this is not as robust as a flag which
is "automatically" correct.

This patch should also fix the problem pointed out by Austin Clements, see

	http://bugzilla.kernel.org/show_bug.cgi?id=10460

Currently, when the task execs it could be killed by the fatal signal sent by
the posix timer, because exec flushes the signal handlers.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/include/linux/signal.h~1_PT_CLEAR_PENDING	2008-03-04 21:43:25.000000000 +0300
+++ 25/include/linux/signal.h	2008-03-04 21:43:25.000000000 +0300
@@ -20,6 +20,7 @@ struct sigqueue {
 
 /* flags values. */
 #define SIGQUEUE_PREALLOC	1
+#define SIGQUEUE_SHARED_PENDING	2	/* meaningful only if queued */
 
 struct sigpending {
 	struct list_head list;
--- 25/kernel/signal.c~1_PT_CLEAR_PENDING	2008-03-21 18:10:30.000000000 +0300
+++ 25/kernel/signal.c	2008-04-22 16:40:45.000000000 +0400
@@ -1233,6 +1233,28 @@ struct sigqueue *sigqueue_alloc(void)
 	return(q);
 }
 
+static void sigqueue_cancel(struct sigqueue *q)
+{
+	struct sigpending *pending;
+	int sig;
+
+	list_del_init(&q->list);
+
+	pending = (q->flags & SIGQUEUE_SHARED_PENDING)
+		? &current->signal->shared_pending
+		: &current->pending;
+
+	sig = q->info.si_signo;
+	if (sig >= SIGRTMIN) {
+		list_for_each_entry(q, &pending->list, list)
+			if (q->info.si_signo == sig)
+				return;
+	}
+
+	sigdelset(&pending->signal, sig);
+	recalc_sigpending();
+}
+
 void sigqueue_free(struct sigqueue *q)
 {
 	unsigned long flags;
@@ -1246,7 +1268,7 @@ void sigqueue_free(struct sigqueue *q)
 	 */
 	spin_lock_irqsave(lock, flags);
 	if (!list_empty(&q->list))
-		list_del_init(&q->list);
+		sigqueue_cancel(q);
 	spin_unlock_irqrestore(lock, flags);
 
 	q->flags &= ~SIGQUEUE_PREALLOC;
@@ -1282,7 +1304,13 @@ int send_sigqueue(struct sigqueue *q, st
 	}
 
 	signalfd_notify(t, sig);
-	pending = group ? &t->signal->shared_pending : &t->pending;
+	if (group) {
+		q->flags |=  SIGQUEUE_SHARED_PENDING;
+		pending = &t->signal->shared_pending;
+	} else {
+		q->flags &= ~SIGQUEUE_SHARED_PENDING;
+		pending = &t->pending;
+	}
 	list_add_tail(&q->list, &pending->list);
 	sigaddset(&pending->signal, sig);
 	complete_signal(sig, t, group);


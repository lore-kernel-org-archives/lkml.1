Return-Path: <linux-kernel-owner+w=401wt.eu-S1030621AbXEBFiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030621AbXEBFiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbXEBFep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:34:45 -0400
Received: from haxent.com ([65.99.219.155]:2157 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754AbXEBFem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:34:42 -0400
Message-Id: <20070502053424.553187000@haxent.com.br>
References: <20070502052235.914764000@haxent.com.br>
User-Agent: quilt/0.45-1
Date: Wed, 02 May 2007 02:22:38 -0300
From: Davi Arnaut <davi@haxent.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 03/22] pollfs: asynchronously wait for a signal
Content-Disposition: inline; filename=pollfs-signal-wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a wait queue to the task_struct in order to be able to
associate (wait for) a signal with other resources.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

---
 include/linux/init_task.h |    1 +
 include/linux/sched.h     |    1 +
 kernel/fork.c             |    1 +
 kernel/signal.c           |    5 +++++
 4 files changed, 8 insertions(+)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -939,6 +939,7 @@ struct task_struct {
 	sigset_t blocked, real_blocked;
 	sigset_t saved_sigmask;		/* To be restored with TIF_RESTORE_SIGMASK */
 	struct sigpending pending;
+	wait_queue_head_t sigwait;
 
 	unsigned long sas_ss_sp;
 	size_t sas_ss_size;
Index: linux-2.6/include/linux/init_task.h
===================================================================
--- linux-2.6.orig/include/linux/init_task.h
+++ linux-2.6/include/linux/init_task.h
@@ -134,6 +134,7 @@ extern struct group_info init_groups;
 		.list = LIST_HEAD_INIT(tsk.pending.list),		\
 		.signal = {{0}}},					\
 	.blocked	= {{0}},					\
+	.sigwait	= __WAIT_QUEUE_HEAD_INITIALIZER(tsk.sigwait),	\
 	.alloc_lock	= __SPIN_LOCK_UNLOCKED(tsk.alloc_lock),		\
 	.journal_info	= NULL,						\
 	.cpu_timers	= INIT_CPU_TIMERS(tsk.cpu_timers),		\
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -1034,6 +1034,7 @@ static struct task_struct *copy_process(
 
 	clear_tsk_thread_flag(p, TIF_SIGPENDING);
 	init_sigpending(&p->pending);
+	init_waitqueue_head(&p->sigwait);
 
 	p->utime = cputime_zero;
 	p->stime = cputime_zero;
Index: linux-2.6/kernel/signal.c
===================================================================
--- linux-2.6.orig/kernel/signal.c
+++ linux-2.6/kernel/signal.c
@@ -224,6 +224,8 @@ fastcall void recalc_sigpending_tsk(stru
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
 	else
 		clear_tsk_thread_flag(t, TIF_SIGPENDING);
+
+	wake_up_interruptible_sync(&t->sigwait);
 }
 
 void recalc_sigpending(void)
@@ -759,6 +761,7 @@ static int send_signal(int sig, struct s
 					      info->si_code >= 0)));
 	if (q) {
 		list_add_tail(&q->list, &signals->list);
+		wake_up_interruptible_sync(&t->sigwait);
 		switch ((unsigned long) info) {
 		case (unsigned long) SEND_SIG_NOINFO:
 			q->info.si_signo = sig;
@@ -1404,6 +1407,7 @@ int send_sigqueue(int sig, struct sigque
 
 	list_add_tail(&q->list, &p->pending.list);
 	sigaddset(&p->pending.signal, sig);
+	wake_up_interruptible_sync(&p->sigwait);
 	if (!sigismember(&p->blocked, sig))
 		signal_wake_up(p, sig == SIGKILL);
 
@@ -1453,6 +1457,7 @@ send_group_sigqueue(int sig, struct sigq
 	list_add_tail(&q->list, &p->signal->shared_pending.list);
 	sigaddset(&p->signal->shared_pending.signal, sig);
 
+	wake_up_interruptible_sync(&p->sigwait);
 	__group_complete_signal(sig, p);
 out:
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);

--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393AbXDMHbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbXDMHbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 03:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXDMHbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 03:31:40 -0400
Received: from mail.screens.ru ([213.234.233.54]:39808 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbXDMHbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 03:31:40 -0400
Date: Fri, 13 Apr 2007 11:31:16 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] change kernel threads to ignore signals instead of blocking them
Message-ID: <20070413073116.GA1540@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On top of Eric's

	kthread-dont-depend-on-work-queues-take-2.patch

Currently kernel threads use sigprocmask(SIG_BLOCK) to protect against signals.
This doesn't prevent the signal delivery, this only blocks signal_wake_up().
Every "killall -33 kthreadd" means a "struct siginfo" leak.

Change kthreadd_setup() to set all handlers to SIG_IGN instead of blocking them
(make a new helper ignore_signals() for that). If the kernel thread needs some
signal, it should use allow_signal() anyway, and in that case it should not use
CLONE_SIGHAND.

Note that we can't change daemonize() (should die!) in the same way, because
it can be used along with CLONE_SIGHAND. This means that allow_signal() still
should unblock the signal to work correctly with daemonize()ed threads.

However, disallow_signal() doesn't block the signal any longer but ignores it.

NOTE: with or without this patch the kernel threads are not protected from
handle_stop_signal(), this seems harmless, but not good.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/sched.h |    1 +
 kernel/exit.c         |    2 +-
 kernel/kthread.c      |   17 +++--------------
 kernel/signal.c       |   10 ++++++++++
 4 files changed, 15 insertions(+), 15 deletions(-)

--- 2.6.21-rc5/include/linux/sched.h~1_SIGIGN	2007-04-05 12:18:28.000000000 +0400
+++ 2.6.21-rc5/include/linux/sched.h	2007-04-13 00:09:56.000000000 +0400
@@ -1299,6 +1299,7 @@ extern int in_egroup_p(gid_t);
 
 extern void proc_caches_init(void);
 extern void flush_signals(struct task_struct *);
+extern void ignore_signals(struct task_struct *);
 extern void flush_signal_handlers(struct task_struct *, int force_default);
 extern int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info);
 
--- 2.6.21-rc5/kernel/signal.c~1_SIGIGN	2007-04-05 12:18:28.000000000 +0400
+++ 2.6.21-rc5/kernel/signal.c	2007-04-13 02:14:06.000000000 +0400
@@ -329,6 +329,16 @@ void flush_signals(struct task_struct *t
 	spin_unlock_irqrestore(&t->sighand->siglock, flags);
 }
 
+void ignore_signals(struct task_struct *t)
+{
+	int i;
+
+	for (i = 0; i < _NSIG; ++i)
+		t->sighand->action[i].sa.sa_handler = SIG_IGN;
+
+	flush_signals(t);
+}
+
 /*
  * Flush all handlers for a task.
  */
--- 2.6.21-rc5/kernel/kthread.c~1_SIGIGN	2007-04-12 23:18:09.000000000 +0400
+++ 2.6.21-rc5/kernel/kthread.c	2007-04-13 02:27:39.000000000 +0400
@@ -215,24 +215,13 @@ EXPORT_SYMBOL(kthread_stop);
 static __init void kthreadd_setup(void)
 {
 	struct task_struct *tsk = current;
-	struct k_sigaction sa;
-	sigset_t blocked;
 
 	set_task_comm(tsk, "kthreadd");
 
-	/* Block and flush all signals */
-	sigfillset(&blocked);
-	sigprocmask(SIG_BLOCK, &blocked, NULL);
-	flush_signals(tsk);
-
-	/* SIG_IGN makes children autoreap: see do_notify_parent(). */
-	sa.sa.sa_handler = SIG_IGN;
-	sa.sa.sa_flags = 0;
-	siginitset(&sa.sa.sa_mask, sigmask(SIGCHLD));
-	do_sigaction(SIGCHLD, &sa, (struct k_sigaction *)0);
+	ignore_signals(tsk);
 
-	set_user_nice(current, -5);
-	set_cpus_allowed(current, CPU_MASK_ALL);
+	set_user_nice(tsk, -5);
+	set_cpus_allowed(tsk, CPU_MASK_ALL);
 }
 
 int kthreadd(void *unused)
--- 2.6.21-rc5/kernel/exit.c~1_SIGIGN	2007-04-12 23:23:50.000000000 +0400
+++ 2.6.21-rc5/kernel/exit.c	2007-04-13 10:17:06.000000000 +0400
@@ -348,7 +348,7 @@ int disallow_signal(int sig)
 		return -EINVAL;
 
 	spin_lock_irq(&current->sighand->siglock);
-	sigaddset(&current->blocked, sig);
+	current->sighand->action[(sig)-1].sa.sa_handler = SIG_IGN;
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 	return 0;


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZBZSo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZBZSo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 13:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZBZSos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 13:44:48 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:5096 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbZBZSoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 13:44:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=XmbQmymitFLyyeYZ31gsIGmfeeHHtnFWnjpK5CooVQ6nu2JzfEcdgKSLGJzym4r223
         nzKAGvq3zvyF908/nzLkbVftZaYoF5ls7J+7soMMnliFJNouqCOHMxFloCnPRrZQDWxJ
         w6FWtwxItFPc+Z/C9oXTBkP6/rMwKqch+Ewcw=
Date: Thu, 26 Feb 2009 19:44:33 +0100
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] signals: don't copy siginfo_t on dequeue
Message-ID: <20090226184433.GA15644@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 60fc9a464377159ab807aec63277d4970019d631 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 26 Feb 2009 19:17:58 +0100
Subject: [PATCH] signals: don't copy siginfo_t on dequeue

Instead of copying the siginfo_t whenever a signal is dequeued, just
get the pointer to the struct sigqueue, which can be freed by the
caller when the signal has been delivered.

We can save kernel text (x86, 32-bit):

$ scripts/bloat-o-meter vmlinux-unpatched vmlinux
add/remove: 0/0 grow/shrink: 3/7 up/down: 81/-538 (-457)
function                                     old     new   delta
get_signal_to_deliver                        871     922     +51
release_console_sem                          459     481     +22
generate_resume_trace                        611     619      +8
send_sigqueue                                257     253      -4
vma_adjust                                  1101    1093      -8
sys_rt_sigtimedwait                          548     531     -17
dequeue_signal                               415     372     -43
__dequeue_signal                             388     259    -129
signalfd_read                               1290    1139    -151
do_notify_resume                            2216    2030    -186

And we reduce stack pressure; In handle_signal() (in x86 code), we
replace a siginfo_t (128 bytes) with a pointer (8 bytes on x86_64),
and the same in signalfd_read().

There is a slight slowdown (2.02% relative increase in CPU time):

		unpatched	patched
----------------------------------------
mean:		3.078500	3.140800
stddev:		0.074624	0.168989

(Numbers are: CPU time in seconds, for two processes to ping-pong
in total 655360 SIGUSR1/SIGUSR2 signals between each other. This
was repeated 100 times for each kernel.)

This patch will also enable us to send signals from the kernel
without copying any siginfo_t at all (and save a similar amount of
stack for some senders) with a future patch.

This is just experimental for now, it may happen that I altered
signal handling completely (although my system seems to work :-)).
But I will be happy for feedback (on the patch, on the results, on
how to improve the results, or anything).

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/kernel/signal.c  |   10 ++--
 fs/signalfd.c             |   38 ++++++------
 include/linux/sched.h     |   12 ++--
 include/linux/signal.h    |    3 +-
 include/linux/tracehook.h |    6 +-
 kernel/signal.c           |  155 +++++++++++++++++++++------------------------
 6 files changed, 108 insertions(+), 116 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index df0587f..a918d3d 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -800,8 +800,7 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 static void do_signal(struct pt_regs *regs)
 {
 	struct k_sigaction ka;
-	siginfo_t info;
-	int signr;
+	struct sigqueue *info;
 	sigset_t *oldset;
 
 	/*
@@ -819,8 +818,8 @@ static void do_signal(struct pt_regs *regs)
 	else
 		oldset = &current->blocked;
 
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
+	info = get_signal_to_deliver(&ka, regs, NULL);
+	if (info && info->info.si_signo > 0) {
 		/*
 		 * Re-enable any watchpoints before delivering the
 		 * signal to user space. The processor register will
@@ -831,7 +830,7 @@ static void do_signal(struct pt_regs *regs)
 			set_debugreg(current->thread.debugreg7, 7);
 
 		/* Whee! Actually deliver the signal.  */
-		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
+		if (handle_signal(info->info.si_signo, &info->info, &ka, oldset, regs) == 0) {
 			/*
 			 * A signal was successfully delivered; the saved
 			 * sigmask will have been stored in the signal frame,
@@ -840,6 +839,7 @@ static void do_signal(struct pt_regs *regs)
 			 */
 			current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
 		}
+		__sigqueue_free(info);
 		return;
 	}
 
diff --git a/fs/signalfd.c b/fs/signalfd.c
index b07565c..ced4954 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -125,32 +125,29 @@ static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
 	return err ? -EFAULT: sizeof(*uinfo);
 }
 
-static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
-				int nonblock)
+static struct sigqueue *signalfd_dequeue(struct signalfd_ctx *ctx, int nonblock)
 {
-	ssize_t ret;
+	struct sigqueue *signal;
 	DECLARE_WAITQUEUE(wait, current);
 
 	spin_lock_irq(&current->sighand->siglock);
-	ret = dequeue_signal(current, &ctx->sigmask, info);
-	switch (ret) {
-	case 0:
-		if (!nonblock)
-			break;
-		ret = -EAGAIN;
-	default:
+	signal = dequeue_signal(current, &ctx->sigmask);
+	if (signal) {
 		spin_unlock_irq(&current->sighand->siglock);
-		return ret;
+		return signal;
+	} else if (nonblock) {
+		spin_unlock_irq(&current->sighand->siglock);
+		return ERR_PTR(-EAGAIN);
 	}
 
 	add_wait_queue(&current->sighand->signalfd_wqh, &wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		ret = dequeue_signal(current, &ctx->sigmask, info);
-		if (ret != 0)
+		signal = dequeue_signal(current, &ctx->sigmask);
+		if (signal)
 			break;
 		if (signal_pending(current)) {
-			ret = -ERESTARTSYS;
+			signal = ERR_PTR(-ERESTARTSYS);
 			break;
 		}
 		spin_unlock_irq(&current->sighand->siglock);
@@ -162,7 +159,7 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
 	remove_wait_queue(&current->sighand->signalfd_wqh, &wait);
 	__set_current_state(TASK_RUNNING);
 
-	return ret;
+	return signal;
 }
 
 /*
@@ -177,7 +174,7 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 	struct signalfd_siginfo __user *siginfo;
 	int nonblock = file->f_flags & O_NONBLOCK;
 	ssize_t ret, total = 0;
-	siginfo_t info;
+	struct sigqueue *info;
 
 	count /= sizeof(struct signalfd_siginfo);
 	if (!count)
@@ -185,10 +182,13 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 
 	siginfo = (struct signalfd_siginfo __user *) buf;
 	do {
-		ret = signalfd_dequeue(ctx, &info, nonblock);
-		if (unlikely(ret <= 0))
+		info = signalfd_dequeue(ctx, nonblock);
+		if (unlikely(IS_ERR(info))) {
+			ret = PTR_ERR(info);
 			break;
-		ret = signalfd_copyinfo(siginfo, &info);
+		}
+		ret = signalfd_copyinfo(siginfo, &info->info);
+		__sigqueue_free(info);
 		if (ret < 0)
 			break;
 		siginfo++;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8981e52..1cf960e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1858,18 +1858,19 @@ extern void proc_caches_init(void);
 extern void flush_signals(struct task_struct *);
 extern void ignore_signals(struct task_struct *);
 extern void flush_signal_handlers(struct task_struct *, int force_default);
-extern int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info);
+extern struct sigqueue *dequeue_signal(struct task_struct *tsk, sigset_t *mask);
 
-static inline int dequeue_signal_lock(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
+static inline struct sigqueue *dequeue_signal_lock(struct task_struct *tsk,
+	sigset_t *mask)
 {
 	unsigned long flags;
-	int ret;
+	struct sigqueue *info;
 
 	spin_lock_irqsave(&tsk->sighand->siglock, flags);
-	ret = dequeue_signal(tsk, mask, info);
+	info = dequeue_signal(tsk, mask);
 	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
 
-	return ret;
+	return info;
 }	
 
 extern void block_all_signals(int (*notifier)(void *priv), void *priv,
@@ -1891,6 +1892,7 @@ extern void force_sig_specific(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
 extern void zap_other_threads(struct task_struct *p);
 extern struct sigqueue *sigqueue_alloc(void);
+extern void __sigqueue_free(struct sigqueue *);
 extern void sigqueue_free(struct sigqueue *);
 extern int send_sigqueue(struct sigqueue *,  struct task_struct *, int group);
 extern int do_sigaction(int, struct k_sigaction *, struct k_sigaction *);
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 84f997f..3d105ec 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -240,7 +240,8 @@ extern int sigprocmask(int, sigset_t *, sigset_t *);
 extern int show_unhandled_signals;
 
 struct pt_regs;
-extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
+extern struct sigqueue *get_signal_to_deliver(struct k_sigaction *return_ka,
+	struct pt_regs *regs, void *cookie);
 extern void exit_signals(struct task_struct *tsk);
 
 extern struct kmem_cache *sighand_cachep;
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 6186a78..bab55c2 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -459,10 +459,8 @@ static inline int tracehook_force_sigpending(void)
  *
  * Called with @task->sighand->siglock held, before dequeuing pending signals.
  */
-static inline int tracehook_get_signal(struct task_struct *task,
-				       struct pt_regs *regs,
-				       siginfo_t *info,
-				       struct k_sigaction *return_ka)
+static inline struct sigqueue *tracehook_get_signal(struct task_struct *task,
+	struct pt_regs *regs, struct k_sigaction *return_ka)
 {
 	return 0;
 }
diff --git a/kernel/signal.c b/kernel/signal.c
index 2a74fe8..3551000 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -214,7 +214,7 @@ static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
 	return q;
 }
 
-static void __sigqueue_free(struct sigqueue *q)
+void __sigqueue_free(struct sigqueue *q)
 {
 	if (q->flags & SIGQUEUE_PREALLOC)
 		return;
@@ -356,7 +356,7 @@ unblock_all_signals(void)
 	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 }
 
-static void collect_signal(int sig, struct sigpending *list, siginfo_t *info)
+static struct sigqueue *collect_signal(int sig, struct sigpending *list)
 {
 	struct sigqueue *q, *first = NULL;
 
@@ -377,40 +377,29 @@ static void collect_signal(int sig, struct sigpending *list, siginfo_t *info)
 	if (first) {
 still_pending:
 		list_del_init(&first->list);
-		copy_siginfo(info, &first->info);
-		__sigqueue_free(first);
-	} else {
-		/* Ok, it wasn't in the queue.  This must be
-		   a fast-pathed signal or we must have been
-		   out of queue space.  So zero out the info.
-		 */
-		info->si_signo = sig;
-		info->si_errno = 0;
-		info->si_code = 0;
-		info->si_pid = 0;
-		info->si_uid = 0;
 	}
+
+	return first;
 }
 
-static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
-			siginfo_t *info)
+static struct sigqueue *__dequeue_signal(struct sigpending *pending,
+	sigset_t *mask)
 {
 	int sig = next_signal(pending, mask);
 
-	if (sig) {
-		if (current->notifier) {
-			if (sigismember(current->notifier_mask, sig)) {
-				if (!(current->notifier)(current->notifier_data)) {
-					clear_thread_flag(TIF_SIGPENDING);
-					return 0;
-				}
+	if (!sig)
+		return NULL;
+
+	if (current->notifier) {
+		if (sigismember(current->notifier_mask, sig)) {
+			if (!(current->notifier)(current->notifier_data)) {
+				clear_thread_flag(TIF_SIGPENDING);
+				return 0;
 			}
 		}
-
-		collect_signal(sig, pending, info);
 	}
 
-	return sig;
+	return collect_signal(sig, pending);
 }
 
 /*
@@ -419,17 +408,16 @@ static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
  *
  * All callers have to hold the siglock.
  */
-int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
+struct sigqueue *dequeue_signal(struct task_struct *tsk, sigset_t *mask)
 {
-	int signr;
+	struct sigqueue *signal;
 
 	/* We only dequeue private signals from ourselves, we don't let
 	 * signalfd steal them
 	 */
-	signr = __dequeue_signal(&tsk->pending, mask, info);
-	if (!signr) {
-		signr = __dequeue_signal(&tsk->signal->shared_pending,
-					 mask, info);
+	signal = __dequeue_signal(&tsk->pending, mask);
+	if (!signal) {
+		signal = __dequeue_signal(&tsk->signal->shared_pending,  mask);
 		/*
 		 * itimer signal ?
 		 *
@@ -443,7 +431,7 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 		 * reducing the timer noise on heavy loaded !highres
 		 * systems too.
 		 */
-		if (unlikely(signr == SIGALRM)) {
+		if (unlikely(signal && signal->info.si_signo == SIGALRM)) {
 			struct hrtimer *tmr = &tsk->signal->real_timer;
 
 			if (!hrtimer_is_queued(tmr) &&
@@ -456,10 +444,10 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 	}
 
 	recalc_sigpending();
-	if (!signr)
-		return 0;
+	if (!signal)
+		return NULL;
 
-	if (unlikely(sig_kernel_stop(signr))) {
+	if (unlikely(sig_kernel_stop(signal->info.si_signo))) {
 		/*
 		 * Set a marker that we have dequeued a stop signal.  Our
 		 * caller might release the siglock and then the pending
@@ -474,7 +462,9 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 		 */
 		tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
 	}
-	if ((info->si_code & __SI_MASK) == __SI_TIMER && info->si_sys_private) {
+	if ((signal->info.si_code & __SI_MASK) == __SI_TIMER
+		&& signal->info.si_sys_private)
+	{
 		/*
 		 * Release the siglock to ensure proper locking order
 		 * of timer locks outside of siglocks.  Note, we leave
@@ -482,10 +472,10 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 		 * about to disable them again anyway.
 		 */
 		spin_unlock(&tsk->sighand->siglock);
-		do_schedule_next_timer(info);
+		do_schedule_next_timer(&signal->info);
 		spin_lock(&tsk->sighand->siglock);
 	}
-	return signr;
+	return signal;
 }
 
 /*
@@ -1706,11 +1696,13 @@ static int do_signal_stop(int signr)
 	return 1;
 }
 
-static int ptrace_signal(int signr, siginfo_t *info,
+static struct sigqueue *ptrace_signal(int signr, struct sigqueue *signal,
 			 struct pt_regs *regs, void *cookie)
 {
+	siginfo_t *info = &signal->info;
+
 	if (!(current->ptrace & PT_PTRACED))
-		return signr;
+		return signal;
 
 	ptrace_signal_deliver(regs, cookie);
 
@@ -1720,7 +1712,7 @@ static int ptrace_signal(int signr, siginfo_t *info,
 	/* We're back.  Did the debugger cancel the sig?  */
 	signr = current->exit_code;
 	if (signr == 0)
-		return signr;
+		return NULL;
 
 	current->exit_code = 0;
 
@@ -1739,18 +1731,18 @@ static int ptrace_signal(int signr, siginfo_t *info,
 	/* If the (new) signal is now blocked, requeue it.  */
 	if (sigismember(&current->blocked, signr)) {
 		specific_send_sig_info(signr, info, current);
-		signr = 0;
+		signal = NULL;
 	}
 
-	return signr;
+	return signal;
 }
 
-int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
-			  struct pt_regs *regs, void *cookie)
+struct sigqueue *get_signal_to_deliver(struct k_sigaction *return_ka,
+	struct pt_regs *regs, void *cookie)
 {
 	struct sighand_struct *sighand = current->sighand;
 	struct signal_struct *signal = current->signal;
-	int signr;
+	struct sigqueue *info;
 
 relock:
 	/*
@@ -1794,26 +1786,25 @@ relock:
 		 * The return value in @signr determines the default action,
 		 * but @info->si_signo is the signal number we will report.
 		 */
-		signr = tracehook_get_signal(current, regs, info, return_ka);
-		if (unlikely(signr < 0))
-			goto relock;
-		if (unlikely(signr != 0))
-			ka = return_ka;
-		else {
-			signr = dequeue_signal(current, &current->blocked,
-					       info);
-
-			if (!signr)
+		info = tracehook_get_signal(current, regs, return_ka);
+		if (unlikely(info)) {
+			if (info->info.si_signo < 0)
+				goto relock;
+			if (info->info.si_signo != 0)
+				ka = return_ka;
+		} else {
+			info = dequeue_signal(current, &current->blocked);
+			if (!info)
 				break; /* will return 0 */
 
-			if (signr != SIGKILL) {
-				signr = ptrace_signal(signr, info,
-						      regs, cookie);
-				if (!signr)
+			if (info->info.si_signo != SIGKILL) {
+				info = ptrace_signal(info->info.si_signo,
+					info, regs, cookie);
+				if (!info)
 					continue;
 			}
 
-			ka = &sighand->action[signr-1];
+			ka = &sighand->action[info->info.si_signo - 1];
 		}
 
 		if (ka->sa.sa_handler == SIG_IGN) /* Do nothing.  */
@@ -1831,7 +1822,7 @@ relock:
 		/*
 		 * Now we are doing the default action for this signal.
 		 */
-		if (sig_kernel_ignore(signr)) /* Default is nothing. */
+		if (sig_kernel_ignore(info->info.si_signo)) /* Default is nothing. */
 			continue;
 
 		/*
@@ -1841,7 +1832,7 @@ relock:
 		    !signal_group_exit(signal))
 			continue;
 
-		if (sig_kernel_stop(signr)) {
+		if (sig_kernel_stop(info->info.si_signo)) {
 			/*
 			 * The default action is to stop all threads in
 			 * the thread group.  The job control signals
@@ -1852,7 +1843,7 @@ relock:
 			 * This allows an intervening SIGCONT to be posted.
 			 * We need to check for that and bail out if necessary.
 			 */
-			if (signr != SIGSTOP) {
+			if (info->info.si_signo != SIGSTOP) {
 				spin_unlock_irq(&sighand->siglock);
 
 				/* signals can be posted during this window */
@@ -1863,7 +1854,7 @@ relock:
 				spin_lock_irq(&sighand->siglock);
 			}
 
-			if (likely(do_signal_stop(info->si_signo))) {
+			if (likely(do_signal_stop(info->info.si_signo))) {
 				/* It released the siglock.  */
 				goto relock;
 			}
@@ -1882,9 +1873,9 @@ relock:
 		 */
 		current->flags |= PF_SIGNALED;
 
-		if (sig_kernel_coredump(signr)) {
+		if (sig_kernel_coredump(info->info.si_signo)) {
 			if (print_fatal_signals)
-				print_fatal_signal(regs, info->si_signo);
+				print_fatal_signal(regs, info->info.si_signo);
 			/*
 			 * If it was able to dump core, this kills all
 			 * other threads in the group and synchronizes with
@@ -1893,17 +1884,18 @@ relock:
 			 * first and our do_group_exit call below will use
 			 * that value and ignore the one we pass it.
 			 */
-			do_coredump(info->si_signo, info->si_signo, regs);
+			do_coredump(info->info.si_signo, info->info.si_signo,
+				regs);
 		}
 
 		/*
 		 * Death signals, no core dump.
 		 */
-		do_group_exit(info->si_signo);
+		do_group_exit(info->info.si_signo);
 		/* NOTREACHED */
 	}
 	spin_unlock_irq(&sighand->siglock);
-	return signr;
+	return info;
 }
 
 void exit_signals(struct task_struct *tsk)
@@ -2074,7 +2066,7 @@ long do_sigpending(void __user *set, unsigned long sigsetsize)
 
 out:
 	return error;
-}	
+}
 
 SYSCALL_DEFINE2(rt_sigpending, sigset_t __user *, set, size_t, sigsetsize)
 {
@@ -2082,7 +2074,6 @@ SYSCALL_DEFINE2(rt_sigpending, sigset_t __user *, set, size_t, sigsetsize)
 }
 
 #ifndef HAVE_ARCH_COPY_SIGINFO_TO_USER
-
 int copy_siginfo_to_user(siginfo_t __user *to, siginfo_t *from)
 {
 	int err;
@@ -2144,17 +2135,16 @@ int copy_siginfo_to_user(siginfo_t __user *to, siginfo_t *from)
 	}
 	return err;
 }
-
 #endif
 
 SYSCALL_DEFINE4(rt_sigtimedwait, const sigset_t __user *, uthese,
 		siginfo_t __user *, uinfo, const struct timespec __user *, uts,
 		size_t, sigsetsize)
 {
-	int ret, sig;
+	int ret;
 	sigset_t these;
 	struct timespec ts;
-	siginfo_t info;
+	struct sigqueue *info;
 	long timeout = 0;
 
 	/* XXX: Don't preclude handling different sized sigset_t's.  */
@@ -2180,8 +2170,8 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const sigset_t __user *, uthese,
 	}
 
 	spin_lock_irq(&current->sighand->siglock);
-	sig = dequeue_signal(current, &these, &info);
-	if (!sig) {
+	info = dequeue_signal(current, &these);
+	if (!info) {
 		timeout = MAX_SCHEDULE_TIMEOUT;
 		if (uts)
 			timeout = (timespec_to_jiffies(&ts)
@@ -2199,7 +2189,7 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const sigset_t __user *, uthese,
 			timeout = schedule_timeout_interruptible(timeout);
 
 			spin_lock_irq(&current->sighand->siglock);
-			sig = dequeue_signal(current, &these, &info);
+			info = dequeue_signal(current, &these);
 			current->blocked = current->real_blocked;
 			siginitset(&current->real_blocked, 0);
 			recalc_sigpending();
@@ -2207,12 +2197,13 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const sigset_t __user *, uthese,
 	}
 	spin_unlock_irq(&current->sighand->siglock);
 
-	if (sig) {
-		ret = sig;
+	if (info) {
+		ret = info->info.si_signo;
 		if (uinfo) {
-			if (copy_siginfo_to_user(uinfo, &info))
+			if (copy_siginfo_to_user(uinfo, &info->info))
 				ret = -EFAULT;
 		}
+		__sigqueue_free(info);
 	} else {
 		ret = -EAGAIN;
 		if (timeout)
-- 
1.6.0.6


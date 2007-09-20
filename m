Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbXITTkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbXITTkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbXITTkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:40:22 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:39168 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbXITTkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:40:20 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 20 Sep 2007 12:40:16 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] signalfd simplification
Message-ID: <Pine.LNX.4.64.0709201220260.8897@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch simplifies signalfd code, by avoiding it to remain 
attached to the sighand during its lifetime.
In this way, the signalfd remain attached to the sighand only during 
poll(2) (and select and epoll) and read(2). This also allows to remove all 
the custom "tsk == current" checks in kernel/signal.c, since 
dequeue_signal() will only be called by "current".
I think this is also what Ben was suggesting time ago.
The external effect of this, is that a thread can extract only its own 
private signals and the group ones. I think this is an acceptable 
behaviour, in that those are the signals the thread would be able to fetch 
w/out signalfd.
Oleg, as far as the smart wakeup thing. Can't be done w/out huge 
revolutions to the kernel code.
It can easily be done for the ->read(), but not for the ->poll(). You need 
to be the provider of the poll_table in order to install custom wakeups, 
and inside ->poll(), the providers are either fs/select.c or 
fs/eventpoll.c (or fs/aio.c). We could add a new poll_wait_func() to pass 
the function to be called, and that would work for fs/select.c (in there 
you can filter based on the signal and eventually issue the real wakeup). 
But it won't work for epoll, since it already expect to install its own 
callback, and ATM callbacks can't be chained.
Since the thundering herd effect on signalfds should be pretty limited, I 
think it's not worth the change.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



---
 fs/exec.c                 |    3 
 fs/signalfd.c             |  190 +++++++---------------------------------------
 include/linux/init_task.h |    2 
 include/linux/sched.h     |    2 
 include/linux/signalfd.h  |   40 ---------
 kernel/exit.c             |    9 --
 kernel/fork.c             |    2 
 kernel/signal.c           |    8 -
 8 files changed, 39 insertions(+), 217 deletions(-)

Index: linux-2.6.mod/fs/signalfd.c
===================================================================
--- linux-2.6.mod.orig/fs/signalfd.c	2007-09-19 15:54:21.000000000 -0700
+++ linux-2.6.mod/fs/signalfd.c	2007-09-19 15:54:42.000000000 -0700
@@ -11,8 +11,10 @@
  *      Now using anonymous inode source.
  *      Thanks to Oleg Nesterov for useful code review and suggestions.
  *      More comments and suggestions from Arnd Bergmann.
- * Sat May 19, 2007: Davi E. M. Arnaut <davi@haxent.com.br>
+ *  Sat May 19, 2007: Davi E. M. Arnaut <davi@haxent.com.br>
  *      Retrieve multiple signals with one read() call
+ *  Sun Jul 15, 2007: Davide Libenzi <davidel@xmailserver.org>
+ *      Attach to the sighand only during read() and poll().
  */
 
 #include <linux/file.h>
@@ -27,102 +29,12 @@
 #include <linux/signalfd.h>
 
 struct signalfd_ctx {
-	struct list_head lnk;
-	wait_queue_head_t wqh;
 	sigset_t sigmask;
-	struct task_struct *tsk;
 };
 
-struct signalfd_lockctx {
-	struct task_struct *tsk;
-	unsigned long flags;
-};
-
-/*
- * Tries to acquire the sighand lock. We do not increment the sighand
- * use count, and we do not even pin the task struct, so we need to
- * do it inside an RCU read lock, and we must be prepared for the
- * ctx->tsk going to NULL (in signalfd_deliver()), and for the sighand
- * being detached. We return 0 if the sighand has been detached, or
- * 1 if we were able to pin the sighand lock.
- */
-static int signalfd_lock(struct signalfd_ctx *ctx, struct signalfd_lockctx *lk)
-{
-	struct sighand_struct *sighand = NULL;
-
-	rcu_read_lock();
-	lk->tsk = rcu_dereference(ctx->tsk);
-	if (likely(lk->tsk != NULL))
-		sighand = lock_task_sighand(lk->tsk, &lk->flags);
-	rcu_read_unlock();
-
-	if (!sighand)
-		return 0;
-
-	if (!ctx->tsk) {
-		unlock_task_sighand(lk->tsk, &lk->flags);
-		return 0;
-	}
-
-	if (lk->tsk->tgid == current->tgid)
-		lk->tsk = current;
-
-	return 1;
-}
-
-static void signalfd_unlock(struct signalfd_lockctx *lk)
-{
-	unlock_task_sighand(lk->tsk, &lk->flags);
-}
-
-/*
- * This must be called with the sighand lock held.
- */
-void signalfd_deliver(struct task_struct *tsk, int sig)
-{
-	struct sighand_struct *sighand = tsk->sighand;
-	struct signalfd_ctx *ctx, *tmp;
-
-	BUG_ON(!sig);
-	list_for_each_entry_safe(ctx, tmp, &sighand->signalfd_list, lnk) {
-		/*
-		 * We use a negative signal value as a way to broadcast that the
-		 * sighand has been orphaned, so that we can notify all the
-		 * listeners about this. Remember the ctx->sigmask is inverted,
-		 * so if the user is interested in a signal, that corresponding
-		 * bit will be zero.
-		 */
-		if (sig < 0) {
-			if (ctx->tsk == tsk) {
-				ctx->tsk = NULL;
-				list_del_init(&ctx->lnk);
-				wake_up(&ctx->wqh);
-			}
-		} else {
-			if (!sigismember(&ctx->sigmask, sig))
-				wake_up(&ctx->wqh);
-		}
-	}
-}
-
-static void signalfd_cleanup(struct signalfd_ctx *ctx)
-{
-	struct signalfd_lockctx lk;
-
-	/*
-	 * This is tricky. If the sighand is gone, we do not need to remove
-	 * context from the list, the list itself won't be there anymore.
-	 */
-	if (signalfd_lock(ctx, &lk)) {
-		list_del(&ctx->lnk);
-		signalfd_unlock(&lk);
-	}
-	kfree(ctx);
-}
-
 static int signalfd_release(struct inode *inode, struct file *file)
 {
-	signalfd_cleanup(file->private_data);
+	kfree(file->private_data);
 	return 0;
 }
 
@@ -130,23 +42,15 @@
 {
 	struct signalfd_ctx *ctx = file->private_data;
 	unsigned int events = 0;
-	struct signalfd_lockctx lk;
 
-	poll_wait(file, &ctx->wqh, wait);
+	poll_wait(file, &current->sighand->signalfd_wqh, wait);
 
-	/*
-	 * Let the caller get a POLLIN in this case, ala socket recv() when
-	 * the peer disconnects.
-	 */
-	if (signalfd_lock(ctx, &lk)) {
-		if ((lk.tsk == current &&
-		     next_signal(&lk.tsk->pending, &ctx->sigmask) > 0) ||
-		    next_signal(&lk.tsk->signal->shared_pending,
-				&ctx->sigmask) > 0)
-			events |= POLLIN;
-		signalfd_unlock(&lk);
-	} else
+	spin_lock_irq(&current->sighand->siglock);
+	if (next_signal(&current->pending, &ctx->sigmask) ||
+	    next_signal(&current->signal->shared_pending,
+			&ctx->sigmask))
 		events |= POLLIN;
+	spin_unlock_irq(&current->sighand->siglock);
 
 	return events;
 }
@@ -219,59 +123,46 @@
 				int nonblock)
 {
 	ssize_t ret;
-	struct signalfd_lockctx lk;
 	DECLARE_WAITQUEUE(wait, current);
 
-	if (!signalfd_lock(ctx, &lk))
-		return 0;
-
-	ret = dequeue_signal(lk.tsk, &ctx->sigmask, info);
+	spin_lock_irq(&current->sighand->siglock);
+	ret = dequeue_signal(current, &ctx->sigmask, info);
 	switch (ret) {
 	case 0:
 		if (!nonblock)
 			break;
 		ret = -EAGAIN;
 	default:
-		signalfd_unlock(&lk);
+		spin_unlock_irq(&current->sighand->siglock);
 		return ret;
 	}
 
-	add_wait_queue(&ctx->wqh, &wait);
+	add_wait_queue(&current->sighand->signalfd_wqh, &wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		ret = dequeue_signal(lk.tsk, &ctx->sigmask, info);
-		signalfd_unlock(&lk);
+		ret = dequeue_signal(current, &ctx->sigmask, info);
 		if (ret != 0)
 			break;
 		if (signal_pending(current)) {
 			ret = -ERESTARTSYS;
 			break;
 		}
+		spin_unlock_irq(&current->sighand->siglock);
 		schedule();
-		ret = signalfd_lock(ctx, &lk);
-		if (unlikely(!ret)) {
-			/*
-			 * Let the caller read zero byte, ala socket
-			 * recv() when the peer disconnect. This test
-			 * must be done before doing a dequeue_signal(),
-			 * because if the sighand has been orphaned,
-			 * the dequeue_signal() call is going to crash
-			 * because ->sighand will be long gone.
-			 */
-			 break;
-		}
+		spin_lock_irq(&current->sighand->siglock);
 	}
+	spin_unlock_irq(&current->sighand->siglock);
 
-	remove_wait_queue(&ctx->wqh, &wait);
+	remove_wait_queue(&current->sighand->signalfd_wqh, &wait);
 	__set_current_state(TASK_RUNNING);
 
 	return ret;
 }
 
 /*
- * Returns either the size of a "struct signalfd_siginfo", or zero if the
- * sighand we are attached to, has been orphaned. The "count" parameter
- * must be at least the size of a "struct signalfd_siginfo".
+ * Returns a multiple of the size of a "struct signalfd_siginfo", or a negative
+ * error code. The "count" parameter must be at least the size of a
+ * "struct signalfd_siginfo".
  */
 static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 			     loff_t *ppos)
@@ -287,7 +178,6 @@
 		return -EINVAL;
 
 	siginfo = (struct signalfd_siginfo __user *) buf;
-
 	do {
 		ret = signalfd_dequeue(ctx, &info, nonblock);
 		if (unlikely(ret <= 0))
@@ -300,7 +190,7 @@
 		nonblock = 1;
 	} while (--count);
 
-	return total ? total : ret;
+	return total ? total: ret;
 }
 
 static const struct file_operations signalfd_fops = {
@@ -309,20 +199,13 @@
 	.read		= signalfd_read,
 };
 
-/*
- * Create a file descriptor that is associated with our signal
- * state. We can pass it around to others if we want to, but
- * it will always be _our_ signal state.
- */
 asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask)
 {
 	int error;
 	sigset_t sigmask;
 	struct signalfd_ctx *ctx;
-	struct sighand_struct *sighand;
 	struct file *file;
 	struct inode *inode;
-	struct signalfd_lockctx lk;
 
 	if (sizemask != sizeof(sigset_t) ||
 	    copy_from_user(&sigmask, user_mask, sizeof(sigmask)))
@@ -335,17 +218,7 @@
 		if (!ctx)
 			return -ENOMEM;
 
-		init_waitqueue_head(&ctx->wqh);
 		ctx->sigmask = sigmask;
-		ctx->tsk = current->group_leader;
-
-		sighand = current->sighand;
-		/*
-		 * Add this fd to the list of signal listeners.
-		 */
-		spin_lock_irq(&sighand->siglock);
-		list_add_tail(&ctx->lnk, &sighand->signalfd_list);
-		spin_unlock_irq(&sighand->siglock);
 
 		/*
 		 * When we call this, the initialization must be complete, since
@@ -364,23 +237,18 @@
 			fput(file);
 			return -EINVAL;
 		}
-		/*
-		 * We need to be prepared of the fact that the sighand this fd
-		 * is attached to, has been detched. In that case signalfd_lock()
-		 * will return 0, and we'll just skip setting the new mask.
-		 */
-		if (signalfd_lock(ctx, &lk)) {
-			ctx->sigmask = sigmask;
-			signalfd_unlock(&lk);
-		}
-		wake_up(&ctx->wqh);
+		spin_lock_irq(&current->sighand->siglock);
+		ctx->sigmask = sigmask;
+		spin_unlock_irq(&current->sighand->siglock);
+
+		wake_up(&current->sighand->signalfd_wqh);
 		fput(file);
 	}
 
 	return ufd;
 
 err_fdalloc:
-	signalfd_cleanup(ctx);
+	kfree(ctx);
 	return error;
 }
 
Index: linux-2.6.mod/fs/exec.c
===================================================================
--- linux-2.6.mod.orig/fs/exec.c	2007-09-19 15:54:21.000000000 -0700
+++ linux-2.6.mod/fs/exec.c	2007-09-19 15:54:42.000000000 -0700
@@ -50,7 +50,6 @@
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
-#include <linux/signalfd.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -784,7 +783,6 @@
 	 * and we can just re-use it all.
 	 */
 	if (atomic_read(&oldsighand->count) <= 1) {
-		signalfd_detach(tsk);
 		exit_itimers(sig);
 		return 0;
 	}
@@ -923,7 +921,6 @@
 	sig->flags = 0;
 
 no_thread_group:
-	signalfd_detach(tsk);
 	exit_itimers(sig);
 	if (leader)
 		release_task(leader);
Index: linux-2.6.mod/kernel/exit.c
===================================================================
--- linux-2.6.mod.orig/kernel/exit.c	2007-09-19 15:54:21.000000000 -0700
+++ linux-2.6.mod/kernel/exit.c	2007-09-19 15:54:42.000000000 -0700
@@ -24,7 +24,6 @@
 #include <linux/pid_namespace.h>
 #include <linux/ptrace.h>
 #include <linux/profile.h>
-#include <linux/signalfd.h>
 #include <linux/mount.h>
 #include <linux/proc_fs.h>
 #include <linux/kthread.h>
@@ -86,14 +85,6 @@
 	sighand = rcu_dereference(tsk->sighand);
 	spin_lock(&sighand->siglock);
 
-	/*
-	 * Notify that this sighand has been detached. This must
-	 * be called with the tsk->sighand lock held. Also, this
-	 * access tsk->sighand internally, so it must be called
-	 * before tsk->sighand is reset.
-	 */
-	signalfd_detach_locked(tsk);
-
 	posix_cpu_timers_exit(tsk);
 	if (atomic_dec_and_test(&sig->count))
 		posix_cpu_timers_exit_group(tsk);
Index: linux-2.6.mod/include/linux/signalfd.h
===================================================================
--- linux-2.6.mod.orig/include/linux/signalfd.h	2007-09-19 15:54:21.000000000 -0700
+++ linux-2.6.mod/include/linux/signalfd.h	2007-09-19 15:54:42.000000000 -0700
@@ -45,49 +45,17 @@
 #ifdef CONFIG_SIGNALFD
 
 /*
- * Deliver the signal to listening signalfd. This must be called
- * with the sighand lock held. Same are the following that end up
- * calling signalfd_deliver().
- */
-void signalfd_deliver(struct task_struct *tsk, int sig);
-
-/*
- * No need to fall inside signalfd_deliver() if no signal listeners
- * are available.
+ * Deliver the signal to listening signalfd.
  */
 static inline void signalfd_notify(struct task_struct *tsk, int sig)
 {
-	if (unlikely(!list_empty(&tsk->sighand->signalfd_list)))
-		signalfd_deliver(tsk, sig);
-}
-
-/*
- * The signal -1 is used to notify the signalfd that the sighand
- * is on its way to be detached.
- */
-static inline void signalfd_detach_locked(struct task_struct *tsk)
-{
-	if (unlikely(!list_empty(&tsk->sighand->signalfd_list)))
-		signalfd_deliver(tsk, -1);
-}
-
-static inline void signalfd_detach(struct task_struct *tsk)
-{
-	struct sighand_struct *sighand = tsk->sighand;
-
-	if (unlikely(!list_empty(&sighand->signalfd_list))) {
-		spin_lock_irq(&sighand->siglock);
-		signalfd_deliver(tsk, -1);
-		spin_unlock_irq(&sighand->siglock);
-	}
+	if (unlikely(waitqueue_active(&tsk->sighand->signalfd_wqh)))
+		wake_up(&tsk->sighand->signalfd_wqh);
 }
 
 #else /* CONFIG_SIGNALFD */
 
-#define signalfd_deliver(t, s) do { } while (0)
-#define signalfd_notify(t, s) do { } while (0)
-#define signalfd_detach_locked(t) do { } while (0)
-#define signalfd_detach(t) do { } while (0)
+static inline void signalfd_notify(struct task_struct *tsk, int sig) { }
 
 #endif /* CONFIG_SIGNALFD */
 
Index: linux-2.6.mod/kernel/signal.c
===================================================================
--- linux-2.6.mod.orig/kernel/signal.c	2007-09-19 15:54:21.000000000 -0700
+++ linux-2.6.mod/kernel/signal.c	2007-09-19 15:54:42.000000000 -0700
@@ -378,8 +378,7 @@
 	/* We only dequeue private signals from ourselves, we don't let
 	 * signalfd steal them
 	 */
-	if (likely(tsk == current))
-		signr = __dequeue_signal(&tsk->pending, mask, info);
+	signr = __dequeue_signal(&tsk->pending, mask, info);
 	if (!signr) {
 		signr = __dequeue_signal(&tsk->signal->shared_pending,
 					 mask, info);
@@ -407,8 +406,7 @@
 			}
 		}
 	}
-	if (likely(tsk == current))
-		recalc_sigpending();
+	recalc_sigpending();
 	if (signr && unlikely(sig_kernel_stop(signr))) {
 		/*
 		 * Set a marker that we have dequeued a stop signal.  Our
@@ -425,7 +423,7 @@
 		if (!(tsk->signal->flags & SIGNAL_GROUP_EXIT))
 			tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
 	}
-	if (signr && likely(tsk == current) &&
+	if (signr &&
 	     ((info->si_code & __SI_MASK) == __SI_TIMER) &&
 	     info->si_sys_private){
 		/*
Index: linux-2.6.mod/include/linux/sched.h
===================================================================
--- linux-2.6.mod.orig/include/linux/sched.h	2007-09-19 15:54:35.000000000 -0700
+++ linux-2.6.mod/include/linux/sched.h	2007-09-19 15:54:42.000000000 -0700
@@ -438,7 +438,7 @@
 	atomic_t		count;
 	struct k_sigaction	action[_NSIG];
 	spinlock_t		siglock;
-	struct list_head        signalfd_list;
+	wait_queue_head_t	signalfd_wqh;
 };
 
 struct pacct_struct {
Index: linux-2.6.mod/kernel/fork.c
===================================================================
--- linux-2.6.mod.orig/kernel/fork.c	2007-09-19 15:54:21.000000000 -0700
+++ linux-2.6.mod/kernel/fork.c	2007-09-19 15:54:42.000000000 -0700
@@ -1438,7 +1438,7 @@
 	struct sighand_struct *sighand = data;
 
 	spin_lock_init(&sighand->siglock);
-	INIT_LIST_HEAD(&sighand->signalfd_list);
+	init_waitqueue_head(&sighand->signalfd_wqh);
 }
 
 void __init proc_caches_init(void)
Index: linux-2.6.mod/include/linux/init_task.h
===================================================================
--- linux-2.6.mod.orig/include/linux/init_task.h	2007-09-19 15:54:21.000000000 -0700
+++ linux-2.6.mod/include/linux/init_task.h	2007-09-19 15:54:42.000000000 -0700
@@ -86,7 +86,7 @@
 	.count		= ATOMIC_INIT(1), 				\
 	.action		= { { { .sa_handler = NULL, } }, },		\
 	.siglock	= __SPIN_LOCK_UNLOCKED(sighand.siglock),	\
-	.signalfd_list	= LIST_HEAD_INIT(sighand.signalfd_list),	\
+	.signalfd_wqh	= __WAIT_QUEUE_HEAD_INITIALIZER(sighand.signalfd_wqh),	\
 }
 
 extern struct group_info init_groups;

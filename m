Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbXCPA0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbXCPA0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 20:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbXCPA0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 20:26:32 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:47052 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbXCPA03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 20:26:29 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Date: Thu, 15 Mar 2007 17:22:15 -0700
Subject: [patch 2/13] signal/timer/event fds v6 - signalfd core ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.9367.1174004536.2>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements the new signalfd() system call.
I took part of the original Linus code (and you know how
badly it can be broken :), and I added even more breakage ;)
Signals are fetched from the same signal queue used by the process,
so signalfd will compete with standard kernel delivery in dequeue_signal().
If you want to reliably fetch signals on the signalfd file, you need to
block them with sigprocmask(SIG_BLOCK).
This seems to be working fine on my Dual Opteron machine. I made a quick 
test program for it:

http://www.xmailserver.org/signafd-test.c

The signalfd() system call implements signal delivery into a file 
descriptor receiver. The signalfd file descriptor if created with the 
following API:

int signalfd(int ufd, const sigset_t *mask, size_t masksize);

The "ufd" parameter allows to change an existing signalfd sigmask, w/out 
going to close/create cycle (Linus idea). Use "ufd" == -1 if you want a 
brand new signalfd file.
The "mask" allows to specify the signal mask of signals that we are 
interested in. The "masksize" parameter is the size of "mask".
The signalfd fd supports the poll(2) and read(2) system calls. The poll(2)
will return POLLIN when signals are available to be dequeued. As a direct
consequence of supporting the Linux poll subsystem, the signalfd fd can use
used together with epoll(2) too.
The read(2) system call will return a "struct signalfd_siginfo" structure
in the userspace supplied buffer. The return value is the number of bytes
copied in the supplied buffer, or -1 in case of error. The read(2) call
can also return 0, in case the sighand structure to which the signalfd
was attached, has been orphaned. The O_NONBLOCK flag is also supported, and
read(2) will return -EAGAIN in case no signal is available.
The format of the struct signalfd_siginfo is, and the valid fields depends
of the (->code & __SI_MASK) value, in the same way a struct siginfo would:

struct signalfd_siginfo {
	__u32 signo;	/* si_signo */
	__s32 err;	/* si_errno */
	__s32 code;	/* si_code */
	__u32 pid;	/* si_pid */
	__u32 uid;	/* si_uid */
	__s32 fd;	/* si_fd */
	__u32 tid;	/* si_fd */
	__u32 band;	/* si_band */
	__u32 overrun;	/* si_overrun */
	__u32 trapno;	/* si_trapno */
	__s32 status;	/* si_status */
	__s32 svint;	/* si_int */
	__u64 svptr;	/* si_ptr */
	__u64 utime;	/* si_utime */
	__u64 stime;	/* si_stime */
	__u64 addr;	/* si_addr */
};



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>



- Davide



Index: linux-2.6.21-rc3.quilt/fs/signalfd.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21-rc3.quilt/fs/signalfd.c	2007-03-15 15:33:52.000000000 -0700
@@ -0,0 +1,381 @@
+/*
+ *  fs/signalfd.c
+ *
+ *  Copyright (C) 2003  Linus Torvalds
+ *
+ *  Mon Mar 5, 2007: Davide Libenzi <davidel@xmailserver.org>
+ *      Changed ->read() to return a siginfo strcture instead of signal number.
+ *      Fixed locking in ->poll().
+ *      Added sighand-detach notification.
+ *      Added fd re-use in sys_signalfd() syscall.
+ *      Now using anonymous inode source.
+ *      Thanks to Oleg Nesterov for useful code review and suggestions.
+ */
+
+#include <linux/file.h>
+#include <linux/poll.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/signal.h>
+#include <linux/list.h>
+#include <linux/anon_inodes.h>
+#include <linux/signalfd.h>
+
+#include <asm/uaccess.h>
+
+
+
+struct signalfd_ctx {
+	struct list_head lnk;
+	wait_queue_head_t wqh;
+	sigset_t sigmask;
+	struct task_struct *tsk;
+};
+
+
+
+static struct sighand_struct *signalfd_get_sighand(struct signalfd_ctx *ctx,
+						   unsigned long *flags);
+static void signalfd_put_sighand(struct signalfd_ctx *ctx,
+				 struct sighand_struct *sighand,
+				 unsigned long *flags);
+static void signalfd_cleanup(struct signalfd_ctx *ctx);
+static int signalfd_close(struct inode *inode, struct file *file);
+static unsigned int signalfd_poll(struct file *file, poll_table *wait);
+static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
+			     siginfo_t const *kinfo);
+static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
+			     loff_t *ppos);
+
+
+
+static const struct file_operations signalfd_fops = {
+	.release	= signalfd_close,
+	.poll		= signalfd_poll,
+	.read		= signalfd_read,
+};
+static struct kmem_cache *signalfd_ctx_cachep;
+
+
+
+static struct sighand_struct *signalfd_get_sighand(struct signalfd_ctx *ctx,
+						   unsigned long *flags)
+{
+	struct sighand_struct *sighand;
+
+	rcu_read_lock();
+	sighand = lock_task_sighand(ctx->tsk, flags);
+	rcu_read_unlock();
+
+	if (sighand && list_empty(&ctx->lnk)) {
+		unlock_task_sighand(ctx->tsk, flags);
+		sighand = NULL;
+	}
+
+	return sighand;
+}
+
+
+static void signalfd_put_sighand(struct signalfd_ctx *ctx,
+				 struct sighand_struct *sighand,
+				 unsigned long *flags)
+{
+	unlock_task_sighand(ctx->tsk, flags);
+}
+
+
+/*
+ * This must be called with the sighand lock held.
+ */
+void signalfd_deliver(struct task_struct *tsk, int sig)
+{
+	struct sighand_struct *sighand = tsk->sighand;
+	struct signalfd_ctx *ctx, *tmp;
+
+	list_for_each_entry_safe(ctx, tmp, &sighand->sfdlist, lnk) {
+		/*
+		 * We use a negative signal value as a way to broadcast that the
+		 * sighand has been orphaned, so that we can notify all the
+		 * listeners about this. Remeber the ctx->sigmask is inverted,
+		 * so if the user is interested in a signal, that corresponding
+		 * bit will be zero.
+		 */
+		if (sig < 0) {
+			if (ctx->tsk == tsk) {
+				list_del_init(&ctx->lnk);
+				wake_up(&ctx->wqh);
+			}
+		} else if (sig > 0) {
+			if (!sigismember(&ctx->sigmask, sig))
+				wake_up(&ctx->wqh);
+		}
+	}
+}
+
+
+/*
+ * Create a file descriptor that is associated with our signal
+ * state. We can pass it around to others if we want to, but
+ * it will always be _our_ signal state.
+ */
+asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask)
+{
+	int error;
+	unsigned long flags;
+	sigset_t sigmask;
+	struct signalfd_ctx *ctx;
+	struct sighand_struct *sighand;
+	struct file *file;
+	struct inode *inode;
+
+	error = -EINVAL;
+	if (sizemask != sizeof(sigset_t) ||
+	    copy_from_user(&sigmask, user_mask, sizeof(sigmask)))
+		goto err_exit;
+	sigdelsetmask(&sigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
+	signotset(&sigmask);
+
+	if (ufd == -1) {
+		error = -ENOMEM;
+		ctx = kmem_cache_alloc(signalfd_ctx_cachep, GFP_KERNEL);
+		if (!ctx)
+			goto err_exit;
+
+		init_waitqueue_head(&ctx->wqh);
+		ctx->sigmask = sigmask;
+		ctx->tsk = current;
+		get_task_struct(current);
+
+		sighand = current->sighand;
+		/*
+		 * Add this fd to the list of signal listeners.
+		 */
+		spin_lock_irq(&sighand->siglock);
+		list_add_tail(&ctx->lnk, &sighand->sfdlist);
+		spin_unlock_irq(&sighand->siglock);
+
+		/*
+		 * When we call this, the initialization must be complete, since
+		 * aino_getfd() will install the fd.
+		 */
+		error = aino_getfd(&ufd, &inode, &file, "[signalfd]",
+				   &signalfd_fops, ctx);
+		if (error)
+			goto err_fdalloc;
+	} else {
+		error = -EBADF;
+		file = fget(ufd);
+		if (!file)
+			goto err_exit;
+		ctx = file->private_data;
+		error = -EINVAL;
+		if (file->f_op != &signalfd_fops) {
+			fput(file);
+			goto err_exit;
+		}
+		if ((sighand = signalfd_get_sighand(ctx, &flags)) != NULL) {
+			ctx->sigmask = sigmask;
+			signalfd_put_sighand(ctx, sighand, &flags);
+		}
+		wake_up(&ctx->wqh);
+		fput(file);
+	}
+
+	return ufd;
+
+err_fdalloc:
+	signalfd_cleanup(ctx);
+err_exit:
+	return error;
+}
+
+
+static void signalfd_cleanup(struct signalfd_ctx *ctx)
+{
+	unsigned long flags;
+	struct sighand_struct *sighand;
+
+	/*
+	 * This is tricky. If the sighand is gone, we do not need to remove
+	 * context from the list, the list itself won't be there anymore.
+	 */
+	if ((sighand = signalfd_get_sighand(ctx, &flags)) != NULL) {
+		list_del(&ctx->lnk);
+		signalfd_put_sighand(ctx, sighand, &flags);
+	}
+	put_task_struct(ctx->tsk);
+	kmem_cache_free(signalfd_ctx_cachep, ctx);
+}
+
+
+static int signalfd_close(struct inode *inode, struct file *file)
+{
+	signalfd_cleanup(file->private_data);
+	return 0;
+}
+
+
+static unsigned int signalfd_poll(struct file *file, poll_table *wait)
+{
+	struct signalfd_ctx *ctx = file->private_data;
+	unsigned int events = 0;
+	unsigned long flags;
+	struct sighand_struct *sighand;
+
+	poll_wait(file, &ctx->wqh, wait);
+
+	/*
+	 * Let the caller get a POLLIN in this case, ala socket recv() when
+	 * the peer disconnect.
+	 */
+	if ((sighand = signalfd_get_sighand(ctx, &flags)) != NULL) {
+		if (next_signal(&ctx->tsk->pending, &ctx->sigmask) > 0 ||
+		    next_signal(&ctx->tsk->signal->shared_pending,
+				&ctx->sigmask) > 0)
+			events |= POLLIN;
+		signalfd_put_sighand(ctx, sighand, &flags);
+	} else
+		events |= POLLIN;
+
+	return events;
+}
+
+
+/*
+ * Copied from copy_siginfo_to_user() in kernel/signal.c
+ */
+static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
+			     siginfo_t const *kinfo)
+{
+	long err;
+
+	err = __clear_user(uinfo, sizeof(*uinfo));
+
+	/*
+	 * If you change siginfo_t structure, please be sure
+	 * this code is fixed accordingly.
+	 */
+	err |= __put_user(kinfo->si_signo, &uinfo->signo);
+	err |= __put_user(kinfo->si_errno, &uinfo->err);
+	err |= __put_user((short)kinfo->si_code, &uinfo->code);
+	switch (kinfo->si_code & __SI_MASK) {
+	case __SI_KILL:
+		err |= __put_user(kinfo->si_pid, &uinfo->pid);
+		err |= __put_user(kinfo->si_uid, &uinfo->uid);
+		break;
+	case __SI_TIMER:
+		 err |= __put_user(kinfo->si_tid, &uinfo->tid);
+		 err |= __put_user(kinfo->si_overrun, &uinfo->overrun);
+		 err |= __put_user(kinfo->si_ptr, &uinfo->svptr);
+		break;
+	case __SI_POLL:
+		err |= __put_user(kinfo->si_band, &uinfo->band);
+		err |= __put_user(kinfo->si_fd, &uinfo->fd);
+		break;
+	case __SI_FAULT:
+		err |= __put_user(kinfo->si_addr, &uinfo->addr);
+#ifdef __ARCH_SI_TRAPNO
+		err |= __put_user(kinfo->si_trapno, &uinfo->trapno);
+#endif
+		break;
+	case __SI_CHLD:
+		err |= __put_user(kinfo->si_pid, &uinfo->pid);
+		err |= __put_user(kinfo->si_uid, &uinfo->uid);
+		err |= __put_user(kinfo->si_status, &uinfo->status);
+		err |= __put_user(kinfo->si_utime, &uinfo->utime);
+		err |= __put_user(kinfo->si_stime, &uinfo->stime);
+		break;
+	case __SI_RT: /* This is not generated by the kernel as of now. */
+	case __SI_MESGQ: /* But this is */
+		err |= __put_user(kinfo->si_pid, &uinfo->pid);
+		err |= __put_user(kinfo->si_uid, &uinfo->uid);
+		err |= __put_user(kinfo->si_ptr, &uinfo->svptr);
+		break;
+	default: /* this is just in case for now ... */
+		err |= __put_user(kinfo->si_pid, &uinfo->pid);
+		err |= __put_user(kinfo->si_uid, &uinfo->uid);
+		break;
+	}
+
+	return err ? -EFAULT: sizeof(*uinfo);
+}
+
+
+static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
+			     loff_t *ppos)
+{
+	struct signalfd_ctx *ctx = file->private_data;
+	ssize_t res = 0;
+	int signo;
+	unsigned long flags;
+	struct sighand_struct *sighand;
+	siginfo_t info;
+	DECLARE_WAITQUEUE(wait, current);
+
+	if (count < sizeof(struct signalfd_siginfo))
+		return -EINVAL;
+	if ((sighand = signalfd_get_sighand(ctx, &flags)) == NULL)
+		return 0;
+	res = -EAGAIN;
+	if ((signo = dequeue_signal(ctx->tsk, &ctx->sigmask, &info)) == 0 &&
+	    !(file->f_flags & O_NONBLOCK)) {
+		add_wait_queue(&ctx->wqh, &wait);
+		for (;;) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			if ((signo = dequeue_signal(ctx->tsk, &ctx->sigmask,
+						    &info)) != 0)
+				break;
+			if (signal_pending(current)) {
+				res = -ERESTARTSYS;
+				break;
+			}
+			signalfd_put_sighand(ctx, sighand, &flags);
+			schedule();
+			if (unlikely((sighand =
+				      signalfd_get_sighand(ctx, &flags)) == NULL)) {
+				/*
+				 * Let the caller read zero byte, ala socket recv()
+				 * when the peer disconnect. This test must be done
+				 * before doing a dequeue_signal(), because if the
+				 * sighand has been orphaned, the dequeue_signal()
+				 * call is going to crash.
+				 */
+				res = 0;
+				break;
+			}
+		}
+		remove_wait_queue(&ctx->wqh, &wait);
+		__set_current_state(TASK_RUNNING);
+	}
+	if (likely(sighand))
+		signalfd_put_sighand(ctx, sighand, &flags);
+	if (likely(signo))
+		res = signalfd_copyinfo((struct signalfd_siginfo __user *) buf,
+					&info);
+
+	return res;
+}
+
+
+static int __init signalfd_init(void)
+{
+	signalfd_ctx_cachep = kmem_cache_create("signalfd_ctx_cache",
+						sizeof(struct signalfd_ctx),
+						0, SLAB_PANIC, NULL, NULL);
+	return 0;
+}
+
+
+static void __exit signalfd_exit(void)
+{
+	kmem_cache_destroy(signalfd_ctx_cachep);
+}
+
+module_init(signalfd_init);
+module_exit(signalfd_exit);
+
+MODULE_LICENSE("GPL");
Index: linux-2.6.21-rc3.quilt/include/linux/init_task.h
===================================================================
--- linux-2.6.21-rc3.quilt.orig/include/linux/init_task.h	2007-03-15 15:19:22.000000000 -0700
+++ linux-2.6.21-rc3.quilt/include/linux/init_task.h	2007-03-15 15:33:52.000000000 -0700
@@ -84,6 +84,7 @@
 	.count		= ATOMIC_INIT(1), 				\
 	.action		= { { { .sa_handler = NULL, } }, },		\
 	.siglock	= __SPIN_LOCK_UNLOCKED(sighand.siglock),	\
+	.sfdlist	= LIST_HEAD_INIT(sighand.sfdlist),		\
 }
 
 extern struct group_info init_groups;
Index: linux-2.6.21-rc3.quilt/include/linux/sched.h
===================================================================
--- linux-2.6.21-rc3.quilt.orig/include/linux/sched.h	2007-03-15 15:19:22.000000000 -0700
+++ linux-2.6.21-rc3.quilt/include/linux/sched.h	2007-03-15 15:33:52.000000000 -0700
@@ -379,6 +379,7 @@
 	atomic_t		count;
 	struct k_sigaction	action[_NSIG];
 	spinlock_t		siglock;
+	struct list_head        sfdlist;
 };
 
 struct pacct_struct {
Index: linux-2.6.21-rc3.quilt/kernel/fork.c
===================================================================
--- linux-2.6.21-rc3.quilt.orig/kernel/fork.c	2007-03-15 15:19:22.000000000 -0700
+++ linux-2.6.21-rc3.quilt/kernel/fork.c	2007-03-15 15:33:52.000000000 -0700
@@ -1424,8 +1424,10 @@
 	struct sighand_struct *sighand = data;
 
 	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-					SLAB_CTOR_CONSTRUCTOR)
+					SLAB_CTOR_CONSTRUCTOR) {
 		spin_lock_init(&sighand->siglock);
+		INIT_LIST_HEAD(&sighand->sfdlist);
+	}
 }
 
 void __init proc_caches_init(void)
Index: linux-2.6.21-rc3.quilt/include/linux/syscalls.h
===================================================================
--- linux-2.6.21-rc3.quilt.orig/include/linux/syscalls.h	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.21-rc3.quilt/include/linux/syscalls.h	2007-03-15 15:33:52.000000000 -0700
@@ -602,6 +602,7 @@
 asmlinkage long sys_set_robust_list(struct robust_list_head __user *head,
 				    size_t len);
 asmlinkage long sys_getcpu(unsigned __user *cpu, unsigned __user *node, struct getcpu_cache __user *cache);
+asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
Index: linux-2.6.21-rc3.quilt/fs/Makefile
===================================================================
--- linux-2.6.21-rc3.quilt.orig/fs/Makefile	2007-03-15 15:32:33.000000000 -0700
+++ linux-2.6.21-rc3.quilt/fs/Makefile	2007-03-15 15:33:52.000000000 -0700
@@ -11,7 +11,7 @@
 		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o anon_inodes.o
+		stack.o anon_inodes.o signalfd.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
Index: linux-2.6.21-rc3.quilt/include/linux/signalfd.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21-rc3.quilt/include/linux/signalfd.h	2007-03-15 15:33:52.000000000 -0700
@@ -0,0 +1,62 @@
+/*
+ *  include/linux/signalfd.h
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#ifndef _LINUX_SIGNALFD_H
+#define _LINUX_SIGNALFD_H
+
+
+struct signalfd_siginfo {
+	__u32 signo;
+	__s32 err;
+	__s32 code;
+	__u32 pid;
+	__u32 uid;
+	__s32 fd;
+	__u32 tid;
+	__u32 band;
+	__u32 overrun;
+	__u32 trapno;
+	__s32 status;
+	__s32 svint;
+	__u64 svptr;
+	__u64 utime;
+	__u64 stime;
+	__u64 addr;
+};
+
+
+void signalfd_deliver(struct task_struct *tsk, int sig);
+
+/*
+ * No need to fall inside signalfd_deliver() if no signal listeners are available.
+ */
+static inline void signalfd_notify(struct task_struct *tsk, int sig)
+{
+	if (unlikely(!list_empty(&tsk->sighand->sfdlist)))
+		signalfd_deliver(tsk, sig);
+}
+
+static inline void signalfd_detach_locked(struct task_struct *tsk)
+{
+	if (unlikely(!list_empty(&tsk->sighand->sfdlist)))
+		signalfd_deliver(tsk, -1);
+}
+
+static inline void signalfd_detach(struct task_struct *tsk)
+{
+	struct sighand_struct *sighand = tsk->sighand;
+
+	if (unlikely(!list_empty(&sighand->sfdlist))) {
+		spin_lock_irq(&sighand->siglock);
+		signalfd_deliver(tsk, -1);
+		spin_unlock_irq(&sighand->siglock);
+	}
+}
+
+
+#endif /* _LINUX_SIGNALFD_H */
+
Index: linux-2.6.21-rc3.quilt/kernel/signal.c
===================================================================
--- linux-2.6.21-rc3.quilt.orig/kernel/signal.c	2007-03-15 15:19:22.000000000 -0700
+++ linux-2.6.21-rc3.quilt/kernel/signal.c	2007-03-15 15:33:52.000000000 -0700
@@ -26,6 +26,7 @@
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
 #include <linux/nsproxy.h>
+#include <linux/signalfd.h>
 
 #include <asm/param.h>
 #include <asm/uaccess.h>
@@ -233,8 +234,7 @@
 
 /* Given the mask, find the first available signal that should be serviced. */
 
-static int
-next_signal(struct sigpending *pending, sigset_t *mask)
+int next_signal(struct sigpending *pending, sigset_t *mask)
 {
 	unsigned long i, *s, *m, x;
 	int sig = 0;
@@ -740,6 +740,12 @@
 	int ret = 0;
 
 	/*
+	 * Deliver the signal to listening signalfds. This must be called
+	 * with the sighand lock held.
+	 */
+	signalfd_notify(t, sig);
+
+	/*
 	 * fast-pathed signals for kernel-internal things like SIGSTOP
 	 * or SIGKILL.
 	 */
@@ -1401,6 +1407,11 @@
 		ret = 1;
 		goto out;
 	}
+	/*
+	 * Deliver the signal to listening signalfds. This must be called
+	 * with the sighand lock held.
+	 */
+	signalfd_notify(p, sig);
 
 	list_add_tail(&q->list, &p->pending.list);
 	sigaddset(&p->pending.signal, sig);
@@ -1444,6 +1455,11 @@
 		q->info.si_overrun++;
 		goto out;
 	} 
+	/*
+	 * Deliver the signal to listening signalfds. This must be called
+	 * with the sighand lock held.
+	 */
+	signalfd_notify(p, sig);
 
 	/*
 	 * Put this signal on the shared-pending queue.
@@ -2104,6 +2120,8 @@
 	/*
 	 * If you change siginfo_t structure, please be sure
 	 * this code is fixed accordingly.
+	 * Please remember to update the signalfd_copyinfo() function
+	 * inside fs/signalfd.c too, in case siginfo_t changes.
 	 * It should never copy any pad contained in the structure
 	 * to avoid security leaks, but must copy the generic
 	 * 3 ints plus the relevant union member.
Index: linux-2.6.21-rc3.quilt/fs/exec.c
===================================================================
--- linux-2.6.21-rc3.quilt.orig/fs/exec.c	2007-03-15 15:19:22.000000000 -0700
+++ linux-2.6.21-rc3.quilt/fs/exec.c	2007-03-15 15:33:52.000000000 -0700
@@ -50,6 +50,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
+#include <linux/signalfd.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -581,6 +582,13 @@
 	int count;
 
 	/*
+	 * Tell all the sighand listeners that this sighand has
+	 * been detached. The signalfd_detach() function grabs the
+	 * sighand lock, if signal listeners are present on the sighand.
+	 */
+	signalfd_detach(tsk);
+
+	/*
 	 * If we don't share sighandlers, then we aren't sharing anything
 	 * and we can just re-use it all.
 	 */
@@ -756,8 +764,7 @@
 		spin_unlock(&oldsighand->siglock);
 		write_unlock_irq(&tasklist_lock);
 
-		if (atomic_dec_and_test(&oldsighand->count))
-			kmem_cache_free(sighand_cachep, oldsighand);
+		__cleanup_sighand(oldsighand);
 	}
 
 	BUG_ON(!thread_group_leader(tsk));
Index: linux-2.6.21-rc3.quilt/kernel/exit.c
===================================================================
--- linux-2.6.21-rc3.quilt.orig/kernel/exit.c	2007-03-15 15:19:22.000000000 -0700
+++ linux-2.6.21-rc3.quilt/kernel/exit.c	2007-03-15 15:33:52.000000000 -0700
@@ -42,6 +42,7 @@
 #include <linux/audit.h> /* for audit_free() */
 #include <linux/resource.h>
 #include <linux/blkdev.h>
+#include <linux/signalfd.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -82,6 +83,14 @@
 	sighand = rcu_dereference(tsk->sighand);
 	spin_lock(&sighand->siglock);
 
+	/*
+	 * Notify that this sighand has been detached. This must
+	 * be called with the tsk->sighand lock held. Also, this
+	 * access tsk->sighand internally, so it must be called
+	 * before tsk->sighand is reset.
+	 */
+	signalfd_detach_locked(tsk);
+
 	posix_cpu_timers_exit(tsk);
 	if (atomic_dec_and_test(&sig->count))
 		posix_cpu_timers_exit_group(tsk);
Index: linux-2.6.21-rc3.quilt/include/linux/signal.h
===================================================================
--- linux-2.6.21-rc3.quilt.orig/include/linux/signal.h	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.21-rc3.quilt/include/linux/signal.h	2007-03-15 15:33:52.000000000 -0700
@@ -233,6 +233,7 @@
 	return sig <= _NSIG ? 1 : 0;
 }
 
+extern int next_signal(struct sigpending *pending, sigset_t *mask);
 extern int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p);
 extern int __group_send_sig_info(int, struct siginfo *, struct task_struct *);
 extern long do_sigpending(void __user *, unsigned long);


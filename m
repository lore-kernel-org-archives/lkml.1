Return-Path: <linux-kernel-owner+w=401wt.eu-S932569AbXCGBhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbXCGBhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 20:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932687AbXCGBhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 20:37:01 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42315 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbXCGBg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 20:36:58 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 6 Mar 2007 17:36:56 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 1/4] signalfd v1 - signalfd core ...
Message-ID: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch series implements a new signalfd() system call. I took part of 
the original Linus code (and you know how badly it can be broken :), and I 
added even more breakage ;)
The patch had to be almost completely changed. This patch allows multiple 
signalfd to listen for signals on the same sighand, w/out raing with 
dequeue_signal. Plus other changes that I don't remember (see here for the 
original patch http://tinyurl.com/3yuna5 ).
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
Note that signalfd delivery and standard signal delivery can go in 
parallel. So you can receive signals on the signalfd file, and on the 
signal handlers. This makes the system more flexible IMO. If you don't 
want to see standard delivery, just pass the same "mask" to 
sigprocmask(SIG_BLOCK).
The signalfd fd supports poll(2) and read(2). The poll(2) will return 
POLLIN when signals are available to be dequeued.
The read(2) call will read u32 signal numbers that landed over the 
signalfd. It returns the size of the data copied, or zero if the sighand 
we are attached to, has been detached.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>



- Davide



fs/Makefile               |    2 
fs/exec.c                 |   12 +
fs/signalfd.c             |  293 ++++++++++++++++++++++++++++++++++++++++++++++
include/linux/init_task.h |    1 
include/linux/sched.h     |    1 
include/linux/signalfd.h  |   26 ++++
include/linux/syscalls.h  |    1 
kernel/exit.c             |    5 
kernel/fork.c             |    4 
kernel/signal.c           |   11 +
10 files changed, 352 insertions(+), 4 deletions(-)



Index: linux-2.6.20.ep2/fs/signalfd.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.20.ep2/fs/signalfd.c	2007-03-06 15:47:55.000000000 -0800
@@ -0,0 +1,293 @@
+/*
+ *  fs/signalfd.c
+ *
+ *  Copyright (C) 2003  Linus Torvalds
+ *
+ *  Mon Mar 5, 2007: Davide Libenzi <davidel@xmailserver.org>
+ *      Changed signal delivery and de-queueing.
+ *      Now using anonymous inode source.
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
+	sigset_t pending;
+	struct task_struct *tsk;
+	struct sighand_struct *sighand;
+};
+
+
+static void signalfd_cleanup(struct signalfd_ctx *ctx);
+static int signalfd_close(struct inode *inode, struct file *file);
+static unsigned int signalfd_poll(struct file *filp, poll_table *wait);
+static unsigned int signalfd_dequeue(struct signalfd_ctx *ctx);
+static ssize_t signalfd_read(struct file *filp, char *buf, size_t count, loff_t *ppos);
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
+/*
+ * This must be called with the sighand lock held.
+ */
+int signalfd_deliver(struct sighand_struct *sighand, int sig)
+{
+	int nsig = 0;
+	struct list_head *pos;
+	struct signalfd_ctx *ctx;
+
+	list_for_each(pos, &sighand->sfdlist) {
+		ctx = list_entry(pos, struct signalfd_ctx, lnk);
+		/*
+		 * We use a negative signal value as a way to broadcast that the
+		 * sighand has been orphaned, so that we can notify all the
+		 * listeners about this.
+		 */
+		if (sig < 0)
+			__wake_up_locked(&ctx->wqh, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE);
+		else if (sigismember(&ctx->sigmask, sig)) {
+			sigaddset(&ctx->pending, sig);
+			__wake_up_locked(&ctx->wqh, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE);
+			nsig++;
+		}
+	}
+
+	return nsig;
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
+	sigset_t sigmask;
+	struct signalfd_ctx *ctx;
+	struct file *file;
+	struct inode *inode;
+
+	error = -EINVAL;
+	if (sizemask != sizeof(sigset_t) ||
+	    copy_from_user(&sigmask, user_mask, sizeof(sigmask)))
+		goto err_exit;
+	sigdelsetmask(&sigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
+
+	if (ufd == -1) {
+		error = -ENOMEM;
+		ctx = kmem_cache_alloc(signalfd_ctx_cachep, GFP_KERNEL);
+		if (!ctx)
+			goto err_exit;
+
+		init_waitqueue_head(&ctx->wqh);
+		memset(&ctx->pending, 0, sizeof(ctx->pending));
+		ctx->sigmask = sigmask;
+		ctx->tsk = current;
+		get_task_struct(current);
+
+		/*
+		 * We also increment the sighand count to make sure
+		 * it doesn't go away from us in poll() when the task
+		 * exits (which can happen if the fd is passed to
+		 * another process with unix domain sockets.
+		 *
+		 * This also guarantees that an execve() will reallocate
+		 * the signal state, and thus avoids security concerns
+		 * with a untrusted process that passes off the signal
+		 * queue fd to another, and then does a suid execve.
+		 */
+		ctx->sighand = current->sighand;
+		atomic_inc(&ctx->sighand->count);
+
+		/*
+		 * Add this fd to the list of signal listeners.
+		 */
+		spin_lock_irq(&ctx->sighand->siglock);
+		list_add_tail(&ctx->lnk, &ctx->sighand->sfdlist);
+		spin_unlock_irq(&ctx->sighand->siglock);
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
+		spin_lock_irq(&ctx->sighand->siglock);
+		ctx->sigmask = sigmask;
+		spin_unlock_irq(&ctx->sighand->siglock);
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
+	spin_lock_irq(&ctx->sighand->siglock);
+	list_del(&ctx->lnk);
+	spin_unlock_irq(&ctx->sighand->siglock);
+	__cleanup_sighand(ctx->sighand);
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
+static unsigned int signalfd_poll(struct file *filp, poll_table *wait)
+{
+	struct signalfd_ctx *ctx = filp->private_data;
+	int i;
+	unsigned long const *pending, *mask;
+
+	poll_wait(filp, &ctx->wqh, wait);
+
+	/*
+	 * Let the caller get a POLLIN in this case, ala socket recv() when
+	 * the peer disconnect.
+	 */
+	if (ctx->sighand != ctx->tsk->sighand)
+		return POLLIN;
+
+	pending = ctx->pending.sig;
+	mask = ctx->sigmask.sig;
+	for (i = 0; i < _NSIG_WORDS; i++, pending++, mask++)
+		if (*pending & *mask)
+			break;
+
+	return i == _NSIG_WORDS ? 0: POLLIN;
+}
+
+
+static unsigned int signalfd_dequeue(struct signalfd_ctx *ctx)
+{
+	int i, bsig;
+	unsigned long isig;
+	unsigned long *pending, *mask;
+
+	pending = ctx->pending.sig;
+	mask = ctx->sigmask.sig;
+	for (i = 0; i < _NSIG_WORDS; i++, pending++, mask++) {
+		if ((isig = *pending & *mask) != 0) {
+			bsig = ffz(~isig);
+			*pending &= ~(1UL << bsig);
+			return bsig + i * _NSIG_BPW + 1;
+		}
+	}
+	return 0;
+}
+
+
+static ssize_t signalfd_read(struct file *filp, char *buf, size_t count, loff_t *ppos)
+{
+	struct signalfd_ctx *ctx = filp->private_data;
+	struct sighand_struct *sighand = ctx->sighand;
+	int res;
+	u32 signr;
+	DECLARE_WAITQUEUE(wait, current);
+
+	if (count < sizeof(signr))
+		return -EINVAL;
+	count = sizeof(signr);
+	spin_lock_irq(&sighand->siglock);
+	__add_wait_queue(&ctx->wqh, &wait);
+	for (res = 0;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		if ((signr = (u32) signalfd_dequeue(ctx)) != 0)
+			break;
+		if (sighand != ctx->tsk->sighand) {
+			/*
+			 * Let the caller read zero byte, ala socket recv() when
+			 * the peer disconnect.
+			 */
+			count = 0;
+			break;
+		}
+		if (signal_pending(current)) {
+			res = -EINTR;
+			break;
+		}
+		spin_unlock_irq(&sighand->siglock);
+		schedule();
+		spin_lock_irq(&sighand->siglock);
+	}
+	__remove_wait_queue(&ctx->wqh, &wait);
+	set_current_state(TASK_RUNNING);
+	spin_unlock_irq(&sighand->siglock);
+	if (res)
+		return res;
+	if (count && put_user(signr, buf))
+		count = -EFAULT;
+	return count;
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
Index: linux-2.6.20.ep2/include/linux/init_task.h
===================================================================
--- linux-2.6.20.ep2.orig/include/linux/init_task.h	2007-03-06 11:09:00.000000000 -0800
+++ linux-2.6.20.ep2/include/linux/init_task.h	2007-03-06 11:12:34.000000000 -0800
@@ -84,6 +84,7 @@
 	.count		= ATOMIC_INIT(1), 				\
 	.action		= { { { .sa_handler = NULL, } }, },		\
 	.siglock	= __SPIN_LOCK_UNLOCKED(sighand.siglock),	\
+	.sfdlist	= LIST_HEAD_INIT(sighand.sfdlist),		\
 }
 
 extern struct group_info init_groups;
Index: linux-2.6.20.ep2/include/linux/sched.h
===================================================================
--- linux-2.6.20.ep2.orig/include/linux/sched.h	2007-03-06 11:09:00.000000000 -0800
+++ linux-2.6.20.ep2/include/linux/sched.h	2007-03-06 11:12:34.000000000 -0800
@@ -379,6 +379,7 @@
 	atomic_t		count;
 	struct k_sigaction	action[_NSIG];
 	spinlock_t		siglock;
+	struct list_head        sfdlist;
 };
 
 struct pacct_struct {
Index: linux-2.6.20.ep2/kernel/fork.c
===================================================================
--- linux-2.6.20.ep2.orig/kernel/fork.c	2007-03-06 11:09:00.000000000 -0800
+++ linux-2.6.20.ep2/kernel/fork.c	2007-03-06 11:12:34.000000000 -0800
@@ -1422,8 +1422,10 @@
 	struct sighand_struct *sighand = data;
 
 	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-					SLAB_CTOR_CONSTRUCTOR)
+					SLAB_CTOR_CONSTRUCTOR) {
 		spin_lock_init(&sighand->siglock);
+		INIT_LIST_HEAD(&sighand->sfdlist);
+	}
 }
 
 void __init proc_caches_init(void)
Index: linux-2.6.20.ep2/include/linux/syscalls.h
===================================================================
--- linux-2.6.20.ep2.orig/include/linux/syscalls.h	2007-03-06 11:09:00.000000000 -0800
+++ linux-2.6.20.ep2/include/linux/syscalls.h	2007-03-06 12:08:47.000000000 -0800
@@ -602,6 +602,7 @@
 asmlinkage long sys_set_robust_list(struct robust_list_head __user *head,
 				    size_t len);
 asmlinkage long sys_getcpu(unsigned __user *cpu, unsigned __user *node, struct getcpu_cache __user *cache);
+asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
Index: linux-2.6.20.ep2/fs/Makefile
===================================================================
--- linux-2.6.20.ep2.orig/fs/Makefile	2007-03-06 11:12:23.000000000 -0800
+++ linux-2.6.20.ep2/fs/Makefile	2007-03-06 11:12:34.000000000 -0800
@@ -11,7 +11,7 @@
 		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o anon_inodes.o
+		stack.o anon_inodes.o signalfd.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
Index: linux-2.6.20.ep2/include/linux/signalfd.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.20.ep2/include/linux/signalfd.h	2007-03-06 11:12:34.000000000 -0800
@@ -0,0 +1,26 @@
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
+int signalfd_deliver(struct sighand_struct *sighand, int sig);
+
+/*
+ * No need to fall inside signalfd_deliver() and get/release a spinlock,
+ * if no signal listeners are available.
+ */
+static inline int signalfd_notify(struct sighand_struct *sighand, int sig)
+{
+	if (likely(list_empty(&sighand->sfdlist)))
+		return 0;
+	return signalfd_deliver(sighand, sig);
+}
+
+#endif /* _LINUX_SIGNALFD_H */
+
Index: linux-2.6.20.ep2/kernel/signal.c
===================================================================
--- linux-2.6.20.ep2.orig/kernel/signal.c	2007-03-06 11:09:00.000000000 -0800
+++ linux-2.6.20.ep2/kernel/signal.c	2007-03-06 11:12:34.000000000 -0800
@@ -26,6 +26,7 @@
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
 #include <linux/nsproxy.h>
+#include <linux/signalfd.h>
 
 #include <asm/param.h>
 #include <asm/uaccess.h>
@@ -780,6 +781,11 @@
 	BUG_ON(!irqs_disabled());
 	assert_spin_locked(&t->sighand->siglock);
 
+	/*
+	 * Deliver the signal to listening signalfds ...
+	 */
+	signalfd_notify(t->sighand, sig);
+
 	/* Short-circuit ignored signals.  */
 	if (sig_ignored(t, sig))
 		goto out;
@@ -968,6 +974,11 @@
 	assert_spin_locked(&p->sighand->siglock);
 	handle_stop_signal(sig, p);
 
+	/*
+	 * Deliver the signal to listening signalfds ...
+	 */
+	signalfd_notify(p->sighand, sig);
+
 	/* Short-circuit ignored signals.  */
 	if (sig_ignored(p, sig))
 		return ret;
Index: linux-2.6.20.ep2/fs/exec.c
===================================================================
--- linux-2.6.20.ep2.orig/fs/exec.c	2007-03-06 11:09:00.000000000 -0800
+++ linux-2.6.20.ep2/fs/exec.c	2007-03-06 13:35:11.000000000 -0800
@@ -50,6 +50,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
+#include <linux/signalfd.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -755,11 +756,18 @@
 		recalc_sigpending();
 
 		spin_unlock(&newsighand->siglock);
+
+		/*
+		 * Tell all the sighand listeners that this sighand has
+		 * been detached. Needs to be called with the sighand lock
+		 * held.
+		 */
+		signalfd_notify(oldsighand, -1);
+
 		spin_unlock(&oldsighand->siglock);
 		write_unlock_irq(&tasklist_lock);
 
-		if (atomic_dec_and_test(&oldsighand->count))
-			kmem_cache_free(sighand_cachep, oldsighand);
+		__cleanup_sighand(oldsighand);
 	}
 
 	BUG_ON(!thread_group_leader(tsk));
Index: linux-2.6.20.ep2/kernel/exit.c
===================================================================
--- linux-2.6.20.ep2.orig/kernel/exit.c	2007-03-06 12:56:22.000000000 -0800
+++ linux-2.6.20.ep2/kernel/exit.c	2007-03-06 13:34:42.000000000 -0800
@@ -42,6 +42,7 @@
 #include <linux/audit.h> /* for audit_free() */
 #include <linux/resource.h>
 #include <linux/blkdev.h>
+#include <linux/signalfd.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -120,6 +121,10 @@
 
 	tsk->signal = NULL;
 	tsk->sighand = NULL;
+	/*
+	 * Notify that this sighand has been detached.
+	 */
+	signalfd_notify(sighand, -1);
 	spin_unlock(&sighand->siglock);
 	rcu_read_unlock();
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbXC3Tkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbXC3Tkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbXC3Tkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:40:52 -0400
Received: from smtp.osdl.org ([65.172.181.24]:50113 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbXC3Tka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:40:30 -0400
Date: Fri, 30 Mar 2007 12:39:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch 2/13] signal/timer/event fds v7 - signalfd core ...
Message-Id: <20070330123954.93993c4d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703271506080.5424@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703271506080.5424@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I couldn't find signalfd core v8 on lkml, so let's look at v7

On Tue, 27 Mar 2007 15:09:07 -0700 (PDT)
Davide Libenzi <davidel@xmailserver.org> wrote:

> This patch series implements the new signalfd() system call.
> I took part of the original Linus code (and you know how
> badly it can be broken :), and I added even more breakage ;)
> Signals are fetched from the same signal queue used by the process,
> so signalfd will compete with standard kernel delivery in dequeue_signal().
> If you want to reliably fetch signals on the signalfd file, you need to
> block them with sigprocmask(SIG_BLOCK).
> This seems to be working fine on my Dual Opteron machine. I made a quick 
> test program for it:
> 
> http://www.xmailserver.org/signafd-test.c
> 
> The signalfd() system call implements signal delivery into a file 
> descriptor receiver. The signalfd file descriptor if created with the 
> following API:
> 
> int signalfd(int ufd, const sigset_t *mask, size_t masksize);
> 
> The "ufd" parameter allows to change an existing signalfd sigmask, w/out 
> going to close/create cycle (Linus idea). Use "ufd" == -1 if you want a 
> brand new signalfd file.
> The "mask" allows to specify the signal mask of signals that we are 
> interested in. The "masksize" parameter is the size of "mask".
> The signalfd fd supports the poll(2) and read(2) system calls. The poll(2)
> will return POLLIN when signals are available to be dequeued. As a direct
> consequence of supporting the Linux poll subsystem, the signalfd fd can use
> used together with epoll(2) too.
> The read(2) system call will return a "struct signalfd_siginfo" structure
> in the userspace supplied buffer. The return value is the number of bytes
> copied in the supplied buffer, or -1 in case of error. The read(2) call
> can also return 0, in case the sighand structure to which the signalfd
> was attached, has been orphaned. The O_NONBLOCK flag is also supported, and
> read(2) will return -EAGAIN in case no signal is available.
> The format of the struct signalfd_siginfo is, and the valid fields depends
> of the (->code & __SI_MASK) value, in the same way a struct siginfo would:
> 
> struct signalfd_siginfo {
> 	__u32 signo;	/* si_signo */
> 	__s32 err;	/* si_errno */
> 	__s32 code;	/* si_code */
> 	__u32 pid;	/* si_pid */
> 	__u32 uid;	/* si_uid */
> 	__s32 fd;	/* si_fd */
> 	__u32 tid;	/* si_fd */
> 	__u32 band;	/* si_band */
> 	__u32 overrun;	/* si_overrun */
> 	__u32 trapno;	/* si_trapno */
> 	__s32 status;	/* si_status */
> 	__s32 svint;	/* si_int */
> 	__u64 svptr;	/* si_ptr */
> 	__u64 utime;	/* si_utime */
> 	__u64 stime;	/* si_stime */
> 	__u64 addr;	/* si_addr */
> };
> 

General comments:

- All these patches will be considered a 100% regression by the
  linux-on-a-cellphone people.  What do we have to do to make all of this
  stuff Kconfigurable?

- All this code is moving us toward being able to unify all asynchronous
  event handling under epoll, yes?

  If so, it is a competitor to kevent, only it's coming from the other
  direction.

  I personally find it an attractive competitor, because it is much more
  incremental and is easier from a design POV.  But what are its
  shortcomings wrt kevent?  Do we have a feel for the what the performance
  difference will be?

  Which other kernel subsystems need to be wired up for this approach to
  reach the same level of capability as kevent?

- Some poor schmuck needs to document all this stuff.  Other poor schmucks
  need to program to it, and to develop libraries which talk to it, etc. 
  Other schmucks need to understand and maintain it.  I judge the code and
  the patches to be inadequately documented.

  Apart from general code commentary, which I will point out at the
  relevant sites, I wonder about things like:

  - What are the sharing semantics?

    - Across dup(), dup2() and fork()?

    - If two !CLONE_SIGHAND, CLONE_FS threads are sharing a signalfd and one
      alters its signal mask?

    - If two processes are sharing a signalfd across fork() and one
      alters its signal mask or something?

  - What are the effects upon the signalfd if the process alters its
    signal state?

  - What happens if a task has multiple signalfds open?  Does one
    signal get delivered to all of the fds?


  IMO all combinations and permutations should be documented for
  posterity and it should be done now so we can review this design.

  Because my next question is "What do Ulrich and co think of these
  interfaces", but I'm not sure that we're ready to take it to them yet.

  Similar observations apply to timerfd and maybe eventfd.

  Please cc Michael Kerrisk <mtk-manpages@gmx.net> (aka "poor schmuck
  #1") on future patches as Michael is hopefully the person who will be
  documenting these interfaces and he has a habit of discovering
  interesting shortcomings when he does that.

> 
> Index: linux-2.6.21-rc5.quilt/fs/signalfd.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.21-rc5.quilt/fs/signalfd.c	2007-03-26 13:21:42.000000000 -0700
> @@ -0,0 +1,348 @@
> +/*
> + *  fs/signalfd.c
> + *
> + *  Copyright (C) 2003  Linus Torvalds
> + *
> + *  Mon Mar 5, 2007: Davide Libenzi <davidel@xmailserver.org>
> + *      Changed ->read() to return a siginfo strcture instead of signal number.
> + *      Fixed locking in ->poll().
> + *      Added sighand-detach notification.
> + *      Added fd re-use in sys_signalfd() syscall.
> + *      Now using anonymous inode source.
> + *      Thanks to Oleg Nesterov for useful code review and suggestions.
> + *      More comments and suggestions from Arnd Bergmann.
> + */
> +
> +#include <linux/file.h>
> +#include <linux/poll.h>
> +#include <linux/slab.h>
> +#include <linux/init.h>
> +#include <linux/fs.h>
> +#include <linux/mount.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/signal.h>
> +#include <linux/list.h>
> +#include <linux/anon_inodes.h>
> +#include <linux/signalfd.h>
> +
> +#include <asm/uaccess.h>
> +
> +
> +

nuke random blank lines.

> +struct signalfd_ctx {
> +	struct list_head lnk;
> +	wait_queue_head_t wqh;
> +	sigset_t sigmask;
> +	struct task_struct *tsk;
> +};
> +
> +struct signalfd_lockctx {
> +	struct task_struct *tsk;
> +	unsigned long flags;
> +};
> +
> +
> +static int signalfd_lock(struct signalfd_ctx *ctx, struct signalfd_lockctx *lk);
> +static void signalfd_unlock(struct signalfd_lockctx *lk);
> +static void signalfd_cleanup(struct signalfd_ctx *ctx);
> +static int signalfd_close(struct inode *inode, struct file *file);
> +static unsigned int signalfd_poll(struct file *file, poll_table *wait);
> +static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
> +			     siginfo_t const *kinfo);

`cosnt siginfo_t *', please.

I dunno, I find all these forward declarations to be a fugly waste of
space, and a maintenance hassle.  I think a lot of them can be made to go
away with some very simple code reorganisations.


> +static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
> +			     loff_t *ppos);
> +
> +
> +
> +static const struct file_operations signalfd_fops = {
> +	.release	= signalfd_close,

Please rename signalfd_close to signalfd_release.

> +	.poll		= signalfd_poll,
> +	.read		= signalfd_read,
> +};
> +
> +
> +

trim these

> +static int signalfd_lock(struct signalfd_ctx *ctx, struct signalfd_lockctx *lk)
> +{
> +	struct sighand_struct *sighand = NULL;
> +
> +	rcu_read_lock();
> +	lk->tsk = rcu_dereference(ctx->tsk);
> +	if (likely(lk->tsk != NULL))
> +		sighand = lock_task_sighand(lk->tsk, &lk->flags);
> +	rcu_read_unlock();
> +
> +	if (sighand && !ctx->tsk) {
> +		unlock_task_sighand(lk->tsk, &lk->flags);
> +		sighand = NULL;
> +	}
> +
> +	return sighand != NULL;
> +}

This function needs documentation - it really is quite obscure.  What does
its return value mean?  Why does it sometimes do lock_task_sighand() and
sometimes does not?  I assume that it's handling exitted tasks in some
fashion but it it is not at all clear.

> +static void signalfd_unlock(struct signalfd_lockctx *lk)
> +{
> +	unlock_task_sighand(lk->tsk, &lk->flags);
> +}

If lk->task can be NULL in signalfd_lock(), how come it cannot be NULL
here?  Because tsk->sighand->siglock prevents the task from exitting?  Some
commentary describing the synchronisation design here would be useful.

> +/*
> + * This must be called with the sighand lock held.
> + */

What does it do?

> +void signalfd_deliver(struct task_struct *tsk, int sig)
> +{
> +	struct sighand_struct *sighand = tsk->sighand;
> +	struct signalfd_ctx *ctx, *tmp;
> +
> +	BUG_ON(!sig);
> +	list_for_each_entry_safe(ctx, tmp, &sighand->sfdlist, lnk) {
> +		/*
> +		 * We use a negative signal value as a way to broadcast that the
> +		 * sighand has been orphaned, so that we can notify all the

Is the term "orphaned" defined anywhere?

> +		 * listeners about this. Remeber the ctx->sigmask is inverted,

s/Remeber/Remember/

> +		 * so if the user is interested in a signal, that corresponding
> +		 * bit will be zero.
> +		 */
> +		if (sig < 0) {
> +			if (ctx->tsk == tsk) {
> +				ctx->tsk = NULL;
> +				list_del_init(&ctx->lnk);
> +				wake_up(&ctx->wqh);
> +			}
> +		} else {
> +			if (!sigismember(&ctx->sigmask, sig))
> +				wake_up(&ctx->wqh);
> +		}
> +	}
> +}
> +
> +/*
> + * Create a file descriptor that is associated with our signal
> + * state. We can pass it around to others if we want to, but
> + * it will always be _our_ signal state.
> + */

Who is "us" here?  The tasks which have this fd open?  The tasks which
share the calling process's sighand_struct?

> +asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask)
> +{
> +	int error;
> +	sigset_t sigmask;
> +	struct signalfd_ctx *ctx;
> +	struct sighand_struct *sighand;
> +	struct file *file;
> +	struct inode *inode;
> +	struct signalfd_lockctx lk;
> +
> +	if (sizemask != sizeof(sigset_t) ||
> +	    copy_from_user(&sigmask, user_mask, sizeof(sigmask)))
> +		return error = -EINVAL;
> +	sigdelsetmask(&sigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
> +	signotset(&sigmask);
> +
> +	if (ufd == -1) {
> +		ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
> +		if (!ctx)
> +			return -ENOMEM;
> +
> +		init_waitqueue_head(&ctx->wqh);
> +		ctx->sigmask = sigmask;
> +		ctx->tsk = current;
> +
> +		sighand = current->sighand;
> +		/*
> +		 * Add this fd to the list of signal listeners.
> +		 */
> +		spin_lock_irq(&sighand->siglock);
> +		list_add_tail(&ctx->lnk, &sighand->sfdlist);
> +		spin_unlock_irq(&sighand->siglock);
> +
> +		/*
> +		 * When we call this, the initialization must be complete, since
> +		 * aino_getfd() will install the fd.
> +		 */
> +		error = aino_getfd(&ufd, &inode, &file, "[signalfd]",
> +				   &signalfd_fops, ctx);
> +		if (error)
> +			goto err_fdalloc;
> +	} else {
> +		file = fget(ufd);
> +		if (!file)
> +			return -EBADF;
> +		ctx = file->private_data;
> +		if (file->f_op != &signalfd_fops) {
> +			fput(file);
> +			return -EINVAL;
> +		}
> +		if (signalfd_lock(ctx, &lk)) {
> +			ctx->sigmask = sigmask;
> +			signalfd_unlock(&lk);
> +		}

For the life of me I can't work out what the above three lines are doing. 
Please add sufficient comments to ensure my survival.

> +		wake_up(&ctx->wqh);
> +		fput(file);
> +	}
> +
> +	return ufd;
> +
> +err_fdalloc:
> +	signalfd_cleanup(ctx);
> +	return error;
> +}
> +
> +static void signalfd_cleanup(struct signalfd_ctx *ctx)
> +{
> +	struct signalfd_lockctx lk;
> +
> +	/*
> +	 * This is tricky. If the sighand is gone, we do not need to remove
> +	 * context from the list, the list itself won't be there anymore.
> +	 */

What chain of circumstances would cause the sighand to be "gone"?

> +	if (signalfd_lock(ctx, &lk)) {
> +		list_del(&ctx->lnk);
> +		signalfd_unlock(&lk);
> +	}
> +	kfree(ctx);
> +}
> +
> +static int signalfd_close(struct inode *inode, struct file *file)
> +{
> +	signalfd_cleanup(file->private_data);
> +	return 0;
> +}
> +
> +static unsigned int signalfd_poll(struct file *file, poll_table *wait)
> +{
> +	struct signalfd_ctx *ctx = file->private_data;
> +	unsigned int events = 0;
> +	struct signalfd_lockctx lk;
> +
> +	poll_wait(file, &ctx->wqh, wait);
> +
> +	/*
> +	 * Let the caller get a POLLIN in this case, ala socket recv() when

In what case?

> +	 * the peer disconnect.

"disconnects"?

> +	 */
> +	if (signalfd_lock(ctx, &lk)) {
> +		if (next_signal(&lk.tsk->pending, &ctx->sigmask) > 0 ||
> +		    next_signal(&lk.tsk->signal->shared_pending,
> +				&ctx->sigmask) > 0)
> +			events |= POLLIN;
> +		signalfd_unlock(&lk);
> +	} else
> +		events |= POLLIN;
> +
> +	return events;
> +}
> +
> +/*
> + * Copied from copy_siginfo_to_user() in kernel/signal.c
> + */

Very much copied.  Can we hoist out some code and share it?

> +static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
> +			     siginfo_t const *kinfo)
> +{
> +	long err;
> +
> +	/*
> +	 * Unused memebers should be zero ...
> +	 */
> +	err = __clear_user(uinfo, sizeof(*uinfo));

Bug.  __clear_user() doesn't return -EFAULT.

I'm looking for an access_ok() and can't find it.  Did we just offer users
a way of reading kernel memory?

> +	/*
> +	 * If you change siginfo_t structure, please be sure
> +	 * this code is fixed accordingly.
> +	 */
> +	err |= __put_user(kinfo->si_signo, &uinfo->signo);
> +	err |= __put_user(kinfo->si_errno, &uinfo->err);
> +	err |= __put_user((short)kinfo->si_code, &uinfo->code);
> +	switch (kinfo->si_code & __SI_MASK) {
> +	case __SI_KILL:
> +		err |= __put_user(kinfo->si_pid, &uinfo->pid);
> +		err |= __put_user(kinfo->si_uid, &uinfo->uid);
> +		break;
> +	case __SI_TIMER:
> +		 err |= __put_user(kinfo->si_tid, &uinfo->tid);
> +		 err |= __put_user(kinfo->si_overrun, &uinfo->overrun);
> +		 err |= __put_user(kinfo->si_ptr, &uinfo->svptr);
> +		break;
> +	case __SI_POLL:
> +		err |= __put_user(kinfo->si_band, &uinfo->band);
> +		err |= __put_user(kinfo->si_fd, &uinfo->fd);
> +		break;
> +	case __SI_FAULT:
> +		err |= __put_user(kinfo->si_addr, &uinfo->addr);
> +#ifdef __ARCH_SI_TRAPNO
> +		err |= __put_user(kinfo->si_trapno, &uinfo->trapno);
> +#endif
> +		break;
> +	case __SI_CHLD:
> +		err |= __put_user(kinfo->si_pid, &uinfo->pid);
> +		err |= __put_user(kinfo->si_uid, &uinfo->uid);
> +		err |= __put_user(kinfo->si_status, &uinfo->status);
> +		err |= __put_user(kinfo->si_utime, &uinfo->utime);
> +		err |= __put_user(kinfo->si_stime, &uinfo->stime);
> +		break;
> +	case __SI_RT: /* This is not generated by the kernel as of now. */
> +	case __SI_MESGQ: /* But this is */
> +		err |= __put_user(kinfo->si_pid, &uinfo->pid);
> +		err |= __put_user(kinfo->si_uid, &uinfo->uid);
> +		err |= __put_user(kinfo->si_ptr, &uinfo->svptr);
> +		break;
> +	default: /* this is just in case for now ... */
> +		err |= __put_user(kinfo->si_pid, &uinfo->pid);
> +		err |= __put_user(kinfo->si_uid, &uinfo->uid);
> +		break;
> +	}
> +
> +	return err ? -EFAULT: sizeof(*uinfo);
> +}
> +
> +static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
> +			     loff_t *ppos)

This function could do with some commentary describing the constraints upon
`count', the semantics of the return value and some description of what it
actually copies into userspace.

lseek doesn't make any sense on this fd, hence signalfd (and eventfd and
timerfd) should be using nonseekable_open(), no?


> +{
> +	struct signalfd_ctx *ctx = file->private_data;
> +	ssize_t res = 0;
> +	int locked, signo;
> +	siginfo_t info;
> +	struct signalfd_lockctx lk;
> +	DECLARE_WAITQUEUE(wait, current);
> +
> +	if (count < sizeof(struct signalfd_siginfo))
> +		return -EINVAL;
> +	if (!(locked = signalfd_lock(ctx, &lk)))

We prefer

	locked = signalfd_lock(ctx, &lk);
	if (locked)

There are many instances of this in the patchset.

> +		return 0;
> +	res = -EAGAIN;
> +	if ((signo = dequeue_signal(lk.tsk, &ctx->sigmask, &info)) == 0 &&
> +	    !(file->f_flags & O_NONBLOCK)) {
> +		add_wait_queue(&ctx->wqh, &wait);

Did you consider using prepare_to_wait()?  It can save a cacheline
transfer when the wakeup is cross-cpu.

> +		for (;;) {
> +			set_current_state(TASK_INTERRUPTIBLE);
> +			if ((signo = dequeue_signal(lk.tsk, &ctx->sigmask,
> +						    &info)) != 0)

Please separate the assignment and the test.

> +				break;
> +			if (signal_pending(current)) {
> +				res = -ERESTARTSYS;
> +				break;
> +			}
> +			signalfd_unlock(&lk);
> +			schedule();
> +			if (unlikely(!(locked = signalfd_lock(ctx, &lk)))) {
	
Please separate the assignment and the test.

> +				/*
> +				 * Let the caller read zero byte, ala socket recv()
> +				 * when the peer disconnect. This test must be done
> +				 * before doing a dequeue_signal(), because if the
> +				 * sighand has been orphaned, the dequeue_signal()
> +				 * call is going to crash.
> +				 */

80 columns, not 83 ;)

> +				res = 0;
> +				break;
> +			}
> +		}
> +		remove_wait_queue(&ctx->wqh, &wait);
> +		__set_current_state(TASK_RUNNING);
> +	}
> +	if (likely(locked))
> +		signalfd_unlock(&lk);
> +	if (likely(signo))
> +		res = signalfd_copyinfo((struct signalfd_siginfo __user *) buf,
> +					&info);
> +
> +	return res;
> +}
> +
> Index: linux-2.6.21-rc5.quilt/include/linux/init_task.h
> ===================================================================
> --- linux-2.6.21-rc5.quilt.orig/include/linux/init_task.h	2007-03-26 13:11:53.000000000 -0700
> +++ linux-2.6.21-rc5.quilt/include/linux/init_task.h	2007-03-26 13:21:42.000000000 -0700
> @@ -84,6 +84,7 @@
>  	.count		= ATOMIC_INIT(1), 				\
>  	.action		= { { { .sa_handler = NULL, } }, },		\
>  	.siglock	= __SPIN_LOCK_UNLOCKED(sighand.siglock),	\
> +	.sfdlist	= LIST_HEAD_INIT(sighand.sfdlist),		\
>  }
>  
>  extern struct group_info init_groups;
> Index: linux-2.6.21-rc5.quilt/include/linux/sched.h
> ===================================================================
> --- linux-2.6.21-rc5.quilt.orig/include/linux/sched.h	2007-03-26 13:11:53.000000000 -0700
> +++ linux-2.6.21-rc5.quilt/include/linux/sched.h	2007-03-26 13:21:42.000000000 -0700
> @@ -379,6 +379,7 @@
>  	atomic_t		count;
>  	struct k_sigaction	action[_NSIG];
>  	spinlock_t		siglock;
> +	struct list_head        sfdlist;

"signalfd_list" would be much clearer.

>  };
>  
> ...
>
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.21-rc5.quilt/include/linux/signalfd.h	2007-03-26 13:21:42.000000000 -0700
> @@ -0,0 +1,71 @@
> +/*
> + *  include/linux/signalfd.h
> + *
> + *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
> + *
> + */
> +
> +#ifndef _LINUX_SIGNALFD_H
> +#define _LINUX_SIGNALFD_H
> +
> +
> +struct signalfd_siginfo {
> +	__u32 signo;
> +	__s32 err;
> +	__s32 code;
> +	__u32 pid;
> +	__u32 uid;
> +	__s32 fd;
> +	__u32 tid;
> +	__u32 band;
> +	__u32 overrun;
> +	__u32 trapno;
> +	__s32 status;
> +	__s32 svint;
> +	__u64 svptr;
> +	__u64 utime;
> +	__u64 stime;
> +	__u64 addr;
> +
> +	/*
> +	 * Pad strcture to 128 bytes. Remember to update the
> +	 * pad size when you add new memebers.

"members"

> +	 */
> +	__u8 __pad[48];
> +};

It would be nice to do it this way:

struct signalfd_info {
	union {
		struct {
			__u32 signo;
			__s32 err;
			...
			__u64 addr;
		};
		char __pad[128];
	};
};

But perhaps the use of anonymous unions and structs will cause problems for
userspace which is using old gcc (but there's a good chance that we've
already gone and done that somewhere else).

We could of course do

struct signalfd_info {
	union {
		struct {
			__u32 signo;
			__s32 err;
			...
			__u64 addr;
		} s;
		char __pad[128];
	} u;
};

but that's such a mouthful that I think I prefer the manually-maintained
__pad[48].

Please add a

	BUILD_BUG_ON(sizeof(struct signalfd_info) != 128);

somewhere.

And please add a comment explaining why this structure needs to have a
fixed size.

> +
> +#ifdef __KERNEL__
> +
> +void signalfd_deliver(struct task_struct *tsk, int sig);
> +
> +/*
> + * No need to fall inside signalfd_deliver() if no signal listeners are available.

80 cols, please.

> + */
> +static inline void signalfd_notify(struct task_struct *tsk, int sig)
> +{
> +	if (unlikely(!list_empty(&tsk->sighand->sfdlist)))
> +		signalfd_deliver(tsk, sig);
> +}

Does signalfd_notify() have locking requirements?


> +static inline void signalfd_detach_locked(struct task_struct *tsk)
> +{
> +	if (unlikely(!list_empty(&tsk->sighand->sfdlist)))
> +		signalfd_deliver(tsk, -1);
> +}
> +
> +static inline void signalfd_detach(struct task_struct *tsk)
> +{
> +	struct sighand_struct *sighand = tsk->sighand;
> +
> +	if (unlikely(!list_empty(&sighand->sfdlist))) {
> +		spin_lock_irq(&sighand->siglock);
> +		signalfd_deliver(tsk, -1);
> +		spin_unlock_irq(&sighand->siglock);
> +	}
> +}

yes, it does.

Are these functions so simple and obvious that they don't require any
description?

> +#endif /* __KERNEL__ */
> +
> +#endif /* _LINUX_SIGNALFD_H */
> +
> Index: linux-2.6.21-rc5.quilt/kernel/signal.c
> ===================================================================
> --- linux-2.6.21-rc5.quilt.orig/kernel/signal.c	2007-03-26 13:11:53.000000000 -0700
> +++ linux-2.6.21-rc5.quilt/kernel/signal.c	2007-03-26 13:21:42.000000000 -0700
> @@ -26,6 +26,7 @@
>  #include <linux/freezer.h>
>  #include <linux/pid_namespace.h>
>  #include <linux/nsproxy.h>
> +#include <linux/signalfd.h>
>  
>  #include <asm/param.h>
>  #include <asm/uaccess.h>
> @@ -233,8 +234,7 @@
>  
>  /* Given the mask, find the first available signal that should be serviced. */
>  
> -static int
> -next_signal(struct sigpending *pending, sigset_t *mask)
> +int next_signal(struct sigpending *pending, sigset_t *mask)
>  {
>  	unsigned long i, *s, *m, x;
>  	int sig = 0;
> @@ -740,6 +740,12 @@
>  	int ret = 0;
>  
>  	/*
> +	 * Deliver the signal to listening signalfds. This must be called
> +	 * with the sighand lock held.
> +	 */

oh, OK.  A funny place to document signalfd_notify() ;)

> +	signalfd_notify(t, sig);
> +
> +	/*
>  	 * fast-pathed signals for kernel-internal things like SIGSTOP
>  	 * or SIGKILL.
>  	 */
> @@ -1401,6 +1407,11 @@
>  		ret = 1;
>  		goto out;
>  	}
> +	/*
> +	 * Deliver the signal to listening signalfds. This must be called
> +	 * with the sighand lock held.
> +	 */
> +	signalfd_notify(p, sig);
>  
>  	list_add_tail(&q->list, &p->pending.list);
>  	sigaddset(&p->pending.signal, sig);
> @@ -1444,6 +1455,11 @@
>  		q->info.si_overrun++;
>  		goto out;
>  	} 
> +	/*
> +	 * Deliver the signal to listening signalfds. This must be called
> +	 * with the sighand lock held.
> +	 */
> +	signalfd_notify(p, sig);

Three times!  Move the commentary to the signalfd_notify() definition site?

>  	/*
>  	 * Put this signal on the shared-pending queue.
> @@ -2104,6 +2120,8 @@
>  	/*
>  	 * If you change siginfo_t structure, please be sure
>  	 * this code is fixed accordingly.
> +	 * Please remember to update the signalfd_copyinfo() function
> +	 * inside fs/signalfd.c too, in case siginfo_t changes.
>  	 * It should never copy any pad contained in the structure
>  	 * to avoid security leaks, but must copy the generic
>  	 * 3 ints plus the relevant union member.
> Index: linux-2.6.21-rc5.quilt/fs/exec.c
> ===================================================================
> --- linux-2.6.21-rc5.quilt.orig/fs/exec.c	2007-03-26 13:11:52.000000000 -0700
> +++ linux-2.6.21-rc5.quilt/fs/exec.c	2007-03-26 13:21:42.000000000 -0700
> @@ -50,6 +50,7 @@
>  #include <linux/tsacct_kern.h>
>  #include <linux/cn_proc.h>
>  #include <linux/audit.h>
> +#include <linux/signalfd.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/mmu_context.h>
> @@ -581,6 +582,13 @@
>  	int count;
>  
>  	/*
> +	 * Tell all the sighand listeners that this sighand has
> +	 * been detached. The signalfd_detach() function grabs the
> +	 * sighand lock, if signal listeners are present on the sighand.
> +	 */
> +	signalfd_detach(tsk);
> +
> +	/*
>  	 * If we don't share sighandlers, then we aren't sharing anything
>  	 * and we can just re-use it all.
>  	 */
> @@ -756,8 +764,7 @@
>  		spin_unlock(&oldsighand->siglock);
>  		write_unlock_irq(&tasklist_lock);
>  
> -		if (atomic_dec_and_test(&oldsighand->count))
> -			kmem_cache_free(sighand_cachep, oldsighand);
> +		__cleanup_sighand(oldsighand);
>  	}
>  
>  	BUG_ON(!thread_group_leader(tsk));
> Index: linux-2.6.21-rc5.quilt/kernel/exit.c
> ===================================================================
> --- linux-2.6.21-rc5.quilt.orig/kernel/exit.c	2007-03-26 13:11:53.000000000 -0700
> +++ linux-2.6.21-rc5.quilt/kernel/exit.c	2007-03-26 13:21:42.000000000 -0700
> @@ -42,6 +42,7 @@
>  #include <linux/audit.h> /* for audit_free() */
>  #include <linux/resource.h>
>  #include <linux/blkdev.h>
> +#include <linux/signalfd.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>
> @@ -82,6 +83,14 @@
>  	sighand = rcu_dereference(tsk->sighand);
>  	spin_lock(&sighand->siglock);
>  
> +	/*
> +	 * Notify that this sighand has been detached. This must
> +	 * be called with the tsk->sighand lock held. Also, this
> +	 * access tsk->sighand internally, so it must be called
> +	 * before tsk->sighand is reset.
> +	 */
> +	signalfd_detach_locked(tsk);

Again, please document your interfaces at the definition site, not at call
site(s).


>  	posix_cpu_timers_exit(tsk);
>  	if (atomic_dec_and_test(&sig->count))
>  		posix_cpu_timers_exit_group(tsk);
> Index: linux-2.6.21-rc5.quilt/include/linux/signal.h
> ===================================================================
> --- linux-2.6.21-rc5.quilt.orig/include/linux/signal.h	2007-02-04 10:44:54.000000000 -0800
> +++ linux-2.6.21-rc5.quilt/include/linux/signal.h	2007-03-26 13:21:42.000000000 -0700
> @@ -233,6 +233,7 @@
>  	return sig <= _NSIG ? 1 : 0;
>  }
>  
> +extern int next_signal(struct sigpending *pending, sigset_t *mask);
>  extern int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p);
>  extern int __group_send_sig_info(int, struct siginfo *, struct task_struct *);
>  extern long do_sigpending(void __user *, unsigned long);
> Index: linux-2.6.21-rc5.quilt/include/linux/Kbuild
> ===================================================================
> --- linux-2.6.21-rc5.quilt.orig/include/linux/Kbuild	2007-03-26 13:11:53.000000000 -0700
> +++ linux-2.6.21-rc5.quilt/include/linux/Kbuild	2007-03-26 13:21:42.000000000 -0700
> @@ -190,6 +190,7 @@
>  unifdef-y += errqueue.h
>  unifdef-y += ethtool.h
>  unifdef-y += eventpoll.h
> +unifdef-y += signalfd.h
>  unifdef-y += ext2_fs.h
>  unifdef-y += ext3_fs.h
>  unifdef-y += fb.h

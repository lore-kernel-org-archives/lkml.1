Return-Path: <linux-kernel-owner+w=401wt.eu-S1751544AbXCQVex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbXCQVex (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 17:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbXCQVex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 17:34:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:55665 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbXCQVew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 17:34:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [patch 2/13] signal/timer/event fds v6 - signalfd core ...
Date: Sat, 17 Mar 2007 22:35:08 +0100
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
References: <send-serie.davidel@xmailserver.org.9367.1174004536.2>
In-Reply-To: <send-serie.davidel@xmailserver.org.9367.1174004536.2>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703172235.09227.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18zfyd3ROqnsfdI7coI3spKR0fmSxW9v9+yTZu
 944k241ELPjafDV+bjvEeFp1OLr3G1HzkJ0OUlfVOE/oDYz/Id
 vRiryz8BAu95oSxf8yQ4Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 March 2007 01:22:15 Davide Libenzi wrote:

> +
> +static struct sighand_struct *signalfd_get_sighand(struct signalfd_ctx
> *ctx, +						   unsigned long *flags);
> +static void signalfd_put_sighand(struct signalfd_ctx *ctx,
> +				 struct sighand_struct *sighand,
> +				 unsigned long *flags);
> +static void signalfd_cleanup(struct signalfd_ctx *ctx);
> +static int signalfd_close(struct inode *inode, struct file *file);
> +static unsigned int signalfd_poll(struct file *file, poll_table *wait);
> +static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
> +			     siginfo_t const *kinfo);
> +static ssize_t signalfd_read(struct file *file, char __user *buf, size_t
> count, +			     loff_t *ppos);
> +

see my comment about forward declarations in the previous mail

> +asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t
> sizemask) +{
> +	int error;
> +	unsigned long flags;
> +	sigset_t sigmask;
> +	struct signalfd_ctx *ctx;
> +	struct sighand_struct *sighand;
> +	struct file *file;
> +	struct inode *inode;
> +
> +	error = -EINVAL;
> +	if (sizemask != sizeof(sigset_t) ||
> +	    copy_from_user(&sigmask, user_mask, sizeof(sigmask)))
> +		goto err_exit;

sizeof(sigset_t) may be different for native and 32-bit compat code.
It would be good if you could handle sizemask==4 && sizeof(sigset_t)==8
in this code, so that there is no need for an extra compat_sys_signalfd
function.

> +	if ((sighand = signalfd_get_sighand(ctx, &flags)) != NULL) {
> +		if (next_signal(&ctx->tsk->pending, &ctx->sigmask) > 0 ||
> +		    next_signal(&ctx->tsk->signal->shared_pending,
> +				&ctx->sigmask) > 0)
> +			events |= POLLIN;
> +		signalfd_put_sighand(ctx, sighand, &flags);
> +	} else
> +		events |= POLLIN;
> +
> +	return events;
> +}

I never really understood the events mask, but other subsystems often
use (POLLIN | POLLRDNORM) instead of just POLLIN. Is there a reason
for not returning POLLRDNORM here?

> +static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
> +			     siginfo_t const *kinfo)
> +{
> +	long err;
> +
> +	err = __clear_user(uinfo, sizeof(*uinfo));
> +
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

Doing it this way looks rather inefficient to me. I think it's
better to just prepare the signalfd_siginfo on the stack and
do a single copy_to_user.

Also, what's the reasoning behind defining a new structure
instead of just returning siginfo_t? Sure siginfo_t is ugly
but it is a well-defined structure and users already deal
with the problems it causes.

> +static void __exit signalfd_exit(void)
> +{
> +	kmem_cache_destroy(signalfd_ctx_cachep);
> +}
> +
> +module_init(signalfd_init);
> +module_exit(signalfd_exit);
> +
> +MODULE_LICENSE("GPL");

Since this file defines a syscall, it can't be a module, so why bother
with this?

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
> +};
> +

Since you define the structure using __u32 etc types, I assume
you mean it to be included from libc or other user space, right?
In this case it needs to be listed in include/linux/Kbuild for
make headers_install to work.

> +void signalfd_deliver(struct task_struct *tsk, int sig);
> +
> +/*
> + * No need to fall inside signalfd_deliver() if no signal listeners are
> available. + */
> +static inline void signalfd_notify(struct task_struct *tsk, int sig)
> +{
> +	if (unlikely(!list_empty(&tsk->sighand->sfdlist)))
> +		signalfd_deliver(tsk, sig);
> +}
> +
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
> +

And all of these need to be surrounded by #ifdef __KERNEL__ so
they don't bleed out to the user space visible parts.

	Arnd <><

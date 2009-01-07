Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbZAGMfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbZAGMfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZAGMfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:35:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39516 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbZAGMfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:35:09 -0500
Date: Wed, 7 Jan 2009 13:34:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Casey Dahlin <cdahlin@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
Message-ID: <20090107123457.GB16268@elte.hu>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4963ABF0.6070400@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ed a few more folks who might be interested in this)

* Casey Dahlin <cdahlin@redhat.com> wrote:

> Original description:
>
> Linux now exposes signals, timers, and events via file descriptors 
> through signalfd, timerfd, and eventfd. This means programmers can use a 
> single select/[e]poll call to monitor all change in their program. This 
> patch aims to expose child death via the same mechanism.
> 
> waitfd provides a file descriptor out of which may be read a series of 
> siginfo_t objects describing child death. A child process is reaped as 
> soon as its information is read. This means child monitoring too can be 
> performed with that same poll call.
> 
> Patch is against v2.6.28

The principle looks sound and acceptable - to complete the epoll mechanism 
to all event sources in the system. There's a few small (mostly stylistic) 
details though:

> index 0000000..0155a83
> --- /dev/null
> +++ b/fs/waitfd.c

> +#include <linux/anon_inodes.h>
> +#include <linux/syscalls.h>
> +
> +long do_waitid(int which, pid_t upid,
> +	       struct siginfo __user *infop, int options,
> +	       struct rusage __user *ru);

please move this prototype into sched.h.

> +struct waitfd_ctx {
> +	int ops;
> +	int which;
> +	pid_t upid;
> +};

please align structure fields vertically, similarly to how you aligned 
other definitions in your patch. Something like:

> +struct waitfd_ctx {
> +	int	ops;
> +	int	which;
> +	pid_t	upid;
> +};

(otherwise it looks all a bit too crammed together)

> +static int waitfd_release(struct inode *inode, struct file *file)
> +{
> +	kfree(file->private_data);
> +	return 0;
> +}
> +
> +static unsigned int waitfd_poll(struct file *file, poll_table *wait)
> +{
> +	struct waitfd_ctx *ctx = file->private_data;
> +	long value;
> +
> +	poll_wait(file, &current->signal->wait_chldexit, wait);
> +
> +	value = do_waitid(ctx->which, ctx->upid, NULL,
> +			   ctx->ops | WNOHANG | WNOWAIT, NULL);
> +	if (value > 0 || value == -ECHILD)
> +		return POLLIN;
> +
> +	return 0;
> +}
> +
> +/*
> + * Returns a multiple of the size of a struct siginfo, or a negative
> + * error code. The "count" parameter must be at least sizeof(struct siginfo)
> + */
> +static ssize_t waitfd_read(struct file *file, char __user *buf, size_t count,
> +			     loff_t *ppos)
> +{
> +	struct waitfd_ctx *ctx = file->private_data;
> +	struct siginfo __user *info_addr = (struct siginfo *)buf;
> +	int flags = ctx->ops;
> +	ssize_t ret, total = 0;
> +
> +	count /= sizeof(struct siginfo);
> +	if (!count)
> +		return -EINVAL;
> +
> +	do {
> +		ret = do_waitid(ctx->which, ctx->upid, info_addr, flags, NULL);
> +		if (ret == 0)
> +			ret = -EAGAIN;
> +		if (ret == -ECHILD)
> +			ret = 0;
> +		if (ret <= 0)
> +			break;
> +
> +		info_addr++;
> +		total += sizeof(struct siginfo);
> +		flags |= WNOHANG;
> +	} while (--count);
> +
> +	return total ? total: ret;

please use symmetric spacing, i.e.:

> +	return total ? total : ret;

> +}
> +
> +static const struct file_operations waitfd_fops = {
> +	.release	= waitfd_release,
> +	.poll		= waitfd_poll,
> +	.read		= waitfd_read,
> +};
> +
> +asmlinkage long sys_waitfd(int which, pid_t upid, int options, int unused)
> +{
> +	int ufd;
> +	struct waitfd_ctx *ctx;
> +
> +	/* Just to make sure we don't end up with a sys_waitfd4 */
> +	(void)unused;

looks a bit silly ...

> +
> +	if (options & ~(WNOHANG|WEXITED|WSTOPPED|WCONTINUED))
> +		return -EINVAL;
> +	if (!(options & (WEXITED|WSTOPPED|WCONTINUED)))
> +		return -EINVAL;
> +
> +	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	ctx->ops = options;
> +	ctx->upid = upid;
> +	ctx->which = which;
> +
> +	ufd = anon_inode_getfd("[waitfd]", &waitfd_fops, ctx,
> +			       (options & WNOHANG) ? O_NONBLOCK : 0);
> +	if (ufd < 0)
> +		kfree(ctx);
> +
> +	return ufd;
> +}
> diff --git a/init/Kconfig b/init/Kconfig
> index f763762..bc34871 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -683,6 +683,16 @@ config EPOLL
>  	  Disabling this option will cause the kernel to be built without
>  	  support for epoll family of system calls.
>  
> +config WAITFD
> +	bool "Enable waitfd() system call" if EMBEDDED
> +	select ANON_INODES
> +	default y
> +	help
> +	  Enable the waitfd() system call that allows receving child state

typo.

> +	  changes from a file descriptor.
> +
> +	  If unsure, say Y.
> +
>  config SIGNALFD
>  	bool "Enable signalfd() system call" if EMBEDDED
>  	select ANON_INODES
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 2d8be7e..b53e8ba 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -1233,18 +1233,20 @@ static int wait_noreap_copyout(struct task_struct *p, pid_t pid, uid_t uid,
>  	int retval = rusagep ? getrusage(p, RUSAGE_BOTH, rusagep) : 0;
>  
>  	put_task_struct(p);
> -	if (!retval)
> -		retval = put_user(SIGCHLD, &infop->si_signo);
> -	if (!retval)
> -		retval = put_user(0, &infop->si_errno);
> -	if (!retval)
> -		retval = put_user((short)why, &infop->si_code);
> -	if (!retval)
> -		retval = put_user(pid, &infop->si_pid);
> -	if (!retval)
> -		retval = put_user(uid, &infop->si_uid);
> -	if (!retval)
> -		retval = put_user(status, &infop->si_status);
> +	if (infop) {
> +		if (!retval)
> +			retval = put_user(SIGCHLD, &infop->si_signo);
> +		if (!retval)
> +			retval = put_user(0, &infop->si_errno);
> +		if (!retval)
> +			retval = put_user((short)why, &infop->si_code);
> +		if (!retval)
> +			retval = put_user(pid, &infop->si_pid);
> +		if (!retval)
> +			retval = put_user(uid, &infop->si_uid);
> +		if (!retval)
> +			retval = put_user(status, &infop->si_status);
> +	}
>  	if (!retval)
>  		retval = pid;
>  	return retval;
> @@ -1727,35 +1729,12 @@ repeat:
>  end:
>  	current->state = TASK_RUNNING;
>  	remove_wait_queue(&current->signal->wait_chldexit,&wait);
> -	if (infop) {
> -		if (retval > 0)
> -			retval = 0;
> -		else {
> -			/*
> -			 * For a WNOHANG return, clear out all the fields
> -			 * we would set so the user can easily tell the
> -			 * difference.
> -			 */
> -			if (!retval)
> -				retval = put_user(0, &infop->si_signo);
> -			if (!retval)
> -				retval = put_user(0, &infop->si_errno);
> -			if (!retval)
> -				retval = put_user(0, &infop->si_code);
> -			if (!retval)
> -				retval = put_user(0, &infop->si_pid);
> -			if (!retval)
> -				retval = put_user(0, &infop->si_uid);
> -			if (!retval)
> -				retval = put_user(0, &infop->si_status);
> -		}
> -	}
>  	return retval;
>  }
>  
> -asmlinkage long sys_waitid(int which, pid_t upid,
> -			   struct siginfo __user *infop, int options,
> -			   struct rusage __user *ru)
> +long do_waitid(int which, pid_t upid,
> +	       struct siginfo __user *infop, int options,
> +	       struct rusage __user *ru)
>  {
>  	struct pid *pid = NULL;
>  	enum pid_type type;
> @@ -1789,6 +1768,39 @@ asmlinkage long sys_waitid(int which, pid_t upid,
>  	ret = do_wait(type, pid, options, infop, NULL, ru);
>  	put_pid(pid);
>  
> +	return ret;
> +}
> +
> +asmlinkage long sys_waitid(int which, pid_t upid,
> +			   struct siginfo __user *infop, int options,
> +			   struct rusage __user *ru)
> +{
> +	long ret;
> +
> +	ret = do_waitid(which, upid, infop, options, ru);
> +
> +	if (ret > 0)
> +		ret = 0;
> +	else {
> +		/*
> +		 * For a WNOHANG return, clear out all the fields
> +		 * we would set so the user can easily tell the
> +		 * difference.
> +		 */
> +		if (!ret)
> +			ret = put_user(0, &infop->si_signo);
> +		if (!ret)
> +			ret = put_user(0, &infop->si_errno);
> +		if (!ret)
> +			ret = put_user(0, &infop->si_code);
> +		if (!ret)
> +			ret = put_user(0, &infop->si_pid);
> +		if (!ret)
> +			ret = put_user(0, &infop->si_uid);
> +		if (!ret)
> +			ret = put_user(0, &infop->si_status);

even if this just moves existing code around, if we touch this, it would 
be far cleaner (and faster as well) to do what other bits of the signal 
code do:

> +		ret  = put_user(0, &infop->si_signo);
> +		ret |= put_user(0, &infop->si_errno);
> +		ret |= put_user(0, &infop->si_code);
> +		ret |= put_user(0, &infop->si_pid);
> +		ret |= put_user(0, &infop->si_uid);
> +		ret |= put_user(0, &infop->si_status);

Since put_user() can only return -EFAULT or zero.

(same for wait_noreap_copyout())

	Ingo

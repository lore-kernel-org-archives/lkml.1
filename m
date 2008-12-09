Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYLITly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYLITly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 14:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbYLITlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 14:41:39 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:45757 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbYLITli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 14:41:38 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 9 Dec 2008 11:41:35 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Casey Dahlin <cdahlin@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Scott James Remnant <scott@netsplit.com>
Subject: Re: [RFC PATCH] waitfd: file descriptor to wait on child processes
In-Reply-To: <493EA441.1070706@redhat.com>
Message-ID: <alpine.DEB.1.10.0812091127160.17144@alien.or.mcafeemobile.com>
References: <493EA441.1070706@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2008, Casey Dahlin wrote:

> This is essentially my first kernel patch, so be nice :)
> 
> Linux already has signalfd, timerfd, and eventfd to expose signals, timers,
> and events via a file descriptor. This patch is a working prototype for a
> fourth: waitfd. It pretty much does what the name suggests: reading from it
> yields a series of status ints (as would be written into the second argument
> of waitpid) for child processes that have changed state. It takes essentially
> the same arguments as waitpid (for now) and supports the same set of features.
> 
> This is far from ready for merge. Some things that are wrong with it:
> * Waitpid's argument scheme probably isn't the best for this. By default it
> makes it easiest to wait on a single child, which is not often useful in this
> case. Waiting on all children or children in a particular process group is
> possible, but not a particular, explicit set of children, which we probably
> want (and which will complicate the implementation significantly).
> * The prototype for peek_waitpid is obviously in the wrong place, but I
> haven't found a good home for it.
> * Waitid's semantics have slightly altered: passing NULL as the pointer to
> siginfo_t with WNOWAIT will now return successfully instead of throwing
> EFAULT. I don't know if that means I broke it or fixed it :)
> * peek_waitpid may not be required at all now. I can probably trick sys_wait4
> or sys_waitid into giving me what I want (or I could always just make do_wait
> non-static).
> 
> Please provide thoughts.

What's wrong in having a signalfd on SIGCHLD, than doing waitpid() once 
you get the signal? Do you have cases where this wouldn't be OK?
About the code, eventually, you really want to report the PID of the 
exited child, together with the status. So maybe a non-compat-requiring 
struct would be better to be returned by read(2).
Also ...




> +static unsigned int waitfd_poll(struct file *file, poll_table *wait)
> +{
> +    struct waitfd_ctx *ctx = file->private_data;
> +    long value;
> +
> +    poll_wait(file, &current->signal->wait_chldexit, wait);
> +
> +    value = peek_waitpid(ctx->upid, ctx->ops);
> +    if (value > 0) {
> +        return POLLIN;
> +    } if (value == -ECHILD) {
> +        return POLLIN;
> +    }

Trust the compiler, it's pretty good in not having you to add Perl-like 
extra brackets ;)
This also looks wierd:

	} if (value == -ECHILD) {

So maybe:

	return value > 0 || value == -ECHILD ? POLLIN: 0;





> +/*
> + * Returns a multiple of the size of a "struct waitfd_siginfo", or a negative
> + * error code. The "count" parameter must be at least the size of a
> + * "struct waitfd_siginfo".
> + */

Really? ...



> +static ssize_t waitfd_read(struct file *file, char __user *buf, size_t count,
> +                 loff_t *ppos)
> +{
> +    struct waitfd_ctx *ctx = file->private_data;
> +    int __user *stat_addr = (int *)buf;
> +    int nonblock = file->f_flags & O_NONBLOCK ? WNOHANG: 0;
> +    ssize_t ret, total = 0;
> +
> +    count /= sizeof(int);
> +    if (!count)
> +        return -EINVAL;
> +
> +    do {
> +        ret = sys_wait4(ctx->upid, stat_addr, ctx->ops | nonblock,
> +                NULL);
> +        if (ret == 0)
> +            ret = -EAGAIN;
> +        if (ret == -ECHILD)
> +            ret = 0;
> +        if (ret <= 0)
> +            break;
> +
> +        stat_addr++;
> +        total += sizeof(struct siginfo);
> +        nonblock = WNOHANG;
> +    } while (--count);
> +
> +    return total ? total: ret;
> +}

... looks like you're returning a sequence of status ints, with wrong data 
size returned by read(2).




> +
> +static const struct file_operations waitfd_fops = {
> +    .release    = waitfd_release,
> +    .poll        = waitfd_poll,
> +    .read        = waitfd_read,
> +};
> +
> +asmlinkage long sys_waitfd(pid_t upid, int ops)

Please leave space for extra flags for fds, otherwise Uli will have to 
make another sys_waitfd3().



> +long peek_waitpid(pid_t upid, int options)
> +{
> +    struct pid *pid = NULL;
> +    enum pid_type type;
> +    long ret;
> +
> +    if (options & ~(WNOHANG|WUNTRACED|WCONTINUED|
> +            __WNOTHREAD|__WCLONE|__WALL))
> +        return -EINVAL;
> +
> +    options |= WNOHANG | WNOWAIT;
> +
> +    if (upid == -1)
> +        type = PIDTYPE_MAX;
> +    else if (upid < 0) {
> +        type = PIDTYPE_PGID;
> +        pid = find_get_pid(-upid);
> +    } else if (upid == 0) {
> +        type = PIDTYPE_PGID;
> +        pid = get_pid(task_pgrp(current));
> +    } else /* upid > 0 */ {
> +        type = PIDTYPE_PID;
> +        pid = find_get_pid(upid);
> +    }
> +
> +    ret = do_wait(type, pid, options | WEXITED, NULL, NULL, NULL);
> +    put_pid(pid);
> +
> +    /* avoid REGPARM breakage on x86: */
> +    asmlinkage_protect(4, ret, upid, options);
> +    return ret;
> +}

Given that you blinded copied this from sys_wait4(), you may want to at 
least try to make sys_wait4() to re-use the new function.
Also, your patch does not apply to latest Linus tree. Which one was the 
base?



- Davide



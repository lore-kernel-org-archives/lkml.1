Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbZAFSpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbZAFSpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbZAFSpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:45:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50208 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbZAFSpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:45:02 -0500
Message-ID: <4963A6D9.9080206@redhat.com>
Date: Tue, 06 Jan 2009 13:45:45 -0500
From: Casey Dahlin <cdahlin@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2] waitfd
References: <49639EB8.40204@redhat.com> <4963A392.1060104@oracle.com>
In-Reply-To: <4963A392.1060104@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Casey Dahlin wrote:
>   
>> Linux now exposes signals, timers, and events via file descriptors
>> through signalfd, timerfd, and eventfd. This means programmers can use a
>> single select/[e]poll call to monitor all change in their program. This
>> patch aims to expose child death via the same mechanism.
>>
>> waitfd provides a file descriptor out of which may be read a series of
>> siginfo_t objects describing child death. A child process is reaped as
>> soon as its information is read. This means child monitoring too can be
>> performed with that same poll call.
>>
>> Patch is against v2.6.28
>>
>> --CJD
>>
>> diff --git a/arch/x86/include/asm/unistd_32.h
>> b/arch/x86/include/asm/unistd_32.h
>> index f2bba78..134d83c 100644
>> --- a/arch/x86/include/asm/unistd_32.h
>> +++ b/arch/x86/include/asm/unistd_32.h
>> @@ -338,6 +338,7 @@
>> #define __NR_dup3        330
>> #define __NR_pipe2        331
>> #define __NR_inotify_init1    332
>> +#define __NR_waitfd        333
>>
>> #ifdef __KERNEL__
>>
>> diff --git a/arch/x86/include/asm/unistd_64.h
>> b/arch/x86/include/asm/unistd_64.h
>> index d2e415e..b28eb07 100644
>> --- a/arch/x86/include/asm/unistd_64.h
>> +++ b/arch/x86/include/asm/unistd_64.h
>> @@ -653,6 +653,8 @@ __SYSCALL(__NR_dup3, sys_dup3)
>> __SYSCALL(__NR_pipe2, sys_pipe2)
>> #define __NR_inotify_init1            294
>> __SYSCALL(__NR_inotify_init1, sys_inotify_init1)
>> +#define __NR_waitfd                295
>> +__SYSCALL(__NR_waitfd, sys_waitfd)
>>
>>     
>
> Only for x86??
>
>   

At the moment. I should have mentioned this earlier but I haven't made 
the syscall table entries for archs I don't test on. That will change 
once the rest of the change has settled out.

>> #ifndef __NO_STUBS
>> diff --git a/arch/x86/kernel/syscall_table_32.S
>> b/arch/x86/kernel/syscall_table_32.S
>> index d44395f..c796a8b 100644
>> --- a/arch/x86/kernel/syscall_table_32.S
>> +++ b/arch/x86/kernel/syscall_table_32.S
>> @@ -332,3 +332,4 @@ ENTRY(sys_call_table)
>>     .long sys_dup3            /* 330 */
>>     .long sys_pipe2
>>     .long sys_inotify_init1
>> +    .long sys_waitfd
>> diff --git a/fs/Makefile b/fs/Makefile
>> index d9f8afe..74c31fb 100644
>> --- a/fs/Makefile
>> +++ b/fs/Makefile
>> @@ -25,6 +25,7 @@ obj-$(CONFIG_INOTIFY_USER)    += inotify_user.o
>> obj-$(CONFIG_EPOLL)        += eventpoll.o
>> obj-$(CONFIG_ANON_INODES)    += anon_inodes.o
>> obj-$(CONFIG_SIGNALFD)        += signalfd.o
>> +obj-$(CONFIG_WAITFD)        += waitfd.o
>> obj-$(CONFIG_TIMERFD)        += timerfd.o
>> obj-$(CONFIG_EVENTFD)        += eventfd.o
>> obj-$(CONFIG_AIO)               += aio.o
>> diff --git a/fs/waitfd.c b/fs/waitfd.c
>> new file mode 100644
>> index 0000000..0155a83
>> --- /dev/null
>> +++ b/fs/waitfd.c
>> @@ -0,0 +1,117 @@
>> +/*
>> + *  fs/waitfd.c
>> + *
>> + *  Copyright (C) 2008  Red Hat, Casey Dahlin <cdahlin@redhat.com>
>> + *
>> + *  Largely derived from fs/signalfd.c
>> + */
>> +
>> +#include <linux/file.h>
>> +#include <linux/poll.h>
>> +#include <linux/init.h>
>> +#include <linux/fs.h>
>> +#include <linux/sched.h>
>> +#include <linux/kernel.h>
>> +#include <linux/signal.h>
>> +#include <linux/list.h>
>> +#include <linux/anon_inodes.h>
>> +#include <linux/syscalls.h>
>> +
>> +long do_waitid(int which, pid_t upid,
>> +           struct siginfo __user *infop, int options,
>> +           struct rusage __user *ru);
>> +
>> +struct waitfd_ctx {
>> +    int ops;
>> +    int which;
>> +    pid_t upid;
>> +};
>> +
>>     
>
> Please use kernel coding style:  use tabs to indent, not <lots-of-spaces>,
> and struct members, functions, etc., are indented by one tab stop minimum.
>
>   

Damnit. This is a mailer artifact. This is the first time thunderbird 
has eaten a patch on me. I'll look in to it.

>> +static int waitfd_release(struct inode *inode, struct file *file)
>> +{
>> +    kfree(file->private_data);
>> +    return 0;
>> +}
>> +
>> +static unsigned int waitfd_poll(struct file *file, poll_table *wait)
>> +{
>> +    struct waitfd_ctx *ctx = file->private_data;
>> +    long value;
>> +
>> +    poll_wait(file, &current->signal->wait_chldexit, wait);
>> +
>> +    value = do_waitid(ctx->which, ctx->upid, NULL,
>> +               ctx->ops | WNOHANG | WNOWAIT, NULL);
>> +    if (value > 0 || value == -ECHILD)
>> +        return POLLIN;
>> +
>> +    return 0;
>> +}
>> +
>> +/*
>> + * Returns a multiple of the size of a struct siginfo, or a negative
>> + * error code. The "count" parameter must be at least sizeof(struct
>> siginfo)
>> + */
>> +static ssize_t waitfd_read(struct file *file, char __user *buf, size_t
>> count,
>> +                 loff_t *ppos)
>> +{
>> +    struct waitfd_ctx *ctx = file->private_data;
>> +    struct siginfo __user *info_addr = (struct siginfo *)buf;
>> +    int flags = ctx->ops;
>> +    ssize_t ret, total = 0;
>> +
>> +    count /= sizeof(struct siginfo);
>> +    if (!count)
>> +        return -EINVAL;
>> +
>> +    do {
>> +        ret = do_waitid(ctx->which, ctx->upid, info_addr, flags, NULL);
>> +        if (ret == 0)
>> +            ret = -EAGAIN;
>> +        if (ret == -ECHILD)
>> +            ret = 0;
>> +        if (ret <= 0)
>> +            break;
>> +
>> +        info_addr++;
>> +        total += sizeof(struct siginfo);
>> +        flags |= WNOHANG;
>> +    } while (--count);
>> +
>> +    return total ? total: ret;
>>     
>
> 	return total ? total : ret;
> please.
>
>   

I actually saw this used elsewhere in the kernel. Assumed I'd missed it 
in the style guidelines :)

>> +}
>> +
>> +static const struct file_operations waitfd_fops = {
>> +    .release    = waitfd_release,
>> +    .poll        = waitfd_poll,
>> +    .read        = waitfd_read,
>> +};
>> +
>> +asmlinkage long sys_waitfd(int which, pid_t upid, int options, int unused)
>> +{
>> +    int ufd;
>> +    struct waitfd_ctx *ctx;
>> +
>> +    /* Just to make sure we don't end up with a sys_waitfd4 */
>> +    (void)unused;
>> +
>> +    if (options & ~(WNOHANG|WEXITED|WSTOPPED|WCONTINUED))
>> +        return -EINVAL;
>> +    if (!(options & (WEXITED|WSTOPPED|WCONTINUED)))
>> +        return -EINVAL;
>>     
>
> Use spaces around '|'.
>
>   

Those 4 lines are copied almost exactly from kernel/exit.c. Is there 
motivation to keep them consistent?

>> +
>> +    ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
>> +    if (!ctx)
>> +        return -ENOMEM;
>> +
>> +    ctx->ops = options;
>> +    ctx->upid = upid;
>> +    ctx->which = which;
>> +
>> +    ufd = anon_inode_getfd("[waitfd]", &waitfd_fops, ctx,
>> +                   (options & WNOHANG) ? O_NONBLOCK : 0);
>> +    if (ufd < 0)
>> +        kfree(ctx);
>> +
>> +    return ufd;
>> +}
>> diff --git a/init/Kconfig b/init/Kconfig
>> index f763762..bc34871 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -683,6 +683,16 @@ config EPOLL
>>       Disabling this option will cause the kernel to be built without
>>       support for epoll family of system calls.
>>
>> +config WAITFD
>> +    bool "Enable waitfd() system call" if EMBEDDED
>> +    select ANON_INODES
>> +    default y
>> +    help
>> +      Enable the waitfd() system call that allows receving child state
>>     
>
> 	                                             receiving
>
> Kconfig help text should be indented by <tab><space><space>.
>
>   
Likely more of the mailer eating the patch.
>> +      changes from a file descriptor.
>> +
>> +      If unsure, say Y.
>> +
>> config SIGNALFD
>>     bool "Enable signalfd() system call" if EMBEDDED
>>     select ANON_INODES
>> diff --git a/kernel/exit.c b/kernel/exit.c
>> index 2d8be7e..b53e8ba 100644
>> --- a/kernel/exit.c
>> +++ b/kernel/exit.c
>> @@ -1233,18 +1233,20 @@ static int wait_noreap_copyout(struct
>> task_struct *p, pid_t pid, uid_t uid,
>>     int retval = rusagep ? getrusage(p, RUSAGE_BOTH, rusagep) : 0;
>>
>>     put_task_struct(p);
>> -    if (!retval)
>> -        retval = put_user(SIGCHLD, &infop->si_signo);
>> -    if (!retval)
>> -        retval = put_user(0, &infop->si_errno);
>> -    if (!retval)
>> -        retval = put_user((short)why, &infop->si_code);
>> -    if (!retval)
>> -        retval = put_user(pid, &infop->si_pid);
>> -    if (!retval)
>> -        retval = put_user(uid, &infop->si_uid);
>> -    if (!retval)
>> -        retval = put_user(status, &infop->si_status);
>> +    if (infop) {
>> +        if (!retval)
>> +            retval = put_user(SIGCHLD, &infop->si_signo);
>> +        if (!retval)
>> +            retval = put_user(0, &infop->si_errno);
>> +        if (!retval)
>> +            retval = put_user((short)why, &infop->si_code);
>> +        if (!retval)
>> +            retval = put_user(pid, &infop->si_pid);
>> +        if (!retval)
>> +            retval = put_user(uid, &infop->si_uid);
>> +        if (!retval)
>> +            retval = put_user(status, &infop->si_status);
>> +    }
>>     if (!retval)
>>         retval = pid;
>>     return retval;
>> @@ -1727,35 +1729,12 @@ repeat:
>> end:
>>     current->state = TASK_RUNNING;
>>     remove_wait_queue(&current->signal->wait_chldexit,&wait);
>> -    if (infop) {
>> -        if (retval > 0)
>> -            retval = 0;
>> -        else {
>> -            /*
>> -             * For a WNOHANG return, clear out all the fields
>> -             * we would set so the user can easily tell the
>> -             * difference.
>> -             */
>> -            if (!retval)
>> -                retval = put_user(0, &infop->si_signo);
>> -            if (!retval)
>> -                retval = put_user(0, &infop->si_errno);
>> -            if (!retval)
>> -                retval = put_user(0, &infop->si_code);
>> -            if (!retval)
>> -                retval = put_user(0, &infop->si_pid);
>> -            if (!retval)
>> -                retval = put_user(0, &infop->si_uid);
>> -            if (!retval)
>> -                retval = put_user(0, &infop->si_status);
>> -        }
>> -    }
>>     return retval;
>> }
>>
>> -asmlinkage long sys_waitid(int which, pid_t upid,
>> -               struct siginfo __user *infop, int options,
>> -               struct rusage __user *ru)
>> +long do_waitid(int which, pid_t upid,
>> +           struct siginfo __user *infop, int options,
>> +           struct rusage __user *ru)
>> {
>>     struct pid *pid = NULL;
>>     enum pid_type type;
>> @@ -1789,6 +1768,39 @@ asmlinkage long sys_waitid(int which, pid_t upid,
>>     ret = do_wait(type, pid, options, infop, NULL, ru);
>>     put_pid(pid);
>>
>> +    return ret;
>> +}
>> +
>> +asmlinkage long sys_waitid(int which, pid_t upid,
>> +               struct siginfo __user *infop, int options,
>> +               struct rusage __user *ru)
>> +{
>> +    long ret;
>> +
>> +    ret = do_waitid(which, upid, infop, options, ru);
>> +
>> +    if (ret > 0)
>> +        ret = 0;
>> +    else {
>> +        /*
>> +         * For a WNOHANG return, clear out all the fields
>> +         * we would set so the user can easily tell the
>> +         * difference.
>> +         */
>> +        if (!ret)
>> +            ret = put_user(0, &infop->si_signo);
>> +        if (!ret)
>> +            ret = put_user(0, &infop->si_errno);
>> +        if (!ret)
>> +            ret = put_user(0, &infop->si_code);
>> +        if (!ret)
>> +            ret = put_user(0, &infop->si_pid);
>> +        if (!ret)
>> +            ret = put_user(0, &infop->si_uid);
>> +        if (!ret)
>> +            ret = put_user(0, &infop->si_status);
>> +    }
>> +
>>     /* avoid REGPARM breakage on x86: */
>>     asmlinkage_protect(5, ret, which, upid, infop, options, ru);
>>     return ret;
>> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
>> index e14a232..e8d4da6 100644
>> --- a/kernel/sys_ni.c
>> +++ b/kernel/sys_ni.c
>> @@ -163,6 +163,7 @@ cond_syscall(sys_ioprio_set);
>> cond_syscall(sys_ioprio_get);
>>
>> /* New file descriptors */
>> +cond_syscall(sys_waitfd);
>> cond_syscall(sys_signalfd);
>> cond_syscall(sys_signalfd4);
>> cond_syscall(compat_sys_signalfd);
>>     
Thanks for the review.

--CJD

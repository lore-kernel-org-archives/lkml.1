Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbYLIUJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbYLIUJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbYLIUJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:09:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59040 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555AbYLIUJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:09:18 -0500
Message-ID: <493ED085.9010701@redhat.com>
Date: Tue, 09 Dec 2008 15:09:41 -0500
From: Casey Dahlin <cdahlin@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Scott James Remnant <scott@netsplit.com>
Subject: Re: [RFC PATCH] waitfd: file descriptor to wait on child processes
References: <493EA441.1070706@redhat.com> <alpine.DEB.1.10.0812091127160.17144@alien.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0812091127160.17144@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> On Tue, 9 Dec 2008, Casey Dahlin wrote:
>
>   
>> This is essentially my first kernel patch, so be nice :)
>>
>> Linux already has signalfd, timerfd, and eventfd to expose signals, timers,
>> and events via a file descriptor. This patch is a working prototype for a
>> fourth: waitfd. It pretty much does what the name suggests: reading from it
>> yields a series of status ints (as would be written into the second argument
>> of waitpid) for child processes that have changed state. It takes essentially
>> the same arguments as waitpid (for now) and supports the same set of features.
>>
>> This is far from ready for merge. Some things that are wrong with it:
>> * Waitpid's argument scheme probably isn't the best for this. By default it
>> makes it easiest to wait on a single child, which is not often useful in this
>> case. Waiting on all children or children in a particular process group is
>> possible, but not a particular, explicit set of children, which we probably
>> want (and which will complicate the implementation significantly).
>> * The prototype for peek_waitpid is obviously in the wrong place, but I
>> haven't found a good home for it.
>> * Waitid's semantics have slightly altered: passing NULL as the pointer to
>> siginfo_t with WNOWAIT will now return successfully instead of throwing
>> EFAULT. I don't know if that means I broke it or fixed it :)
>> * peek_waitpid may not be required at all now. I can probably trick sys_wait4
>> or sys_waitid into giving me what I want (or I could always just make do_wait
>> non-static).
>>
>> Please provide thoughts.
>>     
>
> What's wrong in having a signalfd on SIGCHLD, than doing waitpid() once 
> you get the signal? Do you have cases where this wouldn't be OK?
>   

When the child doesn't send SIGCHLD (clone() lets you do evil things :)

Seriously though, that may be an option. Scott (CC'd ) is primarily the 
consumer of this, so he can better comment.

> About the code, eventually, you really want to report the PID of the 
> exited child, together with the status. So maybe a non-compat-requiring 
> struct would be better to be returned by read(2).
> Also ...
>
>
>
>
>   
>> +static unsigned int waitfd_poll(struct file *file, poll_table *wait)
>> +{
>> +    struct waitfd_ctx *ctx = file->private_data;
>> +    long value;
>> +
>> +    poll_wait(file, &current->signal->wait_chldexit, wait);
>> +
>> +    value = peek_waitpid(ctx->upid, ctx->ops);
>> +    if (value > 0) {
>> +        return POLLIN;
>> +    } if (value == -ECHILD) {
>> +        return POLLIN;
>> +    }
>>     
>
> Trust the compiler, it's pretty good in not having you to add Perl-like 
> extra brackets ;)
> This also looks wierd:
>
> 	} if (value == -ECHILD) {
>
> So maybe:
>
> 	return value > 0 || value == -ECHILD ? POLLIN: 0;
>
>
>   

Yeah, I ripped this up because during debugging poll was behaving oddly, 
and I had been instrumenting the code with printks. It can go back to 
being 1 line now.

>
>
>   
>> +/*
>> + * Returns a multiple of the size of a "struct waitfd_siginfo", or a negative
>> + * error code. The "count" parameter must be at least the size of a
>> + * "struct waitfd_siginfo".
>> + */
>>     
>
> Really? ...
>
>
>   

Wow... and I read this patch before I sent it, too *facepalm*

The function did briefly return a siginfo_t (I implemented on top of 
waitid first).

>   
>> +static ssize_t waitfd_read(struct file *file, char __user *buf, size_t count,
>> +                 loff_t *ppos)
>> +{
>> +    struct waitfd_ctx *ctx = file->private_data;
>> +    int __user *stat_addr = (int *)buf;
>> +    int nonblock = file->f_flags & O_NONBLOCK ? WNOHANG: 0;
>> +    ssize_t ret, total = 0;
>> +
>> +    count /= sizeof(int);
>> +    if (!count)
>> +        return -EINVAL;
>> +
>> +    do {
>> +        ret = sys_wait4(ctx->upid, stat_addr, ctx->ops | nonblock,
>> +                NULL);
>> +        if (ret == 0)
>> +            ret = -EAGAIN;
>> +        if (ret == -ECHILD)
>> +            ret = 0;
>> +        if (ret <= 0)
>> +            break;
>> +
>> +        stat_addr++;
>> +        total += sizeof(struct siginfo);
>> +        nonblock = WNOHANG;
>> +    } while (--count);
>> +
>> +    return total ? total: ret;
>> +}
>>     
>
> ... looks like you're returning a sequence of status ints, with wrong data 
> size returned by read(2).
>
>
>   
More leftovers from above.
>
>   
>> +
>> +static const struct file_operations waitfd_fops = {
>> +    .release    = waitfd_release,
>> +    .poll        = waitfd_poll,
>> +    .read        = waitfd_read,
>> +};
>> +
>> +asmlinkage long sys_waitfd(pid_t upid, int ops)
>>     
>
> Please leave space for extra flags for fds, otherwise Uli will have to 
> make another sys_waitfd3().
>
>
>   
ack'd.
>   
>> +long peek_waitpid(pid_t upid, int options)
>> +{
>> +    struct pid *pid = NULL;
>> +    enum pid_type type;
>> +    long ret;
>> +
>> +    if (options & ~(WNOHANG|WUNTRACED|WCONTINUED|
>> +            __WNOTHREAD|__WCLONE|__WALL))
>> +        return -EINVAL;
>> +
>> +    options |= WNOHANG | WNOWAIT;
>> +
>> +    if (upid == -1)
>> +        type = PIDTYPE_MAX;
>> +    else if (upid < 0) {
>> +        type = PIDTYPE_PGID;
>> +        pid = find_get_pid(-upid);
>> +    } else if (upid == 0) {
>> +        type = PIDTYPE_PGID;
>> +        pid = get_pid(task_pgrp(current));
>> +    } else /* upid > 0 */ {
>> +        type = PIDTYPE_PID;
>> +        pid = find_get_pid(upid);
>> +    }
>> +
>> +    ret = do_wait(type, pid, options | WEXITED, NULL, NULL, NULL);
>> +    put_pid(pid);
>> +
>> +    /* avoid REGPARM breakage on x86: */
>> +    asmlinkage_protect(4, ret, upid, options);
>> +    return ret;
>> +}
>>     
>
> Given that you blinded copied this from sys_wait4(), you may want to at 
> least try to make sys_wait4() to re-use the new function.
>   

Good idea.

> Also, your patch does not apply to latest Linus tree. Which one was the 
> base?
>
>   
This is the last commit before mine in my git repo:

commit f7a8db89c1f42e504bb12d2ae399cd96f755a7db
Merge: 6f84b4d... c49b9f2...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Dec 8 19:52:43 2008 -0800

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
   
    * git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6:
      tproxy: fixe a possible read from an invalid location in the 
socket match
      zd1211rw: use unaligned safe memcmp() in-place of compare_ether_addr()
          (...lots and lots of changes snipped...)

--CJD



Return-Path: <linux-kernel-owner+w=401wt.eu-S966012AbXDHAkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966012AbXDHAkF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 20:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966019AbXDHAkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 20:40:05 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58511 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966012AbXDHAkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 20:40:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
References: <20070406084250.GA179@tv-sign.ru>
	<m18xd5amwq.fsf@ebiederm.dsl.xmission.com>
	<20070406094413.GA673@tv-sign.ru>
	<m1lkh58q16.fsf@ebiederm.dsl.xmission.com>
	<20070406154750.GA541@tv-sign.ru>
	<Pine.LNX.4.64.0704061013060.6730@woody.linux-foundation.org>
	<20070406193621.GA96@tv-sign.ru> <20070407203125.GA6032@tv-sign.ru>
Date: Sat, 07 Apr 2007 18:38:51 -0600
In-Reply-To: <20070407203125.GA6032@tv-sign.ru> (Oleg Nesterov's message of
	"Sun, 8 Apr 2007 00:31:25 +0400")
Message-ID: <m11wiv4s4k.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 04/06, Oleg Nesterov wrote:
>> 
>> Perhaps,
>> 
>> --- t/kernel/exit.c~	2007-04-06 23:31:31.000000000 +0400
>> +++ t/kernel/exit.c	2007-04-06 23:31:57.000000000 +0400
>> @@ -275,10 +275,7 @@ static void reparent_to_init(void)
>>  	remove_parent(current);
>>  	current->parent = child_reaper(current);
>>  	current->real_parent = child_reaper(current);
>> -	add_parent(current);
>> -
>> -	/* Set the exit signal to SIGCHLD so we signal init on exit */
>> -	current->exit_signal = SIGCHLD;
>> +	current->exit_signal = -1;
>>  
>>  	if (!has_rt_policy(current) && (task_nice(current) < 0))
>>  		set_user_nice(current, 0);
>> 
>> is enough. init is still our parent (make ps happy), but it can't see us,
>> we are not on ->children list.
>
> OK, this doesn't work. A multi-threaded init may do execve(). 

Good catch.  daemonize must die! 

> So, we can re-parent a kernel thread to swapper. In that case it doesn't matter
> if we put task on ->children list or not.

Yes.  We can.

> User-visible change. Acceptable?

We would have user visible changes when we changed to ktrhead_create anyway,
and it's none of user space's business so certainly.

>> Off course, we also need to add preparent_to_init() to kthread() and
>> (say) stopmachine(). Or we can create kernel_thread_detached() and
>> modify callers to use it.
>
> It would be very nice to introduce CLONE_KERNEL_THREAD instead, then

If we are going to do something to copy_process and the like let's take
this one step farther.  Let's pass in the value of the task to copy.

Then we can add a wrapper around copy_process to build kernel_thread
something like:

struct task_struct *__kernel_thread(int (*fn)(void *), void * arg,
				    unsigned long flags)
{
	struct task_struct *task;
	struct pt_regs regs, *reg;

        reg = kernel_thread_regs(&regs, fn, arg);
	task = copy_process(&init_task, flags, 0, reg, 0, NULL, NULL, NULL, 0);
	if (!IS_ERR(task))
		wake_up_new_task(task, flags);

	return task;
}

long kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
{
	struct task_struct *task;
	task = __kernel_thread(fn, arg, flags);
        if (IS_ERR(task))
        	return PTR_ERR(task);
	return task->pid;               
}

After that daemonize just becomes:

void daemonize(const char *name, ...)
{
	va_list args;

	va_start(args, name);
	vsnprintf(current->comm, sizeof(current->comm), name, args);
	va_end(args);
}

And kthread_create becomes:

struct task_struct *kthread_create(int (*threadfn)(void *data),
				   void *data,
				   const char namefmt[],
				   ...)
{
	struct kthread_create_info create;
	struct task_struct *task;

	create.threadfn = threadfn;
	create.data = data;

	/* We want our own signal handler (we take no signals by default). */
        task = __kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
	if (!IS_ERR(task)) {
		va_list args;
		va_start(args, namefmt);
		vsnprintf(task->comm, sizeof(task->comm),  namefmt, args);
		va_end(args);
	}
        return task;
}

If we are willing to go that far.  I think it is worth it to touch the
architecture specific code.  As that removes an unnecessary wait
queue, and ensures that kernel threads always start with a consistent
state.  So it is a performance, scalability and simplicity boost.

Otherwise we should just put the code in the callers of kernel_thread
like we do today.

I don't have the energy to rework all of th architecture or even a
noticeable fraction of them right now.  I have to much on my plate.
A non-architecture specific solution looks like a fairly simple
patch and I might get around to it one of these times..

Eric

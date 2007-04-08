Return-Path: <linux-kernel-owner+w=401wt.eu-S1750699AbXDHPqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750699AbXDHPqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 11:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750717AbXDHPqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 11:46:39 -0400
Received: from mail.screens.ru ([213.234.233.54]:35569 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbXDHPqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 11:46:38 -0400
Date: Sun, 8 Apr 2007 19:46:18 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070408154618.GA84@tv-sign.ru>
References: <20070406084250.GA179@tv-sign.ru> <m18xd5amwq.fsf@ebiederm.dsl.xmission.com> <20070406094413.GA673@tv-sign.ru> <m1lkh58q16.fsf@ebiederm.dsl.xmission.com> <20070406154750.GA541@tv-sign.ru> <Pine.LNX.4.64.0704061013060.6730@woody.linux-foundation.org> <20070406193621.GA96@tv-sign.ru> <20070407203125.GA6032@tv-sign.ru> <m11wiv4s4k.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11wiv4s4k.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> writes:
>
> > On 04/06, Oleg Nesterov wrote:
> >>
> >> @@ -275,10 +275,7 @@ static void reparent_to_init(void)
> >>  	remove_parent(current);
> >>  	current->parent = child_reaper(current);
> >>  	current->real_parent = child_reaper(current);
> >> -	add_parent(current);
> >> -
> >> -	/* Set the exit signal to SIGCHLD so we signal init on exit */
> >> -	current->exit_signal = SIGCHLD;
> >> +	current->exit_signal = -1;
> >>
> >>  	if (!has_rt_policy(current) && (task_nice(current) < 0))
> >>  		set_user_nice(current, 0);
> >>
> >> is enough. init is still our parent (make ps happy), but it can't see us,
> >> we are not on ->children list.
> >
> > OK, this doesn't work. A multi-threaded init may do execve().
>
> Good catch.  daemonize must die!

Well, this is not the problem of daemonize(), but I agree, daemonize() should
die with the changes you proposed.

> > So, we can re-parent a kernel thread to swapper. In that case it doesn't matter
> > if we put task on ->children list or not.
>
> Yes.  We can.
>
> > User-visible change. Acceptable?
>
> We would have user visible changes when we changed to ktrhead_create anyway,
> and it's none of user space's business so certainly.

OK, I'll try to do "just for review" patch. I'm afraid pstree will be confused.

> >> Off course, we also need to add preparent_to_init() to kthread() and
> >> (say) stopmachine(). Or we can create kernel_thread_detached() and
> >> modify callers to use it.
> >
> > It would be very nice to introduce CLONE_KERNEL_THREAD instead, then
>
> If we are going to do something to copy_process and the like let's take
> this one step farther.  Let's pass in the value of the task to copy.

Yes! I thought about that too. but see below,

> Then we can add a wrapper around copy_process to build kernel_thread
> something like:
>
> struct task_struct *__kernel_thread(int (*fn)(void *), void * arg,
> 				    unsigned long flags)
> {
> 	struct task_struct *task;
> 	struct pt_regs regs, *reg;
>
>         reg = kernel_thread_regs(&regs, fn, arg);
> 	task = copy_process(&init_task, flags, 0, reg, 0, NULL, NULL, NULL, 0);
> 	if (!IS_ERR(task))
> 		wake_up_new_task(task, flags);
>
> 	return task;
> }

First, we still need some additional flag/parameter to set ->exit_state = -1.
Let's use CLONE_KERNEL_THREAD for discussion.

Now. Can we do copy_process(an_arbitrary_task) ? If yes, we need additional
locking in copy_process(). Just think about ->signal,->parent access. Nasty,
and probably not so useful.

If we can only use "current" or init_task, CLONE_KERNEL_THREAD is enough.
Just now it only

	- sets ->exit_state = -1

	- sets ->parent = &init_task

(note that the second change could be omitted, we can use CLONE_PARENT
 if we know that all users of CLONE_KERNEL_THREAD are kernel threads).

> After that daemonize just becomes:
>
> void daemonize(const char *name, ...)
> {
> 	va_list args;
>
> 	va_start(args, name);
> 	vsnprintf(current->comm, sizeof(current->comm), name, args);
> 	va_end(args);
> }
>
> And kthread_create becomes:
>
> struct task_struct *kthread_create(int (*threadfn)(void *data),
> 				   void *data,
> 				   const char namefmt[],
> 				   ...)
> {
> 	struct kthread_create_info create;
> 	struct task_struct *task;
>
> 	create.threadfn = threadfn;
> 	create.data = data;
>
> 	/* We want our own signal handler (we take no signals by default). */
>         task = __kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
> 	if (!IS_ERR(task)) {
> 		va_list args;
> 		va_start(args, namefmt);
> 		vsnprintf(task->comm, sizeof(task->comm),  namefmt, args);
> 		va_end(args);
> 	}
>         return task;
> }

Yes, nice. This is not complete, we still have to wait for completion,
because kthread_create() promises that a new thread has no CPU on
return (so we can use kthread_bind() for example), but nice anyway.

> If we are willing to go that far.  I think it is worth it to touch the
> architecture specific code.  As that removes an unnecessary wait
> queue, and ensures that kernel threads always start with a consistent
> state.  So it is a performance, scalability and simplicity boost.

Yes.

But note that CLONE_KERNEL_THREAD allows us to achieve the same step by
step. For example, we can extend the meaning of CLONE_KERNEL_THREAD to
use init_task.mm in copy_mm(), then copy_fs(), etc.

Eric, I am far from sure I am right though. Probably it is better to do
one big change as you suggested.

However, I like the idea of for-in-kernel-only CLONE_ flags. For example,
we can kill the ugly "pid" parameter of copy_process() and use CLONE_IDLE
instead.

Also, we can't use __kernel_thread() you propose if we want do_wait(),
using CLONE_ flags a bit more flexible.

BTW. I think your idea of kernel_thread_regs() is very nice in any case. Is
it enough (and possible) to implement an architecture neutral kernel_thread?

Oleg.


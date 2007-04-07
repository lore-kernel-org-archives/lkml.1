Return-Path: <linux-kernel-owner+w=401wt.eu-S966340AbXDGUb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966340AbXDGUb4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 16:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966342AbXDGUb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 16:31:56 -0400
Received: from mail.screens.ru ([213.234.233.54]:59419 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966340AbXDGUby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 16:31:54 -0400
Date: Sun, 8 Apr 2007 00:31:25 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070407203125.GA6032@tv-sign.ru>
References: <20070406084250.GA179@tv-sign.ru> <m18xd5amwq.fsf@ebiederm.dsl.xmission.com> <20070406094413.GA673@tv-sign.ru> <m1lkh58q16.fsf@ebiederm.dsl.xmission.com> <20070406154750.GA541@tv-sign.ru> <Pine.LNX.4.64.0704061013060.6730@woody.linux-foundation.org> <20070406193621.GA96@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406193621.GA96@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06, Oleg Nesterov wrote:
> 
> Perhaps,
> 
> --- t/kernel/exit.c~	2007-04-06 23:31:31.000000000 +0400
> +++ t/kernel/exit.c	2007-04-06 23:31:57.000000000 +0400
> @@ -275,10 +275,7 @@ static void reparent_to_init(void)
>  	remove_parent(current);
>  	current->parent = child_reaper(current);
>  	current->real_parent = child_reaper(current);
> -	add_parent(current);
> -
> -	/* Set the exit signal to SIGCHLD so we signal init on exit */
> -	current->exit_signal = SIGCHLD;
> +	current->exit_signal = -1;
>  
>  	if (!has_rt_policy(current) && (task_nice(current) < 0))
>  		set_user_nice(current, 0);
> 
> is enough. init is still our parent (make ps happy), but it can't see us,
> we are not on ->children list.

OK, this doesn't work. A multi-threaded init may do execve(). Can we forbid
exec() from non-main thread? init is special anyway. We can simplify de_thread()
in this case, and kill tasklist_lock around zap_other_threads().

So, we can re-parent a kernel thread to swapper. In that case it doesn't matter
if we put task on ->children list or not.

User-visible change. Acceptable?

> Off course, we also need to add preparent_to_init() to kthread() and
> (say) stopmachine(). Or we can create kernel_thread_detached() and
> modify callers to use it.

It would be very nice to introduce CLONE_KERNEL_THREAD instead, then

	--- kernel/fork.c~	2007-04-07 20:11:14.000000000 +0400
	+++ kernel/fork.c	2007-04-07 23:40:35.000000000 +0400
	@@ -1159,7 +1159,8 @@ static struct task_struct *copy_process(
		p->parent_exec_id = p->self_exec_id;
	 
		/* ok, now we should be set up.. */
	-	p->exit_signal = (clone_flags & CLONE_THREAD) ? -1 : (clone_flags & CSIGNAL);
	+	p->exit_signal = (clone_flags & (CLONE_THREAD|CLONE_KERNEL_THREAD))
	+					? -1 : (clone_flags & CSIGNAL);
		p->pdeath_signal = 0;
		p->exit_state = 0;
	 
	@@ -1196,6 +1197,8 @@ static struct task_struct *copy_process(
		/* CLONE_PARENT re-uses the old parent */
		if (clone_flags & (CLONE_PARENT|CLONE_THREAD))
			p->parent = current->parent;
	+	else if (unlikely(clone_flags & CLONE_KERNEL_THREAD))
	+		p->parent = &init_task;
		else
			p->parent = current;

That is all, very simple. However, in that case we should introduce

	#define SYS_CLONE_MASK	(~CLONE_KERNEL_THREAD)

and change every sys_clone() implementation to filter out non-SYS_CLONE_MASK
flags. This is trivial (and imho useful), but

	arch/sparc/kernel/process.c
	arch/sparc64/kernel/process.c
	arch/m68knommu/kernel/process.c
	arch/m68k/kernel/process.c
	arch/alpha/kernel/entry.S
	arch/h8300/kernel/process.c
	arch/v850/kernel/process.c
	arch/frv/kernel/kernel_thread.S
	arch/frv/kernel/kernel_thread.S
	arch/powerpc/kernel/misc_32.S
	arch/powerpc/kernel/misc_64.S

implement kthread_create() via sys_clone(). This means that without additional
effort from mainteners these arches can't take advantage of CLONE_KERNEL_THREAD.

Dear CC list, any advice?

Oleg.


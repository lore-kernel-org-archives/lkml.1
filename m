Return-Path: <linux-kernel-owner+w=401wt.eu-S1767668AbXCIXpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767668AbXCIXpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767669AbXCIXpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:45:53 -0500
Received: from mail.screens.ru ([213.234.233.54]:47893 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767668AbXCIXpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:45:52 -0500
Date: Sat, 10 Mar 2007 02:46:02 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel threads
Message-ID: <20070309234602.GA188@tv-sign.ru>
References: <20070309205205.GA173@tv-sign.ru> <20070309213852.059FC1801C4@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309213852.059FC1801C4@magilla.sf.frob.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09, Roland McGrath wrote:
>
> > Yes sure, this change shoud be tested in -mm tree (I'll send the patch
> > on Sunday after some testing). The only (afaics) problem is that with
> > this change a kernel thread must not do do_fork(CLONE_THREAD). 
> 
> To clarify, the danger here is that an exit_signal=-1 leader would
> self-reap and leave behind live threads with dangling ->group_leader
> pointers.  This danger doesn't exist for normal user group leaders with
> parents ignoring SIGCHLD, because exit_signal is never set to -1 until
> do_notify_parent, which is never called until the last thread in the group
> dies (except when ptrace'd, but then do_notify_parent never resets
> exit_signal at all).  Is that right?

I think yes.

> > I think it should not, but currently this is technically
> > possible. Perhaps it makes sense to add BUG_ON(CLONE_THREAD &&
> > group_leader->exit_signal==-1) in copy_process().
>
> It probably wouldn't hurt to make it:
>
> 	if (user_mode(regs))
> 		BUG_ON(current->group_leader->exit_signal == -1);

Well, this is of course right, but a bit strange. Because we can add
this check to any function which can't be called after exit_notify().

> 	else
> 		BUG_ON((clone_flags & (CLONE_THREAD|CLONE_UNTRACED))
> 		       != CLONE_UNTRACED);

I think this _should_ be right, but please note that fork_idle() does
copy_process(CLONE_VM). Also, we may have some external driver which
plays with do_fork/copy_process.

> > While we are talking about kernel threads, there is something I can't
> > undestand. kthread/daemonize use sigprocmask(SIG_BLOCK) to protect
> > against signals. This doesn't look right to me, because this doesn't
> > prevent the signal delivery, this only blocks signal_wake_up(). Every
> > "killall -33 khelper" means a "struct siginfo" leak.
>
> It does prevent the delivery (signal_pending() never set), but not the queuing.

Yep.

> > Imho, the kernel thread shouldn't play with ->blocked at all. Instead
> > it should set SIG_IGN for all handlers. If it really needs, say, SIGCHLD,
> > it should call allow_signal() anyway. Do you see any problems with this
> > approach?
>
> That sounds reasonable to me generally.  However, if kernel threads ever
> spawn user children, they may not want the self-reaping behavior of
> ignoring SIGCHLD even if they never dequeue the signal (because they want
> to call do_wait).

Yes. That is why wait_for_helper() does allow_signal(SIGCHLD). I think a
kernel thread must not make any assumption about ->action[SIGCHLD] if it
wants to call wait4, but we may break some "buggy" external driver.

In fact, most threads inherit action[SIGCHLD] == SIG_IGN from worker_thread().

BTW, wait_for_helper() does do_sigaction() before allow_signal(). Looks
unneeded to me.

>                    There might be other strange caveats like that I'm not
> thinking of.

Yes, this makes me worry too :)

Oleg.


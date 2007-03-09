Return-Path: <linux-kernel-owner+w=401wt.eu-S1766898AbXCIVi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766898AbXCIVi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:38:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767553AbXCIVi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:38:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766898AbXCIVi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:38:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel threads
In-Reply-To: Oleg Nesterov's message of  Friday, 9 March 2007 23:52:05 +0300 <20070309205205.GA173@tv-sign.ru>
Emacs: a real time environment for simulating molasses-based life forms.
Message-Id: <20070309213852.059FC1801C4@magilla.sf.frob.com>
Date: Fri,  9 Mar 2007 13:38:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes sure, this change shoud be tested in -mm tree (I'll send the patch
> on Sunday after some testing). The only (afaics) problem is that with
> this change a kernel thread must not do do_fork(CLONE_THREAD). 

To clarify, the danger here is that an exit_signal=-1 leader would
self-reap and leave behind live threads with dangling ->group_leader
pointers.  This danger doesn't exist for normal user group leaders with
parents ignoring SIGCHLD, because exit_signal is never set to -1 until
do_notify_parent, which is never called until the last thread in the group
dies (except when ptrace'd, but then do_notify_parent never resets
exit_signal at all).  Is that right?

> I think it should not, but currently this is technically
> possible. Perhaps it makes sense to add BUG_ON(CLONE_THREAD &&
> group_leader->exit_signal==-1) in copy_process().

It probably wouldn't hurt to make it:

	if (user_mode(regs))
		BUG_ON(current->group_leader->exit_signal == -1);
	else
		BUG_ON((clone_flags & (CLONE_THREAD|CLONE_UNTRACED))
		       != CLONE_UNTRACED);

> 	zap_other_threads:
> 
> 		if (t != p->group_leader)
> 			t->exit_signal = -1;
> 
> looks like another leftover to me, we already depend on the fact that
> all sub-threads have ->exit_signal == -1 (otherwise, for example, a
> thread group just can't exit properly).

Yes, I agree it looks superfluous.

> While we are talking about kernel threads, there is something I can't
> undestand. kthread/daemonize use sigprocmask(SIG_BLOCK) to protect
> against signals. This doesn't look right to me, because this doesn't
> prevent the signal delivery, this only blocks signal_wake_up(). Every
> "killall -33 khelper" means a "struct siginfo" leak.

It does prevent the delivery (signal_pending() never set), but not the queuing.

> Imho, the kernel thread shouldn't play with ->blocked at all. Instead
> it should set SIG_IGN for all handlers. If it really needs, say, SIGCHLD,
> it should call allow_signal() anyway. Do you see any problems with this
> approach?

That sounds reasonable to me generally.  However, if kernel threads ever
spawn user children, they may not want the self-reaping behavior of
ignoring SIGCHLD even if they never dequeue the signal (because they want
to call do_wait).  There might be other strange caveats like that I'm not
thinking of.  


Thanks,
Roland


Return-Path: <linux-kernel-owner+w=401wt.eu-S1767499AbXCIUwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767499AbXCIUwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 15:52:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767501AbXCIUwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 15:52:01 -0500
Received: from mail.screens.ru ([213.234.233.54]:46979 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767499AbXCIUwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 15:52:00 -0500
Date: Fri, 9 Mar 2007 23:52:05 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel threads
Message-ID: <20070309205205.GA173@tv-sign.ru>
References: <20070308163844.GA6638@tv-sign.ru> <20070309003100.9893B180063@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309003100.9893B180063@magilla.sf.frob.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Roland McGrath wrote:
>
> Your change seems fine to me.  I certainly concur that it seems insane
> for init to be responsible for tasks created magically inside the
> kernel.  The history I've found says that the setting to SIGCHLD was
> introduced as part of "v2.5.1.9 -> v2.5.1.10", without detailed
> commentary in the log.  This was probably before the auto-reaping
> semantics worked as they do now.  So like the man said, at the time,
> it seemed the logical thing to do.
>
> To be paranoid, I wouldn't make this change in any stable kernel series.
> It changes behavior visible to userland (init) from how it has been
> consistently for five years, so, who knows, something might notice.
> The old behavior is pretty harmless, albeit changing it seems both
> preferable and harmless.

Yes sure, this change shoud be tested in -mm tree (I'll send the patch
on Sunday after some testing). The only (afaics) problem is that with
this change a kernel thread must not do do_fork(CLONE_THREAD). I think
it should not, but currently this is technically possible. Perhaps it
makes sense to add BUG_ON(CLONE_THREAD && group_leader->exit_signal==-1)
in copy_process().

On a related note,

	zap_other_threads:

		if (t != p->group_leader)
			t->exit_signal = -1;

looks like another leftover to me, we already depend on the fact that
all sub-threads have ->exit_signal == -1 (otherwise, for example, a
thread group just can't exit properly).


While we are talking about kernel threads, there is something I can't
undestand. kthread/daemonize use sigprocmask(SIG_BLOCK) to protect
against signals. This doesn't look right to me, because this doesn't
prevent the signal delivery, this only blocks signal_wake_up(). Every
"killall -33 khelper" means a "struct siginfo" leak.

Imho, the kernel thread shouldn't play with ->blocked at all. Instead
it should set SIG_IGN for all handlers. If it really needs, say, SIGCHLD,
it should call allow_signal() anyway. Do you see any problems with this
approach?

Oleg.


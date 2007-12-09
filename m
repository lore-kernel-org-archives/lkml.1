Return-Path: <linux-kernel-owner+w=401wt.eu-S1752295AbXLIOEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbXLIOEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 09:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbXLIOEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 09:04:37 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:48160 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbXLIOEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 09:04:36 -0500
Date: Sun, 9 Dec 2007 17:05:25 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ptrace_stop: remove the wrong ->group_stop_count bookkeeping
Message-ID: <20071209140525.GA131@tv-sign.ru>
References: <20071208183801.GA9943@tv-sign.ru> <m1wsroogi0.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wsroogi0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> > ptrace_stop() decrements ->group_stop_count to "participate" in group stop.
> > This looks very wrong to me, the task can in fact decrement this counter twice.
> > If the tracee returns to the user-space before other threads complete the group
> > stop, it will notice TIF_SIGPENDING and do it again.
> 
> This is one of those interesting weird cases.  The ptrace interface remains per
> task.
> 
> So need to handle a simultaneous thread group stop and a per task stop.
> 
> 
> >
> > Another problem is that we don't set SIGNAL_STOP_STOPPED if the counter becomes
> > zero.
> >
> > I must admit, I don't undestand the reason why this code was added, it is very
> > old.
> 
> I haven't dug in enough yet to understand better, but it is my hunch we
> need to do something when we have both kinds of stop happening simultaneously.

Looking further, I think it was done to match the !is_task_stopped_or_traced()
check in do_signal_stop().

Still, I don't understand why we really need this decrement. The ptrace interface
needs only per-thread TASK_TRACED ot TASK_STOPPED, it doesn't need the completion
of the group stop. We can delay the completion of the group stop, but why this is
bad? At worse, the tracer recieves the extra CLD_STOPPED when the tracee resumes.
And do_signal_stop() probably can s/is_task_stopped_or_traced/is_task_stopped/.

OK, it is better to ignore this patch, I don't understand all implications of this
change. But this all doesn't look very good. Suppose we have a lot of threads and
the task with _TIF_SYSCALL_TRACE does system call. So ptrace_notify() decrements
the counter before syscall, after, and before the return to user-space.

Hopefully Roland can clarify.

Oleg.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761040AbZE2TLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761040AbZE2TLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 15:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZE2TLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 15:11:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44161 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbZE2TK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 15:10:59 -0400
Date: Fri, 29 May 2009 21:06:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, jan.kratochvil@redhat.com,
       Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: ptrace && task->exit_code
Message-ID: <20090529190627.GA7017@redhat.com>
References: <20090525000016.GA2239@redhat.com> <20090525215903.GA9113@redhat.com> <20090527021131.4778BFC36B@magilla.sf.frob.com> <20090527224140.GC6770@redhat.com> <20090527230523.GA10032@redhat.com> <20090527232141.8B24DFC2BD@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527232141.8B24DFC2BD@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27, Roland McGrath wrote:
>
> > I didn't realize this until yesterday, but perhaps it makes sense
> > to decouple ptrace && task_struct->exit_code?
>
> I've long thought this was an attractive idea.  But it seems to have lots
> of complications at least as long as ptrace-wait shares so much code with
> normal wait.  I'd figured this might be one of the last things we clean up
> after ptrace is disentangled from core data structures in most every other
> way.
>
> > This is not completely trivial, needs another short series.
>
> I suspect it is more hassle than benefit to do this now.
> I don't think it is the right priority.
>
> > And. I spent a lot of time, but I can't see how to solve the problems
> > with TASK_STOPPED tasks if we do this change.
>
> I bet the complications of this all will be substantially different after
> we change the ptrace locking.  So let's not worry about it yet.

I just can't stop thinking of it ;)

Perhaps I missed something, but except the problem above this does not
look too hard. How about something like this:

	--- a/kernel/ptrace.c
	+++ b/kernel/ptrace.c
	@@ -228,7 +228,11 @@ int ptrace_attach(struct task_struct *task)
	 
		__ptrace_link(task, current);
	 
	-	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
	+	spin_lock(task->signal->siglock);
	+	if (task_is_stopped(task) && !task->exit_code)
	+		task->exit_code = SIGSTOP;
	+	specific_send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
	+	spin_unlock(task->signal->siglock);
	 bad:
		write_unlock_irqrestore(&tasklist_lock, flags);
		task_unlock(task);

?

If we attach, and the task is already stopped, this really means
it was traced and untraced. We can set ->exit_code = SIGSTOP to
ensure do_wait() will succeed.

This also relates to attach-wait-on-stopped test-case, I cc'ed
Jan and Denys.

Note also that after

	do_wait: fix waiting for the group stop with the dead leader
	commit: 90bc8d8b1a38f1ab131a2399a202e1889db95de8

we can't confuse task->real_parent waiting for jctl stop.

What do you think?

Oleg.


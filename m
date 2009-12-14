Return-Path: <linux-kernel-owner+w=401wt.eu-S932301AbZLNRrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbZLNRrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 12:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932264AbZLNRri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 12:47:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244AbZLNRrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 12:47:37 -0500
Date: Mon, 14 Dec 2009 18:41:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Roland McGrath <roland@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 14/14] utrace core
Message-ID: <20091214174127.GA9315@redhat.com>
References: <20091124200220.GA5828@redhat.com> <1259697242.1697.1075.camel@laptop> <20091214002533.3052519@magilla.sf.frob.com> <1260798696.4165.316.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260798696.4165.316.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14, Peter Zijlstra wrote:
>
> > > Quite gross this.. can't we key off the
> > > tracehoook_report_clone_complete() and use a wakeup there?
> >
> > Yes, we intended to clean this up at some point later.  But doing that
> > is just a distraction and complication right now so we put it off.  For
> > this case, however, I suppose we could just punt for the initial version.
> >
> > This code exists to support the special semantics of calling
> > utrace_attach_task() from inside the parent's report_clone() callback.
> > That guarantees the parent that it wins any race with any third thread
> > calling utrace_attach_task().
>
> > This guarantees it will be first attacher
> > in the callback order, but the general subject of callback order is
> > already something we think we will want to revisit in the future after
> > we have more experience with lots of different engines trying to work
> > together.
>
> > It's most meaningful when using the UTRACE_ATTACH_EXCLUSIVE
> > flag -- then you can use UTRACE_ATTACH_EXCLUSIVE|UTRACE_ATTACH_MATCH_OPS
> > to synchronize with other threads trying to attach the same kind of
> > engine to a task, and give special priority in that to the engine that
> > attaches in report_clone() from tracing the parent.
>
> As to the content, can't you accomplish the same thing by processing
> such exclusive parent registration before exposing the child in the
> pid-hash? Right before cgroup_fork_callback() in
> kernel/fork.c:copy_process() seems like the ideal site.

I thought about this too, but there are some complications. Just for
example, what if copy_process() fails after we already reported the
new child was attached. And, the new child is not properly initialized
yet, it doesn't even have the valid pid/real_parent/etc. Just imagine
a callback wants to record task_pid_vnr(). Or it decides to send a
fatal signal (even private) to the new tracee.

> Best would be to fix up the utrace-ptrace implementation and get rid of
> those other kludges I think, not sure.. its all a bit involved and I'm
> not at all sure I'm fully aware of all the ptrace bits.

It is not that utrace-ptrace is buggy. We try to preserve the current
semantics. Yes, we can move this kludge to ptrace layer, but I am not
sure about other UTRACE_ATTACH_EXCLUSIVE engines.

If we move this to ptrace, then we can probably mark the new child
as "ptrace_attach() should fail, because we are going to auto-attach".
But in this case we need multiple hooks in do_fork() path again, like
the old ptrace does, while utrace needs only one.

> The major improvement this utrace stuff brings over the old ptrace is
> that it fully multiplexes the task tracing bits, however if the new bit
> isn't powerful enough to express all of the old bits with that then that
> seems to take the shine of the new bits.

Note that it would be easy to add another callback, and hide this
special case. But we should think twice before doing this.

> I'm well aware that ptrace had some quirky bits in, and this might well
> be one of the crazier parts of it, but to the un-initiated reviewer (me)
> this could have done with a comment explaining exactly why this
> particular site is not worth properly abstracting etc..

Well, agreed.

> > In the "pretty soon" case, that means set_notify_resume:
> > 	if (!test_and_set_tsk_thread_flag(task, TIF_NOTIFY_RESUME))
> > 		kick_process(task);
> > i.e. IPI after test_and_set.  The test_and_set implies an smp_mb().
> > So it should be the case that the set of utrace->pending_attach was seen
> > before the set of TIF_NOTIFY_RESUME.
>
> Not exactly sure where the matching rmb() would come from in
> start_report() and friends -- task_utrace_struct() ?

I am a bit confused...

As Roland said, we don't have any "timing" guarantees, and we can't have.
Whatever we do, the tracee can miss, say, ->report_syscall_entry() event
even if it does a system call "after" utrace_set_events(UTRACE_EVENT_SYSCALL),
this is fine.

But it shouldn't miss TIF_NOTIFY_RESUME/signal_pending/etc. I mean,
"sooner or later" it must hanlde the signal or TIF_NOTIFY_RESUME. And in
this case we can't miss ->pending_attach.

IOW, we must ensure that if ever clear TIF_NOTIFY_RESUME we must not
miss ->pending_attach, correct? and for this case we have mb() after
clear_thread_flag(). Perhaps instead we should add mb__after_clear_bit()
into arch/ hooks, but this needs a lot of arch-dependent changes.



And, btw, the usage of ->replacement_session_keyring looks racy,
exactly because (without utracee) we done have the necessary barriers
on both sides.

Oleg.


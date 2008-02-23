Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbYBWRhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbYBWRhW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 12:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYBWRhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 12:37:09 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:56097 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbYBWRhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 12:37:07 -0500
Date: Sat, 23 Feb 2008 12:35:52 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl, apw@shadowen.org,
       mingo@elte.hu, nickpiggin@yahoo.com.au, paulmck@linux.vnet.ibm.com,
       rusty@rustcorp.com.au, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: + kthread-add-a-missing-memory-barrier-to-kthread_stop.patch
 added to -mm tree
In-Reply-To: <20080223162705.GA7686@tv-sign.ru>
Message-ID: <Pine.LNX.4.58.0802231201090.29347@gandalf.stny.rr.com>
References: <200802230733.m1N7XnMu018253@imap1.linux-foundation.org>
 <20080223162705.GA7686@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 23 Feb 2008, Oleg Nesterov wrote:

> (s/mm-commits/lkml, cc Steven and Linus).

Thanks,

>
> On 02/22, Andrew Morton wrote:
> >
> > From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> >
> > We must ensure that kthread_stop_info.k has been updated before kthread's
> > wakeup.  This is required to properly support the use of kthread_should_stop()
> > in the main loop of kthread.
> >
> > wake_up_process() doesn't imply a full memory barrier,
> > so we add an explicit one.
>
> I tried to raise the similar issue twice without success.
>


> I think we should fix wake_up_process() instead.

At first I was thinking that this may be too much on such an highly used
API. But you may be right. I did a quick seach on who uses
wake_up_process. I randomly picked one.  ptrace.

I think we have a bug there. And this was just by randomly looking at
it.

In kernel/ptrace.c: ptrace_resume

        child->exit_code = data;
        wake_up_process(child);


Again, there's no guarantee that exit_code will equal data when the child
wakes up.

And in something like do_syscall_trace, we have

        ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD) ?
0x80:0));

        /*
         * this isn't the same as continuing with a signal, but it will do
         * for normal use.  strace only continues with a signal if the
         * stopping signal is not SIGTRAP.  -brl
         */
        if (current->exit_code) {


ptrace_notify eventually calls ptrace_stop which schedules. This is what
gets woken up. There is a possible chance that current->exit_code will not
equal data in the ptrace_resume code. That is, if wake_up_process implies
no barrier.

I would recommend having a wake_up_process version that does not imply a
barrier, so we can keep straight forward wakeups fast and not
unnecessarily add barriers.

Good catch Oleg!

-- Steve


>
> Please look at http://marc.info/?l=linux-kernel&m=118503598307267
> and at this thread: http://marc.info/?t=116275561700001
>
> In short: wake_up_process() doesn't imply mb(), this means that _in theory_
> the commonly used code like
>
> 	set_current_state(TASK_INTERRUPTIBLE);
> 	if (CONDITION)
> 		return;
> 	schedule();
>
> is racy wrt
>
> 	CONDITION = 1;
> 	wake_up_process(p);
>
> I'll be happy to be wrong though, please correct me.
>
> Oleg.
>
>

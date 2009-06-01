Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbZFACRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbZFACRR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 22:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbZFACRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 22:17:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905AbZFACRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 22:17:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, jan.kratochvil@redhat.com,
       Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: ptrace && task->exit_code
In-Reply-To: Oleg Nesterov's message of  Friday, 29 May 2009 21:06:27 +0200 <20090529190627.GA7017@redhat.com>
References: <20090525000016.GA2239@redhat.com>
	<20090525215903.GA9113@redhat.com>
	<20090527021131.4778BFC36B@magilla.sf.frob.com>
	<20090527224140.GC6770@redhat.com>
	<20090527230523.GA10032@redhat.com>
	<20090527232141.8B24DFC2BD@magilla.sf.frob.com>
	<20090529190627.GA7017@redhat.com>
X-Zippy-Says: HERE!!  Put THIS on!!  I'm in CHARGE!!
Message-Id: <20090601021629.E9F7FFC3C7@magilla.sf.frob.com>
Date: Sun, 31 May 2009 19:16:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If we attach, and the task is already stopped, this really means
> it was traced and untraced. We can set ->exit_code = SIGSTOP to
> ensure do_wait() will succeed.

If you go that route you really need a do_notify_parent_cldstop() call too.
Obviously the tracer itself won't be blocked in wait while it's in the
middle of this ptrace call.  But it might be relying on a designated thread
calling wait, or it might call wait only when provoked by SIGCHLD, etc.

If you do that, you might as well just do:

	spin_lock(task->signal->siglock);
	specific_send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
	signal_wake_up(task, 1);
	spin_unlock(task->signal->siglock);

That way PTRACE_ATTACH would have a uniform effect on task whether it
was stopped or not.  It always gives the tracer a fresh stop, never
leaves another SIGSTOP queued afterwards, and it's always a proper
ptrace stop where the debugger gets the full range of options like
injecting a new signal and using PTRACE_SETSIGINFO.  (OTOH, then the
debugger can't necessarily tell if the task had been stopped or not
before the attach.)

Jan will probably affirm that userland debuggers wish it had always been
this way.  But real userland debuggers already cope with existing
kernels and will have to continue to cope with old kernels for a long
time to come.  So I don't see that it buys anything to change it now.

> This also relates to attach-wait-on-stopped test-case, I cc'ed
> Jan and Denys.
> 
> Note also that after
> 
> 	do_wait: fix waiting for the group stop with the dead leader
> 	commit: 90bc8d8b1a38f1ab131a2399a202e1889db95de8
> 
> we can't confuse task->real_parent waiting for jctl stop.

Hmm.  I had not thought about how the 90bc8d8 change to touch
group_exit_code instead for real parents affected this ptrace area.

That means that PTRACE_ATTACH while already stopped but not waited-for
no longer "steals" the real parent's tracking of the child's stoppedness
when it had not yet done a wait after its SIGCHLD/wakeup.  After detach,
that wait could happen just like it would have before the debugger came
along.  However, nothing will wake up the parent's wait if it's already
blocked in one at detach time.


Thanks,
Roland

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZLRDy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZLRDy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 22:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755786AbZLRDyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 22:54:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755570AbZLRDyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 22:54:24 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: x86: do_debug && PTRACE_SINGLESTEP broken by
	08d68323d1f0c34452e614263b212ca556dae47f
In-Reply-To: Oleg Nesterov's message of  Friday, 18 December 2009 03:10:42 +0100 <20091218021042.GA508@redhat.com>
References: <20091218005650.GA20667@redhat.com>
	<20091218014021.CB474135F@magilla.sf.frob.com>
	<20091218021042.GA508@redhat.com>
X-Zippy-Says: ..  or were you driving the PONTIAC that HONKED at me in MIAMI last
    Tuesday?
Message-Id: <20091218035345.A002F135F@magilla.sf.frob.com>
Date: Thu, 17 Dec 2009 19:53:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	dr6 = tsk->thread.debugreg6;
> 
> why? we have "tsk->thread.debugreg6 = dr6" above

Yeah, it's a little superfluous.  Except that the existing code uses
tsk->thread.debugreg6 and dr6 inconsistently.  It only matters either way
if some notifier function might change thread.debugreg6, which I wasn't
sure that none might.  i.e., does/should hw_breakpoint hide/remap the
watchpoint-fired bits when they are not for the same-numbered,
ptrace-installed virtual debugreg?  And does/should kprobes, kgdb, and
whatnot, hide DR_STEP from thread.debugreg6 for a step that's not from
user_enable_single_step?

> >  	if ((dr6 & DR_STEP) && !user_mode(regs)) {
> >  		tsk->thread.debugreg6 &= ~DR_STEP;
> >  		set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
> >  		regs->flags &= ~X86_EFLAGS_TF;
> 
> this looks strange... we set TIF_SINGLESTEP but clear X86_EFLAGS_TF

This was the original purpose of TIF_SINGLESTEP from long, long ago.  This
happens when TF was set in user mode and then it did syscall/sysenter so TF
is still set at the first instruction in kernel mode.  TF is cleared from
the interrupted kernel registers so the kernel can resume normally.  In the
original logic, TIF_SINGLESTEP served just to make it turn TF back on when
going to user mode.  Since then we grew the complicated step.c stuff and
it all fits together slightly differently than it did when the original
traps.c path was written.

> can't understand how this change can fix the problem. We should always
> send SIGTRAP if the task returns to user-mode with X86_EFLAGS_TF?

If the debug exception happened in user mode, then we should send SIGTRAP.

In the old (2.6.32) code with its goto-heavy logic the !user_mode(regs)
was goto clear_TF_reenable; and that is:

	clear_TF_reenable:
		set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
		regs->flags &= ~X86_EFLAGS_TF;
		preempt_conditional_cli(regs);
		return;

I thought the new logic was falling through to the send_sigtrap case after
"if ((dr6 & DR_STEP) && !user_mode(regs))".  But now I see that the subtle
use of dr6 vs tsk->thread.debugreg6 (without comments about it!) meant
that DR_STEP is cleared from tsk->thread.debugreg6 before we test it.

So I guess the idea there is that the !user_mode case would swallow the
step indication but still leave some DR_TRAP_BITS set and so you'd generate
a user SIGTRAP in honor of those (i.e. watchpoint hits).  But I thought the
hardware behavior was that a step will set DR_STEP in DR6 but not clear any
DR_TRAP_BITS set from before, so I'm not sure this can't sometimes send a
SIGTRAP twice for a combination of a watchpoint hit and a delayed step.

> OK. I blindly applied this patch, step-simple still fails.

Yeah, it was a quick reaction to the funny-looking control flow.
But I didn't really investigate what is actually happening.


Thanks,
Roland

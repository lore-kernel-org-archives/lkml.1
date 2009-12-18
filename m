Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZLRReN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZLRReN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbZLRReM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:34:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149AbZLRReG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:34:06 -0500
Date: Fri, 18 Dec 2009 18:27:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: x86: do_debug && PTRACE_SINGLESTEP broken by
	08d68323d1f0c34452e614263b212ca556dae47f
Message-ID: <20091218172747.GA10924@redhat.com>
References: <20091218005650.GA20667@redhat.com> <20091218030601.GB16470@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218030601.GB16470@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18, Frederic Weisbecker wrote:
>
> On Fri, Dec 18, 2009 at 01:56:50AM +0100, Oleg Nesterov wrote:
> > Hi.
> >
> > do_debug() is obviously wrong wrt PTRACE_SINGLESTEP/TIF_SINGLESTEP, no?
> >
> > Afaics this was broken by
> >
> > 	hw-breakpoints: modifying generic debug exception to use thread-specific debug registers
> > 	commit 08d68323d1f0c34452e614263b212ca556dae47f
> >
> > To verify, the "patch" below fixes the stepping for me, not sure what
> > is the proper fix...
> >
> > Oleg.
> >
> > --- arch/x86/kernel/traps.c~	2009-12-18 00:20:49.000000000 +0100
> > +++ arch/x86/kernel/traps.c	2009-12-18 01:44:05.000000000 +0100
> > @@ -575,7 +575,7 @@ dotraplinkage void __kprobes do_debug(st
> >  		regs->flags &= ~X86_EFLAGS_TF;
> >  	}
> >  	si_code = get_si_code(tsk->thread.debugreg6);
> > -	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS))
> > +//	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS))
> >  		send_sigtrap(tsk, regs, error_code, si_code);
>
>
>
> But I don't understand why it is broken with the check.
> If we are in a singlestep exception, dr6 should have its
> DR_STEP bit set...
>
> Single stepping works well for me, after a quick check on
> gdb. How did you trigger the bug?

Please find the trivial test-case below. It hangs, because
PTRACE_SINGLESTEP doesn't trigger the trap.

(not sure this matters, but I did the testing under kvm)

Oleg.

#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <sys/ptrace.h>
#include <sys/wait.h>
#include <assert.h>

int main(void)
{
	int pid, status, i;

	pid = fork();
	if (!pid)
		for (;;);

	sleep(1);
	assert(ptrace(PTRACE_ATTACH, pid, 0,0) == 0);

	assert(pid == wait(&status));
	assert(WIFSTOPPED(status));

	for (i = 0; i < 10; ++i) {
		assert(ptrace(PTRACE_SINGLESTEP, pid, 0,0) == 0);

		printf("wait %d ...\n", i);
		assert(pid == wait(&status));

		assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGTRAP);
	}

	kill(pid, SIGKILL);
	return 0;
}


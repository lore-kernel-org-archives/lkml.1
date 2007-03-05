Return-Path: <linux-kernel-owner+w=401wt.eu-S933095AbXCELAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095AbXCELAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 06:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933133AbXCELAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 06:00:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933095AbXCELAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 06:00:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
X-Fcc: ~/Mail/utrace
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: arm utrace
In-Reply-To: Russell King's message of  Saturday, 3 March 2007 18:03:00 +0000 <20070303180300.GA10382@flint.arm.linux.org.uk>
X-Zippy-Says: I predict that by 1993 everyone will live in and around LAS VEGAS
   and wear BEATLE HAIRCUTS!
Message-Id: <20070305104114.1BFC1180055@magilla.sf.frob.com>
Date: Mon,  5 Mar 2007 02:41:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the feedback, and sorry for the typo in my email address in the
porting howto (I've fixed that).

> 1. support for changing the syscall number.  From the changes which
>    Roland has done in arch/arm/kernel/ptrace.c, it seems that we are
>    no longer allowed to change the syscall number.  Why is this?

Any changes I made in arch code were part of mass query-replace changes and
other things I did while grepping for symbols I was removing.  I didn't
intend to remove any useful code and anything changing something wrongly
was an error on my part probably due to misunderstanding the arch code.  
I was just trying to leave arch's I wasn't porting myself slightly closer
to a compilable state.  I'd be glad to amend anything in the patch that is
not right.

>    We need to support a special "SET_SYSCALL" call which is passed the
>    new syscall number.  This needs to be passed to the child, and
>    when the child returns from syscall_trace(), it needs to return this
>    new data as the system call number.

I see.  I don't understand why you don't use regs->ARM_ORIG_r0 for this,
but I am not the expert.  If in fact there is no slot in struct pt_regs
that is right to use, the utrace way to do this is to add another regset
containing just the one word of "syscall about to be made".  It only needs
to be meaningfully settable and gettable when at the syscall entry stop.
Your PTRACE_SET_SYSCALL support would use this.

> 2. tracehook_abort_syscall can not be supported on ARM - syscall numbers
>    aren't (always) passed through the register set.

We can change the signature to (struct task_struct *, struct pt_regs *).
Then following the above plan it can do tsk->thread.syscall = -1.

> 3. single step support.  no idea how to do this with utrace; the
>    documentation seems to imply that utrace will not support software-
>    based single stepping when it involves modifying the text, and that
>    it can continue to be supported via the ptrace compatibility.
> 
>    Since this is the only way to do single stepping on ARM, this means
>    that we need to support ptrace indefinitely.

What those remarks mean is that UTRACE_ACTION_SINGLESTEP will only ever be
for something with semantics like hardware single-step support has, i.e. no
side effects on memory or anything else outside the thread's CPU state.
That is not to say that software single-step will never be implemented in
the utrace world.  

What you need is temporary breakpoint insertion, ideally a breakpoint that
would be per-thread.  Eventually we will have a general facility based on
utrace that provides breakpoints, and later per-thread breakpoints, and it
will get improved over time.  New things using utrace can see
ARCH_HAS_SINGLE_STEP not set and fall back to using breakpoint insertion,
and they will know the different ramifications it might have on the
semantics or performance compared to a machine where UTRACE_ACTION_SINGLESTEP
is available.  ptrace can be like this when that infrastructure is available.
In the meantime, ptrace alone can use the old code and nothing is lost.

> Finally, there's quite a bit of cleanup work which needs to be done for
> utrace - namely removing all the pesky linux/ptrace.h includes scattered
> throughout the tree.  This is by far the biggest problem I've faced in
> trying to tackle utrace soo far.

If that's the worst problem you have, we're in fat city!  I think it's good
to reduce linux/ptrace.h includes so the dependency goes away from every
place not actually dealing with ptrace.  The trap frame struct pt_regs is
traditionally defined in asm/ptrace.h, so that needs to be included in a
lot of places, but linux/ptrace.h is just ptrace hooey nothing much inside
the kernel needs to see.


Thanks,
Roland

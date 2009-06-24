Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbZFXI5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbZFXI5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 04:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbZFXI5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 04:57:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbZFXI46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 04:56:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/17] arm: asm/syscall.h (unfinished)
In-Reply-To: Russell King's message of  Friday, 19 June 2009 10:31:14 +0100 <20090619093114.GB18246@flint.arm.linux.org.uk>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
	<20090425001503.85473FC3C8@magilla.sf.frob.com>
	<20090619093114.GB18246@flint.arm.linux.org.uk>
X-Zippy-Says: TAILFINS!!  ...click...
Message-Id: <20090624085646.17BBE4059B@magilla.sf.frob.com>
Date: Wed, 24 Jun 2009 01:56:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That bit is rather hard - we maintain no global state as to whether a
> task is in a syscall or not.  We also do not maintain a global view
> of which syscall number is being executed.  The kernel just hasn't
> required either of these things before.

I understand.  This has also been true for at least one other machine
(though on others this has turned out to be easy to get reliably even
though it was never explicitly planned for there either).  But lots of
people seem to think this is a really useful debugging feature worth
putting a bit of effort into implementing.  (It enables a debugger to
answer, "What is that process blocked in?"--without prior tracing setup.)

The other machine I have in mind is s390, see commit 59da2139.  That arch's
maintainer took on some new assembly hacking to make syscall_get_nr() work
in all cases, because he thought it was worth the work and whatever changes
to the kernel entry paths to support the feature.  I think that might have
entailed adding a store to some kernel entry paths, though I gather there
was a serendipitous way to replace an existing store so perhaps the hot
paths were not lengthened.

> > I also did not try to handle all the different ABI variants, which I
> > don't really understand.
> 
> There are two places that the syscall number comes from: EABI and thumb
> both use R7.  OABI puts the value in the instruction itself.
> 
> In short, I don't know what to do about this either.  I don't think
> there's a quick and simple answer.

I understand.  I would look at it in a few stages.

First, there is asm/syscall.h for use with syscall tracing.  These
are for new things coming in like ftrace-based tracers that use
TIF_SYSCALL_TRACE or its equivalent, or for userland debuggers that
use /proc/pid/syscall in concert with PTRACE_SYSCALL (instead of
using PTRACE_GETREGS or whatnot).  For these uses, syscall_get_nr()
only has to work right on a task known to be inside syscall_trace().
So current_thread_info()->syscall suffices.

That could be a reasonable first step to commit something simple.
Advise ARM users that the new /proc/pid/syscall et al are reliable
only for explicit syscall tracing features (ptrace/ftrace/utrace).
It gives bad info in other cases, but that's not the end of the
world.  Then you can consider further refinements piecemeal.

Next, there is the "What syscall is he blocked in?" case.  This is
the most-requested reason to want /proc/pid/syscall.  For this
purpose, 99.44% of the time in practice when a person asks this
question, the task will in fact be inside a system call (as opposed
to blocked in a page fault or something else like that).  (People
doing ad hoc debugging can probably tell from wchan if a block is in
a page fault, and actual experiences involving tasks blocked for
minutes in a page fault are not the norm.)  
So, what about something vaguely like:

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 92248eb..0000000 100644  
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -267,6 +267,7 @@ ENTRY(vector_swi)
 	eor	scno, scno, #__NR_SYSCALL_BASE	@ check OS number
 #endif
 
+	str	scno, [tsk, #TI_SYSCALL]!	@ store for syscall_get_nr()
 	stmdb	sp!, {r4, r5}			@ push fifth and sixth args
 	tst	ip, #_TIF_SYSCALL_TRACE		@ are we tracing syscalls?
 	bne	__sys_trace
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 1a07257..0000000 100644  
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -1032,8 +1032,6 @@ asmlinkage int syscall_trace(int why, st
 	ip = regs->ARM_ip;
 	regs->ARM_ip = why;
 
-	current_thread_info()->syscall = scno;
-
 	/*
 	 * Report the system call for tracing.  Entry tracing can
 	 * decide to abort the call.  We handle that by setting an

(Forgive me, I don't actually know a lick of ARM assembly.)  So that
adds a store to current_thread_info()->syscall in the hot path.
Maybe that is acceptable?  Or maybe there is a more clever way to
swizzle things to record the info with net zero overhead.  (On some
machines there seems to be some hardware or lowest-level kernel
state already somewhere that indicates "how we got into kernel mode"
in a way that helps.)

Finally, there is the full reliable definition that if the task is
in an explicit block after entering the kernel from user mode for
some reason other than a system call, syscall_get_nr() returns -1.
It's nice to get there, but in practice many users will be quite
happy just to get the first two stages and know the caveat that
/proc/pid/syscall et al are unreliable when you can't be sure that
where the task is blocked is indeed in a system call.

Assuming something akin to the above for noticing on syscall entry,
then there are two obvious ways to keep that state maintained for
the rest of the time (i.e. reset for non-syscall kernel entries).
One is to reset the record when leaving the kernel after a syscall,
so it's not set again until the next syscall entry.  The other is to
clear that record on every other kind of kernel entry.  The latter
is effectively what other machines I'm aware of all do, but I have
even less clue how to do that on ARM than I've displayed above on
the syscall entry side.  For the latter, perhaps it can be this:

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 92248eb..4844ba2 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -30,6 +30,9 @@ ret_fast_syscall:
 	tst	r1, #_TIF_WORK_MASK
 	bne	fast_work_pending
 
+	mov	why, #-1
+	str	why, [tsk, #TI_SYSCALL]!	@ reset for syscall_get_nr()
+	
 	/* perform architecture specific actions before user return */
 	arch_ret_to_user r1, lr
 
@@ -65,6 +68,8 @@ work_resched:
  */
 ENTRY(ret_to_user)
 ret_slow_syscall:
+	mov	why, #-1
+	str	why, [tsk, #TI_SYSCALL]!	@ reset for syscall_get_nr()
 	disable_irq				@ disable interrupts
 	ldr	r1, [tsk, #TI_FLAGS]
 	tst	r1, #_TIF_WORK_MASK

But again I don't really presume to have any clue about the ARM
assembly code.  I hope I've illustrated some general directions that
might be possible for actual ARM experts to consider and flesh out
whether they are worthwhile.

Regardless, IMHO it's worthwhile to start with the first stage that
is trivial but with the most caveats about its limited utility, and
have an asm/syscall.h rather than none while mulling over the
eventual perfection of syscall_get_nr().

> Your implementation of syscall_get_arguments() looks wrong - for OABI
> it makes sense because there is no padding in the allocation of registers.
> However, for EABI, there is padding, so 64-bit values always come in
> using an even+odd register number.  Short of maintaining some sort of
> table describing the argument placements for every kernel syscall (eww)
> I'm not sure how this could be fixed.

I seem to recall this confusion has come up before, but I can't find
where I explained it.  Perhaps the asm-generic/syscall.h kerneldoc
comments should change to clarify the point.  In fact, I thought I had
changed those descriptions before it went in, but it's not so.

syscall_get_arguments() and syscall_set_arguments() get at the *argument
registers* in their usual order, not at the arguments in any semantic
sense.  Unless I'm mistaken, all ARM syscalls taking 64-bit arguments
receive them in these same registers, and in never more than six
registers total.  (This is true of all other machines too.)  So that's
all these functions have to do: get those six registers.

The consumer of the data (in userland or whatever tracing thing) indeed
needs to know the arch-specific interpretation of these register values
and that differs by the particular syscall number.  That is already true
for knowing what the syscall numbers mean, how many of the registers are
actually used for arguments in a given syscall, which ones are pointers
to what kinds of data or have what other intepretation as bitmasks or
numbers, and that is true on every arch.  Which pairs of registers form
a single semantic argument and when is just another of these details.

There is other work being done on in-kernel syscall tracers that
reconstruct the C-level arguments from syscall_get_arguments() info.
Those do use tables and such (jiggered via the SYSCALL_DEFINE macros and
black magic, AIUI).  But that is all above the syscall_get_arguments()
layer.  You don't need to worry about this to get asm/syscall.h right.


Thanks,
Roland

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbXIPSNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbXIPSNj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 14:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbXIPSNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 14:13:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44778 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752869AbXIPSNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 14:13:20 -0400
Date: Sun, 16 Sep 2007 11:12:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: crashme fault
In-Reply-To: <alpine.LFD.0.999.0709161004080.16478@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0709161055070.16478@woody.linux-foundation.org>
References: <20070912222151.70d1fc7d.randy.dunlap@oracle.com>
 <alpine.LFD.0.999.0709142101140.16478@woody.linux-foundation.org>
 <20070915183412.GA14501@one.firstfloor.org> <46EC2702.3090000@oracle.com>
 <alpine.LFD.0.999.0709151224400.16478@woody.linux-foundation.org>
 <alpine.LFD.0.999.0709151508590.16478@woody.linux-foundation.org>
 <alpine.LFD.0.999.0709151542340.16478@woody.linux-foundation.org>
 <46EC6F2A.5090008@oracle.com> <alpine.LFD.0.999.0709151727180.16478@woody.linux-foundation.org>
 <20070916094001.d87ed0f0.randy.dunlap@oracle.com>
 <alpine.LFD.0.999.0709161004080.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 16 Sep 2007, Linus Torvalds wrote:
> 
> I'm really starting to suspect some early EM64T bug, and I also suspect 
> that it's harmless but that we should just do the trivial patch to say "if 
> the register state is in user mode, we don't care if the CPU says it was a 
> kernel access".

Namely something like this..

The basic idea is that it's pointless to test for "error_code & PF_USER" 
to decide whether we should oops or kill the process: the *real* issue is 
whether we *can* kill the process or not. And that depends not on whether 
the CPU claimed it was a user access or not, but on whether the register 
state we'd return to is user-mode or not!

So anything that decides whether it should send a signal or do to the 
"no_context" Ooops path should use "user_mode_vm(regs)" (yeah, I realize 
that the "_vm" part is unnecessary on x86-64, but it doesn't hurt either, 
and all of the issues are the same on 32/64-bit) which tests the right 
thing.

Now, normally the USER bit in the error code should be the exact same 
thing, except for

 - Some CPU bug (microcode issue, whatever) where some complex fault 
   situation sets the wrong error code.

 - user space accesses that caused a system page fault (ie a page fault 
   while handling another trap - possibly due to lazy page table setup 
   and having the LDT or some other CPU data structure in vmalloc space)

Now, the vmalloc space accesses should be handled separately anyway, so I 
really wonder if it's some subtle CPU bug (I can't reproduce any problems 
on my Core 2 Duo), but the point is that I think this patch really is 
conceptually a real fix regardless, even if it _shouldn't_ matter.

Comments?

Randy, this replaces the hacky patch I sent, but also shuts up about the 
odd thing you're hitting, so for testing your case further this may not be 
the right thing. However, it would be nice to hear whether this just makes 
"crashme" work properly for you without any side effects..

		Linus

----
 arch/x86_64/mm/fault.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86_64/mm/fault.c b/arch/x86_64/mm/fault.c
index 327c9f2..75270a0 100644
--- a/arch/x86_64/mm/fault.c
+++ b/arch/x86_64/mm/fault.c
@@ -87,7 +87,7 @@ static noinline int is_prefetch(struct pt_regs *regs, unsigned long addr,
 	instr = (unsigned char __user *)convert_rip_to_linear(current, regs);
 	max_instr = instr + 15;
 
-	if (user_mode(regs) && instr >= (unsigned char *)TASK_SIZE)
+	if (user_mode_vm(regs) && instr >= (unsigned char *)TASK_SIZE)
 		return 0;
 
 	while (scan_more && instr < max_instr) { 
@@ -320,7 +320,6 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 
 	info.si_code = SEGV_MAPERR;
 
-
 	/*
 	 * We fault-in kernel-space virtual memory on-demand. The
 	 * 'reference' page table is init_mm.pgd.
@@ -404,7 +403,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 		goto good_area;
 	if (!(vma->vm_flags & VM_GROWSDOWN))
 		goto bad_area;
-	if (error_code & 4) {
+	if (error_code & PF_USER) {
 		/* Allow userspace just enough access below the stack pointer
 		 * to let the 'enter' instruction work.
 		 */
@@ -558,7 +557,7 @@ out_of_memory:
 		goto again;
 	}
 	printk("VM: killing process %s\n", tsk->comm);
-	if (error_code & 4)
+	if (user_mode_vm(regs))
 		do_group_exit(SIGKILL);
 	goto no_context;
 
@@ -566,7 +565,7 @@ do_sigbus:
 	up_read(&mm->mmap_sem);
 
 	/* Kernel mode? Handle exceptions or die */
-	if (!(error_code & PF_USER))
+	if (!user_mode_vm(regs))
 		goto no_context;
 
 	tsk->thread.cr2 = address;

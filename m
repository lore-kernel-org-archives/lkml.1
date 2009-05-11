Return-Path: <linux-kernel-owner+w=401wt.eu-S1759504AbZEKWab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504AbZEKWab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbZEKWaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:30:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757098AbZEKWaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:30:21 -0400
Date: Mon, 11 May 2009 15:24:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Masami Hiramatsu <mhiramat@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>, systemtap@sources.redhat.com,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jan Blunck <jblunck@suse.de>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH -rc] [BUGFIX] x86: fix kernel_trap_sp()
In-Reply-To: <20090511210300.17332.67549.stgit@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0905111512240.3586@localhost.localdomain>
References: <20090511210300.17332.67549.stgit@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 May 2009, Masami Hiramatsu wrote:
>
> Use &regs->sp instead of regs for getting the top of stack in kernel mode.
> (on x86-64, regs->sp always points the top of stack)

Ack. 

That said, we have only _one_ use of this "kernel_trap_sp()" in the whole 
kernel, and that use is actually fairly odd too, in that it does it 
_before_ checking that it's in kernel mode.

Admittedly it will then only _use_ the value after it has checked that 
things are in kernel mode, but it all boils down to "ok, that's pretty 
odd".

So how about fixing that, and also fixing the naming of the function. Call 
it "kernel_stack_pointer()" to match its more widely used sibling function
"user_stack_pointer()".

IOW, something like this?

		Linus

---
 arch/x86/include/asm/ptrace.h |    7 ++++---
 arch/x86/oprofile/backtrace.c |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index e304b66..624f133 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -187,14 +187,15 @@ static inline int v8086_mode(struct pt_regs *regs)
 
 /*
  * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
- * when it traps.  So regs will be the current sp.
+ * when it traps.  The previous stack will be directly underneath the saved
+ * registers, and 'sp/ss' won't even have been saved. Thus the '&regs->sp'.
  *
  * This is valid only for kernel mode traps.
  */
-static inline unsigned long kernel_trap_sp(struct pt_regs *regs)
+static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
 {
 #ifdef CONFIG_X86_32
-	return (unsigned long)regs;
+	return (unsigned long)(&regs->sp);
 #else
 	return regs->sp;
 #endif
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index 04df67f..044897b 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -76,9 +76,9 @@ void
 x86_backtrace(struct pt_regs * const regs, unsigned int depth)
 {
 	struct frame_head *head = (struct frame_head *)frame_pointer(regs);
-	unsigned long stack = kernel_trap_sp(regs);
 
 	if (!user_mode_vm(regs)) {
+		unsigned long stack = kernel_stack_pointer(regs);
 		if (depth)
 			dump_trace(NULL, regs, (unsigned long *)stack, 0,
 				   &backtrace_ops, &depth);

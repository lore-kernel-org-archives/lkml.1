Return-Path: <linux-kernel-owner+w=401wt.eu-S1762529AbXKHSzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762529AbXKHSzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 13:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762365AbXKHSza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 13:55:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53850 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762359AbXKHSz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 13:55:28 -0500
Date: Thu, 8 Nov 2007 10:54:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Fitzsimons <robfitz@273k.net>
Cc: linux-kernel@vger.kernel.org, jblunck@suse.de, ak@suse.de, mingo@elte.hu,
       tglx@linutronix.de, Philippe Elie <phil.el@wanadoo.fr>
Subject: Re: oops in oprofile/dump_trace/X86 with 2.6.24-rcX
Message-Id: <20071108105418.8b58306d.akpm@linux-foundation.org>
In-Reply-To: <20071108014527.GA2474@localhost>
References: <20071108014527.GA2474@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 8 Nov 2007 01:45:27 +0000 Robert Fitzsimons <robfitz@273k.net> wrote:
> A couple of days ago I tried to use oprofile with a recent build of
> 2.6.24-rc1, this resulted in a oops 'BUG: unable to handle kernel paging
> request at virtual address'.
> 
> The oops is readily reproducible on my main machine, the steps for me
> are, run opcontrol --init, and then opcontrol --start, then straight
> away or within a few seconds I get the oops.  I have tried to reproduce
> it on another machine with a slightly lower spec, but I wasn't too.
> 
> I've spent some time investigating the problem.  Using git bisect the
> oops first triggers with commit 574a60421c8ea5383a54ebee1f37fa871d00e1b9
> (i386: make callgraph use dump_trace() on i386/x86_64).
> 
> The oops occurs in the dump_trace function when the context pointer is
> referenced on the marked line.
> 
> arch/x86/kernel/traps_32.c, dump_trace()
> 
> 	while (1) {
> 		struct thread_info *context;
> 		context = (struct thread_info *)
> 			((unsigned long)stack & (~(THREAD_SIZE - 1)));
> 		ebp = print_context_stack(context, stack, ebp, ops, data);
> 		/* Should be after the line below, but somewhere
> 		   in early boot context comes out corrupted and we
> 		   can't reference it -AK */
> 		if (ops->stack(data, "IRQ") < 0)
> 			break;
> --->		stack = (unsigned long*)context->previous_esp;
> 		if (!stack)
> 			break;
> 		touch_nmi_watchdog();
> 	}
> 
> In the second and thrid oops with CONFIG_FRAME_POINTER disable the oops
> is trigger below.
> 
> arch/x86/kernel/traps_32.c, print_context_stack()
> 
> 	while (valid_stack_ptr(tinfo, stack, sizeof(*stack))) {
> 		unsigned long addr;
> 
> --->		addr = *stack++;
> 		if (__kernel_text_address(addr))
> 			ops->address(data, addr);
> 	}
> 
> It seems that for some reason the previous_esp value in one of the
> struct thread_info is not being written/updated correctly or is getting
> corrupted.
> 
> I've tried a number of different build options, including very minimal
> configs, enabling/disabling CONFIG_FRAME_POINTER, CONFIG_4KSTACKS,
> different versions of gcc, changing around the installed pci cards, with
> no effect.
> 
> The machine is a fairly old 32-bit Athlon, so I haven't ruled out a
> hardware fault though the machine has been working fine up-until now and
> works fine with other kernel versions.  I've already run memtest+ for
> about about 30 minutes, I'm going to run it again overnight after I've
> sent this email.
> 
> Any suggestions as to what might be causing these oopses?
> 

Philippe, on Sun, 21 Oct you sent a "[patch 1/2] oProfile: oops when
profile_pc() return ~0LU" which as far as I can tell never got applied.

Also, I have no record of [patch 2/2] from that day.  Can you please refresh
and resend both patches asap?

I've queued the below revert of Jan's change, in case your lost [2/2] doesn't
address Robert's oops.

Robert, can you please test this?




From: Andrew Morton <akpm@linux-foundation.org>

Revert 574a60421c8ea5383a54ebee1f37fa871d00e1b9 - Robert Fitzsimons is
reporting oopses.

Cc: Robert Fitzsimons <robfitz@273k.net>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Philippe Elie <phil.el@wanadoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/oprofile/backtrace.c |   97 ++++++++++++++++++++------------
 1 file changed, 61 insertions(+), 36 deletions(-)

diff -puN arch/x86/oprofile/backtrace.c~oprofile-revert-i386-make-callgraph-use-dump_trace-on-i386-x86_64 arch/x86/oprofile/backtrace.c
--- a/arch/x86/oprofile/backtrace.c~oprofile-revert-i386-make-callgraph-use-dump_trace-on-i386-x86_64
+++ a/arch/x86/oprofile/backtrace.c
@@ -13,45 +13,25 @@
 #include <linux/mm.h>
 #include <asm/ptrace.h>
 #include <asm/uaccess.h>
-#include <asm/stacktrace.h>
 
-static void backtrace_warning_symbol(void *data, char *msg,
-				     unsigned long symbol)
-{
-	/* Ignore warnings */
-}
-
-static void backtrace_warning(void *data, char *msg)
-{
-	/* Ignore warnings */
-}
+struct frame_head {
+	struct frame_head * ebp;
+	unsigned long ret;
+} __attribute__((packed));
 
-static int backtrace_stack(void *data, char *name)
+static struct frame_head *
+dump_kernel_backtrace(struct frame_head * head)
 {
-	/* Yes, we want all stacks */
-	return 0;
-}
+	oprofile_add_trace(head->ret);
 
-static void backtrace_address(void *data, unsigned long addr)
-{
-	unsigned int *depth = data;
+	/* frame pointers should strictly progress back up the stack
+	 * (towards higher addresses) */
+	if (head >= head->ebp)
+		return NULL;
 
-	if ((*depth)--)
-		oprofile_add_trace(addr);
+	return head->ebp;
 }
 
-static struct stacktrace_ops backtrace_ops = {
-	.warning = backtrace_warning,
-	.warning_symbol = backtrace_warning_symbol,
-	.stack = backtrace_stack,
-	.address = backtrace_address,
-};
-
-struct frame_head {
-	struct frame_head *ebp;
-	unsigned long ret;
-} __attribute__((packed));
-
 static struct frame_head *
 dump_user_backtrace(struct frame_head * head)
 {
@@ -73,16 +53,61 @@ dump_user_backtrace(struct frame_head * 
 	return bufhead[0].ebp;
 }
 
+/*
+ * |             | /\ Higher addresses
+ * |             |
+ * --------------- stack base (address of current_thread_info)
+ * | thread info |
+ * .             .
+ * |    stack    |
+ * --------------- saved regs->ebp value if valid (frame_head address)
+ * .             .
+ * --------------- saved regs->rsp value if x86_64
+ * |             |
+ * --------------- struct pt_regs * stored on stack if 32-bit
+ * |             |
+ * .             .
+ * |             |
+ * --------------- %esp
+ * |             |
+ * |             | \/ Lower addresses
+ *
+ * Thus, regs (or regs->rsp for x86_64) <-> stack base restricts the
+ * valid(ish) ebp values. Note: (1) for x86_64, NMI and several other
+ * exceptions use special stacks, maintained by the interrupt stack table
+ * (IST). These stacks are set up in trap_init() in
+ * arch/x86_64/kernel/traps.c. Thus, for x86_64, regs now does not point
+ * to the kernel stack; instead, it points to some location on the NMI
+ * stack. On the other hand, regs->rsp is the stack pointer saved when the
+ * NMI occurred. (2) For 32-bit, regs->esp is not valid because the
+ * processor does not save %esp on the kernel stack when interrupts occur
+ * in the kernel mode.
+ */
+#ifdef CONFIG_FRAME_POINTER
+static int valid_kernel_stack(struct frame_head *head, struct pt_regs *regs)
+{
+	unsigned long headaddr = (unsigned long)head;
+	unsigned long stack = stack_pointer(regs);
+	unsigned long stack_base = (stack & ~(THREAD_SIZE - 1)) + THREAD_SIZE;
+
+	return headaddr > stack && headaddr < stack_base;
+}
+#else
+/* without fp, it's just junk */
+static int valid_kernel_stack(struct frame_head *head, struct pt_regs *regs)
+{
+	return 0;
+}
+#endif
+
 void
 x86_backtrace(struct pt_regs * const regs, unsigned int depth)
 {
 	struct frame_head *head = (struct frame_head *)frame_pointer(regs);
-	unsigned long stack = stack_pointer(regs);
 
 	if (!user_mode_vm(regs)) {
-		if (depth)
-			dump_trace(NULL, regs, (unsigned long *)stack,
-				   &backtrace_ops, &depth);
+		while (depth-- && valid_kernel_stack(head, regs))
+			head = dump_kernel_backtrace(head);
 		return;
 	}
 
_


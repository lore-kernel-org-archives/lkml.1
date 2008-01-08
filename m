Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbYAHFOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbYAHFOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 00:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbYAHFOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 00:14:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46310 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbYAHFOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 00:14:43 -0500
Date: Mon, 7 Jan 2008 21:14:37 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@tglx.de, hpa@zytor.com
Subject: [patch 2/2] Use the stack frames to get exact stack-traces for
 CONFIG_FRAMEPOINTER on x86-64
Message-ID: <20080107211437.5ba42f18@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: Use the stack frames to get exact stack-traces for CONFIG_FRAMEPOINTER on x86-64
From: Arjan van de Ven <arjan@linux.intel.com>

x86 32 bit already has this feature: This patch uses the stack frames with
frame pointer into an exact stack trace, by following the frame pointer.
This only affects kernels built with the CONFIG_FRAME_POINTER config option
enabled, and greatly reduces the amount of noise in oopses.

The code tries to use the frame pointers to do a backtrace, but if it smells
iffy or invalid, falls back to the traditional way of printing backtraces,
to make sure that at least some useful backtrace is created.

Due to the fragility and importance of the backtrace code, this needs to
be well reviewed and well tested before merging into mainlne.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 arch/x86/kernel/traps_64.c |   72 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 62 insertions(+), 10 deletions(-)

Index: linux-2.6.24-rc7/arch/x86/kernel/traps_64.c
===================================================================
--- linux-2.6.24-rc7.orig/arch/x86/kernel/traps_64.c
+++ linux-2.6.24-rc7/arch/x86/kernel/traps_64.c
@@ -221,17 +221,55 @@ static inline int valid_stack_ptr(struct
 	return p > t && p < t + THREAD_SIZE - size;
 }
 
-static inline unsigned long print_context_stack(struct thread_info *tinfo,
+/* The form of the top of the frame on the stack */
+struct stack_frame {
+	struct stack_frame *next_frame;
+	unsigned long return_address;
+};
+
+
+static inline unsigned long print_context_stack(void *tinfo,
 				unsigned long *stack, unsigned long ebp,
 				const struct stacktrace_ops *ops, void *data,
 				unsigned long *end)
 {
+
+#ifdef CONFIG_FRAME_POINTER
+	struct stack_frame *frame = (struct stack_frame *)ebp;
+
 	/*
-	 * Print function call entries within a stack. 'cond' is the
-	 * "end of stackframe" condition, that the 'stack++'
-	 * iteration will eventually trigger.
+	 * if EBP is in the current stack frame, use stack frame tracking;
+	 * otherwise fall back to the traditional method.
 	 */
-	while (valid_stack_ptr(tinfo, stack, 3, end))) {
+
+	if (valid_stack_ptr(tinfo, frame, sizeof(*frame), end)) {
+		while (valid_stack_ptr(tinfo, frame, sizeof(*frame), end)) {
+			struct stack_frame *next;
+			unsigned long addr;
+
+			addr = frame->return_address;
+			if (__kernel_text_address(addr))
+				ops->address(data, addr);
+			/*
+			 * break out of recursive entries (such as
+			 * end_of_stack_stop_unwind_function). Also,
+			 * we can never allow a frame pointer to
+			 * move downwards!
+			 */
+			next = frame->next_frame;
+			ebp = (unsigned long)next;
+			if (next <= frame)
+				break;
+			frame = next;
+		}
+	} else
+#endif
+	/*
+	 * Print function call entries within a stack.
+	 * The end condition is either a bound on the stack, or
+	 * an invalid stack ptr, depending on the caller.
+	 */
+	while (valid_stack_ptr(tinfo, stack, 3, end)) {
 		unsigned long addr = *stack++;
 		/* Use unlocked access here because except for NMIs
 		   we should be already protected against module unloads */
@@ -258,6 +296,7 @@ void dump_trace(struct task_struct *tsk,
 	unsigned long *irqstack_end = (unsigned long*)cpu_pda(cpu)->irqstackptr;
 	unsigned used = 0;
 	struct thread_info *tinfo;
+	unsigned long ebp = 0;
 
 	if (!tsk)
 		tsk = current;
@@ -270,6 +309,19 @@ void dump_trace(struct task_struct *tsk,
 			stack = (unsigned long *)tsk->thread.rsp;
 	}
 
+#ifdef CONFIG_FRAME_POINTER
+	if (!ebp) {
+		if (tsk == current) {
+			/* Grab ebp right from our regs */
+			asm("movq %%rbp, %0" : "=r" (ebp):);
+		} else {
+			/* ebp is the last reg pushed by switch_to */
+			ebp = *(unsigned long *) tsk->thread.rsp;
+		}
+	}
+#endif
+
+
 
 	/*
 	 * Print function call entries in all stacks, starting at the
@@ -286,8 +338,8 @@ void dump_trace(struct task_struct *tsk,
 			if (ops->stack(data, id) < 0)
 				break;
 
-			print_context_stack(tinfo, stack, 0, ops,
-						data, estack_end);
+			ebp = print_context_stack(tinfo, stack, ebp, ops,
+							data, estack_end);
 			ops->stack(data, "<EOE>");
 			/*
 			 * We link to the next stack via the
@@ -305,8 +357,8 @@ void dump_trace(struct task_struct *tsk,
 			if (stack >= irqstack && stack < irqstack_end) {
 				if (ops->stack(data, "IRQ") < 0)
 					break;
-				print_context_stack(tinfo, stack, 0, ops,
-							 data, irqstack_end);
+				ebp = print_context_stack(tinfo, stack, ebp,
+						ops, data, irqstack_end);
 				/*
 				 * We link to the next stack (which would be
 				 * the process stack normally) the last
@@ -324,7 +376,7 @@ void dump_trace(struct task_struct *tsk,
 	/*
 	 * This handles the process stack:
 	 */
-	print_context_stack(tinfo, stack, 0, ops, data, NULL);
+	ebp = print_context_stack(tinfo, stack, ebp, ops, data, NULL);
 	put_cpu();
 }
 EXPORT_SYMBOL(dump_trace);

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

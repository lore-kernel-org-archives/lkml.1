Return-Path: <linux-kernel-owner+w=401wt.eu-S1761541AbYALFdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541AbYALFdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 00:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYALFdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 00:33:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33925 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbYALFdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 00:33:06 -0500
Date: Fri, 11 Jan 2008 21:32:57 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org, tglx@tglx.de,
       hpa@zytor.com
Subject: [patch 6/8] x86: Use the stack frames to get exact stack-traces for
 CONFIG_FRAMEPOINTER on x86-64
Message-ID: <20080111213257.125e252b@laptopd505.fenrus.org>
In-Reply-To: <20080111212623.518e1527@laptopd505.fenrus.org>
References: <20080111212623.518e1527@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: x86: Use the stack frames to get exact stack-traces for CONFIG_FRAMEPOINTER on x86-64
From: Arjan van de Ven <arjan@linux.intel.com>

x86 32 bit already has this feature: This patch uses the stack frames with
frame pointer into an exact stack trace, by following the frame pointer.
This only affects kernels built with the CONFIG_FRAME_POINTER config option
enabled, and greatly reduces the amount of noise in oopses.

This code uses the traditional method of doing backtraces, but if it 
finds a valid frame pointer chain, will use that to show which parts
of the backtrace are reliable and which parts are not

Due to the fragility and importance of the backtrace code, this needs to
be well reviewed and well tested before merging into mainlne.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 arch/x86/kernel/traps_64.c |   67 +++++++++++++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 23 deletions(-)

Index: linux-2.6.24-rc7/arch/x86/kernel/traps_64.c
===================================================================
--- linux-2.6.24-rc7.orig/arch/x86/kernel/traps_64.c
+++ linux-2.6.24-rc7/arch/x86/kernel/traps_64.c
@@ -225,31 +225,34 @@ static inline int valid_stack_ptr(struct
 	return p > t && p < t + THREAD_SIZE - size;
 }
 
+/* The form of the top of the frame on the stack */
+struct stack_frame {
+	struct stack_frame *next_frame;
+	unsigned long return_address;
+};
+
+
 static inline unsigned long print_context_stack(struct thread_info *tinfo,
 				unsigned long *stack, unsigned long ebp,
 				const struct stacktrace_ops *ops, void *data,
 				unsigned long *end)
 {
-	/*
-	 * Print function call entries within a stack. 'cond' is the
-	 * "end of stackframe" condition, that the 'stack++'
-	 * iteration will eventually trigger.
-	 */
-	while (valid_stack_ptr(tinfo, stack, 3, end))) {
-		unsigned long addr = *stack++;
-		/* Use unlocked access here because except for NMIs
-		   we should be already protected against module unloads */
+	struct stack_frame *frame = (struct stack_frame *)ebp;
+
+	while (valid_stack_ptr(tinfo, stack, sizeof(*stack), end)) {
+		unsigned long addr;
+
+		addr = *stack;
 		if (__kernel_text_address(addr)) {
-			/*
-			 * If the address is either in the text segment of the
-			 * kernel, or in the region which contains vmalloc'ed
-			 * memory, it *may* be the address of a calling
-			 * routine; if so, print it so that someone tracing
-			 * down the cause of the crash will be able to figure
-			 * out the call path that was taken.
-			 */
-			ops->address(data, addr, 1);
+			if ((unsigned long) stack == ebp + 8) {
+				ops->address(data, addr, 1);
+				frame = frame->next_frame;
+				ebp = (unsigned long) frame;
+			} else {
+				ops->address(data, addr, ebp == 0);
+			}
 		}
+		stack++;
 	}
 	return ebp;
 }
@@ -274,6 +277,19 @@ void dump_trace(struct task_struct *tsk,
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
@@ -290,8 +306,8 @@ void dump_trace(struct task_struct *tsk,
 			if (ops->stack(data, id) < 0)
 				break;
 
-			print_context_stack(tinfo, stack, 0, ops,
-						data, estack_end);
+			ebp = print_context_stack(tinfo, stack, ebp, ops,
+							data, estack_end);
 			ops->stack(data, "<EOE>");
 			/*
 			 * We link to the next stack via the
@@ -309,8 +325,8 @@ void dump_trace(struct task_struct *tsk,
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
@@ -328,7 +344,7 @@ void dump_trace(struct task_struct *tsk,
 	/*
 	 * This handles the process stack:
 	 */
-	print_context_stack(tinfo, stack, 0, ops, data, NULL);
+	ebp = print_context_stack(tinfo, stack, ebp, ops, data, NULL);
 	put_cpu();
 }
 EXPORT_SYMBOL(dump_trace);
@@ -425,6 +441,11 @@ void dump_stack(void)
 	unsigned long dummy;
 	unsigned long ebp = 0;
 
+#ifdef CONFIG_FRAME_POINTER
+	if (!ebp)
+		asm("movq %%rbp, %0" : "=r" (ebp):);
+#endif
+
 	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
 		current->pid, current->comm, print_tainted(),
 		init_utsname()->release,

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

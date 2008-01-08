Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbYAHFN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbYAHFN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 00:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbYAHFNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 00:13:52 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46301 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYAHFNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 00:13:51 -0500
Date: Mon, 7 Jan 2008 21:13:43 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@tglx.de, hpa@zytor.com
Subject: [patch 1/2] Turn 64 bit x86 HANDLE_STACK into print_context_stack
 like 32 bit has
Message-ID: <20080107211343.18b48da8@laptopd505.fenrus.org>
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

Subject: Turn 64 bit x86 HANDLE_STACK into print_context_stack like 32 bit has
From: Arjan van de Ven <arjan@linux.intel.com>

This patch turns the x86 64 bit HANDLE_STACK macro in the backtrace code into 
a function, just like 32 bit has. This is needed pre work in order to get exact
backtraces for CONFIG_FRAME_POINTER to work.

The function and it's arguments are not the same as 32 bit; due to the
exception/interrupt stack way of x86-64 there are a few differences.

This patch should not have any behavior changes, only code movement.

Due to the fragility and importance of the backtrace code, this needs to
be well reviewed and well tested before merging into mainlne.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/kernel/traps_64.c |   74 +++++++++++++++++++++++++++------------------
 1 file changed, 45 insertions(+), 29 deletions(-)

Index: linux-2.6.24-rc7/arch/x86/kernel/traps_64.c
===================================================================
--- linux-2.6.24-rc7.orig/arch/x86/kernel/traps_64.c
+++ linux-2.6.24-rc7/arch/x86/kernel/traps_64.c
@@ -208,10 +208,46 @@ static unsigned long *in_exception_stack
  * severe exception (double fault, nmi, stack fault, debug, mce) hardware stack
  */
 
-static inline int valid_stack_ptr(struct thread_info *tinfo, void *p)
+static inline int valid_stack_ptr(struct thread_info *tinfo,
+			void *p, unsigned int size, void *end)
 {
 	void *t = (void *)tinfo;
-        return p > t && p < t + THREAD_SIZE - 3;
+	if (end) {
+		if (p < end)
+			return 1;
+		else
+			return 0;
+	}
+	return p > t && p < t + THREAD_SIZE - size;
+}
+
+static inline unsigned long print_context_stack(struct thread_info *tinfo,
+				unsigned long *stack, unsigned long ebp,
+				const struct stacktrace_ops *ops, void *data,
+				unsigned long *end)
+{
+	/*
+	 * Print function call entries within a stack. 'cond' is the
+	 * "end of stackframe" condition, that the 'stack++'
+	 * iteration will eventually trigger.
+	 */
+	while (valid_stack_ptr(tinfo, stack, 3, end))) {
+		unsigned long addr = *stack++;
+		/* Use unlocked access here because except for NMIs
+		   we should be already protected against module unloads */
+		if (__kernel_text_address(addr)) {
+			/*
+			 * If the address is either in the text segment of the
+			 * kernel, or in the region which contains vmalloc'ed
+			 * memory, it *may* be the address of a calling
+			 * routine; if so, print it so that someone tracing
+			 * down the cause of the crash will be able to figure
+			 * out the call path that was taken.
+			 */
+			ops->address(data, addr);
+		}
+	}
+	return ebp;
 }
 
 void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
@@ -225,6 +261,7 @@ void dump_trace(struct task_struct *tsk,
 
 	if (!tsk)
 		tsk = current;
+	tinfo = task_thread_info(tsk);
 
 	if (!stack) {
 		unsigned long dummy;
@@ -233,28 +270,6 @@ void dump_trace(struct task_struct *tsk,
 			stack = (unsigned long *)tsk->thread.rsp;
 	}
 
-	/*
-	 * Print function call entries within a stack. 'cond' is the
-	 * "end of stackframe" condition, that the 'stack++'
-	 * iteration will eventually trigger.
-	 */
-#define HANDLE_STACK(cond) \
-	do while (cond) { \
-		unsigned long addr = *stack++; \
-		/* Use unlocked access here because except for NMIs	\
-		   we should be already protected against module unloads */ \
-		if (__kernel_text_address(addr)) { \
-			/* \
-			 * If the address is either in the text segment of the \
-			 * kernel, or in the region which contains vmalloc'ed \
-			 * memory, it *may* be the address of a calling \
-			 * routine; if so, print it so that someone tracing \
-			 * down the cause of the crash will be able to figure \
-			 * out the call path that was taken. \
-			 */ \
-			ops->address(data, addr);   \
-		} \
-	} while (0)
 
 	/*
 	 * Print function call entries in all stacks, starting at the
@@ -270,7 +285,9 @@ void dump_trace(struct task_struct *tsk,
 		if (estack_end) {
 			if (ops->stack(data, id) < 0)
 				break;
-			HANDLE_STACK (stack < estack_end);
+
+			print_context_stack(tinfo, stack, 0, ops,
+						data, estack_end);
 			ops->stack(data, "<EOE>");
 			/*
 			 * We link to the next stack via the
@@ -288,7 +305,8 @@ void dump_trace(struct task_struct *tsk,
 			if (stack >= irqstack && stack < irqstack_end) {
 				if (ops->stack(data, "IRQ") < 0)
 					break;
-				HANDLE_STACK (stack < irqstack_end);
+				print_context_stack(tinfo, stack, 0, ops,
+							 data, irqstack_end);
 				/*
 				 * We link to the next stack (which would be
 				 * the process stack normally) the last
@@ -306,9 +324,7 @@ void dump_trace(struct task_struct *tsk,
 	/*
 	 * This handles the process stack:
 	 */
-	tinfo = task_thread_info(tsk);
-	HANDLE_STACK (valid_stack_ptr(tinfo, stack));
-#undef HANDLE_STACK
+	print_context_stack(tinfo, stack, 0, ops, data, NULL);
 	put_cpu();
 }
 EXPORT_SYMBOL(dump_trace);


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

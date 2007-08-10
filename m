Return-Path: <linux-kernel-owner+w=401wt.eu-S937677AbXHJNjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937677AbXHJNjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 09:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937027AbXHJNhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 09:37:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937792AbXHJNho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 09:37:44 -0400
Message-Id: <20070810133635.821996956@suse.de>
References: <20070810133528.883477787@suse.de>
User-Agent: quilt/0.46-62.2
Date: Fri, 10 Aug 2007 15:35:29 +0200
From: jblunck@suse.de
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de
Subject: [PATCH 1/2] oprofile: Make callgraph use dump_trace() on i386/x86_64
Content-Disposition: inline; filename=patches.fixes/oprofile-backtrace-use-dump_trace.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves oprofile callgraphs for i386/x86_64. The old backtracing
code was unable to produce even kernel backtraces if the kernel wasn't
compiled with framepointers. The code now uses dump_trace().

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 arch/i386/oprofile/backtrace.c |  104 ++++++++++++++---------------------------
 1 file changed, 38 insertions(+), 66 deletions(-)

--- a/arch/i386/oprofile/backtrace.c
+++ b/arch/i386/oprofile/backtrace.c
@@ -13,25 +13,45 @@
 #include <linux/mm.h>
 #include <asm/ptrace.h>
 #include <asm/uaccess.h>
+#include <asm/stacktrace.h>
 
-struct frame_head {
-	struct frame_head * ebp;
-	unsigned long ret;
-} __attribute__((packed));
+static void backtrace_warning_symbol(void *data, char *msg,
+				     unsigned long symbol)
+{
+	/* Ignore warnings */
+}
 
-static struct frame_head *
-dump_kernel_backtrace(struct frame_head * head)
+static void backtrace_warning(void *data, char *msg)
 {
-	oprofile_add_trace(head->ret);
+	/* Ignore warnings */
+}
 
-	/* frame pointers should strictly progress back up the stack
-	 * (towards higher addresses) */
-	if (head >= head->ebp)
-		return NULL;
+static int backtrace_stack(void *data, char *name)
+{
+	/* Yes, we want all stacks */
+	return 0;
+}
 
-	return head->ebp;
+static void backtrace_address(void *data, unsigned long addr)
+{
+	unsigned int *depth = data;
+
+	if ((*depth)--)
+		oprofile_add_trace(addr);
 }
 
+static struct stacktrace_ops backtrace_ops = {
+	.warning = backtrace_warning,
+	.warning_symbol = backtrace_warning_symbol,
+	.stack = backtrace_stack,
+	.address = backtrace_address,
+};
+
+struct frame_head {
+	struct frame_head * ebp;
+	unsigned long ret;
+} __attribute__((packed));
+
 static struct frame_head *
 dump_user_backtrace(struct frame_head * head)
 {
@@ -53,72 +73,24 @@ dump_user_backtrace(struct frame_head * 
 	return bufhead[0].ebp;
 }
 
-/*
- * |             | /\ Higher addresses
- * |             |
- * --------------- stack base (address of current_thread_info)
- * | thread info |
- * .             .
- * |    stack    |
- * --------------- saved regs->ebp value if valid (frame_head address)
- * .             .
- * --------------- saved regs->rsp value if x86_64
- * |             |
- * --------------- struct pt_regs * stored on stack if 32-bit
- * |             |
- * .             .
- * |             |
- * --------------- %esp
- * |             |
- * |             | \/ Lower addresses
- *
- * Thus, regs (or regs->rsp for x86_64) <-> stack base restricts the
- * valid(ish) ebp values. Note: (1) for x86_64, NMI and several other
- * exceptions use special stacks, maintained by the interrupt stack table
- * (IST). These stacks are set up in trap_init() in
- * arch/x86_64/kernel/traps.c. Thus, for x86_64, regs now does not point
- * to the kernel stack; instead, it points to some location on the NMI
- * stack. On the other hand, regs->rsp is the stack pointer saved when the
- * NMI occurred. (2) For 32-bit, regs->esp is not valid because the
- * processor does not save %esp on the kernel stack when interrupts occur
- * in the kernel mode.
- */
-#ifdef CONFIG_FRAME_POINTER
-static int valid_kernel_stack(struct frame_head * head, struct pt_regs * regs)
-{
-	unsigned long headaddr = (unsigned long)head;
-#ifdef CONFIG_X86_64
-	unsigned long stack = (unsigned long)regs->rsp;
-#else
-	unsigned long stack = (unsigned long)regs;
-#endif
-	unsigned long stack_base = (stack & ~(THREAD_SIZE - 1)) + THREAD_SIZE;
-
-	return headaddr > stack && headaddr < stack_base;
-}
-#else
-/* without fp, it's just junk */
-static int valid_kernel_stack(struct frame_head * head, struct pt_regs * regs)
-{
-	return 0;
-}
-#endif
-
-
 void
 x86_backtrace(struct pt_regs * const regs, unsigned int depth)
 {
 	struct frame_head *head;
+	unsigned long stack;
 
 #ifdef CONFIG_X86_64
 	head = (struct frame_head *)regs->rbp;
+	stack = regs->rsp;
 #else
 	head = (struct frame_head *)regs->ebp;
+	stack = regs->esp;
 #endif
 
 	if (!user_mode_vm(regs)) {
-		while (depth-- && valid_kernel_stack(head, regs))
-			head = dump_kernel_backtrace(head);
+		if (depth)
+			dump_trace(NULL, regs, (unsigned long *)stack,
+				   &backtrace_ops, &depth);
 		return;
 	}
 

-- 


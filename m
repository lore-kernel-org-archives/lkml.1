Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbZC3RMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbZC3RMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZC3RLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:11:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52289 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbZC3RLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:11:22 -0400
Message-Id: <20090330171024.341993293@chello.nl>
References: <20090330170701.856843742@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 30 Mar 2009 19:07:15 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 14/15] perf_counter: x86: callchain support
Content-Disposition: inline; filename=perf_counter-x86-callchain.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide the x86 perf_callchain() implementation.

Code based on the sysprof code.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_counter.c |  154 +++++++++++++++++++++++++++++++++++++
 1 file changed, 154 insertions(+)

Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -16,8 +16,10 @@
 #include <linux/module.h>
 #include <linux/kdebug.h>
 #include <linux/sched.h>
+#include <linux/uaccess.h>
 
 #include <asm/apic.h>
+#include <asm/stacktrace.h>
 
 static bool perf_counters_initialized __read_mostly;
 
@@ -958,3 +960,155 @@ hw_perf_counter_init(struct perf_counter
 
 	return &x86_perf_counter_ops;
 }
+
+/*
+ * callchain support
+ */
+
+static inline
+void callchain_store(struct perf_callchain_entry *entry, unsigned long ip)
+{
+	if (entry->nr < MAX_STACK_DEPTH)
+		entry->ip[entry->nr++] = ip;
+}
+
+static DEFINE_PER_CPU(struct perf_callchain_entry, irq_entry);
+static DEFINE_PER_CPU(struct perf_callchain_entry, nmi_entry);
+
+
+static void
+backtrace_warning_symbol(void *data, char *msg, unsigned long symbol)
+{
+	/* Ignore warnings */
+}
+
+static void backtrace_warning(void *data, char *msg)
+{
+	/* Ignore warnings */
+}
+
+static int backtrace_stack(void *data, char *name)
+{
+	/* Don't bother with IRQ stacks for now */
+	return -1;
+}
+
+static void backtrace_address(void *data, unsigned long addr, int reliable)
+{
+	struct perf_callchain_entry *entry = data;
+
+	if (reliable)
+		callchain_store(entry, addr);
+}
+
+static const struct stacktrace_ops backtrace_ops = {
+	.warning		= backtrace_warning,
+	.warning_symbol		= backtrace_warning_symbol,
+	.stack			= backtrace_stack,
+	.address		= backtrace_address,
+};
+
+static void
+perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
+{
+	unsigned long bp;
+	char *stack;
+
+	callchain_store(entry, instruction_pointer(regs));
+
+	stack = ((char *)regs + sizeof(struct pt_regs));
+#ifdef CONFIG_FRAME_POINTER
+	bp = frame_pointer(regs);
+#else
+	bp = 0;
+#endif
+
+	dump_trace(NULL, regs, (void *)stack, bp, &backtrace_ops, entry);
+}
+
+
+struct stack_frame {
+	const void __user	*next_fp;
+	unsigned long		return_address;
+};
+
+static int copy_stack_frame(const void __user *fp, struct stack_frame *frame)
+{
+	int ret;
+
+	if (!access_ok(VERIFY_READ, fp, sizeof(*frame)))
+		return 0;
+
+	ret = 1;
+	pagefault_disable();
+	if (__copy_from_user_inatomic(frame, fp, sizeof(*frame)))
+		ret = 0;
+	pagefault_enable();
+
+	return ret;
+}
+
+static void
+perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
+{
+	struct stack_frame frame;
+	const void __user *fp;
+
+	regs = (struct pt_regs *)current->thread.sp0 - 1;
+	fp   = (void __user *)regs->bp;
+
+	callchain_store(entry, regs->ip);
+
+	while (entry->nr < MAX_STACK_DEPTH) {
+		frame.next_fp	     = NULL;
+		frame.return_address = 0;
+
+		if (!copy_stack_frame(fp, &frame))
+			break;
+
+		if ((unsigned long)fp < user_stack_pointer(regs))
+			break;
+
+		callchain_store(entry, frame.return_address);
+		fp = frame.next_fp;
+	}
+}
+
+static void
+perf_do_callchain(struct pt_regs *regs, struct perf_callchain_entry *entry)
+{
+	int is_user;
+
+	if (!regs)
+		return;
+
+	is_user = user_mode(regs);
+
+	if (!current || current->pid == 0)
+		return;
+
+	if (is_user && current->state != TASK_RUNNING)
+		return;
+
+	if (!is_user)
+		perf_callchain_kernel(regs, entry);
+
+	if (current->mm)
+		perf_callchain_user(regs, entry);
+}
+
+struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
+{
+	struct perf_callchain_entry *entry;
+
+	if (in_nmi())
+		entry = &__get_cpu_var(nmi_entry);
+	else
+		entry = &__get_cpu_var(irq_entry);
+
+	entry->nr = 0;
+
+	perf_do_callchain(regs, entry);
+
+	return entry;
+}

-- 


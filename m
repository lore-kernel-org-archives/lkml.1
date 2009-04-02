Return-Path: <linux-kernel-owner+w=401wt.eu-S1762291AbZDBJNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762291AbZDBJNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757369AbZDBJMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:12:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59144 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbZDBJMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:12:51 -0400
Message-Id: <20090402091319.493101305@chello.nl>
References: <20090402091158.291810516@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 02 Apr 2009 11:12:03 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/6] perf_counter: add more context information
Content-Disposition: inline; filename=perf_counter_callchain_context.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put in counts to tell which ips belong to what context.

  -----
   | |  hv
   | --
nr | |  kernel
   | --
   | |  user
  -----

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_counter.c |    9 +++++++++
 include/linux/perf_counter.h       |    4 ++--
 kernel/perf_counter.c              |    2 +-
 3 files changed, 12 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -1088,6 +1088,7 @@ perf_callchain_kernel(struct pt_regs *re
 {
 	unsigned long bp;
 	char *stack;
+	int nr = entry->nr;
 
 	callchain_store(entry, instruction_pointer(regs));
 
@@ -1099,6 +1100,8 @@ perf_callchain_kernel(struct pt_regs *re
 #endif
 
 	dump_trace(NULL, regs, (void *)stack, bp, &backtrace_ops, entry);
+
+	entry->kernel = entry->nr - nr;
 }
 
 
@@ -1128,6 +1131,7 @@ perf_callchain_user(struct pt_regs *regs
 {
 	struct stack_frame frame;
 	const void __user *fp;
+	int nr = entry->nr;
 
 	regs = (struct pt_regs *)current->thread.sp0 - 1;
 	fp   = (void __user *)regs->bp;
@@ -1147,6 +1151,8 @@ perf_callchain_user(struct pt_regs *regs
 		callchain_store(entry, frame.return_address);
 		fp = frame.next_fp;
 	}
+
+	entry->user = entry->nr - nr;
 }
 
 static void
@@ -1182,6 +1188,9 @@ struct perf_callchain_entry *perf_callch
 		entry = &__get_cpu_var(irq_entry);
 
 	entry->nr = 0;
+	entry->hv = 0;
+	entry->kernel = 0;
+	entry->user = 0;
 
 	perf_do_callchain(regs, entry);
 
Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -520,10 +520,10 @@ extern void perf_counter_mmap(unsigned l
 extern void perf_counter_munmap(unsigned long addr, unsigned long len,
 				unsigned long pgoff, struct file *file);
 
-#define MAX_STACK_DEPTH		255
+#define MAX_STACK_DEPTH		254
 
 struct perf_callchain_entry {
-	u64	nr;
+	u32	nr, hv, kernel, user;
 	u64	ip[MAX_STACK_DEPTH];
 };
 
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1830,7 +1830,7 @@ void perf_counter_output(struct perf_cou
 		callchain = perf_callchain(regs);
 
 		if (callchain) {
-			callchain_size = (1 + callchain->nr) * sizeof(u64);
+			callchain_size = (2 + callchain->nr) * sizeof(u64);
 
 			header.type |= __PERF_EVENT_CALLCHAIN;
 			header.size += callchain_size;

-- 


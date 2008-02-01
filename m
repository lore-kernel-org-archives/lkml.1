Return-Path: <linux-kernel-owner+w=401wt.eu-S1765286AbYBANIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765286AbYBANIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764344AbYBANIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:08:17 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:33247 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764175AbYBANIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:08:16 -0500
Date: Fri, 1 Feb 2008 14:08:11 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Holger Wolf <wolf@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] latencytop s390 support.
Message-ID: <20080201130811.GB29660@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] latencytop s390 support.

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Cc: Holger Wolf <wolf@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

Will go in via the s390 git tree if acceptable.

 arch/s390/Kconfig             |    3 +++
 arch/s390/kernel/stacktrace.c |   31 +++++++++++++++++++++++--------
 2 files changed, 26 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/s390/Kconfig
===================================================================
--- linux-2.6.orig/arch/s390/Kconfig
+++ linux-2.6/arch/s390/Kconfig
@@ -20,6 +20,9 @@ config LOCKDEP_SUPPORT
 config STACKTRACE_SUPPORT
 	def_bool y
 
+config HAVE_LATENCYTOP_SUPPORT
+	def_bool y
+
 config RWSEM_GENERIC_SPINLOCK
 	bool
 
Index: linux-2.6/arch/s390/kernel/stacktrace.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/stacktrace.c
+++ linux-2.6/arch/s390/kernel/stacktrace.c
@@ -14,7 +14,8 @@
 static unsigned long save_context_stack(struct stack_trace *trace,
 					unsigned long sp,
 					unsigned long low,
-					unsigned long high)
+					unsigned long high,
+					int savesched)
 {
 	struct stack_frame *sf;
 	struct pt_regs *regs;
@@ -47,10 +48,12 @@ static unsigned long save_context_stack(
 			return sp;
 		regs = (struct pt_regs *)sp;
 		addr = regs->psw.addr & PSW_ADDR_INSN;
-		if (!trace->skip)
-			trace->entries[trace->nr_entries++] = addr;
-		else
-			trace->skip--;
+		if (savesched || !in_sched_functions(addr)) {
+			if (!trace->skip)
+				trace->entries[trace->nr_entries++] = addr;
+			else
+				trace->skip--;
+		}
 		if (trace->nr_entries >= trace->max_entries)
 			return sp;
 		low = sp;
@@ -66,15 +69,27 @@ void save_stack_trace(struct stack_trace
 	orig_sp = sp & PSW_ADDR_INSN;
 	new_sp = save_context_stack(trace, orig_sp,
 				    S390_lowcore.panic_stack - PAGE_SIZE,
-				    S390_lowcore.panic_stack);
+				    S390_lowcore.panic_stack, 1);
 	if (new_sp != orig_sp)
 		return;
 	new_sp = save_context_stack(trace, new_sp,
 				    S390_lowcore.async_stack - ASYNC_SIZE,
-				    S390_lowcore.async_stack);
+				    S390_lowcore.async_stack, 1);
 	if (new_sp != orig_sp)
 		return;
 	save_context_stack(trace, new_sp,
 			   S390_lowcore.thread_info,
-			   S390_lowcore.thread_info + THREAD_SIZE);
+			   S390_lowcore.thread_info + THREAD_SIZE, 1);
+}
+
+void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
+{
+	unsigned long sp, low, high;
+
+	sp = tsk->thread.ksp & PSW_ADDR_INSN;
+	low = (unsigned long) task_stack_page(tsk);
+	high = (unsigned long) task_pt_regs(tsk);
+	save_context_stack(trace, sp, low, high, 0);
+	if (trace->nr_entries < trace->max_entries)
+		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }

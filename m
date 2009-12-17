Return-Path: <linux-kernel-owner+w=401wt.eu-S1764366AbZLQKyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764366AbZLQKyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 05:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760067AbZLQKyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 05:54:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:53996 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933837AbZLQKx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 05:53:28 -0500
Date: Thu, 17 Dec 2009 10:53:05 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1261024834-5336-2-git-send-regression-fweisbec@gmail.com>
References: <1261024834-5336-2-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf events, x86/stacktrace: Fix performance/softlockup by providing a special frame pointer-only stack walker
Message-ID: <tip-06d65bda75341485d32f33da474b0664819ad497@git.kernel.org>
Git-Commit-ID: 06d65bda75341485d32f33da474b0664819ad497
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  06d65bda75341485d32f33da474b0664819ad497
Gitweb:     http://git.kernel.org/tip/06d65bda75341485d32f33da474b0664819ad497
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 17 Dec 2009 05:40:34 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Dec 2009 10:42:52 +0100

perf events, x86/stacktrace: Fix performance/softlockup by providing a special frame pointer-only stack walker

It's just wasteful for stacktrace users like perf to walk
through every entries on the stack whereas these only accept
reliable ones, ie: that the frame pointer validates.

Since perf requires pure reliable stacktraces, it needs a stack
walker based on frame pointers-only to optimize the stacktrace
processing.

This might solve some near-lockup scenarios that can be triggered
by call-graph tracing timer events.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1261024834-5336-2-git-send-regression-fweisbec@gmail.com>
[ v2: fix for modular builds and small detail tidyup ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/stacktrace.h |    6 ++++++
 arch/x86/kernel/cpu/perf_event.c  |    2 +-
 arch/x86/kernel/dumpstack.c       |   28 ++++++++++++++++++++++++++--
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index 6c75151..35e8912 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -22,6 +22,12 @@ print_context_stack(struct thread_info *tinfo,
 		    const struct stacktrace_ops *ops, void *data,
 		    unsigned long *end, int *graph);
 
+extern unsigned long
+print_context_stack_bp(struct thread_info *tinfo,
+		       unsigned long *stack, unsigned long bp,
+		       const struct stacktrace_ops *ops, void *data,
+		       unsigned long *end, int *graph);
+
 /* Generic stack tracer with callbacks */
 
 struct stacktrace_ops {
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index d3802ee..c223b7e 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2336,7 +2336,7 @@ static const struct stacktrace_ops backtrace_ops = {
 	.warning_symbol		= backtrace_warning_symbol,
 	.stack			= backtrace_stack,
 	.address		= backtrace_address,
-	.walk_stack		= print_context_stack,
+	.walk_stack		= print_context_stack_bp,
 };
 
 #include "../dumpstack.h"
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 8aaa119..c56bc28 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -109,6 +109,30 @@ print_context_stack(struct thread_info *tinfo,
 	}
 	return bp;
 }
+EXPORT_SYMBOL_GPL(print_context_stack);
+
+unsigned long
+print_context_stack_bp(struct thread_info *tinfo,
+		       unsigned long *stack, unsigned long bp,
+		       const struct stacktrace_ops *ops, void *data,
+		       unsigned long *end, int *graph)
+{
+	struct stack_frame *frame = (struct stack_frame *)bp;
+	unsigned long *ret_addr = &frame->return_address;
+
+	while (valid_stack_ptr(tinfo, ret_addr, sizeof(*ret_addr), end)) {
+		unsigned long addr = *ret_addr;
+
+		if (__kernel_text_address(addr)) {
+			ops->address(data, addr, 1);
+			frame = frame->next_frame;
+			ret_addr = &frame->return_address;
+			print_ftrace_graph_addr(addr, data, ops, tinfo, graph);
+		}
+	}
+	return (unsigned long)frame;
+}
+EXPORT_SYMBOL_GPL(print_context_stack_bp);
 
 
 static void
@@ -143,8 +167,8 @@ static void print_trace_address(void *data, unsigned long addr, int reliable)
 static const struct stacktrace_ops print_trace_ops = {
 	.warning		= print_trace_warning,
 	.warning_symbol		= print_trace_warning_symbol,
-	.stack 			= print_trace_stack,
-	.address 		= print_trace_address,
+	.stack			= print_trace_stack,
+	.address		= print_trace_address,
 	.walk_stack		= print_context_stack,
 };
 

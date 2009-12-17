Return-Path: <linux-kernel-owner+w=401wt.eu-S936677AbZLQElp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936677AbZLQElp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936666AbZLQEkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:40:49 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39695 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763989AbZLQEkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:40:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aAmzfaBzXAm8JG8NWukAGFt0+ilb61nPlny5ZWSZ8XHhIsl6EdmtOIFflmR95vLq/W
         LyWlA0X8tJiyjSfm+Ov//MLMugypAZtBElwohRtS9LupiUOil5ibsswwLjELJIOHoIqB
         ZsVMfeu07kG/f17SHWcdmP+wrt+tvuQap5nyo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/2] x86/stacktrace: Provide a special frame pointer-only stack walker
Date: Thu, 17 Dec 2009 05:40:34 +0100
Message-Id: <1261024834-5336-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1261024834-5336-1-git-send-regression-fweisbec@gmail.com>
References: <1261024834-5336-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Tested in x86-64 only)

It's just wasteful for stacktrace users like perf to walk through
every entries on the stack whereas these only accept reliable ones,
ie: that the frame pointer validates.

Since perf requires pure reliable stacktraces, it needs a stack
walker based on frame pointers-only to optimize the stacktrace
processing.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/x86/include/asm/stacktrace.h |    6 ++++++
 arch/x86/kernel/cpu/perf_event.c  |    2 +-
 arch/x86/kernel/dumpstack.c       |   22 ++++++++++++++++++++++
 3 files changed, 29 insertions(+), 1 deletions(-)

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
index 8aaa119..b999d3d 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -110,6 +110,28 @@ print_context_stack(struct thread_info *tinfo,
 	return bp;
 }
 
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
+
 
 static void
 print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
-- 
1.6.2.3


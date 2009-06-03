Return-Path: <linux-kernel-owner+w=401wt.eu-S1757746AbZFCPTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746AbZFCPTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbZFCPSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:18:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37131 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbZFCPSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:18:20 -0400
Message-Id: <20090603151821.497707476@goodmis.org>
References: <20090603151724.144915858@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 03 Jun 2009 11:17:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/5] tracing: add annotation to what type of stack trace is recorded
Content-Disposition: inline; filename=0005-tracing-add-annotation-to-what-type-of-stack-trace-i.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The current method of printing out a stack trace is to add a new line
and print out the trace:

    yum-updatesd-3120  [002]   573.691303:
 => do_softirq
 => irq_exit
 => smp_apic_timer_interrupt
 => apic_timer_interrupt

This looks a bit awkward, and if we have both stack and user stack traces
running, it would be nice to have a title to tell them apart, although
it is easy to tell by the output.

This patch adds an annotation to the start of the stack traces:

            init-1     [003]   929.304979: <stack trace>
 => user_path_at
 => vfs_fstatat
 => vfs_stat
 => sys_newstat
 => system_call_fastpath

             cat-3459  [002]  1016.824040: <user stack trace>
 =>  <0000003aae6c0250>
 =>  <00007ffff4b06ae4>
 =>  <69636172742f6775>

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_output.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 8afeea4..425725c 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -976,7 +976,7 @@ static enum print_line_t trace_stack_print(struct trace_iterator *iter,
 
 	trace_assign_type(field, iter->ent);
 
-	if (!trace_seq_puts(s, "\n"))
+	if (!trace_seq_puts(s, "<stack trace>\n"))
 		goto partial;
 	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
 		if (!field->caller[i] || (field->caller[i] == ULONG_MAX))
@@ -1013,7 +1013,7 @@ static enum print_line_t trace_user_stack_print(struct trace_iterator *iter,
 
 	trace_assign_type(field, iter->ent);
 
-	if (!trace_seq_putc(s, '\n'))
+	if (!trace_seq_puts(s, "<user stack trace>\n"))
 		goto partial;
 
 	if (!seq_print_userip_objs(field, s, flags))
-- 
1.6.3.1

-- 

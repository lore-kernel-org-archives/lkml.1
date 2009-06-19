Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbZFSRZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbZFSRZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 13:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbZFSRZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 13:25:08 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:49765 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbZFSRZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 13:25:07 -0400
Date: Fri, 19 Jun 2009 22:54:53 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 1/3] ksym_tracer: Eliminate trace concatenation and machine
	stall issues post removal
Message-ID: <20090619172453.GB26071@in.ibm.com>
References: <20090619172035.443923337@prasadkr_t60p.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=new_ksym_fix_NEW01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes two issues reported with ksym tracer, seen after
removal of a symbol from the tracer i) Concatenation of trace logs
into a single line ii) Machine stall seen when logs are viewed
using 'trace_pipe'.

Known issue: Upon removal, 'cat trace_pipe' (without any preceding
command and any further output in the trace buffer) responds to
SIGTERM quickly but only after an indeterminate amount of delay
for SIGINT.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 kernel/trace/trace.h      |   12 +++++++++---
 kernel/trace/trace_ksym.c |   11 ++++-------
 2 files changed, 13 insertions(+), 10 deletions(-)

Index: linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/kernel/trace/trace_ksym.c
+++ linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
@@ -71,7 +71,7 @@ void ksym_hbp_handler(struct hw_breakpoi
 {
 	struct ring_buffer_event *event;
 	struct trace_array *tr;
-	struct trace_ksym *entry;
+	struct trace_ksym_rb *entry;
 	int pc;
 
 	if (!ksym_tracing_enabled)
@@ -87,7 +87,7 @@ void ksym_hbp_handler(struct hw_breakpoi
 
 	entry = ring_buffer_event_data(event);
 	strlcpy(entry->ksym_name, hbp->info.name, KSYM_SYMBOL_LEN);
-	entry->ksym_hbp = hbp;
+	memcpy(&(entry->ksym_hbp), hbp, sizeof(struct hw_breakpoint));
 	entry->ip = instruction_pointer(regs);
 	strlcpy(entry->p_name, current->comm, TASK_COMM_LEN);
 #ifdef CONFIG_PROFILE_KSYM_TRACER
@@ -380,7 +380,7 @@ static enum print_line_t ksym_trace_outp
 {
 	struct trace_entry *entry = iter->ent;
 	struct trace_seq *s = &iter->seq;
-	struct trace_ksym *field;
+	struct trace_ksym_rb *field;
 	char str[KSYM_SYMBOL_LEN];
 	int ret;
 
@@ -394,17 +394,14 @@ static enum print_line_t ksym_trace_outp
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	switch (field->ksym_hbp->info.type) {
+	switch (field->ksym_hbp.info.type) {
 	case HW_BREAKPOINT_WRITE:
 		ret = trace_seq_printf(s, " W  ");
 		break;
 	case HW_BREAKPOINT_RW:
 		ret = trace_seq_printf(s, " RW ");
 		break;
-	default:
-		return TRACE_TYPE_PARTIAL_LINE;
 	}
-
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
Index: linux-2.6-tip.hbkpt/kernel/trace/trace.h
===================================================================
--- linux-2.6-tip.hbkpt.orig/kernel/trace/trace.h
+++ linux-2.6-tip.hbkpt/kernel/trace/trace.h
@@ -216,15 +216,21 @@ struct syscall_trace_exit {
 extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
 
 struct trace_ksym {
-	struct trace_entry	ent;
 	struct hw_breakpoint	*ksym_hbp;
 	unsigned long		ksym_addr;
-	unsigned long		ip;
 #ifdef CONFIG_PROFILE_KSYM_TRACER
 	unsigned long		counter;
 #endif
 	struct hlist_node	ksym_hlist;
 	char			ksym_name[KSYM_NAME_LEN];
+};
+
+/* Ring buffer's copy of the breakpoint data */
+struct trace_ksym_rb {
+	struct trace_entry	ent;
+	struct hw_breakpoint	ksym_hbp;
+	unsigned long		ip;
+	char			ksym_name[KSYM_NAME_LEN];
 	char			p_name[TASK_COMM_LEN];
 };
 
@@ -343,7 +349,7 @@ extern void __ftrace_bad_type(void);
 			  TRACE_SYSCALL_ENTER);				\
 		IF_ASSIGN(var, ent, struct syscall_trace_exit,		\
 			  TRACE_SYSCALL_EXIT);				\
-		IF_ASSIGN(var, ent, struct trace_ksym, TRACE_KSYM);	\
+		IF_ASSIGN(var, ent, struct trace_ksym_rb, TRACE_KSYM);	\
 		__ftrace_bad_type();					\
 	} while (0)
 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbZCED30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbZCED30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 22:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbZCED1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 22:27:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40204 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbZCED1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 22:27:16 -0500
Message-Id: <20090305032713.479148505@goodmis.org>
References: <20090305032532.802709985@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Mar 2009 22:25:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Theodore Tso <tytso@mit.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/7] tracing: remove extra latency_trace method from trace structure
Content-Disposition: inline; filename=0005-tracing-remove-extra-latency_trace-method-from-trac.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

The trace and latency_trace function pointers are identical for
every tracer but the function tracer. The differences in the function
tracer are trivial (latency output puts paranthesis around parent).

This patch removes the latency_trace pointer and all prints will
now just use the trace output function pointer.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/blktrace.c     |    1 -
 kernel/trace/trace.c        |    2 +-
 kernel/trace/trace_branch.c |    1 -
 kernel/trace/trace_output.c |   32 --------------------------------
 kernel/trace/trace_output.h |    1 -
 5 files changed, 1 insertions(+), 36 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index e82cb9e..e39679a 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1231,7 +1231,6 @@ static struct tracer blk_tracer __read_mostly = {
 static struct trace_event trace_blk_event = {
 	.type	 	= TRACE_BLK,
 	.trace		= blk_trace_event_print,
-	.latency_trace	= blk_trace_event_print,
 	.binary		= blk_trace_event_print_binary,
 };
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 55fcbb5..21b89ec 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1485,7 +1485,7 @@ static enum print_line_t print_lat_fmt(struct trace_iterator *iter)
 	}
 
 	if (event)
-		return event->latency_trace(iter, sym_flags);
+		return event->trace(iter, sym_flags);
 
 	if (!trace_seq_printf(s, "Unknown type %d\n", entry->type))
 		goto partial;
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index c2e68d4..aaa0755 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -159,7 +159,6 @@ static enum print_line_t trace_branch_print(struct trace_iterator *iter,
 static struct trace_event trace_branch_event = {
 	.type	 	= TRACE_BRANCH,
 	.trace		= trace_branch_print,
-	.latency_trace	= trace_branch_print,
 };
 
 static struct tracer branch_trace __read_mostly =
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 9fc8150..306fef8 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -437,8 +437,6 @@ int register_ftrace_event(struct trace_event *event)
 
 	if (event->trace == NULL)
 		event->trace = trace_nop_print;
-	if (event->latency_trace == NULL)
-		event->latency_trace = trace_nop_print;
 	if (event->raw == NULL)
 		event->raw = trace_nop_print;
 	if (event->hex == NULL)
@@ -480,29 +478,6 @@ enum print_line_t trace_nop_print(struct trace_iterator *iter, int flags)
 }
 
 /* TRACE_FN */
-static enum print_line_t trace_fn_latency(struct trace_iterator *iter,
-					  int flags)
-{
-	struct ftrace_entry *field;
-	struct trace_seq *s = &iter->seq;
-
-	trace_assign_type(field, iter->ent);
-
-	if (!seq_print_ip_sym(s, field->ip, flags))
-		goto partial;
-	if (!trace_seq_puts(s, " ("))
-		goto partial;
-	if (!seq_print_ip_sym(s, field->parent_ip, flags))
-		goto partial;
-	if (!trace_seq_puts(s, ")\n"))
-		goto partial;
-
-	return TRACE_TYPE_HANDLED;
-
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
-}
-
 static enum print_line_t trace_fn_trace(struct trace_iterator *iter, int flags)
 {
 	struct ftrace_entry *field;
@@ -573,7 +548,6 @@ static enum print_line_t trace_fn_bin(struct trace_iterator *iter, int flags)
 static struct trace_event trace_fn_event = {
 	.type	 	= TRACE_FN,
 	.trace		= trace_fn_trace,
-	.latency_trace	= trace_fn_latency,
 	.raw		= trace_fn_raw,
 	.hex		= trace_fn_hex,
 	.binary		= trace_fn_bin,
@@ -705,7 +679,6 @@ static enum print_line_t trace_ctxwake_bin(struct trace_iterator *iter,
 static struct trace_event trace_ctx_event = {
 	.type	 	= TRACE_CTX,
 	.trace		= trace_ctx_print,
-	.latency_trace	= trace_ctx_print,
 	.raw		= trace_ctx_raw,
 	.hex		= trace_ctx_hex,
 	.binary		= trace_ctxwake_bin,
@@ -714,7 +687,6 @@ static struct trace_event trace_ctx_event = {
 static struct trace_event trace_wake_event = {
 	.type	 	= TRACE_WAKE,
 	.trace		= trace_wake_print,
-	.latency_trace	= trace_wake_print,
 	.raw		= trace_wake_raw,
 	.hex		= trace_wake_hex,
 	.binary		= trace_ctxwake_bin,
@@ -770,7 +742,6 @@ static enum print_line_t trace_special_bin(struct trace_iterator *iter,
 static struct trace_event trace_special_event = {
 	.type	 	= TRACE_SPECIAL,
 	.trace		= trace_special_print,
-	.latency_trace	= trace_special_print,
 	.raw		= trace_special_print,
 	.hex		= trace_special_hex,
 	.binary		= trace_special_bin,
@@ -808,7 +779,6 @@ static enum print_line_t trace_stack_print(struct trace_iterator *iter,
 static struct trace_event trace_stack_event = {
 	.type	 	= TRACE_STACK,
 	.trace		= trace_stack_print,
-	.latency_trace	= trace_stack_print,
 	.raw		= trace_special_print,
 	.hex		= trace_special_hex,
 	.binary		= trace_special_bin,
@@ -838,7 +808,6 @@ static enum print_line_t trace_user_stack_print(struct trace_iterator *iter,
 static struct trace_event trace_user_stack_event = {
 	.type	 	= TRACE_USER_STACK,
 	.trace		= trace_user_stack_print,
-	.latency_trace	= trace_user_stack_print,
 	.raw		= trace_special_print,
 	.hex		= trace_special_hex,
 	.binary		= trace_special_bin,
@@ -883,7 +852,6 @@ static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags)
 static struct trace_event trace_print_event = {
 	.type	 	= TRACE_PRINT,
 	.trace		= trace_print_print,
-	.latency_trace	= trace_print_print,
 	.raw		= trace_print_raw,
 };
 
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index 551a25a..8a34d68 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -10,7 +10,6 @@ struct trace_event {
 	struct hlist_node	node;
 	int			type;
 	trace_print_func	trace;
-	trace_print_func	latency_trace;
 	trace_print_func	raw;
 	trace_print_func	hex;
 	trace_print_func	binary;
-- 
1.6.1.3

-- 

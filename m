Return-Path: <linux-kernel-owner+w=401wt.eu-S1754295AbZBDAGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbZBDAGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZBDAGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:06:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45088 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbZBDAGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:06:40 -0500
Date: Tue, 3 Feb 2009 22:05:50 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH tip 1/1] trace: Make the trace_event callbacks return enum
	print_line_t
Message-ID: <20090204000550.GH3440@ghostprotocols.net>
References: <20090203222041.GE3440@ghostprotocols.net> <20090203224933.GG6344@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203224933.GG6344@nowhere>
X-Url: http://oops.ghostprotocols.net:81/blog
Impact: API change
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As they actually all return these enumerators.
    
Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/block/blktrace.c b/block/blktrace.c
index 12df276..c7698d1 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -1158,7 +1158,8 @@ static struct {
 	[__BLK_TA_REMAP]	= {{  "A", "remap" },	   blk_log_remap },
 };
 
-static int blk_trace_event_print(struct trace_iterator *iter, int flags)
+static enum print_line_t blk_trace_event_print(struct trace_iterator *iter,
+					       int flags)
 {
 	struct trace_seq *s = &iter->seq;
 	const struct blk_io_trace *t = (struct blk_io_trace *)iter->ent;
@@ -1196,7 +1197,8 @@ static int blk_trace_synthesize_old_trace(struct trace_iterator *iter)
 				sizeof(old) - offset + t->pdu_len);
 }
 
-static int blk_trace_event_print_binary(struct trace_iterator *iter, int flags)
+static enum print_line_t
+blk_trace_event_print_binary(struct trace_iterator *iter, int flags)
 {
 	return blk_trace_synthesize_old_trace(iter) ?
 			TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5822ff4..fd51cf0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1495,7 +1495,7 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 
 	event = ftrace_find_event(entry->type);
 	if (event && event->hex) {
-		int ret = event->hex(iter, 0);
+		enum print_line_t ret = event->hex(iter, 0);
 		if (ret != TRACE_TYPE_HANDLED)
 			return ret;
 	}
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index f6b35e1..7ac72a4 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -160,7 +160,8 @@ trace_print_print(struct trace_seq *s, struct trace_entry *entry, int flags)
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static int trace_branch_print(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_branch_print(struct trace_iterator *iter,
+					    int flags)
 {
 	struct trace_branch *field;
 
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 5b3c914..b7380ee 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -463,13 +463,14 @@ int unregister_ftrace_event(struct trace_event *event)
  * Standard events
  */
 
-int trace_nop_print(struct trace_iterator *iter, int flags)
+enum print_line_t trace_nop_print(struct trace_iterator *iter, int flags)
 {
 	return TRACE_TYPE_HANDLED;
 }
 
 /* TRACE_FN */
-static int trace_fn_latency(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_fn_latency(struct trace_iterator *iter,
+					  int flags)
 {
 	struct ftrace_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -491,7 +492,7 @@ static int trace_fn_latency(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static int trace_fn_trace(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_fn_trace(struct trace_iterator *iter, int flags)
 {
 	struct ftrace_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -518,7 +519,7 @@ static int trace_fn_trace(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static int trace_fn_raw(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_fn_raw(struct trace_iterator *iter, int flags)
 {
 	struct ftrace_entry *field;
 
@@ -532,7 +533,7 @@ static int trace_fn_raw(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_HANDLED;
 }
 
-static int trace_fn_hex(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_fn_hex(struct trace_iterator *iter, int flags)
 {
 	struct ftrace_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -545,7 +546,7 @@ static int trace_fn_hex(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_HANDLED;
 }
 
-static int trace_fn_bin(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_fn_bin(struct trace_iterator *iter, int flags)
 {
 	struct ftrace_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -568,7 +569,8 @@ static struct trace_event trace_fn_event = {
 };
 
 /* TRACE_CTX an TRACE_WAKE */
-static int trace_ctxwake_print(struct trace_iterator *iter, char *delim)
+static enum print_line_t trace_ctxwake_print(struct trace_iterator *iter,
+					     char *delim)
 {
 	struct ctx_switch_entry *field;
 	char *comm;
@@ -593,12 +595,13 @@ static int trace_ctxwake_print(struct trace_iterator *iter, char *delim)
 	return TRACE_TYPE_HANDLED;
 }
 
-static int trace_ctx_print(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_ctx_print(struct trace_iterator *iter, int flags)
 {
 	return trace_ctxwake_print(iter, "==>");
 }
 
-static int trace_wake_print(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_wake_print(struct trace_iterator *iter,
+					  int flags)
 {
 	return trace_ctxwake_print(iter, "  +");
 }
@@ -626,12 +629,12 @@ static int trace_ctxwake_raw(struct trace_iterator *iter, char S)
 	return TRACE_TYPE_HANDLED;
 }
 
-static int trace_ctx_raw(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_ctx_raw(struct trace_iterator *iter, int flags)
 {
 	return trace_ctxwake_raw(iter, 0);
 }
 
-static int trace_wake_raw(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_wake_raw(struct trace_iterator *iter, int flags)
 {
 	return trace_ctxwake_raw(iter, '+');
 }
@@ -660,17 +663,18 @@ static int trace_ctxwake_hex(struct trace_iterator *iter, char S)
 	return TRACE_TYPE_HANDLED;
 }
 
-static int trace_ctx_hex(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_ctx_hex(struct trace_iterator *iter, int flags)
 {
 	return trace_ctxwake_hex(iter, 0);
 }
 
-static int trace_wake_hex(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_wake_hex(struct trace_iterator *iter, int flags)
 {
 	return trace_ctxwake_hex(iter, '+');
 }
 
-static int trace_ctxwake_bin(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_ctxwake_bin(struct trace_iterator *iter,
+					   int flags)
 {
 	struct ctx_switch_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -706,7 +710,8 @@ static struct trace_event trace_wake_event = {
 };
 
 /* TRACE_SPECIAL */
-static int trace_special_print(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_special_print(struct trace_iterator *iter,
+					     int flags)
 {
 	struct special_entry *field;
 
@@ -721,7 +726,8 @@ static int trace_special_print(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_HANDLED;
 }
 
-static int trace_special_hex(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_special_hex(struct trace_iterator *iter,
+					   int flags)
 {
 	struct special_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -735,7 +741,8 @@ static int trace_special_hex(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_HANDLED;
 }
 
-static int trace_special_bin(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_special_bin(struct trace_iterator *iter,
+					   int flags)
 {
 	struct special_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -760,7 +767,8 @@ static struct trace_event trace_special_event = {
 
 /* TRACE_STACK */
 
-static int trace_stack_print(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_stack_print(struct trace_iterator *iter,
+					   int flags)
 {
 	struct stack_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -796,7 +804,8 @@ static struct trace_event trace_stack_event = {
 };
 
 /* TRACE_USER_STACK */
-static int trace_user_stack_print(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_user_stack_print(struct trace_iterator *iter,
+						int flags)
 {
 	struct userstack_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -825,7 +834,8 @@ static struct trace_event trace_user_stack_event = {
 };
 
 /* TRACE_PRINT */
-static int trace_print_print(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_print_print(struct trace_iterator *iter,
+					   int flags)
 {
 	struct print_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -844,7 +854,7 @@ static int trace_print_print(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static int trace_print_raw(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags)
 {
 	struct print_entry *field;
 
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index 3aeb31f..551a25a 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -3,7 +3,8 @@
 
 #include "trace.h"
 
-typedef int (*trace_print_func)(struct trace_iterator *iter, int flags);
+typedef enum print_line_t (*trace_print_func)(struct trace_iterator *iter,
+					      int flags);
 
 struct trace_event {
 	struct hlist_node	node;
@@ -39,7 +40,7 @@ struct trace_event *ftrace_find_event(int type);
 int register_ftrace_event(struct trace_event *event);
 int unregister_ftrace_event(struct trace_event *event);
 
-int trace_nop_print(struct trace_iterator *iter, int flags);
+enum print_line_t trace_nop_print(struct trace_iterator *iter, int flags);
 
 #define MAX_MEMHEX_BYTES	8
 #define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760724AbZBDWRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbZBDWRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 17:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbZBDWQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 17:16:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35472 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbZBDWQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 17:16:57 -0500
Date: Wed, 4 Feb 2009 20:16:39 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 1/1] trace: assign defaults at register_ftrace_event
Message-ID: <20090204221639.GO3440@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: simplification of tracers

As all tracers are doing this we might as well do it in
register_ftrace_event and save one branch each time we call these
callbacks.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 block/blktrace.c            |    2 --
 kernel/trace/trace.c        |   13 +++++--------
 kernel/trace/trace_branch.c |    3 ---
 kernel/trace/trace_output.c |   13 +++++++++++--
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/block/blktrace.c b/block/blktrace.c
index c7698d1..1ebd068 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -1243,8 +1243,6 @@ static struct trace_event trace_blk_event = {
 	.type	 	= TRACE_BLK,
 	.trace		= blk_trace_event_print,
 	.latency_trace	= blk_trace_event_print,
-	.raw		= trace_nop_print,
-	.hex		= trace_nop_print,
 	.binary		= blk_trace_event_print_binary,
 };
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index fd51cf0..a5e4c0a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1412,7 +1412,7 @@ static enum print_line_t print_lat_fmt(struct trace_iterator *iter)
 			goto partial;
 	}
 
-	if (event && event->latency_trace)
+	if (event)
 		return event->latency_trace(iter, sym_flags);
 
 	if (!trace_seq_printf(s, "Unknown type %d\n", entry->type))
@@ -1441,7 +1441,7 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 			goto partial;
 	}
 
-	if (event && event->trace)
+	if (event)
 		return event->trace(iter, sym_flags);
 
 	if (!trace_seq_printf(s, "Unknown type %d\n", entry->type))
@@ -1467,7 +1467,7 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 	}
 
 	event = ftrace_find_event(entry->type);
-	if (event && event->raw)
+	if (event)
 		return event->raw(iter, 0);
 
 	if (!trace_seq_printf(s, "%d ?\n", entry->type))
@@ -1494,7 +1494,7 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 	}
 
 	event = ftrace_find_event(entry->type);
-	if (event && event->hex) {
+	if (event) {
 		enum print_line_t ret = event->hex(iter, 0);
 		if (ret != TRACE_TYPE_HANDLED)
 			return ret;
@@ -1536,10 +1536,7 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 	}
 
 	event = ftrace_find_event(entry->type);
-	if (event && event->binary)
-		return event->binary(iter, 0);
-
-	return TRACE_TYPE_HANDLED;
+	return event ? event->binary(iter, 0) : TRACE_TYPE_HANDLED;
 }
 
 static int trace_empty(struct trace_iterator *iter)
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 7ac72a4..297deb2 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -182,9 +182,6 @@ static struct trace_event trace_branch_event = {
 	.type	 	= TRACE_BRANCH,
 	.trace		= trace_branch_print,
 	.latency_trace	= trace_branch_print,
-	.raw		= trace_nop_print,
-	.hex		= trace_nop_print,
-	.binary		= trace_nop_print,
 };
 
 static struct tracer branch_trace __read_mostly =
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index b7380ee..b6e99af 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -435,6 +435,17 @@ int register_ftrace_event(struct trace_event *event)
 	if (ftrace_find_event(event->type))
 		goto out;
 
+	if (event->trace == NULL)
+		event->trace = trace_nop_print;
+	if (event->latency_trace == NULL)
+		event->latency_trace = trace_nop_print;
+	if (event->raw == NULL)
+		event->raw = trace_nop_print;
+	if (event->hex == NULL)
+		event->hex = trace_nop_print;
+	if (event->binary == NULL)
+		event->binary = trace_nop_print;
+
 	key = event->type & (EVENT_HASHSIZE - 1);
 
 	hlist_add_head_rcu(&event->node, &event_hash[key]);
@@ -874,8 +885,6 @@ static struct trace_event trace_print_event = {
 	.trace		= trace_print_print,
 	.latency_trace	= trace_print_print,
 	.raw		= trace_print_raw,
-	.hex		= trace_nop_print,
-	.binary		= trace_nop_print,
 };
 
 static struct trace_event *events[] __initdata = {
-- 
1.6.0.6


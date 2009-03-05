Return-Path: <linux-kernel-owner+w=401wt.eu-S1756963AbZCED26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963AbZCED26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 22:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbZCED1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 22:27:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41309 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbZCED1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 22:27:16 -0500
Message-Id: <20090305032713.663776728@goodmis.org>
References: <20090305032532.802709985@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Mar 2009 22:25:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Theodore Tso <tytso@mit.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 6/7] tracing: consolidate print_lat_fmt and print_trace_fmt
Content-Disposition: inline; filename=0006-tracing-consolidate-print_lat_fmt-and-print_trace_f.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

Both print_lat_fmt and print_trace_fmt do pretty much the same thing
except for one different function call. This patch consolidates the
two functions and adds an if statement to perform the difference.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   39 +++++++--------------------------------
 1 files changed, 7 insertions(+), 32 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 21b89ec..d1ef439 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1468,33 +1468,6 @@ static void test_cpu_buff_start(struct trace_iterator *iter)
 	trace_seq_printf(s, "##### CPU %u buffer started ####\n", iter->cpu);
 }
 
-static enum print_line_t print_lat_fmt(struct trace_iterator *iter)
-{
-	struct trace_seq *s = &iter->seq;
-	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
-	struct trace_event *event;
-	struct trace_entry *entry = iter->ent;
-
-	test_cpu_buff_start(iter);
-
-	event = ftrace_find_event(entry->type);
-
-	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
-		if (!trace_print_lat_context(iter))
-			goto partial;
-	}
-
-	if (event)
-		return event->trace(iter, sym_flags);
-
-	if (!trace_seq_printf(s, "Unknown type %d\n", entry->type))
-		goto partial;
-
-	return TRACE_TYPE_HANDLED;
-partial:
-	return TRACE_TYPE_PARTIAL_LINE;
-}
-
 static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
@@ -1509,8 +1482,13 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 	event = ftrace_find_event(entry->type);
 
 	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
-		if (!trace_print_context(iter))
-			goto partial;
+		if (iter->iter_flags & TRACE_FILE_LAT_FMT) {
+			if (!trace_print_lat_context(iter))
+				goto partial;
+		} else {
+			if (!trace_print_context(iter))
+				goto partial;
+		}
 	}
 
 	if (event)
@@ -1652,9 +1630,6 @@ static enum print_line_t print_trace_line(struct trace_iterator *iter)
 	if (trace_flags & TRACE_ITER_RAW)
 		return print_raw_fmt(iter);
 
-	if (iter->iter_flags & TRACE_FILE_LAT_FMT)
-		return print_lat_fmt(iter);
-
 	return print_trace_fmt(iter);
 }
 
-- 
1.6.1.3

-- 

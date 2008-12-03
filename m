Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYLCBc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYLCBc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 20:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYLCBcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 20:32:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:28947 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbYLCBcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 20:32:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=mHnwise4nDze40oh4FekdjfkihqjcNN2z6PX7KL9Hayc4EhBwr1i9CQyrmIRpbdstd
         /d5vZpZjaiuW9wlvyhQWBNxsurPYQem8oHzRSJuiDkcIQTpHL2W12KXVz0dQnq/6FoBu
         JMRdlPF7NrcAhBfI3NaWpi4zDbF7xIfaF0F6M=
Message-ID: <4935E19C.3090501@gmail.com>
Date: Wed, 03 Dec 2008 02:32:12 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] tracing/function-graph-tracer: improve duration output
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: better output of duration for long calls

The old duration output didn't exceeded 9999.999 us to fit the column
and the nanosecs were always 3 numbers. As Ingo suggested, it's better
to have the whole microseconds elapsed time and shift the nanosecs precision
if needed to fit the maximum 7 numbers. And usec need more number, the case
should be rare and important enough to break a bit the column alignment to
show it.

So, depending of the duration value, we now have these patterns:

u.nnn
uu.nnn
uuu.nnn
uuuu.nnn
uuuuu.nn
uuuuuu.n
uuuuuuuu.....

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 23e19d2..c66578f 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -232,11 +232,50 @@ trace_branch_is_leaf(struct trace_iterator *iter,
 }
 
 
-static inline int
+static enum print_line_t
 print_graph_duration(unsigned long long duration, struct trace_seq *s)
 {
 	unsigned long nsecs_rem = do_div(duration, 1000);
-	return trace_seq_printf(s, "%4llu.%3lu us |  ", duration, nsecs_rem);
+	/* log10(ULONG_MAX) + '\0' */
+	char msecs_str[21];
+	char nsecs_str[5];
+	int ret, len;
+	int i;
+
+	sprintf(msecs_str, "%lu", (unsigned long) duration);
+
+	/* Print msecs */
+	ret = trace_seq_printf(s, msecs_str);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	len = strlen(msecs_str);
+
+	/* Print nsecs (we don't want to exceed 7 numbers) */
+	if (len < 7) {
+		snprintf(nsecs_str, 8 - len, "%03lu", nsecs_rem);
+		ret = trace_seq_printf(s, ".%s", nsecs_str);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+		len += strlen(nsecs_str);
+	}
+
+	ret = trace_seq_printf(s, " us ");
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Print remaining spaces to fit the row's width */
+	for (i = len; i < 7; i++) {
+		ret = trace_seq_printf(s, " ");
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
+
+	ret = trace_seq_printf(s, "|  ");
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+	return TRACE_TYPE_HANDLED;
+
 }
 
 /* Signal a overhead of time execution to the output */
@@ -273,10 +312,6 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 	call = &entry->graph_ent;
 	duration = graph_ret->rettime - graph_ret->calltime;
 
-	/* Must not exceed 8 characters: 9999.999 us */
-	if (duration > 10000000ULL)
-		duration = 9999999ULL;
-
 	/* Overhead */
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERHEAD) {
 		ret = print_graph_overhead(duration, s);
@@ -286,7 +321,7 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 
 	/* Duration */
 	ret = print_graph_duration(duration, s);
-	if (!ret)
+	if (ret == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Function */
@@ -387,10 +422,6 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	int ret;
 	unsigned long long duration = trace->rettime - trace->calltime;
 
-	/* Must not exceed 8 characters: xxxx.yyy us */
-	if (duration > 10000000ULL)
-		duration = 9999999ULL;
-
 	/* Pid */
 	if (verif_pid(s, ent->pid, cpu) == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;
@@ -422,7 +453,7 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 
 	/* Duration */
 	ret = print_graph_duration(duration, s);
-	if (!ret)
+	if (ret == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Closing brace */
-- 
1.5.6.3


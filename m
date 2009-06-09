Return-Path: <linux-kernel-owner+w=401wt.eu-S1759771AbZFIVyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759771AbZFIVyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 17:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758061AbZFIVxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 17:53:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56681 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415AbZFIVxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 17:53:38 -0400
Message-Id: <20090609215338.727397649@goodmis.org>
References: <20090609215211.307980196@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 09 Jun 2009 17:52:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/8] tracing: add trace_seq_vprint interface
Content-Disposition: inline; filename=0001-tracing-add-trace_seq_vprint-interface.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The code to update the print formats for events requires a vprintf
format in the trace_seq. This patch adds that interface.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/trace_seq.h   |    2 ++
 kernel/trace/trace_output.c |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index ba9627f..c68bccb 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -27,6 +27,8 @@ trace_seq_init(struct trace_seq *s)
 #ifdef CONFIG_TRACING
 extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
+extern int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
 extern int
 trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary);
 extern void trace_print_seq(struct seq_file *m, struct trace_seq *s);
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 425725c..c05aff4 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -100,6 +100,38 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 }
 EXPORT_SYMBOL_GPL(trace_seq_printf);
 
+/**
+ * trace_seq_vprintf - sequence printing of trace information
+ * @s: trace sequence descriptor
+ * @fmt: printf format string
+ *
+ * The tracer may use either sequence operations or its own
+ * copy to user routines. To simplify formating of a trace
+ * trace_seq_printf is used to store strings into a special
+ * buffer (@s). Then the output may be either used by
+ * the sequencer or pulled into another buffer.
+ */
+int
+trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
+{
+	int len = (PAGE_SIZE - 1) - s->len;
+	int ret;
+
+	if (!len)
+		return 0;
+
+	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
+
+	/* If we can't write it all, don't bother writing anything */
+	if (ret >= len)
+		return 0;
+
+	s->len += ret;
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(trace_seq_vprintf);
+
 int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 {
 	int len = (PAGE_SIZE - 1) - s->len;
-- 
1.6.3.1

-- 

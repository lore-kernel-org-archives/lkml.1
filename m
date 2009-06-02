Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbZFBEp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbZFBEp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbZFBEnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:43:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41684 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbZFBEnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:43:39 -0400
Message-Id: <20090602044341.159038003@goodmis.org>
References: <20090602044315.439593107@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Jun 2009 00:43:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 09/10] tracing: make trace pipe recognize latency format flag
Content-Disposition: inline; filename=0009-tracing-make-trace-pipe-recognize-latency-format-fla.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The trace_pipe did not recognize the latency format flag and would produce
different output than the trace file. The problem was partly due that
the trace flags in the iterator was not set as well as the trace_pipe
zeros out part of the iterator (including the flags) to be able to use
the same routines as the trace file. trace_flags of the iterator should
not cause any problems when not zeroed out by for trace_pipe.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    2 +-
 kernel/trace/trace.c         |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index bbf40f6..5c093ff 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -51,6 +51,7 @@ struct trace_iterator {
 	int			cpu_file;
 	struct mutex		mutex;
 	struct ring_buffer_iter	*buffer_iter[NR_CPUS];
+	unsigned long		iter_flags;
 
 	/* The below is zeroed out in pipe_read */
 	struct trace_seq	seq;
@@ -58,7 +59,6 @@ struct trace_iterator {
 	int			cpu;
 	u64			ts;
 
-	unsigned long		iter_flags;
 	loff_t			pos;
 	long			idx;
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a3a8a87..cae34c6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2826,6 +2826,9 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 	/* trace pipe does not show start of buffer */
 	cpumask_setall(iter->started);
 
+	if (trace_flags & TRACE_ITER_LATENCY_FMT)
+		iter->iter_flags |= TRACE_FILE_LAT_FMT;
+
 	iter->cpu_file = cpu_file;
 	iter->tr = &global_trace;
 	mutex_init(&iter->mutex);
-- 
1.6.3.1

-- 

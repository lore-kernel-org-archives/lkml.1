Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbZCBUax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbZCBUax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 15:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbZCBUa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 15:30:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65521 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZCBUa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 15:30:27 -0500
Message-Id: <20090302203024.334429362@goodmis.org>
References: <20090302202925.364437449@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 02 Mar 2009 15:29:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/7] tracing: make trace_seq_reset global and rename to trace_seq_init
Content-Disposition: inline; filename=0003-tracing-make-trace_seq_reset-global-and-rename-to-t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

The trace_seq functions may be used separately outside of the ftrace
iterator. The trace_seq_reset is needed for these operations.

This patch also renames trace_seq_reset to the more appropriate
trace_seq_init.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   17 +++++------------
 kernel/trace/trace.h |    8 ++++++++
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c5e39cd..ea055aa 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -342,13 +342,6 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	tracing_record_cmdline(tsk);
 }
 
-static void
-trace_seq_reset(struct trace_seq *s)
-{
-	s->len = 0;
-	s->readpos = 0;
-}
-
 ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
 {
 	int len;
@@ -395,7 +388,7 @@ trace_print_seq(struct seq_file *m, struct trace_seq *s)
 	s->buffer[len] = 0;
 	seq_puts(m, s->buffer);
 
-	trace_seq_reset(s);
+	trace_seq_init(s);
 }
 
 /**
@@ -2620,7 +2613,7 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 	if (sret != -EBUSY)
 		return sret;
 
-	trace_seq_reset(&iter->seq);
+	trace_seq_init(&iter->seq);
 
 	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
@@ -2682,7 +2675,7 @@ waitagain:
 	/* Now copy what we have to the user */
 	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
 	if (iter->seq.readpos >= iter->seq.len)
-		trace_seq_reset(&iter->seq);
+		trace_seq_init(&iter->seq);
 
 	/*
 	 * If there was nothing to send to user, inspite of consuming trace
@@ -2819,7 +2812,7 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		partial[i].offset = 0;
 		partial[i].len = iter->seq.len;
 
-		trace_seq_reset(&iter->seq);
+		trace_seq_init(&iter->seq);
 	}
 
 	mutex_unlock(&iter->mutex);
@@ -3631,7 +3624,7 @@ trace_printk_seq(struct trace_seq *s)
 
 	printk(KERN_TRACE "%s", s->buffer);
 
-	trace_seq_reset(s);
+	trace_seq_init(s);
 }
 
 void ftrace_dump(void)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f6fa0b9..cf6ba41 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -395,6 +395,14 @@ struct trace_seq {
 	unsigned int		readpos;
 };
 
+static inline void
+trace_seq_init(struct trace_seq *s)
+{
+	s->len = 0;
+	s->readpos = 0;
+}
+
+
 #define TRACE_PIPE_ALL_CPU	-1
 
 /*
-- 
1.5.6.5

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757066AbYDUVV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbYDUVV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbYDUVVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:21:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60989 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbYDUVVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:21:30 -0400
Message-Id: <20080421212128.360075568@goodmis.org>
References: <20080421210935.460817943@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 Apr 2008 17:09:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       akpm@osdl.org, Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] ftrace: add trace pipe header pluggin
Content-Disposition: inline; filename=ftrace-header-by-method.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a method for open_pipe and open_read to the pluggins
so that they can add a header to the trace pipe call.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   38 +++++++++++++++++++++++++++++++-------
 kernel/trace/trace.h |    5 +++++
 2 files changed, 36 insertions(+), 7 deletions(-)

Index: linux-sched-devel.git/kernel/trace/trace.c
===================================================================
--- linux-sched-devel.git.orig/kernel/trace/trace.c	2008-04-21 14:39:43.000000000 -0400
+++ linux-sched-devel.git/kernel/trace/trace.c	2008-04-21 16:50:49.000000000 -0400
@@ -2352,11 +2352,15 @@ static int tracing_open_pipe(struct inod
 	if (!iter)
 		return -ENOMEM;
 
+	mutex_lock(&trace_types_lock);
 	iter->tr = &global_trace;
 	iter->trace = current_trace;
-
 	filp->private_data = iter;
 
+	if (iter->trace->pipe_open)
+		iter->trace->pipe_open(iter);
+	mutex_unlock(&trace_types_lock);
+
 	return 0;
 }
 
@@ -2425,13 +2429,24 @@ tracing_read_pipe(struct file *filp, cha
 		return cnt;
 	}
 
+	mutex_lock(&trace_types_lock);
+	if (iter->trace->read) {
+		ret = iter->trace->read(iter, filp, ubuf, cnt, ppos);
+		if (ret) {
+			read = ret;
+			goto out;
+		}
+	}
+
 	trace_seq_reset(&iter->seq);
 	start = 0;
 
 	while (trace_empty(iter)) {
 
-		if ((filp->f_flags & O_NONBLOCK))
-			return -EAGAIN;
+		if ((filp->f_flags & O_NONBLOCK)) {
+			read = -EAGAIN;
+			goto out;
+		}
 
 		/*
 		 * This is a make-shift waitqueue. The reason we don't use
@@ -2445,16 +2460,22 @@ tracing_read_pipe(struct file *filp, cha
 		set_current_state(TASK_INTERRUPTIBLE);
 		iter->tr->waiter = current;
 
+		mutex_unlock(&trace_types_lock);
+
 		/* sleep for one second, and try again. */
 		schedule_timeout(HZ);
 
+		mutex_lock(&trace_types_lock);
+
 		iter->tr->waiter = NULL;
 
-		if (signal_pending(current))
-			return -EINTR;
+		if (signal_pending(current)) {
+			read = -EINTR;
+			goto out;
+		}
 
 		if (iter->trace != current_trace)
-			return 0;
+			goto out;
 
 		/*
 		 * We block until we read something and tracing is disabled.
@@ -2473,7 +2494,7 @@ tracing_read_pipe(struct file *filp, cha
 
 	/* stop when tracing is finished */
 	if (trace_empty(iter))
-		return 0;
+		goto out;
 
 	if (cnt >= PAGE_SIZE)
 		cnt = PAGE_SIZE - 1;
@@ -2563,6 +2584,9 @@ tracing_read_pipe(struct file *filp, cha
 	if (ret)
 		read = -EFAULT;
 
+out:
+	mutex_unlock(&trace_types_lock);
+
 	return read;
 }
 
Index: linux-sched-devel.git/kernel/trace/trace.h
===================================================================
--- linux-sched-devel.git.orig/kernel/trace/trace.h	2008-04-21 14:38:09.000000000 -0400
+++ linux-sched-devel.git/kernel/trace/trace.h	2008-04-21 15:23:47.000000000 -0400
@@ -140,9 +140,13 @@ struct tracer {
 	void			(*init)(struct trace_array *tr);
 	void			(*reset)(struct trace_array *tr);
 	void			(*open)(struct trace_iterator *iter);
+	void			(*pipe_open)(struct trace_iterator *iter);
 	void			(*close)(struct trace_iterator *iter);
 	void			(*start)(struct trace_iterator *iter);
 	void			(*stop)(struct trace_iterator *iter);
+	ssize_t			(*read)(struct trace_iterator *iter,
+					struct file *filp, char __user *ubuf,
+					size_t cnt, loff_t *ppos);
 	void			(*ctrl_update)(struct trace_array *tr);
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 	int			(*selftest)(struct tracer *trace,
@@ -165,6 +169,7 @@ struct trace_seq {
 struct trace_iterator {
 	struct trace_array	*tr;
 	struct tracer		*trace;
+	void			*private;
 	long			last_overrun[NR_CPUS];
 	long			overrun[NR_CPUS];
 

-- 

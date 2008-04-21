Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbYDUVWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbYDUVWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbYDUVVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:21:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53315 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbYDUVVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:21:33 -0400
Message-Id: <20080421212128.201844090@goodmis.org>
References: <20080421210935.460817943@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 Apr 2008 17:09:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       akpm@osdl.org, Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] ftrace: add logic to record overruns
Content-Disposition: inline; filename=ftrace-account-overruns.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets up the infrastructure to record overruns of the tracing
buffer.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   16 +++++++++++-----
 kernel/trace/trace.h |    6 +++++-
 2 files changed, 16 insertions(+), 6 deletions(-)

Index: linux-sched-devel.git/kernel/trace/trace.c
===================================================================
--- linux-sched-devel.git.orig/kernel/trace/trace.c	2008-04-21 13:47:30.000000000 -0400
+++ linux-sched-devel.git/kernel/trace/trace.c	2008-04-21 14:39:43.000000000 -0400
@@ -612,6 +612,7 @@ void unregister_tracer(struct tracer *ty
 void tracing_reset(struct trace_array_cpu *data)
 {
 	data->trace_idx = 0;
+	data->overrun = 0;
 	data->trace_head = data->trace_tail = head_page(data);
 	data->trace_head_idx = 0;
 	data->trace_tail_idx = 0;
@@ -753,6 +754,7 @@ tracing_get_trace_entry(struct trace_arr
 	if (data->trace_head == data->trace_tail &&
 	    idx_next == data->trace_tail_idx) {
 		/* overrun */
+		data->overrun++;
 		data->trace_tail_idx++;
 		if (data->trace_tail_idx >= ENTRIES_PER_PAGE) {
 			data->trace_tail =
@@ -2398,8 +2400,6 @@ tracing_read_pipe(struct file *filp, cha
 {
 	struct trace_iterator *iter = filp->private_data;
 	struct trace_array_cpu *data;
-	struct trace_array *tr = iter->tr;
-	struct tracer *tracer = iter->trace;
 	static cpumask_t mask;
 	static int start;
 	unsigned long flags;
@@ -2478,10 +2478,11 @@ tracing_read_pipe(struct file *filp, cha
 	if (cnt >= PAGE_SIZE)
 		cnt = PAGE_SIZE - 1;
 
-	memset(iter, 0, sizeof(*iter));
-	iter->tr = tr;
-	iter->trace = tracer;
+	/* reset all but tr, trace, and overruns */
 	iter->pos = -1;
+	memset(&iter->seq, 0,
+	       sizeof(struct trace_iterator) -
+	       offsetof(struct trace_iterator, seq));
 
 	/*
 	 * We need to stop all tracing on all CPUS to read the
@@ -2510,6 +2511,11 @@ tracing_read_pipe(struct file *filp, cha
 	for_each_cpu_mask(cpu, mask) {
 		data = iter->tr->data[cpu];
 		__raw_spin_lock(&data->lock);
+
+		if (data->overrun > iter->last_overrun[cpu])
+			iter->overrun[cpu] +=
+				data->overrun - iter->last_overrun[cpu];
+		iter->last_overrun[cpu] = data->overrun;
 	}
 
 	while (find_next_entry_inc(iter) != NULL) {
Index: linux-sched-devel.git/kernel/trace/trace.h
===================================================================
--- linux-sched-devel.git.orig/kernel/trace/trace.h	2008-04-21 13:47:30.000000000 -0400
+++ linux-sched-devel.git/kernel/trace/trace.h	2008-04-21 14:38:09.000000000 -0400
@@ -102,6 +102,7 @@ struct trace_array_cpu {
 	void			*trace_head; /* producer */
 	void			*trace_tail; /* consumer */
 	unsigned long		trace_idx;
+	unsigned long		overrun;
 	unsigned long		saved_latency;
 	unsigned long		critical_start;
 	unsigned long		critical_end;
@@ -162,10 +163,13 @@ struct trace_seq {
  * results to users and which routines might sleep, etc:
  */
 struct trace_iterator {
-	struct trace_seq	seq;
 	struct trace_array	*tr;
 	struct tracer		*trace;
+	long			last_overrun[NR_CPUS];
+	long			overrun[NR_CPUS];
 
+	/* The below is zeroed out in pipe_read */
+	struct trace_seq	seq;
 	struct trace_entry	*ent;
 	int			cpu;
 

-- 

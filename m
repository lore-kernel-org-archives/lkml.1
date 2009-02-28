Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbZB1JMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbZB1JMi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZB1JJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:09:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35865 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbZB1JJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:09:40 -0500
Message-Id: <20090228090938.051649847@goodmis.org>
References: <20090228090646.265765024@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 28 Feb 2009 04:06:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       acme@ghostprotocols.net, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 06/10] tracing: add interface to write into current tracer buffer
Content-Disposition: inline; filename=0006-tracing-add-interface-to-write-into-current-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Right now all tracers must manage their own trace buffers. This was
to enforce tracers to be independent in case we finally decide to
allow each tracer to have their own trace buffer.

But now we are adding event tracing that writes to the current tracer's
buffer. This adds an interface to allow events to write to the current
tracer buffer without having to manage its own. Since event tracing
has no "tracer", and is just a way to hook into any other tracer.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   14 ++++++++++++++
 kernel/trace/trace.h |    6 ++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9c5987a..c5e39cd 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -846,6 +846,20 @@ void trace_buffer_unlock_commit(struct trace_array *tr,
 	trace_wake_up();
 }
 
+struct ring_buffer_event *
+trace_current_buffer_lock_reserve(unsigned char type, unsigned long len,
+				  unsigned long flags, int pc)
+{
+	return trace_buffer_lock_reserve(&global_trace,
+					 type, len, flags, pc);
+}
+
+void trace_current_buffer_unlock_commit(struct ring_buffer_event *event,
+					unsigned long flags, int pc)
+{
+	return trace_buffer_unlock_commit(&global_trace, event, flags, pc);
+}
+
 void
 trace_function(struct trace_array *tr,
 	       unsigned long ip, unsigned long parent_ip, unsigned long flags,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 6321917..adf161f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -442,6 +442,12 @@ void trace_buffer_unlock_commit(struct trace_array *tr,
 				struct ring_buffer_event *event,
 				unsigned long flags, int pc);
 
+struct ring_buffer_event *
+trace_current_buffer_lock_reserve(unsigned char type, unsigned long len,
+				  unsigned long flags, int pc);
+void trace_current_buffer_unlock_commit(struct ring_buffer_event *event,
+					unsigned long flags, int pc);
+
 struct trace_entry *tracing_get_trace_entry(struct trace_array *tr,
 						struct trace_array_cpu *data);
 
-- 
1.5.6.5

-- 

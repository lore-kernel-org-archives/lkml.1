Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbZCLCki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbZCLCki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbZCLCjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:39:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43472 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbZCLCjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:39:39 -0400
Message-Id: <20090312023936.262487851@goodmis.org>
References: <20090312023720.144716747@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 11 Mar 2009 22:37:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/4] tracing: expand the ring buffers when an event is activated
Content-Disposition: inline; filename=0002-tracing-expand-the-ring-buffers-when-an-event-is-ac.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

To save memory, the tracer ring buffers are set to a minimum.
The activating of a trace expands the ring buffer size. This patch
adds this expanding, when an event is activated.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c        |   20 ++++++++++++++++++++
 kernel/trace/trace.h        |    3 +++
 kernel/trace/trace_events.c |    8 ++++++++
 3 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0c1dc18..35ee63a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2357,6 +2357,26 @@ static int tracing_resize_ring_buffer(unsigned long size)
 	return ret;
 }
 
+/**
+ * tracing_update_buffers - used by tracing facility to expand ring buffers
+ *
+ * To save on memory when the tracing is never used on a system with it
+ * configured in. The ring buffers are set to a minimum size. But once
+ * a user starts to use the tracing facility, then they need to grow
+ * to their default size.
+ *
+ * This function is to be called when a tracer is about to be used.
+ */
+int tracing_update_buffers(void)
+{
+	int ret = 0;
+
+	if (!ring_buffer_expanded)
+		ret = tracing_resize_ring_buffer(trace_buf_size);
+
+	return ret;
+}
+
 struct trace_option_dentry;
 
 static struct trace_option_dentry *
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c5e1d88..336324d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -737,6 +737,9 @@ static inline void trace_branch_disable(void)
 }
 #endif /* CONFIG_BRANCH_TRACER */
 
+/* set ring buffers to default size if not already done so */
+int tracing_update_buffers(void);
+
 /* trace event type bit fields, not numeric */
 enum {
 	TRACE_EVENT_TYPE_PRINTF		= 1,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 769dfd0..ca624df 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -141,6 +141,10 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
 	if (!cnt || cnt < 0)
 		return 0;
 
+	ret = tracing_update_buffers();
+	if (ret < 0)
+		return ret;
+
 	ret = get_user(ch, ubuf++);
 	if (ret)
 		return ret;
@@ -331,6 +335,10 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	if (ret < 0)
 		return ret;
 
+	ret = tracing_update_buffers();
+	if (ret < 0)
+		return ret;
+
 	switch (val) {
 	case 0:
 	case 1:
-- 
1.6.1.3

-- 

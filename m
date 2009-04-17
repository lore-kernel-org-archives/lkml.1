Return-Path: <linux-kernel-owner+w=401wt.eu-S1761689AbZDQOoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761689AbZDQOoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761443AbZDQOng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:43:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63520 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761007AbZDQOnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:43:33 -0400
Message-Id: <20090417144331.971635220@goodmis.org>
References: <20090417144055.857407604@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 17 Apr 2009 10:40:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 3/5] tracing/events/ring-buffer: expose format of ring buffer headers to users
Content-Disposition: inline; filename=0003-tracing-events-ring-buffer-expose-format-of-ring-bu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently, every thing needed to read the binary output from the
ring buffers is available, with the exception of the way the ring
buffers handles itself internally.

This patch creates two special files in the debugfs/tracing/events
directory:

 # cat /debug/tracing/events/header_page
        field: u64 timestamp;   offset:0;       size:8;
        field: local_t commit;  offset:8;       size:8;
        field: char data;       offset:16;      size:4080;

 # cat /debug/tracing/events/header_event
        type        :    2 bits
        len         :    3 bits
        time_delta  :   27 bits
        array       :   32 bits

        padding     : type == 0
        time_extend : type == 1
        data        : type == 3

This is to allow a userspace app to see if the ring buffer format changes
or not.

Impact: allow userspace apps to know of ringbuffer format changes
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ring_buffer.h |    5 ++++
 kernel/trace/ring_buffer.c  |   44 +++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_events.c |   38 +++++++++++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index f0aa486..fac8f1a 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -166,6 +166,11 @@ void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data);
 int ring_buffer_read_page(struct ring_buffer *buffer, void **data_page,
 			  size_t len, int cpu, int full);
 
+struct trace_seq;
+
+int ring_buffer_print_entry_header(struct trace_seq *s);
+int ring_buffer_print_page_header(struct trace_seq *s);
+
 enum ring_buffer_flags {
 	RB_FL_OVERWRITE		= 1 << 0,
 };
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f935bd5..84a6055 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -22,6 +22,28 @@
 #include "trace.h"
 
 /*
+ * The ring buffer header is special. We must manually up keep it.
+ */
+int ring_buffer_print_entry_header(struct trace_seq *s)
+{
+	int ret;
+
+	ret = trace_seq_printf(s, "\ttype        :    2 bits\n");
+	ret = trace_seq_printf(s, "\tlen         :    3 bits\n");
+	ret = trace_seq_printf(s, "\ttime_delta  :   27 bits\n");
+	ret = trace_seq_printf(s, "\tarray       :   32 bits\n");
+	ret = trace_seq_printf(s, "\n");
+	ret = trace_seq_printf(s, "\tpadding     : type == %d\n",
+			       RINGBUF_TYPE_PADDING);
+	ret = trace_seq_printf(s, "\ttime_extend : type == %d\n",
+			       RINGBUF_TYPE_TIME_EXTEND);
+	ret = trace_seq_printf(s, "\tdata        : type == %d\n",
+			       RINGBUF_TYPE_DATA);
+
+	return ret;
+}
+
+/*
  * The ring buffer is made up of a list of pages. A separate list of pages is
  * allocated for each CPU. A writer may only write to a buffer that is
  * associated with the CPU it is currently executing on.  A reader may read
@@ -340,6 +362,28 @@ static inline int test_time_stamp(u64 delta)
 
 #define BUF_PAGE_SIZE (PAGE_SIZE - BUF_PAGE_HDR_SIZE)
 
+int ring_buffer_print_page_header(struct trace_seq *s)
+{
+	struct buffer_data_page field;
+	int ret;
+
+	ret = trace_seq_printf(s, "\tfield: u64 timestamp;\t"
+			       "offset:0;\tsize:%u;\n",
+			       (unsigned int)sizeof(field.time_stamp));
+
+	ret = trace_seq_printf(s, "\tfield: local_t commit;\t"
+			       "offset:%u;\tsize:%u;\n",
+			       (unsigned int)offsetof(typeof(field), commit),
+			       (unsigned int)sizeof(field.commit));
+
+	ret = trace_seq_printf(s, "\tfield: char data;\t"
+			       "offset:%u;\tsize:%u;\n",
+			       (unsigned int)offsetof(typeof(field), data),
+			       (unsigned int)BUF_PAGE_SIZE);
+
+	return ret;
+}
+
 /*
  * head_page == tail_page && head == tail then buffer is empty.
  */
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f81d6ee..7163a2b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -610,6 +610,30 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	return cnt;
 }
 
+static ssize_t
+show_header(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
+{
+	int (*func)(struct trace_seq *s) = filp->private_data;
+	struct trace_seq *s;
+	int r;
+
+	if (*ppos)
+		return 0;
+
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	trace_seq_init(s);
+
+	func(s);
+	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
+
+	kfree(s);
+
+	return r;
+}
+
 static const struct seq_operations show_event_seq_ops = {
 	.start = t_start,
 	.next = t_next,
@@ -667,6 +691,11 @@ static const struct file_operations ftrace_subsystem_filter_fops = {
 	.write = subsystem_filter_write,
 };
 
+static const struct file_operations ftrace_show_header_fops = {
+	.open = tracing_open_generic,
+	.read = show_header,
+};
+
 static struct dentry *event_trace_events_dir(void)
 {
 	static struct dentry *d_tracer;
@@ -909,6 +938,15 @@ static __init int event_trace_init(void)
 	if (!d_events)
 		return 0;
 
+	/* ring buffer internal formats */
+	trace_create_file("header_page", 0444, d_events,
+			  ring_buffer_print_page_header,
+			  &ftrace_show_header_fops);
+
+	trace_create_file("header_event", 0444, d_events,
+			  ring_buffer_print_entry_header,
+			  &ftrace_show_header_fops);
+
 	for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
 		/* The linker may leave blanks */
 		if (!call->name)
-- 
1.6.2.1

-- 

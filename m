Return-Path: <linux-kernel-owner+w=401wt.eu-S1751396AbZH0DE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbZH0DE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 23:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZH0DEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 23:04:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53737 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbZH0DEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 23:04:24 -0400
Message-ID: <4A95F78F.8010307@cn.fujitsu.com>
Date: Thu, 27 Aug 2009 11:03:43 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] tracing: poll-able ring_buffer consumer
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


makes consumer side(per_cpu/cpu#/trace_pipe_raw) poll-able

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index b81ceed..6fd2664 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -4,6 +4,7 @@
 #include <linux/kmemcheck.h>
 #include <linux/mm.h>
 #include <linux/seq_file.h>
+#include <linux/poll.h>
 
 struct ring_buffer;
 struct ring_buffer_iter;
@@ -188,6 +189,8 @@ int ring_buffer_read_page(struct ring_buffer *buffer, void **data_page,
 void ring_buffer_notify(struct ring_buffer *buffer);
 signed long ring_buffer_wait_page(struct ring_buffer *buffer, int cpu,
 		signed long timeout);
+unsigned int ring_buffer_poll(struct ring_buffer *buffer, int cpu,
+		struct file *filp, poll_table *poll_table);
 
 struct trace_seq;
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index db82b38..c7c23da 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3389,6 +3389,22 @@ ring_buffer_wait_page(struct ring_buffer *buffer, int cpu, signed long timeout)
 			rb_page_available(cpu_buffer), timeout);
 }
 
+unsigned int ring_buffer_poll(struct ring_buffer *buffer, int cpu,
+		struct file *filp, poll_table *poll_table)
+{
+	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
+
+	if (rb_page_available(cpu_buffer))
+		return POLLIN | POLLRDNORM;
+
+	poll_wait(filp, &cpu_buffer->sleepers, poll_table);
+
+	if (rb_page_available(cpu_buffer))
+		return POLLIN | POLLRDNORM;
+
+	return 0;
+}
+
 /**
  * ring_buffer_size - return the size of the ring buffer (in bytes)
  * @buffer: The ring buffer.
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ee435ed..c2aa14c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3294,6 +3294,14 @@ static int tracing_buffers_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static
+unsigned int tracing_buffers_poll(struct file *filp, poll_table *poll_table)
+{
+	struct ftrace_buffer_info *info = filp->private_data;
+
+	return ring_buffer_poll(info->tr->buffer, info->cpu, filp, poll_table);
+}
+
 struct buffer_ref {
 	struct ring_buffer	*buffer;
 	void			*page;
@@ -3459,6 +3467,7 @@ static const struct file_operations tracing_buffers_fops = {
 	.open		= tracing_buffers_open,
 	.read		= tracing_buffers_read,
 	.release	= tracing_buffers_release,
+	.poll		= tracing_buffers_poll,
 	.splice_read	= tracing_buffers_splice_read,
 	.llseek		= no_llseek,
 };




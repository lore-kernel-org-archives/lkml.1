Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249Ab0ASHfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab0ASHfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 02:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145Ab0ASHff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 02:35:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49895 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754964Ab0ASHfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 02:35:32 -0500
Message-ID: <4B556070.6000204@cn.fujitsu.com>
Date: Tue, 19 Jan 2010 15:34:08 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/6] tracing: tracing_stats_read() uses simple buffer instead
 of trace_seq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It seems that struct trace_seq is too heavy for tracing_stats_read().
we use simple buffer instead of struct trace_seq.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 27fecf8..aa1cd92 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3807,27 +3807,22 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 {
 	unsigned long cpu = (unsigned long)filp->private_data;
 	struct trace_array *tr = &global_trace;
-	struct trace_seq *s;
 	unsigned long cnt;
 
-	s = kmalloc(sizeof(*s), GFP_KERNEL);
-	if (!s)
-		return -ENOMEM;
-
-	trace_seq_init(s);
+	unsigned char buf[128];
+	int len = 0;
 
 	cnt = ring_buffer_entries_cpu(tr->buffer, cpu);
-	trace_seq_printf(s, "entries: %ld\n", cnt);
+	len += sprintf(buf + len, "entries: %ld\n", cnt);
 
 	cnt = ring_buffer_overrun_cpu(tr->buffer, cpu);
-	trace_seq_printf(s, "overrun: %ld\n", cnt);
+	len += sprintf(buf + len, "overrun: %ld\n", cnt);
 
 	cnt = ring_buffer_commit_overrun_cpu(tr->buffer, cpu);
-	trace_seq_printf(s, "commit overrun: %ld\n", cnt);
-
-	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
+	len += sprintf(buf + len, "commit overrun: %ld\n", cnt);
 
-	kfree(s);
+	BUG_ON(len >= sizeof(buf)); /* should not happen, 128 is enough. */
+	count = simple_read_from_buffer(ubuf, count, ppos, buf, len);
 
 	return count;
 }


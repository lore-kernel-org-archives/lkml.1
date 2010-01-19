Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306Ab0ASHgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab0ASHgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 02:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164Ab0ASHf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 02:35:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49876 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754058Ab0ASHfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 02:35:25 -0500
Message-ID: <4B556069.3060200@cn.fujitsu.com>
Date: Tue, 19 Jan 2010 15:34:01 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/6] tracing: event_id_read() uses simple buffer instead of
 trace_seq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It seems that struct trace_seq is too heavy for event_id_read().
we use simple buffer instead of struct trace_seq.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 04d3f90..835b370 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -604,23 +604,16 @@ static ssize_t
 event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 {
 	struct ftrace_event_call *call = filp->private_data;
-	struct trace_seq *s;
-	int r;
+	char buf[20];
+	int len;
 
 	if (*ppos)
 		return 0;
 
-	s = kmalloc(sizeof(*s), GFP_KERNEL);
-	if (!s)
-		return -ENOMEM;
+	len = snprintf(buf, sizeof(buf), "%d\n", call->id);
+	len = simple_read_from_buffer(ubuf, cnt, ppos, buf, len);
 
-	trace_seq_init(s);
-	trace_seq_printf(s, "%d\n", call->id);
-
-	r = simple_read_from_buffer(ubuf, cnt, ppos,
-				    s->buffer, s->len);
-	kfree(s);
-	return r;
+	return len;
 }
 
 static ssize_t



Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbZCMClz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbZCMClz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758555AbZCMCif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:38:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47341 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758534AbZCMCi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:38:28 -0400
Message-Id: <20090313023825.869949732@goodmis.org>
References: <20090313023704.971438367@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 12 Mar 2009 22:37:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 05/16] tracing: show that buffer size is not expanded
Content-Disposition: inline; filename=0005-tracing-show-that-buffer-size-is-not-expanded.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: do not confuse user on small trace buffer sizes

When the system boots up, the trace buffer is small to conserve memory.
It is only two pages per online CPU. When the tracer is used, it expands
to the default value.

This can confuse the user if they look at the buffer size and see only
7, but then later they see 1408.

 # cat /debug/tracing/buffer_size_kb
7

 # echo sched_switch > /debug/tracing/current_tracer

 # cat /debug/tracing/buffer_size_kb
1408

This patch tries to help remove this confustion by showing that the
buffer has not been expanded.

 # cat /debug/tracing/buffer_size_kb
7 (expanded: 1408)

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 04ab824..62a63b2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2948,10 +2948,18 @@ tracing_entries_read(struct file *filp, char __user *ubuf,
 		     size_t cnt, loff_t *ppos)
 {
 	struct trace_array *tr = filp->private_data;
-	char buf[64];
+	char buf[96];
 	int r;
 
-	r = sprintf(buf, "%lu\n", tr->entries >> 10);
+	mutex_lock(&trace_types_lock);
+	if (!ring_buffer_expanded)
+		r = sprintf(buf, "%lu (expanded: %lu)\n",
+			    tr->entries >> 10,
+			    trace_buf_size >> 10);
+	else
+		r = sprintf(buf, "%lu\n", tr->entries >> 10);
+	mutex_unlock(&trace_types_lock);
+
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }
 
-- 
1.6.1.3

-- 

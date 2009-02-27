Return-Path: <linux-kernel-owner+w=401wt.eu-S1759140AbZB0Fgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140AbZB0Fgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 00:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbZB0Fet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 00:34:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62061 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbZB0Fep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 00:34:45 -0500
Message-Id: <20090227053442.574625047@goodmis.org>
References: <20090227053410.928389664@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 27 Feb 2009 00:34:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/5] tracing: add protection around open use of current_tracer
Content-Disposition: inline; filename=0003-tracing-add-protection-around-open-use-of-current_t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix to possible race conditions

There's some uses of current_tracer that is not protected by the
trace_types_lock. There is a small chance that a sysadmin changes
the tracer while the current_tracer is being referenced.

If the race is hit, it is unlikely to cause any harm since the
tracers are constant and are not freed. But some strang side
effects may occur.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 485c6e7..6c89ec6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2024,12 +2024,12 @@ static ssize_t
 tracing_trace_options_read(struct file *filp, char __user *ubuf,
 		       size_t cnt, loff_t *ppos)
 {
-	int i;
+	struct tracer_opt *trace_opts;
+	u32 tracer_flags;
+	int len = 0;
 	char *buf;
 	int r = 0;
-	int len = 0;
-	u32 tracer_flags = current_trace->flags->val;
-	struct tracer_opt *trace_opts = current_trace->flags->opts;
+	int i;
 
 
 	/* calculate max size */
@@ -2038,6 +2038,10 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 		len += 3; /* "no" and space */
 	}
 
+	mutex_lock(&trace_types_lock);
+	tracer_flags = current_trace->flags->val;
+	trace_opts = current_trace->flags->opts;
+
 	/*
 	 * Increase the size with names of options specific
 	 * of the current tracer.
@@ -2049,8 +2053,10 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 
 	/* +2 for \n and \0 */
 	buf = kmalloc(len + 2, GFP_KERNEL);
-	if (!buf)
+	if (!buf) {
+		mutex_unlock(&trace_types_lock);
 		return -ENOMEM;
+	}
 
 	for (i = 0; trace_options[i]; i++) {
 		if (trace_flags & (1 << i))
@@ -2067,6 +2073,7 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 			r += sprintf(buf + r, "no%s ",
 				trace_opts[i].name);
 	}
+	mutex_unlock(&trace_types_lock);
 
 	r += sprintf(buf + r, "\n");
 	WARN_ON(r >= len + 2);
@@ -2074,7 +2081,6 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 	r = simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 
 	kfree(buf);
-
 	return r;
 }
 
@@ -2149,7 +2155,9 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 
 	/* If no option could be set, test the specific tracer options */
 	if (!trace_options[i]) {
+		mutex_lock(&trace_types_lock);
 		ret = set_tracer_option(current_trace, cmp, neg);
+		mutex_unlock(&trace_types_lock);
 		if (ret)
 			return ret;
 	}
-- 
1.5.6.5

-- 

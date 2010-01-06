Return-Path: <linux-kernel-owner+w=401wt.eu-S933050Ab0AFXRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab0AFXRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027Ab0AFXRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:17:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56858 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427Ab0AFXPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:15:35 -0500
X-Authority-Analysis: v=1.0 c=1 a=pagEfGQZKeYA:10 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8 a=meVymXHHAAAA:8 a=iGUtEG0860uKFPI71McA:9 a=zFrRS2UJKO3ZQ8L9SGeZg__Pxq0A:4 a=jEp0ucaQiEUA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100106231534.208802835@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jan 2010 18:14:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 11/11] tracing: Add stack dump to trace_printk if stacktrace option is set
References: <20100106231349.107649729@goodmis.org>
Content-Disposition: inline; filename=0011-tracing-Add-stack-dump-to-trace_printk-if-stacktrace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If the ftrace stacktrace option is set, then add the stack dumps to
trace_printk.

Requested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index abdd333..5314c90 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1392,8 +1392,10 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 	entry->fmt			= fmt;
 
 	memcpy(entry->buf, trace_buf, sizeof(u32) * len);
-	if (!filter_check_discard(call, entry, buffer, event))
+	if (!filter_check_discard(call, entry, buffer, event)) {
 		ring_buffer_unlock_commit(buffer, event);
+		ftrace_trace_stack(buffer, flags, 6, pc);
+	}
 
 out_unlock:
 	arch_spin_unlock(&trace_buf_lock);
@@ -1466,8 +1468,10 @@ int trace_array_vprintk(struct trace_array *tr,
 
 	memcpy(&entry->buf, trace_buf, len);
 	entry->buf[len] = '\0';
-	if (!filter_check_discard(call, entry, buffer, event))
+	if (!filter_check_discard(call, entry, buffer, event)) {
 		ring_buffer_unlock_commit(buffer, event);
+		ftrace_trace_stack(buffer, irq_flags, 6, pc);
+	}
 
  out_unlock:
 	arch_spin_unlock(&trace_buf_lock);
-- 
1.6.5



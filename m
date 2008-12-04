Return-Path: <linux-kernel-owner+w=401wt.eu-S1759441AbYLDWru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbYLDWru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 17:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757524AbYLDWrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 17:47:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:39777 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342AbYLDWrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 17:47:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ocY2gPc3V+LAAFKoD1sndgPHSsS+PdWi7X6R89zgR4x8BIZXWTBnsRoNNS4TEWT2aE
         ThOLvHyPch6hw39heXzRAQtImfnqifYwxxOweCrZCUS+07M92euGk3HZYIdD80Ab87wk
         IRi8Xmeh1qS7y2qIbmkE44Hnsj3RybYJ+YNps=
Message-ID: <49385E07.7050304@gmail.com>
Date: Thu, 04 Dec 2008 23:47:35 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] tracing/ftrace: don't insert TRACE_PRINT during selftests
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix tracer selfstests false results

After setting a ftrace_printk somewhere in th kernel, I saw the
Function tracer selftest failing.

When a selftest occurs, the ring buffer is lurked to see if
some entries were inserted. But concurrent insertion such as
ftrace_printk could occured at the same time and could give
false positive or negative results.

This patch prevent prevent from TRACE_PRINT entries insertion
during selftests.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ea38652..5dca6ef 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -44,6 +44,14 @@
 unsigned long __read_mostly	tracing_max_latency = (cycle_t)ULONG_MAX;
 unsigned long __read_mostly	tracing_thresh;
 
+/* We need to change this state when a selftest is running.
+ * A selftest will lurk into the ring-buffer to count the
+ * entries inserted during the selftest although some concurrent
+ * insertions into the ring-buffer such as ftrace_printk could occurred
+ * at the same time, giving false positive or negative results.
+ */
+static atomic_t tracing_selftest_running = ATOMIC_INIT(0);
+
 /* For tracers that don't implement custom flags */
 static struct tracer_opt dummy_tracer_opt[] = {
 	{ }
@@ -589,6 +597,8 @@ int register_tracer(struct tracer *type)
 		struct tracer *saved_tracer = current_trace;
 		struct trace_array *tr = &global_trace;
 		int i;
+
+		atomic_set(&tracing_selftest_running, 1);
 		/*
 		 * Run a selftest on this tracer.
 		 * Here we reset the trace buffer, and set the current
@@ -603,6 +613,7 @@ int register_tracer(struct tracer *type)
 		/* the test is responsible for initializing and enabling */
 		pr_info("Testing tracer %s: ", type->name);
 		ret = type->selftest(type, tr);
+		atomic_set(&tracing_selftest_running, 0);
 		/* the test is responsible for resetting too */
 		current_trace = saved_tracer;
 		if (ret) {
@@ -3594,7 +3605,7 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
 	unsigned long flags, irq_flags;
 	int cpu, len = 0, size, pc;
 
-	if (tracing_disabled)
+	if (tracing_disabled || atomic_read(&tracing_selftest_running))
 		return 0;
 
 	pc = preempt_count();
-- 
1.5.6.3


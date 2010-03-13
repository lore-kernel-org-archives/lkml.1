Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab0CMC7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 21:59:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42385 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757806Ab0CMC65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 21:58:57 -0500
X-Authority-Analysis: v=1.0 c=1 a=X2CRS_YvNPgA:10 a=GzHTLUccyWwA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=MeR8Nho3YvcMjC9bkv8A:9 a=qbGv0Q4E2z_XmG4gKR8A:7 a=cWzmtdUlVHdwmH1-eDxTVx4g4dUA:4 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100313025854.864204406@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 12 Mar 2010 21:56:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       stable@kernel.org
Subject: [PATCH 3/5] tracing: Use same local variable when resetting the ring buffer
References: <20100313025655.104950166@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Use-same-local-variable-when-resetting-the-r.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

In the ftrace code that resets the ring buffer it references the
buffer with a local variable, but then uses the tr->buffer as the
parameter to reset. If the wakeup tracer is running, which can
switch the tr->buffer with the max saved buffer, this can break
the requirement of disabling the buffer before the reset.

   buffer = tr->buffer;
   ring_buffer_record_disable(buffer);
   synchronize_sched();
   __tracing_reset(tr->buffer, cpu);

If the tr->buffer is swapped, then the reset is not happening to the
buffer that was disabled. This will cause the ring buffer to fail.

Found with Li Zefan's ftrace_stress_test.

Cc: stable@kernel.org
Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 6af8d7b..60de37b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -840,10 +840,10 @@ out:
 	mutex_unlock(&trace_types_lock);
 }
 
-static void __tracing_reset(struct trace_array *tr, int cpu)
+static void __tracing_reset(struct ring_buffer *buffer, int cpu)
 {
 	ftrace_disable_cpu();
-	ring_buffer_reset_cpu(tr->buffer, cpu);
+	ring_buffer_reset_cpu(buffer, cpu);
 	ftrace_enable_cpu();
 }
 
@@ -855,7 +855,7 @@ void tracing_reset(struct trace_array *tr, int cpu)
 
 	/* Make sure all commits have finished */
 	synchronize_sched();
-	__tracing_reset(tr, cpu);
+	__tracing_reset(buffer, cpu);
 
 	ring_buffer_record_enable(buffer);
 }
@@ -873,7 +873,7 @@ void tracing_reset_online_cpus(struct trace_array *tr)
 	tr->time_start = ftrace_now(tr->cpu);
 
 	for_each_online_cpu(cpu)
-		__tracing_reset(tr, cpu);
+		__tracing_reset(buffer, cpu);
 
 	ring_buffer_record_enable(buffer);
 }
-- 
1.7.0



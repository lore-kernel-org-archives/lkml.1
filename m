Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301Ab0CMC7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 21:59:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55803 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757618Ab0CMC64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 21:58:56 -0500
X-Authority-Analysis: v=1.0 c=1 a=USWR6xBEGuEA:10 a=GzHTLUccyWwA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=9X6E_MLSBJWOj1PnchoA:9 a=XbreW_3z-Q3QyZayZzkA:7 a=cntDT9y5ROabZjsCASrtq0z-cTIA:4 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100313025855.199922564@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 12 Mar 2010 21:56:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       stable@kernel.org
Subject: [PATCH 4/5] tracing: Disable buffer switching when starting or stopping trace
References: <20100313025655.104950166@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Disable-buffer-switching-when-starting-or-st.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When the trace iterator is read, tracing_start() and tracing_stop()
is called to stop tracing while the iterator is processing the trace
output.

These functions disable both the standard buffer and the max latency
buffer. But if the wakeup tracer is running, it can switch these
buffers between the two disables:

  buffer = global_trace.buffer;
  if (buffer)
      ring_buffer_record_disable(buffer);

      <<<--------- swap happens here

  buffer = max_tr.buffer;
  if (buffer)
      ring_buffer_record_disable(buffer);

What happens is that we disabled the same buffer twice. On tracing_start()
we can enable the same buffer twice. All ring_buffer_record_disable()
must be matched with a ring_buffer_record_enable() or the buffer
can be disable permanently, or enable prematurely, and cause a bug
where a reset happens while a trace is commiting.

This patch protects these two by taking the ftrace_max_lock to prevent
a switch from occurring.

Found with Li Zefan's ftrace_stress_test.

Cc: stable@kernel.org
Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 60de37b..484337d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -950,6 +950,8 @@ void tracing_start(void)
 		goto out;
 	}
 
+	/* Prevent the buffers from switching */
+	arch_spin_lock(&ftrace_max_lock);
 
 	buffer = global_trace.buffer;
 	if (buffer)
@@ -959,6 +961,8 @@ void tracing_start(void)
 	if (buffer)
 		ring_buffer_record_enable(buffer);
 
+	arch_spin_unlock(&ftrace_max_lock);
+
 	ftrace_start();
  out:
 	spin_unlock_irqrestore(&tracing_start_lock, flags);
@@ -980,6 +984,9 @@ void tracing_stop(void)
 	if (trace_stop_count++)
 		goto out;
 
+	/* Prevent the buffers from switching */
+	arch_spin_lock(&ftrace_max_lock);
+
 	buffer = global_trace.buffer;
 	if (buffer)
 		ring_buffer_record_disable(buffer);
@@ -988,6 +995,8 @@ void tracing_stop(void)
 	if (buffer)
 		ring_buffer_record_disable(buffer);
 
+	arch_spin_unlock(&ftrace_max_lock);
+
  out:
 	spin_unlock_irqrestore(&tracing_start_lock, flags);
 }
-- 
1.7.0



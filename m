Return-Path: <linux-kernel-owner+w=401wt.eu-S934310AbZIEADX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310AbZIEADX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934167AbZIEADV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:03:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62255 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934137AbZIEABX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:01:23 -0400
Message-Id: <20090905000124.669570623@goodmis.org>
References: <20090904235527.520961911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 Sep 2009 19:55:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/18] tracing: disable buffers and synchronize_sched before resetting
Content-Disposition: inline; filename=0010-tracing-disable-buffers-and-synchronize_sched-before.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Resetting the ring buffers while traces are happening can corrupt
the ring buffer and disable it (no kernel crash to worry about).

The safest thing to do is disable the ring buffers, call synchronize_sched()
to wait for all current writers to finish and then reset the buffer.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e521f1e..9110329 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -658,12 +658,20 @@ void tracing_reset(struct trace_array *tr, int cpu)
 
 void tracing_reset_online_cpus(struct trace_array *tr)
 {
+	struct ring_buffer *buffer = tr->buffer;
 	int cpu;
 
+	ring_buffer_record_disable(buffer);
+
+	/* Make sure all commits have finished */
+	synchronize_sched();
+
 	tr->time_start = ftrace_now(tr->cpu);
 
 	for_each_online_cpu(cpu)
 		tracing_reset(tr, cpu);
+
+	ring_buffer_record_enable(buffer);
 }
 
 void tracing_reset_current(int cpu)
-- 
1.6.3.3

-- 

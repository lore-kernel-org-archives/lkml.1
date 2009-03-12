Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbZCLCkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbZCLCkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbZCLCjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:39:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35316 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZCLCjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:39:39 -0400
Message-Id: <20090312023936.459886746@goodmis.org>
References: <20090312023720.144716747@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 11 Mar 2009 22:37:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/4] tracing: fix trace_wait to know to wait on all cpus or just one
Content-Disposition: inline; filename=0003-tracing-fix-trace_wait-to-know-to-wait-on-all-cpus.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix to task live locking on reading trace_pipe on one CPU

The same code is used for both trace_pipe (all CPUS) and the per_cpu
trace_pipe file. When there is no data to read, it will check for
signals and wait on the trace wait queue.

The problem happens with the per_cpu wait. The trace_wait code checks
all CPUs. Thus, if there's data in another CPU buffer, then it will
exit the wait, without checking for signals or waiting on the wait queue.

It would then try to read the empty buffer, and since that will just
return nothing, then it will try to wait again. Unfortunately, that will
again fail due to there still being data in the other buffers. This
ends up with a live lock for the task.

This patch fixes the trace_wait to be aware that the iterator may only
be waiting on a single buffer.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 35ee63a..e60f4be 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1666,6 +1666,19 @@ static int trace_empty(struct trace_iterator *iter)
 {
 	int cpu;
 
+	/* If we are looking at one CPU buffer, only check that one */
+	if (iter->cpu_file != TRACE_PIPE_ALL_CPU) {
+		cpu = iter->cpu_file;
+		if (iter->buffer_iter[cpu]) {
+			if (!ring_buffer_iter_empty(iter->buffer_iter[cpu]))
+				return 0;
+		} else {
+			if (!ring_buffer_empty_cpu(iter->tr->buffer, cpu))
+				return 0;
+		}
+		return 1;
+	}
+
 	for_each_tracing_cpu(cpu) {
 		if (iter->buffer_iter[cpu]) {
 			if (!ring_buffer_iter_empty(iter->buffer_iter[cpu]))
-- 
1.6.1.3

-- 

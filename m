Return-Path: <linux-kernel-owner+w=401wt.eu-S1764118AbZAIA3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764118AbZAIA3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 19:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757689AbZAIA2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 19:28:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60353 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841AbZAIA2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 19:28:42 -0500
Message-Id: <20090109002840.800960698@goodmis.org>
References: <20090109002747.240318148@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 08 Jan 2009 19:27:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/3] mmiotrace: count events lost due to not recording
Content-Disposition: inline; filename=0003-mmiotrace-count-events-lost-due-to-not-recording.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Paalanen <pq@iki.fi>

Impact: enhances lost events counting in mmiotrace

The tracing framework, or the ring buffer facility it uses, has a switch
to stop recording data. When recording is off, the trace events will be
lost. The framework does not count these, so mmiotrace has to count them
itself.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_mmiotrace.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index fcec59f..621c8c3 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/mmiotrace.h>
 #include <linux/pci.h>
+#include <asm/atomic.h>
 
 #include "trace.h"
 #include "trace_output.h"
@@ -20,6 +21,7 @@ struct header_iter {
 static struct trace_array *mmio_trace_array;
 static bool overrun_detected;
 static unsigned long prev_overruns;
+static atomic_t dropped_count;
 
 static void mmio_reset_data(struct trace_array *tr)
 {
@@ -122,11 +124,11 @@ static void mmio_close(struct trace_iterator *iter)
 
 static unsigned long count_overruns(struct trace_iterator *iter)
 {
-	unsigned long cnt = 0;
+	unsigned long cnt = atomic_xchg(&dropped_count, 0);
 	unsigned long over = ring_buffer_overruns(iter->tr->buffer);
 
 	if (over > prev_overruns)
-		cnt = over - prev_overruns;
+		cnt += over - prev_overruns;
 	prev_overruns = over;
 	return cnt;
 }
@@ -308,8 +310,10 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 
 	event	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
 					   &irq_flags);
-	if (!event)
+	if (!event) {
+		atomic_inc(&dropped_count);
 		return;
+	}
 	entry	= ring_buffer_event_data(event);
 	tracing_generic_entry_update(&entry->ent, 0, preempt_count());
 	entry->ent.type			= TRACE_MMIO_RW;
@@ -336,8 +340,10 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
 
 	event	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
 					   &irq_flags);
-	if (!event)
+	if (!event) {
+		atomic_inc(&dropped_count);
 		return;
+	}
 	entry	= ring_buffer_event_data(event);
 	tracing_generic_entry_update(&entry->ent, 0, preempt_count());
 	entry->ent.type			= TRACE_MMIO_MAP;
-- 
1.5.6.5

-- 

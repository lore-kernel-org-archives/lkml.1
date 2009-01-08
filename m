Return-Path: <linux-kernel-owner+w=401wt.eu-S1763173AbZAHWR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763173AbZAHWR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbZAHWRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:17:18 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:36557 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZAHWRR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:17:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=XtOPGLSXnf37nH9n9KmKERZpt8+3fLoQ8g3DxtwSvB3wUK/OfMTmF1QKGhbK6ZEmP+
         SlkltC8CrQTx2EBeXn8IYMndinXSRNxYiOvh/RsE6imC3ValaCeURPbHzM2abZREOvKB
         FNf/GyT58SYB0dVnWuubgZ0blkyNtUSV+ZOro=
Date: Fri, 9 Jan 2009 00:17:10 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, pq@iki.fi
Subject: [PATCH v2 3/3] mmiotrace: count events lost due to not recording
Message-ID: <20090109001710.6930a2d3@daedalus.pq.iki.fi>
In-Reply-To: <alpine.DEB.1.10.0901081538080.28112@gandalf.stny.rr.com>
References: <20090108223255.6f29f1cf@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0901081538080.28112@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7b1371189e38609f74c68a7b83c0a7a038a9b712 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Tue, 6 Jan 2009 13:57:11 +0200
Subject: [PATCH] mmiotrace: count events lost due to not recording

Impact: enhances lost events counting in mmiotrace

The tracing framework, or the ring buffer facility it uses, has a switch
to stop recording data. When recording is off, the trace events will be
lost. The framework does not count these, so mmiotrace has to count them
itself.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
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
1.6.0.6


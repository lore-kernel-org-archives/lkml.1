Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbZELELe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbZELELe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 00:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZELELC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 00:11:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42525 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbZELEK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 00:10:59 -0400
Message-Id: <20090512041059.168923989@goodmis.org>
References: <20090512040832.681953177@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 12 May 2009 00:08:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/5] ring-buffer: move calculation of event length
Content-Disposition: inline; filename=0002-ring-buffer-move-calculation-of-event-length.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The event length is calculated and passed in to rb_reserve_next_event
in two different locations. Having rb_reserve_next_event do the
calculations directly makes only one location to do the change and
causes the calculation to be inlined by gcc.

Before:
   text    data     bss     dec     hex filename
  16538      24      12   16574    40be kernel/trace/ring_buffer.o

After:
   text    data     bss     dec     hex filename
  16490      24      12   16526    408e kernel/trace/ring_buffer.o

[ Impact: smaller more efficient code ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index fe40f6c..493cba4 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -367,6 +367,9 @@ static inline int test_time_stamp(u64 delta)
 
 #define BUF_PAGE_SIZE (PAGE_SIZE - BUF_PAGE_HDR_SIZE)
 
+/* Max payload is BUF_PAGE_SIZE - header (8bytes) */
+#define BUF_MAX_DATA_SIZE (BUF_PAGE_SIZE - (sizeof(u32) * 2))
+
 int ring_buffer_print_page_header(struct trace_seq *s)
 {
 	struct buffer_data_page field;
@@ -1396,6 +1399,7 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	int commit = 0;
 	int nr_loops = 0;
 
+	length = rb_calculate_event_length(length);
  again:
 	/*
 	 * We allow for interrupts to reenter here and do a trace.
@@ -1552,8 +1556,7 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
 	if (atomic_read(&cpu_buffer->record_disabled))
 		goto out;
 
-	length = rb_calculate_event_length(length);
-	if (length > BUF_PAGE_SIZE)
+	if (length > BUF_MAX_DATA_SIZE)
 		goto out;
 
 	event = rb_reserve_next_event(cpu_buffer, length);
@@ -1758,7 +1761,6 @@ int ring_buffer_write(struct ring_buffer *buffer,
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
-	unsigned long event_length;
 	void *body;
 	int ret = -EBUSY;
 	int cpu, resched;
@@ -1781,8 +1783,10 @@ int ring_buffer_write(struct ring_buffer *buffer,
 	if (atomic_read(&cpu_buffer->record_disabled))
 		goto out;
 
-	event_length = rb_calculate_event_length(length);
-	event = rb_reserve_next_event(cpu_buffer, event_length);
+	if (length > BUF_MAX_DATA_SIZE)
+		goto out;
+
+	event = rb_reserve_next_event(cpu_buffer, length);
 	if (!event)
 		goto out;
 
-- 
1.6.2.4

-- 

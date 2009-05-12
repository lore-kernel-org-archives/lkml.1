Return-Path: <linux-kernel-owner+w=401wt.eu-S1752738AbZELELU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbZELELU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 00:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbZELELA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 00:11:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42518 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbZELEK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 00:10:59 -0400
Message-Id: <20090512041058.932896238@goodmis.org>
References: <20090512040832.681953177@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 12 May 2009 00:08:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/5] ring-buffer: remove type parameter from rb_reserve_next_event
Content-Disposition: inline; filename=0001-ring-buffer-remove-type-parameter-from-rb_reserve_n.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The rb_reserve_next_event is only called for the data type (type = 0).
There is no reason to pass in the type to the function.

Before:
   text    data     bss     dec     hex filename
  16554      24      12   16590    40ce kernel/trace/ring_buffer.o

After:
   text    data     bss     dec     hex filename
  16538      24      12   16574    40be kernel/trace/ring_buffer.o

[ Impact: cleaner, smaller and slightly more efficient code ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 3611706..fe40f6c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1389,7 +1389,7 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 
 static struct ring_buffer_event *
 rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
-		      unsigned type, unsigned long length)
+		      unsigned long length)
 {
 	struct ring_buffer_event *event;
 	u64 ts, delta;
@@ -1448,7 +1448,7 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 		/* Non commits have zero deltas */
 		delta = 0;
 
-	event = __rb_reserve_next(cpu_buffer, type, length, &ts);
+	event = __rb_reserve_next(cpu_buffer, 0, length, &ts);
 	if (PTR_ERR(event) == -EAGAIN)
 		goto again;
 
@@ -1556,7 +1556,7 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
 	if (length > BUF_PAGE_SIZE)
 		goto out;
 
-	event = rb_reserve_next_event(cpu_buffer, 0, length);
+	event = rb_reserve_next_event(cpu_buffer, length);
 	if (!event)
 		goto out;
 
@@ -1782,7 +1782,7 @@ int ring_buffer_write(struct ring_buffer *buffer,
 		goto out;
 
 	event_length = rb_calculate_event_length(length);
-	event = rb_reserve_next_event(cpu_buffer, 0, event_length);
+	event = rb_reserve_next_event(cpu_buffer, event_length);
 	if (!event)
 		goto out;
 
-- 
1.6.2.4

-- 

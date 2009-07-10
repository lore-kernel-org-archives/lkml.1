Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZGJHxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZGJHxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 03:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbZGJHxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 03:53:41 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44680 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbZGJHxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 03:53:41 -0400
Date: Fri, 10 Jul 2009 09:53:40 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: lizf@cn.fujitsu.com, Alan.Brunelle@hp.com, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Fix blktrace unaligned memory access
Message-ID: <20090710075339.GX23611@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It seems that relay_reserve() (or the ring_buffer_event_data(), that one
still needs some love) can return unaligned memory, there's no way
around that when you have pdu lengths that aren't a nice size. This can
cause unaligned access warnings on platforms that care about alignment.

This is an RFC, perhaps we can fix this in some other way. This one takes
the simple approach, use an on-stack copy and memcpy() that to the
destination.

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 39af8af..9aba4ec 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -62,7 +62,7 @@ static void blk_unregister_tracepoints(void);
 static void trace_note(struct blk_trace *bt, pid_t pid, int action,
 		       const void *data, size_t len)
 {
-	struct blk_io_trace *t;
+	struct blk_io_trace *ptr, __t, *t = &__t;
 	struct ring_buffer_event *event = NULL;
 	int pc = 0;
 	int cpu = smp_processor_id();
@@ -75,15 +75,15 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
 						  0, pc);
 		if (!event)
 			return;
-		t = ring_buffer_event_data(event);
+		ptr = t = ring_buffer_event_data(event);
 		goto record_it;
 	}
 
 	if (!bt->rchan)
 		return;
 
-	t = relay_reserve(bt->rchan, sizeof(*t) + len);
-	if (t) {
+	ptr = relay_reserve(bt->rchan, sizeof(*t) + len);
+	if (ptr) {
 		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
 		t->time = ktime_to_ns(ktime_get());
 record_it:
@@ -92,7 +92,9 @@ record_it:
 		t->pid = pid;
 		t->cpu = cpu;
 		t->pdu_len = len;
-		memcpy((void *) t + sizeof(*t), data, len);
+		if (t == &__t)
+			memcpy(ptr, t, sizeof(*t));
+		memcpy((void *) ptr + sizeof(*ptr), data, len);
 
 		if (blk_tracer)
 			trace_buffer_unlock_commit(blk_tr, event, 0, pc);
@@ -178,7 +180,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 {
 	struct task_struct *tsk = current;
 	struct ring_buffer_event *event = NULL;
-	struct blk_io_trace *t;
+	struct blk_io_trace *ptr, __t, *t = &__t;
 	unsigned long flags = 0;
 	unsigned long *sequence;
 	pid_t pid;
@@ -209,7 +211,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 						  0, pc);
 		if (!event)
 			return;
-		t = ring_buffer_event_data(event);
+		ptr = t = ring_buffer_event_data(event);
 		goto record_it;
 	}
 
@@ -223,8 +225,8 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	if (unlikely(tsk->btrace_seq != blktrace_seq))
 		trace_note_tsk(bt, tsk);
 
-	t = relay_reserve(bt->rchan, sizeof(*t) + pdu_len);
-	if (t) {
+	ptr = relay_reserve(bt->rchan, sizeof(*ptr) + pdu_len);
+	if (ptr) {
 		sequence = per_cpu_ptr(bt->sequence, cpu);
 
 		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
@@ -247,8 +249,10 @@ record_it:
 		t->error = error;
 		t->pdu_len = pdu_len;
 
+		if (t == &__t)
+			memcpy(ptr, t, sizeof(*t));
 		if (pdu_len)
-			memcpy((void *) t + sizeof(*t), pdu_data, pdu_len);
+			memcpy((void *) ptr + sizeof(*ptr), pdu_data, pdu_len);
 
 		if (blk_tracer) {
 			trace_buffer_unlock_commit(blk_tr, event, 0, pc);

-- 
Jens Axboe


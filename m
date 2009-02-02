Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbZBBWbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbZBBWbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZBBWbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:31:01 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38869 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbZBBWbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:31:00 -0500
Date: Mon, 2 Feb 2009 20:30:40 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 3/3] blkftrace: binary tracing, synthesizing old format
Message-ID: <20090202223040.GD12082@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: new feature

With this and a blkrawverify modified not to verify the sequence numbers
we can start using the userspace tools to verify that the data produced
with the ftrace plugin works as expected.

Example:

[root@f10-1 ~]# echo 1 > /sys/block/sda/sda1/trace/enable
[root@f10-1 ~]# echo bin > /d/tracing/trace_options
[root@f10-1 ~]# echo blk > /d/tracing/current_tracer
[root@f10-1 ~]# cat /d/tracing/trace_pipe > sda1.blktrace.0
^C
[root@f10-1 ~]# ./blkrawverify --noseq sda1
Verifying sda1
    CPU 0
Wrote output to sda1.verify.out
[root@f10-1 ~]# cat sda1.verify.out

---------------
Verifying sda1
    ---------------------
    Summary for cpu 0:
          1349 valid +          0 invalid (100.0%) processed

[root@f10-1 ~]#

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 block/blktrace.c |   40 +++++++++++++++++++++++++++++++++++++---
 1 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/block/blktrace.c b/block/blktrace.c
index 570cd3c..4f45b34 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -219,9 +219,16 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
 		t->sequence = ++(*sequence);
 		t->time = ktime_to_ns(ktime_get());
-		t->cpu = cpu;
-		t->pid = pid;
 record_it:
+		/*
+ 		 * These two are not needed in ftrace as they are in the
+ 		 * generic trace_entry, filled by tracing_generic_entry_update,
+ 		 * but for the trace_event->bin() synthesizer benefit we do it
+ 		 * here too.
+ 		 */
+ 		t->cpu = cpu;
+ 		t->pid = pid;
+
 		t->sector = sector;
 		t->bytes = bytes;
 		t->action = what;
@@ -1086,6 +1093,7 @@ static void blk_tracer_start(struct trace_array *tr)
 		if (blk_register_tracepoints())
 			atomic_dec(&blk_probes_ref);
 	mutex_unlock(&blk_probe_mutex);
+	trace_flags &= ~TRACE_ITER_CONTEXT_INFO;
 }
 
 static int blk_tracer_init(struct trace_array *tr)
@@ -1100,6 +1108,7 @@ static int blk_tracer_init(struct trace_array *tr)
 
 static void blk_tracer_stop(struct trace_array *tr)
 {
+	trace_flags |= TRACE_ITER_CONTEXT_INFO;
 	mutex_lock(&blk_probe_mutex);
 	if (atomic_dec_and_test(&blk_probes_ref))
 		blk_unregister_tracepoints();
@@ -1147,6 +1156,9 @@ static int blk_trace_event_print(struct trace_iterator *iter, int flags)
 	const u16 what = t->action & ((1 << BLK_TC_SHIFT) - 1);
 	int ret;
 
+	if (trace_print_context(iter))
+		return TRACE_TYPE_PARTIAL_LINE;
+
 	if (unlikely(what == 0 || what > ARRAY_SIZE(what2act)))
 		ret = trace_seq_printf(s, "Bad pc action %x\n", what);
 	else {
@@ -1159,6 +1171,28 @@ static int blk_trace_event_print(struct trace_iterator *iter, int flags)
 	return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
 }
 
+static int blk_trace_synthesize_old_trace(struct trace_iterator *iter)
+{
+	struct trace_seq *s = &iter->seq;
+	struct blk_io_trace *t = (struct blk_io_trace *)iter->ent;
+	const int offset = offsetof(struct blk_io_trace, sector);
+	struct blk_io_trace old = {
+		.magic	  = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION,
+		.time     = ns2usecs(iter->ts),
+	};
+
+	if (!trace_seq_putmem(s, &old, offset))
+		return 0;
+	return trace_seq_putmem(s, &t->sector,
+				sizeof(old) - offset + t->pdu_len);
+}
+
+static int blk_trace_event_print_binary(struct trace_iterator *iter, int flags)
+{
+	return blk_trace_synthesize_old_trace(iter) ?
+			TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
+}
+
 static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
 {
 	const struct blk_io_trace *t;
@@ -1200,7 +1234,7 @@ static struct trace_event trace_blk_event = {
 	.latency_trace	= blk_trace_event_print,
 	.raw		= trace_nop_print,
 	.hex		= trace_nop_print,
-	.binary		= trace_nop_print,
+	.binary		= blk_trace_event_print_binary,
 };
 
 static int __init init_blk_tracer(void)
-- 
1.6.0.6


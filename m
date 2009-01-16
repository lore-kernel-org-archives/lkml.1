Return-Path: <linux-kernel-owner+w=401wt.eu-S1762272AbZAPEyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762272AbZAPEyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 23:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756354AbZAPEyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 23:54:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64100 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbZAPEyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 23:54:20 -0500
Message-Id: <20090116045418.027910238@goodmis.org>
References: <20090116045342.748642160@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 15 Jan 2009 23:53:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/6] trace: clean up format errors in calls to trace_seq_printf
Content-Disposition: inline; filename=0003-trace-clean-up-format-errors-in-calls-to-trace_seq_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

After adding the printf format checking for trace_seq_printf, several
warnings now show up. This patch cleans them up.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/kmemtrace.c       |    4 ++--
 kernel/trace/trace_mmiotrace.c |   13 +++++++------
 kernel/trace/trace_output.c    |    2 +-
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index faaa5ae..7ebc58c 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -139,12 +139,12 @@ kmemtrace_print_alloc_compress(struct trace_iterator *iter,
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Requested */
-	ret = trace_seq_printf(s, "%4d   ", entry->bytes_req);
+	ret = trace_seq_printf(s, "%4ld   ", entry->bytes_req);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Allocated */
-	ret = trace_seq_printf(s, "%4d   ", entry->bytes_alloc);
+	ret = trace_seq_printf(s, "%4ld   ", entry->bytes_alloc);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 621c8c3..ec78e24 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -184,21 +184,22 @@ static enum print_line_t mmio_print_rw(struct trace_iterator *iter)
 	switch (rw->opcode) {
 	case MMIO_READ:
 		ret = trace_seq_printf(s,
-			"R %d %lu.%06lu %d 0x%llx 0x%lx 0x%lx %d\n",
+			"R %d %u.%06lu %d 0x%llx 0x%lx 0x%lx %d\n",
 			rw->width, secs, usec_rem, rw->map_id,
 			(unsigned long long)rw->phys,
 			rw->value, rw->pc, 0);
 		break;
 	case MMIO_WRITE:
 		ret = trace_seq_printf(s,
-			"W %d %lu.%06lu %d 0x%llx 0x%lx 0x%lx %d\n",
+			"W %d %u.%06lu %d 0x%llx 0x%lx 0x%lx %d\n",
 			rw->width, secs, usec_rem, rw->map_id,
 			(unsigned long long)rw->phys,
 			rw->value, rw->pc, 0);
 		break;
 	case MMIO_UNKNOWN_OP:
 		ret = trace_seq_printf(s,
-			"UNKNOWN %lu.%06lu %d 0x%llx %02x,%02x,%02x 0x%lx %d\n",
+			"UNKNOWN %u.%06lu %d 0x%llx %02lx,%02lx,"
+			"%02lx 0x%lx %d\n",
 			secs, usec_rem, rw->map_id,
 			(unsigned long long)rw->phys,
 			(rw->value >> 16) & 0xff, (rw->value >> 8) & 0xff,
@@ -230,14 +231,14 @@ static enum print_line_t mmio_print_map(struct trace_iterator *iter)
 	switch (m->opcode) {
 	case MMIO_PROBE:
 		ret = trace_seq_printf(s,
-			"MAP %lu.%06lu %d 0x%llx 0x%lx 0x%lx 0x%lx %d\n",
+			"MAP %u.%06lu %d 0x%llx 0x%lx 0x%lx 0x%lx %d\n",
 			secs, usec_rem, m->map_id,
 			(unsigned long long)m->phys, m->virt, m->len,
 			0UL, 0);
 		break;
 	case MMIO_UNPROBE:
 		ret = trace_seq_printf(s,
-			"UNMAP %lu.%06lu %d 0x%lx %d\n",
+			"UNMAP %u.%06lu %d 0x%lx %d\n",
 			secs, usec_rem, m->map_id, 0UL, 0);
 		break;
 	default:
@@ -261,7 +262,7 @@ static enum print_line_t mmio_print_mark(struct trace_iterator *iter)
 	int ret;
 
 	/* The trailing newline must be in the message. */
-	ret = trace_seq_printf(s, "MARK %lu.%06lu %s", secs, usec_rem, msg);
+	ret = trace_seq_printf(s, "MARK %u.%06lu %s", secs, usec_rem, msg);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 4e3ad36..1a4e144 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -440,7 +440,7 @@ trace_fn_raw(struct trace_seq *s, struct trace_entry *entry, int flags)
 
 	trace_assign_type(field, entry);
 
-	if (!trace_seq_printf(s, "%x %x\n",
+	if (!trace_seq_printf(s, "%lx %lx\n",
 			      field->ip,
 			      field->parent_ip))
 		return TRACE_TYPE_PARTIAL_LINE;
-- 
1.5.6.5

-- 

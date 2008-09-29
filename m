Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbYI2S16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbYI2S16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYI2S1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:27:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:40921 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbYI2S1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:27:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=VvBoLwsYL2dMZTNi+2qKfJ0fVyIi1giw2nCWgsxV1orCvYDLPpKVyKWj+vvTmULouf
         jin/lRIA8eNjVaWiAM3V+cYYS20ZdIcoVD41Jn205zJyq73ZzENsrMfLwZ0o8VZDR70b
         BtP9raRCW+8+fuHyd88nfcqCB//q6qggYy2Uk=
Message-ID: <48E11E1E.7010001@gmail.com>
Date: Mon, 29 Sep 2008 20:27:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: mingo@elte.hu
CC: linux-kernel@vger.kernel.org, pq@iki.fi, rostedt@goodmis.org
Subject: [PATCH V2 -tip 3/4] Tracing/ftrace: Adapt mmiotrace to the new type
 of print_line
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt mmiotrace to the new print_line type.
By default, it ignores (and consumes) types it doesn't support.

Acked-by: Pekka Paalanen <pq@iki.fi>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_mmiotrace.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index a108c32..be0a6b0 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -171,7 +171,7 @@ print_out:
 	return (ret == -EBUSY) ? 0 : ret;
 }
 
-static int mmio_print_rw(struct trace_iterator *iter)
+static enum print_line_t mmio_print_rw(struct trace_iterator *iter)
 {
 	struct trace_entry *entry = iter->ent;
 	struct mmiotrace_rw *rw	= &entry->field.mmiorw;
@@ -209,11 +209,11 @@ static int mmio_print_rw(struct trace_iterator *iter)
 		break;
 	}
 	if (ret)
-		return 1;
-	return 0;
+		return TRACE_TYPE_HANDLED;
+	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static int mmio_print_map(struct trace_iterator *iter)
+static enum print_line_t mmio_print_map(struct trace_iterator *iter)
 {
 	struct trace_entry *entry = iter->ent;
 	struct mmiotrace_map *m	= &entry->field.mmiomap;
@@ -221,7 +221,7 @@ static int mmio_print_map(struct trace_iterator *iter)
 	unsigned long long t	= ns2usecs(entry->field.t);
 	unsigned long usec_rem	= do_div(t, 1000000ULL);
 	unsigned secs		= (unsigned long)t;
-	int ret = 1;
+	int ret;
 
 	switch (entry->field.mmiorw.opcode) {
 	case MMIO_PROBE:
@@ -241,11 +241,11 @@ static int mmio_print_map(struct trace_iterator *iter)
 		break;
 	}
 	if (ret)
-		return 1;
-	return 0;
+		return TRACE_TYPE_HANDLED;
+	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static int mmio_print_mark(struct trace_iterator *iter)
+static enum print_line_t mmio_print_mark(struct trace_iterator *iter)
 {
 	struct trace_entry *entry = iter->ent;
 	const char *msg		= entry->field.print.buf;
@@ -258,16 +258,15 @@ static int mmio_print_mark(struct trace_iterator *iter)
 	/* The trailing newline must be in the message. */
 	ret = trace_seq_printf(s, "MARK %lu.%06lu %s", secs, usec_rem, msg);
 	if (!ret)
-		return 0;
+		return TRACE_TYPE_PARTIAL_LINE;
 
 	if (entry->field.flags & TRACE_FLAG_CONT)
 		trace_seq_print_cont(s, iter);
 
-	return 1;
+	return TRACE_TYPE_HANDLED;
 }
 
-/* return 0 to abort printing without consuming current entry in pipe mode */
-static int mmio_print_line(struct trace_iterator *iter)
+static enum print_line_t mmio_print_line(struct trace_iterator *iter)
 {
 	switch (iter->ent->type) {
 	case TRACE_MMIO_RW:
@@ -277,7 +276,7 @@ static int mmio_print_line(struct trace_iterator *iter)
 	case TRACE_PRINT:
 		return mmio_print_mark(iter);
 	default:
-		return 1; /* ignore unknown entries */
+		return TRACE_TYPE_HANDLED; /* ignore unknown entries */
 	}
 }
 

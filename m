Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbYIZPoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbYIZPoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 11:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYIZPoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 11:44:12 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:54579 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbYIZPoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 11:44:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=BvnvD9AwrqnTBaFmoIhD9nNQ4Pg9w42iQkkgG0sxmJ6mgrLQEeMkG2dV8pcSFh3F3M
         at5ZUy28xgOjkGCHMLBZVF5nXQWjgDHj4ZEeYUKVPzOKI1G0mYP6zAA6KMJ+HfsToAt7
         xLcZdIcA1Z+X0UD9OPXNQ3xykenRxEe85HVYY=
Message-ID: <48DD0347.5070008@gmail.com>
Date: Fri, 26 Sep 2008 17:44:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: mingo@elte.hu
CC: rostedt@goodmis.org, linux-kernel@vger.kernel.org, pq@iki.fi
Subject: [PATCH -tip 2/3] Tracing/ftrace: Adapt mmiotrace to the new type
 of print_line
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt mmiotrace to the new print_line type.
By default, it refuses types it doesn't support.
But a tracer needs to print something to the seq anyway. 
That's why it needs to warn about unsupported types.

Pekka if you disagree with it, please don't hesitate to tell me.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 2bbb7dd..69480a5 100644
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
@@ -258,16 +258,16 @@ static int mmio_print_mark(struct trace_iterator *iter)
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
 
 /* return 0 to abort printing without consuming current entry in pipe mode */
-static int mmio_print_line(struct trace_iterator *iter)
+static enum print_line_t mmio_print_line(struct trace_iterator *iter)
 {
 	switch (iter->ent->type) {
 	case TRACE_MMIO_RW:
@@ -277,7 +277,9 @@ static int mmio_print_line(struct trace_iterator *iter)
 	case TRACE_PRINT:
 		return mmio_print_mark(iter);
 	default:
-		return 0; /* ignore unknown entries whithout consuming */
+		/* ignore unknown entries */
+		trace_seq_printf(&iter->seq, "Unknown trace type\n");
+		return TRACE_TYPE_HANDLED;
 	}
 }
 

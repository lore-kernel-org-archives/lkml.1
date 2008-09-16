Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbYIPTCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbYIPTCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 15:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbYIPTCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 15:02:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:64643 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbYIPTCb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 15:02:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=NihD3L2LfuCGGDbFR9Fo60skJst6T7dir4U4FqsSUL/SJtxdWDB4i1bmt80H/exaFS
         H9UBi+9sY4M0XTNS0eiq3Ri1C54/jQpuJo/2LitfItYxfp7DeT5aA6kVGEvwMJa71DHd
         eAxyeDNWh6CawRVcH0E+Lpov/8/WzstPOQpD4=
Date: Tue, 16 Sep 2008 22:02:27 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       Pavel Roskin <proski@gnu.org>
Subject: [PATCH 5/7] mmiotrace: handle TRACE_PRINT entries.
Message-ID: <20080916220227.4db173f5@daedalus.pq.iki.fi>
In-Reply-To: <20080916215416.16aee2dd@daedalus.pq.iki.fi>
References: <48B1D5CA.8000607@gmail.com>
	<c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
	<20080827212130.4b8365a8@daedalus.pq.iki.fi>
	<c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com>
	<20080828214256.296e34ec@daedalus.pq.iki.fi>
	<c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com>
	<20080904203058.7e57729e@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809041407140.2431@gandalf.stny.rr.com>
	<20080915224707.76b2cca0@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809151556260.22620@gandalf.stny.rr.com>
	<20080916215416.16aee2dd@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6a458e250857907e16cb16799392fccbfd5f0f4a Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sun, 17 Aug 2008 18:15:13 +0300
Subject: [PATCH] mmiotrace: handle TRACE_PRINT entries.

Also make trace_seq_print_cont() non-static, and add a newline if the
seq buffer can't hold all data.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 kernel/trace/trace.c           |   31 +++++++++++--------------------
 kernel/trace/trace.h           |   19 +++++++++++++++++++
 kernel/trace/trace_mmiotrace.c |   23 +++++++++++++++++++++++
 3 files changed, 53 insertions(+), 20 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 406de9c..7e7154f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -200,23 +200,6 @@ unsigned long nsecs_to_usecs(unsigned long nsecs)
 }
 
 /*
- * trace_flag_type is an enumeration that holds different
- * states when a trace occurs. These are:
- *  IRQS_OFF	- interrupts were disabled
- *  NEED_RESCED - reschedule is requested
- *  HARDIRQ	- inside an interrupt handler
- *  SOFTIRQ	- inside a softirq handler
- *  CONT	- multiple entries hold the trace item
- */
-enum trace_flag_type {
-	TRACE_FLAG_IRQS_OFF		= 0x01,
-	TRACE_FLAG_NEED_RESCHED		= 0x02,
-	TRACE_FLAG_HARDIRQ		= 0x04,
-	TRACE_FLAG_SOFTIRQ		= 0x08,
-	TRACE_FLAG_CONT			= 0x10,
-};
-
-/*
  * TRACE_ITER_SYM_MASK masks the options in trace_flags that
  * control the output of kernel symbols.
  */
@@ -1517,12 +1500,16 @@ lat_print_timestamp(struct trace_seq *s, unsigned long long abs_usecs,
 
 static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
 
-static void
-trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
+/*
+ * The message is supposed to contain an ending newline.
+ * If the printing stops prematurely, try to add a newline of our own.
+ */
+void trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
 {
 	struct trace_array *tr = iter->tr;
 	struct trace_array_cpu *data = tr->data[iter->cpu];
 	struct trace_entry *ent;
+	bool ok = true;
 
 	ent = trace_entry_idx(tr, data, iter, iter->cpu);
 	if (!ent || ent->type != TRACE_CONT) {
@@ -1531,10 +1518,14 @@ trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
 	}
 
 	do {
-		trace_seq_printf(s, "%s", ent->cont.buf);
+		if (ok)
+			ok = (trace_seq_printf(s, "%s", ent->cont.buf) > 0);
 		__trace_iterator_increment(iter, iter->cpu);
 		ent = trace_entry_idx(tr, data, iter, iter->cpu);
 	} while (ent && ent->type == TRACE_CONT);
+
+	if (!ok)
+		trace_seq_putc(s, '\n');
 }
 
 static int
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index be3b3cf..648433d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -72,6 +72,23 @@ struct print_entry {
 };
 
 /*
+ * trace_flag_type is an enumeration that holds different
+ * states when a trace occurs. These are:
+ *  IRQS_OFF	- interrupts were disabled
+ *  NEED_RESCED - reschedule is requested
+ *  HARDIRQ	- inside an interrupt handler
+ *  SOFTIRQ	- inside a softirq handler
+ *  CONT	- multiple entries hold the trace item
+ */
+enum trace_flag_type {
+	TRACE_FLAG_IRQS_OFF		= 0x01,
+	TRACE_FLAG_NEED_RESCHED		= 0x02,
+	TRACE_FLAG_HARDIRQ		= 0x04,
+	TRACE_FLAG_SOFTIRQ		= 0x08,
+	TRACE_FLAG_CONT			= 0x10,
+};
+
+/*
  * The trace field - the most basic unit of tracing. This is what
  * is printed in the end as a single line in the trace output, such as:
  *
@@ -330,6 +347,8 @@ extern int trace_selftest_startup_sysprof(struct tracer *trace,
 
 extern void *head_page(struct trace_array_cpu *data);
 extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
+extern void trace_seq_print_cont(struct trace_seq *s,
+				 struct trace_iterator *iter);
 extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
 				 size_t cnt);
 extern long ns2usecs(cycle_t nsec);
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 767d1fa..a108c32 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -245,6 +245,27 @@ static int mmio_print_map(struct trace_iterator *iter)
 	return 0;
 }
 
+static int mmio_print_mark(struct trace_iterator *iter)
+{
+	struct trace_entry *entry = iter->ent;
+	const char *msg		= entry->field.print.buf;
+	struct trace_seq *s	= &iter->seq;
+	unsigned long long t	= ns2usecs(entry->field.t);
+	unsigned long usec_rem	= do_div(t, 1000000ULL);
+	unsigned secs		= (unsigned long)t;
+	int ret;
+
+	/* The trailing newline must be in the message. */
+	ret = trace_seq_printf(s, "MARK %lu.%06lu %s", secs, usec_rem, msg);
+	if (!ret)
+		return 0;
+
+	if (entry->field.flags & TRACE_FLAG_CONT)
+		trace_seq_print_cont(s, iter);
+
+	return 1;
+}
+
 /* return 0 to abort printing without consuming current entry in pipe mode */
 static int mmio_print_line(struct trace_iterator *iter)
 {
@@ -253,6 +274,8 @@ static int mmio_print_line(struct trace_iterator *iter)
 		return mmio_print_rw(iter);
 	case TRACE_MMIO_MAP:
 		return mmio_print_map(iter);
+	case TRACE_PRINT:
+		return mmio_print_mark(iter);
 	default:
 		return 1; /* ignore unknown entries */
 	}
-- 
1.5.6.4


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbZCWPVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbZCWPVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758691AbZCWPTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:19:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:41267 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758120AbZCWPTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:19:48 -0400
Date: Mon, 23 Mar 2009 15:19:13 GMT
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eduard.munteanu@linux360.ro, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eduard.munteanu@linux360.ro, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <161be9ca8a27b432c4a6ab79f47788c4521652ae.1237813499.git.eduard.munteanu@linux360.ro>
References: <161be9ca8a27b432c4a6ab79f47788c4521652ae.1237813499.git.eduard.munteanu@linux360.ro>
Subject: [tip:tracing/kmemtrace] kmemtrace: restore original tracing data binary format, improve ABI
Message-ID: <tip-85a99f76300fd22ae763a9dd750a40d8c8859a29@git.kernel.org>
Git-Commit-ID: 85a99f76300fd22ae763a9dd750a40d8c8859a29
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 15:19:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85a99f76300fd22ae763a9dd750a40d8c8859a29
Gitweb:     http://git.kernel.org/tip/85a99f76300fd22ae763a9dd750a40d8c8859a29
Author:     Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
AuthorDate: Mon, 23 Mar 2009 15:12:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 16:08:00 +0100

kmemtrace: restore original tracing data binary format, improve ABI

When kmemtrace was ported to ftrace, the marker strings were taken as
an indication of how the traced data was being exposed to the userspace.
However, the actual format had been binary, not text.

This restores the original binary format, while also adding an origin CPU
field (since ftrace doesn't expose the data per-CPU to userspace), and
re-adding the timestamp field. It also drops arch-independent field
sizing where it didn't make sense, so pointers won't always be 64 bits
wide like they used to.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
LKML-Reference: <161be9ca8a27b432c4a6ab79f47788c4521652ae.1237813499.git.eduard.munteanu@linux360.ro>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/kmemtrace.c |   82 ++++++++++++++++++++++++++++++++-------------
 1 files changed, 58 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 15f40f4..26ec3c3 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -223,47 +223,81 @@ static void kmemtrace_headers(struct seq_file *s)
 }
 
 /*
- * The two following functions give the original output from kmemtrace,
- * or something close to....perhaps they need some missing things
+ * The following functions give the original output from kmemtrace,
+ * plus the origin CPU, since reordering occurs in-kernel now.
  */
+
+#define KMEMTRACE_USER_ALLOC	0
+#define KMEMTRACE_USER_FREE	1
+
+struct kmemtrace_user_event {
+	u8		event_id;
+	u8		type_id;
+	u16		event_size;
+	u32		cpu;
+	u64		timestamp;
+	unsigned long	call_site;
+	unsigned long	ptr;
+};
+
+struct kmemtrace_user_event_alloc {
+	size_t		bytes_req;
+	size_t		bytes_alloc;
+	unsigned	gfp_flags;
+	int		node;
+};
+
 static enum print_line_t
-kmemtrace_print_alloc_original(struct trace_iterator *iter,
-				struct kmemtrace_alloc_entry *entry)
+kmemtrace_print_alloc_user(struct trace_iterator *iter,
+			   struct kmemtrace_alloc_entry *entry)
 {
 	struct trace_seq *s = &iter->seq;
-	int ret;
-
-	/* Taken from the old linux/kmemtrace.h */
-	ret = trace_seq_printf(s, "type_id %d call_site %lu ptr %lu "
-	  "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d\n",
-	   entry->type_id, entry->call_site, (unsigned long) entry->ptr,
-	   (unsigned long) entry->bytes_req, (unsigned long) entry->bytes_alloc,
-	   (unsigned long) entry->gfp_flags, entry->node);
+	struct kmemtrace_user_event *ev;
+	struct kmemtrace_user_event_alloc *ev_alloc;
 
-	if (!ret)
+	ev = trace_seq_reserve(s, sizeof(*ev));
+	if (!ev)
+		return TRACE_TYPE_PARTIAL_LINE;
+	ev->event_id = KMEMTRACE_USER_ALLOC;
+	ev->type_id = entry->type_id;
+	ev->event_size = sizeof(*ev) + sizeof(*ev_alloc);
+	ev->cpu = iter->cpu;
+	ev->timestamp = iter->ts;
+	ev->call_site = entry->call_site; 
+	ev->ptr = (unsigned long) entry->ptr;
+
+	ev_alloc = trace_seq_reserve(s, sizeof(*ev_alloc));
+	if (!ev_alloc)
 		return TRACE_TYPE_PARTIAL_LINE;
+	ev_alloc->bytes_req = entry->bytes_req;
+	ev_alloc->bytes_alloc = entry->bytes_alloc;
+	ev_alloc->gfp_flags = entry->gfp_flags;
+	ev_alloc->node = entry->node;
 
 	return TRACE_TYPE_HANDLED;
 }
 
 static enum print_line_t
-kmemtrace_print_free_original(struct trace_iterator *iter,
-				struct kmemtrace_free_entry *entry)
+kmemtrace_print_free_user(struct trace_iterator *iter,
+			  struct kmemtrace_free_entry *entry)
 {
 	struct trace_seq *s = &iter->seq;
-	int ret;
+	struct kmemtrace_user_event *ev;
 
-	/* Taken from the old linux/kmemtrace.h */
-	ret = trace_seq_printf(s, "type_id %d call_site %lu ptr %lu\n",
-	   entry->type_id, entry->call_site, (unsigned long) entry->ptr);
-
-	if (!ret)
+	ev = trace_seq_reserve(s, sizeof(*ev));
+	if (!ev)
 		return TRACE_TYPE_PARTIAL_LINE;
+	ev->event_id = KMEMTRACE_USER_FREE;
+	ev->type_id = entry->type_id;
+	ev->event_size = sizeof(*ev);
+	ev->cpu = iter->cpu;
+	ev->timestamp = iter->ts;
+	ev->call_site = entry->call_site; 
+	ev->ptr = (unsigned long) entry->ptr;
 
 	return TRACE_TYPE_HANDLED;
 }
 
-
 /* The two other following provide a more minimalistic output */
 static enum print_line_t
 kmemtrace_print_alloc_compress(struct trace_iterator *iter,
@@ -400,7 +434,7 @@ static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
 		if (kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL)
 			return kmemtrace_print_alloc_compress(iter, field);
 		else
-			return kmemtrace_print_alloc_original(iter, field);
+			return kmemtrace_print_alloc_user(iter, field);
 	}
 
 	case TRACE_KMEM_FREE: {
@@ -409,7 +443,7 @@ static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
 		if (kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL)
 			return kmemtrace_print_free_compress(iter, field);
 		else
-			return kmemtrace_print_free_original(iter, field);
+			return kmemtrace_print_free_user(iter, field);
 	}
 
 	default:

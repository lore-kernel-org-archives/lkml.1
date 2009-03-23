Return-Path: <linux-kernel-owner+w=401wt.eu-S1757828AbZCWNO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbZCWNO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756820AbZCWNMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:12:12 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60474 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708AbZCWNMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:12:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=jExpRcpz0W90y5JO+y3SrE32Eh+0KSVckNooZ8tj84wJEIvNu00AMjXiEUfGZChKDB
         QLxzQLfa3O73dER6sOCHs0fhtnz68PLHrUMjfdy3VG7YN2zl5U4ekqB0B74UxuO4STnl
         i2NhiyK/HnCUU6cXh000ZgXsl4n2+IMhwmGXk=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: mingo@elte.hu
Cc: rostedt@goodmis.org, compudj@krystal.dyndns.org, fweisbec@gmail.com,
       penberg@cs.helsinki.fi, paulmck@linux.vnet.ibm.com,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] kmemtrace: restore original tracing data binary format, improve ABI
Date: Mon, 23 Mar 2009 15:12:26 +0200
Message-Id: <161be9ca8a27b432c4a6ab79f47788c4521652ae.1237813499.git.eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <284dba2732a144849d5aa82258fe0de2ad8dcb0b.1237813499.git.eduard.munteanu@linux360.ro>
References: <cover.1237813499.git.eduard.munteanu@linux360.ro>
 <75eba730cfee8e771090b60c4b252bd8d3ffcb18.1237813499.git.eduard.munteanu@linux360.ro>
 <6698c7b983cc20ec84becc757362f48a8948762d.1237813499.git.eduard.munteanu@linux360.ro>
 <8437e9b2ad54db68fa3c3dd89205bc7b50f203b5.1237813499.git.eduard.munteanu@linux360.ro>
 <ae61c0f37156db8ec8dc0d5778018edde60a92e3.1237813499.git.eduard.munteanu@linux360.ro>
 <284dba2732a144849d5aa82258fe0de2ad8dcb0b.1237813499.git.eduard.munteanu@linux360.ro>
In-Reply-To: <cover.1237813499.git.eduard.munteanu@linux360.ro>
References: <cover.1237813499.git.eduard.munteanu@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When kmemtrace was ported to ftrace, the marker strings were taken as an
indication of how the traced data was being exposed to the userspace.
However, the actual format had been binary, not text.

This restores the original binary format, while also adding an origin CPU
field (since ftrace doesn't expose the data per-CPU to userspace), and
re-adding the timestamp field. It also drops arch-independent field
sizing where it didn't make sense, so pointers won't always be 64 bits
wide like they used to.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 kernel/trace/kmemtrace.c |   82 ++++++++++++++++++++++++++++++++-------------
 1 files changed, 58 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 6f3cb4c..98e6f76 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -227,47 +227,81 @@ static void kmemtrace_headers(struct seq_file *s)
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
@@ -404,7 +438,7 @@ static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
 		if (kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL)
 			return kmemtrace_print_alloc_compress(iter, field);
 		else
-			return kmemtrace_print_alloc_original(iter, field);
+			return kmemtrace_print_alloc_user(iter, field);
 	}
 
 	case TRACE_KMEM_FREE: {
@@ -413,7 +447,7 @@ static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
 		if (kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL)
 			return kmemtrace_print_free_compress(iter, field);
 		else
-			return kmemtrace_print_free_original(iter, field);
+			return kmemtrace_print_free_user(iter, field);
 	}
 
 	default:
-- 
1.6.0.6


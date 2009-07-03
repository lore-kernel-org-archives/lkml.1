Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbZGCJdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbZGCJdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbZGCJd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:33:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56075 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756591AbZGCJdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:33:24 -0400
Message-ID: <4A4DD0A0.5060500@cn.fujitsu.com>
Date: Fri, 03 Jul 2009 17:34:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] kmemtrace: print binary output only if 'bin' option is
 set
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently by default the output of kmemtrace is binary format instead
of human-readable output.

This patch makes the following changes:
  - We'll see human-readable output by default
  - We'll see binary output if 'bin' option is set

Note: you may probably need to explicitly disable context-info binary
      output:

	# echo 0 > options/context-info
	# echo 1 > options/bin
	# cat trace_pipe

v2:
- use %pF to print call_site

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 kernel/trace/kmemtrace.c |  120 ++++++++++++++++++++++++++++++++++-----------
 1 files changed, 90 insertions(+), 30 deletions(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 1edaa95..74903b6 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -239,12 +239,52 @@ struct kmemtrace_user_event_alloc {
 };
 
 static enum print_line_t
-kmemtrace_print_alloc_user(struct trace_iterator *iter,
-			   struct kmemtrace_alloc_entry *entry)
+kmemtrace_print_alloc_user(struct trace_iterator *iter, int flags)
+{
+	struct trace_seq *s = &iter->seq;
+	struct kmemtrace_alloc_entry *entry;
+	int ret;
+
+	trace_assign_type(entry, iter->ent);
+
+	ret = trace_seq_printf(s, "type_id %d call_site %pF ptr %lu "
+	    "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d\n",
+	    entry->type_id, (void *)entry->call_site, (unsigned long)entry->ptr,
+	    (unsigned long)entry->bytes_req, (unsigned long)entry->bytes_alloc,
+	    (unsigned long)entry->gfp_flags, entry->node);
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+	return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t
+kmemtrace_print_free_user(struct trace_iterator *iter, int flags)
 {
-	struct kmemtrace_user_event_alloc *ev_alloc;
 	struct trace_seq *s = &iter->seq;
+	struct kmemtrace_free_entry *entry;
+	int ret;
+
+	trace_assign_type(entry, iter->ent);
+
+	ret = trace_seq_printf(s, "type_id %d call_site %pF ptr %lu\n",
+			       entry->type_id, (void *)entry->call_site,
+			       (unsigned long)entry->ptr);
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+	return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t
+kmemtrace_print_alloc_user_bin(struct trace_iterator *iter, int flags)
+{
+	struct trace_seq *s = &iter->seq;
+	struct kmemtrace_alloc_entry *entry;
 	struct kmemtrace_user_event *ev;
+	struct kmemtrace_user_event_alloc *ev_alloc;
+
+	trace_assign_type(entry, iter->ent);
 
 	ev = trace_seq_reserve(s, sizeof(*ev));
 	if (!ev)
@@ -271,12 +311,14 @@ kmemtrace_print_alloc_user(struct trace_iterator *iter,
 }
 
 static enum print_line_t
-kmemtrace_print_free_user(struct trace_iterator *iter,
-			  struct kmemtrace_free_entry *entry)
+kmemtrace_print_free_user_bin(struct trace_iterator *iter, int flags)
 {
 	struct trace_seq *s = &iter->seq;
+	struct kmemtrace_free_entry *entry;
 	struct kmemtrace_user_event *ev;
 
+	trace_assign_type(entry, iter->ent);
+
 	ev = trace_seq_reserve(s, sizeof(*ev));
 	if (!ev)
 		return TRACE_TYPE_PARTIAL_LINE;
@@ -294,12 +336,14 @@ kmemtrace_print_free_user(struct trace_iterator *iter,
 
 /* The two other following provide a more minimalistic output */
 static enum print_line_t
-kmemtrace_print_alloc_compress(struct trace_iterator *iter,
-					struct kmemtrace_alloc_entry *entry)
+kmemtrace_print_alloc_compress(struct trace_iterator *iter)
 {
+	struct kmemtrace_alloc_entry *entry;
 	struct trace_seq *s = &iter->seq;
 	int ret;
 
+	trace_assign_type(entry, iter->ent);
+
 	/* Alloc entry */
 	ret = trace_seq_printf(s, "  +      ");
 	if (!ret)
@@ -362,12 +406,14 @@ kmemtrace_print_alloc_compress(struct trace_iterator *iter,
 }
 
 static enum print_line_t
-kmemtrace_print_free_compress(struct trace_iterator *iter,
-			      struct kmemtrace_free_entry *entry)
+kmemtrace_print_free_compress(struct trace_iterator *iter)
 {
+	struct kmemtrace_free_entry *entry;
 	struct trace_seq *s = &iter->seq;
 	int ret;
 
+	trace_assign_type(entry, iter->ent);
+
 	/* Free entry */
 	ret = trace_seq_printf(s, "  -      ");
 	if (!ret)
@@ -421,32 +467,31 @@ static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
 {
 	struct trace_entry *entry = iter->ent;
 
-	switch (entry->type) {
-	case TRACE_KMEM_ALLOC: {
-		struct kmemtrace_alloc_entry *field;
-
-		trace_assign_type(field, entry);
-		if (kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL)
-			return kmemtrace_print_alloc_compress(iter, field);
-		else
-			return kmemtrace_print_alloc_user(iter, field);
-	}
-
-	case TRACE_KMEM_FREE: {
-		struct kmemtrace_free_entry *field;
-
-		trace_assign_type(field, entry);
-		if (kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL)
-			return kmemtrace_print_free_compress(iter, field);
-		else
-			return kmemtrace_print_free_user(iter, field);
-	}
+	if (!(kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL))
+		return TRACE_TYPE_UNHANDLED;
 
+	switch (entry->type) {
+	case TRACE_KMEM_ALLOC:
+		return kmemtrace_print_alloc_compress(iter);
+	case TRACE_KMEM_FREE:
+		return kmemtrace_print_free_compress(iter);
 	default:
 		return TRACE_TYPE_UNHANDLED;
 	}
 }
 
+static struct trace_event kmem_trace_alloc = {
+	.type			= TRACE_KMEM_ALLOC,
+	.trace			= kmemtrace_print_alloc_user,
+	.binary			= kmemtrace_print_alloc_user_bin,
+};
+
+static struct trace_event kmem_trace_free = {
+	.type			= TRACE_KMEM_FREE,
+	.trace			= kmemtrace_print_free_user,
+	.binary			= kmemtrace_print_free_user_bin,
+};
+
 static struct tracer kmem_tracer __read_mostly = {
 	.name			= "kmemtrace",
 	.init			= kmem_trace_init,
@@ -463,6 +508,21 @@ void kmemtrace_init(void)
 
 static int __init init_kmem_tracer(void)
 {
-	return register_tracer(&kmem_tracer);
+	if (!register_ftrace_event(&kmem_trace_alloc)) {
+		pr_warning("Warning: could not register kmem events\n");
+		return 1;
+	}
+
+	if (!register_ftrace_event(&kmem_trace_free)) {
+		pr_warning("Warning: could not register kmem events\n");
+		return 1;
+	}
+
+	if (!register_tracer(&kmem_tracer)) {
+		pr_warning("Warning: could not register the kmem tracer\n");
+		return 1;
+	}
+
+	return 0;
 }
 device_initcall(init_kmem_tracer);
-- 
1.5.4.rc3



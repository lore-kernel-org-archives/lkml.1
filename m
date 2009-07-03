Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbZGCKWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbZGCKWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbZGCKW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:22:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:36518 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbZGCKW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:22:28 -0400
Date: Fri, 3 Jul 2009 10:21:33 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, lizf@cn.fujitsu.com,
       eduard.munteanu@linux360.ro, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, penberg@cs.helsinki.fi,
       eduard.munteanu@linux360.ro, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A4DD0A0.5060500@cn.fujitsu.com>
References: <4A4DD0A0.5060500@cn.fujitsu.com>
Subject: [tip:tracing/core] kmemtrace: Print binary output only if 'bin' option is set
Message-ID: <tip-ddc1637af217dbd8bc51f30e6d24e84476a869a6@git.kernel.org>
Git-Commit-ID: ddc1637af217dbd8bc51f30e6d24e84476a869a6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 10:21:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ddc1637af217dbd8bc51f30e6d24e84476a869a6
Gitweb:     http://git.kernel.org/tip/ddc1637af217dbd8bc51f30e6d24e84476a869a6
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 3 Jul 2009 17:34:24 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jul 2009 11:39:46 +0200

kmemtrace: Print binary output only if 'bin' option is set

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
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A4DD0A0.5060500@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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

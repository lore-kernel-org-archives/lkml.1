Return-Path: <linux-kernel-owner+w=401wt.eu-S934104AbZDBHMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934104AbZDBHMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbZDBHMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:12:16 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59199 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbZDBHMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:12:15 -0400
Subject: Re: + page-owner-tracking.patch added to -mm tree
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mel Gorman <mel@csn.ul.ie>, Jason Baron <jbaron@redhat.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       alexn@dsv.su.se, akpm@linux-foundation.org, alexn@telia.com,
       apw@shadowen.org, cl@linux-foundation.org, haveblue@us.ibm.com,
       kamezawa.hiroyu@jp.fujitu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Fr?d?ric Weisbecker" <fweisbec@gmail.com>
In-Reply-To: <20090401152251.GB23390@elte.hu>
References: <200903312321.n2VNLAMI006236@imap1.linux-foundation.org>
	 <20090401111540.GC15442@elte.hu> <20090401125506.GA6406@csn.ul.ie>
	 <20090401131713.GQ12966@elte.hu> <20090401133220.GB6406@csn.ul.ie>
	 <20090401134917.GC18677@elte.hu> <1238597398.23857.11.camel@penberg-laptop>
	 <20090401152251.GB23390@elte.hu>
Date: Thu, 02 Apr 2009 10:12:11 +0300
Message-Id: <1238656331.26286.17.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-01 at 17:22 +0200, Ingo Molnar wrote:
> > +kmemtrace_print_page_alloc_user(struct trace_iterator *iter,
> > +				struct kmemtrace_page_alloc_entry *entry)
> > +{
> > +	struct kmemtrace_user_event_page_alloc *ev_alloc;
> > +	struct trace_seq *s = &iter->seq;
> > +	struct kmemtrace_user_event *ev;
> > +
> > +	ev = trace_seq_reserve(s, sizeof(*ev));
> > +	if (!ev)
> > +		return TRACE_TYPE_PARTIAL_LINE;
> > +
> > +	ev->event_id		= KMEMTRACE_USER_PAGE_ALLOC;
> > +	ev->type_id		= entry->type_id;
> > +	ev->event_size		= sizeof(*ev) + sizeof(*ev_alloc);
> > +	ev->cpu			= iter->cpu;
> > +	ev->timestamp		= iter->ts;
> > +	ev->call_site		= 0ULL;	/* FIXME */
> > +	ev->ptr			= 0ULL;	/* FIXME */
> 
> Here we could call save_stack_trace(), in a way like this, to save 
> up to 8 entries of the allocation back-trace:

The example code compiled as-is so here's an updated patch! :-) We
should probably do stack traces for _all_ events like you suggested but
that's a bigger ABI change so I did it only for the new page allocation
event.

			Pekka

diff --git a/include/trace/kmemtrace.h b/include/trace/kmemtrace.h
index 28ee69f..c71f28b 100644
--- a/include/trace/kmemtrace.h
+++ b/include/trace/kmemtrace.h
@@ -20,6 +20,10 @@ static inline void kmemtrace_init(void)
 }
 #endif
 
+DECLARE_TRACE(alloc_pages,
+	      TP_PROTO(gfp_t gfp_mask, int order),
+	      TP_ARGS(gfp_mask, order));
+
 DECLARE_TRACE(kmalloc,
 	      TP_PROTO(unsigned long call_site,
 		      const void *ptr,
diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 5011f4d..527198b 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -6,6 +6,7 @@
  * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
  */
 
+#include <linux/stacktrace.h>
 #include <linux/tracepoint.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
@@ -34,6 +35,28 @@ static struct tracer_flags kmem_tracer_flags = {
 static struct trace_array *kmemtrace_array;
 
 /* Trace allocations */
+static void kmemtrace_alloc_pages(gfp_t gfp_mask, int order)
+{
+	struct trace_array *tr = kmemtrace_array;
+	struct kmemtrace_page_alloc_entry *entry;
+	struct ring_buffer_event *event;
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, 0);
+
+	entry->ent.type		= TRACE_KMEM_PAGE_ALLOC;
+	entry->type_id		= KMEMTRACE_TYPE_PAGES,
+	entry->gfp_mask		= gfp_mask;
+	entry->order		= order;
+
+	ring_buffer_unlock_commit(tr->buffer, event);
+
+	trace_wake_up();
+}
+
 static inline void kmemtrace_alloc(enum kmemtrace_type_id type_id,
 				   unsigned long call_site,
 				   const void *ptr,
@@ -147,6 +170,10 @@ static int kmemtrace_start_probes(void)
 {
 	int err;
 
+	err = register_trace_alloc_pages(kmemtrace_alloc_pages);
+	if (err)
+		return err;
+
 	err = register_trace_kmalloc(kmemtrace_kmalloc);
 	if (err)
 		return err;
@@ -214,8 +241,9 @@ static void kmemtrace_headers(struct seq_file *s)
  * plus the origin CPU, since reordering occurs in-kernel now.
  */
 
-#define KMEMTRACE_USER_ALLOC	0
-#define KMEMTRACE_USER_FREE	1
+#define KMEMTRACE_USER_ALLOC		0
+#define KMEMTRACE_USER_FREE		1
+#define KMEMTRACE_USER_PAGE_ALLOC	2
 
 struct kmemtrace_user_event {
 	u8			event_id;
@@ -227,6 +255,14 @@ struct kmemtrace_user_event {
 	unsigned long		ptr;
 };
 
+#define NR_ENTRIES			8
+
+struct kmemtrace_user_event_page_alloc {
+	unsigned		gfp_mask;
+	int			order;
+	unsigned long		entries[NR_ENTRIES];
+};
+
 struct kmemtrace_user_event_alloc {
 	size_t			bytes_req;
 	size_t			bytes_alloc;
@@ -235,6 +271,44 @@ struct kmemtrace_user_event_alloc {
 };
 
 static enum print_line_t
+kmemtrace_print_page_alloc_user(struct trace_iterator *iter,
+				struct kmemtrace_page_alloc_entry *entry)
+{
+	struct kmemtrace_user_event_page_alloc *ev_alloc;
+	struct trace_seq *s = &iter->seq;
+	struct kmemtrace_user_event *ev;
+	struct stack_trace trace;
+
+	ev = trace_seq_reserve(s, sizeof(*ev));
+	if (!ev)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	ev->event_id		= KMEMTRACE_USER_PAGE_ALLOC;
+	ev->type_id		= entry->type_id;
+	ev->event_size		= sizeof(*ev) + sizeof(*ev_alloc);
+	ev->cpu			= iter->cpu;
+	ev->timestamp		= iter->ts;
+	ev->call_site		= 0ULL;	/* FIXME */
+	ev->ptr			= 0ULL;	/* FIXME */
+
+	ev_alloc = trace_seq_reserve(s, sizeof(*ev_alloc));
+	if (!ev_alloc)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	ev_alloc->gfp_mask	= entry->gfp_mask;
+	ev_alloc->order		= entry->order;
+
+	trace.nr_entries        = 0;
+	trace.max_entries       = NR_ENTRIES;
+	trace.entries           = ev_alloc->entries;
+	trace.skip              = 2;
+
+	save_stack_trace(&trace);
+
+	return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t
 kmemtrace_print_alloc_user(struct trace_iterator *iter,
 			   struct kmemtrace_alloc_entry *entry)
 {
@@ -288,7 +362,49 @@ kmemtrace_print_free_user(struct trace_iterator *iter,
 	return TRACE_TYPE_HANDLED;
 }
 
-/* The two other following provide a more minimalistic output */
+/* The three other following provide a more minimalistic output */
+static enum print_line_t
+kmemtrace_print_page_alloc_compress(struct trace_iterator *iter,
+				    struct kmemtrace_page_alloc_entry *entry)
+{
+	struct trace_seq *s = &iter->seq;
+	int ret;
+
+	/* Alloc entry */
+	ret = trace_seq_printf(s, "  +      ");
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Type */
+	switch (entry->type_id) {
+	case KMEMTRACE_TYPE_PAGES:
+		ret = trace_seq_printf(s, "P   ");
+		break;
+	default:
+		ret = trace_seq_printf(s, "?   ");
+	}
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Flags
+	 * TODO: would be better to see the name of the GFP flag names
+	 */
+	ret = trace_seq_printf(s, "%08x   ", entry->gfp_mask);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Node */
+	ret = trace_seq_printf(s, "%4d   ", entry->order);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	if (!trace_seq_printf(s, "\n"))
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return TRACE_TYPE_HANDLED;
+}
+
 static enum print_line_t
 kmemtrace_print_alloc_compress(struct trace_iterator *iter,
 					struct kmemtrace_alloc_entry *entry)
@@ -418,6 +534,16 @@ static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
 	struct trace_entry *entry = iter->ent;
 
 	switch (entry->type) {
+	case TRACE_KMEM_PAGE_ALLOC: {
+		struct kmemtrace_page_alloc_entry *field;
+
+		trace_assign_type(field, entry);
+		if (kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL)
+			return kmemtrace_print_page_alloc_compress(iter, field);
+		else
+			return kmemtrace_print_page_alloc_user(iter, field);
+	}
+
 	case TRACE_KMEM_ALLOC: {
 		struct kmemtrace_alloc_entry *field;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index cbc168f..3b1bfa5 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -35,6 +35,7 @@ enum trace_type {
 	TRACE_SYSCALL_EXIT,
 	TRACE_KMEM_ALLOC,
 	TRACE_KMEM_FREE,
+	TRACE_KMEM_PAGE_ALLOC,
 	TRACE_POWER,
 	TRACE_BLK,
 
@@ -188,6 +189,13 @@ enum kmemtrace_type_id {
 	KMEMTRACE_TYPE_PAGES,		/* __get_free_pages() and friends. */
 };
 
+struct kmemtrace_page_alloc_entry {
+	struct trace_entry	ent;
+	enum kmemtrace_type_id	type_id;
+	gfp_t			gfp_mask;
+	int			order;
+};
+
 struct kmemtrace_alloc_entry {
 	struct trace_entry	ent;
 	enum kmemtrace_type_id type_id;
@@ -328,6 +336,8 @@ extern void __ftrace_bad_type(void);
 			  TRACE_GRAPH_RET);		\
 		IF_ASSIGN(var, ent, struct hw_branch_entry, TRACE_HW_BRANCHES);\
 		IF_ASSIGN(var, ent, struct trace_power, TRACE_POWER); \
+		IF_ASSIGN(var, ent, struct kmemtrace_page_alloc_entry,	\
+			  TRACE_KMEM_PAGE_ALLOC);	\
 		IF_ASSIGN(var, ent, struct kmemtrace_alloc_entry,	\
 			  TRACE_KMEM_ALLOC);	\
 		IF_ASSIGN(var, ent, struct kmemtrace_free_entry,	\
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a3803ea..f939800 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1479,6 +1479,8 @@ __alloc_pages_internal(gfp_t gfp_mask, unsigned int order,
 	unsigned long did_some_progress;
 	unsigned long pages_reclaimed = 0;
 
+	trace_alloc_pages(gfp_mask, order);
+
 	lockdep_trace_alloc(gfp_mask);
 
 	might_sleep_if(wait);
@@ -1676,6 +1678,8 @@ got_pg:
 	return page;
 }
 EXPORT_SYMBOL(__alloc_pages_internal);
+DEFINE_TRACE(alloc_pages);
+EXPORT_TRACEPOINT_SYMBOL(alloc_pages);
 
 /*
  * Common helper functions.



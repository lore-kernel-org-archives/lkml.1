Return-Path: <linux-kernel-owner+w=401wt.eu-S1756377AbZCEXah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbZCEXah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757941AbZCEX3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:29:22 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:48015 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064AbZCEX3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:29:20 -0500
Message-Id: <20090305225519.517967574@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:48:03 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 35/41] Marker API update
Content-Disposition: inline; filename=marker.c-api-update.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:16 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add channel id field to marker structure. Identifies the buffer group in which
the event will be written. Adapt the marker.c file to manage the new field.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 kernel/marker.c |  115 ++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 84 insertions(+), 31 deletions(-)

Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- linux-2.6-lttng.orig/kernel/marker.c	2009-02-06 15:52:18.000000000 -0500
+++ linux-2.6-lttng/kernel/marker.c	2009-02-06 15:52:36.000000000 -0500
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/immediate.h>
+#include <linux/ltt-tracer.h>
 
 extern struct marker __start___markers[];
 extern struct marker __stop___markers[];
@@ -76,7 +77,7 @@ struct marker_entry {
 	struct rcu_head rcu;
 	void *oldptr;
 	int rcu_pending;
-	u16 chan_id;
+	u16 channel_id;
 	u16 event_id;
 	unsigned char ptype:1;
 	unsigned char format_allocated:1;
@@ -85,6 +86,7 @@ struct marker_entry {
 
 /**
  * __mark_empty_function - Empty probe callback
+ * @mdata: marker data
  * @probe_private: probe private data
  * @call_private: call site private data
  * @fmt: format string
@@ -95,8 +97,8 @@ struct marker_entry {
  * though the function pointer change and the marker enabling are two distinct
  * operations that modifies the execution flow of preemptible code.
  */
-notrace void __mark_empty_function(void *probe_private, void *call_private,
-	const char *fmt, va_list *args)
+notrace void __mark_empty_function(const struct marker *mdata,
+	void *probe_private, void *call_private, const char *fmt, va_list *args)
 {
 }
 EXPORT_SYMBOL_GPL(__mark_empty_function);
@@ -134,8 +136,8 @@ notrace void marker_probe_cb(const struc
 		 * dependant, so we put an explicit smp_rmb() here. */
 		smp_rmb();
 		va_start(args, call_private);
-		func(mdata->single.probe_private, call_private, mdata->format,
-			&args);
+		func(mdata, mdata->single.probe_private, call_private,
+			mdata->format, &args);
 		va_end(args);
 	} else {
 		struct marker_probe_closure *multi;
@@ -155,8 +157,8 @@ notrace void marker_probe_cb(const struc
 		smp_read_barrier_depends();
 		for (i = 0; multi[i].func; i++) {
 			va_start(args, call_private);
-			multi[i].func(multi[i].probe_private, call_private,
-				mdata->format, &args);
+			multi[i].func(mdata, multi[i].probe_private,
+				call_private, mdata->format, &args);
 			va_end(args);
 		}
 	}
@@ -189,8 +191,8 @@ static notrace void marker_probe_cb_noar
 		/* Must read the ptr before private data. They are not data
 		 * dependant, so we put an explicit smp_rmb() here. */
 		smp_rmb();
-		func(mdata->single.probe_private, call_private, mdata->format,
-			&args);
+		func(mdata, mdata->single.probe_private, call_private,
+			mdata->format, &args);
 	} else {
 		struct marker_probe_closure *multi;
 		int i;
@@ -208,8 +210,8 @@ static notrace void marker_probe_cb_noar
 		 */
 		smp_read_barrier_depends();
 		for (i = 0; multi[i].func; i++)
-			multi[i].func(multi[i].probe_private, call_private,
-				mdata->format, &args);
+			multi[i].func(mdata, multi[i].probe_private,
+				call_private, mdata->format, &args);
 	}
 	rcu_read_unlock_sched_notrace();
 }
@@ -218,13 +220,6 @@ static void free_old_closure(struct rcu_
 {
 	struct marker_entry *entry = container_of(head,
 		struct marker_entry, rcu);
-	int ret;
-
-	/* Single probe removed */
-	if (!entry->ptype) {
-		ret = ltt_channels_unregister(entry->channel);
-		WARN_ON(ret);
-	}
 	kfree(entry->oldptr);
 	/* Make sure we free the data before setting the pending flag to 0 */
 	smp_wmb();
@@ -437,8 +432,9 @@ static struct marker_entry *add_marker(c
 			e->call = marker_probe_cb_noarg;
 		else
 			e->call = marker_probe_cb;
-		trace_mark(core_marker_format, "name %s format %s",
-				e->name, e->format);
+		trace_mark(metadata, core_marker_format,
+			   "channel %s name %s format %s",
+			   e->channel, e->name, e->format);
 	} else {
 		e->format = NULL;
 		e->call = marker_probe_cb;
@@ -458,7 +454,7 @@ static struct marker_entry *add_marker(c
  * Remove the marker from the marker hash table. Must be called with mutex_lock
  * held.
  */
-static int remove_marker(const char *name)
+static int remove_marker(const char *channel, const char *name)
 {
 	struct hlist_head *head;
 	struct hlist_node *node;
@@ -467,6 +463,7 @@ static int remove_marker(const char *nam
 	size_t channel_len = strlen(channel) + 1;
 	size_t name_len = strlen(name) + 1;
 	u32 hash;
+	int ret;
 
 	hash = jhash(channel, channel_len-1, 0) ^ jhash(name, name_len-1, 0);
 	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
@@ -483,6 +480,8 @@ static int remove_marker(const char *nam
 	hlist_del(&e->hlist);
 	if (e->format_allocated)
 		kfree(e->format);
+	ret = ltt_channels_unregister(e->channel);
+	WARN_ON(ret);
 	/* Make sure the call_rcu has been executed */
 	if (e->rcu_pending)
 		rcu_barrier_sched();
@@ -500,8 +499,9 @@ static int marker_set_format(struct mark
 		return -ENOMEM;
 	entry->format_allocated = 1;
 
-	trace_mark(core_marker_format, "name %s format %s",
-			entry->name, entry->format);
+	trace_mark(metadata, core_marker_format,
+		   "channel %s name %s format %s",
+		   entry->channel, entry->name, entry->format);
 	return 0;
 }
 
@@ -537,6 +537,8 @@ static int set_marker(struct marker_entr
 	 * callback (does not set arguments).
 	 */
 	elem->call = entry->call;
+	elem->channel_id = entry->channel_id;
+	elem->event_id = entry->event_id;
 	/*
 	 * Sanity check :
 	 * We only update the single probe private data when the ptr is
@@ -631,9 +633,9 @@ static void disable_marker(struct marker
 	smp_wmb();
 	elem->ptype = 0;	/* single probe */
 	/*
-	 * Leave the private data and id there, because removal is racy and
-	 * should be done only after an RCU period. These are never used until
-	 * the next initialization anyway.
+	 * Leave the private data and channel_id/event_id there, because removal
+	 * is racy and should be done only after an RCU period. These are never
+	 * used until the next initialization anyway.
 	 */
 }
 
@@ -652,7 +654,7 @@ void marker_update_probe_range(struct ma
 
 	mutex_lock(&markers_mutex);
 	for (iter = begin; iter < end; iter++) {
-		mark_entry = get_marker(iter->name);
+		mark_entry = get_marker(iter->channel, iter->name);
 		if (mark_entry) {
 			set_marker(mark_entry, iter, !!mark_entry->refcount);
 			/*
@@ -716,7 +718,7 @@ int marker_probe_register(const char *ch
 	int first_probe = 0;
 
 	mutex_lock(&markers_mutex);
-	entry = get_marker(name);
+	entry = get_marker(channel, name);
 	if (!entry) {
 		first_probe = 1;
 		entry = add_marker(channel, name, format);
@@ -731,10 +733,18 @@ int marker_probe_register(const char *ch
 		if (ret < 0)
 			goto error_unregister_channel;
 		entry->channel_id = ret;
-		ret = ltt_channels_get_event_id(channel);
+		ret = ltt_channels_get_event_id(channel, name);
 		if (ret < 0)
 			goto error_unregister_channel;
 		entry->event_id = ret;
+		ret = 0;
+		trace_mark(metadata, core_marker_id,
+			   "channel %s name %s event_id %hu "
+			   "int #1u%zu long #1u%zu pointer #1u%zu "
+			   "size_t #1u%zu alignment #1u%u",
+			   channel, name, entry->event_id,
+			   sizeof(int), sizeof(long), sizeof(void *),
+			   sizeof(size_t), ltt_get_alignment());
 	} else if (format) {
 		if (!entry->format)
 			ret = marker_set_format(entry, format);
@@ -773,6 +783,7 @@ int marker_probe_register(const char *ch
 	/* write rcu_pending before calling the RCU callback */
 	smp_wmb();
 	call_rcu_sched(&entry->rcu, free_old_closure);
+	goto end;
 
 error_unregister_channel:
 	ret_err = ltt_channels_unregister(channel);
@@ -978,7 +989,7 @@ EXPORT_SYMBOL_GPL(marker_get_private_dat
  * markers_compact_event_ids - Compact markers event IDs and reassign channels
  *
  * Called when no channel users are active by the channel infrastructure.
- * Called with lock_markers() held.
+ * Called with lock_markers() and channel mutex held.
  */
 void markers_compact_event_ids(void)
 {
@@ -986,6 +997,7 @@ void markers_compact_event_ids(void)
 	unsigned int i;
 	struct hlist_head *head;
 	struct hlist_node *node;
+	int ret;
 
 	for (i = 0; i < MARKER_TABLE_SIZE; i++) {
 		head = &marker_table[i];
@@ -993,7 +1005,8 @@ void markers_compact_event_ids(void)
 			ret = ltt_channels_get_index_from_name(entry->channel);
 			WARN_ON(ret < 0);
 			entry->channel_id = ret;
-			ret = ltt_channels_get_event_id(entry->channel);
+			ret = _ltt_channels_get_event_id(entry->channel,
+							 entry->name);
 			WARN_ON(ret < 0);
 			entry->event_id = ret;
 		}
@@ -1102,3 +1115,43 @@ static int init_markers(void)
 __initcall(init_markers);
 
 #endif /* CONFIG_MODULES */
+
+void ltt_dump_marker_state(struct ltt_trace_struct *trace)
+{
+	struct marker_iter iter;
+	struct ltt_probe_private_data call_data;
+	const char *channel;
+
+	call_data.trace = trace;
+	call_data.serializer = NULL;
+
+	marker_iter_reset(&iter);
+	marker_iter_start(&iter);
+	for (; iter.marker != NULL; marker_iter_next(&iter)) {
+		if (!_imv_read(iter.marker->state))
+			continue;
+		channel = ltt_channels_get_name_from_index(
+				iter.marker->channel_id);
+		__trace_mark(0, metadata, core_marker_id,
+			&call_data,
+			"channel %s name %s event_id %hu "
+			"int #1u%zu long #1u%zu pointer #1u%zu "
+			"size_t #1u%zu alignment #1u%u",
+			channel,
+			iter.marker->name,
+			iter.marker->event_id,
+			sizeof(int), sizeof(long),
+			sizeof(void *), sizeof(size_t),
+			ltt_get_alignment());
+		if (iter.marker->format)
+			__trace_mark(0, metadata,
+				core_marker_format,
+				&call_data,
+				"channel %s name %s format %s",
+				channel,
+				iter.marker->name,
+				iter.marker->format);
+	}
+	marker_iter_stop(&iter);
+}
+EXPORT_SYMBOL_GPL(ltt_dump_marker_state);

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

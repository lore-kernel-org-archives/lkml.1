Return-Path: <linux-kernel-owner+w=401wt.eu-S1758301AbZBEQSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301AbZBEQSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbZBEQR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:17:58 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:46646 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbZBEQR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:17:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:cc:subject;
        b=HDwzrilzmvWl2dcnDezyn8ywrPesnZ6ru6dNWBYgO8rw3/dmx663aDvL5dm9cVxHVU
         hW7OWcXV+zD7KpEkb9ZsqIIWUHSu9a2GkIwwCZPCFfLo6drL4s4L410t/v6lW6heJFQi
         wJZczZQGm5znjf7bFiy52B4iOU+z3yocfDI38=
Message-ID: <498b1131.0f345e0a.22e2.ffffd06c@mx.google.com>
Date: Thu, 05 Feb 2009 08:17:53 -0800 (PST)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [RFC][PATCH] tracing/core: support for tracer's private events
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(LKML rejected my message, re-attempting...)

The question of tracer's private events aka "subevents" started to raise on the block
tracer discussion and projects about a syscall tracer.

When a tracer registers a trace type, it has to put it on trace.h
Until now, the tracers haven't needed more than three types.

But the block tracer logs various types of events from the block subsystem.
All of them are wrapped into one global trace type and a private subtype field
is set for each traces and processed on output from the tracer.

We could have put all of these events into trace.h but this approach can
bring an overhead on this header file with the coming of new tracers in the
future.

Also the project of a syscall tracer, still in discussion concerning its low-level
interface, have enforced the need of these subtypes by anticipating the need of one
type per syscall.

This patch is only a RFC (compiled tested only). I just want to be sure this new subevent
interface really fit these needs and actually make these private events simplier to handle
before going further.

With this patch, the event hashtable contains now trace_event_entry as nodes.
This trace_event_entry embeeds the usual trace event, the hlist node, an array
of subevents and a callback to determine the subtype of an event. We need such
a callback provided by the tracer because these subtypes are fully tracer's dependent.

It doesn't touches the backward compatibility.
If a tracer needs subevents handling, it needs to define its own array of subevents:

struct trace_event subevents[] = {
	{
		.trace = subtrace1;
		.hex	= subhex1;
	},
	{
		.trace = subtrace2;
		.bin = subbin2;
	},
	....
}

its own subtype finder:

int subevent_type_find(struct trace_entry *ent)
{
	return my_subtype_number;
}

Note that the subtype numbers returned matches the index into
the subevents array.
I started the whole thing assuming a tracer will define its subtypes
number starting from 0, but it doesn't seem to be so obvious.

Probably it would be better to assume random subevents numbers and then
have a hashlist of subevents per trace_event_entry inside the hlist instead
of an array. This way a tracer can hook into raw subsystems events number
which can have random values.

Anyway, I will let you comment this idea.

Once you have all that ready, you can register your subevents along the
global event you registered before:

register_ftrace_subevent(global_event, &subevents, ARRAY_SIZE(subevents),
			     subevent_type_find);

What do you think?

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c        |   10 ++--
 kernel/trace/trace_output.c |  128 ++++++++++++++++++++++++++++++++++++-------
 kernel/trace/trace_output.h |   28 +++++++---
 3 files changed, 132 insertions(+), 34 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a5e4c0a..b080eba 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1405,7 +1405,7 @@ static enum print_line_t print_lat_fmt(struct trace_iterator *iter)
 
 	test_cpu_buff_start(iter);
 
-	event = ftrace_find_event(entry->type);
+	event = ftrace_find_event(entry);
 
 	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
 		if (!trace_print_lat_context(iter))
@@ -1434,7 +1434,7 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 
 	test_cpu_buff_start(iter);
 
-	event = ftrace_find_event(entry->type);
+	event = ftrace_find_event(entry);
 
 	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
 		if (!trace_print_context(iter))
@@ -1466,7 +1466,7 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 			goto partial;
 	}
 
-	event = ftrace_find_event(entry->type);
+	event = ftrace_find_event(entry);
 	if (event)
 		return event->raw(iter, 0);
 
@@ -1493,7 +1493,7 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 		SEQ_PUT_HEX_FIELD_RET(s, iter->ts);
 	}
 
-	event = ftrace_find_event(entry->type);
+	event = ftrace_find_event(entry);
 	if (event) {
 		enum print_line_t ret = event->hex(iter, 0);
 		if (ret != TRACE_TYPE_HANDLED)
@@ -1535,7 +1535,7 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 		SEQ_PUT_FIELD_RET(s, iter->ts);
 	}
 
-	event = ftrace_find_event(entry->type);
+	event = ftrace_find_event(entry);
 	return event ? event->binary(iter, 0) : TRACE_TYPE_HANDLED;
 }
 
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index b6e99af..84e68c3 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -14,6 +14,14 @@
 /* must be a power of 2 */
 #define EVENT_HASHSIZE	128
 
+struct trace_event_entry {
+	struct hlist_node	node;
+	struct trace_event	*event;
+	struct trace_event	*subevents;
+	int			nb_subevents;
+	subevent_type_func	find_subevent_type;
+};
+
 static DEFINE_MUTEX(trace_event_mutex);
 static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
 
@@ -381,26 +389,62 @@ static int task_state_char(unsigned long state)
 	return bit < sizeof(state_to_char) - 1 ? state_to_char[bit] : '?';
 }
 
+static struct trace_event_entry *find_event_entry(int type)
+{
+	struct trace_event_entry *entry;
+	struct hlist_node *n;
+	unsigned key;
+
+	key = type & (EVENT_HASHSIZE - 1);
+
+	hlist_for_each_entry_rcu(entry, n, &event_hash[key], node) {
+		if (entry->event->type == type)
+			return entry;
+	}
+
+	return NULL;
+}
+
 /**
  * ftrace_find_event - find a registered event
  * @type: the type of event to look for
  *
  * Returns an event of type @type otherwise NULL
  */
-struct trace_event *ftrace_find_event(int type)
+struct trace_event *ftrace_find_event(struct trace_entry *ent)
 {
 	struct trace_event *event;
-	struct hlist_node *n;
-	unsigned key;
+	struct trace_event_entry *entry;
+	int type = ent->type;
+	int index;
 
-	key = type & (EVENT_HASHSIZE - 1);
+	entry = find_event_entry(type);
 
-	hlist_for_each_entry_rcu(event, n, &event_hash[key], node) {
-		if (event->type == type)
-			return event;
+	if (!entry)
+		return NULL;
+
+	event = entry->event;
+	if (entry->subevents) {
+		index = entry->find_subevent_type(ent);
+		if (index >= 0 && index < entry->nb_subevents)
+			return &entry->subevents[index];
 	}
 
-	return NULL;
+	return event;
+}
+
+static void set_default_events(struct trace_event *event)
+{
+	if (event->trace == NULL)
+		event->trace = trace_nop_print;
+	if (event->latency_trace == NULL)
+		event->latency_trace = trace_nop_print;
+	if (event->raw == NULL)
+		event->raw = trace_nop_print;
+	if (event->hex == NULL)
+		event->hex = trace_nop_print;
+	if (event->binary == NULL)
+		event->binary = trace_nop_print;
 }
 
 /**
@@ -420,6 +464,7 @@ struct trace_event *ftrace_find_event(int type)
  */
 int register_ftrace_event(struct trace_event *event)
 {
+	struct trace_event_entry *entry;
 	unsigned key;
 	int ret = 0;
 
@@ -432,23 +477,22 @@ int register_ftrace_event(struct trace_event *event)
 		WARN_ON(1);
 	}
 
-	if (ftrace_find_event(event->type))
+	if (find_event_entry(event->type))
 		goto out;
 
-	if (event->trace == NULL)
-		event->trace = trace_nop_print;
-	if (event->latency_trace == NULL)
-		event->latency_trace = trace_nop_print;
-	if (event->raw == NULL)
-		event->raw = trace_nop_print;
-	if (event->hex == NULL)
-		event->hex = trace_nop_print;
-	if (event->binary == NULL)
-		event->binary = trace_nop_print;
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	set_default_events(event);
 
+	entry->event = event;
+	event->entry = entry;
 	key = event->type & (EVENT_HASHSIZE - 1);
 
-	hlist_add_head_rcu(&event->node, &event_hash[key]);
+	hlist_add_head_rcu(&entry->node, &event_hash[key]);
 
 	ret = event->type;
  out:
@@ -463,10 +507,52 @@ int register_ftrace_event(struct trace_event *event)
  */
 int unregister_ftrace_event(struct trace_event *event)
 {
+	struct trace_event_entry *entry;
+	entry = event->entry;
+
 	mutex_lock(&trace_event_mutex);
-	hlist_del(&event->node);
+	hlist_del(&entry->node);
 	mutex_unlock(&trace_event_mutex);
 
+	kfree(entry);
+
+	return 0;
+}
+
+int register_ftrace_subevent(struct trace_event *event,
+			     struct trace_event *subevents,
+			     int nb_subevents,
+			     subevent_type_func find_subevent_type)
+{
+	struct trace_event_entry *entry = event->entry;
+	int i;
+
+	if (!entry || !find_subevent_type)
+		return -EINVAL;
+
+	for (i = 0; i < nb_subevents; i++) {
+		set_default_events(&subevents[i]);
+		subevents[i].entry = entry;
+	}
+
+	entry->subevents = subevents;
+	entry->nb_subevents = nb_subevents;
+	entry->find_subevent_type = find_subevent_type;
+
+	return 0;
+}
+
+int unregister_ftrace_subevents(struct trace_event *subevents)
+{
+	struct trace_event_entry *entry = subevents->entry;
+
+	if (!entry)
+		return -EINVAL;
+
+	entry->nb_subevents = 0;
+	entry->subevents = NULL;
+	entry->find_subevent_type = NULL;
+
 	return 0;
 }
 
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index 551a25a..eaae579 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -6,14 +6,19 @@
 typedef enum print_line_t (*trace_print_func)(struct trace_iterator *iter,
 					      int flags);
 
+typedef int (*subevent_type_func)(struct trace_entry *ent);
+
+struct trace_event_entry;
+
 struct trace_event {
-	struct hlist_node	node;
-	int			type;
-	trace_print_func	trace;
-	trace_print_func	latency_trace;
-	trace_print_func	raw;
-	trace_print_func	hex;
-	trace_print_func	binary;
+	int				type;
+	trace_print_func		trace;
+	trace_print_func		latency_trace;
+	trace_print_func		raw;
+	trace_print_func		hex;
+	trace_print_func		binary;
+
+	struct trace_event_entry	*entry;
 };
 
 extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
@@ -36,10 +41,17 @@ int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
 int trace_print_context(struct trace_iterator *iter);
 int trace_print_lat_context(struct trace_iterator *iter);
 
-struct trace_event *ftrace_find_event(int type);
+struct trace_event *ftrace_find_event(struct trace_entry *ent);
 int register_ftrace_event(struct trace_event *event);
 int unregister_ftrace_event(struct trace_event *event);
 
+int register_ftrace_subevent(struct trace_event *event,
+			     struct trace_event *subevents,
+			     int nb_subevents,
+			     subevent_type_func find_subevent_type);
+
+int unregister_ftrace_subevents(struct trace_event *subevents);
+
 enum print_line_t trace_nop_print(struct trace_iterator *iter, int flags);
 
 #define MAX_MEMHEX_BYTES	8


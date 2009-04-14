Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbZDNR2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbZDNR2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZDNR0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:26:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62430 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZDNR0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:26:44 -0400
Message-Id: <20090414172642.137060126@goodmis.org>
References: <20090414172337.280621613@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 14 Apr 2009 13:23:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 8/8] tracing/events: add support for modules to TRACE_EVENT
Content-Disposition: inline; filename=0008-tracing-events-add-support-for-modules-to-TRACE_EVE.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: allow modules to add TRACE_EVENTS on load

This patch adds the final hooks to allow modules to use the TRACE_EVENT
macro. A notifier and a data structure are used to link the TRACE_EVENTs
defined in the module to connect them with the ftrace event tracing system.

It also adds the necessary automated clean ups to the trace events when a
module is removed.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    3 +
 include/linux/module.h       |    4 +
 include/linux/trace_seq.h    |    2 +
 include/trace/ftrace.h       |    1 +
 kernel/module.c              |    7 ++
 kernel/trace/trace_events.c  |  128 +++++++++++++++++++++++++++++++-----------
 6 files changed, 113 insertions(+), 32 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 1781085..75f3ac0 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -7,6 +7,7 @@
 
 struct trace_array;
 struct tracer;
+struct dentry;
 
 /*
  * The trace entry - the most basic unit of tracing. This is what
@@ -87,6 +88,7 @@ struct ftrace_event_call {
 	char			*name;
 	char			*system;
 	struct dentry		*dir;
+	struct trace_event	*event;
 	int			enabled;
 	int			(*regfunc)(void);
 	void			(*unregfunc)(void);
@@ -97,6 +99,7 @@ struct ftrace_event_call {
 	struct list_head	fields;
 	int			n_preds;
 	struct filter_pred	**preds;
+	void			*mod;
 
 #ifdef CONFIG_EVENT_PROFILE
 	atomic_t	profile_count;
diff --git a/include/linux/module.h b/include/linux/module.h
index 627ac08..6155fa4 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -337,6 +337,10 @@ struct module
 	const char **trace_bprintk_fmt_start;
 	unsigned int num_trace_bprintk_fmt;
 #endif
+#ifdef CONFIG_EVENT_TRACING
+	struct ftrace_event_call *trace_events;
+	unsigned int num_trace_events;
+#endif
 
 #ifdef CONFIG_MODULE_UNLOAD
 	/* What modules depend on me? */
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 28051da..15ca2c7 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_TRACE_SEQ_H
 #define _LINUX_TRACE_SEQ_H
 
+#include <linux/fs.h>
+
 /*
  * Trace sequences are used to allow a function to call several other functions
  * to create a string of data to use (up to a max of PAGE_SIZE.
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 955b967..60c5323 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -477,6 +477,7 @@ __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.system			= __stringify(TRACE_SYSTEM),		\
+	.event			= &ftrace_event_type_##call,		\
 	.raw_init		= ftrace_raw_init_event_##call,		\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
diff --git a/kernel/module.c b/kernel/module.c
index e797812..a039470 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -18,6 +18,7 @@
 */
 #include <linux/module.h>
 #include <linux/moduleloader.h>
+#include <linux/ftrace_event.h>
 #include <linux/init.h>
 #include <linux/kallsyms.h>
 #include <linux/fs.h>
@@ -2172,6 +2173,12 @@ static noinline struct module *load_module(void __user *umod,
 					sizeof(*mod->tracepoints),
 					&mod->num_tracepoints);
 #endif
+#ifdef CONFIG_EVENT_TRACING
+	mod->trace_events = section_objs(hdr, sechdrs, secstrings,
+					 "_ftrace_events",
+					 sizeof(*mod->trace_events),
+					 &mod->num_trace_events);
+#endif
 
 #ifdef CONFIG_MODVERSIONS
 	if ((mod->num_syms && !mod->crcs)
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 8b9e621..a4b1777 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -713,7 +713,13 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 		return d_events;
 	}
 
-	system->name = name;
+	system->name = kstrdup(name, GFP_KERNEL);
+	if (!system->name) {
+		debugfs_remove(system->entry);
+		kfree(system);
+		return d_events;
+	}
+
 	list_add(&system->list, &event_subsystems);
 
 	system->preds = NULL;
@@ -738,7 +744,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 	 * If the trace point header did not define TRACE_SYSTEM
 	 * then the system would be called "TRACE_SYSTEM".
 	 */
-	if (strcmp(call->system, "TRACE_SYSTEM") != 0)
+	if (strcmp(call->system, TRACE_SYSTEM) != 0)
 		d_events = event_subsystem_dir(call->system, d_events);
 
 	if (call->raw_init) {
@@ -757,21 +763,13 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 		return -1;
 	}
 
-	if (call->regfunc) {
-		entry = debugfs_create_file("enable", 0644, call->dir, call,
-					    &ftrace_enable_fops);
-		if (!entry)
-			pr_warning("Could not create debugfs "
-				   "'%s/enable' entry\n", call->name);
-	}
+	if (call->regfunc)
+		entry = trace_create_file("enable", 0644, call->dir, call,
+					  &ftrace_enable_fops);
 
-	if (call->id) {
-		entry = debugfs_create_file("id", 0444, call->dir, call,
-				&ftrace_event_id_fops);
-		if (!entry)
-			pr_warning("Could not create debugfs '%s/id' entry\n",
-					call->name);
-	}
+	if (call->id)
+		entry = trace_create_file("id", 0444, call->dir, call,
+					  &ftrace_event_id_fops);
 
 	if (call->define_fields) {
 		ret = call->define_fields();
@@ -780,40 +778,102 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 				   " events/%s\n", call->name);
 			return ret;
 		}
-		entry = debugfs_create_file("filter", 0644, call->dir, call,
-					    &ftrace_event_filter_fops);
-		if (!entry)
-			pr_warning("Could not create debugfs "
-				   "'%s/filter' entry\n", call->name);
+		entry = trace_create_file("filter", 0644, call->dir, call,
+					  &ftrace_event_filter_fops);
 	}
 
 	/* A trace may not want to export its format */
 	if (!call->show_format)
 		return 0;
 
-	entry = debugfs_create_file("format", 0444, call->dir, call,
-				    &ftrace_event_format_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'%s/format' entry\n", call->name);
+	entry = trace_create_file("format", 0444, call->dir, call,
+				  &ftrace_event_format_fops);
+
+	return 0;
+}
+
+#define for_each_event(event, start, end)			\
+	for (event = start;					\
+	     (unsigned long)event < (unsigned long)end;		\
+	     event++)
+
+static void trace_module_add_events(struct module *mod)
+{
+	struct ftrace_event_call *call, *start, *end;
+	struct dentry *d_events;
+
+	start = mod->trace_events;
+	end = mod->trace_events + mod->num_trace_events;
+
+	if (start == end)
+		return;
+
+	d_events = event_trace_events_dir();
+	if (!d_events)
+		return;
+
+	for_each_event(call, start, end) {
+		/* The linker may leave blanks */
+		if (!call->name)
+			continue;
+		call->mod = mod;
+		list_add(&call->list, &ftrace_events);
+		event_create_dir(call, d_events);
+	}
+}
+
+static void trace_module_remove_events(struct module *mod)
+{
+	struct ftrace_event_call *call, *p;
+
+	list_for_each_entry_safe(call, p, &ftrace_events, list) {
+		if (call->mod == mod) {
+			if (call->enabled) {
+				call->enabled = 0;
+				call->unregfunc();
+			}
+			if (call->event)
+				unregister_ftrace_event(call->event);
+			debugfs_remove_recursive(call->dir);
+			list_del(&call->list);
+		}
+	}
+}
+
+int trace_module_notify(struct notifier_block *self,
+			unsigned long val, void *data)
+{
+	struct module *mod = data;
+
+	mutex_lock(&event_mutex);
+	switch (val) {
+	case MODULE_STATE_COMING:
+		trace_module_add_events(mod);
+		break;
+	case MODULE_STATE_GOING:
+		trace_module_remove_events(mod);
+		break;
+	}
+	mutex_unlock(&event_mutex);
 
 	return 0;
 }
 
+struct notifier_block trace_module_nb = {
+	.notifier_call = trace_module_notify,
+	.priority = 0,
+};
+
 extern struct ftrace_event_call __start_ftrace_events[];
 extern struct ftrace_event_call __stop_ftrace_events[];
 
-#define for_each_event(event)						\
-	for (event = __start_ftrace_events;				\
-	     (unsigned long)event < (unsigned long)__stop_ftrace_events; \
-	     event++)
-
 static __init int event_trace_init(void)
 {
 	struct ftrace_event_call *call;
 	struct dentry *d_tracer;
 	struct dentry *entry;
 	struct dentry *d_events;
+	int ret;
 
 	d_tracer = tracing_init_dentry();
 	if (!d_tracer)
@@ -837,7 +897,7 @@ static __init int event_trace_init(void)
 	if (!d_events)
 		return 0;
 
-	for_each_event(call) {
+	for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
 		/* The linker may leave blanks */
 		if (!call->name)
 			continue;
@@ -845,6 +905,10 @@ static __init int event_trace_init(void)
 		event_create_dir(call, d_events);
 	}
 
+	ret = register_module_notifier(&trace_module_nb);
+	if (!ret)
+		pr_warning("Failed to register trace events module notifier\n");
+
 	return 0;
 }
 fs_initcall(event_trace_init);
-- 
1.6.2.1

-- 

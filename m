Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbZDYE2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbZDYE2Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 00:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZDYE0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 00:26:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37200 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbZDYE0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 00:26:35 -0400
Message-Id: <20090425042633.428284874@goodmis.org>
References: <20090425042030.431477667@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 25 Apr 2009 00:20:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Greg KH <greg@kroah.com>
Subject: [PATCH 5/5] tracing/events: make modules have their own file_operations structure
Content-Disposition: inline; filename=0005-tracing-events-make-modules-have-their-own-file_ope.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

For proper module reference counting, the file_operations that modules use
must have the "owner" field set to the module. Unfortunately, the trace events
use share file_operations. The same file_operations are used by all both
kernel core and all modules.

This patch makes the modules allocate their own file_operations and
copies the functions from the core kernel. This allows those file
operations to be owned by the module.

Care is taken to free this code on module unload.

Thanks to Greg KH for reminding me that file_operations must be owned
by the module to have reference counting take place.

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   95 +++++++++++++++++++++++++++++++++++++++---
 1 files changed, 88 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index b920815..be4d3a4 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -770,7 +770,11 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 }
 
 static int
-event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
+event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
+		 const struct file_operations *id,
+		 const struct file_operations *enable,
+		 const struct file_operations *filter,
+		 const struct file_operations *format)
 {
 	struct dentry *entry;
 	int ret;
@@ -800,11 +804,11 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 
 	if (call->regfunc)
 		entry = trace_create_file("enable", 0644, call->dir, call,
-					  &ftrace_enable_fops);
+					  enable);
 
 	if (call->id)
 		entry = trace_create_file("id", 0444, call->dir, call,
-					  &ftrace_event_id_fops);
+					  id);
 
 	if (call->define_fields) {
 		ret = call->define_fields();
@@ -814,7 +818,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 			return ret;
 		}
 		entry = trace_create_file("filter", 0644, call->dir, call,
-					  &ftrace_event_filter_fops);
+					  filter);
 	}
 
 	/* A trace may not want to export its format */
@@ -822,7 +826,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 		return 0;
 
 	entry = trace_create_file("format", 0444, call->dir, call,
-				  &ftrace_event_format_fops);
+				  format);
 
 	return 0;
 }
@@ -833,8 +837,60 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 	     event++)
 
 #ifdef CONFIG_MODULES
+
+static LIST_HEAD(ftrace_module_file_list);
+
+/*
+ * Modules must own their file_operations to keep up with
+ * reference counting.
+ */
+struct ftrace_module_file_ops {
+	struct list_head		list;
+	struct module			*mod;
+	struct file_operations		id;
+	struct file_operations		enable;
+	struct file_operations		format;
+	struct file_operations		filter;
+};
+
+static struct ftrace_module_file_ops *
+trace_create_file_ops(struct module *mod)
+{
+	struct ftrace_module_file_ops *file_ops;
+
+	/*
+	 * This is a bit of a PITA. To allow for correct reference
+	 * counting, modules must "own" their file_operations.
+	 * To do this, we allocate the file operations that will be
+	 * used in the event directory.
+	 */
+
+	file_ops = kmalloc(sizeof(*file_ops), GFP_KERNEL);
+	if (!file_ops)
+		return NULL;
+
+	file_ops->mod = mod;
+
+	file_ops->id = ftrace_event_id_fops;
+	file_ops->id.owner = mod;
+
+	file_ops->enable = ftrace_enable_fops;
+	file_ops->enable.owner = mod;
+
+	file_ops->filter = ftrace_event_filter_fops;
+	file_ops->filter.owner = mod;
+
+	file_ops->format = ftrace_event_format_fops;
+	file_ops->format.owner = mod;
+
+	list_add(&file_ops->list, &ftrace_module_file_list);
+
+	return file_ops;
+}
+
 static void trace_module_add_events(struct module *mod)
 {
+	struct ftrace_module_file_ops *file_ops = NULL;
 	struct ftrace_event_call *call, *start, *end;
 	struct dentry *d_events;
 
@@ -852,14 +908,27 @@ static void trace_module_add_events(struct module *mod)
 		/* The linker may leave blanks */
 		if (!call->name)
 			continue;
+
+		/*
+		 * This module has events, create file ops for this module
+		 * if not already done.
+		 */
+		if (!file_ops) {
+			file_ops = trace_create_file_ops(mod);
+			if (!file_ops)
+				return;
+		}
 		call->mod = mod;
 		list_add(&call->list, &ftrace_events);
-		event_create_dir(call, d_events);
+		event_create_dir(call, d_events,
+				 &file_ops->id, &file_ops->enable,
+				 &file_ops->filter, &file_ops->format);
 	}
 }
 
 static void trace_module_remove_events(struct module *mod)
 {
+	struct ftrace_module_file_ops *file_ops;
 	struct ftrace_event_call *call, *p;
 
 	list_for_each_entry_safe(call, p, &ftrace_events, list) {
@@ -874,6 +943,16 @@ static void trace_module_remove_events(struct module *mod)
 			list_del(&call->list);
 		}
 	}
+
+	/* Now free the file_operations */
+	list_for_each_entry(file_ops, &ftrace_module_file_list, list) {
+		if (file_ops->mod == mod)
+			break;
+	}
+	if (&file_ops->list != &ftrace_module_file_list) {
+		list_del(&file_ops->list);
+		kfree(file_ops);
+	}
 }
 
 static int trace_module_notify(struct notifier_block *self,
@@ -954,7 +1033,9 @@ static __init int event_trace_init(void)
 		if (!call->name)
 			continue;
 		list_add(&call->list, &ftrace_events);
-		event_create_dir(call, d_events);
+		event_create_dir(call, d_events, &ftrace_event_id_fops,
+				 &ftrace_enable_fops, &ftrace_event_filter_fops,
+				 &ftrace_event_format_fops);
 	}
 
 	ret = register_module_notifier(&trace_module_nb);
-- 
1.6.2.1

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761966AbZEGDQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761966AbZEGDQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 23:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757517AbZEGDOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 23:14:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55273 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbZEGDOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 23:14:34 -0400
Message-Id: <20090507031434.586509269@goodmis.org>
References: <20090507031335.815354104@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 May 2009 23:13:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/7] tracing: reset ring buffer when removing modules with events
Content-Disposition: inline; filename=0006-tracing-reset-ring-buffer-when-removing-modules-wit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Li Zefan found that there's a race using the event ids of events and
modules. When a module is loaded, an event id is incremented. We only
have 16 bits for event ids (65536) and there is a possible (but highly
unlikely) race that we could load and unload a module that registers
events so many times that the event id counter overflows.

When it overflows, it then restarts and goes looking for available
ids. An id is available if it was added by a module and released.

The race is if you have one module add an id, and then is removed.
Another module loaded can use that same event id. But if the old module
still had events in the ring buffer, the new module's call back would
get bogus data.  At best (and most likely) the output would just be
garbage. But if the module for some reason used pointers (not recommended)
then this could potentially crash.

The safest thing to do is just reset the ring buffer if a module that
registered events is removed.

[ Impact: prevent unpredictable results of event id overflows ]

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <49FEAFD0.30106@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c        |   10 ++++++++++
 kernel/trace/trace.h        |    2 ++
 kernel/trace/trace_events.c |    9 +++++++++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4164a34..dd40d23 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -639,6 +639,16 @@ void tracing_reset_online_cpus(struct trace_array *tr)
 		tracing_reset(tr, cpu);
 }
 
+void tracing_reset_current(int cpu)
+{
+	tracing_reset(&global_trace, cpu);
+}
+
+void tracing_reset_current_online_cpus(void)
+{
+	tracing_reset_online_cpus(&global_trace);
+}
+
 #define SAVED_CMDLINES 128
 #define NO_CMDLINE_MAP UINT_MAX
 static unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 777c6c3..ba25793 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -409,6 +409,8 @@ int tracing_is_enabled(void);
 void trace_wake_up(void);
 void tracing_reset(struct trace_array *tr, int cpu);
 void tracing_reset_online_cpus(struct trace_array *tr);
+void tracing_reset_current(int cpu);
+void tracing_reset_current_online_cpus(void);
 int tracing_open_generic(struct inode *inode, struct file *filp);
 struct dentry *trace_create_file(const char *name,
 				 mode_t mode,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 8d579ff..6d2c842 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -932,9 +932,11 @@ static void trace_module_remove_events(struct module *mod)
 {
 	struct ftrace_module_file_ops *file_ops;
 	struct ftrace_event_call *call, *p;
+	bool found = false;
 
 	list_for_each_entry_safe(call, p, &ftrace_events, list) {
 		if (call->mod == mod) {
+			found = true;
 			if (call->enabled) {
 				call->enabled = 0;
 				call->unregfunc();
@@ -957,6 +959,13 @@ static void trace_module_remove_events(struct module *mod)
 		list_del(&file_ops->list);
 		kfree(file_ops);
 	}
+
+	/*
+	 * It is safest to reset the ring buffer if the module being unloaded
+	 * registered any events.
+	 */
+	if (found)
+		tracing_reset_current_online_cpus();
 }
 
 static int trace_module_notify(struct notifier_block *self,
-- 
1.6.2.4

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbZB1JLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbZB1JLY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbZB1JJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:09:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbZB1JJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:09:40 -0500
Message-Id: <20090228090937.149263440@goodmis.org>
References: <20090228090646.265765024@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 28 Feb 2009 04:06:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       acme@ghostprotocols.net, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 02/10] tracing: add subsystem level to trace events
Content-Disposition: inline; filename=0002-tracing-add-subsystem-level-to-trace-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If a trace point header defines TRACE_SYSTEM, then it will add the
following trace points into that event system.

If include/trace/irq_event_types.h has:

 #define TRACE_SYSTEM irq

at the top and

 #undef TRACE_SYSTEM

at the bottom, then a directory "irq" will be created in the
/debug/tracing/events directory. Inside that directory will contain the
two trace points that are defined in include/trace/irq_event_types.h.

Only adding the above to irq and not to sched, we get:

 # ls /debug/tracing/events/
irq                     sched_process_exit  sched_signal_send  sched_wakeup_new
sched_kthread_stop      sched_process_fork  sched_switch
sched_kthread_stop_ret  sched_process_free  sched_wait_task
sched_migrate_task      sched_process_wait  sched_wakeup

 # ls /debug/tracing/events/irq
irq_handler_entry  irq_handler_exit

If we add #define TRACE_SYSTEM sched to the trace/sched_event_types.h
then the rest of the trace events will be put in a sched directory
within the events directory.

I've been playing with this idea of the subsystem for a while, but
recently Tom Zanussi posted some patches to lkml that included this
method. Tom's approach was clean and got me to finally put some effort
to clean up the event trace points.

Thanks to Tom Zanussi for demonstrating how nice the subsystem
method is.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/events.c       |    4 +++
 kernel/trace/trace_events.c |   48 +++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_events.h |    2 +
 3 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/events.c b/kernel/trace/events.c
index 46e27ad..4e4e458 100644
--- a/kernel/trace/events.c
+++ b/kernel/trace/events.c
@@ -2,6 +2,10 @@
  * This is the place to register all trace points as events.
  */
 
+/* someday this needs to go in a generic header */
+#define __STR(x) #x
+#define STR(x) __STR(x)
+
 #include <trace/trace_events.h>
 
 #include "trace_events.h"
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 3bcb9df..1933220 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -345,11 +345,59 @@ static struct dentry *event_trace_events_dir(void)
 	return d_events;
 }
 
+struct event_subsystem {
+	struct list_head	list;
+	const char		*name;
+	struct dentry		*entry;
+};
+
+static LIST_HEAD(event_subsystems);
+
+static struct dentry *
+event_subsystem_dir(const char *name, struct dentry *d_events)
+{
+	struct event_subsystem *system;
+
+	/* First see if we did not already create this dir */
+	list_for_each_entry(system, &event_subsystems, list) {
+		if (strcmp(system->name, name) == 0)
+			return system->entry;
+	}
+
+	/* need to create new entry */
+	system = kmalloc(sizeof(*system), GFP_KERNEL);
+	if (!system) {
+		pr_warning("No memory to create event subsystem %s\n",
+			   name);
+		return d_events;
+	}
+
+	system->entry = debugfs_create_dir(name, d_events);
+	if (!system->entry) {
+		pr_warning("Could not create event subsystem %s\n",
+			   name);
+		kfree(system);
+		return d_events;
+	}
+
+	system->name = name;
+	list_add(&system->list, &event_subsystems);
+
+	return system->entry;
+}
+
 static int
 event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 {
 	struct dentry *entry;
 
+	/*
+	 * If the trace point header did not define TRACE_SYSTEM
+	 * then the system would be called "TRACE_SYSTEM".
+	 */
+	if (strcmp(call->system, "TRACE_SYSTEM") != 0)
+		d_events = event_subsystem_dir(call->system, d_events);
+
 	call->dir = debugfs_create_dir(call->name, d_events);
 	if (!call->dir) {
 		pr_warning("Could not create debugfs "
diff --git a/kernel/trace/trace_events.h b/kernel/trace/trace_events.h
index deb95e5..b015d7b 100644
--- a/kernel/trace/trace_events.h
+++ b/kernel/trace/trace_events.h
@@ -7,6 +7,7 @@
 
 struct ftrace_event_call {
 	char		*name;
+	char		*system;
 	struct dentry	*dir;
 	int		enabled;
 	int		(*regfunc)(void);
@@ -44,6 +45,7 @@ static struct ftrace_event_call __used					\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name 			= #call,				\
+	.system			= STR(TRACE_SYSTEM),			\
 	.regfunc		= ftrace_reg_event_##call,		\
 	.unregfunc		= ftrace_unreg_event_##call,		\
 }
-- 
1.5.6.5

-- 

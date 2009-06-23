Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbZFWSc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbZFWSc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbZFWSbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:31:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39329 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755769AbZFWSbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:31:45 -0400
Date: Tue, 23 Jun 2009 14:29:14 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
CC: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com, lizf@cn.fujitsu.com
Message-Id: <1166bdbdfd21d93fc075823118de07efa5981bf9.1245770664.git.jbaron@redhat.com>
In-Reply-To: <cover.1245770664.git.jbaron@redhat.com>
References: <cover.1245770664.git.jbaron@redhat.com>
Subject: [PATCH 6/7] V2 add syscall tracepoints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the return value of raw_init() to bail us out of creating a trace event
file.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

---
 kernel/trace/trace_events.c |   29 +++++++++++++++++++----------
 1 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index aa08be6..aa341ff 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -904,15 +904,6 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 	if (strcmp(call->system, TRACE_SYSTEM) != 0)
 		d_events = event_subsystem_dir(call->system, d_events);
 
-	if (call->raw_init) {
-		ret = call->raw_init();
-		if (ret < 0) {
-			pr_warning("Could not initialize trace point"
-				   " events/%s\n", call->name);
-			return ret;
-		}
-	}
-
 	call->dir = debugfs_create_dir(call->name, d_events);
 	if (!call->dir) {
 		pr_warning("Could not create debugfs "
@@ -1011,6 +1002,7 @@ static void trace_module_add_events(struct module *mod)
 	struct ftrace_module_file_ops *file_ops = NULL;
 	struct ftrace_event_call *call, *start, *end;
 	struct dentry *d_events;
+	int ret;
 
 	start = mod->trace_events;
 	end = mod->trace_events + mod->num_trace_events;
@@ -1026,7 +1018,15 @@ static void trace_module_add_events(struct module *mod)
 		/* The linker may leave blanks */
 		if (!call->name)
 			continue;
-
+		if (call->raw_init) {
+			ret = call->raw_init();
+			if (ret < 0) {
+				if (ret != -ENOSYS)
+					pr_warning("Could not initialize trace"
+					"point events/%s\n", call->name);
+				continue;
+			}
+		}
 		/*
 		 * This module has events, create file ops for this module
 		 * if not already done.
@@ -1163,6 +1163,15 @@ static __init int event_trace_init(void)
 		/* The linker may leave blanks */
 		if (!call->name)
 			continue;
+		if (call->raw_init) {
+			ret = call->raw_init();
+			if (ret < 0) {
+				if (ret != -ENOSYS)
+					pr_warning("Could not initialize trace"
+					"point events/%s\n", call->name);
+				continue;
+			}
+		}
 		list_add(&call->list, &ftrace_events);
 		event_create_dir(call, d_events, &ftrace_event_id_fops,
 				 &ftrace_enable_fops, &ftrace_event_filter_fops,
-- 
1.6.0.6


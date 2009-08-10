Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbZHJUzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbZHJUzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbZHJUzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:55:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60979 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232AbZHJUzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:55:01 -0400
Date: Mon, 10 Aug 2009 16:52:39 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com
Message-Id: <e7e5646cd0debf75f80c1c2bdb8db558daf380ee.1249932670.git.jbaron@redhat.com>
In-Reply-To: <cover.1249932670.git.jbaron@redhat.com>
References: <cover.1249932670.git.jbaron@redhat.com>
Subject: [PATCH 06/12] trace_event - raw_init bailout
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the return value of raw_init() to bail us out of creating a trace event
file.

Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 kernel/trace/trace_events.c |   29 +++++++++++++++++++----------
 1 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index e0cbede..f95f847 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -925,15 +925,6 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
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
@@ -1058,6 +1049,7 @@ static void trace_module_add_events(struct module *mod)
 	struct ftrace_module_file_ops *file_ops = NULL;
 	struct ftrace_event_call *call, *start, *end;
 	struct dentry *d_events;
+	int ret;
 
 	start = mod->trace_events;
 	end = mod->trace_events + mod->num_trace_events;
@@ -1073,7 +1065,15 @@ static void trace_module_add_events(struct module *mod)
 		/* The linker may leave blanks */
 		if (!call->name)
 			continue;
-
+		if (call->raw_init) {
+			ret = call->raw_init();
+			if (ret < 0) {
+				if (ret != -ENOSYS)
+					pr_warning("Could not initialize trace "
+					"point events/%s\n", call->name);
+				continue;
+			}
+		}
 		/*
 		 * This module has events, create file ops for this module
 		 * if not already done.
@@ -1225,6 +1225,15 @@ static __init int event_trace_init(void)
 		/* The linker may leave blanks */
 		if (!call->name)
 			continue;
+		if (call->raw_init) {
+			ret = call->raw_init();
+			if (ret < 0) {
+				if (ret != -ENOSYS)
+					pr_warning("Could not initialize trace "
+					"point events/%s\n", call->name);
+				continue;
+			}
+		}
 		list_add(&call->list, &ftrace_events);
 		event_create_dir(call, d_events, &ftrace_event_id_fops,
 				 &ftrace_enable_fops, &ftrace_event_filter_fops,
-- 
1.6.2.5


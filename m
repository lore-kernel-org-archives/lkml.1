Return-Path: <linux-kernel-owner+w=401wt.eu-S932228AbZHKSv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbZHKSv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932185AbZHKSv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:51:57 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:48086 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127AbZHKStT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:49:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aF+H+1DCUZsKcvSaqVR8VRqWTKIRSXoCgCtvFyDsuV+guCtkBdeE1XKigcSnFhvE5o
         32s2wEAB5vYqmuMB3YDqenko1xr7ctwV2YMRf8rDU0rKs7Bx+Mc+aTDwWaaHzH+k/l/8
         oVQaOOlFI4JbihIW1hcFM0ZQDAaaxDmBcsyqE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 07/16] tracing: Raw_init() bailout in trace event register fail case
Date: Tue, 11 Aug 2009 20:48:56 +0200
Message-Id: <1250016545-6601-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Allow the return value of raw_init() trace event callback to bail us out
of creating a trace event file, in case we fail to register our
event.

Also, we plan to return -ENOSYS for syscall events that don't match any
syscalls listed in our arch tracing syscall table, we don't want to warn
in that case, we just want this event to be invisible in debugfs and
ignored.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
1.6.2.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759838AbZANVdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759838AbZANVdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbZANVdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:33:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:2444 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbZANVda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:33:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:cc:subject;
        b=HOg8YgbmCCKJWt0dASPWa29jroAlAuuq+bbnmJa6hu8SO0ves0W/ZkMQL4/t1sNPRm
         wG7TX4lF/YstiO9FfnlCQLDw777hrOVYrp+Zs/ZMp07q3BZFYwMH2WQgHNmvUxHbbVqY
         aHdK7FqjIN4pGkUw4TP0QMtAN0liRZxQMydTs=
Message-ID: <496e5a27.1438560a.4923.ffffb67a@mx.google.com>
Date: Wed, 14 Jan 2009 13:33:27 -0800 (PST)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] tracing/function-graph-tracer: fix a regression while suspend to disk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix a crash while kernel image restore

When the function graph tracer is running and while suspend to disk, some racy
and dangerous things happen against this tracer.

The current task will save its registers including the stack pointer which
contains the return address hooked by the tracer. But the current task will
continue to enter other functions after that to save the memory, and then
it will store other return addresses, and finally loose the old depth which
matches the return address saved in the old stack (during the registers saving).

So on image restore, the code will return to wrong addresses.
And there are other things: on restore, the task will have it's "current"
pointer overwritten during registers restoring....switching from one task to
another... That would be insane to try to trace function graphs at these
stages.

This patch makes the function graph tracer listening on power events, making
it's tracing disabled for the current task (the one that performs the hibernation work)
while suspend/resume to disk, making the tracing safe during hibernation.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/ftrace.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8c1c9c0..7e9a20b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -17,6 +17,7 @@
 #include <linux/clocksource.h>
 #include <linux/kallsyms.h>
 #include <linux/seq_file.h>
+#include <linux/suspend.h>
 #include <linux/debugfs.h>
 #include <linux/hardirq.h>
 #include <linux/kthread.h>
@@ -1957,6 +1958,7 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 static atomic_t ftrace_graph_active;
+static struct notifier_block ftrace_suspend_notifier;
 
 int ftrace_graph_entry_stub(struct ftrace_graph_ent *trace)
 {
@@ -2035,6 +2037,27 @@ static int start_graph_tracing(void)
 	return ret;
 }
 
+/*
+ * Hibernation protection.
+ * The state of the current task is too much unstable during
+ * suspend/restore to disk. We want to protect against that.
+ */
+static int
+ftrace_suspend_notifier_call(struct notifier_block *bl, unsigned long state,
+							void *unused)
+{
+	switch (state) {
+	case PM_HIBERNATION_PREPARE:
+		pause_graph_tracing();
+		break;
+
+	case PM_POST_HIBERNATION:
+		unpause_graph_tracing();
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
 int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 			trace_func_graph_ent_t entryfunc)
 {
@@ -2042,6 +2065,9 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 
 	mutex_lock(&ftrace_sysctl_lock);
 
+	ftrace_suspend_notifier.notifier_call = ftrace_suspend_notifier_call;
+	register_pm_notifier(&ftrace_suspend_notifier);
+
 	atomic_inc(&ftrace_graph_active);
 	ret = start_graph_tracing();
 	if (ret) {
@@ -2067,6 +2093,7 @@ void unregister_ftrace_graph(void)
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
 	ftrace_graph_entry = ftrace_graph_entry_stub;
 	ftrace_shutdown(FTRACE_STOP_FUNC_RET);
+	unregister_pm_notifier(&ftrace_suspend_notifier);
 
 	mutex_unlock(&ftrace_sysctl_lock);
 }
-- 
1.6.0.4



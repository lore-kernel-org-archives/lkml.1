Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbZAOAFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbZAOAFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 19:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759908AbZAOADi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 19:03:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62201 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758769AbZAOADe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 19:03:34 -0500
Message-Id: <20090115000332.743671868@goodmis.org>
References: <20090115000254.519563275@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 14 Jan 2009 19:02:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/4] tracing/function-graph-tracer: fix a regression while suspend to disk
Content-Disposition: inline; filename=0004-tracing-function-graph-tracer-fix-a-regression-whil.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

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
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
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
1.5.6.5

-- 

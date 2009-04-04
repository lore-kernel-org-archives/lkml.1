Return-Path: <linux-kernel-owner+w=401wt.eu-S937526AbZDDAeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937526AbZDDAeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 20:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936719AbZDDA2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 20:28:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46034 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574AbZDDA2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 20:28:12 -0400
Message-Id: <20090404002809.395636493@goodmis.org>
References: <20090404002703.627460459@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 20:27:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 07/10] function-graph: use int instead of atomic for ftrace_graph_active
Content-Disposition: inline; filename=0007-function-graph-use-int-instead-of-atomic-for-ftrace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: cleanup

The variable ftrace_graph_active is only modified under the
ftrace_lock mutex, thus an atomic is not necessary for modification.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index dfc969f..83dc994 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2519,7 +2519,7 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
-static atomic_t ftrace_graph_active;
+static int ftrace_graph_active;
 static struct notifier_block ftrace_suspend_notifier;
 
 int ftrace_graph_entry_stub(struct ftrace_graph_ent *trace)
@@ -2671,7 +2671,7 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	mutex_lock(&ftrace_lock);
 
 	/* we currently allow only one tracer registered at a time */
-	if (atomic_read(&ftrace_graph_active)) {
+	if (ftrace_graph_active) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -2679,10 +2679,10 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	ftrace_suspend_notifier.notifier_call = ftrace_suspend_notifier_call;
 	register_pm_notifier(&ftrace_suspend_notifier);
 
-	atomic_inc(&ftrace_graph_active);
+	ftrace_graph_active++;
 	ret = start_graph_tracing();
 	if (ret) {
-		atomic_dec(&ftrace_graph_active);
+		ftrace_graph_active--;
 		goto out;
 	}
 
@@ -2700,7 +2700,7 @@ void unregister_ftrace_graph(void)
 {
 	mutex_lock(&ftrace_lock);
 
-	atomic_dec(&ftrace_graph_active);
+	ftrace_graph_active--;
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch);
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
 	ftrace_graph_entry = ftrace_graph_entry_stub;
@@ -2713,7 +2713,7 @@ void unregister_ftrace_graph(void)
 /* Allocate a return stack for newly created task */
 void ftrace_graph_init_task(struct task_struct *t)
 {
-	if (atomic_read(&ftrace_graph_active)) {
+	if (ftrace_graph_active) {
 		t->ret_stack = kmalloc(FTRACE_RETFUNC_DEPTH
 				* sizeof(struct ftrace_ret_stack),
 				GFP_KERNEL);
-- 
1.6.2.1

-- 

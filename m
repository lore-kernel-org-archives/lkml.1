Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbYLCEvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbYLCEvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbYLCEuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:50:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63711 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYLCEup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:50:45 -0500
Message-Id: <20081203045043.362050477@goodmis.org>
References: <20081203045001.367443457@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Dec 2008 23:50:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/5] ftrace: add ftrace_graph_stop
Content-Disposition: inline; filename=0001-ftrace-add-ftrace_graph_stop.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: new ftrace_graph_stop function

While developing more features of function graph, I hit a bug that
caused the WARN_ON to trigger in the prepare_ftrace_return function.
Well, it was hard for me to find out that was happening because the
bug would not print, it would just cause a hard lockup or reboot.
The reason is that it is not safe to call printk from this function.

Looking further, I also found that it calls unregister_ftrace_graph,
which grabs a mutex and calls kstop machine. This would definitely
lock the box up if it were to trigger.

This patch adds a fast and safe ftrace_graph_stop() which will
stop the function tracer. Then it is safe to call the WARN ON.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c |   10 ++++++----
 include/linux/ftrace.h   |    2 ++
 kernel/trace/ftrace.c    |    5 +++++
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 1a5b8f8..adba8e9 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -484,14 +484,16 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 		: "memory"
 	);
 
-	if (WARN_ON(faulted)) {
-		unregister_ftrace_graph();
+	if (unlikely(faulted)) {
+		ftrace_graph_stop();
+		WARN_ON(1);
 		return;
 	}
 
-	if (WARN_ON(!__kernel_text_address(old))) {
-		unregister_ftrace_graph();
+	if (unlikely(!__kernel_text_address(old))) {
+		ftrace_graph_stop();
 		*parent = old;
+		WARN_ON(1);
 		return;
 	}
 
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index afba918..58ca1c3 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -376,6 +376,8 @@ typedef void (*trace_func_graph_ent_t)(struct ftrace_graph_ent *); /* entry */
 extern int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 				trace_func_graph_ent_t entryfunc);
 
+extern void ftrace_graph_stop(void);
+
 /* The current handlers in use */
 extern trace_func_graph_ret_t ftrace_graph_return;
 extern trace_func_graph_ent_t ftrace_graph_entry;
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2e78628..a44af05 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1769,5 +1769,10 @@ void ftrace_graph_exit_task(struct task_struct *t)
 
 	kfree(ret_stack);
 }
+
+void ftrace_graph_stop(void)
+{
+	ftrace_stop();
+}
 #endif
 
-- 
1.5.6.5

-- 

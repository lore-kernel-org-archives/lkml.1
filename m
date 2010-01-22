Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672Ab0AVBRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab0AVBRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343Ab0AVBQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:16:43 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53143 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab0AVBQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:16:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QLZOJmwC03Es1U/+LKLpXivuUUf0s9kJa8hSNWDJTu6d2pK2GuQSJcB2pzuX38Na/i
         2ajJo4FjiVgclTsyZmJ9bXYtwBnKAy1RjJZDTKniZIXwJX3rxm1SZIYHHexcyUCjmrDj
         yAKY8QwDCQD8tSyhtnTBSkHbVVzgtv8a9jEqw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC PATCH 09/10] tracing: Use the hashlist for graph function
Date: Fri, 22 Jan 2010 02:16:21 +0100
Message-Id: <1264122982-1553-10-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we set a filter to start tracing from a given function in
the function graph tracer, the filter is stored in a linear array.

It doesn't scale very well, we even limited the number of such
functions to 32.

Now that we have a hashlist of functions, lets put a field inside
each function node so that we can check if a function is one of
these filters using the hashlist, not a linear array.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/trace/ftrace.c                |   61 ++++++++++++++++++++++++++++++++++
 kernel/trace/functions_hlist.c       |   29 ++++++++++++++++
 kernel/trace/functions_hlist.h       |    2 +
 kernel/trace/trace.h                 |   21 +-----------
 kernel/trace/trace_functions_graph.c |   41 ++++++++++++++++++++++-
 5 files changed, 133 insertions(+), 21 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 027743c..d719078 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2193,6 +2193,67 @@ static DEFINE_MUTEX(graph_lock);
 int ftrace_graph_count;
 unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
 
+static int
+change_graph_function_hlist(unsigned long ip, int val, struct func_hlist *hlist)
+{
+	struct func_node *rec;
+
+	rec = function_find_hlist_node(hlist, ip);
+	if (!rec) {
+		rec = function_hlist_record_alloc(hlist, ip);
+		if (!rec)
+			return 1;
+	}
+
+	rec->graph_start = val;
+
+	return 0;
+}
+
+static int change_graph_function(unsigned long ip, int val)
+{
+	int ret;
+	int cpu;
+	struct func_hlist *hlist;
+
+	for_each_online_cpu(cpu) {
+		hlist = &per_cpu(func_hlist_cpu, cpu);
+		ret = change_graph_function_hlist(ip, val, hlist);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static void clear_graph_functions(void)
+{
+	int i;
+
+	for (i = 0; i < ftrace_graph_count; i++)
+		change_graph_function(ftrace_graph_funcs[i], 0);
+}
+
+int set_graph_functions(void)
+{
+	int i;
+	int ret = 0;
+
+	mutex_lock(&graph_lock);
+
+	for (i = 0; i < ftrace_graph_count; i++) {
+		ret = change_graph_function(ftrace_graph_funcs[i], 1);
+		if (ret) {
+			clear_graph_functions();
+			break;
+		}
+	}
+
+	mutex_unlock(&graph_lock);
+
+	return 0;
+}
+
 static void *
 __g_next(struct seq_file *m, loff_t *pos)
 {
diff --git a/kernel/trace/functions_hlist.c b/kernel/trace/functions_hlist.c
index d682213..7a60265 100644
--- a/kernel/trace/functions_hlist.c
+++ b/kernel/trace/functions_hlist.c
@@ -54,6 +54,35 @@ void function_hlist_reset_profile(void)
 		function_hlist_reset_profile_cpu(cpu);
 }
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+static void function_hlist_reset_graph_cpu(int cpu)
+{
+	struct func_hlist *hlist = &per_cpu(func_hlist_cpu, cpu);
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct func_node *rec;
+	int i;
+
+	for (i = 0; i < FUNCTIONS_HLIST_SIZE; i++) {
+		head = &hlist->hash[i];
+
+		if (hlist_empty(head))
+			continue;
+
+		hlist_for_each_entry(rec, node, head, node)
+			rec->graph_start = 0;
+	}
+}
+
+void function_hlist_reset_graph(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		function_hlist_reset_graph_cpu(cpu);
+}
+#endif
+
 static void __function_hlist_release(struct func_hlist *hlist)
 {
 	struct func_hlist_page *pg = hlist->start;
diff --git a/kernel/trace/functions_hlist.h b/kernel/trace/functions_hlist.h
index a4655c7..39d89b4 100644
--- a/kernel/trace/functions_hlist.h
+++ b/kernel/trace/functions_hlist.h
@@ -8,6 +8,7 @@ struct func_node {
 	unsigned long			counter;
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	unsigned long long		time;
+	int				graph_start;
 #endif
 };
 
@@ -38,3 +39,4 @@ function_hlist_record_alloc(struct func_hlist *hlist, unsigned long ip);
 int get_function_hlist(void);
 void put_function_hlist(void);
 void function_hlist_reset_profile(void);
+void function_hlist_reset_graph(void);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index ce077fb..ff0b01a 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -499,26 +499,7 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s);
 #define FTRACE_GRAPH_MAX_FUNCS		32
 extern int ftrace_graph_count;
 extern unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS];
-
-static inline int ftrace_graph_addr(unsigned long addr)
-{
-	int i;
-
-	if (!ftrace_graph_count)
-		return 1;
-
-	for (i = 0; i < ftrace_graph_count; i++) {
-		if (addr == ftrace_graph_funcs[i])
-			return 1;
-	}
-
-	return 0;
-}
-#else
-static inline int ftrace_graph_addr(unsigned long addr)
-{
-	return 1;
-}
+int set_graph_functions(void);
 #endif /* CONFIG_DYNAMIC_FTRACE */
 #else /* CONFIG_FUNCTION_GRAPH_TRACER */
 static inline enum print_line_t
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 616b135..da24add 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -13,6 +13,7 @@
 
 #include "trace.h"
 #include "trace_output.h"
+#include "functions_hlist.h"
 
 struct fgraph_cpu_data {
 	pid_t		last_pid;
@@ -202,6 +203,33 @@ static int __trace_graph_entry(struct trace_array *tr,
 	return 1;
 }
 
+static inline int ftrace_graph_addr(unsigned long addr)
+{
+	struct func_node *rec;
+	struct func_hlist *hlist;
+
+	if (!ftrace_graph_count)
+		return 0;
+
+	hlist = &__get_cpu_var(func_hlist_cpu);
+
+	rec = function_find_hlist_node(hlist, addr);
+	if (!rec) {
+		/*
+		 * TODO: send a retrieval error event
+		 * to keep track of this.
+		 */
+		rec = function_hlist_record_alloc(hlist, addr);
+		if (!rec)
+			return 0;
+	}
+
+	if (rec->graph_start)
+		return 1;
+
+	return 0;
+}
+
 int trace_graph_entry(struct ftrace_graph_ent *trace)
 {
 	struct trace_array *tr = graph_array;
@@ -294,10 +322,20 @@ static int graph_trace_init(struct trace_array *tr)
 	int ret;
 
 	set_graph_array(tr);
+	ret = get_function_hlist();
+	if (ret)
+		return ret;
+
+	function_hlist_reset_graph();
+	set_graph_functions();
+
 	ret = register_ftrace_graph(&trace_graph_return,
 				    &trace_graph_entry);
-	if (ret)
+	if (ret) {
+		put_function_hlist();
 		return ret;
+	}
+
 	tracing_start_cmdline_record();
 
 	return 0;
@@ -307,6 +345,7 @@ static void graph_trace_reset(struct trace_array *tr)
 {
 	tracing_stop_cmdline_record();
 	unregister_ftrace_graph();
+	put_function_hlist();
 }
 
 static int max_bytes_for_cpu;
-- 
1.6.2.3


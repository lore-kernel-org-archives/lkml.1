Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259Ab0AVBTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab0AVBTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370Ab0AVBSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:18:54 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:57482 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab0AVBQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:16:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cAWV4lrtxomYLaQj9qh4Wz2n7ff5DThAkApzL0Hw1eCwYr5wmSIftFNiOy5gi70Iam
         UCLDJQ/nkN8HiBfGZspNqC8TlFXihkgUfqMyy7Yttntuahj/71LHAiTlZV0nNM6v38aB
         Bgwcwn4Xxnd7XFfy7lyUv06GOu6adIM7GPweo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC PATCH 01/10] ftrace: Generalize the function hashlist from function profiler
Date: Fri, 22 Jan 2010 02:16:13 +0100
Message-Id: <1264122982-1553-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract and generalize the function hashlist in use by the function
profiler.

Having a general purpose hashlist for kernel functions will help
multiplexing dynamic tracing parameters for parallel users of the
function and function graph tracers. This can help tracking who is
tracing which functions among concurrent tracers.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/trace/Makefile          |    1 +
 kernel/trace/ftrace.c          |  289 ++++-----------------------------------
 kernel/trace/functions_hlist.c |  217 ++++++++++++++++++++++++++++++
 kernel/trace/functions_hlist.h |   38 ++++++
 4 files changed, 286 insertions(+), 259 deletions(-)
 create mode 100644 kernel/trace/functions_hlist.c
 create mode 100644 kernel/trace/functions_hlist.h

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index d00c6fe..f9804f2 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -58,5 +58,6 @@ obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
 obj-$(CONFIG_KSYM_TRACER) += trace_ksym.o
 obj-$(CONFIG_EVENT_TRACING) += power-traces.o
+obj-$(CONFIG_FUNCTION_PROFILER) += functions_hlist.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1e6640f..c050ce3 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -27,13 +27,13 @@
 #include <linux/sysctl.h>
 #include <linux/ctype.h>
 #include <linux/list.h>
-#include <linux/hash.h>
 
 #include <trace/events/sched.h>
 
 #include <asm/ftrace.h>
 #include <asm/setup.h>
 
+#include "functions_hlist.h"
 #include "trace_output.h"
 #include "trace_stat.h"
 
@@ -258,52 +258,19 @@ static void ftrace_update_pid_func(void)
 }
 
 #ifdef CONFIG_FUNCTION_PROFILER
-struct ftrace_profile {
-	struct hlist_node		node;
-	unsigned long			ip;
-	unsigned long			counter;
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	unsigned long long		time;
-#endif
-};
-
-struct ftrace_profile_page {
-	struct ftrace_profile_page	*next;
-	unsigned long			index;
-	struct ftrace_profile		records[];
-};
-
-struct ftrace_profile_stat {
-	atomic_t			disabled;
-	struct hlist_head		*hash;
-	struct ftrace_profile_page	*pages;
-	struct ftrace_profile_page	*start;
-	struct tracer_stat		stat;
-};
-
-#define PROFILE_RECORDS_SIZE						\
-	(PAGE_SIZE - offsetof(struct ftrace_profile_page, records))
 
-#define PROFILES_PER_PAGE					\
-	(PROFILE_RECORDS_SIZE / sizeof(struct ftrace_profile))
-
-static int ftrace_profile_bits __read_mostly;
 static int ftrace_profile_enabled __read_mostly;
 
 /* ftrace_profile_lock - synchronize the enable and disable of the profiler */
 static DEFINE_MUTEX(ftrace_profile_lock);
 
-static DEFINE_PER_CPU(struct ftrace_profile_stat, ftrace_profile_stats);
-
-#define FTRACE_PROFILE_HASH_SIZE 1024 /* must be power of 2 */
-
 static void *
 function_stat_next(void *v, int idx)
 {
-	struct ftrace_profile *rec = v;
-	struct ftrace_profile_page *pg;
+	struct func_node *rec = v;
+	struct func_hlist_page *pg;
 
-	pg = (struct ftrace_profile_page *)((unsigned long)rec & PAGE_MASK);
+	pg = (struct func_hlist_page *)((unsigned long)rec & PAGE_MASK);
 
  again:
 	if (idx != 0)
@@ -323,21 +290,21 @@ function_stat_next(void *v, int idx)
 
 static void *function_stat_start(struct tracer_stat *trace)
 {
-	struct ftrace_profile_stat *stat =
-		container_of(trace, struct ftrace_profile_stat, stat);
+	struct func_hlist *hlist =
+		container_of(trace, struct func_hlist, stat);
 
-	if (!stat || !stat->start)
+	if (!hlist || !hlist->start)
 		return NULL;
 
-	return function_stat_next(&stat->start->records[0], 0);
+	return function_stat_next(&hlist->start->records[0], 0);
 }
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 /* function graph compares on total time */
 static int function_stat_cmp(void *p1, void *p2)
 {
-	struct ftrace_profile *a = p1;
-	struct ftrace_profile *b = p2;
+	struct func_node *a = p1;
+	struct func_node *b = p2;
 
 	if (a->time < b->time)
 		return -1;
@@ -350,8 +317,8 @@ static int function_stat_cmp(void *p1, void *p2)
 /* not function graph compares against hits */
 static int function_stat_cmp(void *p1, void *p2)
 {
-	struct ftrace_profile *a = p1;
-	struct ftrace_profile *b = p2;
+	struct func_node *a = p1;
+	struct func_node *b = p2;
 
 	if (a->counter < b->counter)
 		return -1;
@@ -378,7 +345,7 @@ static int function_stat_headers(struct seq_file *m)
 
 static int function_stat_show(struct seq_file *m, void *v)
 {
-	struct ftrace_profile *rec = v;
+	struct func_node *rec = v;
 	char str[KSYM_SYMBOL_LEN];
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	static DEFINE_MUTEX(mutex);
@@ -407,207 +374,11 @@ static int function_stat_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static void ftrace_profile_reset(struct ftrace_profile_stat *stat)
-{
-	struct ftrace_profile_page *pg;
-
-	pg = stat->pages = stat->start;
-
-	while (pg) {
-		memset(pg->records, 0, PROFILE_RECORDS_SIZE);
-		pg->index = 0;
-		pg = pg->next;
-	}
-
-	memset(stat->hash, 0,
-	       FTRACE_PROFILE_HASH_SIZE * sizeof(struct hlist_head));
-}
-
-int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
-{
-	struct ftrace_profile_page *pg;
-	int functions;
-	int pages;
-	int i;
-
-	/* If we already allocated, do nothing */
-	if (stat->pages)
-		return 0;
-
-	stat->pages = (void *)get_zeroed_page(GFP_KERNEL);
-	if (!stat->pages)
-		return -ENOMEM;
-
-#ifdef CONFIG_DYNAMIC_FTRACE
-	functions = ftrace_update_tot_cnt;
-#else
-	/*
-	 * We do not know the number of functions that exist because
-	 * dynamic tracing is what counts them. With past experience
-	 * we have around 20K functions. That should be more than enough.
-	 * It is highly unlikely we will execute every function in
-	 * the kernel.
-	 */
-	functions = 20000;
-#endif
-
-	pg = stat->start = stat->pages;
-
-	pages = DIV_ROUND_UP(functions, PROFILES_PER_PAGE);
-
-	for (i = 0; i < pages; i++) {
-		pg->next = (void *)get_zeroed_page(GFP_KERNEL);
-		if (!pg->next)
-			goto out_free;
-		pg = pg->next;
-	}
-
-	return 0;
-
- out_free:
-	pg = stat->start;
-	while (pg) {
-		unsigned long tmp = (unsigned long)pg;
-
-		pg = pg->next;
-		free_page(tmp);
-	}
-
-	free_page((unsigned long)stat->pages);
-	stat->pages = NULL;
-	stat->start = NULL;
-
-	return -ENOMEM;
-}
-
-static int ftrace_profile_init_cpu(int cpu)
-{
-	struct ftrace_profile_stat *stat;
-	int size;
-
-	stat = &per_cpu(ftrace_profile_stats, cpu);
-
-	if (stat->hash) {
-		/* If the profile is already created, simply reset it */
-		ftrace_profile_reset(stat);
-		return 0;
-	}
-
-	/*
-	 * We are profiling all functions, but usually only a few thousand
-	 * functions are hit. We'll make a hash of 1024 items.
-	 */
-	size = FTRACE_PROFILE_HASH_SIZE;
-
-	stat->hash = kzalloc(sizeof(struct hlist_head) * size, GFP_KERNEL);
-
-	if (!stat->hash)
-		return -ENOMEM;
-
-	if (!ftrace_profile_bits) {
-		size--;
-
-		for (; size; size >>= 1)
-			ftrace_profile_bits++;
-	}
-
-	/* Preallocate the function profiling pages */
-	if (ftrace_profile_pages_init(stat) < 0) {
-		kfree(stat->hash);
-		stat->hash = NULL;
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static int ftrace_profile_init(void)
-{
-	int cpu;
-	int ret = 0;
-
-	for_each_online_cpu(cpu) {
-		ret = ftrace_profile_init_cpu(cpu);
-		if (ret)
-			break;
-	}
-
-	return ret;
-}
-
-/* interrupts must be disabled */
-static struct ftrace_profile *
-ftrace_find_profiled_func(struct ftrace_profile_stat *stat, unsigned long ip)
-{
-	struct ftrace_profile *rec;
-	struct hlist_head *hhd;
-	struct hlist_node *n;
-	unsigned long key;
-
-	key = hash_long(ip, ftrace_profile_bits);
-	hhd = &stat->hash[key];
-
-	if (hlist_empty(hhd))
-		return NULL;
-
-	hlist_for_each_entry_rcu(rec, n, hhd, node) {
-		if (rec->ip == ip)
-			return rec;
-	}
-
-	return NULL;
-}
-
-static void ftrace_add_profile(struct ftrace_profile_stat *stat,
-			       struct ftrace_profile *rec)
-{
-	unsigned long key;
-
-	key = hash_long(rec->ip, ftrace_profile_bits);
-	hlist_add_head_rcu(&rec->node, &stat->hash[key]);
-}
-
-/*
- * The memory is already allocated, this simply finds a new record to use.
- */
-static struct ftrace_profile *
-ftrace_profile_alloc(struct ftrace_profile_stat *stat, unsigned long ip)
-{
-	struct ftrace_profile *rec = NULL;
-
-	/* prevent recursion (from NMIs) */
-	if (atomic_inc_return(&stat->disabled) != 1)
-		goto out;
-
-	/*
-	 * Try to find the function again since an NMI
-	 * could have added it
-	 */
-	rec = ftrace_find_profiled_func(stat, ip);
-	if (rec)
-		goto out;
-
-	if (stat->pages->index == PROFILES_PER_PAGE) {
-		if (!stat->pages->next)
-			goto out;
-		stat->pages = stat->pages->next;
-	}
-
-	rec = &stat->pages->records[stat->pages->index++];
-	rec->ip = ip;
-	ftrace_add_profile(stat, rec);
-
- out:
-	atomic_dec(&stat->disabled);
-
-	return rec;
-}
-
 static void
 function_profile_call(unsigned long ip, unsigned long parent_ip)
 {
-	struct ftrace_profile_stat *stat;
-	struct ftrace_profile *rec;
+	struct func_hlist *hlist;
+	struct func_node *rec;
 	unsigned long flags;
 
 	if (!ftrace_profile_enabled)
@@ -615,13 +386,13 @@ function_profile_call(unsigned long ip, unsigned long parent_ip)
 
 	local_irq_save(flags);
 
-	stat = &__get_cpu_var(ftrace_profile_stats);
-	if (!stat->hash || !ftrace_profile_enabled)
+	hlist = &__get_cpu_var(func_hlist_cpu);
+	if (!hlist->hash || !ftrace_profile_enabled)
 		goto out;
 
-	rec = ftrace_find_profiled_func(stat, ip);
+	rec = function_find_hlist_node(hlist, ip);
 	if (!rec) {
-		rec = ftrace_profile_alloc(stat, ip);
+		rec = function_hlist_record_alloc(hlist, ip);
 		if (!rec)
 			goto out;
 	}
@@ -640,14 +411,14 @@ static int profile_graph_entry(struct ftrace_graph_ent *trace)
 
 static void profile_graph_return(struct ftrace_graph_ret *trace)
 {
-	struct ftrace_profile_stat *stat;
+	struct func_hlist *hlist;
 	unsigned long long calltime;
-	struct ftrace_profile *rec;
+	struct func_node *rec;
 	unsigned long flags;
 
 	local_irq_save(flags);
-	stat = &__get_cpu_var(ftrace_profile_stats);
-	if (!stat->hash || !ftrace_profile_enabled)
+	hlist = &__get_cpu_var(func_hlist_cpu);
+	if (!hlist->hash || !ftrace_profile_enabled)
 		goto out;
 
 	calltime = trace->rettime - trace->calltime;
@@ -667,7 +438,7 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
 			calltime = 0;
 	}
 
-	rec = ftrace_find_profiled_func(stat, trace->func);
+	rec = function_find_hlist_node(hlist, trace->func);
 	if (rec)
 		rec->time += calltime;
 
@@ -727,7 +498,7 @@ ftrace_profile_write(struct file *filp, const char __user *ubuf,
 	mutex_lock(&ftrace_profile_lock);
 	if (ftrace_profile_enabled ^ val) {
 		if (val) {
-			ret = ftrace_profile_init();
+			ret = function_hlist_init();
 			if (ret < 0) {
 				cnt = ret;
 				goto out;
@@ -785,14 +556,14 @@ static struct tracer_stat function_stats __initdata = {
 
 static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
 {
-	struct ftrace_profile_stat *stat;
+	struct func_hlist *hlist;
 	struct dentry *entry;
 	char *name;
 	int ret;
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
-		stat = &per_cpu(ftrace_profile_stats, cpu);
+		hlist = &per_cpu(func_hlist_cpu, cpu);
 
 		/* allocate enough for function name + cpu number */
 		name = kmalloc(32, GFP_KERNEL);
@@ -806,10 +577,10 @@ static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
 			     cpu);
 			return;
 		}
-		stat->stat = function_stats;
+		hlist->stat = function_stats;
 		snprintf(name, 32, "function%d", cpu);
-		stat->stat.name = name;
-		ret = register_stat_tracer(&stat->stat);
+		hlist->stat.name = name;
+		ret = register_stat_tracer(&hlist->stat);
 		if (ret) {
 			WARN(1,
 			     "Could not register function stat for cpu %d\n",
diff --git a/kernel/trace/functions_hlist.c b/kernel/trace/functions_hlist.c
new file mode 100644
index 0000000..37804c4
--- /dev/null
+++ b/kernel/trace/functions_hlist.c
@@ -0,0 +1,217 @@
+/*
+ * Copyright (C) 2007-2010 Steven Rostedt <srostedt@redhat.com>
+ *
+ * Extracted from function profiling in ftrace.c, generalize naming:
+ * 	Copyright (C) 2010 Frederic Weisbecker <fweisbec@gmail.com>
+ */
+
+#include <linux/gfp.h>
+#include "functions_hlist.h"
+#include "trace.h"
+
+#define FUNCTIONS_RECORDS_SIZE						\
+	(PAGE_SIZE - offsetof(struct func_hlist_page, records))
+
+#define RECORDS_PER_PAGE					\
+	(FUNCTIONS_RECORDS_SIZE / sizeof(struct func_node))
+
+#define FUNCTIONS_HLIST_SIZE 1024 /* must be power of 2 */
+
+DEFINE_PER_CPU(struct func_hlist, func_hlist_cpu);
+
+int functions_hash_bits __read_mostly;
+
+static void function_hlist_reset(struct func_hlist *hlist)
+{
+	struct func_hlist_page *pg;
+
+	pg = hlist->pages = hlist->start;
+
+	while (pg) {
+		memset(pg->records, 0, FUNCTIONS_RECORDS_SIZE);
+		pg->index = 0;
+		pg = pg->next;
+	}
+
+	memset(hlist->hash, 0,
+	       FUNCTIONS_HLIST_SIZE * sizeof(struct hlist_head));
+}
+
+static int function_hlist_pages_init(struct func_hlist *hlist)
+{
+	struct func_hlist_page *pg;
+	int functions;
+	int pages;
+	int i;
+
+	/* If we already allocated, do nothing */
+	if (hlist->pages)
+		return 0;
+
+	hlist->pages = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!hlist->pages)
+		return -ENOMEM;
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+	functions = ftrace_update_tot_cnt;
+#else
+	/*
+	 * We do not know the number of functions that exist because
+	 * dynamic tracing is what counts them. With past experience
+	 * we have around 20K functions. That should be more than enough.
+	 * It is highly unlikely we will execute every function in
+	 * the kernel.
+	 */
+	functions = 20000;
+#endif
+
+	pg = hlist->start = hlist->pages;
+
+	pages = DIV_ROUND_UP(functions, RECORDS_PER_PAGE);
+
+	for (i = 0; i < pages; i++) {
+		pg->next = (void *)get_zeroed_page(GFP_KERNEL);
+		if (!pg->next)
+			goto out_free;
+		pg = pg->next;
+	}
+
+	return 0;
+
+ out_free:
+	pg = hlist->start;
+	while (pg) {
+		unsigned long tmp = (unsigned long)pg;
+
+		pg = pg->next;
+		free_page(tmp);
+	}
+
+	free_page((unsigned long)hlist->pages);
+	hlist->pages = NULL;
+	hlist->start = NULL;
+
+	return -ENOMEM;
+}
+
+static int function_hlist_init_cpu(int cpu)
+{
+	struct func_hlist *hlist;
+	int size;
+
+	hlist = &per_cpu(func_hlist_cpu, cpu);
+
+	if (hlist->hash) {
+		/* If the profile is already created, simply reset it */
+		function_hlist_reset(hlist);
+		return 0;
+	}
+
+	/*
+	 * We are profiling all functions, but usually only a few thousand
+	 * functions are hit. We'll make a hash of 1024 items.
+	 */
+	size = FUNCTIONS_HLIST_SIZE;
+
+	hlist->hash = kzalloc(sizeof(struct hlist_head) * size, GFP_KERNEL);
+
+	if (!hlist->hash)
+		return -ENOMEM;
+
+	if (!functions_hash_bits) {
+		size--;
+
+		for (; size; size >>= 1)
+			functions_hash_bits++;
+	}
+
+	/* Preallocate the function profiling pages */
+	if (function_hlist_pages_init(hlist) < 0) {
+		kfree(hlist->hash);
+		hlist->hash = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+int function_hlist_init(void)
+{
+	int cpu;
+	int ret = 0;
+
+	for_each_online_cpu(cpu) {
+		ret = function_hlist_init_cpu(cpu);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+struct func_node *
+function_find_hlist_node(struct func_hlist *hlist, unsigned long ip)
+{
+	struct func_node *rec;
+	struct hlist_head *hhd;
+	struct hlist_node *n;
+	unsigned long key;
+
+	key = hash_long(ip, functions_hash_bits);
+	hhd = &hlist->hash[key];
+
+	if (hlist_empty(hhd))
+		return NULL;
+
+	hlist_for_each_entry_rcu(rec, n, hhd, node) {
+		if (rec->ip == ip)
+			return rec;
+	}
+
+	return NULL;
+}
+
+static void function_hlist_add(struct func_hlist *hlist,
+			       struct func_node *rec)
+{
+	unsigned long key;
+
+	key = hash_long(rec->ip, functions_hash_bits);
+	hlist_add_head_rcu(&rec->node, &hlist->hash[key]);
+}
+
+/*
+ * The memory is already allocated, this simply finds a new record to use.
+ */
+struct func_node *
+function_hlist_record_alloc(struct func_hlist *hlist, unsigned long ip)
+{
+	struct func_node *rec = NULL;
+
+	/* prevent recursion (from NMIs) */
+	if (atomic_inc_return(&hlist->disabled) != 1)
+		goto out;
+
+	/*
+	 * Try to find the function again since an NMI
+	 * could have added it
+	 */
+	rec = function_find_hlist_node(hlist, ip);
+	if (rec)
+		goto out;
+
+	if (hlist->pages->index == RECORDS_PER_PAGE) {
+		if (!hlist->pages->next)
+			goto out;
+		hlist->pages = hlist->pages->next;
+	}
+
+	rec = &hlist->pages->records[hlist->pages->index++];
+	rec->ip = ip;
+	function_hlist_add(hlist, rec);
+
+ out:
+	atomic_dec(&hlist->disabled);
+
+	return rec;
+}
diff --git a/kernel/trace/functions_hlist.h b/kernel/trace/functions_hlist.h
new file mode 100644
index 0000000..3f4e485
--- /dev/null
+++ b/kernel/trace/functions_hlist.h
@@ -0,0 +1,38 @@
+#include <linux/hash.h>
+#include <linux/list.h>
+#include "trace_stat.h"
+
+struct func_node {
+	struct hlist_node		node;
+	unsigned long			ip;
+	unsigned long			counter;
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	unsigned long long		time;
+#endif
+};
+
+struct func_hlist_page {
+	struct func_hlist_page		*next;
+	unsigned long			index;
+	struct func_node		records[];
+};
+
+struct func_hlist {
+	atomic_t			disabled;
+	struct hlist_head		*hash;
+	struct func_hlist_page		*pages;
+	struct func_hlist_page		*start;
+	struct tracer_stat		stat;
+};
+
+DECLARE_PER_CPU(struct func_hlist, func_hlist_cpu);
+
+extern int functions_hash_bits;
+
+struct func_node *
+function_find_hlist_node(struct func_hlist *hlist, unsigned long ip);
+
+struct func_node *
+function_hlist_record_alloc(struct func_hlist *hlist, unsigned long ip);
+
+int function_hlist_init(void);
-- 
1.6.2.3


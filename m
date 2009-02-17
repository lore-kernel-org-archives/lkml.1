Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZBQFSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZBQFSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 00:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZBQFOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 00:14:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53253 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbZBQFOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 00:14:10 -0500
Message-Id: <20090217051407.644936411@goodmis.org>
References: <20090217051227.957864159@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 00:12:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 13/15] ftrace: show selected functions in set_ftrace_filter
Content-Disposition: inline; filename=0013-ftrace-show-selected-functions-in-set_ftrace_filter.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds output to show what functions have tracer hooks
attached to them.

  # echo 'sys_open:traceon:4' > /debug/tracing/set_ftrace_filter
  # cat set_ftrace_filter

 #### all functions enabled ####
 sys_open:ftrace_traceon:0000000000000004

  # echo 'do_fork:traceoff:' > set_ftrace_filter
  # cat set_ftrace_filter

 #### all functions enabled ####
 sys_open:ftrace_traceon:0000000000000002
 do_fork:ftrace_traceoff:ffffffffffffffff

Note the 4 changed to a 2. This is because The code was executed twice
since the traceoff was added. If a cat is done again:

 #### all functions enabled ####
 sys_open:ftrace_traceon
 do_fork:ftrace_traceoff:ffffffffffffffff

The number disappears. That is because it will not print a NULL.

Callbacks to allow the tracer to pretty print will be implemented soon.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |  123 +++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 103 insertions(+), 20 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0b80e32..1e05884 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -45,14 +45,14 @@
 			ftrace_kill();		\
 	} while (0)
 
+/* hash bits for specific function selection */
+#define FTRACE_HASH_BITS 7
+#define FTRACE_FUNC_HASHSIZE (1 << FTRACE_HASH_BITS)
+
 /* ftrace_enabled is a method to turn ftrace on or off */
 int ftrace_enabled __read_mostly;
 static int last_ftrace_enabled;
 
-/* set when tracing only a pid */
-struct pid *ftrace_pid_trace;
-static struct pid * const ftrace_swapper_pid = &init_struct_pid;
-
 /* Quick disabling of function tracer. */
 int function_trace_stop;
 
@@ -248,6 +248,21 @@ static void ftrace_update_pid_func(void)
 # error Dynamic ftrace depends on MCOUNT_RECORD
 #endif
 
+/* set when tracing only a pid */
+struct pid *ftrace_pid_trace;
+static struct pid * const ftrace_swapper_pid = &init_struct_pid;
+static struct hlist_head ftrace_func_hash[FTRACE_FUNC_HASHSIZE] __read_mostly;
+
+struct ftrace_func_hook {
+	struct hlist_node	node;
+	struct ftrace_hook_ops	*ops;
+	unsigned long		flags;
+	unsigned long		ip;
+	void			*data;
+	struct rcu_head		rcu;
+};
+
+
 enum {
 	FTRACE_ENABLE_CALLS		= (1 << 0),
 	FTRACE_DISABLE_CALLS		= (1 << 1),
@@ -750,12 +765,14 @@ enum {
 	FTRACE_ITER_NOTRACE	= (1 << 2),
 	FTRACE_ITER_FAILURES	= (1 << 3),
 	FTRACE_ITER_PRINTALL	= (1 << 4),
+	FTRACE_ITER_HASH	= (1 << 5),
 };
 
 #define FTRACE_BUFF_MAX (KSYM_SYMBOL_LEN+4) /* room for wildcards */
 
 struct ftrace_iterator {
 	struct ftrace_page	*pg;
+	int			hidx;
 	int			idx;
 	unsigned		flags;
 	unsigned char		buffer[FTRACE_BUFF_MAX+1];
@@ -764,17 +781,86 @@ struct ftrace_iterator {
 };
 
 static void *
+t_hash_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct ftrace_iterator *iter = m->private;
+	struct hlist_node *hnd = v;
+	struct hlist_head *hhd;
+
+	WARN_ON(!(iter->flags & FTRACE_ITER_HASH));
+
+	(*pos)++;
+
+ retry:
+	if (iter->hidx >= FTRACE_FUNC_HASHSIZE)
+		return NULL;
+
+	hhd = &ftrace_func_hash[iter->hidx];
+
+	if (hlist_empty(hhd)) {
+		iter->hidx++;
+		hnd = NULL;
+		goto retry;
+	}
+
+	if (!hnd)
+		hnd = hhd->first;
+	else {
+		hnd = hnd->next;
+		if (!hnd) {
+			iter->hidx++;
+			goto retry;
+		}
+	}
+
+	return hnd;
+}
+
+static void *t_hash_start(struct seq_file *m, loff_t *pos)
+{
+	struct ftrace_iterator *iter = m->private;
+	void *p = NULL;
+
+	iter->flags |= FTRACE_ITER_HASH;
+
+	return t_hash_next(m, p, pos);
+}
+
+static int t_hash_show(struct seq_file *m, void *v)
+{
+	struct ftrace_func_hook *rec;
+	struct hlist_node *hnd = v;
+	char str[KSYM_SYMBOL_LEN];
+
+	rec = hlist_entry(hnd, struct ftrace_func_hook, node);
+
+	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
+	seq_printf(m, "%s:", str);
+
+	kallsyms_lookup((unsigned long)rec->ops->func, NULL, NULL, NULL, str);
+	seq_printf(m, "%s", str);
+
+	if (rec->data)
+		seq_printf(m, ":%p", rec->data);
+	seq_putc(m, '\n');
+
+	return 0;
+}
+
+static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct ftrace_iterator *iter = m->private;
 	struct dyn_ftrace *rec = NULL;
 
+	if (iter->flags & FTRACE_ITER_HASH)
+		return t_hash_next(m, v, pos);
+
 	(*pos)++;
 
 	if (iter->flags & FTRACE_ITER_PRINTALL)
 		return NULL;
 
-	mutex_lock(&ftrace_lock);
  retry:
 	if (iter->idx >= iter->pg->index) {
 		if (iter->pg->next) {
@@ -803,7 +889,6 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 			goto retry;
 		}
 	}
-	mutex_unlock(&ftrace_lock);
 
 	return rec;
 }
@@ -813,6 +898,7 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 	struct ftrace_iterator *iter = m->private;
 	void *p = NULL;
 
+	mutex_lock(&ftrace_lock);
 	/*
 	 * For set_ftrace_filter reading, if we have the filter
 	 * off, we can short cut and just print out that all
@@ -820,12 +906,15 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 	 */
 	if (iter->flags & FTRACE_ITER_FILTER && !ftrace_filtered) {
 		if (*pos > 0)
-			return NULL;
+			return t_hash_start(m, pos);
 		iter->flags |= FTRACE_ITER_PRINTALL;
 		(*pos)++;
 		return iter;
 	}
 
+	if (iter->flags & FTRACE_ITER_HASH)
+		return t_hash_start(m, pos);
+
 	if (*pos > 0) {
 		if (iter->idx < 0)
 			return p;
@@ -835,11 +924,15 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 
 	p = t_next(m, p, pos);
 
+	if (!p)
+		return t_hash_start(m, pos);
+
 	return p;
 }
 
 static void t_stop(struct seq_file *m, void *p)
 {
+	mutex_unlock(&ftrace_lock);
 }
 
 static int t_show(struct seq_file *m, void *v)
@@ -848,6 +941,9 @@ static int t_show(struct seq_file *m, void *v)
 	struct dyn_ftrace *rec = v;
 	char str[KSYM_SYMBOL_LEN];
 
+	if (iter->flags & FTRACE_ITER_HASH)
+		return t_hash_show(m, v);
+
 	if (iter->flags & FTRACE_ITER_PRINTALL) {
 		seq_printf(m, "#### all functions enabled ####\n");
 		return 0;
@@ -1246,19 +1342,6 @@ static int __init ftrace_mod_cmd_init(void)
 }
 device_initcall(ftrace_mod_cmd_init);
 
-#define FTRACE_HASH_BITS 7
-#define FTRACE_FUNC_HASHSIZE (1 << FTRACE_HASH_BITS)
-static struct hlist_head ftrace_func_hash[FTRACE_FUNC_HASHSIZE] __read_mostly;
-
-struct ftrace_func_hook {
-	struct hlist_node	node;
-	struct ftrace_hook_ops	*ops;
-	unsigned long		flags;
-	unsigned long		ip;
-	void			*data;
-	struct rcu_head		rcu;
-};
-
 static void
 function_trace_hook_call(unsigned long ip, unsigned long parent_ip)
 {
-- 
1.5.6.5

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbZBQSXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbZBQSXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbZBQSVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:21:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64122 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbZBQSV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:21:27 -0500
Message-Id: <20090217182125.316095499@goodmis.org>
References: <20090217182048.233060814@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 13:20:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/6] ftrace: rename _hook to _probe
Content-Disposition: inline; filename=0002-ftrace-rename-_hook-to-_probe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

Ingo Molnar did not like the _hook naming convention used by the
select function tracer. Luis Claudio R. Goncalves suggested using
the "_probe" extension. This patch implements the change of
calling the functions and variables "_hook" and replacing them
with "_probe".

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h         |   12 +++---
 kernel/trace/ftrace.c          |   78 ++++++++++++++++++++--------------------
 kernel/trace/trace_functions.c |   26 +++++++-------
 3 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 6328122..9d224c4 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -108,7 +108,7 @@ struct ftrace_func_command {
 
 struct seq_file;
 
-struct ftrace_hook_ops {
+struct ftrace_probe_ops {
 	void			(*func)(unsigned long ip,
 					unsigned long parent_ip,
 					void **data);
@@ -116,19 +116,19 @@ struct ftrace_hook_ops {
 	void			(*free)(void **data);
 	int			(*print)(struct seq_file *m,
 					 unsigned long ip,
-					 struct ftrace_hook_ops *ops,
+					 struct ftrace_probe_ops *ops,
 					 void *data);
 };
 
 extern int
-register_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
+register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 			      void *data);
 extern void
-unregister_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
+unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 				void *data);
 extern void
-unregister_ftrace_function_hook_func(char *glob, struct ftrace_hook_ops *ops);
-extern void unregister_ftrace_function_hook_all(char *glob);
+unregister_ftrace_function_probe_func(char *glob, struct ftrace_probe_ops *ops);
+extern void unregister_ftrace_function_probe_all(char *glob);
 
 enum {
 	FTRACE_FL_FREE		= (1 << 0),
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index af9d95c..330a059 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -255,9 +255,9 @@ static struct pid * const ftrace_swapper_pid = &init_struct_pid;
 
 static struct hlist_head ftrace_func_hash[FTRACE_FUNC_HASHSIZE] __read_mostly;
 
-struct ftrace_func_hook {
+struct ftrace_func_probe {
 	struct hlist_node	node;
-	struct ftrace_hook_ops	*ops;
+	struct ftrace_probe_ops	*ops;
 	unsigned long		flags;
 	unsigned long		ip;
 	void			*data;
@@ -830,11 +830,11 @@ static void *t_hash_start(struct seq_file *m, loff_t *pos)
 
 static int t_hash_show(struct seq_file *m, void *v)
 {
-	struct ftrace_func_hook *rec;
+	struct ftrace_func_probe *rec;
 	struct hlist_node *hnd = v;
 	char str[KSYM_SYMBOL_LEN];
 
-	rec = hlist_entry(hnd, struct ftrace_func_hook, node);
+	rec = hlist_entry(hnd, struct ftrace_func_probe, node);
 
 	if (rec->ops->print)
 		return rec->ops->print(m, rec->ip, rec->ops, rec->data);
@@ -1351,9 +1351,9 @@ static int __init ftrace_mod_cmd_init(void)
 device_initcall(ftrace_mod_cmd_init);
 
 static void
-function_trace_hook_call(unsigned long ip, unsigned long parent_ip)
+function_trace_probe_call(unsigned long ip, unsigned long parent_ip)
 {
-	struct ftrace_func_hook *entry;
+	struct ftrace_func_probe *entry;
 	struct hlist_head *hhd;
 	struct hlist_node *n;
 	unsigned long key;
@@ -1379,18 +1379,18 @@ function_trace_hook_call(unsigned long ip, unsigned long parent_ip)
 	ftrace_preempt_enable(resched);
 }
 
-static struct ftrace_ops trace_hook_ops __read_mostly =
+static struct ftrace_ops trace_probe_ops __read_mostly =
 {
-	.func = function_trace_hook_call,
+	.func = function_trace_probe_call,
 };
 
-static int ftrace_hook_registered;
+static int ftrace_probe_registered;
 
-static void __enable_ftrace_function_hook(void)
+static void __enable_ftrace_function_probe(void)
 {
 	int i;
 
-	if (ftrace_hook_registered)
+	if (ftrace_probe_registered)
 		return;
 
 	for (i = 0; i < FTRACE_FUNC_HASHSIZE; i++) {
@@ -1402,16 +1402,16 @@ static void __enable_ftrace_function_hook(void)
 	if (i == FTRACE_FUNC_HASHSIZE)
 		return;
 
-	__register_ftrace_function(&trace_hook_ops);
+	__register_ftrace_function(&trace_probe_ops);
 	ftrace_startup(0);
-	ftrace_hook_registered = 1;
+	ftrace_probe_registered = 1;
 }
 
-static void __disable_ftrace_function_hook(void)
+static void __disable_ftrace_function_probe(void)
 {
 	int i;
 
-	if (!ftrace_hook_registered)
+	if (!ftrace_probe_registered)
 		return;
 
 	for (i = 0; i < FTRACE_FUNC_HASHSIZE; i++) {
@@ -1421,16 +1421,16 @@ static void __disable_ftrace_function_hook(void)
 	}
 
 	/* no more funcs left */
-	__unregister_ftrace_function(&trace_hook_ops);
+	__unregister_ftrace_function(&trace_probe_ops);
 	ftrace_shutdown(0);
-	ftrace_hook_registered = 0;
+	ftrace_probe_registered = 0;
 }
 
 
 static void ftrace_free_entry_rcu(struct rcu_head *rhp)
 {
-	struct ftrace_func_hook *entry =
-		container_of(rhp, struct ftrace_func_hook, rcu);
+	struct ftrace_func_probe *entry =
+		container_of(rhp, struct ftrace_func_probe, rcu);
 
 	if (entry->ops->free)
 		entry->ops->free(&entry->data);
@@ -1439,10 +1439,10 @@ static void ftrace_free_entry_rcu(struct rcu_head *rhp)
 
 
 int
-register_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
+register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 			      void *data)
 {
-	struct ftrace_func_hook *entry;
+	struct ftrace_func_probe *entry;
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec;
 	int type, len, not;
@@ -1453,7 +1453,7 @@ register_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
 	type = ftrace_setup_glob(glob, strlen(glob), &search, &not);
 	len = strlen(search);
 
-	/* we do not support '!' for function hooks */
+	/* we do not support '!' for function probes */
 	if (WARN_ON(not))
 		return -EINVAL;
 
@@ -1468,7 +1468,7 @@ register_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
 
 		entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 		if (!entry) {
-			/* If we did not hook to any, then return error */
+			/* If we did not process any, then return error */
 			if (!count)
 				count = -ENOMEM;
 			goto out_unlock;
@@ -1498,7 +1498,7 @@ register_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
 		hlist_add_head_rcu(&entry->node, &ftrace_func_hash[key]);
 
 	} while_for_each_ftrace_rec();
-	__enable_ftrace_function_hook();
+	__enable_ftrace_function_probe();
 
  out_unlock:
 	mutex_unlock(&ftrace_lock);
@@ -1507,15 +1507,15 @@ register_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
 }
 
 enum {
-	HOOK_TEST_FUNC		= 1,
-	HOOK_TEST_DATA		= 2
+	PROBE_TEST_FUNC		= 1,
+	PROBE_TEST_DATA		= 2
 };
 
 static void
-__unregister_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
+__unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 				  void *data, int flags)
 {
-	struct ftrace_func_hook *entry;
+	struct ftrace_func_probe *entry;
 	struct hlist_node *n, *tmp;
 	char str[KSYM_SYMBOL_LEN];
 	int type = MATCH_FULL;
@@ -1530,7 +1530,7 @@ __unregister_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
 		type = ftrace_setup_glob(glob, strlen(glob), &search, &not);
 		len = strlen(search);
 
-		/* we do not support '!' for function hooks */
+		/* we do not support '!' for function probes */
 		if (WARN_ON(not))
 			return;
 	}
@@ -1542,10 +1542,10 @@ __unregister_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
 		hlist_for_each_entry_safe(entry, n, tmp, hhd, node) {
 
 			/* break up if statements for readability */
-			if ((flags & HOOK_TEST_FUNC) && entry->ops != ops)
+			if ((flags & PROBE_TEST_FUNC) && entry->ops != ops)
 				continue;
 
-			if ((flags & HOOK_TEST_DATA) && entry->data != data)
+			if ((flags & PROBE_TEST_DATA) && entry->data != data)
 				continue;
 
 			/* do this last, since it is the most expensive */
@@ -1560,27 +1560,27 @@ __unregister_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
 			call_rcu(&entry->rcu, ftrace_free_entry_rcu);
 		}
 	}
-	__disable_ftrace_function_hook();
+	__disable_ftrace_function_probe();
 	mutex_unlock(&ftrace_lock);
 }
 
 void
-unregister_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
+unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 				void *data)
 {
-	__unregister_ftrace_function_hook(glob, ops, data,
-					  HOOK_TEST_FUNC | HOOK_TEST_DATA);
+	__unregister_ftrace_function_probe(glob, ops, data,
+					  PROBE_TEST_FUNC | PROBE_TEST_DATA);
 }
 
 void
-unregister_ftrace_function_hook_func(char *glob, struct ftrace_hook_ops *ops)
+unregister_ftrace_function_probe_func(char *glob, struct ftrace_probe_ops *ops)
 {
-	__unregister_ftrace_function_hook(glob, ops, NULL, HOOK_TEST_FUNC);
+	__unregister_ftrace_function_probe(glob, ops, NULL, PROBE_TEST_FUNC);
 }
 
-void unregister_ftrace_function_hook_all(char *glob)
+void unregister_ftrace_function_probe_all(char *glob)
 {
-	__unregister_ftrace_function_hook(glob, NULL, NULL, 0);
+	__unregister_ftrace_function_probe(glob, NULL, NULL, 0);
 }
 
 static LIST_HEAD(ftrace_commands);
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 021a574..6ea73ed 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -269,21 +269,21 @@ ftrace_traceoff(unsigned long ip, unsigned long parent_ip, void **data)
 
 static int
 ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
-			 struct ftrace_hook_ops *ops, void *data);
+			 struct ftrace_probe_ops *ops, void *data);
 
-static struct ftrace_hook_ops traceon_hook_ops = {
+static struct ftrace_probe_ops traceon_probe_ops = {
 	.func			= ftrace_traceon,
 	.print			= ftrace_trace_onoff_print,
 };
 
-static struct ftrace_hook_ops traceoff_hook_ops = {
+static struct ftrace_probe_ops traceoff_probe_ops = {
 	.func			= ftrace_traceoff,
 	.print			= ftrace_trace_onoff_print,
 };
 
 static int
 ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
-			 struct ftrace_hook_ops *ops, void *data)
+			 struct ftrace_probe_ops *ops, void *data)
 {
 	char str[KSYM_SYMBOL_LEN];
 	long count = (long)data;
@@ -291,7 +291,7 @@ ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
 	kallsyms_lookup(ip, NULL, NULL, NULL, str);
 	seq_printf(m, "%s:", str);
 
-	if (ops == &traceon_hook_ops)
+	if (ops == &traceon_probe_ops)
 		seq_printf(m, "traceon");
 	else
 		seq_printf(m, "traceoff");
@@ -306,15 +306,15 @@ ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
 static int
 ftrace_trace_onoff_unreg(char *glob, char *cmd, char *param)
 {
-	struct ftrace_hook_ops *ops;
+	struct ftrace_probe_ops *ops;
 
 	/* we register both traceon and traceoff to this callback */
 	if (strcmp(cmd, "traceon") == 0)
-		ops = &traceon_hook_ops;
+		ops = &traceon_probe_ops;
 	else
-		ops = &traceoff_hook_ops;
+		ops = &traceoff_probe_ops;
 
-	unregister_ftrace_function_hook_func(glob, ops);
+	unregister_ftrace_function_probe_func(glob, ops);
 
 	return 0;
 }
@@ -322,7 +322,7 @@ ftrace_trace_onoff_unreg(char *glob, char *cmd, char *param)
 static int
 ftrace_trace_onoff_callback(char *glob, char *cmd, char *param, int enable)
 {
-	struct ftrace_hook_ops *ops;
+	struct ftrace_probe_ops *ops;
 	void *count = (void *)-1;
 	char *number;
 	int ret;
@@ -336,9 +336,9 @@ ftrace_trace_onoff_callback(char *glob, char *cmd, char *param, int enable)
 
 	/* we register both traceon and traceoff to this callback */
 	if (strcmp(cmd, "traceon") == 0)
-		ops = &traceon_hook_ops;
+		ops = &traceon_probe_ops;
 	else
-		ops = &traceoff_hook_ops;
+		ops = &traceoff_probe_ops;
 
 	if (!param)
 		goto out_reg;
@@ -357,7 +357,7 @@ ftrace_trace_onoff_callback(char *glob, char *cmd, char *param, int enable)
 		return ret;
 
  out_reg:
-	ret = register_ftrace_function_hook(glob, ops, count);
+	ret = register_ftrace_function_probe(glob, ops, count);
 
 	return ret;
 }
-- 
1.5.6.5

-- 

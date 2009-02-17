Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbZBQFRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbZBQFRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 00:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZBQFOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 00:14:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42028 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbZBQFOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 00:14:08 -0500
Message-Id: <20090217051407.035764950@goodmis.org>
References: <20090217051227.957864159@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 00:12:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 10/15] ftrace: trace different functions with a different tracer
Content-Disposition: inline; filename=0010-ftrace-trace-different-functions-with-a-different-t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: new feature

Currently, the function tracer only gives you an ability to hook
a tracer to all functions being traced. The dynamic function trace
allows you to pick and choose which of those functions will be
traced, but all functions being traced will call all tracers that
registered with the function tracer.

This patch adds a new feature that allows a tracer to hook to specific
functions, even when all functions are being traced. It allows for
different functions to call different tracer hooks.

The way this is accomplished is by a special function that will hook
to the function tracer and will set up a hash table knowing which
tracer hook to call with which function. This is the most general
and easiest method to accomplish this. Later, an arch may choose
to supply their own method in changing the mcount call of a function
to call a different tracer. But that will be an exercise for the
future.

To register a function:

 struct ftrace_hook_ops {
	void			(*func)(unsigned long ip,
					unsigned long parent_ip,
					void **data);
	int			(*callback)(unsigned long ip, void **data);
	void			(*free)(void **data);
 };

 int register_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
				  void *data);

glob is a simple glob to search for the functions to hook.
ops is a pointer to the operations (listed below)
data is the default data to be passed to the hook functions when traced

ops:
 func is the hook function to call when the functions are traced
 callback is a callback function that is called when setting up the hash.
   That is, if the tracer needs to do something special for each
   function, that is being traced, and wants to give each function
   its own data. The address of the entry data is passed to this
   callback, so that the callback may wish to update the entry to
   whatever it would like.
 free is a callback for when the entry is freed. In case the tracer
   allocated any data, it is give the chance to free it.

To unregister we have three functions:

  void
  unregister_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
				void *data)

This will unregister all hooks that match glob, point to ops, and
have its data matching data. (note, if glob is NULL, blank or '*',
all functions will be tested).

  void
  unregister_ftrace_function_hook_func(char *glob,
				 struct ftrace_hook_ops *ops)

This will unregister all functions matching glob that has an entry
pointing to ops.

  void unregister_ftrace_function_hook_all(char *glob)

This simply unregisters all funcs.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |   18 ++++
 kernel/trace/ftrace.c  |  247 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 265 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f0a0ecc..13918c4 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -106,6 +106,24 @@ struct ftrace_func_command {
 /* asm/ftrace.h must be defined for archs supporting dynamic ftrace */
 #include <asm/ftrace.h>
 
+struct ftrace_hook_ops {
+	void			(*func)(unsigned long ip,
+					unsigned long parent_ip,
+					void **data);
+	int			(*callback)(unsigned long ip, void **data);
+	void			(*free)(void **data);
+};
+
+extern int
+register_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
+			      void *data);
+extern void
+unregister_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
+				void *data);
+extern void
+unregister_ftrace_function_hook_func(char *glob, struct ftrace_hook_ops *ops);
+extern void unregister_ftrace_function_hook_all(char *glob);
+
 enum {
 	FTRACE_FL_FREE		= (1 << 0),
 	FTRACE_FL_FAILED	= (1 << 1),
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 157d4f6..0b80e32 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -27,6 +27,7 @@
 #include <linux/sysctl.h>
 #include <linux/ctype.h>
 #include <linux/list.h>
+#include <linux/hash.h>
 
 #include <asm/ftrace.h>
 
@@ -1245,6 +1246,252 @@ static int __init ftrace_mod_cmd_init(void)
 }
 device_initcall(ftrace_mod_cmd_init);
 
+#define FTRACE_HASH_BITS 7
+#define FTRACE_FUNC_HASHSIZE (1 << FTRACE_HASH_BITS)
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
+static void
+function_trace_hook_call(unsigned long ip, unsigned long parent_ip)
+{
+	struct ftrace_func_hook *entry;
+	struct hlist_head *hhd;
+	struct hlist_node *n;
+	unsigned long key;
+	int resched;
+
+	key = hash_long(ip, FTRACE_HASH_BITS);
+
+	hhd = &ftrace_func_hash[key];
+
+	if (hlist_empty(hhd))
+		return;
+
+	/*
+	 * Disable preemption for these calls to prevent a RCU grace
+	 * period. This syncs the hash iteration and freeing of items
+	 * on the hash. rcu_read_lock is too dangerous here.
+	 */
+	resched = ftrace_preempt_disable();
+	hlist_for_each_entry_rcu(entry, n, hhd, node) {
+		if (entry->ip == ip)
+			entry->ops->func(ip, parent_ip, &entry->data);
+	}
+	ftrace_preempt_enable(resched);
+}
+
+static struct ftrace_ops trace_hook_ops __read_mostly =
+{
+	.func = function_trace_hook_call,
+};
+
+static int ftrace_hook_registered;
+
+static void __enable_ftrace_function_hook(void)
+{
+	int i;
+
+	if (ftrace_hook_registered)
+		return;
+
+	for (i = 0; i < FTRACE_FUNC_HASHSIZE; i++) {
+		struct hlist_head *hhd = &ftrace_func_hash[i];
+		if (hhd->first)
+			break;
+	}
+	/* Nothing registered? */
+	if (i == FTRACE_FUNC_HASHSIZE)
+		return;
+
+	__register_ftrace_function(&trace_hook_ops);
+	ftrace_startup(0);
+	ftrace_hook_registered = 1;
+}
+
+static void __disable_ftrace_function_hook(void)
+{
+	int i;
+
+	if (!ftrace_hook_registered)
+		return;
+
+	for (i = 0; i < FTRACE_FUNC_HASHSIZE; i++) {
+		struct hlist_head *hhd = &ftrace_func_hash[i];
+		if (hhd->first)
+			return;
+	}
+
+	/* no more funcs left */
+	__unregister_ftrace_function(&trace_hook_ops);
+	ftrace_shutdown(0);
+	ftrace_hook_registered = 0;
+}
+
+
+static void ftrace_free_entry_rcu(struct rcu_head *rhp)
+{
+	struct ftrace_func_hook *entry =
+		container_of(rhp, struct ftrace_func_hook, rcu);
+
+	if (entry->ops->free)
+		entry->ops->free(&entry->data);
+	kfree(entry);
+}
+
+
+int
+register_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
+			      void *data)
+{
+	struct ftrace_func_hook *entry;
+	struct ftrace_page *pg;
+	struct dyn_ftrace *rec;
+	unsigned long key;
+	int type, len, not;
+	int count = 0;
+	char *search;
+
+	type = ftrace_setup_glob(glob, strlen(glob), &search, &not);
+	len = strlen(search);
+
+	/* we do not support '!' for function hooks */
+	if (WARN_ON(not))
+		return -EINVAL;
+
+	mutex_lock(&ftrace_lock);
+	do_for_each_ftrace_rec(pg, rec) {
+
+		if (rec->flags & FTRACE_FL_FAILED)
+			continue;
+
+		if (!ftrace_match_record(rec, search, len, type))
+			continue;
+
+		entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+		if (!entry) {
+			/* If we did not hook to any, then return error */
+			if (!count)
+				count = -ENOMEM;
+			goto out_unlock;
+		}
+
+		count++;
+
+		entry->data = data;
+
+		/*
+		 * The caller might want to do something special
+		 * for each function we find. We call the callback
+		 * to give the caller an opportunity to do so.
+		 */
+		if (ops->callback) {
+			if (ops->callback(rec->ip, &entry->data) < 0) {
+				/* caller does not like this func */
+				kfree(entry);
+				continue;
+			}
+		}
+
+		entry->ops = ops;
+		entry->ip = rec->ip;
+
+		key = hash_long(entry->ip, FTRACE_HASH_BITS);
+		hlist_add_head_rcu(&entry->node, &ftrace_func_hash[key]);
+
+	} while_for_each_ftrace_rec();
+	__enable_ftrace_function_hook();
+
+ out_unlock:
+	mutex_unlock(&ftrace_lock);
+
+	return count;
+}
+
+enum {
+	HOOK_TEST_FUNC		= 1,
+	HOOK_TEST_DATA		= 2
+};
+
+static void
+__unregister_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
+				  void *data, int flags)
+{
+	struct ftrace_func_hook *entry;
+	struct hlist_node *n, *tmp;
+	char str[KSYM_SYMBOL_LEN];
+	int type = MATCH_FULL;
+	int i, len = 0;
+	char *search;
+
+	if (glob && (strcmp(glob, "*") || !strlen(glob)))
+		glob = NULL;
+	else {
+		int not;
+
+		type = ftrace_setup_glob(glob, strlen(glob), &search, &not);
+		len = strlen(search);
+
+		/* we do not support '!' for function hooks */
+		if (WARN_ON(not))
+			return;
+	}
+
+	mutex_lock(&ftrace_lock);
+	for (i = 0; i < FTRACE_FUNC_HASHSIZE; i++) {
+		struct hlist_head *hhd = &ftrace_func_hash[i];
+
+		hlist_for_each_entry_safe(entry, n, tmp, hhd, node) {
+
+			/* break up if statements for readability */
+			if ((flags & HOOK_TEST_FUNC) && entry->ops != ops)
+				continue;
+
+			if ((flags & HOOK_TEST_DATA) && entry->data != data)
+				continue;
+
+			/* do this last, since it is the most expensive */
+			if (glob) {
+				kallsyms_lookup(entry->ip, NULL, NULL,
+						NULL, str);
+				if (!ftrace_match(str, glob, len, type))
+					continue;
+			}
+
+			hlist_del(&entry->node);
+			call_rcu(&entry->rcu, ftrace_free_entry_rcu);
+		}
+	}
+	__disable_ftrace_function_hook();
+	mutex_unlock(&ftrace_lock);
+}
+
+void
+unregister_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
+				void *data)
+{
+	__unregister_ftrace_function_hook(glob, ops, data,
+					  HOOK_TEST_FUNC | HOOK_TEST_DATA);
+}
+
+void
+unregister_ftrace_function_hook_func(char *glob, struct ftrace_hook_ops *ops)
+{
+	__unregister_ftrace_function_hook(glob, ops, NULL, HOOK_TEST_FUNC);
+}
+
+void unregister_ftrace_function_hook_all(char *glob)
+{
+	__unregister_ftrace_function_hook(glob, NULL, NULL, 0);
+}
+
 static LIST_HEAD(ftrace_commands);
 static DEFINE_MUTEX(ftrace_cmd_mutex);
 
-- 
1.5.6.5

-- 

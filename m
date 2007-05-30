Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbXE3OE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbXE3OE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbXE3ODO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:03:14 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:46559 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756042AbXE3ODL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:03:11 -0400
Message-Id: <20070530140227.398040643@polymtl.ca>
References: <20070530140025.917261793@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 30 May 2007 10:00:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 2/9] Conditional Calls - Hash Table
Content-Disposition: inline; filename=conditional-calls-hash-table.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 30 May 2007 14:02:27 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reimplementation of the cond calls which uses a hash table to hold the active
cond_calls. It permits to first arm a cond_call and then load supplementary
modules that contain this cond_call.

Without this, the order of loading a module containing a cond_call and arming a
cond_call matters and there is no symbol dependency to check this.

At module load time, each cond_call checks if it is enabled in the hash table
and is set accordingly.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/condcall.h |    2 
 kernel/module.c          |  205 +++++++++++++++++++++++++++++------------------
 2 files changed, 129 insertions(+), 78 deletions(-)

Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2007-05-17 01:42:50.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2007-05-17 01:46:42.000000000 -0400
@@ -33,6 +33,8 @@
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
 #include <linux/condcall.h>
+#include <linux/jhash.h>
+#include <linux/list.h>
 #include <linux/err.h>
 #include <linux/vermagic.h>
 #include <linux/notifier.h>
@@ -71,6 +73,20 @@
 
 static BLOCKING_NOTIFIER_HEAD(module_notify_list);
 
+#ifdef CONFIG_COND_CALL
+/* Conditional call hash table, containing the active cond_calls.
+ * Protected by module_mutex. */
+#define COND_CALL_HASH_BITS 6
+#define COND_CALL_TABLE_SIZE (1 << COND_CALL_HASH_BITS)
+
+struct cond_call_entry {
+	struct hlist_node hlist;
+	char name[0];
+};
+
+static struct hlist_head cond_call_table[COND_CALL_TABLE_SIZE];
+#endif //CONFIG_COND_CALL
+
 int register_module_notifier(struct notifier_block * nb)
 {
 	return blocking_notifier_chain_register(&module_notify_list, nb);
@@ -305,6 +321,68 @@
 }
 
 #ifdef CONFIG_COND_CALL
+/* Check if the cond_call is present in the hash table.
+ * Returns 1 if present, 0 if not. */
+static int hash_check_cond_call(const char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct cond_call_entry *e;
+	size_t len = strlen(name);
+	u32 hash = jhash(name, len, 0);
+
+	head = &cond_call_table[hash & ((1 << COND_CALL_HASH_BITS)-1)];
+	hlist_for_each_entry(e, node, head, hlist)
+		if (!strcmp(name, e->name))
+			return 1;
+	return 0;
+}
+
+/* Add the cond_call to the hash table. Must be called with mutex_lock held. */
+static int hash_add_cond_call(const char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct cond_call_entry *e;
+	size_t len = strlen(name);
+	u32 hash = jhash(name, len, 0);
+
+	head = &cond_call_table[hash & ((1 << COND_CALL_HASH_BITS)-1)];
+	hlist_for_each_entry(e, node, head, hlist)
+		if (!strcmp(name, e->name))
+			return 0;	/* Already there */
+	/* Using kmalloc here to allocate a variable length element. Could
+	 * cause some memory fragmentation if overused. */
+	e = kmalloc(sizeof(struct cond_call_entry) + len + 1, GFP_KERNEL);
+	if (!e)
+		return -ENOMEM;
+	memcpy(&e->name[0], name, len + 1);
+	hlist_add_head(&e->hlist, head);
+	return 0;
+}
+
+/* Remove the cond_call from the hash table. Must be called with mutex_lock
+ * held. */
+static void hash_remove_cond_call(const char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct cond_call_entry *e;
+	int found = 0;
+	size_t len = strlen(name);
+	u32 hash = jhash(name, len, 0);
+
+	head = &cond_call_table[hash & ((1 << COND_CALL_HASH_BITS)-1)];
+	hlist_for_each_entry(e, node, head, hlist)
+		if (!strcmp(name, e->name)) {
+			found = 1;
+			break;
+		}
+	if (found) {
+		hlist_del(&e->hlist);
+		kfree(e);
+	}
+}
 
 /* Set the enable bit of the cond_call, choosing the generic or architecture
  * specific functions depending on the cond_call's flags.
@@ -317,59 +395,53 @@
 		return cond_call_generic_set_enable(address, enable);
 }
 
-/* Query the state of a cond_calls range. */
-static int _cond_call_query_range(const char *name,
-	const struct __cond_call_struct *begin,
-	const struct __cond_call_struct *end)
+static int cond_call_get_enable(void *address, int flags)
+{
+	if (flags & CF_OPTIMIZED)
+		return COND_CALL_OPTIMIZED_ENABLE(address);
+	else
+		return COND_CALL_GENERIC_ENABLE(address);
+}
+
+/* Setup the cond_call according to the data present in the cond_call hash
+ * upon module load. */
+void module_cond_call_setup(struct module *mod)
 {
 	const struct __cond_call_struct *iter;
-	int ret = 0;
+	int enable;
 
-	for (iter = begin; iter < end; iter++) {
-		if (strcmp(name, iter->name) != 0)
-			continue;
-		if (iter->flags & CF_OPTIMIZED)
-			ret = COND_CALL_OPTIMIZED_ENABLE(iter->enable);
-		else
-			ret = COND_CALL_GENERIC_ENABLE(iter->enable);
-		if (ret)
-			break;
+	for (iter = mod->cond_calls;
+		iter < mod->cond_calls+mod->num_cond_calls; iter++) {
+		enable = hash_check_cond_call(iter->name);
+		if (enable != cond_call_get_enable(iter->enable, iter->flags))
+			cond_call_set_enable(iter->enable, enable, iter->flags);
 	}
-	return ret;
 }
 
 /* Sets a range of cond_calls to a enabled state : set the enable bit. */
-static int _cond_call_arm_range(const char *name,
+static void _cond_call_arm_range(const char *name,
 	const struct __cond_call_struct *begin,
 	const struct __cond_call_struct *end)
 {
 	const struct __cond_call_struct *iter;
-	int found = 0;
 
 	for (iter = begin; iter < end; iter++) {
-		if (strcmp(name, iter->name) != 0)
-			continue;
-		cond_call_set_enable(iter->enable, 1, iter->flags);
-		found++;
+		if (!strcmp(name, iter->name))
+			cond_call_set_enable(iter->enable, 1, iter->flags);
 	}
-	return found;
 }
 
 /* Sets a range of cond_calls to a disabled state : unset the enable bit. */
-static int _cond_call_disarm_range(const char *name,
+static void _cond_call_disarm_range(const char *name,
 	const struct __cond_call_struct *begin,
 	const struct __cond_call_struct *end)
 {
 	const struct __cond_call_struct *iter;
-	int found = 0;
 
 	for (iter = begin; iter < end; iter++) {
-		if (strcmp(name, iter->name) != 0)
-			continue;
-		cond_call_set_enable(iter->enable, 0, iter->flags);
-		found++;
+		if (!strcmp(name, iter->name))
+			cond_call_set_enable(iter->enable, 0, iter->flags);
 	}
-	return found;
 }
 
 /* Provides a listing of the cond_calls present in the kernel with their type
@@ -397,105 +469,79 @@
 	return found;
 }
 
-/* Calls _cond_call_query_range for the core cond_calls and modules cond_calls.
- */
-static int _cond_call_query(const char *name)
-{
-	struct module *mod;
-	int ret = 0;
-
-	/* Core kernel cond_calls */
-	ret = _cond_call_query_range(name,
-			__start___cond_call, __stop___cond_call);
-	if (ret)
-		return ret;
-	/* Cond_calls in modules. */
-	list_for_each_entry(mod, &modules, list) {
-		if (mod->taints)
-			continue;
-		ret = _cond_call_query_range(name,
-			mod->cond_calls, mod->cond_calls+mod->num_cond_calls);
-		if (ret)
-			break;
-	}
-	return ret;
-}
-
 /* Cond_call enabling/disabling use the module_mutex to synchronize.
- * Returns 1 if enabled, 0 if disabled or not present. */
+ * Returns 1 if enabled, 0 if disabled. */
 int cond_call_query(const char *name)
 {
-	int ret = 0;
+	int ret;
 
 	mutex_lock(&module_mutex);
-	ret = _cond_call_query(name);
+	ret = hash_check_cond_call(name);
 	mutex_unlock(&module_mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(cond_call_query);
 
-/* Calls _cond_call_arm_range for the core cond_calls and modules cond_calls.
- * FIXME : cond_call will not be active on modules loaded later than the
- * cond_call_arm. */
+/* Calls _cond_call_arm_range for the core cond_calls and modules cond_calls. */
 static int _cond_call_arm(const char *name)
 {
 	struct module *mod;
-	int found = 0;
+	int ret;
+
+	ret = hash_add_cond_call(name);
+	if (ret)
+		return ret;
 
 	/* Core kernel cond_calls */
-	found += _cond_call_arm_range(name,
+	_cond_call_arm_range(name,
 			__start___cond_call, __stop___cond_call);
 	/* Cond_calls in modules. */
 	list_for_each_entry(mod, &modules, list) {
 		if (mod->taints)
 			continue;
-		found += _cond_call_arm_range(name,
+		_cond_call_arm_range(name,
 			mod->cond_calls, mod->cond_calls+mod->num_cond_calls);
 	}
-	return found;
+	return ret;
 }
 
 /* Cond_call enabling/disabling use the module_mutex to synchronize. */
 int cond_call_arm(const char *name)
 {
-	int found = 0;
+	int ret;
 
 	mutex_lock(&module_mutex);
-	found = _cond_call_arm(name);
+	ret = _cond_call_arm(name);
 	mutex_unlock(&module_mutex);
-	return found;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(cond_call_arm);
 
 /* Calls _cond_call_disarm_range for the core cond_calls and modules cond_calls.
  */
-static int _cond_call_disarm(const char *name)
+static void _cond_call_disarm(const char *name)
 {
 	struct module *mod;
-	int found = 0;
 
 	/* Core kernel cond_calls */
-	found += _cond_call_disarm_range(name,
+	_cond_call_disarm_range(name,
 			__start___cond_call, __stop___cond_call);
 	/* Cond_calls in modules. */
 	list_for_each_entry(mod, &modules, list) {
 		if (mod->taints)
 			continue;
-		found += _cond_call_disarm_range(name,
+		_cond_call_disarm_range(name,
 			mod->cond_calls, mod->cond_calls+mod->num_cond_calls);
 	}
-	return found;
+	hash_remove_cond_call(name);
 }
 
 /* Cond_call enabling/disabling use the module_mutex to synchronize. */
-int cond_call_disarm(const char *name)
+void cond_call_disarm(const char *name)
 {
-	int found = 0;
-
 	mutex_lock(&module_mutex);
-	found = _cond_call_disarm(name);
+	_cond_call_disarm(name);
 	mutex_unlock(&module_mutex);
-	return found;
 }
 EXPORT_SYMBOL_GPL(cond_call_disarm);
 
@@ -525,7 +571,10 @@
 	return found;
 }
 EXPORT_SYMBOL_GPL(cond_call_list);
-
+#else
+static void module_cond_call_setup(struct module *mod)
+{
+}
 #endif
 
 #ifdef CONFIG_SMP
@@ -2211,6 +2260,8 @@
 
 	add_kallsyms(mod, sechdrs, symindex, strindex, secstrings);
 
+	module_cond_call_setup(mod);
+
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
 		goto cleanup;
Index: linux-2.6-lttng/include/linux/condcall.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/condcall.h	2007-05-17 01:42:50.000000000 -0400
+++ linux-2.6-lttng/include/linux/condcall.h	2007-05-17 01:46:42.000000000 -0400
@@ -81,7 +81,7 @@
 #define COND_CALL_MAX_FORMAT_LEN	1024
 
 extern int cond_call_arm(const char *name);
-extern int cond_call_disarm(const char *name);
+extern void cond_call_disarm(const char *name);
 
 /* cond_call_query : Returns 1 if enabled, 0 if disabled or not present */
 extern int cond_call_query(const char *name);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

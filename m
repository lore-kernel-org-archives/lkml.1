Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbXE3OHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbXE3OHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbXE3OH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:07:27 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47904 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbXE3OHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:07:22 -0400
Message-Id: <20070530140713.306302163@polymtl.ca>
References: <20070530140359.006540666@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 30 May 2007 10:04:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 3/6] Linux Kernel Markers - Hash Table
Content-Disposition: inline; filename=linux-kernel-markers-hash-table.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 30 May 2007 14:07:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite of the markers using a hash table as a basic container for the enabled
probes. It permits to first arm a probe and then load modules containing
markers for this probe and still be coherent.

At module load time, each marker is checked for an active probe in the hash
table.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/marker.h |    2 
 kernel/module.c        |  485 +++++++++++++++++++++++++++----------------------
 2 files changed, 277 insertions(+), 210 deletions(-)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2007-05-17 00:52:36.000000000 -0400
+++ linux-2.6-lttng/include/linux/marker.h	2007-05-17 00:53:06.000000000 -0400
@@ -91,7 +91,7 @@
 #define marker_arm_probe(name, format, probe, pdata) \
 		_marker_arm_probe(CF_DEFAULT, name, format, probe, pdata)
 
-extern int marker_disarm_probe(const char *name);
+extern void marker_disarm_probe(const char *name);
 extern int marker_list_probe(marker_probe_func *probe);
 const struct __mark_marker *marker_query(const char *name, int instance);
 
Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2007-05-17 00:52:36.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2007-05-17 00:53:40.000000000 -0400
@@ -88,6 +88,24 @@
 static struct hlist_head cond_call_table[COND_CALL_TABLE_SIZE];
 #endif //CONFIG_COND_CALL
 
+#ifdef CONFIG_MARKERS
+/* Marker hash table, containing the active markers.
+ * Protected by module_mutex. */
+#define MARKER_HASH_BITS 6
+#define MARKER_TABLE_SIZE (1 << MARKER_HASH_BITS)
+
+struct marker_entry {
+	struct hlist_node hlist;
+	int flags;
+	char *format;
+	marker_probe_func *probe;
+	void *pdata;
+	char name[0];	/* Contains name'\0'format'\0' */
+};
+
+static struct hlist_head marker_table[MARKER_TABLE_SIZE];
+#endif //CONFIG_MARKERS
+
 int register_module_notifier(struct notifier_block * nb)
 {
 	return blocking_notifier_chain_register(&module_notify_list, nb);
@@ -161,8 +179,8 @@
 extern const unsigned long __start___kcrctab_unused_gpl[];
 extern const struct __cond_call_struct __start___cond_call[];
 extern const struct __cond_call_struct __stop___cond_call[];
-extern const struct __mark_marker __start___markers[];
-extern const struct __mark_marker __stop___markers[];
+extern struct __mark_marker __start___markers[];
+extern struct __mark_marker __stop___markers[];
 
 #ifndef CONFIG_MODVERSIONS
 #define symversion(base, idx) NULL
@@ -581,159 +599,267 @@
 #endif
 
 #ifdef CONFIG_MARKERS
-
 /* Empty callback provided as a probe to the markers. By providing this to a
  * disabled marker, we makes sure the  execution flow is always valid even
  * though the function pointer change and the marker enabling are two distinct
  * operations that modifies the execution flow of preemptible code. */
-void __mark_empty_function(const struct __mark_marker_data *mdata,
+void __mark_empty_function(const struct __mark_marker *mdata,
 	const char *fmt, ...)
 {
 }
 EXPORT_SYMBOL_GPL(__mark_empty_function);
 
-/* Sets the probe callback corresponding to a range of markers.
- */
-static int _marker_set_probe_range(int flags, const char *name,
-	const char *format,
-	marker_probe_func *probe,
-	void *pdata,
-	const struct __mark_marker *begin,
-	const struct __mark_marker *end)
+/* Get marker if the marker is present in the hash table.
+ * Returns NULL if not present. */
+static struct marker_entry *hash_get_marker(const char *name)
 {
-	const struct __mark_marker *iter;
-	int found = 0;
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *e;
+	size_t len = strlen(name);
+	u32 hash = jhash(name, len, 0);
 
-	for (iter = begin; iter < end; iter++) {
-		if (strcmp(name, iter->mdata->name) != 0)
-			continue;
+	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
+	hlist_for_each_entry(e, node, head, hlist)
+		if (!strcmp(name, e->name))
+			return e;
+	return NULL;
+}
 
-		if (format) {
-			if (strcmp(format, iter->mdata->format) != 0) {
-				printk(KERN_NOTICE
-					"Format mismatch for probe %s "
-					"(%s), marker (%s)\n",
-					name,
-					format,
-					iter->mdata->format);
-				continue;
-			}
-		} else
-			format = iter->mdata->format;
+/* Add the marker to the hash table. Must be called with mutex_lock held. */
+static int hash_add_marker(int flags, const char *name,
+	const char *format, marker_probe_func *probe, void *pdata)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *e;
+	size_t name_len = strlen(name);
+	size_t format_len = strlen(format);
+	u32 hash = jhash(name, name_len, 0);
 
-		if (flags & CF_LOCKDEP
-			&& !(iter->mdata->flags & CF_LOCKDEP)) {
-			printk(KERN_NOTICE
-				"Incompatible lockdep flags for "
-				"probe %s\n",
-				name);
-			continue;
-		}
-		if (flags & CF_PRINTK
-			&& !(iter->mdata->flags & CF_PRINTK)) {
+	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
+	hlist_for_each_entry(e, node, head, hlist)
+		if (!strcmp(name, e->name)) {
 			printk(KERN_NOTICE
-				"Incompatible printk flags for "
-				"probe %s\n",
-				name);
-			continue;
+				"Marker %s busy, probe %p already installed\n",
+				name, e->probe);
+			return -EBUSY;	/* Already there */
 		}
-		if (probe == __mark_empty_function) {
-			if (iter->mdata->call != __mark_empty_function)
-				iter->mdata->call = __mark_empty_function;
-		} else {
-			if (iter->mdata->call != __mark_empty_function) {
-				if (iter->mdata->call != probe) {
-					printk(KERN_NOTICE
-						"Marker %s busy, "
-						"probe %p already "
-						"installed\n",
-						name,
-						iter->mdata->call);
-					continue;
-				}
-			} else
-				iter->mdata->call = probe;
-			iter->mdata->pdata = pdata;
+	/* Using kmalloc here to allocate a variable length element. Could
+	 * cause some memory fragmentation if overused. */
+	e = kmalloc(sizeof(struct marker_entry) + name_len + 1 + format_len + 1,
+			GFP_KERNEL);
+	if (!e)
+		return -ENOMEM;
+	memcpy(&e->name[0], name, name_len + 1);
+	e->format = &e->name[name_len + 1];
+	memcpy(e->format, format, format_len + 1);
+	e->flags = flags;
+	e->probe = probe;
+	e->pdata = pdata;
+	hlist_add_head(&e->hlist, head);
+	return 0;
+}
+
+/* Remove the marker from the hash table. Must be called with mutex_lock
+ * held. */
+static void hash_remove_marker(const char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *e;
+	int found = 0;
+	size_t len = strlen(name);
+	u32 hash = jhash(name, len, 0);
+
+	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
+	hlist_for_each_entry(e, node, head, hlist)
+		if (!strcmp(name, e->name)) {
+			found = 1;
+			break;
 		}
-		found++;
+	if (found) {
+		hlist_del(&e->hlist);
+		kfree(e);
 	}
-	return found;
 }
 
-/* Sets a range of markers to a disabled state : unset the enable bit and
- * provide the empty callback.
- * Keep a count of other markers connected to the same module as the one
- * provided as parameter. */
-static int marker_remove_probe_range(const char *name,
+/* Sets the probe callback corresponding to one marker.
+ */
+static int set_marker(int flags, const char *name, const char *format,
+			marker_probe_func *probe, void *pdata,
+			struct __mark_marker *elem)
+{
+	BUG_ON(strcmp(name, elem->name) != 0);
+
+	if (format)
+		if (strcmp(format, elem->format) != 0) {
+			printk(KERN_NOTICE
+				"Format mismatch for probe %s "
+				"(%s), marker (%s)\n",
+				name,
+				format,
+				elem->format);
+			return -EPERM;
+		}
+	if (flags & CF_LOCKDEP
+		&& !(elem->flags & CF_LOCKDEP)) {
+		printk(KERN_NOTICE
+			"Incompatible lockdep flags for "
+			"probe %s\n",
+			name);
+		return -EPERM;
+	}
+	if (flags & CF_PRINTK
+		&& !(elem->flags & CF_PRINTK)) {
+		printk(KERN_NOTICE
+			"Incompatible printk flags for "
+			"probe %s\n",
+			name);
+		return -EPERM;
+	}
+	elem->call = probe;
+	elem->pdata = pdata;
+	return 0;
+}
+
+static void disable_marker(struct __mark_marker *elem)
+{
+	elem->call = __mark_empty_function;
+	/* Leave the pdata there, because removal is racy and should be done
+	 * only after a synchronize_sched(). It's never used anyway. */
+}
+
+/* Updates the probe callback corresponding to a range of markers. */
+static int marker_update_probe_range(
+	struct __mark_marker *begin,
+	struct __mark_marker *end,
 	struct module *probe_module,
-	int *ref_count,
-	const struct __mark_marker *begin,
-	const struct __mark_marker *end)
+	int *refcount)
 {
-	const struct __mark_marker *iter;
-	int found = 0;
+	struct __mark_marker *iter;
+	struct marker_entry *hash_mark;
+	int ret;
 
 	for (iter = begin; iter < end; iter++) {
-		if (strcmp(name, iter->mdata->name) != 0) {
+		hash_mark = hash_get_marker(iter->name);
+		if (hash_mark) {
+			ret = set_marker(hash_mark->flags,
+				hash_mark->name, hash_mark->format,
+				hash_mark->probe, hash_mark->pdata,
+				iter);
+			if (ret)
+				return ret;
 			if (probe_module)
-				if (__module_text_address(
-					(unsigned long)iter->mdata->call)
-						== probe_module)
-					(*ref_count)++;
-			continue;
+				if (probe_module ==
+			__module_text_address((unsigned long)hash_mark->probe))
+					(*refcount)++;
+		} else {
+			disable_marker(iter);
 		}
-		iter->mdata->call = __mark_empty_function;
-		found++;
 	}
-	return found;
+	return 0;
 }
 
-/* Provides a listing of the markers present in the kernel along with their
- * callback and format string. */
-static int marker_list_probe_range(marker_probe_func *probe,
-	const struct __mark_marker *begin,
-	const struct __mark_marker *end)
+/* Update probes, removing the faulty probes.
+ * Issues a synchronize_sched() when no reference to the module passed
+ * as parameter is found in the probes so the probe module can be
+ * safely unloaded from now on. */
+static int marker_update_probes(struct module *probe_module)
 {
-	const struct __mark_marker *iter;
-	int found = 0;
+	struct module *mod;
+	int ret;
+	int refcount = 0;
 
-	for (iter = begin; iter < end; iter++) {
-		if (probe)
-			if (probe != iter->mdata->call) continue;
-		printk("name %s func 0x%p format \"%s\"\n",
-			iter->mdata->name,
-			iter->mdata->call, iter->mdata->format);
-		found++;
+	mutex_lock(&module_mutex);
+	/* Core kernel markers */
+	ret = marker_update_probe_range(__start___markers,
+			__stop___markers, probe_module, &refcount);
+	if (ret)
+		goto end;
+	/* Markers in modules. */
+	list_for_each_entry(mod, &modules, list)
+		if (!mod->taints) {
+			ret = marker_update_probe_range(mod->markers,
+				mod->markers+mod->num_markers,
+				probe_module, &refcount);
+			if (ret)
+				goto end;
+		}
+end:
+	mutex_unlock(&module_mutex);
+	if (!ret && probe_module && refcount == 0)
+		synchronize_sched();
+	return ret;
+}
+
+/* Setup the marker according to the data present in the marker hash
+ * upon module load. If an error occur during the set probe range,
+ * refuse to load the module. */
+static int module_marker_update(struct module *mod)
+{
+	if (!mod->taints)
+		return marker_update_probe_range(mod->markers,
+			mod->markers+mod->num_markers, NULL, NULL);
+	return 0;
+}
+
+/* Arm the probe : set the callback for each marker and arm the cond_call.
+ * If the marker update fails, remove the probe and refresh the markers. */
+int _marker_arm_probe(int flags, const char *name, const char *format,
+			marker_probe_func *probe, void *pdata)
+{
+	int ret = 0;
+
+	ret = hash_add_marker(flags, name,
+			format, probe, pdata);
+	if (ret)
+		return ret;
+	ret = marker_update_probes(NULL);
+	if (ret) {
+		hash_remove_marker(name);
+		ret = marker_update_probes(NULL);
+		BUG_ON(ret);
 	}
-	return found;
+	ret = cond_call_arm(name);
+	return ret;
 }
+EXPORT_SYMBOL_GPL(_marker_arm_probe);
 
 /* Get the module to which the probe handler's text belongs.
  * Called with module_mutex taken.
  * Returns NULL if the probe handler is not in a module. */
 static struct module *__marker_get_probe_module(const char *name)
 {
-	struct module *mod;
-	const struct __mark_marker *iter;
+	struct marker_entry *hash_mark;
 
-	list_for_each_entry(mod, &modules, list) {
-		if (mod->taints)
-			continue;
-		for (iter = mod->markers;
-			iter < mod->markers+mod->num_markers; iter++) {
-			if (strcmp(name, iter->mdata->name) != 0)
-				continue;
-			if (iter->mdata->call)
-				return __module_text_address(
-					(unsigned long)iter->mdata->call);
-		}
-	}
+	hash_mark = hash_get_marker(name);
+	if (hash_mark)
+		return __module_text_address((unsigned long)hash_mark->probe);
 	return NULL;
 }
 
+/* Disarm the probe : disarm the con_call and set the empty callback for each
+ * marker. */
+void marker_disarm_probe(const char *name)
+{
+	struct module *probe_module;
+	int ret;
+
+	cond_call_disarm(name);
+
+	/* In what module is the probe handler ? */
+	probe_module = __marker_get_probe_module(name);
+
+	hash_remove_marker(name);
+	ret = marker_update_probes(probe_module);
+	BUG_ON(ret);
+}
+EXPORT_SYMBOL_GPL(marker_disarm_probe);
+
 /* Looks up a marker by its name and instance number within the specificed
  * range and returns the associated data structure. */
-const struct __mark_marker_data *marker_query_range(const char *name,
+static const struct __mark_marker *marker_query_range(const char *name,
 	int instance,
 	const struct __mark_marker *begin,
 	const struct __mark_marker *end)
@@ -742,96 +868,61 @@
 	int found = 0;
 
 	for (iter = begin; iter < end; iter++) {
-		if (strcmp(name, iter->mdata->name) != 0)
+		if (strcmp(name, iter->name) != 0)
 			continue;
-
 		if (found++ == instance)
-			return iter->mdata;
+			return iter;
 	}
 	return NULL;
 }
 
-/* Calls _marker_set_probe_range for the core markers and modules markers.
- * Marker arm uses the modlist_lock to synchronise. */
-static int marker_set_probe(int flags, const char *name, const char *format,
-				marker_probe_func *probe,
-				void *pdata)
+/* Looks up a marker by its name and instance number and returns the
+ * associated data structure. */
+const struct __mark_marker *marker_query(const char *name, int instance)
 {
 	struct module *mod;
-	int found = 0;
+	const struct __mark_marker *mdata;
 
 	mutex_lock(&module_mutex);
 	/* Core kernel markers */
-	found += _marker_set_probe_range(flags, name, format, probe,
-			pdata,
+	mdata = marker_query_range(name, instance,
 			__start___markers, __stop___markers);
-	/* Markers in modules. */
-	list_for_each_entry(mod, &modules, list) {
-		if (!mod->taints)
-			found += _marker_set_probe_range(flags, name, format,
-			probe, pdata,
-			mod->markers, mod->markers+mod->num_markers);
+	if (!mdata) {
+		/* Markers in modules. */
+		list_for_each_entry(mod, &modules, list)
+			if (!mod->taints) {
+				mdata = marker_query_range(name, instance,
+					mod->markers,
+					mod->markers+mod->num_markers);
+				if (mdata)
+					break;
+			}
 	}
 	mutex_unlock(&module_mutex);
-	return found;
+	return mdata;
 }
+EXPORT_SYMBOL_GPL(marker_query);
 
-/* Calls _marker_remove_probe_range for the core markers and modules markers.
- * Marker enabling/disabling use the modlist_lock to synchronise.
- * ref_count is the number of markers still connected to the same module
- * as the one in which sits the probe handler currently removed, excluding the
- * one currently removed. If the count is 0, we issue a synchronize_sched() to
- * make sure the module can safely unload. */
-static int marker_remove_probe(const char *name)
+/* Provides a listing of the markers present in the kernel along with their
+ * callback and format string. */
+static int marker_list_probe_range(marker_probe_func *probe,
+	const struct __mark_marker *begin,
+	const struct __mark_marker *end)
 {
-	struct module *mod, *probe_module;
+	const struct __mark_marker *iter;
 	int found = 0;
-	int ref_count = 0;
 
-	mutex_lock(&module_mutex);
-	/* In what module is the probe handler ? */
-	probe_module = __marker_get_probe_module(name);
-	/* Core kernel markers */
-	found += marker_remove_probe_range(name, probe_module, &ref_count,
-			__start___markers, __stop___markers);
-	/* Markers in modules. */
-	list_for_each_entry(mod, &modules, list) {
-		if (!mod->taints)
-			found += marker_remove_probe_range(name, probe_module,
-				&ref_count,
-				mod->markers, mod->markers+mod->num_markers);
+	for (iter = begin; iter < end; iter++) {
+		if (probe)
+			if (probe != iter->call) continue;
+		printk("name %s func 0x%p format \"%s\"\n",
+			iter->name,
+			iter->call, iter->format);
+		found++;
 	}
-	mutex_unlock(&module_mutex);
-	if (!ref_count)
-		synchronize_sched();
 	return found;
 }
 
-/* Arming a probe (set handler, enable cond_call). */
-int _marker_arm_probe(int flags, const char *name, const char *format,
-				marker_probe_func *probe, void *pdata)
-{
-	int ret;
-
-	ret = marker_set_probe(flags, name, format, probe, pdata);
-	if (ret)
-		ret = cond_call_arm(name);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(_marker_arm_probe);
-
-/* Disarm a probe (disable cond_call, remove handler). */
-int marker_disarm_probe(const char *name)
-{
-	int ret;
-
-	ret = cond_call_disarm(name);
-	if (ret)
-		ret = marker_remove_probe(name);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(marker_disarm_probe);
-
 /* Calls _marker_list_probe_range for the core markers and modules markers.
  * Marker listing uses the modlist_lock to synchronise.
  * TODO : should output this listing to a procfs file. */
@@ -858,33 +949,11 @@
 	return found;
 }
 EXPORT_SYMBOL_GPL(marker_list_probe);
-
-/* Looks up a marker by its name and instance number and returns the
- * associated data structure. */
-const struct __mark_marker_data *marker_query(const char *name, int instance)
+#else
+static int module_marker_update(struct module *mod)
 {
-	struct module *mod;
-	const struct __mark_marker_data *mdata;
-
-	mutex_lock(&module_mutex);
-	/* Core kernel markers */
-	mdata = marker_query_range(name, instance,
-			__start___markers, __stop___markers);
-	if (!mdata) {
-		/* Markers in modules. */
-		list_for_each_entry(mod, &modules, list)
-			if (!mod->taints) {
-				mdata = marker_query_range(name, instance,
-					mod->markers,
-					mod->markers+mod->num_markers);
-				if (mdata)
-					break;
-			}
-	}
-	mutex_unlock(&module_mutex);
-	return mdata;
+	return 0;
 }
-EXPORT_SYMBOL_GPL(marker_query);
 #endif
 
 #ifdef CONFIG_SMP
@@ -2247,7 +2316,6 @@
 	unsigned int condcallindex;
 	unsigned int condcallstringsindex;
 	unsigned int markersindex;
-	unsigned int markersdataindex;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -2347,7 +2415,6 @@
 	condcallindex = find_sec(hdr, sechdrs, secstrings, "__cond_call");
 	condcallstringsindex = find_sec(hdr, sechdrs, secstrings, "__cond_call_strings");
 	markersindex = find_sec(hdr, sechdrs, secstrings, "__markers");
-	markersdataindex = find_sec(hdr, sechdrs, secstrings, "__markers_data");
 
 	/* Don't keep modinfo section */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -2373,13 +2440,9 @@
 #ifdef CONFIG_MARKERS
 	if (markersindex)
 		sechdrs[markersindex].sh_flags |= SHF_ALLOC;
-	if (markersdataindex)
-		sechdrs[markersdataindex].sh_flags |= SHF_ALLOC;
 #else
 	if (markersindex)
 		sechdrs[markersindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
-	if (markersdataindex)
-		sechdrs[markersdataindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
 #endif
 
 	/* Check module struct version now, before we try to use module. */
@@ -2590,6 +2653,10 @@
 
 	add_kallsyms(mod, sechdrs, symindex, strindex, secstrings);
 
+	err = module_marker_update(mod);
+	if (err < 0)
+		goto cleanup;
+
 	module_cond_call_setup(mod);
 
 	err = module_finalize(hdr, sechdrs, mod);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

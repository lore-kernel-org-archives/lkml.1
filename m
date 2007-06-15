Return-Path: <linux-kernel-owner+w=401wt.eu-S1758982AbXFOUhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982AbXFOUhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758312AbXFOUhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:37:03 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56586 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830AbXFOUg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:36:58 -0400
Message-Id: <20070615203550.345828862@polymtl.ca>
References: <20070615202959.316963297@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 15 Jun 2007 16:30:01 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 2/5] Linux Kernel Markers, architecture independent code.
Content-Disposition: inline; filename=linux-kernel-markers-architecture-independent-code.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 15 Jun 2007 20:36:05 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The marker activation functions sits in kernel/marker.c. A linked list is used
to keep track of the armed/disarmed markers, so they can be activated at module
load time.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---

 include/asm-generic/vmlinux.lds.h |   11 
 include/linux/marker.h            |  108 ++++++++
 include/linux/module.h            |    5 
 kernel/Makefile                   |    1 
 kernel/marker.c                   |  491 ++++++++++++++++++++++++++++++++++++++
 kernel/module.c                   |   19 +
 6 files changed, 634 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-06-15 16:14:08.000000000 -0400
+++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-06-15 16:14:10.000000000 -0400
@@ -129,6 +129,11 @@
 		VMLINUX_SYMBOL(__stop___immediate) = .;			\
 	}								\
 									\
+	/* Markers: strings */						\
+        __markers_strings : AT(ADDR(__markers_strings) - LOAD_OFFSET) {	\
+		*(__markers_strings)					\
+ 	}								\
+									\
 	/* Kernel symbol table: strings */				\
         __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {	\
 		*(__ksymtab_strings)					\
@@ -153,7 +158,11 @@
 /* EXTRARW_DATA adds a place to declare rw data that will not be mixed with the
  * .data content; therefore limiting data cache pollution when data is put in
  * the EXTRARW_DATA sections. */
-#define EXTRARW_DATA
+#define EXTRARW_DATA							\
+		. = ALIGN(8);						\
+		VMLINUX_SYMBOL(__start___markers) = .;			\
+		*(__markers)						\
+		VMLINUX_SYMBOL(__stop___markers) = .;
 
 #define SECURITY_INIT							\
 	.security_initcall.init : AT(ADDR(.security_initcall.init) - LOAD_OFFSET) { \
Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/linux/marker.h	2007-06-15 16:14:10.000000000 -0400
@@ -0,0 +1,108 @@
+#ifndef _LINUX_MARKER_H
+#define _LINUX_MARKER_H
+
+/*
+ * Code markup for dynamic and static tracing.
+ *
+ * See Documentation/marker.txt.
+ *
+ * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#ifdef __KERNEL__
+
+#include <linux/immediate.h>
+
+struct module;
+struct __mark_marker;
+
+typedef void marker_probe_func(const struct __mark_marker *mdata,
+	const char *fmt, ...);
+
+struct __mark_marker {
+	const char *name;	/* Marker name */
+	const char *format;	/* Marker format string, describing the
+				 * variable argument list.
+				 */
+	const char *args;	/* List of arguments litteraly transformed
+				 * into a string: "arg1, arg2, arg3".
+				 */
+	immediate_t state;	/* Immediate value state. */
+	int flags;		/* Flags controlling the markers flavor.
+				 * Passed to the contidional call declaration
+				 * and used to check that the probe matches the
+				 * markers restrictions at connexion time. */
+	marker_probe_func *call;/* Probe handler function pointer */
+	void *pdata;		/* Private probe data */
+};
+
+#ifdef CONFIG_MARKERS
+
+/* Generic marker flavor always available.
+ * Note : the empty asm volatile with read constraint is used here instead of a
+ * "used" attribute to fix a gcc 4.1.x bug. */
+#define _trace_mark(flags, name, format, args...)			\
+	do {								\
+		static const char __mstrtab_name_##name[]		\
+		__attribute__((section("__markers_strings")))		\
+		= #name;						\
+		static const char __mstrtab_format_##name[]		\
+		__attribute__((section("__markers_strings")))		\
+		= format;						\
+		static const char __mstrtab_args_##name[]		\
+		__attribute__((section("__markers_strings")))		\
+		= #args;						\
+		static struct __mark_marker __mark_##name		\
+		__attribute__((section("__markers"))) =			\
+		{ __mstrtab_name_##name,  __mstrtab_format_##name,	\
+		__mstrtab_args_##name, { 0 }, (flags),			\
+		__mark_empty_function, NULL };				\
+		asm volatile ( "" : : "i" (&__mark_##name));		\
+		__mark_check_format(format, ## args);			\
+		if (unlikely(_immediate((flags), __mark_##name.state))) { \
+			preempt_disable();				\
+			(*__mark_##name.call)(&__mark_##name, format, ## args);\
+			preempt_enable();				\
+		}							\
+	} while (0)
+
+extern int module_marker_update(struct module *mod);
+#else /* !CONFIG_MARKERS */
+#define _trace_mark(flags, name, format, args...) \
+		__mark_check_format(format, ## args)
+static inline int module_marker_update(struct module *mod)
+{
+	return 0;
+}
+#endif /* CONFIG_MARKERS */
+
+/* Marker with default behavior */
+#define trace_mark(name, format, args...) \
+	_trace_mark(IF_DEFAULT, name, format, ## args)
+
+#define MARK_MAX_FORMAT_LEN	1024
+/* Pass this as a format string for a marker with no argument */
+#define MARK_NOARGS " "
+
+/* To be used for string format validity checking with sparse */
+static inline
+void __mark_check_format(const char *fmt, ...)
+{ }
+
+extern marker_probe_func __mark_empty_function;
+
+extern int _marker_arm_probe(int flags, const char *name, const char *format,
+				marker_probe_func *probe, void *pdata);
+
+#define marker_arm_probe(name, format, probe, pdata) \
+		_marker_arm_probe(IF_DEFAULT, name, format, probe, pdata)
+
+extern void marker_disarm_probe(const char *name);
+extern int marker_list_probe(marker_probe_func *probe);
+const struct __mark_marker *marker_query(const char *name, int instance);
+
+#endif /* __KERNEL__ */
+#endif
Index: linux-2.6-lttng/include/linux/module.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/module.h	2007-06-15 16:13:49.000000000 -0400
+++ linux-2.6-lttng/include/linux/module.h	2007-06-15 16:14:10.000000000 -0400
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
 #include <linux/immediate.h>
+#include <linux/marker.h>
 #include <asm/local.h>
 
 #include <asm/module.h>
@@ -364,6 +365,10 @@
 	const struct __immediate *immediates;
 	unsigned int num_immediates;
 #endif
+#ifdef CONFIG_MARKERS
+	struct __mark_marker *markers;
+	unsigned int num_markers;
+#endif
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2007-06-15 16:13:49.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2007-06-15 16:14:10.000000000 -0400
@@ -1681,6 +1681,10 @@
 #ifdef CONFIG_IMMEDIATE
 	immediateindex = find_sec(hdr, sechdrs, secstrings, "__immediate");
 #endif
+#ifdef CONFIG_MARKERS
+	markersindex = find_sec(hdr, sechdrs, secstrings, "__markers");
+ 	markersstringsindex = find_sec(hdr, sechdrs, secstrings, "__markers_strings");
+#endif
 
 	/* Don't keep modinfo section */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -1840,6 +1844,10 @@
 			sechdrs[immediateindex].sh_size / sizeof(*mod->immediates);
 	}
 #endif
+	if (markersindex)
+		sechdrs[markersindex].sh_flags |= SHF_ALLOC;
+	if (markersstringsindex)
+		sechdrs[markersstringsindex].sh_flags |= SHF_ALLOC;
 
 	mod->unused_syms = (void *)sechdrs[unusedindex].sh_addr;
 	if (unusedcrcindex)
@@ -1881,6 +1889,13 @@
 		if (err < 0)
 			goto cleanup;
 	}
+#ifdef CONFIG_MARKERS
+	if (markersindex) {
+		mod->markers = (void *)sechdrs[markersindex].sh_addr;
+		mod->num_markers =
+			sechdrs[markersindex].sh_size / sizeof(*mod->markers);
+	}
+#endif
 
         /* Find duplicate symbols */
 	err = verify_export_symbols(mod);
@@ -1899,6 +1914,10 @@
 
 	add_kallsyms(mod, sechdrs, symindex, strindex, secstrings);
 
+	err = module_marker_update(mod);
+	if (err < 0)
+		goto cleanup;
+
 	module_immediate_setup(mod);
 
 	err = module_finalize(hdr, sechdrs, mod);
Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/kernel/marker.c	2007-06-15 16:14:10.000000000 -0400
@@ -0,0 +1,491 @@
+/*
+ * Copyright (C) 2007 Mathieu Desnoyers
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/rcupdate.h>
+#include <linux/marker.h>
+
+extern struct __mark_marker __start___markers[];
+extern struct __mark_marker __stop___markers[];
+
+/*
+ * module_mutex nests inside markers_mutex. Markers mutex protects the builtin
+ * and module markers.
+ */
+DEFINE_MUTEX(markers_mutex);
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
+static HLIST_HEAD(marker_list);
+
+/*
+ * Empty callback provided as a probe to the markers. By providing this to a
+ * disabled marker, we makes sure the  execution flow is always valid even
+ * though the function pointer change and the marker enabling are two distinct
+ * operations that modifies the execution flow of preemptible code.
+ */
+void __mark_empty_function(const struct __mark_marker *mdata,
+	const char *fmt, ...)
+{
+}
+EXPORT_SYMBOL_GPL(__mark_empty_function);
+
+/*
+ * Get marker if the marker is present in the marker list.
+ * Must be called with markers_mutex held.
+ * Returns NULL if not present.
+ */
+static struct marker_entry *_get_marker(const char *name)
+{
+	struct hlist_node *node;
+	struct marker_entry *e;
+
+	hlist_for_each_entry(e, node, &marker_list, hlist)
+		if (!strcmp(name, e->name))
+			return e;
+	return NULL;
+}
+
+/*
+ * Add the marker to the marker list. Must be called with markers_mutex held.
+ */
+static int _add_marker(int flags, const char *name,
+	const char *format, marker_probe_func *probe, void *pdata)
+{
+	struct hlist_node *node;
+	struct marker_entry *e;
+	size_t name_len = strlen(name);
+	size_t format_len = strlen(format);
+
+	hlist_for_each_entry(e, node, &marker_list, hlist) {
+		if (!strcmp(name, e->name)) {
+			printk(KERN_NOTICE
+				"Marker %s busy, probe %p already installed\n",
+				name, e->probe);
+			return -EBUSY;	/* Already there */
+		}
+	}
+	/*
+	 * Using kmalloc here to allocate a variable length element. Could
+	 * cause some memory fragmentation if overused.
+	 */
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
+	hlist_add_head(&e->hlist, &marker_list);
+	return 0;
+}
+
+/*
+ * Remove the marker from the marker list. Must be called with mutex_lock
+ * held.
+ */
+static void _remove_marker(const char *name)
+{
+	struct hlist_node *node;
+	struct marker_entry *e;
+	int found = 0;
+
+	hlist_for_each_entry(e, node, &marker_list, hlist) {
+		if (!strcmp(name, e->name)) {
+			found = 1;
+			break;
+		}
+	}
+	if (found) {
+		hlist_del(&e->hlist);
+		kfree(e);
+	}
+}
+
+/* Sets the probe callback corresponding to one marker. */
+static int _set_marker(int flags, const char *name, const char *format,
+			marker_probe_func *probe, void *pdata,
+			struct __mark_marker *elem)
+{
+	BUG_ON(strcmp(name, elem->name) != 0);
+
+	if (format) {
+		if (strcmp(format, elem->format) != 0) {
+			printk(KERN_NOTICE
+				"Format mismatch for probe %s "
+				"(%s), marker (%s)\n",
+				name,
+				format,
+				elem->format);
+			return -EPERM;
+		}
+	}
+	if (flags & IF_LOCKDEP
+		&& !(elem->flags & IF_LOCKDEP)) {
+		printk(KERN_NOTICE
+			"Incompatible lockdep flags for "
+			"probe %s\n",
+			name);
+		return -EPERM;
+	}
+	elem->call = probe;
+	elem->pdata = pdata;
+	__immediate_update(&elem->state, 1);
+	return 0;
+}
+
+static void _disable_marker(struct __mark_marker *elem)
+{
+	__immediate_update(&elem->state, 0);
+	elem->call = __mark_empty_function;
+	/*
+	 * Leave the pdata there, because removal is racy and should be done
+	 * only after a synchronize_sched(). It's never used anyway.
+	 */
+}
+
+/*
+ * Updates the probe callback corresponding to a range of markers.
+ * Must be called with markers_mutex held.
+ */
+static int _marker_update_probe_range(
+	struct __mark_marker *begin,
+	struct __mark_marker *end,
+	struct module *probe_module,
+	int *refcount)
+{
+	struct __mark_marker *iter;
+	struct marker_entry *mark_entry;
+	int ret;
+
+	for (iter = begin; iter < end; iter++) {
+		mark_entry = _get_marker(iter->name);
+		if (mark_entry) {
+			ret = _set_marker(mark_entry->flags,
+				mark_entry->name, mark_entry->format,
+				mark_entry->probe, mark_entry->pdata,
+				iter);
+			if (ret)
+				return ret;
+			if (probe_module)
+				if (probe_module ==
+			__module_text_address((unsigned long)mark_entry->probe))
+					(*refcount)++;
+		} else {
+			_disable_marker(iter);
+		}
+	}
+	return 0;
+}
+
+#ifdef CONFIG_MODULES
+/*
+ * Update module probes.
+ * Must be called with markers_mutex held.
+ */
+static inline int __marker_update_probes_modules(struct module *probe_module,
+	int *refcount)
+{
+	int ret = 0;
+	struct module *mod;
+
+	list_for_each_entry(mod, &modules, list) {
+		if (!mod->taints) {
+			ret = _marker_update_probe_range(mod->markers,
+				mod->markers+mod->num_markers,
+				probe_module, refcount);
+			if (ret)
+				break;
+		}
+	}
+	return ret;
+}
+#else
+static inline int __marker_update_probes_modules(struct module *probe_module,
+	int *refcount)
+{
+	return 0;
+}
+#endif
+
+/*
+ * Update probes, removing the faulty probes.
+ * Issues a synchronize_sched() when no reference to the module passed
+ * as parameter is found in the probes so the probe module can be
+ * safely unloaded from now on.
+ */
+static inline int __marker_update_probes(struct module *probe_module)
+{
+	int ret;
+	int refcount = 0;
+
+	/* Core kernel markers */
+	ret = _marker_update_probe_range(__start___markers,
+			__stop___markers, probe_module, &refcount);
+	if (ret)
+		goto end;
+	/* Markers in modules. */
+	ret = __marker_update_probes_modules(probe_module, &refcount);
+end:
+	if (!ret && probe_module && refcount == 0)
+		synchronize_sched();
+	return ret;
+}
+
+#ifdef CONFIG_MODULES
+/*
+ * Setup the marker according to the data present in the marker list
+ * upon module load. If an error occur during the set probe range,
+ * refuse to load the module. Must be called with module_mutex held.
+ */
+int module_marker_update(struct module *mod)
+{
+	if (!mod->taints)
+		return _marker_update_probe_range(mod->markers,
+			mod->markers+mod->num_markers, NULL, NULL);
+	return 0;
+}
+
+/*
+ * Update the system wide probes, with modules. */
+static inline int _marker_update_probes(struct module *probe_module)
+{
+	int ret;
+	mutex_lock(&module_mutex);
+	ret = __marker_update_probes(probe_module);
+	mutex_unlock(&module_mutex);
+	return ret;
+}
+#else
+/* Update the system wide probes, without modules. */
+static inline int _marker_update_probes(struct module *probe_module)
+{
+	return __marker_update_probes(probe_module);
+}
+#endif
+
+/*
+ * Arm the probe : set the callback for each marker and arm the immediate.
+ * If the marker update fails, remove the probe and refresh the markers.
+ */
+int _marker_arm_probe(int flags, const char *name, const char *format,
+			marker_probe_func *probe, void *pdata)
+{
+	int ret = 0;
+
+	mutex_lock(&markers_mutex);
+	ret = _add_marker(flags, name,
+			format, probe, pdata);
+	if (ret)
+		goto end;
+	ret = _marker_update_probes(NULL);
+	if (ret) {
+		_remove_marker(name);
+		ret = _marker_update_probes(NULL);
+		BUG_ON(ret);
+	}
+end:
+	mutex_unlock(&markers_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(_marker_arm_probe);
+
+/*
+ * Get the module to which the probe handler's text belongs.
+ * Called with module_mutex taken.
+ * Returns NULL if the probe handler is not in a module.
+ */
+static struct module *__marker_get_probe_module(const char *name)
+{
+	struct marker_entry *mark_entry;
+
+	mark_entry = _get_marker(name);
+	if (mark_entry)
+		return __module_text_address((unsigned long)mark_entry->probe);
+	return NULL;
+}
+
+/*
+ * Disarm the probe : disarm the immediate and set the empty callback for each
+ * marker.
+ */
+void marker_disarm_probe(const char *name)
+{
+	struct module *probe_module;
+	int ret;
+
+	mutex_lock(&markers_mutex);
+	/* In what module is the probe handler ? */
+	probe_module = __marker_get_probe_module(name);
+
+	_remove_marker(name);
+	ret = _marker_update_probes(probe_module);
+	BUG_ON(ret);
+	mutex_unlock(&markers_mutex);
+}
+EXPORT_SYMBOL_GPL(marker_disarm_probe);
+
+/*
+ * Looks up a marker by its name and instance number within the specificed
+ * range and returns the associated data structure.
+ */
+static const struct __mark_marker *_marker_query_range(const char *name,
+	int instance,
+	const struct __mark_marker *begin,
+	const struct __mark_marker *end)
+{
+	const struct __mark_marker *iter;
+	int found = 0;
+
+	for (iter = begin; iter < end; iter++) {
+		if (strcmp(name, iter->name) != 0)
+			continue;
+		if (found++ == instance)
+			return iter;
+	}
+	return NULL;
+}
+
+/* Query the markers in the modules */
+#ifdef CONFIG_MODULES
+static inline const struct __mark_marker *marker_query_modules(const char *name,
+			int instance)
+{
+	struct module *mod;
+	const struct __mark_marker *mdata = NULL;
+
+	mutex_lock(&module_mutex);
+	/* Markers in modules. */
+	list_for_each_entry(mod, &modules, list) {
+		if (!mod->taints) {
+			mdata = _marker_query_range(name, instance,
+				mod->markers,
+				mod->markers+mod->num_markers);
+			if (mdata)
+				break;
+		}
+	}
+	mutex_unlock(&module_mutex);
+	return mdata;
+}
+#else
+static inline const struct __mark_marker *marker_query_modules(const char *name,
+			int instance)
+{
+	return NULL;
+}
+#endif
+
+/*
+ * Looks up a marker by its name and instance number and returns the
+ * associated data structure.
+ */
+const struct __mark_marker *marker_query(const char *name, int instance)
+{
+	const struct __mark_marker *mdata;
+
+	mutex_lock(&markers_mutex);
+	/* Core kernel markers */
+	mdata = _marker_query_range(name, instance,
+			__start___markers, __stop___markers);
+	if (!mdata)
+		mdata = marker_query_modules(name, instance);
+	mutex_unlock(&markers_mutex);
+	return mdata;
+}
+EXPORT_SYMBOL_GPL(marker_query);
+
+/*
+ * Provides a listing of the markers present in the kernel along with their
+ * callback and format string.
+ */
+static int _marker_list_probe_range(marker_probe_func *probe,
+	const struct __mark_marker *begin,
+	const struct __mark_marker *end)
+{
+	const struct __mark_marker *iter;
+	int found = 0;
+
+	for (iter = begin; iter < end; iter++) {
+		if (probe)
+			if (probe != iter->call) continue;
+		printk("name %s func 0x%p format \"%s\"\n",
+			iter->name,
+			iter->call, iter->format);
+		found++;
+	}
+	return found;
+}
+
+#ifdef CONFIG_MODULES
+static inline int marker_list_probe_modules(marker_probe_func *probe)
+{
+	int found = 0;
+	struct module *mod;
+
+	printk("Listing module markers\n");
+	mutex_lock(&module_mutex);
+	list_for_each_entry(mod, &modules, list) {
+		if (!mod->taints) {
+			printk("Listing markers for module %s\n", mod->name);
+			found += _marker_list_probe_range(probe,
+				mod->markers, mod->markers+mod->num_markers);
+		}
+	}
+	mutex_unlock(&module_mutex);
+	return found;
+}
+#else
+static inline int marker_list_probe_modules(marker_probe_func *probe)
+{
+	return 0;
+}
+#endif
+
+/*
+ * Calls _marker_list_probe_range for the core markers and modules markers.
+ * Marker listing uses the modlist_lock to synchronise.
+ * TODO : should output this listing to a procfs file.
+ */
+int marker_list_probe(marker_probe_func *probe)
+{
+	int found = 0;
+
+	mutex_lock(&markers_mutex);
+	/* Core kernel markers */
+	printk("Listing kernel markers\n");
+	found += _marker_list_probe_range(probe,
+			__start___markers, __stop___markers);
+	/* Markers in modules. */
+	found += marker_list_probe_modules(probe);
+	mutex_unlock(&markers_mutex);
+	return found;
+}
+EXPORT_SYMBOL_GPL(marker_list_probe);
Index: linux-2.6-lttng/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/kernel/Makefile	2007-06-15 16:13:50.000000000 -0400
+++ linux-2.6-lttng/kernel/Makefile	2007-06-15 16:14:10.000000000 -0400
@@ -57,6 +57,7 @@
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_IMMEDIATE) += immediate.o
+obj-$(CONFIG_MARKERS) += marker.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

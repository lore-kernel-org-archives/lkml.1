Return-Path: <linux-kernel-owner+w=401wt.eu-S937689AbXGNBgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937689AbXGNBgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935321AbXGNBb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:31:58 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:39118 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936895AbXGNBbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:31:52 -0400
Message-Id: <20070714013050.289300592@polymtl.ca>
References: <20070714012914.508504384@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 13 Jul 2007 21:29:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 1/4] Linux Kernel Markers, architecture independent code.
Content-Disposition: inline; filename=linux-kernel-markers-architecture-independent-code.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat, 14 Jul 2007 01:30:50 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The marker activation functions sits in kernel/marker.c. A hash table is used
to keep track of the registered probes and armed markers, so the markers within
a newly loaded module that should be active can be activated at module load
time.

marker_query has been removed. marker_get_first, marker_get_next and
marker_release should be used as iterators on the markers.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---

 include/asm-generic/vmlinux.lds.h |   11 
 include/linux/marker.h            |  136 ++++++++
 include/linux/module.h            |    5 
 kernel/marker.c                   |  636 ++++++++++++++++++++++++++++++++++++++
 kernel/module.c                   |   19 +
 5 files changed, 806 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-07-13 09:08:46.000000000 -0400
+++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-07-13 10:32:40.000000000 -0400
@@ -12,7 +12,11 @@
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
-	*(.data.init.refok)
+	*(.data.init.refok)						\
+	. = ALIGN(8);							\
+	VMLINUX_SYMBOL(__start___markers) = .;				\
+	*(__markers)							\
+	VMLINUX_SYMBOL(__stop___markers) = .;
 
 #define RO_DATA(align)							\
 	. = ALIGN((align));						\
@@ -129,6 +133,11 @@
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
Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/linux/marker.h	2007-07-13 10:33:58.000000000 -0400
@@ -0,0 +1,136 @@
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
+#include <linux/types.h>
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
+	immediate_char_t state;	/* Immediate value state. */
+	marker_probe_func *call;/* Probe handler function pointer */
+	void *pdata;		/* Private probe data */
+} __attribute__((aligned(8)));
+
+#ifdef CONFIG_MARKERS
+
+/*
+ * Generic marker flavor always available.
+ * Note : the empty asm volatile with read constraint is used here instead of a
+ * "used" attribute to fix a gcc 4.1.x bug.
+ * Make sure the alignment of the structure in the __markers section will
+ * not add unwanted padding between the beginning of the section and the
+ * structure. Force alignment to the same alignment as the section start.
+ */
+#define __trace_mark(generic, name, format, args...)			\
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
+		{ __mstrtab_name_##name, __mstrtab_format_##name,	\
+		__mstrtab_args_##name, { 0 },				\
+		__mark_empty_function, NULL };				\
+		asm volatile ( "" : : "i" (&__mark_##name));		\
+		__mark_check_format(format, ## args);			\
+		if (!generic) {						\
+			immediate_if (&__mark_##name.state) { 		\
+				preempt_disable();			\
+				(*__mark_##name.call)			\
+					(&__mark_##name, format, ## args); \
+				preempt_enable();			\
+			}						\
+		} else {						\
+			_immediate_if (&__mark_##name.state) { 		\
+				preempt_disable();			\
+				(*__mark_##name.call)			\
+					(&__mark_##name, format, ## args); \
+				preempt_enable();			\
+			}						\
+		}							\
+	} while (0)
+
+extern void module_marker_update(struct module *mod);
+#else /* !CONFIG_MARKERS */
+#define __trace_mark(generic, name, format, args...) \
+		__mark_check_format(format, ## args)
+static inline void module_marker_update(struct module *mod) { }
+#endif /* CONFIG_MARKERS */
+
+/* Marker with default behavior */
+#define trace_mark(name, format, args...) \
+	__trace_mark(0, name, format, ## args)
+/*
+ * Map to the generic marker. Should be used for markers in __init and __exit
+ * functions and in lockdep code.
+ */
+#define _trace_mark(name, format, args...) \
+	__trace_mark(1, name, format, ## args)
+
+#define MARK_MAX_FORMAT_LEN	1024
+/* Pass this as a format string for a marker with no argument */
+#define MARK_NOARGS " "
+
+/* To be used for string format validity checking with gcc */
+static inline void __mark_check_format(const char *fmt, ...)
+		__attribute__ ((format (printf, 1, 2)));
+static inline void __mark_check_format(const char *fmt, ...) { }
+
+extern marker_probe_func __mark_empty_function;
+
+/*
+ * Connect a probe to a markers.
+ * pdata must be a valid allocated memory address, or NULL.
+ */
+extern int marker_probe_register(const char *name, const char *format,
+				marker_probe_func *probe, void *pdata);
+
+/*
+ * Returns the pdata given to marker_probe_register.
+ */
+extern void *marker_probe_unregister(const char *name);
+/*
+ * Unregister a marker by providing the registered pdata.
+ */
+extern void *marker_probe_unregister_pdata(void *pdata);
+
+extern int marker_arm(const char *name);
+extern int marker_disarm(const char *name);
+extern struct __mark_marker *marker_get_first(void);
+extern struct __mark_marker *marker_get_next(struct __mark_marker *iter);
+extern void marker_release(struct __mark_marker *iter);
+extern void *marker_get_pdata(const char *name);
+
+#endif /* __KERNEL__ */
+#endif
Index: linux-2.6-lttng/include/linux/module.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/module.h	2007-07-13 09:08:46.000000000 -0400
+++ linux-2.6-lttng/include/linux/module.h	2007-07-13 10:33:14.000000000 -0400
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
 #include <linux/immediate.h>
+#include <linux/marker.h>
 #include <asm/local.h>
 
 #include <asm/module.h>
@@ -380,6 +381,10 @@
 	const struct __immediate *immediate;
 	unsigned int num_immediate;
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
--- linux-2.6-lttng.orig/kernel/module.c	2007-07-13 09:08:46.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2007-07-13 10:33:14.000000000 -0400
@@ -1625,6 +1625,8 @@
 	unsigned int unusedgplindex;
 	unsigned int unusedgplcrcindex;
 	unsigned int immediateindex = 0;
+	unsigned int markersindex = 0;
+	unsigned int markersstringsindex = 0;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -1724,6 +1726,10 @@
 #ifdef CONFIG_IMMEDIATE
 	immediateindex = find_sec(hdr, sechdrs, secstrings, "__immediate");
 #endif
+#ifdef CONFIG_MARKERS
+	markersindex = find_sec(hdr, sechdrs, secstrings, "__markers");
+ 	markersstringsindex = find_sec(hdr, sechdrs, secstrings, "__markers_strings");
+#endif
 
 	/* Don't keep modinfo section */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -1883,6 +1889,10 @@
 			sechdrs[immediateindex].sh_size / sizeof(*mod->immediate);
 	}
 #endif
+	if (markersindex)
+		sechdrs[markersindex].sh_flags |= SHF_ALLOC;
+	if (markersstringsindex)
+		sechdrs[markersstringsindex].sh_flags |= SHF_ALLOC;
 
 	mod->unused_syms = (void *)sechdrs[unusedindex].sh_addr;
 	if (unusedcrcindex)
@@ -1924,6 +1934,13 @@
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
@@ -1948,6 +1965,8 @@
         }
 #endif
 
+	module_marker_update(mod);
+
 	module_immediate_setup(mod);
 
 	err = module_finalize(hdr, sechdrs, mod);
Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/kernel/marker.c	2007-07-13 14:04:02.000000000 -0400
@@ -0,0 +1,636 @@
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
+#include <linux/jhash.h>
+#include <linux/list.h>
+#include <linux/rcupdate.h>
+#include <linux/marker.h>
+#include <linux/err.h>
+#include <linux/immediate.h>
+
+extern struct __mark_marker __start___markers[];
+extern struct __mark_marker __stop___markers[];
+
+/*
+ * module_mutex nests inside markers_mutex. Markers mutex protects the builtin
+ * and module markers, and the hash table.
+ */
+DEFINE_MUTEX(markers_mutex);
+
+/*
+ * Marker hash table, containing the active markers.
+ * Protected by module_mutex.
+ */
+#define MARKER_HASH_BITS 6
+#define MARKER_TABLE_SIZE (1 << MARKER_HASH_BITS)
+
+struct marker_entry {
+	struct hlist_node hlist;
+	char *format;
+	marker_probe_func *probe;
+	void *pdata;
+	int refcount;	/* Number of times armed. 0 if disarmed. */
+	char name[0];	/* Contains name'\0'format'\0' */
+};
+
+static struct hlist_head marker_table[MARKER_TABLE_SIZE];
+
+/*
+ * Empty callback provided as a probe to the markers. By providing this to a
+ * disabled marker, we makes sure the  execution flow is always valid even
+ * though the function pointer change and the marker enabling are two distinct
+ * operations that modifies the execution flow of preemptible code.
+ */
+void __mark_empty_function(const struct __mark_marker *mdata,
+	const char *fmt, ...)
+{ }
+EXPORT_SYMBOL_GPL(__mark_empty_function);
+
+/*
+ * Get marker if the marker is present in the marker hash table.
+ * Must be called with markers_mutex held.
+ * Returns NULL if not present.
+ */
+static struct marker_entry *_get_marker(const char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *e;
+	size_t len = strlen(name) + 1;
+	u32 hash = jhash(name, len-1, 0);
+
+	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
+	hlist_for_each_entry(e, node, head, hlist) {
+		if (!strcmp(name, e->name))
+			return e;
+	}
+	return NULL;
+}
+
+/*
+ * Add the marker to the marker hash table. Must be called with markers_mutex
+ * held.
+ */
+static int _add_marker(const char *name,
+	const char *format, marker_probe_func *probe, void *pdata)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *e;
+	size_t name_len = strlen(name) + 1;
+	size_t format_len = 0;
+	u32 hash = jhash(name, name_len-1, 0);
+
+	if (format)
+		format_len = strlen(format) + 1;
+	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
+	hlist_for_each_entry(e, node, head, hlist) {
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
+	e = kmalloc(sizeof(struct marker_entry) + name_len + format_len,
+			GFP_KERNEL);
+	if (!e)
+		return -ENOMEM;
+	memcpy(&e->name[0], name, name_len);
+	if (format) {
+		e->format = &e->name[name_len];
+		memcpy(e->format, format, format_len);
+		trace_mark(core_marker_format, "name %s format %s",
+				e->name, e->format);
+	} else
+		e->format = NULL;
+	e->probe = probe;
+	e->pdata = pdata;
+	e->refcount = 0;
+	hlist_add_head(&e->hlist, head);
+	return 0;
+}
+
+/*
+ * Remove the marker from the marker hash table. Must be called with mutex_lock
+ * held.
+ */
+static void *_remove_marker(const char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *e;
+	int found = 0;
+	size_t len = strlen(name) + 1;
+	void *pdata = NULL;
+	u32 hash = jhash(name, len-1, 0);
+
+	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
+	hlist_for_each_entry(e, node, head, hlist) {
+		if (!strcmp(name, e->name)) {
+			found = 1;
+			break;
+		}
+	}
+	if (found) {
+		pdata = e->pdata;
+		hlist_del(&e->hlist);
+		kfree(e);
+	}
+	return pdata;
+}
+
+/*
+ * Set the mark_entry format to the format found in the element.
+ */
+static int _marker_set_format(struct marker_entry **entry, const char *format)
+{
+	struct marker_entry *e;
+	size_t name_len = strlen((*entry)->name) + 1;
+	size_t format_len = strlen(format) + 1;
+
+	e = kmalloc(sizeof(struct marker_entry) + name_len + format_len,
+			GFP_KERNEL);
+	if (!e)
+		return -ENOMEM;
+	memcpy(&e->name[0], (*entry)->name, name_len);
+	e->format = &e->name[name_len];
+	memcpy(e->format, format, format_len);
+	e->probe = (*entry)->probe;
+	e->pdata = (*entry)->pdata;
+	e->refcount = (*entry)->refcount;
+	hlist_add_before(&e->hlist, &(*entry)->hlist);
+	hlist_del(&(*entry)->hlist);
+	kfree(*entry);
+	*entry = e;
+	trace_mark(core_marker_format, "name %s format %s",
+			e->name, e->format);
+	return 0;
+}
+
+/* Sets the probe callback corresponding to one marker. */
+static int _set_marker(struct marker_entry **entry,
+			struct __mark_marker *elem)
+{
+	int ret;
+	BUG_ON(strcmp((*entry)->name, elem->name) != 0);
+
+	if ((*entry)->format) {
+		if (strcmp((*entry)->format, elem->format) != 0) {
+			printk(KERN_NOTICE
+				"Format mismatch for probe %s "
+				"(%s), marker (%s)\n",
+				(*entry)->name,
+				(*entry)->format,
+				elem->format);
+			return -EPERM;
+		}
+	} else {
+		ret = _marker_set_format(entry, elem->format);
+		if (ret)
+			return ret;
+	}
+	elem->call = (*entry)->probe;
+	elem->pdata = (*entry)->pdata;
+	_immediate_set(&elem->state, 1);
+	return 0;
+}
+
+/*
+ * Disable a marker and its probe callback.
+ * Note: only after a synchronize_sched() issued after setting elem->call to the
+ * empty function insures that the original callback is not used anymore. This
+ * insured by preemption disabling around the call site.
+ */
+static void _disable_marker(struct __mark_marker *elem)
+{
+	_immediate_set(&elem->state, 0);
+	elem->call = __mark_empty_function;
+	/*
+	 * Leave the pdata and id there, because removal is racy and should be
+	 * done only after a synchronize_sched(). There are never used until
+	 * the next initialization anyway.
+	 */
+}
+
+/*
+ * Updates the probe callback corresponding to a range of markers.
+ * Must be called with markers_mutex held.
+ */
+static void _marker_update_probe_range(
+	struct __mark_marker *begin,
+	struct __mark_marker *end,
+	struct module *probe_module,
+	int *refcount)
+{
+	struct __mark_marker *iter;
+	struct marker_entry *mark_entry;
+
+	for (iter = begin; iter < end; iter++) {
+		mark_entry = _get_marker(iter->name);
+		if (mark_entry && mark_entry->refcount) {
+			_set_marker(&mark_entry, iter);
+			/*
+			 * ignore error, continue
+			 */
+			if (probe_module)
+				if (probe_module ==
+			__module_text_address((unsigned long)mark_entry->probe))
+					(*refcount)++;
+		} else {
+			_disable_marker(iter);
+		}
+	}
+}
+
+#ifdef CONFIG_MODULES
+/*
+ * Update module probes.
+ * Must be called with markers_mutex held.
+ */
+static inline void __marker_update_probes_modules(struct module *probe_module,
+	int *refcount)
+{
+	struct module *mod;
+
+	list_for_each_entry(mod, &modules, list) {
+		if (!mod->taints) {
+			_marker_update_probe_range(mod->markers,
+				mod->markers+mod->num_markers,
+				probe_module, refcount);
+		}
+	}
+}
+#else
+static inline void __marker_update_probes_modules(struct module *probe_module,
+	int *refcount)
+{ }
+#endif
+
+/*
+ * Update probes, removing the faulty probes.
+ * Issues a synchronize_sched() when no reference to the module passed
+ * as parameter is found in the probes so the probe module can be
+ * safely unloaded from now on.
+ */
+static inline void __marker_update_probes(struct module *probe_module)
+{
+	int refcount = 0;
+
+	/* Core kernel markers */
+	_marker_update_probe_range(__start___markers,
+			__stop___markers, probe_module, &refcount);
+	/* Markers in modules. */
+	__marker_update_probes_modules(probe_module, &refcount);
+	if (probe_module && refcount == 0)
+		synchronize_sched();
+}
+
+#ifdef CONFIG_MODULES
+/*
+ * Setup the marker according to the data present in the marker hash table
+ * upon module load. If an error occur during the set probe range,
+ * refuse to load the module. Must be called with module_mutex held.
+ * Since the probe_module parameter is NULL, it is safe for refcount to be NULL.
+ */
+void module_marker_update(struct module *mod)
+{
+	if (!mod->taints)
+		_marker_update_probe_range(mod->markers,
+			mod->markers+mod->num_markers, NULL, NULL);
+}
+
+/*
+ * Update the system wide probes, with modules. */
+static inline void _marker_update_probes(struct module *probe_module)
+{
+	mutex_lock(&module_mutex);
+	__marker_update_probes(probe_module);
+	mutex_unlock(&module_mutex);
+}
+#else
+/* Update the system wide probes, without modules. */
+static inline void _marker_update_probes(struct module *probe_module)
+{
+	__marker_update_probes(probe_module);
+}
+#endif
+
+/*
+ * Register a probe : set the callback for each marker.
+ * Markers must be disarmed to be registered.
+ */
+int marker_probe_register(const char *name, const char *format,
+			marker_probe_func *probe, void *pdata)
+{
+	struct marker_entry *entry;
+	int ret = 0;
+
+	mutex_lock(&markers_mutex);
+	entry = _get_marker(name);
+	if (entry && entry->refcount) {
+		ret = -EBUSY;
+		goto end;
+	}
+	ret = _add_marker(name, format, probe, pdata);
+	if (ret)
+		goto end;
+	_marker_update_probes(NULL);
+end:
+	mutex_unlock(&markers_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(marker_probe_register);
+
+/*
+ * Unregister a probe : unset the callback for each marker.
+ * returns the pdata if ok.
+ * else, returns a ERR_PTR().
+ */
+void *marker_probe_unregister(const char *name)
+{
+	struct module *probe_module;
+	struct marker_entry *entry;
+	void *pdata;
+
+	mutex_lock(&markers_mutex);
+	entry = _get_marker(name);
+	if (!entry) {
+		pdata = ERR_PTR(-ENOENT);
+		goto end;
+	}
+	entry->refcount = 0;
+	/* In what module is the probe handler ? */
+	probe_module = __module_text_address((unsigned long)entry->probe);
+	pdata = _remove_marker(name);
+	_marker_update_probes(probe_module);
+end:
+	mutex_unlock(&markers_mutex);
+	return pdata;
+}
+EXPORT_SYMBOL_GPL(marker_probe_unregister);
+
+/*
+ * Unregister a probe by pdata : unset the callback for each marker.
+ * Markers must be disarmed to be unregistered.
+ * returns the pdata if ok.
+ * else, returns a ERR_PTR().
+ */
+void *marker_probe_unregister_pdata(void *pdata)
+{
+	struct module *probe_module;
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *entry;
+	int found = 0;
+	unsigned int i;
+
+	mutex_lock(&markers_mutex);
+	for (i = 0; i < MARKER_TABLE_SIZE; i++) {
+		head = &marker_table[i];
+		hlist_for_each_entry(entry, node, head, hlist) {
+			if (entry->pdata == pdata) {
+				found = 1;
+				goto iter_end;
+			}
+		}
+	}
+iter_end:
+	if (!found) {
+		pdata = ERR_PTR(-ENOENT);
+		goto end;
+	}
+	entry->refcount = 0;
+	/* In what module is the probe handler ? */
+	probe_module = __module_text_address((unsigned long)entry->probe);
+	pdata = _remove_marker(entry->name);
+	_marker_update_probes(probe_module);
+end:
+	mutex_unlock(&markers_mutex);
+	return pdata;
+}
+EXPORT_SYMBOL_GPL(marker_probe_unregister_pdata);
+
+/*
+ * Arm the probe : arm the immediate values.
+ * A probe must have been previously registered.
+ */
+int marker_arm(const char *name)
+{
+	struct marker_entry * entry;
+	int ret = 0;
+
+	mutex_lock(&markers_mutex);
+	entry = _get_marker(name);
+	if (!entry) {
+		ret = -ENOENT;
+		goto end;
+	}
+	/*
+	 * Only need to update probes when refcount passes from 0 to 1.
+	 */
+	if (entry->refcount++)
+		goto end;
+	_marker_update_probes(NULL);
+end:
+	mutex_unlock(&markers_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(marker_arm);
+
+/*
+ * Disarm the probe : disarm the immediate and set the empty callback for each
+ * marker.
+ */
+int marker_disarm(const char *name)
+{
+	struct marker_entry * entry;
+	int ret = 0;
+
+	mutex_lock(&markers_mutex);
+	entry = _get_marker(name);
+	if (!entry) {
+		ret = -ENOENT;
+		goto end;
+	}
+	/*
+	 * Only permit decrement refcount if higher than 0.
+	 * Do probe update only on 1 -> 0 transition.
+	 */
+	if (entry->refcount) {
+		if (--entry->refcount)
+			goto end;
+	} else {
+		ret = -EPERM;
+		goto end;
+	}
+	_marker_update_probes(NULL);
+end:
+	mutex_unlock(&markers_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(marker_disarm);
+
+void *marker_get_pdata(const char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *e;
+	size_t name_len = strlen(name) + 1;
+	u32 hash = jhash(name, name_len-1, 0);
+	int found = 0;
+
+	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
+	hlist_for_each_entry(e, node, head, hlist) {
+		if (!strcmp(name, e->name)) {
+			found = 1;
+			return e->pdata;
+		}
+	}
+	return ERR_PTR(-ENOENT);
+}
+EXPORT_SYMBOL_GPL(marker_get_pdata);
+
+
+/*
+ * No markers are added to the core marker section, no lock needed.
+ * Must be called with modules mutex held for modules markers.
+ * Returns 1 if current is found, or 0 if current is not found.
+ */
+static int _marker_get_next_range(struct __mark_marker *cur,
+	int found,
+	struct __mark_marker **next,
+	struct __mark_marker *begin,
+	struct __mark_marker *end)
+{
+	if (found && begin != end) {
+		/*
+		 * current found in the previous module, get the following
+		 * marker.
+		 */
+		*next = begin;
+	} else if (cur >= begin && cur < end) {
+		found = 1;
+		if (cur + 1 < end) {
+			/*
+			 * next marker sits within the same module.
+			 */
+			*next = cur + 1;
+		}
+	}
+	return found;
+}
+
+#ifdef CONFIG_MODULES
+/*
+ * Returns 0 if current not foud.
+ * Returns 1 if current found.
+ */
+static inline int marker_get_next_modules(struct __mark_marker *cur,
+						int found,
+						struct __mark_marker **next)
+{
+	struct module *iter_mod;
+	struct module *cur_mod = NULL;
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry(iter_mod, &modules, list) {
+		if (!iter_mod->taints) {
+			found = _marker_get_next_range(cur, found, next,
+				iter_mod->markers,
+				iter_mod->markers + iter_mod->num_markers);
+			/*
+			 * Stop if the current marker has been found _and_
+			 * the next marker has been set. Inc module refcount.
+			 *
+			 * If the current marker is found and not the next one,
+			 * remember the current module for module_put.
+			 */
+			if (found) {
+				if (*next) {
+					__module_get(iter_mod);
+					break;
+				} else
+					cur_mod = iter_mod;
+			}
+
+		}
+	}
+	mutex_unlock(&module_mutex);
+	if (cur_mod)
+		module_put(cur_mod);
+	return found;
+}
+#else
+static inline int marker_get_next_modules(struct __mark_marker *cur,
+						int found,
+						struct __mark_marker **next)
+{
+	return 0;
+}
+#endif
+
+/*
+ * Only need to increment the module use count.
+ * We allow modification of markers beneath us, since we only want to output
+ * their information.
+ * Returns NULL when it reaches the last marker.
+ */
+struct __mark_marker *marker_get_next(struct __mark_marker *cur)
+{
+	int found = 0;
+	struct __mark_marker *next = NULL;
+
+	/* Get the first marker when cur is NULL */
+	if (!cur)
+		found = 1;
+	/* Core kernel markers */
+	found = _marker_get_next_range(cur, found, &next,
+			__start___markers, __stop___markers);
+	if (found && next)
+		goto end;
+	/* Markers in modules. */
+	found = marker_get_next_modules(cur, found, &next);
+end:
+	return next;
+}
+EXPORT_SYMBOL_GPL(marker_get_next);
+
+struct __mark_marker *marker_get_first(void)
+{
+	return marker_get_next(NULL);
+}
+EXPORT_SYMBOL_GPL(marker_get_first);
+
+/*
+ * FIXME: suboptimal
+ * Gets the markers until the end, so no module refcount is held when the
+ * function ends.
+ */
+void marker_release(struct __mark_marker *iter)
+{
+	while (iter != NULL)
+		iter = marker_get_next(iter);
+}
+EXPORT_SYMBOL_GPL(marker_release);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

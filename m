Return-Path: <linux-kernel-owner+w=401wt.eu-S1761220AbXIRVQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761220AbXIRVQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760850AbXIRVPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:15:37 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:55267 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759501AbXIRVPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:15:35 -0400
Message-Id: <20070918211459.193904061@polymtl.ca>
References: <20070918211324.161373216@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 17:13:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 1/4] Linux Kernel Markers - Architecture Independent Code
Content-Disposition: inline; filename=linux-kernel-markers-architecture-independent-code.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 18 Sep 2007 21:14:59 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The marker activation functions sits in kernel/marker.c. A hash table is used
to keep track of the registered probes and armed markers, so the markers within
a newly loaded module that should be active can be activated at module load
time.

marker_query has been removed. marker_get_first, marker_get_next and
marker_release should be used as iterators on the markers.

Changelog:
- markers_mutex now nests inside module_mutex rather than the opposite.
- Iteration on modules is now done in module.c.
- module_mutex is not exported anymore.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: "Frank Ch. Eigler" <fche@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Rusty Russell <rusty@rustcorp.com.au>
---

 include/asm-generic/vmlinux.lds.h |   11 
 include/linux/marker.h            |  175 ++++++++++
 include/linux/module.h            |   18 +
 kernel/marker.c                   |  608 ++++++++++++++++++++++++++++++++++++++
 kernel/module.c                   |   66 ++++
 5 files changed, 875 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-09-14 10:11:18.000000000 -0400
+++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-09-14 10:11:31.000000000 -0400
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
+++ linux-2.6-lttng/include/linux/marker.h	2007-09-17 12:43:54.000000000 -0400
@@ -0,0 +1,175 @@
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
+#include <linux/immediate.h>
+#include <linux/types.h>
+
+struct module;
+struct __mark_marker;
+
+/**
+ * marker_probe_func - Type of a marker probe function
+ * @mdata: pointer of type struct __mark_marker
+ * @private_data: caller site private data
+ * @fmt: format string
+ * @...: variable argument list
+ *
+ * Type of marker probe functions. They receive the mdata and need to parse the
+ * format string to recover the variable argument list.
+ */
+typedef void marker_probe_func(const struct __mark_marker *mdata,
+	void *private_data, const char *fmt, ...);
+
+struct __mark_marker {
+	const char *name;	/* Marker name */
+	const char *format;	/* Marker format string, describing the
+				 * variable argument list.
+				 */
+	const char *args;	/* List of arguments litteraly transformed
+				 * into a string: "arg1, arg2, arg3".
+				 */
+	DEFINE_IMMEDIATE(char, state);	/* Immediate value state. */
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
+#define __trace_mark(generic, name, call_data, format, args...)		\
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
+		__mstrtab_args_##name, 0,				\
+		__mark_empty_function, NULL };				\
+		asm volatile ( "" : : "i" (&__mark_##name));		\
+		__mark_check_format(format, ## args);			\
+		if (!generic) {						\
+			if (unlikely(immediate_read(__mark_##name.state))) { \
+				preempt_disable();			\
+				(*__mark_##name.call)			\
+					(&__mark_##name, call_data,	\
+					format, ## args);		\
+				preempt_enable();			\
+			}						\
+		} else {						\
+			if (unlikely(_immediate_read(__mark_##name.state))) { \
+				preempt_disable();			\
+				(*__mark_##name.call)			\
+					(&__mark_##name, call_data,	\
+					format, ## args);		\
+				preempt_enable();			\
+			}						\
+		}							\
+	} while (0)
+
+extern void marker_update_probe_range(struct __mark_marker *begin,
+	struct __mark_marker *end, struct module *probe_module, int *refcount);
+#else /* !CONFIG_MARKERS */
+#define __trace_mark(generic, name, call_data, format, args...) \
+		__mark_check_format(format, ## args)
+static inline void marker_update_probe_range(struct __mark_marker *begin,
+	struct __mark_marker *end, struct module *probe_module, int *refcount)
+{ }
+#endif /* CONFIG_MARKERS */
+
+/**
+ * trace_mark - Marker using code patching
+ * @name: marker name, not quoted.
+ * @format: format string
+ * @args...: variable argument list
+ *
+ * Places a marker using optimized code patching technique (immediate_read())
+ * to be enabled.
+ */
+#define trace_mark(name, format, args...) \
+	__trace_mark(0, name, NULL, format, ## args)
+
+/**
+ * _trace_mark - Marker using variable read
+ * @name: marker name, not quoted.
+ * @format: format string
+ * @args...: variable argument list
+ *
+ * Places a marker using a standard memory read (_immediate_read()) to be
+ * enabled. Should be used for markers in __init and __exit functions and in
+ * lockdep code.
+ */
+#define _trace_mark(name, format, args...) \
+	__trace_mark(1, name, NULL, format, ## args)
+
+#define MARK_MAX_FORMAT_LEN	1024
+
+/**
+ * MARK_NOARGS - Format string for a marker with no argument.
+ */
+#define MARK_NOARGS " "
+
+/* To be used for string format validity checking with gcc */
+static inline void __attribute__ ((format (printf, 1, 2)))
+	__mark_check_format(const char *fmt, ...) { }
+
+extern marker_probe_func __mark_empty_function;
+
+/*
+ * Connect a probe to a marker.
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
+
+struct marker_iter {
+	struct module *module;
+	struct __mark_marker *marker;
+};
+
+extern void marker_iter_start(struct marker_iter *iter);
+extern void marker_iter_next(struct marker_iter *iter);
+extern void marker_iter_stop(struct marker_iter *iter);
+extern void marker_iter_reset(struct marker_iter *iter);
+extern void *marker_get_pdata(const char *name);
+extern int marker_get_iter_range(struct __mark_marker **marker,
+	struct __mark_marker *begin,
+	struct __mark_marker *end);
+
+#endif
Index: linux-2.6-lttng/include/linux/module.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/module.h	2007-09-14 10:11:18.000000000 -0400
+++ linux-2.6-lttng/include/linux/module.h	2007-09-14 10:11:31.000000000 -0400
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
 #include <linux/immediate.h>
+#include <linux/marker.h>
 #include <asm/local.h>
 
 #include <asm/module.h>
@@ -376,6 +377,10 @@ struct module
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
@@ -482,6 +487,9 @@ extern void print_modules(void);
 extern void _module_immediate_update(void);
 extern void module_immediate_update(void);
 
+extern void module_update_markers(struct module *probe_module, int *refcount);
+extern int module_get_iter_markers(struct marker_iter *iter);
+
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
 #define EXPORT_SYMBOL_GPL(sym)
@@ -589,6 +597,16 @@ static inline void module_immediate_upda
 {
 }
 
+static inline void module_update_markers(struct module *probe_module,
+		int *refcount)
+{
+}
+
+static inline int module_get_iter_markers(struct marker_iter *iter)
+{
+	return 0;
+}
+
 #endif /* CONFIG_MODULES */
 
 struct device_driver;
Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2007-09-14 10:11:30.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2007-09-14 10:11:31.000000000 -0400
@@ -1720,6 +1720,8 @@ static struct module *load_module(void _
 	unsigned int unusedgplindex;
 	unsigned int unusedgplcrcindex;
 	unsigned int immediateindex;
+	unsigned int markersindex;
+	unsigned int markersstringsindex;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -1972,6 +1974,8 @@ static struct module *load_module(void _
 	mod->num_immediate =
 		sechdrs[immediateindex].sh_size / sizeof(*mod->immediate);
 #endif
+	markersindex = find_sec(hdr, sechdrs, secstrings, "__markers");
+ 	markersstringsindex = find_sec(hdr, sechdrs, secstrings, "__markers_strings");
 
 	mod->unused_syms = (void *)sechdrs[unusedindex].sh_addr;
 	if (unusedcrcindex)
@@ -2013,6 +2017,11 @@ static struct module *load_module(void _
 		if (err < 0)
 			goto cleanup;
 	}
+#ifdef CONFIG_MARKERS
+	mod->markers = (void *)sechdrs[markersindex].sh_addr;
+	mod->num_markers =
+		sechdrs[markersindex].sh_size / sizeof(*mod->markers);
+#endif
 
         /* Find duplicate symbols */
 	err = verify_export_symbols(mod);
@@ -2037,12 +2046,16 @@ static struct module *load_module(void _
 		 goto nomodsectinfo;
 #endif
 
+	if (!mod->taints) {
 #ifdef CONFIG_IMMEDIATE
-	if (!mod->taints)
 		immediate_update_range(mod->immediate,
 			mod->immediate + mod->num_immediate);
 #endif
-
+#ifdef CONFIG_MARKERS
+		marker_update_probe_range(mod->markers,
+			mod->markers + mod->num_markers, NULL, NULL);
+#endif
+	}
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
 		goto cleanup;
@@ -2693,3 +2706,52 @@ void module_immediate_update(void)
 }
 EXPORT_SYMBOL_GPL(module_immediate_update);
 #endif
+
+#ifdef CONFIG_MARKERS
+void module_update_markers(struct module *probe_module, int *refcount)
+{
+	struct module *mod;
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry(mod, &modules, list)
+		if (!mod->taints)
+			marker_update_probe_range(mod->markers,
+				mod->markers + mod->num_markers,
+				probe_module, refcount);
+	mutex_unlock(&module_mutex);
+}
+EXPORT_SYMBOL_GPL(module_update_markers);
+
+/*
+ * Returns 0 if current not found.
+ * Returns 1 if current found.
+ */
+int module_get_iter_markers(struct marker_iter *iter)
+{
+	struct module *iter_mod;
+	int found = 0;
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry(iter_mod, &modules, list) {
+		if (!iter_mod->taints) {
+			/*
+			 * Sorted module list
+			 */
+			if (iter_mod < iter->module)
+				continue;
+			else if (iter_mod > iter->module)
+				iter->marker = NULL;
+			found = marker_get_iter_range(&iter->marker,
+				iter_mod->markers,
+				iter_mod->markers + iter_mod->num_markers);
+			if (found) {
+				iter->module = iter_mod;
+				break;
+			}
+		}
+	}
+	mutex_unlock(&module_mutex);
+	return found;
+}
+EXPORT_SYMBOL_GPL(module_get_iter_markers);
+#endif
Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/kernel/marker.c	2007-09-14 10:11:31.000000000 -0400
@@ -0,0 +1,608 @@
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
+ * and module markers, the hash table and deferred_sync.
+ */
+DEFINE_MUTEX(markers_mutex);
+
+/*
+ * Marker deferred synchronization.
+ * Upon marker probe_unregister, we delay call to synchronize_sched() to
+ * accelerate mass unregistration (only when there is no more reference to a
+ * given module do we call synchronize_sched()). However, we need to make sure
+ * every critical region has ended before we re-arm a marker that has been
+ * unregistered and then registered back with a different probe data.
+ */
+static int deferred_sync;
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
+/**
+ * __mark_empty_function - Empty probe callback
+ * @mdata: pointer of type const struct __mark_marker
+ * @fmt: format string
+ * @...: variable argument list
+ *
+ * Empty callback provided as a probe to the markers. By providing this to a
+ * disabled marker, we make sure the  execution flow is always valid even
+ * though the function pointer change and the marker enabling are two distinct
+ * operations that modifies the execution flow of preemptible code.
+ */
+void __mark_empty_function(const struct __mark_marker *mdata,
+	void *private_data,
+	const char *fmt, ...)
+{ }
+EXPORT_SYMBOL_GPL(__mark_empty_function);
+
+/*
+ * Get marker if the marker is present in the marker hash table.
+ * Must be called with markers_mutex held.
+ * Returns NULL if not present.
+ */
+static struct marker_entry *get_marker(const char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *e;
+	u32 hash = jhash(name, strlen(name), 0);
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
+static int add_marker(const char *name,
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
+static void *remove_marker(const char *name)
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
+static int marker_set_format(struct marker_entry **entry, const char *format)
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
+/*
+ * Sets the probe callback corresponding to one marker.
+ */
+static int set_marker(struct marker_entry **entry,
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
+		ret = marker_set_format(entry, elem->format);
+		if (ret)
+			return ret;
+	}
+	elem->call = (*entry)->probe;
+	elem->pdata = (*entry)->pdata;
+	_immediate_set(elem->state, 1);
+	return 0;
+}
+
+/*
+ * Disable a marker and its probe callback.
+ * Note: only after a synchronize_sched() issued after setting elem->call to the
+ * empty function insures that the original callback is not used anymore. This
+ * insured by preemption disabling around the call site.
+ */
+static void disable_marker(struct __mark_marker *elem)
+{
+	_immediate_set(elem->state, 0);
+	elem->call = __mark_empty_function;
+	/*
+	 * Leave the pdata and id there, because removal is racy and should be
+	 * done only after a synchronize_sched(). These are never used until
+	 * the next initialization anyway.
+	 */
+}
+
+/**
+ * marker_update_probe_range - Update a probe range
+ * @begin: beginning of the range
+ * @end: end of the range
+ * @probe_module: module address of the probe being updated
+ * @refcount: number of references left to the given probe_module (out)
+ *
+ * Updates the probe callback corresponding to a range of markers.
+ * Must be called with markers_mutex held.
+ */
+void marker_update_probe_range(
+	struct __mark_marker *begin,
+	struct __mark_marker *end,
+	struct module *probe_module,
+	int *refcount)
+{
+	struct __mark_marker *iter;
+	struct marker_entry *mark_entry;
+
+	for (iter = begin; iter < end; iter++) {
+		mark_entry = get_marker(iter->name);
+		if (mark_entry && mark_entry->refcount) {
+			set_marker(&mark_entry, iter);
+			/*
+			 * ignore error, continue
+			 */
+			if (probe_module)
+				if (probe_module ==
+			__module_text_address((unsigned long)mark_entry->probe))
+					(*refcount)++;
+		} else {
+			disable_marker(iter);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(marker_update_probe_range);
+
+/*
+ * Update probes, removing the faulty probes.
+ * Issues a synchronize_sched() when no reference to the module passed
+ * as parameter is found in the probes so the probe module can be
+ * safely unloaded from now on.
+ */
+static inline void marker_update_probes(struct module *probe_module)
+{
+	int refcount = 0;
+
+	mutex_lock(&markers_mutex);
+	/* Core kernel markers */
+	marker_update_probe_range(__start___markers,
+			__stop___markers, probe_module, &refcount);
+	/* Markers in modules. */
+	module_update_markers(probe_module, &refcount);
+	if (probe_module && refcount == 0) {
+		synchronize_sched();
+		deferred_sync = 0;
+	}
+	mutex_unlock(&markers_mutex);
+}
+
+/**
+ * marker_probe_register -  Connect a probe to a marker
+ * @name: marker name
+ * @format: format string
+ * @probe: probe handler
+ * @pdata: probe private data
+ *
+ * pdata must be a valid allocated memory address, or NULL.
+ * Returns 0 if ok, error value on error.
+ */
+int marker_probe_register(const char *name, const char *format,
+			marker_probe_func *probe, void *pdata)
+{
+	struct marker_entry *entry;
+	int ret = 0, need_update = 0;
+
+	mutex_lock(&markers_mutex);
+	entry = get_marker(name);
+	if (entry && entry->refcount) {
+		ret = -EBUSY;
+		goto end;
+	}
+	if (deferred_sync) {
+		synchronize_sched();
+		deferred_sync = 0;
+	}
+	ret = add_marker(name, format, probe, pdata);
+	if (ret)
+		goto end;
+	need_update = 1;
+end:
+	mutex_unlock(&markers_mutex);
+	if (need_update)
+		marker_update_probes(NULL);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(marker_probe_register);
+
+/**
+ * marker_probe_unregister -  Disconnect a probe from a marker
+ * @name: marker name
+ *
+ * Returns the pdata given to marker_probe_register, or an ERR_PTR().
+ */
+void *marker_probe_unregister(const char *name)
+{
+	struct module *probe_module;
+	struct marker_entry *entry;
+	void *pdata;
+	int need_update = 0;
+
+	mutex_lock(&markers_mutex);
+	entry = get_marker(name);
+	if (!entry) {
+		pdata = ERR_PTR(-ENOENT);
+		goto end;
+	}
+	entry->refcount = 0;
+	/* In what module is the probe handler ? */
+	probe_module = __module_text_address((unsigned long)entry->probe);
+	pdata = remove_marker(name);
+	deferred_sync = 1;
+	need_update = 1;
+end:
+	mutex_unlock(&markers_mutex);
+	if (need_update)
+		marker_update_probes(probe_module);
+	return pdata;
+}
+EXPORT_SYMBOL_GPL(marker_probe_unregister);
+
+/**
+ * marker_probe_unregister_pdata -  Disconnect a probe from a marker
+ * @pdata: probe private data
+ *
+ * Unregister a marker by providing the registered pdata.
+ * Returns the pdata given to marker_probe_register, or an ERR_PTR().
+ */
+void *marker_probe_unregister_pdata(void *pdata)
+{
+	struct module *probe_module;
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct marker_entry *entry;
+	int found = 0;
+	unsigned int i;
+	int need_update = 0;
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
+	pdata = remove_marker(entry->name);
+	deferred_sync = 1;
+	need_update = 1;
+end:
+	mutex_unlock(&markers_mutex);
+	if (need_update)
+		marker_update_probes(probe_module);
+	return pdata;
+}
+EXPORT_SYMBOL_GPL(marker_probe_unregister_pdata);
+
+/**
+ * marker_arm - Arm a marker
+ * @name: marker name
+ *
+ * Activate a marker. It keeps a reference count of the number of
+ * arming/disarming done.
+ * Returns 0 if ok, error value on error.
+ */
+int marker_arm(const char *name)
+{
+	struct marker_entry * entry;
+	int ret = 0, need_update = 0;
+
+	mutex_lock(&markers_mutex);
+	entry = get_marker(name);
+	if (!entry) {
+		ret = -ENOENT;
+		goto end;
+	}
+	/*
+	 * Only need to update probes when refcount passes from 0 to 1.
+	 */
+	if (entry->refcount++)
+		goto end;
+	need_update = 1;
+end:
+	mutex_unlock(&markers_mutex);
+	if (need_update)
+		marker_update_probes(NULL);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(marker_arm);
+
+/**
+ * marker_disarm - Disarm a marker
+ * @name: marker name
+ *
+ * Disarm a marker. It keeps a reference count of the number of arming/disarming
+ * done.
+ * Returns 0 if ok, error value on error.
+ */
+int marker_disarm(const char *name)
+{
+	struct marker_entry * entry;
+	int ret = 0, need_update = 0;
+
+	mutex_lock(&markers_mutex);
+	entry = get_marker(name);
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
+	need_update = 1;
+end:
+	mutex_unlock(&markers_mutex);
+	if (need_update)
+		marker_update_probes(NULL);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(marker_disarm);
+
+/**
+ * marker_get_pdata - Get a marker's probe private data
+ * @name: marker name
+ *
+ * Returns the pdata pointer, or an ERR_PTR.
+ * The pdata pointer should _only_ be dereferenced if the caller is the owner of
+ * the data, or its content could vanish. This is mostly used to confirm that a
+ * caller is the owner of a registered probe.
+ */
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
+/**
+ * marker_get_iter_range - Get a next marker iterator given a range.
+ * @marker: current markers (in), next marker (out)
+ * @begin: beginning of the range
+ * @end: end of the range
+ *
+ * Returns whether a next marker has been found (1) or not (0).
+ * Will return the first marker in the range if the input marker is NULL.
+ */
+int marker_get_iter_range(struct __mark_marker **marker,
+	struct __mark_marker *begin,
+	struct __mark_marker *end)
+{
+	int found = 0;
+
+	if (!*marker && begin != end) {
+		found = 1;
+		*marker = begin;
+	} else if (*marker >= begin && *marker < end) {
+		found = 1;
+		/*
+		 * *marker is known to be a valid marker from now on.
+		 */
+	}
+	return found;
+}
+EXPORT_SYMBOL_GPL(marker_get_iter_range);
+
+static inline void marker_get_iter(struct marker_iter *iter)
+{
+	int found = 0;
+
+	/* Core kernel markers */
+	if (!iter->module) {
+		found = marker_get_iter_range(&iter->marker,
+				__start___markers, __stop___markers);
+		if (found)
+			goto end;
+	}
+	/* Markers in modules. */
+	found = module_get_iter_markers(iter);
+end:
+	if (!found)
+		marker_iter_reset(iter);
+}
+
+void marker_iter_start(struct marker_iter *iter)
+{
+	mutex_lock(&markers_mutex);
+	marker_get_iter(iter);
+}
+EXPORT_SYMBOL_GPL(marker_iter_start);
+
+void marker_iter_next(struct marker_iter *iter)
+{
+	iter->marker++;
+	/*
+	 * iter->marker may be invalid because we blindly incremented it.
+	 * Make sure it is valid by marshalling on the markers, getting the
+	 * markers from following modules if necessary.
+	 */
+	marker_get_iter(iter);
+}
+EXPORT_SYMBOL_GPL(marker_iter_next);
+
+void marker_iter_stop(struct marker_iter *iter)
+{
+	mutex_unlock(&markers_mutex);
+}
+EXPORT_SYMBOL_GPL(marker_iter_stop);
+
+void marker_iter_reset(struct marker_iter *iter)
+{
+	iter->module = NULL;
+	iter->marker = NULL;
+}
+EXPORT_SYMBOL_GPL(marker_iter_reset);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

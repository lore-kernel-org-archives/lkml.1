Return-Path: <linux-kernel-owner+w=401wt.eu-S1764943AbXE2SlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764943AbXE2SlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbXE2SiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:38:16 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:43944 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764032AbXE2SiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:38:13 -0400
Message-Id: <20070529183759.249481181@polymtl.ca>
References: <20070529183725.179570071@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 29 May 2007 14:37:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 2/6] Linux Kernel Markers, architecture independent code.
Content-Disposition: inline; filename=linux-kernel-markers-architecture-independent-code.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 29 May 2007 18:37:59 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---

 include/asm-generic/vmlinux.lds.h |    6 
 include/linux/marker.h            |   99 +++++++++++
 include/linux/module.h            |    3 
 kernel/module.c                   |  330 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 437 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-05-17 02:12:41.000000000 -0400
@@ -143,7 +143,11 @@
 									\
 	. = ALIGN(4096);
 
-#define EXTRA_RWDATA
+#define EXTRA_RWDATA							\
+		. = ALIGN(8);						\
+		VMLINUX_SYMBOL(__start___markers) = .;			\
+		*(__markers)						\
+		VMLINUX_SYMBOL(__stop___markers) = .;			\
 
 #define SECURITY_INIT							\
 	.security_initcall.init : AT(ADDR(.security_initcall.init) - LOAD_OFFSET) { \
Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/linux/marker.h	2007-05-17 02:13:29.000000000 -0400
@@ -0,0 +1,99 @@
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
+#include <linux/condcall.h>
+
+struct __mark_marker;
+
+typedef void marker_probe_func(const struct __mark_marker *mdata,
+	const char *fmt, ...);
+
+struct __mark_marker {
+	const char *name;
+	const char *format;
+	const char *args;
+	int flags;
+	marker_probe_func *call;
+	void *pdata;
+} __attribute__((packed));
+
+#ifdef CONFIG_MARKERS
+
+/* Macro calling the callback. Placed inside the cond_call() parameters. */
+#define trace_mark_call(func, name, format, args...) \
+	({ \
+		preempt_disable(); \
+		(func)(name, format, ## args); \
+		preempt_enable(); \
+	})
+
+/* Generic marker flavor always available.
+ * Note : the empty asm volatile with read constraint is used here instead of a
+ * "used" attribute to fix a gcc 4.1.x bug. */
+#define _trace_mark(flags, name, format, args...) \
+	do { \
+		static const char __mstrtab_name_##name[] \
+		__attribute__((section("__cond_call_strings"))) \
+		= #name; \
+		static const char __mstrtab_format_##name[] \
+		__attribute__((section("__cond_call_strings"))) \
+		= format; \
+		static const char __mstrtab_args_##name[] \
+		__attribute__((section("__cond_call_strings"))) \
+		= #args; \
+		static struct __mark_marker __mark_##name \
+		__attribute__((section("__markers"))) = \
+		{ __mstrtab_name_##name,  __mstrtab_format_##name, \
+		__mstrtab_args_##name, (flags), __mark_empty_function, NULL }; \
+		asm volatile ( "" : : "i" (&__mark_##name)); \
+		__mark_check_format(format, ## args); \
+		_cond_call((flags), name, \
+			trace_mark_call(*__mark_##name.call, \
+				&__mark_##name, format, ## args)); \
+	} while (0)
+
+/* Marker with default behavior */
+#define trace_mark(name, format, args...) \
+	_trace_mark(CF_DEFAULT, name, format, ## args)
+
+#else /* !CONFIG_MARKERS */
+#define trace_mark(flags, name, format, args...) \
+		__mark_check_format(format, ## args)
+#endif /* CONFIG_MARKERS */
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
+		_marker_arm_probe(CF_DEFAULT, name, format, probe, pdata)
+
+extern int marker_disarm_probe(const char *name);
+extern int marker_list_probe(marker_probe_func *probe);
+const struct __mark_marker *marker_query(const char *name, int instance);
+
+#endif /* __KERNEL__ */
+#endif
Index: linux-2.6-lttng/include/linux/module.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/module.h	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/include/linux/module.h	2007-05-17 02:13:15.000000000 -0400
@@ -17,6 +17,7 @@
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
 #include <linux/condcall.h>
+#include <linux/marker.h>
 #include <asm/local.h>
 
 #include <asm/module.h>
@@ -360,6 +361,8 @@
 
 	const struct __cond_call_struct *cond_calls;
 	unsigned int num_cond_calls;
+	struct __mark_marker *markers;
+	unsigned int num_markers;
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2007-05-17 02:12:41.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2007-05-17 02:13:29.000000000 -0400
@@ -33,6 +33,7 @@
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
 #include <linux/condcall.h>
+#include <linux/marker.h>
 #include <linux/jhash.h>
 #include <linux/list.h>
 #include <linux/err.h>
@@ -160,6 +161,8 @@
 extern const unsigned long __start___kcrctab_unused_gpl[];
 extern const struct __cond_call_struct __start___cond_call[];
 extern const struct __cond_call_struct __stop___cond_call[];
+extern const struct __mark_marker __start___markers[];
+extern const struct __mark_marker __stop___markers[];
 
 #ifndef CONFIG_MODVERSIONS
 #define symversion(base, idx) NULL
@@ -577,6 +580,313 @@
 }
 #endif
 
+#ifdef CONFIG_MARKERS
+
+/* Empty callback provided as a probe to the markers. By providing this to a
+ * disabled marker, we makes sure the  execution flow is always valid even
+ * though the function pointer change and the marker enabling are two distinct
+ * operations that modifies the execution flow of preemptible code. */
+void __mark_empty_function(const struct __mark_marker_data *mdata,
+	const char *fmt, ...)
+{
+}
+EXPORT_SYMBOL_GPL(__mark_empty_function);
+
+/* Sets the probe callback corresponding to a range of markers.
+ */
+static int _marker_set_probe_range(int flags, const char *name,
+	const char *format,
+	marker_probe_func *probe,
+	void *pdata,
+	const struct __mark_marker *begin,
+	const struct __mark_marker *end)
+{
+	const struct __mark_marker *iter;
+	int found = 0;
+
+	for (iter = begin; iter < end; iter++) {
+		if (strcmp(name, iter->mdata->name) != 0)
+			continue;
+
+		if (format) {
+			if (strcmp(format, iter->mdata->format) != 0) {
+				printk(KERN_NOTICE
+					"Format mismatch for probe %s "
+					"(%s), marker (%s)\n",
+					name,
+					format,
+					iter->mdata->format);
+				continue;
+			}
+		} else
+			format = iter->mdata->format;
+
+		if (flags & CF_LOCKDEP
+			&& !(iter->mdata->flags & CF_LOCKDEP)) {
+			printk(KERN_NOTICE
+				"Incompatible lockdep flags for "
+				"probe %s\n",
+				name);
+			continue;
+		}
+		if (flags & CF_PRINTK
+			&& !(iter->mdata->flags & CF_PRINTK)) {
+			printk(KERN_NOTICE
+				"Incompatible printk flags for "
+				"probe %s\n",
+				name);
+			continue;
+		}
+		if (probe == __mark_empty_function) {
+			if (iter->mdata->call != __mark_empty_function)
+				iter->mdata->call = __mark_empty_function;
+		} else {
+			if (iter->mdata->call != __mark_empty_function) {
+				if (iter->mdata->call != probe) {
+					printk(KERN_NOTICE
+						"Marker %s busy, "
+						"probe %p already "
+						"installed\n",
+						name,
+						iter->mdata->call);
+					continue;
+				}
+			} else
+				iter->mdata->call = probe;
+			iter->mdata->pdata = pdata;
+		}
+		found++;
+	}
+	return found;
+}
+
+/* Sets a range of markers to a disabled state : unset the enable bit and
+ * provide the empty callback.
+ * Keep a count of other markers connected to the same module as the one
+ * provided as parameter. */
+static int marker_remove_probe_range(const char *name,
+	struct module *probe_module,
+	int *ref_count,
+	const struct __mark_marker *begin,
+	const struct __mark_marker *end)
+{
+	const struct __mark_marker *iter;
+	int found = 0;
+
+	for (iter = begin; iter < end; iter++) {
+		if (strcmp(name, iter->mdata->name) != 0) {
+			if (probe_module)
+				if (__module_text_address(
+					(unsigned long)iter->mdata->call)
+						== probe_module)
+					(*ref_count)++;
+			continue;
+		}
+		iter->mdata->call = __mark_empty_function;
+		found++;
+	}
+	return found;
+}
+
+/* Provides a listing of the markers present in the kernel along with their
+ * callback and format string. */
+static int marker_list_probe_range(marker_probe_func *probe,
+	const struct __mark_marker *begin,
+	const struct __mark_marker *end)
+{
+	const struct __mark_marker *iter;
+	int found = 0;
+
+	for (iter = begin; iter < end; iter++) {
+		if (probe)
+			if (probe != iter->mdata->call) continue;
+		printk("name %s func 0x%p format \"%s\"\n",
+			iter->mdata->name,
+			iter->mdata->call, iter->mdata->format);
+		found++;
+	}
+	return found;
+}
+
+/* Get the module to which the probe handler's text belongs.
+ * Called with module_mutex taken.
+ * Returns NULL if the probe handler is not in a module. */
+static struct module *__marker_get_probe_module(const char *name)
+{
+	struct module *mod;
+	const struct __mark_marker *iter;
+
+	list_for_each_entry(mod, &modules, list) {
+		if (mod->taints)
+			continue;
+		for (iter = mod->markers;
+			iter < mod->markers+mod->num_markers; iter++) {
+			if (strcmp(name, iter->mdata->name) != 0)
+				continue;
+			if (iter->mdata->call)
+				return __module_text_address(
+					(unsigned long)iter->mdata->call);
+		}
+	}
+	return NULL;
+}
+
+/* Looks up a marker by its name and instance number within the specificed
+ * range and returns the associated data structure. */
+const struct __mark_marker_data *marker_query_range(const char *name,
+	int instance,
+	const struct __mark_marker *begin,
+	const struct __mark_marker *end)
+{
+	const struct __mark_marker *iter;
+	int found = 0;
+
+	for (iter = begin; iter < end; iter++) {
+		if (strcmp(name, iter->mdata->name) != 0)
+			continue;
+
+		if (found++ == instance)
+			return iter->mdata;
+	}
+	return NULL;
+}
+
+/* Calls _marker_set_probe_range for the core markers and modules markers.
+ * Marker arm uses the modlist_lock to synchronise. */
+static int marker_set_probe(int flags, const char *name, const char *format,
+				marker_probe_func *probe,
+				void *pdata)
+{
+	struct module *mod;
+	int found = 0;
+
+	mutex_lock(&module_mutex);
+	/* Core kernel markers */
+	found += _marker_set_probe_range(flags, name, format, probe,
+			pdata,
+			__start___markers, __stop___markers);
+	/* Markers in modules. */
+	list_for_each_entry(mod, &modules, list) {
+		if (!mod->taints)
+			found += _marker_set_probe_range(flags, name, format,
+			probe, pdata,
+			mod->markers, mod->markers+mod->num_markers);
+	}
+	mutex_unlock(&module_mutex);
+	return found;
+}
+
+/* Calls _marker_remove_probe_range for the core markers and modules markers.
+ * Marker enabling/disabling use the modlist_lock to synchronise.
+ * ref_count is the number of markers still connected to the same module
+ * as the one in which sits the probe handler currently removed, excluding the
+ * one currently removed. If the count is 0, we issue a synchronize_sched() to
+ * make sure the module can safely unload. */
+static int marker_remove_probe(const char *name)
+{
+	struct module *mod, *probe_module;
+	int found = 0;
+	int ref_count = 0;
+
+	mutex_lock(&module_mutex);
+	/* In what module is the probe handler ? */
+	probe_module = __marker_get_probe_module(name);
+	/* Core kernel markers */
+	found += marker_remove_probe_range(name, probe_module, &ref_count,
+			__start___markers, __stop___markers);
+	/* Markers in modules. */
+	list_for_each_entry(mod, &modules, list) {
+		if (!mod->taints)
+			found += marker_remove_probe_range(name, probe_module,
+				&ref_count,
+				mod->markers, mod->markers+mod->num_markers);
+	}
+	mutex_unlock(&module_mutex);
+	if (!ref_count)
+		synchronize_sched();
+	return found;
+}
+
+/* Arming a probe (set handler, enable cond_call). */
+int _marker_arm_probe(int flags, const char *name, const char *format,
+				marker_probe_func *probe, void *pdata)
+{
+	int ret;
+
+	ret = marker_set_probe(flags, name, format, probe, pdata);
+	if (ret)
+		ret = cond_call_arm(name);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(_marker_arm_probe);
+
+/* Disarm a probe (disable cond_call, remove handler). */
+int marker_disarm_probe(const char *name)
+{
+	int ret;
+
+	ret = cond_call_disarm(name);
+	if (ret)
+		ret = marker_remove_probe(name);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(marker_disarm_probe);
+
+/* Calls _marker_list_probe_range for the core markers and modules markers.
+ * Marker listing uses the modlist_lock to synchronise.
+ * TODO : should output this listing to a procfs file. */
+int marker_list_probe(marker_probe_func *probe)
+{
+	struct module *mod;
+	int found = 0;
+
+	mutex_lock(&module_mutex);
+	/* Core kernel markers */
+	printk("Listing kernel markers\n");
+	found += marker_list_probe_range(probe,
+			__start___markers, __stop___markers);
+	/* Markers in modules. */
+	printk("Listing module markers\n");
+	list_for_each_entry(mod, &modules, list) {
+		if (!mod->taints) {
+			printk("Listing markers for module %s\n", mod->name);
+			found += marker_list_probe_range(probe,
+				mod->markers, mod->markers+mod->num_markers);
+		}
+	}
+	mutex_unlock(&module_mutex);
+	return found;
+}
+EXPORT_SYMBOL_GPL(marker_list_probe);
+
+/* Looks up a marker by its name and instance number and returns the
+ * associated data structure. */
+const struct __mark_marker_data *marker_query(const char *name, int instance)
+{
+	struct module *mod;
+	const struct __mark_marker_data *mdata;
+
+	mutex_lock(&module_mutex);
+	/* Core kernel markers */
+	mdata = marker_query_range(name, instance,
+			__start___markers, __stop___markers);
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
+	}
+	mutex_unlock(&module_mutex);
+	return mdata;
+}
+EXPORT_SYMBOL_GPL(marker_query);
+#endif
+
 #ifdef CONFIG_SMP
 /* Number of blocks used and allocated. */
 static unsigned int pcpu_num_used, pcpu_num_allocated;
@@ -1936,6 +2246,8 @@
 	unsigned int unusedgplcrcindex;
 	unsigned int condcallindex;
 	unsigned int condcallstringsindex;
+	unsigned int markersindex;
+	unsigned int markersdataindex;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -2034,6 +2346,8 @@
 #endif
 	condcallindex = find_sec(hdr, sechdrs, secstrings, "__cond_call");
 	condcallstringsindex = find_sec(hdr, sechdrs, secstrings, "__cond_call_strings");
+	markersindex = find_sec(hdr, sechdrs, secstrings, "__markers");
+	markersdataindex = find_sec(hdr, sechdrs, secstrings, "__markers_data");
 
 	/* Don't keep modinfo section */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -2056,6 +2370,17 @@
 		sechdrs[condcallstringsindex].sh_flags
 					&= ~(unsigned long)SHF_ALLOC;
 #endif
+#ifdef CONFIG_MARKERS
+	if (markersindex)
+		sechdrs[markersindex].sh_flags |= SHF_ALLOC;
+	if (markersdataindex)
+		sechdrs[markersdataindex].sh_flags |= SHF_ALLOC;
+#else
+	if (markersindex)
+		sechdrs[markersindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
+	if (markersdataindex)
+		sechdrs[markersdataindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
+#endif
 
 	/* Check module struct version now, before we try to use module. */
 	if (!check_modstruct_version(sechdrs, versindex, mod)) {
@@ -2201,6 +2526,11 @@
 		mod->num_cond_calls =
 			sechdrs[condcallindex].sh_size / sizeof(*mod->cond_calls);
 	}
+	if (markersindex) {
+		mod->markers = (void *)sechdrs[markersindex].sh_addr;
+		mod->num_markers =
+			sechdrs[markersindex].sh_size / sizeof(*mod->markers);
+	}
 
 	mod->unused_syms = (void *)sechdrs[unusedindex].sh_addr;
 	if (unusedcrcindex)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

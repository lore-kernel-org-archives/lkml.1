Return-Path: <linux-kernel-owner+w=401wt.eu-S1764110AbXE2Sii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764110AbXE2Sii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759633AbXE2ShZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:37:25 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:43726 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759369AbXE2ShW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:37:22 -0400
Message-Id: <20070529183707.602366328@polymtl.ca>
References: <20070529183356.192838687@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 29 May 2007 14:33:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 1/9] Conditional Calls - Architecture Independent Code
Content-Disposition: inline; filename=conditional-calls-architecture-independent-code.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 29 May 2007 18:37:08 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Conditional calls are used to compile in code that is meant to be dynamically
enabled at runtime. When code is disabled, it has a very small footprint.

It has a generic cond_call version and optimized per architecture cond_calls.
The optimized cond_call uses a load immediate to remove a data cache hit.

It adds a new rodata section "__cond_call" to place the pointers to the enable
value.

cond_call activation functions sits in module.c.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-generic/vmlinux.lds.h |   16 +-
 include/linux/condcall.h          |   91 +++++++++++++
 include/linux/module.h            |    4 
 kernel/module.c                   |  248 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 356 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/include/linux/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/linux/condcall.h	2007-05-17 02:13:53.000000000 -0400
@@ -0,0 +1,91 @@
+#ifndef _LINUX_CONDCALL_H
+#define _LINUX_CONDCALL_H
+
+/*
+ * Conditional function calls. Cheap when disabled, enabled at runtime.
+ *
+ * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#ifdef __KERNEL__
+
+struct __cond_call_struct {
+	const char *name;
+	void *enable;
+	int flags;
+} __attribute__((packed));
+
+
+/* Cond call flags : selects the mechanism used to enable the conditional calls
+ * and prescribe what can be executed within their function. This is primarily
+ * used at reentrancy-unfriendly sites. */
+#define CF_OPTIMIZED		(1 << 0) /* Use optimized cond_call */
+#define CF_LOCKDEP		(1 << 1) /* Can call lockdep */
+#define CF_PRINTK		(1 << 2) /* Probe can call vprintk */
+#define CF_STATIC_ENABLE	(1 << 3) /* Enable cond_call statically */
+#define _CF_NR			4
+
+#ifdef CONFIG_COND_CALL
+
+/* Generic cond_call flavor always available.
+ * Note : the empty asm volatile with read constraint is used here instead of a
+ * "used" attribute to fix a gcc 4.1.x bug. */
+#define cond_call_generic(flags, name, func) \
+	({ \
+		static const char __cstrtab_name_##name[] \
+		__attribute__((section("__cond_call_strings"))) = #name; \
+		static char __cond_call_enable_##name = \
+			(flags) & CF_STATIC_ENABLE; \
+		static const struct __cond_call_struct __cond_call_##name \
+			__attribute__((section("__cond_call"))) = \
+			{ __cstrtab_name_##name, \
+			&__cond_call_enable_##name, \
+			(flags) & ~CF_OPTIMIZED } ; \
+		asm volatile ( "" : : "i" (&__cond_call_##name)); \
+		(unlikely(__cond_call_enable_##name)) ? \
+			(func) : \
+			(__typeof__(func))0; \
+	})
+
+#define COND_CALL_GENERIC_ENABLE_IMMEDIATE_OFFSET 0
+#define COND_CALL_GENERIC_ENABLE_TYPE unsigned char
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define COND_CALL_GENERIC_ENABLE(a) \
+	*(COND_CALL_GENERIC_ENABLE_TYPE*) \
+		((char*)a+COND_CALL_GENERIC_ENABLE_IMMEDIATE_OFFSET)
+
+static inline int cond_call_generic_set_enable(void *address, char enable)
+{
+	COND_CALL_GENERIC_ENABLE(address) = enable;
+	return 0;
+}
+
+#else /* !CONFIG_COND_CALL */
+#define cond_call_generic(flags, name, func) \
+	({ \
+		((flags) & CF_STATIC_ENABLE) ? \
+			(func) : \
+			(__typeof__(func))0; \
+	})
+#endif /* CONFIG_COND_CALL */
+
+#ifdef CONFIG_COND_CALL_ENABLE_OPTIMIZATION
+#include <asm/condcall.h>		/* optimized cond_call flavor */
+#else
+#include <asm-generic/condcall.h>	/* fallback on generic cond_call */
+#endif
+
+#define COND_CALL_MAX_FORMAT_LEN	1024
+
+extern int cond_call_arm(const char *name);
+extern int cond_call_disarm(const char *name);
+
+/* cond_call_query : Returns 1 if enabled, 0 if disabled or not present */
+extern int cond_call_query(const char *name);
+extern int cond_call_list(const char *name);
+
+#endif /* __KERNEL__ */
+#endif
Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-05-17 02:12:25.000000000 -0400
+++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-05-17 02:13:42.000000000 -0400
@@ -116,11 +116,22 @@
 		*(__kcrctab_gpl_future)					\
 		VMLINUX_SYMBOL(__stop___kcrctab_gpl_future) = .;	\
 	}								\
-									\
+	/* Conditional calls: pointers */				\
+	__cond_call : AT(ADDR(__cond_call) - LOAD_OFFSET) {		\
+		VMLINUX_SYMBOL(__start___cond_call) = .;		\
+		*(__cond_call)						\
+		VMLINUX_SYMBOL(__stop___cond_call) = .;			\
+	}								\
 	/* Kernel symbol table: strings */				\
         __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {	\
 		*(__ksymtab_strings)					\
-	}								\
+ 	}								\
+	/* Conditional calls: strings */				\
+        __cond_call_strings : AT(ADDR(__cond_call_strings) - LOAD_OFFSET) { \
+		*(__cond_call_strings)					\
+ 	}								\
+	__end_rodata = .;						\
+	. = ALIGN(4096);						\
 									\
 	/* Built-in module parameters. */				\
 	__param : AT(ADDR(__param) - LOAD_OFFSET) {			\
@@ -228,4 +239,3 @@
   	*(.initcall6s.init)						\
   	*(.initcall7.init)						\
   	*(.initcall7s.init)
-
Index: linux-2.6-lttng/include/linux/module.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/module.h	2007-05-17 02:12:34.000000000 -0400
+++ linux-2.6-lttng/include/linux/module.h	2007-05-17 02:13:41.000000000 -0400
@@ -16,6 +16,7 @@
 #include <linux/stringify.h>
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
+#include <linux/condcall.h>
 #include <asm/local.h>
 
 #include <asm/module.h>
@@ -356,6 +357,9 @@
 	/* The command line arguments (may be mangled).  People like
 	   keeping pointers to this stuff */
 	char *args;
+
+	const struct __cond_call_struct *cond_calls;
+	unsigned int num_cond_calls;
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2007-05-17 02:12:25.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2007-05-17 02:13:53.000000000 -0400
@@ -32,6 +32,7 @@
 #include <linux/cpu.h>
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
+#include <linux/condcall.h>
 #include <linux/err.h>
 #include <linux/vermagic.h>
 #include <linux/notifier.h>
@@ -141,6 +142,8 @@
 extern const unsigned long __start___kcrctab_gpl_future[];
 extern const unsigned long __start___kcrctab_unused[];
 extern const unsigned long __start___kcrctab_unused_gpl[];
+extern const struct __cond_call_struct __start___cond_call[];
+extern const struct __cond_call_struct __stop___cond_call[];
 
 #ifndef CONFIG_MODVERSIONS
 #define symversion(base, idx) NULL
@@ -301,6 +304,230 @@
 	return NULL;
 }
 
+#ifdef CONFIG_COND_CALL
+
+/* Set the enable bit of the cond_call, choosing the generic or architecture
+ * specific functions depending on the cond_call's flags.
+ */
+static int cond_call_set_enable(void *address, char enable, int flags)
+{
+	if (flags & CF_OPTIMIZED)
+		return cond_call_optimized_set_enable(address, enable);
+	else
+		return cond_call_generic_set_enable(address, enable);
+}
+
+/* Query the state of a cond_calls range. */
+static int _cond_call_query_range(const char *name,
+	const struct __cond_call_struct *begin,
+	const struct __cond_call_struct *end)
+{
+	const struct __cond_call_struct *iter;
+	int ret = 0;
+
+	for (iter = begin; iter < end; iter++) {
+		if (strcmp(name, iter->name) != 0)
+			continue;
+		if (iter->flags & CF_OPTIMIZED)
+			ret = COND_CALL_OPTIMIZED_ENABLE(iter->enable);
+		else
+			ret = COND_CALL_GENERIC_ENABLE(iter->enable);
+		if (ret)
+			break;
+	}
+	return ret;
+}
+
+/* Sets a range of cond_calls to a enabled state : set the enable bit. */
+static int _cond_call_arm_range(const char *name,
+	const struct __cond_call_struct *begin,
+	const struct __cond_call_struct *end)
+{
+	const struct __cond_call_struct *iter;
+	int found = 0;
+
+	for (iter = begin; iter < end; iter++) {
+		if (strcmp(name, iter->name) != 0)
+			continue;
+		cond_call_set_enable(iter->enable, 1, iter->flags);
+		found++;
+	}
+	return found;
+}
+
+/* Sets a range of cond_calls to a disabled state : unset the enable bit. */
+static int _cond_call_disarm_range(const char *name,
+	const struct __cond_call_struct *begin,
+	const struct __cond_call_struct *end)
+{
+	const struct __cond_call_struct *iter;
+	int found = 0;
+
+	for (iter = begin; iter < end; iter++) {
+		if (strcmp(name, iter->name) != 0)
+			continue;
+		cond_call_set_enable(iter->enable, 0, iter->flags);
+		found++;
+	}
+	return found;
+}
+
+/* Provides a listing of the cond_calls present in the kernel with their type
+ * (optimized or generic) and state (enabled or disabled). */
+static int _cond_call_list_range(const char *name,
+	const struct __cond_call_struct *begin,
+	const struct __cond_call_struct *end)
+{
+	const struct __cond_call_struct *iter;
+	int found = 0;
+
+	for (iter = begin; iter < end; iter++) {
+		if (name)
+			if (strcmp(name, iter->name) != 0)
+				continue;
+		printk("name %s \n", iter->name);
+		if (iter->flags & CF_OPTIMIZED)
+			printk("  enable %u optimized\n",
+				COND_CALL_OPTIMIZED_ENABLE(iter->enable));
+		else
+			printk("  enable %u generic\n",
+				COND_CALL_GENERIC_ENABLE(iter->enable));
+		found++;
+	}
+	return found;
+}
+
+/* Calls _cond_call_query_range for the core cond_calls and modules cond_calls.
+ */
+static int _cond_call_query(const char *name)
+{
+	struct module *mod;
+	int ret = 0;
+
+	/* Core kernel cond_calls */
+	ret = _cond_call_query_range(name,
+			__start___cond_call, __stop___cond_call);
+	if (ret)
+		return ret;
+	/* Cond_calls in modules. */
+	list_for_each_entry(mod, &modules, list) {
+		if (mod->taints)
+			continue;
+		ret = _cond_call_query_range(name,
+			mod->cond_calls, mod->cond_calls+mod->num_cond_calls);
+		if (ret)
+			break;
+	}
+	return ret;
+}
+
+/* Cond_call enabling/disabling use the module_mutex to synchronize.
+ * Returns 1 if enabled, 0 if disabled or not present. */
+int cond_call_query(const char *name)
+{
+	int ret = 0;
+
+	mutex_lock(&module_mutex);
+	ret = _cond_call_query(name);
+	mutex_unlock(&module_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cond_call_query);
+
+/* Calls _cond_call_arm_range for the core cond_calls and modules cond_calls.
+ * FIXME : cond_call will not be active on modules loaded later than the
+ * cond_call_arm. */
+static int _cond_call_arm(const char *name)
+{
+	struct module *mod;
+	int found = 0;
+
+	/* Core kernel cond_calls */
+	found += _cond_call_arm_range(name,
+			__start___cond_call, __stop___cond_call);
+	/* Cond_calls in modules. */
+	list_for_each_entry(mod, &modules, list) {
+		if (mod->taints)
+			continue;
+		found += _cond_call_arm_range(name,
+			mod->cond_calls, mod->cond_calls+mod->num_cond_calls);
+	}
+	return found;
+}
+
+/* Cond_call enabling/disabling use the module_mutex to synchronize. */
+int cond_call_arm(const char *name)
+{
+	int found = 0;
+
+	mutex_lock(&module_mutex);
+	found = _cond_call_arm(name);
+	mutex_unlock(&module_mutex);
+	return found;
+}
+EXPORT_SYMBOL_GPL(cond_call_arm);
+
+/* Calls _cond_call_disarm_range for the core cond_calls and modules cond_calls.
+ */
+static int _cond_call_disarm(const char *name)
+{
+	struct module *mod;
+	int found = 0;
+
+	/* Core kernel cond_calls */
+	found += _cond_call_disarm_range(name,
+			__start___cond_call, __stop___cond_call);
+	/* Cond_calls in modules. */
+	list_for_each_entry(mod, &modules, list) {
+		if (mod->taints)
+			continue;
+		found += _cond_call_disarm_range(name,
+			mod->cond_calls, mod->cond_calls+mod->num_cond_calls);
+	}
+	return found;
+}
+
+/* Cond_call enabling/disabling use the module_mutex to synchronize. */
+int cond_call_disarm(const char *name)
+{
+	int found = 0;
+
+	mutex_lock(&module_mutex);
+	found = _cond_call_disarm(name);
+	mutex_unlock(&module_mutex);
+	return found;
+}
+EXPORT_SYMBOL_GPL(cond_call_disarm);
+
+/* Calls _cond_call_list_range for the core and module cond_calls.
+ * Cond call listing uses the module_mutex to synchronize.
+ * TODO : should output this listing to a procfs file. */
+int cond_call_list(const char *name)
+{
+	struct module *mod;
+	int found = 0;
+
+	mutex_lock(&module_mutex);
+	/* Core kernel cond_calls */
+	printk("Listing kernel cond_calls\n");
+	found += _cond_call_list_range(name,
+			__start___cond_call, __stop___cond_call);
+	/* Cond_calls in modules. */
+	printk("Listing module cond_calls\n");
+	list_for_each_entry(mod, &modules, list) {
+		if (!mod->taints) {
+			printk("Listing cond_calls for module %s\n", mod->name);
+			found += _cond_call_list_range(name, mod->cond_calls,
+				mod->cond_calls+mod->num_cond_calls);
+		}
+	}
+	mutex_unlock(&module_mutex);
+	return found;
+}
+EXPORT_SYMBOL_GPL(cond_call_list);
+
+#endif
+
 #ifdef CONFIG_SMP
 /* Number of blocks used and allocated. */
 static unsigned int pcpu_num_used, pcpu_num_allocated;
@@ -1658,6 +1885,8 @@
 	unsigned int unusedcrcindex;
 	unsigned int unusedgplindex;
 	unsigned int unusedgplcrcindex;
+	unsigned int condcallindex;
+	unsigned int condcallstringsindex;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -1754,6 +1983,8 @@
 #ifdef ARCH_UNWIND_SECTION_NAME
 	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
 #endif
+	condcallindex = find_sec(hdr, sechdrs, secstrings, "__cond_call");
+	condcallstringsindex = find_sec(hdr, sechdrs, secstrings, "__cond_call_strings");
 
 	/* Don't keep modinfo section */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -1764,6 +1995,18 @@
 #endif
 	if (unwindex)
 		sechdrs[unwindex].sh_flags |= SHF_ALLOC;
+#ifdef CONFIG_COND_CALL
+	if (condcallindex)
+		sechdrs[condcallindex].sh_flags |= SHF_ALLOC;
+	if (condcallstringsindex)
+		sechdrs[condcallstringsindex].sh_flags |= SHF_ALLOC;
+#else
+	if (condcallindex)
+		sechdrs[condcallindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
+	if (condcallstringsindex)
+		sechdrs[condcallstringsindex].sh_flags
+					&= ~(unsigned long)SHF_ALLOC;
+#endif
 
 	/* Check module struct version now, before we try to use module. */
 	if (!check_modstruct_version(sechdrs, versindex, mod)) {
@@ -1904,6 +2147,11 @@
 	mod->gpl_future_syms = (void *)sechdrs[gplfutureindex].sh_addr;
 	if (gplfuturecrcindex)
 		mod->gpl_future_crcs = (void *)sechdrs[gplfuturecrcindex].sh_addr;
+	if (condcallindex) {
+		mod->cond_calls = (void *)sechdrs[condcallindex].sh_addr;
+		mod->num_cond_calls =
+			sechdrs[condcallindex].sh_size / sizeof(*mod->cond_calls);
+	}
 
 	mod->unused_syms = (void *)sechdrs[unusedindex].sh_addr;
 	if (unusedcrcindex)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

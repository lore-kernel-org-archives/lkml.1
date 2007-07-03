Return-Path: <linux-kernel-owner+w=401wt.eu-S1760502AbXGCQql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760502AbXGCQql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759559AbXGCQp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:45:27 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:45779 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755802AbXGCQpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:45:19 -0400
Message-Id: <20070703164513.741212414@polymtl.ca>
References: <20070703164046.645090494@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jul 2007 12:40:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 02/10] Immediate Value - Architecture Independent Code
Content-Disposition: inline; filename=immediate-values-architecture-independent-code.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  3 Jul 2007 16:45:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Immediate values (previously known as conditional calls) are used as a
fast condition used in an if() statement to compile in a block meant to be
dynamically enabled at runtime. When it is disabled, it has a very small
footprint: it loads an immediate value, fed to the branch. In the disabled
state, the branch skips the whole block (if the block consists in a function
call, it will skip the argument setup and the call itself).

It can be used to compile code in the kernel that is seldomly meant to be
dynamically activated. It's the case of CPU specific workarounds, profiling,
tracing, etc.

There is a generic immediate() version, which uses standard global variables,
and optimized per architecture immediate() implementations, which use a load
immediate to remove a data cache hit. When the immediate() functionnality is
disabled in the kernel, it falls back to global variables.

It adds a new rodata section "__immediate" to place the pointers to the enable
value. immediate() activation functions sits in kernel/immediate.c.

Immediate values refer to the memory address of a previously declared integer.
This integer hold the information about the state of the immediate values
associated, and must be accessed through the API found in linux/immediate.h.

At module load time, each immediate value is checked to see if it must be
enabled. It would be the case if the variable they refer to is exported from
another module and already enabled.

In their current implementation, immediate values should not be used to store
data not meant to be either 0 or !0. The goal of the optimized implementations
is to get the smallest instruction, with lowest impact on the normal function
behavior and to provide a int3 handler teardown that will support preemptible
code. Also, since the i386 architecture implementation depends on the 0 vs !0
variable caracteristic, it is recommended to only use these variables as a
condition for a if() statement.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-generic/vmlinux.lds.h |    7 +
 include/linux/immediate.h         |  116 ++++++++++++++++++++++
 include/linux/module.h            |   10 +
 kernel/Makefile                   |    1 
 kernel/immediate.c                |  197 ++++++++++++++++++++++++++++++++++++++
 kernel/module.c                   |   18 +++
 6 files changed, 349 insertions(+)

Index: linux-2.6-lttng/include/linux/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/linux/immediate.h	2007-07-03 11:51:20.000000000 -0400
@@ -0,0 +1,116 @@
+#ifndef _LINUX_IMMEDIATE_H
+#define _LINUX_IMMEDIATE_H
+
+/*
+ * Immediate values, can be set at runtime. Only set to 0 or 1.
+ *
+ * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#ifdef __KERNEL__
+
+struct module;
+
+/* Always access this type with the provided functions. */
+typedef struct { int value; } immediate_t;
+
+struct __immediate {
+		/* Identifier variable (int *) of the immediate value */
+	immediate_t *var;
+		/*
+		 * Pointer to the memory location that holds the value (data or
+ 		 * immediate value within the load immediate instruction).
+		 */
+	void *enable;
+		/* Immediate value flags, see the list below */
+	int flags;
+};
+
+/*
+ * Immediate value flags : selects the mechanism used to set the immediate
+ * value. This is primarily used at reentrancy-unfriendly sites.
+ *
+ * On an architecture that has optimized immediate values implemented,
+ * the IF_OPTIMIZED flags distinguishes between optimized and non-optimized
+ * immediate value statements: typically, reentrancy-unfriendly sites should
+ * declare their immediate values without the IF_OPTIMIZED flag.
+ */
+#define IF_OPTIMIZED		(1 << 0) /* Use optimized immediate */
+#define IF_LOCKDEP		(1 << 1) /* Can trigger lockdep at patch site */
+#define _IF_NR			2
+
+/*
+ * In order to support embedded systems with read-only memory for the text
+ * segment, the choice to disable the "optimized" immediate values is left as a
+ * config option even if the architecture has the optimized flavor.
+ *
+ * This include scheme is used to support both the generic and optimized version
+ * at the same time : if a _immediate is declared with the IF_OPTIMIZED flags
+ * unset, it will use the generic version. This is useful when we must place
+ * immediates in locations that present specific reentrancy issues, such as
+ * some trap handlers, in the lockdep code and some of the scheduler code. The
+ * optimized version, when it uses the i386 mechanism to insure correct
+ * cross-cpu code modification, can trigger a trap, which will call into lockdep
+ * and might have other side-effects.
+ */
+
+#ifdef CONFIG_IMMEDIATE
+
+#include <asm/immediate.h>		/* optimized immediate flavor */
+
+/*
+ * Generic immediate flavor always available.
+ *
+ * Note : the empty asm volatile with read constraint is used here instead of a
+ * "used" attribute to fix a gcc 4.1.x bug.
+ * Quoting Jeremy Fitzhardinge <jeremy@goop.org> :
+ * "There's a gcc bug which ignores the attribute for local-scope static
+ * variables: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=29299"
+ */
+#define immediate_generic(flags, var)					\
+	({								\
+		static const struct __immediate __immediate_info	\
+			__attribute__((section("__immediate"))) =	\
+			{ &(var), NULL, (flags) & ~IF_OPTIMIZED } ;	\
+		asm volatile ( "" : : "i" (&__immediate_info));		\
+		(var).value;						\
+	})
+
+extern void immediate_arm(immediate_t *var);
+extern void immediate_disarm(immediate_t *var);
+extern int immediate_list(void);
+extern void module_immediate_setup(struct module *mod);
+extern void __immediate_update(immediate_t *var, int value);
+#else /* !CONFIG_IMMEDIATE */
+
+#include <asm-generic/immediate.h>	/* fallback on generic immediate */
+
+#define immediate_generic(flags, var)	(unlikely((var).value))
+
+static inline void immediate_arm(immediate_t *var)
+{
+	var->value = 1;
+}
+
+static inline void immediate_disarm(immediate_t *var)
+{
+	var->value = 0;
+}
+static inline void module_immediate_setup(struct module *mod) { }
+static inline void __immediate_update(immediate_t *var, int value)
+{
+	var->value = value;
+}
+#endif /* CONFIG_IMMEDIATE */
+
+/* immediate_query : Returns 1 if enabled, 0 if disabled or not present */
+static inline int immediate_query(immediate_t *var)
+{
+	return var->value;
+}
+
+#endif /* __KERNEL__ */
+#endif
Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-07-03 11:47:41.000000000 -0400
+++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-07-03 11:51:20.000000000 -0400
@@ -122,6 +122,13 @@
 		VMLINUX_SYMBOL(__stop___kcrctab_gpl_future) = .;	\
 	}								\
 									\
+	/* Immediate values: pointers */				\
+	__immediate : AT(ADDR(__immediate) - LOAD_OFFSET) {		\
+		VMLINUX_SYMBOL(__start___immediate) = .;		\
+		*(__immediate)						\
+		VMLINUX_SYMBOL(__stop___immediate) = .;			\
+	}								\
+									\
 	/* Kernel symbol table: strings */				\
         __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {	\
 		*(__ksymtab_strings)					\
Index: linux-2.6-lttng/include/linux/module.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/module.h	2007-07-03 11:47:41.000000000 -0400
+++ linux-2.6-lttng/include/linux/module.h	2007-07-03 11:51:20.000000000 -0400
@@ -15,6 +15,7 @@
 #include <linux/stringify.h>
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
+#include <linux/immediate.h>
 #include <asm/local.h>
 
 #include <asm/module.h>
@@ -67,6 +68,10 @@
 /* Archs provide a method of finding the correct exception table. */
 struct exception_table_entry;
 
+/* Protects the list of modules. */
+extern struct mutex module_mutex;
+extern struct list_head modules;
+
 const struct exception_table_entry *
 search_extable(const struct exception_table_entry *first,
 	       const struct exception_table_entry *last,
@@ -370,6 +375,11 @@
 	/* The command line arguments (may be mangled).  People like
 	   keeping pointers to this stuff */
 	char *args;
+
+#ifdef CONFIG_IMMEDIATE
+	const struct __immediate *immediates;
+	unsigned int num_immediates;
+#endif
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2007-07-03 11:48:45.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2007-07-03 11:51:20.000000000 -0400
@@ -32,6 +32,7 @@
 #include <linux/cpu.h>
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
+#include <linux/immediate.h>
 #include <linux/err.h>
 #include <linux/vermagic.h>
 #include <linux/notifier.h>
@@ -1623,6 +1624,9 @@
 	unsigned int unusedcrcindex;
 	unsigned int unusedgplindex;
 	unsigned int unusedgplcrcindex;
+	unsigned int immediateindex = 0;
+	unsigned int markersindex = 0;
+	unsigned int markersstringsindex = 0;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -1719,6 +1723,9 @@
 #ifdef ARCH_UNWIND_SECTION_NAME
 	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
 #endif
+#ifdef CONFIG_IMMEDIATE
+	immediateindex = find_sec(hdr, sechdrs, secstrings, "__immediate");
+#endif
 
 	/* Don't keep modinfo section */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -1729,6 +1736,8 @@
 #endif
 	if (unwindex)
 		sechdrs[unwindex].sh_flags |= SHF_ALLOC;
+	if (immediateindex)
+		sechdrs[immediateindex].sh_flags |= SHF_ALLOC;
 
 	/* Check module struct version now, before we try to use module. */
 	if (!check_modstruct_version(sechdrs, versindex, mod)) {
@@ -1869,6 +1878,13 @@
 	mod->gpl_future_syms = (void *)sechdrs[gplfutureindex].sh_addr;
 	if (gplfuturecrcindex)
 		mod->gpl_future_crcs = (void *)sechdrs[gplfuturecrcindex].sh_addr;
+#ifdef CONFIG_IMMEDIATE
+	if (immediateindex) {
+		mod->immediates = (void *)sechdrs[immediateindex].sh_addr;
+		mod->num_immediates =
+			sechdrs[immediateindex].sh_size / sizeof(*mod->immediates);
+	}
+#endif
 
 	mod->unused_syms = (void *)sechdrs[unusedindex].sh_addr;
 	if (unusedcrcindex)
@@ -1934,6 +1950,8 @@
         }
 #endif
 
+	module_immediate_setup(mod);
+
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
 		goto cleanup;
Index: linux-2.6-lttng/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/kernel/Makefile	2007-07-03 11:47:41.000000000 -0400
+++ linux-2.6-lttng/kernel/Makefile	2007-07-03 11:51:20.000000000 -0400
@@ -58,6 +58,7 @@
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
+obj-$(CONFIG_IMMEDIATE) += immediate.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
Index: linux-2.6-lttng/kernel/immediate.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/kernel/immediate.c	2007-07-03 11:51:20.000000000 -0400
@@ -0,0 +1,197 @@
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
+#include <linux/immediate.h>
+
+extern const struct __immediate __start___immediate[];
+extern const struct __immediate __stop___immediate[];
+
+/*
+ * modules_mutex nests inside immediate_mutex. immediate_mutex protects builtin
+ * immediates and module immediates.
+ */
+DEFINE_MUTEX(immediate_mutex);
+
+/*
+ * Sets a range of immediates to a enabled state : set the enable bit.
+ */
+static void _immediate_update_range(
+	const struct __immediate *begin, const struct __immediate *end)
+{
+	const struct __immediate *iter;
+	int enable;
+
+	for (iter = begin; iter < end; iter++) {
+		if (!(iter->flags & IF_OPTIMIZED))
+			continue;
+		enable = immediate_query(iter->var);
+		if (enable != IMMEDIATE_OPTIMIZED_ENABLE(iter->enable))
+			immediate_optimized_set_enable(iter->enable, enable);
+	}
+}
+
+#ifdef CONFIG_MODULES
+/*
+ * Setup the immediate according to the variable upon which it depends.  Called
+ * by load_module with module_mutex held. This mutex protects against concurrent
+ * modifications to modules'immediates. Therefore, since
+ * module_immediate_setup() does not modify builtin immediates, it does not need
+ * to take the immediate_mutex.
+ */
+void module_immediate_setup(struct module *mod)
+{
+	_immediate_update_range(mod->immediates,
+		mod->immediates+mod->num_immediates);
+}
+#endif
+
+/*
+ * Provides a listing of the immediates present in the kernel with their type
+ * (optimized or generic) and state (enabled or disabled).
+ */
+static int _immediate_list_range(const struct __immediate *begin,
+	const struct __immediate *end)
+{
+	const struct __immediate *iter;
+	int found = 0;
+
+	for (iter = begin; iter < end; iter++) {
+		printk("variable %p \n", iter->var);
+		if (iter->flags & IF_OPTIMIZED)
+			printk("  enable %u optimized\n",
+				IMMEDIATE_OPTIMIZED_ENABLE(iter->enable));
+		else
+			printk("  enable %u generic\n",
+				immediate_query(iter->var));
+		found++;
+	}
+	return found;
+}
+
+#ifdef CONFIG_MODULES
+static inline void __immediate_update_modules(immediate_t *var, int value)
+{
+	struct module *mod;
+
+	list_for_each_entry(mod, &modules, list) {
+		if (mod->taints)
+			continue;
+		_immediate_update_range(mod->immediates,
+			mod->immediates+mod->num_immediates);
+	}
+}
+#else
+static inline void __immediate_update_modules(immediate_t *var, int value) { }
+#endif
+
+/*
+ * Calls _immediate_update_range for the core immediates and modules immediates.
+ */
+void __immediate_update(immediate_t *var, int value)
+{
+
+	var->value = value;
+	/* Core kernel immediates */
+	_immediate_update_range(__start___immediate, __stop___immediate);
+	/* immediates in modules. */
+	__immediate_update_modules(var, value);
+}
+
+#ifdef CONFIG_MODULES
+/*
+ * Takes module_mutex.
+ */
+void _immediate_update(immediate_t *var, int value)
+{
+	mutex_lock(&module_mutex);
+	__immediate_update(var, value);
+	mutex_unlock(&module_mutex);
+}
+#else
+void _immediate_update(immediate_t *var, int value)
+{
+	__immediate_update(var, value);
+}
+#endif
+
+/* immediate enabling/disabling use the immediate_mutex to synchronize. */
+void immediate_arm(immediate_t *var)
+{
+	mutex_lock(&immediate_mutex);
+	_immediate_update(var, 1);
+	mutex_unlock(&immediate_mutex);
+}
+EXPORT_SYMBOL_GPL(immediate_arm);
+
+/* immediate enabling/disabling use the immediate_mutex to synchronize. */
+void immediate_disarm(immediate_t *var)
+{
+	mutex_lock(&immediate_mutex);
+	_immediate_update(var, 0);
+	mutex_unlock(&immediate_mutex);
+}
+EXPORT_SYMBOL_GPL(immediate_disarm);
+
+#ifdef CONFIG_MODULES
+static inline int immediate_list_modules(void)
+{
+	int found = 0;
+	struct module *mod;
+
+	printk("Listing module immediate values\n");
+	mutex_lock(&module_mutex);
+	list_for_each_entry(mod, &modules, list) {
+		if (!mod->taints) {
+			printk("Listing immediate values for module %s\n",
+				mod->name);
+			found += _immediate_list_range(mod->immediates,
+				mod->immediates+mod->num_immediates);
+		}
+	}
+	mutex_unlock(&module_mutex);
+	return found;
+}
+#else
+static inline int immediate_list_modules(void)
+{
+	return 0;
+}
+#endif
+
+/*
+ * Calls _immediate_list_range for the core and module immediates.
+ * Cond call listing uses the module_mutex to synchronize.
+ * Takes the immediate mutex to protect against builtin immediate modification
+ * and takes the module_mutex to protect against module list modification.
+ * TODO : should output this listing to a procfs file.
+ */
+int immediate_list(void)
+{
+	int found = 0;
+
+	mutex_lock(&immediate_mutex);
+	/* Core kernel immediates */
+	printk("Listing kernel immediate values\n");
+	found += _immediate_list_range(__start___immediate, __stop___immediate);
+	/* immediates in modules. */
+	found += immediate_list_modules();
+	mutex_unlock(&immediate_mutex);
+	return found;
+}
+EXPORT_SYMBOL_GPL(immediate_list);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

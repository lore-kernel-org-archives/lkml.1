Return-Path: <linux-kernel-owner+w=401wt.eu-S935179AbXHLPNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935179AbXHLPNW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936254AbXHLPIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:08:51 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47597 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936152AbXHLPIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:08:48 -0400
Message-Id: <20070812150814.414317013@polymtl.ca>
References: <20070812150702.769065566@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:07:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 2/8] Immediate Values - Architecture Independent Code
Content-Disposition: inline; filename=immediate-values-architecture-independent-code.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 15:08:14 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Immediate values are used as read mostly variables that are rarely updated. They
use code patching to modify the values inscribed in the instruction stream. It
provides a way to save precious cache lines that would otherwise have to be used
by these variables.

There is a generic _immediate_read() version, which uses standard global
variables, and optimized per architecture immediate_read() implementations,
which use a load immediate to remove a data cache hit. When the immediate values
functionnality is disabled in the kernel, it falls back to global variables.

It adds a new rodata section "__immediate" to place the pointers to the enable
value. Immediate values activation functions sits in kernel/immediate.c.

Immediate values refer to the memory address of a previously declared integer.
This integer holds the information about the state of the immediate values
associated, and must be accessed through the API found in linux/immediate.h.

At module load time, each immediate value is checked to see if it must be
enabled. It would be the case if the variable they refer to is exported from
another module and already enabled.

In the early stages of start_kernel(), the immediate values are updated to
reflect the state of the variable they refer to.

* Why should this be merged *

It improves performances on heavy memory I/O workloads.

An interesting result shows the potential this infrastructure has by
showing the slowdown a simple system call such as getppid() suffers when it is
used under heavy user-space cache trashing:

Random walk L1 and L2 trashing surrounding a getppid() call:
(note: in this test, do_syscal_trace was taken at each system call, see
Documentation/immediate.txt in these patches for details)
- No memory pressure :   getppid() takes  1573 cycles
- With memory pressure : getppid() takes 15589 cycles

We therefore have a slowdown of 10 times just to get the kernel variables from
memory. Another test on the same architecture (Intel P4) measured the memory
latency to be 559 cycles. Therefore, each cache line removed from the hot path
would improve the syscall time of 3.5% in these conditions.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-generic/vmlinux.lds.h |    7 ++
 include/linux/immediate.h         |  119 +++++++++++++++++++++++++++++++++++
 include/linux/module.h            |    6 +
 init/main.c                       |    2 
 kernel/Makefile                   |    1 
 kernel/immediate.c                |  128 ++++++++++++++++++++++++++++++++++++++
 kernel/module.c                   |   16 ++++
 7 files changed, 279 insertions(+)

Index: linux-2.6-lttng/include/linux/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/linux/immediate.h	2007-08-07 13:30:21.000000000 -0400
@@ -0,0 +1,119 @@
+#ifndef _LINUX_IMMEDIATE_H
+#define _LINUX_IMMEDIATE_H
+
+/*
+ * Immediate values, can be updated at runtime and save cache lines.
+ *
+ * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#ifdef CONFIG_IMMEDIATE
+#include <asm/immediate.h>
+#else
+/*
+ * Generic immediate values: a simple, standard, memory load.
+ */
+
+struct module;
+
+/**
+ * immediate_read - read immediate variable
+ * @var: pointer of type immediate_*_t
+ *
+ * Reads the value of @var.
+ */
+#define immediate_read(var)		_immediate_read(var)
+
+/**
+ * immediate_set - set immediate variable (with locking)
+ * @var: pointer of type immediate_*_t
+ * @i: required value
+ *
+ * Sets the value of @var, taking the module_mutex if required by
+ * the architecture.
+ */
+#define immediate_set(var, i)		((var)->value = (i))
+
+/**
+ * _immediate_set - set immediate variable (without locking)
+ * @var: pointer of type immediate_*_t
+ * @i: required value
+ *
+ * Sets the value of @var. Must be called with module_mutex held.
+ */
+#define _immediate_set(var, i)		immediate_set(var, i)
+
+/**
+ * immediate_set_early - set immediate variable at early boot
+ * @var: pointer of type immediate_*_t
+ * @i: required value
+ *
+ * Sets the value of @var. Should be used for early boot updates.
+ */
+#define immediate_set_early(var, i)	immediate_set(var, i)
+
+/**
+ * immediate_if - if () statement depending on an immediate value
+ * @var: pointer of type immediate_*_t
+ *
+ * Use as an if () statement depending on an immediate value.
+ */
+#define immediate_if(var)		if (immediate_read(var))
+
+/*
+ * Internal update functions.
+ */
+static inline void module_immediate_setup(struct module *mod) { }
+static inline void immediate_update_early(void) { }
+#endif
+
+/**
+ * DEFINE_IMMEDIATE_TYPE - Define an immediate type
+ * @type: type that the immediate should hold
+ * @name: name of the immediate type
+ *
+ * Define new immediate types. Naming scheme is immediate_*_t.
+ * Always access these types with the provided functions.
+ */
+#define DEFINE_IMMEDIATE_TYPE(type, name) \
+	typedef struct { type value; } name
+
+/*
+ * Standard pre-defined immediate types.
+ */
+DEFINE_IMMEDIATE_TYPE(char, immediate_char_t);
+DEFINE_IMMEDIATE_TYPE(short, immediate_short_t);
+DEFINE_IMMEDIATE_TYPE(int, immediate_int_t);
+DEFINE_IMMEDIATE_TYPE(long, immediate_long_t);
+DEFINE_IMMEDIATE_TYPE(void*, immediate_void_ptr_t);
+
+/**
+ * IMMEDIATE_INIT - Static initialization of an immediate variable
+ * @i: required value
+ *
+ * Use this macro to initialize an immediate value to an initial static
+ * value.
+ */
+#define IMMEDIATE_INIT(i)		{ (i) }
+
+/**
+ * _immediate_read - Read immediate value with standard memory load.
+ * @var: pointer of type immediate_*_t
+ *
+ * Force a data read of the immediate value instead of the immediate value
+ * based mechanism. Useful for __init and __exit section data read.
+ */
+#define _immediate_read(var)		(var)->value
+
+/*
+ * _immediate_if - if () statement depending on immediate value (memory load)
+ * @var: pointer of type immediate_*_t
+ *
+ * Force the use of a normal if () statement depending on an immediate value.
+ */
+#define _immediate_if(var)		if (_immediate_read(var))
+
+#endif
Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-08-07 13:28:12.000000000 -0400
+++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-08-07 13:29:55.000000000 -0400
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
--- linux-2.6-lttng.orig/include/linux/module.h	2007-08-07 13:29:52.000000000 -0400
+++ linux-2.6-lttng/include/linux/module.h	2007-08-07 13:29:55.000000000 -0400
@@ -15,6 +15,7 @@
 #include <linux/stringify.h>
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
+#include <linux/immediate.h>
 #include <asm/local.h>
 
 #include <asm/module.h>
@@ -374,6 +375,11 @@ struct module
 	/* The command line arguments (may be mangled).  People like
 	   keeping pointers to this stuff */
 	char *args;
+
+#ifdef CONFIG_IMMEDIATE
+	const struct __immediate *immediate;
+	unsigned int num_immediate;
+#endif
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2007-08-07 13:29:52.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2007-08-07 13:29:55.000000000 -0400
@@ -33,6 +33,7 @@
 #include <linux/cpu.h>
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
+#include <linux/immediate.h>
 #include <linux/err.h>
 #include <linux/vermagic.h>
 #include <linux/notifier.h>
@@ -1719,6 +1720,7 @@ static struct module *load_module(void _
 	unsigned int unusedcrcindex;
 	unsigned int unusedgplindex;
 	unsigned int unusedgplcrcindex;
+	unsigned int immediateindex = 0;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -1815,6 +1817,9 @@ static struct module *load_module(void _
 #ifdef ARCH_UNWIND_SECTION_NAME
 	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
 #endif
+#ifdef CONFIG_IMMEDIATE
+	immediateindex = find_sec(hdr, sechdrs, secstrings, "__immediate");
+#endif
 
 	/* Don't keep modinfo section */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -1825,6 +1830,8 @@ static struct module *load_module(void _
 #endif
 	if (unwindex)
 		sechdrs[unwindex].sh_flags |= SHF_ALLOC;
+	if (immediateindex)
+		sechdrs[immediateindex].sh_flags |= SHF_ALLOC;
 
 	/* Check module struct version now, before we try to use module. */
 	if (!check_modstruct_version(sechdrs, versindex, mod)) {
@@ -1965,6 +1972,13 @@ static struct module *load_module(void _
 	mod->gpl_future_syms = (void *)sechdrs[gplfutureindex].sh_addr;
 	if (gplfuturecrcindex)
 		mod->gpl_future_crcs = (void *)sechdrs[gplfuturecrcindex].sh_addr;
+#ifdef CONFIG_IMMEDIATE
+	if (immediateindex) {
+		mod->immediate = (void *)sechdrs[immediateindex].sh_addr;
+		mod->num_immediate =
+			sechdrs[immediateindex].sh_size / sizeof(*mod->immediate);
+	}
+#endif
 
 	mod->unused_syms = (void *)sechdrs[unusedindex].sh_addr;
 	if (unusedcrcindex)
@@ -2031,6 +2045,8 @@ static struct module *load_module(void _
 	 }
 #endif
 
+	module_immediate_setup(mod);
+
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
 		goto cleanup;
Index: linux-2.6-lttng/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/kernel/Makefile	2007-08-07 13:28:12.000000000 -0400
+++ linux-2.6-lttng/kernel/Makefile	2007-08-07 13:29:55.000000000 -0400
@@ -57,6 +57,7 @@ obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
+obj-$(CONFIG_IMMEDIATE) += immediate.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
Index: linux-2.6-lttng/kernel/immediate.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/kernel/immediate.c	2007-08-07 13:30:27.000000000 -0400
@@ -0,0 +1,128 @@
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
+#include <linux/memory.h>
+
+extern const struct __immediate __start___immediate[];
+extern const struct __immediate __stop___immediate[];
+
+/*
+ * modules_mutex nests inside immediate_mutex. immediate_mutex protects builtin
+ * immediates and module immediates.
+ */
+static DEFINE_MUTEX(immediate_mutex);
+
+/*
+ * Sets a range of immediates to a enabled state : set the enable bit.
+ */
+static inline void _immediate_update_range(const struct __immediate *begin,
+		const struct __immediate *end)
+{
+	const struct __immediate *iter;
+	int ret;
+
+	for (iter = begin; iter < end; iter++) {
+		mutex_lock(&immediate_mutex);
+		kernel_text_lock();
+		ret = arch_immediate_update(iter);
+		kernel_text_unlock();
+		if (ret)
+			printk(KERN_WARNING "Invalid immediate value. "
+					    "Variable at %p, "
+					    "instruction at %p, size %lu\n",
+					    (void*)iter->immediate,
+					    (void*)iter->var, iter->size);
+		mutex_unlock(&immediate_mutex);
+	}
+}
+
+#ifdef CONFIG_MODULES
+/**
+ * module_immediate_setup - Update immediate values in a module
+ * @mod: pointer to the struct module
+ *
+ * Setup the immediate according to the variable upon which it depends.  Called
+ * by load_module with module_mutex held. This mutex protects against concurrent
+ * modifications to modules'immediates. Therefore, since
+ * module_immediate_setup() does not modify builtin immediates, it does not need
+ * to take the immediate_mutex.
+ */
+void module_immediate_setup(struct module *mod)
+{
+	_immediate_update_range(mod->immediate,
+				mod->immediate+mod->num_immediate);
+}
+
+/*
+ * immediate mutex nests inside the modules mutex.
+ */
+static inline void immediate_update_modules(int lock)
+{
+	struct module *mod;
+
+	if (lock)
+		mutex_lock(&module_mutex);
+	list_for_each_entry(mod, &modules, list) {
+		if (mod->taints)
+			continue;
+		_immediate_update_range(mod->immediate,
+			mod->immediate + mod->num_immediate);
+	}
+	if (lock)
+		mutex_unlock(&module_mutex);
+}
+#else
+static inline void immediate_update_modules(int lock) { }
+#endif
+
+/**
+ * immediate_update - update all immediate values in the kernel
+ * @lock: should a module_mutex be taken ?
+ *
+ * Iterate on the kernel core and modules to update the immediate values.
+ */
+void immediate_update(int lock)
+{
+	/* Core kernel immediates */
+	_immediate_update_range(__start___immediate, __stop___immediate);
+	/* immediates in modules. */
+	immediate_update_modules(lock);
+}
+EXPORT_SYMBOL_GPL(immediate_update);
+
+static void __init immediate_update_early_range(const struct __immediate *begin,
+		const struct __immediate *end)
+{
+	const struct __immediate *iter;
+
+	for (iter = begin; iter < end; iter++)
+		arch_immediate_update_early(iter);
+}
+
+/**
+ * immediate_update_early - Update immediate values at boot time
+ *
+ * Update the immediate values to the state of the variables they refer to. It
+ * is done before SMP is active, at the very beginning of start_kernel().
+ */
+void __init immediate_update_early(void)
+{
+	immediate_update_early_range(__start___immediate, __stop___immediate);
+}
Index: linux-2.6-lttng/init/main.c
===================================================================
--- linux-2.6-lttng.orig/init/main.c	2007-08-07 13:28:12.000000000 -0400
+++ linux-2.6-lttng/init/main.c	2007-08-07 13:29:55.000000000 -0400
@@ -56,6 +56,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/device.h>
 #include <linux/kthread.h>
+#include <linux/immediate.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -521,6 +522,7 @@ asmlinkage void __init start_kernel(void
 	unwind_init();
 	lockdep_init();
 	container_init_early();
+	immediate_update_early();
 
 	local_irq_disable();
 	early_boot_irqs_off();

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

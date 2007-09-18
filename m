Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbXIRVKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbXIRVKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758737AbXIRVJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:09:00 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54534 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164AbXIRVI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:08:58 -0400
Message-Id: <20070918210852.661973546@polymtl.ca>
References: <20070918210747.828804366@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 17:07:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 1/7] Immediate Values - Architecture Independent Code
Content-Disposition: inline; filename=immediate-values-architecture-independent-code.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 18 Sep 2007 21:08:53 +0000
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

Changelog:

- section __immediate is already SHF_ALLOC
- Because of the wonders of ELF, section 0 has sh_addr and sh_size 0.  So
  the if (immediateindex) is unnecessary here.
- Remove module_mutex usage: depend on functions implemented in module.c for
  that.
- Does not update tainted module's immediate values.
- remove immediate_*_t types, add DECLARE_IMMEDIATE() and DEFINE_IMMEDIATE().
  - immediate_read(&var) becomes immediate_read(var) because of this.
- Adding a new EXPORT_IMMEDIATE_SYMBOL(_GPL).
- remove immediate_if(). Should use if (unlikely(immediate_read(var))) instead.
  - Wait until we have gcc support before we add the immediate_if macro, since
    its form may have to change.
- Document immediate_set_early(). This design is chosen over immediate_init()
  because:
    - We can mark the function __init so it is freed after boot.
    - Module code patching can also be done by the "normal" function. This is
      preferred, even if it can be slightly slower, because update performance
      does not matter.
    - immediate_init() could confuse users because we can actually "initialize"
      an immediate value to a certain value, which will be used as initial
      value. e.g.:
        static DEFINE_IMMEDIATE(int, var) = 10;

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-generic/vmlinux.lds.h |    7 ++
 include/linux/immediate.h         |  133 ++++++++++++++++++++++++++++++++++++++
 include/linux/module.h            |   17 ++++
 init/main.c                       |    2 
 kernel/Makefile                   |    1 
 kernel/immediate.c                |   92 ++++++++++++++++++++++++++
 kernel/module.c                   |   49 ++++++++++++++
 7 files changed, 301 insertions(+)

Index: linux-2.6-lttng/include/linux/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/linux/immediate.h	2007-09-17 13:38:32.000000000 -0400
@@ -0,0 +1,133 @@
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
+
+#include <asm/immediate.h>
+
+/**
+ * immediate_set - set immediate variable (with locking)
+ * @name: immediate value name
+ * @i: required value
+ *
+ * Sets the value of @name, taking the module_mutex if required by
+ * the architecture.
+ */
+#define immediate_set(name, i)						\
+	do {								\
+		name##__immediate = (i);				\
+		core_immediate_update();				\
+		module_immediate_update();				\
+	} while (0)
+
+
+/**
+ * _immediate_set - set immediate variable (without locking)
+ * @name: immediate value name
+ * @i: required value
+ *
+ * Sets the value of @name. Must be called with module_mutex held.
+ */
+#define _immediate_set(name, i)						\
+	do {								\
+		name##__immediate = (i);				\
+		core_immediate_update();				\
+		_module_immediate_update();				\
+	} while (0)
+
+/**
+ * immediate_set_early - set immediate variable at early boot
+ * @name: immediate value name
+ * @i: required value
+ *
+ * Sets the value of @name. Should be used for updates at early boot, when only
+ * one CPU is active and interrupts are disabled.
+ */
+#define immediate_set_early(name, i)					\
+	do {								\
+		name##__immediate = (i);				\
+		immediate_update_early();				\
+	} while (0)
+
+/*
+ * Internal update functions.
+ */
+extern void core_immediate_update(void);
+extern void immediate_update_range(const struct __immediate *begin,
+	const struct __immediate *end);
+extern void immediate_update_early(void);
+
+#else
+
+/*
+ * Generic immediate values: a simple, standard, memory load.
+ */
+
+/**
+ * immediate_read - read immediate variable
+ * @name: immediate value name
+ *
+ * Reads the value of @name.
+ */
+#define immediate_read(name)		_immediate_read(name)
+
+/**
+ * immediate_set - set immediate variable (with locking)
+ * @name: immediate value name
+ * @i: required value
+ *
+ * Sets the value of @name, taking the module_mutex if required by
+ * the architecture.
+ */
+#define immediate_set(name, i)		(name##__immediate = (i))
+
+/**
+ * _immediate_set - set immediate variable (without locking)
+ * @name: immediate value name
+ * @i: required value
+ *
+ * Sets the value of @name. Must be called with module_mutex held.
+ */
+#define _immediate_set(name, i)		immediate_set(name, i)
+
+/**
+ * immediate_set_early - set immediate variable at early boot
+ * @name: immediate value name
+ * @i: required value
+ *
+ * Sets the value of @name. Should be used for early boot updates.
+ */
+#define immediate_set_early(name, i)	immediate_set(name, i)
+
+/*
+ * Internal update functions.
+ */
+static inline void immediate_update_early(void)
+{ }
+#endif
+
+#define DECLARE_IMMEDIATE(type, name) extern __typeof__(type) name##__immediate
+#define DEFINE_IMMEDIATE(type, name)  __typeof__(type) name##__immediate
+
+#define EXPORT_IMMEDIATE_SYMBOL(name) EXPORT_SYMBOL(name##__immediate)
+#define EXPORT_IMMEDIATE_SYMBOL_GPL(name) EXPORT_SYMBOL_GPL(name##__immediate)
+
+/**
+ * _immediate_read - Read immediate value with standard memory load.
+ * @name: immediate value name
+ *
+ * Force a data read of the immediate value instead of the immediate value
+ * based mechanism. Useful for __init and __exit section data read.
+ */
+#define _immediate_read(name)		(name##__immediate)
+
+#endif
Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-09-17 13:25:06.000000000 -0400
+++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-09-17 13:35:50.000000000 -0400
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
--- linux-2.6-lttng.orig/include/linux/module.h	2007-09-17 13:25:06.000000000 -0400
+++ linux-2.6-lttng/include/linux/module.h	2007-09-17 13:35:50.000000000 -0400
@@ -15,6 +15,7 @@
 #include <linux/stringify.h>
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
+#include <linux/immediate.h>
 #include <asm/local.h>
 
 #include <asm/module.h>
@@ -370,6 +371,11 @@ struct module
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
@@ -473,6 +479,9 @@ int unregister_module_notifier(struct no
 
 extern void print_modules(void);
 
+extern void _module_immediate_update(void);
+extern void module_immediate_update(void);
+
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
 #define EXPORT_SYMBOL_GPL(sym)
@@ -572,6 +581,14 @@ static inline void print_modules(void)
 {
 }
 
+static inline void _module_immediate_update(void)
+{
+}
+
+static inline void module_immediate_update(void)
+{
+}
+
 #endif /* CONFIG_MODULES */
 
 struct device_driver;
Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2007-09-17 13:25:06.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2007-09-17 13:35:51.000000000 -0400
@@ -33,6 +33,7 @@
 #include <linux/cpu.h>
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
+#include <linux/immediate.h>
 #include <linux/err.h>
 #include <linux/vermagic.h>
 #include <linux/notifier.h>
@@ -1717,6 +1718,7 @@ static struct module *load_module(void _
 	unsigned int unusedcrcindex;
 	unsigned int unusedgplindex;
 	unsigned int unusedgplcrcindex;
+	unsigned int immediateindex;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -1813,6 +1815,7 @@ static struct module *load_module(void _
 #ifdef ARCH_UNWIND_SECTION_NAME
 	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
 #endif
+	immediateindex = find_sec(hdr, sechdrs, secstrings, "__immediate");
 
 	/* Don't keep modinfo section */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -1963,6 +1966,11 @@ static struct module *load_module(void _
 	mod->gpl_future_syms = (void *)sechdrs[gplfutureindex].sh_addr;
 	if (gplfuturecrcindex)
 		mod->gpl_future_crcs = (void *)sechdrs[gplfuturecrcindex].sh_addr;
+#ifdef CONFIG_IMMEDIATE
+	mod->immediate = (void *)sechdrs[immediateindex].sh_addr;
+	mod->num_immediate =
+		sechdrs[immediateindex].sh_size / sizeof(*mod->immediate);
+#endif
 
 	mod->unused_syms = (void *)sechdrs[unusedindex].sh_addr;
 	if (unusedcrcindex)
@@ -2028,6 +2036,12 @@ static struct module *load_module(void _
 		 goto nomodsectinfo;
 #endif
 
+#ifdef CONFIG_IMMEDIATE
+	if (!mod->taints)
+		immediate_update_range(mod->immediate,
+			mod->immediate + mod->num_immediate);
+#endif
+
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
 		goto cleanup;
@@ -2629,3 +2643,38 @@ EXPORT_SYMBOL(module_remove_driver);
 void struct_module(struct module *mod) { return; }
 EXPORT_SYMBOL(struct_module);
 #endif
+
+#ifdef CONFIG_IMMEDIATE
+/**
+ * _module_immediate_update - update all immediate values in the kernel
+ *
+ * Iterate on the kernel core and modules to update the immediate values.
+ * Module_mutex must be held be the caller.
+ */
+void _module_immediate_update(void)
+{
+	struct module *mod;
+
+	list_for_each_entry(mod, &modules, list) {
+		if (mod->taints)
+			continue;
+		immediate_update_range(mod->immediate,
+			mod->immediate + mod->num_immediate);
+	}
+}
+EXPORT_SYMBOL_GPL(_module_immediate_update);
+
+/**
+ * module_immediate_update - update all immediate values in the kernel
+ *
+ * Iterate on the kernel core and modules to update the immediate values.
+ * Takes module_mutex.
+ */
+void module_immediate_update(void)
+{
+	mutex_lock(&module_mutex);
+	_module_immediate_update();
+	mutex_unlock(&module_mutex);
+}
+EXPORT_SYMBOL_GPL(module_immediate_update);
+#endif
Index: linux-2.6-lttng/kernel/immediate.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/kernel/immediate.c	2007-09-17 13:25:22.000000000 -0400
@@ -0,0 +1,92 @@
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
+ * immediate_mutex nests inside module_mutex. immediate_mutex protects builtin
+ * immediates and module immediates.
+ */
+static DEFINE_MUTEX(immediate_mutex);
+
+/**
+ * immediate_update_range - Update immediate values in a range
+ * @begin: pointer to the beginning of the range
+ * @end: pointer to the end of the range
+ *
+ * Sets a range of immediates to a enabled state : set the enable bit.
+ */
+void immediate_update_range(const struct __immediate *begin,
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
+EXPORT_SYMBOL_GPL(immediate_update_range);
+
+/**
+ * immediate_update - update all immediate values in the kernel
+ * @lock: should a module_mutex be taken ?
+ *
+ * Iterate on the kernel core and modules to update the immediate values.
+ */
+void core_immediate_update(void)
+{
+	/* Core kernel immediates */
+	immediate_update_range(__start___immediate, __stop___immediate);
+}
+EXPORT_SYMBOL_GPL(core_immediate_update);
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
--- linux-2.6-lttng.orig/init/main.c	2007-09-17 13:25:06.000000000 -0400
+++ linux-2.6-lttng/init/main.c	2007-09-17 13:25:22.000000000 -0400
@@ -56,6 +56,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/device.h>
 #include <linux/kthread.h>
+#include <linux/immediate.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -525,6 +526,7 @@ asmlinkage void __init start_kernel(void
 	unwind_init();
 	lockdep_init();
 	container_init_early();
+	immediate_update_early();
 
 	local_irq_disable();
 	early_boot_irqs_off();
Index: linux-2.6-lttng/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/kernel/Makefile	2007-09-17 13:25:06.000000000 -0400
+++ linux-2.6-lttng/kernel/Makefile	2007-09-17 13:35:50.000000000 -0400
@@ -61,6 +61,7 @@ obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_RESOURCE_COUNTERS) += res_counter.o
+obj-$(CONFIG_IMMEDIATE) += immediate.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

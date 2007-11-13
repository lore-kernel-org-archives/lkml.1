Return-Path: <linux-kernel-owner+w=401wt.eu-S1763367AbXKMTBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763367AbXKMTBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761931AbXKMTAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:00:53 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:38244 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761915AbXKMTAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:00:51 -0500
Message-Id: <20071113190039.477800977@polymtl.ca>
References: <20071113185800.436425570@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 13:58:01 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 1/8] Immediate Values - Architecture Independent Code
Content-Disposition: inline; filename=immediate-values-architecture-independent-code.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 19:00:40 +0000
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
- Dont't declare the __immediate section in vmlinux.lds.h, just put the content
  in the rodata section.
- Simplify interface : remove immediate_set_early, keep track of kernel boot
  status internally.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 include/asm-generic/vmlinux.lds.h |    4 +
 include/linux/immediate.h         |   83 ++++++++++++++++++++++++++++++++++++
 include/linux/module.h            |   16 +++++++
 init/main.c                       |    8 +++
 kernel/Makefile                   |    1 
 kernel/immediate.c                |   86 ++++++++++++++++++++++++++++++++++++++
 kernel/module.c                   |   50 +++++++++++++++++++++-
 7 files changed, 247 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/linux/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/linux/immediate.h	2007-11-13 09:46:32.000000000 -0500
@@ -0,0 +1,83 @@
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
+/*
+ * Internal update functions.
+ */
+extern void core_immediate_update(void);
+extern void immediate_update_range(const struct __immediate *begin,
+	const struct __immediate *end);
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
+static inline void core_immediate_update(void) { }
+static inline void module_immediate_update(void) { }
+
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
Index: linux-2.6-lttng/include/linux/module.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/module.h	2007-11-13 09:41:47.000000000 -0500
+++ linux-2.6-lttng/include/linux/module.h	2007-11-13 09:46:32.000000000 -0500
@@ -15,6 +15,7 @@
 #include <linux/stringify.h>
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
+#include <linux/immediate.h>
 #include <linux/marker.h>
 #include <asm/local.h>
 
@@ -355,6 +356,10 @@ struct module
 	/* The command line arguments (may be mangled).  People like
 	   keeping pointers to this stuff */
 	char *args;
+#ifdef CONFIG_IMMEDIATE
+	const struct __immediate *immediate;
+	unsigned int num_immediate;
+#endif
 #ifdef CONFIG_MARKERS
 	struct marker *markers;
 	unsigned int num_markers;
@@ -464,6 +469,9 @@ extern void print_modules(void);
 
 extern void module_update_markers(struct module *probe_module, int *refcount);
 
+extern void _module_immediate_update(void);
+extern void module_immediate_update(void);
+
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
 #define EXPORT_SYMBOL_GPL(sym)
@@ -568,6 +576,14 @@ static inline void module_update_markers
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
--- linux-2.6-lttng.orig/kernel/module.c	2007-11-13 09:41:47.000000000 -0500
+++ linux-2.6-lttng/kernel/module.c	2007-11-13 09:48:06.000000000 -0500
@@ -33,6 +33,7 @@
 #include <linux/cpu.h>
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
+#include <linux/immediate.h>
 #include <linux/err.h>
 #include <linux/vermagic.h>
 #include <linux/notifier.h>
@@ -1673,6 +1674,7 @@ static struct module *load_module(void _
 	unsigned int unusedcrcindex;
 	unsigned int unusedgplindex;
 	unsigned int unusedgplcrcindex;
+	unsigned int immediateindex;
 	unsigned int markersindex;
 	unsigned int markersstringsindex;
 	struct module *mod;
@@ -1771,6 +1773,7 @@ static struct module *load_module(void _
 #ifdef ARCH_UNWIND_SECTION_NAME
 	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
 #endif
+	immediateindex = find_sec(hdr, sechdrs, secstrings, "__immediate");
 
 	/* Don't keep modinfo section */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -1922,6 +1925,11 @@ static struct module *load_module(void _
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
@@ -1989,11 +1997,16 @@ static struct module *load_module(void _
 
 	add_kallsyms(mod, sechdrs, symindex, strindex, secstrings);
 
+	if (!mod->taints) {
 #ifdef CONFIG_MARKERS
-	if (!mod->taints)
 		marker_update_probe_range(mod->markers,
 			mod->markers + mod->num_markers, NULL, NULL);
 #endif
+#ifdef CONFIG_IMMEDIATE
+		immediate_update_range(mod->immediate,
+			mod->immediate + mod->num_immediate);
+#endif
+	}
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
 		goto cleanup;
@@ -2600,3 +2613,38 @@ void module_update_markers(struct module
 	mutex_unlock(&module_mutex);
 }
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
+++ linux-2.6-lttng/kernel/immediate.c	2007-11-13 09:46:32.000000000 -0500
@@ -0,0 +1,86 @@
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
+/*
+ * Kernel ready to execute the SMP update that may depend on trap and ipi.
+ */
+static int immediate_early_boot_complete;
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
+	if (immediate_early_boot_complete) {
+		for (iter = begin; iter < end; iter++) {
+			mutex_lock(&immediate_mutex);
+			kernel_text_lock();
+			ret = arch_immediate_update(iter);
+			kernel_text_unlock();
+			if (ret)
+				printk(KERN_WARNING
+					"Invalid immediate value. "
+					"Variable at %p, "
+					"instruction at %p, size %lu\n",
+					(void *)iter->immediate,
+					(void *)iter->var, iter->size);
+			mutex_unlock(&immediate_mutex);
+		}
+	} else
+		for (iter = begin; iter < end; iter++)
+			arch_immediate_update_early(iter);
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
+void __init immediate_init_complete(void)
+{
+	immediate_early_boot_complete = 1;
+}
Index: linux-2.6-lttng/init/main.c
===================================================================
--- linux-2.6-lttng.orig/init/main.c	2007-11-13 09:25:29.000000000 -0500
+++ linux-2.6-lttng/init/main.c	2007-11-13 09:46:32.000000000 -0500
@@ -57,6 +57,7 @@
 #include <linux/device.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
+#include <linux/immediate.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -101,6 +102,11 @@ static inline void mark_rodata_ro(void) 
 #ifdef CONFIG_TC
 extern void tc_init(void);
 #endif
+#ifdef CONFIG_IMMEDIATE
+extern void immediate_init_complete(void);
+#else
+static inline void immediate_init_complete(void) { }
+#endif
 
 enum system_states system_state;
 EXPORT_SYMBOL(system_state);
@@ -518,6 +524,7 @@ asmlinkage void __init start_kernel(void
 	unwind_init();
 	lockdep_init();
 	cgroup_init_early();
+	core_immediate_update();
 
 	local_irq_disable();
 	early_boot_irqs_off();
@@ -639,6 +646,7 @@ asmlinkage void __init start_kernel(void
 	cpuset_init();
 	taskstats_init_early();
 	delayacct_init();
+	immediate_init_complete();
 
 	check_bugs();
 
Index: linux-2.6-lttng/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/kernel/Makefile	2007-11-13 09:25:29.000000000 -0500
+++ linux-2.6-lttng/kernel/Makefile	2007-11-13 09:46:32.000000000 -0500
@@ -57,6 +57,7 @@ obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
+obj-$(CONFIG_IMMEDIATE) += immediate.o
 obj-$(CONFIG_MARKERS) += marker.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-11-13 09:25:28.000000000 -0500
+++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-11-13 09:46:32.000000000 -0500
@@ -25,6 +25,10 @@
 		*(.rodata) *(.rodata.*)					\
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
+		. = ALIGN(8);						\
+		VMLINUX_SYMBOL(__start___immediate) = .;		\
+		*(__immediate)		/* Immediate values: pointers */ \
+		VMLINUX_SYMBOL(__stop___immediate) = .;			\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbZIXOoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbZIXOoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbZIXOn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:43:59 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48513 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbZIXOn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:43:56 -0400
Message-Id: <20090924133359.218934235@polymtl.ca>
References: <20090924132626.485545323@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Sep 2009 09:26:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jason Baron <jbaron@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>,
       Christoph Hellwig <hch@infradead.org>, akpm@osdl.org
Subject: [patch 02/12] Immediate Values - Architecture Independent Code
Content-Disposition: inline; filename=immediate-values-architecture-independent-code.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 24 Sep 2009 14:07:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Immediate values are used as read mostly variables that are rarely updated. They
use code patching to modify the values inscribed in the instruction stream. It
provides a way to save precious cache lines that would otherwise have to be used
by these variables.

There is a generic _imv_read() version, which uses standard global
variables, and optimized per architecture imv_read() implementations,
which use a load immediate to remove a data cache hit. When the immediate values
functionnality is disabled in the kernel, it falls back to global variables.

It adds a new rodata section "__imv" to place the pointers to the enable
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

- section __imv is already SHF_ALLOC
- Because of the wonders of ELF, section 0 has sh_addr and sh_size 0.  So
  the if (immediateindex) is unnecessary here.
- Remove module_mutex usage: depend on functions implemented in module.c for
  that.
- Does not update tainted module's immediate values.
- remove imv_*_t types, add DECLARE_IMV() and DEFINE_IMV().
  - imv_read(&var) becomes imv_read(var) because of this.
- Adding a new EXPORT_IMV_SYMBOL(_GPL).
- remove imv_if(). Should use if (unlikely(imv_read(var))) instead.
  - Wait until we have gcc support before we add the imv_if macro, since
    its form may have to change.
- Dont't declare the __imv section in vmlinux.lds.h, just put the content
  in the rodata section.
- Simplify interface : remove imv_set_early, keep track of kernel boot
  status internally.
- Remove the ALIGN(8) before the __imv section. It is packed now.
- Uses an IPI busy-loop on each CPU with interrupts disabled as a simple,
  architecture agnostic, update mechanism.
- Use imv_* instead of immediate_*.
- Updating immediate values, cannot rely on smp_call_function() b/c
  synchronizing cpus using IPIs leads to deadlocks. Process A held a read lock
  on tasklist_lock, then process B called apply_imv_update(). Process A received
  the IPI and begins executing ipi_busy_loop(). Then process C takes a write
  lock irq on the task list lock, before receiving the IPI. Thus, process A
  holds up process C, and C can't get an IPI b/c interrupts are disabled. Solve
  this problem by using a new 'ALL_CPUS' parameter to stop_machine_run(). Which
  runs a function on all cpus after they are busy looping and have disabled
  irqs. Since this is done in a new process context, we don't have to worry
  about interrupted spin_locks. Also, less lines of code. Has survived 24 hours+
  of testing...
- Folded "fix use immediate" patch.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Jason Baron <jbaron@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Adrian Bunk <bunk@stusta.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: Christoph Hellwig <hch@infradead.org>
CC: mingo@elte.hu
CC: akpm@osdl.org
---
 include/asm-generic/vmlinux.lds.h |    3 
 include/linux/immediate.h         |   94 +++++++++++++++++++
 include/linux/module.h            |   16 +++
 init/main.c                       |    7 +
 kernel/Makefile                   |    1 
 kernel/immediate.c                |  183 ++++++++++++++++++++++++++++++++++++++
 kernel/module.c                   |   41 ++++++++
 7 files changed, 345 insertions(+)

Index: linux.trees.git/include/linux/module.h
===================================================================
--- linux.trees.git.orig/include/linux/module.h	2009-09-24 08:52:55.000000000 -0400
+++ linux.trees.git/include/linux/module.h	2009-09-24 08:59:42.000000000 -0400
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
 #include <linux/tracepoint.h>
+#include <linux/immediate.h>
 
 #include <asm/local.h>
 #include <asm/module.h>
@@ -330,6 +331,10 @@ struct module
 	struct tracepoint *tracepoints;
 	unsigned int num_tracepoints;
 #endif
+#ifdef CONFIG_IMMEDIATE
+	const struct __imv *immediate;
+	unsigned int num_immediate;
+#endif
 
 #ifdef CONFIG_TRACING
 	const char **trace_bprintk_fmt_start;
@@ -533,6 +538,9 @@ extern void print_modules(void);
 extern void module_update_tracepoints(void);
 extern int module_get_iter_tracepoints(struct tracepoint_iter *iter);
 
+extern void _module_imv_update(void);
+extern void module_imv_update(void);
+
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
 #define EXPORT_SYMBOL_GPL(sym)
@@ -653,6 +661,14 @@ static inline int module_get_iter_tracep
 	return 0;
 }
 
+static inline void _module_imv_update(void)
+{
+}
+
+static inline void module_imv_update(void)
+{
+}
+
 #endif /* CONFIG_MODULES */
 
 struct device_driver;
Index: linux.trees.git/kernel/module.c
===================================================================
--- linux.trees.git.orig/kernel/module.c	2009-09-24 08:52:55.000000000 -0400
+++ linux.trees.git/kernel/module.c	2009-09-24 08:58:28.000000000 -0400
@@ -36,6 +36,7 @@
 #include <linux/cpu.h>
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
+#include <linux/immediate.h>
 #include <linux/err.h>
 #include <linux/vermagic.h>
 #include <linux/notifier.h>
@@ -2236,6 +2237,11 @@ static noinline struct module *load_modu
 	mod->ctors = section_objs(hdr, sechdrs, secstrings, ".ctors",
 				  sizeof(*mod->ctors), &mod->num_ctors);
 #endif
+#ifdef CONFIG_IMMEDIATE
+	mod->immediate = section_objs(hdr, sechdrs, secstrings, "__imv",
+					sizeof(*mod->immediate),
+					&mod->num_immediate);
+#endif
 
 #ifdef CONFIG_TRACEPOINTS
 	mod->tracepoints = section_objs(hdr, sechdrs, secstrings,
@@ -3000,3 +3006,38 @@ int module_get_iter_tracepoints(struct t
 	return found;
 }
 #endif
+
+#ifdef CONFIG_IMMEDIATE
+/**
+ * _module_imv_update - update all immediate values in the kernel
+ *
+ * Iterate on the kernel core and modules to update the immediate values.
+ * Module_mutex must be held be the caller.
+ */
+void _module_imv_update(void)
+{
+	struct module *mod;
+
+	list_for_each_entry(mod, &modules, list) {
+		if (mod->taints)
+			continue;
+		imv_update_range(mod->immediate,
+			mod->immediate + mod->num_immediate);
+	}
+}
+EXPORT_SYMBOL_GPL(_module_imv_update);
+
+/**
+ * module_imv_update - update all immediate values in the kernel
+ *
+ * Iterate on the kernel core and modules to update the immediate values.
+ * Takes module_mutex.
+ */
+void module_imv_update(void)
+{
+	mutex_lock(&module_mutex);
+	_module_imv_update();
+	mutex_unlock(&module_mutex);
+}
+EXPORT_SYMBOL_GPL(module_imv_update);
+#endif
Index: linux.trees.git/kernel/immediate.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/kernel/immediate.c	2009-09-24 08:58:28.000000000 -0400
@@ -0,0 +1,183 @@
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
+#include <linux/cpu.h>
+#include <linux/stop_machine.h>
+
+#include <asm/cacheflush.h>
+#include <asm/atomic.h>
+
+/*
+ * Kernel ready to execute the SMP update that may depend on trap and ipi.
+ */
+static int imv_early_boot_complete;
+static atomic_t stop_machine_first;
+static int wrote_text;
+
+extern const struct __imv __start___imv[];
+extern const struct __imv __stop___imv[];
+
+static int stop_machine_imv_update(void *imv_ptr)
+{
+	struct __imv *imv = imv_ptr;
+
+	if (atomic_dec_and_test(&stop_machine_first)) {
+		text_poke((void *)imv->imv, (void *)imv->var, imv->size);
+		smp_wmb(); /* make sure other cpus see that this has run */
+		wrote_text = 1;
+	} else {
+		while (!wrote_text)
+			smp_rmb();
+		sync_core();
+	}
+
+	flush_icache_range(imv->imv, imv->imv + imv->size);
+
+	return 0;
+}
+
+/*
+ * imv_mutex nests inside module_mutex. imv_mutex protects builtin
+ * immediates and module immediates.
+ */
+static DEFINE_MUTEX(imv_mutex);
+
+/**
+ * apply_imv_update - update one immediate value
+ * @imv: pointer of type const struct __imv to update
+ *
+ * Update one immediate value. Must be called with imv_mutex held.
+ * It makes sure all CPUs are not executing the modified code by having them
+ * busy looping with interrupts disabled.
+ * It does _not_ protect against NMI and MCE (could be a problem with Intel's
+ * errata if we use immediate values in their code path).
+ */
+static int apply_imv_update(const struct __imv *imv)
+{
+	/*
+	 * If the variable and the instruction have the same value, there is
+	 * nothing to do.
+	 */
+	switch (imv->size) {
+	case 1:
+		if (*(uint8_t *)imv->imv == *(uint8_t *)imv->var)
+			return 0;
+		break;
+	case 2:
+		if (*(uint16_t *)imv->imv == *(uint16_t *)imv->var)
+			return 0;
+		break;
+	case 4:
+		if (*(uint32_t *)imv->imv == *(uint32_t *)imv->var)
+			return 0;
+		break;
+	case 8:
+		if (*(uint64_t *)imv->imv == *(uint64_t *)imv->var)
+			return 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (imv_early_boot_complete) {
+		mutex_lock(&text_mutex);
+		atomic_set(&stop_machine_first, 1);
+		wrote_text = 0;
+		stop_machine(stop_machine_imv_update, (void *)imv, NULL);
+		mutex_unlock(&text_mutex);
+	} else
+		text_poke_early((void *)imv->imv, (void *)imv->var,
+				imv->size);
+	return 0;
+}
+
+/**
+ * imv_update_range - Update immediate values in a range
+ * @begin: pointer to the beginning of the range
+ * @end: pointer to the end of the range
+ *
+ * Updates a range of immediates.
+ */
+void imv_update_range(const struct __imv *begin,
+		const struct __imv *end)
+{
+	const struct __imv *iter;
+	int ret;
+
+	mutex_lock(&imv_mutex);
+	for (iter = begin; iter < end; iter++) {
+		ret = apply_imv_update(iter);
+		if (imv_early_boot_complete && ret)
+			printk(KERN_WARNING
+				"Invalid immediate value. "
+				"Variable at %p, "
+				"instruction at %p, size %hu\n",
+				(void *)iter->imv,
+				(void *)iter->var, iter->size);
+	}
+	mutex_unlock(&imv_mutex);
+}
+EXPORT_SYMBOL_GPL(imv_update_range);
+
+/**
+ * imv_update - update all immediate values in the kernel
+ *
+ * Iterate on the kernel core and modules to update the immediate values.
+ */
+void core_imv_update(void)
+{
+	/* Core kernel imvs */
+	imv_update_range(__start___imv, __stop___imv);
+}
+EXPORT_SYMBOL_GPL(core_imv_update);
+
+void __init imv_init_complete(void)
+{
+	imv_early_boot_complete = 1;
+}
+
+int imv_module_notify(struct notifier_block *self,
+		      unsigned long val, void *data)
+{
+	struct module *mod = data;
+
+	switch (val) {
+	case MODULE_STATE_COMING:
+		imv_update_range(mod->immediate,
+				 mod->immediate + mod->num_immediate);
+		break;
+	case MODULE_STATE_GOING:
+		/* All references will be gone, no update required. */
+		break;
+	}
+	return 0;
+}
+
+struct notifier_block imv_module_nb = {
+	.notifier_call = imv_module_notify,
+	.priority = 0,
+};
+
+static int init_imv(void)
+{
+	return register_module_notifier(&imv_module_nb);
+}
+__initcall(init_imv);
Index: linux.trees.git/init/main.c
===================================================================
--- linux.trees.git.orig/init/main.c	2009-09-24 08:52:55.000000000 -0400
+++ linux.trees.git/init/main.c	2009-09-24 08:58:28.000000000 -0400
@@ -97,6 +97,11 @@ static inline void mark_rodata_ro(void) 
 #ifdef CONFIG_TC
 extern void tc_init(void);
 #endif
+#ifdef USE_IMMEDIATE
+extern void imv_init_complete(void);
+#else
+static inline void imv_init_complete(void) { }
+#endif
 
 enum system_states system_state __read_mostly;
 EXPORT_SYMBOL(system_state);
@@ -544,6 +549,7 @@ asmlinkage void __init start_kernel(void
 	boot_init_stack_canary();
 
 	cgroup_init_early();
+	core_imv_update();
 
 	local_irq_disable();
 	early_boot_irqs_off();
@@ -685,6 +691,7 @@ asmlinkage void __init start_kernel(void
 	cpuset_init();
 	taskstats_init_early();
 	delayacct_init();
+	imv_init_complete();
 
 	check_bugs();
 
Index: linux.trees.git/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux.trees.git.orig/include/asm-generic/vmlinux.lds.h	2009-09-24 08:52:54.000000000 -0400
+++ linux.trees.git/include/asm-generic/vmlinux.lds.h	2009-09-24 08:58:28.000000000 -0400
@@ -202,6 +202,9 @@
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
+		VMLINUX_SYMBOL(__start___imv) = .;			\
+		*(__imv)		/* Immediate values: pointers */ \
+		VMLINUX_SYMBOL(__stop___imv) = .;			\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
Index: linux.trees.git/include/linux/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/immediate.h	2009-09-24 08:58:28.000000000 -0400
@@ -0,0 +1,94 @@
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
+struct __imv {
+	unsigned long var;	/* Pointer to the identifier variable of the
+				 * immediate value
+				 */
+	unsigned long imv;	/*
+				 * Pointer to the memory location of the
+				 * immediate value within the instruction.
+				 */
+	unsigned char size;	/* Type size. */
+} __attribute__ ((packed));
+
+#include <asm/immediate.h>
+
+/**
+ * imv_set - set immediate variable (with locking)
+ * @name: immediate value name
+ * @i: required value
+ *
+ * Sets the value of @name, taking the module_mutex if required by
+ * the architecture.
+ */
+#define imv_set(name, i)						\
+	do {								\
+		name##__imv = (i);					\
+		core_imv_update();					\
+		module_imv_update();					\
+	} while (0)
+
+/*
+ * Internal update functions.
+ */
+extern void core_imv_update(void);
+extern void imv_update_range(const struct __imv *begin,
+	const struct __imv *end);
+
+#else
+
+/*
+ * Generic immediate values: a simple, standard, memory load.
+ */
+
+/**
+ * imv_read - read immediate variable
+ * @name: immediate value name
+ *
+ * Reads the value of @name.
+ */
+#define imv_read(name)			_imv_read(name)
+
+/**
+ * imv_set - set immediate variable (with locking)
+ * @name: immediate value name
+ * @i: required value
+ *
+ * Sets the value of @name, taking the module_mutex if required by
+ * the architecture.
+ */
+#define imv_set(name, i)		(name##__imv = (i))
+
+static inline void core_imv_update(void) { }
+static inline void module_imv_update(void) { }
+
+#endif
+
+#define DECLARE_IMV(type, name) extern __typeof__(type) name##__imv
+#define DEFINE_IMV(type, name)  __typeof__(type) name##__imv
+
+#define EXPORT_IMV_SYMBOL(name) EXPORT_SYMBOL(name##__imv)
+#define EXPORT_IMV_SYMBOL_GPL(name) EXPORT_SYMBOL_GPL(name##__imv)
+
+/**
+ * _imv_read - Read immediate value with standard memory load.
+ * @name: immediate value name
+ *
+ * Force a data read of the immediate value instead of the immediate value
+ * based mechanism. Useful for __init and __exit section data read.
+ */
+#define _imv_read(name)		(name##__imv)
+
+#endif
Index: linux.trees.git/kernel/Makefile
===================================================================
--- linux.trees.git.orig/kernel/Makefile	2009-09-24 08:52:55.000000000 -0400
+++ linux.trees.git/kernel/Makefile	2009-09-24 09:00:15.000000000 -0400
@@ -88,6 +88,7 @@ obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
+obj-$(CONFIG_IMMEDIATE) += immediate.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

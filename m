Return-Path: <linux-kernel-owner+w=401wt.eu-S1758498AbXLUCHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498AbXLUCHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 21:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbXLUB7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 20:59:21 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:53375 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761264AbXLUB7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 20:59:12 -0500
Message-Id: <20071221015726.253261266@polymtl.ca>
References: <20071221015438.433195466@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 20:54:50 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 12/24] Immediate Values - Architecture Independent Code
Content-Disposition: inline; filename=immediate-values-architecture-independent-code.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 21 Dec 2007 01:57:31 +0000
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

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 include/asm-generic/vmlinux.lds.h |    3 
 include/linux/immediate.h         |   94 +++++++++++++++++++
 include/linux/module.h            |   16 +++
 init/main.c                       |    8 +
 kernel/Makefile                   |    1 
 kernel/immediate.c                |  187 ++++++++++++++++++++++++++++++++++++++
 kernel/module.c                   |   50 +++++++++-
 7 files changed, 358 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/linux/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/linux/immediate.h	2007-11-28 09:32:04.000000000 -0500
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
Index: linux-2.6-lttng/include/linux/module.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/module.h	2007-11-28 09:31:51.000000000 -0500
+++ linux-2.6-lttng/include/linux/module.h	2007-11-28 09:32:04.000000000 -0500
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
+	const struct __imv *immediate;
+	unsigned int num_immediate;
+#endif
 #ifdef CONFIG_MARKERS
 	struct marker *markers;
 	unsigned int num_markers;
@@ -464,6 +469,9 @@ extern void print_modules(void);
 
 extern void module_update_markers(void);
 
+extern void _module_imv_update(void);
+extern void module_imv_update(void);
+
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
 #define EXPORT_SYMBOL_GPL(sym)
@@ -568,6 +576,14 @@ static inline void module_update_markers
 {
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
Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2007-11-28 09:31:51.000000000 -0500
+++ linux-2.6-lttng/kernel/module.c	2007-11-28 09:32:04.000000000 -0500
@@ -33,6 +33,7 @@
 #include <linux/cpu.h>
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
+#include <linux/immediate.h>
 #include <linux/err.h>
 #include <linux/vermagic.h>
 #include <linux/notifier.h>
@@ -1675,6 +1676,7 @@ static struct module *load_module(void _
 	unsigned int unusedcrcindex;
 	unsigned int unusedgplindex;
 	unsigned int unusedgplcrcindex;
+	unsigned int immediateindex;
 	unsigned int markersindex;
 	unsigned int markersstringsindex;
 	struct module *mod;
@@ -1773,6 +1775,7 @@ static struct module *load_module(void _
 #ifdef ARCH_UNWIND_SECTION_NAME
 	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
 #endif
+	immediateindex = find_sec(hdr, sechdrs, secstrings, "__imv");
 
 	/* Don't keep modinfo section */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -1924,6 +1927,11 @@ static struct module *load_module(void _
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
@@ -1991,11 +1999,16 @@ static struct module *load_module(void _
 
 	add_kallsyms(mod, sechdrs, symindex, strindex, secstrings);
 
+	if (!mod->taints) {
 #ifdef CONFIG_MARKERS
-	if (!mod->taints)
 		marker_update_probe_range(mod->markers,
 			mod->markers + mod->num_markers);
 #endif
+#ifdef CONFIG_IMMEDIATE
+		imv_update_range(mod->immediate,
+			mod->immediate + mod->num_immediate);
+#endif
+	}
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
 		goto cleanup;
@@ -2601,3 +2614,38 @@ void module_update_markers(void)
 	mutex_unlock(&module_mutex);
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
Index: linux-2.6-lttng/kernel/immediate.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/kernel/immediate.c	2007-11-28 09:32:04.000000000 -0500
@@ -0,0 +1,187 @@
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
+
+#include <asm/cacheflush.h>
+
+/*
+ * Kernel ready to execute the SMP update that may depend on trap and ipi.
+ */
+static int imv_early_boot_complete;
+
+extern const struct __imv __start___imv[];
+extern const struct __imv __stop___imv[];
+
+/*
+ * imv_mutex nests inside module_mutex. imv_mutex protects builtin
+ * immediates and module immediates.
+ */
+static DEFINE_MUTEX(imv_mutex);
+
+static atomic_t wait_sync;
+
+struct ipi_loop_data {
+	long value;
+	const struct __imv *imv;
+} loop_data;
+
+static void ipi_busy_loop(void *arg)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	atomic_dec(&wait_sync);
+	do {
+		/* Make sure the wait_sync gets re-read */
+		smp_mb();
+	} while (atomic_read(&wait_sync) > loop_data.value);
+	atomic_dec(&wait_sync);
+	do {
+		/* Make sure the wait_sync gets re-read */
+		smp_mb();
+	} while (atomic_read(&wait_sync) > 0);
+	/*
+	 * Issuing a synchronizing instruction must be done on each CPU before
+	 * reenabling interrupts after modifying an instruction. Required by
+	 * Intel's errata.
+	 */
+	sync_core();
+	flush_icache_range(loop_data.imv->imv,
+		loop_data.imv->imv + loop_data.imv->size);
+	local_irq_restore(flags);
+}
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
+	unsigned long flags;
+	long online_cpus;
+
+	/*
+	 * If the variable and the instruction have the same value, there is
+	 * nothing to do.
+	 */
+	switch (imv->size) {
+	case 1:	if (*(uint8_t *)imv->imv
+				== *(uint8_t *)imv->var)
+			return 0;
+		break;
+	case 2:	if (*(uint16_t *)imv->imv
+				== *(uint16_t *)imv->var)
+			return 0;
+		break;
+	case 4:	if (*(uint32_t *)imv->imv
+				== *(uint32_t *)imv->var)
+			return 0;
+		break;
+	case 8:	if (*(uint64_t *)imv->imv
+				== *(uint64_t *)imv->var)
+			return 0;
+		break;
+	default:return -EINVAL;
+	}
+
+	if (imv_early_boot_complete) {
+		kernel_text_lock();
+		lock_cpu_hotplug();
+		online_cpus = num_online_cpus();
+		atomic_set(&wait_sync, 2 * online_cpus);
+		loop_data.value = online_cpus;
+		loop_data.imv = imv;
+		smp_call_function(ipi_busy_loop, NULL, 1, 0);
+		local_irq_save(flags);
+		atomic_dec(&wait_sync);
+		do {
+			/* Make sure the wait_sync gets re-read */
+			smp_mb();
+		} while (atomic_read(&wait_sync) > online_cpus);
+		text_poke((void *)imv->imv, (void *)imv->var,
+				imv->size);
+		/*
+		 * Make sure the modified instruction is seen by all CPUs before
+		 * we continue (visible to other CPUs and local interrupts).
+		 */
+		wmb();
+		atomic_dec(&wait_sync);
+		flush_icache_range(imv->imv,
+				imv->imv + imv->size);
+		local_irq_restore(flags);
+		unlock_cpu_hotplug();
+		kernel_text_unlock();
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
+	for (iter = begin; iter < end; iter++) {
+		mutex_lock(&imv_mutex);
+		ret = apply_imv_update(iter);
+		if (imv_early_boot_complete && ret)
+			printk(KERN_WARNING
+				"Invalid immediate value. "
+				"Variable at %p, "
+				"instruction at %p, size %hu\n",
+				(void *)iter->imv,
+				(void *)iter->var, iter->size);
+		mutex_unlock(&imv_mutex);
+	}
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
Index: linux-2.6-lttng/init/main.c
===================================================================
--- linux-2.6-lttng.orig/init/main.c	2007-11-28 09:27:34.000000000 -0500
+++ linux-2.6-lttng/init/main.c	2007-11-28 09:32:04.000000000 -0500
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
+extern void imv_init_complete(void);
+#else
+static inline void imv_init_complete(void) { }
+#endif
 
 enum system_states system_state;
 EXPORT_SYMBOL(system_state);
@@ -518,6 +524,7 @@ asmlinkage void __init start_kernel(void
 	unwind_init();
 	lockdep_init();
 	cgroup_init_early();
+	core_imv_update();
 
 	local_irq_disable();
 	early_boot_irqs_off();
@@ -639,6 +646,7 @@ asmlinkage void __init start_kernel(void
 	cpuset_init();
 	taskstats_init_early();
 	delayacct_init();
+	imv_init_complete();
 
 	check_bugs();
 
Index: linux-2.6-lttng/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/kernel/Makefile	2007-11-28 09:27:34.000000000 -0500
+++ linux-2.6-lttng/kernel/Makefile	2007-11-28 09:32:04.000000000 -0500
@@ -56,6 +56,7 @@ obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
+obj-$(CONFIG_IMMEDIATE) += immediate.o
 obj-$(CONFIG_MARKERS) += marker.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-11-28 09:27:34.000000000 -0500
+++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-11-28 09:32:04.000000000 -0500
@@ -25,6 +25,9 @@
 		*(.rodata) *(.rodata.*)					\
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
+		VMLINUX_SYMBOL(__start___imv) = .;			\
+		*(__imv)		/* Immediate values: pointers */ \
+		VMLINUX_SYMBOL(__stop___imv) = .;			\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

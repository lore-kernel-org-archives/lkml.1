Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbXEJCxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbXEJCxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 22:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbXEJCw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 22:52:57 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:35962 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680AbXEJCwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 22:52:55 -0400
Message-Id: <20070510020916.508519573@polymtl.ca>
References: <20070510015555.973107048@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 May 2007 21:56:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <ak@muc.de>
Subject: [patch 05/10] Linux Kernel Markers - i386 optimized version
Content-Disposition: inline; filename=linux-kernel-markers-i386-optimization.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 10 May 2007 02:52:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[bunk@stusta.de: marker exports must be EXPORT_SYMBOL_GPL]
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/Makefile |    1 
 arch/i386/kernel/marker.c |   99 ++++++++++++++++++++++++++++++++++++++++++++++
 include/asm-i386/marker.h |   84 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 184 insertions(+)

Index: linux-2.6-lttng/arch/i386/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/i386/kernel/Makefile	2007-05-09 18:14:51.000000000 -0400
+++ linux-2.6-lttng/arch/i386/kernel/Makefile	2007-05-09 18:16:03.000000000 -0400
@@ -33,6 +33,7 @@
 obj-y				+= sysenter.o vsyscall.o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_stub.o
+obj-$(CONFIG_MARKERS_ENABLE_OPTIMIZATION)	+= marker.o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault.o
 obj-$(CONFIG_SERIAL_8250)	+= legacy_serial.o
 obj-$(CONFIG_VM86)		+= vm86.o
Index: linux-2.6-lttng/arch/i386/kernel/marker.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/arch/i386/kernel/marker.c	2007-05-09 18:16:03.000000000 -0400
@@ -0,0 +1,99 @@
+/* marker.c
+ *
+ * Erratum 49 fix for Intel PIII and higher.
+ *
+ * Permits marker activation by XMC with correct serialization.
+ *
+ * Reentrant for NMI and trap handler instrumentation. Permits XMC to a
+ * location that has preemption enabled because it involves no temporary or
+ * reused data structure.
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+
+#include <linux/notifier.h>
+#include <linux/mutex.h>
+#include <linux/preempt.h>
+#include <linux/smp.h>
+#include <linux/notifier.h>
+#include <linux/module.h>
+#include <linux/marker.h>
+#include <linux/kdebug.h>
+
+#include <asm/cacheflush.h>
+
+#define BREAKPOINT_INSTRUCTION  0xcc
+#define BREAKPOINT_INS_LEN 1
+
+static DEFINE_MUTEX(mark_mutex);
+static long target_eip = 0;
+
+static void mark_synchronize_core(void *info)
+{
+	sync_core();	/* use cpuid to stop speculative execution */
+}
+
+/* We simply skip the 2 bytes load immediate here, leaving the register in an
+ * undefined state. We don't care about the content (0 or !0), because we are
+ * changing the value 0->1 or 1->0. This small window of undefined value
+ * doesn't matter.
+ */
+static int mark_notifier(struct notifier_block *nb,
+	unsigned long val, void *data)
+{
+	enum die_val die_val = (enum die_val) val;
+	struct die_args *args = (struct die_args *)data;
+
+	if (!args->regs || user_mode_vm(args->regs))
+		return NOTIFY_DONE;
+
+	if (die_val == DIE_INT3	&& args->regs->eip == target_eip) {
+		args->regs->eip += 1; /* Skip the next byte of load immediate */
+		return NOTIFY_STOP;
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block mark_notify = {
+	.notifier_call = mark_notifier,
+	.priority = 0x7fffffff,	/* we need to be notified first */
+};
+
+int marker_optimized_set_enable(void *address, char enable)
+{
+	char saved_byte;
+	int ret;
+	char *dest = address;
+
+	if (!(enable ^ dest[1])) /* Must be a state change 0<->1 to execute */
+		return 0;
+
+	mutex_lock(&mark_mutex);
+	target_eip = (long)address + BREAKPOINT_INS_LEN;
+	/* register_die_notifier has memory barriers */
+	register_die_notifier(&mark_notify);
+	saved_byte = *dest;
+	*dest = BREAKPOINT_INSTRUCTION;
+	wmb();
+	/* Execute serializing instruction on each CPU.
+	 * Acts as a memory barrier. */
+	ret = on_each_cpu(mark_synchronize_core, NULL, 1, 1);
+	BUG_ON(ret != 0);
+
+	dest[1] = enable;
+	wmb();
+	*dest = saved_byte;
+		/* Wait for all int3 handlers to end
+		   (interrupts are disabled in int3).
+		   This CPU is clearly not in a int3 handler
+		   (not preemptible).
+		   synchronize_sched has memory barriers */
+	synchronize_sched();
+	unregister_die_notifier(&mark_notify);
+	/* unregister_die_notifier has memory barriers */
+	target_eip = 0;
+	mutex_unlock(&mark_mutex);
+	flush_icache_range(address, size);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(marker_optimized_set_enable);
Index: linux-2.6-lttng/include/asm-i386/marker.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-i386/marker.h	2007-05-09 18:16:03.000000000 -0400
@@ -0,0 +1,84 @@
+#ifndef _ASM_I386_MARKER_H
+#define _ASM_I386_MARKER_H
+
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. i386 architecture optimisations.
+ *
+ * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+
+#ifdef CONFIG_MARKERS
+
+#define MF_DEFAULT (MF_OPTIMIZED | MF_LOCKDEP | MF_PRINTK)
+
+/* Optimized version of the markers */
+#define trace_mark_optimized(flags, name, format, args...) \
+	do { \
+		static const char __mstrtab_name_##name[] \
+		__attribute__((section("__markers_strings"))) \
+		= #name; \
+		static const char __mstrtab_format_##name[] \
+		__attribute__((section("__markers_strings"))) \
+		= format; \
+		static const char __mstrtab_args_##name[] \
+		__attribute__((section("__markers_strings"))) \
+		= #args; \
+		static struct __mark_marker_data __mark_data_##name \
+		__attribute__((section("__markers_data"))) = \
+		{ __mstrtab_name_##name,  __mstrtab_format_##name, \
+		__mstrtab_args_##name, \
+		(flags) | MF_OPTIMIZED, __mark_empty_function, NULL }; \
+		char condition; \
+		asm volatile(	".section __markers, \"a\", @progbits;\n\t" \
+					".long %1, 0f;\n\t" \
+					".previous;\n\t" \
+					".align 2\n\t" \
+					"0:\n\t" \
+					"movb $0,%0;\n\t" \
+				: "=r" (condition) \
+				: "m" (__mark_data_##name)); \
+		__mark_check_format(format, ## args); \
+		if (likely(!condition)) { \
+		} else { \
+			preempt_disable(); \
+			(*__mark_data_##name.call)(&__mark_data_##name, \
+						format, ## args); \
+			preempt_enable(); \
+		} \
+	} while (0)
+
+/* Marker macro selecting the generic or optimized version of marker, depending
+ * on the flags specified. */
+#define _trace_mark(flags, format, args...) \
+do { \
+	if (((flags) & MF_LOCKDEP) && ((flags) & MF_OPTIMIZED)) \
+		trace_mark_optimized(flags, format, ## args); \
+	else \
+		trace_mark_generic(flags, format, ## args); \
+} while (0)
+
+/* Marker with default behavior */
+#define trace_mark(format, args...) _trace_mark(MF_DEFAULT, format, ## args)
+
+/* Architecture dependant marker information, used internally for marker
+ * activation. */
+
+/* Offset of the immediate value from the start of the movb instruction, in
+ * bytes. */
+#define MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET 1
+#define MARK_OPTIMIZED_ENABLE_TYPE char
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define MARK_OPTIMIZED_ENABLE(a) \
+	*(MARK_OPTIMIZED_ENABLE_TYPE*) \
+		((char*)a+MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET)
+
+extern int marker_optimized_set_enable(void *address, char enable);
+
+#endif
+#endif //_ASM_I386_MARKER_H

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbXBKUDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbXBKUDh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 15:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932327AbXBKUDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 15:03:36 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:57624 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbXBKUDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 15:03:33 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       systemtap@sources.redhat.com, ltt-dev@shafik.org
Subject: [PATCH 04/05] Linux Kernel Markers : i386 optimization
Date: Sun, 11 Feb 2007 15:03:26 -0500
Message-Id: <11712242082031-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca>
References: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Markers : i386 optimization

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- /dev/null
+++ b/include/asm-i386/marker.h
@@ -0,0 +1,47 @@
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
+#define MARK(name, format, args...) \
+	do { \
+		static marker_probe_func *__mark_call_##name = \
+					__mark_empty_function; \
+		static const struct __mark_marker_c __mark_c_##name \
+			__attribute__((section(".markers.c"))) = \
+			{ #name, &__mark_call_##name, format, \
+			MARKER_OPTIMIZED } ; \
+		char condition; \
+		asm volatile(	".section .markers, \"a\";\n\t" \
+					".long %1, 0f;\n\t" \
+					".previous;\n\t" \
+					".align 2\n\t" \
+					"0:\n\t" \
+					"movb $0,%0;\n\t" \
+				: "=r" (condition) \
+				: "m" (__mark_c_##name)); \
+		__mark_check_format(format, ## args); \
+		if (unlikely(condition)) { \
+			preempt_disable(); \
+			(*__mark_call_##name)(format, ## args); \
+			preempt_enable(); \
+		} \
+	} while (0)
+
+/* Offset of the immediate value from the start of the movb instruction, in
+ * bytes. */
+#define MARK_ENABLE_IMMEDIATE_OFFSET 1
+#define MARK_ENABLE_TYPE char
+#define MARK_POLYMORPHIC
+
+extern int arch_marker_set_ins_enable(void *address, char enable);
+
+#endif
--- /dev/null
+++ b/arch/i386/kernel/marker.c
@@ -0,0 +1,93 @@
+/* marker.c
+ *
+ * Erratum 49 fix for Intel PIII and higher.
+ *
+ * Permits marker activation by XMC with correct serialization.
+ *
+ * Reentrant for NMI and trap handler instrumentation. :-)
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
+#include <asm/cacheflush.h>
+#include <asm/kdebug.h>
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
+int arch_marker_set_ins_enable(void *address, char enable)
+{
+	char saved_byte;
+	int ret;
+	char *dest = address;
+
+	mutex_lock(&mark_mutex);
+	BUG_ON(!(enable ^ dest[1]));	/* Must be a state change 0<->1 */
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
+EXPORT_SYMBOL(arch_marker_set_ins_enable);
--- a/arch/i386/kernel/Makefile
+++ b/arch/i386/kernel/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_VM86)		+= vm86.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_K8_NB)		+= k8.o
+obj-$(CONFIG_MARKERS_ENABLE_OPTIMIZATION)	+= marker.o
 
 # Make sure this is linked after any other paravirt_ops structs: see head.S
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o

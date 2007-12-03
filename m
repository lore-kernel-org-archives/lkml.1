Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbXLCNrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbXLCNrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 08:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbXLCNrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 08:47:14 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:60830 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751454AbXLCNrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 08:47:13 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 2/2] [AVR32] Oprofile support
Date: Mon,  3 Dec 2007 14:46:58 +0100
Message-Id: <1196689618-17503-2-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1196689618-17503-1-git-send-email-hskinnemoen@atmel.com>
References: <1196689618-17503-1-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the necessary architecture code to run oprofile on AVR32
using the performance counters documented by the AVR32 Architecture
Manual.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Acked-by: Philippe Elie <phil.el@wanadoo.fr>
---
Mathieu, I want to get oprofile support queued up for 2.6.25, and
since I don't see any signs that the Kconfig.instrumentation removal
patches are going in any time soon, I'm going to turn things around
and apply these two patches to my tree.

This unfortunately means that your patch won't apply cleanly to -mm
anymore, but it'll hopefully be easy to fix. When you do, please add
ARCH_SUPPORTS_OPROFILE to arch/avr32/Kconfig as well.

 arch/avr32/Makefile                  |    1 +
 arch/avr32/oprofile/Makefile         |    8 +
 arch/avr32/oprofile/op_model_avr32.c |  235 ++++++++++++++++++++++++++++++++++
 kernel/Kconfig.instrumentation       |    2 +-
 4 files changed, 245 insertions(+), 1 deletions(-)
 create mode 100644 arch/avr32/oprofile/Makefile
 create mode 100644 arch/avr32/oprofile/op_model_avr32.c

diff --git a/arch/avr32/Makefile b/arch/avr32/Makefile
index 8791864..f75d52c 100644
--- a/arch/avr32/Makefile
+++ b/arch/avr32/Makefile
@@ -31,6 +31,7 @@ core-$(CONFIG_BOARD_ATNGW100)		+= arch/avr32/boards/atngw100/
 core-$(CONFIG_LOADER_U_BOOT)		+= arch/avr32/boot/u-boot/
 core-y					+= arch/avr32/kernel/
 core-y					+= arch/avr32/mm/
+drivers-$(CONFIG_OPROFILE)		+= arch/avr32/oprofile/
 libs-y					+= arch/avr32/lib/
 
 archincdir-$(CONFIG_PLATFORM_AT32AP)	:= arch-at32ap
diff --git a/arch/avr32/oprofile/Makefile b/arch/avr32/oprofile/Makefile
new file mode 100644
index 0000000..1fe81c3
--- /dev/null
+++ b/arch/avr32/oprofile/Makefile
@@ -0,0 +1,8 @@
+obj-$(CONFIG_OPROFILE) += oprofile.o
+
+oprofile-y		:= $(addprefix ../../../drivers/oprofile/,	\
+				oprof.o cpu_buffer.o buffer_sync.o	\
+				event_buffer.o oprofile_files.o		\
+				oprofilefs.o oprofile_stats.o		\
+				timer_int.o)
+oprofile-y		+= op_model_avr32.o
diff --git a/arch/avr32/oprofile/op_model_avr32.c b/arch/avr32/oprofile/op_model_avr32.c
new file mode 100644
index 0000000..e2f876b
--- /dev/null
+++ b/arch/avr32/oprofile/op_model_avr32.c
@@ -0,0 +1,235 @@
+/*
+ * AVR32 Performance Counter Driver
+ *
+ * Copyright (C) 2005-2007 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Author: Ronny Pedersen
+ */
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/oprofile.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+
+#include <asm/intc.h>
+#include <asm/sysreg.h>
+#include <asm/system.h>
+
+#define AVR32_PERFCTR_IRQ_GROUP	0
+#define AVR32_PERFCTR_IRQ_LINE	1
+
+enum { PCCNT, PCNT0, PCNT1, NR_counter };
+
+struct avr32_perf_counter {
+	unsigned long	enabled;
+	unsigned long	event;
+	unsigned long	count;
+	unsigned long	unit_mask;
+	unsigned long	kernel;
+	unsigned long	user;
+
+	u32		ie_mask;
+	u32		flag_mask;
+};
+
+static struct avr32_perf_counter counter[NR_counter] = {
+	{
+		.ie_mask	= SYSREG_BIT(IEC),
+		.flag_mask	= SYSREG_BIT(FC),
+	}, {
+		.ie_mask	= SYSREG_BIT(IE0),
+		.flag_mask	= SYSREG_BIT(F0),
+	}, {
+		.ie_mask	= SYSREG_BIT(IE1),
+		.flag_mask	= SYSREG_BIT(F1),
+	},
+};
+
+static void avr32_perf_counter_reset(void)
+{
+	/* Reset all counter and disable/clear all interrupts */
+	sysreg_write(PCCR, (SYSREG_BIT(PCCR_R)
+				| SYSREG_BIT(PCCR_C)
+				| SYSREG_BIT(FC)
+				| SYSREG_BIT(F0)
+				| SYSREG_BIT(F1)));
+}
+
+static irqreturn_t avr32_perf_counter_interrupt(int irq, void *dev_id)
+{
+	struct avr32_perf_counter *ctr = dev_id;
+	struct pt_regs *regs;
+	u32 pccr;
+
+	if (likely(!(intc_get_pending(AVR32_PERFCTR_IRQ_GROUP)
+					& (1 << AVR32_PERFCTR_IRQ_LINE))))
+		return IRQ_NONE;
+
+	regs = get_irq_regs();
+	pccr = sysreg_read(PCCR);
+
+	/* Clear the interrupt flags we're about to handle */
+	sysreg_write(PCCR, pccr);
+
+	/* PCCNT */
+	if (ctr->enabled && (pccr & ctr->flag_mask)) {
+		sysreg_write(PCCNT, -ctr->count);
+		oprofile_add_sample(regs, PCCNT);
+	}
+	ctr++;
+	/* PCNT0 */
+	if (ctr->enabled && (pccr & ctr->flag_mask)) {
+		sysreg_write(PCNT0, -ctr->count);
+		oprofile_add_sample(regs, PCNT0);
+	}
+	ctr++;
+	/* PCNT1 */
+	if (ctr->enabled && (pccr & ctr->flag_mask)) {
+		sysreg_write(PCNT1, -ctr->count);
+		oprofile_add_sample(regs, PCNT1);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int avr32_perf_counter_create_files(struct super_block *sb,
+		struct dentry *root)
+{
+	struct dentry *dir;
+	unsigned int i;
+	char filename[4];
+
+	for (i = 0; i < NR_counter; i++) {
+		snprintf(filename, sizeof(filename), "%u", i);
+		dir = oprofilefs_mkdir(sb, root, filename);
+
+		oprofilefs_create_ulong(sb, dir, "enabled",
+				&counter[i].enabled);
+		oprofilefs_create_ulong(sb, dir, "event",
+				&counter[i].event);
+		oprofilefs_create_ulong(sb, dir, "count",
+				&counter[i].count);
+
+		/* Dummy entries */
+		oprofilefs_create_ulong(sb, dir, "kernel",
+				&counter[i].kernel);
+		oprofilefs_create_ulong(sb, dir, "user",
+				&counter[i].user);
+		oprofilefs_create_ulong(sb, dir, "unit_mask",
+				&counter[i].unit_mask);
+	}
+
+	return 0;
+}
+
+static int avr32_perf_counter_setup(void)
+{
+	struct avr32_perf_counter *ctr;
+	u32 pccr;
+	int ret;
+	int i;
+
+	pr_debug("avr32_perf_counter_setup\n");
+
+	if (sysreg_read(PCCR) & SYSREG_BIT(PCCR_E)) {
+		printk(KERN_ERR
+			"oprofile: setup: perf counter already enabled\n");
+		return -EBUSY;
+	}
+
+	ret = request_irq(AVR32_PERFCTR_IRQ_GROUP,
+			avr32_perf_counter_interrupt, IRQF_SHARED,
+			"oprofile", counter);
+	if (ret)
+		return ret;
+
+	avr32_perf_counter_reset();
+
+	pccr = 0;
+	for (i = PCCNT; i < NR_counter; i++) {
+		ctr = &counter[i];
+		if (!ctr->enabled)
+			continue;
+
+		pr_debug("enabling counter %d...\n", i);
+
+		pccr |= ctr->ie_mask;
+
+		switch (i) {
+		case PCCNT:
+			/* PCCNT always counts cycles, so no events */
+			sysreg_write(PCCNT, -ctr->count);
+			break;
+		case PCNT0:
+			pccr |= SYSREG_BF(CONF0, ctr->event);
+			sysreg_write(PCNT0, -ctr->count);
+			break;
+		case PCNT1:
+			pccr |= SYSREG_BF(CONF1, ctr->event);
+			sysreg_write(PCNT1, -ctr->count);
+			break;
+		}
+	}
+
+	pr_debug("oprofile: writing 0x%x to PCCR...\n", pccr);
+
+	sysreg_write(PCCR, pccr);
+
+	return 0;
+}
+
+static void avr32_perf_counter_shutdown(void)
+{
+	pr_debug("avr32_perf_counter_shutdown\n");
+
+	avr32_perf_counter_reset();
+	free_irq(AVR32_PERFCTR_IRQ_GROUP, counter);
+}
+
+static int avr32_perf_counter_start(void)
+{
+	pr_debug("avr32_perf_counter_start\n");
+
+	sysreg_write(PCCR, sysreg_read(PCCR) | SYSREG_BIT(PCCR_E));
+
+	return 0;
+}
+
+static void avr32_perf_counter_stop(void)
+{
+	pr_debug("avr32_perf_counter_stop\n");
+
+	sysreg_write(PCCR, sysreg_read(PCCR) & ~SYSREG_BIT(PCCR_E));
+}
+
+static struct oprofile_operations avr32_perf_counter_ops __initdata = {
+	.create_files	= avr32_perf_counter_create_files,
+	.setup		= avr32_perf_counter_setup,
+	.shutdown	= avr32_perf_counter_shutdown,
+	.start		= avr32_perf_counter_start,
+	.stop		= avr32_perf_counter_stop,
+	.cpu_type	= "avr32",
+};
+
+int __init oprofile_arch_init(struct oprofile_operations *ops)
+{
+	if (!(current_cpu_data.features & AVR32_FEATURE_PCTR))
+		return -ENODEV;
+
+	memcpy(ops, &avr32_perf_counter_ops,
+			sizeof(struct oprofile_operations));
+
+	printk(KERN_INFO "oprofile: using AVR32 performance monitoring.\n");
+
+	return 0;
+}
+
+void oprofile_arch_exit(void)
+{
+
+}
diff --git a/kernel/Kconfig.instrumentation b/kernel/Kconfig.instrumentation
index f5f2c76..fcd4bf7 100644
--- a/kernel/Kconfig.instrumentation
+++ b/kernel/Kconfig.instrumentation
@@ -21,7 +21,7 @@ config PROFILING
 config OPROFILE
 	tristate "OProfile system profiling (EXPERIMENTAL)"
 	depends on PROFILING
-	depends on ALPHA || ARM || BLACKFIN || X86_32 || IA64 || M32R || MIPS || PARISC || PPC || S390 || SUPERH || SPARC || X86_64
+	depends on ALPHA || ARM || AVR32 || BLACKFIN || X86_32 || IA64 || M32R || MIPS || PARISC || PPC || S390 || SUPERH || SPARC || X86_64
 	help
 	  OProfile is a profiling system capable of profiling the
 	  whole system, include the kernel, kernel modules, libraries,
-- 
1.5.3.4


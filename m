Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbXKGOF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbXKGOF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 09:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbXKGOFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 09:05:51 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:59268 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754765AbXKGOFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 09:05:49 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Philippe Elie <phil.el@wanadoo.fr>, oprofile-list@lists.sourceforge.net
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [RFC/PATCH] AVR32: Oprofile support
Date: Wed,  7 Nov 2007 15:05:33 +0100
Message-Id: <1194444333-9264-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the necessary architecture code to run oprofile on AVR32
using the performance counters documented by the AVR32 Architecture
Manual.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
This patch is meant to go on top of Mathieu Desnoyers' "Move
Instrumentation Support menu to arch/Kconfig" patches, but if you want
to try it out on something more mainstream, just add

source "kernel/Kconfig.instrumentation"

somewhere in arch/avr32/Kconfig and add AVR32 to the list of
architectures OPROFILE depends on in kernel/Kconfig.instrumentation.

 arch/avr32/Kconfig                   |    3 +
 arch/avr32/Makefile                  |    1 +
 arch/avr32/oprofile/Makefile         |    8 +
 arch/avr32/oprofile/op_model_avr32.c |  235 ++++++++++++++++++++++++++++++++++
 4 files changed, 247 insertions(+), 0 deletions(-)
 create mode 100644 arch/avr32/oprofile/Makefile
 create mode 100644 arch/avr32/oprofile/op_model_avr32.c

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 461bfca..c7dda5f 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -67,6 +67,9 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
+config ARCH_SUPPORTS_OPROFILE
+	def_bool y
+
 config ARCH_SUPPORTS_KPROBES
 	def_bool y
 
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
-- 
1.5.3.4


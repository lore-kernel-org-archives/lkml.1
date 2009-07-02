Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbZGBP0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbZGBP0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZGBP0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:26:00 -0400
Received: from mail-ew0-f215.google.com ([209.85.219.215]:49024 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZGBPZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:25:59 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2009 11:25:58 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BaRsmrpxrhZT88l7wfj278nx9dVD3L+Fdafd9/eUTAPqz5OHEwbGaqAwaGvUtBvc+6
         HAm7xLMQjQyyxlbLxeqLWsCySx/ag7ioB8mFuDskp7ME7u61uWZmTO6o0dqOkHNk589L
         5MBClYnCHj1EtFY4YIjkF9BWGqGHLyb/Rvl6U=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       ralf@linux-mips.org
Cc: Wu Zhangjin <wuzj@lemote.com>, Yan Hua <yanh@lemote.com>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>,
       loongson-dev <loongson-dev@googlegroups.com>,
       Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>,
       Arnaud Patard <apatard@mandriva.com>
Subject: [PATCH v4 11/16] [loongson] add oprofile support
Date: Thu,  2 Jul 2009 23:25:46 +0800
Message-Id: <b47ec17eab16bf50fa67e2302f2f92585602fe73.1246546684.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1246546684.git.wuzhangjin@gmail.com>
References: <cover.1246546684.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

this kernel support is needed by the user-space tool:oprofile to profile
linux kernel or applications via loongson2 performance counters. you can
enable this driver via CONFIG_OPROFILE = y or m.

In loongson2, there are two performance counters, each one can count 16 events
respectively. when anyone of the performance counter overflows, an interrupt
will generate and goes to the interrupt line: MIPS_CPU_IRQ_BASE + 6

Signed-off-by: Yanhua <yanh@lemote.com>
Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 arch/mips/include/asm/mach-lemote/loongson.h |    3 +
 arch/mips/lemote/lm2e/irq.c                  |    2 +
 arch/mips/oprofile/Makefile                  |    1 +
 arch/mips/oprofile/common.c                  |    4 +
 arch/mips/oprofile/op_model_loongson2.c      |  177 ++++++++++++++++++++++++++
 5 files changed, 187 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/oprofile/op_model_loongson2.c

diff --git a/arch/mips/include/asm/mach-lemote/loongson.h b/arch/mips/include/asm/mach-lemote/loongson.h
index 916eace..95ee4c8 100644
--- a/arch/mips/include/asm/mach-lemote/loongson.h
+++ b/arch/mips/include/asm/mach-lemote/loongson.h
@@ -50,4 +50,7 @@ extern void __init prom_init_env(void);
 #define LOONGSON_PXARB_CFG      BONITO(BONITO_REGBASE + 0x68)
 #define LOONGSON_PXARB_STATUS       BONITO(BONITO_REGBASE + 0x6c)
 
+/* loongson2-specific perf counter IRQ */
+#define LOONGSON2_PERFCNT_IRQ   (MIPS_CPU_IRQ_BASE + 6)
+
 #endif /* __ASM_MACH_LOONGSON_LOONGSON_H */
diff --git a/arch/mips/lemote/lm2e/irq.c b/arch/mips/lemote/lm2e/irq.c
index fb7643a..9585f5a 100644
--- a/arch/mips/lemote/lm2e/irq.c
+++ b/arch/mips/lemote/lm2e/irq.c
@@ -58,6 +58,8 @@ asmlinkage void plat_irq_dispatch(void)
 
 	if (pending & CAUSEF_IP7)
 		do_IRQ(MIPS_CPU_IRQ_BASE + 7);
+	else if (pending & CAUSEF_IP6) /* perf counter loverflow */
+		do_IRQ(LOONGSON2_PERFCNT_IRQ);
 	else if (pending & CAUSEF_IP5)
 		i8259_irqdispatch();
 	else if (pending & CAUSEF_IP2)
diff --git a/arch/mips/oprofile/Makefile b/arch/mips/oprofile/Makefile
index bf3be6f..02cc65e 100644
--- a/arch/mips/oprofile/Makefile
+++ b/arch/mips/oprofile/Makefile
@@ -15,3 +15,4 @@ oprofile-$(CONFIG_CPU_MIPS64)		+= op_model_mipsxx.o
 oprofile-$(CONFIG_CPU_R10000)		+= op_model_mipsxx.o
 oprofile-$(CONFIG_CPU_SB1)		+= op_model_mipsxx.o
 oprofile-$(CONFIG_CPU_RM9000)		+= op_model_rm9000.o
+oprofile-$(CONFIG_CPU_LOONGSON2)	+= op_model_loongson2.o
diff --git a/arch/mips/oprofile/common.c b/arch/mips/oprofile/common.c
index 3bf3354..7832ad2 100644
--- a/arch/mips/oprofile/common.c
+++ b/arch/mips/oprofile/common.c
@@ -16,6 +16,7 @@
 
 extern struct op_mips_model op_model_mipsxx_ops __attribute__((weak));
 extern struct op_mips_model op_model_rm9000_ops __attribute__((weak));
+extern struct op_mips_model op_model_loongson2_ops __attribute__((weak));
 
 static struct op_mips_model *model;
 
@@ -93,6 +94,9 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	case CPU_RM9000:
 		lmodel = &op_model_rm9000_ops;
 		break;
+	case CPU_LOONGSON2:
+		lmodel = &op_model_loongson2_ops;
+		break;
 	};
 
 	if (!lmodel)
diff --git a/arch/mips/oprofile/op_model_loongson2.c b/arch/mips/oprofile/op_model_loongson2.c
new file mode 100644
index 0000000..655cb8d
--- /dev/null
+++ b/arch/mips/oprofile/op_model_loongson2.c
@@ -0,0 +1,177 @@
+/*
+ * Loongson2 performance counter driver for oprofile
+ *
+ * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ * Author: Yanhua <yanh@lemote.com>
+ * Author: Wu Zhangjin <wuzj@lemote.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ */
+#include <linux/init.h>
+#include <linux/oprofile.h>
+#include <linux/interrupt.h>
+
+#include <loongson.h>			/* LOONGSON2_PERFCNT_IRQ */
+#include "op_impl.h"
+
+/*
+ * a patch should be sent to oprofile with the loongson-specific support.
+ * otherwise, the oprofile tool will not recognize this and complain about
+ * "cpu_type 'unset' is not valid".
+ */
+#define LOONGSON2_CPU_TYPE	"mips/godson2"
+
+#define LOONGSON2_COUNTER1_EVENT(event)	((event & 0x0f) << 5)
+#define LOONGSON2_COUNTER2_EVENT(event)	((event & 0x0f) << 9)
+
+#define LOONGSON2_PERFCNT_EXL			(1UL	<<  0)
+#define LOONGSON2_PERFCNT_KERNEL		(1UL    <<  1)
+#define LOONGSON2_PERFCNT_SUPERVISOR	(1UL    <<  2)
+#define LOONGSON2_PERFCNT_USER			(1UL    <<  3)
+#define LOONGSON2_PERFCNT_INT_EN		(1UL    <<  4)
+#define LOONGSON2_PERFCNT_OVERFLOW		(1ULL   << 31)
+
+/* Loongson2 performance counter register */
+#define read_c0_perfctrl() __read_64bit_c0_register($24, 0)
+#define write_c0_perfctrl(val) __write_64bit_c0_register($24, 0, val)
+#define read_c0_perfcnt() __read_64bit_c0_register($25, 0)
+#define write_c0_perfcnt(val) __write_64bit_c0_register($25, 0, val)
+
+static struct loongson2_register_config {
+	unsigned int ctrl;
+	unsigned long long reset_counter1;
+	unsigned long long reset_counter2;
+	int cnt1_enalbed, cnt2_enalbed;
+} reg;
+
+DEFINE_SPINLOCK(sample_lock);
+
+static char *oprofid = "LoongsonPerf";
+static irqreturn_t loongson2_perfcount_handler(int irq, void *dev_id);
+/* Compute all of the registers in preparation for enabling profiling.  */
+
+static void loongson2_reg_setup(struct op_counter_config *cfg)
+{
+	unsigned int ctrl = 0;
+
+	reg.reset_counter1 = 0;
+	reg.reset_counter2 = 0;
+	/* Compute the performance counter ctrl word.  */
+	/* For now count kernel and user mode */
+	if (cfg[0].enabled) {
+		ctrl |= LOONGSON2_COUNTER1_EVENT(cfg[0].event);
+		reg.reset_counter1 = 0x80000000ULL - cfg[0].count;
+	}
+
+	if (cfg[1].enabled) {
+		ctrl |= LOONGSON2_COUNTER2_EVENT(cfg[1].event);
+		reg.reset_counter2 = (0x80000000ULL - cfg[1].count);
+	}
+
+	if (cfg[0].enabled || cfg[1].enabled) {
+		ctrl |= LOONGSON2_PERFCNT_EXL | LOONGSON2_PERFCNT_INT_EN;
+		if (cfg[0].kernel || cfg[1].kernel)
+			ctrl |= LOONGSON2_PERFCNT_KERNEL;
+		if (cfg[0].user || cfg[1].user)
+			ctrl |= LOONGSON2_PERFCNT_USER;
+	}
+
+	reg.ctrl = ctrl;
+
+	reg.cnt1_enalbed = cfg[0].enabled;
+	reg.cnt2_enalbed = cfg[1].enabled;
+
+}
+
+/* Program all of the registers in preparation for enabling profiling.  */
+
+static void loongson2_cpu_setup(void *args)
+{
+	uint64_t perfcount;
+
+	perfcount = (reg.reset_counter2 << 32) | reg.reset_counter1;
+	write_c0_perfcnt(perfcount);
+}
+
+static void loongson2_cpu_start(void *args)
+{
+	/* Start all counters on current CPU */
+	if (reg.cnt1_enalbed || reg.cnt2_enalbed)
+		write_c0_perfctrl(reg.ctrl);
+}
+
+static void loongson2_cpu_stop(void *args)
+{
+	/* Stop all counters on current CPU */
+	write_c0_perfctrl(0);
+	memset(&reg, 0, sizeof(reg));
+}
+
+static irqreturn_t loongson2_perfcount_handler(int irq, void *dev_id)
+{
+	uint64_t counter, counter1, counter2;
+	struct pt_regs *regs = get_irq_regs();
+	int enabled;
+	unsigned long flags;
+
+	/*
+	 * LOONGSON2 defines two 32-bit performance counters.
+	 * To avoid a race updating the registers we need to stop the counters
+	 * while we're messing with
+	 * them ...
+	 */
+
+	/* Check whether the irq belongs to me */
+	enabled = reg.cnt1_enalbed | reg.cnt2_enalbed;
+	if (!enabled)
+		return IRQ_NONE;
+
+	counter = read_c0_perfcnt();
+	counter1 = counter & 0xffffffff;
+	counter2 = counter >> 32;
+
+	spin_lock_irqsave(&sample_lock, flags);
+
+	if (counter1 & LOONGSON2_PERFCNT_OVERFLOW) {
+		if (reg.cnt1_enalbed)
+			oprofile_add_sample(regs, 0);
+		counter1 = reg.reset_counter1;
+	}
+	if (counter2 & LOONGSON2_PERFCNT_OVERFLOW) {
+		if (reg.cnt2_enalbed)
+			oprofile_add_sample(regs, 1);
+		counter2 = reg.reset_counter2;
+	}
+
+	spin_unlock_irqrestore(&sample_lock, flags);
+
+	write_c0_perfcnt((counter2 << 32) | counter1);
+
+	return IRQ_HANDLED;
+}
+
+static int __init loongson2_init(void)
+{
+	return request_irq(LOONGSON2_PERFCNT_IRQ, loongson2_perfcount_handler,
+			   IRQF_SHARED, "Perfcounter", oprofid);
+}
+
+static void loongson2_exit(void)
+{
+	write_c0_perfctrl(0);
+	free_irq(LOONGSON2_PERFCNT_IRQ, oprofid);
+}
+
+struct op_mips_model op_model_loongson2_ops = {
+	.reg_setup = loongson2_reg_setup,
+	.cpu_setup = loongson2_cpu_setup,
+	.init = loongson2_init,
+	.exit = loongson2_exit,
+	.cpu_start = loongson2_cpu_start,
+	.cpu_stop = loongson2_cpu_stop,
+	.cpu_type = LOONGSON2_CPU_TYPE,
+	.num_counters = 2
+};
-- 
1.6.2.1


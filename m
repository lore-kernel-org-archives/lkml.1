Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbZJUOff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbZJUOff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 10:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbZJUOfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 10:35:33 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:64251 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbZJUOfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 10:35:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QUHkRZDVCdoofAIaphNFZf4CCttNAJZcDlgcdbjMbUiH4zgx2HN3qR0gvEhs9py7ug
         R7/n8xyYcMcp4nufz4JtbJ5r7/bQm9m9iNKYLG4vbFQvIgw0yPe1DJ95l8UP5hY90rzK
         n/E2XI76nJfL2dQdOS3g7OJ/4FAbsP7iBz+Fg=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH -v4 3/9] tracing: add MIPS specific trace_clock_local()
Date: Wed, 21 Oct 2009 22:34:57 +0800
Message-Id: <3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>
 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1256135456.git.wuzhangjin@gmail.com>
References: <cover.1256135456.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add the mips_timecounter_read() based high precision version
of trace_clock_local().

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/kernel/Makefile      |    6 ++++++
 arch/mips/kernel/trace_clock.c |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/kernel/trace_clock.c

diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index 8e26e9c..f228868 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -8,6 +8,10 @@ obj-y		+= cpu-probe.o branch.o entry.o genex.o irq.o process.o \
 		   ptrace.o reset.o setup.o signal.o syscall.o \
 		   time.o topology.o traps.o unaligned.o watch.o
 
+ifdef CONFIG_FUNCTION_TRACER
+CFLAGS_REMOVE_trace_clock.o = -pg
+endif
+
 obj-$(CONFIG_CEVT_BCM1480)	+= cevt-bcm1480.o
 obj-$(CONFIG_CEVT_R4K_LIB)	+= cevt-r4k.o
 obj-$(CONFIG_MIPS_MT_SMTC)	+= cevt-smtc.o
@@ -24,6 +28,8 @@ obj-$(CONFIG_SYNC_R4K)		+= sync-r4k.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_MODULES)		+= mips_ksyms.o module.o
 
+obj-$(CONFIG_FTRACE)		+= trace_clock.o
+
 obj-$(CONFIG_CPU_LOONGSON2)	+= r4k_fpu.o r4k_switch.o
 obj-$(CONFIG_CPU_MIPS32)	+= r4k_fpu.o r4k_switch.o
 obj-$(CONFIG_CPU_MIPS64)	+= r4k_fpu.o r4k_switch.o
diff --git a/arch/mips/kernel/trace_clock.c b/arch/mips/kernel/trace_clock.c
new file mode 100644
index 0000000..2e3475f
--- /dev/null
+++ b/arch/mips/kernel/trace_clock.c
@@ -0,0 +1,37 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive for
+ * more details.
+ *
+ * Copyright (C) 2009 Lemote Inc. & DSLab, Lanzhou University, China
+ * Author: Wu Zhangjin <wuzj@lemote.com>
+ */
+
+#include <linux/clocksource.h>
+#include <linux/sched.h>
+
+#include <asm/time.h>
+
+/*
+ * trace_clock_local(): the simplest and least coherent tracing clock.
+ *
+ * Useful for tracing that does not cross to other CPUs nor
+ * does it go through idle events.
+ */
+u64 trace_clock_local(void)
+{
+	unsigned long flags;
+	u64 clock;
+
+	raw_local_irq_save(flags);
+
+	preempt_disable_notrace();
+
+	clock = mips_timecounter_read();
+
+	preempt_enable_no_resched_notrace();
+
+	raw_local_irq_restore(flags);
+
+	return clock;
+}
-- 
1.6.2.1


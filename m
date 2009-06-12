Return-Path: <linux-kernel-owner+w=401wt.eu-S933221AbZFLQcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221AbZFLQcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764786AbZFLQZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:22 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39107 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764581AbZFLQZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:25:09 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 22/27] Blackfin: add preliminary support for STACKTRACE
Date: Fri, 12 Jun 2009 12:24:40 -0400
Message-Id: <1244823885-22410-23-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig             |    3 ++
 arch/blackfin/kernel/Makefile     |    1 +
 arch/blackfin/kernel/stacktrace.c |   53 +++++++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 0 deletions(-)
 create mode 100644 arch/blackfin/kernel/stacktrace.c

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index d68cb0d..77ec14f 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -55,6 +55,9 @@ config FORCE_MAX_ZONEORDER
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
+config STACKTRACE_SUPPORT
+	def_bool y
+
 config TRACE_IRQFLAGS_SUPPORT
 	def_bool y
 
diff --git a/arch/blackfin/kernel/Makefile b/arch/blackfin/kernel/Makefile
index fd4d432..a66dda4 100644
--- a/arch/blackfin/kernel/Makefile
+++ b/arch/blackfin/kernel/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_MODULES)                += module.o
 obj-$(CONFIG_KGDB)                   += kgdb.o
 obj-$(CONFIG_KGDB_TESTS)             += kgdb_test.o
 obj-$(CONFIG_EARLY_PRINTK)           += early_printk.o
+obj-$(CONFIG_STACKTRACE)             += stacktrace.o
 
 # the kgdb test puts code into L2 and without linker
 # relaxation, we need to force long calls to/from it
diff --git a/arch/blackfin/kernel/stacktrace.c b/arch/blackfin/kernel/stacktrace.c
new file mode 100644
index 0000000..30301e1
--- /dev/null
+++ b/arch/blackfin/kernel/stacktrace.c
@@ -0,0 +1,53 @@
+/*
+ * Blackfin stacktrace code (mostly copied from avr32)
+ *
+ * Copyright 2009 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/sched.h>
+#include <linux/stacktrace.h>
+#include <linux/thread_info.h>
+#include <linux/module.h>
+
+register unsigned long current_frame_pointer asm("FP");
+
+struct stackframe {
+	unsigned long fp;
+	unsigned long rets;
+};
+
+/*
+ * Save stack-backtrace addresses into a stack_trace buffer.
+ */
+void save_stack_trace(struct stack_trace *trace)
+{
+	unsigned long low, high;
+	unsigned long fp;
+	struct stackframe *frame;
+	int skip = trace->skip;
+
+	low = (unsigned long)task_stack_page(current);
+	high = low + THREAD_SIZE;
+	fp = current_frame_pointer;
+
+	while (fp >= low && fp <= (high - sizeof(*frame))) {
+		frame = (struct stackframe *)fp;
+
+		if (skip) {
+			skip--;
+		} else {
+			trace->entries[trace->nr_entries++] = frame->rets;
+			if (trace->nr_entries >= trace->max_entries)
+				break;
+		}
+
+		/*
+		 * The next frame must be at a higher address than the
+		 * current frame.
+		 */
+		low = fp + sizeof(*frame);
+		fp = frame->fp;
+	}
+}
+EXPORT_SYMBOL_GPL(save_stack_trace);
-- 
1.6.3.1


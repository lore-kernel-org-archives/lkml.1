Return-Path: <linux-kernel-owner+w=401wt.eu-S932292AbZD3Pog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbZD3Pog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbZD3PmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:42:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58586 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284AbZD3PmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:42:01 -0400
Message-Id: <10b3a32656e5552458db7412ef9ff8530d5f92aa.1241105648.git.arnd@arndb.de>
In-Reply-To: <cover.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 6 Nov 2008 14:16:55 +0100
Subject: [PATCH 04/27] asm-generic: add legacy I/O header files
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
X-Provags-ID: V01U2FsdGVkX1/jMjQVjcgBh61Th0esAmDpjwVpKW0g6T4B0tk
 XdMzX9ZO2kHF8xc4h9NUgEY3Xp6MoOEGKLbBcgvo4lJKHubl2L
 i4gcP0Ffx3UGYhJj+A17Q==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dma.h, hw_irq.h, serial.h and timex.h files originally
described PC-style i8237, i8259A, i8250 and i8253 chips.
Modern architectures live happily without these specific
interfaces, but a few definitions from these headers keep
getting used in common code.

The new generic headers are what most architectures use
anyway nowadays, just implementing the minimal definitions.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
 include/asm-generic/dma.h    |   15 +++++++++++++++
 include/asm-generic/hw_irq.h |    9 +++++++++
 include/asm-generic/serial.h |   13 +++++++++++++
 include/asm-generic/timex.h  |   29 +++++++++++++++++++++++++++++
 4 files changed, 66 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/dma.h
 create mode 100644 include/asm-generic/hw_irq.h
 create mode 100644 include/asm-generic/serial.h
 create mode 100644 include/asm-generic/timex.h

diff --git a/include/asm-generic/dma.h b/include/asm-generic/dma.h
new file mode 100644
index 0000000..9dfc3a7
--- /dev/null
+++ b/include/asm-generic/dma.h
@@ -0,0 +1,15 @@
+#ifndef __ASM_GENERIC_DMA_H
+#define __ASM_GENERIC_DMA_H
+/*
+ * This file traditionally describes the i8237 PC style DMA controller.
+ * Most architectures don't have these any more and can get the minimal
+ * implementation from kernel/dma.c by not defining MAX_DMA_CHANNELS.
+ *
+ * Some code relies on seeing MAX_DMA_ADDRESS though.
+ */
+#define MAX_DMA_ADDRESS PAGE_OFFSET
+
+extern int request_dma(unsigned int dmanr, const char *device_id);
+extern void free_dma(unsigned int dmanr);
+
+#endif /* __ASM_GENERIC_DMA_H */
diff --git a/include/asm-generic/hw_irq.h b/include/asm-generic/hw_irq.h
new file mode 100644
index 0000000..89036d7
--- /dev/null
+++ b/include/asm-generic/hw_irq.h
@@ -0,0 +1,9 @@
+#ifndef __ASM_GENERIC_HW_IRQ_H
+#define __ASM_GENERIC_HW_IRQ_H
+/*
+ * hw_irq.h has internal declarations for the low-level interrupt
+ * controller, like the original i8259A.
+ * In general, this is not needed for new architectures.
+ */
+
+#endif /* __ASM_GENERIC_HW_IRQ_H */
diff --git a/include/asm-generic/serial.h b/include/asm-generic/serial.h
new file mode 100644
index 0000000..5e29109
--- /dev/null
+++ b/include/asm-generic/serial.h
@@ -0,0 +1,13 @@
+#ifndef __ASM_GENERIC_SERIAL_H
+#define __ASM_GENERIC_SERIAL_H
+
+/*
+ * This should not be an architecture specific #define, oh well.
+ *
+ * Traditionally, it just describes i8250 and related serial ports
+ * that have this clock rate.
+ */
+
+#define BASE_BAUD (1843200 / 16)
+
+#endif /* __ASM_GENERIC_SERIAL_H */
diff --git a/include/asm-generic/timex.h b/include/asm-generic/timex.h
new file mode 100644
index 0000000..8a8d4a0
--- /dev/null
+++ b/include/asm-generic/timex.h
@@ -0,0 +1,29 @@
+#ifndef __ASM_GENERIC_TIMEX_H
+#define __ASM_GENERIC_TIMEX_H
+
+/*
+ * CLOCK_TICK_RATE is highly PC-specific and should not
+ * be used in portable code. 1193182 is the value for the
+ * original i8253 PIC.
+ */
+#ifndef CLOCK_TICK_RATE
+#define CLOCK_TICK_RATE		1193182
+#endif
+
+/*
+ * If you have a cycle counter, return the value here.
+ */
+typedef unsigned long cycles_t;
+static inline cycles_t get_cycles(void)
+{
+	return 0;
+}
+
+/*
+ * Architectures are encouraged to implement read_current_timer
+ * and define this in order to avoid the expensive delay loop
+ * calibration during boot.
+ */
+#undef ARCH_HAS_READ_CURRENT_TIMER
+
+#endif /* __ASM_GENERIC_TIMEX_H */
-- 
1.5.6.3



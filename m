Return-Path: <linux-kernel-owner+w=401wt.eu-S1762361AbZEMXAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762361AbZEMXAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 19:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761504AbZEMW5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:57:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62669 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760526AbZEMW4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:56:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: [PATCH 11/15] asm-generic: add legacy I/O header files
Date: Wed, 13 May 2009 22:56:34 +0000
Message-Id: <1242255398-23779-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1242255398-23779-1-git-send-email-arnd@arndb.de>
References: <1242255398-23779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18JCkxb+55o9cBwpVhaDgf4J20orfbRBosTx3b
 +o1Yl8eVqZCAzd7GG8nMdp8Rfjc7sHxlBTupAmhXGoY79rUfSl
 y0J/9M/1oc8tWbGA23UlA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dma.h, hw_irq.h, serial.h and timex.h files originally
described PC-style i8237, i8259A, i8250, i8253 and i8255 chips
as well as the VGA style text mode graphics.

Modern architectures live happily without these specific
interfaces, but a few definitions from these headers keep
getting used in common code.

The new generic headers are what most architectures use
anyway nowadays, just implementing the minimal definitions.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
 include/asm-generic/dma.h     |   15 +++++++++++++++
 include/asm-generic/hw_irq.h  |    9 +++++++++
 include/asm-generic/parport.h |   23 +++++++++++++++++++++++
 include/asm-generic/serial.h  |   13 +++++++++++++
 include/asm-generic/timex.h   |   22 ++++++++++++++++++++++
 include/asm-generic/vga.h     |   24 ++++++++++++++++++++++++
 6 files changed, 106 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/dma.h
 create mode 100644 include/asm-generic/hw_irq.h
 create mode 100644 include/asm-generic/parport.h
 create mode 100644 include/asm-generic/serial.h
 create mode 100644 include/asm-generic/timex.h
 create mode 100644 include/asm-generic/vga.h

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
diff --git a/include/asm-generic/parport.h b/include/asm-generic/parport.h
new file mode 100644
index 0000000..40528cb
--- /dev/null
+++ b/include/asm-generic/parport.h
@@ -0,0 +1,23 @@
+#ifndef __ASM_GENERIC_PARPORT_H
+#define __ASM_GENERIC_PARPORT_H
+
+/*
+ * An ISA bus may have i8255 parallel ports at well-known
+ * locations in the I/O space, which are scanned by
+ * parport_pc_find_isa_ports.
+ *
+ * Without ISA support, the driver will only attach
+ * to devices on the PCI bus.
+ */
+
+static int __devinit parport_pc_find_isa_ports(int autoirq, int autodma);
+static int __devinit parport_pc_find_nonpci_ports(int autoirq, int autodma)
+{
+#ifdef CONFIG_ISA
+	return parport_pc_find_isa_ports(autoirq, autodma);
+#else
+	return 0;
+#endif
+}
+
+#endif /* __ASM_GENERIC_PARPORT_H */
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
index 0000000..b2243cb
--- /dev/null
+++ b/include/asm-generic/timex.h
@@ -0,0 +1,22 @@
+#ifndef __ASM_GENERIC_TIMEX_H
+#define __ASM_GENERIC_TIMEX_H
+
+/*
+ * If you have a cycle counter, return the value here.
+ */
+typedef unsigned long cycles_t;
+#ifndef get_cycles
+static inline cycles_t get_cycles(void)
+{
+	return 0;
+}
+#endif
+
+/*
+ * Architectures are encouraged to implement read_current_timer
+ * and define this in order to avoid the expensive delay loop
+ * calibration during boot.
+ */
+#undef ARCH_HAS_READ_CURRENT_TIMER
+
+#endif /* __ASM_GENERIC_TIMEX_H */
diff --git a/include/asm-generic/vga.h b/include/asm-generic/vga.h
new file mode 100644
index 0000000..36c8ff5
--- /dev/null
+++ b/include/asm-generic/vga.h
@@ -0,0 +1,24 @@
+/*
+ *	Access to VGA videoram
+ *
+ *	(c) 1998 Martin Mares <mj@ucw.cz>
+ */
+#ifndef __ASM_GENERIC_VGA_H
+#define __ASM_GENERIC_VGA_H
+
+/*
+ *	On most architectures that support VGA, we can just
+ *	recalculate addresses and then access the videoram
+ *	directly without any black magic.
+ *
+ *	Everyone else needs to ioremap the address and use
+ *	proper I/O accesses.
+ */
+#ifndef VGA_MAP_MEM
+#define VGA_MAP_MEM(x, s) (unsigned long)phys_to_virt(x)
+#endif
+
+#define vga_readb(x) (*(x))
+#define vga_writeb(x, y) (*(y) = (x))
+
+#endif /* _ASM_GENERIC_VGA_H */
-- 
1.6.0.4


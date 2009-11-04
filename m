Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbZKDJGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbZKDJGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 04:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbZKDJGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 04:06:06 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:46415 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbZKDJF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 04:05:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=asatq1+iBPtRj8IgITfnlgL/LPguojtO3e/i1uBbxKFIIZS+wDFzS+LrgL97rkkY0Y
         6S4WMY0rZrTdGl9RtpxK1FA8/l55AW6Mla5wNYrPM9/xr4N8aOJ6BgMumMPev12I17z2
         QYjru81x24xUV5yvedyF8CHrYjYPjbAoUtOYQ=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, linux-mips@linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>, huhb@lemote.com, yanh@lemote.com,
       Zhang Le <r0bertz@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       liujl@lemote.com
Subject: [PATCH -queue v0 4/6] [loongson] add basic fuloong2f support
Date: Wed,  4 Nov 2009 17:05:47 +0800
Message-Id: <0f805f7d12c5a7cbcc125ba4a1b70113ec2047a6.1257325319.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1257325319.git.wuzhangjin@gmail.com>
References: <cover.1257325319.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fuloong(2f) has an AMD CS5536 south bridge. we need to add support for
it.

there are several modules provided by cs5536, currently, only these modules are
used in fuloong(2f) mini PC: ide, acc(audio), ohci, isa, and ehci.

since the PCI operations are similiar between fuloong(2e) and
fuloong(2f),yeeloong(2f) and even similiar to gdium, herein, I just rename
ops-fuloong2e.c to ops-loongsgon2.c to share most of the source code.

and also, the serial port support is enabled via adding a macro in
machine.h.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/Makefile                            |    1 +
 arch/mips/include/asm/mach-loongson/machine.h |    8 +-
 arch/mips/loongson/Kconfig                    |   30 ++++
 arch/mips/loongson/Makefile                   |    6 +
 arch/mips/loongson/fuloong-2f/Makefile        |    5 +
 arch/mips/loongson/fuloong-2f/irq.c           |  114 ++++++++++++++
 arch/mips/loongson/fuloong-2f/reset.c         |   68 ++++++++
 arch/mips/pci/Makefile                        |    3 +-
 arch/mips/pci/fixup-fuloong2f.c               |  171 ++++++++++++++++++++
 arch/mips/pci/ops-fuloong2e.c                 |  154 ------------------
 arch/mips/pci/ops-loongson2.c                 |  207 +++++++++++++++++++++++++
 11 files changed, 611 insertions(+), 156 deletions(-)
 create mode 100644 arch/mips/loongson/fuloong-2f/Makefile
 create mode 100644 arch/mips/loongson/fuloong-2f/irq.c
 create mode 100644 arch/mips/loongson/fuloong-2f/reset.c
 create mode 100644 arch/mips/pci/fixup-fuloong2f.c
 delete mode 100644 arch/mips/pci/ops-fuloong2e.c
 create mode 100644 arch/mips/pci/ops-loongson2.c

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 47ecded..65d4734 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -327,6 +327,7 @@ core-$(CONFIG_MACH_LOONGSON) +=arch/mips/loongson/
 cflags-$(CONFIG_MACH_LOONGSON) += -I$(srctree)/arch/mips/include/asm/mach-loongson \
                     -mno-branch-likely
 load-$(CONFIG_LEMOTE_FULOONG2E) +=0xffffffff80100000
+load-$(CONFIG_LEMOTE_FULOONG2F) +=0xffffffff80200000
 
 #
 # MIPS Malta board
diff --git a/arch/mips/include/asm/mach-loongson/machine.h b/arch/mips/include/asm/mach-loongson/machine.h
index ea5954c..2eb9be6 100644
--- a/arch/mips/include/asm/mach-loongson/machine.h
+++ b/arch/mips/include/asm/mach-loongson/machine.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
+ * Copyright (C) 2009 Lemote, Inc.
  * Author: Wu Zhangjin <wuzj@lemote.com>
  *
  * This program is free software; you can redistribute  it and/or modify it
@@ -17,6 +17,12 @@
 
 #define LOONGSON_MACHTYPE MACH_LEMOTE_FL2E
 
+#elif defined(CONFIG_LEMOTE_FULOONG2F)
+
+#define LOONGSON_UART_BASE (LOONGSON_PCIIO_BASE + 0x2f8)
+
+#define LOONGSON_MACHTYPE MACH_LEMOTE_FL2F
+
 #endif
 
 #endif /* __ASM_MACH_LOONGSON_MACHINE_H */
diff --git a/arch/mips/loongson/Kconfig b/arch/mips/loongson/Kconfig
index b03d773..8156d71 100644
--- a/arch/mips/loongson/Kconfig
+++ b/arch/mips/loongson/Kconfig
@@ -28,6 +28,36 @@ config LEMOTE_FULOONG2E
 	  an FPGA northbridge
 
 	  Lemote Fuloong(2e) mini PC have a VIA686B south bridge.
+
+config LEMOTE_FULOONG2F
+	bool "Lemote Fuloong(2f) mini-PC"
+	select ARCH_SPARSEMEM_ENABLE
+	select CEVT_R4K
+	select CSRC_R4K
+	select SYS_HAS_CPU_LOONGSON2F
+	select DMA_NONCOHERENT
+	select BOOT_ELF32
+	select BOARD_SCACHE
+	select HW_HAS_PCI
+	select I8259
+	select ISA
+	select IRQ_CPU
+	select SYS_SUPPORTS_32BIT_KERNEL
+	select SYS_SUPPORTS_64BIT_KERNEL
+	select SYS_SUPPORTS_LITTLE_ENDIAN
+	select SYS_SUPPORTS_HIGHMEM
+	select SYS_HAS_EARLY_PRINTK
+	select GENERIC_HARDIRQS_NO__DO_IRQ
+	select GENERIC_ISA_DMA_SUPPORT_BROKEN
+	select CPU_HAS_WB
+	select CS5536
+	help
+	  Lemote Fuloong(2f) mini-PC board based on the Chinese Loongson-2F
+	  CPU, which has an internal DDR and PCIX controller. the PCIX
+	  controller have the similiar programming interface of the FPGA north
+	  bridge of LOONGSON2E.
+
+	  Lemote Fuloong(2f) mini PC have an AMD CS5536 south bridge.
 endchoice
 
 config CS5536
diff --git a/arch/mips/loongson/Makefile b/arch/mips/loongson/Makefile
index 39048c4..635062b 100644
--- a/arch/mips/loongson/Makefile
+++ b/arch/mips/loongson/Makefile
@@ -9,3 +9,9 @@ obj-$(CONFIG_MACH_LOONGSON) += common/
 #
 
 obj-$(CONFIG_LEMOTE_FULOONG2E)  += fuloong-2e/
+
+#
+# Lemote Fuloong mini-PC (Loongson 2F-based)
+#
+
+obj-$(CONFIG_LEMOTE_FULOONG2F)  += fuloong-2f/
diff --git a/arch/mips/loongson/fuloong-2f/Makefile b/arch/mips/loongson/fuloong-2f/Makefile
new file mode 100644
index 0000000..010b86c
--- /dev/null
+++ b/arch/mips/loongson/fuloong-2f/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for fuloong-2f
+#
+
+obj-y += irq.o reset.o
diff --git a/arch/mips/loongson/fuloong-2f/irq.c b/arch/mips/loongson/fuloong-2f/irq.c
new file mode 100644
index 0000000..22c45fd
--- /dev/null
+++ b/arch/mips/loongson/fuloong-2f/irq.c
@@ -0,0 +1,114 @@
+/*
+ * Copyright (C) 2007 Lemote Inc.
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#include <linux/interrupt.h>
+
+#include <asm/irq_cpu.h>
+#include <asm/i8259.h>
+#include <asm/mipsregs.h>
+
+#include <loongson.h>
+#include <machine.h>
+
+#define LOONGSON_TIMER_IRQ	(MIPS_CPU_IRQ_BASE + 7)	/* cpu timer */
+#define LOONGSON_PERFCNT_IRQ	(MIPS_CPU_IRQ_BASE + 6) /* cpu perf counter */
+#define LOONGSON_NORTH_BRIDGE_IRQ	(MIPS_CPU_IRQ_BASE + 6)	/* bonito */
+#define LOONGSON_UART_IRQ	(MIPS_CPU_IRQ_BASE + 3)	/* cpu serial port */
+#define LOONGSON_SOUTH_BRIDGE_IRQ	(MIPS_CPU_IRQ_BASE + 2)	/* i8259 */
+
+#define LOONGSON_INT_BIT_INT0		(1 << 11)
+#define LOONGSON_INT_BIT_INT1		(1 << 12)
+
+static int mach_i8259_irq(void)
+{
+	int irq, isr, imr;
+
+	irq = -1;
+
+	if ((LOONGSON_INTISR & LOONGSON_INTEN) & LOONGSON_INT_BIT_INT0) {
+		imr = inb(0x21) | (inb(0xa1) << 8);
+		isr = inb(0x20) | (inb(0xa0) << 8);
+		isr &= ~0x4;	/* irq2 for cascade */
+		isr &= ~imr;
+		irq = ffs(isr) - 1;
+	}
+
+	return irq;
+}
+
+static void i8259_irqdispatch(void)
+{
+	int irq;
+
+	irq = mach_i8259_irq();
+	if (irq >= 0)
+		do_IRQ(irq);
+	else
+		spurious_interrupt();
+}
+
+void mach_irq_dispatch(unsigned int pending)
+{
+	if (pending & CAUSEF_IP7)
+		do_IRQ(LOONGSON_TIMER_IRQ);
+	else if (pending & CAUSEF_IP6) {	/* North Bridge, Perf counter */
+#ifdef CONFIG_OPROFILE
+		do_IRQ(LOONGSON2_PERFCNT_IRQ);
+#endif
+		bonito_irqdispatch();
+	} else if (pending & CAUSEF_IP3)	/* CPU UART */
+		do_IRQ(LOONGSON_UART_IRQ);
+	else if (pending & CAUSEF_IP2)	/* South Bridge */
+		i8259_irqdispatch();
+	else
+		spurious_interrupt();
+}
+
+void __init set_irq_trigger_mode(void)
+{
+	/* setup cs5536 as high level trigger */
+	LOONGSON_INTPOL = LOONGSON_INT_BIT_INT0 | LOONGSON_INT_BIT_INT1;
+	LOONGSON_INTEDGE &= ~(LOONGSON_INT_BIT_INT0 | LOONGSON_INT_BIT_INT1);
+}
+
+static irqreturn_t ip6_action(int cpl, void *dev_id)
+{
+	return IRQ_HANDLED;
+}
+
+struct irqaction ip6_irqaction = {
+	.handler = ip6_action,
+	.name = "cascade",
+	.flags = IRQF_SHARED,
+};
+
+struct irqaction cascade_irqaction = {
+	.handler = no_action,
+	.name = "cascade",
+};
+
+void __init mach_init_irq(void)
+{
+	/* init all controller
+	 *   0-15         ------> i8259 interrupt
+	 *   16-23        ------> mips cpu interrupt
+	 *   32-63        ------> bonito irq
+	 */
+
+	/* Sets the first-level interrupt dispatcher. */
+	mips_cpu_irq_init();
+	init_i8259_irqs();
+	bonito_irq_init();
+
+	/* setup north bridge irq (bonito) */
+	setup_irq(LOONGSON_NORTH_BRIDGE_IRQ, &ip6_irqaction);
+	/* setup source bridge irq (i8259) */
+	setup_irq(LOONGSON_SOUTH_BRIDGE_IRQ, &cascade_irqaction);
+}
diff --git a/arch/mips/loongson/fuloong-2f/reset.c b/arch/mips/loongson/fuloong-2f/reset.c
new file mode 100644
index 0000000..ac52f10
--- /dev/null
+++ b/arch/mips/loongson/fuloong-2f/reset.c
@@ -0,0 +1,68 @@
+/* Board-specific reboot/shutdown routines
+ *
+ * Copyright (c) 2009 Philippe Vachon <philippe@cowpig.ca>
+ *
+ * Copyright (C) 2009 Lemote Inc.
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/types.h>
+
+#include <loongson.h>
+
+/* cs5536 is the south bridge used by fuloong2f mini PC */
+#include <cs5536/cs5536.h>
+
+void mach_prepare_reboot(void)
+{
+	/*
+	 * reset cpu to full speed, this is needed when enabling cpu frequency
+	 * scalling
+	 */
+	LOONGSON_CHIPCFG0 |= 0x7;
+
+	/* send a reset signal to south bridge.
+	 *
+	 * NOTE: if enable "Power Management" in kernel, rtl8169 will not reset
+	 * normally with this reset operation and it will not work in PMON, but
+	 * you can type halt command and then reboot, seems the hardware reset
+	 * logic not work normally.
+	 */
+	{
+		u32 hi, lo;
+		_rdmsr(DIVIL_MSR_REG(DIVIL_SOFT_RESET), &hi, &lo);
+		lo |= 0x00000001;
+		_wrmsr(DIVIL_MSR_REG(DIVIL_SOFT_RESET), hi, lo);
+	}
+	/* the reset signal need about 8ms(?) to function */
+	udelay(8000);
+}
+
+void mach_prepare_shutdown(void)
+{
+	u32 hi, lo, val;
+	int gpio_base;
+
+	/* get gpio base */
+	_rdmsr(DIVIL_MSR_REG(DIVIL_LBAR_GPIO), &hi, &lo);
+	gpio_base = lo & 0xff00;
+
+	/* make cs5536 gpio13 output enable */
+	val = inl(gpio_base + GPIOL_OUT_EN);
+	val &= ~(1 << (16 + 13));
+	val |= (1 << 13);
+	outl(val, gpio_base + GPIOL_OUT_EN);
+	mmiowb();
+	/* make cs5536 gpio13 output low level voltage. */
+	val = inl(gpio_base + GPIOL_OUT_VAL) & ~(1 << (13));
+	val |= (1 << (16 + 13));
+	outl(val, gpio_base + GPIOL_OUT_VAL);
+	mmiowb();
+}
diff --git a/arch/mips/pci/Makefile b/arch/mips/pci/Makefile
index 0610c86..e7ad00b 100644
--- a/arch/mips/pci/Makefile
+++ b/arch/mips/pci/Makefile
@@ -28,7 +28,8 @@ obj-$(CONFIG_MIPS_COBALT)	+= fixup-cobalt.o
 obj-$(CONFIG_SOC_AU1500)	+= fixup-au1000.o ops-au1000.o
 obj-$(CONFIG_SOC_AU1550)	+= fixup-au1000.o ops-au1000.o
 obj-$(CONFIG_SOC_PNX8550)	+= fixup-pnx8550.o ops-pnx8550.o
-obj-$(CONFIG_LEMOTE_FULOONG2E)	+= fixup-fuloong2e.o ops-fuloong2e.o
+obj-$(CONFIG_LEMOTE_FULOONG2E)	+= fixup-fuloong2e.o ops-loongson2.o
+obj-$(CONFIG_LEMOTE_FULOONG2F)	+= fixup-fuloong2f.o ops-loongson2.o
 obj-$(CONFIG_MIPS_MALTA)	+= fixup-malta.o
 obj-$(CONFIG_PMC_MSP7120_GW)	+= fixup-pmcmsp.o ops-pmcmsp.o
 obj-$(CONFIG_PMC_MSP7120_EVAL)	+= fixup-pmcmsp.o ops-pmcmsp.o
diff --git a/arch/mips/pci/fixup-fuloong2f.c b/arch/mips/pci/fixup-fuloong2f.c
new file mode 100644
index 0000000..994f668
--- /dev/null
+++ b/arch/mips/pci/fixup-fuloong2f.c
@@ -0,0 +1,171 @@
+/*
+ * Copyright (C) 2008 Lemote Technology
+ * Copyright (C) 2004 ICT CAS
+ * Author: Li xiaoyu, lixy@ict.ac.cn
+ *
+ * Copyright (C) 2007 Lemote, Inc.
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+#include <linux/init.h>
+#include <linux/pci.h>
+
+#include <loongson.h>
+#include <cs5536/cs5536.h>
+#include <cs5536/cs5536_pci.h>
+
+/* PCI interrupt pins
+ *
+ * These should not be changed, or you should consider loongson2f interrupt
+ * register and your pci card dispatch
+ */
+
+#define PCIA		4
+#define PCIB		5
+#define PCIC		6
+#define PCID		7
+
+/* all the pci device has the PCIA pin, check the datasheet. */
+static char irq_tab[][5] __initdata = {
+	/*      INTA    INTB    INTC    INTD */
+	{0, 0, 0, 0, 0},	/*  11: Unused */
+	{0, 0, 0, 0, 0},	/*  12: Unused */
+	{0, 0, 0, 0, 0},	/*  13: Unused */
+	{0, 0, 0, 0, 0},	/*  14: Unused */
+	{0, 0, 0, 0, 0},	/*  15: Unused */
+	{0, 0, 0, 0, 0},	/*  16: Unused */
+	{0, PCIA, 0, 0, 0},	/*  17: RTL8110-0 */
+	{0, PCIB, 0, 0, 0},	/*  18: RTL8110-1 */
+	{0, PCIC, 0, 0, 0},	/*  19: SiI3114 */
+	{0, PCID, 0, 0, 0},	/*  20: 3-ports nec usb */
+	{0, PCIA, PCIB, PCIC, PCID},	/*  21: PCI-SLOT */
+	{0, 0, 0, 0, 0},	/*  22: Unused */
+	{0, 0, 0, 0, 0},	/*  23: Unused */
+	{0, 0, 0, 0, 0},	/*  24: Unused */
+	{0, 0, 0, 0, 0},	/*  25: Unused */
+	{0, 0, 0, 0, 0},	/*  26: Unused */
+	{0, 0, 0, 0, 0},	/*  27: Unused */
+};
+
+int __init pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
+{
+	int virq;
+
+	if ((PCI_SLOT(dev->devfn) != PCI_IDSEL_CS5536)
+	    && (PCI_SLOT(dev->devfn) < 32)) {
+		virq = irq_tab[slot][pin];
+		printk(KERN_INFO "slot: %d, pin: %d, irq: %d\n", slot, pin,
+		       virq + LOONGSON_IRQ_BASE);
+		if (virq != 0)
+			return LOONGSON_IRQ_BASE + virq;
+		else
+			return 0;
+	} else if (PCI_SLOT(dev->devfn) == PCI_IDSEL_CS5536) {	/*  cs5536 */
+		switch (PCI_FUNC(dev->devfn)) {
+		case 2:
+			pci_write_config_byte(dev, PCI_INTERRUPT_LINE,
+					      CS5536_IDE_INTR);
+			return CS5536_IDE_INTR;	/*  for IDE */
+		case 3:
+			pci_write_config_byte(dev, PCI_INTERRUPT_LINE,
+					      CS5536_ACC_INTR);
+			return CS5536_ACC_INTR;	/*  for AUDIO */
+		case 4:	/*  for OHCI */
+		case 5:	/*  for EHCI */
+		case 6:	/*  for UDC */
+		case 7:	/*  for OTG */
+			pci_write_config_byte(dev, PCI_INTERRUPT_LINE,
+					      CS5536_USB_INTR);
+			return CS5536_USB_INTR;
+		}
+		return dev->irq;
+	} else {
+		printk(KERN_INFO " strange pci slot number.\n");
+		return 0;
+	}
+}
+
+/* Do platform specific device initialization at pci_enable_device() time */
+int pcibios_plat_dev_init(struct pci_dev *dev)
+{
+	return 0;
+}
+
+/* CS5536 SPEC. fixup */
+static void __init loongson_cs5536_isa_fixup(struct pci_dev *pdev)
+{
+	/* the uart1 and uart2 interrupt in PIC is enabled as default */
+	pci_write_config_dword(pdev, PCI_UART1_INT_REG, 1);
+	pci_write_config_dword(pdev, PCI_UART2_INT_REG, 1);
+	return;
+}
+
+static void __init loongson_cs5536_ide_fixup(struct pci_dev *pdev)
+{
+	/* setting the mutex pin as IDE function */
+	pci_write_config_dword(pdev, PCI_IDE_CFG_REG,
+			       CS5536_IDE_FLASH_SIGNATURE);
+	return;
+}
+
+static void __init loongson_cs5536_acc_fixup(struct pci_dev *pdev)
+{
+	u8 val;
+
+	/* enable the AUDIO interrupt in PIC  */
+	pci_write_config_dword(pdev, PCI_ACC_INT_REG, 1);
+
+#if 1
+	pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &val);
+	printk(KERN_INFO "cs5536 acc latency 0x%x\n", val);
+	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0xc0);
+#endif
+	return;
+}
+
+static void __init loongson_cs5536_ohci_fixup(struct pci_dev *pdev)
+{
+	/* enable the OHCI interrupt in PIC */
+	/* THE OHCI, EHCI, UDC, OTG are shared with interrupt in PIC */
+	pci_write_config_dword(pdev, PCI_OHCI_INT_REG, 1);
+	return;
+}
+
+static void __init loongson_cs5536_ehci_fixup(struct pci_dev *pdev)
+{
+	u32 hi, lo;
+
+	/* Serial short detect enable */
+	_rdmsr(USB_MSR_REG(USB_CONFIG), &hi, &lo);
+	_wrmsr(USB_MSR_REG(USB_CONFIG), (1 << 1) | (1 << 2) | (1 << 3), lo);
+
+	/* setting the USB2.0 micro frame length */
+	pci_write_config_dword(pdev, PCI_EHCI_FLADJ_REG, 0x2000);
+	return;
+}
+
+static void __init loongson_nec_fixup(struct pci_dev *pdev)
+{
+	unsigned int val;
+
+	pci_read_config_dword(pdev, 0xe0, &val);
+	/* Only 2 port be used */
+	pci_write_config_dword(pdev, 0xe0, (val & ~3) | 0x2);
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA,
+			 loongson_cs5536_isa_fixup);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_OHC,
+			 loongson_cs5536_ohci_fixup);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_EHC,
+			 loongson_cs5536_ehci_fixup);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_AUDIO,
+			 loongson_cs5536_acc_fixup);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_IDE,
+			 loongson_cs5536_ide_fixup);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NEC, PCI_DEVICE_ID_NEC_USB,
+			 loongson_nec_fixup);
diff --git a/arch/mips/pci/ops-fuloong2e.c b/arch/mips/pci/ops-fuloong2e.c
deleted file mode 100644
index 171f65c..0000000
--- a/arch/mips/pci/ops-fuloong2e.c
+++ /dev/null
@@ -1,154 +0,0 @@
-/*
- * fuloong2e specific PCI support.
- *
- * Copyright (C) 1999, 2000, 2004  MIPS Technologies, Inc.
- *	All rights reserved.
- *	Authors: Carsten Langgaard <carstenl@mips.com>
- *		 Maciej W. Rozycki <macro@mips.com>
- *
- * Copyright (C) 2009 Lemote Inc.
- * Author: Wu Zhangjin <wuzj@lemote.com>
- *
- *  This program is free software; you can distribute it and/or modify it
- *  under the terms of the GNU General Public License (Version 2) as
- *  published by the Free Software Foundation.
- */
-#include <linux/types.h>
-#include <linux/pci.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-
-#include <loongson.h>
-
-#define PCI_ACCESS_READ  0
-#define PCI_ACCESS_WRITE 1
-
-#define CFG_SPACE_REG(offset) \
-	(void *)CKSEG1ADDR(LOONGSON_PCICFG_BASE | (offset))
-#define ID_SEL_BEGIN 11
-#define MAX_DEV_NUM (31 - ID_SEL_BEGIN)
-
-
-static int loongson_pcibios_config_access(unsigned char access_type,
-				      struct pci_bus *bus,
-				      unsigned int devfn, int where,
-				      u32 *data)
-{
-	u32 busnum = bus->number;
-	u32 addr, type;
-	u32 dummy;
-	void *addrp;
-	int device = PCI_SLOT(devfn);
-	int function = PCI_FUNC(devfn);
-	int reg = where & ~3;
-
-	if (busnum == 0) {
-		/* Type 0 configuration for onboard PCI bus */
-		if (device > MAX_DEV_NUM)
-			return -1;
-
-		addr = (1 << (device + ID_SEL_BEGIN)) | (function << 8) | reg;
-		type = 0;
-	} else {
-		/* Type 1 configuration for offboard PCI bus */
-		addr = (busnum << 16) | (device << 11) | (function << 8) | reg;
-		type = 0x10000;
-	}
-
-	/* Clear aborts */
-	LOONGSON_PCICMD |= LOONGSON_PCICMD_MABORT_CLR | \
-				LOONGSON_PCICMD_MTABORT_CLR;
-
-	LOONGSON_PCIMAP_CFG = (addr >> 16) | type;
-
-	/* Flush Bonito register block */
-	dummy = LOONGSON_PCIMAP_CFG;
-	mmiowb();
-
-	addrp = CFG_SPACE_REG(addr & 0xffff);
-	if (access_type == PCI_ACCESS_WRITE)
-		writel(cpu_to_le32(*data), addrp);
-	else
-		*data = le32_to_cpu(readl(addrp));
-
-	/* Detect Master/Target abort */
-	if (LOONGSON_PCICMD & (LOONGSON_PCICMD_MABORT_CLR |
-			     LOONGSON_PCICMD_MTABORT_CLR)) {
-		/* Error occurred */
-
-		/* Clear bits */
-		LOONGSON_PCICMD |= (LOONGSON_PCICMD_MABORT_CLR |
-				  LOONGSON_PCICMD_MTABORT_CLR);
-
-		return -1;
-	}
-
-	return 0;
-
-}
-
-
-/*
- * We can't address 8 and 16 bit words directly.  Instead we have to
- * read/write a 32bit word and mask/modify the data we actually want.
- */
-static int loongson_pcibios_read(struct pci_bus *bus, unsigned int devfn,
-			     int where, int size, u32 *val)
-{
-	u32 data = 0;
-
-	if ((size == 2) && (where & 1))
-		return PCIBIOS_BAD_REGISTER_NUMBER;
-	else if ((size == 4) && (where & 3))
-		return PCIBIOS_BAD_REGISTER_NUMBER;
-
-	if (loongson_pcibios_config_access(PCI_ACCESS_READ, bus, devfn, where,
-				       &data))
-		return -1;
-
-	if (size == 1)
-		*val = (data >> ((where & 3) << 3)) & 0xff;
-	else if (size == 2)
-		*val = (data >> ((where & 3) << 3)) & 0xffff;
-	else
-		*val = data;
-
-	return PCIBIOS_SUCCESSFUL;
-}
-
-static int loongson_pcibios_write(struct pci_bus *bus, unsigned int devfn,
-			      int where, int size, u32 val)
-{
-	u32 data = 0;
-
-	if ((size == 2) && (where & 1))
-		return PCIBIOS_BAD_REGISTER_NUMBER;
-	else if ((size == 4) && (where & 3))
-		return PCIBIOS_BAD_REGISTER_NUMBER;
-
-	if (size == 4)
-		data = val;
-	else {
-		if (loongson_pcibios_config_access(PCI_ACCESS_READ, bus, devfn,
-					where, &data))
-			return -1;
-
-		if (size == 1)
-			data = (data & ~(0xff << ((where & 3) << 3))) |
-				(val << ((where & 3) << 3));
-		else if (size == 2)
-			data = (data & ~(0xffff << ((where & 3) << 3))) |
-				(val << ((where & 3) << 3));
-	}
-
-	if (loongson_pcibios_config_access(PCI_ACCESS_WRITE, bus, devfn, where,
-				       &data))
-		return -1;
-
-	return PCIBIOS_SUCCESSFUL;
-}
-
-struct pci_ops loongson_pci_ops = {
-	.read = loongson_pcibios_read,
-	.write = loongson_pcibios_write
-};
diff --git a/arch/mips/pci/ops-loongson2.c b/arch/mips/pci/ops-loongson2.c
new file mode 100644
index 0000000..7352142
--- /dev/null
+++ b/arch/mips/pci/ops-loongson2.c
@@ -0,0 +1,207 @@
+/*
+ * fuloong2e specific PCI support.
+ *
+ * Copyright (C) 1999, 2000, 2004  MIPS Technologies, Inc.
+ *	All rights reserved.
+ *	Authors: Carsten Langgaard <carstenl@mips.com>
+ *		 Maciej W. Rozycki <macro@mips.com>
+ *
+ * Copyright (C) 2009 Lemote Inc.
+ * Author: Wu Zhangjin <wuzj@lemote.com>
+ *
+ *  This program is free software; you can distribute it and/or modify it
+ *  under the terms of the GNU General Public License (Version 2) as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+
+#include <loongson.h>
+
+#ifdef CONFIG_CS5536
+#include <cs5536/cs5536_pci.h>
+#include <cs5536/cs5536.h>
+#endif
+
+#define PCI_ACCESS_READ  0
+#define PCI_ACCESS_WRITE 1
+
+#define CFG_SPACE_REG(offset) \
+	(void *)CKSEG1ADDR(LOONGSON_PCICFG_BASE | (offset))
+#define ID_SEL_BEGIN 11
+#define MAX_DEV_NUM (31 - ID_SEL_BEGIN)
+
+
+static int loongson_pcibios_config_access(unsigned char access_type,
+				      struct pci_bus *bus,
+				      unsigned int devfn, int where,
+				      u32 *data)
+{
+	u32 busnum = bus->number;
+	u32 addr, type;
+	u32 dummy;
+	void *addrp;
+	int device = PCI_SLOT(devfn);
+	int function = PCI_FUNC(devfn);
+	int reg = where & ~3;
+
+	if (busnum == 0) {
+		/* board-specific part,currently,only fuloong2f,yeeloong2f
+		 * use CS5536, fuloong2e use via686b, gdium has no
+		 * south bridge
+		 */
+#ifdef CONFIG_CS5536
+		/* cs5536_pci_conf_read4/write4() will call _rdmsr/_wrmsr()
+		 * to access the regsters 0xf4,0xf8,0xfc, which is bigger than
+		 * 0xf0, so, it will not go this branch, but the others. so,
+		 * no calling dead loop here.
+		 */
+		if ((PCI_IDSEL_CS5536 == device) && (reg < 0xF0)) {
+			switch (access_type) {
+			case PCI_ACCESS_READ:
+				*data = cs5536_pci_conf_read4(function, reg);
+				break;
+			case PCI_ACCESS_WRITE:
+				cs5536_pci_conf_write4(function, reg, *data);
+				break;
+			}
+			return 0;
+		}
+#endif
+		/* Type 0 configuration for onboard PCI bus */
+		if (device > MAX_DEV_NUM)
+			return -1;
+
+		addr = (1 << (device + ID_SEL_BEGIN)) | (function << 8) | reg;
+		type = 0;
+	} else {
+		/* Type 1 configuration for offboard PCI bus */
+		addr = (busnum << 16) | (device << 11) | (function << 8) | reg;
+		type = 0x10000;
+	}
+
+	/* Clear aborts */
+	LOONGSON_PCICMD |= LOONGSON_PCICMD_MABORT_CLR | \
+				LOONGSON_PCICMD_MTABORT_CLR;
+
+	LOONGSON_PCIMAP_CFG = (addr >> 16) | type;
+
+	/* Flush Bonito register block */
+	dummy = LOONGSON_PCIMAP_CFG;
+	mmiowb();
+
+	addrp = CFG_SPACE_REG(addr & 0xffff);
+	if (access_type == PCI_ACCESS_WRITE)
+		writel(cpu_to_le32(*data), addrp);
+	else
+		*data = le32_to_cpu(readl(addrp));
+
+	/* Detect Master/Target abort */
+	if (LOONGSON_PCICMD & (LOONGSON_PCICMD_MABORT_CLR |
+			     LOONGSON_PCICMD_MTABORT_CLR)) {
+		/* Error occurred */
+
+		/* Clear bits */
+		LOONGSON_PCICMD |= (LOONGSON_PCICMD_MABORT_CLR |
+				  LOONGSON_PCICMD_MTABORT_CLR);
+
+		return -1;
+	}
+
+	return 0;
+
+}
+
+
+/*
+ * We can't address 8 and 16 bit words directly.  Instead we have to
+ * read/write a 32bit word and mask/modify the data we actually want.
+ */
+static int loongson_pcibios_read(struct pci_bus *bus, unsigned int devfn,
+			     int where, int size, u32 *val)
+{
+	u32 data = 0;
+
+	if ((size == 2) && (where & 1))
+		return PCIBIOS_BAD_REGISTER_NUMBER;
+	else if ((size == 4) && (where & 3))
+		return PCIBIOS_BAD_REGISTER_NUMBER;
+
+	if (loongson_pcibios_config_access(PCI_ACCESS_READ, bus, devfn, where,
+				       &data))
+		return -1;
+
+	if (size == 1)
+		*val = (data >> ((where & 3) << 3)) & 0xff;
+	else if (size == 2)
+		*val = (data >> ((where & 3) << 3)) & 0xffff;
+	else
+		*val = data;
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static int loongson_pcibios_write(struct pci_bus *bus, unsigned int devfn,
+			      int where, int size, u32 val)
+{
+	u32 data = 0;
+
+	if ((size == 2) && (where & 1))
+		return PCIBIOS_BAD_REGISTER_NUMBER;
+	else if ((size == 4) && (where & 3))
+		return PCIBIOS_BAD_REGISTER_NUMBER;
+
+	if (size == 4)
+		data = val;
+	else {
+		if (loongson_pcibios_config_access(PCI_ACCESS_READ, bus, devfn,
+					where, &data))
+			return -1;
+
+		if (size == 1)
+			data = (data & ~(0xff << ((where & 3) << 3))) |
+				(val << ((where & 3) << 3));
+		else if (size == 2)
+			data = (data & ~(0xffff << ((where & 3) << 3))) |
+				(val << ((where & 3) << 3));
+	}
+
+	if (loongson_pcibios_config_access(PCI_ACCESS_WRITE, bus, devfn, where,
+				       &data))
+		return -1;
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+struct pci_ops loongson_pci_ops = {
+	.read = loongson_pcibios_read,
+	.write = loongson_pcibios_write
+};
+
+#ifdef CONFIG_CS5536
+void _rdmsr(u32 msr, u32 *hi, u32 *lo)
+{
+	struct pci_bus bus = {
+		.number = PCI_BUS_CS5536
+	};
+	u32 devfn = PCI_DEVFN(PCI_IDSEL_CS5536, 0);
+	loongson_pcibios_write(&bus, devfn, PCI_MSR_ADDR, 4, msr);
+	loongson_pcibios_read(&bus, devfn, PCI_MSR_DATA_LO, 4, lo);
+	loongson_pcibios_read(&bus, devfn, PCI_MSR_DATA_HI, 4, hi);
+}
+EXPORT_SYMBOL(_rdmsr);
+
+void _wrmsr(u32 msr, u32 hi, u32 lo)
+{
+	struct pci_bus bus = {
+		.number = PCI_BUS_CS5536
+	};
+	u32 devfn = PCI_DEVFN(PCI_IDSEL_CS5536, 0);
+	loongson_pcibios_write(&bus, devfn, PCI_MSR_ADDR, 4, msr);
+	loongson_pcibios_write(&bus, devfn, PCI_MSR_DATA_LO, 4, lo);
+	loongson_pcibios_write(&bus, devfn, PCI_MSR_DATA_HI, 4, hi);
+}
+EXPORT_SYMBOL(_wrmsr);
+#endif
-- 
1.6.2.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbZKDJFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbZKDJFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 04:05:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbZKDJFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 04:05:08 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:33321 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZKDJFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 04:05:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kse6/1/K3RCobzPQvIdfTlZ9LHzs3tbF0JypIFigIg6BL82mjDjMqZxSuBAo4G0Xnk
         A7DEJvglr+N0LmhuGAssRHLv0UgmPt4/nkammacldBXmZcpk+Xch8Qq4hocgyyKROSuq
         YVDV+nKUGWaT+vcX/PQDoI3jM42T/3r5HLAAQ=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, linux-mips@linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>, huhb@lemote.com, yanh@lemote.com,
       Zhang Le <r0bertz@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       liujl@lemote.com
Subject: [PATCH -queue v0 1/6] [loongson] add basic loongson-2f support
Date: Wed,  4 Nov 2009 17:04:47 +0800
Message-Id: <a1bd2470bc465e505281c761adca8c2287d102b3.1257325319.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1257325319.git.wuzhangjin@gmail.com>
References: <cover.1257325319.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loongson2F has built-in DDR2 and PCIX controller. The PCIX controller
have a similar programming interface with FPGA northbridge used in
Loongson2E.

The main differences between loongson-2e and loongson-2f include:

1. loongson-2f has an extra address windows configuration module, which
can be used to map CPU address space to DDR or PCI address space, or map
the PCI-DMA address space to DDR or LIO address space.

2. loongson-2f support 8 levels of software configurable cpu frequency,
which can be configured via a register(LOONGSON_CHIPCFG0).  the coming
cpufreq and standby support are based on this feature.

herein, the module and the corresponding operations are abstracted to
loongson.h.

besides, the other loongson2f-specific source code are added here,
including gcc 4.4 support, pci memory space, pci io space, dma address.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/Kconfig                                  |   18 ++++
 arch/mips/Makefile                                 |    2 +
 .../mips/include/asm/mach-loongson/dma-coherence.h |    4 +
 arch/mips/include/asm/mach-loongson/loongson.h     |   84 +++++++++++++++++++-
 arch/mips/include/asm/mach-loongson/mem.h          |   25 ++++--
 arch/mips/include/asm/mach-loongson/pci.h          |   28 ++++++-
 arch/mips/loongson/common/bonito-irq.c             |    5 +
 arch/mips/loongson/common/init.c                   |   18 ++++
 arch/mips/loongson/common/mem.c                    |   17 ++++
 arch/mips/loongson/common/pci.c                    |    8 ++
 10 files changed, 199 insertions(+), 10 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index ae9fa98..8417357 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1059,6 +1059,21 @@ config CPU_LOONGSON2E
 	  The Loongson 2E processor implements the MIPS III instruction set
 	  with many extensions.
 
+	  It has an internal FPGA northbridge, which is compatiable to
+	  bonito64.
+
+config CPU_LOONGSON2F
+	bool "Loongson 2F"
+	depends on SYS_HAS_CPU_LOONGSON2F
+	select CPU_LOONGSON2
+	help
+	  The Loongson 2F processor implements the MIPS III instruction set
+	  with many extensions.
+
+	  Loongson2F have built-in DDR2 and PCIX controller. The PCIX controller
+	  have a similar programming interface with FPGA northbridge used in
+	  Loongson2E.
+
 config CPU_MIPS32_R1
 	bool "MIPS32 Release 1"
 	depends on SYS_HAS_CPU_MIPS32_R1
@@ -1303,6 +1318,9 @@ config CPU_LOONGSON2
 config SYS_HAS_CPU_LOONGSON2E
 	bool
 
+config SYS_HAS_CPU_LOONGSON2F
+	bool
+
 config SYS_HAS_CPU_MIPS32_R1
 	bool
 
diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index ba04782..47ecded 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -125,6 +125,8 @@ cflags-$(CONFIG_CPU_TX49XX)	+= -march=r4600 -Wa,--trap
 cflags-$(CONFIG_CPU_LOONGSON2)	+= -Wa,--trap
 cflags-$(CONFIG_CPU_LOONGSON2E) += \
 	$(call cc-option,-march=loongson2e,-march=r4600)
+cflags-$(CONFIG_CPU_LOONGSON2F) += \
+	$(call cc-option,-march=loongson2f,-march=r4600)
 
 cflags-$(CONFIG_CPU_MIPS32_R1)	+= $(call cc-option,-march=mips32,-mips32 -U_MIPS_ISA -D_MIPS_ISA=_MIPS_ISA_MIPS32) \
 			-Wa,-mips32 -Wa,--trap
diff --git a/arch/mips/include/asm/mach-loongson/dma-coherence.h b/arch/mips/include/asm/mach-loongson/dma-coherence.h
index 71a6851..981c75f 100644
--- a/arch/mips/include/asm/mach-loongson/dma-coherence.h
+++ b/arch/mips/include/asm/mach-loongson/dma-coherence.h
@@ -28,7 +28,11 @@ static inline dma_addr_t plat_map_dma_mem_page(struct device *dev,
 static inline unsigned long plat_dma_addr_to_phys(struct device *dev,
 	dma_addr_t dma_addr)
 {
+#if defined(CONFIG_CPU_LOONGSON2F) && defined(CONFIG_64BIT)
+	return (dma_addr > 0x8fffffff) ? dma_addr : (dma_addr & 0x0fffffff);
+#else
 	return dma_addr & 0x7fffffff;
+#endif
 }
 
 static inline void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr,
diff --git a/arch/mips/include/asm/mach-loongson/loongson.h b/arch/mips/include/asm/mach-loongson/loongson.h
index e6869aa..9e41469 100644
--- a/arch/mips/include/asm/mach-loongson/loongson.h
+++ b/arch/mips/include/asm/mach-loongson/loongson.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
+ * Copyright (C) 2009 Lemote, Inc.
  * Author: Wu Zhangjin <wuzj@lemote.com>
  *
  * This program is free software; you can redistribute  it and/or modify it
@@ -215,4 +215,86 @@ extern void mach_irq_dispatch(unsigned int pending);
 #define LOONGSON_PCIMAP_WIN(WIN, ADDR)	\
 	((((ADDR)>>26) & LOONGSON_PCIMAP_PCIMAP_LO0) << ((WIN)*6))
 
+/* Chip Config */
+#ifdef CONFIG_CPU_LOONGSON2F
+#define LOONGSON_CHIPCFG0		LOONGSON_REG(LOONGSON_REGBASE + 0x80)
+#endif
+
+/*
+ * address windows configuration module
+ *
+ * loongson2e do not have this module
+ */
+#if defined(CONFIG_CPU_LOONGSON2F) && defined(CONFIG_64BIT)
+
+/* address window config module base address */
+#define LOONGSON_ADDRWINCFG_BASE		0x3ff00000ul
+#define LOONGSON_ADDRWINCFG_SIZE		0x180
+
+extern unsigned long _loongson_addrwincfg_base;
+#define LOONGSON_ADDRWINCFG(offset) \
+	(*(volatile u64 *)(_loongson_addrwincfg_base + (offset)))
+
+#define CPU_WIN0_BASE	LOONGSON_ADDRWINCFG(0x00)
+#define CPU_WIN1_BASE	LOONGSON_ADDRWINCFG(0x08)
+#define CPU_WIN2_BASE	LOONGSON_ADDRWINCFG(0x10)
+#define CPU_WIN3_BASE	LOONGSON_ADDRWINCFG(0x18)
+
+#define CPU_WIN0_MASK	LOONGSON_ADDRWINCFG(0x20)
+#define CPU_WIN1_MASK	LOONGSON_ADDRWINCFG(0x28)
+#define CPU_WIN2_MASK	LOONGSON_ADDRWINCFG(0x30)
+#define CPU_WIN3_MASK	LOONGSON_ADDRWINCFG(0x38)
+
+#define CPU_WIN0_MMAP	LOONGSON_ADDRWINCFG(0x40)
+#define CPU_WIN1_MMAP	LOONGSON_ADDRWINCFG(0x48)
+#define CPU_WIN2_MMAP	LOONGSON_ADDRWINCFG(0x50)
+#define CPU_WIN3_MMAP	LOONGSON_ADDRWINCFG(0x58)
+
+#define PCIDMA_WIN0_BASE	LOONGSON_ADDRWINCFG(0x60)
+#define PCIDMA_WIN1_BASE	LOONGSON_ADDRWINCFG(0x68)
+#define PCIDMA_WIN2_BASE	LOONGSON_ADDRWINCFG(0x70)
+#define PCIDMA_WIN3_BASE	LOONGSON_ADDRWINCFG(0x78)
+
+#define PCIDMA_WIN0_MASK	LOONGSON_ADDRWINCFG(0x80)
+#define PCIDMA_WIN1_MASK	LOONGSON_ADDRWINCFG(0x88)
+#define PCIDMA_WIN2_MASK	LOONGSON_ADDRWINCFG(0x90)
+#define PCIDMA_WIN3_MASK	LOONGSON_ADDRWINCFG(0x98)
+
+#define PCIDMA_WIN0_MMAP	LOONGSON_ADDRWINCFG(0xa0)
+#define PCIDMA_WIN1_MMAP	LOONGSON_ADDRWINCFG(0xa8)
+#define PCIDMA_WIN2_MMAP	LOONGSON_ADDRWINCFG(0xb0)
+#define PCIDMA_WIN3_MMAP	LOONGSON_ADDRWINCFG(0xb8)
+
+#define ADDRWIN_WIN0	0
+#define ADDRWIN_WIN1	1
+#define ADDRWIN_WIN2	2
+#define ADDRWIN_WIN3	3
+
+#define ADDRWIN_MAP_DST_DDR	0
+#define ADDRWIN_MAP_DST_PCI	1
+#define ADDRWIN_MAP_DST_LIO	1
+
+/*
+ * s: CPU, PCIDMA
+ * d: DDR, PCI, LIO
+ * win: 0, 1, 2, 3
+ * src: map source
+ * dst: map destination
+ * size: ~mask + 1
+ */
+#define LOONGSON_ADDRWIN_CFG(s, d, w, src, dst, size) do {\
+	s##_WIN##w##_BASE = (src); \
+	s##_WIN##w##_MMAP = (src) | ADDRWIN_MAP_DST_##d; \
+	s##_WIN##w##_MASK = ~(size-1); \
+} while (0)
+
+#define LOONGSON_ADDRWIN_CPUTOPCI(win, src, dst, size) \
+	LOONGSON_ADDRWIN_CFG(CPU, PCI, win, src, dst, size)
+#define LOONGSON_ADDRWIN_CPUTODDR(win, src, dst, size) \
+	LOONGSON_ADDRWIN_CFG(CPU, DDR, win, src, dst, size)
+#define LOONGSON_ADDRWIN_PCITODDR(win, src, dst, size) \
+	LOONGSON_ADDRWIN_CFG(PCIDMA, DDR, win, src, dst, size)
+
+#endif	/* ! CONFIG_CPU_LOONGSON2F && CONFIG_64BIT */
+
 #endif /* __ASM_MACH_LOONGSON_LOONGSON_H */
diff --git a/arch/mips/include/asm/mach-loongson/mem.h b/arch/mips/include/asm/mach-loongson/mem.h
index bd7b3cb..5c6551d 100644
--- a/arch/mips/include/asm/mach-loongson/mem.h
+++ b/arch/mips/include/asm/mach-loongson/mem.h
@@ -12,19 +12,30 @@
 #define __ASM_MACH_LOONGSON_MEM_H
 
 /*
- * On Lemote Loongson 2e
+ * high memory space
  *
- * the high memory space starts from 512M.
- * the peripheral registers reside between 0x1000:0000 and 0x2000:0000.
+ * in loongson2e, starts from 512M
+ * in loongson2f, starts from 2G 256M
  */
+#ifdef CONFIG_CPU_LOONGSON2E
+#define LOONGSON_HIGHMEM_START	0x20000000
+#else
+#define LOONGSON_HIGHMEM_START	0x90000000
+#endif
 
-#ifdef CONFIG_LEMOTE_FULOONG2E
-
-#define LOONGSON_HIGHMEM_START  0x20000000
+/*
+ * the peripheral registers(MMIO):
+ *
+ * On the Lemote Loongson 2e system, reside between 0x1000:0000 and 0x2000:0000.
+ * On the Lemote Loongson 2f system, reside between 0x1000:0000 and 0x8000:0000.
+ */
 
 #define LOONGSON_MMIO_MEM_START 0x10000000
-#define LOONGSON_MMIO_MEM_END   0x20000000
 
+#ifdef CONFIG_CPU_LOONGSON2E
+#define LOONGSON_MMIO_MEM_END	0x20000000
+#else
+#define LOONGSON_MMIO_MEM_END	0x80000000
 #endif
 
 #endif /* __ASM_MACH_LOONGSON_MEM_H */
diff --git a/arch/mips/include/asm/mach-loongson/pci.h b/arch/mips/include/asm/mach-loongson/pci.h
index 576487c..31ba908 100644
--- a/arch/mips/include/asm/mach-loongson/pci.h
+++ b/arch/mips/include/asm/mach-loongson/pci.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2008 Zhang Le <r0bertz@gentoo.org>
+ * Copyright (c) 2009 Wu Zhangjin <wuzj@lemote.com>
  *
  * This program is free software; you can redistribute it
  * and/or modify it under the terms of the GNU General
@@ -24,7 +25,30 @@
 
 extern struct pci_ops loongson_pci_ops;
 
-#ifdef CONFIG_LEMOTE_FULOONG2E
+/* this is an offset from mips_io_port_base */
+#define LOONGSON_PCI_IO_START	0x00004000UL
+
+#if defined(CONFIG_CPU_LOONGSON2F) && defined(CONFIG_64BIT)
+
+/*
+ * we use address window2 to map cpu address space to pci space
+ * window2: cpu [1G, 2G] -> pci [1G, 2G]
+ * why not use window 0 & 1? because they are used by cpu when booting.
+ * window0: cpu [0, 256M] -> ddr [0, 256M]
+ * window1: cpu [256M, 512M] -> pci [256M, 512M]
+ */
+
+/* the smallest LOONGSON_CPU_MEM_SRC can be 512M */
+#define LOONGSON_CPU_MEM_SRC	0x40000000ul		/* 1G */
+#define LOONGSON_PCI_MEM_DST	LOONGSON_CPU_MEM_SRC
+
+#define LOONGSON_PCI_MEM_START	LOONGSON_PCI_MEM_DST
+#define LOONGSON_PCI_MEM_END	(0x80000000ul-1)	/* 2G */
+
+#define MMAP_CPUTOPCI_SIZE	(LOONGSON_PCI_MEM_END - \
+					LOONGSON_PCI_MEM_START + 1)
+
+#else	/* loongson2f/32bit & loongson2e */
 
 /* this pci memory space is mapped by pcimap in pci.c */
 #define LOONGSON_PCI_MEM_START	LOONGSON_PCILO1_BASE
@@ -32,6 +56,6 @@ extern struct pci_ops loongson_pci_ops;
 /* this is an offset from mips_io_port_base */
 #define LOONGSON_PCI_IO_START	0x00004000UL
 
-#endif
+#endif	/* !(defined(CONFIG_CPU_LOONGSON2F) && defined(CONFIG_64BIT))*/
 
 #endif /* !__ASM_MACH_LOONGSON_PCI_H_ */
diff --git a/arch/mips/loongson/common/bonito-irq.c b/arch/mips/loongson/common/bonito-irq.c
index a1cbd11..9c1ddae 100644
--- a/arch/mips/loongson/common/bonito-irq.c
+++ b/arch/mips/loongson/common/bonito-irq.c
@@ -35,10 +35,13 @@ static struct irq_chip bonito_irq_type = {
 	.unmask	= bonito_irq_enable,
 };
 
+/* there is no need to handle dma timeout in loongson-2f based machines */
+#ifdef CONFIG_CPU_LOONGSON2E
 static struct irqaction dma_timeout_irqaction = {
 	.handler	= no_action,
 	.name		= "dma_timeout",
 };
+#endif
 
 void bonito_irq_init(void)
 {
@@ -47,5 +50,7 @@ void bonito_irq_init(void)
 	for (i = LOONGSON_IRQ_BASE; i < LOONGSON_IRQ_BASE + 32; i++)
 		set_irq_chip_and_handler(i, &bonito_irq_type, handle_level_irq);
 
+#ifdef CONFIG_CPU_LOONGSON2E
 	setup_irq(LOONGSON_IRQ_BASE + 10, &dma_timeout_irqaction);
+#endif
 }
diff --git a/arch/mips/loongson/common/init.c b/arch/mips/loongson/common/init.c
index b7e4913..4afca97 100644
--- a/arch/mips/loongson/common/init.c
+++ b/arch/mips/loongson/common/init.c
@@ -14,12 +14,30 @@
 
 #include <loongson.h>
 
+#if defined(CONFIG_CPU_LOONGSON2F) && defined(CONFIG_64BIT)
+unsigned long _loongson_addrwincfg_base;
+
+/* Loongson CPU address windows config space base address */
+static inline void set_loongson_addrwincfg_base(void)
+{
+	*(unsigned long *)&_loongson_addrwincfg_base = (unsigned long)
+		ioremap(LOONGSON_ADDRWINCFG_BASE, LOONGSON_ADDRWINCFG_SIZE);
+	barrier();
+}
+#else
+static inline void set_loongson_addrwincfg_base(void)
+{
+}
+#endif
+
 void __init prom_init(void)
 {
     /* init base address of io space */
 	set_io_port_base((unsigned long)
 		ioremap(LOONGSON_PCIIO_BASE, LOONGSON_PCIIO_SIZE));
 
+	set_loongson_addrwincfg_base();
+
 	prom_init_cmdline();
 	prom_init_env();
 	prom_init_memory();
diff --git a/arch/mips/loongson/common/mem.c b/arch/mips/loongson/common/mem.c
index 47a20de..45991af 100644
--- a/arch/mips/loongson/common/mem.c
+++ b/arch/mips/loongson/common/mem.c
@@ -21,6 +21,23 @@ void __init prom_init_memory(void)
     add_memory_region(memsize << 20, LOONGSON_PCI_MEM_START - (memsize <<
 			    20), BOOT_MEM_RESERVED);
 #ifdef CONFIG_64BIT
+#ifdef CONFIG_CPU_LOONGSON2F
+	{
+		int bit;
+
+		bit = fls(memsize + highmemsize);
+		if (bit != ffs(memsize + highmemsize))
+			bit += 20;
+		else
+			bit = bit + 20 - 1;
+
+		/* set cpu window3 to map CPU to DDR: 2G -> 2G */
+		LOONGSON_ADDRWIN_CPUTODDR(ADDRWIN_WIN3, 0x80000000ul,
+					  0x80000000ul, (1 << bit));
+		mmiowb();
+	}
+#endif	/* CONFIG_CPU_LOONGSON2F */
+
     if (highmemsize > 0)
 	add_memory_region(LOONGSON_HIGHMEM_START,
 		highmemsize << 20, BOOT_MEM_RAM);
diff --git a/arch/mips/loongson/common/pci.c b/arch/mips/loongson/common/pci.c
index a7eb8b9..eac43b8 100644
--- a/arch/mips/loongson/common/pci.c
+++ b/arch/mips/loongson/common/pci.c
@@ -67,6 +67,14 @@ static void __init setup_pcimap(void)
 	/* can not change gnt to break pci transfer when device's gnt not
 	deassert for some broken device */
 	LOONGSON_PXARB_CFG = 0x00fe0105ul;
+
+#if defined(CONFIG_CPU_LOONGSON2F) && defined(CONFIG_64BIT)
+	/*
+	 * set cpu addr window2 to map CPU address space to PCI address space
+	 */
+	LOONGSON_ADDRWIN_CPUTOPCI(ADDRWIN_WIN2, LOONGSON_CPU_MEM_SRC,
+		LOONGSON_PCI_MEM_DST, MMAP_CPUTOPCI_SIZE);
+#endif
 }
 
 static int __init pcibios_init(void)
-- 
1.6.2.1


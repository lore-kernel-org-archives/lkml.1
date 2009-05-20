Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbZETWdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbZETWdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 18:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbZETWde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 18:33:34 -0400
Received: from mail-px0-f171.google.com ([209.85.216.171]:58519 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbZETWdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 18:33:33 -0400
X-Greylist: delayed 1284 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 May 2009 18:33:33 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wjbojeMx51fbXCECd90+0OZ5e5smHXZIvEccMNSl2BgpdCc6UtfSgkIAVAt/3mCaBM
         1PSfiAU73NGZCRKqNXqaIcQmGd6zxTPiXF7k9Gam6z3UuIorqJYo5knggGHgpXF3aR9P
         E0iP0fRdEf/D1jZPuGuOVXu32xC09eUean6iM=
From: wuzhangjin@gmail.com
To: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Wu Zhangjin <wuzhangjin@gmail.com>,
       Yan hua <yanh@lemote.com>, Philippe Vachon <philippe@cowpig.ca>,
       Zhang Le <r0bertz@gentoo.org>, Zhang Fuxin <zhangfx@lemote.com>,
       Arnaud Patard <apatard@mandriva.com>, loongson-dev@googlegroups.com,
       gnewsense-dev@nongnu.org, Nicholas Mc Guire <hofrat@hofr.at>,
       Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>
Subject: [loongson-PATCH-v1 12/27] add basic loongson-2f support
Date: Thu, 21 May 2009 06:05:19 +0800
Message-Id: <99d05416b4e26467587f52fbd6c67788baeb4747.1242855716.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1242855716.git.wuzhangjin@gmail.com>
References: <cover.1242855716.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

Loongson2F has built-in DDR2 and PCIX controller. The PCIX controller
have a similar programming interface with FPGA northbridge used in
Loongson2E.

so, the main difference between loongson-2e and loongson-2f is:

loongson-2f has an extra address windows configuration module, which can
be used to map CPU address space to DDR or PCI address space, or map the
PCI-DMA address space to DDR or LIO address space.

herein, the module and the operations are abstracted to loongson.h.

NOTE: this module is only available in 64bit kernel.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/Kconfig                                  |   18 +++++
 .../mips/include/asm/mach-loongson/dma-coherence.h |    4 +
 arch/mips/include/asm/mach-loongson/loongson.h     |   79 +++++++++++++++++++-
 arch/mips/include/asm/mach-loongson/mem.h          |   23 ++++++
 arch/mips/include/asm/mach-loongson/pci.h          |   30 +++++++-
 arch/mips/loongson/common/init.c                   |   17 ++++
 arch/mips/loongson/common/mem.c                    |   21 ++++-
 arch/mips/loongson/common/pci.c                    |   14 +++-
 8 files changed, 197 insertions(+), 9 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index b5581d6..2aaa4d0 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1008,6 +1008,21 @@ config CPU_LOONGSON2E
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
@@ -1255,6 +1270,9 @@ config CPU_LOONGSON2
 config SYS_HAS_CPU_LOONGSON2E
 	bool
 
+config SYS_HAS_CPU_LOONGSON2F
+	bool
+
 config SYS_HAS_CPU_MIPS32_R1
 	bool
 
diff --git a/arch/mips/include/asm/mach-loongson/dma-coherence.h b/arch/mips/include/asm/mach-loongson/dma-coherence.h
index f27d0f8..6ba8279 100644
--- a/arch/mips/include/asm/mach-loongson/dma-coherence.h
+++ b/arch/mips/include/asm/mach-loongson/dma-coherence.h
@@ -27,7 +27,11 @@ static inline dma_addr_t plat_map_dma_mem_page(struct device *dev,
 
 static inline unsigned long plat_dma_addr_to_phys(dma_addr_t dma_addr)
 {
+#if defined(CONFIG_CPU_LOONGSON2F) & defined(CONFIG_64BIT)
+	return (dma_addr > 0x8fffffff) ? dma_addr : (dma_addr & 0x0fffffff);
+#else
 	return dma_addr & 0x7fffffff;
+#endif
 }
 
 static inline void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr)
diff --git a/arch/mips/include/asm/mach-loongson/loongson.h b/arch/mips/include/asm/mach-loongson/loongson.h
index 29c9730..8ddfbd3 100644
--- a/arch/mips/include/asm/mach-loongson/loongson.h
+++ b/arch/mips/include/asm/mach-loongson/loongson.h
@@ -221,5 +221,82 @@ extern void mach_prepare_shutdown(void);
 #define LOONGSON_PCIMAP_WIN(WIN, ADDR)	\
 	((((ADDR)>>26) & LOONGSON_PCIMAP_PCIMAP_LO0) << ((WIN)*6))
 
-#endif				/* __LOONGSON_H */
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
+	(*(u64 *)(_loongson_addrwincfg_base + (offset)))
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
+} while (0);
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
+#endif	/* __LOONGSON_H */
 
diff --git a/arch/mips/include/asm/mach-loongson/mem.h b/arch/mips/include/asm/mach-loongson/mem.h
index ad01dc2..fb53be0 100644
--- a/arch/mips/include/asm/mach-loongson/mem.h
+++ b/arch/mips/include/asm/mach-loongson/mem.h
@@ -1,8 +1,31 @@
 #ifndef __MEM_H
 #define __MEM_H
 
+/*
+ * high memory space
+ *
+ * in loongson2e, starts from 512M
+ * in loongson2f, starts from 2G + 256M
+ */
+#ifdef CONFIG_CPU_LOONGSON2E
 #define LOONGSON_HIGHMEM_START	0x20000000
+#else
+#define LOONGSON_HIGHMEM_START	0x90000000
+#endif
+
+/*
+ * the peripheral registers(MMIO):
+ *
+ * On the Lemote Loongson 2e system, reside between 0x1000:0000 and 0x2000:0000.
+ * On the Lemote Loongson 2f system, reside between 0x1000:0000 and 0x8000:0000.
+ */
+
 #define LOONGSON_MMIO_MEM_START 0x10000000
+
+#ifdef CONFIG_CPU_LOONGSON2E
 #define LOONGSON_MMIO_MEM_END	0x20000000
+#else
+#define LOONGSON_MMIO_MEM_END	0x80000000
+#endif
 
 #endif	/* !__MEM_H */
diff --git a/arch/mips/include/asm/mach-loongson/pci.h b/arch/mips/include/asm/mach-loongson/pci.h
index 8f02486..cdec41c 100644
--- a/arch/mips/include/asm/mach-loongson/pci.h
+++ b/arch/mips/include/asm/mach-loongson/pci.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2008 Zhang Le <r0bertz@gentoo.org>
+ * Copyright (c) 2009 Wu Zhangjin <wuzj@lemote.com>
  *
  * This program is free software; you can redistribute it
  * and/or modify it under the terms of the GNU General
@@ -24,8 +25,35 @@
 
 extern struct pci_ops loongson_pci_ops;
 
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
+
 #define LOONGSON_PCI_MEM_START	0x14000000UL
 #define LOONGSON_PCI_MEM_END	0x1fffffffUL
-#define LOONGSON_PCI_IO_START	0x00004000UL
+
+#endif	/* !(defined(CONFIG_CPU_LOONGSON2F) && defined(CONFIG_64BIT))*/
+
 
 #endif /* !_LOONGSON_PCI_H_ */
diff --git a/arch/mips/loongson/common/init.c b/arch/mips/loongson/common/init.c
index 76e6fda..9bbd06f 100644
--- a/arch/mips/loongson/common/init.c
+++ b/arch/mips/loongson/common/init.c
@@ -22,6 +22,17 @@
 
 #include <loongson.h>
 
+#if defined(CONFIG_CPU_LOONGSON2F) && defined(CONFIG_64BIT)
+unsigned long _loongson_addrwincfg_base;
+
+/* Loongson CPU address windows config space base address */
+static inline void set_loongson_addrwincfg_base(unsigned long base)
+{
+	*(unsigned long *)&_loongson_addrwincfg_base = base;
+	barrier();
+}
+#endif
+
 void __init prom_init(void)
 {
 	/* init mach type, does we need to init it?? */
@@ -31,6 +42,12 @@ void __init prom_init(void)
 	set_io_port_base((unsigned long)
 			 ioremap(LOONGSON_PCIIO_BASE, LOONGSON_PCIIO_SIZE));
 
+#if defined(CONFIG_CPU_LOONGSON2F) && defined(CONFIG_64BIT)
+	set_loongson_addrwincfg_base((unsigned long)
+				     ioremap(LOONGSON_ADDRWINCFG_BASE,
+					     LOONGSON_ADDRWINCFG_SIZE));
+#endif
+
 	prom_init_cmdline();
 	prom_init_memory();
 }
diff --git a/arch/mips/loongson/common/mem.c b/arch/mips/loongson/common/mem.c
index 17a7278..9e0b6e0 100644
--- a/arch/mips/loongson/common/mem.c
+++ b/arch/mips/loongson/common/mem.c
@@ -17,6 +17,23 @@ void __init prom_init_memory(void)
 {
 	add_memory_region(0x0, (memsize << 20), BOOT_MEM_RAM);
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
+#endif				/* CONFIG_CPU_LOONGSON2F */
+
 	if (highmemsize > 0) {
 		add_memory_region(LOONGSON_HIGHMEM_START,
 				  highmemsize << 20, BOOT_MEM_RAM);
@@ -30,10 +47,6 @@ int __uncached_access(struct file *file, unsigned long addr)
 	if (file->f_flags & O_SYNC)
 		return 1;
 
-	/*
-	 * On the Lemote Loongson 2e system, the peripheral registers
-	 * reside between 0x1000:0000 and 0x2000:0000.
-	 */
 	return addr >= __pa(high_memory) ||
 		((addr >= LOONGSON_MMIO_MEM_START) && \
 			(addr < LOONGSON_MMIO_MEM_END));
diff --git a/arch/mips/loongson/common/pci.c b/arch/mips/loongson/common/pci.c
index e97c845..e8291c3 100644
--- a/arch/mips/loongson/common/pci.c
+++ b/arch/mips/loongson/common/pci.c
@@ -30,15 +30,15 @@
 #include <pci.h>
 
 static struct resource loongson_pci_mem_resource = {
-	.name   = "LOONGSON PCI MEM",
+	.name   = "pci memory space",
 	.start  = LOONGSON_PCI_MEM_START,
 	.end    = LOONGSON_PCI_MEM_END,
 	.flags  = IORESOURCE_MEM,
 };
 
 static struct resource loongson_pci_io_resource = {
-	.name   = "LOONGSON PCI IO MEM",
-	.start  = LOONGSON_PCI_IO_START,
+	.name   = "pci io space",
+	.start  = LOONGSON_PCI_IO_START,	/* reserve regacy I/O space */
 	.end    = IO_SPACE_LIMIT,
 	.flags  = IORESOURCE_IO,
 };
@@ -85,6 +85,14 @@ static void __init ict_pcimap(void)
 	/* can not change gnt to break pci transfer when device's gnt not
 	deassert for some broken device */
 	LOONGSON_PXARB_CFG = 0x00fe0105ul;
+
+#if defined(CONFIG_CPU_LOONGSON2F) && defined(CONFIG_64BIT)
+	/*
+	 * set cpu addr window2 to map CPU address space to PCI address space
+	 */
+	LOONGSON_ADDRWIN_CPUTOPCI(ADDRWIN_WIN2, LOONGSON_CPU_MEM_SRC,
+			LOONGSON_PCI_MEM_DST, MMAP_CPUTOPCI_SIZE);
+#endif
 }
 
 static int __init pcibios_init(void)
-- 
1.6.2.1


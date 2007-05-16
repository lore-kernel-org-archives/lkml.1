Return-Path: <linux-kernel-owner+w=401wt.eu-S1759418AbXEPJ21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418AbXEPJ21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 05:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbXEPJ2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 05:28:20 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:52347 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752203AbXEPJ2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 05:28:17 -0400
Date: Wed, 16 May 2007 11:27:30 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AVR32 update
Message-ID: <20070516112730.794a4c02@dhcp-252-105.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'for-linus' branch of

  git://www.atmel.no/~hskinnemoen/linux/kernel/avr32.git for-linus

to receive the following updates. The bulk of it is board-specific
monitor specs and other data for the atmel_lcdfb driver that was merged
last week.

Christoph Hellwig (1):
      [AVR32] optimize pagefault path

Haavard Skinnemoen (3):
      [AVR32] Remove bogus comment in arch/avr32/kernel/irq.c
      [AVR32] Wire up signalfd, timerfd and eventfd
      [AVR32] Implement platform hooks for atmel_lcdfb driver

 arch/avr32/boards/atstk1000/atstk1000.h |   15 ++++++
 arch/avr32/boards/atstk1000/atstk1002.c |   10 ++--
 arch/avr32/boards/atstk1000/setup.c     |   45 +++++++++++++++++-
 arch/avr32/kernel/irq.c                 |    9 ----
 arch/avr32/kernel/kprobes.c             |    7 +--
 arch/avr32/kernel/syscall_table.S       |    3 +
 arch/avr32/mach-at32ap/at32ap7000.c     |   77 ++++++++++++++++++++++++-------
 arch/avr32/mm/fault.c                   |   36 +++++----------
 include/asm-avr32/arch-at32ap/board.h   |    8 +--
 include/asm-avr32/kdebug.h              |   17 +++++--
 include/asm-avr32/kprobes.h             |    1 +
 include/asm-avr32/unistd.h              |    5 ++-
 12 files changed, 161 insertions(+), 72 deletions(-)
 create mode 100644 arch/avr32/boards/atstk1000/atstk1000.h

diff --git a/arch/avr32/boards/atstk1000/atstk1000.h b/arch/avr32/boards/atstk1000/atstk1000.h
new file mode 100644
index 0000000..9a49ed0
--- /dev/null
+++ b/arch/avr32/boards/atstk1000/atstk1000.h
@@ -0,0 +1,15 @@
+/*
+ * ATSTK1000 setup code: Daughterboard interface
+ *
+ * Copyright (C) 2007 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __ARCH_AVR32_BOARDS_ATSTK1000_ATSTK1000_H
+#define __ARCH_AVR32_BOARDS_ATSTK1000_ATSTK1000_H
+
+extern struct atmel_lcdfb_info atstk1000_lcdc_data;
+
+#endif /* __ARCH_AVR32_BOARDS_ATSTK1000_ATSTK1000_H */
diff --git a/arch/avr32/boards/atstk1000/atstk1002.c b/arch/avr32/boards/atstk1000/atstk1002.c
index abe6ca2..fe1dbe2 100644
--- a/arch/avr32/boards/atstk1000/atstk1002.c
+++ b/arch/avr32/boards/atstk1000/atstk1002.c
@@ -16,6 +16,8 @@
 #include <linux/types.h>
 #include <linux/spi/spi.h>
 
+#include <video/atmel_lcdc.h>
+
 #include <asm/io.h>
 #include <asm/setup.h>
 #include <asm/arch/at32ap7000.h>
@@ -23,6 +25,7 @@
 #include <asm/arch/init.h>
 #include <asm/arch/portmux.h>
 
+#include "atstk1000.h"
 
 #define	SW2_DEFAULT		/* MMCI and UART_A available */
 
@@ -31,9 +34,7 @@ struct eth_addr {
 };
 
 static struct eth_addr __initdata hw_addr[2];
-
 static struct eth_platform_data __initdata eth_data[2];
-static struct lcdc_platform_data atstk1000_fb0_data;
 
 static struct spi_board_info spi0_board_info[] __initdata = {
 	{
@@ -148,9 +149,8 @@ static int __init atstk1002_init(void)
 	set_hw_addr(at32_add_device_eth(0, &eth_data[0]));
 
 	at32_add_device_spi(0, spi0_board_info, ARRAY_SIZE(spi0_board_info));
-	atstk1000_fb0_data.fbmem_start = fbmem_start;
-	atstk1000_fb0_data.fbmem_size = fbmem_size;
-	at32_add_device_lcdc(0, &atstk1000_fb0_data);
+	at32_add_device_lcdc(0, &atstk1000_lcdc_data,
+			     fbmem_start, fbmem_size);
 
 	return 0;
 }
diff --git a/arch/avr32/boards/atstk1000/setup.c b/arch/avr32/boards/atstk1000/setup.c
index 2bc4b88..c9af409 100644
--- a/arch/avr32/boards/atstk1000/setup.c
+++ b/arch/avr32/boards/atstk1000/setup.c
@@ -8,13 +8,56 @@
  * published by the Free Software Foundation.
  */
 #include <linux/bootmem.h>
+#include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/linkage.h>
 
-#include <asm/setup.h>
+#include <video/atmel_lcdc.h>
 
+#include <asm/setup.h>
 #include <asm/arch/board.h>
 
+#include "atstk1000.h"
+
 /* Initialized by bootloader-specific startup code. */
 struct tag *bootloader_tags __initdata;
+
+static struct fb_videomode __initdata ltv350qv_modes[] = {
+	{
+		.name		= "320x240 @ 75",
+		.refresh	= 75,
+		.xres		= 320,		.yres		= 240,
+		.pixclock	= KHZ2PICOS(6891),
+
+		.left_margin	= 17,		.right_margin	= 33,
+		.upper_margin	= 10,		.lower_margin	= 10,
+		.hsync_len	= 16,		.vsync_len	= 1,
+
+		.sync		= 0,
+		.vmode		= FB_VMODE_NONINTERLACED,
+	},
+};
+
+static struct fb_monspecs __initdata atstk1000_default_monspecs = {
+	.manufacturer		= "SNG",
+	.monitor		= "LTV350QV",
+	.modedb			= ltv350qv_modes,
+	.modedb_len		= ARRAY_SIZE(ltv350qv_modes),
+	.hfmin			= 14820,
+	.hfmax			= 22230,
+	.vfmin			= 60,
+	.vfmax			= 90,
+	.dclkmax		= 30000000,
+};
+
+struct atmel_lcdfb_info __initdata atstk1000_lcdc_data = {
+	.default_bpp		= 24,
+	.default_dmacon		= ATMEL_LCDC_DMAEN | ATMEL_LCDC_DMA2DEN,
+	.default_lcdcon2	= (ATMEL_LCDC_DISTYPE_TFT
+				   | ATMEL_LCDC_INVCLK
+				   | ATMEL_LCDC_CLKMOD_ALWAYSACTIVE
+				   | ATMEL_LCDC_MEMOR_BIG),
+	.default_monspecs	= &atstk1000_default_monspecs,
+	.guard_time		= 2,
+};
diff --git a/arch/avr32/kernel/irq.c b/arch/avr32/kernel/irq.c
index fd31124..61f2de2 100644
--- a/arch/avr32/kernel/irq.c
+++ b/arch/avr32/kernel/irq.c
@@ -7,15 +7,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * This file contains the code used by various IRQ handling routines:
- * asking for different IRQ's should be done through these routines
- * instead of just grabbing them. Thus setups with different IRQ numbers
- * shouldn't result in any weird surprises, and installing new handlers
- * should be easier.
- *
- * IRQ's are in fact implemented a bit like signal handlers for the kernel.
- * Naturally it's not a 1:1 relation, but there are similarities.
  */
 
 #include <linux/interrupt.h>
diff --git a/arch/avr32/kernel/kprobes.c b/arch/avr32/kernel/kprobes.c
index 004c94b..4942ee6 100644
--- a/arch/avr32/kernel/kprobes.c
+++ b/arch/avr32/kernel/kprobes.c
@@ -179,7 +179,7 @@ static int __kprobes post_kprobe_handler(struct pt_regs *regs)
 	return 1;
 }
 
-static int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
+int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 {
 	struct kprobe *cur = kprobe_running();
 
@@ -216,11 +216,6 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 		if (post_kprobe_handler(args->regs))
 			ret = NOTIFY_STOP;
 		break;
-	case DIE_FAULT:
-		if (kprobe_running()
-		    && kprobe_fault_handler(args->regs, args->trapnr))
-			ret = NOTIFY_STOP;
-		break;
 	default:
 		break;
 	}
diff --git a/arch/avr32/kernel/syscall_table.S b/arch/avr32/kernel/syscall_table.S
index 07f6a6f..75c81f2 100644
--- a/arch/avr32/kernel/syscall_table.S
+++ b/arch/avr32/kernel/syscall_table.S
@@ -292,4 +292,7 @@ sys_call_table:
 	.long	sys_shmdt
 	.long	sys_shmctl
 	.long	sys_utimensat
+	.long	sys_signalfd
+	.long	sys_timerfd		/* 280 */
+	.long	sys_eventfd
 	.long	sys_ni_syscall		/* r8 is saturated at nr_syscalls */
diff --git a/arch/avr32/mach-at32ap/at32ap7000.c b/arch/avr32/mach-at32ap/at32ap7000.c
index 56db45b..1d2bf34 100644
--- a/arch/avr32/mach-at32ap/at32ap7000.c
+++ b/arch/avr32/mach-at32ap/at32ap7000.c
@@ -6,6 +6,7 @@
  * published by the Free Software Foundation.
  */
 #include <linux/clk.h>
+#include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
@@ -17,6 +18,8 @@
 #include <asm/arch/portmux.h>
 #include <asm/arch/sm.h>
 
+#include <video/atmel_lcdc.h>
+
 #include "clock.h"
 #include "hmatrix.h"
 #include "pio.h"
@@ -881,20 +884,26 @@ at32_add_device_spi(unsigned int id, struct spi_board_info *b, unsigned int n)
 /* --------------------------------------------------------------------
  *  LCDC
  * -------------------------------------------------------------------- */
-static struct lcdc_platform_data lcdc0_data;
-static struct resource lcdc0_resource[] = {
+static struct atmel_lcdfb_info atmel_lcdfb0_data;
+static struct resource atmel_lcdfb0_resource[] = {
 	{
 		.start		= 0xff000000,
 		.end		= 0xff000fff,
 		.flags		= IORESOURCE_MEM,
 	},
 	IRQ(1),
+	{
+		/* Placeholder for pre-allocated fb memory */
+		.start		= 0x00000000,
+		.end		= 0x00000000,
+		.flags		= 0,
+	},
 };
-DEFINE_DEV_DATA(lcdc, 0);
-DEV_CLK(hclk, lcdc0, hsb, 7);
-static struct clk lcdc0_pixclk = {
-	.name		= "pixclk",
-	.dev		= &lcdc0_device.dev,
+DEFINE_DEV_DATA(atmel_lcdfb, 0);
+DEV_CLK(hck1, atmel_lcdfb0, hsb, 7);
+static struct clk atmel_lcdfb0_pixclk = {
+	.name		= "lcdc_clk",
+	.dev		= &atmel_lcdfb0_device.dev,
 	.mode		= genclk_mode,
 	.get_rate	= genclk_get_rate,
 	.set_rate	= genclk_set_rate,
@@ -903,13 +912,34 @@ static struct clk lcdc0_pixclk = {
 };
 
 struct platform_device *__init
-at32_add_device_lcdc(unsigned int id, struct lcdc_platform_data *data)
+at32_add_device_lcdc(unsigned int id, struct atmel_lcdfb_info *data,
+		     unsigned long fbmem_start, unsigned long fbmem_len)
 {
 	struct platform_device *pdev;
+	struct atmel_lcdfb_info *info;
+	struct fb_monspecs *monspecs;
+	struct fb_videomode *modedb;
+	unsigned int modedb_size;
+
+	/*
+	 * Do a deep copy of the fb data, monspecs and modedb. Make
+	 * sure all allocations are done before setting up the
+	 * portmux.
+	 */
+	monspecs = kmemdup(data->default_monspecs,
+			   sizeof(struct fb_monspecs), GFP_KERNEL);
+	if (!monspecs)
+		return NULL;
+
+	modedb_size = sizeof(struct fb_videomode) * monspecs->modedb_len;
+	modedb = kmemdup(monspecs->modedb, modedb_size, GFP_KERNEL);
+	if (!modedb)
+		goto err_dup_modedb;
+	monspecs->modedb = modedb;
 
 	switch (id) {
 	case 0:
-		pdev = &lcdc0_device;
+		pdev = &atmel_lcdfb0_device;
 		select_peripheral(PC(19), PERIPH_A, 0);	/* CC	  */
 		select_peripheral(PC(20), PERIPH_A, 0);	/* HSYNC  */
 		select_peripheral(PC(21), PERIPH_A, 0);	/* PCLK	  */
@@ -942,19 +972,32 @@ at32_add_device_lcdc(unsigned int id, struct lcdc_platform_data *data)
 		select_peripheral(PD(16), PERIPH_A, 0);	/* DATA22 */
 		select_peripheral(PD(17), PERIPH_A, 0);	/* DATA23 */
 
-		clk_set_parent(&lcdc0_pixclk, &pll0);
-		clk_set_rate(&lcdc0_pixclk, clk_get_rate(&pll0));
+		clk_set_parent(&atmel_lcdfb0_pixclk, &pll0);
+		clk_set_rate(&atmel_lcdfb0_pixclk, clk_get_rate(&pll0));
 		break;
 
 	default:
-		return NULL;
+		goto err_invalid_id;
 	}
 
-	memcpy(pdev->dev.platform_data, data,
-	       sizeof(struct lcdc_platform_data));
+	if (fbmem_len) {
+		pdev->resource[2].start = fbmem_start;
+		pdev->resource[2].end = fbmem_start + fbmem_len - 1;
+		pdev->resource[2].flags = IORESOURCE_MEM;
+	}
+
+	info = pdev->dev.platform_data;
+	memcpy(info, data, sizeof(struct atmel_lcdfb_info));
+	info->default_monspecs = monspecs;
 
 	platform_device_register(pdev);
 	return pdev;
+
+err_invalid_id:
+	kfree(modedb);
+err_dup_modedb:
+	kfree(monspecs);
+	return NULL;
 }
 
 /* --------------------------------------------------------------------
@@ -1037,8 +1080,8 @@ struct clk *at32_clock_list[] = {
 	&macb1_pclk,
 	&atmel_spi0_spi_clk,
 	&atmel_spi1_spi_clk,
-	&lcdc0_hclk,
-	&lcdc0_pixclk,
+	&atmel_lcdfb0_hck1,
+	&atmel_lcdfb0_pixclk,
 	&gclk0,
 	&gclk1,
 	&gclk2,
@@ -1077,7 +1120,7 @@ void __init at32_clock_init(void)
 	genclk_init_parent(&gclk2);
 	genclk_init_parent(&gclk3);
 	genclk_init_parent(&gclk4);
-	genclk_init_parent(&lcdc0_pixclk);
+	genclk_init_parent(&atmel_lcdfb0_pixclk);
 
 	/*
 	 * Turn on all clocks that have at least one user already, and
diff --git a/arch/avr32/mm/fault.c b/arch/avr32/mm/fault.c
index 88b00b1..e011f1c 100644
--- a/arch/avr32/mm/fault.c
+++ b/arch/avr32/mm/fault.c
@@ -12,41 +12,30 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
-
 #include <linux/kdebug.h>
+#include <linux/kprobes.h>
+
 #include <asm/mmu_context.h>
 #include <asm/sysreg.h>
 #include <asm/tlb.h>
 #include <asm/uaccess.h>
 
 #ifdef CONFIG_KPROBES
-ATOMIC_NOTIFIER_HEAD(notify_page_fault_chain);
-
-/* Hook to register for page fault notifications */
-int register_page_fault_notifier(struct notifier_block *nb)
+static inline int notify_page_fault(struct pt_regs *regs, int trap)
 {
-	return atomic_notifier_chain_register(&notify_page_fault_chain, nb);
-}
+	int ret = 0;
 
-int unregister_page_fault_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_unregister(&notify_page_fault_chain, nb);
-}
+	if (!user_mode(regs)) {
+		if (kprobe_running() && kprobe_fault_handler(regs, trap))
+			ret = 1;
+	}
 
-static inline int notify_page_fault(enum die_val val, struct pt_regs *regs,
-				    int trap, int sig)
-{
-	struct die_args args = {
-		.regs = regs,
-		.trapnr = trap,
-	};
-	return atomic_notifier_call_chain(&notify_page_fault_chain, val, &args);
+	return ret;
 }
 #else
-static inline int notify_page_fault(enum die_val val, struct pt_regs *regs,
-				    int trap, int sig)
+static inline int notify_page_fault(struct pt_regs *regs, int trap)
 {
-	return NOTIFY_DONE;
+	return 0;
 }
 #endif
 
@@ -76,8 +65,7 @@ asmlinkage void do_page_fault(unsigned long ecr, struct pt_regs *regs)
 	long signr;
 	int code;
 
-	if (notify_page_fault(DIE_PAGE_FAULT, regs,
-			      ecr, SIGSEGV) == NOTIFY_STOP)
+	if (notify_page_fault(regs, ecr))
 		return;
 
 	address = sysreg_read(TLBEAR);
diff --git a/include/asm-avr32/arch-at32ap/board.h b/include/asm-avr32/arch-at32ap/board.h
index 1a7b07d..9fd2e32 100644
--- a/include/asm-avr32/arch-at32ap/board.h
+++ b/include/asm-avr32/arch-at32ap/board.h
@@ -30,11 +30,9 @@ struct spi_board_info;
 struct platform_device *
 at32_add_device_spi(unsigned int id, struct spi_board_info *b, unsigned int n);
 
-struct lcdc_platform_data {
-	unsigned long fbmem_start;
-	unsigned long fbmem_size;
-};
+struct atmel_lcdfb_info;
 struct platform_device *
-at32_add_device_lcdc(unsigned int id, struct lcdc_platform_data *data);
+at32_add_device_lcdc(unsigned int id, struct atmel_lcdfb_info *data,
+		     unsigned long fbmem_start, unsigned long fbmem_len);
 
 #endif /* __ASM_ARCH_BOARD_H */
diff --git a/include/asm-avr32/kdebug.h b/include/asm-avr32/kdebug.h
index de41927..7f54e2b 100644
--- a/include/asm-avr32/kdebug.h
+++ b/include/asm-avr32/kdebug.h
@@ -5,13 +5,22 @@
 
 /* Grossly misnamed. */
 enum die_val {
-	DIE_FAULT,
 	DIE_BREAKPOINT,
 	DIE_SSTEP,
-	DIE_PAGE_FAULT,
 };
 
-int register_page_fault_notifier(struct notifier_block *nb);
-int unregister_page_fault_notifier(struct notifier_block *nb);
+/*
+ * These are only here because kprobes.c wants them to implement a
+ * blatant layering violation.  Will hopefully go away soon once all
+ * architectures are updated.
+ */
+static inline int register_page_fault_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+static inline int unregister_page_fault_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
 
 #endif /* __ASM_AVR32_KDEBUG_H */
diff --git a/include/asm-avr32/kprobes.h b/include/asm-avr32/kprobes.h
index 09a5cbe..190a637 100644
--- a/include/asm-avr32/kprobes.h
+++ b/include/asm-avr32/kprobes.h
@@ -26,6 +26,7 @@ struct arch_specific_insn {
 	kprobe_opcode_t	insn[MAX_INSN_SIZE];
 };
 
+extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
 
diff --git a/include/asm-avr32/unistd.h b/include/asm-avr32/unistd.h
index 2418cce..3b4e35b 100644
--- a/include/asm-avr32/unistd.h
+++ b/include/asm-avr32/unistd.h
@@ -296,9 +296,12 @@
 #define __NR_shmctl		277
 
 #define __NR_utimensat		278
+#define __NR_signalfd		279
+#define __NR_timerfd		280
+#define __NR_eventfd		281
 
 #ifdef __KERNEL__
-#define NR_syscalls		279
+#define NR_syscalls		282
 
 
 #define __ARCH_WANT_IPC_PARSE_VERSION

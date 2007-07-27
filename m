Return-Path: <linux-kernel-owner+w=401wt.eu-S932199AbXG0IsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbXG0IsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 04:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXG0Ir5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 04:47:57 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:7723 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbXG0Iry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 04:47:54 -0400
X-IronPort-AV: i="4.16,587,1175486400"; 
   d="scan'208"; a="46657823:sNHT36971578"
Subject: [GIT PULL try#4] Blackfin update
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Perches <joe@perches.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Fri, 27 Jul 2007 16:55:09 +0800
Message-Id: <1185526509.11601.21.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
X-OriginalArrivalTime: 27 Jul 2007 08:47:51.0546 (UTC) FILETIME=[D0E8A5A0:01C7D02A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 arch/blackfin/Makefile                           |    4 ++
 arch/blackfin/kernel/dma-mapping.c               |    3 +-
 arch/blackfin/kernel/setup.c                     |    5 +--
 arch/blackfin/kernel/traps.c                     |    2 +-
 arch/blackfin/kernel/vmlinux.lds.S               |   16 +++++---
 arch/blackfin/mach-bf561/head.S                  |   10 ++--
 arch/blackfin/mach-common/cacheinit.S            |    3 +
 arch/blackfin/mach-common/ints-priority-dc.c     |   39 ++++++++++--------
 arch/blackfin/mach-common/ints-priority-sc.c     |   48 +++++++++++++---------
 drivers/i2c/busses/Kconfig                       |    4 +-
 drivers/input/serio/Kconfig                      |    2 +-
 drivers/net/bfin_mac.c                           |    6 ++-
 drivers/rtc/rtc-bfin.c                           |    2 +-
 include/asm-blackfin/bfin-global.h               |    1 +
 include/asm-blackfin/mach-bf548/cdefBF54x_base.h |   33 +++++++++++++++
 include/asm-blackfin/mach-bf548/irq.h            |    1 +
 include/asm-blackfin/mach-bf561/cdefBF561.h      |    6 +++
 include/asm-blackfin/mach-bf561/defBF561.h       |    4 ++
 include/asm-blackfin/thread_info.h               |   12 +++---
 19 files changed, 136 insertions(+), 65 deletions(-)

Bernd Schmidt (3):
      Blackfin arch: Load P0 before storing through it
      Blackfin arch: fix bug which unaligns the init thread's stack and causes the current macro to fail.
      Blackfin arch: Initialize the exception vectors early in the boot process

Bryan Wu (2):
      Blackfin arch: fix a compiling warning about dma-mapping
      Blackfin arch: add BF54x I2C/TWI TWI0 driver support

Michael Hennerich (3):
      Blackfin arch: add error message when IRQ no available
      Blackfin Ethernet MAC driver: fix bug Report returned -ENOMEM upwards (in case L1/uncached memory alloc fails)
      Input Serio: Blackfin doesnt support I8042 - make sure it doesnt get selected

Mike Frysinger (5):
      Blackfin arch: setup aliases for some core Core A MMRs
      Blackfin arch: use bfin_read_SWRST() now that BF561 provides it
      Blackfin arch: add selections for BF544 and BF542
      Blackfin arch: switch to using proper defines this time THREAD_SIZE and PAGE_SIZE instead of just PAGE_SIZE everywhere
      Blackfin On-Chip RTC driver update for supporting BF54x

Sonic Zhang (1):
      Blackfin arch: fix KGDB bug, dont forget last parameter.

diff --git a/arch/blackfin/Makefile b/arch/blackfin/Makefile
index 1b75672..2084166 100644
--- a/arch/blackfin/Makefile
+++ b/arch/blackfin/Makefile
@@ -24,6 +24,8 @@ machine-$(CONFIG_BF533) := bf533
 machine-$(CONFIG_BF534) := bf537
 machine-$(CONFIG_BF536) := bf537
 machine-$(CONFIG_BF537) := bf537
+machine-$(CONFIG_BF542) := bf548
+machine-$(CONFIG_BF544) := bf548
 machine-$(CONFIG_BF548) := bf548
 machine-$(CONFIG_BF549) := bf548
 machine-$(CONFIG_BF561) := bf561
@@ -36,6 +38,8 @@ cpu-$(CONFIG_BF533) := bf533
 cpu-$(CONFIG_BF534) := bf534
 cpu-$(CONFIG_BF536) := bf536
 cpu-$(CONFIG_BF537) := bf537
+cpu-$(CONFIG_BF542) := bf542
+cpu-$(CONFIG_BF544) := bf544
 cpu-$(CONFIG_BF548) := bf548
 cpu-$(CONFIG_BF549) := bf549
 cpu-$(CONFIG_BF561) := bf561
diff --git a/arch/blackfin/kernel/dma-mapping.c b/arch/blackfin/kernel/dma-mapping.c
index ea48d5b..94d7b11 100644
--- a/arch/blackfin/kernel/dma-mapping.c
+++ b/arch/blackfin/kernel/dma-mapping.c
@@ -160,7 +160,8 @@ dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	BUG_ON(direction == DMA_NONE);
 
 	for (i = 0; i < nents; i++, sg++) {
-		sg->dma_address = page_address(sg->page) + sg->offset;
+		sg->dma_address = (dma_addr_t)(page_address(sg->page) +
+					sg->offset);
 
 		invalidate_dcache_range(sg_dma_address(sg),
 					sg_dma_address(sg) +
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index f59dcee..88f221b 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -402,11 +402,7 @@ void __init setup_arch(char **cmdline_p)
 	if (l1_length > L1_DATA_A_LENGTH)
 		panic("L1 data memory overflow\n");
 
-#ifdef BF561_FAMILY
-	_bfin_swrst = bfin_read_SICA_SWRST();
-#else
 	_bfin_swrst = bfin_read_SWRST();
-#endif
 
 	/* Copy atomic sequences to their fixed location, and sanity check that
 	   these locations are the ones that we advertise to userspace.  */
@@ -429,6 +425,7 @@ void __init setup_arch(char **cmdline_p)
 	BUG_ON((char *)&atomic_xor32 - (char *)&fixed_code_start
 	       != ATOMIC_XOR32 - FIXED_CODE_START);
 
+	init_exception_vectors();
 	bf53x_cache_init();
 }
 
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 3909f5b..8766bd6 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -140,7 +140,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 #ifdef CONFIG_KGDB
 # define CHK_DEBUGGER_TRAP() \
 	do { \
-		CHK_DEBUGGER(trapnr, sig, info.si_code, fp); \
+		CHK_DEBUGGER(trapnr, sig, info.si_code, fp, ); \
 	} while (0)
 # define CHK_DEBUGGER_TRAP_MAYBE() \
 	do { \
diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index d06f860..fb53780 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -32,6 +32,7 @@
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/mem_map.h>
 #include <asm/page.h>
+#include <asm/thread_info.h>
 
 OUTPUT_FORMAT("elf32-bfin")
 ENTRY(__start)
@@ -64,8 +65,12 @@ SECTIONS
 
 	.data :
 	{
-		. = ALIGN(PAGE_SIZE);
+		/* make sure the init_task is aligned to the
+		 * kernel thread size so we can locate the kernel
+		 * stack properly and quickly.
+		 */
 		__sdata = .;
+		. = ALIGN(THREAD_SIZE);
 		*(.data.init_task)
 		DATA_DATA
 		CONSTRUCTORS
@@ -73,14 +78,14 @@ SECTIONS
 		. = ALIGN(32);
 		*(.data.cacheline_aligned)
 
-		. = ALIGN(PAGE_SIZE);
+		. = ALIGN(THREAD_SIZE);
 		__edata = .;
 	}
 
-	. = ALIGN(PAGE_SIZE);
 	___init_begin = .;
 	.init :
 	{
+		. = ALIGN(PAGE_SIZE);
 		__sinittext = .;
 		*(.init.text)
 		__einittext = .;
@@ -153,10 +158,9 @@ SECTIONS
 		__ebss_b_l1 = .;
 	}
 
-	. = LOADADDR(.data_b_l1) + SIZEOF(.data_b_l1);
-	___init_end = ALIGN(PAGE_SIZE);
+	___init_end = LOADADDR(.data_b_l1) + SIZEOF(.data_b_l1);
 
-	.bss ___init_end :
+	.bss LOADADDR(.data_b_l1) + SIZEOF(.data_b_l1) :
 	{
 		. = ALIGN(4);
 		___bss_start = .;
diff --git a/arch/blackfin/mach-bf561/head.S b/arch/blackfin/mach-bf561/head.S
index 2f08bcb..38650a6 100644
--- a/arch/blackfin/mach-bf561/head.S
+++ b/arch/blackfin/mach-bf561/head.S
@@ -440,15 +440,15 @@ ENTRY(_bfin_reset)
 	SSYNC;
 
 	/* make sure SYSCR is set to use BMODE */
-	P0.h = hi(SICA_SYSCR);
-	P0.l = lo(SICA_SYSCR);
-	R0.l = 0x20;
+	P0.h = hi(SYSCR);
+	P0.l = lo(SYSCR);
+	R0.l = 0x20;		/* on BF561, disable core b */
 	W[P0] = R0.l;
 	SSYNC;
 
 	/* issue a system soft reset */
-	P1.h = hi(SICA_SWRST);
-	P1.l = lo(SICA_SWRST);
+	P1.h = hi(SWRST);
+	P1.l = lo(SWRST);
 	R1.l = 0x0007;
 	W[P1] = R1;
 	SSYNC;
diff --git a/arch/blackfin/mach-common/cacheinit.S b/arch/blackfin/mach-common/cacheinit.S
index 9d47562..5be6b97 100644
--- a/arch/blackfin/mach-common/cacheinit.S
+++ b/arch/blackfin/mach-common/cacheinit.S
@@ -60,6 +60,9 @@ ENDPROC(_bfin_write_IMEM_CONTROL)
 
 #if defined(CONFIG_BLKFIN_DCACHE)
 ENTRY(_bfin_write_DMEM_CONTROL)
+	P0.l = (DMEM_CONTROL & 0xFFFF);
+	P0.h = (DMEM_CONTROL >> 16);
+
 	CLI R1;
 	SSYNC;		/* SSYNC required before writing to DMEM_CONTROL. */
 	.align 8;
diff --git a/arch/blackfin/mach-common/ints-priority-dc.c b/arch/blackfin/mach-common/ints-priority-dc.c
index 6b9fd03..660f881 100644
--- a/arch/blackfin/mach-common/ints-priority-dc.c
+++ b/arch/blackfin/mach-common/ints-priority-dc.c
@@ -358,26 +358,10 @@ static void bf561_demux_gpio_irq(unsigned int inta_irq,
 
 #endif				/* CONFIG_IRQCHIP_DEMUX_GPIO */
 
-/*
- * This function should be called during kernel startup to initialize
- * the BFin IRQ handling routines.
- */
-int __init init_arch_irq(void)
+void __init init_exception_vectors(void)
 {
-	int irq;
-	unsigned long ilat = 0;
-	/*  Disable all the peripheral intrs  - page 4-29 HW Ref manual */
-	bfin_write_SICA_IMASK0(SIC_UNMASK_ALL);
-	bfin_write_SICA_IMASK1(SIC_UNMASK_ALL);
 	SSYNC();
 
-	bfin_write_SICA_IWR0(IWR_ENABLE_ALL);
-	bfin_write_SICA_IWR1(IWR_ENABLE_ALL);
-
-	local_irq_disable();
-
-	init_exception_buff();
-
 #ifndef CONFIG_KGDB
 	bfin_write_EVT0(evt_emulation);
 #endif
@@ -395,6 +379,27 @@ int __init init_arch_irq(void)
 	bfin_write_EVT14(evt14_softirq);
 	bfin_write_EVT15(evt_system_call);
 	CSYNC();
+}
+
+/*
+ * This function should be called during kernel startup to initialize
+ * the BFin IRQ handling routines.
+ */
+int __init init_arch_irq(void)
+{
+	int irq;
+	unsigned long ilat = 0;
+	/*  Disable all the peripheral intrs  - page 4-29 HW Ref manual */
+	bfin_write_SICA_IMASK0(SIC_UNMASK_ALL);
+	bfin_write_SICA_IMASK1(SIC_UNMASK_ALL);
+	SSYNC();
+
+	bfin_write_SICA_IWR0(IWR_ENABLE_ALL);
+	bfin_write_SICA_IWR1(IWR_ENABLE_ALL);
+
+	local_irq_disable();
+
+	init_exception_buff();
 
 	for (irq = 0; irq <= SYS_IRQS; irq++) {
 		if (irq <= IRQ_CORETMR)
diff --git a/arch/blackfin/mach-common/ints-priority-sc.c b/arch/blackfin/mach-common/ints-priority-sc.c
index 28a878c..4708023 100644
--- a/arch/blackfin/mach-common/ints-priority-sc.c
+++ b/arch/blackfin/mach-common/ints-priority-sc.c
@@ -579,8 +579,12 @@ static unsigned int bfin_gpio_irq_startup(unsigned int irq)
 	u16 gpionr = irq - IRQ_PA0;
 	u8 pint_val = irq2pint_lut[irq - SYS_IRQS];
 
-	if (pint_val == IRQ_NOT_AVAIL)
+	if (pint_val == IRQ_NOT_AVAIL) {
+		printk(KERN_ERR
+		"GPIO IRQ %d :Not in PINT Assign table "
+		"Reconfigure Interrupt to Port Assignemt\n", irq);
 		return -ENODEV;
+	}
 
 	if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
 		ret = gpio_request(gpionr, NULL);
@@ -713,6 +717,29 @@ static void bfin_demux_gpio_irq(unsigned int intb_irq,
 }
 #endif				/* CONFIG_IRQCHIP_DEMUX_GPIO */
 
+void __init init_exception_vectors(void)
+{
+	SSYNC();
+
+#ifndef CONFIG_KGDB
+	bfin_write_EVT0(evt_emulation);
+#endif
+	bfin_write_EVT2(evt_evt2);
+	bfin_write_EVT3(trap);
+	bfin_write_EVT5(evt_ivhw);
+	bfin_write_EVT6(evt_timer);
+	bfin_write_EVT7(evt_evt7);
+	bfin_write_EVT8(evt_evt8);
+	bfin_write_EVT9(evt_evt9);
+	bfin_write_EVT10(evt_evt10);
+	bfin_write_EVT11(evt_evt11);
+	bfin_write_EVT12(evt_evt12);
+	bfin_write_EVT13(evt_evt13);
+	bfin_write_EVT14(evt14_softirq);
+	bfin_write_EVT15(evt_system_call);
+	CSYNC();
+}
+
 /*
  * This function should be called during kernel startup to initialize
  * the BFin IRQ handling routines.
@@ -733,29 +760,10 @@ int __init init_arch_irq(void)
 	bfin_write_SIC_IMASK(SIC_UNMASK_ALL);
 	bfin_write_SIC_IWR(IWR_ENABLE_ALL);
 #endif
-
 	SSYNC();
 
 	local_irq_disable();
 
-#ifndef CONFIG_KGDB
-	bfin_write_EVT0(evt_emulation);
-#endif
-	bfin_write_EVT2(evt_evt2);
-	bfin_write_EVT3(trap);
-	bfin_write_EVT5(evt_ivhw);
-	bfin_write_EVT6(evt_timer);
-	bfin_write_EVT7(evt_evt7);
-	bfin_write_EVT8(evt_evt8);
-	bfin_write_EVT9(evt_evt9);
-	bfin_write_EVT10(evt_evt10);
-	bfin_write_EVT11(evt_evt11);
-	bfin_write_EVT12(evt_evt12);
-	bfin_write_EVT13(evt_evt13);
-	bfin_write_EVT14(evt14_softirq);
-	bfin_write_EVT15(evt_system_call);
-	CSYNC();
-
 #if defined(CONFIG_IRQCHIP_DEMUX_GPIO) && defined(CONFIG_BF54x)
 #ifdef CONFIG_PINTx_REASSIGN
 	pint[0]->assign = CONFIG_PINT0_ASSIGN;
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index da16478..1842f52 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -92,9 +92,9 @@ config I2C_AU1550
 
 config I2C_BLACKFIN_TWI
 	tristate "Blackfin TWI I2C support"
-	depends on BF534 || BF536 || BF537
+	depends on BF534 || BF536 || BF537 || BF54x
 	help
-	  This is the TWI I2C device driver for Blackfin 534/536/537.
+	  This is the TWI I2C device driver for Blackfin 534/536/537/54x.
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-bfin-twi.
 
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index adef447..5ce632c 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -21,7 +21,7 @@ if SERIO
 config SERIO_I8042
 	tristate "i8042 PC Keyboard controller" if EMBEDDED || !X86
 	default y
-	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && !M68K
+	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && !M68K && !BFIN
 	---help---
 	  i8042 is the chip over which the standard AT keyboard and PS/2
 	  mouse are connected to the computer. If you use these devices,
diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
index 9a08d65..2bb97d4 100644
--- a/drivers/net/bfin_mac.c
+++ b/drivers/net/bfin_mac.c
@@ -798,6 +798,7 @@ static void bf537mac_shutdown(struct net_device *dev)
  */
 static int bf537mac_open(struct net_device *dev)
 {
+	int retval;
 	pr_debug("%s: %s\n", dev->name, __FUNCTION__);
 
 	/*
@@ -811,7 +812,10 @@ static int bf537mac_open(struct net_device *dev)
 	}
 
 	/* initial rx and tx list */
-	desc_list_init();
+	retval = desc_list_init();
+
+	if (retval)
+		return retval;
 
 	bf537mac_setphy(dev);
 	setup_system_regs(dev);
diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 260ead9..1aa709d 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -1,6 +1,6 @@
 /*
  * Blackfin On-Chip Real Time Clock Driver
- *  Supports BF531/BF532/BF533/BF534/BF536/BF537
+ *  Supports BF53[123]/BF53[467]/BF54[2489]
  *
  * Copyright 2004-2007 Analog Devices Inc.
  *
diff --git a/include/asm-blackfin/bfin-global.h b/include/asm-blackfin/bfin-global.h
index c4d6cbb..a970781 100644
--- a/include/asm-blackfin/bfin-global.h
+++ b/include/asm-blackfin/bfin-global.h
@@ -61,6 +61,7 @@ extern void bfin_dcache_init(void);
 extern int read_iloc(void);
 extern int bfin_console_init(void);
 extern asmlinkage void lower_to_irq14(void);
+extern void init_exception_vectors(void);
 extern void init_dma(void);
 extern void program_IAR(void);
 extern void evt14_softirq(void);
diff --git a/include/asm-blackfin/mach-bf548/cdefBF54x_base.h b/include/asm-blackfin/mach-bf548/cdefBF54x_base.h
index 98d35a9..cdf29e7 100644
--- a/include/asm-blackfin/mach-bf548/cdefBF54x_base.h
+++ b/include/asm-blackfin/mach-bf548/cdefBF54x_base.h
@@ -242,6 +242,39 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 #define bfin_read_TWI0_RCV_DATA16()		bfin_read16(TWI0_RCV_DATA16)
 #define bfin_write_TWI0_RCV_DATA16(val)		bfin_write16(TWI0_RCV_DATA16, val)
 
+#define bfin_read_TWI_CLKDIV()			bfin_read16(TWI0_CLKDIV)
+#define bfin_write_TWI_CLKDIV(val)		bfin_write16(TWI0_CLKDIV, val)
+#define bfin_read_TWI_CONTROL()			bfin_read16(TWI0_CONTROL)
+#define bfin_write_TWI_CONTROL(val)		bfin_write16(TWI0_CONTROL, val)
+#define bfin_read_TWI_SLAVE_CTRL()		bfin_read16(TWI0_SLAVE_CTRL)
+#define bfin_write_TWI_SLAVE_CTRL(val)		bfin_write16(TWI0_SLAVE_CTRL, val)
+#define bfin_read_TWI_SLAVE_STAT()		bfin_read16(TWI0_SLAVE_STAT)
+#define bfin_write_TWI_SLAVE_STAT(val)		bfin_write16(TWI0_SLAVE_STAT, val)
+#define bfin_read_TWI_SLAVE_ADDR()		bfin_read16(TWI0_SLAVE_ADDR)
+#define bfin_write_TWI_SLAVE_ADDR(val)		bfin_write16(TWI0_SLAVE_ADDR, val)
+#define bfin_read_TWI_MASTER_CTL()		bfin_read16(TWI0_MASTER_CTRL)
+#define bfin_write_TWI_MASTER_CTL(val)		bfin_write16(TWI0_MASTER_CTRL, val)
+#define bfin_read_TWI_MASTER_STAT()		bfin_read16(TWI0_MASTER_STAT)
+#define bfin_write_TWI_MASTER_STAT(val)		bfin_write16(TWI0_MASTER_STAT, val)
+#define bfin_read_TWI_MASTER_ADDR()		bfin_read16(TWI0_MASTER_ADDR)
+#define bfin_write_TWI_MASTER_ADDR(val)		bfin_write16(TWI0_MASTER_ADDR, val)
+#define bfin_read_TWI_INT_STAT()		bfin_read16(TWI0_INT_STAT)
+#define bfin_write_TWI_INT_STAT(val)		bfin_write16(TWI0_INT_STAT, val)
+#define bfin_read_TWI_INT_MASK()		bfin_read16(TWI0_INT_MASK)
+#define bfin_write_TWI_INT_MASK(val)		bfin_write16(TWI0_INT_MASK, val)
+#define bfin_read_TWI_FIFO_CTL()		bfin_read16(TWI0_FIFO_CTRL)
+#define bfin_write_TWI_FIFO_CTL(val)		bfin_write16(TWI0_FIFO_CTRL, val)
+#define bfin_read_TWI_FIFO_STAT()		bfin_read16(TWI0_FIFO_STAT)
+#define bfin_write_TWI_FIFO_STAT(val)		bfin_write16(TWI0_FIFO_STAT, val)
+#define bfin_read_TWI_XMT_DATA8()		bfin_read16(TWI0_XMT_DATA8)
+#define bfin_write_TWI_XMT_DATA8(val)		bfin_write16(TWI0_XMT_DATA8, val)
+#define bfin_read_TWI_XMT_DATA16()		bfin_read16(TWI0_XMT_DATA16)
+#define bfin_write_TWI_XMT_DATA16(val)		bfin_write16(TWI0_XMT_DATA16, val)
+#define bfin_read_TWI_RCV_DATA8()		bfin_read16(TWI0_RCV_DATA8)
+#define bfin_write_TWI_RCV_DATA8(val)		bfin_write16(TWI0_RCV_DATA8, val)
+#define bfin_read_TWI_RCV_DATA16()		bfin_read16(TWI0_RCV_DATA16)
+#define bfin_write_TWI_RCV_DATA16(val)		bfin_write16(TWI0_RCV_DATA16, val)
+
 /* SPORT0 is not defined in the shared file because it is not available on the ADSP-BF542 and ADSP-BF544 bfin_read_()rocessors */
 
 /* SPORT1 Registers */
diff --git a/include/asm-blackfin/mach-bf548/irq.h b/include/asm-blackfin/mach-bf548/irq.h
index 0b3325b..e548d3c 100644
--- a/include/asm-blackfin/mach-bf548/irq.h
+++ b/include/asm-blackfin/mach-bf548/irq.h
@@ -112,6 +112,7 @@ Events         (highest priority)  EMU         0
 #define IRQ_ATAPI_TX	BFIN_IRQ(44)	/* ATAPI TX (DMA11) Interrupt */
 #define IRQ_TWI0	BFIN_IRQ(45)	/* TWI0 Interrupt */
 #define IRQ_TWI1	BFIN_IRQ(46)	/* TWI1 Interrupt */
+#define IRQ_TWI		IRQ_TWI0	/* TWI Interrupt */
 #define IRQ_CAN0_RX	BFIN_IRQ(47)	/* CAN0 Receive Interrupt */
 #define IRQ_CAN0_TX	BFIN_IRQ(48)	/* CAN0 Transmit Interrupt */
 #define IRQ_MDMAS2	BFIN_IRQ(49)	/* MDMA Stream 2 Interrupt */
diff --git a/include/asm-blackfin/mach-bf561/cdefBF561.h b/include/asm-blackfin/mach-bf561/cdefBF561.h
index 1a8ec9e..6e87ab2 100644
--- a/include/asm-blackfin/mach-bf561/cdefBF561.h
+++ b/include/asm-blackfin/mach-bf561/cdefBF561.h
@@ -81,6 +81,12 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 #define bfin_write_PLL_LOCKCNT(val)          bfin_write16(PLL_LOCKCNT,val)
 #define bfin_read_CHIPID()                   bfin_read32(CHIPID)
 
+/* For MMR's that are reserved on Core B, set up defines to better integrate with other ports */
+#define bfin_read_SWRST()                    bfin_read_SICA_SWRST()
+#define bfin_write_SWRST()                   bfin_write_SICA_SWRST()
+#define bfin_read_SYSCR()                    bfin_read_SICA_SYSCR()
+#define bfin_write_SYSCR()                   bfin_write_SICA_SYSCR()
+
 /* System Reset and Interrupt Controller registers for core A (0xFFC0 0100-0xFFC0 01FF) */
 #define bfin_read_SICA_SWRST()               bfin_read16(SICA_SWRST)
 #define bfin_write_SICA_SWRST(val)           bfin_write16(SICA_SWRST,val)
diff --git a/include/asm-blackfin/mach-bf561/defBF561.h b/include/asm-blackfin/mach-bf561/defBF561.h
index 89150ec..0f2dc6e 100644
--- a/include/asm-blackfin/mach-bf561/defBF561.h
+++ b/include/asm-blackfin/mach-bf561/defBF561.h
@@ -52,6 +52,10 @@
 #define PLL_LOCKCNT            0xFFC00010	/* PLL Lock Count register (16-bit) */
 #define CHIPID                 0xFFC00014       /* Chip ID Register */
 
+/* For MMR's that are reserved on Core B, set up defines to better integrate with other ports */
+#define SWRST                   SICA_SWRST
+#define SYSCR                   SICA_SYSCR
+
 /* System Reset and Interrupt Controller registers for core A (0xFFC0 0100-0xFFC0 01FF) */
 #define SICA_SWRST              0xFFC00100	/* Software Reset register */
 #define SICA_SYSCR              0xFFC00104	/* System Reset Configuration register */
diff --git a/include/asm-blackfin/thread_info.h b/include/asm-blackfin/thread_info.h
index fa8f08c..34d3c2e 100644
--- a/include/asm-blackfin/thread_info.h
+++ b/include/asm-blackfin/thread_info.h
@@ -39,6 +39,11 @@
  */
 #define ALIGN_PAGE_MASK         0xffffe000
 
+/*
+ * Size of kernel stack for each process. This must be a power of 2...
+ */
+#define THREAD_SIZE		8192	/* 2 pages */
+
 #ifndef __ASSEMBLY__
 
 typedef unsigned long mm_segment_t;
@@ -76,11 +81,6 @@ struct thread_info {
 #define init_thread_info	(init_thread_union.thread_info)
 #define init_stack		(init_thread_union.stack)
 
-/*
- * Size of kernel stack for each process. This must be a power of 2...
- */
-#define THREAD_SIZE		8192	/* 2 pages */
-
 /* How to get the thread information struct from C */
 
 static inline struct thread_info *current_thread_info(void)
@@ -94,7 +94,7 @@ static inline struct thread_info *current_thread_info(void)
 	struct thread_info *ti;
       __asm__("%0 = sp;": "=&d"(ti):
 	);
-	return (struct thread_info *)((long)ti & ~8191UL);
+	return (struct thread_info *)((long)ti & ~((long)THREAD_SIZE-1));
 }
 
 /* thread information allocation */

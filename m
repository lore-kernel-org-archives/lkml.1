Return-Path: <linux-kernel-owner+w=401wt.eu-S1945937AbXBPPj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945937AbXBPPj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945943AbXBPPj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:39:57 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:64349 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1945936AbXBPPj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:39:56 -0500
Date: Fri, 16 Feb 2007 16:39:40 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
Subject: [GIT PULL] AVR32 update
Message-ID: <20070216163940.7793b249@dhcp-252-105.norway.atmel.com>
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

to receive the following updates. This includes a few build fixes, a
handful of fixes to the platform code (picked out of a patch by David
Brownell) and a SysV IPC fix. After this, SysV IPC should actually work
on AVR32 provided libc is re-built against a new set of kernel headers
(otherwise, it will be exactly as broken as before.)

Haavard

 arch/avr32/boards/atstk1000/atstk1002.c |    9 +--
 arch/avr32/kernel/syscall_table.S       |   22 +++--
 arch/avr32/mach-at32ap/at32ap7000.c     |  144 ++++++++++++++++++++++++-------
 arch/avr32/mach-at32ap/clock.c          |    6 +-
 include/asm-avr32/arch-at32ap/board.h   |    4 +-
 include/asm-avr32/io.h                  |   23 ++++--
 include/asm-avr32/unistd.h              |   17 +++-
 7 files changed, 167 insertions(+), 58 deletions(-)

Haavard Skinnemoen (7):
      [AVR32] Fix prototypes for __raw_writesb and friends
      [AVR32] Define ioremap_nocache, ioport_map and ioport_unmap
      [AVR32] Wire up the SysV IPC calls properly
      [AVR32] Remove unnecessary sys_nfsservctl conditional
      [AVR32] Make sure all genclocks have a parent
      [AVR32] Warn, don't BUG if clk_disable is called too many times
      [AVR32] Use per-controller spi_board_info structures

diff --git a/arch/avr32/boards/atstk1000/atstk1002.c b/arch/avr32/boards/atstk1000/atstk1002.c
index d47e39f..5974768 100644
--- a/arch/avr32/boards/atstk1000/atstk1002.c
+++ b/arch/avr32/boards/atstk1000/atstk1002.c
@@ -8,7 +8,6 @@
  * published by the Free Software Foundation.
  */
 #include <linux/clk.h>
-#include <linux/device.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -36,12 +35,11 @@ static struct eth_addr __initdata hw_addr[2];
 static struct eth_platform_data __initdata eth_data[2];
 extern struct lcdc_platform_data atstk1000_fb0_data;
 
-static struct spi_board_info spi_board_info[] __initdata = {
+static struct spi_board_info spi0_board_info[] __initdata = {
 	{
+		/* QVGA display */
 		.modalias	= "ltv350qv",
-		.controller_data = (void *)GPIO_PIN_PA(4),
 		.max_speed_hz	= 16000000,
-		.bus_num	= 0,
 		.chip_select	= 1,
 	},
 };
@@ -149,8 +147,7 @@ static int __init atstk1002_init(void)
 
 	set_hw_addr(at32_add_device_eth(0, &eth_data[0]));
 
-	spi_register_board_info(spi_board_info, ARRAY_SIZE(spi_board_info));
-	at32_add_device_spi(0);
+	at32_add_device_spi(0, spi0_board_info, ARRAY_SIZE(spi0_board_info));
 	at32_add_device_lcdc(0, &atstk1000_fb0_data);
 
 	return 0;
diff --git a/arch/avr32/kernel/syscall_table.S b/arch/avr32/kernel/syscall_table.S
index db8f8b5..7c27958 100644
--- a/arch/avr32/kernel/syscall_table.S
+++ b/arch/avr32/kernel/syscall_table.S
@@ -8,14 +8,6 @@
  * published by the Free Software Foundation.
  */
 
-#if !defined(CONFIG_NFSD) && !defined(CONFIG_NFSD_MODULE)
-#define sys_nfsservctl sys_ni_syscall
-#endif
-
-#if !defined(CONFIG_SYSV_IPC)
-# define sys_ipc	sys_ni_syscall
-#endif
-
 	.section .rodata,"a",@progbits
 	.type	sys_call_table,@object
 	.global	sys_call_table
@@ -129,7 +121,7 @@ sys_call_table:
 	.long	sys_getitimer		/* 105 */
 	.long	sys_swapoff
 	.long	sys_sysinfo
-	.long	sys_ipc
+	.long	sys_ni_syscall		/* was sys_ipc briefly */
 	.long	sys_sendfile
 	.long	sys_setdomainname	/* 110 */
 	.long	sys_newuname
@@ -287,4 +279,16 @@ sys_call_table:
 	.long	sys_tee
 	.long	sys_vmsplice
 	.long	__sys_epoll_pwait	/* 265 */
+	.long	sys_msgget
+	.long	sys_msgsnd
+	.long	sys_msgrcv
+	.long	sys_msgctl
+	.long	sys_semget		/* 270 */
+	.long	sys_semop
+	.long	sys_semctl
+	.long	sys_semtimedop
+	.long	sys_shmat
+	.long	sys_shmget		/* 275 */
+	.long	sys_shmdt
+	.long	sys_shmctl
 	.long	sys_ni_syscall		/* r8 is saturated at nr_syscalls */
diff --git a/arch/avr32/mach-at32ap/at32ap7000.c b/arch/avr32/mach-at32ap/at32ap7000.c
index c1e477e..bc23550 100644
--- a/arch/avr32/mach-at32ap/at32ap7000.c
+++ b/arch/avr32/mach-at32ap/at32ap7000.c
@@ -8,6 +8,7 @@
 #include <linux/clk.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/spi/spi.h>
 
 #include <asm/io.h>
 
@@ -310,8 +311,6 @@ static void genclk_mode(struct clk *clk, int enabled)
 {
 	u32 control;
 
-	BUG_ON(clk->index > 7);
-
 	control = sm_readl(&system_manager, PM_GCCTRL + 4 * clk->index);
 	if (enabled)
 		control |= SM_BIT(CEN);
@@ -325,11 +324,6 @@ static unsigned long genclk_get_rate(struct clk *clk)
 	u32 control;
 	unsigned long div = 1;
 
-	BUG_ON(clk->index > 7);
-
-	if (!clk->parent)
-		return 0;
-
 	control = sm_readl(&system_manager, PM_GCCTRL + 4 * clk->index);
 	if (control & SM_BIT(DIVEN))
 		div = 2 * (SM_BFEXT(DIV, control) + 1);
@@ -342,11 +336,6 @@ static long genclk_set_rate(struct clk *clk, unsigned long rate, int apply)
 	u32 control;
 	unsigned long parent_rate, actual_rate, div;
 
-	BUG_ON(clk->index > 7);
-
-	if (!clk->parent)
-		return 0;
-
 	parent_rate = clk->parent->get_rate(clk->parent);
 	control = sm_readl(&system_manager, PM_GCCTRL + 4 * clk->index);
 
@@ -373,11 +362,8 @@ int genclk_set_parent(struct clk *clk, struct clk *parent)
 {
 	u32 control;
 
-	BUG_ON(clk->index > 7);
-
 	printk("clk %s: new parent %s (was %s)\n",
-	       clk->name, parent->name,
-	       clk->parent ? clk->parent->name : "(null)");
+	       clk->name, parent->name, clk->parent->name);
 
 	control = sm_readl(&system_manager, PM_GCCTRL + 4 * clk->index);
 
@@ -399,6 +385,22 @@ int genclk_set_parent(struct clk *clk, struct clk *parent)
 	return 0;
 }
 
+static void __init genclk_init_parent(struct clk *clk)
+{
+	u32 control;
+	struct clk *parent;
+
+	BUG_ON(clk->index > 7);
+
+	control = sm_readl(&system_manager, PM_GCCTRL + 4 * clk->index);
+	if (control & SM_BIT(OSCSEL))
+		parent = (control & SM_BIT(PLLSEL)) ? &pll1 : &osc1;
+	else
+		parent = (control & SM_BIT(PLLSEL)) ? &pll0 : &osc0;
+
+	clk->parent = parent;
+}
+
 /* --------------------------------------------------------------------
  *  System peripherals
  * -------------------------------------------------------------------- */
@@ -750,8 +752,41 @@ static struct resource atmel_spi1_resource[] = {
 DEFINE_DEV(atmel_spi, 1);
 DEV_CLK(spi_clk, atmel_spi1, pba, 1);
 
-struct platform_device *__init at32_add_device_spi(unsigned int id)
+static void
+at32_spi_setup_slaves(unsigned int bus_num, struct spi_board_info *b,
+		      unsigned int n, const u8 *pins)
+{
+	unsigned int pin, mode;
+
+	for (; n; n--, b++) {
+		b->bus_num = bus_num;
+		if (b->chip_select >= 4)
+			continue;
+		pin = (unsigned)b->controller_data;
+		if (!pin) {
+			pin = pins[b->chip_select];
+			b->controller_data = (void *)pin;
+		}
+		mode = AT32_GPIOF_OUTPUT;
+		if (!(b->mode & SPI_CS_HIGH))
+			mode |= AT32_GPIOF_HIGH;
+		at32_select_gpio(pin, mode);
+	}
+}
+
+struct platform_device *__init
+at32_add_device_spi(unsigned int id, struct spi_board_info *b, unsigned int n)
 {
+	/*
+	 * Manage the chipselects as GPIOs, normally using the same pins
+	 * the SPI controller expects; but boards can use other pins.
+	 */
+	static u8 __initdata spi0_pins[] =
+		{ GPIO_PIN_PA(3), GPIO_PIN_PA(4),
+		  GPIO_PIN_PA(5), GPIO_PIN_PA(20), };
+	static u8 __initdata spi1_pins[] =
+		{ GPIO_PIN_PB(2), GPIO_PIN_PB(3),
+		  GPIO_PIN_PB(4), GPIO_PIN_PA(27), };
 	struct platform_device *pdev;
 
 	switch (id) {
@@ -760,14 +795,7 @@ struct platform_device *__init at32_add_device_spi(unsigned int id)
 		select_peripheral(PA(0),  PERIPH_A, 0);	/* MISO	 */
 		select_peripheral(PA(1),  PERIPH_A, 0);	/* MOSI	 */
 		select_peripheral(PA(2),  PERIPH_A, 0);	/* SCK	 */
-
-		/* NPCS[2:0] */
-		at32_select_gpio(GPIO_PIN_PA(3),
-				 AT32_GPIOF_OUTPUT | AT32_GPIOF_HIGH);
-		at32_select_gpio(GPIO_PIN_PA(4),
-				 AT32_GPIOF_OUTPUT | AT32_GPIOF_HIGH);
-		at32_select_gpio(GPIO_PIN_PA(5),
-				 AT32_GPIOF_OUTPUT | AT32_GPIOF_HIGH);
+		at32_spi_setup_slaves(0, b, n, spi0_pins);
 		break;
 
 	case 1:
@@ -775,20 +803,14 @@ struct platform_device *__init at32_add_device_spi(unsigned int id)
 		select_peripheral(PB(0),  PERIPH_B, 0);	/* MISO  */
 		select_peripheral(PB(1),  PERIPH_B, 0);	/* MOSI  */
 		select_peripheral(PB(5),  PERIPH_B, 0);	/* SCK   */
-
-		/* NPCS[2:0] */
-		at32_select_gpio(GPIO_PIN_PB(2),
-				 AT32_GPIOF_OUTPUT | AT32_GPIOF_HIGH);
-		at32_select_gpio(GPIO_PIN_PB(3),
-				 AT32_GPIOF_OUTPUT | AT32_GPIOF_HIGH);
-		at32_select_gpio(GPIO_PIN_PB(4),
-				 AT32_GPIOF_OUTPUT | AT32_GPIOF_HIGH);
+		at32_spi_setup_slaves(1, b, n, spi1_pins);
 		break;
 
 	default:
 		return NULL;
 	}
 
+	spi_register_board_info(b, n);
 	platform_device_register(pdev);
 	return pdev;
 }
@@ -872,6 +894,50 @@ at32_add_device_lcdc(unsigned int id, struct lcdc_platform_data *data)
 	return pdev;
 }
 
+/* --------------------------------------------------------------------
+ *  GCLK
+ * -------------------------------------------------------------------- */
+static struct clk gclk0 = {
+	.name		= "gclk0",
+	.mode		= genclk_mode,
+	.get_rate	= genclk_get_rate,
+	.set_rate	= genclk_set_rate,
+	.set_parent	= genclk_set_parent,
+	.index		= 0,
+};
+static struct clk gclk1 = {
+	.name		= "gclk1",
+	.mode		= genclk_mode,
+	.get_rate	= genclk_get_rate,
+	.set_rate	= genclk_set_rate,
+	.set_parent	= genclk_set_parent,
+	.index		= 1,
+};
+static struct clk gclk2 = {
+	.name		= "gclk2",
+	.mode		= genclk_mode,
+	.get_rate	= genclk_get_rate,
+	.set_rate	= genclk_set_rate,
+	.set_parent	= genclk_set_parent,
+	.index		= 2,
+};
+static struct clk gclk3 = {
+	.name		= "gclk3",
+	.mode		= genclk_mode,
+	.get_rate	= genclk_get_rate,
+	.set_rate	= genclk_set_rate,
+	.set_parent	= genclk_set_parent,
+	.index		= 3,
+};
+static struct clk gclk4 = {
+	.name		= "gclk4",
+	.mode		= genclk_mode,
+	.get_rate	= genclk_get_rate,
+	.set_rate	= genclk_set_rate,
+	.set_parent	= genclk_set_parent,
+	.index		= 4,
+};
+
 struct clk *at32_clock_list[] = {
 	&osc32k,
 	&osc0,
@@ -908,6 +974,11 @@ struct clk *at32_clock_list[] = {
 	&atmel_spi1_spi_clk,
 	&lcdc0_hclk,
 	&lcdc0_pixclk,
+	&gclk0,
+	&gclk1,
+	&gclk2,
+	&gclk3,
+	&gclk4,
 };
 unsigned int at32_nr_clocks = ARRAY_SIZE(at32_clock_list);
 
@@ -936,6 +1007,13 @@ void __init at32_clock_init(void)
 	if (sm_readl(sm, PM_PLL1) & SM_BIT(PLLOSC))
 		pll1.parent = &osc1;
 
+	genclk_init_parent(&gclk0);
+	genclk_init_parent(&gclk1);
+	genclk_init_parent(&gclk2);
+	genclk_init_parent(&gclk3);
+	genclk_init_parent(&gclk4);
+	genclk_init_parent(&lcdc0_pixclk);
+
 	/*
 	 * Turn on all clocks that have at least one user already, and
 	 * turn off everything else. We only do this for module
diff --git a/arch/avr32/mach-at32ap/clock.c b/arch/avr32/mach-at32ap/clock.c
index 3d0d109..49e7b12 100644
--- a/arch/avr32/mach-at32ap/clock.c
+++ b/arch/avr32/mach-at32ap/clock.c
@@ -63,7 +63,11 @@ EXPORT_SYMBOL(clk_enable);
 
 static void __clk_disable(struct clk *clk)
 {
-	BUG_ON(clk->users == 0);
+	if (clk->users == 0) {
+		printk(KERN_ERR "%s: mismatched disable\n", clk->name);
+		WARN_ON(1);
+		return;
+	}
 
 	if (--clk->users == 0 && clk->mode)
 		clk->mode(clk, 0);
diff --git a/include/asm-avr32/arch-at32ap/board.h b/include/asm-avr32/arch-at32ap/board.h
index b120ee0..1a7b07d 100644
--- a/include/asm-avr32/arch-at32ap/board.h
+++ b/include/asm-avr32/arch-at32ap/board.h
@@ -26,7 +26,9 @@ struct eth_platform_data {
 struct platform_device *
 at32_add_device_eth(unsigned int id, struct eth_platform_data *data);
 
-struct platform_device *at32_add_device_spi(unsigned int id);
+struct spi_board_info;
+struct platform_device *
+at32_add_device_spi(unsigned int id, struct spi_board_info *b, unsigned int n);
 
 struct lcdc_platform_data {
 	unsigned long fbmem_start;
diff --git a/include/asm-avr32/io.h b/include/asm-avr32/io.h
index eec4750..c08e810 100644
--- a/include/asm-avr32/io.h
+++ b/include/asm-avr32/io.h
@@ -28,13 +28,13 @@ static __inline__ void * phys_to_virt(unsigned long address)
  * Generic IO read/write.  These perform native-endian accesses.  Note
  * that some architectures will want to re-define __raw_{read,write}w.
  */
-extern void __raw_writesb(unsigned int addr, const void *data, int bytelen);
-extern void __raw_writesw(unsigned int addr, const void *data, int wordlen);
-extern void __raw_writesl(unsigned int addr, const void *data, int longlen);
+extern void __raw_writesb(void __iomem *addr, const void *data, int bytelen);
+extern void __raw_writesw(void __iomem *addr, const void *data, int wordlen);
+extern void __raw_writesl(void __iomem *addr, const void *data, int longlen);
 
-extern void __raw_readsb(unsigned int addr, void *data, int bytelen);
-extern void __raw_readsw(unsigned int addr, void *data, int wordlen);
-extern void __raw_readsl(unsigned int addr, void *data, int longlen);
+extern void __raw_readsb(const void __iomem *addr, void *data, int bytelen);
+extern void __raw_readsw(const void __iomem *addr, void *data, int wordlen);
+extern void __raw_readsl(const void __iomem *addr, void *data, int longlen);
 
 static inline void writeb(unsigned char b, volatile void __iomem *addr)
 {
@@ -252,6 +252,9 @@ extern void __iounmap(void __iomem *addr);
 #define ioremap(offset, size)			\
 	__ioremap((offset), (size), 0)
 
+#define ioremap_nocache(offset, size)		\
+	__ioremap((offset), (size), 0)
+
 #define iounmap(addr)				\
 	__iounmap(addr)
 
@@ -263,6 +266,14 @@ extern void __iounmap(void __iomem *addr);
 #define page_to_bus page_to_phys
 #define bus_to_page phys_to_page
 
+/*
+ * Create a virtual mapping cookie for an IO port range.  There exists
+ * no such thing as port-based I/O on AVR32, so a regular ioremap()
+ * should do what we need.
+ */
+#define ioport_map(port, nr)	ioremap(port, nr)
+#define ioport_unmap(port)	iounmap(port)
+
 #define dma_cache_wback_inv(_start, _size)	\
 	flush_dcache_region(_start, _size)
 #define dma_cache_inv(_start, _size)		\
diff --git a/include/asm-avr32/unistd.h b/include/asm-avr32/unistd.h
index 56ed1f9..8f51204 100644
--- a/include/asm-avr32/unistd.h
+++ b/include/asm-avr32/unistd.h
@@ -120,7 +120,7 @@
 #define __NR_getitimer		105
 #define __NR_swapoff		106
 #define __NR_sysinfo		107
-#define __NR_ipc		108
+/* 108 was __NR_ipc for a little while */
 #define __NR_sendfile		109
 #define __NR_setdomainname	110
 #define __NR_uname		111
@@ -282,8 +282,21 @@
 #define __NR_vmsplice		264
 #define __NR_epoll_pwait	265
 
+#define __NR_msgget		266
+#define __NR_msgsnd		267
+#define __NR_msgrcv		268
+#define __NR_msgctl		269
+#define __NR_semget		270
+#define __NR_semop		271
+#define __NR_semctl		272
+#define __NR_semtimedop		273
+#define __NR_shmat		274
+#define __NR_shmget		275
+#define __NR_shmdt		276
+#define __NR_shmctl		277
+
 #ifdef __KERNEL__
-#define NR_syscalls		266
+#define NR_syscalls		278
 
 
 #define __ARCH_WANT_IPC_PARSE_VERSION

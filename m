Return-Path: <linux-kernel-owner+w=401wt.eu-S1946491AbXBIO6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946491AbXBIO6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 09:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946497AbXBIO6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 09:58:12 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:61916 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946491AbXBIO6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 09:58:09 -0500
Date: Fri, 9 Feb 2007 15:57:45 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] AVR32 update
Message-ID: <20070209155745.23bd6080@dhcp-252-105.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the 'for-linus' branch of

git://www.atmel.no/~hskinnemoen/linux/kernel/avr32.git for-linus

to receive the following updates.

David, this means that everything should be ready for the SPI driver
on my part. I've tested it on top of this lot, and it works fine.

Haavard

 arch/avr32/boards/atstk1000/Makefile       |    2 +-
 arch/avr32/boards/atstk1000/atstk1002.c    |   53 ++++++-
 arch/avr32/boards/atstk1000/spi.c          |   27 ---
 arch/avr32/kernel/cpu.c                    |    1 +
 arch/avr32/kernel/irq.c                    |    1 +
 arch/avr32/kernel/setup.c                  |    4 +-
 arch/avr32/lib/libgcc.h                    |   33 ----
 arch/avr32/lib/longlong.h                  |   98 -----------
 arch/avr32/mach-at32ap/Makefile            |    2 +-
 arch/avr32/mach-at32ap/at32ap7000.c        |   60 ++++++--
 arch/avr32/mach-at32ap/extint.c            |   36 ++--
 arch/avr32/mach-at32ap/pio.c               |  255 ++++++++++++++++++++++++++--
 arch/avr32/mm/cache.c                      |   32 +++-
 include/asm-avr32/arch-at32ap/at32ap7000.h |    2 +
 include/asm-avr32/arch-at32ap/gpio.h       |   27 +++
 include/asm-avr32/arch-at32ap/irq.h        |   14 ++
 include/asm-avr32/arch-at32ap/portmux.h    |    8 +-
 include/asm-avr32/checksum.h               |    2 +-
 include/asm-avr32/dma-mapping.h            |    8 +
 include/asm-avr32/gpio.h                   |    6 +
 include/asm-avr32/irq.h                    |    8 +-
 include/asm-avr32/posix_types.h            |    2 +-
 include/asm-avr32/uaccess.h                |    6 -
 23 files changed, 455 insertions(+), 232 deletions(-)
 delete mode 100644 arch/avr32/boards/atstk1000/spi.c
 delete mode 100644 arch/avr32/lib/libgcc.h
 delete mode 100644 arch/avr32/lib/longlong.h
 create mode 100644 include/asm-avr32/arch-at32ap/gpio.h
 create mode 100644 include/asm-avr32/arch-at32ap/irq.h
 create mode 100644 include/asm-avr32/gpio.h

Ahmed S. Darwish (1):
      [AVR32] Use ARRAY_SIZE macro when appropriate

David Brownell (4):
      [AVR32] /proc/interrupts display
      [AVR32] fix serial port setup on ATSTK1000
      [AVR32] ext int fixes
      [AVR32] Fix incorrect invalidation of shared cachelines

Haavard Skinnemoen (9):
      [AVR32] Implement dma_mapping_error()
      [AVR32] GPIO API implementation
      [AVR32] Don't reset PIO state at bootup
      [AVR32] Introduce at32_reserve_pin()
      [AVR32] Add PIOE device and reserve SDRAM pins
      [AVR32] SPI platform code update
      [AVR32] Remove last remains of libgcc
      [AVR32] ssize_t should be long, not int
      [AVR32] Add missing #include <linux/module.h>

Robert P. J. Day (1):
      Remove a couple final references to obsolete verify_area().

diff --git a/arch/avr32/boards/atstk1000/Makefile b/arch/avr32/boards/atstk1000/Makefile
index df94994..8e09922 100644
--- a/arch/avr32/boards/atstk1000/Makefile
+++ b/arch/avr32/boards/atstk1000/Makefile
@@ -1,2 +1,2 @@
-obj-y				+= setup.o spi.o flash.o
+obj-y				+= setup.o flash.o
 obj-$(CONFIG_BOARD_ATSTK1002)	+= atstk1002.o
diff --git a/arch/avr32/boards/atstk1000/atstk1002.c b/arch/avr32/boards/atstk1000/atstk1002.c
index 32b361f..d47e39f 100644
--- a/arch/avr32/boards/atstk1000/atstk1002.c
+++ b/arch/avr32/boards/atstk1000/atstk1002.c
@@ -8,17 +8,24 @@
  * published by the Free Software Foundation.
  */
 #include <linux/clk.h>
+#include <linux/device.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/spi/spi.h>
 
 #include <asm/io.h>
 #include <asm/setup.h>
+#include <asm/arch/at32ap7000.h>
 #include <asm/arch/board.h>
 #include <asm/arch/init.h>
+#include <asm/arch/portmux.h>
+
+
+#define	SW2_DEFAULT		/* MMCI and UART_A available */
 
 struct eth_addr {
 	u8 addr[6];
@@ -29,6 +36,16 @@ static struct eth_addr __initdata hw_addr[2];
 static struct eth_platform_data __initdata eth_data[2];
 extern struct lcdc_platform_data atstk1000_fb0_data;
 
+static struct spi_board_info spi_board_info[] __initdata = {
+	{
+		.modalias	= "ltv350qv",
+		.controller_data = (void *)GPIO_PIN_PA(4),
+		.max_speed_hz	= 16000000,
+		.bus_num	= 0,
+		.chip_select	= 1,
+	},
+};
+
 /*
  * The next two functions should go away as the boot loader is
  * supposed to initialize the macb address registers with a valid
@@ -86,23 +103,53 @@ static void __init set_hw_addr(struct platform_device *pdev)
 
 void __init setup_board(void)
 {
-	at32_map_usart(1, 0);	/* /dev/ttyS0 */
-	at32_map_usart(2, 1);	/* /dev/ttyS1 */
-	at32_map_usart(3, 2);	/* /dev/ttyS2 */
+#ifdef	SW2_DEFAULT
+	at32_map_usart(1, 0);	/* USART 1/A: /dev/ttyS0, DB9 */
+#else
+	at32_map_usart(0, 1);	/* USART 0/B: /dev/ttyS1, IRDA */
+#endif
+	/* USART 2/unused: expansion connector */
+	at32_map_usart(3, 2);	/* USART 3/C: /dev/ttyS2, DB9 */
 
 	at32_setup_serial_console(0);
 }
 
 static int __init atstk1002_init(void)
 {
+	/*
+	 * ATSTK1000 uses 32-bit SDRAM interface. Reserve the
+	 * SDRAM-specific pins so that nobody messes with them.
+	 */
+	at32_reserve_pin(GPIO_PIN_PE(0));	/* DATA[16]	*/
+	at32_reserve_pin(GPIO_PIN_PE(1));	/* DATA[17]	*/
+	at32_reserve_pin(GPIO_PIN_PE(2));	/* DATA[18]	*/
+	at32_reserve_pin(GPIO_PIN_PE(3));	/* DATA[19]	*/
+	at32_reserve_pin(GPIO_PIN_PE(4));	/* DATA[20]	*/
+	at32_reserve_pin(GPIO_PIN_PE(5));	/* DATA[21]	*/
+	at32_reserve_pin(GPIO_PIN_PE(6));	/* DATA[22]	*/
+	at32_reserve_pin(GPIO_PIN_PE(7));	/* DATA[23]	*/
+	at32_reserve_pin(GPIO_PIN_PE(8));	/* DATA[24]	*/
+	at32_reserve_pin(GPIO_PIN_PE(9));	/* DATA[25]	*/
+	at32_reserve_pin(GPIO_PIN_PE(10));	/* DATA[26]	*/
+	at32_reserve_pin(GPIO_PIN_PE(11));	/* DATA[27]	*/
+	at32_reserve_pin(GPIO_PIN_PE(12));	/* DATA[28]	*/
+	at32_reserve_pin(GPIO_PIN_PE(13));	/* DATA[29]	*/
+	at32_reserve_pin(GPIO_PIN_PE(14));	/* DATA[30]	*/
+	at32_reserve_pin(GPIO_PIN_PE(15));	/* DATA[31]	*/
+	at32_reserve_pin(GPIO_PIN_PE(26));	/* SDCS		*/
+
 	at32_add_system_devices();
 
+#ifdef	SW2_DEFAULT
 	at32_add_device_usart(0);
+#else
 	at32_add_device_usart(1);
+#endif
 	at32_add_device_usart(2);
 
 	set_hw_addr(at32_add_device_eth(0, &eth_data[0]));
 
+	spi_register_board_info(spi_board_info, ARRAY_SIZE(spi_board_info));
 	at32_add_device_spi(0);
 	at32_add_device_lcdc(0, &atstk1000_fb0_data);
 
diff --git a/arch/avr32/boards/atstk1000/spi.c b/arch/avr32/boards/atstk1000/spi.c
deleted file mode 100644
index 567726c..0000000
--- a/arch/avr32/boards/atstk1000/spi.c
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * ATSTK1000 SPI devices
- *
- * Copyright (C) 2005 Atmel Norway
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/device.h>
-#include <linux/spi/spi.h>
-
-static struct spi_board_info spi_board_info[] __initdata = {
-	{
-		.modalias	= "ltv350qv",
-		.max_speed_hz	= 16000000,
-		.bus_num	= 0,
-		.chip_select	= 1,
-	},
-};
-
-static int board_init_spi(void)
-{
-	spi_register_board_info(spi_board_info, ARRAY_SIZE(spi_board_info));
-	return 0;
-}
-arch_initcall(board_init_spi);
diff --git a/arch/avr32/kernel/cpu.c b/arch/avr32/kernel/cpu.c
index 342452b..2e72fd2 100644
--- a/arch/avr32/kernel/cpu.c
+++ b/arch/avr32/kernel/cpu.c
@@ -9,6 +9,7 @@
 #include <linux/sysdev.h>
 #include <linux/seq_file.h>
 #include <linux/cpu.h>
+#include <linux/module.h>
 #include <linux/percpu.h>
 #include <linux/param.h>
 #include <linux/errno.h>
diff --git a/arch/avr32/kernel/irq.c b/arch/avr32/kernel/irq.c
index 856f354..fd31124 100644
--- a/arch/avr32/kernel/irq.c
+++ b/arch/avr32/kernel/irq.c
@@ -57,6 +57,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%3d: ", i);
 		for_each_online_cpu(cpu)
 			seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
+		seq_printf(p, " %8s", irq_desc[i].chip->name ? : "-");
 		seq_printf(p, "  %s", action->name);
 		for (action = action->next; action; action = action->next)
 			seq_printf(p, ", %s", action->name);
diff --git a/arch/avr32/kernel/setup.c b/arch/avr32/kernel/setup.c
index a342116..c6734ae 100644
--- a/arch/avr32/kernel/setup.c
+++ b/arch/avr32/kernel/setup.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/root_dev.h>
 #include <linux/cpu.h>
+#include <linux/kernel.h>
 
 #include <asm/sections.h>
 #include <asm/processor.h>
@@ -174,8 +175,7 @@ static int __init parse_tag_mem_range(struct tag *tag,
 	 * Copy the data so the bootmem init code doesn't need to care
 	 * about it.
 	 */
-	if (mem_range_next_free >=
-	    (sizeof(mem_range_cache) / sizeof(mem_range_cache[0])))
+	if (mem_range_next_free >= ARRAY_SIZE(mem_range_cache))
 		panic("Physical memory map too complex!\n");
 
 	new = &mem_range_cache[mem_range_next_free++];
diff --git a/arch/avr32/lib/libgcc.h b/arch/avr32/lib/libgcc.h
deleted file mode 100644
index 5a091b5..0000000
--- a/arch/avr32/lib/libgcc.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/* Definitions for various functions 'borrowed' from gcc-3.4.3 */
-
-#define BITS_PER_UNIT	8
-
-typedef		 int QItype	__attribute__ ((mode (QI)));
-typedef unsigned int UQItype	__attribute__ ((mode (QI)));
-typedef		 int HItype	__attribute__ ((mode (HI)));
-typedef unsigned int UHItype	__attribute__ ((mode (HI)));
-typedef 	 int SItype	__attribute__ ((mode (SI)));
-typedef unsigned int USItype	__attribute__ ((mode (SI)));
-typedef		 int DItype	__attribute__ ((mode (DI)));
-typedef unsigned int UDItype	__attribute__ ((mode (DI)));
-typedef 	float SFtype	__attribute__ ((mode (SF)));
-typedef		float DFtype	__attribute__ ((mode (DF)));
-typedef int word_type __attribute__ ((mode (__word__)));
-
-#define W_TYPE_SIZE (4 * BITS_PER_UNIT)
-#define Wtype	SItype
-#define UWtype	USItype
-#define HWtype	SItype
-#define UHWtype	USItype
-#define DWtype	DItype
-#define UDWtype	UDItype
-#define __NW(a,b)	__ ## a ## si ## b
-#define __NDW(a,b)	__ ## a ## di ## b
-
-struct DWstruct {Wtype high, low;};
-
-typedef union
-{
-  struct DWstruct s;
-  DWtype ll;
-} DWunion;
diff --git a/arch/avr32/lib/longlong.h b/arch/avr32/lib/longlong.h
deleted file mode 100644
index cd5e369..0000000
--- a/arch/avr32/lib/longlong.h
+++ /dev/null
@@ -1,98 +0,0 @@
-/* longlong.h -- definitions for mixed size 32/64 bit arithmetic.
-   Copyright (C) 1991, 1992, 1994, 1995, 1996, 1997, 1998, 1999, 2000
-   Free Software Foundation, Inc.
-
-   This definition file is free software; you can redistribute it
-   and/or modify it under the terms of the GNU General Public
-   License as published by the Free Software Foundation; either
-   version 2, or (at your option) any later version.
-
-   This definition file is distributed in the hope that it will be
-   useful, but WITHOUT ANY WARRANTY; without even the implied
-   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-   See the GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 59 Temple Place - Suite 330,
-   Boston, MA 02111-1307, USA.  */
-
-/* Borrowed from gcc-3.4.3 */
-
-#define __BITS4 (W_TYPE_SIZE / 4)
-#define __ll_B ((UWtype) 1 << (W_TYPE_SIZE / 2))
-#define __ll_lowpart(t) ((UWtype) (t) & (__ll_B - 1))
-#define __ll_highpart(t) ((UWtype) (t) >> (W_TYPE_SIZE / 2))
-
-#define count_leading_zeros(count, x) ((count) = __builtin_clz(x))
-
-#define __udiv_qrnnd_c(q, r, n1, n0, d) \
-  do {									\
-    UWtype __d1, __d0, __q1, __q0;					\
-    UWtype __r1, __r0, __m;						\
-    __d1 = __ll_highpart (d);						\
-    __d0 = __ll_lowpart (d);						\
-									\
-    __r1 = (n1) % __d1;							\
-    __q1 = (n1) / __d1;							\
-    __m = (UWtype) __q1 * __d0;						\
-    __r1 = __r1 * __ll_B | __ll_highpart (n0);				\
-    if (__r1 < __m)							\
-      {									\
-	__q1--, __r1 += (d);						\
-	if (__r1 >= (d)) /* i.e. we didn't get carry when adding to __r1 */\
-	  if (__r1 < __m)						\
-	    __q1--, __r1 += (d);					\
-      }									\
-    __r1 -= __m;							\
-									\
-    __r0 = __r1 % __d1;							\
-    __q0 = __r1 / __d1;							\
-    __m = (UWtype) __q0 * __d0;						\
-    __r0 = __r0 * __ll_B | __ll_lowpart (n0);				\
-    if (__r0 < __m)							\
-      {									\
-	__q0--, __r0 += (d);						\
-	if (__r0 >= (d))						\
-	  if (__r0 < __m)						\
-	    __q0--, __r0 += (d);					\
-      }									\
-    __r0 -= __m;							\
-									\
-    (q) = (UWtype) __q1 * __ll_B | __q0;				\
-    (r) = __r0;								\
-  } while (0)
-
-#define udiv_qrnnd __udiv_qrnnd_c
-
-#define sub_ddmmss(sh, sl, ah, al, bh, bl) \
-  do {									\
-    UWtype __x;								\
-    __x = (al) - (bl);							\
-    (sh) = (ah) - (bh) - (__x > (al));					\
-    (sl) = __x;								\
-  } while (0)
-
-#define umul_ppmm(w1, w0, u, v)						\
-  do {									\
-    UWtype __x0, __x1, __x2, __x3;					\
-    UHWtype __ul, __vl, __uh, __vh;					\
-									\
-    __ul = __ll_lowpart (u);						\
-    __uh = __ll_highpart (u);						\
-    __vl = __ll_lowpart (v);						\
-    __vh = __ll_highpart (v);						\
-									\
-    __x0 = (UWtype) __ul * __vl;					\
-    __x1 = (UWtype) __ul * __vh;					\
-    __x2 = (UWtype) __uh * __vl;					\
-    __x3 = (UWtype) __uh * __vh;					\
-									\
-    __x1 += __ll_highpart (__x0);/* this can't give carry */		\
-    __x1 += __x2;		/* but this indeed can */		\
-    if (__x1 < __x2)		/* did we get it? */			\
-      __x3 += __ll_B;		/* yes, add it in the proper pos.  */	\
-									\
-    (w1) = __x3 + __ll_highpart (__x1);					\
-    (w0) = __ll_lowpart (__x1) * __ll_B + __ll_lowpart (__x0);		\
-  } while (0)
diff --git a/arch/avr32/mach-at32ap/Makefile b/arch/avr32/mach-at32ap/Makefile
index f62eb69..b21bea9 100644
--- a/arch/avr32/mach-at32ap/Makefile
+++ b/arch/avr32/mach-at32ap/Makefile
@@ -1,2 +1,2 @@
-obj-y				+= at32ap.o clock.o pio.o intc.o extint.o hsmc.o
+obj-y				+= at32ap.o clock.o intc.o extint.o pio.o hsmc.o
 obj-$(CONFIG_CPU_AT32AP7000)	+= at32ap7000.o
diff --git a/arch/avr32/mach-at32ap/at32ap7000.c b/arch/avr32/mach-at32ap/at32ap7000.c
index 48f4ef3..c1e477e 100644
--- a/arch/avr32/mach-at32ap/at32ap7000.c
+++ b/arch/avr32/mach-at32ap/at32ap7000.c
@@ -496,9 +496,16 @@ static struct resource pio3_resource[] = {
 DEFINE_DEV(pio, 3);
 DEV_CLK(mck, pio3, pba, 13);
 
+static struct resource pio4_resource[] = {
+	PBMEM(0xffe03800),
+	IRQ(17),
+};
+DEFINE_DEV(pio, 4);
+DEV_CLK(mck, pio4, pba, 14);
+
 void __init at32_add_system_devices(void)
 {
-	system_manager.eim_first_irq = NR_INTERNAL_IRQS;
+	system_manager.eim_first_irq = EIM_IRQ_BASE;
 
 	platform_device_register(&at32_sm_device);
 	platform_device_register(&at32_intc0_device);
@@ -509,6 +516,7 @@ void __init at32_add_system_devices(void)
 	platform_device_register(&pio1_device);
 	platform_device_register(&pio2_device);
 	platform_device_register(&pio3_device);
+	platform_device_register(&pio4_device);
 }
 
 /* --------------------------------------------------------------------
@@ -521,7 +529,7 @@ static struct atmel_uart_data atmel_usart0_data = {
 };
 static struct resource atmel_usart0_resource[] = {
 	PBMEM(0xffe00c00),
-	IRQ(7),
+	IRQ(6),
 };
 DEFINE_DEV_DATA(atmel_usart, 0);
 DEV_CLK(usart, atmel_usart0, pba, 4);
@@ -583,7 +591,7 @@ static inline void configure_usart3_pins(void)
 	select_peripheral(PB(17), PERIPH_B, 0);	/* TXD	*/
 }
 
-static struct platform_device *at32_usarts[4];
+static struct platform_device *__initdata at32_usarts[4];
 
 void __init at32_map_usart(unsigned int hw_id, unsigned int line)
 {
@@ -728,12 +736,19 @@ at32_add_device_eth(unsigned int id, struct eth_platform_data *data)
 /* --------------------------------------------------------------------
  *  SPI
  * -------------------------------------------------------------------- */
-static struct resource spi0_resource[] = {
+static struct resource atmel_spi0_resource[] = {
 	PBMEM(0xffe00000),
 	IRQ(3),
 };
-DEFINE_DEV(spi, 0);
-DEV_CLK(mck, spi0, pba, 0);
+DEFINE_DEV(atmel_spi, 0);
+DEV_CLK(spi_clk, atmel_spi0, pba, 0);
+
+static struct resource atmel_spi1_resource[] = {
+	PBMEM(0xffe00400),
+	IRQ(4),
+};
+DEFINE_DEV(atmel_spi, 1);
+DEV_CLK(spi_clk, atmel_spi1, pba, 1);
 
 struct platform_device *__init at32_add_device_spi(unsigned int id)
 {
@@ -741,13 +756,33 @@ struct platform_device *__init at32_add_device_spi(unsigned int id)
 
 	switch (id) {
 	case 0:
-		pdev = &spi0_device;
+		pdev = &atmel_spi0_device;
 		select_peripheral(PA(0),  PERIPH_A, 0);	/* MISO	 */
 		select_peripheral(PA(1),  PERIPH_A, 0);	/* MOSI	 */
 		select_peripheral(PA(2),  PERIPH_A, 0);	/* SCK	 */
-		select_peripheral(PA(3),  PERIPH_A, 0);	/* NPCS0 */
-		select_peripheral(PA(4),  PERIPH_A, 0);	/* NPCS1 */
-		select_peripheral(PA(5),  PERIPH_A, 0);	/* NPCS2 */
+
+		/* NPCS[2:0] */
+		at32_select_gpio(GPIO_PIN_PA(3),
+				 AT32_GPIOF_OUTPUT | AT32_GPIOF_HIGH);
+		at32_select_gpio(GPIO_PIN_PA(4),
+				 AT32_GPIOF_OUTPUT | AT32_GPIOF_HIGH);
+		at32_select_gpio(GPIO_PIN_PA(5),
+				 AT32_GPIOF_OUTPUT | AT32_GPIOF_HIGH);
+		break;
+
+	case 1:
+		pdev = &atmel_spi1_device;
+		select_peripheral(PB(0),  PERIPH_B, 0);	/* MISO  */
+		select_peripheral(PB(1),  PERIPH_B, 0);	/* MOSI  */
+		select_peripheral(PB(5),  PERIPH_B, 0);	/* SCK   */
+
+		/* NPCS[2:0] */
+		at32_select_gpio(GPIO_PIN_PB(2),
+				 AT32_GPIOF_OUTPUT | AT32_GPIOF_HIGH);
+		at32_select_gpio(GPIO_PIN_PB(3),
+				 AT32_GPIOF_OUTPUT | AT32_GPIOF_HIGH);
+		at32_select_gpio(GPIO_PIN_PB(4),
+				 AT32_GPIOF_OUTPUT | AT32_GPIOF_HIGH);
 		break;
 
 	default:
@@ -860,6 +895,7 @@ struct clk *at32_clock_list[] = {
 	&pio1_mck,
 	&pio2_mck,
 	&pio3_mck,
+	&pio4_mck,
 	&atmel_usart0_usart,
 	&atmel_usart1_usart,
 	&atmel_usart2_usart,
@@ -868,7 +904,8 @@ struct clk *at32_clock_list[] = {
 	&macb0_pclk,
 	&macb1_hclk,
 	&macb1_pclk,
-	&spi0_mck,
+	&atmel_spi0_spi_clk,
+	&atmel_spi1_spi_clk,
 	&lcdc0_hclk,
 	&lcdc0_pixclk,
 };
@@ -880,6 +917,7 @@ void __init at32_portmux_init(void)
 	at32_init_pio(&pio1_device);
 	at32_init_pio(&pio2_device);
 	at32_init_pio(&pio3_device);
+	at32_init_pio(&pio4_device);
 }
 
 void __init at32_clock_init(void)
diff --git a/arch/avr32/mach-at32ap/extint.c b/arch/avr32/mach-at32ap/extint.c
index b59272e..4a60ecc 100644
--- a/arch/avr32/mach-at32ap/extint.c
+++ b/arch/avr32/mach-at32ap/extint.c
@@ -55,20 +55,11 @@ static int eim_set_irq_type(unsigned int irq, unsigned int flow_type)
 	unsigned long flags;
 	int ret = 0;
 
+	flow_type &= IRQ_TYPE_SENSE_MASK;
 	if (flow_type == IRQ_TYPE_NONE)
 		flow_type = IRQ_TYPE_LEVEL_LOW;
 
 	desc = &irq_desc[irq];
-	desc->status &= ~(IRQ_TYPE_SENSE_MASK | IRQ_LEVEL);
-	desc->status |= flow_type & IRQ_TYPE_SENSE_MASK;
-
-	if (flow_type & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH)) {
-		desc->status |= IRQ_LEVEL;
-		set_irq_handler(irq, handle_level_irq);
-	} else {
-		set_irq_handler(irq, handle_edge_irq);
-	}
-
 	spin_lock_irqsave(&sm->lock, flags);
 
 	mode = sm_readl(sm, EIM_MODE);
@@ -97,9 +88,16 @@ static int eim_set_irq_type(unsigned int irq, unsigned int flow_type)
 		break;
 	}
 
-	sm_writel(sm, EIM_MODE, mode);
-	sm_writel(sm, EIM_EDGE, edge);
-	sm_writel(sm, EIM_LEVEL, level);
+	if (ret == 0) {
+		sm_writel(sm, EIM_MODE, mode);
+		sm_writel(sm, EIM_EDGE, edge);
+		sm_writel(sm, EIM_LEVEL, level);
+
+		if (flow_type & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
+			flow_type |= IRQ_LEVEL;
+		desc->status &= ~(IRQ_TYPE_SENSE_MASK | IRQ_LEVEL);
+		desc->status |= flow_type;
+	}
 
 	spin_unlock_irqrestore(&sm->lock, flags);
 
@@ -122,8 +120,6 @@ static void demux_eim_irq(unsigned int irq, struct irq_desc *desc)
 	unsigned long status, pending;
 	unsigned int i, ext_irq;
 
-	spin_lock(&sm->lock);
-
 	status = sm_readl(sm, EIM_ISR);
 	pending = status & sm_readl(sm, EIM_IMR);
 
@@ -133,10 +129,11 @@ static void demux_eim_irq(unsigned int irq, struct irq_desc *desc)
 
 		ext_irq = i + sm->eim_first_irq;
 		ext_desc = irq_desc + ext_irq;
-		ext_desc->handle_irq(ext_irq, ext_desc);
+		if (ext_desc->status & IRQ_LEVEL)
+			handle_level_irq(ext_irq, ext_desc);
+		else
+			handle_edge_irq(ext_irq, ext_desc);
 	}
-
-	spin_unlock(&sm->lock);
 }
 
 static int __init eim_init(void)
@@ -168,8 +165,9 @@ static int __init eim_init(void)
 	sm->eim_chip = &eim_chip;
 
 	for (i = 0; i < nr_irqs; i++) {
+		/* NOTE the handler we set here is ignored by the demux */
 		set_irq_chip_and_handler(sm->eim_first_irq + i, &eim_chip,
-					 handle_edge_irq);
+					 handle_level_irq);
 		set_irq_chip_data(sm->eim_first_irq + i, sm);
 	}
 
diff --git a/arch/avr32/mach-at32ap/pio.c b/arch/avr32/mach-at32ap/pio.c
index f1280ed..9ba5654 100644
--- a/arch/avr32/mach-at32ap/pio.c
+++ b/arch/avr32/mach-at32ap/pio.c
@@ -12,7 +12,9 @@
 #include <linux/debugfs.h>
 #include <linux/fs.h>
 #include <linux/platform_device.h>
+#include <linux/irq.h>
 
+#include <asm/gpio.h>
 #include <asm/io.h>
 
 #include <asm/arch/portmux.h>
@@ -26,7 +28,8 @@ struct pio_device {
 	const struct platform_device *pdev;
 	struct clk *clk;
 	u32 pinmux_mask;
-	char name[32];
+	u32 gpio_mask;
+	char name[8];
 };
 
 static struct pio_device pio_dev[MAX_NR_PIO_DEVICES];
@@ -76,6 +79,9 @@ void __init at32_select_periph(unsigned int pin, unsigned int periph,
 	if (!(flags & AT32_GPIOF_PULLUP))
 		pio_writel(pio, PUDR, mask);
 
+	/* gpio_request NOT allowed */
+	set_bit(pin_index, &pio->gpio_mask);
+
 	return;
 
 fail:
@@ -99,19 +105,52 @@ void __init at32_select_gpio(unsigned int pin, unsigned long flags)
 		goto fail;
 	}
 
-	pio_writel(pio, PUER, mask);
-	if (flags & AT32_GPIOF_HIGH)
-		pio_writel(pio, SODR, mask);
-	else
-		pio_writel(pio, CODR, mask);
-	if (flags & AT32_GPIOF_OUTPUT)
+	if (flags & AT32_GPIOF_OUTPUT) {
+		if (flags & AT32_GPIOF_HIGH)
+			pio_writel(pio, SODR, mask);
+		else
+			pio_writel(pio, CODR, mask);
+		pio_writel(pio, PUDR, mask);
 		pio_writel(pio, OER, mask);
-	else
+	} else {
+		if (flags & AT32_GPIOF_PULLUP)
+			pio_writel(pio, PUER, mask);
+		else
+			pio_writel(pio, PUDR, mask);
+		if (flags & AT32_GPIOF_DEGLITCH)
+			pio_writel(pio, IFER, mask);
+		else
+			pio_writel(pio, IFDR, mask);
 		pio_writel(pio, ODR, mask);
+	}
 
 	pio_writel(pio, PER, mask);
-	if (!(flags & AT32_GPIOF_PULLUP))
-		pio_writel(pio, PUDR, mask);
+
+	/* gpio_request now allowed */
+	clear_bit(pin_index, &pio->gpio_mask);
+
+	return;
+
+fail:
+	dump_stack();
+}
+
+/* Reserve a pin, preventing anyone else from changing its configuration. */
+void __init at32_reserve_pin(unsigned int pin)
+{
+	struct pio_device *pio;
+	unsigned int pin_index = pin & 0x1f;
+
+	pio = gpio_to_pio(pin);
+	if (unlikely(!pio)) {
+		printk("pio: invalid pin %u\n", pin);
+		goto fail;
+	}
+
+	if (unlikely(test_and_set_bit(pin_index, &pio->pinmux_mask))) {
+		printk("%s: pin %u is busy\n", pio->name, pin_index);
+		goto fail;
+	}
 
 	return;
 
@@ -119,20 +158,197 @@ fail:
 	dump_stack();
 }
 
+/*--------------------------------------------------------------------------*/
+
+/* GPIO API */
+
+int gpio_request(unsigned int gpio, const char *label)
+{
+	struct pio_device *pio;
+	unsigned int pin;
+
+	pio = gpio_to_pio(gpio);
+	if (!pio)
+		return -ENODEV;
+
+	pin = gpio & 0x1f;
+	if (test_and_set_bit(pin, &pio->gpio_mask))
+		return -EBUSY;
+
+	return 0;
+}
+EXPORT_SYMBOL(gpio_request);
+
+void gpio_free(unsigned int gpio)
+{
+	struct pio_device *pio;
+	unsigned int pin;
+
+	pio = gpio_to_pio(gpio);
+	if (!pio) {
+		printk(KERN_ERR
+		       "gpio: attempted to free invalid pin %u\n", gpio);
+		return;
+	}
+
+	pin = gpio & 0x1f;
+	if (!test_and_clear_bit(pin, &pio->gpio_mask))
+		printk(KERN_ERR "gpio: freeing free or non-gpio pin %s-%u\n",
+		       pio->name, pin);
+}
+EXPORT_SYMBOL(gpio_free);
+
+int gpio_direction_input(unsigned int gpio)
+{
+	struct pio_device *pio;
+	unsigned int pin;
+
+	pio = gpio_to_pio(gpio);
+	if (!pio)
+		return -ENODEV;
+
+	pin = gpio & 0x1f;
+	pio_writel(pio, ODR, 1 << pin);
+
+	return 0;
+}
+EXPORT_SYMBOL(gpio_direction_input);
+
+int gpio_direction_output(unsigned int gpio)
+{
+	struct pio_device *pio;
+	unsigned int pin;
+
+	pio = gpio_to_pio(gpio);
+	if (!pio)
+		return -ENODEV;
+
+	pin = gpio & 0x1f;
+	pio_writel(pio, OER, 1 << pin);
+
+	return 0;
+}
+EXPORT_SYMBOL(gpio_direction_output);
+
+int gpio_get_value(unsigned int gpio)
+{
+	struct pio_device *pio = &pio_dev[gpio >> 5];
+
+	return (pio_readl(pio, PDSR) >> (gpio & 0x1f)) & 1;
+}
+EXPORT_SYMBOL(gpio_get_value);
+
+void gpio_set_value(unsigned int gpio, int value)
+{
+	struct pio_device *pio = &pio_dev[gpio >> 5];
+	u32 mask;
+
+	mask = 1 << (gpio & 0x1f);
+	if (value)
+		pio_writel(pio, SODR, mask);
+	else
+		pio_writel(pio, CODR, mask);
+}
+EXPORT_SYMBOL(gpio_set_value);
+
+/*--------------------------------------------------------------------------*/
+
+/* GPIO IRQ support */
+
+static void gpio_irq_mask(unsigned irq)
+{
+	unsigned		gpio = irq_to_gpio(irq);
+	struct pio_device	*pio = &pio_dev[gpio >> 5];
+
+	pio_writel(pio, IDR, 1 << (gpio & 0x1f));
+}
+
+static void gpio_irq_unmask(unsigned irq)
+{
+	unsigned		gpio = irq_to_gpio(irq);
+	struct pio_device	*pio = &pio_dev[gpio >> 5];
+
+	pio_writel(pio, IER, 1 << (gpio & 0x1f));
+}
+
+static int gpio_irq_type(unsigned irq, unsigned type)
+{
+	if (type != IRQ_TYPE_EDGE_BOTH && type != IRQ_TYPE_NONE)
+		return -EINVAL;
+
+	return 0;
+}
+
+static struct irq_chip gpio_irqchip = {
+	.name		= "gpio",
+	.mask		= gpio_irq_mask,
+	.unmask		= gpio_irq_unmask,
+	.set_type	= gpio_irq_type,
+};
+
+static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
+{
+	struct pio_device	*pio = get_irq_chip_data(irq);
+	unsigned		gpio_irq;
+
+	gpio_irq = (unsigned) get_irq_data(irq);
+	for (;;) {
+		u32		isr;
+		struct irq_desc	*d;
+
+		/* ack pending GPIO interrupts */
+		isr = pio_readl(pio, ISR) & pio_readl(pio, IMR);
+		if (!isr)
+			break;
+		do {
+			int i;
+
+			i = ffs(isr) - 1;
+			isr &= ~(1 << i);
+
+			i += gpio_irq;
+			d = &irq_desc[i];
+
+			d->handle_irq(i, d);
+		} while (isr);
+	}
+}
+
+static void __init
+gpio_irq_setup(struct pio_device *pio, int irq, int gpio_irq)
+{
+	unsigned	i;
+
+	set_irq_chip_data(irq, pio);
+	set_irq_data(irq, (void *) gpio_irq);
+
+	for (i = 0; i < 32; i++, gpio_irq++) {
+		set_irq_chip_data(gpio_irq, pio);
+		set_irq_chip_and_handler(gpio_irq, &gpio_irqchip,
+				handle_simple_irq);
+	}
+
+	set_irq_chained_handler(irq, gpio_irq_handler);
+}
+
+/*--------------------------------------------------------------------------*/
+
 static int __init pio_probe(struct platform_device *pdev)
 {
 	struct pio_device *pio = NULL;
+	int irq = platform_get_irq(pdev, 0);
+	int gpio_irq_base = GPIO_IRQ_BASE + pdev->id * 32;
 
 	BUG_ON(pdev->id >= MAX_NR_PIO_DEVICES);
 	pio = &pio_dev[pdev->id];
 	BUG_ON(!pio->regs);
 
-	/* TODO: Interrupts */
+	gpio_irq_setup(pio, irq, gpio_irq_base);
 
 	platform_set_drvdata(pdev, pio);
 
-	printk(KERN_INFO "%s: Atmel Port Multiplexer at 0x%p (irq %d)\n",
-	       pio->name, pio->regs, platform_get_irq(pdev, 0));
+	printk(KERN_DEBUG "%s: base 0x%p, irq %d chains %d..%d\n",
+	       pio->name, pio->regs, irq, gpio_irq_base, gpio_irq_base + 31);
 
 	return 0;
 }
@@ -148,7 +364,7 @@ static int __init pio_init(void)
 {
 	return platform_driver_register(&pio_driver);
 }
-subsys_initcall(pio_init);
+postcore_initcall(pio_init);
 
 void __init at32_init_pio(struct platform_device *pdev)
 {
@@ -184,6 +400,13 @@ void __init at32_init_pio(struct platform_device *pdev)
 	pio->pdev = pdev;
 	pio->regs = ioremap(regs->start, regs->end - regs->start + 1);
 
-	pio_writel(pio, ODR, ~0UL);
-	pio_writel(pio, PER, ~0UL);
+	/*
+	 * request_gpio() is only valid for pins that have been
+	 * explicitly configured as GPIO and not previously requested
+	 */
+	pio->gpio_mask = ~0UL;
+
+	/* start with irqs disabled and acked */
+	pio_writel(pio, IDR, ~0UL);
+	(void) pio_readl(pio, ISR);
 }
diff --git a/arch/avr32/mm/cache.c b/arch/avr32/mm/cache.c
index 450515b..fb13f72 100644
--- a/arch/avr32/mm/cache.c
+++ b/arch/avr32/mm/cache.c
@@ -22,18 +22,34 @@
 
 void invalidate_dcache_region(void *start, size_t size)
 {
-	unsigned long v, begin, end, linesz;
+	unsigned long v, begin, end, linesz, mask;
+	int flush = 0;
 
 	linesz = boot_cpu_data.dcache.linesz;
+	mask = linesz - 1;
+
+	/* when first and/or last cachelines are shared, flush them
+	 * instead of invalidating ... never discard valid data!
+	 */
+	begin = (unsigned long)start;
+	end = begin + size - 1;
+
+	if (begin & mask) {
+		flush_dcache_line(start);
+		begin += linesz;
+		flush = 1;
+	}
+	if ((end & mask) != mask) {
+		flush_dcache_line((void *)end);
+		end -= linesz;
+		flush = 1;
+	}
 
-	//printk("invalidate dcache: %p + %u\n", start, size);
-
-	/* You asked for it, you got it */
-	begin = (unsigned long)start & ~(linesz - 1);
-	end = ((unsigned long)start + size + linesz - 1) & ~(linesz - 1);
-
-	for (v = begin; v < end; v += linesz)
+	/* remaining cachelines only need invalidation */
+	for (v = begin; v <= end; v += linesz)
 		invalidate_dcache_line((void *)v);
+	if (flush)
+		flush_write_buffer();
 }
 
 void clean_dcache_region(void *start, size_t size)
diff --git a/include/asm-avr32/arch-at32ap/at32ap7000.h b/include/asm-avr32/arch-at32ap/at32ap7000.h
index ba85e04..3914d7b 100644
--- a/include/asm-avr32/arch-at32ap/at32ap7000.h
+++ b/include/asm-avr32/arch-at32ap/at32ap7000.h
@@ -24,10 +24,12 @@
 #define GPIO_PIOB_BASE	(GPIO_PIOA_BASE + 32)
 #define GPIO_PIOC_BASE	(GPIO_PIOB_BASE + 32)
 #define GPIO_PIOD_BASE	(GPIO_PIOC_BASE + 32)
+#define GPIO_PIOE_BASE	(GPIO_PIOD_BASE + 32)
 
 #define GPIO_PIN_PA(N)	(GPIO_PIOA_BASE + (N))
 #define GPIO_PIN_PB(N)	(GPIO_PIOB_BASE + (N))
 #define GPIO_PIN_PC(N)	(GPIO_PIOC_BASE + (N))
 #define GPIO_PIN_PD(N)	(GPIO_PIOD_BASE + (N))
+#define GPIO_PIN_PE(N)	(GPIO_PIOE_BASE + (N))
 
 #endif /* __ASM_ARCH_AT32AP7000_H__ */
diff --git a/include/asm-avr32/arch-at32ap/gpio.h b/include/asm-avr32/arch-at32ap/gpio.h
new file mode 100644
index 0000000..fcb756b
--- /dev/null
+++ b/include/asm-avr32/arch-at32ap/gpio.h
@@ -0,0 +1,27 @@
+#ifndef __ASM_AVR32_ARCH_GPIO_H
+#define __ASM_AVR32_ARCH_GPIO_H
+
+#include <linux/compiler.h>
+#include <asm/irq.h>
+
+
+/* Arch-neutral GPIO API */
+int __must_check gpio_request(unsigned int gpio, const char *label);
+void gpio_free(unsigned int gpio);
+
+int gpio_direction_input(unsigned int gpio);
+int gpio_direction_output(unsigned int gpio);
+int gpio_get_value(unsigned int gpio);
+void gpio_set_value(unsigned int gpio, int value);
+
+static inline int gpio_to_irq(unsigned int gpio)
+{
+	return gpio + GPIO_IRQ_BASE;
+}
+
+static inline int irq_to_gpio(unsigned int irq)
+{
+	return irq - GPIO_IRQ_BASE;
+}
+
+#endif /* __ASM_AVR32_ARCH_GPIO_H */
diff --git a/include/asm-avr32/arch-at32ap/irq.h b/include/asm-avr32/arch-at32ap/irq.h
new file mode 100644
index 0000000..5adffab
--- /dev/null
+++ b/include/asm-avr32/arch-at32ap/irq.h
@@ -0,0 +1,14 @@
+#ifndef __ASM_AVR32_ARCH_IRQ_H
+#define __ASM_AVR32_ARCH_IRQ_H
+
+#define EIM_IRQ_BASE	NR_INTERNAL_IRQS
+#define NR_EIM_IRQS	32
+
+#define AT32_EXTINT(n)	(EIM_IRQ_BASE + (n))
+
+#define GPIO_IRQ_BASE	(EIM_IRQ_BASE + NR_EIM_IRQS)
+#define NR_GPIO_IRQS	(5 * 32)
+
+#define NR_IRQS		(GPIO_IRQ_BASE + NR_GPIO_IRQS)
+
+#endif /* __ASM_AVR32_ARCH_IRQ_H */
diff --git a/include/asm-avr32/arch-at32ap/portmux.h b/include/asm-avr32/arch-at32ap/portmux.h
index 83c6905..9930871 100644
--- a/include/asm-avr32/arch-at32ap/portmux.h
+++ b/include/asm-avr32/arch-at32ap/portmux.h
@@ -15,12 +15,14 @@
  *
  * The following flags determine the initial state of the pin.
  */
-#define AT32_GPIOF_PULLUP	0x00000001	/* Enable pull-up */
-#define AT32_GPIOF_OUTPUT	0x00000002	/* Enable output driver */
-#define AT32_GPIOF_HIGH		0x00000004	/* Set output high */
+#define AT32_GPIOF_PULLUP	0x00000001	/* (not-OUT) Enable pull-up */
+#define AT32_GPIOF_OUTPUT	0x00000002	/* (OUT) Enable output driver */
+#define AT32_GPIOF_HIGH		0x00000004	/* (OUT) Set output high */
+#define AT32_GPIOF_DEGLITCH	0x00000008	/* (IN) Filter glitches */
 
 void at32_select_periph(unsigned int pin, unsigned int periph,
 			unsigned long flags);
 void at32_select_gpio(unsigned int pin, unsigned long flags);
+void at32_reserve_pin(unsigned int pin);
 
 #endif /* __ASM_ARCH_PORTMUX_H__ */
diff --git a/include/asm-avr32/checksum.h b/include/asm-avr32/checksum.h
index af9d53f..4ddbfd2 100644
--- a/include/asm-avr32/checksum.h
+++ b/include/asm-avr32/checksum.h
@@ -38,7 +38,7 @@ __wsum csum_partial_copy_generic(const void *src, void *dst, int len,
  *	passed in an incorrect kernel address to one of these functions.
  *
  *	If you use these functions directly please don't forget the
- *	verify_area().
+ *	access_ok().
  */
 static inline
 __wsum csum_partial_copy_nocheck(const void *src, void *dst,
diff --git a/include/asm-avr32/dma-mapping.h b/include/asm-avr32/dma-mapping.h
index 5c01e27..115813e 100644
--- a/include/asm-avr32/dma-mapping.h
+++ b/include/asm-avr32/dma-mapping.h
@@ -32,6 +32,14 @@ static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 	return 0;
 }
 
+/*
+ * dma_map_single can't fail as it is implemented now.
+ */
+static inline int dma_mapping_error(dma_addr_t addr)
+{
+	return 0;
+}
+
 /**
  * dma_alloc_coherent - allocate consistent memory for DMA
  * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
diff --git a/include/asm-avr32/gpio.h b/include/asm-avr32/gpio.h
new file mode 100644
index 0000000..19e8ccc
--- /dev/null
+++ b/include/asm-avr32/gpio.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_AVR32_GPIO_H
+#define __ASM_AVR32_GPIO_H
+
+#include <asm/arch/gpio.h>
+
+#endif /* __ASM_AVR32_GPIO_H */
diff --git a/include/asm-avr32/irq.h b/include/asm-avr32/irq.h
index f7e7257..83e6549 100644
--- a/include/asm-avr32/irq.h
+++ b/include/asm-avr32/irq.h
@@ -2,8 +2,12 @@
 #define __ASM_AVR32_IRQ_H
 
 #define NR_INTERNAL_IRQS	64
-#define NR_EXTERNAL_IRQS	64
-#define NR_IRQS			(NR_INTERNAL_IRQS + NR_EXTERNAL_IRQS)
+
+#include <asm/arch/irq.h>
+
+#ifndef NR_IRQS
+#define NR_IRQS			(NR_INTERNAL_IRQS)
+#endif
 
 #define irq_canonicalize(i)	(i)
 
diff --git a/include/asm-avr32/posix_types.h b/include/asm-avr32/posix_types.h
index 2831b03..9e255b9 100644
--- a/include/asm-avr32/posix_types.h
+++ b/include/asm-avr32/posix_types.h
@@ -23,7 +23,7 @@ typedef unsigned short  __kernel_ipc_pid_t;
 typedef unsigned int	__kernel_uid_t;
 typedef unsigned int	__kernel_gid_t;
 typedef unsigned long	__kernel_size_t;
-typedef int             __kernel_ssize_t;
+typedef long		__kernel_ssize_t;
 typedef int             __kernel_ptrdiff_t;
 typedef long            __kernel_time_t;
 typedef long            __kernel_suseconds_t;
diff --git a/include/asm-avr32/uaccess.h b/include/asm-avr32/uaccess.h
index 821deb5..74a679e 100644
--- a/include/asm-avr32/uaccess.h
+++ b/include/asm-avr32/uaccess.h
@@ -68,12 +68,6 @@ static inline void set_fs(mm_segment_t s)
 
 #define access_ok(type, addr, size) (likely(__range_ok(addr, size) == 0))
 
-static inline int
-verify_area(int type, const void __user *addr, unsigned long size)
-{
-	return access_ok(type, addr, size) ? 0 : -EFAULT;
-}
-
 /* Generic arbitrary sized copy. Return the number of bytes NOT copied */
 extern __kernel_size_t __copy_user(void *to, const void *from,
 				   __kernel_size_t n);

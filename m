Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbXKONVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbXKONVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 08:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbXKONVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 08:21:47 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:52540 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754373AbXKONVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 08:21:46 -0500
Date: Thu, 15 Nov 2007 14:21:37 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
Subject: [GIT PULL] avr32 fixes for 2.6.24-rc3
Message-ID: <20071115142137.726fce36@dhcp-255-175.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0-rc1 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from

  ssh://master.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git for-linus

to receive the following updates.

Adrian Bunk (1):
      [AVR32] remove UID16 option

Haavard Skinnemoen (4):
      [AVR32] pcmcia ioaddr_t should be 32 bits on AVR32
      [AVR32] Turn off debugging in SMC driver
      [AVR32] Add missing bit in PCCR sysreg
      [AVR32] Export intc_get_pending symbol

Hans-Christian Egtvedt (1):
      Extend I/O resource for wdt0 for at32ap7000 devices

ben.nizette@iinet.net.au (1):
      [AVR32] Fix duplicate clock index in at32ap machine code

 arch/avr32/Kconfig                  |    3 ---
 arch/avr32/mach-at32ap/at32ap7000.c |    4 ++--
 arch/avr32/mach-at32ap/hsmc.c       |    1 -
 arch/avr32/mach-at32ap/intc.c       |    4 +++-
 include/asm-avr32/sysreg.h          |    2 ++
 include/pcmcia/cs_types.h           |    2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index bbecbd8..4f402c9 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -19,9 +19,6 @@ config AVR32
 	  There is an AVR32 Linux project with a web page at
 	  http://avr32linux.org/.
 
-config UID16
-	bool
-
 config GENERIC_GPIO
 	bool
 	default y
diff --git a/arch/avr32/mach-at32ap/at32ap7000.c b/arch/avr32/mach-at32ap/at32ap7000.c
index a9d9ec0..7c4388f 100644
--- a/arch/avr32/mach-at32ap/at32ap7000.c
+++ b/arch/avr32/mach-at32ap/at32ap7000.c
@@ -474,7 +474,7 @@ static struct resource at32ap700x_rtc0_resource[] = {
 static struct resource at32_wdt0_resource[] = {
 	{
 		.start	= 0xfff000b0,
-		.end	= 0xfff000bf,
+		.end	= 0xfff000cf,
 		.flags	= IORESOURCE_MEM,
 	},
 };
@@ -690,7 +690,7 @@ static struct resource atmel_usart0_resource[] = {
 	IRQ(6),
 };
 DEFINE_DEV_DATA(atmel_usart, 0);
-DEV_CLK(usart, atmel_usart0, pba, 4);
+DEV_CLK(usart, atmel_usart0, pba, 3);
 
 static struct atmel_uart_data atmel_usart1_data = {
 	.use_dma_tx	= 1,
diff --git a/arch/avr32/mach-at32ap/hsmc.c b/arch/avr32/mach-at32ap/hsmc.c
index 704607f..fa427ed 100644
--- a/arch/avr32/mach-at32ap/hsmc.c
+++ b/arch/avr32/mach-at32ap/hsmc.c
@@ -7,7 +7,6 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#define DEBUG
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/init.h>
diff --git a/arch/avr32/mach-at32ap/intc.c b/arch/avr32/mach-at32ap/intc.c
index dd5c009..0b286cd 100644
--- a/arch/avr32/mach-at32ap/intc.c
+++ b/arch/avr32/mach-at32ap/intc.c
@@ -13,6 +13,7 @@
 #include <linux/irq.h>
 #include <linux/platform_device.h>
 
+#include <asm/intc.h>
 #include <asm/io.h>
 
 #include "intc.h"
@@ -136,7 +137,8 @@ fail:
 	panic("Interrupt controller initialization failed!\n");
 }
 
-unsigned long intc_get_pending(int group)
+unsigned long intc_get_pending(unsigned int group)
 {
 	return intc_readl(&intc0, INTREQ0 + 4 * group);
 }
+EXPORT_SYMBOL_GPL(intc_get_pending);
diff --git a/include/asm-avr32/sysreg.h b/include/asm-avr32/sysreg.h
index c02bc83..dd21182 100644
--- a/include/asm-avr32/sysreg.h
+++ b/include/asm-avr32/sysreg.h
@@ -215,6 +215,8 @@
 #define SYSREG_IRP_SIZE				6
 
 /* Bitfields in PCCR */
+#define SYSREG_PCCR_E_OFFSET			0
+#define SYSREG_PCCR_E_SIZE			1
 #define SYSREG_PCCR_R_OFFSET			1
 #define SYSREG_PCCR_R_SIZE			1
 #define SYSREG_PCCR_C_OFFSET			2
diff --git a/include/pcmcia/cs_types.h b/include/pcmcia/cs_types.h
index c1d1629..5f38803 100644
--- a/include/pcmcia/cs_types.h
+++ b/include/pcmcia/cs_types.h
@@ -21,7 +21,7 @@
 #include <sys/types.h>
 #endif
 
-#if defined(__arm__) || defined(__mips__)
+#if defined(__arm__) || defined(__mips__) || defined(__avr32__)
 /* This (ioaddr_t) is exposed to userspace & hence cannot be changed. */
 typedef u_int   ioaddr_t;
 #else

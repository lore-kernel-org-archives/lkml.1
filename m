Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbYEaKd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbYEaKd2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 06:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYEaKdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 06:33:21 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:31577 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbYEaKdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 06:33:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=wu5bra+IruVTPXXfp2tOEs68MFwje0oFApTNdpLf/fOJlRA4XER3Aog203Y1OsCRhVjbNNufbbK2SbOVLtjtn3eEd40qhGw1YI53vDKvc9eMdrGJUx5aF1Qjld1tuzf0aXfcP4eCpIEW47vCY6qsL0uOlm6KNinTtHQxLxEwgII=
Message-ID: <386072610805310333o96c5802q8fb731c0215c3173@mail.gmail.com>
Date: Sat, 31 May 2008 18:33:17 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel List" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Blackfin arch updates for 2.6.26-RC4
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 43c47eafd2011598
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 arch/blackfin/kernel/gptimers.c            |    2 +-
 arch/blackfin/lib/outs.S                   |    2 +-
 arch/blackfin/mach-bf527/boards/ezkit.c    |    4 +-
 arch/blackfin/mach-bf537/boards/Makefile   |    2 +-
 arch/blackfin/mach-bf537/boards/led.S      |  183 ----------------------------
 arch/blackfin/mach-bf548/boards/Makefile   |    2 +-
 arch/blackfin/mach-bf548/boards/cm_bf548.c |    2 +-
 arch/blackfin/mach-bf548/boards/led.S      |  172 --------------------------
 drivers/serial/8250.c                      |    4 +-
 drivers/serial/8250.h                      |    5 -
 include/asm-blackfin/bfin-global.h         |    7 -
 include/asm-blackfin/mach-bf527/anomaly.h  |    5 +-
 include/asm-blackfin/mach-bf533/anomaly.h  |   31 +++---
 include/asm-blackfin/mach-bf537/anomaly.h  |   10 +-
 include/asm-blackfin/mach-bf548/anomaly.h  |    2 +
 include/asm-blackfin/mach-bf561/anomaly.h  |    2 +-
 16 files changed, 35 insertions(+), 400 deletions(-)
 delete mode 100644 arch/blackfin/mach-bf537/boards/led.S
 delete mode 100644 arch/blackfin/mach-bf548/boards/led.S

Bryan Wu (3):
      Blackfin arch: Fix typo. it should be _outsw_8
      Blackfin arch: Fix bug - set corret SSEL and IRQ to enable AD7877 on BF527
      8250 Serial Driver: revert extra IRQ flag definition patch

Michael Hennerich (2):
      Blackfin arch: Cleanup no functional changes
      Blackfin arch: Remove bad and usless code

Mike Frysinger (1):
      Blackfin arch: update anomaly headers from toolchain trunk

diff --git a/arch/blackfin/kernel/gptimers.c b/arch/blackfin/kernel/gptimers.c
index e698554..3a3e961 100644
--- a/arch/blackfin/kernel/gptimers.c
+++ b/arch/blackfin/kernel/gptimers.c
@@ -10,8 +10,8 @@

 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/io.h>

-#include <asm/io.h>
 #include <asm/blackfin.h>
 #include <asm/gptimers.h>

diff --git a/arch/blackfin/lib/outs.S b/arch/blackfin/lib/outs.S
index 3daf960..4685b7a 100644
--- a/arch/blackfin/lib/outs.S
+++ b/arch/blackfin/lib/outs.S
@@ -76,4 +76,4 @@ ENTRY(_outsw_8)
 		R0 = R0 + R1;
 .Lword8_loop_e: W[P0] = R0;
 	RTS;
-ENDPROC(_outsw)
+ENDPROC(_outsw_8)
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c
b/arch/blackfin/mach-bf527/boards/ezkit.c
index bb6d58c..fa4f4e8 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -647,10 +647,10 @@ static struct spi_board_info
bfin_spi_board_info[] __initdata = {
 	{
 		.modalias		= "ad7877",
 		.platform_data		= &bfin_ad7877_ts_info,
-		.irq			= IRQ_PF6,
+		.irq			= IRQ_PF8,
 		.max_speed_hz	= 12500000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num	= 0,
-		.chip_select  = 1,
+		.chip_select  = 2,
 		.controller_data = &spi_ad7877_chip_info,
 	},
 #endif
diff --git a/arch/blackfin/mach-bf537/boards/Makefile
b/arch/blackfin/mach-bf537/boards/Makefile
index 87e450f..c94f7a5 100644
--- a/arch/blackfin/mach-bf537/boards/Makefile
+++ b/arch/blackfin/mach-bf537/boards/Makefile
@@ -3,7 +3,7 @@
 #

 obj-$(CONFIG_GENERIC_BF537_BOARD)      += generic_board.o
-obj-$(CONFIG_BFIN537_STAMP)            += stamp.o led.o
+obj-$(CONFIG_BFIN537_STAMP)            += stamp.o
 obj-$(CONFIG_BFIN537_BLUETECHNIX_CM)   += cm_bf537.o
 obj-$(CONFIG_PNAV10)                   += pnav10.o
 obj-$(CONFIG_CAMSIG_MINOTAUR)          += minotaur.o
diff --git a/arch/blackfin/mach-bf537/boards/led.S
b/arch/blackfin/mach-bf537/boards/led.S
deleted file mode 100644
index 4e9ea42..0000000
--- a/arch/blackfin/mach-bf537/boards/led.S
+++ /dev/null
@@ -1,183 +0,0 @@
-/****************************************************
- * LED1 ---- PF6        LED2 ---- PF7               *
- * LED3 ---- PF8        LED4 ---- PF9               *
- * LED5 ---- PF10       LED6 ---- PF11              *
- ****************************************************/
-
-#include <linux/linkage.h>
-#include <asm/blackfin.h>
-
-/* All functions in this file save the registers they uses.
-   So there is no need to save any registers before calling them.  */
-
-	.text;
-
-/* Initialize LEDs.  */
-
-ENTRY(_led_init)
-	LINK 12;
-	[--SP] = P0;
-	[--SP] = R0;
-	[--SP] = R1;
-	[--SP] = R2;
-	R1 = PF6|PF7|PF8|PF9|PF10|PF11 (Z);
-	R2 = ~R1;
-
-	P0.H = hi(PORTF_FER);
-	P0.L = lo(PORTF_FER);
-	R0 = W[P0](Z);
-	SSYNC;
-	R0 = R0 & R2;
-	W[P0] = R0.L;
-	SSYNC;
-
-	P0.H = hi(PORTFIO_DIR);
-	P0.L = lo(PORTFIO_DIR);
-	R0 = W[P0](Z);
-	SSYNC;
-	R0 = R0 | R1;
-	W[P0] = R0.L;
-	SSYNC;
-
-	P0.H = hi(PORTFIO_INEN);
-	P0.L = lo(PORTFIO_INEN);
-	R0 = W[P0](Z);
-	SSYNC;
-	R0 = R0 & R2;
-	W[P0] = R0.L;
-	SSYNC;
-
-	R2 = [SP++];
-	R1 = [SP++];
-	R0 = [SP++];
-	P0 = [SP++];
-	UNLINK;
-	RTS;
-	.size	_led_init, .-_led_init
-
-/* Set one LED on. Leave other LEDs unchanged.
-   It expects the LED number passed through R0.  */
-
-ENTRY(_led_on)
-	LINK 12;
-	[--SP] = P0;
-	[--SP] = R1;
-	CALL _led_init;
-	R1 = 1;
-	R0 += 5;
-	R1 <<= R0;
-	P0.H = hi(PORTFIO);
-	P0.L = lo(PORTFIO);
-	R0 = W[P0](Z);
-	SSYNC;
-	R0 = R0 | R1;
-	W[P0] = R0.L;
-	SSYNC;
-	R1 = [SP++];
-	P0 = [SP++];
-	UNLINK;
-	RTS;
-	.size	_led_on, .-_led_on
-
-/* Set one LED off. Leave other LEDs unchanged.  */
-
-ENTRY(_led_off)
-	LINK 12;
-	[--SP] = P0;
-	[--SP] = R1;
-	CALL _led_init;
-	R1 = 1;
-	R0 += 5;
-	R1 <<= R0;
-	R1 = ~R1;
-	P0.H = hi(PORTFIO);
-	P0.L = lo(PORTFIO);
-	R0 = W[P0](Z);
-	SSYNC;
-	R0 = R0 & R1;
-	W[P0] = R0.L;
-	SSYNC;
-	R1 = [SP++];
-	P0 = [SP++];
-	UNLINK;
-	RTS;
-	.size	_led_off, .-_led_off
-
-/* Toggle one LED. Leave other LEDs unchanged.  */
-
-ENTRY(_led_toggle)
-	LINK 12;
-	[--SP] = P0;
-	[--SP] = R1;
-	CALL _led_init;
-	R1 = 1;
-	R0 += 5;
-	R1 <<= R0;
-	P0.H = hi(PORTFIO);
-	P0.L = lo(PORTFIO);
-	R0 = W[P0](Z);
-	SSYNC;
-	R0 = R0 ^ R1;
-	W[P0] = R0.L;
-	SSYNC;
-	R1 = [SP++];
-	P0 = [SP++];
-	UNLINK;
-	RTS;
-	.size	_led_toggle, .-_led_toggle
-
-/* Display the number using LEDs in binary format.  */
-
-ENTRY(_led_disp_num)
-	LINK 12;
-	[--SP] = P0;
-	[--SP] = R1;
-	[--SP] = R2;
-	CALL _led_init;
-	R1 = 0x3f(X);
-	R0 = R0 & R1;
-	R2 = 6(X);
-	R0 <<= R2;
-	R1 <<= R2;
-	P0.H = hi(PORTFIO);
-	P0.L = lo(PORTFIO);
-	R2 = W[P0](Z);
-	SSYNC;
-	R1 = ~R1;
-	R2 = R2 & R1;
-	R2 = R2 | R0;
-	W[P0] = R2.L;
-	SSYNC;
-	R2 = [SP++];
-	R1 = [SP++];
-	P0 = [SP++];
-	UNLINK;
-	RTS;
-	.size	_led_disp_num, .-_led_disp_num
-
-/* Toggle the number using LEDs in binary format.  */
-
-ENTRY(_led_toggle_num)
-	LINK 12;
-	[--SP] = P0;
-	[--SP] = R1;
-	[--SP] = R2;
-	CALL _led_init;
-	R1 = 0x3f(X);
-	R0 = R0 & R1;
-	R1 = 6(X);
-	R0 <<= R1;
-	P0.H = hi(PORTFIO);
-	P0.L = lo(PORTFIO);
-	R1 = W[P0](Z);
-	SSYNC;
-	R1 = R1 ^ R0;
-	W[P0] = R1.L;
-	SSYNC;
-	R2 = [SP++];
-	R1 = [SP++];
-	P0 = [SP++];
-	UNLINK;
-	RTS;
-	.size	_led_toggle_num, .-_led_toggle_num
-
diff --git a/arch/blackfin/mach-bf548/boards/Makefile
b/arch/blackfin/mach-bf548/boards/Makefile
index eed161d..319ef54 100644
--- a/arch/blackfin/mach-bf548/boards/Makefile
+++ b/arch/blackfin/mach-bf548/boards/Makefile
@@ -2,5 +2,5 @@
 # arch/blackfin/mach-bf548/boards/Makefile
 #

-obj-$(CONFIG_BFIN548_EZKIT)            += ezkit.o led.o
+obj-$(CONFIG_BFIN548_EZKIT)            += ezkit.o
 obj-$(CONFIG_BFIN548_BLUETECHNIX_CM)   += cm_bf548.o
diff --git a/arch/blackfin/mach-bf548/boards/cm_bf548.c
b/arch/blackfin/mach-bf548/boards/cm_bf548.c
index 3b74f96..4f4ae87 100644
--- a/arch/blackfin/mach-bf548/boards/cm_bf548.c
+++ b/arch/blackfin/mach-bf548/boards/cm_bf548.c
@@ -684,7 +684,7 @@ static struct platform_device *cm_bf548_devices[]
__initdata = {

 static int __init cm_bf548_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(cm_bf548_devices, ARRAY_SIZE(cm_bf548_devices));

 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
diff --git a/arch/blackfin/mach-bf548/boards/led.S
b/arch/blackfin/mach-bf548/boards/led.S
deleted file mode 100644
index f47daf3..0000000
--- a/arch/blackfin/mach-bf548/boards/led.S
+++ /dev/null
@@ -1,172 +0,0 @@
-/****************************************************
- * LED1 ---- PG6        LED2 ---- PG7               *
- * LED3 ---- PG8        LED4 ---- PG9               *
- * LED5 ---- PG10       LED6 ---- PG11              *
- ****************************************************/
-
-#include <linux/linkage.h>
-#include <asm/blackfin.h>
-
-/* All functions in this file save the registers they uses.
-   So there is no need to save any registers before calling them.  */
-
-	.text;
-
-/* Initialize LEDs.  */
-
-ENTRY(_led_init)
-	LINK 0;
-	[--SP] = P0;
-	[--SP] = R0;
-	[--SP] = R1;
-	[--SP] = R2;
-	R1 = (PG6|PG7|PG8|PG9|PG10|PG11)(Z);
-	R2 = ~R1;
-
-	P0.H = hi(PORTG_FER);
-	P0.L = lo(PORTG_FER);
-	R0 = W[P0](Z);
-	SSYNC;
-	R0 = R0 & R2;
-	W[P0] = R0.L;
-	SSYNC;
-
-	P0.H = hi(PORTG_DIR_SET);
-	P0.L = lo(PORTG_DIR_SET);
-	W[P0] = R1.L;
-	SSYNC;
-
-	P0.H = hi(PORTG_INEN);
-	P0.L = lo(PORTG_INEN);
-	R0 = W[P0](Z);
-	SSYNC;
-	R0 = R0 & R2;
-	W[P0] = R0.L;
-	SSYNC;
-
-	R2 = [SP++];
-	R1 = [SP++];
-	R0 = [SP++];
-	P0 = [SP++];
-	RTS;
-	.size	_led_init, .-_led_init
-
-/* Set one LED on. Leave other LEDs unchanged.
-   It expects the LED number passed through R0.  */
-
-ENTRY(_led_on)
-	LINK 0;
-	[--SP] = P0;
-	[--SP] = R1;
-	CALL _led_init;
-	R1 = 1;
-	R0 += 5;
-	R1 <<= R0;
-	P0.H = hi(PORTG_SET);
-	P0.L = lo(PORTG_SET);
-	W[P0] = R1.L;
-	SSYNC;
-	R1 = [SP++];
-	P0 = [SP++];
-	UNLINK;
-	RTS;
-	.size	_led_on, .-_led_on
-
-/* Set one LED off. Leave other LEDs unchanged.  */
-
-ENTRY(_led_off)
-	LINK 0;
-	[--SP] = P0;
-	[--SP] = R1;
-	CALL _led_init;
-	R1 = 1;
-	R0 += 5;
-	R1 <<= R0;
-	P0.H = hi(PORTG_CLEAR);
-	P0.L = lo(PORTG_CLEAR);
-	W[P0] = R1.L;
-	SSYNC;
-	R1 = [SP++];
-	P0 = [SP++];
-	UNLINK;
-	RTS;
-	.size	_led_off, .-_led_off
-
-/* Toggle one LED. Leave other LEDs unchanged.  */
-
-ENTRY(_led_toggle)
-	LINK 0;
-	[--SP] = P0;
-	[--SP] = R1;
-	CALL _led_init;
-	R1 = 1;
-	R0 += 5;
-	R1 <<= R0;
-	P0.H = hi(PORTG);
-	P0.L = lo(PORTG);
-	R0 = W[P0](Z);
-	SSYNC;
-	R0 = R0 ^ R1;
-	W[P0] = R0.L;
-	SSYNC;
-	R1 = [SP++];
-	P0 = [SP++];
-	UNLINK;
-	RTS;
-	.size	_led_toggle, .-_led_toggle
-
-/* Display the number using LEDs in binary format.  */
-
-ENTRY(_led_disp_num)
-	LINK 0;
-	[--SP] = P0;
-	[--SP] = R1;
-	[--SP] = R2;
-	CALL _led_init;
-	R1 = 0x3f(X);
-	R0 = R0 & R1;
-	R2 = 6(X);
-	R0 <<= R2;
-	R1 <<= R2;
-	P0.H = hi(PORTG);
-	P0.L = lo(PORTG);
-	R2 = W[P0](Z);
-	SSYNC;
-	R1 = ~R1;
-	R2 = R2 & R1;
-	R2 = R2 | R0;
-	W[P0] = R2.L;
-	SSYNC;
-	R2 = [SP++];
-	R1 = [SP++];
-	P0 = [SP++];
-	UNLINK;
-	RTS;
-	.size	_led_disp_num, .-_led_disp_num
-
-/* Toggle the number using LEDs in binary format.  */
-
-ENTRY(_led_toggle_num)
-	LINK 0;
-	[--SP] = P0;
-	[--SP] = R1;
-	[--SP] = R2;
-	CALL _led_init;
-	R1 = 0x3f(X);
-	R0 = R0 & R1;
-	R1 = 6(X);
-	R0 <<= R1;
-	P0.H = hi(PORTG);
-	P0.L = lo(PORTG);
-	R1 = W[P0](Z);
-	SSYNC;
-	R1 = R1 ^ R0;
-	W[P0] = R1.L;
-	SSYNC;
-	R2 = [SP++];
-	R1 = [SP++];
-	P0 = [SP++];
-	UNLINK;
-	RTS;
-	.size	_led_toggle_num, .-_led_toggle_num
-
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 1400ea6..1bc00b7 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -43,7 +43,6 @@

 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/serial.h>

 #include "8250.h"

@@ -93,6 +92,7 @@ static unsigned int nr_uarts =
CONFIG_SERIAL_8250_RUNTIME_UARTS;
  */
 #define CONFIG_HUB6 1

+#include <asm/serial.h>
 /*
  * SERIAL_PORT_DFNS tells us about built-in ports that have no
  * standard enumeration mechanism.   Platforms that can find all
@@ -1547,8 +1547,6 @@ static int serial_link_irq_chain(struct
uart_8250_port *up)
 		i->head = &up->list;
 		spin_unlock_irq(&i->lock);

-		irq_flags |= SERIAL_EXTRA_IRQ_FLAGS;
-
 		ret = request_irq(up->port.irq, serial8250_interrupt,
 				  irq_flags, "serial", i);
 		if (ret < 0)
diff --git a/drivers/serial/8250.h b/drivers/serial/8250.h
index a10a40c..91bd28f 100644
--- a/drivers/serial/8250.h
+++ b/drivers/serial/8250.h
@@ -78,8 +78,3 @@ struct serial8250_config {
 #else
 #define ALPHA_KLUDGE_MCR 0
 #endif
-
-#ifndef SERIAL_EXTRA_IRQ_FLAGS
-#define SERIAL_EXTRA_IRQ_FLAGS 0
-#endif
-
diff --git a/include/asm-blackfin/bfin-global.h
b/include/asm-blackfin/bfin-global.h
index a9248d8..7603383 100644
--- a/include/asm-blackfin/bfin-global.h
+++ b/include/asm-blackfin/bfin-global.h
@@ -105,13 +105,6 @@ extern int sram_free(const void*);
 extern void *sram_alloc_with_lsl(size_t, unsigned long);
 extern int sram_free_with_lsl(const void*);

-extern void led_on(int);
-extern void led_off(int);
-extern void led_toggle(int);
-extern void led_disp_num(int);
-extern void led_toggle_num(int);
-extern void init_leds(void);
-
 extern const char bfin_board_name[];
 extern unsigned long wall_jiffies;

diff --git a/include/asm-blackfin/mach-bf527/anomaly.h
b/include/asm-blackfin/mach-bf527/anomaly.h
index 735fa02..4725268 100644
--- a/include/asm-blackfin/mach-bf527/anomaly.h
+++ b/include/asm-blackfin/mach-bf527/anomaly.h
@@ -15,12 +15,16 @@

 /* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg
Store in slot2 Not Supported */
 #define ANOMALY_05000074 (1)
+/* DMA_RUN Bit Is Not Valid after a Peripheral Receive Channel DMA Stops */
+#define ANOMALY_05000119 (1)
 /* Rx.H Cannot Be Used to Access 16-bit System MMR Registers */
 #define ANOMALY_05000122 (1)
 /* Spurious Hardware Error from an Access in the Shadow of a
Conditional Branch */
 #define ANOMALY_05000245 (1)
 /* Sensitivity To Noise with Slow Input Edge Rates on External SPORT
TX and RX Clocks */
 #define ANOMALY_05000265 (1)
+/* Errors when SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are
Interrupted */
+#define ANOMALY_05000312 (1)
 /* Incorrect Access of OTP_STATUS During otp_write() Function */
 #define ANOMALY_05000328 (1)
 /* Disallowed Configuration Prevents Subsequent Allowed Configuration
on Host DMA Port */
@@ -92,7 +96,6 @@
 #define ANOMALY_05000266 (0)
 #define ANOMALY_05000273 (0)
 #define ANOMALY_05000311 (0)
-#define ANOMALY_05000312 (0)
 #define ANOMALY_05000323 (0)
 #define ANOMALY_05000363 (0)

diff --git a/include/asm-blackfin/mach-bf533/anomaly.h
b/include/asm-blackfin/mach-bf533/anomaly.h
index 5a6dcc5..8f7ea11 100644
--- a/include/asm-blackfin/mach-bf533/anomaly.h
+++ b/include/asm-blackfin/mach-bf533/anomaly.h
@@ -2,7 +2,7 @@
  * File: include/asm-blackfin/mach-bf533/anomaly.h
  * Bugs: Enter bugs at http://blackfin.uclinux.org/
  *
- * Copyright (C) 2004-2007 Analog Devices Inc.
+ * Copyright (C) 2004-2008 Analog Devices Inc.
  * Licensed under the GPL-2 or later.
  */

@@ -176,6 +176,21 @@
 #define ANOMALY_05000315 (1)
 /* Internal Voltage Regulator Values of 1.05V, 1.10V and 1.15V Not
Allowed for LQFP Packages */
 #define ANOMALY_05000319 (ANOMALY_BF531 || ANOMALY_BF532)
+/* Serial Port (SPORT) Multichannel Transmit Failure when Channel 0
Is Disabled */
+#define ANOMALY_05000357 (1)
+/* UART Break Signal Issues */
+#define ANOMALY_05000363 (__SILICON_REVISION__ < 5)
+/* PPI Underflow Error Goes Undetected in ITU-R 656 Mode */
+#define ANOMALY_05000366 (1)
+/* Possible RETS Register Corruption when Subroutine Is under 5
Cycles in Duration */
+#define ANOMALY_05000371 (1)
+/* PPI Does Not Start Properly In Specific Mode */
+#define ANOMALY_05000400 (__SILICON_REVISION__ >= 5)
+/* SSYNC Stalls Processor when Executed from Non-Cacheable Memory */
+#define ANOMALY_05000402 (__SILICON_REVISION__ >= 5)
+/* Level-Sensitive External GPIO Wakeups May Cause Indefinite Stall */
+#define ANOMALY_05000403 (1)
+

 /* These anomalies have been "phased" out of analog.com anomaly sheets and are
  * here to show running on older silicon just isn't feasible.
@@ -249,20 +264,6 @@
 #define ANOMALY_05000192 (__SILICON_REVISION__ < 3)
 /* Internal Voltage Regulator may not start up */
 #define ANOMALY_05000206 (__SILICON_REVISION__ < 3)
-/* Serial Port (SPORT) Multichannel Transmit Failure when Channel 0
Is Disabled */
-#define ANOMALY_05000357 (1)
-/* UART Break Signal Issues */
-#define ANOMALY_05000363 (__SILICON_REVISION__ < 5)
-/* PPI Underflow Error Goes Undetected in ITU-R 656 Mode */
-#define ANOMALY_05000366 (1)
-/* Possible RETS Register Corruption when Subroutine Is under 5
Cycles in Duration */
-#define ANOMALY_05000371 (1)
-/* PPI Does Not Start Properly In Specific Mode */
-#define ANOMALY_05000400 (__SILICON_REVISION__ == 5)
-/* SSYNC Stalls Processor when Executed from Non-Cacheable Memory */
-#define ANOMALY_05000402 (__SILICON_REVISION__ == 5)
-/* Level-Sensitive External GPIO Wakeups May Cause Indefinite Stall */
-#define ANOMALY_05000403 (1)

 /* Anomalies that don't exist on this proc */
 #define ANOMALY_05000266 (0)
diff --git a/include/asm-blackfin/mach-bf537/anomaly.h
b/include/asm-blackfin/mach-bf537/anomaly.h
index a6b08fa..8460ab9 100644
--- a/include/asm-blackfin/mach-bf537/anomaly.h
+++ b/include/asm-blackfin/mach-bf537/anomaly.h
@@ -2,7 +2,7 @@
  * File: include/asm-blackfin/mach-bf537/anomaly.h
  * Bugs: Enter bugs at http://blackfin.uclinux.org/
  *
- * Copyright (C) 2004-2007 Analog Devices Inc.
+ * Copyright (C) 2004-2008 Analog Devices Inc.
  * Licensed under the GPL-2 or later.
  */

@@ -132,8 +132,8 @@
 #define ANOMALY_05000322 (1)
 /* Ethernet MAC MDIO Reads Do Not Meet IEEE Specification */
 #define ANOMALY_05000341 (__SILICON_REVISION__ >= 3)
-/* New Feature: UART Remains Enabled after UART Boot (Not Available
on Older Silicon) */
-#define ANOMALY_05000350 (__SILICON_REVISION__ < 3)
+/* New Feature: UART Remains Enabled after UART Boot */
+#define ANOMALY_05000350 (__SILICON_REVISION__ >= 3)
 /* Regulator Programming Blocked when Hibernate Wakeup Source Remains Active */
 #define ANOMALY_05000355 (1)
 /* Serial Port (SPORT) Multichannel Transmit Failure when Channel 0
Is Disabled */
@@ -145,12 +145,10 @@
 /* Possible RETS Register Corruption when Subroutine Is under 5
Cycles in Duration */
 #define ANOMALY_05000371 (1)
 /* SSYNC Stalls Processor when Executed from Non-Cacheable Memory */
-#define ANOMALY_05000402 (__SILICON_REVISION__ >= 3)
+#define ANOMALY_05000402 (__SILICON_REVISION__ >= 5)
 /* Level-Sensitive External GPIO Wakeups May Cause Indefinite Stall */
 #define ANOMALY_05000403 (1)

-
-
 /* Anomalies that don't exist on this proc */
 #define ANOMALY_05000125 (0)
 #define ANOMALY_05000158 (0)
diff --git a/include/asm-blackfin/mach-bf548/anomaly.h
b/include/asm-blackfin/mach-bf548/anomaly.h
index 49d3ceb..3ad5965 100644
--- a/include/asm-blackfin/mach-bf548/anomaly.h
+++ b/include/asm-blackfin/mach-bf548/anomaly.h
@@ -75,6 +75,8 @@
 #define ANOMALY_05000365 (1)
 /* Addressing Conflict between Boot ROM and Asynchronous Memory */
 #define ANOMALY_05000369 (1)
+/* Possible RETS Register Corruption when Subroutine Is under 5
Cycles in Duration */
+#define ANOMALY_05000371 (1)
 /* Mobile DDR Operation Not Functional */
 #define ANOMALY_05000377 (1)
 /* Security/Authentication Speedpath Causes Authentication To Fail To
Initiate */
diff --git a/include/asm-blackfin/mach-bf561/anomaly.h
b/include/asm-blackfin/mach-bf561/anomaly.h
index 82157ca..5c5d7d7 100644
--- a/include/asm-blackfin/mach-bf561/anomaly.h
+++ b/include/asm-blackfin/mach-bf561/anomaly.h
@@ -2,7 +2,7 @@
  * File: include/asm-blackfin/mach-bf561/anomaly.h
  * Bugs: Enter bugs at http://blackfin.uclinux.org/
  *
- * Copyright (C) 2004-2007 Analog Devices Inc.
+ * Copyright (C) 2004-2008 Analog Devices Inc.
  * Licensed under the GPL-2 or later.
  */

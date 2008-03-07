Return-Path: <linux-kernel-owner+w=401wt.eu-S933268AbYCGJbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268AbYCGJbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765558AbYCGJ2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:28:12 -0500
Received: from mail.atmel.fr ([81.80.104.162]:61933 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932938AbYCGJ2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:28:06 -0500
Message-ID: <47D10A99.4050800@atmel.com>
Date: Fri, 07 Mar 2008 10:27:53 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Stelian Pop <stelian@popies.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: David Brownell <david-b@pacbell.net>, Andrew Victor <linux@maxim.org.za>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Nicolas FERRE <nicolas.ferre@atmel.com>,
       Sedji GAOUAOU <sedji.gaouaou@atmel.com>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>
Subject: [PATCH] AT91: UDPHS driver: SAM9RL board and cpu integration
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for the USB High Speed Device Port on the 
AT91SAM9RL system on chip. The AT91SAM9RL uses the same 
UDPHS IP as the AVR32 and the AT91CAP9 (atmel_usba_udc driver).

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Like AT91CAP9 patches, this cpu/board integration is generated against 
Linux 2.6.25-rc4 + the very last atmel_usba_udc cleanup patches comming
from those threads :
http://lists.arm.linux.org.uk/lurker/message/20080228.143442.a2338930.en.html
http://lists.arm.linux.org.uk/lurker/message/20080305.141253.d4458042.en.html

Thanks a lot to Stelian, Haavard and David to put this driver integration well
under way.

 arch/arm/mach-at91/at91sam9rl_devices.c |   90 ++++++++++++++++++++++++++++++++
 arch/arm/mach-at91/board-sam9rlek.c     |   10 +++
 arch/arm/mach-at91/clock.c              |    9 +--
 drivers/usb/gadget/Kconfig              |    2 
 include/asm-arm/arch-at91/at91_pmc.h    |    4 -
 include/asm-arm/arch-at91/at91sam9rl.h  |    2 
 6 files changed, 109 insertions(+), 8 deletions(-)

--- linux-2.6.x-rc.orig/arch/arm/mach-at91/at91sam9rl_devices.c
+++ linux-2.6.x-rc/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -26,6 +26,96 @@
 
 
 /* --------------------------------------------------------------------
+ *  USB HS Device (Gadget)
+ * -------------------------------------------------------------------- */
+
+#if defined(CONFIG_USB_GADGET_ATMEL_USBA) || defined(CONFIG_USB_GADGET_ATMEL_USBA_MODULE)
+
+static struct resource usba_udc_resources[] = {
+	[0] = {
+		.start	= AT91SAM9RL_UDPHS_FIFO,
+		.end	= AT91SAM9RL_UDPHS_FIFO + SZ_512K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= AT91SAM9RL_BASE_UDPHS,
+		.end	= AT91SAM9RL_BASE_UDPHS + SZ_1K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[2] = {
+		.start	= AT91SAM9RL_ID_UDPHS,
+		.end	= AT91SAM9RL_ID_UDPHS,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+#define EP(nam, idx, maxpkt, maxbk, dma, isoc)			\
+	[idx] = {						\
+		.name		= nam,				\
+		.index		= idx,				\
+		.fifo_size	= maxpkt,			\
+		.nr_banks	= maxbk,			\
+		.can_dma	= dma,				\
+		.can_isoc	= isoc,				\
+	}
+
+static struct usba_ep_data usba_udc_ep[] __initdata = {
+	EP("ep0", 0, 64, 1, 0, 0),
+	EP("ep1", 1, 1024, 2, 1, 1),
+	EP("ep2", 2, 1024, 2, 1, 1),
+	EP("ep3", 3, 1024, 3, 1, 0),
+	EP("ep4", 4, 1024, 3, 1, 0),
+	EP("ep5", 5, 1024, 3, 1, 1),
+	EP("ep6", 6, 1024, 3, 1, 1),
+};
+
+#undef EP
+
+/*
+ * pdata doesn't have room for any endpoints, so we need to
+ * append room for the ones we need right after it.
+ */
+static struct {
+	struct usba_platform_data pdata;
+	struct usba_ep_data ep[7];
+} usba_udc_data;
+
+static struct platform_device at91_usba_udc_device = {
+	.name		= "atmel_usba_udc",
+	.id		= -1,
+	.dev		= {
+				.platform_data	= &usba_udc_data.pdata,
+	},
+	.resource	= usba_udc_resources,
+	.num_resources	= ARRAY_SIZE(usba_udc_resources),
+};
+
+void __init at91_add_device_usba(struct usba_platform_data *data)
+{
+	usba_udc_data.pdata.vbus_pin = -EINVAL;
+	usba_udc_data.pdata.num_ep = ARRAY_SIZE(usba_udc_ep);
+	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));;
+
+	if (data && data->vbus_pin >= 0) {
+		at91_set_gpio_input(data->vbus_pin, 0);
+		at91_set_deglitch(data->vbus_pin, 1);
+		usba_udc_data.pdata.vbus_pin = data->vbus_pin;
+	}
+
+	/* Pullup pin is handled internally by USB device peripheral */
+
+	/* Clocks */
+	at91_clock_associate("utmi_clk", &at91_usba_udc_device.dev, "hclk");
+	at91_clock_associate("udphs_clk", &at91_usba_udc_device.dev, "pclk");
+
+	platform_device_register(&at91_usba_udc_device);
+}
+#else
+void __init at91_add_device_usba(struct usba_platform_data *data) {}
+#endif
+
+
+/* --------------------------------------------------------------------
  *  MMC / SD
  * -------------------------------------------------------------------- */
 
--- linux-2.6.x-rc.orig/arch/arm/mach-at91/board-sam9rlek.c
+++ linux-2.6.x-rc/arch/arm/mach-at91/board-sam9rlek.c
@@ -61,6 +61,14 @@ static void __init ek_init_irq(void)
 
 
 /*
+ * USB HS Device port
+ */
+static struct usba_platform_data __initdata ek_usba_udc_data = {
+	.vbus_pin	= AT91_PIN_PA8,
+};
+
+
+/*
  * MCI (SD/MMC)
  */
 static struct at91_mmc_data __initdata ek_mmc_data = {
@@ -190,6 +198,8 @@ static void __init ek_board_init(void)
 	at91_add_device_mmc(0, &ek_mmc_data);
 	/* LCD Controller */
 	at91_add_device_lcdc(&ek_lcdc_data);
+	/* USB HS */
+	at91_add_device_usba(&ek_usba_udc_data);
 }
 
 MACHINE_START(AT91SAM9RLEK, "Atmel AT91SAM9RL-EK")
--- linux-2.6.x-rc.orig/drivers/usb/gadget/Kconfig
+++ linux-2.6.x-rc/drivers/usb/gadget/Kconfig
@@ -121,7 +121,7 @@ config USB_GADGET_ATMEL_USBA
 	depends on AVR32 || ARCH_AT91
 	help
 	  USBA is the integrated high-speed USB Device controller on
-	  the AT32AP700x and AT91CAP9 processors from Atmel.
+	  the AT32AP700x, some AT91SAM9 and AT91CAP9 processors from Atmel.
 
 config USB_ATMEL_USBA
 	tristate
--- linux-2.6.x-rc.orig/arch/arm/mach-at91/clock.c
+++ linux-2.6.x-rc/arch/arm/mach-at91/clock.c
@@ -392,8 +392,9 @@ static int at91_clk_show(struct seq_file
 	seq_printf(s, "MOR  = %8x\n", at91_sys_read(AT91_CKGR_MOR));
 	seq_printf(s, "MCFR = %8x\n", at91_sys_read(AT91_CKGR_MCFR));
 	seq_printf(s, "PLLA = %8x\n", at91_sys_read(AT91_CKGR_PLLAR));
-	seq_printf(s, "PLLB = %8x\n", at91_sys_read(AT91_CKGR_PLLBR));
-	if (cpu_is_at91cap9())
+	if (!cpu_is_at91sam9rl())
+		seq_printf(s, "PLLB = %8x\n", at91_sys_read(AT91_CKGR_PLLBR));
+	if (cpu_is_at91cap9() || cpu_is_at91sam9rl())
 		seq_printf(s, "UCKR = %8x\n", uckr = at91_sys_read(AT91_CKGR_UCKR));
 	seq_printf(s, "MCKR = %8x\n", at91_sys_read(AT91_PMC_MCKR));
 	seq_printf(s, "SR   = %8x\n", sr = at91_sys_read(AT91_PMC_SR));
@@ -611,7 +612,7 @@ int __init at91_clock_init(unsigned long
 	/*
 	 * USB HS clock init
 	 */
-	if (cpu_is_at91cap9()) {
+	if (cpu_is_at91cap9() || cpu_is_at91sam9rl()) {
 		/*
 		 * multiplier is hard-wired to 40
 		 * (obtain the USB High Speed 480 MHz when input is 12 MHz)
@@ -636,7 +637,7 @@ int __init at91_clock_init(unsigned long
 	for (i = 0; i < ARRAY_SIZE(standard_pmc_clocks); i++)
 		list_add_tail(&standard_pmc_clocks[i]->node, &clocks);
 
-	if (cpu_is_at91cap9())
+	if (cpu_is_at91cap9() || cpu_is_at91sam9rl())
 		list_add_tail(&utmi_clk.node, &clocks);
 
 	/* MCK and CPU clock are "always on" */
--- linux-2.6.x-rc.orig/include/asm-arm/arch-at91/at91sam9rl.h
+++ linux-2.6.x-rc/include/asm-arm/arch-at91/at91sam9rl.h
@@ -110,6 +110,6 @@
 #define AT91SAM9RL_ROM_SIZE	(2 * SZ_16K)	/* Internal ROM size (32Kb) */
 
 #define AT91SAM9RL_LCDC_BASE	0x00500000	/* LCD Controller */
-#define AT91SAM9RL_UDPHS_BASE	0x00600000	/* USB Device HS controller */
+#define AT91SAM9RL_UDPHS_FIFO	0x00600000	/* USB Device HS controller */
 
 #endif
--- linux-2.6.x-rc.orig/include/asm-arm/arch-at91/at91_pmc.h
+++ linux-2.6.x-rc/include/asm-arm/arch-at91/at91_pmc.h
@@ -42,7 +42,7 @@
 #define		AT91_PMC_UPLLEN		(1 << 16)		/* UTMI PLL */
 #define		AT91_PMC_BIASEN		(1 << 24)		/* UTMI BIAS */
 
-#define	AT91_CKGR_MOR		(AT91_PMC + 0x20)	/* Main Oscillator Register [not on SAM9RL] */
+#define	AT91_CKGR_MOR		(AT91_PMC + 0x20)	/* Main Oscillator Register */
 #define		AT91_PMC_MOSCEN		(1    << 0)		/* Main Oscillator Enable */
 #define		AT91_PMC_OSCBYPASS	(1    << 1)		/* Oscillator Bypass [SAM9x, CAP9] */
 #define		AT91_PMC_OSCOUNT	(0xff << 8)		/* Main Oscillator Start-up Time */
@@ -92,7 +92,7 @@
 #define		AT91_PMC_LOCKA		(1 <<  1)		/* PLLA Lock */
 #define		AT91_PMC_LOCKB		(1 <<  2)		/* PLLB Lock */
 #define		AT91_PMC_MCKRDY		(1 <<  3)		/* Master Clock */
-#define		AT91_PMC_LOCKU		(1 <<  6)		/* UPLL Lock [AT91CAP9 only] */
+#define		AT91_PMC_LOCKU		(1 <<  6)		/* UPLL Lock [SAM9RL, CAP9] */
 #define		AT91_PMC_PCK0RDY	(1 <<  8)		/* Programmable Clock 0 */
 #define		AT91_PMC_PCK1RDY	(1 <<  9)		/* Programmable Clock 1 */
 #define		AT91_PMC_PCK2RDY	(1 << 10)		/* Programmable Clock 2 */


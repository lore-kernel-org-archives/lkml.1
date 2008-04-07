Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbYDGPqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbYDGPqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbYDGPqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:46:40 -0400
Received: from mail.atmel.fr ([81.80.104.162]:37517 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbYDGPqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:46:39 -0400
Message-ID: <47FA41C6.2040406@atmel.com>
Date: Mon, 07 Apr 2008 17:46:14 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Stelian Pop <stelian@popies.net>, Andrew Victor <linux@maxim.org.za>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] AT91 UDPHS driver: SAM9RL board and cpu integration.
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
Linux 2.6.25-rc8 + last AT91 patches already accepted in the patch 
system (4902/1 to 4915/1 )
 arch/arm/mach-at91/at91sam9rl_devices.c |   95 ++++++++++++++++++++++++++++++++
 arch/arm/mach-at91/board-sam9rlek.c     |   10 +++
 arch/arm/mach-at91/clock.c              |    9 +--
 drivers/usb/gadget/Kconfig              |    4 -
 include/asm-arm/arch-at91/at91sam9rl.h  |    2 
 5 files changed, 113 insertions(+), 7 deletions(-)

--- linux-2.6.25-rc.orig/arch/arm/mach-at91/at91sam9rl_devices.c
+++ linux-2.6.25-rc/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -26,6 +26,101 @@
 
 
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
+	/*
+	 * Invalid pins are 0 on AT91, but the usba driver is shared
+	 * with AVR32, which use negative values instead. Once/if
+	 * gpio_is_valid() is ported to AT91, revisit this code.
+	 */
+	usba_udc_data.pdata.vbus_pin = -EINVAL;
+	usba_udc_data.pdata.num_ep = ARRAY_SIZE(usba_udc_ep);
+	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));;
+
+	if (data && data->vbus_pin > 0) {
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
 
--- linux-2.6.25-rc.orig/arch/arm/mach-at91/board-sam9rlek.c
+++ linux-2.6.25-rc/arch/arm/mach-at91/board-sam9rlek.c
@@ -56,6 +56,14 @@ static void __init ek_init_irq(void)
 
 
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
@@ -175,6 +183,8 @@ static void __init ek_board_init(void)
 {
 	/* Serial */
 	at91_add_device_serial();
+	/* USB HS */
+	at91_add_device_usba(&ek_usba_udc_data);
 	/* I2C */
 	at91_add_device_i2c(NULL, 0);
 	/* NAND */
--- linux-2.6.25-rc.orig/arch/arm/mach-at91/clock.c
+++ linux-2.6.25-rc/arch/arm/mach-at91/clock.c
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
--- linux-2.6.25-rc.orig/drivers/usb/gadget/Kconfig
+++ linux-2.6.25-rc/drivers/usb/gadget/Kconfig
@@ -118,10 +118,10 @@ config USB_AMD5536UDC
 config USB_GADGET_ATMEL_USBA
 	boolean "Atmel USBA"
 	select USB_GADGET_DUALSPEED
-	depends on AVR32 || ARCH_AT91CAP9
+	depends on AVR32 || ARCH_AT91CAP9 || ARCH_AT91SAM9RL
 	help
 	  USBA is the integrated high-speed USB Device controller on
-	  the AT32AP700x and AT91CAP9 processors from Atmel.
+	  the AT32AP700x, some AT91SAM9 and AT91CAP9 processors from Atmel.
 
 config USB_ATMEL_USBA
 	tristate
--- linux-2.6.25-rc.orig/include/asm-arm/arch-at91/at91sam9rl.h
+++ linux-2.6.25-rc/include/asm-arm/arch-at91/at91sam9rl.h
@@ -110,6 +110,6 @@
 #define AT91SAM9RL_ROM_SIZE	(2 * SZ_16K)	/* Internal ROM size (32Kb) */
 
 #define AT91SAM9RL_LCDC_BASE	0x00500000	/* LCD Controller */
-#define AT91SAM9RL_UDPHS_BASE	0x00600000	/* USB Device HS controller */
+#define AT91SAM9RL_UDPHS_FIFO	0x00600000	/* USB Device HS controller */
 
 #endif




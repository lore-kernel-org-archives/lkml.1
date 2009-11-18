Return-Path: <linux-kernel-owner+w=401wt.eu-S1756936AbZKRNH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbZKRNH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 08:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756764AbZKRNH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 08:07:26 -0500
Received: from mail.atmel.fr ([81.80.104.162]:63438 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756740AbZKRNHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 08:07:25 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: dtor@mail.ru, linux-input@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, avictor.za@gmail.com
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 4/4] at91/input: touchscreen support for at91sam9g45ekes
Date: Wed, 18 Nov 2009 15:12:15 +0100
Message-Id: <6ee40906b7ed3c732b940e78a7d1355d2b6a7547.1258553002.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <693b9933de6fe9eb7e4401ca56a8f9ab6a966666.1258553002.git.nicolas.ferre@atmel.com>
References: <693b9933de6fe9eb7e4401ca56a8f9ab6a966666.1258553002.git.nicolas.ferre@atmel.com>
In-Reply-To: <693b9933de6fe9eb7e4401ca56a8f9ab6a966666.1258553002.git.nicolas.ferre@atmel.com>
References: <693b9933de6fe9eb7e4401ca56a8f9ab6a966666.1258553002.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New at91sam9g45ekes board provides a LCD with resistive touchscreen. This is the
support of this feature by atmel_tsadcc driver.
This also sets up platform parameters to be passed to the driver.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91sam9g45_devices.c |   51 ++++++++++++++++++++++++++++++
 arch/arm/mach-at91/board-sam9m10g45ek.c  |   12 +++++++
 drivers/input/touchscreen/Kconfig        |    2 +-
 3 files changed, 64 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 332b784..a5a4eb1 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -810,6 +810,57 @@ static void __init at91_add_device_rtc(void) {}
 
 
 /* --------------------------------------------------------------------
+ *  Touchscreen
+ * -------------------------------------------------------------------- */
+
+#if defined(CONFIG_TOUCHSCREEN_ATMEL_TSADCC) || defined(CONFIG_TOUCHSCREEN_ATMEL_TSADCC_MODULE)
+static u64 tsadcc_dmamask = DMA_BIT_MASK(32);
+static struct at91_tsadcc_data tsadcc_data;
+
+static struct resource tsadcc_resources[] = {
+	[0] = {
+		.start	= AT91SAM9G45_BASE_TSC,
+		.end	= AT91SAM9G45_BASE_TSC + SZ_16K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= AT91SAM9G45_ID_TSC,
+		.end	= AT91SAM9G45_ID_TSC,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device at91sam9g45_tsadcc_device = {
+	.name		= "atmel_tsadcc",
+	.id		= -1,
+	.dev		= {
+				.dma_mask		= &tsadcc_dmamask,
+				.coherent_dma_mask	= DMA_BIT_MASK(32),
+				.platform_data		= &tsadcc_data,
+	},
+	.resource	= tsadcc_resources,
+	.num_resources	= ARRAY_SIZE(tsadcc_resources),
+};
+
+void __init at91_add_device_tsadcc(struct at91_tsadcc_data *data)
+{
+	if (!data)
+		return;
+
+	at91_set_gpio_input(AT91_PIN_PD20, 0);	/* AD0_XR */
+	at91_set_gpio_input(AT91_PIN_PD21, 0);	/* AD1_XL */
+	at91_set_gpio_input(AT91_PIN_PD22, 0);	/* AD2_YT */
+	at91_set_gpio_input(AT91_PIN_PD23, 0);	/* AD3_TB */
+
+	tsadcc_data = *data;
+	platform_device_register(&at91sam9g45_tsadcc_device);
+}
+#else
+void __init at91_add_device_tsadcc(struct at91_tsadcc_data *data) {}
+#endif
+
+
+/* --------------------------------------------------------------------
  *  RTT
  * -------------------------------------------------------------------- */
 
diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index 64c3843..3d6764b 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -229,6 +229,16 @@ static struct atmel_lcdfb_info __initdata ek_lcdc_data;
 
 
 /*
+ * Touchscreen
+ */
+static struct at91_tsadcc_data ek_tsadcc_data = {
+	.adc_clock		= 300000,
+	.pendet_debounce	= 0x0d,
+	.ts_sample_hold_time	= 0x0a,
+};
+
+
+/*
  * GPIO Buttons
  */
 #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
@@ -378,6 +388,8 @@ static void __init ek_board_init(void)
 	at91_add_device_i2c(0, NULL, 0);
 	/* LCD Controller */
 	at91_add_device_lcdc(&ek_lcdc_data);
+	/* Touch Screen */
+	at91_add_device_tsadcc(&ek_tsadcc_data);
 	/* Push Buttons */
 	ek_add_device_buttons();
 	/* AC97 */
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 8cc453c..fddae60 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -297,7 +297,7 @@ config TOUCHSCREEN_TOUCHWIN
 
 config TOUCHSCREEN_ATMEL_TSADCC
 	tristate "Atmel Touchscreen Interface"
-	depends on ARCH_AT91SAM9RL
+ 	depends on ARCH_AT91SAM9RL || ARCH_AT91SAM9G45
 	help
 	  Say Y here if you have a 4-wire touchscreen connected to the
           ADC Controller on your Atmel SoC (such as the AT91SAM9RL).
-- 
1.5.6.5


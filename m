Return-Path: <linux-kernel-owner+w=401wt.eu-S1752092AbZJTN2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbZJTN2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 09:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZJTN2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 09:28:14 -0400
Received: from mail.atmel.fr ([81.80.104.162]:44951 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbZJTN2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 09:28:12 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, avictor.za@gmail.com,
       akpm@linux-foundation.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] at91: at91sam9g20ek modify dual slot evaluation kit
Date: Tue, 20 Oct 2009 16:32:53 +0200
Message-Id: <1256049173-17373-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at91sam9g20ek rev. C and onwards embed two SD/MMC slots. This patch modify the
previous dual slot board definition to match the official rev. C board. It also
allows the use of at91_mci SD/MMC driver in addition to the atmel-mci one.

Some pins have been re-affected from leds or Ethernet phy IRQ to the SD/MMC
slot A. This lead to a modification of those definitions.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
This is a modification of the changes introduced by the patch:
"AT91: atmel-mci: Platform configuration to the the atmel-mci driver" that went
into mainline through the MMC path (thanks to Andrew Morton).

Also move slightly the 2MMC board Kconfig entry.

 arch/arm/mach-at91/Kconfig                     |   20 +++++++++++---------
 arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c |   23 +++++++++++++++--------
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index e35d54d..2fd8843 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -289,13 +289,6 @@ config MACH_NEOCORE926
 	help
 	  Select this if you are using the Adeneo Neocore 926 board.
 
-config MACH_AT91SAM9G20EK_2MMC
-	bool "Atmel AT91SAM9G20-EK Evaluation Kit modified for 2 MMC Slots"
-	depends on ARCH_AT91SAM9G20
-	help
-	  Select this if you are using an Atmel AT91SAM9G20-EK Evaluation Kit
-	  Rev A or B modified for 2 MMC Slots.
-
 endif
 
 # ----------------------------------------------------------
@@ -322,7 +315,16 @@ config MACH_AT91SAM9G20EK
 	bool "Atmel AT91SAM9G20-EK Evaluation Kit"
 	depends on ARCH_AT91SAM9G20
 	help
-	  Select this if you are using Atmel's AT91SAM9G20-EK Evaluation Kit.
+	  Select this if you are using Atmel's AT91SAM9G20-EK Evaluation Kit
+	  that embeds only one SD/MMC slot.
+
+config MACH_AT91SAM9G20EK_2MMC
+	bool "Atmel AT91SAM9G20-EK Evaluation Kit with 2 SD/MMC Slots"
+	depends on ARCH_AT91SAM9G20
+	help
+	  Select this if you are using an Atmel AT91SAM9G20-EK Evaluation Kit
+	  with 2 SD/MMC Slots. This is the case for AT91SAM9G20-EK rev. C and
+	  onwards.
 
 config MACH_CPU9G20
 	bool "Eukrea CPU9G20 board"
@@ -392,7 +394,7 @@ config MTD_AT91_DATAFLASH_CARD
 
 config MTD_NAND_ATMEL_BUSWIDTH_16
 	bool "Enable 16-bit data bus interface to NAND flash"
-	depends on (MACH_AT91SAM9260EK || MACH_AT91SAM9261EK || MACH_AT91SAM9G10EK || MACH_AT91SAM9263EK || MACH_AT91SAM9G20EK || MACH_AT91SAM9G45EKES || MACH_AT91CAP9ADK)
+	depends on (MACH_AT91SAM9260EK || MACH_AT91SAM9261EK || MACH_AT91SAM9G10EK || MACH_AT91SAM9263EK || MACH_AT91SAM9G20EK || MACH_AT91SAM9G20EK_2MMC || MACH_AT91SAM9G45EKES || MACH_AT91CAP9ADK)
 	help
 	  On AT91SAM926x boards both types of NAND flash can be present
 	  (8 and 16 bit data bus width).
diff --git a/arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c b/arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c
index a28e53f..a4102d7 100644
--- a/arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c
+++ b/arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c
@@ -90,7 +90,7 @@ static struct at91_udc_data __initdata ek_udc_data = {
  * SPI devices.
  */
 static struct spi_board_info ek_spi_devices[] = {
-#if !defined(CONFIG_MMC_ATMELMCI)
+#if !(defined(CONFIG_MMC_ATMELMCI) || defined(CONFIG_MMC_AT91))
 	{	/* DataFlash chip */
 		.modalias	= "mtd_dataflash",
 		.chip_select	= 1,
@@ -113,7 +113,7 @@ static struct spi_board_info ek_spi_devices[] = {
  * MACB Ethernet device
  */
 static struct at91_eth_data __initdata ek_macb_data = {
-	.phy_irq_pin	= AT91_PIN_PC12,
+	.phy_irq_pin	= AT91_PIN_PB0,
 	.is_rmii	= 1,
 };
 
@@ -194,24 +194,27 @@ static void __init ek_add_device_nand(void)
 
 /*
  * MCI (SD/MMC)
- * det_pin and wp_pin are not connected
+ * wp_pin is not connected
  */
 #if defined(CONFIG_MMC_ATMELMCI) || defined(CONFIG_MMC_ATMELMCI_MODULE)
 static struct mci_platform_data __initdata ek_mmc_data = {
 	.slot[0] = {
 		.bus_width	= 4,
-		.detect_pin	= -ENODEV,
+		.detect_pin	= AT91_PIN_PC2,
 		.wp_pin		= -ENODEV,
 	},
 	.slot[1] = {
 		.bus_width	= 4,
-		.detect_pin	= -ENODEV,
+		.detect_pin	= AT91_PIN_PC9,
 		.wp_pin		= -ENODEV,
 	},
 
 };
 #else
-static struct amci_platform_data __initdata ek_mmc_data = {
+static struct at91_mmc_data __initdata ek_mmc_data = {
+	.slot_b		= 1,	/* Only one slot so use slot B */
+	.wire4		= 1,
+	.det_pin	= AT91_PIN_PC9,
 };
 #endif
 
@@ -221,13 +224,13 @@ static struct amci_platform_data __initdata ek_mmc_data = {
 static struct gpio_led ek_leds[] = {
 	{	/* "bottom" led, green, userled1 to be defined */
 		.name			= "ds5",
-		.gpio			= AT91_PIN_PB12,
+		.gpio			= AT91_PIN_PB8,
 		.active_low		= 1,
 		.default_trigger	= "none",
 	},
 	{	/* "power" led, yellow */
 		.name			= "ds1",
-		.gpio			= AT91_PIN_PB13,
+		.gpio			= AT91_PIN_PB9,
 		.default_trigger	= "heartbeat",
 	}
 };
@@ -254,7 +257,11 @@ static void __init ek_board_init(void)
 	/* Ethernet */
 	at91_add_device_eth(&ek_macb_data);
 	/* MMC */
+#if defined(CONFIG_MMC_ATMELMCI) || defined(CONFIG_MMC_ATMELMCI_MODULE)
 	at91_add_device_mci(0, &ek_mmc_data);
+#else
+	at91_add_device_mmc(0, &ek_mmc_data);
+#endif
 	/* I2C */
 	at91_add_device_i2c(ek_i2c_devices, ARRAY_SIZE(ek_i2c_devices));
 	/* LEDs */
-- 
1.5.6.5


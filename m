Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbZCWPeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbZCWPeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756737AbZCWPd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:33:26 -0400
Received: from mx1.emlix.com ([193.175.82.87]:53761 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbZCWPdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:33:24 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 2/6] xtensa: add s6000 spi host to s6105 platform
Date: Mon, 23 Mar 2009 16:34:18 +0100
Message-Id: <1237822462-32109-2-git-send-email-dg@emlix.com>
In-Reply-To: <1237822462-32109-1-git-send-email-dg@emlix.com>
References: <1237822462-32109-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/platforms/s6105/device.c |   48 ++++++++++++++++++++++++++++++++++
 arch/xtensa/platforms/s6105/setup.c  |    5 +++-
 2 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/platforms/s6105/device.c b/arch/xtensa/platforms/s6105/device.c
index 9394e6f..a7ea916 100644
--- a/arch/xtensa/platforms/s6105/device.c
+++ b/arch/xtensa/platforms/s6105/device.c
@@ -14,6 +14,8 @@
 #include <linux/platform_device.h>
 #include <linux/serial.h>
 #include <linux/serial_8250.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_s6000.h>
 
 #include <variant/hardware.h>
 #include <variant/dmac.h>
@@ -24,6 +26,7 @@
 #define UART_INTNUM		4
 #define GMAC_INTNUM		5
 #define I2C_INTNUM		6
+#define SPI_INTNUM		11
 
 static const signed char gpio3_irq_mappings[] = {
 	S6_INTC_GPIO(3),
@@ -49,11 +52,17 @@ static const signed char i2c_irq_mappings[] = {
 	-1
 };
 
+static const signed char spi_irq_mappings[] = {
+	S6_INTC_SPI,
+	-1
+};
+
 const signed char *platform_irq_mappings[NR_IRQS] = {
 	[GPIO3_INTNUM] = gpio3_irq_mappings,
 	[UART_INTNUM] = uart_irq_mappings,
 	[GMAC_INTNUM] = gmac_irq_mappings,
 	[I2C_INTNUM] = i2c_irq_mappings,
+	[SPI_INTNUM] = spi_irq_mappings,
 };
 
 static struct plat_serial8250_port serial_platform_data[] = {
@@ -173,6 +182,36 @@ static struct i2c_board_info __initdata s6_i2c_devices[] = {
 	},
 };
 
+static struct resource s6_spi_resource[] = {
+	{
+		.name   = "mem",
+		.start  = (resource_size_t)S6_REG_SPI,
+		.end    = (resource_size_t)S6_REG_SPI + 0x1000 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	{
+		.name   = "irq",
+		.start  = (resource_size_t)SPI_INTNUM,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+#define S6_SPI_BUS_NUM	0
+
+static __devinitdata struct s6_spi_platform_data s6_spi_pdata = {
+	.bus_num     = S6_SPI_BUS_NUM,
+	.cs_polarity = 0x00,
+	.clock       = "PCLK",
+};
+
+#define S6_SPI_CS_BOOT_FLASH	0
+#define S6_SPI_CS_BACK_PANEL	1
+#define S6_SPI_CS_EXPANSION	3
+#define S6_SPI_CS_MMC_SLOT	4
+
+static struct spi_board_info __initdata s6_spi_devices[] = {
+};
+
 static struct platform_device platform_devices[] = {
 	{
 		.name = "serial8250",
@@ -195,6 +234,14 @@ static struct platform_device platform_devices[] = {
 			.platform_data = &s6_i2c_pdata,
 		},
 	},
+	{
+		.name = "spi_s6000",
+		.resource = s6_spi_resource,
+		.num_resources = ARRAY_SIZE(s6_spi_resource),
+		.dev = {
+			.platform_data = &s6_spi_pdata,
+		},
+	},
 };
 
 static int __init device_init(void)
@@ -203,6 +250,7 @@ static int __init device_init(void)
 
 	i2c_register_board_info(S6_I2C_BUS_NUM, s6_i2c_devices,
 				ARRAY_SIZE(s6_i2c_devices));
+	spi_register_board_info(s6_spi_devices, ARRAY_SIZE(s6_spi_devices));
 	s6_gmac_resource[5].start = prepare_phy_irq(GPIO_PHY_IRQ);
 
 	for (i = 0; i < ARRAY_SIZE(platform_devices); i++)
diff --git a/arch/xtensa/platforms/s6105/setup.c b/arch/xtensa/platforms/s6105/setup.c
index e64db1c..5ffa148 100644
--- a/arch/xtensa/platforms/s6105/setup.c
+++ b/arch/xtensa/platforms/s6105/setup.c
@@ -58,7 +58,10 @@ void __init platform_setup(char **cmdline)
 
 void __init platform_init(bp_tag_t *first)
 {
-	s6_setup_gpio(0);
+	s6_setup_gpio(1 << GPIO_SPI_CS0 |
+			1 << GPIO_SPI_CS1 |
+			1 << GPIO_SPI_CS3 |
+			1 << GPIO_SPI_CS4);
 	gpio_request(GPIO_LED1_NGREEN, "led1_green");
 	gpio_request(GPIO_LED1_RED, "led1_red");
 	gpio_direction_output(GPIO_LED1_NGREEN, 1);
-- 
1.6.2.107.ge47ee


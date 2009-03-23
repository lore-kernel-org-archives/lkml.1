Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbZCWPEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbZCWPEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbZCWPEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:04:25 -0400
Received: from mx1.emlix.com ([193.175.82.87]:40935 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754700AbZCWPEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:04:23 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>,
       Oskar Schirmer <os@emlix.com>
Subject: [patch 2/5] xtensa: s6105 specific configuration for the s6000 i2c host
Date: Mon, 23 Mar 2009 16:05:15 +0100
Message-Id: <1237820718-30607-2-git-send-email-dg@emlix.com>
In-Reply-To: <1237820718-30607-1-git-send-email-dg@emlix.com>
References: <1237820718-30607-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Glöckner <dg@emlix.com>
Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 arch/xtensa/platforms/s6105/device.c |   51 ++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/arch/xtensa/platforms/s6105/device.c b/arch/xtensa/platforms/s6105/device.c
index 963634a..00f52ee 100644
--- a/arch/xtensa/platforms/s6105/device.c
+++ b/arch/xtensa/platforms/s6105/device.c
@@ -6,6 +6,8 @@
 
 #include <linux/kernel.h>
 #include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/i2c/s6000.h>
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/phy.h>
@@ -21,6 +23,7 @@
 #define GPIO3_INTNUM		3
 #define UART_INTNUM		4
 #define GMAC_INTNUM		5
+#define I2C_INTNUM		6
 
 static const signed char gpio3_irq_mappings[] = {
 	S6_INTC_GPIO(3),
@@ -41,10 +44,16 @@ static const signed char gmac_irq_mappings[] = {
 	-1
 };
 
+static const signed char i2c_irq_mappings[] = {
+	S6_INTC_I2C,
+	-1
+};
+
 const signed char *platform_irq_mappings[NR_IRQS] = {
 	[GPIO3_INTNUM] = gpio3_irq_mappings,
 	[UART_INTNUM] = uart_irq_mappings,
 	[GMAC_INTNUM] = gmac_irq_mappings,
+	[I2C_INTNUM] = i2c_irq_mappings,
 };
 
 static struct plat_serial8250_port serial_platform_data[] = {
@@ -129,6 +138,38 @@ fail:
 	return PHY_POLL;
 }
 
+#define S6_I2C_BUS_NUM 0
+
+static __devinitdata struct s6_i2c_platform_data s6_i2c_pdata = {
+	.bus_num = S6_I2C_BUS_NUM,
+	.clock = "PCLK",
+};
+
+static struct resource s6_i2c_resource[] = {
+	{
+		.name   = "mem",
+		.start  = (resource_size_t)S6_REG_I2C,
+		.end    = (resource_size_t)S6_REG_I2C + 0x1000 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	{
+		.name   = "irq",
+		.start  = (resource_size_t)I2C_INTNUM,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+#define S6I2C_ADDR_TLV320AIC31	0x18
+#define S6I2C_ADDR_SAA7121	0x44
+#define S6I2C_ADDR_MT9D131	0x48
+#define S6I2C_ADDR_AT24HC02B	0x57
+#define S6I2C_ADDR_M41T62	0x68
+#define S6I2C_ADDR_CDCE906	0x69
+#define S6I2C_ADDR_PCA9543	0x73
+
+static struct i2c_board_info __initdata s6_i2c_devices[] = {
+};
+
 static struct platform_device platform_devices[] = {
 	{
 		.name = "serial8250",
@@ -143,12 +184,22 @@ static struct platform_device platform_devices[] = {
 		.resource = s6_gmac_resource,
 		.num_resources = ARRAY_SIZE(s6_gmac_resource),
 	},
+	{
+		.name = "i2c-s6000",
+		.resource = s6_i2c_resource,
+		.num_resources = ARRAY_SIZE(s6_i2c_resource),
+		.dev = {
+			.platform_data = &s6_i2c_pdata,
+		},
+	},
 };
 
 static int __init device_init(void)
 {
 	int i;
 
+	i2c_register_board_info(S6_I2C_BUS_NUM, s6_i2c_devices,
+				ARRAY_SIZE(s6_i2c_devices));
 	s6_gmac_resource[5].start = prepare_phy_irq(GPIO_PHY_IRQ);
 
 	for (i = 0; i < ARRAY_SIZE(platform_devices); i++)
-- 
1.6.2.107.ge47ee


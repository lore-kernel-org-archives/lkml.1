Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbZCZOtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbZCZOtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758939AbZCZOs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:48:28 -0400
Received: from mx1.emlix.com ([193.175.82.87]:42312 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758830AbZCZOs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:48:27 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 1/5] xtensa: add s6000 data port to s6105 platform
Date: Thu, 26 Mar 2009 15:49:30 +0100
Message-Id: <1238078974-26040-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/platforms/s6105/device.c               |   40 ++++++++++++++++++++
 arch/xtensa/platforms/s6105/include/platform/irq.h |    1 +
 arch/xtensa/platforms/s6105/setup.c                |    2 +
 3 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/xtensa/platforms/s6105/device.c b/arch/xtensa/platforms/s6105/device.c
index f7af6d2..9238d24 100644
--- a/arch/xtensa/platforms/s6105/device.c
+++ b/arch/xtensa/platforms/s6105/device.c
@@ -22,6 +22,7 @@
 #include <linux/spi/mmc_spi.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/spi_s6000.h>
+#include <media/s6dp-link.h>
 
 #include <variant/hardware.h>
 #include <variant/dmac.h>
@@ -53,6 +54,14 @@ static const signed char i2c_irq_mappings[] = {
 	-1
 };
 
+static const signed char dp_irq_mappings[] = {
+	S6_INTC_DMA_DPTERMCNT(0),
+	S6_INTC_DMA_DPTERMCNT(1),
+	S6_INTC_DMA_DPTERMCNT(2),
+	S6_INTC_DMA_DPTERMCNT(3),
+	-1
+};
+
 static const signed char isef_irq_mappings[] = {
 	S6_INTC_DMA_LMSPENDCNT(11),
 	-1
@@ -75,6 +84,7 @@ const signed char *platform_irq_mappings[NR_IRQS] = {
 	[UART_INTNUM] = uart_irq_mappings,
 	[GMAC_INTNUM] = gmac_irq_mappings,
 	[I2C_INTNUM] = i2c_irq_mappings,
+	[DP_INTNUM] = dp_irq_mappings,
 	[ISEF_INTNUM] = isef_irq_mappings,
 	[I2S_INTNUM] = i2s_irq_mappings,
 	[SPI_INTNUM] = spi_irq_mappings,
@@ -191,6 +201,10 @@ static struct resource s6_i2c_resource[] = {
 #define S6I2C_ADDR_CDCE906	0x69
 #define S6I2C_ADDR_PCA9543	0x73
 
+static struct s6dp_link s6dp_links[] = {
+	{ }
+};
+
 static struct i2c_board_info __initdata s6_i2c_devices[] = {
 	{
 		I2C_BOARD_INFO("24c02", S6I2C_ADDR_AT24HC02B),
@@ -355,6 +369,23 @@ static struct spi_board_info __initdata s6_spi_devices[] = {
 	},
 };
 
+static struct resource s6_dp_resource[] = {
+	{
+		.start	= (resource_size_t)S6_REG_DP,
+		.end	= (resource_size_t)S6_REG_DP + 0x10000 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= (resource_size_t)S6_REG_DPDMA,
+		.end	= (resource_size_t)S6_REG_DPDMA + 0x10000 - 1,
+		.flags	= IORESOURCE_DMA,
+	},
+	{
+		.start	= (resource_size_t)DP_INTNUM,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
 static struct platform_device platform_devices[] = {
 	{
 		.name = "serial8250",
@@ -391,6 +422,15 @@ static struct platform_device platform_devices[] = {
 			.platform_data = &s6_spi_pdata,
 		},
 	},
+	{
+		.name = "s6dp",
+		.id = -1,
+		.resource = s6_dp_resource,
+		.num_resources = ARRAY_SIZE(s6_dp_resource),
+		.dev = {
+			.platform_data = &s6dp_links,
+		},
+	},
 };
 
 static int __init device_init(void)
diff --git a/arch/xtensa/platforms/s6105/include/platform/irq.h b/arch/xtensa/platforms/s6105/include/platform/irq.h
index 84c972f..65f6d92 100644
--- a/arch/xtensa/platforms/s6105/include/platform/irq.h
+++ b/arch/xtensa/platforms/s6105/include/platform/irq.h
@@ -5,6 +5,7 @@
 #define UART_INTNUM	4
 #define GMAC_INTNUM	5
 #define I2C_INTNUM	6
+#define DP_INTNUM	7
 #define ISEF_INTNUM	8
 #define I2S_INTNUM	10
 #define SPI_INTNUM	11
diff --git a/arch/xtensa/platforms/s6105/setup.c b/arch/xtensa/platforms/s6105/setup.c
index bbd1730..87ae88c 100644
--- a/arch/xtensa/platforms/s6105/setup.c
+++ b/arch/xtensa/platforms/s6105/setup.c
@@ -46,12 +46,14 @@ void __init platform_setup(char **cmdline)
 	reg &= ~(1 << S6_GREG1_BLOCK_SB);
 	reg &= ~(1 << S6_GREG1_BLOCK_GMAC);
 	reg &= ~(1 << S6_GREG1_BLOCK_I2S);
+	reg &= ~(1 << S6_GREG1_BLOCK_DP);
 	writel(reg, S6_REG_GREG1 + S6_GREG1_CLKGATE);
 
 	reg = readl(S6_REG_GREG1 + S6_GREG1_BLOCKENA);
 	reg |= 1 << S6_GREG1_BLOCK_SB;
 	reg |= 1 << S6_GREG1_BLOCK_GMAC;
 	reg |= 1 << S6_GREG1_BLOCK_I2S;
+	reg |= 1 << S6_GREG1_BLOCK_DP;
 	writel(reg, S6_REG_GREG1 + S6_GREG1_BLOCKENA);
 
 	printk(KERN_NOTICE "S6105 on Stretch S6000 - "
-- 
1.6.2.107.ge47ee


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758101AbZCZNdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbZCZNdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 09:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbZCZNcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 09:32:43 -0400
Received: from mx1.emlix.com ([193.175.82.87]:35334 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbZCZNcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 09:32:41 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 3/4] xtensa: prepare s6105 platform for I2S
Date: Thu, 26 Mar 2009 14:33:47 +0100
Message-Id: <1238074428-24666-3-git-send-email-dg@emlix.com>
In-Reply-To: <1238074428-24666-1-git-send-email-dg@emlix.com>
References: <1238074428-24666-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch routes the I2S irq, powers up the I2S block and resets the
I2S codec.

Resetting of the codec can't be moved to the sound driver as the reset
line affects another chip as well.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/platforms/s6105/device.c |   16 ++++++++++++++++
 arch/xtensa/platforms/s6105/setup.c  |    2 ++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/xtensa/platforms/s6105/device.c b/arch/xtensa/platforms/s6105/device.c
index d296201..f7af6d2 100644
--- a/arch/xtensa/platforms/s6105/device.c
+++ b/arch/xtensa/platforms/s6105/device.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/delay.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
 #include <linux/i2c/s6000.h>
@@ -57,6 +58,13 @@ static const signed char isef_irq_mappings[] = {
 	-1
 };
 
+static const signed char i2s_irq_mappings[] = {
+	S6_INTC_I2S_ERR,
+	S6_INTC_DMA_HOSTTERMCNT(2),
+	S6_INTC_DMA_HOSTTERMCNT(3),
+	-1
+};
+
 static const signed char spi_irq_mappings[] = {
 	S6_INTC_SPI,
 	-1
@@ -68,6 +76,7 @@ const signed char *platform_irq_mappings[NR_IRQS] = {
 	[GMAC_INTNUM] = gmac_irq_mappings,
 	[I2C_INTNUM] = i2c_irq_mappings,
 	[ISEF_INTNUM] = isef_irq_mappings,
+	[I2S_INTNUM] = i2s_irq_mappings,
 	[SPI_INTNUM] = spi_irq_mappings,
 };
 
@@ -388,6 +397,13 @@ static int __init device_init(void)
 {
 	int i;
 
+	/* reset TLV320AIC31 and SAA7121 */
+	if (!gpio_request(GPIO_BP_RESET, "bp_reset")) {
+		gpio_direction_output(GPIO_BP_RESET, 0);
+		udelay(1);
+		gpio_set_value(GPIO_BP_RESET, 1);
+	}
+
 	i2c_register_board_info(S6_I2C_BUS_NUM, s6_i2c_devices,
 				ARRAY_SIZE(s6_i2c_devices));
 	spi_register_board_info(s6_spi_devices, ARRAY_SIZE(s6_spi_devices));
diff --git a/arch/xtensa/platforms/s6105/setup.c b/arch/xtensa/platforms/s6105/setup.c
index 5ffa148..bbd1730 100644
--- a/arch/xtensa/platforms/s6105/setup.c
+++ b/arch/xtensa/platforms/s6105/setup.c
@@ -45,11 +45,13 @@ void __init platform_setup(char **cmdline)
 	reg = readl(S6_REG_GREG1 + S6_GREG1_CLKGATE);
 	reg &= ~(1 << S6_GREG1_BLOCK_SB);
 	reg &= ~(1 << S6_GREG1_BLOCK_GMAC);
+	reg &= ~(1 << S6_GREG1_BLOCK_I2S);
 	writel(reg, S6_REG_GREG1 + S6_GREG1_CLKGATE);
 
 	reg = readl(S6_REG_GREG1 + S6_GREG1_BLOCKENA);
 	reg |= 1 << S6_GREG1_BLOCK_SB;
 	reg |= 1 << S6_GREG1_BLOCK_GMAC;
+	reg |= 1 << S6_GREG1_BLOCK_I2S;
 	writel(reg, S6_REG_GREG1 + S6_GREG1_BLOCKENA);
 
 	printk(KERN_NOTICE "S6105 on Stretch S6000 - "
-- 
1.6.2.107.ge47ee


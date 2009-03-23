Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbZCWON3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbZCWON3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 10:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757455AbZCWOMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 10:12:36 -0400
Received: from mx1.emlix.com ([193.175.82.87]:57594 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757200AbZCWOM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 10:12:26 -0400
From: Oskar Schirmer <os@emlix.com>
To: Jeff Garzik <jgarzik@pobox.com>, Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Oskar Schirmer <os@emlix.com>,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 2/3] xtensa: s6105 specific configuration for s6gmac
Date: Mon, 23 Mar 2009 15:13:19 +0100
Message-Id: <1237817600-29471-2-git-send-email-os@emlix.com>
In-Reply-To: <1237817600-29471-1-git-send-email-os@emlix.com>
References: <1237817600-29471-1-git-send-email-os@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform-specific configuration for the s6gmac driver, including the
PHY interrupt line.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 arch/xtensa/platforms/s6105/device.c |   91 ++++++++++++++++++++++++++++++++++
 arch/xtensa/platforms/s6105/setup.c  |    9 +++
 2 files changed, 100 insertions(+), 0 deletions(-)

diff --git a/arch/xtensa/platforms/s6105/device.c b/arch/xtensa/platforms/s6105/device.c
index 78b08be..963634a 100644
--- a/arch/xtensa/platforms/s6105/device.c
+++ b/arch/xtensa/platforms/s6105/device.c
@@ -5,14 +5,27 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/gpio.h>
 #include <linux/init.h>
+#include <linux/irq.h>
+#include <linux/phy.h>
 #include <linux/platform_device.h>
 #include <linux/serial.h>
 #include <linux/serial_8250.h>
 
 #include <variant/hardware.h>
+#include <variant/dmac.h>
 
+#include <platform/gpio.h>
+
+#define GPIO3_INTNUM		3
 #define UART_INTNUM		4
+#define GMAC_INTNUM		5
+
+static const signed char gpio3_irq_mappings[] = {
+	S6_INTC_GPIO(3),
+	-1
+};
 
 static const signed char uart_irq_mappings[] = {
 	S6_INTC_UART(0),
@@ -20,8 +33,18 @@ static const signed char uart_irq_mappings[] = {
 	-1,
 };
 
+static const signed char gmac_irq_mappings[] = {
+	S6_INTC_GMAC_STAT,
+	S6_INTC_GMAC_ERR,
+	S6_INTC_DMA_HOSTTERMCNT(0),
+	S6_INTC_DMA_HOSTTERMCNT(1),
+	-1
+};
+
 const signed char *platform_irq_mappings[NR_IRQS] = {
+	[GPIO3_INTNUM] = gpio3_irq_mappings,
 	[UART_INTNUM] = uart_irq_mappings,
+	[GMAC_INTNUM] = gmac_irq_mappings,
 };
 
 static struct plat_serial8250_port serial_platform_data[] = {
@@ -46,6 +69,66 @@ static struct plat_serial8250_port serial_platform_data[] = {
 	{ },
 };
 
+static struct resource s6_gmac_resource[] = {
+	{
+		.name   = "mem",
+		.start  = (resource_size_t)S6_REG_GMAC,
+		.end    = (resource_size_t)S6_REG_GMAC + 0x10000 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	{
+		.name   = "dma",
+		.start  = (resource_size_t)
+			DMA_CHNL(S6_REG_HIFDMA, S6_HIFDMA_GMACTX),
+		.end    = (resource_size_t)
+			DMA_CHNL(S6_REG_HIFDMA, S6_HIFDMA_GMACTX) + 0x100 - 1,
+		.flags  = IORESOURCE_DMA,
+	},
+	{
+		.name   = "dma",
+		.start  = (resource_size_t)
+			DMA_CHNL(S6_REG_HIFDMA, S6_HIFDMA_GMACRX),
+		.end    = (resource_size_t)
+			DMA_CHNL(S6_REG_HIFDMA, S6_HIFDMA_GMACRX) + 0x100 - 1,
+		.flags  = IORESOURCE_DMA,
+	},
+	{
+		.name   = "io",
+		.start  = (resource_size_t)S6_MEM_GMAC,
+		.end    = (resource_size_t)S6_MEM_GMAC + 0x2000000 - 1,
+		.flags  = IORESOURCE_IO,
+	},
+	{
+		.name   = "irq",
+		.start  = (resource_size_t)GMAC_INTNUM,
+		.flags  = IORESOURCE_IRQ,
+	},
+	{
+		.name   = "irq",
+		.start  = (resource_size_t)PHY_POLL,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+static int __init prepare_phy_irq(int pin)
+{
+	int irq;
+	if (gpio_request(pin, "s6gmac_phy") < 0)
+		goto fail;
+	if (gpio_direction_input(pin) < 0)
+		goto free;
+	irq = gpio_to_irq(pin);
+	if (irq < 0)
+		goto free;
+	if (set_irq_type(irq, IRQ_TYPE_LEVEL_LOW) < 0)
+		goto free;
+	return irq;
+free:
+	gpio_free(pin);
+fail:
+	return PHY_POLL;
+}
+
 static struct platform_device platform_devices[] = {
 	{
 		.name = "serial8250",
@@ -54,12 +137,20 @@ static struct platform_device platform_devices[] = {
 			.platform_data = serial_platform_data,
 		},
 	},
+	{
+		.name = "s6gmac",
+		.id = 0,
+		.resource = s6_gmac_resource,
+		.num_resources = ARRAY_SIZE(s6_gmac_resource),
+	},
 };
 
 static int __init device_init(void)
 {
 	int i;
 
+	s6_gmac_resource[5].start = prepare_phy_irq(GPIO_PHY_IRQ);
+
 	for (i = 0; i < ARRAY_SIZE(platform_devices); i++)
 		platform_device_register(&platform_devices[i]);
 	return 0;
diff --git a/arch/xtensa/platforms/s6105/setup.c b/arch/xtensa/platforms/s6105/setup.c
index 1dbf133..e64db1c 100644
--- a/arch/xtensa/platforms/s6105/setup.c
+++ b/arch/xtensa/platforms/s6105/setup.c
@@ -35,12 +35,21 @@ void __init platform_setup(char **cmdline)
 {
 	unsigned long reg;
 
+	reg = readl(S6_REG_GREG1 + S6_GREG1_PLLSEL);
+	reg &= ~(S6_GREG1_PLLSEL_GMAC_MASK << S6_GREG1_PLLSEL_GMAC |
+		S6_GREG1_PLLSEL_GMII_MASK << S6_GREG1_PLLSEL_GMII);
+	reg |= S6_GREG1_PLLSEL_GMAC_125MHZ << S6_GREG1_PLLSEL_GMAC |
+		S6_GREG1_PLLSEL_GMII_125MHZ << S6_GREG1_PLLSEL_GMII;
+	writel(reg, S6_REG_GREG1 + S6_GREG1_PLLSEL);
+
 	reg = readl(S6_REG_GREG1 + S6_GREG1_CLKGATE);
 	reg &= ~(1 << S6_GREG1_BLOCK_SB);
+	reg &= ~(1 << S6_GREG1_BLOCK_GMAC);
 	writel(reg, S6_REG_GREG1 + S6_GREG1_CLKGATE);
 
 	reg = readl(S6_REG_GREG1 + S6_GREG1_BLOCKENA);
 	reg |= 1 << S6_GREG1_BLOCK_SB;
+	reg |= 1 << S6_GREG1_BLOCK_GMAC;
 	writel(reg, S6_REG_GREG1 + S6_GREG1_BLOCKENA);
 
 	printk(KERN_NOTICE "S6105 on Stretch S6000 - "
-- 
1.6.2.107.ge47ee


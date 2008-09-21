Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbYIUWWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbYIUWWJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 18:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYIUWV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 18:21:57 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:45697 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbYIUWV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 18:21:56 -0400
X-Greylist: delayed 1267 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Sep 2008 18:21:56 EDT
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: kernel@wantstofly.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] [ARM] ep93xx: add ethernet support for edb9302
Date: Sun, 21 Sep 2008 19:00:43 -0300
Message-Id: <1222034443-6732-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EDB9302 board use EP9302 controller, which include an ethernet device.
Register the platform device to enable it.

Using edb9302a won't work for these boards because they do not include
the chip ID. Ethernet wouldn't work without this patch and it seems
there is no edb9302 board without ethernet. So, this is the correct fix.
---
 arch/arm/mach-ep93xx/edb9302.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-ep93xx/edb9302.c b/arch/arm/mach-ep93xx/edb9302.c
index 97550c0..fb34289 100644
--- a/arch/arm/mach-ep93xx/edb9302.c
+++ b/arch/arm/mach-ep93xx/edb9302.c
@@ -43,10 +43,40 @@ static struct platform_device edb9302_flash = {
 	.resource	= &edb9302_flash_resource,
 };
 
+static struct ep93xx_eth_data edb9302_eth_data = {
+	.phy_id			= 1,
+};
+
+static struct resource edb9302_eth_resource[] = {
+	{
+		.start	= EP93XX_ETHERNET_PHYS_BASE,
+		.end	= EP93XX_ETHERNET_PHYS_BASE + 0xffff,
+		.flags	= IORESOURCE_MEM,
+	}, {
+		.start	= IRQ_EP93XX_ETHERNET,
+		.end	= IRQ_EP93XX_ETHERNET,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device edb9302_eth_device = {
+	.name		= "ep93xx-eth",
+	.id		= -1,
+	.dev		= {
+		.platform_data	= &edb9302_eth_data,
+	},
+	.num_resources	= 2,
+	.resource	= edb9302_eth_resource,
+};
+
 static void __init edb9302_init_machine(void)
 {
 	ep93xx_init_devices();
 	platform_device_register(&edb9302_flash);
+
+	memcpy(edb9302_eth_data.dev_addr,
+		(void *)(EP93XX_ETHERNET_BASE + 0x50), 6);
+	platform_device_register(&edb9302_eth_device);
 }
 
 MACHINE_START(EDB9302, "Cirrus Logic EDB9302 Evaluation Board")
-- 
1.5.6.5


Return-Path: <linux-kernel-owner+w=401wt.eu-S1765000AbXEUKRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765000AbXEUKRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756867AbXEUKJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:42 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:27800 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761461AbXEUKJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:19 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="39510287:sNHT37681042"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 05/32] Blackfin arch: Add configuration data for ISP176x on BF561
Date: Mon, 21 May 2007 18:09:13 +0800
Message-Id: <11797421832284-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-bf561/boards/ezkit.c |   49 +++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-bf561/boards/ezkit.c b/arch/blackfin/mach-bf561/boards/ezkit.c
index 14eb4f9..e8d4058 100644
--- a/arch/blackfin/mach-bf561/boards/ezkit.c
+++ b/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -32,12 +32,61 @@
 #include <linux/spi/spi.h>
 #include <asm/irq.h>
 #include <asm/bfin5xx_spi.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 
 /*
  * Name the Board for the /proc/cpuinfo
  */
 char *bfin_board_name = "ADDS-BF561-EZKIT";
 
+#define ISP1761_BASE       0x2C0F0000
+#define ISP1761_IRQ        IRQ_PF10
+
+#if defined(CONFIG_USB_ISP1760_HCD) || defined(CONFIG_USB_ISP1760_HCD_MODULE)
+static struct resource bfin_isp1761_resources[] = {
+	[0] = {
+		.name	= "isp1761-regs",
+		.start  = ISP1761_BASE + 0x00000000,
+		.end    = ISP1761_BASE + 0x000fffff,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = ISP1761_IRQ,
+		.end    = ISP1761_IRQ,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bfin_isp1761_device = {
+	.name           = "isp1761",
+	.id             = 0,
+	.num_resources  = ARRAY_SIZE(bfin_isp1761_resources),
+	.resource       = bfin_isp1761_resources,
+};
+
+static struct platform_device *bfin_isp1761_devices[] = {
+	&bfin_isp1761_device,
+};
+
+int __init bfin_isp1761_init(void)
+{
+	unsigned int num_devices=ARRAY_SIZE(bfin_isp1761_devices);
+
+	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	set_irq_type(ISP1761_IRQ, IRQF_TRIGGER_FALLING);
+
+	return platform_add_devices(bfin_isp1761_devices, num_devices);
+}
+
+void __exit bfin_isp1761_exit(void)
+{
+	platform_device_unregister(&bfin_isp1761_device);
+}
+
+arch_initcall(bfin_isp1761_init);
+#endif
+
 /*
  *  USB-LAN EzExtender board
  *  Driver needs to know address, irq and flag pin.
-- 
1.5.1.2

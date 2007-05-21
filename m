Return-Path: <linux-kernel-owner+w=401wt.eu-S1765477AbXEUKS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765477AbXEUKS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762004AbXEUKJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:48 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:4457 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761602AbXEUKJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:21 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="39510301:sNHT29050301"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 13/32] Blackfin arch: initial tepla-bf561 board support
Date: Mon, 21 May 2007 18:09:21 +0800
Message-Id: <1179742184861-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/Kconfig                    |    8 +++-
 arch/blackfin/mach-bf561/boards/Makefile |    3 +-
 arch/blackfin/mach-bf561/boards/tepla.c  |   61 ++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 2 deletions(-)
 create mode 100644 arch/blackfin/mach-bf561/boards/tepla.c

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 35b33a4..b1b111b 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -193,7 +193,7 @@ config BFIN537_BLUETECHNIX_CM
 	  CM-BF537 support for EVAL- and DEV-Board.
 
 config BFIN561_BLUETECHNIX_CM
-	bool "BF561-CM"
+	bool "Bluetechnix CM-BF561"
 	depends on (BF561)
 	help
 	  CM-BF561 support for EVAL- and DEV-Board.
@@ -204,6 +204,12 @@ config BFIN561_EZKIT
 	help
 	  BF561-EZKIT-LITE board Support.
 
+config BFIN561_TEPLA
+	bool "BF561-TEPLA"
+	depends on (BF561)
+	help
+	 BF561-TEPLA board Support.
+
 config PNAV10
 	bool "PNAV 1.0 board"
 	depends on (BF537)
diff --git a/arch/blackfin/mach-bf561/boards/Makefile b/arch/blackfin/mach-bf561/boards/Makefile
index 886edc7..495a1cf 100644
--- a/arch/blackfin/mach-bf561/boards/Makefile
+++ b/arch/blackfin/mach-bf561/boards/Makefile
@@ -3,5 +3,6 @@
 #
 
 obj-$(CONFIG_GENERIC_BOARD)            += generic_board.o
-obj-$(CONFIG_BFIN561_EZKIT)            += ezkit.o
 obj-$(CONFIG_BFIN561_BLUETECHNIX_CM)   += cm_bf561.o
+obj-$(CONFIG_BFIN561_EZKIT)            += ezkit.o
+obj-$(CONFIG_BFIN561_TEPLA)            += tepla.o
diff --git a/arch/blackfin/mach-bf561/boards/tepla.c b/arch/blackfin/mach-bf561/boards/tepla.c
new file mode 100644
index 0000000..db308c7
--- /dev/null
+++ b/arch/blackfin/mach-bf561/boards/tepla.c
@@ -0,0 +1,61 @@
+/*
+ *  File: arch/blackfin/mach-bf561/tepla.c
+ *
+ *  Copyright 2004-2007 Analog Devices Inc.
+ *  Only SMSC91C1111 was registered, may do more later.
+ *
+ *  Copyright 2005 National ICT Australia (NICTA), Aidan Williams <aidan@nicta.com.au>
+ *  Thanks to Jamey Hicks.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <asm/irq.h>
+
+char *bfin_board_name = "Tepla-BF561";
+
+/*
+ *  Driver needs to know address, irq and flag pin.
+ */
+static struct resource smc91x_resources[] = {
+	{
+		.start	= 0x2C000300,
+		.end	= 0x2C000320,
+		.flags	= IORESOURCE_MEM,
+	},{
+		.start	= IRQ_PROG_INTB,
+		.end	= IRQ_PROG_INTB,
+		.flags	= IORESOURCE_IRQ|IORESOURCE_IRQ_HIGHLEVEL,
+	},{
+		/*
+		 *  denotes the flag pin and is used directly if
+		 *  CONFIG_IRQCHIP_DEMUX_GPIO is defined.
+		 */
+		.start	= IRQ_PF7,
+		.end	= IRQ_PF7,
+		.flags	= IORESOURCE_IRQ|IORESOURCE_IRQ_HIGHLEVEL,
+	},
+};
+
+static struct platform_device smc91x_device = {
+	.name          = "smc91x",
+	.id            = 0,
+	.num_resources = ARRAY_SIZE(smc91x_resources),
+	.resource      = smc91x_resources,
+};
+
+static struct platform_device *tepla_devices[] __initdata = {
+	&smc91x_device,
+};
+
+static int __init tepla_init(void)
+{
+	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	return platform_add_devices(tepla_devices, ARRAY_SIZE(tepla_devices));
+}
+
+arch_initcall(tepla_init);
-- 
1.5.1.2

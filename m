Return-Path: <linux-kernel-owner+w=401wt.eu-S1752269AbZFOCmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbZFOCmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 22:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbZFOCmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 22:42:08 -0400
Received: from smtp-out.google.com ([216.239.45.13]:52032 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbZFOCmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 22:42:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=ToJ9bRUMpYVuloclvRsAZ7Xrj8aTPO1MsRr/jDEDeOxeXyB+85FQHWY4FHmvCbZOZ
	+9EgzKo1Q4sivcloFBiWw==
From: Brian Swetland <swetland@google.com>
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, pavel@ucw.cz,
       Brian Swetland <swetland@google.com>
Subject: [PATCH 3/3] [ARM] msm: add minimal board file for HTC Dream device
Date: Sun, 14 Jun 2009 19:39:17 -0700
Message-Id: <1245033557-10968-4-git-send-email-swetland@google.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1245033557-10968-3-git-send-email-swetland@google.com>
References: <1245033557-10968-1-git-send-email-swetland@google.com>
 <1245033557-10968-2-git-send-email-swetland@google.com>
 <1245033557-10968-3-git-send-email-swetland@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Swetland <swetland@google.com>
---
 arch/arm/mach-msm/Kconfig       |    6 ++
 arch/arm/mach-msm/Makefile      |    1 +
 arch/arm/mach-msm/board-dream.c |  113 +++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/board-dream.h |    5 ++
 4 files changed, 125 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/board-dream.c
 create mode 100644 arch/arm/mach-msm/board-dream.h

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 35f2a90..f780086 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -34,4 +34,10 @@ config MACH_HALIBUT
 	help
 	  Support for the Qualcomm SURF7201A eval board.
 
+config MACH_TROUT
+	default y
+	bool "HTC Dream (aka trout)"
+	help
+	  Support for the HTC Dream, T-Mobile G1, Android ADP1 devices.
+
 endif
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 1aa4700..91e6f5c 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -6,3 +6,4 @@ obj-y += clock.o clock-7x01a.o
 
 obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o
 
+obj-$(CONFIG_MACH_TROUT) += board-dream.o
diff --git a/arch/arm/mach-msm/board-dream.c b/arch/arm/mach-msm/board-dream.c
new file mode 100644
index 0000000..1babe45
--- /dev/null
+++ b/arch/arm/mach-msm/board-dream.c
@@ -0,0 +1,113 @@
+/* linux/arch/arm/mach-msm/board-dream.c
+ *
+ * Copyright (C) 2009 Google, Inc.
+ * Author: Brian Swetland <swetland@google.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+
+#include <mach/hardware.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/flash.h>
+
+#include <mach/irqs.h>
+#include <mach/board.h>
+#include <mach/msm_iomap.h>
+
+#include <linux/mtd/nand.h>
+#include <linux/mtd/partitions.h>
+
+#include "devices.h"
+#include "board-dream.h"
+
+static struct resource smc91x_resources[] = {
+	[0] = {
+		.start	= 0x9C004300,
+		.end	= 0x9C004400,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= MSM_GPIO_TO_INT(49),
+		.end	= MSM_GPIO_TO_INT(49),
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device smc91x_device = {
+	.name		= "smc91x",
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(smc91x_resources),
+	.resource	= smc91x_resources,
+};
+
+static struct platform_device *devices[] __initdata = {
+	&msm_device_uart3,
+	&msm_device_smd,
+	&msm_device_nand,
+	&msm_device_hsusb,
+	&msm_device_i2c,
+	&smc91x_device,
+};
+
+extern struct sys_timer msm_timer;
+
+static void __init trout_init_irq(void)
+{
+	msm_init_irq();
+}
+
+static void __init trout_init(void)
+{
+	platform_add_devices(devices, ARRAY_SIZE(devices));
+}
+
+static struct map_desc trout_io_desc[] __initdata = {
+	{
+		.virtual = TROUT_CPLD_BASE,
+		.pfn     = __phys_to_pfn(TROUT_CPLD_START),
+		.length  = TROUT_CPLD_SIZE,
+		.type    = MT_DEVICE_NONSHARED
+	}
+};
+
+static void __init trout_map_io(void)
+{
+	msm_map_common_io();
+	iotable_init(trout_io_desc, ARRAY_SIZE(trout_io_desc));
+
+#ifdef CONFIG_MSM_DEBUG_UART3
+	/* route UART3 to the "H2W" extended usb connector */
+	writeb(0x80, TROUT_CPLD_BASE + 0x00);
+#endif
+
+	msm_clock_init();
+}
+
+MACHINE_START(TROUT, "HTC Dream")
+#ifdef CONFIG_MSM_DEBUG_UART
+	.phys_io	= MSM_DEBUG_UART_PHYS,
+	.io_pg_offst	= ((MSM_DEBUG_UART_BASE) >> 18) & 0xfffc,
+#endif
+	.boot_params	= 0x10000100,
+	.map_io		= trout_map_io,
+	.init_irq	= trout_init_irq,
+	.init_machine	= trout_init,
+	.timer		= &msm_timer,
+MACHINE_END
diff --git a/arch/arm/mach-msm/board-dream.h b/arch/arm/mach-msm/board-dream.h
new file mode 100644
index 0000000..4f345a5
--- /dev/null
+++ b/arch/arm/mach-msm/board-dream.h
@@ -0,0 +1,5 @@
+
+#define TROUT_CPLD_BASE   0xE8100000
+#define TROUT_CPLD_START  0x98000000
+#define TROUT_CPLD_SIZE   SZ_4K
+
-- 
1.6.2.4


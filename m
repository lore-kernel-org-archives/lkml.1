Return-Path: <linux-kernel-owner+w=401wt.eu-S1759496AbZBSNux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496AbZBSNux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756515AbZBSNrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:47:36 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:50970 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbZBSNrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:47:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vUM8sbtzfh/TTbAn4icd+MsBqfTI7s6RklLEgOC6FQm6+1zMmo4JwiD9RcTVS/cZMO
         8uZHN5IAqS8eMTQxObyBw2fUnrbyy8rFVumJOIHkvcnhs7VJmgVvB8LVX36bxoANdvHV
         ipKIj+0tnTZx3TxJHlGr50MTEwEqyNGF/MWnY=
From: Eric Miao <eric.y.miao@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Eric Miao <eric.miao@marvell.com>,
       Zhangfei Gao <zhangfei.gao@marvell.com>
Subject: [PATCH] [ARM] pxa/zylonite2: add support for debug ethernet
Date: Thu, 19 Feb 2009 21:45:59 +0800
Message-Id: <1235051161-8858-11-git-send-email-eric.y.miao@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1235051161-8858-10-git-send-email-eric.y.miao@gmail.com>
References: <1235051161-8858-1-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-2-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-3-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-4-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-5-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-6-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-7-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-8-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-9-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-10-git-send-email-eric.y.miao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Miao <eric.miao@marvell.com>

Signed-off-by: Zhangfei Gao <zhangfei.gao@marvell.com>
Signed-off-by: Eric Miao <eric.miao@marvell.com>
---
 arch/arm/mach-mmp/zylonite2.c |   63 +++++++++++++++++++++++++++++++++++++++++
 drivers/net/smc91x.h          |    1 +
 2 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mmp/zylonite2.c b/arch/arm/mach-mmp/zylonite2.c
index ca419aa..59792c7 100644
--- a/arch/arm/mach-mmp/zylonite2.c
+++ b/arch/arm/mach-mmp/zylonite2.c
@@ -10,26 +10,89 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/smc91x.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <mach/addr-map.h>
 #include <mach/mfp-pxa168.h>
 #include <mach/pxa168.h>
+#include <mach/gpio.h>
 
 #include "common.h"
 
 static unsigned long zylonite2_pin_config[] __initdata = {
+	/* Data Flash Interface */
+	GPIO0_DFI_D15,
+	GPIO1_DFI_D14,
+	GPIO2_DFI_D13,
+	GPIO3_DFI_D12,
+	GPIO4_DFI_D11,
+	GPIO5_DFI_D10,
+	GPIO6_DFI_D9,
+	GPIO7_DFI_D8,
+	GPIO8_DFI_D7,
+	GPIO9_DFI_D6,
+	GPIO10_DFI_D5,
+	GPIO11_DFI_D4,
+	GPIO12_DFI_D3,
+	GPIO13_DFI_D2,
+	GPIO14_DFI_D1,
+	GPIO15_DFI_D0,
+
+	/* Static Memory Controller */
+	GPIO18_SMC_nCS0,
+	GPIO34_SMC_nCS1,
+	GPIO23_SMC_nLUA,
+	GPIO25_SMC_nLLA,
+	GPIO28_SMC_RDY,
+	GPIO29_SMC_SCLK,
+	GPIO35_SMC_BE1,
+	GPIO36_SMC_BE2,
+	GPIO27_GPIO,	/* Ethernet IRQ */
+
 	/* UART1 */
 	GPIO107_UART1_RXD,
 	GPIO108_UART1_TXD,
 };
 
+static struct smc91x_platdata zylonite2_smc91x_info = {
+	.flags	= SMC91X_USE_16BIT | SMC91X_NOWAIT,
+};
+
+static struct resource smc91x_resources[] = {
+	[0] = {
+		.start	= SMC_CS1_PHYS_BASE + 0x300,
+		.end	= SMC_CS1_PHYS_BASE + 0xfffff,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= gpio_to_irq(27),
+		.end	= gpio_to_irq(27),
+		.flags	= IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHEDGE,
+	}
+};
+
+static struct platform_device smc91x_device = {
+	.name		= "smc91x",
+	.id		= 0,
+	.dev		= {
+		.platform_data = &zylonite2_smc91x_info,
+	},
+	.num_resources	= ARRAY_SIZE(smc91x_resources),
+	.resource	= smc91x_resources,
+};
+
 static void __init zylonite2_init(void)
 {
 	mfp_config(ARRAY_AND_SIZE(zylonite2_pin_config));
 
+	/* on-chip devices */
 	pxa168_add_uart1();
+
+	/* off-chip devices */
+	platform_device_register(&smc91x_device);
 }
 
 MACHINE_START(ZYLONITE2, "PXA168-based Zylonite2 Development Platform")
diff --git a/drivers/net/smc91x.h b/drivers/net/smc91x.h
index 4d689b5..1083e2c 100644
--- a/drivers/net/smc91x.h
+++ b/drivers/net/smc91x.h
@@ -44,6 +44,7 @@
     defined(CONFIG_MACH_MAINSTONE) ||\
     defined(CONFIG_MACH_ZYLONITE) ||\
     defined(CONFIG_MACH_LITTLETON) ||\
+    defined(CONFIG_MACH_ZYLONITE2) ||\
     defined(CONFIG_ARCH_VIPER)
 
 #include <asm/mach-types.h>
-- 
1.6.0.4


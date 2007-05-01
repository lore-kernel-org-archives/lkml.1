Return-Path: <linux-kernel-owner+w=401wt.eu-S1946504AbXEAFLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946504AbXEAFLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 01:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946595AbXEAFLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 01:11:03 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:63522 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946593AbXEAFK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 01:10:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:mime-version:content-type:content-transfer-encoding;
        b=TDUlYKz0NZHlEWoj82nzfcCj8GKNA8M7gNGPa0CH85PgX54ZKvZSLoGBUsFs7jvBC3hnOFmPrIT71yZkG0+Uue6UMQNe7ipPvVmLmp3MuwR8K8vUZDqueiHEGhTI70FMXDeyYU0vdlNvOydspvxtPxP/QqXC2lnrQFaB/Wwg04w=
Date: Tue, 1 May 2007 08:10:54 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <8710007822.20070501081054@gmail.com>
To: linux-kernel@vger.kernel.org
CC: Ben Dooks <ben-linux-arm@fluff.org>
Subject: [RFC, PATCH 4/4] SoC base drivers: ASIC3 support for iPaq rx3715
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello linux-kernel,

mach-rx3715: Add support for builtin ASIC3 chip, based on the 
asic3_base driver.


 arch/arm/mach-s3c2440/mach-rx3715.c         |   84 +++++++++++++++++++++++++++
 include/asm-arm/arch-s3c2410/rx3000-asic3.h |   63 ++++++++++++++++++++
 include/asm-arm/arch-s3c2410/rx3000.h       |   19 ++++++
 3 files changed, 166 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c2440/mach-rx3715.c b/arch/arm/mach-s3c2440/mach-rx3715.c
index ae1d0a8..0c7285f 100644
--- a/arch/arm/mach-s3c2440/mach-rx3715.c
+++ b/arch/arm/mach-s3c2440/mach-rx3715.c
@@ -2,6 +2,7 @@
  *
  * Copyright (c) 2003,2004 Simtec Electronics
  *	Ben Dooks <ben@simtec.co.uk>
+ * Copyright 2006 Roman Moravcik <roman.moravcik@gmail.com>
  *
  * http://www.handhelds.org/projects/rx3715.html
  *
@@ -50,6 +51,11 @@
 #include <asm/plat-s3c24xx/cpu.h>
 #include <asm/plat-s3c24xx/pm.h>
 
+#include <linux/soc/asic3_base.h>
+#include <asm/hardware/ipaq-asic3.h>
+#include <asm/arch/rx3000.h>
+#include <asm/arch/rx3000-asic3.h>
+
 static struct map_desc rx3715_iodesc[] __initdata = {
 	/* dump ISA space somewhere unused */
 
@@ -107,6 +113,84 @@ static struct s3c2410_uartcfg rx3715_uartcfgs[] = {
 	}
 };
 
+/* ASIC3 SoC data */
+static struct asic3_platform_data rx3715_asic3_cfg = {
+	.gpio_a = {
+		.dir            = 0xffff,
+		.init           = 0x0028,
+		.sleep_mask     = 0xffff,
+		.sleep_out      = 0x0030,
+		.batt_fault_out = 0x0030,
+		.alt_function   = 0x0000,
+		.sleep_conf     = 0x0008,
+	},
+	.gpio_b = {
+		.dir            = 0xffff,
+		.init           = 0x1a02,
+		.sleep_mask     = 0xffff,
+		.sleep_out      = 0x0402,
+		.batt_fault_out = 0x0402,
+		.alt_function   = 0x0000,
+		.sleep_conf     = 0x0008,
+	},
+	.gpio_c = {
+		.dir            = 0xffff,
+		.init           = 0x0600,
+		.sleep_mask     = 0xffff,
+		.sleep_out      = 0x0000,
+		.batt_fault_out = 0x0000,
+		.alt_function   = 0x0007,
+		.sleep_conf     = 0x0008,
+	},
+	.gpio_d = {
+		.dir            = 0xfff0,
+		.init           = 0x0040,
+		.sleep_mask     = 0xfff0,
+		.sleep_out      = 0x0000,
+		.batt_fault_out = 0x0000,
+		.alt_function   = 0x0000,
+		.sleep_conf     = 0x0008,
+	},
+	.irq_base = RX3000_ASIC3_IRQ_BASE,
+
+	/*.child_platform_devs = child_devices,
+	.num_child_platform_devs = ARRAY_SIZE(child_devices),*/
+};
+
+static struct resource s3c_asic3_resources[] = {
+	[0] = {
+		.start  = 0x08000000,
+		.end    = 0x08000000 + IPAQ_ASIC3_MAP_SIZE - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = IRQ_EINT12,
+		.end    = IRQ_EINT12,
+		.flags  = IORESOURCE_IRQ,
+	},
+	/* SD part */
+	[2] = {
+		.start	= 0x10000000,
+		.end	= 0x10000000 + IPAQ_ASIC3_MAP_SIZE - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[3] = {
+		.start	= IRQ_EINT14,
+		.end	= IRQ_EINT14,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device s3c_device_asic3 = {
+	.name           = "asic3",
+	.id             = 0,
+	.num_resources  = ARRAY_SIZE(s3c_asic3_resources),
+	.resource       = s3c_asic3_resources,
+	.dev = { .platform_data = &rx3715_asic3_cfg, }
+};
+
+EXPORT_SYMBOL(s3c_device_asic3);
+
 /* framebuffer lcd controller information */
 
 static struct s3c2410fb_mach_info rx3715_lcdcfg __initdata = {
diff --git a/include/asm-arm/arch-s3c2410/rx3000-asic3.h b/include/asm-arm/arch-s3c2410/rx3000-asic3.h
new file mode 100644
index 0000000..5ffbeb4
--- /dev/null
+++ b/include/asm-arm/arch-s3c2410/rx3000-asic3.h
@@ -0,0 +1,63 @@
+/*
+ * linux/include/asm-arm/arch-s3c2410/rx3000-asic3.h
+ *
+ * Written by Roman Moravcik <roman.moravcik@gmail.com>
+ *
+ * Use consistent with the GNU GPL is permitted,
+ * provided that this copyright notice is
+ * preserved in its entirety in all copies and derived works.
+ *
+ */
+
+#ifndef __ASM_ARCH_RX3000_ASIC3_H
+#define __ASM_ARCH_RX3000_ASIC3_H "rx3000-asic3.h"
+
+#include <asm/hardware/ipaq-asic3.h>
+
+/* GPIOA */
+#define ASIC3_GPA0			(1 << 0)  /* charger enable, 0 = disable, 1 = enable */
+#define ASIC3_GPA1			(1 << 1)  /* audio mute, 0 = mute, 1 = unmute */
+#define ASIC3_GPA2			(1 << 2)  /* audio reset, 0 = disable, 1 = enable */
+#define ASIC3_GPA3			(1 << 3)  /* usb d+ pullup, 0 = disable, 1 = enable */
+#define ASIC3_GPA13			(1 << 13) /* charger mode, 0 = slow, 1 = fast */
+#define ASIC3_GPA15			(1 << 15) /* bluetooth clock 32kHz, 0 = disable, 1 = enable */
+
+/* GPIOB */
+#define ASIC3_GPB1			(1 << 1)  /* backup battery charger enable, 0 = enable, 1 = disable */
+#define ASIC3_GPB2			(1 << 2)  /* rs232 level convertor supply, 0 = off, 1 = on */
+#define ASIC3_GPB3			(1 << 3)  /* wlan supply, 0 = off, 1 = on */
+#define ASIC3_GPB10			(1 << 10) 
+#define ASIC3_GPB11			(1 << 11) /* lcd supply, 0 = off, 1 = on */
+#define ASIC3_GPB12			(1 << 12) /* lcd supply, 0 = off, 1 = on */
+
+/* GPIOC */
+#define ASIC3_GPC0			(1 << 0)  /* green led */
+#define ASIC3_GPC1			(1 << 1)  /* red led */
+#define ASIC3_GPC2			(1 << 2)  /* blue led */
+#define ASIC3_GPC4			(1 << 4)  /* camera supply, 0 = off, 1 = on */
+#define ASIC3_GPC5			(1 << 5)  /* camera supply, 0 = off, 1 = on */
+#define ASIC3_GPC7			(1 << 7)  /* audio supply, 0 = off, 1 = on */
+#define ASIC3_GPC9			(1 << 9)  /* lcd supply, 0 = off, 1 = on */
+#define ASIC3_GPC10			(1 << 10) /* lcd supply, 0 = off, 1 = on */
+#define ASIC3_GPC11			(1 << 11) /* wlan supply, 0 = off, 1 = on */
+#define ASIC3_GPC12			(1 << 12) /* bluetooth supply, 0 = off, 1 = on */
+#define ASIC3_GPC13			(1 << 13) /* wlan supply, 0 = off, 1 = on */
+
+/* GPIOD */
+#define ASIC3_GPD0      		(1 << 0)  /* right button */
+#define ASIC3_GPD1       		(1 << 1)  /* down button */
+#define ASIC3_GPD2	        	(1 << 2)  /* left button */
+#define ASIC3_GPD3		        (1 << 3)  /* up button */
+
+/* ASIC3 IRQs */
+#define IRQ_ASIC3_EINT0 	        (ASIC3_GPIOD_IRQ_BASE + 0) /* right button */
+#define IRQ_ASIC3_EINT1 		(ASIC3_GPIOD_IRQ_BASE + 1) /* down button */
+#define IRQ_ASIC3_EINT2			(ASIC3_GPIOD_IRQ_BASE + 2) /* left button */
+#define IRQ_ASIC3_EINT3			(ASIC3_GPIOD_IRQ_BASE + 3) /* up button */
+
+/* ASIC3 LEDS */
+#define ASIC3_LED0       		(0) /* green led */
+#define ASIC3_LED1	                (1) /* red led */
+#define ASIC3_LED2              	(2) /* blue led */
+
+#endif  // __ASM_ARCH_RX3000_ASIC3_H
diff --git a/include/asm-arm/arch-s3c2410/rx3000.h b/include/asm-arm/arch-s3c2410/rx3000.h
new file mode 100644
index 0000000..faa32ea
--- /dev/null
+++ b/include/asm-arm/arch-s3c2410/rx3000.h
@@ -0,0 +1,19 @@
+/*
+ * linux/include/asm-arm/arch-s3c2410/rx3000.h
+ *
+ * Written by Roman Moravcik <roman.moravcik@gmail.com>
+ *
+ * Use consistent with the GNU GPL is permitted,
+ * provided that this copyright notice is
+ * preserved in its entirety in all copies and derived works.
+ *
+ */
+
+#ifndef __ASM_ARCH_RX3000_H
+#define __ASM_ARCH_RX3000_H
+
+#include <asm/arch/irqs.h>
+
+#define RX3000_ASIC3_IRQ_BASE (IRQ_S3C2440_AC97 + 1)
+
+#endif  // __ASM_ARCH_RX3000_H


-- 
Best regards,
 Paul                          mailto:pmiscml@gmail.com


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbZEFIMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbZEFIMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbZEFIMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:12:14 -0400
Received: from araneidae.co.uk ([62.3.233.233]:3700 "EHLO araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbZEFIMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:12:08 -0400
X-Greylist: delayed 2524 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 May 2009 04:12:07 EDT
Date: Wed, 6 May 2009 08:33:29 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.29.2] XCEP PXA255 Processor Board
Message-ID: <Pine.LNX.4.64.0905060832110.24668@venus.araneidae.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XCEP PXA255 Processor Board (new architecture)

Adds support for the XCEP processor from IskraTel.  This is a small
single board computer with an ARM XScale PXA255 processor, 32M flash,
64M RAM and an SMSC LAN91C111 network device.

This board is used in a series of electron beam position monitors used
in synchrotron light sources world wide.

Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
---
 arch/arm/mach-pxa/Kconfig  |    6 ++
 arch/arm/mach-pxa/Makefile |    1 +
 arch/arm/mach-pxa/xcep.c   |  203 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/smc91x.h       |    5 +
 4 files changed, 215 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-pxa/xcep.c

diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index 8eea730..738cc98 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -395,6 +395,12 @@ config MACH_EZX_E2
 	default y
 	depends on PXA_EZX
 
+config MACH_XCEP
+	bool "Iskratel Electronics XCEP"
+	select PXA25x
+	select MTD_PHYSMAP
+	select PXA_SSP
+
 endmenu
 
 config PXA25x
diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index 7b28bb5..d9890a7 100644
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -71,6 +71,7 @@ obj-$(CONFIG_MACH_CM_X300)      += cm-x300.o
 obj-$(CONFIG_PXA_EZX)           += ezx.o
 
 obj-$(CONFIG_MACH_INTELMOTE2)   += imote2.o
+obj-$(CONFIG_MACH_XCEP)         += xcep.o
 
 # Support for blinky lights
 led-y := leds.o
diff --git a/arch/arm/mach-pxa/xcep.c b/arch/arm/mach-pxa/xcep.c
new file mode 100644
index 0000000..7a02416
--- /dev/null
+++ b/arch/arm/mach-pxa/xcep.c
@@ -0,0 +1,203 @@
+/*
+ *  linux/arch/arm/mach-pxa/xcep.c
+ *
+ *  Support for the Iskratel Electronics XCEP platform.
+ *
+ *  Author:     Ales Bardorfer <ales@i-tech.si>
+ *  Updates by: Matej Kenda <matej.kenda@hermes-softlab.com>
+ *  Created:    June 2006
+ *  Copyright:  (C) 2006 Instrumentation Technologies
+ *
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/sysdev.h>
+#include <linux/major.h>
+#include <linux/fb.h>
+#include <linux/interrupt.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/physmap.h>
+#include <linux/i2c.h>
+
+#include <asm/setup.h>
+#include <asm/memory.h>
+#include <asm/mach-types.h>
+#include <mach/hardware.h>
+#include <asm/irq.h>
+#include <asm/sizes.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+#include <asm/mach/flash.h>
+
+#include <mach/pxa-regs.h>
+#include <mach/pxa2xx-regs.h>
+#include <mach/pxa2xx-gpio.h>
+#include <mach/udc.h>
+#include <mach/irda.h>
+#include <mach/pxafb.h>
+#include <mach/mmc.h>
+#include <mach/i2c.h>
+
+#include "generic.h"
+
+
+#define XCEP_ETH_PHYS	0x0c000300
+#define XCEP_ETH_END    0x0c0fffff
+#define XCEP_ETH_IRQ	0
+
+/*  XCEP CPLD base */
+#define XCEP_CPLD_BASE  0xf0000000
+
+
+
+static struct mtd_partition xcep_partitions[] = {
+	{
+		.name =		"Bootloader",
+		.size =		0x00040000,
+		.offset =	0,
+		.mask_flags =	MTD_WRITEABLE  /* force read-only */
+	}, {
+		.name =		"Bootloader ENV",
+		.size =		0x00040000,
+		.offset =	0x00040000,
+		.mask_flags =	MTD_WRITEABLE  /* force read-only */
+	}, {
+		.name =		"Kernel",
+		.size =		0x00100000,
+		.offset =	0x00080000,
+	}, {
+		.name =		"Rescue fs",
+		.size =		0x00280000,
+		.offset =	0x00180000,
+	}, {
+		.name =		"Filesystem",
+		.size =		MTDPART_SIZ_FULL,
+		.offset =	0x00400000
+	}
+};
+
+static struct physmap_flash_data xcep_flash_data[] = {
+	{
+		.width		= 4,		/* bankwidth in bytes */
+		.parts		= xcep_partitions,
+		.nr_parts	= ARRAY_SIZE(xcep_partitions)
+	}
+};
+
+static struct resource flash_resource = {
+	.start	= PXA_CS0_PHYS,
+	.end	= PXA_CS0_PHYS + SZ_32M - 1,
+	.flags	= IORESOURCE_MEM,
+};
+
+static struct platform_device flash_device = {
+	.name	= "physmap-flash",
+	.id	= 0,
+	.dev 	= {
+		.platform_data = xcep_flash_data,
+	},
+	.resource = &flash_resource,
+	.num_resources = 1,
+};
+
+
+
+static struct resource smc91x_resources[] = {
+	[0] = {
+		.name	= "smc91x-regs",
+		.start	= XCEP_ETH_PHYS,
+		.end	= XCEP_ETH_END,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= IRQ_GPIO(XCEP_ETH_IRQ),
+		.end	= IRQ_GPIO(XCEP_ETH_IRQ),
+		.flags	= IORESOURCE_IRQ,
+	},
+	[2] = {
+		.name	= "smc91x-attrib",
+		.start	= 0x0e000000,
+		.end	= 0x0e0fffff,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device smc91x_device = {
+	.name		= "smc91x",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(smc91x_resources),
+	.resource	= smc91x_resources,
+};
+
+
+static struct map_desc xcep_io_desc[] __initdata = {
+  	{	/* CPLD */
+		.virtual	= XCEP_CPLD_BASE,
+		.pfn		= __phys_to_pfn(0x10000000),
+		.length		= 0x00000100,
+		.type		= MT_DEVICE
+	}
+};
+
+
+static struct platform_device *devices[] __initdata = {
+	&flash_device,
+	&smc91x_device,
+};
+
+/*
+ * We have to state that there are HWMON devices on the I2C bus on XCEP.
+ * Drivers for HWMON verify capabilities of the adapter when loading and
+ * refuse to attach if the adapter doesn't support HWMON class of devices.
+ * See also Documentation/i2c/porting-clients.
+ */
+static struct i2c_pxa_platform_data xcep_i2c_platform_data  = {
+	.class = I2C_CLASS_HWMON
+};
+
+static void __init xcep_init_vlio(void)
+{
+	/* See Intel XScale Developer's Guide for details */
+	/* Set RDF and RDN to appropriate values (chip select 3 (smc91x)) */
+	MSC1 = (MSC1 & 0xffff) | 0xD5540000;
+	/* Set RDF and RDN to appropriate values (chip select 5 (fpga)) */
+	MSC2 = (MSC2 & 0xffff) | 0x72A00000;
+}
+
+static void __init xcep_init(void)
+{
+	xcep_init_vlio();
+
+	platform_add_devices(ARRAY_AND_SIZE(devices));
+	pxa_set_i2c_info(&xcep_i2c_platform_data);
+}
+
+static void __init xcep_map_io(void)
+{
+	pxa_map_io();
+	iotable_init(ARRAY_AND_SIZE(xcep_io_desc));
+
+	/* This is for the SMC chip select */
+	pxa_gpio_mode(GPIO79_nCS_3_MD);
+
+}
+
+MACHINE_START(XCEP, "Iskratel XCEP")
+	.phys_io	= 0x80000000,
+	.io_pg_offst	= 0xf8000000,
+	.boot_params	= 0xa0000100,
+	.init_machine	= xcep_init,
+	.map_io		= xcep_map_io,
+	.init_irq	= pxa25x_init_irq,
+	.timer		= &pxa_timer,
+MACHINE_END
diff --git a/drivers/net/smc91x.h b/drivers/net/smc91x.h
index c4ccd12..2c4a1b2 100644
--- a/drivers/net/smc91x.h
+++ b/drivers/net/smc91x.h
@@ -431,6 +431,11 @@ static inline void LPD7_SMC_outsw (unsigned char* a, int r,
 
 #endif
 
+#if defined(CONFIG_MACH_XCEP)
+#define SMC_USE_PXA_DMA		1
+#endif
+
+
 
 /* store this information for the driver.. */
 struct smc_local {
-- 
1.6.1.3


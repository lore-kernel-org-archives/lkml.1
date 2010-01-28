Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475Ab0A1MzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0A1MzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 07:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806Ab0A1MzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 07:55:15 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:54032 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab0A1MzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 07:55:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=FO3MfiFjzlWqYIbKAwKd9pqjWnzBLE1OIgq5I37Ex62DY+51JOlKFiniAtC4qz6dK6
         KztAAUeHFprs4A3fV8dqnoeRklYtJFxGXZLMi66epyAPWjT8CbQwDPeueg1dUFXERvk2
         D8AtA1ONZJVWrMLLjOMBMDybWdOyd8Fu2ui3s=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux@arm.linux.org.uk
Cc: eric.y.miao@gmail.com, tony@atomide.com, linux-kernel@vger.kernel.org,
       khilman@deeprootsystems.com, lethal@linux-sh.org, ben-linux@fluff.org,
       Magnus Damm <magnus.damm@gmail.com>,
       linux-arm-kernel@lists.infradead.org
Date: Thu, 28 Jan 2010 21:41:01 +0900
Message-Id: <20100128124101.8982.71955.sendpatchset@rxone.opensource.se>
In-Reply-To: <20100128124028.8982.16123.sendpatchset@rxone.opensource.se>
References: <20100128124028.8982.16123.sendpatchset@rxone.opensource.se>
Subject: [PATCH 03/06] ARM: Add sh7372 and AP4EVB support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This patch adds base support for the SuperH Mobile ARM processor
sh7372 together with AP4EVB board support. Only timer, serial
console and NOR flash are supported at this point. Patches for
the interrupt controller, pinmux support, clock framework and
runtime pm will be submitted as feature patches on top of this.

The mach-type entry has been submitted but is included here for now.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Applies on top of linux-next 20100119 and the sh7367+sh7377 patches.

 arch/arm/mach-shmobile/Kconfig               |   14 +
 arch/arm/mach-shmobile/Makefile              |    2 
 arch/arm/mach-shmobile/board-ap4evb.c        |  127 +++++++++++++
 arch/arm/mach-shmobile/include/mach/common.h |    4 
 arch/arm/mach-shmobile/setup-sh7372.c        |  241 ++++++++++++++++++++++++++
 arch/arm/tools/mach-types                    |    1 
 6 files changed, 389 insertions(+)

--- 0003/arch/arm/mach-shmobile/Kconfig
+++ work/arch/arm/mach-shmobile/Kconfig	2010-01-21 19:51:03.000000000 +0900
@@ -18,6 +18,14 @@ config ARCH_SH7377
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 
+config ARCH_SH7372
+	bool "SH-Mobile SH7372 (AP4)"
+	select CPU_V7
+	select HAVE_CLK
+	select COMMON_CLKDEV
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+
 comment "SH-Mobile Board Type"
 
 config MACH_G3EVM
@@ -28,6 +36,10 @@ config MACH_G4EVM
 	bool "G4EVM board"
 	depends on ARCH_SH7377
 
+config MACH_AP4EVB
+	bool "AP4EVB board"
+	depends on ARCH_SH7372
+
 comment "SH-Mobile System Configuration"
 
 menu "Memory configuration"
@@ -36,6 +48,7 @@ config MEMORY_START
 	hex "Physical memory start address"
 	default "0x50000000" if MACH_G3EVM
 	default "0x40000000" if MACH_G4EVM
+	default "0x40000000" if MACH_AP4EVB
 	default "0x00000000"
 	---help---
 	  Tweak this only when porting to a new machine which does not
@@ -46,6 +59,7 @@ config MEMORY_SIZE
 	hex "Physical memory size"
 	default "0x08000000" if MACH_G3EVM
 	default "0x08000000" if MACH_G4EVM
+	default "0x10000000" if MACH_AP4EVB
 	default "0x04000000"
 	help
 	  This sets the default memory size assumed by your kernel. It can
--- 0003/arch/arm/mach-shmobile/Makefile
+++ work/arch/arm/mach-shmobile/Makefile	2010-01-21 19:51:03.000000000 +0900
@@ -8,7 +8,9 @@ obj-y				:= timer.o
 # CPU objects
 obj-$(CONFIG_ARCH_SH7367)	+= setup-sh7367.o clock-sh7367.o
 obj-$(CONFIG_ARCH_SH7377)	+= setup-sh7377.o clock-sh7367.o
+obj-$(CONFIG_ARCH_SH7372)	+= setup-sh7372.o clock-sh7367.o
 
 # Board objects
 obj-$(CONFIG_MACH_G3EVM)	+= board-g3evm.o
 obj-$(CONFIG_MACH_G4EVM)	+= board-g4evm.o
+obj-$(CONFIG_MACH_AP4EVB)	+= board-ap4evb.o
--- /dev/null
+++ work/arch/arm/mach-shmobile/board-ap4evb.c	2010-01-21 19:51:04.000000000 +0900
@@ -0,0 +1,127 @@
+/*
+ * AP4EVB board support
+ *
+ * Copyright (C) 2010  Magnus Damm
+ * Copyright (C) 2008  Yoshihiro Shimoda
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/physmap.h>
+#include <linux/io.h>
+#include <mach/common.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+
+static struct mtd_partition nor_flash_partitions[] = {
+	{
+		.name		= "loader",
+		.offset		= 0x00000000,
+		.size		= 512 * 1024,
+	},
+	{
+		.name		= "bootenv",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= 512 * 1024,
+	},
+	{
+		.name		= "kernel_ro",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= 8 * 1024 * 1024,
+		.mask_flags	= MTD_WRITEABLE,
+	},
+	{
+		.name		= "kernel",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= 8 * 1024 * 1024,
+	},
+	{
+		.name		= "data",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= MTDPART_SIZ_FULL,
+	},
+};
+
+static struct physmap_flash_data nor_flash_data = {
+	.width		= 2,
+	.parts		= nor_flash_partitions,
+	.nr_parts	= ARRAY_SIZE(nor_flash_partitions),
+};
+
+static struct resource nor_flash_resources[] = {
+	[0]	= {
+		.start	= 0x00000000,
+		.end	= 0x08000000 - 1,
+		.flags	= IORESOURCE_MEM,
+	}
+};
+
+static struct platform_device nor_flash_device = {
+	.name		= "physmap-flash",
+	.dev		= {
+		.platform_data	= &nor_flash_data,
+	},
+	.num_resources	= ARRAY_SIZE(nor_flash_resources),
+	.resource	= nor_flash_resources,
+};
+
+
+static struct platform_device *ap4evb_devices[] __initdata = {
+	&nor_flash_device,
+};
+
+static struct map_desc ap4evb_io_desc[] __initdata = {
+	/* create a 1:1 entity map for 0xe6xxxxxx
+	 * used by CPGA, INTC and PFC.
+	 */
+	{
+		.virtual	= 0xe6000000,
+		.pfn		= __phys_to_pfn(0xe6000000),
+		.length		= 256 << 20,
+		.type		= MT_DEVICE_NONSHARED
+	},
+};
+
+static void __init ap4evb_map_io(void)
+{
+	iotable_init(ap4evb_io_desc, ARRAY_SIZE(ap4evb_io_desc));
+
+	/* setup early devices and clocks here as well */
+	sh7372_add_early_devices();
+	sh7367_clock_init(); /* use g3 clocks for now */
+}
+
+static void __init ap4evb_init(void)
+{
+	sh7372_add_standard_devices();
+
+	platform_add_devices(ap4evb_devices, ARRAY_SIZE(ap4evb_devices));
+}
+
+MACHINE_START(AP4EVB, "ap4evb")
+	.phys_io	= 0xe6000000,
+	.io_pg_offst	= ((0xe6000000) >> 18) & 0xfffc,
+	.map_io		= ap4evb_map_io,
+	.init_irq	= sh7372_init_irq,
+	.init_machine	= ap4evb_init,
+	.timer		= &shmobile_timer,
+MACHINE_END
--- 0003/arch/arm/mach-shmobile/include/mach/common.h
+++ work/arch/arm/mach-shmobile/include/mach/common.h	2010-01-21 19:51:03.000000000 +0900
@@ -12,4 +12,8 @@ extern void sh7377_init_irq(void);
 extern void sh7377_add_early_devices(void);
 extern void sh7377_add_standard_devices(void);
 
+extern void sh7372_init_irq(void);
+extern void sh7372_add_early_devices(void);
+extern void sh7372_add_standard_devices(void);
+
 #endif /* __ARCH_MACH_COMMON_H */
--- /dev/null
+++ work/arch/arm/mach-shmobile/setup-sh7372.c	2010-01-21 19:51:04.000000000 +0900
@@ -0,0 +1,241 @@
+/*
+ * sh7372 processor support
+ *
+ * Copyright (C) 2010  Magnus Damm
+ * Copyright (C) 2008  Yoshihiro Shimoda
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/input.h>
+#include <linux/io.h>
+#include <linux/serial_sci.h>
+#include <linux/sh_intc.h>
+#include <linux/sh_timer.h>
+#include <mach/hardware.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+
+static struct plat_sci_port scif0_platform_data = {
+	.mapbase	= 0xe6c40000,
+	.flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP,
+	.type		= PORT_SCIF,
+	.irqs		= { 80, 80, 80, 80 },
+};
+
+static struct platform_device scif0_device = {
+	.name		= "sh-sci",
+	.id		= 0,
+	.dev		= {
+		.platform_data	= &scif0_platform_data,
+	},
+};
+
+static struct plat_sci_port scif1_platform_data = {
+	.mapbase	= 0xe6c50000,
+	.flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP,
+	.type		= PORT_SCIF,
+	.irqs           = { 81, 81, 81, 81 },
+};
+
+static struct platform_device scif1_device = {
+	.name		= "sh-sci",
+	.id		= 1,
+	.dev		= {
+		.platform_data	= &scif1_platform_data,
+	},
+};
+
+static struct plat_sci_port scif2_platform_data = {
+	.mapbase	= 0xe6c60000,
+	.flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP,
+	.type		= PORT_SCIF,
+	.irqs           = { 82, 82, 82, 82 },
+};
+
+static struct platform_device scif2_device = {
+	.name		= "sh-sci",
+	.id		= 2,
+	.dev		= {
+		.platform_data	= &scif2_platform_data,
+	},
+};
+
+static struct plat_sci_port scif3_platform_data = {
+	.mapbase	= 0xe6c70000,
+	.flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP,
+	.type		= PORT_SCIF,
+	.irqs           = { 83, 83, 83, 83 },
+};
+
+static struct platform_device scif3_device = {
+	.name		= "sh-sci",
+	.id		= 3,
+	.dev		= {
+		.platform_data	= &scif3_platform_data,
+	},
+};
+
+static struct plat_sci_port scif4_platform_data = {
+	.mapbase	= 0xe6c80000,
+	.flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP,
+	.type		= PORT_SCIF,
+	.irqs           = { 89, 89, 89, 89 },
+};
+
+static struct platform_device scif4_device = {
+	.name		= "sh-sci",
+	.id		= 4,
+	.dev		= {
+		.platform_data	= &scif4_platform_data,
+	},
+};
+
+static struct plat_sci_port scif5_platform_data = {
+	.mapbase	= 0xe6cb0000,
+	.flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP,
+	.type		= PORT_SCIF,
+	.irqs           = { 90, 90, 90, 90 },
+};
+
+static struct platform_device scif5_device = {
+	.name		= "sh-sci",
+	.id		= 5,
+	.dev		= {
+		.platform_data	= &scif5_platform_data,
+	},
+};
+
+static struct plat_sci_port scif6_platform_data = {
+	.mapbase	= 0xe6c30000,
+	.flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP,
+	.type		= PORT_SCIF,
+	.irqs           = { 91, 91, 91, 91 },
+};
+
+static struct platform_device scif6_device = {
+	.name		= "sh-sci",
+	.id		= 6,
+	.dev		= {
+		.platform_data	= &scif6_platform_data,
+	},
+};
+
+static struct sh_timer_config cmt10_platform_data = {
+	.name = "CMT10",
+	.channel_offset = 0x10,
+	.timer_bit = 0,
+	.clk = "r_clk",
+	.clockevent_rating = 125,
+	.clocksource_rating = 125,
+};
+
+static struct resource cmt10_resources[] = {
+	[0] = {
+		.name	= "CMT10",
+		.start	= 0xe6138010,
+		.end	= 0xe613801b,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= 72,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device cmt10_device = {
+	.name		= "sh_cmt",
+	.id		= 10,
+	.dev = {
+		.platform_data	= &cmt10_platform_data,
+	},
+	.resource	= cmt10_resources,
+	.num_resources	= ARRAY_SIZE(cmt10_resources),
+};
+
+static struct platform_device *sh7372_early_devices[] __initdata = {
+	&scif0_device,
+	&scif1_device,
+	&scif2_device,
+	&scif3_device,
+	&scif4_device,
+	&scif5_device,
+	&scif6_device,
+	&cmt10_device,
+};
+
+void __init sh7372_add_standard_devices(void)
+{
+	platform_add_devices(sh7372_early_devices,
+			    ARRAY_SIZE(sh7372_early_devices));
+}
+
+#define SMSTPCR3 0xe615013c
+#define SMSTPCR3_CMT1 (1 << 29)
+
+void __init sh7372_add_early_devices(void)
+{
+	/* enable clock to CMT1 */
+	__raw_writel(__raw_readl(SMSTPCR3) & ~SMSTPCR3_CMT1, SMSTPCR3);
+
+	early_platform_add_devices(sh7372_early_devices,
+				   ARRAY_SIZE(sh7372_early_devices));
+}
+
+enum {
+	UNUSED = 0,
+
+	/* interrupt sources INTCA */
+
+	SCIFA0, SCIFA1, SCIFA2, SCIFA3, SCIFA4, SCIFA5, SCIFB,
+	CMT10,
+};
+
+static struct intc_vect vectors[] = {
+	INTC_VECT(CMT10, 0xb00),
+	INTC_VECT(SCIFA0, 0xc00), INTC_VECT(SCIFA1, 0xc20),
+	INTC_VECT(SCIFA2, 0xc40), INTC_VECT(SCIFA3, 0xc60),
+	INTC_VECT(SCIFA4, 0xd20), INTC_VECT(SCIFA5, 0xd40),
+	INTC_VECT(SCIFB, 0xd60),
+};
+
+static struct intc_mask_reg mask_registers[] = {
+	{ 0xe6940094, 0xe69400d4, 8, /* IMR5A / IMCR5A */
+	  { 0, 0, 0, 0, SCIFA3, SCIFA2, SCIFA1, SCIFA0 } },
+	{ 0xe6940098, 0xe69400d8, 8, /* IMR6A / IMCR6A */
+	  { SCIFB, SCIFA5, SCIFA4, 0, 0, 0, 0, 0 } },
+	{ 0xe69400a4, 0xe69400e4, 8, /* IMR9A / IMCR9A */
+	  { 0, 0, 0, CMT10, 0, 0, 0, 0 } },
+};
+
+static struct intc_prio_reg prio_registers[] = {
+	{ 0xe6940014, 0, 16, 4, /* IPRFA */ { 0, 0, 0, CMT10 } },
+	{ 0xe6940018, 0, 16, 4, /* IPRGA */ { SCIFA0, SCIFA1,
+					      SCIFA2, SCIFA3 } },
+	{ 0xe6940020, 0, 16, 4, /* IPRIA */ { 0, SCIFA4, 0, 0 } },
+	{ 0xe6940034, 0, 16, 4, /* IPRNA */ { SCIFB, SCIFA5, 0, 0 } },
+};
+
+static DECLARE_INTC_DESC(intc_desc, "sh7372", vectors, NULL, mask_registers,
+			 prio_registers, NULL);
+
+void __init sh7372_init_irq(void)
+{
+	register_intc_controller(&intc_desc);
+}
--- 0001/arch/arm/tools/mach-types
+++ work/arch/arm/tools/mach-types	2010-01-21 19:51:03.000000000 +0900
@@ -2578,3 +2578,4 @@ glacier			MACH_GLACIER		GLACIER			2592
 phrazer_bulldog		MACH_PHRAZER_BULLDOG	PHRAZER_BULLDOG		2593
 omap3_bulldog		MACH_OMAP3_BULLDOG	OMAP3_BULLDOG		2594
 pca101			MACH_PCA101		PCA101			2595
+ap4evb			MACH_AP4EVB		AP4EVB			2630

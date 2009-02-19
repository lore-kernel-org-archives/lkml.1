Return-Path: <linux-kernel-owner+w=401wt.eu-S1758508AbZBSNso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508AbZBSNso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbZBSNr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:47:29 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:50970 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbZBSNrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:47:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=JW5VGhNJpT67BCr87vbxcVzcixboIGaX2Y55faE5pUkF/8U+5mFtnZPC+rO9lN2ljh
         H1CfJ0YqQYMRNXRC341+rlfmSXPFyo+61dKD9i78uFW8rzNLxCE5tKicsg4PXTe1U3pw
         mqqV78Q/p7eK7TkhXjb+ecvKunYU3mseBHzMI=
From: Eric Miao <eric.y.miao@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Eric Miao <eric.miao@marvell.com>, Jason Chagas <chagas@marvell.com>
Subject: [PATCH] [ARM] pxa: add base support for Marvell's PXA168 processor line
Date: Thu, 19 Feb 2009 21:45:53 +0800
Message-Id: <1235051161-8858-5-git-send-email-eric.y.miao@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1235051161-8858-4-git-send-email-eric.y.miao@gmail.com>
References: <1235051161-8858-1-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-2-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-3-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-4-git-send-email-eric.y.miao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Miao <eric.miao@marvell.com>

"""The Marvell® PXA168 processor is the first in a family of application
processors targeted at mass market opportunities in computing and consumer
devices. It balances high computing and multimedia performance with low
power consumption to support extended battery life, and includes a wealth
of integrated peripherals to reduce overall BOM cost .... """

See http://www.marvell.com/featured/pxa168.jsp for more information.

  1. Marvell Mohawk core is a hybrid of xscale3 and its own ARM core,
     there are many enhancements like instructions for flushing the
     whole D-cache, and so on

  2. Clock reuses Russell's common clkdev, and added the basic support
     for UART1/2.

  3. Devices are a bit different from the 'mach-pxa' way, the platform
     devices are now dynamically allocated only when necessary (i.e.
     when pxa_register_device() is called). Description for each device
     are stored in an array of 'struct pxa_device_desc'. Now that:

     a. this array of device description is marked with __initdata and
        can be freed up system is fully up

     b. which means board code has to add all needed devices early in
        his initializing function

     c. platform specific data can now be marked as __initdata since
        they are allocated and copied by platform_device_add_data()

  4. only the basic UART1/2/3 are added, more devices will come later.

Signed-off-by: Jason Chagas <chagas@marvell.com>
Signed-off-by: Eric Miao <eric.miao@marvell.com>
---
 arch/arm/Kconfig                             |   16 +
 arch/arm/Makefile                            |    1 +
 arch/arm/boot/compressed/head.S              |   12 +
 arch/arm/include/asm/cacheflush.h            |    8 +
 arch/arm/include/asm/proc-fns.h              |    8 +
 arch/arm/mach-mmp/Kconfig                    |   20 ++
 arch/arm/mach-mmp/Makefile                   |   11 +
 arch/arm/mach-mmp/Makefile.boot              |    1 +
 arch/arm/mach-mmp/clock.c                    |   83 +++++
 arch/arm/mach-mmp/clock.h                    |   71 +++++
 arch/arm/mach-mmp/common.c                   |   37 +++
 arch/arm/mach-mmp/common.h                   |    9 +
 arch/arm/mach-mmp/devices.c                  |   72 +++++
 arch/arm/mach-mmp/include/mach/addr-map.h    |   34 ++
 arch/arm/mach-mmp/include/mach/clkdev.h      |    7 +
 arch/arm/mach-mmp/include/mach/cputype.h     |   35 +++
 arch/arm/mach-mmp/include/mach/debug-macro.S |   23 ++
 arch/arm/mach-mmp/include/mach/devices.h     |   31 ++
 arch/arm/mach-mmp/include/mach/dma.h         |   13 +
 arch/arm/mach-mmp/include/mach/entry-macro.S |   25 ++
 arch/arm/mach-mmp/include/mach/hardware.h    |    4 +
 arch/arm/mach-mmp/include/mach/io.h          |   21 ++
 arch/arm/mach-mmp/include/mach/irqs.h        |   59 ++++
 arch/arm/mach-mmp/include/mach/memory.h      |   14 +
 arch/arm/mach-mmp/include/mach/pxa168.h      |   20 ++
 arch/arm/mach-mmp/include/mach/regs-apbc.h   |   53 ++++
 arch/arm/mach-mmp/include/mach/regs-apmu.h   |   36 +++
 arch/arm/mach-mmp/include/mach/regs-icu.h    |   31 ++
 arch/arm/mach-mmp/include/mach/regs-timers.h |   44 +++
 arch/arm/mach-mmp/include/mach/system.h      |   21 ++
 arch/arm/mach-mmp/include/mach/timex.h       |    9 +
 arch/arm/mach-mmp/include/mach/uncompress.h  |   41 +++
 arch/arm/mach-mmp/include/mach/vmalloc.h     |    5 +
 arch/arm/mach-mmp/irq.c                      |   58 ++++
 arch/arm/mach-mmp/pxa168.c                   |   54 ++++
 arch/arm/mach-mmp/time.c                     |  212 +++++++++++++
 arch/arm/mach-mmp/zylonite2.c                |   31 ++
 arch/arm/mm/Kconfig                          |   15 +-
 arch/arm/mm/Makefile                         |    1 +
 arch/arm/mm/proc-mohawk.S                    |  421 ++++++++++++++++++++++++++
 40 files changed, 1665 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/mach-mmp/Kconfig
 create mode 100644 arch/arm/mach-mmp/Makefile
 create mode 100644 arch/arm/mach-mmp/Makefile.boot
 create mode 100644 arch/arm/mach-mmp/clock.c
 create mode 100644 arch/arm/mach-mmp/clock.h
 create mode 100644 arch/arm/mach-mmp/common.c
 create mode 100644 arch/arm/mach-mmp/common.h
 create mode 100644 arch/arm/mach-mmp/devices.c
 create mode 100644 arch/arm/mach-mmp/include/mach/addr-map.h
 create mode 100644 arch/arm/mach-mmp/include/mach/clkdev.h
 create mode 100644 arch/arm/mach-mmp/include/mach/cputype.h
 create mode 100644 arch/arm/mach-mmp/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-mmp/include/mach/devices.h
 create mode 100644 arch/arm/mach-mmp/include/mach/dma.h
 create mode 100644 arch/arm/mach-mmp/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-mmp/include/mach/hardware.h
 create mode 100644 arch/arm/mach-mmp/include/mach/io.h
 create mode 100644 arch/arm/mach-mmp/include/mach/irqs.h
 create mode 100644 arch/arm/mach-mmp/include/mach/memory.h
 create mode 100644 arch/arm/mach-mmp/include/mach/pxa168.h
 create mode 100644 arch/arm/mach-mmp/include/mach/regs-apbc.h
 create mode 100644 arch/arm/mach-mmp/include/mach/regs-apmu.h
 create mode 100644 arch/arm/mach-mmp/include/mach/regs-icu.h
 create mode 100644 arch/arm/mach-mmp/include/mach/regs-timers.h
 create mode 100644 arch/arm/mach-mmp/include/mach/system.h
 create mode 100644 arch/arm/mach-mmp/include/mach/timex.h
 create mode 100644 arch/arm/mach-mmp/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-mmp/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-mmp/irq.c
 create mode 100644 arch/arm/mach-mmp/pxa168.c
 create mode 100644 arch/arm/mach-mmp/time.c
 create mode 100644 arch/arm/mach-mmp/zylonite2.c
 create mode 100644 arch/arm/mm/proc-mohawk.S

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a268734..7eaf910 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -478,6 +478,8 @@ config ARCH_PXA
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ARCH_REQUIRE_GPIOLIB
+	select HAVE_CLK
+	select COMMON_CLKDEV
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
@@ -485,6 +487,18 @@ config ARCH_PXA
 	help
 	  Support for Intel/Marvell's PXA2xx/PXA3xx processor line.
 
+config ARCH_MMP
+	bool "Marvell PXA168"
+	depends on MMU
+	select HAVE_CLK
+	select COMMON_CLKDEV
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	select TICK_ONESHOT
+	select PLAT_PXA
+	help
+	  Support for Marvell's PXA168 processor line.
+
 config ARCH_RPC
 	bool "RiscPC"
 	select ARCH_ACORN
@@ -621,6 +635,8 @@ source "arch/arm/mach-mv78xx0/Kconfig"
 source "arch/arm/mach-pxa/Kconfig"
 source "arch/arm/plat-pxa/Kconfig"
 
+source "arch/arm/mach-mmp/Kconfig"
+
 source "arch/arm/mach-sa1100/Kconfig"
 
 source "arch/arm/plat-omap/Kconfig"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 5f578a2..070154d 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -105,6 +105,7 @@ ifeq ($(CONFIG_ARCH_SA1100),y)
  textofs-$(CONFIG_SA1111)	   := 0x00208000
 endif
  machine-$(CONFIG_ARCH_PXA)	   := pxa
+ machine-$(CONFIG_ARCH_MMP)	   := mmp
     plat-$(CONFIG_PLAT_PXA)	   := pxa
  machine-$(CONFIG_ARCH_L7200)	   := l7200
  machine-$(CONFIG_ARCH_INTEGRATOR) := integrator
diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 77d6142..4629dc8 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -630,6 +630,18 @@ proc_types:
 		b	__armv4_mmu_cache_off
 		b	__armv4_mmu_cache_flush
 
+		.word 0x56158000
+		.word 0xff0ff000
+		b __armv4_mmu_cache_on
+		b __armv4_mmu_cache_off
+		b __armv5tej_mmu_cache_flush
+
+		.word	0x56056930
+		.word	0xff0ffff0		@ PXA935
+		b	__armv4_mmu_cache_on
+		b	__armv4_mmu_cache_off
+		b	__armv4_mmu_cache_flush
+
 		.word	0x56050000		@ Feroceon
 		.word	0xff0f0000
 		b	__armv4_mmu_cache_on
diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index 6cbd8fd..bfb0cb9 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -94,6 +94,14 @@
 # endif
 #endif
 
+#if defined(CONFIG_CPU_MOHAWK)
+# ifdef _CACHE
+#  define MULTI_CACHE 1
+# else
+#  define _CACHE mohawk
+# endif
+#endif
+
 #if defined(CONFIG_CPU_FEROCEON)
 # define MULTI_CACHE 1
 #endif
diff --git a/arch/arm/include/asm/proc-fns.h b/arch/arm/include/asm/proc-fns.h
index db80203..c625031 100644
--- a/arch/arm/include/asm/proc-fns.h
+++ b/arch/arm/include/asm/proc-fns.h
@@ -185,6 +185,14 @@
 #   define CPU_NAME cpu_xsc3
 #  endif
 # endif
+# ifdef CONFIG_CPU_MOHAWK
+#  ifdef CPU_NAME
+#   undef  MULTI_CPU
+#   define MULTI_CPU
+#  else
+#   define CPU_NAME cpu_mohawk
+#  endif
+# endif
 # ifdef CONFIG_CPU_FEROCEON
 #  ifdef CPU_NAME
 #   undef  MULTI_CPU
diff --git a/arch/arm/mach-mmp/Kconfig b/arch/arm/mach-mmp/Kconfig
new file mode 100644
index 0000000..9510534
--- /dev/null
+++ b/arch/arm/mach-mmp/Kconfig
@@ -0,0 +1,20 @@
+if ARCH_MMP
+
+menu "Marvell PXA168 Implmentations"
+
+config MACH_ZYLONITE2
+	bool "Marvell's PXA168 Zylonite2 Development Board"
+	select CPU_PXA168
+	help
+	  Say 'Y' here if you want to support the Marvell PXA168-based
+	  Zylonite2 Development Board.
+
+endmenu
+
+config CPU_PXA168
+	bool
+	select CPU_MOHAWK
+	help
+	  Select code specific to PXA168
+
+endif
diff --git a/arch/arm/mach-mmp/Makefile b/arch/arm/mach-mmp/Makefile
new file mode 100644
index 0000000..d5bf7dd
--- /dev/null
+++ b/arch/arm/mach-mmp/Makefile
@@ -0,0 +1,11 @@
+#
+# Makefile for Marvell's PXA168 processors line
+#
+
+obj-y				+= common.o clock.o devices.o irq.o time.o
+
+# SoC support
+obj-$(CONFIG_CPU_PXA168)	+= pxa168.o
+
+# board support
+obj-$(CONFIG_MACH_ZYLONITE2)	+= zylonite2.o
diff --git a/arch/arm/mach-mmp/Makefile.boot b/arch/arm/mach-mmp/Makefile.boot
new file mode 100644
index 0000000..574a4aa
--- /dev/null
+++ b/arch/arm/mach-mmp/Makefile.boot
@@ -0,0 +1 @@
+   zreladdr-y	:= 0x00008000
diff --git a/arch/arm/mach-mmp/clock.c b/arch/arm/mach-mmp/clock.c
new file mode 100644
index 0000000..2d9cc5a
--- /dev/null
+++ b/arch/arm/mach-mmp/clock.c
@@ -0,0 +1,83 @@
+/*
+ *  linux/arch/arm/mach-mmp/clock.c
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+
+#include <mach/regs-apbc.h>
+#include "clock.h"
+
+static void apbc_clk_enable(struct clk *clk)
+{
+	uint32_t clk_rst;
+
+	clk_rst = APBC_APBCLK | APBC_FNCLK | APBC_FNCLKSEL(clk->fnclksel);
+	__raw_writel(clk_rst, clk->clk_rst);
+}
+
+static void apbc_clk_disable(struct clk *clk)
+{
+	__raw_writel(0, clk->clk_rst);
+}
+
+struct clkops apbc_clk_ops = {
+	.enable		= apbc_clk_enable,
+	.disable	= apbc_clk_disable,
+};
+
+static DEFINE_SPINLOCK(clocks_lock);
+
+int clk_enable(struct clk *clk)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+	if (clk->enabled++ == 0)
+		clk->ops->enable(clk);
+	spin_unlock_irqrestore(&clocks_lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL(clk_enable);
+
+void clk_disable(struct clk *clk)
+{
+	unsigned long flags;
+
+	WARN_ON(clk->enabled == 0);
+
+	spin_lock_irqsave(&clocks_lock, flags);
+	if (--clk->enabled == 0)
+		clk->ops->disable(clk);
+	spin_unlock_irqrestore(&clocks_lock, flags);
+}
+EXPORT_SYMBOL(clk_disable);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	unsigned long rate;
+
+	if (clk->ops->getrate)
+		rate = clk->ops->getrate(clk);
+	else
+		rate = clk->rate;
+
+	return rate;
+}
+EXPORT_SYMBOL(clk_get_rate);
+
+void clks_register(struct clk_lookup *clks, size_t num)
+{
+	int i;
+
+	for (i = 0; i < num; i++)
+		clkdev_add(&clks[i]);
+}
diff --git a/arch/arm/mach-mmp/clock.h b/arch/arm/mach-mmp/clock.h
new file mode 100644
index 0000000..ed967e7
--- /dev/null
+++ b/arch/arm/mach-mmp/clock.h
@@ -0,0 +1,71 @@
+/*
+ *  linux/arch/arm/mach-mmp/clock.h
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <asm/clkdev.h>
+
+struct clkops {
+	void			(*enable)(struct clk *);
+	void			(*disable)(struct clk *);
+	unsigned long		(*getrate)(struct clk *);
+};
+
+struct clk {
+	const struct clkops	*ops;
+
+	void __iomem	*clk_rst;	/* clock reset control register */
+	int		fnclksel;	/* functional clock select (APBC) */
+	uint32_t	enable_val;	/* value for clock enable (APMU) */
+	unsigned long	rate;
+	int		enabled;
+};
+
+extern struct clkops apbc_clk_ops;
+
+#define APBC_CLK(_name, _reg, _fnclksel, _rate)			\
+struct clk clk_##_name = {					\
+		.clk_rst	= (void __iomem *)APBC_##_reg,	\
+		.fnclksel	= _fnclksel,			\
+		.rate		= _rate,			\
+		.ops		= &apbc_clk_ops,		\
+}
+
+#define APBC_CLK_OPS(_name, _reg, _fnclksel, _rate, _ops)	\
+struct clk clk_##_name = {					\
+		.clk_rst	= (void __iomem *)APBC_##_reg,	\
+		.fnclksel	= _fnclksel,			\
+		.rate		= _rate,			\
+		.ops		= _ops,				\
+}
+
+#define APMU_CLK(_name, _reg, _eval, _rate)			\
+struct clk clk_##_name = {					\
+		.clk_rst	= (void __iomem *)APMU_##_reg,	\
+		.enable_val	= _eval,			\
+		.rate		= _rate,			\
+		.ops		= &apmu_clk_ops,		\
+}
+
+#define APMU_CLK_OPS(_name, _reg, _eval, _rate, _ops)		\
+struct clk clk_##_name = {					\
+		.clk_rst	= (void __iomem *)APMU_##_reg,	\
+		.enable_val	= _eval,			\
+		.rate		= _rate,			\
+		.ops		= _ops,				\
+}
+
+#define INIT_CLKREG(_clk, _devname, _conname)			\
+	{							\
+		.clk		= _clk,				\
+		.dev_id		= _devname,			\
+		.con_id		= _conname,			\
+	}
+
+extern struct clk clk_pxa168_gpio;
+extern struct clk clk_pxa168_timers;
+
+extern void clks_register(struct clk_lookup *, size_t);
diff --git a/arch/arm/mach-mmp/common.c b/arch/arm/mach-mmp/common.c
new file mode 100644
index 0000000..e1e66c1
--- /dev/null
+++ b/arch/arm/mach-mmp/common.c
@@ -0,0 +1,37 @@
+/*
+ *  linux/arch/arm/mach-mmp/common.c
+ *
+ *  Code common to PXA168 processor lines
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+
+#include <asm/page.h>
+#include <asm/mach/map.h>
+#include <mach/addr-map.h>
+
+#include "common.h"
+
+static struct map_desc standard_io_desc[] __initdata = {
+	{
+		.pfn		= __phys_to_pfn(APB_PHYS_BASE),
+		.virtual	= APB_VIRT_BASE,
+		.length		= APB_PHYS_SIZE,
+		.type		= MT_DEVICE,
+	}, {
+		.pfn		= __phys_to_pfn(AXI_PHYS_BASE),
+		.virtual	= AXI_VIRT_BASE,
+		.length		= AXI_PHYS_SIZE,
+		.type		= MT_DEVICE,
+	},
+};
+
+void __init pxa_map_io(void)
+{
+	iotable_init(standard_io_desc, ARRAY_SIZE(standard_io_desc));
+}
diff --git a/arch/arm/mach-mmp/common.h b/arch/arm/mach-mmp/common.h
new file mode 100644
index 0000000..a92cb1a
--- /dev/null
+++ b/arch/arm/mach-mmp/common.h
@@ -0,0 +1,9 @@
+#define ARRAY_AND_SIZE(x)	(x), ARRAY_SIZE(x)
+
+struct sys_timer;
+
+extern struct sys_timer pxa168_timer;
+extern void __init pxa168_init_irq(void);
+
+extern void __init icu_init_irq(void);
+extern void __init pxa_map_io(void);
diff --git a/arch/arm/mach-mmp/devices.c b/arch/arm/mach-mmp/devices.c
new file mode 100644
index 0000000..e18d530
--- /dev/null
+++ b/arch/arm/mach-mmp/devices.c
@@ -0,0 +1,72 @@
+/*
+ * linux/arch/arm/mach-mmp/devices.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+
+#include <asm/irq.h>
+#include <mach/devices.h>
+
+int __init pxa_register_device(struct pxa_device_desc *desc,
+				void *data, size_t size)
+{
+	struct platform_device *pdev;
+	struct resource res[2 + MAX_RESOURCE_DMA];
+	int i, ret = 0, nres = 0;
+
+	pdev = platform_device_alloc(desc->drv_name, desc->id);
+	if (pdev == NULL)
+		return -ENOMEM;
+
+	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+
+	memset(res, 0, sizeof(res));
+
+	if (desc->start != -1ul && desc->size > 0) {
+		res[nres].start	= desc->start;
+		res[nres].end	= desc->start + desc->size - 1;
+		res[nres].flags	= IORESOURCE_MEM;
+		nres++;
+	}
+
+	if (desc->irq != NO_IRQ) {
+		res[nres].start	= desc->irq;
+		res[nres].end	= desc->irq;
+		res[nres].flags	= IORESOURCE_IRQ;
+		nres++;
+	}
+
+	for (i = 0; i < MAX_RESOURCE_DMA; i++, nres++) {
+		if (desc->dma[i] == 0)
+			break;
+
+		res[nres].start	= desc->dma[i];
+		res[nres].end	= desc->dma[i];
+		res[nres].flags	= IORESOURCE_DMA;
+	}
+
+	ret = platform_device_add_resources(pdev, res, nres);
+	if (ret) {
+		platform_device_put(pdev);
+		return ret;
+	}
+
+	if (data && size) {
+		ret = platform_device_add_data(pdev, data, size);
+		if (ret) {
+			platform_device_put(pdev);
+			return ret;
+		}
+	}
+
+	return platform_device_add(pdev);
+}
+
+PXA168_DEVICE(uart1, "pxa2xx-uart", 0, UART1, 0xd4017000, 0x30, 21, 22);
+PXA168_DEVICE(uart2, "pxa2xx-uart", 1, UART2, 0xd4018000, 0x30, 23, 24);
diff --git a/arch/arm/mach-mmp/include/mach/addr-map.h b/arch/arm/mach-mmp/include/mach/addr-map.h
new file mode 100644
index 0000000..3254089
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/addr-map.h
@@ -0,0 +1,34 @@
+/*
+ * linux/arch/arm/mach-mmp/include/mach/addr-map.h
+ *
+ *   Common address map definitions
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_MACH_ADDR_MAP_H
+#define __ASM_MACH_ADDR_MAP_H
+
+/* APB - Application Subsystem Peripheral Bus
+ *
+ * NOTE: the DMA controller registers are actually on the AXI fabric #1
+ * slave port to AHB/APB bridge, due to its close relationship to those
+ * peripherals on APB, let's count it into the ABP mapping area.
+ */
+#define APB_PHYS_BASE		0xd4000000
+#define APB_VIRT_BASE		0xfe000000
+#define APB_PHYS_SIZE		0x00200000
+
+#define AXI_PHYS_BASE		0xd4200000
+#define AXI_VIRT_BASE		0xfe200000
+#define AXI_PHYS_SIZE		0x00200000
+
+/* Static Memory Controller - Chip Select 0 and 1 */
+#define SMC_CS0_PHYS_BASE	0x80000000
+#define SMC_CS0_PHYS_SIZE	0x10000000
+#define SMC_CS1_PHYS_BASE	0x90000000
+#define SMC_CS1_PHYS_SIZE	0x10000000
+
+#endif /* __ASM_MACH_ADDR_MAP_H */
diff --git a/arch/arm/mach-mmp/include/mach/clkdev.h b/arch/arm/mach-mmp/include/mach/clkdev.h
new file mode 100644
index 0000000..2fb354e
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/clkdev.h
@@ -0,0 +1,7 @@
+#ifndef __ASM_MACH_CLKDEV_H
+#define __ASM_MACH_CLKDEV_H
+
+#define __clk_get(clk) ({ 1; })
+#define __clk_put(clk) do { } while (0)
+
+#endif /* __ASM_MACH_CLKDEV_H */
diff --git a/arch/arm/mach-mmp/include/mach/cputype.h b/arch/arm/mach-mmp/include/mach/cputype.h
new file mode 100644
index 0000000..f58490c
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/cputype.h
@@ -0,0 +1,35 @@
+#ifndef __ASM_MACH_CPUTYPE_H
+#define __ASM_MACH_CPUTYPE_H
+
+#include <asm/cputype.h>
+
+/*
+ *  CPU   Stepping   OLD_ID       CPU_ID      CHIP_ID
+ *
+ * PXA168    A0    0x41159263   0x56158400   0x00A0A333
+ */
+
+#ifndef CONFIG_CPU_MOHAWK_OLD_ID
+
+#ifdef CONFIG_CPU_PXA168
+#  define __cpu_is_pxa168(id)	\
+	({ unsigned int _id = ((id) >> 8) & 0xff; _id == 0x84; })
+#else
+#  define __cpu_is_pxa168(id)	(0)
+#endif
+
+#else
+
+#ifdef CONFIG_CPU_PXA168
+#  define __cpu_is_pxa168(id)	\
+	({ unsigned int _id = (id) & 0xffff; _id == 0x9263; })
+#else
+#  define __cpu_is_pxa168(id)	(0)
+#endif
+
+#endif /* CONFIG_CPU_MOHAWK_OLD_ID */
+
+#define cpu_is_pxa168()		({ __cpu_is_pxa168(read_cpuid_id()); })
+#define cpu_is_pxa910()		({ __cpu_is_pxa910(read_cpuid_id()); })
+
+#endif /* __ASM_MACH_CPUTYPE_H */
diff --git a/arch/arm/mach-mmp/include/mach/debug-macro.S b/arch/arm/mach-mmp/include/mach/debug-macro.S
new file mode 100644
index 0000000..a850f87
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/debug-macro.S
@@ -0,0 +1,23 @@
+/* arch/arm/mach-mmp/include/mach/debug-macro.S
+ *
+ * Debugging macro include header
+ *
+ *  Copied from arch/arm/mach-pxa/include/mach/debug.S
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <mach/addr-map.h>
+
+		.macro	addruart,rx
+		mrc	p15, 0, \rx, c1, c0
+		tst	\rx, #1				@ MMU enabled?
+		ldreq	\rx, =APB_PHYS_BASE		@ physical
+		ldrne	\rx, =APB_VIRT_BASE		@ virtual
+		orr	\rx, \rx, #0x00017000
+		.endm
+
+#define UART_SHIFT	2
+#include <asm/hardware/debug-8250.S>
diff --git a/arch/arm/mach-mmp/include/mach/devices.h b/arch/arm/mach-mmp/include/mach/devices.h
new file mode 100644
index 0000000..9b1ba00
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/devices.h
@@ -0,0 +1,31 @@
+#include <linux/types.h>
+
+#define MAX_RESOURCE_DMA	2
+
+/* structure for describing the on-chip devices */
+struct pxa_device_desc {
+	const char	*dev_name;
+	const char	*drv_name;
+	int		id;
+	int		irq;
+	unsigned long	start;
+	unsigned long	size;
+	int		dma[MAX_RESOURCE_DMA];
+};
+
+#define PXA168_DEVICE(_name, _drv, _id, _irq, _start, _size, _dma...)	\
+struct pxa_device_desc pxa168_device_##_name __initdata = {		\
+	.dev_name	= "pxa168-" #_name,				\
+	.drv_name	= _drv,						\
+	.id		= _id,						\
+	.irq		= IRQ_PXA168_##_irq,				\
+	.start		= _start,					\
+	.size		= _size,					\
+	.dma		= { _dma },					\
+};
+
+extern struct pxa_device_desc pxa168_device_uart1;
+extern struct pxa_device_desc pxa168_device_uart2;
+extern struct pxa_device_desc pxa168_device_uart3;
+
+extern int pxa_register_device(struct pxa_device_desc *, void *, size_t);
diff --git a/arch/arm/mach-mmp/include/mach/dma.h b/arch/arm/mach-mmp/include/mach/dma.h
new file mode 100644
index 0000000..1d69145
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/dma.h
@@ -0,0 +1,13 @@
+/*
+ * linux/arch/arm/mach-mmp/include/mach/dma.h
+ */
+
+#ifndef __ASM_MACH_DMA_H
+#define __ASM_MACH_DMA_H
+
+#include <mach/addr-map.h>
+
+#define DMAC_REGS_VIRT	(APB_VIRT_BASE + 0x00000)
+
+#include <plat/dma.h>
+#endif /* __ASM_MACH_DMA_H */
diff --git a/arch/arm/mach-mmp/include/mach/entry-macro.S b/arch/arm/mach-mmp/include/mach/entry-macro.S
new file mode 100644
index 0000000..6d3cd35
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/entry-macro.S
@@ -0,0 +1,25 @@
+/*
+ * linux/arch/arm/mach-mmp/include/mach/entry-macro.S
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <mach/regs-icu.h>
+
+	.macro	disable_fiq
+	.endm
+
+	.macro	arch_ret_to_user, tmp1, tmp2
+	.endm
+
+	.macro	get_irqnr_preamble, base, tmp
+	ldr	\base, =ICU_AP_IRQ_SEL_INT_NUM
+	.endm
+
+	.macro	get_irqnr_and_base, irqnr, irqstat, base, tmp
+	ldr	\tmp, [\base, #0]
+	and	\irqnr, \tmp, #0x3f
+	tst	\tmp, #(1 << 6)
+	.endm
diff --git a/arch/arm/mach-mmp/include/mach/hardware.h b/arch/arm/mach-mmp/include/mach/hardware.h
new file mode 100644
index 0000000..99264a5
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/hardware.h
@@ -0,0 +1,4 @@
+#ifndef __ASM_MACH_HARDWARE_H
+#define __ASM_MACH_HARDWARE_H
+
+#endif /* __ASM_MACH_HARDWARE_H */
diff --git a/arch/arm/mach-mmp/include/mach/io.h b/arch/arm/mach-mmp/include/mach/io.h
new file mode 100644
index 0000000..e7adf3d
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/io.h
@@ -0,0 +1,21 @@
+/*
+ * linux/arch/arm/mach-mmp/include/mach/io.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_MACH_IO_H
+#define __ASM_MACH_IO_H
+
+#define IO_SPACE_LIMIT 0xffffffff
+
+/*
+ * We don't actually have real ISA nor PCI buses, but there is so many
+ * drivers out there that might just work if we fake them...
+ */
+#define __io(a)		__typesafe_io(a)
+#define __mem_pci(a)	(a)
+
+#endif /* __ASM_MACH_IO_H */
diff --git a/arch/arm/mach-mmp/include/mach/irqs.h b/arch/arm/mach-mmp/include/mach/irqs.h
new file mode 100644
index 0000000..fe1dc7b
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/irqs.h
@@ -0,0 +1,59 @@
+#ifndef __ASM_MACH_IRQS_H
+#define __ASM_MACH_IRQS_H
+
+/*
+ * Interrupt numbers for PXA168
+ */
+#define IRQ_PXA168_NONE			(-1)
+#define IRQ_PXA168_SSP3			0
+#define IRQ_PXA168_SSP2			1
+#define IRQ_PXA168_SSP1			2
+#define IRQ_PXA168_SSP0			3
+#define IRQ_PXA168_PMIC_INT		4
+#define IRQ_PXA168_RTC_INT		5
+#define IRQ_PXA168_RTC_ALARM		6
+#define IRQ_PXA168_TWSI			7
+#define IRQ_PXA168_GPU			8
+#define IRQ_PXA168_KEYPAD		9
+#define IRQ_PXA168_ONEWIRE		12
+#define IRQ_PXA168_TIMER1		13
+#define IRQ_PXA168_TIMER2		14
+#define IRQ_PXA168_TIMER3		15
+#define IRQ_PXA168_CMU			16
+#define IRQ_PXA168_SSP4			17
+#define IRQ_PXA168_MSP_WAKEUP		19
+#define IRQ_PXA168_CF_WAKEUP		20
+#define IRQ_PXA168_XD_WAKEUP		21
+#define IRQ_PXA168_MFU			22
+#define IRQ_PXA168_MSP			23
+#define IRQ_PXA168_CF			24
+#define IRQ_PXA168_XD			25
+#define IRQ_PXA168_DDR_INT		26
+#define IRQ_PXA168_UART1		27
+#define IRQ_PXA168_UART2		28
+#define IRQ_PXA168_UART3		29
+#define IRQ_PXA168_WDT			35
+#define IRQ_PXA168_FRQ_CHANGE		38
+#define IRQ_PXA168_MMC			39
+#define IRQ_PXA168_MMC2			40
+#define IRQ_PXA168_LCD			41
+#define IRQ_PXA168_CI			42
+#define IRQ_PXA168_USB1			44
+#define IRQ_PXA168_NAND			45
+#define IRQ_PXA168_HIFI_DMA		46
+#define IRQ_PXA168_DMA_INT0		47
+#define IRQ_PXA168_DMA_INT1		48
+#define IRQ_PXA168_GPIOX		49
+#define IRQ_PXA168_USB2			51
+#define IRQ_PXA168_AC97			57
+#define IRQ_PXA168_PWRI2C		58
+#define IRQ_PXA168_PMU			60
+#define IRQ_PXA168_SM_INT		63
+
+#define IRQ_GPIO_START			64
+#define IRQ_GPIO_NUM			128
+#define IRQ_GPIO(x)			(IRQ_GPIO_START + (x))
+
+#define NR_IRQS		(IRQ_GPIO_START + IRQ_GPIO_NUM)
+
+#endif /* __ASM_MACH_IRQS_H */
diff --git a/arch/arm/mach-mmp/include/mach/memory.h b/arch/arm/mach-mmp/include/mach/memory.h
new file mode 100644
index 0000000..bdb21d7
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/memory.h
@@ -0,0 +1,14 @@
+/*
+ * linux/arch/arm/mach-mmp/include/mach/memory.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_MACH_MEMORY_H
+#define __ASM_MACH_MEMORY_H
+
+#define PHYS_OFFSET	UL(0x00000000)
+
+#endif /* __ASM_MACH_MEMORY_H */
diff --git a/arch/arm/mach-mmp/include/mach/pxa168.h b/arch/arm/mach-mmp/include/mach/pxa168.h
new file mode 100644
index 0000000..71424be
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/pxa168.h
@@ -0,0 +1,20 @@
+#ifndef __ASM_MACH_PXA168_H
+#define __ASM_MACH_PXA168_H
+
+#include <mach/devices.h>
+
+static inline int pxa168_add_uart1(void)
+{
+	return pxa_register_device(&pxa168_device_uart1, NULL, 0);
+}
+
+static inline int pxa168_add_uart2(void)
+{
+	return pxa_register_device(&pxa168_device_uart2, NULL, 0);
+}
+
+static inline int pxa168_add_uart3(void)
+{
+	return pxa_register_device(&pxa168_device_uart3, NULL, 0);
+}
+#endif /* __ASM_MACH_PXA168_H */
diff --git a/arch/arm/mach-mmp/include/mach/regs-apbc.h b/arch/arm/mach-mmp/include/mach/regs-apbc.h
new file mode 100644
index 0000000..64c063d
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/regs-apbc.h
@@ -0,0 +1,53 @@
+/*
+ * linux/arch/arm/mach-mmp/include/mach/regs-apbc.h
+ *
+ *   Application Peripheral Bus Clock Unit
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_MACH_REGS_APBC_H
+#define __ASM_MACH_REGS_APBC_H
+
+#include <mach/addr-map.h>
+
+#define APBC_VIRT_BASE	(APB_VIRT_BASE + 0x015000)
+#define APBC_REG(x)	(APBC_VIRT_BASE + (x))
+
+/*
+ * APB clock register offsets for PXA168
+ */
+#define APBC_PXA168_UART1	APBC_REG(0x000)
+#define APBC_PXA168_UART2	APBC_REG(0x004)
+#define APBC_PXA168_GPIO	APBC_REG(0x008)
+#define APBC_PXA168_PWM0	APBC_REG(0x00c)
+#define APBC_PXA168_PWM1	APBC_REG(0x010)
+#define APBC_PXA168_SSP1	APBC_REG(0x01c)
+#define APBC_PXA168_SSP2	APBC_REG(0x020)
+#define APBC_PXA168_RTC		APBC_REG(0x028)
+#define APBC_PXA168_TWSI	APBC_REG(0x02c)
+#define APBC_PXA168_KPC		APBC_REG(0x030)
+#define APBC_PXA168_TIMERS	APBC_REG(0x034)
+#define APBC_PXA168_AIB		APBC_REG(0x03c)
+#define APBC_PXA168_SW_JTAG	APBC_REG(0x040)
+#define APBC_PXA168_ONEWIRE	APBC_REG(0x048)
+#define APBC_PXA168_SSP3	APBC_REG(0x04c)
+#define APBC_PXA168_ASFAR	APBC_REG(0x050)
+#define APBC_PXA168_ASSAR	APBC_REG(0x054)
+#define APBC_PXA168_SSP4	APBC_REG(0x058)
+#define APBC_PXA168_SSP5	APBC_REG(0x05c)
+#define APBC_PXA168_PI2C	APBC_REG(0x06c)
+#define APBC_PXA168_UART3	APBC_REG(0x070)
+#define APBC_PXA168_AC97	APBC_REG(0x084)
+
+/* Common APB clock register bit definitions */
+#define APBC_APBCLK	(1 << 0)  /* APB Bus Clock Enable */
+#define APBC_FNCLK	(1 << 1)  /* Functional Clock Enable */
+#define APBC_RST	(1 << 2)  /* Reset Generation */
+
+/* Functional Clock Selection Mask */
+#define APBC_FNCLKSEL(x)	(((x) & 0xf) << 4)
+
+#endif /* __ASM_MACH_REGS_APBC_H */
diff --git a/arch/arm/mach-mmp/include/mach/regs-apmu.h b/arch/arm/mach-mmp/include/mach/regs-apmu.h
new file mode 100644
index 0000000..9190305
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/regs-apmu.h
@@ -0,0 +1,36 @@
+/*
+ * linux/arch/arm/mach-mmp/include/mach/regs-apmu.h
+ *
+ *   Application Subsystem Power Management Unit
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_MACH_REGS_APMU_H
+#define __ASM_MACH_REGS_APMU_H
+
+#include <mach/addr-map.h>
+
+#define APMU_VIRT_BASE	(AXI_VIRT_BASE + 0x82800)
+#define APMU_REG(x)	(APMU_VIRT_BASE + (x))
+
+/* Clock Reset Control */
+#define APMU_IRE	APMU_REG(0x048)
+#define APMU_LCD	APMU_REG(0x04c)
+#define APMU_CCIC	APMU_REG(0x050)
+#define APMU_SDH0	APMU_REG(0x054)
+#define APMU_SDH1	APMU_REG(0x058)
+#define APMU_USB	APMU_REG(0x05c)
+#define APMU_NAND	APMU_REG(0x060)
+#define APMU_DMA	APMU_REG(0x064)
+#define APMU_GEU	APMU_REG(0x068)
+#define APMU_BUS	APMU_REG(0x06c)
+
+#define APMU_FNCLK_EN	(1 << 4)
+#define APMU_AXICLK_EN	(1 << 3)
+#define APMU_FNRST_DIS	(1 << 1)
+#define APMU_AXIRST_DIS	(1 << 0)
+
+#endif /* __ASM_MACH_REGS_APMU_H */
diff --git a/arch/arm/mach-mmp/include/mach/regs-icu.h b/arch/arm/mach-mmp/include/mach/regs-icu.h
new file mode 100644
index 0000000..e5f0872
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/regs-icu.h
@@ -0,0 +1,31 @@
+/*
+ * linux/arch/arm/mach-mmp/include/mach/regs-icu.h
+ *
+ *   Interrupt Control Unit
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_MACH_ICU_H
+#define __ASM_MACH_ICU_H
+
+#include <mach/addr-map.h>
+
+#define ICU_VIRT_BASE	(AXI_VIRT_BASE + 0x82000)
+#define ICU_REG(x)	(ICU_VIRT_BASE + (x))
+
+#define ICU_INT_CONF(n)		ICU_REG((n) << 2)
+#define ICU_INT_CONF_AP_INT	(1 << 6)
+#define ICU_INT_CONF_CP_INT	(1 << 5)
+#define ICU_INT_CONF_IRQ	(1 << 4)
+#define ICU_INT_CONF_MASK	(0xf)
+
+#define ICU_AP_FIQ_SEL_INT_NUM	ICU_REG(0x108)	/* AP FIQ Selected Interrupt */
+#define ICU_AP_IRQ_SEL_INT_NUM	ICU_REG(0x10C)	/* AP IRQ Selected Interrupt */
+#define ICU_AP_GBL_IRQ_MSK	ICU_REG(0x114)	/* AP Global Interrupt Mask */
+#define ICU_INT_STATUS_0	ICU_REG(0x128)	/* Interrupt Stuats 0 */
+#define ICU_INT_STATUS_1	ICU_REG(0x12C)	/* Interrupt Status 1 */
+
+#endif /* __ASM_MACH_ICU_H */
diff --git a/arch/arm/mach-mmp/include/mach/regs-timers.h b/arch/arm/mach-mmp/include/mach/regs-timers.h
new file mode 100644
index 0000000..45589fe
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/regs-timers.h
@@ -0,0 +1,44 @@
+/*
+ * linux/arch/arm/mach-mmp/include/mach/regs-timers.h
+ *
+ *   Timers Module
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_MACH_REGS_TIMERS_H
+#define __ASM_MACH_REGS_TIMERS_H
+
+#include <mach/addr-map.h>
+
+#define TIMERS1_VIRT_BASE	(APB_VIRT_BASE + 0x14000)
+#define TIMERS2_VIRT_BASE	(APB_VIRT_BASE + 0x16000)
+
+#define TMR_CCR		(0x0000)
+#define TMR_TN_MM(n, m)	(0x0004 + ((n) << 3) + (((n) + (m)) << 2))
+#define TMR_CR(n)	(0x0028 + ((n) << 2))
+#define TMR_SR(n)	(0x0034 + ((n) << 2))
+#define TMR_IER(n)	(0x0040 + ((n) << 2))
+#define TMR_PLVR(n)	(0x004c + ((n) << 2))
+#define TMR_PLCR(n)	(0x0058 + ((n) << 2))
+#define TMR_WMER	(0x0064)
+#define TMR_WMR		(0x0068)
+#define TMR_WVR		(0x006c)
+#define TMR_WSR		(0x0070)
+#define TMR_ICR(n)	(0x0074 + ((n) << 2))
+#define TMR_WICR	(0x0080)
+#define TMR_CER		(0x0084)
+#define TMR_CMR		(0x0088)
+#define TMR_ILR(n)	(0x008c + ((n) << 2))
+#define TMR_WCR		(0x0098)
+#define TMR_WFAR	(0x009c)
+#define TMR_WSAR	(0x00A0)
+#define TMR_CVWR(n)	(0x00A4 + ((n) << 2))
+
+#define TMR_CCR_CS_0(x)	(((x) & 0x3) << 0)
+#define TMR_CCR_CS_1(x)	(((x) & 0x7) << 2)
+#define TMR_CCR_CS_2(x)	(((x) & 0x3) << 5)
+
+#endif /* __ASM_MACH_REGS_TIMERS_H */
diff --git a/arch/arm/mach-mmp/include/mach/system.h b/arch/arm/mach-mmp/include/mach/system.h
new file mode 100644
index 0000000..001edfe
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/system.h
@@ -0,0 +1,21 @@
+/*
+ * linux/arch/arm/mach-mmp/include/mach/system.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_MACH_SYSTEM_H
+#define __ASM_MACH_SYSTEM_H
+
+static inline void arch_idle(void)
+{
+	cpu_do_idle();
+}
+
+static inline void arch_reset(char mode)
+{
+	cpu_reset(0);
+}
+#endif /* __ASM_MACH_SYSTEM_H */
diff --git a/arch/arm/mach-mmp/include/mach/timex.h b/arch/arm/mach-mmp/include/mach/timex.h
new file mode 100644
index 0000000..6cebbd0
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/timex.h
@@ -0,0 +1,9 @@
+/*
+ * linux/arch/arm/mach-mmp/include/mach/timex.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define CLOCK_TICK_RATE		3250000
diff --git a/arch/arm/mach-mmp/include/mach/uncompress.h b/arch/arm/mach-mmp/include/mach/uncompress.h
new file mode 100644
index 0000000..c93d5fa
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/uncompress.h
@@ -0,0 +1,41 @@
+/*
+ * arch/arm/mach-mmp/include/mach/uncompress.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/serial_reg.h>
+#include <mach/addr-map.h>
+
+#define UART1_BASE	(APB_PHYS_BASE + 0x36000)
+#define UART2_BASE	(APB_PHYS_BASE + 0x17000)
+#define UART3_BASE	(APB_PHYS_BASE + 0x18000)
+
+static inline void putc(char c)
+{
+	volatile unsigned long *UART = (unsigned long *)UART2_BASE;
+
+	/* UART enabled? */
+	if (!(UART[UART_IER] & UART_IER_UUE))
+		return;
+
+	while (!(UART[UART_LSR] & UART_LSR_THRE))
+		barrier();
+
+	UART[UART_TX] = c;
+}
+
+/*
+ * This does not append a newline
+ */
+static inline void flush(void)
+{
+}
+
+/*
+ * nothing to do
+ */
+#define arch_decomp_setup()
+#define arch_decomp_wdog()
diff --git a/arch/arm/mach-mmp/include/mach/vmalloc.h b/arch/arm/mach-mmp/include/mach/vmalloc.h
new file mode 100644
index 0000000..b60ccaf
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/vmalloc.h
@@ -0,0 +1,5 @@
+/*
+ * linux/arch/arm/mach-mmp/include/mach/vmalloc.h
+ */
+
+#define VMALLOC_END	0xfe000000
diff --git a/arch/arm/mach-mmp/irq.c b/arch/arm/mach-mmp/irq.c
new file mode 100644
index 0000000..f6b93b1
--- /dev/null
+++ b/arch/arm/mach-mmp/irq.c
@@ -0,0 +1,58 @@
+/*
+ *  linux/arch/arm/mach-mmp/irq.c
+ *
+ *  Generic IRQ handling, GPIO IRQ demultiplexing, etc.
+ *
+ *  Author:	Bin Yang <bin.yang@marvell.com>
+ *  Created:	Sep 30, 2008
+ *  Copyright:	Marvell International Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+
+#include <mach/regs-icu.h>
+
+#include "common.h"
+
+#define PRIORITY_DEFAULT	0x1
+#define PRIORITY_NONE		0x0
+
+static void icu_mask_irq(unsigned int irq)
+{
+	uint32_t conf = __raw_readl(ICU_INT_CONF(irq)) & ~ICU_INT_CONF_MASK;
+
+	__raw_writel(conf | PRIORITY_NONE, ICU_INT_CONF(irq));
+}
+
+static void icu_unmask_irq(unsigned int irq)
+{
+	uint32_t conf = __raw_readl(ICU_INT_CONF(irq)) & ~ICU_INT_CONF_MASK;
+
+	__raw_writel(conf | PRIORITY_DEFAULT, ICU_INT_CONF(irq));
+}
+
+static struct irq_chip icu_irq_chip = {
+	.name	= "icu_irq",
+	.ack	= icu_mask_irq,
+	.mask	= icu_mask_irq,
+	.unmask	= icu_unmask_irq,
+};
+
+void __init icu_init_irq(void)
+{
+	uint32_t conf = ICU_INT_CONF_AP_INT | ICU_INT_CONF_IRQ;
+	int irq;
+
+	for (irq = 0; irq < 64; irq++) {
+		__raw_writel(conf, ICU_INT_CONF(irq));
+		set_irq_chip(irq, &icu_irq_chip);
+		set_irq_handler(irq, handle_level_irq);
+		set_irq_flags(irq, IRQF_VALID);
+	}
+}
diff --git a/arch/arm/mach-mmp/pxa168.c b/arch/arm/mach-mmp/pxa168.c
new file mode 100644
index 0000000..546db19
--- /dev/null
+++ b/arch/arm/mach-mmp/pxa168.c
@@ -0,0 +1,54 @@
+/*
+ *  linux/arch/arm/mach-mmp/pxa168.c
+ *
+ *  Code specific to PXA168
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/list.h>
+
+#include <mach/addr-map.h>
+#include <mach/cputype.h>
+#include <mach/regs-apbc.h>
+#include <mach/irqs.h>
+#include <mach/dma.h>
+
+#include "common.h"
+#include "clock.h"
+
+void __init pxa168_init_irq(void)
+{
+	icu_init_irq();
+}
+
+/* clocks for external use */
+APBC_CLK(pxa168_gpio, PXA168_GPIO, 0, 0);
+APBC_CLK(pxa168_timers, PXA168_TIMERS, 3, 3250000);
+
+/* APB peripheral clocks */
+static APBC_CLK(uart1, PXA168_UART1, 1, 14745600);
+static APBC_CLK(uart2, PXA168_UART2, 1, 14745600);
+static APBC_CLK(uart3, PXA168_UART3, 1, 14745600);
+
+static struct clk_lookup pxa168_clkregs[] = {
+	INIT_CLKREG(&clk_uart1, "pxa2xx-uart.0", NULL),
+	INIT_CLKREG(&clk_uart2, "pxa2xx-uart.1", NULL),
+	INIT_CLKREG(&clk_uart3, "pxa2xx-uart.2", NULL),
+};
+
+static int __init pxa168_init(void)
+{
+	if (cpu_is_pxa168()) {
+		pxa_init_dma(IRQ_PXA168_DMA_INT0, 32);
+		clks_register(ARRAY_AND_SIZE(pxa168_clkregs));
+	}
+
+	return 0;
+}
+postcore_initcall(pxa168_init);
diff --git a/arch/arm/mach-mmp/time.c b/arch/arm/mach-mmp/time.c
new file mode 100644
index 0000000..3d29b4b
--- /dev/null
+++ b/arch/arm/mach-mmp/time.c
@@ -0,0 +1,212 @@
+/*
+ * linux/arch/arm/mach-mmp/time.c
+ *
+ *   Support for clocksource and clockevents
+ *
+ * Copyright (C) 2008 Marvell International Ltd.
+ * All rights reserved.
+ *
+ *   2008-04-11: Jason Chagas <Jason.chagas@marvell.com>
+ *   2008-10-08: Bin Yang <bin.yang@marvell.com>
+ *
+ * The timers module actually includes three timers, each timer with upto
+ * three match comparators. Timer #0 is used here in free-running mode as
+ * the clock source, and match comparator #1 used as clock event device.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/clockchips.h>
+
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/sched.h>
+#include <linux/cnt32_to_63.h>
+#include <linux/clk.h>
+
+#include <asm/mach/time.h>
+#include <mach/addr-map.h>
+#include <mach/regs-timers.h>
+#include <mach/irqs.h>
+
+#include "clock.h"
+
+#define TIMERS_VIRT_BASE	TIMERS1_VIRT_BASE
+
+#define MAX_DELTA		(0xfffffffe)
+#define MIN_DELTA		(16)
+
+#define TCR2NS_SCALE_FACTOR	10
+
+static unsigned long tcr2ns_scale;
+
+static void __init set_tcr2ns_scale(unsigned long tcr_rate)
+{
+	unsigned long long v = 1000000000ULL << TCR2NS_SCALE_FACTOR;
+	do_div(v, tcr_rate);
+	tcr2ns_scale = v;
+	/*
+	 * We want an even value to automatically clear the top bit
+	 * returned by cnt32_to_63() without an additional run time
+	 * instruction. So if the LSB is 1 then round it up.
+	 */
+	if (tcr2ns_scale & 1)
+		tcr2ns_scale++;
+}
+
+/*
+ * Note: the timer needs some delay to stablize the counter capture
+ */
+static inline uint32_t timer_read(void)
+{
+	int delay = 100;
+
+	__raw_writel(1, TIMERS_VIRT_BASE + TMR_CVWR(0));
+
+	while (delay--)
+		cpu_relax();
+
+	return __raw_readl(TIMERS_VIRT_BASE + TMR_CVWR(0));
+}
+
+unsigned long long sched_clock(void)
+{
+	unsigned long long v = cnt32_to_63(timer_read());
+	return (v * tcr2ns_scale) >> TCR2NS_SCALE_FACTOR;
+}
+
+static irqreturn_t timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *c = dev_id;
+
+	/* disable and clear pending interrupt status */
+	__raw_writel(0x0, TIMERS_VIRT_BASE + TMR_IER(0));
+	__raw_writel(0x1, TIMERS_VIRT_BASE + TMR_ICR(0));
+	c->event_handler(c);
+	return IRQ_HANDLED;
+}
+
+static int timer_set_next_event(unsigned long delta,
+				struct clock_event_device *dev)
+{
+	unsigned long flags, next;
+
+	local_irq_save(flags);
+
+	/* clear pending interrupt status and enable */
+	__raw_writel(0x01, TIMERS_VIRT_BASE + TMR_ICR(0));
+	__raw_writel(0x01, TIMERS_VIRT_BASE + TMR_IER(0));
+
+	next = timer_read() + delta;
+	__raw_writel(next, TIMERS_VIRT_BASE + TMR_TN_MM(0, 0));
+
+	local_irq_restore(flags);
+	return 0;
+}
+
+static void timer_set_mode(enum clock_event_mode mode,
+			   struct clock_event_device *dev)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	switch (mode) {
+	case CLOCK_EVT_MODE_ONESHOT:
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		/* disable the matching interrupt */
+		__raw_writel(0x00, TIMERS_VIRT_BASE + TMR_IER(0));
+		break;
+	case CLOCK_EVT_MODE_RESUME:
+	case CLOCK_EVT_MODE_PERIODIC:
+		break;
+	}
+	local_irq_restore(flags);
+}
+
+static struct clock_event_device ckevt = {
+	.name		= "clockevent",
+	.features	= CLOCK_EVT_FEAT_ONESHOT,
+	.shift		= 32,
+	.rating		= 200,
+	.set_next_event	= timer_set_next_event,
+	.set_mode	= timer_set_mode,
+};
+
+static cycle_t clksrc_read(void)
+{
+	return timer_read();
+}
+
+static struct clocksource cksrc = {
+	.name		= "clocksource",
+	.shift		= 20,
+	.rating		= 200,
+	.read		= clksrc_read,
+	.mask		= CLOCKSOURCE_MASK(32),
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static void __init timer_config(void)
+{
+	uint32_t ccr = __raw_readl(TIMERS_VIRT_BASE + TMR_CCR);
+	uint32_t cer = __raw_readl(TIMERS_VIRT_BASE + TMR_CER);
+	uint32_t cmr = __raw_readl(TIMERS_VIRT_BASE + TMR_CMR);
+
+	__raw_writel(cer & ~0x1, TIMERS_VIRT_BASE + TMR_CER); /* disable */
+
+	ccr &= TMR_CCR_CS_0(0x3);
+	__raw_writel(ccr, TIMERS_VIRT_BASE + TMR_CCR);
+
+	/* free-running mode */
+	__raw_writel(cmr | 0x01, TIMERS_VIRT_BASE + TMR_CMR);
+
+	__raw_writel(0x0, TIMERS_VIRT_BASE + TMR_PLCR(0)); /* free-running */
+	__raw_writel(0x7, TIMERS_VIRT_BASE + TMR_ICR(0));  /* clear status */
+	__raw_writel(0x0, TIMERS_VIRT_BASE + TMR_IER(0));
+
+	/* enable timer counter */
+	__raw_writel(cer | 0x01, TIMERS_VIRT_BASE + TMR_CER);
+}
+
+static struct irqaction timer_irq = {
+	.name		= "timer",
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.handler	= timer_interrupt,
+	.dev_id		= &ckevt,
+};
+
+static void __init timer_init(int irq)
+{
+	timer_config();
+
+	set_tcr2ns_scale(CLOCK_TICK_RATE);
+
+	ckevt.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, ckevt.shift);
+	ckevt.max_delta_ns = clockevent_delta2ns(MAX_DELTA, &ckevt);
+	ckevt.min_delta_ns = clockevent_delta2ns(MIN_DELTA, &ckevt);
+	ckevt.cpumask = cpumask_of(0);
+
+	cksrc.mult = clocksource_hz2mult(CLOCK_TICK_RATE, cksrc.shift);
+
+	setup_irq(irq, &timer_irq);
+
+	clocksource_register(&cksrc);
+	clockevents_register_device(&ckevt);
+}
+
+static void __init pxa168_timer_init(void)
+{
+	clk_enable(&clk_pxa168_timers);
+
+	timer_init(IRQ_PXA168_TIMER1);
+}
+
+struct sys_timer pxa168_timer = {
+	.init		= pxa168_timer_init,
+};
diff --git a/arch/arm/mach-mmp/zylonite2.c b/arch/arm/mach-mmp/zylonite2.c
new file mode 100644
index 0000000..82319b5
--- /dev/null
+++ b/arch/arm/mach-mmp/zylonite2.c
@@ -0,0 +1,31 @@
+/*
+ *  linux/arch/arm/mach-mmp/zylonite2.c
+ *
+ *  Support for the Marvell PXA168-based Zylonite2 Development Platform.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <mach/addr-map.h>
+
+#include "common.h"
+
+static void __init zylonite2_init(void)
+{
+}
+
+MACHINE_START(ZYLONITE2, "PXA168-based Zylonite2 Development Platform")
+	.phys_io        = APB_PHYS_BASE,
+	.boot_params    = 0x00000100,
+	.io_pg_offst    = (APB_VIRT_BASE >> 18) & 0xfffc,
+	.map_io		= pxa_map_io,
+	.init_irq       = pxa168_init_irq,
+	.timer          = &pxa168_timer,
+	.init_machine   = zylonite2_init,
+MACHINE_END
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index d490f37..64086f4 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -340,6 +340,17 @@ config CPU_XSC3
 	select CPU_TLB_V4WBI if MMU
 	select IO_36
 
+# Marvell PJ1 (Mohawk)
+config CPU_MOHAWK
+	bool
+	select CPU_32v5
+	select CPU_ABRT_EV5T
+	select CPU_PABRT_NOIFAR
+	select CPU_CACHE_VIVT
+	select CPU_CP15_MMU
+	select CPU_TLB_V4WBI if MMU
+	select CPU_COPY_V4WB if MMU
+
 # Feroceon
 config CPU_FEROCEON
 	bool
@@ -569,7 +580,7 @@ comment "Processor Features"
 
 config ARM_THUMB
 	bool "Support Thumb user binaries"
-	depends on CPU_ARM720T || CPU_ARM740T || CPU_ARM920T || CPU_ARM922T || CPU_ARM925T || CPU_ARM926T || CPU_ARM940T || CPU_ARM946E || CPU_ARM1020 || CPU_ARM1020E || CPU_ARM1022 || CPU_ARM1026 || CPU_XSCALE || CPU_XSC3 || CPU_V6 || CPU_V7 || CPU_FEROCEON
+	depends on CPU_ARM720T || CPU_ARM740T || CPU_ARM920T || CPU_ARM922T || CPU_ARM925T || CPU_ARM926T || CPU_ARM940T || CPU_ARM946E || CPU_ARM1020 || CPU_ARM1020E || CPU_ARM1022 || CPU_ARM1026 || CPU_XSCALE || CPU_XSC3 || CPU_MOHAWK || CPU_V6 || CPU_V7 || CPU_FEROCEON
 	default y
 	help
 	  Say Y if you want to include kernel support for running user space
@@ -653,7 +664,7 @@ config CPU_CACHE_ROUND_ROBIN
 
 config CPU_BPREDICT_DISABLE
 	bool "Disable branch prediction"
-	depends on CPU_ARM1020 || CPU_V6 || CPU_XSC3 || CPU_V7
+	depends on CPU_ARM1020 || CPU_V6 || CPU_MOHAWK || CPU_XSC3 || CPU_V7
 	help
 	  Say Y here to disable branch prediction.  If unsure, say N.
 
diff --git a/arch/arm/mm/Makefile b/arch/arm/mm/Makefile
index 480f78a..64149d9 100644
--- a/arch/arm/mm/Makefile
+++ b/arch/arm/mm/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_CPU_SA110)		+= proc-sa110.o
 obj-$(CONFIG_CPU_SA1100)	+= proc-sa1100.o
 obj-$(CONFIG_CPU_XSCALE)	+= proc-xscale.o
 obj-$(CONFIG_CPU_XSC3)		+= proc-xsc3.o
+obj-$(CONFIG_CPU_MOHAWK)	+= proc-mohawk.o
 obj-$(CONFIG_CPU_FEROCEON)	+= proc-feroceon.o
 obj-$(CONFIG_CPU_V6)		+= proc-v6.o
 obj-$(CONFIG_CPU_V7)		+= proc-v7.o
diff --git a/arch/arm/mm/proc-mohawk.S b/arch/arm/mm/proc-mohawk.S
new file mode 100644
index 0000000..719659a
--- /dev/null
+++ b/arch/arm/mm/proc-mohawk.S
@@ -0,0 +1,421 @@
+/*
+ *  linux/arch/arm/mm/proc-mohawk.S: MMU functions for Marvell PJ1 core
+ *
+ *  PJ1 (codename Mohawk) is a hybrid of the xscale3 and Marvell's own core.
+ *
+ *  Heavily based on proc-arm926.S and proc-xsc3.S
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/linkage.h>
+#include <linux/init.h>
+#include <asm/assembler.h>
+#include <asm/hwcap.h>
+#include <asm/pgtable-hwdef.h>
+#include <asm/pgtable.h>
+#include <asm/page.h>
+#include <asm/ptrace.h>
+#include "proc-macros.S"
+
+/*
+ * This is the maximum size of an area which will be flushed.  If the
+ * area is larger than this, then we flush the whole cache.
+ */
+#define CACHE_DLIMIT	32768
+
+/*
+ * The cache line size of the L1 D cache.
+ */
+#define CACHE_DLINESIZE	32
+
+/*
+ * cpu_mohawk_proc_init()
+ */
+ENTRY(cpu_mohawk_proc_init)
+	mov	pc, lr
+
+/*
+ * cpu_mohawk_proc_fin()
+ */
+ENTRY(cpu_mohawk_proc_fin)
+	stmfd	sp!, {lr}
+	mov	ip, #PSR_F_BIT | PSR_I_BIT | SVC_MODE
+	msr	cpsr_c, ip
+	bl	mohawk_flush_kern_cache_all
+	mrc	p15, 0, r0, c1, c0, 0		@ ctrl register
+	bic	r0, r0, #0x1800			@ ...iz...........
+	bic	r0, r0, #0x0006			@ .............ca.
+	mcr	p15, 0, r0, c1, c0, 0		@ disable caches
+	ldmfd	sp!, {pc}
+
+/*
+ * cpu_mohawk_reset(loc)
+ *
+ * Perform a soft reset of the system.  Put the CPU into the
+ * same state as it would be if it had been reset, and branch
+ * to what would be the reset vector.
+ *
+ * loc: location to jump to for soft reset
+ *
+ * (same as arm926)
+ */
+	.align	5
+ENTRY(cpu_mohawk_reset)
+	mov	ip, #0
+	mcr	p15, 0, ip, c7, c7, 0		@ invalidate I,D caches
+	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
+	mcr	p15, 0, ip, c8, c7, 0		@ invalidate I & D TLBs
+	mrc	p15, 0, ip, c1, c0, 0		@ ctrl register
+	bic	ip, ip, #0x0007			@ .............cam
+	bic	ip, ip, #0x1100			@ ...i...s........
+	mcr	p15, 0, ip, c1, c0, 0		@ ctrl register
+	mov	pc, r0
+
+/*
+ * cpu_mohawk_do_idle()
+ *
+ * Called with IRQs disabled
+ */
+	.align	5
+ENTRY(cpu_mohawk_do_idle)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
+	mcr	p15, 0, r0, c7, c0, 4		@ wait for interrupt
+	mov	pc, lr
+
+/*
+ *	flush_user_cache_all()
+ *
+ *	Clean and invalidate all cache entries in a particular
+ *	address space.
+ */
+ENTRY(mohawk_flush_user_cache_all)
+	/* FALLTHROUGH */
+
+/*
+ *	flush_kern_cache_all()
+ *
+ *	Clean and invalidate the entire cache.
+ */
+ENTRY(mohawk_flush_kern_cache_all)
+	mov	r2, #VM_EXEC
+	mov	ip, #0
+__flush_whole_cache:
+	mcr	p15, 0, ip, c7, c14, 0		@ clean & invalidate all D cache
+	tst	r2, #VM_EXEC
+	mcrne	p15, 0, ip, c7, c5, 0		@ invalidate I cache
+	mcrne	p15, 0, ip, c7, c10, 0		@ drain write buffer
+	mov	pc, lr
+
+/*
+ *	flush_user_cache_range(start, end, flags)
+ *
+ *	Clean and invalidate a range of cache entries in the
+ *	specified address range.
+ *
+ *	- start	- start address (inclusive)
+ *	- end	- end address (exclusive)
+ *	- flags	- vm_flags describing address space
+ *
+ * (same as arm926)
+ */
+ENTRY(mohawk_flush_user_cache_range)
+	mov	ip, #0
+	sub	r3, r1, r0			@ calculate total size
+	cmp	r3, #CACHE_DLIMIT
+	bgt	__flush_whole_cache
+1:	tst	r2, #VM_EXEC
+	mcr	p15, 0, r0, c7, c14, 1		@ clean and invalidate D entry
+	mcrne	p15, 0, r0, c7, c5, 1		@ invalidate I entry
+	add	r0, r0, #CACHE_DLINESIZE
+	mcr	p15, 0, r0, c7, c14, 1		@ clean and invalidate D entry
+	mcrne	p15, 0, r0, c7, c5, 1		@ invalidate I entry
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+	tst	r2, #VM_EXEC
+	mcrne	p15, 0, ip, c7, c10, 4		@ drain WB
+	mov	pc, lr
+
+/*
+ *	coherent_kern_range(start, end)
+ *
+ *	Ensure coherency between the Icache and the Dcache in the
+ *	region described by start, end.  If you have non-snooping
+ *	Harvard caches, you need to implement this function.
+ *
+ *	- start	- virtual start address
+ *	- end	- virtual end address
+ */
+ENTRY(mohawk_coherent_kern_range)
+	/* FALLTHROUGH */
+
+/*
+ *	coherent_user_range(start, end)
+ *
+ *	Ensure coherency between the Icache and the Dcache in the
+ *	region described by start, end.  If you have non-snooping
+ *	Harvard caches, you need to implement this function.
+ *
+ *	- start	- virtual start address
+ *	- end	- virtual end address
+ *
+ * (same as arm926)
+ */
+ENTRY(mohawk_coherent_user_range)
+	bic	r0, r0, #CACHE_DLINESIZE - 1
+1:	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
+	mcr	p15, 0, r0, c7, c5, 1		@ invalidate I entry
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+
+/*
+ *	flush_kern_dcache_page(void *page)
+ *
+ *	Ensure no D cache aliasing occurs, either with itself or
+ *	the I cache
+ *
+ *	- addr	- page aligned address
+ */
+ENTRY(mohawk_flush_kern_dcache_page)
+	add	r1, r0, #PAGE_SZ
+1:	mcr	p15, 0, r0, c7, c14, 1		@ clean+invalidate D entry
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+
+/*
+ *	dma_inv_range(start, end)
+ *
+ *	Invalidate (discard) the specified virtual address range.
+ *	May not write back any entries.  If 'start' or 'end'
+ *	are not cache line aligned, those lines must be written
+ *	back.
+ *
+ *	- start	- virtual start address
+ *	- end	- virtual end address
+ *
+ * (same as v4wb)
+ */
+ENTRY(mohawk_dma_inv_range)
+	tst	r0, #CACHE_DLINESIZE - 1
+	mcrne	p15, 0, r0, c7, c10, 1		@ clean D entry
+	tst	r1, #CACHE_DLINESIZE - 1
+	mcrne	p15, 0, r1, c7, c10, 1		@ clean D entry
+	bic	r0, r0, #CACHE_DLINESIZE - 1
+1:	mcr	p15, 0, r0, c7, c6, 1		@ invalidate D entry
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+
+/*
+ *	dma_clean_range(start, end)
+ *
+ *	Clean the specified virtual address range.
+ *
+ *	- start	- virtual start address
+ *	- end	- virtual end address
+ *
+ * (same as v4wb)
+ */
+ENTRY(mohawk_dma_clean_range)
+	bic	r0, r0, #CACHE_DLINESIZE - 1
+1:	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+
+/*
+ *	dma_flush_range(start, end)
+ *
+ *	Clean and invalidate the specified virtual address range.
+ *
+ *	- start	- virtual start address
+ *	- end	- virtual end address
+ */
+ENTRY(mohawk_dma_flush_range)
+	bic	r0, r0, #CACHE_DLINESIZE - 1
+1:
+	mcr	p15, 0, r0, c7, c14, 1		@ clean+invalidate D entry
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+
+ENTRY(mohawk_cache_fns)
+	.long	mohawk_flush_kern_cache_all
+	.long	mohawk_flush_user_cache_all
+	.long	mohawk_flush_user_cache_range
+	.long	mohawk_coherent_kern_range
+	.long	mohawk_coherent_user_range
+	.long	mohawk_flush_kern_dcache_page
+	.long	mohawk_dma_inv_range
+	.long	mohawk_dma_clean_range
+	.long	mohawk_dma_flush_range
+
+ENTRY(cpu_mohawk_dcache_clean_area)
+1:	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
+	add	r0, r0, #CACHE_DLINESIZE
+	subs	r1, r1, #CACHE_DLINESIZE
+	bhi	1b
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+
+/*
+ * cpu_mohawk_switch_mm(pgd)
+ *
+ * Set the translation base pointer to be as described by pgd.
+ *
+ * pgd: new page tables
+ */
+	.align	5
+ENTRY(cpu_mohawk_switch_mm)
+	mov	ip, #0
+	mcr	p15, 0, ip, c7, c14, 0		@ clean & invalidate all D cache
+	mcr	p15, 0, ip, c7, c5, 0		@ invalidate I cache
+	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
+	orr	r0, r0, #0x18			@ cache the page table in L2
+	mcr	p15, 0, r0, c2, c0, 0		@ load page table pointer
+	mcr	p15, 0, ip, c8, c7, 0		@ invalidate I & D TLBs
+	mov	pc, lr
+
+/*
+ * cpu_mohawk_set_pte_ext(ptep, pte, ext)
+ *
+ * Set a PTE and flush it out
+ */
+	.align	5
+ENTRY(cpu_mohawk_set_pte_ext)
+	armv3_set_pte_ext
+	mov	r0, r0
+	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+
+	__INIT
+
+	.type	__mohawk_setup, #function
+__mohawk_setup:
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c7		@ invalidate I,D caches
+	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
+	mcr	p15, 0, r0, c8, c7		@ invalidate I,D TLBs
+	orr	r4, r4, #0x18			@ cache the page table in L2
+	mcr	p15, 0, r4, c2, c0, 0		@ load page table pointer
+
+	mov	r0, #0				@ don't allow CP access
+	mcr	p15, 0, r0, c15, c1, 0		@ write CP access register
+
+	adr	r5, mohawk_crval
+	ldmia	r5, {r5, r6}
+	mrc	p15, 0, r0, c1, c0		@ get control register
+	bic	r0, r0, r5
+	orr	r0, r0, r6
+	mov	pc, lr
+
+	.size	__mohawk_setup, . - __mohawk_setup
+
+	/*
+	 *  R
+	 * .RVI ZFRS BLDP WCAM
+	 * .011 1001 ..00 0101
+	 *
+	 */
+	.type	mohawk_crval, #object
+mohawk_crval:
+	crval	clear=0x00007f3f, mmuset=0x00003905, ucset=0x00001134
+
+	__INITDATA
+
+/*
+ * Purpose : Function pointers used to access above functions - all calls
+ *	     come through these
+ */
+	.type	mohawk_processor_functions, #object
+mohawk_processor_functions:
+	.word	v5t_early_abort
+	.word	pabort_noifar
+	.word	cpu_mohawk_proc_init
+	.word	cpu_mohawk_proc_fin
+	.word	cpu_mohawk_reset
+	.word	cpu_mohawk_do_idle
+	.word	cpu_mohawk_dcache_clean_area
+	.word	cpu_mohawk_switch_mm
+	.word	cpu_mohawk_set_pte_ext
+	.size	mohawk_processor_functions, . - mohawk_processor_functions
+
+	.section ".rodata"
+
+	.type	cpu_arch_name, #object
+cpu_arch_name:
+	.asciz	"armv5te"
+	.size	cpu_arch_name, . - cpu_arch_name
+
+	.type	cpu_elf_name, #object
+cpu_elf_name:
+	.asciz	"v5"
+	.size	cpu_elf_name, . - cpu_elf_name
+
+	.type	cpu_mohawk_name, #object
+cpu_mohawk_name:
+	.asciz	"Marvell 88SV331x"
+	.size	cpu_mohawk_name, . - cpu_mohawk_name
+
+	.type	cpu_pxa168_name, #object
+cpu_pxa168_name:
+	.asciz	"Marvell PXA168"
+	.size	cpu_pxa168_name, . - cpu_pxa168_name
+
+	.align
+
+	.section ".proc.info.init", #alloc, #execinstr
+
+	.type	__pxa168_proc_info,#object
+__pxa168_proc_info:
+	.long	0x56158400			@ Marvell PXA168
+	.long	0xff0fff00
+	.long   PMD_TYPE_SECT | \
+		PMD_SECT_BUFFERABLE | \
+		PMD_SECT_CACHEABLE | \
+		PMD_BIT4 | \
+		PMD_SECT_AP_WRITE | \
+		PMD_SECT_AP_READ
+	.long   PMD_TYPE_SECT | \
+		PMD_BIT4 | \
+		PMD_SECT_AP_WRITE | \
+		PMD_SECT_AP_READ
+	b	__mohawk_setup
+	.long	cpu_arch_name
+	.long	cpu_elf_name
+	.long	HWCAP_SWP|HWCAP_HALF|HWCAP_THUMB|HWCAP_FAST_MULT|HWCAP_EDSP
+	.long	cpu_pxa168_name
+	.long	mohawk_processor_functions
+	.long	v4wbi_tlb_fns
+	.long	v4wb_user_fns
+	.long	mohawk_cache_fns
+	.size	__pxa168_proc_info, . - __pxa168_proc_info
-- 
1.6.0.4


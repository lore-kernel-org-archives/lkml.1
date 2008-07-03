Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbYGCMms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbYGCMms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759994AbYGCMmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:42:23 -0400
Received: from bu3sch.de ([62.75.166.246]:37327 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758733AbYGCMmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:42:21 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] gpiolib: Allow user-selection
Date: Thu, 3 Jul 2008 12:33:03 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807031233.04229.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds functionality to the gpio-lib subsystem to
make it possible to enable the gpio-lib code even if the
architecture code didn't request to get it built in.

The archtitecture code does still need to implement the gpiolib
accessor functions in its asm/gpio.h file.
This patch adds the implementations for x86 and PPC.

With these changes it is possible to run generic GPIO expansion
cards on every architecture that implements the trivial wrapper
functions. Support for more architectures can easily be added.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This patch should be scheduled for the next kernel feature merge window.
This is diffed against current linux-next. Compiletested on x86 and powerpc.
Runtime tested on x86.


Index: linux-next/arch/x86/Kconfig
===================================================================
--- linux-next.orig/arch/x86/Kconfig	2008-07-03 11:31:07.000000000 +0200
+++ linux-next/arch/x86/Kconfig	2008-07-03 11:36:14.000000000 +0200
@@ -27,6 +27,7 @@
 	select HAVE_FTRACE
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
+	select ARCH_WANT_OPTIONAL_GPIOLIB if !X86_RDC321X
 
 config ARCH_DEFCONFIG
 	string
Index: linux-next/include/asm-x86/gpio.h
===================================================================
--- linux-next.orig/include/asm-x86/gpio.h	2008-07-03 11:31:13.000000000 +0200
+++ linux-next/include/asm-x86/gpio.h	2008-07-03 11:36:14.000000000 +0200
@@ -1,6 +1,62 @@
+/*
+ * Generic GPIO API implementation for x86.
+ *
+ * Derived from the generic GPIO API for powerpc:
+ *
+ * Copyright (c) 2007-2008  MontaVista Software, Inc.
+ *
+ * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
 #ifndef _ASM_I386_GPIO_H
 #define _ASM_I386_GPIO_H
 
+#ifdef CONFIG_X86_RDC321X
 #include <gpio.h>
+#else /* CONFIG_X86_RDC321X */
+
+#include <asm-generic/gpio.h>
+
+#ifdef CONFIG_GPIOLIB
+
+/*
+ * Just call gpiolib.
+ */
+static inline int gpio_get_value(unsigned int gpio)
+{
+	return __gpio_get_value(gpio);
+}
+
+static inline void gpio_set_value(unsigned int gpio, int value)
+{
+	__gpio_set_value(gpio, value);
+}
+
+static inline int gpio_cansleep(unsigned int gpio)
+{
+	return __gpio_cansleep(gpio);
+}
+
+/*
+ * Not implemented, yet.
+ */
+static inline int gpio_to_irq(unsigned int gpio)
+{
+	return -ENOSYS;
+}
+
+static inline int irq_to_gpio(unsigned int irq)
+{
+	return -EINVAL;
+}
+
+#endif /* CONFIG_GPIOLIB */
+
+#endif /* CONFIG_X86_RDC321X */
 
 #endif /* _ASM_I386_GPIO_H */
Index: linux-next/arch/powerpc/Kconfig
===================================================================
--- linux-next.orig/arch/powerpc/Kconfig	2008-07-03 11:31:06.000000000 +0200
+++ linux-next/arch/powerpc/Kconfig	2008-07-03 11:37:16.000000000 +0200
@@ -113,6 +113,7 @@
 	select HAVE_LMB
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_OPROFILE
+	select ARCH_WANT_OPTIONAL_GPIOLIB
 
 config EARLY_PRINTK
 	bool
Index: linux-next/drivers/gpio/Kconfig
===================================================================
--- linux-next.orig/drivers/gpio/Kconfig	2008-07-03 11:31:08.000000000 +0200
+++ linux-next/drivers/gpio/Kconfig	2008-07-03 11:36:14.000000000 +0200
@@ -2,15 +2,40 @@
 # GPIO infrastructure and expanders
 #
 
-config HAVE_GPIO_LIB
+config ARCH_WANT_OPTIONAL_GPIOLIB
 	bool
 	help
+	  Select this config option from the architecture Kconfig, if
+	  it is possible to use gpiolib on the architecture, but let the
+	  user decide whether to actually build it or not.
+	  Select this instead of ARCH_REQUIRE_GPIOLIB, if your architecture does
+	  not depend on GPIOs being available, but rather let the user
+	  decide whether he needs it or not.
+
+config ARCH_REQUIRE_GPIOLIB
+	bool
+	select GPIOLIB
+	help
 	  Platforms select gpiolib if they use this infrastructure
 	  for all their GPIOs, usually starting with ones integrated
 	  into SOC processors.
+	  Selecting this from the architecture code will cause the gpiolib
+	  code to always get built in.
+
+
+
+menuconfig GPIOLIB
+	bool "GPIO Support"
+	depends on ARCH_WANT_OPTIONAL_GPIOLIB || ARCH_REQUIRE_GPIOLIB
+	select GENERIC_GPIO
+	help
+	  This enables GPIO support through the generic GPIO library.
+	  You only need to enable this, if you also want to enable
+	  one or more of the GPIO expansion card drivers below.
+
+	  If unsure, say N.
 
-menu "GPIO Support"
-	depends on HAVE_GPIO_LIB
+if GPIOLIB
 
 config DEBUG_GPIO
 	bool "Debug GPIO calls"
@@ -70,4 +95,4 @@
 	  SPI driver for Microchip MCP23S08 I/O expander.  This provides
 	  a GPIO interface supporting inputs and outputs.
 
-endmenu
+endif
Index: linux-next/drivers/gpio/Makefile
===================================================================
--- linux-next.orig/drivers/gpio/Makefile	2008-07-03 11:31:08.000000000 +0200
+++ linux-next/drivers/gpio/Makefile	2008-07-03 11:36:14.000000000 +0200
@@ -2,7 +2,7 @@
 
 ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
-obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpiolib.o
+obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
Index: linux-next/Documentation/gpio.txt
===================================================================
--- linux-next.orig/Documentation/gpio.txt	2008-07-03 11:31:04.000000000 +0200
+++ linux-next/Documentation/gpio.txt	2008-07-03 11:36:14.000000000 +0200
@@ -392,11 +392,21 @@
 
 Platform Support
 ----------------
-To support this framework, a platform's Kconfig will "select HAVE_GPIO_LIB"
+To support this framework, a platform's Kconfig will "select" either
+ARCH_REQUIRE_GPIOLIB or ARCH_WANT_OPTIONAL_GPIOLIB
 and arrange that its <asm/gpio.h> includes <asm-generic/gpio.h> and defines
 three functions: gpio_get_value(), gpio_set_value(), and gpio_cansleep().
 They may also want to provide a custom value for ARCH_NR_GPIOS.
 
+ARCH_REQUIRE_GPIOLIB means that the gpio-lib code will always get compiled
+into the kernel on that architecture.
+
+ARCH_WANT_OPTIONAL_GPIOLIB means the gpio-lib code defaults to off and the user
+can enable it and build it into the kernel optionally.
+
+If neither of these options are selected, the platform does not support
+GPIOs through GPIO-lib and the code cannot be enabled by the user.
+
 Trivial implementations of those functions can directly use framework
 code, which always dispatches through the gpio_chip:
 
Index: linux-next/arch/arm/Kconfig
===================================================================
--- linux-next.orig/arch/arm/Kconfig	2008-07-03 11:31:05.000000000 +0200
+++ linux-next/arch/arm/Kconfig	2008-07-03 11:36:14.000000000 +0200
@@ -262,7 +262,7 @@
 	select ARM_AMBA
 	select ARM_VIC
 	select GENERIC_GPIO
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	help
 	  This enables support for the Cirrus EP93xx series of CPUs.
 
@@ -430,7 +430,7 @@
 	depends on MMU
 	select ARCH_MTD_XIP
 	select GENERIC_GPIO
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
@@ -460,7 +460,7 @@
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	help
 	  Support for StrongARM 11x0 based boards.
 
@@ -500,7 +500,7 @@
 config ARCH_OMAP
 	bool "TI OMAP"
 	select GENERIC_GPIO
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
Index: linux-next/arch/arm/configs/am200epdkit_defconfig
===================================================================
--- linux-next.orig/arch/arm/configs/am200epdkit_defconfig	2008-07-03 11:31:05.000000000 +0200
+++ linux-next/arch/arm/configs/am200epdkit_defconfig	2008-07-03 11:36:14.000000000 +0200
@@ -668,7 +668,7 @@
 #
 # CONFIG_SPI is not set
 # CONFIG_SPI_MASTER is not set
-CONFIG_HAVE_GPIO_LIB=y
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
 
 #
 # GPIO Support
Index: linux-next/arch/avr32/Kconfig
===================================================================
--- linux-next.orig/arch/avr32/Kconfig	2008-07-03 11:31:05.000000000 +0200
+++ linux-next/arch/avr32/Kconfig	2008-07-03 11:38:02.000000000 +0200
@@ -87,7 +87,7 @@
 	select SUBARCH_AVR32B
 	select MMU
 	select PERFORMANCE_COUNTERS
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	select GENERIC_ALLOCATOR
 
 #
Index: linux-next/arch/avr32/configs/atngw100_defconfig
===================================================================
--- linux-next.orig/arch/avr32/configs/atngw100_defconfig	2008-07-03 11:31:05.000000000 +0200
+++ linux-next/arch/avr32/configs/atngw100_defconfig	2008-07-03 11:36:14.000000000 +0200
@@ -646,7 +646,7 @@
 # CONFIG_SPI_AT25 is not set
 CONFIG_SPI_SPIDEV=m
 # CONFIG_SPI_TLE62X0 is not set
-CONFIG_HAVE_GPIO_LIB=y
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
 
 #
 # GPIO Support
Index: linux-next/arch/avr32/configs/atstk1002_defconfig
===================================================================
--- linux-next.orig/arch/avr32/configs/atstk1002_defconfig	2008-07-03 11:31:05.000000000 +0200
+++ linux-next/arch/avr32/configs/atstk1002_defconfig	2008-07-03 11:36:14.000000000 +0200
@@ -664,7 +664,7 @@
 # CONFIG_SPI_AT25 is not set
 CONFIG_SPI_SPIDEV=m
 # CONFIG_SPI_TLE62X0 is not set
-CONFIG_HAVE_GPIO_LIB=y
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
 
 #
 # GPIO Support
Index: linux-next/arch/avr32/configs/atstk1003_defconfig
===================================================================
--- linux-next.orig/arch/avr32/configs/atstk1003_defconfig	2008-07-03 11:31:05.000000000 +0200
+++ linux-next/arch/avr32/configs/atstk1003_defconfig	2008-07-03 11:36:14.000000000 +0200
@@ -614,7 +614,7 @@
 # CONFIG_SPI_AT25 is not set
 CONFIG_SPI_SPIDEV=m
 # CONFIG_SPI_TLE62X0 is not set
-CONFIG_HAVE_GPIO_LIB=y
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
 
 #
 # GPIO Support
Index: linux-next/arch/avr32/configs/atstk1004_defconfig
===================================================================
--- linux-next.orig/arch/avr32/configs/atstk1004_defconfig	2008-07-03 11:31:05.000000000 +0200
+++ linux-next/arch/avr32/configs/atstk1004_defconfig	2008-07-03 11:36:14.000000000 +0200
@@ -390,7 +390,7 @@
 # CONFIG_SPI_AT25 is not set
 # CONFIG_SPI_SPIDEV is not set
 # CONFIG_SPI_TLE62X0 is not set
-CONFIG_HAVE_GPIO_LIB=y
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
 
 #
 # GPIO Support
Index: linux-next/arch/mips/Kconfig
===================================================================
--- linux-next.orig/arch/mips/Kconfig	2008-07-03 11:31:06.000000000 +0200
+++ linux-next/arch/mips/Kconfig	2008-07-03 11:36:14.000000000 +0200
@@ -800,7 +800,7 @@
 
 config GPIO_TXX9
 	select GENERIC_GPIO
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	bool
 
 config CFE
Index: linux-next/arch/powerpc/platforms/52xx/Kconfig
===================================================================
--- linux-next.orig/arch/powerpc/platforms/52xx/Kconfig	2008-07-03 11:31:06.000000000 +0200
+++ linux-next/arch/powerpc/platforms/52xx/Kconfig	2008-07-03 11:36:14.000000000 +0200
@@ -47,6 +47,6 @@
 config PPC_MPC5200_GPIO
 	bool "MPC5200 GPIO support"
 	depends on PPC_MPC52xx
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	help
 	  Enable gpiolib support for mpc5200 based boards
Index: linux-next/drivers/Makefile
===================================================================
--- linux-next.orig/drivers/Makefile	2008-07-03 11:31:07.000000000 +0200
+++ linux-next/drivers/Makefile	2008-07-03 11:36:14.000000000 +0200
@@ -5,7 +5,7 @@
 # Rewritten to use lists instead of if-statements.
 #
 
-obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpio/
+obj-y				+= gpio/
 obj-$(CONFIG_PCI)		+= pci/
 obj-$(CONFIG_PARISC)		+= parisc/
 obj-$(CONFIG_RAPIDIO)		+= rapidio/
Index: linux-next/drivers/i2c/chips/Kconfig
===================================================================
--- linux-next.orig/drivers/i2c/chips/Kconfig	2008-07-03 11:31:08.000000000 +0200
+++ linux-next/drivers/i2c/chips/Kconfig	2008-07-03 11:36:14.000000000 +0200
@@ -126,7 +126,7 @@
 
 config TPS65010
 	tristate "TPS6501x Power Management chips"
-	depends on HAVE_GPIO_LIB
+	depends on GPIOLIB
 	default y if MACH_OMAP_H2 || MACH_OMAP_H3 || MACH_OMAP_OSK
 	help
 	  If you say yes here you get support for the TPS6501x series of
Index: linux-next/drivers/mfd/Kconfig
===================================================================
--- linux-next.orig/drivers/mfd/Kconfig	2008-07-03 11:31:09.000000000 +0200
+++ linux-next/drivers/mfd/Kconfig	2008-07-03 11:41:57.000000000 +0200
@@ -28,7 +28,7 @@
 
 config HTC_EGPIO
 	bool "HTC EGPIO support"
-	depends on GENERIC_HARDIRQS && HAVE_GPIO_LIB && ARM
+	depends on GENERIC_HARDIRQS && GPIOLIB && ARM
 	help
 	    This driver supports the CPLD egpio chip present on
 	    several HTC phones.  It provides basic support for input
@@ -44,7 +44,7 @@
 
 config MFD_TC6393XB
 	bool "Support Toshiba TC6393XB"
-	depends on HAVE_GPIO_LIB
+	depends on GPIOLIB
 	select MFD_CORE
 	help
 	  Support for Toshiba Mobile IO Controller TC6393XB
Index: linux-next/drivers/of/Kconfig
===================================================================
--- linux-next.orig/drivers/of/Kconfig	2008-07-03 11:31:10.000000000 +0200
+++ linux-next/drivers/of/Kconfig	2008-07-03 11:36:14.000000000 +0200
@@ -4,7 +4,7 @@
 
 config OF_GPIO
 	def_bool y
-	depends on OF && PPC_OF && HAVE_GPIO_LIB
+	depends on OF && PPC_OF && GPIOLIB
 	help
 	  OpenFirmware GPIO accessors
 
Index: linux-next/include/asm-generic/gpio.h
===================================================================
--- linux-next.orig/include/asm-generic/gpio.h	2008-07-03 11:31:13.000000000 +0200
+++ linux-next/include/asm-generic/gpio.h	2008-07-03 11:36:14.000000000 +0200
@@ -3,7 +3,7 @@
 
 #include <linux/types.h>
 
-#ifdef CONFIG_HAVE_GPIO_LIB
+#ifdef CONFIG_GPIOLIB
 
 #include <linux/compiler.h>
 
Index: linux-next/include/asm-mips/mach-generic/gpio.h
===================================================================
--- linux-next.orig/include/asm-mips/mach-generic/gpio.h	2008-07-03 11:31:13.000000000 +0200
+++ linux-next/include/asm-mips/mach-generic/gpio.h	2008-07-03 11:36:14.000000000 +0200
@@ -1,7 +1,7 @@
 #ifndef __ASM_MACH_GENERIC_GPIO_H
 #define __ASM_MACH_GENERIC_GPIO_H
 
-#ifdef CONFIG_HAVE_GPIO_LIB
+#ifdef CONFIG_GPIOLIB
 #define gpio_get_value	__gpio_get_value
 #define gpio_set_value	__gpio_set_value
 #define gpio_cansleep	__gpio_cansleep
Index: linux-next/include/asm-powerpc/gpio.h
===================================================================
--- linux-next.orig/include/asm-powerpc/gpio.h	2008-07-03 11:31:13.000000000 +0200
+++ linux-next/include/asm-powerpc/gpio.h	2008-07-03 11:36:14.000000000 +0200
@@ -17,7 +17,7 @@
 #include <linux/errno.h>
 #include <asm-generic/gpio.h>
 
-#ifdef CONFIG_HAVE_GPIO_LIB
+#ifdef CONFIG_GPIOLIB
 
 /*
  * We don't (yet) implement inlined/rapid versions for on-chip gpios.
@@ -51,6 +51,6 @@
 	return -EINVAL;
 }
 
-#endif /* CONFIG_HAVE_GPIO_LIB */
+#endif /* CONFIG_GPIOLIB */
 
 #endif /* __ASM_POWERPC_GPIO_H */
Index: linux-next/arch/arm/configs/xm_x270_defconfig
===================================================================
--- linux-next.orig/arch/arm/configs/xm_x270_defconfig	2008-07-03 11:41:07.000000000 +0200
+++ linux-next/arch/arm/configs/xm_x270_defconfig	2008-07-03 11:41:25.000000000 +0200
@@ -970,7 +970,7 @@
 # CONFIG_I2C_DEBUG_BUS is not set
 # CONFIG_I2C_DEBUG_CHIP is not set
 # CONFIG_SPI is not set
-CONFIG_HAVE_GPIO_LIB=y
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
 
 #
 # GPIO Support
Index: linux-next/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
===================================================================
--- linux-next.orig/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig	2008-07-03 11:39:27.000000000 +0200
+++ linux-next/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig	2008-07-03 11:39:45.000000000 +0200
@@ -703,7 +703,7 @@
 # CONFIG_SPI_AT25 is not set
 CONFIG_SPI_SPIDEV=y
 # CONFIG_SPI_TLE62X0 is not set
-CONFIG_HAVE_GPIO_LIB=y
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
 
 #
 # GPIO Support
Index: linux-next/arch/powerpc/sysdev/qe_lib/Kconfig
===================================================================
--- linux-next.orig/arch/powerpc/sysdev/qe_lib/Kconfig	2008-07-03 11:40:16.000000000 +0200
+++ linux-next/arch/powerpc/sysdev/qe_lib/Kconfig	2008-07-03 11:40:39.000000000 +0200
@@ -29,7 +29,7 @@
 	bool "QE GPIO support"
 	depends on QUICC_ENGINE
 	select GENERIC_GPIO
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	help
 	  Say Y here if you're going to use hardware that connects to the
 	  QE GPIOs.



-- 
Greetings Michael.

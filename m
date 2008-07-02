Return-Path: <linux-kernel-owner+w=401wt.eu-S1759535AbYGBVrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535AbYGBVrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbYGBVr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:47:29 -0400
Received: from bu3sch.de ([62.75.166.246]:46212 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbYGBVr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:47:27 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] gpiolib: Allow user-selection
Date: Wed, 2 Jul 2008 23:46:53 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807022346.53222.mb@bu3sch.de>
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


Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig	2008-07-02 23:12:59.000000000 +0200
+++ linux-2.6/arch/x86/Kconfig	2008-07-02 23:15:33.000000000 +0200
@@ -25,6 +25,7 @@ config X86
 	select HAVE_KRETPROBES
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
+	select ARCH_WANT_OPTIONAL_GPIOLIB if !X86_RDC321X
 
 config ARCH_DEFCONFIG
 	string
Index: linux-2.6/include/asm-x86/gpio.h
===================================================================
--- linux-2.6.orig/include/asm-x86/gpio.h	2008-07-02 23:12:59.000000000 +0200
+++ linux-2.6/include/asm-x86/gpio.h	2008-07-02 23:31:42.000000000 +0200
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
Index: linux-2.6/arch/powerpc/Kconfig
===================================================================
--- linux-2.6.orig/arch/powerpc/Kconfig	2008-07-02 23:12:59.000000000 +0200
+++ linux-2.6/arch/powerpc/Kconfig	2008-07-02 23:15:33.000000000 +0200
@@ -110,6 +110,7 @@ config PPC
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_LMB
+	select ARCH_WANT_OPTIONAL_GPIOLIB
 
 config EARLY_PRINTK
 	bool
Index: linux-2.6/drivers/gpio/Kconfig
===================================================================
--- linux-2.6.orig/drivers/gpio/Kconfig	2008-07-02 23:12:59.000000000 +0200
+++ linux-2.6/drivers/gpio/Kconfig	2008-07-02 23:28:57.000000000 +0200
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
@@ -70,4 +95,4 @@ config GPIO_MCP23S08
 	  SPI driver for Microchip MCP23S08 I/O expander.  This provides
 	  a GPIO interface supporting inputs and outputs.
 
-endmenu
+endif
Index: linux-2.6/drivers/gpio/Makefile
===================================================================
--- linux-2.6.orig/drivers/gpio/Makefile	2008-07-02 23:12:59.000000000 +0200
+++ linux-2.6/drivers/gpio/Makefile	2008-07-02 23:15:33.000000000 +0200
@@ -2,7 +2,7 @@
 
 ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
-obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpiolib.o
+obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
Index: linux-2.6/Documentation/gpio.txt
===================================================================
--- linux-2.6.orig/Documentation/gpio.txt	2008-05-01 13:19:44.000000000 +0200
+++ linux-2.6/Documentation/gpio.txt	2008-07-02 23:35:48.000000000 +0200
@@ -392,11 +392,21 @@ either NULL or the label associated with
 
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
 
Index: linux-2.6/arch/arm/Kconfig
===================================================================
--- linux-2.6.orig/arch/arm/Kconfig	2008-05-01 13:19:44.000000000 +0200
+++ linux-2.6/arch/arm/Kconfig	2008-07-02 23:23:59.000000000 +0200
@@ -254,7 +254,7 @@ config ARCH_EP93XX
 	select ARM_AMBA
 	select ARM_VIC
 	select GENERIC_GPIO
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	help
 	  This enables support for the Cirrus EP93xx series of CPUs.
 
@@ -393,7 +393,7 @@ config ARCH_PXA
 	depends on MMU
 	select ARCH_MTD_XIP
 	select GENERIC_GPIO
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
@@ -423,7 +423,7 @@ config ARCH_SA1100
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	help
 	  Support for StrongARM 11x0 based boards.
 
@@ -463,7 +463,7 @@ config ARCH_DAVINCI
 config ARCH_OMAP
 	bool "TI OMAP"
 	select GENERIC_GPIO
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
Index: linux-2.6/arch/arm/configs/am200epdkit_defconfig
===================================================================
--- linux-2.6.orig/arch/arm/configs/am200epdkit_defconfig	2008-05-01 13:19:44.000000000 +0200
+++ linux-2.6/arch/arm/configs/am200epdkit_defconfig	2008-07-02 23:23:34.000000000 +0200
@@ -668,7 +668,7 @@ CONFIG_UNIX98_PTYS=y
 #
 # CONFIG_SPI is not set
 # CONFIG_SPI_MASTER is not set
-CONFIG_HAVE_GPIO_LIB=y
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
 
 #
 # GPIO Support
Index: linux-2.6/arch/avr32/Kconfig
===================================================================
--- linux-2.6.orig/arch/avr32/Kconfig	2008-05-01 13:19:44.000000000 +0200
+++ linux-2.6/arch/avr32/Kconfig	2008-07-02 23:26:20.000000000 +0200
@@ -87,7 +87,7 @@ config PLATFORM_AT32AP
 	select SUBARCH_AVR32B
 	select MMU
 	select PERFORMANCE_COUNTERS
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 
 #
 # CPU types
Index: linux-2.6/arch/avr32/configs/atngw100_defconfig
===================================================================
--- linux-2.6.orig/arch/avr32/configs/atngw100_defconfig	2008-06-13 13:13:38.000000000 +0200
+++ linux-2.6/arch/avr32/configs/atngw100_defconfig	2008-07-02 23:25:22.000000000 +0200
@@ -646,7 +646,7 @@ CONFIG_SPI_ATMEL=y
 # CONFIG_SPI_AT25 is not set
 CONFIG_SPI_SPIDEV=m
 # CONFIG_SPI_TLE62X0 is not set
-CONFIG_HAVE_GPIO_LIB=y
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
 
 #
 # GPIO Support
Index: linux-2.6/arch/avr32/configs/atstk1002_defconfig
===================================================================
--- linux-2.6.orig/arch/avr32/configs/atstk1002_defconfig	2008-06-13 13:13:38.000000000 +0200
+++ linux-2.6/arch/avr32/configs/atstk1002_defconfig	2008-07-02 23:25:02.000000000 +0200
@@ -664,7 +664,7 @@ CONFIG_SPI_ATMEL=y
 # CONFIG_SPI_AT25 is not set
 CONFIG_SPI_SPIDEV=m
 # CONFIG_SPI_TLE62X0 is not set
-CONFIG_HAVE_GPIO_LIB=y
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
 
 #
 # GPIO Support
Index: linux-2.6/arch/avr32/configs/atstk1003_defconfig
===================================================================
--- linux-2.6.orig/arch/avr32/configs/atstk1003_defconfig	2008-06-13 13:13:38.000000000 +0200
+++ linux-2.6/arch/avr32/configs/atstk1003_defconfig	2008-07-02 23:25:55.000000000 +0200
@@ -614,7 +614,7 @@ CONFIG_SPI_ATMEL=y
 # CONFIG_SPI_AT25 is not set
 CONFIG_SPI_SPIDEV=m
 # CONFIG_SPI_TLE62X0 is not set
-CONFIG_HAVE_GPIO_LIB=y
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
 
 #
 # GPIO Support
Index: linux-2.6/arch/avr32/configs/atstk1004_defconfig
===================================================================
--- linux-2.6.orig/arch/avr32/configs/atstk1004_defconfig	2008-06-13 13:13:38.000000000 +0200
+++ linux-2.6/arch/avr32/configs/atstk1004_defconfig	2008-07-02 23:26:04.000000000 +0200
@@ -390,7 +390,7 @@ CONFIG_SPI_ATMEL=y
 # CONFIG_SPI_AT25 is not set
 # CONFIG_SPI_SPIDEV is not set
 # CONFIG_SPI_TLE62X0 is not set
-CONFIG_HAVE_GPIO_LIB=y
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
 
 #
 # GPIO Support
Index: linux-2.6/arch/mips/Kconfig
===================================================================
--- linux-2.6.orig/arch/mips/Kconfig	2008-05-01 13:19:45.000000000 +0200
+++ linux-2.6/arch/mips/Kconfig	2008-07-02 23:24:28.000000000 +0200
@@ -800,7 +800,7 @@ config CSRC_SB1250
 
 config GPIO_TXX9
 	select GENERIC_GPIO
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	bool
 
 config CFE
Index: linux-2.6/arch/powerpc/platforms/52xx/Kconfig
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/52xx/Kconfig	2008-05-01 13:19:46.000000000 +0200
+++ linux-2.6/arch/powerpc/platforms/52xx/Kconfig	2008-07-02 23:26:41.000000000 +0200
@@ -47,6 +47,6 @@ config PPC_MPC5200_BUGFIX
 config PPC_MPC5200_GPIO
 	bool "MPC5200 GPIO support"
 	depends on PPC_MPC52xx
-	select HAVE_GPIO_LIB
+	select ARCH_REQUIRE_GPIOLIB
 	help
 	  Enable gpiolib support for mpc5200 based boards
Index: linux-2.6/drivers/Makefile
===================================================================
--- linux-2.6.orig/drivers/Makefile	2008-05-01 13:19:48.000000000 +0200
+++ linux-2.6/drivers/Makefile	2008-07-02 23:29:33.000000000 +0200
@@ -5,7 +5,7 @@
 # Rewritten to use lists instead of if-statements.
 #
 
-obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpio/
+obj-y				+= gpio/
 obj-$(CONFIG_PCI)		+= pci/
 obj-$(CONFIG_PARISC)		+= parisc/
 obj-$(CONFIG_RAPIDIO)		+= rapidio/
Index: linux-2.6/drivers/i2c/chips/Kconfig
===================================================================
--- linux-2.6.orig/drivers/i2c/chips/Kconfig	2008-05-01 13:19:49.000000000 +0200
+++ linux-2.6/drivers/i2c/chips/Kconfig	2008-07-02 23:27:49.000000000 +0200
@@ -93,7 +93,7 @@ config ISP1301_OMAP
 
 config TPS65010
 	tristate "TPS6501x Power Management chips"
-	depends on HAVE_GPIO_LIB
+	depends on GPIOLIB
 	default y if MACH_OMAP_H2 || MACH_OMAP_H3 || MACH_OMAP_OSK
 	help
 	  If you say yes here you get support for the TPS6501x series of
Index: linux-2.6/drivers/mfd/Kconfig
===================================================================
--- linux-2.6.orig/drivers/mfd/Kconfig	2008-06-13 13:13:40.000000000 +0200
+++ linux-2.6/drivers/mfd/Kconfig	2008-07-02 23:28:09.000000000 +0200
@@ -24,7 +24,7 @@ config MFD_ASIC3
 
 config HTC_EGPIO
 	bool "HTC EGPIO support"
-	depends on GENERIC_HARDIRQS && HAVE_GPIO_LIB && ARM
+	depends on GENERIC_HARDIRQS && GPIOLIB && ARM
 	help
 	    This driver supports the CPLD egpio chip present on
 	    several HTC phones.  It provides basic support for input
Index: linux-2.6/drivers/of/Kconfig
===================================================================
--- linux-2.6.orig/drivers/of/Kconfig	2008-05-01 13:19:51.000000000 +0200
+++ linux-2.6/drivers/of/Kconfig	2008-07-02 23:27:28.000000000 +0200
@@ -4,7 +4,7 @@ config OF_DEVICE
 
 config OF_GPIO
 	def_bool y
-	depends on OF && PPC_OF && HAVE_GPIO_LIB
+	depends on OF && PPC_OF && GPIOLIB
 	help
 	  OpenFirmware GPIO accessors
 
Index: linux-2.6/include/asm-generic/gpio.h
===================================================================
--- linux-2.6.orig/include/asm-generic/gpio.h	2008-06-13 13:13:45.000000000 +0200
+++ linux-2.6/include/asm-generic/gpio.h	2008-07-02 23:32:19.000000000 +0200
@@ -3,7 +3,7 @@
 
 #include <linux/types.h>
 
-#ifdef CONFIG_HAVE_GPIO_LIB
+#ifdef CONFIG_GPIOLIB
 
 #include <linux/compiler.h>
 
Index: linux-2.6/include/asm-mips/mach-generic/gpio.h
===================================================================
--- linux-2.6.orig/include/asm-mips/mach-generic/gpio.h	2008-05-01 13:19:58.000000000 +0200
+++ linux-2.6/include/asm-mips/mach-generic/gpio.h	2008-07-02 23:31:17.000000000 +0200
@@ -1,7 +1,7 @@
 #ifndef __ASM_MACH_GENERIC_GPIO_H
 #define __ASM_MACH_GENERIC_GPIO_H
 
-#ifdef CONFIG_HAVE_GPIO_LIB
+#ifdef CONFIG_GPIOLIB
 #define gpio_get_value	__gpio_get_value
 #define gpio_set_value	__gpio_set_value
 #define gpio_cansleep	__gpio_cansleep
Index: linux-2.6/include/asm-powerpc/gpio.h
===================================================================
--- linux-2.6.orig/include/asm-powerpc/gpio.h	2008-05-01 13:19:58.000000000 +0200
+++ linux-2.6/include/asm-powerpc/gpio.h	2008-07-02 23:31:58.000000000 +0200
@@ -17,7 +17,7 @@
 #include <linux/errno.h>
 #include <asm-generic/gpio.h>
 
-#ifdef CONFIG_HAVE_GPIO_LIB
+#ifdef CONFIG_GPIOLIB
 
 /*
  * We don't (yet) implement inlined/rapid versions for on-chip gpios.
@@ -51,6 +51,6 @@ static inline int irq_to_gpio(unsigned i
 	return -EINVAL;
 }
 
-#endif /* CONFIG_HAVE_GPIO_LIB */
+#endif /* CONFIG_GPIOLIB */
 
 #endif /* __ASM_POWERPC_GPIO_H */


-- 
Greetings Michael.

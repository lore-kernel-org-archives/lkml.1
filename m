Return-Path: <linux-kernel-owner+w=401wt.eu-S1760072AbYGAXH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072AbYGAXH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 19:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758154AbYGAXGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 19:06:37 -0400
Received: from bu3sch.de ([62.75.166.246]:51014 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757606AbYGAXGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 19:06:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH RFC] x86: Add user configurable GPIO-lib support
Date: Wed, 2 Jul 2008 01:05:52 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel <linux-kernel@vger.kernel.org>,
       florian.fainelli@telecomint.eu,
       the arch/x86 maintainers <x86@kernel.org>, david-b@pacbell.net
References: <200807011249.40551.mb@bu3sch.de> <200807011313.40598.mb@bu3sch.de> <20080701111918.GA11809@elte.hu>
In-Reply-To: <20080701111918.GA11809@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807020105.52607.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2008 13:19:18 Ingo Molnar wrote:
> 
> * Michael Buesch <mb@bu3sch.de> wrote:
> 
> > > ... and thus perhaps your GPIO_USERSELECTION patch should move into 
> > > drivers/ and be generally accessible, not special to x86?
> > 
> > Yes I'd really like to move it there, too. But currently that clashes 
> > with architectures like MIPS, some PPC flavours and probably others 
> > that implement their own GPIO API. We should have an 
> > ARCH_IMPLEMENT_GPIO or whatever, but currently we don't seem to have 
> > that.
> > 
> > So well. If it's desired to put the user selection into drivers/gpio 
> > (which I'd really prefer), I can try to make a patch that adds 
> > ARCH_IMPLEMENT_GPIO to every arch that implements their own GPIO API 
> > and make GPIO_USERSELECTION depend on !ARCH_IMPLEMENT_GPIO.
> 
> or we could try it the other way around: stick 
> ARCH_ALLOWS_TRULY_GENERAL_PURPOSE_INPUT_OUTPUT (note: please use a 
> better name ;-) into x86, add the user text to drivers/ and let other 
> architectures enable it too?
> 
> That way your commits would still be pretty focused (you'd avoid having 
> to touch a lot of architectures) and it would still work all across the 
> spectrum.

Something like this, perhaps. Not 100% finished, yet (see the FIXME).


Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig	2008-07-01 12:45:23.000000000 +0200
+++ linux-2.6/arch/x86/Kconfig	2008-07-02 00:21:05.000000000 +0200
@@ -25,6 +25,7 @@ config X86
 	select HAVE_KRETPROBES
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
+	select ARCH_WANT_OPTIONAL_GPIOLIB if !X86_RDC321X
 
 config ARCH_DEFCONFIG
 	string
Index: linux-2.6/include/asm-x86/gpio.h
===================================================================
--- linux-2.6.orig/include/asm-x86/gpio.h	2008-07-01 12:45:23.000000000 +0200
+++ linux-2.6/include/asm-x86/gpio.h	2008-07-02 00:00:34.000000000 +0200
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
+#ifdef CONFIG_HAVE_GPIO_LIB
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
+#endif /* CONFIG_HAVE_GPIO_LIB */
+
+#endif /* CONFIG_X86_RDC321X */
 
 #endif /* _ASM_I386_GPIO_H */
Index: linux-2.6/arch/powerpc/Kconfig
===================================================================
--- linux-2.6.orig/arch/powerpc/Kconfig	2008-07-01 12:45:23.000000000 +0200
+++ linux-2.6/arch/powerpc/Kconfig	2008-07-02 01:01:26.000000000 +0200
@@ -110,6 +110,7 @@ config PPC
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_LMB
+	select ARCH_WANT_OPTIONAL_GPIOLIB
 
 config EARLY_PRINTK
 	bool
Index: linux-2.6/drivers/gpio/Kconfig
===================================================================
--- linux-2.6.orig/drivers/gpio/Kconfig	2008-07-01 12:45:23.000000000 +0200
+++ linux-2.6/drivers/gpio/Kconfig	2008-07-02 01:00:16.000000000 +0200
@@ -2,15 +2,39 @@
 # GPIO infrastructure and expanders
 #
 
+config ARCH_WANT_OPTIONAL_GPIOLIB
+	bool
+	help
+	  Select this config option from the architecture Kconfig, if
+	  it is possible to use gpiolib on the architecture, but let the
+	  user decide whether to actually build it or not.
+	  Select this instead of HAVE_GPIO_LIB, if your architecture does
+	  not depend on GPIOs being available, but rather let the user
+	  decide whether he needs it or not.
+
+#FIXME: Probably rename the following to ARCH_REQUIRE_GPIOLIB
 config HAVE_GPIO_LIB
 	bool
+	select GPIOLIB
 	help
 	  Platforms select gpiolib if they use this infrastructure
 	  for all their GPIOs, usually starting with ones integrated
 	  into SOC processors.
+	  Selecting this from the architecture code will cause the gpiolib
+	  code to always get built in.
+
+menuconfig GPIOLIB
+	bool "GPIO Support"
+	depends on ARCH_WANT_OPTIONAL_GPIOLIB || HAVE_GPIO_LIB
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
@@ -70,4 +94,4 @@ config GPIO_MCP23S08
 	  SPI driver for Microchip MCP23S08 I/O expander.  This provides
 	  a GPIO interface supporting inputs and outputs.
 
-endmenu
+endif
Index: linux-2.6/drivers/gpio/Makefile
===================================================================
--- linux-2.6.orig/drivers/gpio/Makefile	2008-07-01 12:45:23.000000000 +0200
+++ linux-2.6/drivers/gpio/Makefile	2008-07-02 00:45:11.000000000 +0200
@@ -2,7 +2,7 @@
 
 ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
-obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpiolib.o
+obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o



-- 
Greetings Michael.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbYGAKv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbYGAKv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 06:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYGAKvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 06:51:18 -0400
Received: from bu3sch.de ([62.75.166.246]:38106 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbYGAKvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 06:51:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: [PATCH RFC] x86: Add user configurable GPIO-lib support
Date: Tue, 1 Jul 2008 12:49:40 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807011249.40551.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So this adds user-configurable GPIO support through gpiolib
on subarchitectures that do not implement a GPIO implementation, yet.
Currently that's everything except X86_RDC321X.

The advantage of this is to make it possible to use generic PCI (or
other bus) GPIO extention cards in standard PCs through the standard
GPIO API.

If another subarch implements its own GPIO, it needs to add
itself as an inverted dependency to GPIO_USERSELECTION to make
sure the user does not enable two GPIO API implementations.

About the asm-x86/gpio.h:
I'm not sure what this <gpio.h> include currently is.
Can somebody explain that to me? Where is this supposed
to include a gpio.h file from?


What's your opinion on this?


Index: wireless-testing/arch/x86/Kconfig
===================================================================
--- wireless-testing.orig/arch/x86/Kconfig	2008-06-30 23:00:29.000000000 +0200
+++ wireless-testing/arch/x86/Kconfig	2008-06-30 23:07:04.000000000 +0200
@@ -1675,6 +1675,19 @@
 
 source "drivers/pci/hotplug/Kconfig"
 
+config GPIO_USERSELECTION
+	bool "Enable generic GPIO support through gpiolib"
+	depends on !X86_RDC321X
+	select GENERIC_GPIO
+	select HAVE_GPIO_LIB
+	help
+	  This enables GPIO support through the generic GPIO library.
+	  You only need to enable this, if you also want to enable
+	  one or more of the GPIO expansion card drivers in
+	  "Device Drivers/GPIO Support".
+
+	  If unsure, say N.
+
 endmenu
 
 
Index: wireless-testing/include/asm-x86/gpio.h
===================================================================
--- wireless-testing.orig/include/asm-x86/gpio.h	2008-06-30 23:28:55.000000000 +0200
+++ wireless-testing/include/asm-x86/gpio.h	2008-06-30 23:36:20.000000000 +0200
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

-- 
Greetings Michael.

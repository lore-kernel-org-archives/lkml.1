Return-Path: <linux-kernel-owner+w=401wt.eu-S934544AbXJRT1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934544AbXJRT1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 15:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934041AbXJRT1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 15:27:12 -0400
Received: from mail.queued.net ([207.210.101.209]:1624 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934304AbXJRT1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 15:27:10 -0400
Date: Thu, 18 Oct 2007 15:27:08 -0400
From: Andres Salomon <dilinger@queued.net>
To: linux-kernel@vger.kernel.org
Cc: Jordan Crouse <jordan.crouse@amd.com>, info-linux@geode.amd.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] GEODE: update GPIO API to support setting multiple GPIOs at
 once
Message-ID: <20071018152708.215c9da1@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The existing Geode GPIO API only allows for updating one GPIO at once.  There
are instances where users want to update multiple GPIOs at once.  With the
current API, they are given two choices; either ignore the GPIO API:

      outl(0xc000, gpio_base + GPIO_OUTPUT_VAL);
      outl(0xc000, gpio_base + GPIO_OUTPUT_ENABLE);

Alternatively, call each GPIO update separately:

      geode_gpio_set(14, GPIO_OUTPUT_VAL);
      geode_gpio_set(15, GPIO_OUTPUT_VAL);
      geode_gpio_set(14, GPIO_OUTPUT_ENABLE);
      geode_gpio_set(15, GPIO_OUTPUT_ENABLE);

Neither are desirable.  This patch changes the GPIO API to allow for setting
of multiple GPIOs at once; rather than being passed an integer, we pass
a bitmask and provide a translation function.  The above code would now
look like this:

      geode_gpio_set(geode_gpio(14)|geode_gpio(15), GPIO_OUTPUT_VAL);
      geode_gpio_set(geode_gpio(14)|geode_gpio(15), GPIO_OUTPUT_ENABLE);

Since there are no upstream users of the GPIO API yet (afaik), best to
change this now.  This also adds a bit of sanity checking; it is no
longer possible to use a GPIO above 28.


Note the semantics of geode_gpio_isset() have changed:
geode_gpio_isset(geode_gpio(3)|geode_gpio(4), ...)
will only return true iff both GPIOs are set. 

Signed-off-by: Andres Salomon <dilinger@debian.org>

diff --git a/arch/x86/kernel/geode_32.c b/arch/x86/kernel/geode_32.c
index f12d8c5..9c7f7d3 100644
--- a/arch/x86/kernel/geode_32.c
+++ b/arch/x86/kernel/geode_32.c
@@ -1,6 +1,7 @@
 /*
  * AMD Geode southbridge support code
  * Copyright (C) 2006, Advanced Micro Devices, Inc.
+ * Copyright (C) 2007, Andres Salomon <dilinger@debian.org>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of version 2 of the GNU General Public License
@@ -51,45 +52,62 @@ EXPORT_SYMBOL_GPL(geode_get_dev_base);
 
 /* === GPIO API === */
 
-void geode_gpio_set(unsigned int gpio, unsigned int reg)
+void geode_gpio_set(u32 gpio, unsigned int reg)
 {
 	u32 base = geode_get_dev_base(GEODE_DEV_GPIO);
 
 	if (!base)
 		return;
 
-	if (gpio < 16)
-		outl(1 << gpio, base + reg);
-	else
-		outl(1 << (gpio - 16), base + 0x80 + reg);
+	/* low bank register */
+	if (gpio & 0xFFFF)
+		outl(gpio & 0xFFFF, base + reg);
+	/* high bank register */
+	gpio >>= 16;
+	if (gpio)
+		outl(gpio, base + 0x80 + reg);
 }
 EXPORT_SYMBOL_GPL(geode_gpio_set);
 
-void geode_gpio_clear(unsigned int gpio, unsigned int reg)
+void geode_gpio_clear(u32 gpio, unsigned int reg)
 {
 	u32 base = geode_get_dev_base(GEODE_DEV_GPIO);
 
 	if (!base)
 		return;
 
-	if (gpio < 16)
-		outl(1 << (gpio + 16), base + reg);
-	else
-		outl(1 << gpio, base + 0x80 + reg);
+	/* low bank register */
+	if (gpio & 0xFFFF)
+		outl((gpio & 0xFFFF) << 16, base + reg);
+	/* high bank register */
+	gpio &= (0xFFFF << 16);
+	if (gpio)
+		outl(gpio, base + 0x80 + reg);
 }
 EXPORT_SYMBOL_GPL(geode_gpio_clear);
 
-int geode_gpio_isset(unsigned int gpio, unsigned int reg)
+int geode_gpio_isset(u32 gpio, unsigned int reg)
 {
 	u32 base = geode_get_dev_base(GEODE_DEV_GPIO);
+	u32 val;
 
 	if (!base)
 		return 0;
 
-	if (gpio < 16)
-		return (inl(base + reg) & (1 << gpio)) ? 1 : 0;
-	else
-		return (inl(base + 0x80 + reg) & (1 << (gpio - 16))) ? 1 : 0;
+	/* low bank register */
+	if (gpio & 0xFFFF) {
+		val = inl(base + reg) & (gpio & 0xFFFF);
+		if ((gpio & 0xFFFF) == val)
+			return 1;
+	}
+	/* high bank register */
+	gpio >>= 16;
+	if (gpio) {
+		val = inl(base + 0x80 + reg) & gpio;
+		if (gpio == val)
+			return 1;
+	}
+	return 0;
 }
 EXPORT_SYMBOL_GPL(geode_gpio_isset);
 
diff --git a/include/asm-x86/geode.h b/include/asm-x86/geode.h
index d948988..593d3ec 100644
--- a/include/asm-x86/geode.h
+++ b/include/asm-x86/geode.h
@@ -119,9 +119,15 @@ extern int geode_get_dev_base(unsigned int dev);
 #define GPIO_MAP_Z		0xE8
 #define GPIO_MAP_W		0xEC
 
-extern void geode_gpio_set(unsigned int, unsigned int);
-extern void geode_gpio_clear(unsigned int, unsigned int);
-extern int geode_gpio_isset(unsigned int, unsigned int);
+static inline u32 geode_gpio(unsigned int nr)
+{
+	BUG_ON(nr > 28);
+	return 1 << nr;
+}
+
+extern void geode_gpio_set(u32, unsigned int);
+extern void geode_gpio_clear(u32, unsigned int);
+extern int geode_gpio_isset(u32, unsigned int);
 extern void geode_gpio_setup_event(unsigned int, int, int);
 extern void geode_gpio_set_irq(unsigned int, unsigned int);
 

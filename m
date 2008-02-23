Return-Path: <linux-kernel-owner+w=401wt.eu-S932553AbYBWBPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553AbYBWBPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 20:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYBWBPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 20:15:20 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:48607 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751812AbYBWBPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 20:15:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bKmvc2MQSv5v79ZWWW7VVDDhQZFFowvmC4jrBiVyhj9aEmWDjdgeW+0f81BtBdk3BDdPn2i4KvVwsicvw0CPbsfZAfWgNfSQ+YvcN2cfDRSZTYeuuCTbK/Dzi2Cg/vUSAyF6xHQlqhtatnSFhsAZQDR2n1HZekCtPt0W1j0R9eQ=  ;
X-YMail-OSG: RUmg7dUVM1nvy688FZ9zfz4L5KPWnNLpE7msI2S2KBu5HQ_7H0lOm16KNYSMUmQCnutBHE9tRA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.25-rc2-git] gpio:  <linux/gpio.h> and "no GPIO support here" stubs
Date: Fri, 22 Feb 2008 17:12:17 -0800
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, cbouatmailru@gmail.com,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Florian Fainelli <florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802221712.17815.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a <linux/gpio.h> defining fail/warn stubs for GPIO calls on platforms
that don't support the GPIO programming interface.  That includes the
arch-specific implementation glue otherwise.

This facilitates a new model for GPIO usage:  drivers that can use GPIOs
if they're available, but don't require them.  One example of such a
driver is NAND driver for various FreeScale chips.  On platforms update
with GPIO support, they can be used instead of a worst-case delay to
verify that the BUSY signal is off.

(Also includes a couple minor unrelated doc updates.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Please include before 2.6.25-final ...

 Documentation/gpio.txt |   16 ++++++--
 include/linux/gpio.h   |   95 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 107 insertions(+), 4 deletions(-)

--- g26.orig/Documentation/gpio.txt	2008-02-22 16:20:36.000000000 -0800
+++ g26/Documentation/gpio.txt	2008-02-22 17:02:00.000000000 -0800
@@ -2,6 +2,9 @@ GPIO Interfaces
 
 This provides an overview of GPIO access conventions on Linux.
 
+These calls use the gpio_* naming prefix.  No other calls should use that
+prefix, or the related __gpio_* prefix.
+
 
 What is a GPIO?
 ===============
@@ -69,11 +72,13 @@ in this document, but drivers acting as 
 not care how it's implemented.)
 
 That said, if the convention is supported on their platform, drivers should
-use it when possible.  Platforms should declare GENERIC_GPIO support in
-Kconfig (boolean true), which multi-platform drivers can depend on when
-using the include file:
+use it when possible.  Platforms must declare GENERIC_GPIO support in their
+Kconfig (boolean true), and provide an <asm/gpio.h> file.  Drivers that can't
+work without standard GPIO calls should have Kconfig entries which depend
+on GENERIC_GPIO.  The GPIO calls are available, either as "real code" or as
+optimized-away stubs, when drivers use the include file:
 
-	#include <asm/gpio.h>
+	#include <linux/gpio.h>
 
 If you stick to this convention then it'll be easier for other developers to
 see what your code is doing, and help maintain it.
@@ -326,6 +331,9 @@ pulldowns integrated on some platforms. 
 or support them in the same way; and any given board might use external
 pullups (or pulldowns) so that the on-chip ones should not be used.
 (When a circuit needs 5 kOhm, on-chip 100 kOhm resistors won't do.)
+Likewise drive strength (2 mA vs 20 mA) and voltage (1.8V vs 3.3V) is a
+platform-specific issue, as are models like (not) having a one-to-one
+correspondence between configurable pins and GPIOs.
 
 There are other system-specific mechanisms that are not specified here,
 like the aforementioned options for input de-glitching and wire-OR output.
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ g26/include/linux/gpio.h	2008-02-22 17:05:48.000000000 -0800
@@ -0,0 +1,95 @@
+#ifndef __LINUX_GPIO_H
+#define __LINUX_GPIO_H
+
+/* see Documentation/gpio.txt */
+
+#ifdef CONFIG_GENERIC_GPIO
+#include <asm/gpio.h>
+
+#else
+
+/*
+ * Some platforms don't support the GPIO programming interface.
+ *
+ * In case some driver uses it anyway (it should normally have
+ * depended on GENERIC_GPIO), these routines help the compiler
+ * optimize out much GPIO-related code ... or trigger a runtime
+ * warning when something is wrongly called.
+ */
+
+static inline int gpio_is_valid(int number)
+{
+	return 0;
+}
+
+static inline int gpio_request(unsigned gpio, const char *label)
+{
+	return -ENOSYS;
+}
+
+static inline void gpio_free(unsigned gpio)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+}
+
+static inline int gpio_direction_input(unsigned gpio)
+{
+	return -ENOSYS;
+}
+
+static inline int gpio_direction_output(unsigned gpio, int value)
+{
+	return -ENOSYS;
+}
+
+static inline int gpio_get_value(unsigned gpio)
+{
+	/* GPIO can never have been requested or set as {in,out}put */
+	WARN_ON(1);
+	return 0;
+}
+
+static inline void gpio_set_value(unsigned gpio, int value)
+{
+	/* GPIO can never have been requested or set as output */
+	WARN_ON(1);
+}
+
+static inline int gpio_cansleep(unsigned gpio)
+{
+	/* GPIO can never have been requested or set as {in,out}put */
+	WARN_ON(1);
+	return 0;
+}
+
+static inline int gpio_get_value_cansleep(unsigned gpio)
+{
+	/* GPIO can never have been requested or set as {in,out}put */
+	WARN_ON(1);
+	return 0;
+}
+
+static inline void gpio_set_value_cansleep(unsigned gpio, int value)
+{
+	/* GPIO can never have been requested or set as output */
+	WARN_ON(1);
+}
+
+static inline int gpio_to_irq(unsigned gpio)
+{
+	/* GPIO can never have been requested or set as input */
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+static inline int irq_to_gpio(unsigned irq)
+{
+	/* irq can never have been returned from gpio_to_irq() */
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+#endif
+
+#endif /* __LINUX_GPIO_H */

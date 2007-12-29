Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbXL2EFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbXL2EFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 23:05:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbXL2EEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 23:04:38 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:21904 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754106AbXL2EEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 23:04:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=xzjV8KKyDm2tFNI2mmfVdsDNZ/ZZ+mZx+eCqhjWwNEdzkIjuZ4WStVCUfbiykkTGHeBBfp4J+f414YSe4nD8hnAledYuOJI03UznTL+eTYjOtA7cLXbg9C0bs/X6Rc3Y/2QDVKiuvn2ppZ5JBFqQbKzp0b4Q4avPw1syjNZ6Q/o=  ;
X-YMail-OSG: WpFXZUgVM1nvI5wTamkqKgz.wKpdqC0VSarybNADqBxOFuTqkYU5T7jmA7V2qMheZcQalVcHVg--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.24-rc6-mm 1/9] gpiolib: add drivers/gpio directory
Date: Fri, 28 Dec 2007 19:53:19 -0800
User-Agent: KMail/1.9.6
Cc: Jean Delvare <khali@linux-fr.org>, eric miao <eric.y.miao@gmail.com>
References: <200712281927.32575.david-b@pacbell.net>
In-Reply-To: <200712281927.32575.david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712281953.20103.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Add an empty drivers/gpio directory for gpiolib infrastructure
and GPIO expanders.  It is populated by subsequent patches.

This won't be the only place to hold such gpio_chip code.  Many
external chips add a few GPIOs as secondary functionality (such
as MFD drivers) and platform code frequently needs to closely
integrate GPIO and IRQ support.

This is placed *early* in the build/link sequence since it's common
for other drivers to depend on GPIOs to do their work, so they must
be initialized early in the device_initcall() sequence.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Cc: Eric Miao <eric.miao@marvell.com>
---
 arch/arm/Kconfig      |    2 ++
 drivers/Kconfig       |    2 ++
 drivers/Makefile      |    1 +
 drivers/gpio/Kconfig  |   32 ++++++++++++++++++++++++++++++++
 drivers/gpio/Makefile |    6 ++++++
 5 files changed, 43 insertions(+)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1040,6 +1040,8 @@ source "drivers/i2c/Kconfig"
 
 source "drivers/spi/Kconfig"
 
+source "drivers/gpio/Kconfig"
+
 source "drivers/w1/Kconfig"
 
 source "drivers/power/Kconfig"
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -52,6 +52,8 @@ source "drivers/i2c/Kconfig"
 
 source "drivers/spi/Kconfig"
 
+source "drivers/gpio/Kconfig"
+
 source "drivers/w1/Kconfig"
 
 source "drivers/power/Kconfig"
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -5,6 +5,7 @@
 # Rewritten to use lists instead of if-statements.
 #
 
+obj-$(CONFIG_GPIO_LIB)		+= gpio/
 obj-$(CONFIG_PCI)		+= pci/
 obj-$(CONFIG_PARISC)		+= parisc/
 obj-$(CONFIG_RAPIDIO)		+= rapidio/
--- /dev/null
+++ b/drivers/gpio/Kconfig
@@ -0,0 +1,32 @@
+#
+# GPIO infrastructure and expanders
+#
+
+config GPIO_LIB
+	bool
+	help
+	  Platforms select gpiolib if they use this infrastructure
+	  for all their GPIOs, usually starting with ones integrated
+	  into SOC processors.
+
+menu "GPIO Support"
+	depends on GPIO_LIB
+
+config DEBUG_GPIO
+	bool "Debug GPIO calls"
+	depends on DEBUG_KERNEL
+	help
+	  Say Y here to add some extra checks and diagnostics to GPIO calls.
+	  The checks help ensure that GPIOs have been properly initialized
+	  before they are used and that sleeping calls aren not made from
+	  nonsleeping contexts.  They can make bitbanged serial protocols
+	  slower.  The diagnostics help catch the type of setup errors
+	  that are most common when setting up new platforms or boards.
+
+# put expanders in the right section, in alphabetical order
+
+comment "I2C GPIO expanders:"
+
+comment "SPI GPIO expanders:"
+
+endmenu
--- /dev/null
+++ b/drivers/gpio/Makefile
@@ -0,0 +1,6 @@
+# gpio support: dedicated expander chips, etc
+
+ifeq ($(CONFIG_DEBUG_GPIO),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
+

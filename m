Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbYAEUQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbYAEUQT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 15:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbYAEUQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 15:16:06 -0500
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:36789 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755534AbYAEUQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 15:16:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ApiryNK7AtalqsOSvXxAoxWIRajk3Ak/NY6lR24+Dr1FOY7Fg0qiddo3VLCiyUjriMWQVEhg43cH6LbrPZRIHBsQmC8URlL4r5y/ymDaJuwibtWjp/CDlM898QB/TukN/EIwSNIdJzPlFd4zRdTqqJNswi9hHfB9f6LR5Tg+ZbU=  ;
X-YMail-OSG: qV.7yzoVM1krOElK1LDz3Hhq0hzyvyczHWXcQFeG7yIRz42.2FXlWF2MJkMYk_CA_.mW3q5yPA--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.24-rc6-mm 1/9] gpiolib: add drivers/gpio directory
Date: Sat, 5 Jan 2008 12:07:04 -0800
User-Agent: KMail/1.9.6
Cc: Jean Delvare <khali@linux-fr.org>, eric miao <eric.y.miao@gmail.com>
References: <200712281927.32575.david-b@pacbell.net> <200712281953.20103.david-b@pacbell.net>
In-Reply-To: <200712281953.20103.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801051207.05338.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Add an empty drivers/gpio directory for gpiolib infrastructure
and GPIO expanders.  It will be populated by later patches.

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
Incorporates cleanup as suggested by Sam Ravnborg:  use HAVE_*
and a new idiom for adding "-DDEBUG".

 arch/arm/Kconfig      |    2 ++
 drivers/Kconfig       |    2 ++
 drivers/Makefile      |    1 +
 drivers/gpio/Kconfig  |   32 ++++++++++++++++++++++++++++++++
 drivers/gpio/Makefile |    4 ++++
 5 files changed, 41 insertions(+)

--- at91.orig/arch/arm/Kconfig	2008-01-05 12:00:45.000000000 -0800
+++ at91/arch/arm/Kconfig	2008-01-05 12:00:47.000000000 -0800
@@ -1040,6 +1040,8 @@ source "drivers/i2c/Kconfig"
 
 source "drivers/spi/Kconfig"
 
+source "drivers/gpio/Kconfig"
+
 source "drivers/w1/Kconfig"
 
 source "drivers/power/Kconfig"
--- at91.orig/drivers/Kconfig	2008-01-05 12:00:45.000000000 -0800
+++ at91/drivers/Kconfig	2008-01-05 12:00:47.000000000 -0800
@@ -52,6 +52,8 @@ source "drivers/i2c/Kconfig"
 
 source "drivers/spi/Kconfig"
 
+source "drivers/gpio/Kconfig"
+
 source "drivers/w1/Kconfig"
 
 source "drivers/power/Kconfig"
--- at91.orig/drivers/Makefile	2008-01-05 12:00:45.000000000 -0800
+++ at91/drivers/Makefile	2008-01-05 12:00:47.000000000 -0800
@@ -5,6 +5,7 @@
 # Rewritten to use lists instead of if-statements.
 #
 
+obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpio/
 obj-$(CONFIG_PCI)		+= pci/
 obj-$(CONFIG_PARISC)		+= parisc/
 obj-$(CONFIG_RAPIDIO)		+= rapidio/
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ at91/drivers/gpio/Kconfig	2008-01-05 12:00:47.000000000 -0800
@@ -0,0 +1,32 @@
+#
+# GPIO infrastructure and expanders
+#
+
+config HAVE_GPIO_LIB
+	bool
+	help
+	  Platforms select gpiolib if they use this infrastructure
+	  for all their GPIOs, usually starting with ones integrated
+	  into SOC processors.
+
+menu "GPIO Support"
+	depends on HAVE_GPIO_LIB
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
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ at91/drivers/gpio/Makefile	2008-01-05 12:00:47.000000000 -0800
@@ -0,0 +1,4 @@
+# gpio support: dedicated expander chips, etc
+
+ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
+

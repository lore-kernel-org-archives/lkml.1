Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbXL2SgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbXL2SgH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 13:36:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbXL2Sfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 13:35:55 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:29217 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755296AbXL2Sfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 13:35:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hoqt9orZDgNBq4Qz4wNMkNyQAwjU4LVmAiz6HLh619L38aydW+UJwl0p3+lCyF4jzLHB12wJwkxkpYc1i4XYtZUp/frIrwxJneYbgUTDsXs5dso7bb+bhJzeYXqzzUDocqt1fWfYrZFOiaj1lGk76P2Qq4ewBVCkznIIXwtdJ0M=  ;
X-YMail-OSG: tmoZXgAVM1mkL7CAMVjenQUDrsN2gokjhLIpPboIJa7WGduPh_LehWSemMjW7UVflOFW.r2oRg--
From: David Brownell <david-b@pacbell.net>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 2.6.24-rc6-mm 1/9] gpiolib: add drivers/gpio directory
Date: Sat, 29 Dec 2007 10:19:39 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>, eric miao <eric.y.miao@gmail.com>
References: <200712281927.32575.david-b@pacbell.net> <200712281953.20103.david-b@pacbell.net> <20071229065837.GB16569@uranus.ravnborg.org>
In-Reply-To: <20071229065837.GB16569@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712291019.39969.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 December 2007, Sam Ravnborg wrote:
> kconfig symbols that are "select" targets should be named "HAVE_" so in
> this case you could use HAVE_GPIO_LIB.
> This is by convention only but introduced to make it visible that this is
> a config symbol supposed to be selected.

Not widely adopted yet, but of course such things take time.


> Then on top of that the HAVE_ symbols should not have any dependencies
> so we avoid that "select" selects a symbol where the dependencies are
> not fulfilled.

That limitation of "select" still seems more buglike to me than
anything else, FWIW.  Not that it matters in this case.
 

> In your case you could just use
> obj-y += gpio/
> 
> in the Makefile and then there is no need to actually reference the
> kconfig symbol.

No, that just shifts the reference into the drivers/gpio Makefilee.

 
> ccflags-$(CONFIG_DEBUG_GPIO) := -DDEBUG

Another new convention.  :)

Pretty much like the folowing, then?

- Dave


==============	CUT HERE
Kbuild/Kconfig feedback from Sam Ravnborg, adopting new conventions:

  - HAVE_* for Kconfig symbols that platforms will select

  - Descend into drivers/gpio unconditionally, letting the Makefile
    sort out the differences

  - Use "ccflags-$(CONGIF_DEBUG_GPIO) += -DDEBUG" instead of
    those ugly (but traditional) conditionals.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 arch/arm/Kconfig           |    4 +-
 arch/avr32/Kconfig         |    2 +-
 drivers/Makefile           |    2 +-
 drivers/gpio/Kconfig       |    4 ++--
 drivers/gpio/Makefile      |   10 ++++------
 include/asm-generic/gpio.h |    2 +-
 6 files changed, 10 insertions(+), 12 deletions(-)

--- at91.orig/arch/arm/Kconfig
+++ at91/arch/arm/Kconfig
@@ -346,7 +346,7 @@ config ARCH_PXA
 	select GENERIC_GPIO
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
-	select GPIO_LIB
+	select HAVE_GPIO_LIB
 	help
 	  Support for Intel/Marvell's PXA2xx/PXA3xx processor line.
 
--- at91.orig/arch/avr32/Kconfig
+++ at91/arch/avr32/Kconfig
@@ -80,7 +80,7 @@ config PLATFORM_AT32AP
 	select SUBARCH_AVR32B
 	select MMU
 	select PERFORMANCE_COUNTERS
-	select GPIO_LIB
+	select HAVE_GPIO_LIB
 
 choice
 	prompt "AVR32 CPU type"
--- at91.orig/drivers/Makefile
+++ at91/drivers/Makefile
@@ -5,7 +5,7 @@
 # Rewritten to use lists instead of if-statements.
 #
 
-obj-$(CONFIG_GPIO_LIB)		+= gpio/
+obj-y				+= gpio/
 obj-$(CONFIG_PCI)		+= pci/
 obj-$(CONFIG_PARISC)		+= parisc/
 obj-$(CONFIG_RAPIDIO)		+= rapidio/
--- at91.orig/drivers/gpio/Kconfig
+++ at91/drivers/gpio/Kconfig
@@ -2,7 +2,7 @@
 # GPIO infrastructure and expanders
 #
 
-config GPIO_LIB
+config HAVE_GPIO_LIB
 	bool
 	help
 	  Platforms select gpiolib if they use this infrastructure
@@ -10,7 +10,7 @@ config GPIO_LIB
 	  into SOC processors.
 
 menu "GPIO Support"
-	depends on GPIO_LIB
+	depends on HAVE_GPIO_LIB
 
 config DEBUG_GPIO
 	bool "Debug GPIO calls"
--- at91.orig/drivers/gpio/Makefile
+++ at91/drivers/gpio/Makefile
@@ -1,12 +1,10 @@
 # gpio support: dedicated expander chips, etc
 
+ccflags-$(CONGIF_DEBUG_GPIO)	+= -DDEBUG
+
+obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpiolib.o
+
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
 obj-$(CONFIG_GPIO_PCA9539)	+= pca9539.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 
-ifeq ($(CONFIG_DEBUG_GPIO),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
-
-obj-$(CONFIG_GPIO_LIB) += gpiolib.o
-
--- at91.orig/include/asm-generic/gpio.h
+++ at91/include/asm-generic/gpio.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_GENERIC_GPIO_H
 #define _ASM_GENERIC_GPIO_H
 
-#ifdef CONFIG_GPIO_LIB
+#ifdef CONFIG_HAVE_GPIO_LIB
 
 /* Platforms may implement their GPIO interface with library code,
  * at a small performance cost for non-inlined operations and some

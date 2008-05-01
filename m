Return-Path: <linux-kernel-owner+w=401wt.eu-S1761864AbYEAAwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761864AbYEAAwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYEAAwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 20:52:33 -0400
Received: from linux-m68k.xs4all.nl ([82.95.193.92]:48443 "EHLO
	scrub.xs4all.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753097AbYEAAwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 20:52:32 -0400
Date: Thu, 1 May 2008 02:51:47 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jan Engelhardt <jengelh@gmx.de>, Richard Purdie <rpurdie@rpsys.net>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch, -git] input: CONFIG_INPUT_APANEL build fix
In-Reply-To: <20080430224701.GC2629@anvil.corenet.prv>
Message-ID: <Pine.LNX.4.64.0805010213530.30555@scrub.home>
References: <20080430185345.GA27224@elte.hu> <20080430150021.ZZRA012@mailhub.coreip.homeip.net>
 <20080430202013.GB14164@elte.hu> <20080430163924.ZZRA012@mailhub.coreip.homeip.net>
 <20080430212029.GA28813@elte.hu> <20080430222645.GB2629@anvil.corenet.prv>
 <20080430223828.GA31878@elte.hu> <20080430224701.GC2629@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 30 Apr 2008, Dmitry Torokhov wrote:

> You still did not answer to the main question - do you think we should
> revert the commit that actually introduced breakage in the sense that
> anything depending on LEDS_CLASS should also add NEW_LEDS dependancy?
> That will take care of the problem (as far as LEDs are concerned) for
> _all_ subsystems and drivers at once.

Well, that would mean reverting the complete led subsystem, since the 
menuconfig patch you pointed at, isn't really the problem (did you 
actually try to revert that patch?).

Anyway, the actual issue are all the drivers that select LEDS_CLASS
without selecting NEW_LEDS.

The patch below fixes the dependency problem without adding a lot of new 
selects by using LEDS_CORE, which is selected by LEDS_CLASS/LEDS_TRIGGERS 
as needed.
I removed the comments as they were a little redundant and I removed the 
selects of NEW_LEDS as these are not needed anymore.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 drivers/hwmon/Kconfig      |    1 -
 drivers/input/misc/Kconfig |    1 -
 drivers/leds/Kconfig       |   16 +++++++---------
 drivers/leds/Makefile      |    2 +-
 drivers/macintosh/Kconfig  |    1 -
 drivers/misc/Kconfig       |    3 ---
 net/mac80211/Kconfig       |    1 -
 7 files changed, 8 insertions(+), 17 deletions(-)

Index: linux-2.6/drivers/leds/Kconfig
===================================================================
--- linux-2.6.orig/drivers/leds/Kconfig
+++ linux-2.6/drivers/leds/Kconfig
@@ -1,3 +1,6 @@
+config LEDS_CORE
+	def_bool n
+
 menuconfig NEW_LEDS
 	bool "LED Support"
 	help
@@ -7,16 +10,13 @@ menuconfig NEW_LEDS
 	  This is not related to standard keyboard LEDs which are controlled
 	  via the input system.
 
-if NEW_LEDS
-
 config LEDS_CLASS
-	tristate "LED Class Support"
+	tristate "LED Driver Support" if NEW_LEDS
+	select LEDS_CORE
 	help
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
 
-comment "LED drivers"
-
 config LEDS_ATMEL_PWM
 	tristate "LED Support using Atmel PWM outputs"
 	depends on LEDS_CLASS && ATMEL_PWM
@@ -147,10 +147,9 @@ config LEDS_CLEVO_MAIL
 	  To compile this driver as a module, choose M here: the
 	  module will be called leds-clevo-mail.
 
-comment "LED Triggers"
-
 config LEDS_TRIGGERS
-	bool "LED Trigger support"
+	bool "LED Trigger support" if NEW_LEDS
+	select LEDS_CORE
 	help
 	  This option enables trigger support for the leds class.
 	  These triggers allow kernel events to drive the LEDs and can
@@ -190,4 +189,3 @@ config LEDS_TRIGGER_DEFAULT_ON
 	  This allows LEDs to be initialised in the ON state.
 	  If unsure, say Y.
 
-endif # NEW_LEDS
Index: linux-2.6/drivers/leds/Makefile
===================================================================
--- linux-2.6.orig/drivers/leds/Makefile
+++ linux-2.6/drivers/leds/Makefile
@@ -1,6 +1,6 @@
 
 # LED Core
-obj-$(CONFIG_NEW_LEDS)			+= led-core.o
+obj-$(CONFIG_LEDS_CORE)			+= led-core.o
 obj-$(CONFIG_LEDS_CLASS)		+= led-class.o
 obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
 
Index: linux-2.6/drivers/hwmon/Kconfig
===================================================================
--- linux-2.6.orig/drivers/hwmon/Kconfig
+++ linux-2.6/drivers/hwmon/Kconfig
@@ -763,7 +763,6 @@ config SENSORS_HDAPS
 config SENSORS_APPLESMC
 	tristate "Apple SMC (Motion sensor, light sensor, keyboard backlight)"
 	depends on INPUT && X86
-	select NEW_LEDS
 	select LEDS_CLASS
 	select INPUT_POLLDEV
 	default n
Index: linux-2.6/drivers/input/misc/Kconfig
===================================================================
--- linux-2.6.orig/drivers/input/misc/Kconfig
+++ linux-2.6/drivers/input/misc/Kconfig
@@ -81,7 +81,6 @@ config INPUT_WISTRON_BTNS
 	tristate "x86 Wistron laptop button interface"
 	depends on X86 && !X86_64
 	select INPUT_POLLDEV
-	select NEW_LEDS
 	select LEDS_CLASS
 	select CHECK_SIGNATURE
 	help
Index: linux-2.6/drivers/macintosh/Kconfig
===================================================================
--- linux-2.6.orig/drivers/macintosh/Kconfig
+++ linux-2.6/drivers/macintosh/Kconfig
@@ -90,7 +90,6 @@ config ADB_PMU
 config ADB_PMU_LED
 	bool "Support for the Power/iBook front LED"
 	depends on ADB_PMU
-	select NEW_LEDS
 	select LEDS_CLASS
 	help
 	  Support the front LED on Power/iBooks as a generic LED that can
Index: linux-2.6/drivers/misc/Kconfig
===================================================================
--- linux-2.6.orig/drivers/misc/Kconfig
+++ linux-2.6/drivers/misc/Kconfig
@@ -140,7 +140,6 @@ config ACER_WMI
 	depends on EXPERIMENTAL
 	depends on ACPI
 	depends on LEDS_CLASS
-	depends on NEW_LEDS
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on SERIO_I8042
 	select ACPI_WMI
@@ -161,7 +160,6 @@ config ASUS_LAPTOP
         depends on ACPI
 	depends on EXPERIMENTAL && !ACPI_ASUS
 	depends on LEDS_CLASS
-	depends on NEW_LEDS
 	depends on BACKLIGHT_CLASS_DEVICE
         ---help---
 	  This is the new Linux driver for Asus laptops. It may also support some
@@ -248,7 +246,6 @@ config THINKPAD_ACPI
 	select HWMON
 	select NVRAM
 	select INPUT
-	select NEW_LEDS
 	select LEDS_CLASS
 	---help---
 	  This is a driver for the IBM and Lenovo ThinkPad laptops. It adds
Index: linux-2.6/net/mac80211/Kconfig
===================================================================
--- linux-2.6.orig/net/mac80211/Kconfig
+++ linux-2.6/net/mac80211/Kconfig
@@ -74,7 +74,6 @@ config MAC80211_MESH
 config MAC80211_LEDS
 	bool "Enable LED triggers"
 	depends on MAC80211
-	select NEW_LEDS
 	select LEDS_TRIGGERS
 	---help---
 	  This option enables a few LED triggers for different

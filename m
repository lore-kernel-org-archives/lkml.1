Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbYK1WJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbYK1WJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 17:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYK1WJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 17:09:24 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:57164 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbYK1WJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 17:09:23 -0500
Date: Fri, 28 Nov 2008 17:09:09 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH] x86: create drivers/x86/ from drivers/misc/
In-reply-to: <alpine.LFD.2.00.0811281702570.24773@localhost.localdomain>
X-X-Sender: lenb@localhost.localdomain
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Len Brown <len.brown@intel.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, x86@kernel.org,
       linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.2.00.0811281706540.24773@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081128213620.2ec593d4.sfr@canb.auug.org.au>
 <4930307C.30106@oracle.com> <20081129083550.3c23af37.sfr@canb.auug.org.au>
 <alpine.LFD.2.00.0811281649001.24773@localhost.localdomain>
 <alpine.LFD.2.00.0811281702570.24773@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9f57b53c82091c7af2f6082d83d6fc6542e36917 Mon Sep 17 00:00:00 2001
From: Len Brown <len.brown@intel.com>
Date: Fri, 21 Nov 2008 00:57:09 -0500
Subject: [PATCH] x86: create drivers/x86/ from drivers/misc/
Organization: Intel Open Source Technology Center

Move x86 platform specific drivers from drivers/misc/
to a new home under drivers/x86/.

The community has been maintaining x86 platform specific drivers
under /drivers/misc/ for a few years.  The oldest ones started
life under drivers/acpi, but got booted out because they are
generally vendor-specific extensions to ACPI, or simply
users of ACPI, rather than implementers of the ACPI spec.

The thing that they have in common is that they are
x86 vendor specific platform drivers.  So when asked,
Linus suggested we move them to drivers/x86.

Signed-off-by: Len Brown <len.brown@intel.com>
---
just the interesting part of the patch is included below, due to size.


 arch/x86/Kconfig                         |    2 +
 arch/x86/Makefile                        |    3 +
 drivers/misc/Kconfig                     |  280 ----------------------------
 drivers/misc/Makefile                    |   11 --
 drivers/x86/Kconfig                      |  290 ++++++++++++++++++++++++++++++
 drivers/x86/Makefile                     |   17 ++
 drivers/{misc => x86}/acer-wmi.c         |    0
 drivers/{misc => x86}/asus-laptop.c      |    0
 drivers/{misc => x86}/compal-laptop.c    |    0
 drivers/{misc => x86}/eeepc-laptop.c     |    0
 drivers/{misc => x86}/fujitsu-laptop.c   |    0
 drivers/{misc => x86}/hp-wmi.c           |    0
 drivers/{misc => x86}/intel_menlow.c     |    0
 drivers/{misc => x86}/msi-laptop.c       |    0
 drivers/{misc => x86}/panasonic-laptop.c |    0
 drivers/{misc => x86}/sony-laptop.c      |    0
 drivers/{misc => x86}/tc1100-wmi.c       |    0
 drivers/{misc => x86}/thinkpad_acpi.c    |    0
 18 files changed, 312 insertions(+), 291 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 93224b5..b89db1e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1904,6 +1904,8 @@ source "drivers/Kconfig"
 
 source "drivers/firmware/Kconfig"
 
+source "drivers/x86/Kconfig"
+
 source "fs/Kconfig"
 
 source "arch/x86/Kconfig.debug"
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index d1a47ad..a750519 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -171,6 +171,9 @@ ifeq ($(CONFIG_X86_32),y)
 drivers-$(CONFIG_FB) += arch/x86/video/
 endif
 
+# x86 platform-specific drivers
+drivers-y       += drivers/x86/
+
 ####
 # boot loader support. Several targets are kept for legacy purposes
 
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index fee7304..8b775b8 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -136,97 +136,6 @@ config TIFM_7XX1
           To compile this driver as a module, choose M here: the module will
 	  be called tifm_7xx1.
 
-config ACER_WMI
-        tristate "Acer WMI Laptop Extras (EXPERIMENTAL)"
-	depends on X86
-	depends on EXPERIMENTAL
-	depends on ACPI
-	depends on LEDS_CLASS
-	depends on NEW_LEDS
-	depends on BACKLIGHT_CLASS_DEVICE
-	depends on SERIO_I8042
-	depends on RFKILL
-	select ACPI_WMI
-	---help---
-	  This is a driver for newer Acer (and Wistron) laptops. It adds
-	  wireless radio and bluetooth control, and on some laptops,
-	  exposes the mail LED and LCD backlight.
-
-	  For more information about this driver see
-	  <file:Documentation/laptops/acer-wmi.txt>
-
-	  If you have an ACPI-WMI compatible Acer/ Wistron laptop, say Y or M
-	  here.
-
-config ASUS_LAPTOP
-        tristate "Asus Laptop Extras (EXPERIMENTAL)"
-        depends on X86
-        depends on ACPI
-	depends on EXPERIMENTAL && !ACPI_ASUS
-	depends on LEDS_CLASS
-	depends on NEW_LEDS
-	depends on BACKLIGHT_CLASS_DEVICE
-        ---help---
-	  This is the new Linux driver for Asus laptops. It may also support some
-	  MEDION, JVC or VICTOR laptops. It makes all the extra buttons generate
-	  standard ACPI events that go through /proc/acpi/events. It also adds
-	  support for video output switching, LCD backlight control, Bluetooth and
-	  Wlan control, and most importantly, allows you to blink those fancy LEDs.
-
-	  For more information and a userspace daemon for handling the extra
-	  buttons see <http://acpi4asus.sf.net/>.
-
-	  If you have an ACPI-compatible ASUS laptop, say Y or M here.
-
-config FUJITSU_LAPTOP
-        tristate "Fujitsu Laptop Extras"
-        depends on X86
-        depends on ACPI
-	depends on INPUT
-        depends on BACKLIGHT_CLASS_DEVICE
-        ---help---
-	  This is a driver for laptops built by Fujitsu:
-
-	    * P2xxx/P5xxx/S6xxx/S7xxx series Lifebooks
-	    * Possibly other Fujitsu laptop models
-	    * Tested with S6410 and S7020
-
-	  It adds support for LCD brightness control and some hotkeys.
-
-	  If you have a Fujitsu laptop, say Y or M here.
-
-config FUJITSU_LAPTOP_DEBUG
-	bool "Verbose debug mode for Fujitsu Laptop Extras"
-	depends on FUJITSU_LAPTOP
-	default n
-	---help---
-	  Enables extra debug output from the fujitsu extras driver, at the
-	  expense of a slight increase in driver size.
-
-	  If you are not sure, say N here.
-
-config TC1100_WMI
-	tristate "HP Compaq TC1100 Tablet WMI Extras (EXPERIMENTAL)"
-	depends on X86 && !X86_64
-	depends on EXPERIMENTAL
-	depends on ACPI
-	select ACPI_WMI
-	---help---
-	  This is a driver for the WMI extensions (wireless and bluetooth power
-	  control) of the HP Compaq TC1100 tablet.
-
-config HP_WMI
-       tristate "HP WMI extras"
-       depends on ACPI_WMI
-       depends on INPUT
-       depends on RFKILL
-       help
-         Say Y here if you want to support WMI-based hotkeys on HP laptops and
-	 to read data from WMI such as docking or ambient light sensor state.
-
-         To compile this driver as a module, choose M here: the module will
-         be called hp-wmi.
-
 config ICS932S401
 	tristate "Integrated Circuits ICS932S401"
 	depends on I2C && EXPERIMENTAL
@@ -237,170 +146,6 @@ config ICS932S401
 	  This driver can also be built as a module. If so, the module
 	  will be called ics932s401.
 
-config MSI_LAPTOP
-        tristate "MSI Laptop Extras"
-        depends on X86
-        depends on ACPI
-        depends on BACKLIGHT_CLASS_DEVICE
-        ---help---
-	  This is a driver for laptops built by MSI (MICRO-STAR
-	  INTERNATIONAL):
-
-	  MSI MegaBook S270 (MS-1013)
-	  Cytron/TCM/Medion/Tchibo MD96100/SAM2000
-
-	  It adds support for Bluetooth, WLAN and LCD brightness control.
-
-	  More information about this driver is available at
-	  <http://0pointer.de/lennart/tchibo.html>.
-
-	  If you have an MSI S270 laptop, say Y or M here.
-
-config PANASONIC_LAPTOP
-	tristate "Panasonic Laptop Extras"
-	depends on X86 && INPUT && ACPI
-        depends on BACKLIGHT_CLASS_DEVICE
-	---help---
-	  This driver adds support for access to backlight control and hotkeys
-	  on Panasonic Let's Note laptops.
-
-	  If you have a Panasonic Let's note laptop (such as the R1(N variant),
-	  R2, R3, R5, T2, W2 and Y2 series), say Y.
-
-config COMPAL_LAPTOP
-	tristate "Compal Laptop Extras"
-	depends on X86
-	depends on ACPI
-	depends on BACKLIGHT_CLASS_DEVICE
-	---help---
-	  This is a driver for laptops built by Compal:
-
-	  Compal FL90/IFL90
-	  Compal FL91/IFL91
-	  Compal FL92/JFL92
-	  Compal FT00/IFT00
-
-	  It adds support for Bluetooth, WLAN and LCD brightness control.
-
-	  If you have an Compal FL9x/IFL9x/FT00 laptop, say Y or M here.
-
-config SONY_LAPTOP
-	tristate "Sony Laptop Extras"
-	depends on X86 && ACPI
-	select BACKLIGHT_CLASS_DEVICE
-	depends on INPUT
-	  ---help---
-	  This mini-driver drives the SNC and SPIC devices present in the ACPI
-	  BIOS of the Sony Vaio laptops.
-
-	  It gives access to some extra laptop functionalities like Bluetooth,
-	  screen brightness control, Fn keys and allows powering on/off some
-	  devices.
-
-	  Read <file:Documentation/laptops/sony-laptop.txt> for more information.
-
-config SONYPI_COMPAT
-	bool "Sonypi compatibility"
-	depends on SONY_LAPTOP
-	  ---help---
-	  Build the sonypi driver compatibility code into the sony-laptop driver.
-
-config THINKPAD_ACPI
-	tristate "ThinkPad ACPI Laptop Extras"
-	depends on X86 && ACPI
-	select BACKLIGHT_LCD_SUPPORT
-	select BACKLIGHT_CLASS_DEVICE
-	select HWMON
-	select NVRAM
-	select INPUT
-	select NEW_LEDS
-	select LEDS_CLASS
-	select NET
-	select RFKILL
-	---help---
-	  This is a driver for the IBM and Lenovo ThinkPad laptops. It adds
-	  support for Fn-Fx key combinations, Bluetooth control, video
-	  output switching, ThinkLight control, UltraBay eject and more.
-	  For more information about this driver see
-	  <file:Documentation/laptops/thinkpad-acpi.txt> and
-	  <http://ibm-acpi.sf.net/> .
-
-	  This driver was formerly known as ibm-acpi.
-
-	  If you have an IBM or Lenovo ThinkPad laptop, say Y or M here.
-
-config THINKPAD_ACPI_DEBUG
-	bool "Verbose debug mode"
-	depends on THINKPAD_ACPI
-	default n
-	---help---
-	  Enables extra debugging information, at the expense of a slightly
-	  increase in driver size.
-
-	  If you are not sure, say N here.
-
-config THINKPAD_ACPI_DOCK
-	bool "Legacy Docking Station Support"
-	depends on THINKPAD_ACPI
-	depends on ACPI_DOCK=n
-	default n
-	---help---
-	  Allows the thinkpad_acpi driver to handle docking station events.
-	  This support was made obsolete by the generic ACPI docking station
-	  support (CONFIG_ACPI_DOCK).  It will allow locking and removing the
-	  laptop from the docking station, but will not properly connect PCI
-	  devices.
-
-	  If you are not sure, say N here.
-
-config THINKPAD_ACPI_BAY
-	bool "Legacy Removable Bay Support"
-	depends on THINKPAD_ACPI
-	default y
-	---help---
-	  Allows the thinkpad_acpi driver to handle removable bays.  It will
-	  electrically disable the device in the bay, and also generate
-	  notifications when the bay lever is ejected or inserted.
-
-	  If you are not sure, say Y here.
-
-config THINKPAD_ACPI_VIDEO
-	bool "Video output control support"
-	depends on THINKPAD_ACPI
-	default y
-	---help---
-	  Allows the thinkpad_acpi driver to provide an interface to control
-	  the various video output ports.
-
-	  This feature often won't work well, depending on ThinkPad model,
-	  display state, video output devices in use, whether there is a X
-	  server running, phase of the moon, and the current mood of
-	  Schroedinger's cat.  If you can use X.org's RandR to control
-	  your ThinkPad's video output ports instead of this feature,
-	  don't think twice: do it and say N here to save some memory.
-
-	  If you are not sure, say Y here.
-
-config THINKPAD_ACPI_HOTKEY_POLL
-	bool "Support NVRAM polling for hot keys"
-	depends on THINKPAD_ACPI
-	default y
-	---help---
-	  Some thinkpad models benefit from NVRAM polling to detect a few of
-	  the hot key press events.  If you know your ThinkPad model does not
-	  need to do NVRAM polling to support any of the hot keys you use,
-	  unselecting this option will save about 1kB of memory.
-
-	  ThinkPads T40 and newer, R52 and newer, and X31 and newer are
-	  unlikely to need NVRAM polling in their latest BIOS versions.
-
-	  NVRAM polling can detect at most the following keys: ThinkPad/Access
-	  IBM, Zoom, Switch Display (fn+F7), ThinkLight, Volume up/down/mute,
-	  Brightness up/down, Display Expand (fn+F8), Hibernate (fn+F12).
-
-	  If you are not sure, say Y here.  The driver enables polling only if
-	  it is strictly necessary to do so.
-
 config ATMEL_SSC
 	tristate "Device driver for Atmel SSC peripheral"
 	depends on AVR32 || ARCH_AT91
@@ -413,31 +158,6 @@ config ATMEL_SSC
 
 	  If unsure, say N.
 
-config INTEL_MENLOW
-	tristate "Thermal Management driver for Intel menlow platform"
-	depends on ACPI_THERMAL
-	select THERMAL
-	depends on X86
-	---help---
-	  ACPI thermal management enhancement driver on
-	  Intel Menlow platform.
-
-	  If unsure, say N.
-
-config EEEPC_LAPTOP
-	tristate "Eee PC Hotkey Driver (EXPERIMENTAL)"
-	depends on X86
-	depends on ACPI
-	depends on BACKLIGHT_CLASS_DEVICE
-	depends on HWMON
-	depends on EXPERIMENTAL
-	depends on RFKILL
-	---help---
-	  This driver supports the Fn-Fx keys on Eee PC laptops.
-	  It also adds the ability to switch camera/wlan on/off.
-
-	  If you have an Eee PC laptop, say Y or M here.
-
 config ENCLOSURE_SERVICES
 	tristate "Enclosure Services"
 	default n
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 817f7f5..4a62847 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -5,15 +5,9 @@ obj- := misc.o	# Dummy rule to force built-in.o to be made
 
 obj-$(CONFIG_IBM_ASM)		+= ibmasm/
 obj-$(CONFIG_HDPU_FEATURES)	+= hdpuftrs/
-obj-$(CONFIG_ASUS_LAPTOP)	+= asus-laptop.o
-obj-$(CONFIG_EEEPC_LAPTOP)	+= eeepc-laptop.o
-obj-$(CONFIG_MSI_LAPTOP)	+= msi-laptop.o
-obj-$(CONFIG_COMPAL_LAPTOP)	+= compal-laptop.o
-obj-$(CONFIG_ACER_WMI)		+= acer-wmi.o
 obj-$(CONFIG_ATMEL_PWM)		+= atmel_pwm.o
 obj-$(CONFIG_ATMEL_SSC)		+= atmel-ssc.o
 obj-$(CONFIG_ATMEL_TCLIB)	+= atmel_tclib.o
-obj-$(CONFIG_HP_WMI)		+= hp-wmi.o
 obj-$(CONFIG_ICS932S401)	+= ics932s401.o
 obj-$(CONFIG_TC1100_WMI)	+= tc1100-wmi.o
 obj-$(CONFIG_LKDTM)		+= lkdtm.o
@@ -21,12 +15,7 @@ obj-$(CONFIG_TIFM_CORE)       	+= tifm_core.o
 obj-$(CONFIG_TIFM_7XX1)       	+= tifm_7xx1.o
 obj-$(CONFIG_PHANTOM)		+= phantom.o
 obj-$(CONFIG_SGI_IOC4)		+= ioc4.o
-obj-$(CONFIG_SONY_LAPTOP)	+= sony-laptop.o
-obj-$(CONFIG_THINKPAD_ACPI)	+= thinkpad_acpi.o
-obj-$(CONFIG_FUJITSU_LAPTOP)	+= fujitsu-laptop.o
-obj-$(CONFIG_PANASONIC_LAPTOP)	+= panasonic-laptop.o
 obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
-obj-$(CONFIG_INTEL_MENLOW)	+= intel_menlow.o
 obj-$(CONFIG_ENCLOSURE_SERVICES) += enclosure.o
 obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
 obj-$(CONFIG_SGI_XP)		+= sgi-xp/



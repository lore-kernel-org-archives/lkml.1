Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbXLFMl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbXLFMl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbXLFMll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:41:41 -0500
Received: from nic2.axis.se ([193.13.178.10]:35705 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177AbXLFMlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:41:35 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <rehash.foo.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2007 17:02:22 +0100
Subject: [PATCH 01/47] Rearrange Kconfigs for CRIS v10 and v32 to allow compilation without warnings.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove some unneeded configs and add some new ones.
- Merge common config items to common file instead of duplicating them.
- Pull in standard Kconfig.preempt.
- Remove some unneeded Kconfigs for subsystems not (yet) available on CRIS
  (md, scsi, ieee1394, i2o, isdn, telephony, media, pcmcia, pci)
- Rename CRISv32 config items which had different types from CRISv10.
  (ETRAX_LED2G, ETRAX_LED2R, ETRAX_LED3G, ETRAX_LED3R, ETRAX_I2C_DATA_PORT,
  ETRAX_I2C_CLK_PORT)

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/Kconfig                  |  490 +++++++++++++++++++++++---
 arch/cris/arch-v10/Kconfig         |   71 +----
 arch/cris/arch-v10/drivers/Kconfig |  158 +--------
 arch/cris/arch-v32/Kconfig         |  309 ++++-------------
 arch/cris/arch-v32/drivers/Kconfig |  697 +++++++++++++++++++++++++-----------
 5 files changed, 1006 insertions(+), 719 deletions(-)

diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 222da15..0e9926d 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -13,10 +13,6 @@ config ZONE_DMA
 	bool
 	default y
 
-config NO_DMA
-	bool
-	default y
-
 config RWSEM_GENERIC_SPINLOCK
 	bool
 	default y
@@ -24,6 +20,10 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
+config GENERIC_IOMAP
+       bool
+       default y
+
 config ARCH_HAS_ILOG2_U32
 	bool
 	default n
@@ -44,13 +44,16 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config IRQ_PER_CPU
-	bool
-	default y
-
 config NO_IOPORT
 	def_bool y
 
+config NO_IOMEM
+	def_bool y
+
+config FORCE_MAX_ZONEORDER
+	int
+	default 6
+
 config CRIS
 	bool
 	default y
@@ -93,17 +96,15 @@ config ETRAX_FAST_TIMER
 	 timers).
 	 This is needed if CONFIG_ETRAX_SERIAL_FAST_TIMER is enabled.
 
-config PREEMPT
-	bool "Preemptible Kernel"
+config ETRAX_KMALLOCED_MODULES
+	bool "Enable module allocation with kmalloc"
 	help
-	  This option reduces the latency of the kernel when reacting to
-	  real-time or interactive events by allowing a low priority process to
-	  be preempted even if it is in kernel mode executing a system call.
-	  This allows applications to run more reliably even when the system is
-	  under load.
+	  Enable module allocation with kmalloc instead of vmalloc.
 
-	  Say Y here if you are building a kernel for a desktop, embedded
-	  or real-time system.  Say N if you are unsure.
+config OOM_REBOOT
+       bool "Enable reboot at out of memory"
+
+source "kernel/Kconfig.preempt"
 
 source mm/Kconfig
 
@@ -130,26 +131,127 @@ config SVINTO_SIM
 	help
 	  Support the xsim ETRAX Simulator.
 
+config ETRAXFS
+	bool "ETRAX-FS-V32"
+	help
+	  Support CRIS V32.
+
+config CRIS_MACH_ARTPEC3
+        bool "ARTPEC-3"
+        help
+          Support Axis ARTPEC-3.
+
 endchoice
 
+config ETRAX_VCS_SIM
+	bool "VCS Simulator"
+	help
+	  Setup hardware to be run in the VCS simulator.
+
 config ETRAX_ARCH_V10
        bool
        default y if ETRAX100LX || ETRAX100LX_V2
        default n if !(ETRAX100LX || ETRAX100LX_V2)
 
+config ETRAX_ARCH_V32
+       bool
+       default y if (ETRAXFS || CRIS_MACH_ARTPEC3)
+       default n if !(ETRAXFS || CRIS_MACH_ARTPEC3)
+
 config ETRAX_DRAM_SIZE
 	int "DRAM size (dec, in MB)"
 	default "8"
 	help
 	  Size of DRAM (decimal in MB) typically 2, 8 or 16.
 
+config ETRAX_VMEM_SIZE
+       int "Video memory size (dec, in MB)"
+       depends on ETRAX_ARCH_V32 && !ETRAXFS
+       default 8 if !ETRAXFS
+       help
+	Size of Video accessible memory (decimal, in MB).
+
 config ETRAX_FLASH_BUSWIDTH
-	int "Buswidth of flash in bytes"
+	int "Buswidth of NOR flash in bytes"
 	default "2"
 	help
-	  Width in bytes of the Flash bus (1, 2 or 4). Is usually 2.
+	  Width in bytes of the NOR Flash bus (1, 2 or 4). Is usually 2.
+
+config ETRAX_NANDFLASH_BUSWIDTH
+	int "Buswidth of NAND flash in bytes"
+	default "1"
+	help
+	  Width in bytes of the NAND flash (1 or 2).
+
+config ETRAX_FLASH1_SIZE
+       int "FLASH1 size (dec, in MB. 0 = Unknown)"
+       default "0"
+
+choice
+	prompt "Product debug-port"
+	default ETRAX_DEBUG_PORT0
+
+config ETRAX_DEBUG_PORT0
+	bool "Serial-0"
+	help
+	  Choose a serial port for the ETRAX debug console.  Default to
+	  port 0.
+
+config ETRAX_DEBUG_PORT1
+	bool "Serial-1"
+	help
+	  Use serial port 1 for the console.
+
+config ETRAX_DEBUG_PORT2
+	bool "Serial-2"
+	help
+	  Use serial port 2 for the console.
+
+config ETRAX_DEBUG_PORT3
+	bool "Serial-3"
+	help
+	  Use serial port 3 for the console.
+
+config ETRAX_DEBUG_PORT_NULL
+	bool "disabled"
+	help
+	  Disable serial-port debugging.
+
+endchoice
+
+choice
+	prompt "Kernel GDB port"
+	depends on ETRAX_KGDB
+	default ETRAX_KGDB_PORT0
+	help
+	  Choose a serial port for kernel debugging.  NOTE: This port should
+	  not be enabled under Drivers for built-in interfaces (as it has its
+	  own initialization code) and should not be the same as the debug port.
+
+config ETRAX_KGDB_PORT0
+	bool "Serial-0"
+	help
+	  Use serial port 0 for kernel debugging.
+
+config ETRAX_KGDB_PORT1
+	bool "Serial-1"
+	help
+	  Use serial port 1 for kernel debugging.
+
+config ETRAX_KGDB_PORT2
+	bool "Serial-2"
+	help
+	  Use serial port 2 for kernel debugging.
+
+config ETRAX_KGDB_PORT3
+	bool "Serial-3"
+	help
+	  Use serial port 3 for kernel debugging.
+
+endchoice
 
 source arch/cris/arch-v10/Kconfig
+source arch/cris/arch-v32/Kconfig
 
 endmenu
 
@@ -157,8 +259,331 @@ source "net/Kconfig"
 
 # bring in ETRAX built-in drivers
 menu "Drivers for built-in interfaces"
-# arch/cris/arch is a symlink to correct arch (arch-v10 or arch-v32)
-source arch/cris/arch/drivers/Kconfig
+source arch/cris/arch-v10/drivers/Kconfig
+source arch/cris/arch-v32/drivers/Kconfig
+
+choice
+	prompt "RTC chip"
+	depends on ETRAX_RTC
+	default ETRAX_PCF8563 if ETRAX_ARCH_V32
+	default ETRAX_DS1302 if ETRAX_ARCH_V10
+
+config ETRAX_DS1302
+	depends on ETRAX_ARCH_V10
+	bool "DS1302"
+	help
+	  Enables the driver for the DS1302 Real-Time Clock battery-backed
+	  chip on some products.
+
+config ETRAX_PCF8563
+	bool "PCF8563"
+	help
+	  Enables the driver for the PCF8563 Real-Time Clock battery-backed
+	  chip on some products.
+
+endchoice
+
+choice
+	prompt "Network LED behavior"
+	depends on ETRAX_ETHERNET
+	default ETRAX_NETWORK_LED_ON_WHEN_ACTIVITY
+
+config ETRAX_NETWORK_LED_ON_WHEN_LINK
+	bool "LED_on_when_link"
+	help
+	  Selecting LED_on_when_link will light the LED when there is a
+	  connection and will flash off when there is activity.
+
+	  Selecting LED_on_when_activity will light the LED only when
+	  there is activity.
+
+	  This setting will also affect the behaviour of other activity LEDs
+	  e.g. Bluetooth.
+
+config ETRAX_NETWORK_LED_ON_WHEN_ACTIVITY
+	bool "LED_on_when_activity"
+	help
+	  Selecting LED_on_when_link will light the LED when there is a
+	  connection and will flash off when there is activity.
+
+	  Selecting LED_on_when_activity will light the LED only when
+	  there is activity.
+
+	  This setting will also affect the behaviour of other activity LEDs
+	  e.g. Bluetooth.
+
+endchoice
+
+choice
+	prompt "Ser0 DMA out channel"
+	depends on ETRAX_SERIAL_PORT0
+	default ETRAX_SERIAL_PORT0_DMA6_OUT if ETRAX_ARCH_V32
+	default ETRAX_SERIAL_PORT0_NO_DMA_OUT if ETRAX_ARCH_V10
+
+config ETRAX_SERIAL_PORT0_NO_DMA_OUT
+	bool "Ser0 uses no DMA for output"
+	help
+	  Do not use DMA for ser0 output.
+
+config ETRAX_SERIAL_PORT0_DMA6_OUT
+	bool "Ser0 uses DMA6 for output"
+	depends on ETRAXFS
+	help
+	  Enables the DMA6 output channel for ser0 (ttyS0).
+	  If you do not enable DMA, an interrupt for each character will be
+	  used when transmitting data.
+	  Normally you want to use DMA, unless you use the DMA channel for
+	  something else.
+
+config ETRAX_SERIAL_PORT0_DMA0_OUT
+	bool "Ser0 uses DMA0 for output"
+	depends on CRIS_MACH_ARTPEC3
+	help
+	  Enables the DMA0 output channel for ser0 (ttyS0).
+	  If you do not enable DMA, an interrupt for each character will be
+	  used when transmitting data.
+	  Normally you want to use DMA, unless you use the DMA channel for
+	  something else.
+
+endchoice
+
+choice
+	prompt "Ser0 DMA in channel "
+	depends on ETRAX_SERIAL_PORT0
+	default ETRAX_SERIAL_PORT0_NO_DMA_IN if ETRAX_ARCH_V32
+	default ETRAX_SERIAL_PORT0_DMA7_IN if ETRAX_ARCH_V10
+	help
+	  What DMA channel to use for ser0.
+
+config ETRAX_SERIAL_PORT0_NO_DMA_IN
+	bool "Ser0 uses no DMA for input"
+	help
+	  Do not use DMA for ser0 input.
+
+config ETRAX_SERIAL_PORT0_DMA7_IN
+	bool "Ser0 uses DMA7 for input"
+	depends on ETRAXFS
+	help
+	  Enables the DMA7 input channel for ser0 (ttyS0).
+	  If you do not enable DMA, an interrupt for each character will be
+	  used when receiving data.
+	  Normally you want to use DMA, unless you use the DMA channel for
+	  something else.
+
+config ETRAX_SERIAL_PORT0_DMA1_IN
+	bool "Ser0 uses DMA1 for input"
+	depends on CRIS_MACH_ARTPEC3
+	help
+	  Enables the DMA1 input channel for ser0 (ttyS0).
+	  If you do not enable DMA, an interrupt for each character will be
+	  used when receiveing data.
+	  Normally you want to use DMA, unless you use the DMA channel for
+	  something else.
+
+endchoice
+
+choice
+	prompt "Ser1 DMA in channel "
+	depends on ETRAX_SERIAL_PORT1
+	default ETRAX_SERIAL_PORT1_NO_DMA_IN if ETRAX_ARCH_V32
+	default ETRAX_SERIAL_PORT1_DMA9_IN if ETRAX_ARCH_V10
+	help
+	  What DMA channel to use for ser1.
+
+config ETRAX_SERIAL_PORT1_NO_DMA_IN
+	bool "Ser1 uses no DMA for input"
+	help
+	  Do not use DMA for ser1 input.
+
+config ETRAX_SERIAL_PORT1_DMA5_IN
+	bool "Ser1 uses DMA5 for input"
+	depends on ETRAX_ARCH_V32
+	help
+	  Enables the DMA5 input channel for ser1 (ttyS1).
+	  If you do not enable DMA, an interrupt for each character will be
+	  used when receiving data.
+	  Normally you want this on, unless you use the DMA channel for
+	  something else.
+
+config ETRAX_SERIAL_PORT1_DMA9_IN
+	depends on ETRAX_ARCH_V10
+	bool "Ser1 uses DMA9 for input"
+
+endchoice
+
+
+choice
+	prompt "Ser1 DMA out channel"
+	depends on ETRAX_SERIAL_PORT1
+	default ETRAX_SERIAL_PORT1_NO_DMA_OUT if ETRAX_ARCH_V32
+	default ETRAX_SERIAL_PORT1_DMA8_OUT if ETRAX_ARCH_V10
+	help
+	  What DMA channel to use for ser1.
+
+config ETRAX_SERIAL_PORT1_NO_DMA_OUT
+	bool "Ser1 uses no DMA for output"
+	help
+	  Do not use DMA for ser1 output.
+
+config ETRAX_SERIAL_PORT1_DMA8_OUT
+	depends on ETRAX_ARCH_V10
+	bool "Ser1 uses DMA8 for output"
+
+config ETRAX_SERIAL_PORT1_DMA4_OUT
+	depends on ETRAX_ARCH_V32
+	bool "Ser1 uses DMA4 for output"
+	help
+	  Enables the DMA4 output channel for ser1 (ttyS1).
+	  If you do not enable DMA, an interrupt for each character will be
+	  used when transmitting data.
+	  Normally you want this on, unless you use the DMA channel for
+	  something else.
+
+endchoice
+
+choice
+	prompt "Ser2 DMA out channel"
+	depends on ETRAX_SERIAL_PORT2
+	default ETRAX_SERIAL_PORT2_NO_DMA_OUT if ETRAX_ARCH_V32
+	default ETRAX_SERIAL_PORT2_DMA2_OUT if ETRAX_ARCH_V10
+
+config ETRAX_SERIAL_PORT2_NO_DMA_OUT
+	bool "Ser2 uses no DMA for output"
+	help
+	  Do not use DMA for ser2 output.
+
+config ETRAX_SERIAL_PORT2_DMA2_OUT
+	bool "Ser2 uses DMA2 for output"
+	depends on ETRAXFS || ETRAX_ARCH_V10
+	help
+	  Enables the DMA2 output channel for ser2 (ttyS2).
+	  If you do not enable DMA, an interrupt for each character will be
+	  used when transmitting data.
+	  Normally you want to use DMA, unless you use the DMA channel for
+	  something else.
+
+config ETRAX_SERIAL_PORT2_DMA6_OUT
+	bool "Ser2 uses DMA6 for output"
+	depends on CRIS_MACH_ARTPEC3
+	help
+	  Enables the DMA6 output channel for ser2 (ttyS2).
+	  If you do not enable DMA, an interrupt for each character will be
+	  used when transmitting data.
+	  Normally you want to use DMA, unless you use the DMA channel for
+	  something else.
+
+endchoice
+
+choice
+	prompt "Ser2 DMA in channel"
+	depends on ETRAX_SERIAL_PORT2
+	default ETRAX_SERIAL_PORT2_NO_DMA_IN if ETRAX_ARCH_V32
+	default ETRAX_SERIAL_PORT2_DMA3_IN if ETRAX_ARCH_V10
+	help
+	  What DMA channel to use for ser2.
+
+config ETRAX_SERIAL_PORT2_NO_DMA_IN
+	bool "Ser2 uses no DMA for input"
+	help
+	  Do not use DMA for ser2 input.
+
+config ETRAX_SERIAL_PORT2_DMA3_IN
+	bool "Ser2 uses DMA3 for input"
+	depends on ETRAXFS || ETRAX_ARCH_V10
+	help
+	  Enables the DMA3 input channel for ser2 (ttyS2).
+	  If you do not enable DMA, an interrupt for each character will be
+	  used when receiving data.
+	  Normally you want to use DMA, unless you use the DMA channel for
+	  something else.
+
+config ETRAX_SERIAL_PORT2_DMA7_IN
+	bool "Ser2 uses DMA7 for input"
+	depends on CRIS_MACH_ARTPEC3
+	help
+	  Enables the DMA7 input channel for ser2 (ttyS2).
+	  If you do not enable DMA, an interrupt for each character will be
+	  used when receiveing data.
+	  Normally you want to use DMA, unless you use the DMA channel for
+	  something else.
+
+endchoice
+
+choice
+	prompt "Ser3 DMA in channel"
+	depends on ETRAX_SERIAL_PORT3
+	default ETRAX_SERIAL_PORT3_NO_DMA_IN if ETRAX_ARCH_V32
+	default ETRAX_SERIAL_PORT3_DMA5_IN if ETRAX_ARCH_V10
+	help
+	  What DMA channel to use for ser3.
+
+config ETRAX_SERIAL_PORT3_NO_DMA_IN
+	bool "Ser3 uses no DMA for input"
+	help
+	  Do not use DMA for ser3 input.
+
+config ETRAX_SERIAL_PORT3_DMA5_IN
+	depends on ETRAX_ARCH_V10
+	bool "DMA 5"
+
+config ETRAX_SERIAL_PORT3_DMA9_IN
+	bool "Ser3 uses DMA9 for input"
+	depends on ETRAXFS
+	help
+	  Enables the DMA9 input channel for ser3 (ttyS3).
+	  If you do not enable DMA, an interrupt for each character will be
+	  used when receiving data.
+	  Normally you want to use DMA, unless you use the DMA channel for
+	  something else.
+
+config ETRAX_SERIAL_PORT3_DMA3_IN
+	bool "Ser3 uses DMA3 for input"
+	depends on CRIS_MACH_ARTPEC3
+	help
+	  Enables the DMA3 input channel for ser3 (ttyS3).
+	  If you do not enable DMA, an interrupt for each character will be
+	  used when receiveing data.
+	  Normally you want to use DMA, unless you use the DMA channel for
+	  something else.
+
+endchoice
+
+choice
+	prompt "Ser3 DMA out channel"
+	depends on ETRAX_SERIAL_PORT3
+	default ETRAX_SERIAL_PORT3_NO_DMA_OUT if ETRAX_ARCH_V32
+	default ETRAX_SERIAL_PORT3_DMA4_OUT if ETRAX_ARCH_V10
+
+config ETRAX_SERIAL_PORT3_NO_DMA_OUT
+	bool "Ser3 uses no DMA for output"
+	help
+	  Do not use DMA for ser3 output.
+
+config ETRAX_SERIAL_PORT3_DMA4_OUT
+	depends on ETRAX_ARCH_V10
+	bool "DMA 4"
+
+config ETRAX_SERIAL_PORT3_DMA8_OUT
+	bool "Ser3 uses DMA8 for output"
+	depends on ETRAXFS
+	help
+	  Enables the DMA8 output channel for ser3 (ttyS3).
+	  If you do not enable DMA, an interrupt for each character will be
+	  used when transmitting data.
+	  Normally you want to use DMA, unless you use the DMA channel for
+	  something else.
+
+config ETRAX_SERIAL_PORT3_DMA2_OUT
+	bool "Ser3 uses DMA2 for output"
+	depends on CRIS_MACH_ARTPEC3
+	help
+	  Enables the DMA2 output channel for ser3 (ttyS3).
+	  If you do not enable DMA, an interrupt for each character will be
+	  used when transmitting data.
+	  Normally you want to use DMA, unless you use the DMA channel for
+	  something else.
+
+endchoice
 
 endmenu
 
@@ -173,22 +598,10 @@ source "drivers/pnp/Kconfig"
 
 source "drivers/block/Kconfig"
 
-source "drivers/md/Kconfig"
-
 source "drivers/ide/Kconfig"
 
-source "drivers/scsi/Kconfig"
-
-source "drivers/ieee1394/Kconfig"
-
-source "drivers/message/i2o/Kconfig"
-
 source "drivers/net/Kconfig"
 
-source "drivers/isdn/Kconfig"
-
-source "drivers/telephony/Kconfig"
-
 source "drivers/i2c/Kconfig"
 
 source "drivers/rtc/Kconfig"
@@ -200,21 +613,10 @@ source "drivers/input/Kconfig"
 
 source "drivers/char/Kconfig"
 
-#source drivers/misc/Config.in
-source "drivers/media/Kconfig"
-
 source "fs/Kconfig"
 
-source "sound/Kconfig"
-
-source "drivers/pcmcia/Kconfig"
-
-source "drivers/pci/Kconfig"
-
 source "drivers/usb/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/cris/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/cris/arch-v10/Kconfig b/arch/cris/arch-v10/Kconfig
index f1ce6f6..adc164e 100644
--- a/arch/cris/arch-v10/Kconfig
+++ b/arch/cris/arch-v10/Kconfig
@@ -1,3 +1,7 @@
+if ETRAX_ARCH_V10
+
+menu "CRIS v10 options"
+
 # ETRAX 100LX v1 has a MMU "feature" requiring a low mapping
 config CRIS_LOW_MAP
 	bool
@@ -226,69 +230,6 @@ config ETRAX_LED12R
 	  For products with only one or two controllable LEDs,
 	  set this to same as CONFIG_ETRAX_LED1G (normally 2).
 
-choice
-	prompt "Product debug-port"
-	depends on ETRAX_ARCH_V10
-	default ETRAX_DEBUG_PORT0
-
-config ETRAX_DEBUG_PORT0
-	bool "Serial-0"
-	help
-	  Choose a serial port for the ETRAX debug console.  Default to
-	  port 0.
-
-config ETRAX_DEBUG_PORT1
-	bool "Serial-1"
-	help
-	  Use serial port 1 for the console.
-
-config ETRAX_DEBUG_PORT2
-	bool "Serial-2"
-	help
-	  Use serial port 2 for the console.
-
-config ETRAX_DEBUG_PORT3
-	bool "Serial-3"
-	help
-	  Use serial port 3 for the console.
-
-config ETRAX_DEBUG_PORT_NULL
-	bool "disabled"
-	help
-	  Disable serial-port debugging.
-
-endchoice
-
-choice
-	prompt "Kernel GDB port"
-	depends on ETRAX_KGDB
-	default ETRAX_KGDB_PORT0
-	help
-	  Choose a serial port for kernel debugging.  NOTE: This port should
-	  not be enabled under Drivers for built-in interfaces (as it has its
-	  own initialization code) and should not be the same as the debug port.
-
-config ETRAX_KGDB_PORT0
-	bool "Serial-0"
-	help
-	  Use serial port 0 for kernel debugging.
-
-config ETRAX_KGDB_PORT1
-	bool "Serial-1"
-	help
-	  Use serial port 1 for kernel debugging.
-
-config ETRAX_KGDB_PORT2
-	bool "Serial-2"
-	help
-	  Use serial port 2 for kernel debugging.
-
-config ETRAX_KGDB_PORT3
-	bool "Serial-3"
-	help
-	  Use serial port 3 for kernel debugging.
-
-endchoice
 
 choice
 	prompt "Product rescue-port"
@@ -451,3 +392,7 @@ config ETRAX_POWERBUTTON_BIT
 	default "25"
 	help
 	  Configure where power button is connected.
+
+endmenu
+
+endif
diff --git a/arch/cris/arch-v10/drivers/Kconfig b/arch/cris/arch-v10/drivers/Kconfig
index e3c0f29..10e9b50 100644
--- a/arch/cris/arch-v10/drivers/Kconfig
+++ b/arch/cris/arch-v10/drivers/Kconfig
@@ -1,3 +1,5 @@
+if ETRAX_ARCH_V10
+
 config ETRAX_ETHERNET
 	bool "Ethernet support"
 	depends on ETRAX_ARCH_V10
@@ -7,37 +9,6 @@ config ETRAX_ETHERNET
 	  This option enables the ETRAX 100LX built-in 10/100Mbit Ethernet
 	  controller.
 
-choice
-	prompt "Network LED behavior"
-	depends on ETRAX_ETHERNET
-	default ETRAX_NETWORK_LED_ON_WHEN_ACTIVITY
-
-config ETRAX_NETWORK_LED_ON_WHEN_LINK
-	bool "LED_on_when_link"
-	help
-	  Selecting LED_on_when_link will light the LED when there is a
-	  connection and will flash off when there is activity.
-
-	  Selecting LED_on_when_activity will light the LED only when
-	  there is activity.
-
-	  This setting will also affect the behaviour of other activity LEDs
-	  e.g. Bluetooth.
-
-config ETRAX_NETWORK_LED_ON_WHEN_ACTIVITY
-	bool "LED_on_when_activity"
-	help
-	  Selecting LED_on_when_link will light the LED when there is a
-	  connection and will flash off when there is activity.
-
-	  Selecting LED_on_when_activity will light the LED only when
-	  there is activity.
-
-	  This setting will also affect the behaviour of other activity LEDs
-	  e.g. Bluetooth.
-
-endchoice
-
 config ETRAX_SERIAL
 	bool "Serial-port support"
 	depends on ETRAX_ARCH_V10
@@ -82,32 +53,6 @@ config ETRAX_SERIAL_PORT0
 	  the same DMA channels.
 
 choice
-	prompt "Ser0 DMA out assignment"
-	depends on ETRAX_SERIAL_PORT0
-	default ETRAX_SERIAL_PORT0_DMA6_OUT
-
-config ETRAX_SERIAL_PORT0_NO_DMA_OUT
-	bool "No DMA out"
-
-config ETRAX_SERIAL_PORT0_DMA6_OUT
-	bool "DMA 6"
-
-endchoice
-
-choice
-	prompt "Ser0 DMA in assignment"
-	depends on ETRAX_SERIAL_PORT0
-	default ETRAX_SERIAL_PORT0_DMA7_IN
-
-config ETRAX_SERIAL_PORT0_NO_DMA_IN
-	bool "No DMA in"
-
-config ETRAX_SERIAL_PORT0_DMA7_IN
-	bool "DMA 7"
-
-endchoice
-
-choice
 	prompt "Ser0 DTR, RI, DSR and CD assignment"
 	depends on ETRAX_SERIAL_PORT0
 	default ETRAX_SER0_DTR_RI_DSR_CD_ON_NONE
@@ -196,32 +141,6 @@ config ETRAX_SERIAL_PORT1
 	  Enables the ETRAX 100 serial driver for ser1 (ttyS1).
 
 choice
-	prompt "Ser1 DMA out assignment"
-	depends on ETRAX_SERIAL_PORT1
-	default ETRAX_SERIAL_PORT1_DMA8_OUT
-
-config ETRAX_SERIAL_PORT1_NO_DMA_OUT
-	bool "No DMA out"
-
-config ETRAX_SERIAL_PORT1_DMA8_OUT
-	bool "DMA 8"
-
-endchoice
-
-choice
-	prompt "Ser1 DMA in assignment"
-	depends on ETRAX_SERIAL_PORT1
-	default ETRAX_SERIAL_PORT1_DMA9_IN
-
-config ETRAX_SERIAL_PORT1_NO_DMA_IN
-	bool "No DMA in"
-
-config ETRAX_SERIAL_PORT1_DMA9_IN
-	bool "DMA 9"
-
-endchoice
-
-choice
 	prompt "Ser1 DTR, RI, DSR and CD assignment"
 	depends on ETRAX_SERIAL_PORT1
 	default ETRAX_SER1_DTR_RI_DSR_CD_ON_NONE
@@ -313,32 +232,6 @@ config ETRAX_SERIAL_PORT2
 	  Enables the ETRAX 100 serial driver for ser2 (ttyS2).
 
 choice
-	prompt "Ser2 DMA out assignment"
-	depends on ETRAX_SERIAL_PORT2
-	default ETRAX_SERIAL_PORT2_DMA2_OUT
-
-config ETRAX_SERIAL_PORT2_NO_DMA_OUT
-	bool "No DMA out"
-
-config ETRAX_SERIAL_PORT2_DMA2_OUT
-	bool "DMA 2"
-
-endchoice
-
-choice
-	prompt "Ser2 DMA in assignment"
-	depends on ETRAX_SERIAL_PORT2
-	default ETRAX_SERIAL_PORT2_DMA3_IN
-
-config ETRAX_SERIAL_PORT2_NO_DMA_IN
-	bool "No DMA in"
-
-config ETRAX_SERIAL_PORT2_DMA3_IN
-	bool "DMA 3"
-
-endchoice
-
-choice
 	prompt "Ser2 DTR, RI, DSR and CD assignment"
 	depends on ETRAX_SERIAL_PORT2
 	default ETRAX_SER2_DTR_RI_DSR_CD_ON_NONE
@@ -427,32 +320,6 @@ config ETRAX_SERIAL_PORT3
 	  Enables the ETRAX 100 serial driver for ser3 (ttyS3).
 
 choice
-	prompt "Ser3 DMA out assignment"
-	depends on ETRAX_SERIAL_PORT3
-	default ETRAX_SERIAL_PORT3_DMA4_OUT
-
-config ETRAX_SERIAL_PORT3_NO_DMA_OUT
-	bool "No DMA out"
-
-config ETRAX_SERIAL_PORT3_DMA4_OUT
-	bool "DMA 4"
-
-endchoice
-
-choice
-	prompt "Ser3 DMA in assignment"
-	depends on ETRAX_SERIAL_PORT3
-	default ETRAX_SERIAL_PORT3_DMA5_IN
-
-config ETRAX_SERIAL_PORT3_NO_DMA_IN
-	bool "No DMA in"
-
-config ETRAX_SERIAL_PORT3_DMA5_IN
-	bool "DMA 5"
-
-endchoice
-
-choice
 	prompt "Ser3 DTR, RI, DSR and CD assignment"
 	depends on ETRAX_SERIAL_PORT3
 	default ETRAX_SER3_DTR_RI_DSR_CD_ON_NONE
@@ -741,25 +608,6 @@ config ETRAX_RTC
 	  normal time reading should be done using libc function time and
 	  friends.
 
-choice
-	prompt "RTC chip"
-	depends on ETRAX_RTC
-	default ETRAX_DS1302
-
-config ETRAX_DS1302
-	bool "DS1302"
-	help
-	  Enables the driver for the DS1302 Real-Time Clock battery-backed
-	  chip on some products.
-
-config ETRAX_PCF8563
-	bool "PCF8563"
-	help
-	  Enables the driver for the PCF8563 Real-Time Clock battery-backed
-	  chip on some products.
-
-endchoice
-
 config ETRAX_DS1302_RST_ON_GENERIC_PORT
 	bool "DS1302 RST on Generic Port"
 	depends on ETRAX_DS1302
@@ -806,3 +654,5 @@ config ETRAX_DS1302_TRICKLE_CHARGE
 	  1 = 2kohm, 2 = 4kohm, 3 = 4kohm
 	  4 = 1 diode, 8 = 2 diodes
 	  Allowed values are (increasing current): 0, 11, 10, 9, 7, 6, 5
+
+endif
diff --git a/arch/cris/arch-v32/Kconfig b/arch/cris/arch-v32/Kconfig
index 4f79d8e..70d8dc9 100644
--- a/arch/cris/arch-v32/Kconfig
+++ b/arch/cris/arch-v32/Kconfig
@@ -1,25 +1,73 @@
+if ETRAX_ARCH_V32
+
+source arch/cris/arch-v32/mach-fs/Kconfig
+source arch/cris/arch-v32/mach-a3/Kconfig
+
+source drivers/cpufreq/Kconfig
+
 config ETRAX_DRAM_VIRTUAL_BASE
 	hex
 	depends on ETRAX_ARCH_V32
 	default "c0000000"
 
-config ETRAX_LED1G
-	string "First green LED bit"
+choice
+	prompt "Nbr of Ethernet LED groups"
 	depends on ETRAX_ARCH_V32
+	default ETRAX_NBR_LED_GRP_ONE
+	help
+	  Select how many Ethernet LED groups that can be used. Usually one per Ethernet
+	  interface is a good choice.
+
+config	ETRAX_NBR_LED_GRP_ZERO
+	bool "Use zero LED groups"
+	help
+	  Select this if you do not want any Ethernet LEDs.
+
+config	ETRAX_NBR_LED_GRP_ONE
+	bool "Use one LED group"
+	help
+	  Select this if you want one Ethernet LED group. This LED group
+	  can be used for one or more Ethernet interfaces. However, it is
+	  recomended that each Ethernet interface use a dedicated LED group.
+
+config	ETRAX_NBR_LED_GRP_TWO
+	bool "Use two LED groups"
+	help
+	  Select this if you want two Ethernet LED groups. This is the
+	  best choice if you have more than one Ethernet interface and
+	  would like to have separate LEDs for the interfaces.
+
+endchoice
+
+config ETRAX_LED_G_NET0
+	string "Ethernet LED group 0 green LED bit"
+	depends on ETRAX_ARCH_V32 && (ETRAX_NBR_LED_GRP_ONE || ETRAX_NBR_LED_GRP_TWO)
 	default "PA3"
 	help
-	  Bit to use for the first green LED (network LED).
-	  Most Axis products use bit A3 here.
+	  Bit to use for the green LED in Ethernet LED group 0.
 
-config ETRAX_LED1R
-	string "First red LED bit"
-	depends on ETRAX_ARCH_V32
+config ETRAX_LED_R_NET0
+	string "Ethernet LED group 0 red LED bit"
+	depends on ETRAX_ARCH_V32 && (ETRAX_NBR_LED_GRP_ONE || ETRAX_NBR_LED_GRP_TWO)
 	default "PA4"
 	help
-	  Bit to use for the first red LED (network LED).
-	  Most Axis products use bit A4 here.
+	  Bit to use for the red LED in Ethernet LED group 0.
+
+config ETRAX_LED_G_NET1
+	string "Ethernet group 1 green LED bit"
+	depends on ETRAX_ARCH_V32 && ETRAX_NBR_LED_GRP_TWO
+	default ""
+	help
+	  Bit to use for the green LED in Ethernet LED group 1.
 
-config ETRAX_LED2G
+config ETRAX_LED_R_NET1
+	string "Ethernet group 1 red LED bit"
+	depends on ETRAX_ARCH_V32 && ETRAX_NBR_LED_GRP_TWO
+	default ""
+	help
+	  Bit to use for the red LED in Ethernet LED group 1.
+
+config ETRAX_V32_LED2G
 	string "Second green LED bit"
 	depends on ETRAX_ARCH_V32
 	default "PA5"
@@ -27,7 +75,7 @@ config ETRAX_LED2G
 	  Bit to use for the first green LED (status LED).
 	  Most Axis products use bit A5 here.
 
-config ETRAX_LED2R
+config ETRAX_V32_LED2R
 	string "Second red LED bit"
 	depends on ETRAX_ARCH_V32
 	default "PA6"
@@ -35,7 +83,7 @@ config ETRAX_LED2R
 	  Bit to use for the first red LED (network LED).
 	  Most Axis products use bit A6 here.
 
-config ETRAX_LED3G
+config ETRAX_V32_LED3G
 	string "Third green LED bit"
 	depends on ETRAX_ARCH_V32
 	default "PA7"
@@ -43,7 +91,7 @@ config ETRAX_LED3G
 	  Bit to use for the first green LED (drive/power LED).
 	  Most Axis products use bit A7 here.
 
-config ETRAX_LED3R
+config ETRAX_V32_LED3R
 	string "Third red LED bit"
 	depends on ETRAX_ARCH_V32
 	default "PA7"
@@ -52,39 +100,6 @@ config ETRAX_LED3R
 	  Most Axis products use bit A7 here.
 
 choice
-	prompt "Product debug-port"
-	depends on ETRAX_ARCH_V32
-	default ETRAX_DEBUG_PORT0
-
-config ETRAX_DEBUG_PORT0
-	bool "Serial-0"
-	help
-	  Choose a serial port for the ETRAX debug console.  Default to
-	  port 0.
-
-config ETRAX_DEBUG_PORT1
-	bool "Serial-1"
-	help
-	  Use serial port 1 for the console.
-
-config ETRAX_DEBUG_PORT2
-	bool "Serial-2"
-	help
-	  Use serial port 2 for the console.
-
-config ETRAX_DEBUG_PORT3
-	bool "Serial-3"
-	help
-	  Use serial port 3 for the console.
-
-config ETRAX_DEBUG_PORT_NULL
-	bool "disabled"
-	help
-	  Disable serial-port debugging.
-
-endchoice
-
-choice
 	prompt "Kernel GDB port"
 	depends on ETRAX_KGDB
 	default ETRAX_KGDB_PORT0
@@ -93,204 +108,12 @@ choice
 	  not be enabled under Drivers for built-in interfaces (as it has its
 	  own initialization code) and should not be the same as the debug port.
 
-config ETRAX_KGDB_PORT0
-	bool "Serial-0"
+config ETRAX_KGDB_PORT4
+	bool "Serial-4"
+	depends on ETRAX_SERIAL_PORTS = 5
 	help
-	  Use serial port 0 for kernel debugging.
-
-config ETRAX_KGDB_PORT1
-	bool "Serial-1"
-	help
-	  Use serial port 1 for kernel debugging.
-
-config ETRAX_KGDB_PORT2
-	bool "Serial-2"
-	help
-	  Use serial port 2 for kernel debugging.
-
-config ETRAX_KGDB_PORT3
-	bool "Serial-3"
-	help
-	  Use serial port 3 for kernel debugging.
+	  Use serial port 4 for kernel debugging.
 
 endchoice
 
-config ETRAX_MEM_GRP1_CONFIG
-	hex "MEM_GRP1_CONFIG"
-	depends on ETRAX_ARCH_V32
-	default "4044a"
-	help
-	  Waitstates for flash. The default value is suitable for the
-	  standard flashes used in axis products (120 ns).
-
-config ETRAX_MEM_GRP2_CONFIG
-	hex "MEM_GRP2_CONFIG"
-	depends on ETRAX_ARCH_V32
-	default "0"
-	help
-	  Waitstates for SRAM. 0 is a good choice for most Axis products.
-
-config ETRAX_MEM_GRP3_CONFIG
-	hex "MEM_GRP3_CONFIG"
-	depends on ETRAX_ARCH_V32
-	default "0"
-	help
-	  Waitstates for CSP0-3. 0 is a good choice for most Axis products.
-	  It may need to be changed if external devices such as extra
-	  register-mapped LEDs are used.
-
-config ETRAX_MEM_GRP4_CONFIG
-	hex "MEM_GRP4_CONFIG"
-	depends on ETRAX_ARCH_V32
-	default "0"
-	help
-	  Waitstates for CSP4-6. 0 is a good choice for most Axis products.
-
-config ETRAX_SDRAM_GRP0_CONFIG
-	hex "SDRAM_GRP0_CONFIG"
-	depends on ETRAX_ARCH_V32
-	default "336"
-	help
-	  SDRAM configuration for group 0. The value depends on the
-	  hardware configuration. The default value is suitable
-	  for 32 MB organized as two 16 bits chips (e.g. Axis
-	  part number 18550) connected as one 32 bit device (i.e. in
-	  the same group).
-
-config ETRAX_SDRAM_GRP1_CONFIG
-	hex "SDRAM_GRP1_CONFIG"
-	depends on ETRAX_ARCH_V32
-	default "0"
-	help
-	  SDRAM configuration for group 1. The default value is 0
-	  because group 1 is not used in the default configuration,
-	  described in the help for SDRAM_GRP0_CONFIG.
-
-config ETRAX_SDRAM_TIMING
-	hex "SDRAM_TIMING"
-	depends on ETRAX_ARCH_V32
-	default "104a"
-	help
-	  SDRAM timing parameters. The default value is ok for
-	  most hardwares but large SDRAMs may require a faster
-	  refresh (a.k.a 8K refresh). The default value implies
-	  100MHz clock and SDR mode.
-
-config ETRAX_SDRAM_COMMAND
-	hex "SDRAM_COMMAND"
-	depends on ETRAX_ARCH_V32
-	default "0"
-	help
-	  SDRAM command. Should be 0 unless you really know what
-	  you are doing (may be != 0 for unusual address line
-	  mappings such as in a MCM)..
-
-config ETRAX_DEF_GIO_PA_OE
-	hex "GIO_PA_OE"
-	depends on ETRAX_ARCH_V32
-	default "1c"
-	help
-	  Configures the direction of general port A bits.  1 is out, 0 is in.
-	  This is often totally different depending on the product used.
-	  There are some guidelines though - if you know that only LED's are
-	  connected to port PA, then they are usually connected to bits 2-4
-	  and you can therefore use 1c.  On other boards which don't have the
-	  LED's at the general ports, these bits are used for all kinds of
-	  stuff.  If you don't know what to use, it is always safe to put all
-	  as inputs, although floating inputs isn't good.
-
-config ETRAX_DEF_GIO_PA_OUT
-	hex "GIO_PA_OUT"
-	depends on ETRAX_ARCH_V32
-	default "00"
-	help
-	  Configures the initial data for the general port A bits.  Most
-	  products should use 00 here.
-
-config ETRAX_DEF_GIO_PB_OE
-	hex "GIO_PB_OE"
-	depends on ETRAX_ARCH_V32
-	default "00000"
-	help
-	  Configures the direction of general port B bits.  1 is out, 0 is in.
-	  This is often totally different depending on the product used.
-	  There are some guidelines though - if you know that only LED's are
-	  connected to port PA, then they are usually connected to bits 2-4
-	  and you can therefore use 1c.  On other boards which don't have the
-	  LED's at the general ports, these bits are used for all kinds of
-	  stuff.  If you don't know what to use, it is always safe to put all
-	  as inputs, although floating inputs isn't good.
-
-config ETRAX_DEF_GIO_PB_OUT
-	hex "GIO_PB_OUT"
-	depends on ETRAX_ARCH_V32
-	default "00000"
-	help
-	  Configures the initial data for the general port B bits.  Most
-	  products should use 00000 here.
-
-config ETRAX_DEF_GIO_PC_OE
-	hex "GIO_PC_OE"
-	depends on ETRAX_ARCH_V32
-	default "00000"
-	help
-	  Configures the direction of general port C bits.  1 is out, 0 is in.
-	  This is often totally different depending on the product used.
-	  There are some guidelines though - if you know that only LED's are
-	  connected to port PA, then they are usually connected to bits 2-4
-	  and you can therefore use 1c.  On other boards which don't have the
-	  LED's at the general ports, these bits are used for all kinds of
-	  stuff.  If you don't know what to use, it is always safe to put all
-	  as inputs, although floating inputs isn't good.
-
-config ETRAX_DEF_GIO_PC_OUT
-	hex "GIO_PC_OUT"
-	depends on ETRAX_ARCH_V32
-	default "00000"
-	help
-	  Configures the initial data for the general port C bits.  Most
-	  products should use 00000 here.
-
-config ETRAX_DEF_GIO_PD_OE
-	hex "GIO_PD_OE"
-	depends on ETRAX_ARCH_V32
-	default "00000"
-	help
-	  Configures the direction of general port D bits.  1 is out, 0 is in.
-	  This is often totally different depending on the product used.
-	  There are some guidelines though - if you know that only LED's are
-	  connected to port PA, then they are usually connected to bits 2-4
-	  and you can therefore use 1c.  On other boards which don't have the
-	  LED's at the general ports, these bits are used for all kinds of
-	  stuff.  If you don't know what to use, it is always safe to put all
-	  as inputs, although floating inputs isn't good.
-
-config ETRAX_DEF_GIO_PD_OUT
-	hex "GIO_PD_OUT"
-	depends on ETRAX_ARCH_V32
-	default "00000"
-	help
-	  Configures the initial data for the general port D bits.  Most
-	  products should use 00000 here.
-
-config ETRAX_DEF_GIO_PE_OE
-	hex "GIO_PE_OE"
-	depends on ETRAX_ARCH_V32
-	default "00000"
-	help
-	  Configures the direction of general port E bits.  1 is out, 0 is in.
-	  This is often totally different depending on the product used.
-	  There are some guidelines though - if you know that only LED's are
-	  connected to port PA, then they are usually connected to bits 2-4
-	  and you can therefore use 1c.  On other boards which don't have the
-	  LED's at the general ports, these bits are used for all kinds of
-	  stuff.  If you don't know what to use, it is always safe to put all
-	  as inputs, although floating inputs isn't good.
-
-config ETRAX_DEF_GIO_PE_OUT
-	hex "GIO_PE_OUT"
-	depends on ETRAX_ARCH_V32
-	default "00000"
-	help
-	  Configures the initial data for the general port E bits.  Most
-	  products should use 00000 here.
+endif
diff --git a/arch/cris/arch-v32/drivers/Kconfig b/arch/cris/arch-v32/drivers/Kconfig
index 9bccb5e..471c203 100644
--- a/arch/cris/arch-v32/drivers/Kconfig
+++ b/arch/cris/arch-v32/drivers/Kconfig
@@ -1,65 +1,105 @@
+if ETRAX_ARCH_V32
+
 config ETRAX_ETHERNET
 	bool "Ethernet support"
 	depends on ETRAX_ARCH_V32
 	select NET_ETHERNET
+	select MII
 	help
 	  This option enables the ETRAX FS built-in 10/100Mbit Ethernet
 	  controller.
 
-config ETRAX_ETHERNET_HW_CSUM
-	bool "Hardware accelerated ethernet checksum and scatter/gather"
+config ETRAX_NO_PHY
+	bool "PHY not present"
 	depends on ETRAX_ETHERNET
-	depends on ETRAX_STREAMCOPROC
-	default y
+	default N
 	help
-	  Hardware acceleration of checksumming and scatter/gather
+	  This option disables all MDIO communication with an ethernet
+	  transceiver connected to the MII interface. This option shall
+	  typically be enabled if the MII interface is connected to a
+	  switch. This option should normally be disabled. If enabled,
+	  speed and duplex will be locked to 100 Mbit and full duplex.
 
 config ETRAX_ETHERNET_IFACE0
 	depends on ETRAX_ETHERNET
 	bool "Enable network interface 0"
 
 config ETRAX_ETHERNET_IFACE1
-	depends on ETRAX_ETHERNET
+	depends on (ETRAX_ETHERNET && ETRAXFS)
 	bool "Enable network interface 1 (uses DMA6 and DMA7)"
 
+config ETRAX_ETHERNET_GBIT
+	depends on (ETRAX_ETHERNET && CRIS_MACH_ARTPEC3)
+	bool "Enable gigabit Ethernet support"
+
 choice
-	prompt "Network LED behavior"
-	depends on ETRAX_ETHERNET
-	default ETRAX_NETWORK_LED_ON_WHEN_ACTIVITY
+	prompt "Eth0 led group"
+	depends on ETRAX_ETHERNET_IFACE0
+	default ETRAX_ETH0_USE_LEDGRP0
 
-config ETRAX_NETWORK_LED_ON_WHEN_LINK
-	bool "LED_on_when_link"
+config ETRAX_ETH0_USE_LEDGRP0
+	bool "Use LED grp 0"
+	depends on ETRAX_NBR_LED_GRP_ONE || ETRAX_NBR_LED_GRP_TWO
 	help
-	  Selecting LED_on_when_link will light the LED when there is a
-	  connection and will flash off when there is activity.
-
-	  Selecting LED_on_when_activity will light the LED only when
-	  there is activity.
+	  Use LED grp 0 for eth0
 
-	  This setting will also affect the behaviour of other activity LEDs
-	  e.g. Bluetooth.
+config ETRAX_ETH0_USE_LEDGRP1
+	bool "Use LED grp 1"
+	depends on ETRAX_NBR_LED_GRP_TWO
+	help
+	  Use LED grp 1 for eth0
 
-config ETRAX_NETWORK_LED_ON_WHEN_ACTIVITY
-	bool "LED_on_when_activity"
+config ETRAX_ETH0_USE_LEDGRPNULL
+	bool "Use no LEDs for eth0"
 	help
-	  Selecting LED_on_when_link will light the LED when there is a
-	  connection and will flash off when there is activity.
+	  Use no LEDs for eth0
+endchoice
+
+choice
+	prompt "Eth1 led group"
+	depends on ETRAX_ETHERNET_IFACE1
+	default ETRAX_ETH1_USE_LEDGRP1
 
-	  Selecting LED_on_when_activity will light the LED only when
-	  there is activity.
+config ETRAX_ETH1_USE_LEDGRP0
+	bool "Use LED grp 0"
+	depends on ETRAX_NBR_LED_GRP_ONE || ETRAX_NBR_LED_GRP_TWO
+	help
+	  Use LED grp 0 for eth1
 
-	  This setting will also affect the behaviour of other activity LEDs
-	  e.g. Bluetooth.
+config ETRAX_ETH1_USE_LEDGRP1
+	bool "Use LED grp 1"
+	depends on ETRAX_NBR_LED_GRP_TWO
+	help
+	  Use LED grp 1 for eth1
 
+config ETRAX_ETH1_USE_LEDGRPNULL
+	bool "Use no LEDs for eth1"
+	help
+	  Use no LEDs for eth1
 endchoice
 
 config ETRAXFS_SERIAL
 	bool "Serial-port support"
 	depends on ETRAX_ARCH_V32
+	select SERIAL_CORE
+	select SERIAL_CORE_CONSOLE
 	help
 	  Enables the ETRAX FS serial driver for ser0 (ttyS0)
 	  You probably want this enabled.
 
+config ETRAX_RS485
+	bool "RS-485 support"
+	depends on ETRAXFS_SERIAL
+	help
+	  Enables support for RS-485 serial communication.
+
+config ETRAX_RS485_DISABLE_RECEIVER
+	bool "Disable serial receiver"
+	depends on ETRAX_RS485
+	help
+	  It is necessary to disable the serial receiver to avoid serial
+	  loopback.  Not all products are able to do this in software only.
+
 config ETRAX_SERIAL_PORT0
 	bool "Serial port 0 enabled"
 	depends on ETRAXFS_SERIAL
@@ -70,50 +110,28 @@ config ETRAX_SERIAL_PORT0
 	  ser0 can use dma4 or dma6 for output and dma5 or dma7 for input.
 
 choice
-	prompt "Ser0 DMA in channel "
+	prompt "Ser0 default port type "
 	depends on ETRAX_SERIAL_PORT0
-	default ETRAX_SERIAL_PORT0_NO_DMA_IN
-	help
-	  What DMA channel to use for ser0.
-
-
-config ETRAX_SERIAL_PORT0_NO_DMA_IN
-	bool "Ser0 uses no DMA for input"
+	default ETRAX_SERIAL_PORT0_TYPE_232
 	help
-	  Do not use DMA for ser0 input.
+	  Type of serial port.
 
-config ETRAX_SERIAL_PORT0_DMA7_IN
-	bool "Ser0 uses DMA7 for input"
-	depends on ETRAX_SERIAL_PORT0
+config ETRAX_SERIAL_PORT0_TYPE_232
+	bool "Ser0 is a RS-232 port"
 	help
-	  Enables the DMA7 input channel for ser0 (ttyS0).
-	  If you do not enable DMA, an interrupt for each character will be
-	  used when receiving data.
-	  Normally you want to use DMA, unless you use the DMA channel for
-	  something else.
-
-endchoice
+	  Configure serial port 0 to be a RS-232 port.
 
-choice
-	prompt "Ser0 DMA out channel"
-	depends on ETRAX_SERIAL_PORT0
-	default ETRAX_SERIAL_PORT0_NO_DMA_OUT
-
-config ETRAX_SERIAL_PORT0_NO_DMA_OUT
-	bool "Ser0 uses no DMA for output"
+config ETRAX_SERIAL_PORT0_TYPE_485HD
+	bool "Ser0 is a half duplex RS-485 port"
+	depends on ETRAX_RS485
 	help
-	  Do not use DMA for ser0 output.
+	  Configure serial port 0 to be a half duplex (two wires) RS-485 port.
 
-config ETRAX_SERIAL_PORT0_DMA6_OUT
-	bool "Ser0 uses DMA6 for output"
-	depends on ETRAX_SERIAL_PORT0
+config ETRAX_SERIAL_PORT0_TYPE_485FD
+	bool "Ser0 is a full duplex RS-485 port"
+	depends on ETRAX_RS485
 	help
-	  Enables the DMA6 output channel for ser0 (ttyS0).
-	  If you do not enable DMA, an interrupt for each character will be
-	  used when transmitting data.
-	  Normally you want to use DMA, unless you use the DMA channel for
-	  something else.
-
+	  Configure serial port 0 to be a full duplex (four wires) RS-485 port.
 endchoice
 
 config ETRAX_SER0_DTR_BIT
@@ -139,52 +157,28 @@ config ETRAX_SERIAL_PORT1
 	  Enables the ETRAX FS serial driver for ser1 (ttyS1).
 
 choice
-	prompt "Ser1 DMA in channel "
+	prompt "Ser1 default port type"
 	depends on ETRAX_SERIAL_PORT1
-	default ETRAX_SERIAL_PORT1_NO_DMA_IN
+	default ETRAX_SERIAL_PORT1_TYPE_232
 	help
-	  What DMA channel to use for ser1.
-
+	  Type of serial port.
 
-config ETRAX_SERIAL_PORT1_NO_DMA_IN
-	bool "Ser1 uses no DMA for input"
+config ETRAX_SERIAL_PORT1_TYPE_232
+	bool "Ser1 is a RS-232 port"
 	help
-	  Do not use DMA for ser1 input.
+	  Configure serial port 1 to be a RS-232 port.
 
-config ETRAX_SERIAL_PORT1_DMA5_IN
-	bool "Ser1 uses DMA5 for input"
-	depends on ETRAX_SERIAL_PORT1
-	help
-	  Enables the DMA5 input channel for ser1 (ttyS1).
-	  If you do not enable DMA, an interrupt for each character will be
-	  used when receiving data.
-	  Normally you want this on, unless you use the DMA channel for
-	  something else.
-
-endchoice
-
-choice
-	prompt "Ser1 DMA out channel "
-	depends on ETRAX_SERIAL_PORT1
-	default ETRAX_SERIAL_PORT1_NO_DMA_OUT
-	help
-	  What DMA channel to use for ser1.
-
-config ETRAX_SERIAL_PORT1_NO_DMA_OUT
-	bool "Ser1 uses no DMA for output"
+config ETRAX_SERIAL_PORT1_TYPE_485HD
+	bool "Ser1 is a half duplex RS-485 port"
+	depends on ETRAX_RS485
 	help
-	  Do not use DMA for ser1 output.
+	  Configure serial port 1 to be a half duplex (two wires) RS-485 port.
 
-config ETRAX_SERIAL_PORT1_DMA4_OUT
-	bool "Ser1 uses DMA4 for output"
-	depends on ETRAX_SERIAL_PORT1
+config ETRAX_SERIAL_PORT1_TYPE_485FD
+	bool "Ser1 is a full duplex RS-485 port"
+	depends on ETRAX_RS485
 	help
-	  Enables the DMA4 output channel for ser1 (ttyS1).
-	  If you do not enable DMA, an interrupt for each character will be
-	  used when transmitting data.
-	  Normally you want this on, unless you use the DMA channel for
-	  something else.
-
+	  Configure serial port 1 to be a full duplex (four wires) RS-485 port.
 endchoice
 
 config ETRAX_SER1_DTR_BIT
@@ -210,52 +204,31 @@ config ETRAX_SERIAL_PORT2
 	  Enables the ETRAX FS serial driver for ser2 (ttyS2).
 
 choice
-	prompt "Ser2 DMA in channel "
+	prompt "Ser2 default port type"
 	depends on ETRAX_SERIAL_PORT2
-	default ETRAX_SERIAL_PORT2_NO_DMA_IN
+	default ETRAX_SERIAL_PORT2_TYPE_232
 	help
-	  What DMA channel to use for ser2.
+	  What DMA channel to use for ser2
 
-
-config ETRAX_SERIAL_PORT2_NO_DMA_IN
-	bool "Ser2 uses no DMA for input"
+config ETRAX_SERIAL_PORT2_TYPE_232
+	bool "Ser2 is a RS-232 port"
 	help
-	  Do not use DMA for ser2 input.
-
-config ETRAX_SERIAL_PORT2_DMA3_IN
-	bool "Ser2 uses DMA3 for input"
-	depends on ETRAX_SERIAL_PORT2
-	help
-	  Enables the DMA3 input channel for ser2 (ttyS2).
-	  If you do not enable DMA, an interrupt for each character will be
-	  used when receiving data.
-	  Normally you want to use DMA, unless you use the DMA channel for
-	  something else.
-
-endchoice
-
-choice
-	prompt "Ser2 DMA out channel"
-	depends on ETRAX_SERIAL_PORT2
-	default ETRAX_SERIAL_PORT2_NO_DMA_OUT
+	  Configure serial port 2 to be a RS-232 port.
 
-config ETRAX_SERIAL_PORT2_NO_DMA_OUT
-	bool "Ser2 uses no DMA for output"
+config ETRAX_SERIAL_PORT2_TYPE_485HD
+	bool "Ser2 is a half duplex RS-485 port"
+	depends on ETRAX_RS485
 	help
-	  Do not use DMA for ser2 output.
+	  Configure serial port 2 to be a half duplex (two wires) RS-485 port.
 
-config ETRAX_SERIAL_PORT2_DMA2_OUT
-	bool "Ser2 uses DMA2 for output"
-	depends on ETRAX_SERIAL_PORT2
+config ETRAX_SERIAL_PORT2_TYPE_485FD
+	bool "Ser2 is a full duplex RS-485 port"
+	depends on ETRAX_RS485
 	help
-	  Enables the DMA2 output channel for ser2 (ttyS2).
-	  If you do not enable DMA, an interrupt for each character will be
-	  used when transmitting data.
-	  Normally you want to use DMA, unless you use the DMA channel for
-	  something else.
-
+	  Configure serial port 2 to be a full duplex (four wires) RS-485 port.
 endchoice
 
+
 config ETRAX_SER2_DTR_BIT
 	string "Ser 2 DTR bit (empty = not used)"
 	depends on ETRAX_SERIAL_PORT2
@@ -279,71 +252,121 @@ config ETRAX_SERIAL_PORT3
 	  Enables the ETRAX FS serial driver for ser3 (ttyS3).
 
 choice
-	prompt "Ser3 DMA in channel "
+	prompt "Ser3 default port type"
 	depends on ETRAX_SERIAL_PORT3
-	default ETRAX_SERIAL_PORT3_NO_DMA_IN
+	default ETRAX_SERIAL_PORT3_TYPE_232
 	help
 	  What DMA channel to use for ser3.
 
+config ETRAX_SERIAL_PORT3_TYPE_232
+	bool "Ser3 is a RS-232 port"
+	help
+	  Configure serial port 3 to be a RS-232 port.
+
+config ETRAX_SERIAL_PORT3_TYPE_485HD
+	bool "Ser3 is a half duplex RS-485 port"
+	depends on ETRAX_RS485
+	help
+	  Configure serial port 3 to be a half duplex (two wires) RS-485 port.
 
-config ETRAX_SERIAL_PORT3_NO_DMA_IN
-	bool "Ser3 uses no DMA for input"
+config ETRAX_SERIAL_PORT3_TYPE_485FD
+	bool "Ser3 is a full duplex RS-485 port"
+	depends on ETRAX_RS485
 	help
-	  Do not use DMA for ser3 input.
+	  Configure serial port 3 to be a full duplex (four wires) RS-485 port.
+endchoice
 
-config ETRAX_SERIAL_PORT3_DMA9_IN
-	bool "Ser3 uses DMA9 for input"
+config ETRAX_SER3_DTR_BIT
+	string "Ser 3 DTR bit (empty = not used)"
 	depends on ETRAX_SERIAL_PORT3
+
+config ETRAX_SER3_RI_BIT
+	string "Ser 3 RI bit (empty = not used)"
+	depends on ETRAX_SERIAL_PORT3
+
+config ETRAX_SER3_DSR_BIT
+	string "Ser 3 DSR bit (empty = not used)"
+	depends on ETRAX_SERIAL_PORT3
+
+config ETRAX_SER3_CD_BIT
+	string "Ser 3 CD bit (empty = not used)"
+	depends on ETRAX_SERIAL_PORT3
+
+config ETRAX_SERIAL_PORT4
+	bool "Serial port 4 enabled"
+	depends on ETRAXFS_SERIAL && CRIS_MACH_ARTPEC3
 	help
-	  Enables the DMA9 input channel for ser3 (ttyS3).
-	  If you do not enable DMA, an interrupt for each character will be
-	  used when receiving data.
-	  Normally you want to use DMA, unless you use the DMA channel for
-	  something else.
+	  Enables the ETRAX FS serial driver for ser4 (ttyS4).
+
+choice
+	prompt "Ser4 default port type"
+	depends on ETRAX_SERIAL_PORT4
+	default ETRAX_SERIAL_PORT4_TYPE_232
+	help
+	  What DMA channel to use for ser4.
+
+config ETRAX_SERIAL_PORT4_TYPE_232
+	bool "Ser4 is a RS-232 port"
+	help
+	  Configure serial port 4 to be a RS-232 port.
 
+config ETRAX_SERIAL_PORT4_TYPE_485HD
+	bool "Ser4 is a half duplex RS-485 port"
+	depends on ETRAX_RS485
+	help
+	  Configure serial port 4 to be a half duplex (two wires) RS-485 port.
+
+config ETRAX_SERIAL_PORT4_TYPE_485FD
+	bool "Ser4 is a full duplex RS-485 port"
+	depends on ETRAX_RS485
+	help
+	  Configure serial port 4 to be a full duplex (four wires) RS-485 port.
 endchoice
 
 choice
-	prompt "Ser3 DMA out channel"
-	depends on ETRAX_SERIAL_PORT3
-	default ETRAX_SERIAL_PORT3_NO_DMA_OUT
+	prompt "Ser4 DMA in channel "
+	depends on ETRAX_SERIAL_PORT4
+	default ETRAX_SERIAL_PORT4_NO_DMA_IN
+	help
+	  What DMA channel to use for ser4.
+
 
-config ETRAX_SERIAL_PORT3_NO_DMA_OUT
-	bool "Ser3 uses no DMA for output"
+config ETRAX_SERIAL_PORT4_NO_DMA_IN
+	bool "Ser4 uses no DMA for input"
 	help
-	  Do not use DMA for ser3 output.
+	  Do not use DMA for ser4 input.
 
-config ETRAX_SERIAL_PORT3_DMA8_OUT
-	bool "Ser3 uses DMA8 for output"
-	depends on ETRAX_SERIAL_PORT3
+config ETRAX_SERIAL_PORT4_DMA9_IN
+	bool "Ser4 uses DMA9 for input"
+	depends on ETRAX_SERIAL_PORT4
 	help
-	  Enables the DMA8 output channel for ser3 (ttyS3).
+	  Enables the DMA9 input channel for ser4 (ttyS4).
 	  If you do not enable DMA, an interrupt for each character will be
-	  used when transmitting data.
+	  used when receiveing data.
 	  Normally you want to use DMA, unless you use the DMA channel for
 	  something else.
 
 endchoice
 
-config ETRAX_SER3_DTR_BIT
-	string "Ser 3 DTR bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT3
+config ETRAX_SER4_DTR_BIT
+	string "Ser 4 DTR bit (empty = not used)"
+	depends on ETRAX_SERIAL_PORT4
 
-config ETRAX_SER3_RI_BIT
-	string "Ser 3 RI bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT3
+config ETRAX_SER4_RI_BIT
+	string "Ser 4 RI bit (empty = not used)"
+	depends on ETRAX_SERIAL_PORT4
 
-config ETRAX_SER3_DSR_BIT
-	string "Ser 3 DSR bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT3
+config ETRAX_SER4_DSR_BIT
+	string "Ser 4 DSR bit (empty = not used)"
+	depends on ETRAX_SERIAL_PORT4
 
 config ETRAX_SER3_CD_BIT
-	string "Ser 3 CD bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT3
+	string "Ser 4 CD bit (empty = not used)"
+	depends on ETRAX_SERIAL_PORT4
 
 config ETRAX_RS485
 	bool "RS-485 support"
-	depends on ETRAX_SERIAL
+	depends on ETRAXFS_SERIAL
 	help
 	  Enables support for RS-485 serial communication.  For a primer on
 	  RS-485, see <http://www.hw.cz/english/docs/rs485/rs485.html>.
@@ -354,7 +377,6 @@ config ETRAX_RS485_DISABLE_RECEIVER
 	help
 	  It is necessary to disable the serial receiver to avoid serial
 	  loopback.  Not all products are able to do this in software only.
-	  Axis 2400/2401 must disable receiver.
 
 config ETRAX_AXISFLASHMAP
 	bool "Axis flash-map support"
@@ -362,6 +384,7 @@ config ETRAX_AXISFLASHMAP
 	select MTD
 	select MTD_CFI
 	select MTD_CFI_AMDSTD
+	select MTD_JEDECPROBE
 	select MTD_CHAR
 	select MTD_BLOCK
 	select MTD_PARTITIONS
@@ -392,7 +415,7 @@ config ETRAX_SYNCHRONOUS_SERIAL0_DMA
 
 config ETRAX_SYNCHRONOUS_SERIAL_PORT1
          bool "Synchronous serial port 1 enabled"
-         depends on ETRAX_SYNCHRONOUS_SERIAL
+         depends on ETRAX_SYNCHRONOUS_SERIAL && ETRAXFS
          help
            Enabled synchronous serial port 1.
 
@@ -403,6 +426,31 @@ config ETRAX_SYNCHRONOUS_SERIAL1_DMA
            A synchronous serial port can run in manual or DMA mode.
            Selecting this option will make it run in DMA mode.
 
+config ETRAX_AXISFLASHMAP
+	bool "Axis flash-map support"
+	depends on ETRAX_ARCH_V32
+	select MTD
+	select MTD_CFI
+	select MTD_CFI_AMDSTD
+	select MTD_JEDECPROBE
+	select MTD_CHAR
+	select MTD_BLOCK
+	select MTD_PARTITIONS
+	select MTD_CONCAT
+	select MTD_COMPLEX_MAPPINGS
+	help
+	  This option enables MTD mapping of flash devices.  Needed to use
+	  flash memories.  If unsure, say Y.
+
+config ETRAX_AXISFLASHMAP_MTD0WHOLE
+	bool "MTD0 is whole boot flash device"
+	depends on ETRAX_AXISFLASHMAP
+	default N
+	help
+	  When this option is not set, mtd0 refers to the first partition
+	  on the boot flash device. When set, mtd0 refers to the whole
+	  device, with mtd1 referring to the first partition etc.
+
 config ETRAX_PTABLE_SECTOR
 	int "Byte-offset of partition table sector"
 	depends on ETRAX_AXISFLASHMAP
@@ -423,19 +471,27 @@ config ETRAX_NANDFLASH
 	  This option enables MTD mapping of NAND flash devices.  Needed to use
 	  NAND flash memories.  If unsure, say Y.
 
+config ETRAX_NANDBOOT
+	bool "Boot from NAND flash"
+	depends on ETRAX_NANDFLASH
+	help
+	  This options enables booting from NAND flash devices.
+	  Say Y if your boot code, kernel and root file system is in
+	  NAND flash. Say N if they are in NOR flash.
+
 config ETRAX_I2C
 	bool "I2C driver"
 	depends on ETRAX_ARCH_V32
 	help
-	  This option enabled the I2C driver used by e.g. the RTC driver.
+	  This option enables the I2C driver used by e.g. the RTC driver.
 
-config ETRAX_I2C_DATA_PORT
+config ETRAX_V32_I2C_DATA_PORT
 	string "I2C data pin"
 	depends on ETRAX_I2C
 	help
 	  The pin to use for I2C data.
 
-config ETRAX_I2C_CLK_PORT
+config ETRAX_V32_I2C_CLK_PORT
 	string "I2C clock pin"
 	depends on ETRAX_I2C
 	help
@@ -443,22 +499,10 @@ config ETRAX_I2C_CLK_PORT
 
 config ETRAX_RTC
 	bool "Real Time Clock support"
-	depends on ETRAX_ARCH_V32
+	depends on ETRAX_ARCH_V32 && ETRAX_I2C
 	help
 	  Enabled RTC support.
 
-choice
-	prompt "RTC chip"
-	depends on ETRAX_RTC
-	default ETRAX_PCF8563
-
-config ETRAX_PCF8563
-	bool "PCF8563"
-	help
-	  Philips PCF8563 RTC
-
-endchoice
-
 config ETRAX_GPIO
 	bool "GPIO support"
 	depends on ETRAX_ARCH_V32
@@ -474,33 +518,36 @@ config ETRAX_GPIO
 	  Remember that you need to setup the port directions appropriately in
 	  the General configuration.
 
-config ETRAX_PA_BUTTON_BITMASK
-	hex "PA-buttons bitmask"
+config ETRAX_VIRTUAL_GPIO
+	bool "Virtual GPIO support"
 	depends on ETRAX_GPIO
-	default "0x02"
 	help
-	  This is a bitmask (8 bits) with information about what bits on PA
-	  that are used for buttons.
-	  Most products has a so called TEST button on PA1, if that is true
-	  use 0x02 here.
-	  Use 00 if there are no buttons on PA.
-	  If the bitmask is <> 00 a button driver will be included in the gpio
-	  driver. ETRAX general I/O support must be enabled.
+	  Enables the virtual Etrax general port device (major 120, minor 6).
+	  It uses an I/O expander for the I2C-bus.
+
+config ETRAX_VIRTUAL_GPIO_INTERRUPT_PA_PIN
+	int "Virtual GPIO interrupt pin on PA pin"
+	range 0 7
+	depends on ETRAX_VIRTUAL_GPIO
+	help
+	  The pin to use on PA for virtual gpio interrupt.
 
 config ETRAX_PA_CHANGEABLE_DIR
 	hex "PA user changeable dir mask"
 	depends on ETRAX_GPIO
-	default "0x00"
+	default "0x00" if ETRAXFS
+	default "0x00000000" if !ETRAXFS
 	help
 	  This is a bitmask (8 bits) with information of what bits in PA that a
 	  user can change direction on using ioctl's.
 	  Bit set = changeable.
-	  You probably want 0x00 here, but it depends on your hardware.
+	  You probably want 0 here, but it depends on your hardware.
 
 config ETRAX_PA_CHANGEABLE_BITS
 	hex "PA user changeable bits mask"
 	depends on ETRAX_GPIO
-	default "0x00"
+	default "0x00" if ETRAXFS
+	default "0x00000000" if !ETRAXFS
 	help
 	  This is a bitmask (8 bits) with information of what bits in PA
 	  that a user can change the value on using ioctl's.
@@ -509,17 +556,19 @@ config ETRAX_PA_CHANGEABLE_BITS
 config ETRAX_PB_CHANGEABLE_DIR
 	hex "PB user changeable dir mask"
 	depends on ETRAX_GPIO
-	default "0x00000"
+	default "0x00000" if ETRAXFS
+	default "0x00000000" if !ETRAXFS
 	help
 	  This is a bitmask (18 bits) with information of what bits in PB
 	  that a user can change direction on using ioctl's.
 	  Bit set = changeable.
-	  You probably want 0x00000 here, but it depends on your hardware.
+	  You probably want 0 here, but it depends on your hardware.
 
 config ETRAX_PB_CHANGEABLE_BITS
 	hex "PB user changeable bits mask"
 	depends on ETRAX_GPIO
-	default "0x00000"
+	default "0x00000" if ETRAXFS
+	default "0x00000000" if !ETRAXFS
 	help
 	  This is a bitmask (18 bits) with information of what bits in PB
 	  that a user can change the value on using ioctl's.
@@ -528,17 +577,19 @@ config ETRAX_PB_CHANGEABLE_BITS
 config ETRAX_PC_CHANGEABLE_DIR
 	hex "PC user changeable dir mask"
 	depends on ETRAX_GPIO
-	default "0x00000"
+	default "0x00000" if ETRAXFS
+	default "0x00000000" if !ETRAXFS
 	help
 	  This is a bitmask (18 bits) with information of what bits in PC
 	  that a user can change direction on using ioctl's.
 	  Bit set = changeable.
-	  You probably want 0x00000 here, but it depends on your hardware.
+	  You probably want 0 here, but it depends on your hardware.
 
 config ETRAX_PC_CHANGEABLE_BITS
 	hex "PC user changeable bits mask"
 	depends on ETRAX_GPIO
-	default "0x00000"
+	default "0x00000" if ETRAXFS
+	default "0x00000000" if ETRAXFS
 	help
 	  This is a bitmask (18 bits) with information of what bits in PC
 	  that a user can change the value on using ioctl's.
@@ -546,7 +597,7 @@ config ETRAX_PC_CHANGEABLE_BITS
 
 config ETRAX_PD_CHANGEABLE_DIR
 	hex "PD user changeable dir mask"
-	depends on ETRAX_GPIO
+	depends on ETRAX_GPIO && ETRAXFS
 	default "0x00000"
 	help
 	  This is a bitmask (18 bits) with information of what bits in PD
@@ -556,7 +607,7 @@ config ETRAX_PD_CHANGEABLE_DIR
 
 config ETRAX_PD_CHANGEABLE_BITS
 	hex "PD user changeable bits mask"
-	depends on ETRAX_GPIO
+	depends on ETRAX_GPIO && ETRAXFS
 	default "0x00000"
 	help
 	  This is a bitmask (18 bits) with information of what bits in PD
@@ -565,7 +616,7 @@ config ETRAX_PD_CHANGEABLE_BITS
 
 config ETRAX_PE_CHANGEABLE_DIR
 	hex "PE user changeable dir mask"
-	depends on ETRAX_GPIO
+	depends on ETRAX_GPIO && ETRAXFS
 	default "0x00000"
 	help
 	  This is a bitmask (18 bits) with information of what bits in PE
@@ -575,20 +626,36 @@ config ETRAX_PE_CHANGEABLE_DIR
 
 config ETRAX_PE_CHANGEABLE_BITS
 	hex "PE user changeable bits mask"
-	depends on ETRAX_GPIO
+	depends on ETRAX_GPIO && ETRAXFS
 	default "0x00000"
 	help
 	  This is a bitmask (18 bits) with information of what bits in PE
 	  that a user can change the value on using ioctl's.
 	  Bit set = changeable.
 
+config ETRAX_PV_CHANGEABLE_DIR
+	hex "PV user changeable dir mask"
+	depends on ETRAX_VIRTUAL_GPIO
+	default "0x0000"
+	help
+	  This is a bitmask (16 bits) with information of what bits in PV
+	  that a user can change direction on using ioctl's.
+	  Bit set = changeable.
+	  You probably want 0x0000 here, but it depends on your hardware.
+
+config ETRAX_PV_CHANGEABLE_BITS
+	hex "PV user changeable bits mask"
+	depends on ETRAX_VIRTUAL_GPIO
+	default "0x0000"
+	help
+	  This is a bitmask (16 bits) with information of what bits in PV
+	  that a user can change the value on using ioctl's.
+	  Bit set = changeable.
+
 config ETRAX_CARDBUS
         bool "Cardbus support"
         depends on ETRAX_ARCH_V32
-        select PCCARD
-        select CARDBUS
         select HOTPLUG
-        select PCCARD_NONSTATIC
         help
 	 Enabled the ETRAX Cardbus driver.
 
@@ -610,3 +677,203 @@ config ETRAX_STREAMCOPROC
 	help
 	  This option enables a driver for the stream co-processor
 	  for cryptographic operations.
+
+source drivers/mmc/Kconfig
+
+config ETRAX_MMC_IOP
+	tristate "MMC/SD host driver using IO-processor"
+	depends on ETRAX_ARCH_V32 && MMC
+	help
+	  This option enables the SD/MMC host controller interface.
+	  The host controller is implemented using the built in
+	  IO-Processor. Only the SPU is used in this implementation.
+
+config ETRAX_SPI_MMC
+# Make this one of several "choices" (possible simultaneously but
+# suggested uniquely) when an IOP driver emerges for "real" MMC/SD
+# protocol support.
+	tristate
+	depends on !ETRAX_MMC_IOP
+	default MMC
+	select SPI
+	select MMC_SPI
+	select ETRAX_SPI_MMC_BOARD
+
+# For the parts that can't be a module (due to restrictions in
+# framework elsewhere).
+config ETRAX_SPI_MMC_BOARD
+       boolean
+       default n
+
+# While the board info is MMC_SPI only, the drivers are written to be
+# independent of MMC_SPI, so we'll keep SPI non-dependent on the
+# MMC_SPI config choices (well, except for a single depends-on-line
+# for the board-info file until a separate non-MMC SPI board file
+# emerges).
+# FIXME: When that happens, we'll need to be able to ask for and
+# configure non-MMC SPI ports together with MMC_SPI ports (if multiple
+# SPI ports are enabled).
+
+config SPI_ETRAX_SSER
+	tristate
+	depends on SPI_MASTER && ETRAX_ARCH_V32 && EXPERIMENTAL
+	select SPI_BITBANG
+	help
+	  This enables using an synchronous serial (sser) port as a
+	  SPI master controller on Axis ETRAX FS and later.  The
+	  driver can be configured to use any sser port.
+
+config SPI_ETRAX_GPIO
+	tristate
+	depends on SPI_MASTER && ETRAX_ARCH_V32 && EXPERIMENTAL
+	select SPI_BITBANG
+	help
+	  This enables using GPIO pins port as a SPI master controller
+	  on Axis ETRAX FS and later.  The driver can be configured to
+	  use any GPIO pins.
+
+config ETRAX_SPI_SSER0
+	tristate "SPI using synchronous serial port 0 (sser0)"
+	depends on ETRAX_SPI_MMC
+	default m if MMC_SPI=m
+	default y if MMC_SPI=y
+	default y if MMC_SPI=n
+	select SPI_ETRAX_SSER
+	help
+	  Say Y for an MMC/SD socket connected to synchronous serial port 0,
+	  or for devices using the SPI protocol on that port.  Say m if you
+	  want to build it as a module, which will be named spi_crisv32_sser.
+	  (You need to select MMC separately.)
+
+config ETRAX_SPI_SSER0_DMA
+	bool "DMA for SPI on sser0 enabled"
+	depends on ETRAX_SPI_SSER0
+	depends on !ETRAX_SERIAL_PORT1_DMA4_OUT && !ETRAX_SERIAL_PORT1_DMA5_IN
+	default y
+	help
+	  Say Y if using DMA (dma4/dma5) for SPI on synchronous serial port 0.
+
+config ETRAX_SPI_MMC_CD_SSER0_PIN
+	string "MMC/SD card detect pin for SPI on sser0"
+	depends on ETRAX_SPI_SSER0 && MMC_SPI
+	default "pd11"
+	help
+	  The pin to use for SD/MMC card detect.  This pin should be pulled up
+	  and grounded when a card is present.  If defined as " " (space), no
+	  pin is selected.  A card must then always be inserted for proper
+	  action.
+
+config ETRAX_SPI_MMC_WP_SSER0_PIN
+	string "MMC/SD card write-protect pin for SPI on sser0"
+	depends on ETRAX_SPI_SSER0 && MMC_SPI
+	default "pd10"
+	help
+	  The pin to use for the SD/MMC write-protect signal for a memory
+	  card.  If defined as " " (space), the card is considered writable.
+
+config ETRAX_SPI_SSER1
+	tristate "SPI using synchronous serial port 1 (sser1)"
+	depends on ETRAX_SPI_MMC
+	default m if MMC_SPI=m && ETRAX_SPI_SSER0=n
+	default y if MMC_SPI=y && ETRAX_SPI_SSER0=n
+	default y if MMC_SPI=n && ETRAX_SPI_SSER0=n
+	select SPI_ETRAX_SSER
+	help
+	  Say Y for an MMC/SD socket connected to synchronous serial port 1,
+	  or for devices using the SPI protocol on that port.  Say m if you
+	  want to build it as a module, which will be named spi_crisv32_sser.
+	  (You need to select MMC separately.)
+
+config ETRAX_SPI_SSER1_DMA
+	bool "DMA for SPI on sser1 enabled"
+	depends on ETRAX_SPI_SSER1 && !ETRAX_ETHERNET_IFACE1
+	depends on !ETRAX_SERIAL_PORT0_DMA6_OUT && !ETRAX_SERIAL_PORT0_DMA7_IN
+	default y
+	help
+	  Say Y if using DMA (dma6/dma7) for SPI on synchronous serial port 1.
+
+config ETRAX_SPI_MMC_CD_SSER1_PIN
+	string "MMC/SD card detect pin for SPI on sser1"
+	depends on ETRAX_SPI_SSER1 && MMC_SPI
+	default "pd12"
+	help
+	  The pin to use for SD/MMC card detect.  This pin should be pulled up
+	  and grounded when a card is present.  If defined as " " (space), no
+	  pin is selected.  A card must then always be inserted for proper
+	  action.
+
+config ETRAX_SPI_MMC_WP_SSER1_PIN
+	string "MMC/SD card write-protect pin for SPI on sser1"
+	depends on ETRAX_SPI_SSER1 && MMC_SPI
+	default "pd9"
+	help
+	  The pin to use for the SD/MMC write-protect signal for a memory
+	  card.  If defined as " " (space), the card is considered writable.
+
+config ETRAX_SPI_GPIO
+	tristate "Bitbanged SPI using gpio pins"
+	depends on ETRAX_SPI_MMC
+	select SPI_ETRAX_GPIO
+	default m if MMC_SPI=m && ETRAX_SPI_SSER0=n && ETRAX_SPI_SSER1=n
+	default y if MMC_SPI=y && ETRAX_SPI_SSER0=n && ETRAX_SPI_SSER1=n
+	default y if MMC_SPI=n && ETRAX_SPI_SSER0=n && ETRAX_SPI_SSER1=n
+	help
+	  Say Y for an MMC/SD socket connected to general I/O pins (but not
+	  a complete synchronous serial ports), or for devices using the SPI
+	  protocol on general I/O pins.  Slow and slows down the system.
+	  Say m to build it as a module, which will be called spi_crisv32_gpio.
+	  (You need to select MMC separately.)
+
+# The default match that of sser0, only because that's how it was tested.
+config ETRAX_SPI_CS_PIN
+	string "SPI chip select pin"
+	depends on ETRAX_SPI_GPIO
+	default "pc3"
+	help
+	  The pin to use for SPI chip select.
+
+config ETRAX_SPI_CLK_PIN
+	string "SPI clock pin"
+	depends on ETRAX_SPI_GPIO
+	default "pc1"
+	help
+	  The pin to use for the SPI clock.
+
+config ETRAX_SPI_DATAIN_PIN
+	string "SPI MISO (data in) pin"
+	depends on ETRAX_SPI_GPIO
+	default "pc16"
+	help
+	  The pin to use for SPI data in from the device.
+
+config ETRAX_SPI_DATAOUT_PIN
+	string "SPI MOSI (data out) pin"
+	depends on ETRAX_SPI_GPIO
+	default "pc0"
+	help
+	  The pin to use for SPI data out to the device.
+
+config ETRAX_SPI_MMC_CD_GPIO_PIN
+	string "MMC/SD card detect pin for SPI using gpio (space for none)"
+	depends on ETRAX_SPI_GPIO && MMC_SPI
+	default "pd11"
+	help
+	  The pin to use for SD/MMC card detect.  This pin should be pulled up
+	  and grounded when a card is present.  If defined as " " (space), no
+	  pin is selected.  A card must then always be inserted for proper
+	  action.
+
+config ETRAX_SPI_MMC_WP_GPIO_PIN
+	string "MMC/SD card write-protect pin for SPI using gpio (space for none)"
+	depends on ETRAX_SPI_GPIO && MMC_SPI
+	default "pd10"
+	help
+	  The pin to use for the SD/MMC write-protect signal for a memory
+	  card.  If defined as " " (space), the card is considered writable.
+
+# Avoid choices causing non-working configs by conditionalizing the inclusion.
+if ETRAX_SPI_MMC
+source drivers/spi/Kconfig
+endif
+
+endif
-- 
1.5.3.6.970.gd25430


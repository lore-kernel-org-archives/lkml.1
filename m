Return-Path: <linux-kernel-owner+w=401wt.eu-S932460AbXE1IoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbXE1IoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758416AbXE1IhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:37:01 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:2643 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761477AbXE1Igr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:36:47 -0400
X-IronPort-AV: i="4.14,586,1170651600"; 
   d="scan'208"; a="31069478:sNHT37917208"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>, Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH 19/20] Blackfin on-chip watchdog driver
Date: Mon, 28 May 2007 16:37:54 +0800
Message-Id: <11803414821370-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11803414753217-git-send-email-bryan.wu@analog.com>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

This patch implements the driver necessary use the Analog Devices
Blackfin processor's on-chip watchdog controller, supports
BF53[123]/BF53[467]/BF561.

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
---
 Documentation/watchdog/watchdog-api.txt |   25 +-
 MAINTAINERS                             |    8 +
 drivers/char/watchdog/Kconfig           |   13 +
 drivers/char/watchdog/Kconfig.orig      |  768 +++++++++++++++++++++++++++++++
 drivers/char/watchdog/Makefile          |    3 +
 drivers/char/watchdog/bfin_wdt.c        |  621 +++++++++++++++++++++++++
 6 files changed, 1437 insertions(+), 1 deletions(-)
 create mode 100644 drivers/char/watchdog/Kconfig.orig
 create mode 100644 drivers/char/watchdog/bfin_wdt.c

diff --git a/Documentation/watchdog/watchdog-api.txt b/Documentation/watchdog/watchdog-api.txt
index 8d16f6f..b7b77ac 100644
--- a/Documentation/watchdog/watchdog-api.txt
+++ b/Documentation/watchdog/watchdog-api.txt
@@ -252,7 +252,30 @@ advantechwdt.c -- Advantech Single Board Computer
 	GETSUPPORT returns WDIOF_KEEPALIVEPING and WDIOF_SETTIMEOUT.
 	The GETSTATUS call returns if the device is open or not.
 	[FIXME -- silliness again?]
-	
+
+bfin_wdt.c -- Blackfin On-Chip Watchdog Timer
+
+	Timeout defaults to 20 seconds and is limited to 2^32 /
+	System Clock HZ, supports SETTIMEOUT.
+
+	Supports CONFIG_WATCHDOG_NOWAYOUT.
+
+	GETSUPPORT returns WDIOF_KEEPALIVEPING and WDIOF_SETTIMEOUT.
+
+	GETBOOTSTATUS is supported.  GETSTATUS returns whether the
+	watchdog timer has expired (useful when watchdog generates an
+	interrupt rather than resets the processor).
+
+	The watchdog can be configured to reset the part, signal an
+	interrupt, or issue an NMI.
+
+	The dual core parts have two watchdog devices.  Only the
+	watchdog on the core actually running Linux is supported.
+
+	The default interrupt behavior is for waking up the processor.
+	Board people can customize this behavior; see the driver for
+	more information.
+
 booke_wdt.c -- PowerPC BookE Watchdog Timer
 
 	Timeout default varies according to frequency, supports
diff --git a/MAINTAINERS b/MAINTAINERS
index 0736b64..1d7b1ce 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -767,6 +767,14 @@ L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
 
+BLACKFIN WATCHDOG DRIVER
+P:	Mike Frysinger
+M:	michael.frysinger@analog.com
+M:	vapier.adi@gmail.com
+L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
+W:	http://blackfin.uclinux.org
+S:	Supported
+
 BAYCOM/HDLCDRV DRIVERS FOR AX.25
 P:	Thomas Sailer
 M:	t.sailer@alumni.ethz.ch
diff --git a/drivers/char/watchdog/Kconfig b/drivers/char/watchdog/Kconfig
index 1cad32c..43383f5 100644
--- a/drivers/char/watchdog/Kconfig
+++ b/drivers/char/watchdog/Kconfig
@@ -609,6 +609,19 @@ config SH_WDT_MMAP
 	  If you say Y here, user applications will be able to mmap the
 	  WDT/CPG registers.
 
+# Blackfin Architecture
+
+config BFIN_WDT
+	tristate "Blackfin On-Chip Watchdog Timer"
+	depends on WATCHDOG && BLACKFIN
+	---help---
+	  If you say yes here you will get support for the Blackfin On-Chip
+	  Watchdog Timer. If you have one of these processors and wish to
+	  have watchdog support enabled, say Y, otherwise say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bfin_wdt.
+
 # SPARC64 Architecture
 
 config WATCHDOG_CP1XXX
diff --git a/drivers/char/watchdog/Kconfig.orig b/drivers/char/watchdog/Kconfig.orig
new file mode 100644
index 0000000..1cad32c
--- /dev/null
+++ b/drivers/char/watchdog/Kconfig.orig
@@ -0,0 +1,768 @@
+#
+# Watchdog device configuration
+#
+
+menuconfig WATCHDOG
+	bool "Watchdog Timer Support"
+	---help---
+	  If you say Y here (and to one of the following options) and create a
+	  character special file /dev/watchdog with major number 10 and minor
+	  number 130 using mknod ("man mknod"), you will get a watchdog, i.e.:
+	  subsequently opening the file and then failing to write to it for
+	  longer than 1 minute will result in rebooting the machine. This
+	  could be useful for a networked machine that needs to come back
+	  on-line as fast as possible after a lock-up. There's both a watchdog
+	  implementation entirely in software (which can sometimes fail to
+	  reboot the machine) and a driver for hardware watchdog boards, which
+	  are more robust and can also keep track of the temperature inside
+	  your computer. For details, read <file:Documentation/watchdog/watchdog.txt>
+	  in the kernel source.
+
+	  The watchdog is usually used together with the watchdog daemon
+	  which is available from
+	  <ftp://ibiblio.org/pub/Linux/system/daemons/watchdog/>. This daemon can
+	  also monitor NFS connections and can reboot the machine when the process
+	  table is full.
+
+	  If unsure, say N.
+
+if WATCHDOG
+
+config WATCHDOG_NOWAYOUT
+	bool "Disable watchdog shutdown on close"
+	help
+	  The default watchdog behaviour (which you get if you say N here) is
+	  to stop the timer if the process managing it closes the file
+	  /dev/watchdog. It's always remotely possible that this process might
+	  get killed. If you say Y here, the watchdog cannot be stopped once
+	  it has been started.
+
+#
+# General Watchdog drivers
+#
+
+comment "Watchdog Device Drivers"
+
+# Architecture Independent
+
+config SOFT_WATCHDOG
+	tristate "Software watchdog"
+	help
+	  A software monitoring watchdog. This will fail to reboot your system
+	  from some situations that the hardware watchdog will recover
+	  from. Equally it's a lot cheaper to install.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called softdog.
+
+# ARM Architecture
+
+config AT91RM9200_WATCHDOG
+	tristate "AT91RM9200 watchdog"
+	depends on ARCH_AT91RM9200
+	help
+	  Watchdog timer embedded into AT91RM9200 chips. This will reboot your
+	  system when the timeout is reached.
+
+config 21285_WATCHDOG
+	tristate "DC21285 watchdog"
+	depends on FOOTBRIDGE
+	help
+	  The Intel Footbridge chip contains a built-in watchdog circuit. Say Y
+	  here if you wish to use this. Alternatively say M to compile the
+	  driver as a module, which will be called wdt285.
+
+	  This driver does not work on all machines. In particular, early CATS
+	  boards have hardware problems that will cause the machine to simply
+	  lock up if the watchdog fires.
+
+	  "If in doubt, leave it out" - say N.
+
+config 977_WATCHDOG
+	tristate "NetWinder WB83C977 watchdog"
+	depends on FOOTBRIDGE && ARCH_NETWINDER
+	help
+	  Say Y here to include support for the WB977 watchdog included in
+	  NetWinder machines. Alternatively say M to compile the driver as
+	  a module, which will be called wdt977.
+
+	  Not sure? It's safe to say N.
+
+config IXP2000_WATCHDOG
+	tristate "IXP2000 Watchdog"
+	depends on ARCH_IXP2000
+	help
+	  Say Y here if to include support for the watchdog timer
+	  in the Intel IXP2000(2400, 2800, 2850) network processors.
+	  This driver can be built as a module by choosing M. The module
+	  will be called ixp2000_wdt.
+
+	  Say N if you are unsure.
+
+config IXP4XX_WATCHDOG
+	tristate "IXP4xx Watchdog"
+	depends on ARCH_IXP4XX
+	help
+	  Say Y here if to include support for the watchdog timer
+	  in the Intel IXP4xx network processors. This driver can
+	  be built as a module by choosing M. The module will
+	  be called ixp4xx_wdt.
+
+	  Note: The internal IXP4xx watchdog does a soft CPU reset
+	  which doesn't reset any peripherals. There are circumstances
+	  where the watchdog will fail to reset the board correctly
+	  (e.g., if the boot ROM is in an unreadable state).
+
+	  Say N if you are unsure.
+
+config S3C2410_WATCHDOG
+	tristate "S3C2410 Watchdog"
+	depends on ARCH_S3C2410
+	help
+	  Watchdog timer block in the Samsung S3C2410 chips. This will
+	  reboot the system when the timer expires with the watchdog
+	  enabled.
+
+	  The driver is limited by the speed of the system's PCLK
+	  signal, so with reasonably fast systems (PCLK around 50-66MHz)
+	  then watchdog intervals of over approximately 20seconds are
+	  unavailable.
+
+	  The driver can be built as a module by choosing M, and will
+	  be called s3c2410_wdt
+
+config SA1100_WATCHDOG
+	tristate "SA1100/PXA2xx watchdog"
+	depends on ARCH_SA1100 || ARCH_PXA
+	help
+	  Watchdog timer embedded into SA11x0 and PXA2xx chips. This will
+	  reboot your system when timeout is reached.
+
+	  NOTE: once enabled, this timer cannot be disabled.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sa1100_wdt.
+
+config MPCORE_WATCHDOG
+	tristate "MPcore watchdog"
+	depends on ARM_MPCORE_PLATFORM && LOCAL_TIMERS
+	help
+	  Watchdog timer embedded into the MPcore system.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mpcore_wdt.
+
+config EP93XX_WATCHDOG
+	tristate "EP93xx Watchdog"
+	depends on ARCH_EP93XX
+	help
+	  Say Y here if to include support for the watchdog timer
+	  embedded in the Cirrus Logic EP93xx family of devices.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ep93xx_wdt.
+
+config OMAP_WATCHDOG
+	tristate "OMAP Watchdog"
+	depends on ARCH_OMAP16XX || ARCH_OMAP24XX
+	help
+	  Support for TI OMAP1610/OMAP1710/OMAP2420 watchdog.  Say 'Y' here to
+	  enable the OMAP1610/OMAP1710 watchdog timer.
+
+config PNX4008_WATCHDOG
+	tristate "PNX4008 Watchdog"
+	depends on ARCH_PNX4008
+	help
+	  Say Y here if to include support for the watchdog timer
+	  in the PNX4008 processor.
+	  This driver can be built as a module by choosing M. The module
+	  will be called pnx4008_wdt.
+
+	  Say N if you are unsure.
+
+# X86 (i386 + ia64 + x86_64) Architecture
+
+config ACQUIRE_WDT
+	tristate "Acquire SBC Watchdog Timer"
+	depends on X86
+	---help---
+	  This is the driver for the hardware watchdog on Single Board
+	  Computers produced by Acquire Inc (and others). This watchdog
+	  simply watches your kernel to make sure it doesn't freeze, and if
+	  it does, it reboots your computer after a certain amount of time.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called acquirewdt.
+
+	  Most people will say N.
+
+config ADVANTECH_WDT
+	tristate "Advantech SBC Watchdog Timer"
+	depends on X86
+	help
+	  If you are configuring a Linux kernel for the Advantech single-board
+	  computer, say `Y' here to support its built-in watchdog timer
+	  feature. More information can be found at
+	  <http://www.advantech.com.tw/products/>
+
+config ALIM1535_WDT
+	tristate "ALi M1535 PMU Watchdog Timer"
+	depends on X86 && PCI
+	---help---
+	  This is the driver for the hardware watchdog on the ALi M1535 PMU.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called alim1535_wdt.
+
+	  Most people will say N.
+
+config ALIM7101_WDT
+	tristate "ALi M7101 PMU Computer Watchdog"
+	depends on X86 && PCI
+	help
+	  This is the driver for the hardware watchdog on the ALi M7101 PMU
+	  as used in the x86 Cobalt servers.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called alim7101_wdt.
+
+	  Most people will say N.
+
+config SC520_WDT
+	tristate "AMD Elan SC520 processor Watchdog"
+	depends on X86
+	help
+	  This is the driver for the hardware watchdog built in to the
+	  AMD "Elan" SC520 microcomputer commonly used in embedded systems.
+	  This watchdog simply watches your kernel to make sure it doesn't
+	  freeze, and if it does, it reboots your computer after a certain
+	  amount of time.
+
+	  You can compile this driver directly into the kernel, or use
+	  it as a module.  The module will be called sc520_wdt.
+
+config EUROTECH_WDT
+	tristate "Eurotech CPU-1220/1410 Watchdog Timer"
+	depends on X86
+	help
+	  Enable support for the watchdog timer on the Eurotech CPU-1220 and
+	  CPU-1410 cards.  These are PC/104 SBCs. Spec sheets and product
+	  information are at <http://www.eurotech.it/>.
+
+config IB700_WDT
+	tristate "IB700 SBC Watchdog Timer"
+	depends on X86
+	---help---
+	  This is the driver for the hardware watchdog on the IB700 Single
+	  Board Computer produced by TMC Technology (www.tmc-uk.com). This watchdog
+	  simply watches your kernel to make sure it doesn't freeze, and if
+	  it does, it reboots your computer after a certain amount of time.
+
+	  This driver is like the WDT501 driver but for slightly different hardware.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ib700wdt.
+
+	  Most people will say N.
+
+config IBMASR
+	tristate "IBM Automatic Server Restart"
+	depends on X86
+	help
+	  This is the driver for the IBM Automatic Server Restart watchdog
+	  timer built-in into some eServer xSeries machines.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ibmasr.
+
+config WAFER_WDT
+	tristate "ICP Wafer 5823 Single Board Computer Watchdog"
+	depends on X86
+	help
+	  This is a driver for the hardware watchdog on the ICP Wafer 5823
+	  Single Board Computer (and probably other similar models).
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wafer5823wdt.
+
+config I6300ESB_WDT
+	tristate "Intel 6300ESB Timer/Watchdog"
+	depends on X86 && PCI
+	---help---
+	  Hardware driver for the watchdog timer built into the Intel
+	  6300ESB controller hub.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called i6300esb.
+
+config ITCO_WDT
+	tristate "Intel TCO Timer/Watchdog"
+	depends on (X86 || IA64) && PCI
+	---help---
+	  Hardware driver for the intel TCO timer based watchdog devices.
+	  These drivers are included in the Intel 82801 I/O Controller
+	  Hub family (from ICH0 up to ICH8) and in the Intel 6300ESB
+	  controller hub.
+
+	  The TCO (Total Cost of Ownership) timer is a watchdog timer
+	  that will reboot the machine after its second expiration. The
+	  expiration time can be configured with the "heartbeat" parameter.
+
+	  On some motherboards the driver may fail to reset the chipset's
+	  NO_REBOOT flag which prevents the watchdog from rebooting the
+	  machine. If this is the case you will get a kernel message like
+	  "failed to reset NO_REBOOT flag, reboot disabled by hardware".
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called iTCO_wdt.
+
+config ITCO_VENDOR_SUPPORT
+	bool "Intel TCO Timer/Watchdog Specific Vendor Support"
+	depends on ITCO_WDT
+	---help---
+	  Add vendor specific support to the intel TCO timer based watchdog
+	  devices. At this moment we only have additional support for some
+	  SuperMicro Inc. motherboards.
+
+config SC1200_WDT
+	tristate "National Semiconductor PC87307/PC97307 (ala SC1200) Watchdog"
+	depends on X86
+	help
+	  This is a driver for National Semiconductor PC87307/PC97307 hardware
+	  watchdog cards as found on the SC1200. This watchdog is mainly used
+	  for power management purposes and can be used to power down the device
+	  during inactivity periods (includes interrupt activity monitoring).
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sc1200wdt.
+
+	  Most people will say N.
+
+config SCx200_WDT
+	tristate "National Semiconductor SCx200 Watchdog"
+	depends on SCx200 && PCI
+	help
+	  Enable the built-in watchdog timer support on the National
+	  Semiconductor SCx200 processors.
+
+	  If compiled as a module, it will be called scx200_wdt.
+
+config PC87413_WDT
+	tristate "NS PC87413 watchdog"
+	depends on X86
+	---help---
+	  This is the driver for the hardware watchdog on the PC87413 chipset
+	  This watchdog simply watches your kernel to make sure it doesn't
+	  freeze, and if it does, it reboots your computer after a certain
+	  amount of time.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called pc87413_wdt.
+
+	  Most people will say N.
+ 
+config 60XX_WDT
+	tristate "SBC-60XX Watchdog Timer"
+	depends on X86
+	help
+	  This driver can be used with the watchdog timer found on some
+	  single board computers, namely the 6010 PII based computer.
+	  It may well work with other cards.  It reads port 0x443 to enable
+	  and re-set the watchdog timer, and reads port 0x45 to disable
+	  the watchdog.  If you have a card that behave in similar ways,
+	  you can probably make this driver work with your card as well.
+
+	  You can compile this driver directly into the kernel, or use
+	  it as a module.  The module will be called sbc60xxwdt.
+
+config SBC8360_WDT
+	tristate "SBC8360 Watchdog Timer"
+	depends on X86
+	---help---
+
+	  This is the driver for the hardware watchdog on the SBC8360 Single
+	  Board Computer produced by Axiomtek Co., Ltd. (www.axiomtek.com).
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sbc8360.ko.
+
+	  Most people will say N.
+
+config CPU5_WDT
+	tristate "SMA CPU5 Watchdog"
+	depends on X86
+	---help---
+	  TBD.
+	  To compile this driver as a module, choose M here: the
+	  module will be called cpu5wdt.
+
+config SMSC37B787_WDT
+	tristate "Winbond SMsC37B787 Watchdog Timer"
+	depends on X86
+	---help---
+	  This is the driver for the hardware watchdog component on the
+	  Winbond SMsC37B787 chipset as used on the NetRunner Mainboard
+	  from Vision Systems and maybe others.
+
+	  This watchdog simply watches your kernel to make sure it doesn't
+	  freeze, and if it does, it reboots your computer after a certain
+	  amount of time.
+
+	  Usually a userspace daemon will notify the kernel WDT driver that
+	  userspace is still alive, at regular intervals.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called smsc37b787_wdt.
+
+	  Most people will say N.
+
+config W83627HF_WDT
+	tristate "W83627HF Watchdog Timer"
+	depends on X86
+	---help---
+	  This is the driver for the hardware watchdog on the W83627HF chipset
+	  as used in Advantech PC-9578 and Tyan S2721-533 motherboards
+	  (and likely others).  This watchdog simply watches your kernel to
+	  make sure it doesn't freeze, and if it does, it reboots your computer
+	  after a certain amount of time.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called w83627hf_wdt.
+
+	  Most people will say N.
+
+config W83697HF_WDT
+	tristate "W83697HF/W83697HG Watchdog Timer"
+	depends on X86
+	---help---
+	  This is the driver for the hardware watchdog on the W83697HF/HG
+	  chipset as used in Dedibox/VIA motherboards (and likely others).
+	  This watchdog simply watches your kernel to make sure it doesn't
+	  freeze, and if it does, it reboots your computer after a certain
+	  amount of time.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called w83697hf_wdt.
+
+	  Most people will say N.
+
+config W83877F_WDT
+	tristate "W83877F (EMACS) Watchdog Timer"
+	depends on X86
+	---help---
+	  This is the driver for the hardware watchdog on the W83877F chipset
+	  as used in EMACS PC-104 motherboards (and likely others).  This
+	  watchdog simply watches your kernel to make sure it doesn't freeze,
+	  and if it does, it reboots your computer after a certain amount of
+	  time.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called w83877f_wdt.
+
+	  Most people will say N.
+
+config W83977F_WDT
+	tristate "W83977F (PCM-5335) Watchdog Timer"
+	depends on X86
+	---help---
+	  This is the driver for the hardware watchdog on the W83977F I/O chip
+	  as used in AAEON's PCM-5335 SBC (and likely others).  This
+	  watchdog simply watches your kernel to make sure it doesn't freeze,
+	  and if it does, it reboots your computer after a certain amount of
+	  time.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called w83977f_wdt.
+
+config MACHZ_WDT
+	tristate "ZF MachZ Watchdog"
+	depends on X86
+	---help---
+	  If you are using a ZF Micro MachZ processor, say Y here, otherwise
+	  N.  This is the driver for the watchdog timer built-in on that
+	  processor using ZF-Logic interface.  This watchdog simply watches
+	  your kernel to make sure it doesn't freeze, and if it does, it
+	  reboots your computer after a certain amount of time.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called machzwd.
+
+config SBC_EPX_C3_WATCHDOG
+	tristate "Winsystems SBC EPX-C3 watchdog"
+	depends on X86
+	---help---
+	  This is the driver for the built-in watchdog timer on the EPX-C3
+	  Single-board computer made by Winsystems, Inc.
+
+	  *Note*: This hardware watchdog is not probeable and thus there
+	  is no way to know if writing to its IO address will corrupt
+	  your system or have any real effect.  The only way to be sure
+	  that this driver does what you want is to make sure you
+	  are running it on an EPX-C3 from Winsystems with the watchdog
+	  timer at IO address 0x1ee and 0x1ef.  It will write to both those
+	  IO ports.  Basically, the assumption is made that if you compile
+	  this driver into your kernel and/or load it as a module, that you
+	  know what you are doing and that you are in fact running on an
+	  EPX-C3 board!
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sbc_epx_c3.
+
+# PowerPC Architecture
+
+config 8xx_WDT
+	tristate "MPC8xx Watchdog Timer"
+	depends on 8xx
+
+config 83xx_WDT
+	tristate "MPC83xx Watchdog Timer"
+	depends on PPC_83xx
+
+config MV64X60_WDT
+	tristate "MV64X60 (Marvell Discovery) Watchdog Timer"
+	depends on MV64X60
+
+config BOOKE_WDT
+	bool "PowerPC Book-E Watchdog Timer"
+	depends on BOOKE || 4xx
+	---help---
+	  Please see Documentation/watchdog/watchdog-api.txt for
+	  more information.
+
+# PPC64 Architecture
+
+config WATCHDOG_RTAS
+	tristate "RTAS watchdog"
+	depends on PPC_RTAS
+	help
+	  This driver adds watchdog support for the RTAS watchdog.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called wdrtas.
+
+# MIPS Architecture
+
+config INDYDOG
+	tristate "Indy/I2 Hardware Watchdog"
+	depends on SGI_IP22
+	help
+	  Hardware driver for the Indy's/I2's watchdog. This is a
+	  watchdog timer that will reboot the machine after a 60 second
+	  timer expired and no process has written to /dev/watchdog during
+	  that time.
+
+config WDT_MTX1
+	tristate "MTX-1 Hardware Watchdog"
+	depends on MIPS_MTX1
+	help
+	  Hardware driver for the MTX-1 boards. This is a watchdog timer that
+	  will reboot the machine after a 100 seconds timer expired.
+
+config WDT_RM9K_GPI
+	tristate "RM9000/GPI hardware watchdog"
+	depends on CPU_RM9000
+	help
+	  Watchdog implementation using the GPI hardware found on
+	  PMC-Sierra RM9xxx CPUs.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rm9k_wdt.
+
+# S390 Architecture
+
+config ZVM_WATCHDOG
+	tristate "z/VM Watchdog Timer"
+	depends on S390
+	help
+	  IBM s/390 and zSeries machines running under z/VM 5.1 or later
+	  provide a virtual watchdog timer to their guest that cause a
+	  user define Control Program command to be executed after a
+	  timeout.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called vmwatchdog.
+
+# SUPERH Architecture
+
+config SH_WDT
+	tristate "SuperH Watchdog"
+	depends on SUPERH
+	help
+	  This driver adds watchdog support for the integrated watchdog in the
+	  SuperH processors. If you have one of these processors and wish
+	  to have watchdog support enabled, say Y, otherwise say N.
+
+	  As a side note, saying Y here will automatically boost HZ to 1000
+	  so that the timer has a chance to clear the overflow counter. On
+	  slower systems (such as the SH-2 and SH-3) this will likely yield
+	  some performance issues. As such, the WDT should be avoided here
+	  unless it is absolutely necessary.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called shwdt.
+
+config SH_WDT_MMAP
+	bool "Allow mmap of SH WDT"
+	default n
+	depends on SH_WDT
+	help
+	  If you say Y here, user applications will be able to mmap the
+	  WDT/CPG registers.
+
+# SPARC64 Architecture
+
+config WATCHDOG_CP1XXX
+	tristate "CP1XXX Hardware Watchdog support"
+	depends on SPARC64 && PCI
+	---help---
+	  This is the driver for the hardware watchdog timers present on
+	  Sun Microsystems CompactPCI models CP1400 and CP1500.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cpwatchdog.
+
+	  If you do not have a CompactPCI model CP1400 or CP1500, or
+	  another UltraSPARC-IIi-cEngine boardset with hardware watchdog,
+	  you should say N to this option.
+
+config WATCHDOG_RIO
+	tristate "RIO Hardware Watchdog support"
+	depends on SPARC64 && PCI
+	help
+	  Say Y here to support the hardware watchdog capability on Sun RIO
+	  machines.  The watchdog timeout period is normally one minute but
+	  can be changed with a boot-time parameter.
+
+#
+# ISA-based Watchdog Cards
+#
+
+comment "ISA-based Watchdog Cards"
+	depends on ISA
+
+config PCWATCHDOG
+	tristate "Berkshire Products ISA-PC Watchdog"
+	depends on ISA
+	---help---
+	  This is the driver for the Berkshire Products ISA-PC Watchdog card.
+	  This card simply watches your kernel to make sure it doesn't freeze,
+	  and if it does, it reboots your computer after a certain amount of
+	  time. This driver is like the WDT501 driver but for different
+	  hardware. Please read <file:Documentation/watchdog/pcwd-watchdog.txt>. The PC
+	  watchdog cards can be ordered from <http://www.berkprod.com/>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called pcwd.
+
+	  Most people will say N.
+
+config MIXCOMWD
+	tristate "Mixcom Watchdog"
+	depends on ISA
+	---help---
+	  This is a driver for the Mixcom hardware watchdog cards.  This
+	  watchdog simply watches your kernel to make sure it doesn't freeze,
+	  and if it does, it reboots your computer after a certain amount of
+	  time.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mixcomwd.
+
+	  Most people will say N.
+
+config WDT
+	tristate "WDT Watchdog timer"
+	depends on ISA
+	---help---
+	  If you have a WDT500P or WDT501P watchdog board, say Y here,
+	  otherwise N. It is not possible to probe for this board, which means
+	  that you have to inform the kernel about the IO port and IRQ that
+	  is needed (you can do this via the io and irq parameters)
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wdt.
+
+config WDT_501
+	bool "WDT501 features"
+	depends on WDT
+	help
+	  Saying Y here and creating a character special file /dev/temperature
+	  with major number 10 and minor number 131 ("man mknod") will give
+	  you a thermometer inside your computer: reading from
+	  /dev/temperature yields one byte, the temperature in degrees
+	  Fahrenheit. This works only if you have a WDT501P watchdog board
+	  installed.
+
+	  If you want to enable the Fan Tachometer on the WDT501P, then you
+	  can do this via the tachometer parameter. Only do this if you have a
+	  fan tachometer actually set up.
+
+#
+# PCI-based Watchdog Cards
+#
+
+comment "PCI-based Watchdog Cards"
+	depends on PCI
+
+config PCIPCWATCHDOG
+	tristate "Berkshire Products PCI-PC Watchdog"
+	depends on PCI
+	---help---
+	  This is the driver for the Berkshire Products PCI-PC Watchdog card.
+	  This card simply watches your kernel to make sure it doesn't freeze,
+	  and if it does, it reboots your computer after a certain amount of
+	  time. The card can also monitor the internal temperature of the PC.
+	  More info is available at <http://www.berkprod.com/pci_pc_watchdog.htm>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called pcwd_pci.
+
+	  Most people will say N.
+
+config WDTPCI
+	tristate "PCI-WDT500/501 Watchdog timer"
+	depends on PCI
+	---help---
+	  If you have a PCI-WDT500/501 watchdog board, say Y here, otherwise N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wdt_pci.
+
+config WDT_501_PCI
+	bool "PCI-WDT501 features"
+	depends on WDTPCI
+	help
+	  Saying Y here and creating a character special file /dev/temperature
+	  with major number 10 and minor number 131 ("man mknod") will give
+	  you a thermometer inside your computer: reading from
+	  /dev/temperature yields one byte, the temperature in degrees
+	  Fahrenheit. This works only if you have a PCI-WDT501 watchdog board
+	  installed.
+
+	  If you want to enable the Fan Tachometer on the PCI-WDT501, then you
+	  can do this via the tachometer parameter. Only do this if you have a
+	  fan tachometer actually set up.
+
+#
+# USB-based Watchdog Cards
+#
+
+comment "USB-based Watchdog Cards"
+	depends on USB
+
+config USBPCWATCHDOG
+	tristate "Berkshire Products USB-PC Watchdog"
+	depends on USB
+	---help---
+	  This is the driver for the Berkshire Products USB-PC Watchdog card.
+	  This card simply watches your kernel to make sure it doesn't freeze,
+	  and if it does, it reboots your computer after a certain amount of
+	  time. The card can also monitor the internal temperature of the PC.
+	  More info is available at <http://www.berkprod.com/usb_pc_watchdog.htm>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called pcwd_usb.
+
+	  Most people will say N.
+
+endif # WATCHDOG
diff --git a/drivers/char/watchdog/Makefile b/drivers/char/watchdog/Makefile
index 8bfc00c..de1d75d 100644
--- a/drivers/char/watchdog/Makefile
+++ b/drivers/char/watchdog/Makefile
@@ -80,6 +80,9 @@ obj-$(CONFIG_WDT_RM9K_GPI) += rm9k_wdt.o
 # SUPERH Architecture
 obj-$(CONFIG_SH_WDT) += shwdt.o
 
+# Blackfin Architecture
+obj-$(CONFIG_BFIN_WDT) += bfin_wdt.o
+
 # SPARC64 Architecture
 
 # Architecture Independant
diff --git a/drivers/char/watchdog/bfin_wdt.c b/drivers/char/watchdog/bfin_wdt.c
new file mode 100644
index 0000000..d049a4c
--- /dev/null
+++ b/drivers/char/watchdog/bfin_wdt.c
@@ -0,0 +1,621 @@
+/*
+ * Blackfin On-Chip Watchdog Driver
+ *  Supports BF53[123]/BF53[467]/BF561
+ *
+ * Originally based on softdog.c
+ * Copyright 2006-2007 Analog Devices Inc.
+ * Copyright 2006-2007 Michele d'Amico
+ * Copyright 1996 Alan Cox <alan@redhat.com>
+ *
+ * Enter bugs at http://blackfin.uclinux.org/
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+/* Notes for people customizing General Purpose Interrupt (GPI) behavior.
+ *
+ * Normally when the watchdog times out, you reboot the system.  In
+ * some scenarios, you would rather have the machine come to a complete
+ * halt.  Or perhaps you want to wake the system up from sleep.  If the
+ * board provides some watchdog functions, we'll call those.  Otherwise,
+ * we'll let the GPI event wake up the processor if it's put to sleep.
+ *
+ * The functions you should implement in your board file:
+ *
+ *	irqreturn_t bfin_board_watchdog_interrupt(void);
+ *		called when the interrupt is fired.  perhaps you want to execute
+ *		kernel_halt() or do some other crazy stuff.
+ *
+ *	int bfin_board_watchdog_suspend(void);
+ *		called when suspending this device.  default behavior is to either
+ *		mark watchdog as a wakeup source (GPI) or turn it off (RESET).
+ *
+ *	int bfin_board_watchdog_resume(void);
+ *		called when resuming this device.  default behavior is to either
+ *		unmark watchdog as a wakeup source (GPI) or turn it on (RESET).
+ */
+
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/timer.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/fs.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <asm/blackfin.h>
+#include <asm/uaccess.h>
+
+#define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
+#define stampit() stamp("here i am")
+
+#define WATCHDOG_NAME "bfin-wdt"
+#define PFX WATCHDOG_NAME ": "
+
+/* The BF561 has two watchdogs (one per core), but since Linux
+ * only runs on core A, we'll just work with that one.
+ */
+#ifdef BF561_FAMILY
+# define bfin_read_WDOG_CTL()    bfin_read_WDOGA_CTL()
+# define bfin_read_WDOG_CNT()    bfin_read_WDOGA_CNT()
+# define bfin_read_WDOG_STAT()   bfin_read_WDOGA_STAT()
+# define bfin_write_WDOG_CTL(x)  bfin_write_WDOGA_CTL(x)
+# define bfin_write_WDOG_CNT(x)  bfin_write_WDOGA_CNT(x)
+# define bfin_write_WDOG_STAT(x) bfin_write_WDOGA_STAT(x)
+#endif
+
+/* Bit in SWRST that indicates boot caused by watchdog */
+#define SWRST_RESET_WDOG 0x4000
+
+/* Bit in WDOG_CTL that indicates watchdog has expired (WDR0) */
+#define WDOG_EXPIRED 0x8000
+
+/* Masks for WDEV field in WDOG_CTL register */
+#define ICTL_RESET   0x0
+#define ICTL_NMI     0x2
+#define ICTL_GPI     0x4
+#define ICTL_NONE    0x6
+#define ICTL_MASK    0x6
+
+/* Masks for WDEN field in WDOG_CTL register */
+#define WDEN_MASK    0x0FF0
+#define WDEN_ENABLE  0x0000
+#define WDEN_DISABLE 0x0AD0
+
+/* some defaults */
+#define WATCHDOG_TIMEOUT 20
+#define WATCHDOG_ACTION 0 /* 0 = ICTL_RESET */
+
+static unsigned int timeout = WATCHDOG_TIMEOUT;
+static int nowayout = WATCHDOG_NOWAYOUT;
+static unsigned int action = WATCHDOG_ACTION;
+static struct watchdog_info bfin_wdt_info;
+static unsigned long open_check;
+static char expect_close, bfin_wdt_expired = 0;
+static spinlock_t bfin_wdt_spinlock = SPIN_LOCK_UNLOCKED;
+
+/**
+ *	bfin_wdt_keepalive - Keep the Userspace Watchdog Alive
+ *
+ * 	The Userspace watchdog got a KeepAlive: schedule the next timeout.
+ */
+static int bfin_wdt_keepalive(void)
+{
+	stampit();
+	bfin_write_WDOG_STAT(0);
+	return 0;
+}
+
+/**
+ *	bfin_wdt_stop - Stop the Watchdog
+ *
+ *	Stops the on-chip watchdog.
+ */
+static int bfin_wdt_stop(void)
+{
+	stampit();
+	bfin_write_WDOG_CTL((bfin_read_WDOG_CTL() & ~WDEN_MASK) | WDEN_DISABLE);
+	return 0;
+}
+
+/**
+ *	bfin_wdt_start - Start the Watchdog
+ *
+ *	Starts the on-chip watchdog.  Automatically loads WDOG_CNT
+ *	into WDOG_STAT for us.
+ */
+static int bfin_wdt_start(void)
+{
+	stampit();
+	bfin_write_WDOG_CTL((bfin_read_WDOG_CTL() & ~WDEN_MASK) | WDEN_ENABLE);
+	return 0;
+}
+
+/**
+ *	bfin_wdt_running - Check Watchdog status
+ *
+ *	See if the watchdog is running.
+ */
+static int bfin_wdt_running(void)
+{
+	return ((bfin_read_WDOG_CTL() & WDEN_MASK) != WDEN_DISABLE);
+}
+
+/**
+ *	bfin_wdt_set_timeout - Set the Userspace Watchdog timeout
+ *	@t: new timeout value (in seconds)
+ *
+ *	Translate the specified timeout in seconds into System Clock
+ *	terms which is what the on-chip Watchdog requires.
+ */
+static int bfin_wdt_set_timeout(unsigned long t)
+{
+	u32 cnt;
+	unsigned long flags;
+
+	stampit();
+
+	cnt = t * get_sclk();
+	if (cnt < get_sclk()) {
+		printk(KERN_WARNING PFX "timeout value is too large\n");
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&bfin_wdt_spinlock, flags);
+	{
+		int run = bfin_wdt_running();
+		bfin_wdt_stop();
+		bfin_write_WDOG_CNT(cnt);
+		if (run) bfin_wdt_start();
+	}
+	spin_unlock_irqrestore(&bfin_wdt_spinlock, flags);
+
+	timeout = t;
+
+	return 0;
+}
+
+/**
+ *	bfin_wdt_interrupt - General Purpose Watchdog Interrupt Handler
+ *	@irq: irq # that triggered us
+ *	@dev_id: this device instance
+ *
+ *	Call board-specific ISR if it exists, otherwise we need to stop
+ *	and start the watchdog -- simply forcing a reload of the count
+ *	will not reset the interrupt status.
+ *
+ *	Note: While we could interrogate the WDR0 bit in WDOG_CTL, that
+ *	      requires us to turn off/on the watchdog to clear it.  So
+ *	      we'll just suck it up and mimic the bit with bfin_wdt_expired.
+ */
+extern irqreturn_t bfin_board_watchdog_interrupt(void) __attribute__((weak));
+static irqreturn_t bfin_wdt_interrupt(int irq, void *dev_id)
+{
+	bfin_wdt_expired = 1;
+	if (bfin_board_watchdog_interrupt) {
+		return bfin_board_watchdog_interrupt();
+	} else {
+		bfin_wdt_stop();
+		bfin_wdt_keepalive();
+		bfin_wdt_start();
+		return IRQ_HANDLED;
+	}
+}
+
+/**
+ *	bfin_wdt_open - Open the Device
+ *	@inode: inode of device
+ *	@file: file handle of device
+ *
+ *	Watchdog device is opened and started.
+ */
+static int bfin_wdt_open(struct inode *inode, struct file *file)
+{
+	stampit();
+
+	if (test_and_set_bit(0, &open_check))
+		return -EBUSY;
+
+	if (nowayout)
+		__module_get(THIS_MODULE);
+
+	bfin_wdt_keepalive();
+	bfin_wdt_start();
+
+	return nonseekable_open(inode, file);
+}
+
+/**
+ *	bfin_wdt_close - Close the Device
+ *	@inode: inode of device
+ *	@file: file handle of device
+ *
+ *	Watchdog device is closed and stopped.
+ */
+static int bfin_wdt_release(struct inode *inode, struct file *file)
+{
+	stampit();
+
+	if (expect_close == 42) {
+		bfin_wdt_stop();
+	} else {
+		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		bfin_wdt_keepalive();
+	}
+
+	expect_close = 0;
+	clear_bit(0, &open_check);
+
+	return 0;
+}
+
+/**
+ *	bfin_wdt_write - Write to Device
+ *	@file: file handle of device
+ *	@buf: buffer to write
+ *	@count: length of buffer
+ *	@ppos: offset
+ *
+ *	Pings the watchdog on write.
+ */
+static ssize_t bfin_wdt_write(struct file *file, const char __user *data,
+                              size_t len, loff_t *ppos)
+{
+	stampit();
+
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			/* In case it was set long ago */
+			expect_close = 0;
+
+			for (i = 0; i != len; i++) {
+				char c;
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					expect_close = 42;
+			}
+		}
+		bfin_wdt_keepalive();
+	}
+
+	return len;
+}
+
+/**
+ *	bfin_wdt_ioctl - Query Device
+ *	@inode: inode of device
+ *	@file: file handle of device
+ *	@cmd: watchdog command
+ *	@arg: argument
+ *
+ *	Query basic information from the device or ping it, as outlined by the
+ *	watchdog API.
+ */
+static int bfin_wdt_ioctl(struct inode *inode, struct file *file,
+                          unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+
+	stampit();
+
+	switch (cmd) {
+		default:
+			return -ENOTTY;
+
+		case WDIOC_GETSUPPORT:
+			if (copy_to_user(argp, &bfin_wdt_info, sizeof(bfin_wdt_info)))
+				return -EFAULT;
+			else
+				return 0;
+
+		case WDIOC_GETSTATUS: {
+			int ret = bfin_wdt_expired;
+			bfin_wdt_expired = 0;
+			return put_user(ret, p);
+		}
+
+		case WDIOC_GETBOOTSTATUS:
+			return put_user(!!(_bfin_swrst & SWRST_RESET_WDOG), p);
+
+		case WDIOC_KEEPALIVE:
+			bfin_wdt_keepalive();
+			return 0;
+
+		case WDIOC_SETTIMEOUT: {
+			int new_timeout;
+
+			if (get_user(new_timeout, p))
+				return -EFAULT;
+
+			if (bfin_wdt_set_timeout(new_timeout))
+				return -EINVAL;
+		}
+			/* Fall */
+		case WDIOC_GETTIMEOUT:
+			return put_user(timeout, p);
+
+		case WDIOC_SETOPTIONS: {
+			unsigned long flags;
+			int options, ret = -EINVAL;
+
+			if (get_user(options, p))
+				return -EFAULT;
+
+			spin_lock_irqsave(&bfin_wdt_spinlock, flags);
+
+			if (options & WDIOS_DISABLECARD) {
+				bfin_wdt_stop();
+				ret = 0;
+			}
+
+			if (options & WDIOS_ENABLECARD) {
+				bfin_wdt_start();
+				ret = 0;
+			}
+
+			spin_unlock_irqrestore(&bfin_wdt_spinlock, flags);
+
+			return ret;
+		}
+	}
+}
+
+/**
+ *	bfin_wdt_notify_sys - Notifier Handler
+ *	@this: notifier block
+ *	@code: notifier event
+ *	@unused: unused
+ *
+ *	Handles specific events, such as turning off the watchdog during a
+ *	shutdown event.
+ */
+static int bfin_wdt_notify_sys(struct notifier_block *this, unsigned long code,
+                               void *unused)
+{
+	stampit();
+
+	if (code == SYS_DOWN || code == SYS_HALT)
+		bfin_wdt_stop();
+
+	return NOTIFY_DONE;
+}
+
+/**
+ *	bfin_wdt_probe - Init per-device settings
+ *	@pdev: device being probed
+ *
+ *	If we are in GPI mode, grab the interrupt.
+ */
+static int __devinit bfin_wdt_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	stampit();
+
+	if (action == ICTL_GPI) {
+		ret = request_irq(IRQ_WATCH, bfin_wdt_interrupt,
+		                  IRQF_DISABLED, WATCHDOG_NAME, pdev);
+		if (ret) {
+			printk(KERN_ERR PFX "unable to allocate watchdog IRQ %i (err=%d)\n",
+			       IRQ_WATCH, ret);
+			clear_bit(0, &open_check);
+			return ret;
+		}
+
+		device_init_wakeup(&pdev->dev, 0);
+	}
+
+	return 0;
+}
+
+/**
+ *	bfin_wdt_remove - Free per-device settings
+ *	@pdev: device being removed
+ *
+ *	If we were in GPI mode, free the interrupt.
+ */
+static int __devexit bfin_wdt_remove(struct platform_device *pdev)
+{
+	stampit();
+
+	if (action == ICTL_GPI) {
+		device_init_wakeup(&pdev->dev, 0);
+		free_irq(IRQ_WATCH, pdev);
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int bfin_wdt_pm_state;
+
+/**
+ *	bfin_wdt_suspend - suspend the watchdog
+ *	@pdev: device being suspended
+ *	@state: requested suspend state
+ *
+ *	Remember if the watchdog was running and stop it.
+ *	TODO: is this even right?  Doesn't seem to be any
+ *	      standard in the watchdog world ...
+ */
+extern int bfin_board_watchdog_suspend(void) __attribute__((weak));
+static int bfin_wdt_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	stampit();
+
+	if (bfin_board_watchdog_suspend) {
+		return bfin_board_watchdog_suspend();
+	} else if (action == ICTL_GPI) {
+		if (device_may_wakeup(&pdev->dev))
+			enable_irq_wake(IRQ_WATCH);
+	} else {
+		bfin_wdt_pm_state = bfin_wdt_running();
+		bfin_wdt_stop();
+	}
+
+	return 0;
+}
+
+/**
+ *	bfin_wdt_resume - resume the watchdog
+ *	@pdev: device being resumed
+ *
+ *	If the watchdog was running, turn it back on.
+ */
+extern int bfin_board_watchdog_resume(void) __attribute__((weak));
+static int bfin_wdt_resume(struct platform_device *pdev)
+{
+	stampit();
+
+	if (bfin_board_watchdog_resume) {
+		return bfin_board_watchdog_resume();
+	} else if (action == ICTL_GPI) {
+		if (device_may_wakeup(&pdev->dev))
+			disable_irq_wake(IRQ_WATCH);
+	} else if (bfin_wdt_pm_state) {
+		bfin_wdt_set_timeout(timeout);
+		bfin_wdt_start();
+	}
+
+	return 0;
+}
+#else
+# define bfin_wdt_suspend NULL
+# define bfin_wdt_resume NULL
+#endif
+
+static struct platform_device bfin_wdt_device = {
+	.name          = WATCHDOG_NAME,
+	.id            = -1,
+};
+
+static struct platform_driver bfin_wdt_driver = {
+	.driver    = {
+		.name  = WATCHDOG_NAME,
+		.owner = THIS_MODULE,
+	},
+	.probe     = bfin_wdt_probe,
+	.remove    = __devexit_p(bfin_wdt_remove),
+	.suspend   = bfin_wdt_suspend,
+	.resume    = bfin_wdt_resume,
+};
+
+static struct file_operations bfin_wdt_fops = {
+	.owner    = THIS_MODULE,
+	.llseek   = no_llseek,
+	.write    = bfin_wdt_write,
+	.ioctl    = bfin_wdt_ioctl,
+	.open     = bfin_wdt_open,
+	.release  = bfin_wdt_release,
+};
+
+static struct miscdevice bfin_wdt_miscdev = {
+	.minor    = WATCHDOG_MINOR,
+	.name     = "watchdog",
+	.fops     = &bfin_wdt_fops,
+};
+
+static struct watchdog_info bfin_wdt_info = {
+	.identity = "Blackfin Watchdog",
+	.options  = WDIOF_SETTIMEOUT |
+	            WDIOF_KEEPALIVEPING |
+	            WDIOF_MAGICCLOSE,
+};
+
+static struct notifier_block bfin_wdt_notifier = {
+	.notifier_call = bfin_wdt_notify_sys,
+};
+
+/**
+ *	bfin_wdt_init - Initialize module
+ *
+ *	Registers the device and notifier handler. Actual device
+ *	initialization is handled by bfin_wdt_open().
+ */
+static int __init bfin_wdt_init(void)
+{
+	const u16 code2action[] = { ICTL_RESET, ICTL_NMI, ICTL_GPI, ICTL_NONE };
+	int ret;
+
+	stampit();
+
+	/* Check that the timeout value is within range */
+	if (bfin_wdt_set_timeout(timeout))
+		return -EINVAL;
+
+	/* Check that the action value is within range */
+	if (action >= ARRAY_SIZE(code2action)) {
+		printk(KERN_ERR PFX "invalid action, must be: 0 (reboot), 1 (NMI), 2 (GPI), 3 (none)\n");
+		return -EINVAL;
+	} else {
+		action = code2action[action];
+		bfin_write_WDOG_CTL((bfin_read_WDOG_CTL() & ~ICTL_MASK) | action);
+	}
+
+	/* Since this is an on-chip device and needs no board-specific
+	 * resources, we'll handle all the platform device stuff here.
+	 */
+	ret = platform_device_register(&bfin_wdt_device);
+	if (ret)
+		return ret;
+
+	ret = platform_driver_probe(&bfin_wdt_driver, NULL);
+	if (ret)
+		return ret;
+
+	ret = register_reboot_notifier(&bfin_wdt_notifier);
+	if (ret) {
+		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n", ret);
+		return ret;
+	}
+
+	ret = misc_register(&bfin_wdt_miscdev);
+	if (ret) {
+		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
+		unregister_reboot_notifier(&bfin_wdt_notifier);
+		return ret;
+	}
+
+	printk(KERN_INFO PFX "initialized: action=%d timeout=%d sec (nowayout=%d)\n",
+	       action, timeout, nowayout);
+
+	return 0;
+}
+
+/**
+ *	bfin_wdt_exit - Deinitialize module
+ *
+ *	Unregisters the device and notifier handler. Actual device
+ *	deinitialization is handled by bfin_wdt_close().
+ */
+static void __exit bfin_wdt_exit(void)
+{
+	misc_deregister(&bfin_wdt_miscdev);
+	unregister_reboot_notifier(&bfin_wdt_notifier);
+}
+
+module_init(bfin_wdt_init);
+module_exit(bfin_wdt_exit);
+
+MODULE_AUTHOR("Michele d'Amico, Mike Frysinger <vapier@gentoo.org>");
+MODULE_DESCRIPTION("Blackfin Watchdog Device Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+
+module_param(timeout, uint, 0);
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (1<=timeout<=((2^32)/SCLK), default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+module_param(action, uint, 0);
+MODULE_PARM_DESC(action, "Watchdog timeout action: 0 for reboot, 1 for NMI, 2 for General Purpose Interrupt, 3 for none (default=" __MODULE_STRING(WATCHDOG_ACTION) ")");
-- 
1.5.2

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760095AbXKIXT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095AbXKIXT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbXKIXTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:19:14 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:51337 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbXKIXTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:19:07 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 02/11] x86: start unification of arch/x86/Kconfig.*
Date: Sat, 10 Nov 2007 00:20:36 +0100
Message-Id: <11946504451172-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <20071109230812.GA5176@uranus.ravnborg.org>
References: <20071109230812.GA5176@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This step introduces the file arch/x86/Kconfig
which contains all the menu's from "Power Management"
and below.

The main part of the new Kconfig file is shared
and the remaining i386/x86_64 specific symbols
are covered by dependencies.

A x86_64 allmodconfig build did not show any differences.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/Kconfig        |  401 +++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/Kconfig.i386   |  326 +--------------------------------------
 arch/x86/Kconfig.x86_64 |  135 +----------------
 3 files changed, 404 insertions(+), 458 deletions(-)
 create mode 100644 arch/x86/Kconfig

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
new file mode 100644
index 0000000..d1382c5
--- /dev/null
+++ b/arch/x86/Kconfig
@@ -0,0 +1,401 @@
+menu "Power management options"
+	depends on !X86_VOYAGER
+
+config ARCH_HIBERNATION_HEADER
+	bool
+	depends on X86_64 && HIBERNATION
+	default y
+
+source "kernel/power/Kconfig"
+
+source "drivers/acpi/Kconfig"
+
+menuconfig APM
+	tristate "APM (Advanced Power Management) BIOS support"
+	depends on X86_32 && PM_SLEEP && !X86_VISWS
+	---help---
+	  APM is a BIOS specification for saving power using several different
+	  techniques. This is mostly useful for battery powered laptops with
+	  APM compliant BIOSes. If you say Y here, the system time will be
+	  reset after a RESUME operation, the /proc/apm device will provide
+	  battery status information, and user-space programs will receive
+	  notification of APM "events" (e.g. battery status change).
+
+	  If you select "Y" here, you can disable actual use of the APM
+	  BIOS by passing the "apm=off" option to the kernel at boot time.
+
+	  Note that the APM support is almost completely disabled for
+	  machines with more than one CPU.
+
+	  In order to use APM, you will need supporting software. For location
+	  and more information, read <file:Documentation/pm.txt> and the
+	  Battery Powered Linux mini-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.
+
+	  This driver does not spin down disk drives (see the hdparm(8)
+	  manpage ("man 8 hdparm") for that), and it doesn't turn off
+	  VESA-compliant "green" monitors.
+
+	  This driver does not support the TI 4000M TravelMate and the ACER
+	  486/DX4/75 because they don't have compliant BIOSes. Many "green"
+	  desktop machines also don't have compliant BIOSes, and this driver
+	  may cause those machines to panic during the boot phase.
+
+	  Generally, if you don't have a battery in your machine, there isn't
+	  much point in using this driver and you should say N. If you get
+	  random kernel OOPSes or reboots that don't seem to be related to
+	  anything, try disabling/enabling this option (or disabling/enabling
+	  APM in your BIOS).
+
+	  Some other things you should try when experiencing seemingly random,
+	  "weird" problems:
+
+	  1) make sure that you have enough swap space and that it is
+	  enabled.
+	  2) pass the "no-hlt" option to the kernel
+	  3) switch on floating point emulation in the kernel and pass
+	  the "no387" option to the kernel
+	  4) pass the "floppy=nodma" option to the kernel
+	  5) pass the "mem=4M" option to the kernel (thereby disabling
+	  all but the first 4 MB of RAM)
+	  6) make sure that the CPU is not over clocked.
+	  7) read the sig11 FAQ at <http://www.bitwizard.nl/sig11/>
+	  8) disable the cache from your BIOS settings
+	  9) install a fan for the video card or exchange video RAM
+	  10) install a better fan for the CPU
+	  11) exchange RAM chips
+	  12) exchange the motherboard.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called apm.
+
+if APM
+
+config APM_IGNORE_USER_SUSPEND
+	bool "Ignore USER SUSPEND"
+	help
+	  This option will ignore USER SUSPEND requests. On machines with a
+	  compliant APM BIOS, you want to say N. However, on the NEC Versa M
+	  series notebooks, it is necessary to say Y because of a BIOS bug.
+
+config APM_DO_ENABLE
+	bool "Enable PM at boot time"
+	---help---
+	  Enable APM features at boot time. From page 36 of the APM BIOS
+	  specification: "When disabled, the APM BIOS does not automatically
+	  power manage devices, enter the Standby State, enter the Suspend
+	  State, or take power saving steps in response to CPU Idle calls."
+	  This driver will make CPU Idle calls when Linux is idle (unless this
+	  feature is turned off -- see "Do CPU IDLE calls", below). This
+	  should always save battery power, but more complicated APM features
+	  will be dependent on your BIOS implementation. You may need to turn
+	  this option off if your computer hangs at boot time when using APM
+	  support, or if it beeps continuously instead of suspending. Turn
+	  this off if you have a NEC UltraLite Versa 33/C or a Toshiba
+	  T400CDT. This is off by default since most machines do fine without
+	  this feature.
+
+config APM_CPU_IDLE
+	bool "Make CPU Idle calls when idle"
+	help
+	  Enable calls to APM CPU Idle/CPU Busy inside the kernel's idle loop.
+	  On some machines, this can activate improved power savings, such as
+	  a slowed CPU clock rate, when the machine is idle. These idle calls
+	  are made after the idle loop has run for some length of time (e.g.,
+	  333 mS). On some machines, this will cause a hang at boot time or
+	  whenever the CPU becomes idle. (On machines with more than one CPU,
+	  this option does nothing.)
+
+config APM_DISPLAY_BLANK
+	bool "Enable console blanking using APM"
+	help
+	  Enable console blanking using the APM. Some laptops can use this to
+	  turn off the LCD backlight when the screen blanker of the Linux
+	  virtual console blanks the screen. Note that this is only used by
+	  the virtual console screen blanker, and won't turn off the backlight
+	  when using the X Window system. This also doesn't have anything to
+	  do with your VESA-compliant power-saving monitor. Further, this
+	  option doesn't work for all laptops -- it might not turn off your
+	  backlight at all, or it might print a lot of errors to the console,
+	  especially if you are using gpm.
+
+config APM_ALLOW_INTS
+	bool "Allow interrupts during APM BIOS calls"
+	help
+	  Normally we disable external interrupts while we are making calls to
+	  the APM BIOS as a measure to lessen the effects of a badly behaving
+	  BIOS implementation.  The BIOS should reenable interrupts if it
+	  needs to.  Unfortunately, some BIOSes do not -- especially those in
+	  many of the newer IBM Thinkpads.  If you experience hangs when you
+	  suspend, try setting this to Y.  Otherwise, say N.
+
+config APM_REAL_MODE_POWER_OFF
+	bool "Use real mode APM BIOS call to power off"
+	help
+	  Use real mode APM BIOS calls to switch off the computer. This is
+	  a work-around for a number of buggy BIOSes. Switch this option on if
+	  your computer crashes instead of powering off properly.
+
+endif # APM
+
+source "arch/x86/kernel/cpu/cpufreq/Kconfig"
+
+source "drivers/cpuidle/Kconfig"
+
+endmenu
+
+
+menu "Bus options (PCI etc.)"
+
+config PCI
+	bool "PCI support" if !X86_VISWS
+	depends on !X86_VOYAGER
+	default y if X86_VISWS
+	select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)
+	help
+	  Find out whether you have a PCI motherboard. PCI is the name of a
+	  bus system, i.e. the way the CPU talks to the other stuff inside
+	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
+	  VESA. If you have PCI, say Y, otherwise N.
+
+	  The PCI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>, contains valuable
+	  information about which PCI hardware does work under Linux and which
+	  doesn't.
+
+choice
+	prompt "PCI access mode"
+	depends on X86_32 && PCI && !X86_VISWS
+	default PCI_GOANY
+	---help---
+	  On PCI systems, the BIOS can be used to detect the PCI devices and
+	  determine their configuration. However, some old PCI motherboards
+	  have BIOS bugs and may crash if this is done. Also, some embedded
+	  PCI-based systems don't have any BIOS at all. Linux can also try to
+	  detect the PCI hardware directly without using the BIOS.
+
+	  With this option, you can specify how Linux should detect the
+	  PCI devices. If you choose "BIOS", the BIOS will be used,
+	  if you choose "Direct", the BIOS won't be used, and if you
+	  choose "MMConfig", then PCI Express MMCONFIG will be used.
+	  If you choose "Any", the kernel will try MMCONFIG, then the
+	  direct access method and falls back to the BIOS if that doesn't
+	  work. If unsure, go with the default, which is "Any".
+
+config PCI_GOBIOS
+	bool "BIOS"
+
+config PCI_GOMMCONFIG
+	bool "MMConfig"
+
+config PCI_GODIRECT
+	bool "Direct"
+
+config PCI_GOANY
+	bool "Any"
+
+endchoice
+
+config PCI_BIOS
+	bool
+	depends on X86_32 && !X86_VISWS && PCI && (PCI_GOBIOS || PCI_GOANY)
+	default y
+
+# x86-64 doesn't support PCI BIOS access from long mode so always go direct.
+config PCI_DIRECT
+	bool
+	depends on PCI && (X86_64 || (PCI_GODIRECT || PCI_GOANY) || X86_VISWS)
+	default y
+
+config PCI_MMCONFIG
+	bool
+	depends on X86_32 && PCI && ACPI && (PCI_GOMMCONFIG || PCI_GOANY)
+	default y
+
+config PCI_DOMAINS
+	bool
+	depends on PCI
+	default y
+
+config PCI_MMCONFIG
+	bool "Support mmconfig PCI config space access"
+	depends on X86_64 && PCI && ACPI
+
+config DMAR
+	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
+	depends on X86_64 && PCI_MSI && ACPI && EXPERIMENTAL
+	help
+	  DMA remapping (DMAR) devices support enables independent address
+	  translations for Direct Memory Access (DMA) from devices.
+	  These DMA remapping devices are reported via ACPI tables
+	  and include PCI device scope covered by these DMA
+	  remapping devices.
+
+config DMAR_GFX_WA
+	bool "Support for Graphics workaround"
+	depends on DMAR
+	default y
+	help
+	 Current Graphics drivers tend to use physical address
+	 for DMA and avoid using DMA APIs. Setting this config
+	 option permits the IOMMU driver to set a unity map for
+	 all the OS-visible memory. Hence the driver can continue
+	 to use physical addresses for DMA.
+
+config DMAR_FLOPPY_WA
+	bool
+	depends on DMAR
+	default y
+	help
+	 Floppy disk drivers are know to bypass DMA API calls
+	 thereby failing to work when IOMMU is enabled. This
+	 workaround will setup a 1:1 mapping for the first
+	 16M to make floppy (an ISA device) work.
+
+source "drivers/pci/pcie/Kconfig"
+
+source "drivers/pci/Kconfig"
+
+# x86_64 have no ISA slots, but do have ISA-style DMA.
+config ISA_DMA_API
+	bool
+	default y
+
+if X86_32
+
+config ISA
+	bool "ISA support"
+	depends on !(X86_VOYAGER || X86_VISWS)
+	help
+	  Find out whether you have ISA slots on your motherboard.  ISA is the
+	  name of a bus system, i.e. the way the CPU talks to the other stuff
+	  inside your box.  Other bus systems are PCI, EISA, MicroChannel
+	  (MCA) or VESA.  ISA is an older system, now being displaced by PCI;
+	  newer boards don't support it.  If you have ISA, say Y, otherwise N.
+
+config EISA
+	bool "EISA support"
+	depends on ISA
+	---help---
+	  The Extended Industry Standard Architecture (EISA) bus was
+	  developed as an open alternative to the IBM MicroChannel bus.
+
+	  The EISA bus provided some of the features of the IBM MicroChannel
+	  bus while maintaining backward compatibility with cards made for
+	  the older ISA bus.  The EISA bus saw limited use between 1988 and
+	  1995 when it was made obsolete by the PCI bus.
+
+	  Say Y here if you are building a kernel for an EISA-based machine.
+
+	  Otherwise, say N.
+
+source "drivers/eisa/Kconfig"
+
+config MCA
+	bool "MCA support" if !(X86_VISWS || X86_VOYAGER)
+	default y if X86_VOYAGER
+	help
+	  MicroChannel Architecture is found in some IBM PS/2 machines and
+	  laptops.  It is a bus system similar to PCI or ISA. See
+	  <file:Documentation/mca.txt> (and especially the web page given
+	  there) before attempting to build an MCA bus kernel.
+
+source "drivers/mca/Kconfig"
+
+config SCx200
+	tristate "NatSemi SCx200 support"
+	depends on !X86_VOYAGER
+	help
+	  This provides basic support for National Semiconductor's
+	  (now AMD's) Geode processors.  The driver probes for the
+	  PCI-IDs of several on-chip devices, so its a good dependency
+	  for other scx200_* drivers.
+
+	  If compiled as a module, the driver is named scx200.
+
+config SCx200HR_TIMER
+	tristate "NatSemi SCx200 27MHz High-Resolution Timer Support"
+	depends on SCx200 && GENERIC_TIME
+	default y
+	help
+	  This driver provides a clocksource built upon the on-chip
+	  27MHz high-resolution timer.  Its also a workaround for
+	  NSC Geode SC-1100's buggy TSC, which loses time when the
+	  processor goes idle (as is done by the scheduler).  The
+	  other workaround is idle=poll boot option.
+
+config GEODE_MFGPT_TIMER
+	bool "Geode Multi-Function General Purpose Timer (MFGPT) events"
+	depends on MGEODE_LX && GENERIC_TIME && GENERIC_CLOCKEVENTS
+	default y
+	help
+	  This driver provides a clock event source based on the MFGPT
+	  timer(s) in the CS5535 and CS5536 companion chip for the geode.
+	  MFGPTs have a better resolution and max interval than the
+	  generic PIT, and are suitable for use as high-res timers.
+
+config K8_NB
+	def_bool y
+	depends on AGP_AMD64
+
+endif # X86_32
+
+source "drivers/pcmcia/Kconfig"
+
+source "drivers/pci/hotplug/Kconfig"
+
+endmenu
+
+
+menu "Executable file formats / Emulations"
+
+source "fs/Kconfig.binfmt"
+
+config IA32_EMULATION
+	bool "IA32 Emulation"
+	depends on X86_64
+	help
+	  Include code to run 32-bit programs under a 64-bit kernel. You should
+	  likely turn this on, unless you're 100% sure that you don't have any
+	  32-bit programs left.
+
+config IA32_AOUT
+       tristate "IA32 a.out support"
+       depends on IA32_EMULATION
+       help
+         Support old a.out binaries in the 32bit emulation.
+
+config COMPAT
+	bool
+	depends on IA32_EMULATION
+	default y
+
+config COMPAT_FOR_U64_ALIGNMENT
+	def_bool COMPAT
+	depends on X86_64
+
+config SYSVIPC_COMPAT
+	bool
+	depends on X86_64 && COMPAT && SYSVIPC
+	default y
+
+endmenu
+
+
+source "net/Kconfig"
+
+source "drivers/Kconfig"
+
+source "drivers/firmware/Kconfig"
+
+source "fs/Kconfig"
+
+source "kernel/Kconfig.instrumentation"
+
+source "arch/x86/Kconfig.debug"
+
+source "security/Kconfig"
+
+source "crypto/Kconfig"
+
+source "lib/Kconfig"
diff --git a/arch/x86/Kconfig.i386 b/arch/x86/Kconfig.i386
index b6f2fd0..9fe63f1 100644
--- a/arch/x86/Kconfig.i386
+++ b/arch/x86/Kconfig.i386
@@ -517,8 +517,6 @@ config X86_CPUID
 	  with major 203 and minors 0 to 31 for /dev/cpu/0/cpuid to
 	  /dev/cpu/31/cpuid.
 
-source "drivers/firmware/Kconfig"
-
 choice
 	prompt "High Memory Support"
 	default HIGHMEM4G if !X86_NUMAQ
@@ -957,328 +955,6 @@ config ARCH_ENABLE_MEMORY_HOTPLUG
 	def_bool y
 	depends on HIGHMEM
 
-menu "Power management options (ACPI, APM)"
-	depends on !X86_VOYAGER
-
-source kernel/power/Kconfig
-
-source "drivers/acpi/Kconfig"
-
-menuconfig APM
-	tristate "APM (Advanced Power Management) BIOS support"
-	depends on PM_SLEEP && !X86_VISWS
-	---help---
-	  APM is a BIOS specification for saving power using several different
-	  techniques. This is mostly useful for battery powered laptops with
-	  APM compliant BIOSes. If you say Y here, the system time will be
-	  reset after a RESUME operation, the /proc/apm device will provide
-	  battery status information, and user-space programs will receive
-	  notification of APM "events" (e.g. battery status change).
-
-	  If you select "Y" here, you can disable actual use of the APM
-	  BIOS by passing the "apm=off" option to the kernel at boot time.
-
-	  Note that the APM support is almost completely disabled for
-	  machines with more than one CPU.
-
-	  In order to use APM, you will need supporting software. For location
-	  and more information, read <file:Documentation/pm.txt> and the
-	  Battery Powered Linux mini-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
-
-	  This driver does not spin down disk drives (see the hdparm(8)
-	  manpage ("man 8 hdparm") for that), and it doesn't turn off
-	  VESA-compliant "green" monitors.
-
-	  This driver does not support the TI 4000M TravelMate and the ACER
-	  486/DX4/75 because they don't have compliant BIOSes. Many "green"
-	  desktop machines also don't have compliant BIOSes, and this driver
-	  may cause those machines to panic during the boot phase.
-
-	  Generally, if you don't have a battery in your machine, there isn't
-	  much point in using this driver and you should say N. If you get
-	  random kernel OOPSes or reboots that don't seem to be related to
-	  anything, try disabling/enabling this option (or disabling/enabling
-	  APM in your BIOS).
-
-	  Some other things you should try when experiencing seemingly random,
-	  "weird" problems:
-
-	  1) make sure that you have enough swap space and that it is
-	  enabled.
-	  2) pass the "no-hlt" option to the kernel
-	  3) switch on floating point emulation in the kernel and pass
-	  the "no387" option to the kernel
-	  4) pass the "floppy=nodma" option to the kernel
-	  5) pass the "mem=4M" option to the kernel (thereby disabling
-	  all but the first 4 MB of RAM)
-	  6) make sure that the CPU is not over clocked.
-	  7) read the sig11 FAQ at <http://www.bitwizard.nl/sig11/>
-	  8) disable the cache from your BIOS settings
-	  9) install a fan for the video card or exchange video RAM
-	  10) install a better fan for the CPU
-	  11) exchange RAM chips
-	  12) exchange the motherboard.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called apm.
-
-if APM
-
-config APM_IGNORE_USER_SUSPEND
-	bool "Ignore USER SUSPEND"
-	help
-	  This option will ignore USER SUSPEND requests. On machines with a
-	  compliant APM BIOS, you want to say N. However, on the NEC Versa M
-	  series notebooks, it is necessary to say Y because of a BIOS bug.
-
-config APM_DO_ENABLE
-	bool "Enable PM at boot time"
-	---help---
-	  Enable APM features at boot time. From page 36 of the APM BIOS
-	  specification: "When disabled, the APM BIOS does not automatically
-	  power manage devices, enter the Standby State, enter the Suspend
-	  State, or take power saving steps in response to CPU Idle calls."
-	  This driver will make CPU Idle calls when Linux is idle (unless this
-	  feature is turned off -- see "Do CPU IDLE calls", below). This
-	  should always save battery power, but more complicated APM features
-	  will be dependent on your BIOS implementation. You may need to turn
-	  this option off if your computer hangs at boot time when using APM
-	  support, or if it beeps continuously instead of suspending. Turn
-	  this off if you have a NEC UltraLite Versa 33/C or a Toshiba
-	  T400CDT. This is off by default since most machines do fine without
-	  this feature.
-
-config APM_CPU_IDLE
-	bool "Make CPU Idle calls when idle"
-	help
-	  Enable calls to APM CPU Idle/CPU Busy inside the kernel's idle loop.
-	  On some machines, this can activate improved power savings, such as
-	  a slowed CPU clock rate, when the machine is idle. These idle calls
-	  are made after the idle loop has run for some length of time (e.g.,
-	  333 mS). On some machines, this will cause a hang at boot time or
-	  whenever the CPU becomes idle. (On machines with more than one CPU,
-	  this option does nothing.)
-
-config APM_DISPLAY_BLANK
-	bool "Enable console blanking using APM"
-	help
-	  Enable console blanking using the APM. Some laptops can use this to
-	  turn off the LCD backlight when the screen blanker of the Linux
-	  virtual console blanks the screen. Note that this is only used by
-	  the virtual console screen blanker, and won't turn off the backlight
-	  when using the X Window system. This also doesn't have anything to
-	  do with your VESA-compliant power-saving monitor. Further, this
-	  option doesn't work for all laptops -- it might not turn off your
-	  backlight at all, or it might print a lot of errors to the console,
-	  especially if you are using gpm.
-
-config APM_ALLOW_INTS
-	bool "Allow interrupts during APM BIOS calls"
-	help
-	  Normally we disable external interrupts while we are making calls to
-	  the APM BIOS as a measure to lessen the effects of a badly behaving
-	  BIOS implementation.  The BIOS should reenable interrupts if it
-	  needs to.  Unfortunately, some BIOSes do not -- especially those in
-	  many of the newer IBM Thinkpads.  If you experience hangs when you
-	  suspend, try setting this to Y.  Otherwise, say N.
-
-config APM_REAL_MODE_POWER_OFF
-	bool "Use real mode APM BIOS call to power off"
-	help
-	  Use real mode APM BIOS calls to switch off the computer. This is
-	  a work-around for a number of buggy BIOSes. Switch this option on if
-	  your computer crashes instead of powering off properly.
-
-endif # APM
-
-source "arch/x86/kernel/cpu/cpufreq/Kconfig"
-
-source "drivers/cpuidle/Kconfig"
-
-endmenu
-
-menu "Bus options (PCI, PCMCIA, EISA, MCA, ISA)"
-
-config PCI
-	bool "PCI support" if !X86_VISWS
-	depends on !X86_VOYAGER
-	default y if X86_VISWS
-	select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)
-	help
-	  Find out whether you have a PCI motherboard. PCI is the name of a
-	  bus system, i.e. the way the CPU talks to the other stuff inside
-	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
-	  VESA. If you have PCI, say Y, otherwise N.
-
-	  The PCI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
-choice
-	prompt "PCI access mode"
-	depends on PCI && !X86_VISWS
-	default PCI_GOANY
-	---help---
-	  On PCI systems, the BIOS can be used to detect the PCI devices and
-	  determine their configuration. However, some old PCI motherboards
-	  have BIOS bugs and may crash if this is done. Also, some embedded
-	  PCI-based systems don't have any BIOS at all. Linux can also try to
-	  detect the PCI hardware directly without using the BIOS.
-
-	  With this option, you can specify how Linux should detect the
-	  PCI devices. If you choose "BIOS", the BIOS will be used,
-	  if you choose "Direct", the BIOS won't be used, and if you
-	  choose "MMConfig", then PCI Express MMCONFIG will be used.
-	  If you choose "Any", the kernel will try MMCONFIG, then the
-	  direct access method and falls back to the BIOS if that doesn't
-	  work. If unsure, go with the default, which is "Any".
-
-config PCI_GOBIOS
-	bool "BIOS"
-
-config PCI_GOMMCONFIG
-	bool "MMConfig"
-
-config PCI_GODIRECT
-	bool "Direct"
-
-config PCI_GOANY
-	bool "Any"
-
-endchoice
-
-config PCI_BIOS
-	bool
-	depends on !X86_VISWS && PCI && (PCI_GOBIOS || PCI_GOANY)
-	default y
-
-config PCI_DIRECT
-	bool
- 	depends on PCI && ((PCI_GODIRECT || PCI_GOANY) || X86_VISWS)
-	default y
-
-config PCI_MMCONFIG
-	bool
-	depends on PCI && ACPI && (PCI_GOMMCONFIG || PCI_GOANY)
-	default y
-
-config PCI_DOMAINS
-	bool
-	depends on PCI
-	default y
-
-source "drivers/pci/pcie/Kconfig"
-
-source "drivers/pci/Kconfig"
-
-config ISA_DMA_API
-	bool
-	default y
-
-config ISA
-	bool "ISA support"
-	depends on !(X86_VOYAGER || X86_VISWS)
-	help
-	  Find out whether you have ISA slots on your motherboard.  ISA is the
-	  name of a bus system, i.e. the way the CPU talks to the other stuff
-	  inside your box.  Other bus systems are PCI, EISA, MicroChannel
-	  (MCA) or VESA.  ISA is an older system, now being displaced by PCI;
-	  newer boards don't support it.  If you have ISA, say Y, otherwise N.
-
-config EISA
-	bool "EISA support"
-	depends on ISA
-	---help---
-	  The Extended Industry Standard Architecture (EISA) bus was
-	  developed as an open alternative to the IBM MicroChannel bus.
-
-	  The EISA bus provided some of the features of the IBM MicroChannel
-	  bus while maintaining backward compatibility with cards made for
-	  the older ISA bus.  The EISA bus saw limited use between 1988 and
-	  1995 when it was made obsolete by the PCI bus.
-
-	  Say Y here if you are building a kernel for an EISA-based machine.
-
-	  Otherwise, say N.
-
-source "drivers/eisa/Kconfig"
-
-config MCA
-	bool "MCA support" if !(X86_VISWS || X86_VOYAGER)
-	default y if X86_VOYAGER
-	help
-	  MicroChannel Architecture is found in some IBM PS/2 machines and
-	  laptops.  It is a bus system similar to PCI or ISA. See
-	  <file:Documentation/mca.txt> (and especially the web page given
-	  there) before attempting to build an MCA bus kernel.
-
-source "drivers/mca/Kconfig"
-
-config SCx200
-	tristate "NatSemi SCx200 support"
-	depends on !X86_VOYAGER
-	help
-	  This provides basic support for National Semiconductor's
-	  (now AMD's) Geode processors.  The driver probes for the
-	  PCI-IDs of several on-chip devices, so its a good dependency
-	  for other scx200_* drivers.
-
-	  If compiled as a module, the driver is named scx200.
-
-config SCx200HR_TIMER
-	tristate "NatSemi SCx200 27MHz High-Resolution Timer Support"
-	depends on SCx200 && GENERIC_TIME
-	default y
-	help
-	  This driver provides a clocksource built upon the on-chip
-	  27MHz high-resolution timer.  Its also a workaround for
-	  NSC Geode SC-1100's buggy TSC, which loses time when the
-	  processor goes idle (as is done by the scheduler).  The
-	  other workaround is idle=poll boot option.
-
-config GEODE_MFGPT_TIMER
-	bool "Geode Multi-Function General Purpose Timer (MFGPT) events"
-	depends on MGEODE_LX && GENERIC_TIME && GENERIC_CLOCKEVENTS
-	default y
-	help
-	  This driver provides a clock event source based on the MFGPT
-	  timer(s) in the CS5535 and CS5536 companion chip for the geode.
-	  MFGPTs have a better resolution and max interval than the
-	  generic PIT, and are suitable for use as high-res timers.
-
-config K8_NB
-	def_bool y
-	depends on AGP_AMD64
-
-source "drivers/pcmcia/Kconfig"
-
-source "drivers/pci/hotplug/Kconfig"
-
-endmenu
-
-menu "Executable file formats"
-
-source "fs/Kconfig.binfmt"
-
-endmenu
-
-source "net/Kconfig"
-
-source "drivers/Kconfig"
-
-source "fs/Kconfig"
-
-source "kernel/Kconfig.instrumentation"
-
-source "arch/x86/Kconfig.debug"
-
-source "security/Kconfig"
-
-source "crypto/Kconfig"
-
-source "lib/Kconfig"
 
 #
 # Use the generic interrupt handling code in kernel/irq/:
@@ -1319,3 +995,5 @@ config X86_TRAMPOLINE
 config KTIME_SCALAR
 	bool
 	default y
+
+source "arch/x86/Kconfig"
diff --git a/arch/x86/Kconfig.x86_64 b/arch/x86/Kconfig.x86_64
index 8d6b534..264623c 100644
--- a/arch/x86/Kconfig.x86_64
+++ b/arch/x86/Kconfig.x86_64
@@ -698,142 +698,9 @@ config GENERIC_IRQ_PROBE
 	bool
 	default y
 
-# we have no ISA slots, but we do have ISA-style DMA.
-config ISA_DMA_API
-	bool
-	default y
-
 config GENERIC_PENDING_IRQ
 	bool
 	depends on GENERIC_HARDIRQS && SMP
 	default y
 
-menu "Power management options"
-
-source kernel/power/Kconfig
-
-config ARCH_HIBERNATION_HEADER
-	bool
-	depends on HIBERNATION
-	default y
-
-source "drivers/acpi/Kconfig"
-
-source "arch/x86/kernel/cpu/cpufreq/Kconfig"
-
-source "drivers/cpuidle/Kconfig"
-
-endmenu
-
-menu "Bus options (PCI etc.)"
-
-config PCI
-	bool "PCI support"
-	select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)
-
-# x86-64 doesn't support PCI BIOS access from long mode so always go direct.
-config PCI_DIRECT
-	bool
-	depends on PCI
-	default y
-
-config PCI_MMCONFIG
-	bool "Support mmconfig PCI config space access"
-	depends on PCI && ACPI
-
-config PCI_DOMAINS
-	bool
-	depends on PCI
-	default y
-
-config DMAR
-	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
-	depends on PCI_MSI && ACPI && EXPERIMENTAL
-	help
-	  DMA remapping (DMAR) devices support enables independent address
-	  translations for Direct Memory Access (DMA) from devices.
-	  These DMA remapping devices are reported via ACPI tables
-	  and include PCI device scope covered by these DMA
-	  remapping devices.
-
-config DMAR_GFX_WA
-	bool "Support for Graphics workaround"
-	depends on DMAR
-	default y
-	help
-	 Current Graphics drivers tend to use physical address
-	 for DMA and avoid using DMA APIs. Setting this config
-	 option permits the IOMMU driver to set a unity map for
-	 all the OS-visible memory. Hence the driver can continue
-	 to use physical addresses for DMA.
-
-config DMAR_FLOPPY_WA
-	bool
-	depends on DMAR
-	default y
-	help
-	 Floppy disk drivers are know to bypass DMA API calls
-	 thereby failing to work when IOMMU is enabled. This
-	 workaround will setup a 1:1 mapping for the first
-	 16M to make floppy (an ISA device) work.
-
-source "drivers/pci/pcie/Kconfig"
-
-source "drivers/pci/Kconfig"
-
-source "drivers/pcmcia/Kconfig"
-
-source "drivers/pci/hotplug/Kconfig"
-
-endmenu
-
-
-menu "Executable file formats / Emulations"
-
-source "fs/Kconfig.binfmt"
-
-config IA32_EMULATION
-	bool "IA32 Emulation"
-	help
-	  Include code to run 32-bit programs under a 64-bit kernel. You should
-	  likely turn this on, unless you're 100% sure that you don't have any
-	  32-bit programs left.
-
-config IA32_AOUT
-       tristate "IA32 a.out support"
-       depends on IA32_EMULATION
-       help
-         Support old a.out binaries in the 32bit emulation.
-
-config COMPAT
-	bool
-	depends on IA32_EMULATION
-	default y
-
-config COMPAT_FOR_U64_ALIGNMENT
-	def_bool COMPAT
-
-config SYSVIPC_COMPAT
-	bool
-	depends on COMPAT && SYSVIPC
-	default y
-
-endmenu
-
-source "net/Kconfig"
-
-source drivers/Kconfig
-
-source "drivers/firmware/Kconfig"
-
-source fs/Kconfig
-
-source "kernel/Kconfig.instrumentation"
-
-source "arch/x86/Kconfig.debug"
-
-source "security/Kconfig"
-
-source "crypto/Kconfig"
-
-source "lib/Kconfig"
+source "arch/x86/Kconfig"
-- 
1.5.3.4.1157.g0e74-dirty


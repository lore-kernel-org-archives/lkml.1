Return-Path: <linux-kernel-owner+w=401wt.eu-S1761284AbXHUG4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761284AbXHUG4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760622AbXHUGxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:53:32 -0400
Received: from canuck.infradead.org ([209.217.80.40]:44214 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759904AbXHUGxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:53:30 -0400
Date: Mon, 20 Aug 2007 23:54:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       S??bastien Dugu?? <sebastien.dugue@bull.net>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <lenb@kernel.org>,
       Adam Belay <ambx1@neo.rr.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Russell King <rmk@arm.linux.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Sascha Sommer <saschasommer@freenet.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 07/20] revert "x86, serial: convert legacy COM ports to
	platform devices"
Message-ID: <20070821065441.GH5275@kroah.com>
References: <20070821064251.972690753@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070821065210.GA5275@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Andrew Morton <akpm@linux-foundation.org>

Revert 7e92b4fc345f5b6f57585fbe5ffdb0f24d7c9b26.  It broke Sébastien Dugué's
machine and Jeff said (persuasively)

  This seems like it will break decades-long-working stuff, in favor of
  breaking new ground in our favorite area, "trusting the BIOS."

  It's just not worth it for serial ports, IMO.  Serial ports are something
  that just shouldn't break at this late stage in the game.  My new Intel
  platform boxes don't even have serial ports, so I question the value of
  messing with serial port probing even more...  because...  just wait a year,
  and your box won't have a serial port either!  :)

  I certainly don't object to the use of platform devices (or isa_driver),
  but the probe change seems questionable.  That's sorta analagous to
  rewriting the floppy driver probe routine.  Sure you could do it...  but why
  risk all that damage and go through debugging all over again?

  It seems clear from this report that we cannot, should not, trust BIOS for
  something (a) so simple and (b) that has been working for over a decade.

Much discussion ensued and we've decided to have another go at all of this.

Cc: Sébastien Dugué <sebastien.dugue@bull.net>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Sascha Sommer <saschasommer@freenet.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/kernel-parameters.txt |    5 --
 arch/i386/kernel/Makefile           |    1 
 arch/i386/kernel/legacy_serial.c    |   67 ------------------------------------
 arch/x86_64/kernel/Makefile         |    2 -
 drivers/serial/Kconfig              |   14 ++-----
 include/asm-i386/serial.h           |   16 ++++++++
 include/asm-x86_64/serial.h         |   16 ++++++++
 7 files changed, 37 insertions(+), 84 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -850,11 +850,6 @@ and is between 256 and 4096 characters. 
 	lasi=		[HW,SCSI] PARISC LASI driver for the 53c700 chip
 			Format: addr:<io>,irq:<irq>
 
-	legacy_serial.force [HW,IA-32,X86-64]
-			Probe for COM ports at legacy addresses even
-			if PNPBIOS or ACPI should describe them.  This
-			is for working around firmware defects.
-
 	llsc*=		[IA64] See function print_params() in
 			arch/ia64/sn/kernel/llsc4.c.
 
--- a/arch/i386/kernel/Makefile
+++ b/arch/i386/kernel/Makefile
@@ -35,7 +35,6 @@ obj-y				+= sysenter.o vsyscall.o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_stub.o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault.o
-obj-$(CONFIG_SERIAL_8250)	+= legacy_serial.o
 obj-$(CONFIG_VM86)		+= vm86.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
--- a/arch/i386/kernel/legacy_serial.c
+++ /dev/null
@@ -1,67 +0,0 @@
-/*
- * Legacy COM port devices for x86 platforms without PNPBIOS or ACPI.
- * Data taken from include/asm-i386/serial.h.
- *
- * (c) Copyright 2007 Hewlett-Packard Development Company, L.P.
- *	Bjorn Helgaas <bjorn.helgaas@hp.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/pnp.h>
-#include <linux/serial_8250.h>
-
-/* Standard COM flags (except for COM4, because of the 8514 problem) */
-#ifdef CONFIG_SERIAL_DETECT_IRQ
-#define COM_FLAGS (UPF_BOOT_AUTOCONF | UPF_SKIP_TEST | UPF_AUTO_IRQ)
-#define COM4_FLAGS (UPF_BOOT_AUTOCONF | UPF_AUTO_IRQ)
-#else
-#define COM_FLAGS (UPF_BOOT_AUTOCONF | UPF_SKIP_TEST)
-#define COM4_FLAGS UPF_BOOT_AUTOCONF
-#endif
-
-#define PORT(_base,_irq,_flags)				\
-	{						\
-		.iobase		= _base,		\
-		.irq		= _irq,			\
-		.uartclk	= 1843200,		\
-		.iotype		= UPIO_PORT,		\
-		.flags		= _flags,		\
-	}
-
-static struct plat_serial8250_port x86_com_data[] = {
-	PORT(0x3F8, 4, COM_FLAGS),
-	PORT(0x2F8, 3, COM_FLAGS),
-	PORT(0x3E8, 4, COM_FLAGS),
-	PORT(0x2E8, 3, COM4_FLAGS),
-	{ },
-};
-
-static struct platform_device x86_com_device = {
-	.name			= "serial8250",
-	.id			= PLAT8250_DEV_PLATFORM,
-	.dev			= {
-		.platform_data	= x86_com_data,
-	},
-};
-
-static int force_legacy_probe;
-module_param_named(force, force_legacy_probe, bool, 0);
-MODULE_PARM_DESC(force, "Force legacy serial port probe");
-
-static int __init serial8250_x86_com_init(void)
-{
-	if (pnp_platform_devices && !force_legacy_probe)
-		return -ENODEV;
-
-	return platform_device_register(&x86_com_device);
-}
-
-module_init(serial8250_x86_com_init);
-
-MODULE_AUTHOR("Bjorn Helgaas");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Generic 8250/16x50 legacy probe module");
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -32,7 +32,6 @@ obj-$(CONFIG_EARLY_PRINTK)	+= early_prin
 obj-$(CONFIG_IOMMU)		+= pci-gart.o aperture.o
 obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary.o tce.o
 obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb.o
-obj-$(CONFIG_SERIAL_8250)	+= legacy_serial.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer.o
 obj-$(CONFIG_X86_VSMP)		+= vsmp.o
@@ -50,7 +49,6 @@ CFLAGS_vsyscall.o		:= $(PROFILING) -g0
 
 therm_throt-y                   += ../../i386/kernel/cpu/mcheck/therm_throt.o
 bootflag-y			+= ../../i386/kernel/bootflag.o
-legacy_serial-y			+= ../../i386/kernel/legacy_serial.o
 cpuid-$(subst m,y,$(CONFIG_X86_CPUID))  += ../../i386/kernel/cpuid.o
 topology-y                     += ../../i386/kernel/topology.o
 microcode-$(subst m,y,$(CONFIG_MICROCODE))  += ../../i386/kernel/microcode.o
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -74,21 +74,17 @@ config SERIAL_8250_PCI
 	depends on SERIAL_8250 && PCI
 	default SERIAL_8250
 	help
-	  Say Y here if you have PCI serial ports.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called 8250_pci.
+	  This builds standard PCI serial support. You may be able to
+	  disable this feature if you only need legacy serial support.
+	  Saves about 9K.
 
 config SERIAL_8250_PNP
 	tristate "8250/16550 PNP device support" if EMBEDDED
 	depends on SERIAL_8250 && PNP
 	default SERIAL_8250
 	help
-	  Say Y here if you have serial ports described by PNPBIOS or ACPI.
-	  These are typically ports built into the system board.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called 8250_pnp.
+	  This builds standard PNP serial support. You may be able to
+	  disable this feature if you only need legacy serial support.
 
 config SERIAL_8250_HP300
 	tristate
--- a/include/asm-i386/serial.h
+++ b/include/asm-i386/serial.h
@@ -11,3 +11,19 @@
  * megabits/second; but this requires the faster clock.
  */
 #define BASE_BAUD ( 1843200 / 16 )
+
+/* Standard COM flags (except for COM4, because of the 8514 problem) */
+#ifdef CONFIG_SERIAL_DETECT_IRQ
+#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST | ASYNC_AUTO_IRQ)
+#define STD_COM4_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_AUTO_IRQ)
+#else
+#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST)
+#define STD_COM4_FLAGS ASYNC_BOOT_AUTOCONF
+#endif
+
+#define SERIAL_PORT_DFNS			\
+	/* UART CLK   PORT IRQ     FLAGS        */			\
+	{ 0, BASE_BAUD, 0x3F8, 4, STD_COM_FLAGS },	/* ttyS0 */	\
+	{ 0, BASE_BAUD, 0x2F8, 3, STD_COM_FLAGS },	/* ttyS1 */	\
+	{ 0, BASE_BAUD, 0x3E8, 4, STD_COM_FLAGS },	/* ttyS2 */	\
+	{ 0, BASE_BAUD, 0x2E8, 3, STD_COM4_FLAGS },	/* ttyS3 */
--- a/include/asm-x86_64/serial.h
+++ b/include/asm-x86_64/serial.h
@@ -11,3 +11,19 @@
  * megabits/second; but this requires the faster clock.
  */
 #define BASE_BAUD ( 1843200 / 16 )
+
+/* Standard COM flags (except for COM4, because of the 8514 problem) */
+#ifdef CONFIG_SERIAL_DETECT_IRQ
+#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST | ASYNC_AUTO_IRQ)
+#define STD_COM4_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_AUTO_IRQ)
+#else
+#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST)
+#define STD_COM4_FLAGS ASYNC_BOOT_AUTOCONF
+#endif
+
+#define SERIAL_PORT_DFNS			\
+	/* UART CLK   PORT IRQ     FLAGS        */			\
+	{ 0, BASE_BAUD, 0x3F8, 4, STD_COM_FLAGS },	/* ttyS0 */	\
+	{ 0, BASE_BAUD, 0x2F8, 3, STD_COM_FLAGS },	/* ttyS1 */	\
+	{ 0, BASE_BAUD, 0x3E8, 4, STD_COM_FLAGS },	/* ttyS2 */	\
+	{ 0, BASE_BAUD, 0x2E8, 3, STD_COM4_FLAGS },	/* ttyS3 */

-- 

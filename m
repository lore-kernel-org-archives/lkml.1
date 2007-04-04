Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbXDDWrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbXDDWrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 18:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbXDDWri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 18:47:38 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:38002 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbXDDWq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 18:46:29 -0400
Message-Id: <20070404224609.264175000@ldl.fc.hp.com>
References: <20070404224536.337573000@ldl.fc.hp.com>
User-Agent: quilt/0.45-1
Date: Wed, 04 Apr 2007 16:45:41 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Keith Owens <kaos@ocs.com.au>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Matthieu CASTET <castet.matthieu@free.fr>
Cc: Jean Tourrilhes <jt@hpl.hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ville Syrjala <syrjala@sci.fi>
Cc: Russell King <rmk+serial@arm.linux.org.uk>
Cc: linux-serial@vger.kernel.org
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 5/5] x86, serial: convert legacy COM ports to platform devices
Content-Disposition: inline; filename=x86-change-legacy-serial-to-platform.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make x86 COM ports into platform devices and don't probe for them
if we have PNP.

This prevents double discovery, where a device was found both by
the legacy probe and by 8250_pnp, e.g.,

    serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
    00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A

This also means IRDA devices without a UART PNP ID will no longer be
claimed by the serial driver, which might require changes in IRDA
drivers and administration.

In addition to this patch, you may need to configure a setserial init
script, e.g., /etc/init.d/setserial, so it doesn't poke legacy UART
stuff back in.  On Debian, "dpkg-reconfigure setserial" with the "kernel"
option does this.

To force the old legacy probe behavior even when we have PNPBIOS or
ACPI, load the new legacy_serial module (or build 8250 static) with
the "legacy_serial.force" option.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: w/include/asm-i386/serial.h
===================================================================
--- w.orig/include/asm-i386/serial.h	2007-03-27 16:12:29.000000000 -0600
+++ w/include/asm-i386/serial.h	2007-03-27 16:13:04.000000000 -0600
@@ -11,19 +11,3 @@
  * megabits/second; but this requires the faster clock.
  */
 #define BASE_BAUD ( 1843200 / 16 )
-
-/* Standard COM flags (except for COM4, because of the 8514 problem) */
-#ifdef CONFIG_SERIAL_DETECT_IRQ
-#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST | ASYNC_AUTO_IRQ)
-#define STD_COM4_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_AUTO_IRQ)
-#else
-#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST)
-#define STD_COM4_FLAGS ASYNC_BOOT_AUTOCONF
-#endif
-
-#define SERIAL_PORT_DFNS			\
-	/* UART CLK   PORT IRQ     FLAGS        */			\
-	{ 0, BASE_BAUD, 0x3F8, 4, STD_COM_FLAGS },	/* ttyS0 */	\
-	{ 0, BASE_BAUD, 0x2F8, 3, STD_COM_FLAGS },	/* ttyS1 */	\
-	{ 0, BASE_BAUD, 0x3E8, 4, STD_COM_FLAGS },	/* ttyS2 */	\
-	{ 0, BASE_BAUD, 0x2E8, 3, STD_COM4_FLAGS },	/* ttyS3 */
Index: w/include/asm-x86_64/serial.h
===================================================================
--- w.orig/include/asm-x86_64/serial.h	2007-03-27 16:12:29.000000000 -0600
+++ w/include/asm-x86_64/serial.h	2007-03-27 16:13:04.000000000 -0600
@@ -11,19 +11,3 @@
  * megabits/second; but this requires the faster clock.
  */
 #define BASE_BAUD ( 1843200 / 16 )
-
-/* Standard COM flags (except for COM4, because of the 8514 problem) */
-#ifdef CONFIG_SERIAL_DETECT_IRQ
-#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST | ASYNC_AUTO_IRQ)
-#define STD_COM4_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_AUTO_IRQ)
-#else
-#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST)
-#define STD_COM4_FLAGS ASYNC_BOOT_AUTOCONF
-#endif
-
-#define SERIAL_PORT_DFNS			\
-	/* UART CLK   PORT IRQ     FLAGS        */			\
-	{ 0, BASE_BAUD, 0x3F8, 4, STD_COM_FLAGS },	/* ttyS0 */	\
-	{ 0, BASE_BAUD, 0x2F8, 3, STD_COM_FLAGS },	/* ttyS1 */	\
-	{ 0, BASE_BAUD, 0x3E8, 4, STD_COM_FLAGS },	/* ttyS2 */	\
-	{ 0, BASE_BAUD, 0x2E8, 3, STD_COM4_FLAGS },	/* ttyS3 */
Index: w/arch/i386/kernel/legacy_serial.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ w/arch/i386/kernel/legacy_serial.c	2007-03-28 16:37:26.000000000 -0600
@@ -0,0 +1,67 @@
+/*
+ * Legacy COM port devices for x86 platforms without PNPBIOS or ACPI.
+ * Data taken from include/asm-i386/serial.h.
+ *
+ * (c) Copyright 2007 Hewlett-Packard Development Company, L.P.
+ *	Bjorn Helgaas <bjorn.helgaas@hp.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/pnp.h>
+#include <linux/serial_8250.h>
+
+/* Standard COM flags (except for COM4, because of the 8514 problem) */
+#ifdef CONFIG_SERIAL_DETECT_IRQ
+#define COM_FLAGS (UPF_BOOT_AUTOCONF | UPF_SKIP_TEST | UPF_AUTO_IRQ)
+#define COM4_FLAGS (UPF_BOOT_AUTOCONF | UPF_AUTO_IRQ)
+#else
+#define COM_FLAGS (UPF_BOOT_AUTOCONF | UPF_SKIP_TEST)
+#define COM4_FLAGS UPF_BOOT_AUTOCONF
+#endif
+
+#define PORT(_base,_irq,_flags)				\
+	{						\
+		.iobase		= _base,		\
+		.irq		= _irq,			\
+		.uartclk	= 1843200,		\
+		.iotype		= UPIO_PORT,		\
+		.flags		= _flags,		\
+	}
+
+static struct plat_serial8250_port x86_com_data[] = {
+	PORT(0x3F8, 4, COM_FLAGS),
+	PORT(0x2F8, 3, COM_FLAGS),
+	PORT(0x3E8, 4, COM_FLAGS),
+	PORT(0x2E8, 3, COM4_FLAGS),
+	{ },
+};
+
+static struct platform_device x86_com_device = {
+	.name			= "serial8250",
+	.id			= PLAT8250_DEV_PLATFORM,
+	.dev			= {
+		.platform_data	= x86_com_data,
+	},
+};
+
+static int force_legacy_probe;
+module_param_named(force, force_legacy_probe, bool, 0);
+MODULE_PARM_DESC(force, "Force legacy serial port probe");
+
+static int __init serial8250_x86_com_init(void)
+{
+	if (pnp_platform_devices && !force_legacy_probe)
+		return -ENODEV;
+
+	return platform_device_register(&x86_com_device);
+}
+
+module_init(serial8250_x86_com_init);
+
+MODULE_AUTHOR("Bjorn Helgaas");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Generic 8250/16x50 legacy probe module");
Index: w/arch/i386/kernel/Makefile
===================================================================
--- w.orig/arch/i386/kernel/Makefile	2007-03-27 16:12:29.000000000 -0600
+++ w/arch/i386/kernel/Makefile	2007-03-27 16:13:04.000000000 -0600
@@ -39,6 +39,7 @@
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_MARKERS_ENABLE_OPTIMIZATION)	+= marker.o
+obj-$(CONFIG_SERIAL_8250)	+= legacy_serial.o
 
 obj-$(CONFIG_VMI)		+= vmi.o vmitime.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o
Index: w/arch/x86_64/kernel/Makefile
===================================================================
--- w.orig/arch/x86_64/kernel/Makefile	2007-03-27 16:12:29.000000000 -0600
+++ w/arch/x86_64/kernel/Makefile	2007-03-27 16:21:49.000000000 -0600
@@ -36,6 +36,7 @@
 obj-$(CONFIG_X86_VSMP)		+= vsmp.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_AUDIT)		+= audit.o
+obj-$(CONFIG_SERIAL_8250)	+= legacy_serial.o
 
 obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
Index: w/drivers/serial/Kconfig
===================================================================
--- w.orig/drivers/serial/Kconfig	2007-03-27 16:12:29.000000000 -0600
+++ w/drivers/serial/Kconfig	2007-03-27 16:13:04.000000000 -0600
@@ -73,17 +73,21 @@
 	depends on SERIAL_8250 && PCI
 	default SERIAL_8250
 	help
-	  This builds standard PCI serial support. You may be able to
-	  disable this feature if you only need legacy serial support.
-	  Saves about 9K.
+	  Say Y here if you have PCI serial ports.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called 8250_pci.
 
 config SERIAL_8250_PNP
 	tristate "8250/16550 PNP device support" if EMBEDDED
 	depends on SERIAL_8250 && PNP
 	default SERIAL_8250
 	help
-	  This builds standard PNP serial support. You may be able to
-	  disable this feature if you only need legacy serial support.
+	  Say Y here if you have serial ports described by PNPBIOS or ACPI.
+	  These are typically ports built into the system board.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called 8250_pnp.
 
 config SERIAL_8250_HP300
 	tristate
Index: w/Documentation/kernel-parameters.txt
===================================================================
--- w.orig/Documentation/kernel-parameters.txt	2007-03-26 15:42:45.000000000 -0600
+++ w/Documentation/kernel-parameters.txt	2007-03-28 16:29:21.000000000 -0600
@@ -799,6 +799,11 @@
 	lasi=		[HW,SCSI] PARISC LASI driver for the 53c700 chip
 			Format: addr:<io>,irq:<irq>
 
+	legacy_serial.force [HW,IA-32,X86-64]
+			Probe for COM ports at legacy addresses even
+			if PNPBIOS or ACPI should describe them.  This
+			is for working around firmware defects.
+
 	llsc*=		[IA64] See function print_params() in
 			arch/ia64/sn/kernel/llsc4.c.
 

--

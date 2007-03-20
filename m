Return-Path: <linux-kernel-owner+w=401wt.eu-S933509AbXCTOco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509AbXCTOco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 10:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933473AbXCTOco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 10:32:44 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:48873 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933509AbXCTOcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 10:32:42 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Keith Owens <kaos@ocs.com.au>
Subject: Re: PNPACPI probes serial twice, messes up serial console
Date: Tue, 20 Mar 2007 08:32:24 -0600
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
References: <17887.1174373206@kao2.melbourne.sgi.com>
In-Reply-To: <17887.1174373206@kao2.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703200832.24921.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 March 2007 00:46, Keith Owens wrote:
> Booting with 'console=tty console=ttyS0,9600'.  The serial console on
> ttyS0 (0x3f8, irq 4) is probed twice, once from serial8250_init() and
> again from serial_pnp_probe().

I played with this last summer, but was too timid to finish it
and post it.  My plan was to remove the legacy SERIAL_PORT_DFNS,
make platform devices for them, and only register the platform
devices in the absence of PNP.

My motivation at the time was to prevent 8250 from claiming IRDA
devices that happened to live at legacy UART addresses.  I also
wanted to make IRDA (smsc-ircc2 in my case) smart enough to use
PNP to locate its devices, since 8250 would no longer claim them.

Here's the dusty patch (against 2.6.18-rc1-mm2).  If it seems
like a reasonable thing to do, I can update it, polish it up,
add a changelog, and post it.

Index: work-mm2/drivers/serial/8250_x86.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ work-mm2/drivers/serial/8250_x86.c	2006-08-22 16:47:02.000000000 -0600
@@ -0,0 +1,67 @@
+/*
+ * Legacy COM port devices for x86 platforms without PNPBIOS or ACPI.
+ * Data taken from include/asm-i386/serial.h.
+ *
+ * (c) Copyright 2006 Hewlett-Packard Development Company, L.P.
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
+	.id			= PLAT8250_DEV_X86,
+	.dev			= {
+		.platform_data	= x86_com_data,
+	},
+};
+
+static int __init serial8250_x86_com_init(void)
+{
+#ifdef CONFIG_SERIAL_8250_PNP
+	extern int serial8250_nopnp;
+
+	if (pnp_platform_devices && !serial8250_nopnp)
+		return 0;
+#endif
+
+	return platform_device_register(&x86_com_device);
+}
+
+module_init(serial8250_x86_com_init);
+
+MODULE_AUTHOR("Bjorn Helgaas");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Generic 8250/16x50 legacy probe module");
Index: work-mm2/drivers/serial/Makefile
===================================================================
--- work-mm2.orig/drivers/serial/Makefile	2006-08-22 12:26:25.000000000 -0600
+++ work-mm2/drivers/serial/Makefile	2006-08-22 16:37:36.000000000 -0600
@@ -7,6 +7,7 @@
 obj-$(CONFIG_SERIAL_CORE) += serial_core.o
 obj-$(CONFIG_SERIAL_21285) += 21285.o
 obj-$(CONFIG_SERIAL_8250) += 8250.o
+obj-$(CONFIG_SERIAL_8250_X86) += 8250_x86.o
 obj-$(CONFIG_SERIAL_8250_PNP) += 8250_pnp.o
 obj-$(CONFIG_SERIAL_8250_GSC) += 8250_gsc.o
 obj-$(CONFIG_SERIAL_8250_PCI) += 8250_pci.o
Index: work-mm2/include/linux/serial_8250.h
===================================================================
--- work-mm2.orig/include/linux/serial_8250.h	2006-08-22 12:26:25.000000000 -0600
+++ work-mm2/include/linux/serial_8250.h	2006-08-22 16:37:36.000000000 -0600
@@ -44,6 +44,7 @@
 	PLAT8250_DEV_HUB6,
 	PLAT8250_DEV_MCA,
 	PLAT8250_DEV_AU1X00,
+	PLAT8250_DEV_X86,
 };
 
 /*
Index: work-mm2/include/asm-i386/serial.h
===================================================================
--- work-mm2.orig/include/asm-i386/serial.h	2006-08-22 12:26:25.000000000 -0600
+++ work-mm2/include/asm-i386/serial.h	2006-08-22 16:37:36.000000000 -0600
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
Index: work-mm2/drivers/serial/Kconfig
===================================================================
--- work-mm2.orig/drivers/serial/Kconfig	2006-08-22 12:26:25.000000000 -0600
+++ work-mm2/drivers/serial/Kconfig	2006-08-22 16:37:36.000000000 -0600
@@ -63,6 +63,22 @@
 
 	  If unsure, say N.
 
+config SERIAL_8250_X86
+	tristate "8250/16550 legacy COM port support" if EMBEDDED
+	depends on SERIAL_8250 && X86
+	default SERIAL_8250
+	help
+	  Say Y here if you have legacy COM ports and PNP is disabled
+	  or not available.
+
+	  This driver is for the legacy COM1, COM2, COM3, and COM4 ports at
+	  I/O ports 0x3f8, 0x2f8, 0x3e8, and 0x2e8.  On machines newer than
+	  1995 or so, these ports are described by PNPBIOS or ACPI, and
+	  8250_pnp should be used instead of this driver.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called 8250_x86.
+
 config SERIAL_8250_GSC
 	tristate
 	depends on SERIAL_8250 && GSC
@@ -73,17 +89,21 @@
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
Index: work-mm2/include/asm-x86_64/serial.h
===================================================================
--- work-mm2.orig/include/asm-x86_64/serial.h	2006-08-22 12:26:25.000000000 -0600
+++ work-mm2/include/asm-x86_64/serial.h	2006-08-22 16:37:36.000000000 -0600
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
Index: work-mm2/drivers/serial/8250_pnp.c
===================================================================
--- work-mm2.orig/drivers/serial/8250_pnp.c	2006-08-22 12:26:25.000000000 -0600
+++ work-mm2/drivers/serial/8250_pnp.c	2006-08-22 16:49:47.000000000 -0600
@@ -458,8 +458,17 @@
 	.remove		= __devexit_p(serial_pnp_remove),
 };
 
+int serial8250_nopnp;
+module_param_named(nopnp, serial8250_nopnp, bool, 0);
+MODULE_PARM_DESC(nopnp, "Do not use PNP to detect serial ports");
+
 static int __init serial8250_pnp_init(void)
 {
+	if (serial8250_nopnp) {
+		printk("skipping 8250_pnp registration\n");
+		return 0;
+	}
+
 	return pnp_register_driver(&serial_pnp_driver);
 }
 

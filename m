Return-Path: <linux-kernel-owner+w=401wt.eu-S1759170AbXFURmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170AbXFURmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbXFURmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:42:00 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:48741 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbXFURl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:41:59 -0400
Date: Thu, 21 Jun 2007 10:42:54 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] serial : convert early_uart to earlycon for 8250 fix 3 alias
In-reply-to: <200706120955.44097.yinghai.lu@sun.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>, Alex Chiang <achiang@hp.com>,
       akpm@linux-foundation.org, ak@suse.de,
       Gerd Hoffmann <kraxel@redhat.com>, rmk@arm.linux.org.uk,
       Andy Whitcroft <apw@shadowen.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200706211042.54917.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200706010002.l5102LN5031209@shell0.pdx.osdl.net>
 <466EC86C.6000601@sun.com> <200706120955.44097.yinghai.lu@sun.com>
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] serial : convert early_uart to earlycon for 8250 fix 3 alias

make the console=uart,io,0x3f8,9600n8 like console=uart8250,io,0x3f8,9600
suggested by Andy Whitcroft.
 
Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

--- a/Documentation/kernel-parameters.txt	2007-06-21 10:12:48.000000000 -0700
+++ b/Documentation/kernel-parameters.txt	2007-06-21 10:13:43.000000000 -0700
@@ -467,16 +467,16 @@
 			Documentation/networking/netconsole.txt for an
 			alternative.
 
-		uart8250,io,<addr>[,options]
-		uart8250,mmio,<addr>[,options]
+		uart[8250],io,<addr>[,options]
+		uart[8250],mmio,<addr>[,options]
 			Start an early, polled-mode console on the 8250/16550
 			UART at the specified I/O port or MMIO address,
 			switching to the matching ttyS device later.  The
 			options are the same as for ttyS, above.
 
 	earlycon=	[KNL] Output early console device and options.
-		uart8250,io,<addr>[,options]
-		uart8250,mmio,<addr>[,options]
+		uart[8250],io,<addr>[,options]
+		uart[8250],mmio,<addr>[,options]
 			Start an early, polled-mode console on the 8250/16550
 			UART at the specified I/O port or MMIO address.
 			The options are the same as for ttyS, above.
--- a/drivers/serial/8250_early.c	2007-06-21 10:04:25.000000000 -0700
+++ b/drivers/serial/8250_early.c	2007-06-21 10:12:08.000000000 -0700
@@ -210,8 +210,11 @@
 	int err;
 
 	options = strstr(cmdline, "uart8250,");
-	if (!options)
-		return 0;
+	if (!options) {
+		options = strstr(cmdline, "uart,");
+		if (!options)
+			return 0;
+	}
 
 	options = strchr(cmdline, ',') + 1;
 	if ((err = early_serial8250_setup(options)) < 0)
@@ -227,6 +230,7 @@
 	struct early_serial8250_device *device = &early_device;
 	struct uart_port *port = &device->port;
 	int line;
+	int ret;
 
 	if (!device->port.membase && !device->port.iobase)
 		return -ENODEV;
@@ -235,8 +239,13 @@
 	if (line < 0)
 		return -ENODEV;
 
-	return update_console_cmdline("uart", 8250,
+	ret = update_console_cmdline("uart", 8250,
+			     "ttyS", line, device->options);
+	if (ret < 0)
+		ret = update_console_cmdline("uart", 0,
 				     "ttyS", line, device->options);
+
+	return ret;
 }
 
 early_param("earlycon", setup_early_serial8250_console);

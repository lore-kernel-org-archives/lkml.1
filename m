Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbXITFpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbXITFpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 01:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbXITFpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 01:45:24 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:62210 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757415AbXITFpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 01:45:21 -0400
Date: Thu, 20 Sep 2007 14:45:15 +0900 (JST)
Message-Id: <20070920.144515.126142885.nemoto@toshiba-tops.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ralf@linux-mips.org,
       linux-serial@vger.kernel.org
Subject: [PATCH] serial_txx9: Use UPF_FIXED_PORT
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The UPF_FIXED_PORT flags was introduced in 2.6.22 and it can be used
instead of the driver specific verify_port routine.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/serial/serial_txx9.c |   26 +++++---------------------
 1 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/serial/serial_txx9.c b/drivers/serial/serial_txx9.c
index 0930e2a..c25c9a5 100644
--- a/drivers/serial/serial_txx9.c
+++ b/drivers/serial/serial_txx9.c
@@ -37,7 +37,7 @@
 
 #include <asm/io.h>
 
-static char *serial_version = "1.10";
+static char *serial_version = "1.11";
 static char *serial_name = "TX39/49 Serial driver";
 
 #define PASS_LIMIT	256
@@ -68,8 +68,6 @@ static char *serial_name = "TX39/49 Serial driver";
  */
 #define UART_NR  CONFIG_SERIAL_TXX9_NR_UARTS
 
-#define HIGH_BITS_OFFSET	((sizeof(long)-sizeof(int))*8)
-
 struct uart_txx9_port {
 	struct uart_port	port;
 	/* No additional info for now */
@@ -756,21 +754,6 @@ static void serial_txx9_config_port(struct uart_port *port, int uflags)
 	serial_txx9_initialize(port);
 }
 
-static int
-serial_txx9_verify_port(struct uart_port *port, struct serial_struct *ser)
-{
-	unsigned long new_port = ser->port;
-	if (HIGH_BITS_OFFSET)
-		new_port += (unsigned long)ser->port_high << HIGH_BITS_OFFSET;
-	if (ser->type != port->type ||
-	    ser->irq != port->irq ||
-	    ser->io_type != port->iotype ||
-	    new_port != port->iobase ||
-	    (unsigned long)ser->iomem_base != port->mapbase)
-		return -EINVAL;
-	return 0;
-}
-
 static const char *
 serial_txx9_type(struct uart_port *port)
 {
@@ -794,7 +777,6 @@ static struct uart_ops serial_txx9_pops = {
 	.release_port	= serial_txx9_release_port,
 	.request_port	= serial_txx9_request_port,
 	.config_port	= serial_txx9_config_port,
-	.verify_port	= serial_txx9_verify_port,
 };
 
 static struct uart_txx9_port serial_txx9_ports[UART_NR];
@@ -950,7 +932,8 @@ int __init early_serial_txx9_setup(struct uart_port *port)
 
 	serial_txx9_ports[port->line].port = *port;
 	serial_txx9_ports[port->line].port.ops = &serial_txx9_pops;
-	serial_txx9_ports[port->line].port.flags |= UPF_BOOT_AUTOCONF;
+	serial_txx9_ports[port->line].port.flags |=
+		UPF_BOOT_AUTOCONF | UPF_FIXED_PORT;
 	return 0;
 }
 
@@ -995,7 +978,8 @@ static int __devinit serial_txx9_register_port(struct uart_port *port)
 		uart->port.irq      = port->irq;
 		uart->port.uartclk  = port->uartclk;
 		uart->port.iotype   = port->iotype;
-		uart->port.flags    = port->flags | UPF_BOOT_AUTOCONF;
+		uart->port.flags    = port->flags
+			| UPF_BOOT_AUTOCONF | UPF_FIXED_PORT;
 		uart->port.mapbase  = port->mapbase;
 		if (port->dev)
 			uart->port.dev = port->dev;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbYAPRJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbYAPRJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbYAPRIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:08:54 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:33204 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbYAPRIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:08:50 -0500
Message-Id: <20080116170914.959390017@ldl.fc.hp.com>
References: <20080116170541.511233227@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 Jan 2008 10:05:43 -0700
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org
Cc: Russell King <rmk+serial@arm.linux.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2/2] 8250_pnp: register x86 COM ports at the conventional ttyS names
Content-Disposition: inline; filename=8250-pnp-names
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 users expect COM1-COM4 ports at the conventional ioport addresses
to be named ttyS0-ttyS3.  For PNP devices, the BIOS determines the
order we discover them, so we might discover COM2 before COM1.

We currently always get the correct names, even without this patch.
But that's only because serial8250_isa_init_ports() first registers
the hard-coded list of COM port addresses from SERIAL_PORT_DFNS.  When
PNP rediscovers one of those ports, it gets the already-established
line.

This patch removes the implicit dependency on SERIAL_PORT_DFNS by
requesting the names we desire.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work5/drivers/serial/8250_pnp.c
===================================================================
--- work5.orig/drivers/serial/8250_pnp.c	2008-01-16 09:29:33.000000000 -0700
+++ work5/drivers/serial/8250_pnp.c	2008-01-16 09:51:09.000000000 -0700
@@ -427,6 +427,21 @@
 }
 
 static int __devinit
+serial_pnp_line(struct uart_port *port)
+{
+#ifdef CONFIG_X86
+	switch (port->iobase) {
+	case 0x3f8:	return 0;	/* COM1 -> ttyS0 */
+	case 0x2f8:	return 1;	/* COM2 -> ttyS1 */
+	case 0x3e8:	return 2;	/* COM3 -> ttyS2 */
+	case 0x2e8:	return 3;	/* COM4 -> ttyS3 */
+	}
+#endif
+
+	return -ENODEV;
+}
+
+static int __devinit
 serial_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 {
 	struct uart_port port;
@@ -462,7 +477,17 @@
 	port.uartclk = 1843200;
 	port.dev = &dev->dev;
 
-	line = serial8250_register_port(&port);
+	line = serial_pnp_line(&port);
+	if (line >= 0)
+		line = serial8250_register_port_at(&port, line);
+
+	/*
+	 * If the desired line was busy, or if we don't care which line
+	 * we get, use the regular registration.
+	 */
+	if (line < 0)
+		line = serial8250_register_port(&port);
+
 	if (line < 0)
 		return -ENODEV;
 

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760912AbZFXRWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912AbZFXRWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 13:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbZFXRWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 13:22:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34161 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbZFXRWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 13:22:34 -0400
Date: Wed, 24 Jun 2009 13:22:26 -0400
From: Dave Jones <davej@redhat.com>
To: alan@lxorguk.ukuu.org.uk
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Mathias Adam <a2@adamis.de>
Subject: serial: enable higher baud rates for 16c95x
Message-ID: <20090624172213.GA21123@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, alan@lxorguk.ukuu.org.uk,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Mathias Adam <a2@adamis.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch has been around (and in Fedora) for 4 years.

Previous discussion around this patch:
http://marc.theaimsgroup.com/?l=linux-kernel&m=112687270832687&w=2
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=126403
http://lkml.org/lkml/2006/8/2/208

The objection seemed to be summarised as "it might break something else".
In the four years it's been in Fedora, I don't recall seeing a single
serial bug report that was related.

From: Mathias Adam <a2@adamis.de>
Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6.13-org/drivers/serial/8250.c	2005-08-29 01:41:01.000000000 +0200
+++ linux-2.6.13/drivers/serial/8250.c	2005-09-16 12:18:14.000000000 +0200
@@ -7,6 +7,9 @@
  *
  *  Copyright (C) 2001 Russell King.
  *
+ *  2005/09/16: Enabled higher baud rates for 16C95x.
+ *		(Mathias Adam <a2@adamis.de>)
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -1652,6 +1655,14 @@
 	else if ((port->flags & UPF_MAGIC_MULTIPLIER) &&
 		 baud == (port->uartclk/8))
 		quot = 0x8002;
+	/*
+	 * For 16C950s UART_TCR is used in combination with divisor==1
+	 * to achieve baud rates up to baud_base*4.
+	 */
+	else if ((port->type == PORT_16C950) &&
+		 baud > (port->uartclk/16))
+		quot = 1;
+
 	else
 		quot = uart_get_divisor(port, baud);
 
@@ -1665,7 +1676,7 @@
 	struct uart_8250_port *up = (struct uart_8250_port *)port;
 	unsigned char cval, fcr = 0;
 	unsigned long flags;
-	unsigned int baud, quot;
+	unsigned int baud, quot, max_baud;
 
 	switch (termios->c_cflag & CSIZE) {
 	case CS5:
@@ -2034,7 +2034,8 @@ serial8250_set_termios(struct uart_port 
 	/*
 	 * Ask the core to calculate the divisor for us.
 	 */
-	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16);
+	max_baud = (up->port.type == PORT_16C950 ? port->uartclk/4 : port->uartclk/16);
+	baud = uart_get_baud_rate(port, termios, old, 0, max_baud);
 	quot = serial8250_get_divisor(port, baud);
 
 	/*
@@ -1733,6 +1745,19 @@
 	 */
 	spin_lock_irqsave(&up->port.lock, flags);
 
+	/*
+	 * 16C950 supports additional prescaler ratios between 1:16 and 1:4
+	 * thus increasing max baud rate to uartclk/4.
+	 */
+	if (up->port.type == PORT_16C950) {
+		if (baud == port->uartclk/4)
+			serial_icr_write(up, UART_TCR, 0x4);
+		else if (baud == port->uartclk/8)
+			serial_icr_write(up, UART_TCR, 0x8);
+		else
+			serial_icr_write(up, UART_TCR, 0);
+	}
+
 	/*
 	 * Update the per-port timeout.
 	 */


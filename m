Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbZLAMhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbZLAMhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 07:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbZLAMhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 07:37:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57207 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbZLAMht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 07:37:49 -0500
Date: Tue, 1 Dec 2009 13:37:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: bluetooth cf slow (10KB/sec), lots of dmesg spam
Message-ID: <20091201123744.GC1982@elf.ucw.cz>
References: <20091129155801.GA1634@ucw.cz>
 <20091130153915.0a6910e3@lxorguk.ukuu.org.uk>
 <20091129164450.GA1438@ucw.cz>
 <20091130235739.6dfa3d66@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130235739.6dfa3d66@lxorguk.ukuu.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-11-30 23:57:39, Alan Cox wrote:
> > ioctl(3, SNDCTL_TMR_START or TCSETS, {B921600 -opost -isig -icanon -echo ...}) = 0
> 
> It's certainly trying
> > 
> > ...set 921K using TCSETS/B921600... and kernel says ok, but ...
> 
> Careful: termios is one of those "gotcha" ioctls. It returns 0 to say
> "stuff happened" and returns a termios struct which contains the results
> - which may not be what you requested.
> 
> So a set to an unsupported rate (too high for the chip clock) will
> produce a response of 0 and return the baud rate you actually got
> given.

Ok, that part seems to work.

> > ...we are still at 115200... I wonder if 921600 is the right speed to
> > use after all? Any other speeds I should try? (and can 400MHz arm
> > handle 921K on serial line?)
> 
> It's pushing it on an x86 with a 16550A. You've got about 14 character
> times of worst case latency permitted and 14 x 10 bits isn't a lot at
> that rate. Some of the clones have much bigger FIFOs so it may depend
> what you actually have.

/dev/ttyBT, Line 0, UART: 16950/954, Port: 0x9100, IRQ: 16

...so hopefully it has bigger buffers.

This patch was flying around for about forever and seems vaguely
related, but... the card seems to only be detected with divisor of 8,
not even divisor of 1 seems to work :-(.
									Pavel
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 737b4c9..8540343 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
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
@@ -2229,6 +2232,14 @@ static unsigned int serial8250_get_divisor(struct uart_port *port, unsigned int
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
 
@@ -2242,7 +2253,7 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 	struct uart_8250_port *up = (struct uart_8250_port *)port;
 	unsigned char cval, fcr = 0;
 	unsigned long flags;
-	unsigned int baud, quot;
+	unsigned int baud, quot, max_baud;
 
 	switch (termios->c_cflag & CSIZE) {
 	case CS5:
@@ -2274,9 +2285,11 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 	/*
 	 * Ask the core to calculate the divisor for us.
 	 */
-	baud = uart_get_baud_rate(port, termios, old,
-				  port->uartclk / 16 / 0xffff,
-				  port->uartclk / 16);
+ 	max_baud = port->uartclk/16;
+	if (up->port.type == PORT_16C950)
+		max_baud = port->uartclk/4;
+	baud = uart_get_baud_rate(port, termios, old, max_baud / 0xffff,
+				  max_baud / 16);
 	quot = serial8250_get_divisor(port, baud);
 
 	/*
@@ -2313,6 +2326,19 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 	spin_lock_irqsave(&up->port.lock, flags);
 
 	/*
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
+	/*
 	 * Update the per-port timeout.
 	 */
 	uart_update_timeout(port, termios->c_cflag, baud);


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

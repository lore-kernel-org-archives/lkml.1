Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbZGBVg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbZGBVg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 17:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbZGBVgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 17:36:22 -0400
Received: from ru.mvista.com ([213.79.90.228]:28902 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754850AbZGBVgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 17:36:21 -0400
Date: Fri, 3 Jul 2009 01:36:24 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] 8250: Now honours baud rate lower bounds
Message-ID: <20090702213624.GA23193@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A platform clock drives 8250 ports in most SOC systems, the clock
might run at high frequencies, and so it's not always possible to
downscale uart clock to a desired value.

Currently the 8250 uart driver accepts not supported baud rates, and
what is worse, it is doing this silently, and then passes not accepted
values to a new termios, so userspace has no chance to catch this kind
of errors (userspace verifies that settings were accepted by reading
back and comparing the settings).

This patch fixes the issue by passing minimum baud rate to the
uart_get_baud_rate() call, the call should take care of all bounds,
so userspace should now report:

  # stty -F /dev/ttyS0 speed 300
  115200
  stty: /dev/ttyS0: unable to perform all requested operations

p.s. uart_get_baud_rate() falls back to 9600, which still might be too
     low for some 10 GHz platforms, but that's a separate issue, and
     we can wait with fixing this till we find such a platform.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/serial/8250.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index fb867a9..22d8d4f 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -567,6 +567,11 @@ static inline void _serial_dl_write(struct uart_8250_port *up, int value)
 	serial_outp(up, UART_DLM, value >> 8 & 0xff);
 }
 
+static unsigned int _serial_dl_max(struct uart_8250_port *up)
+{
+	return 0xffff;
+}
+
 #if defined(CONFIG_SERIAL_8250_AU1X00)
 /* Au1x00 haven't got a standard divisor latch */
 static int serial_dl_read(struct uart_8250_port *up)
@@ -584,6 +589,14 @@ static void serial_dl_write(struct uart_8250_port *up, int value)
 	else
 		_serial_dl_write(up, value);
 }
+
+static unsigned int serial_dl_max(struct uart_8250_port *up)
+{
+	if (up->port.iotype == UPIO_AU)
+		return 0xffffffff;
+	else
+		return _serial_dl_max(up);
+}
 #elif defined(CONFIG_SERIAL_8250_RM9K)
 static int serial_dl_read(struct uart_8250_port *up)
 {
@@ -602,9 +615,15 @@ static void serial_dl_write(struct uart_8250_port *up, int value)
 		_serial_dl_write(up, value);
 	}
 }
+
+static unsigned int serial_dl_max(struct uart_8250_port *up)
+{
+	return _serial_dl_max(up);
+}
 #else
 #define serial_dl_read(up) _serial_dl_read(up)
 #define serial_dl_write(up, value) _serial_dl_write(up, value)
+#define serial_dl_max(up) _serial_dl_max(up)
 #endif
 
 /*
@@ -2272,7 +2291,9 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 	/*
 	 * Ask the core to calculate the divisor for us.
 	 */
-	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16);
+	baud = uart_get_baud_rate(port, termios, old,
+				  port->uartclk / 16 / serial_dl_max(up),
+				  port->uartclk / 16);
 	quot = serial8250_get_divisor(port, baud);
 
 	/*
-- 
1.6.3.3

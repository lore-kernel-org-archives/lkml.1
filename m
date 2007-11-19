Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbXKSPYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbXKSPYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:24:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbXKSPXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:23:55 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53324 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753339AbXKSPXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:23:54 -0500
Date: Mon, 19 Nov 2007 15:22:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [PATCH] mct232: speed, new termios and compliance cleanups
Message-ID: <20071119152211.4be48986@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/usb/serial/mct_u232.c linux-2.6.24-rc2-mm1/drivers/usb/serial/mct_u232.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/usb/serial/mct_u232.c	2007-11-16 17:54:49.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/usb/serial/mct_u232.c	2007-11-16 18:37:35.000000000 +0000
@@ -184,8 +184,10 @@
  * we do not know how to support. We ignore them for the moment.
  * XXX Rate-limit the error message, it's user triggerable.
  */
-static int mct_u232_calculate_baud_rate(struct usb_serial *serial, speed_t value)
+static int mct_u232_calculate_baud_rate(struct usb_serial *serial, speed_t value, speed_t *result)
 {
+	*result = value;
+
 	if (le16_to_cpu(serial->dev->descriptor.idProduct) == MCT_U232_SITECOM_PID
 	  || le16_to_cpu(serial->dev->descriptor.idProduct) == MCT_U232_BELKIN_F5U109_PID) {
 		switch (value) {
@@ -200,11 +202,13 @@
 		case  57600: return 0x0b;
 		case 115200: return 0x0c;
 		default:
-			err("MCT USB-RS232: unsupported baudrate request 0x%x,"
-			    " using default of B9600", value);
+			*result = 9600;
 			return 0x08;
 		}
 	} else {
+		/* FIXME: Can we use any divider - should we do
+		   divider = 115200/value;
+		   real baud = 115200/divider */
 		switch (value) {
 		case 300: break;
 		case 600: break;
@@ -217,9 +221,8 @@
 		case 57600: break;
 		case 115200: break;
 		default:
-			err("MCT USB-RS232: unsupported baudrate request 0x%x,"
-			    " using default of B9600", value);
 			value = 9600;
+			*result = 9600;
 		}
 		return 115200/value;
 	}
@@ -232,16 +235,19 @@
         int rc;
         unsigned char zero_byte = 0;
         unsigned char cts_enable_byte = 0;
+        speed_t speed;
 
-	divisor = cpu_to_le32(mct_u232_calculate_baud_rate(serial, value));
+	divisor = cpu_to_le32(mct_u232_calculate_baud_rate(serial, value, &speed));
 
         rc = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
                              MCT_U232_SET_BAUD_RATE_REQUEST,
 			     MCT_U232_SET_REQUEST_TYPE,
                              0, 0, &divisor, MCT_U232_SET_BAUD_RATE_SIZE,
 			     WDR_TIMEOUT);
-	if (rc < 0)
+	if (rc < 0)	/*FIXME: What value speed results */
 		err("Set BAUD RATE %d failed (error = %d)", value, rc);
+	else
+		tty_encode_baud_rate(port->tty, speed, speed);
 	dbg("set_baud_rate: value: 0x%x, divisor: 0x%x", value, divisor);
 
 	/* Mimic the MCT-supplied Windows driver (version 1.21P.0104), which
@@ -608,7 +614,8 @@
 {
 	struct usb_serial *serial = port->serial;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
-	unsigned int cflag = port->tty->termios->c_cflag;
+	struct ktermios *termios = port->tty->termios;
+	unsigned int cflag = termios->c_cflag;
 	unsigned int old_cflag = old_termios->c_cflag;
 	unsigned long flags;
 	unsigned int control_state;
@@ -669,6 +676,8 @@
 		last_lcr |= MCT_U232_DATA_BITS_8;
 		break;
 	}
+	
+	termios->c_cflag &= ~CMSPAR;
 
 	/* set the number of stop bits */
 	last_lcr |= (cflag & CSTOPB) ?
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/usb/serial/mct_u232.h linux-2.6.24-rc2-mm1/drivers/usb/serial/mct_u232.h
--- linux.vanilla-2.6.24-rc2-mm1/drivers/usb/serial/mct_u232.h	2007-11-16 17:20:48.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/usb/serial/mct_u232.h	2007-11-16 18:37:35.000000000 +0000
@@ -79,7 +79,7 @@
  * and "Intel solution". They are the regular MCT and "Sitecom" for us.
  * This is pointless to document in the header, see the code for the bits.
  */
-static int mct_u232_calculate_baud_rate(struct usb_serial *serial, speed_t value);
+static int mct_u232_calculate_baud_rate(struct usb_serial *serial, speed_t value, speed_t *result);
 
 /*
  * Line Control Register (LCR)

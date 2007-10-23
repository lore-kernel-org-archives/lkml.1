Return-Path: <linux-kernel-owner+w=401wt.eu-S1753078AbXJWOZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbXJWOZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 10:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXJWOZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 10:25:05 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:33542 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbXJWOZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 10:25:03 -0400
Date: Tue, 23 Oct 2007 15:24:54 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] dz: Clean up and improve the setup of termios settings
Message-ID: <Pine.LNX.4.64N.0710231452110.8693@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 A set of changes to the way termios settings are propagated to the serial 
port hardware.  The DZ11 only supports a selection of fixed baud settings, 
so some requests may not be fulfilled.  Keep the old setting in such a 
case and failing that resort to 9600bps.  Also add a missing update of the 
transmit timeout.  And remove the explicit encoding of the line selected 
from writes to the Line Parameters Register as it has been preencoded by 
the ->set_termios() call already.  Finally, remove a duplicate macro for 
the Receiver Enable bit.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 Tested with checkpatch.pl and at the run-time -- MIPS/Linux on a
DECstation 5000/200.

 Please apply,

  Maciej

patch-mips-2.6.23-rc5-20070904-dz-termios-8
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/drivers/serial/dz.c linux-mips-2.6.23-rc5-20070904/drivers/serial/dz.c
--- linux-mips-2.6.23-rc5-20070904.macro/drivers/serial/dz.c	2007-10-13 20:10:37.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/drivers/serial/dz.c	2007-10-23 14:09:24.000000000 +0000
@@ -125,8 +125,8 @@ static void dz_stop_rx(struct uart_port 
 {
 	struct dz_port *dport = (struct dz_port *)uport;
 
-	dport->cflag &= ~DZ_CREAD;
-	dz_out(dport, DZ_LPR, dport->cflag | dport->port.line);
+	dport->cflag &= ~DZ_RXENAB;
+	dz_out(dport, DZ_LPR, dport->cflag);
 }
 
 static void dz_enable_ms(struct uart_port *port)
@@ -461,12 +461,51 @@ static void dz_break_ctl(struct uart_por
 	spin_unlock_irqrestore(&uport->lock, flags);
 }
 
+static int dz_encode_baud_rate(unsigned int baud)
+{
+	switch (baud) {
+	case 50:
+		return DZ_B50;
+	case 75:
+		return DZ_B75;
+	case 110:
+		return DZ_B110;
+	case 134:
+		return DZ_B134;
+	case 150:
+		return DZ_B150;
+	case 300:
+		return DZ_B300;
+	case 600:
+		return DZ_B600;
+	case 1200:
+		return DZ_B1200;
+	case 1800:
+		return DZ_B1800;
+	case 2000:
+		return DZ_B2000;
+	case 2400:
+		return DZ_B2400;
+	case 3600:
+		return DZ_B3600;
+	case 4800:
+		return DZ_B4800;
+	case 7200:
+		return DZ_B7200;
+	case 9600:
+		return DZ_B9600;
+	default:
+		return -1;
+	}
+}
+
 static void dz_set_termios(struct uart_port *uport, struct ktermios *termios,
 			   struct ktermios *old_termios)
 {
 	struct dz_port *dport = (struct dz_port *)uport;
 	unsigned long flags;
 	unsigned int cflag, baud;
+	int bflag;
 
 	cflag = dport->port.line;
 
@@ -493,60 +532,26 @@ static void dz_set_termios(struct uart_p
 		cflag |= DZ_PARODD;
 
 	baud = uart_get_baud_rate(uport, termios, old_termios, 50, 9600);
-	switch (baud) {
-	case 50:
-		cflag |= DZ_B50;
-		break;
-	case 75:
-		cflag |= DZ_B75;
-		break;
-	case 110:
-		cflag |= DZ_B110;
-		break;
-	case 134:
-		cflag |= DZ_B134;
-		break;
-	case 150:
-		cflag |= DZ_B150;
-		break;
-	case 300:
-		cflag |= DZ_B300;
-		break;
-	case 600:
-		cflag |= DZ_B600;
-		break;
-	case 1200:
-		cflag |= DZ_B1200;
-		break;
-	case 1800:
-		cflag |= DZ_B1800;
-		break;
-	case 2000:
-		cflag |= DZ_B2000;
-		break;
-	case 2400:
-		cflag |= DZ_B2400;
-		break;
-	case 3600:
-		cflag |= DZ_B3600;
-		break;
-	case 4800:
-		cflag |= DZ_B4800;
-		break;
-	case 7200:
-		cflag |= DZ_B7200;
-		break;
-	case 9600:
-	default:
-		cflag |= DZ_B9600;
+	bflag = dz_encode_baud_rate(baud);
+	if (bflag < 0)	{			/* Try to keep unchanged.  */
+		baud = uart_get_baud_rate(uport, old_termios, NULL, 50, 9600);
+		bflag = dz_encode_baud_rate(baud);
+		if (bflag < 0)	{		/* Resort to 9600.  */
+			baud = 9600;
+			bflag = DZ_B9600;
+		}
+		tty_termios_encode_baud_rate(termios, baud, baud);
 	}
+	cflag |= bflag;
 
 	if (termios->c_cflag & CREAD)
 		cflag |= DZ_RXENAB;
 
 	spin_lock_irqsave(&dport->port.lock, flags);
 
-	dz_out(dport, DZ_LPR, cflag | dport->port.line);
+	uart_update_timeout(uport, termios->c_cflag, baud);
+
+	dz_out(dport, DZ_LPR, cflag);
 	dport->cflag = cflag;
 
 	/* setup accept flag */
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/drivers/serial/dz.h linux-mips-2.6.23-rc5-20070904/drivers/serial/dz.h
--- linux-mips-2.6.23-rc5-20070904.macro/drivers/serial/dz.h	2007-02-05 16:38:50.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/drivers/serial/dz.h	2007-10-13 17:27:11.000000000 +0000
@@ -107,8 +107,8 @@
 #define DZ_B7200         0x0D00
 #define DZ_B9600         0x0E00
 
-#define DZ_CREAD         0x1000               /* Enable receiver */
-#define DZ_RXENAB        0x1000               /* enable receive char */
+#define DZ_RXENAB        0x1000               /* Receiver Enable */
+
 /*
  * Addresses for the DZ registers
  */
